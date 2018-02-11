

PatKitDef(\hardcore).edit
PatKitDef(\hardcore).presetCompileString.editorInsert
(
PatKitDef('hardcore').targets = [
	StepEvent.newFrom((gain: 1.3756398719868, pos: 0.04, speed: 1.0559370629371, instrument: 'playersec', bufnum: BufDef('heavy/kick8.flac'), sustain: 1)),
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('heavy/kick12.flac'))),
	StepEvent.newFrom((gain: 1.5299350942137, instrument: 'playersec', bufnum: BufDef('heavy/snare5.flac'))),
	nil,
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('heavy/snare5.flac'))),
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('heavy/snare4.flac'))),
	nil,
	nil,
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('loop/loop1_185bpm.flac'))),
];
);


(
~t = 180/2/60; TempoClock.default.tempo = ~t;
Pdef.defaultQuant = 8;
)

Pdef(\drums).set(\out, nil)
(
Pdef(\drums, 
	Ppar([
		Pbind(\sustain, 0.1) <> PatKitDef(\hardcore).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, Pseq([
				2,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
			],inf),
			\dur, 1/8,
			\gain, 0.8,
			\amp, 0.1,
		)),
		PatKitDef(\hardcore).asPattern(Pbind(
			\kitIndex, Pseq([8,1],inf).stutter(2),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
			],inf).coin.not,
			\sustain, 1.0,
			\dur, PdurStutter(Pseq([1,2,4,8],inf), 1).stutter(8),
			\gain, 1,
			\amp, 0.1,
		)),
		PatKitDef(\hardcore).asPattern(Pbind(
			\kitIndex, 2,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0, 
				1,1,0,0, 1,1,0,0, 1,0,1,1, 1,0,0,0, 

				Pseq([
					1,1,0,0, 1,0,1,0, 1,0,1,1,
					1,1,0,0, 1,0,0,0, 1,0,1,1, 1,0,0,0, 1,0,0,0,
				],4),
			],inf).coin.not,
			\sustain, 0.15 * Pseq([1,0.7,1.1,0.3],inf) * Pseq([1,0.7,0.3,1.2],inf).stutter(32),
			\sustain, 0.15 * Pseq([
				0.6,0.6,0.9,
				0.6,0.6,0.9, 0.6,0.9,
				0.6,0.6,0.9,
				0.6,0.9,0.9, 0.6,0.9,
			].rotate(0),inf).stutter(4) * Pseq([1,Pseq( [ 0.9 ],3 )],inf),
			\speed, 1.0,
			\dur, 1/8,
			\amp, 0.1,
		)),
		
	])
).play;
)

(
	// dnb
Pdef(\drums, 
	Ppar([
		Pbind(\sustain, 0.1) <> PatKitDef(\hardcore).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, Pseq([
				2,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
			],inf),
			\dur, 1/8,
			\gain, 0.8,
			\amp, 0.1,
		)),
		PatKitDef(\hardcore).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0, 
			],inf).coin.not,
			\sustain, 1.0,
			\dur, 1/8,
			\gain, 1,
			\amp, 0.1,
		)),
		PatKitDef(\hardcore).asPattern(Pbind(
			\kitIndex, 2,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0, 
				1,1,0,0, 1,1,0,0, 1,0,1,1, 1,0,0,0, 

				Pseq([
					1,1,0,0, 1,0,1,0, 1,0,1,1,
					1,1,0,0, 1,0,0,0, 1,0,1,1, 1,0,0,0, 1,0,0,0,
				],4),
			],inf).coin.not,
			\sustain, 0.15 * Pseq([1,0.7,1.1,0.3],inf) * Pseq([1,0.7,0.3,1.2],inf).stutter(32),
			\sustain, 0.15 * Pseq([
				0.6,0.6,0.9,
				0.6,0.6,0.9, 0.6,0.9,
				0.6,0.6,0.9,
				0.6,0.9,0.9, 0.6,0.9,
			].rotate(0),inf).stutter(4) * Pseq([1,Pseq( [ 0.9 ],3 )],inf),
			\speed, 1.0,
			\dur, 1/8,
			\amp, 0.1,
		)),
		
	])
).play;
)

/////////////////////////////


(
SynthDef(\neurosnare, {
    var snd;
    // a percussive click to give it some attack
    snd = LPF.ar(HPF.ar(WhiteNoise.ar, 300), 8000) * Env.linen(0.001, 0.01, 0.001).ar;
    // sine sweep body. very important!
    snd = snd + (SinOsc.ar(Env([400, 596, 760], [0.04, 0.7], \exp).ar) * Env.perc(0.04, 0.2).ar * 6.dbamp).tanh;
    // sound of snare coils rattling
    snd = snd + (HPF.ar(BPeakEQ.ar(WhiteNoise.ar, 4000, 0.5, 3), 300) * Env.perc(0.05, 0.2).delay(0.01).ar(2) * -3.dbamp);
    // another sound sweep to improve the attack, optional
    snd = snd + (SinOsc.ar(XLine.kr(3000, 1500, 0.01)) * Env.perc(0.001, 0.02).ar);
    // distortion helps glue everything together and acts as a compressor
    snd = (snd * 1.4).tanh;
    snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1));
    Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\neurosnare, [amp: 0.4]);
(
Pdef(\neurosnare, Pbind(
	\instrument, \neurosnare,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);

/////////////////////////////////////


(
SynthDef(\snarebpf2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var pop, popAmp, popFreq;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;

	popFreq = EnvGen.ar(Env([3261, 410, 160], [0.005, 0.01], curve: \exp));
	popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
	pop = SinOsc.ar(popFreq * ( 1 + ( SinOsc.ar(410) * 0.4 ))) * popAmp;

	env1 = EnvGen.kr(Env([1,0.2,0.01],[0.1,0.8]), 1);

	sig =  BPF.ar(sig, ( 17000*env1.lag(1)*[1,1.01,2,2.4,1/2] ).clip(20,20000), env1, mul:0.952);
	sig = LPF.ar(sig, 10000) + ( sig/2 ) / 1.52;
	//sig = Pluck.ar(sig, 1, 0.01, 1/7000,1);
	sig = sig + CombL.ar(sig, 0.01, 1/freq/2 * [1,1.23,1.433],810);
	sig = sig + pop;

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.4,4.8,0.01,0.11,-6)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
)

(
SynthDef(\tredrone, { arg lagf=0, freq=200, pan=0, amp=0.1, out=0;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(lagf);
	freq = freq * [1, 5/3];
	sig = LFPulse.ar(freq * ( 1 + ( CuspL.ar(\cusfreq.kr(10) + [1,2,3],\cus2.kr(1.1),\cus3.kr(1)).lag(0.1) * ( CuspL.ar(0.1)/3 + 0.1+[ [0,0.01] ] ) * \fma.kr(1) ))).mean;
	sig.debug("kjkj");
	sig = sig /13;
	sig1 = sig;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq.lag(1) * SinOsc.kr(1*~t * [1,3/5]).range(0,1), \rq.kr(0.5));
	sig = sig + BPF.ar(sig1, freq.lag(1) * 8);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
(
Pdef(\tredrone, PmonoArtic(\tredrone,
	\legato, 1,
	\cus3, { rrand(0.01,10) }.dup(3),
	\fma, 0.01,
	\cus2, [1,2,3]*10,
	\cusfreq, [1,2,3]/3,
	\lpfr, 2,
	\lagf, Pseq([1,0,0,1]/2,inf).stutter(8),
	\degree, Pseq([
		[0,2,4],
		[0,2,4]+2,
		[0,2,4],
		[0,2,4]+2-12,
		[0,2,4],
		[0,2,4]+2,
		[0,2,4],
		[-20,-20,-20],
	],inf).stutter(8),
	\dur, 1,
	\amp, 0.1
)).play;
);
);

(
Pdef(\cadrums, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \snarebpf2,
			\freq, 200,
			\legato, Pseq([
				8,0,0,4, 0,1,0,0,
				8,0,0,4, 0,4,0,1,
				8,0,0,1, 0,4,0,0,
				2,0,0,4, 0,1,0,1,
			],inf)/10,
			\legato, Pseq([
				4,0,1,0,
				4,0,16,0,
			],inf)/8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1
		);
	]),

).play;
);

(
Pdef(\cadrums, 
	Ppar([
		PatKitDef(\hardcore).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq({[
				1,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.5,
			\hasGate, false,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.5,
			\hasGate, false,
			\pos, 1/4,
			\speed, -1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\hasGate, false,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \snarebpf2,
			\freq, 200,
			\legato, Pseq([
				8,0,0,4, 0,1,0,0,
				8,0,0,4, 0,4,0,1,
				8,0,0,1, 0,4,0,0,
				2,0,0,4, 0,1,0,1,
			],inf)/10,
			\hasGate, false,
			\legato, Pseq([
				4,0,1,0,
				4,0,16,0,
			],inf)/8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1
		);
	]),

).play;
);
