(
// from gpt
SynthDef(\ps1OpeningPad, {
    arg out = 0, amp = 0.5, gate = 1, freq = 55, detune = 0.015, attack = 3.5, release = 4.0;
    
    // 1. Stereo Detuned Sawtooth Cluster (16 Voices)
    // We generate a bank of frequencies slightly offset from the base frequency
    var voiceCount = 16;
    var freqs = Array.fill(voiceCount, { |i|
        freq * (1 + LFNoise1.kr(0.2).range(detune.neg, detune)) * (1 + ((i - (voiceCount/2)) * 0.001))
    });
    
    // Generate the multi-voice sawtooth wave
    var oscillators = Saw.ar(freqs);
    
    // 2. Slow Swelling Envelopes
    // Volume envelope
    var ampEnv = EnvGen.kr(Env.asr(attack, 1.0, release, \sin), gate, doneAction: 2);
    // Filter cutoff envelope to match the opening brightness swell
    var filterEnv = EnvGen.kr(Env.asr(attack * 1.2, 1.0, release, \lin), gate);
    
    // 3. Low Pass Filtering & Saturation
    // Smooth out the harsh highs and simulate analog tape/hardware warmth
    var cutoff = filterEnv.linexp(0, 1, freq * 2, freq * 18);
    var filtered = LPF.ar(oscillators, cutoff);
    var saturated = (filtered * 1.5).tanh; // Mild soft clipping
    
    // 4. Stereo Distribution
    // Mix the 16 voices into a wide stereo field
    var stereoMix = Splay.ar(saturated, spread: 0.9, center: 0.0);
    
    // 5. Final Output with Master Volume
    Out.ar(out, stereoMix * ampEnv * amp);
}).add;
)

// --- Test the Synth Def ---
x = Synth(\ps1OpeningPad, [\freq, 79, \amp, 0.1]); // Plays a deep A1 root note

// --- To stop it (triggers the long release) ---
x.set(\gate, 0);

//////////

(
SynthDef(\pspad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv;
	var num=16;
	var lplfo;
	var det = 0.001;
	freq.poll;
	lplfo = LFNoise1.ar(0.2!num).range(1+det,1-det);
	lpenv = EnvGen.kr(Env([5,48,1],[4.1,4.8],2), 1);
	sig = LFSaw.ar(freq * ((0..( num-1 ))/( num-1 ) - 0.5 * \fspread.kr(0.0102) + 1) * lplfo);
	sig = RLPF.ar(sig, ( freq * lpenv *lplfo ).clip(20,2e4),0.4);
	sig = (sig * 1.5).tanh;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(4.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\pspad,
			//\note, Pseq([
				//2,
			//],inf),
			\freq, 79,
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \pspad,
			\note, Pseq([
				[0,4,7],
				[0,5,9],
			],inf) +.x Pseq([[ 0,24 ]]),
			\dur, 8,
			\octave, 3,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\pspad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv;
	var num=16;
	var lplfo;
	var det = 0.001;
	lplfo = LFNoise1.ar(0.2!num).range(1+det,1-det);
	lpenv = EnvGen.kr(Env([5,48,1],[4.1,4.8],2), 1);
	sig = LFPulse.ar(freq * ((0..( num-1 ))/( num-1 ) - 0.5 * \fspread.kr(0.0102) + 1) * lplfo);
	sig = RLPF.ar(sig, ( \ffac.kr(1) * freq * lpenv *lplfo ).clip(20,2e4),0.4);
	sig = (sig * 1.5).tanh;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(4.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \pspad,
			\note, Pseq([
				0,0,0,7,
			],inf).stutter(8)-5,
			\dur, 1/4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[58].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pbind(
			\instrument, \pspad,
			\note, Pseq([
				0,0,0,-5,
			],inf).stutter(8),
			\dur, 1/4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\ffac, Pseg(Pseq([0.4,3],1),32).loop,
			\octave, 3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\amp, 0.1/3,
			\out, BusDef(\basstrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\dur, 1/8,
			\legato, Pseq([1,0.5],inf),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \pspad,
			\note, Pseq([
				[0,4,7],
				[0,5,9],
			],inf) +.x Pseq([[ 0,24 ]]),
			\dur, 8,
			\octave, 3,
			\amp, 0.1/4,
		),
	])
)).play;
);
