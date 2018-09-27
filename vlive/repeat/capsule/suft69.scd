(
SynthDef(\hihat_electro, {
    |out = 0, pan = 0, amp = 0.3|
    var click, clickAmp;
    var noise, noiseAmp;
    var snd;

    // noise -> resonance -> expodec envelope
    noiseAmp = EnvGen.ar(Env.perc(0.001, 0.3, curve: -8), doneAction: 2);
    noise = Mix(BPF.ar(ClipNoise.ar, [4010, 4151], [0.15, 0.56], [1.0, 0.6])) * 0.7 * noiseAmp;

    snd = noise;

    Out.ar(out, Pan2.ar(snd, pan, amp));
//By Nathan Ho aka Snappizz
//http://sccode.org/1-523
}).add;
SynthDef(\snare_electro, {
    |out = 0, pan = 0, amp = 0.3|
    var pop, popAmp, popFreq;
    var noise, noiseAmp;
    var snd;

    // pop makes a click coming from very high frequencies
    // slowing down a little and stopping in mid-to-low
    popFreq = EnvGen.ar(Env([3261, 410, 160], [0.005, 0.01], curve: \exp));
    popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
    pop = SinOsc.ar(popFreq) * popAmp;
    // bandpass-filtered white noise
    noiseAmp = EnvGen.ar(Env.perc(0.001, 0.15), doneAction: 2);
    noise = BPF.ar(WhiteNoise.ar, 810, 1.6) * noiseAmp;

    snd = (pop + noise) * 1.3;

    Out.ar(out, Pan2.ar(snd, pan, amp));
//By Nathan Ho aka Snappizz
//http://sccode.org/1-523
}).add;
SynthDef(\stringsx, { arg out, freq=440, amp=0.8, gate=1, pan, freqLag=0.2;
//From SC Examples Folder
// some small pieces
// Julian Rohrhuber, 2007
					var env, in, delay, f1, f2;
					f1 = freq.lag(freqLag);
					f2 = freq.lag(freqLag * 0.5);
					delay = 0.25 / f2;
					env = \adsr.kr(Env.adsr(0.1,0.1,0.8,0.1));
					in = WhiteNoise.ar(180);
					in = CombL.ar(in, delay, delay, 1);
					in = Resonz.ar(in, f1, 0.001).abs;
					in = in * EnvGen.kr(env, gate, doneAction:2);
					Out.ar(out, Pan2.ar(in, pan, amp));

}).add;
SynthDef(\stringsx3, { arg out, freq=440, amp=0.8, gate=1, pan, freqLag=0.2;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var env, in, delay, f1, f2;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	f1 = freq.lag(freqLag);
	f2 = freq.lag(freqLag * 0.5);
	env1 = EnvGen.kr(Env([1,1/2,2,1/2],[0.051,0.4,1]), 1);
	delay = 0.25 / f2;
	env = \adsr.kr(Env.adsr(0.1,0.1,0.8,0.1));
	sig = WhiteNoise.ar(18);
	sig = CombL.ar(sig, delay, delay, 1);
	sig = Resonz.ar(sig, f1, 0.001).abs;
	sig2 = BPF.ar(sig, f2*env1, 0.1,mul:1)*2;
	sig2 = Normalizer.ar(sig2, 0.4,0.0001);
	sig2 = HPF.ar(sig, 300)*8;
	//sig = sig + sig2;
	sig = sig2;
	sig = sig * EnvGen.kr(env, gate, doneAction:2);
	Out.ar(out, Pan2.ar(sig, pan, amp));

}).add;
SynthDef(\stringsx2, { arg out, freq=440, amp=0.8, gate=1, pan, freqLag=0.2;
//From SC Examples Folder
// some small pieces
// Julian Rohrhuber, 2007
					var env, in, delay, f1, f2;
					var env1, env2, env3, env4, env5, env6, env7, env8;
					f1 = freq.lag(freqLag);
					f2 = freq.lag(freqLag * 0.5);

					env1 = EnvGen.kr(Env([1,1.12,1],[0.051,0.8]), 1);
					delay = 0.25 / f2;
					env = \adsr.kr(Env.adsr(0.1,0.1,0.8,0.1));
					in = WhiteNoise.ar(180);
					in = CombL.ar(in, delay, delay * SinOsc.kr([1,2]).range(0.1,1) , 1);
					in = Resonz.ar(in, f1 * env1, 0.001).abs;
					in = in * EnvGen.kr(env, gate, doneAction:2);
					Out.ar(out, Pan2.ar(in, pan, amp).mean);

}).add;
SynthDef(\choruscompresseffectx, {|out =0 gate= 1|
	var source = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var chorus;
	var sig;

	chorus= Splay.ar(Array.fill(4,{
		var maxdelaytime= rrand(0.005,0.02);

		DelayC.ar(source[0], maxdelaytime,LFNoise1.kr(Rand(0.1,0.6),0.25*maxdelaytime,0.75*maxdelaytime) )
	}));

	chorus = Compander.ar(4*(source + chorus),source,0.4,1,4);


	sig = chorus;
	sig = SelectX.ar(\mix.kr(0.5), [source, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * 0.6 * \gain.kr(1);
	Out.ar(out,sig);

//From Steal This Sound SC Example
//By Nick Collins
}).add;
SynthDef(\vlip, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,0.002,0.3],[0.1,0.8]), 1);
	sig = SinOsc.ar(freq * SinOsc.ar((1..8)/10, mul:\fmamp.kr(2.001) * env1, add:1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\kalimba, {
	//Kalimba based on bank of ressonators
    |out = 0, freq = 440, amp = 0.1, mix = 0.1, relMin = 2.5, relMax = 3.5|
    var snd;
    // Basic tone is a SinOsc
    snd = SinOsc.ar(freq) * EnvGen.ar(Env.perc(0.005, Rand(relMin, relMax), 1, -8), doneAction: 2);
    // The "clicking" sounds are modeled with a bank of resonators excited by enveloped pink noise
    snd = (snd * (1 - mix)) + (DynKlank.ar(`[
        // the resonant frequencies are randomized a little to add variation
        // there are two high resonant freqs and one quiet "bass" freq to give it some depth
        [240*ExpRand(0.9, 1.1), 2020*ExpRand(0.9, 1.1), 3151*ExpRand(0.9, 1.1)],
        [-7, 0, 3].dbamp,
        [0.8, 0.05, 0.07]
    ], PinkNoise.ar * EnvGen.ar(Env.perc(0.001, 0.01))) * mix);
    Out.ar(out, Pan2.ar(snd, 0, amp));
//By Nathan Ho aka Snappiz
//http://sccode.org/1-51l
}).add;
)
~t = 135/4/60; TempoClock.default.tempo = ~t;
~t = 155/4/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,1,3,-1
			],inf).stutter(6),
			\octave, 3,
			\legato, Pseq([
				4,0,0, 0,0,0,  2,0,0, 0,0,0,
				4,0,0, 0,0,0,  0,0,1/2, 1,0,0,
				4,0,0, 0,0,1/2,  1,0,0, 0,0,0,
				4,0,0, 0,0,0,  0,0,0, 1/2,0,1/2,
				4,0,0, 0,0,0,  2,0,0, 0,0,0,
				4,0,0, 0,0,0,  0,0,1/2, 1,0,0,
				0,0,0, 0,0,1/2,  6,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 1,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.071,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\choruscompresseffectx,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\sendbus1),
			\dur, 1,
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,0,  0,0,0, 1,0,1,
				0,0,0, 1,0,0,  0,0,0, 0,0,0,
				1,0,0, 0,0,0,  0,0,1, 1,0,1,
				0,0,0, 1,0,0,  0,0,0, 0,0,0,
				1,0,0, 0,0,0,  0,0,0, 1,0,1,
				0,0,0, 1,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 1,0,1,  0,0,0, 0,0,0,
			],inf).coin.not,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \snare_electro,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\freq, 200,
			\dur, 1/8,
			\amp, 0.2,
		),
		Pbind(
			\instrument, "snaretuned2",
			\isRest, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,1,
				0,0,1, 1,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,1,
				0,0,0, 1,0,1,  0,0,0, 0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.2) ],
			],inf),
			\dur, 1/12,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \hihat_electro,
			\freq, 200,
			\isRest, Pseq([
				1,0,0, 1,0,1, 1,0,1, 1,0,1,
				1,1,0, 1,0,0, 1,0,0, 1,0,0,
				1,0,1, 1,0,0, 1,1,0, 1,0,1,
				1,1,0, 1,0,0, 1,0,0, 1,0,1,

				1,0,0, 1,0,1, 1,0,1, 1,0,1,
				1,1,0, 1,0,0, 1,0,0, 1,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				1,1,0, 1,0,0, 0,0,1, 1,1,1,
			],inf).coin.not,
			\dur, 1/12,
			\amp, 0.1 * Pseq([
				1,0.6,0.7,
			],inf),
		),
		Pbind(
			\instrument, \kalimba,
			\note, Pseq([
				0,-1
			],inf),
			\isRest, Pseq([
				1,0,0,1, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \kalimba,
			\note, Pseq([
				4,3,3,3,
			],inf),
			\octave, 7,
			\legato, Pseq([
				4,0,0,0, 0,0,2,0,
				4,0,0,0, 0,0,2,0,
				4,0,0,0, 0,0,2,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kalimba,
			\note, Pseq([
				4,3,3,3,
			],inf),
			//\sdf, Pfunc({ arg ev; ev.use({ ~freq.value.postln }); 1 }),
			\freq, ~pmodenv.(Pseq([329,311].reverse,inf), 2),
			\octave, 7,
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,

				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				4,0,0, 0,0,0,  1,0,1, 1,0,1,
				1,0,0, 1,0,0,  0,0,0, 1,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \vlip,
			\freq, 200,
			\legato, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, Pseq([
				Pseq([
					\stringsx,
				],6),
				Pseq([
					\stringsx2,
				],2),
			],inf),
			\note, Pseq([
				[0,3,7],
				[0,3,7]+3,
				[0,3,7],
				[0,3,7]+3,
				[0,3,7],
				[0,3,7]+3,
				[0,3,7],
				[0,3,7]+3,
			],inf),
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(0.1,0.1,0.8,3.1) ],
				],6),
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
					[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\legato, Pseq([
				Pseq([
					0.8,
				],6),
				0.1,0.8,
			],inf),
			\lag, Pseq([
				Pseq([
					0
				],6),
				5/12,
				0,
			],inf),
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
)

(
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,1,3,-1
			],inf).stutter(6),
			\octave, 3,
			\legato, Pseq([
				4,0,0, 0,0,0,  2,0,0, 0,0,0,
				4,0,0, 0,0,0,  0,0,1/2, 1,0,0,
				4,0,0, 0,0,1/2,  1,0,0, 0,0,0,
				4,0,0, 0,0,0,  0,0,0, 1/2,0,1/2,
				4,0,0, 0,0,0,  2,0,0, 0,0,0,
				4,0,0, 0,0,0,  0,0,1/2, 1,0,0,
				0,0,0, 0,0,1/2,  6,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 1,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.071,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\choruscompresseffectx,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\sendbus1),
			\dur, 1,
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,0,  0,0,0, 1,0,1,
				0,0,0, 1,0,0,  0,0,0, 0,0,0,
				1,0,0, 0,0,0,  0,0,1, 1,0,1,
				0,0,0, 1,0,0,  0,0,0, 0,0,0,
				1,0,0, 0,0,0,  0,0,0, 1,0,1,
				0,0,0, 1,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 1,0,1,  0,0,0, 0,0,0,
			],inf).coin.not,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \snare_electro,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\freq, 200,
			\dur, 1/8,
			\amp, 0.2,
		),
		Pbind(
			\instrument, "snaretuned2",
			\isRest, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,1,
				0,0,1, 1,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,1,
				0,0,0, 1,0,1,  0,0,0, 0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.2) ],
			],inf),
			\dur, 1/12,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \hihat_electro,
			\freq, 200,
			\isRest, Pseq([
				1,0,0, 1,0,1, 1,0,1, 1,0,1,
				1,1,0, 1,0,0, 1,0,0, 1,0,0,
				1,0,1, 1,0,0, 1,1,0, 1,0,1,
				1,1,0, 1,0,0, 1,0,0, 1,0,1,

				1,0,0, 1,0,1, 1,0,1, 1,0,1,
				1,1,0, 1,0,0, 1,0,0, 1,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				1,1,0, 1,0,0, 0,0,1, 1,1,1,
			],inf).coin.not,
			\dur, 1/12,
			\amp, 0.1 * Pseq([
				1,0.6,0.7,
			],inf),
		),
		Pbind(
			\instrument, \kalimba,
			\note, Pseq([
				0,-1
			],inf),
			\isRest, Pseq([
				1,0,0,1, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \kalimba,
			\note, Pseq([
				4,3,3,3,
			],inf),
			\octave, 7,
			\legato, Pseq([
				4,0,0,0, 0,0,2,0,
				4,0,0,0, 0,0,2,0,
				4,0,0,0, 0,0,2,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kalimba,
			\note, Pseq([
				4,3,3,3,
			],inf),
			//\sdf, Pfunc({ arg ev; ev.use({ ~freq.value.postln }); 1 }),
			\freq, ~pmodenv.(Pseq([329,311].reverse,inf), 2),
			\octave, 7,
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,

				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				4,0,0, 0,0,0,  1,0,1, 1,0,1,
				1,0,0, 1,0,0,  0,0,0, 1,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \vlip,
			\freq, 200,
			\legato, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, Pseq([
				Pseq([
					\organ_tonewheel1,
				],6),
				Pseq([
					\stringsx2,
				],2),
			],inf),
			\note, Pseq([
				[0,3,7],
				[0,3,7]+3,
				[0,3,7],
				[0,3,7]+3,
				[0,3,7],
				[0,3,7]+3,
				[0,3,7],
				[0,3,7]+3,
			],inf),
			\sus, 1,
			\rel, 0.71,
			\strum, Pseg(Pseq([0,0.4],inf),8),
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(0.1,0.1,0.8,3.1) ],
				],6),
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
					[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\legato, Pseq([
				Pseq([
					0.8,
				],6),
				0.1,0.8,
			],inf),
			\lag, Pseq([
				Pseq([
					0
				],6),
				5/12,
				0,
			],inf),
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,0,-2,-1
			],inf).stutter(6),
			\freq, Pseq([
				Pkey(\freq).keep(12*6),
				~pmodenv.(Pseq([80, 70,65,60,60, 70,65,60,60],1), 1/4),
			],inf),
			\lpf, ~pmodenv.(Pseq([100,500],inf), 2),
			\rq, ~pmodenv.(Pseq([0.1,0.9],inf), 1.22),
			\octave, 3,
			\legato, Pseq([
				8,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 3,0,0,
				8,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 6,0,0,  0,0,0, 3,0,0,
				8,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
				9,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 3,0,0,  0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.071,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\choruscompresseffectx,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\sendbus1),
			\dur, 1,
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,0,  0,0,0, 1,0,1,
				0,0,0, 1,0,0,  0,0,0, 0,0,0,
				1,0,0, 0,0,0,  0,0,1, 1,0,1,
				0,0,0, 1,0,0,  0,0,0, 0,0,0,
				1,0,0, 0,0,0,  0,0,0, 1,0,1,
				0,0,0, 1,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 1,0,1,  0,0,0, 0,0,0,
			],inf).coin.not,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \snare_electro,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\freq, 200,
			\dur, 1/8,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \hihat_electro,
			\freq, 200,
			\isRest, Pseq([
				1,0,0, 1,0,0, 1,1,0, 1,0,0,
				1,0,0, 1,0,0, 1,0,0, 1,0,0,
				1,0,0, 1,0,0, 1,0,1, 1,0,0,
				1,0,1, 0,0,1, 1,0,0, 1,0,0,
			],inf).coin.not,
			\dur, 1/12,
			\amp, 0.1 * Pseq([
				1,0.6,0.7,
			],inf),
		),
		Pbind(
			\instrument, \kalimba,
			\note, Pseq([
				0,-1
			],inf),
			\isRest, Pseq([
				1,0,0,1, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \kalimba,
			\note, Pseq([
				4,3,3,3,
			],inf),
			\octave, 7,
			\legato, Pseq([
				4,0,0,0, 0,0,2,0,
				4,0,0,0, 0,0,2,0,
				4,0,0,0, 0,0,2,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kalimba,
			\note, Pseq([
				4,3,3,3,
			],inf),
			//\sdf, Pfunc({ arg ev; ev.use({ ~freq.value.postln }); 1 }),
			\freq, ~pmodenv.(Pseq([329,311].reverse,inf), 2),
			\octave, 7,
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,

				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				4,0,0, 0,0,0,  1,0,1, 1,0,1,
				1,0,0, 1,0,0,  0,0,0, 1,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \vlip,
			\freq, 200,
			\legato, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, Pseq([
				Pseq([
					\stringsx,
				],6),
				Pseq([
					\stringsx2,
				],2),
			],inf),
			\note, Pseq([
				[0,3,7],
				[0,3,7]+3,
				[0,3,7],
				[0,3,7]+3,
				[0,3,7],
				[0,3,7]+3,
				[0,3,7],
				[0,3,7]+3,
			],inf),
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(0.1,0.1,0.8,3.1) ],
				],6),
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
					[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\legato, Pseq([
				Pseq([
					0.8,
				],6),
				0.1,0.8,
			],inf),
			\lag, Pseq([
				Pseq([
					0
				],6),
				5/12,
				0,
			],inf),
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
)


