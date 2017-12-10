(
SynthDef(\fmgbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fratio=1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	sig = FMGrain.ar(
		Impulse.ar(freq/2), 0.1, freq , freq*fratio * ( 1 + ( SinOsc.ar(freq*1) * 0.001 )),
		LFSaw.ar( freq!2 ).range(0.1, 1 * env1),
	).sum;
	sig = sig * 3;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

(
	~master.();
Pdef(\track3_idea, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.4,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				1,0,1,1, 0,1,1,0,
				1,1,1,0, 1,0,1,1,
				0,0,1,0, 0,1,1,0,
				0,1,0,0, 1,0,1,0,
				1,0,1,1, 0,1,1,0,
				1,1,1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1/8,
			\speed, 1 * Pwhite(1/2,2.1),
			\dur, 1/16,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\hat) <> Pbind(
			\kitIndex, 9,
			\isRest, Pseq([
				0.51,1
			],inf).coin.not,
			\sustain, 0.1/8,
			\gain, 2,
			\speed, 1 * Pwhite(1/2,2.1),
			\dur, 1/16,
			\amp, 0.1,
		)),
		Pdef(\bass) <> Pbind(
			\instrument, \fmgbass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, 0.3,
			\fratio, 1,
			\octave, 3,
			\dur, Pseq([
				Pser([
					1/2,
				],32),
				Prand([1/8,1/4,1/3, Prand(1/(1..8),1)],4).stutter(6),
			],inf),
			\amp, 0.02
		),
		
	])
).play;
)
