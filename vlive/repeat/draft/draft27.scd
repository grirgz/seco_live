ProtoDef(\rardn, ProtoTemplateDef(\rdn));
ProtoDef(\rardn).edit;

(
SynthDef(\snapkick, { |out = 0, pan = 0, amp = 0.3|
	var body, bodyFreq, bodyAmp;
	var pop, popFreq, popAmp;
	var click, clickAmp;
	var snd;

	// body starts midrange, quickly drops down to low freqs, and trails off
	bodyFreq = EnvGen.ar(Env([261, 90, 51], [0.035, 0.08], curve: \exp));
	bodyAmp = EnvGen.ar(Env.linen(0.005, 0.1, 0.3), doneAction: 2);
	body = SinOsc.ar(bodyFreq) * bodyAmp;
	// pop sweeps over the midrange
	popFreq = XLine.kr(750, 261, 0.02);
	popAmp = EnvGen.ar(Env.linen(0.001, 0.02, 0.001)) * 0.15;
	pop = SinOsc.ar(popFreq) * popAmp;
	// click is spectrally rich, covering the high-freq range
	// you can use Formant, FM, noise, whatever
	clickAmp = EnvGen.ar(Env.perc(0.001, 0.01)) * 0.15;
	click = LPF.ar(Formant.ar(910, 4760, 2110), 3140) * clickAmp;

	snd = body + pop + click;
	snd = snd.tanh;

	Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;
)

(
Pdef(\fxpatdrummer, 
	Ppar([
		//Pmono(\drumfx,
		//	\inbus, BusDef(\fx1, \audio),
		//	\dur, 1/4,
		//	'wet10', 1.0,
		//	'mix', 0.4,
		//	\eqdb2b, 8,
		//	\eqdb2a, 8,
		//	'gain', 0.41015160133764,
		//	'fb', Pseq([
		//		0,0,0,0.0001,
		//		0,0,0,0.00001,
		//		0,0.08,0,0.00001,
		//		0,0,0,0.00001,
		//	],inf),
		//	'delay2', 0.00013111339374216,
		//	'delay', Pseq([
		//		Pser([
		//			0,0,0,0.008,
		//			0,0,0.00001,0.00008,
		//			0,0,0,0.008,
		//			0,0,0,0.8,
		//		],8*4),

		//		Pser([
		//			0,0,0,0.6,
		//			0.001,0,0,0.008,
		//			0,0.009,0.40001,0.00008,
		//			0,0,0,0.08,
		//		],8*4),
		//	],inf) + 0.000001,
		//	'delay2', Pseq([
		//		Pseq([
		//			0.00010306431405564,
		//			0.00000306431405564,
		//			0.00000306431405564,
		//			0.0000010306431405564,
		//		],6),
		//		Pseq([
		//			0.00000006431405564,
		//			0.00010306431405564,
		//			0.00100306431405564,
		//			0.0001010306431405564,
		//		],2),
		//		Pseq([
		//			0.00000306431405564,
		//			0.00110306431405564,
		//			0.00000306431405564,
		//			0.0000010306431405564,
		//		],6),
		//		Pseq([
		//			0.00000006431405564,
		//			0.00100306431405564,
		//			0.00010306431405564,
		//			0.0001010306431405564,
		//		],2),
		//	],inf),
		//	'distamp', Pseq([
		//		0.1,0.1, 0.1,0.1,
		//		0.1,0.1, 0.1,0.1,
		//		0.1,10.1, 0.1,0.1,
		//		0.1,0.1, 0.1,0.1,

		//		0.1,0.1, 0.1,0.1,
		//		0.1,0.1, 0.1,0.1,
		//		0.1,0.1, 0.1,0.1,
		//		100,0.1,1,1,
		//	],inf),
		//	'shift', 0.0,
		//	'shift2', 0.0,
		//	'pitchlag', 1.0,
		//	'pitchmix', 0.0,
		//	'prelpf', 17000,
		//	'prehpf', 92.923391195936,
		//	'lpf', 17000,
		//	'hpf', 17,
		//	'fbdistamp', 0.47619047619048,
		//	'fbdistmix', 0.41176470588235,
		//	'postlpf', 17000,
		//	'posthpf', 17,
		//	'wetamp', 0.18504562572587,
		//	'indelay', 0.04,
		//	'wet20', 1.0,
		//	'mamp', 1,
		//),
		Pbind(
			\instrument, \default,
			\freq, 30,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\out, BusDef(\fx1, \audio),
		),
		Pbind(
			\instrument, \snapkick,
			//\out, BusDef(\fx1, \audio),
			\lag, 0.04,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\sustain, 0.1,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snaretuned,
			\out, BusDef(\fx1, \audio),
			\sustain, 0.1/2,
			\adsr, Pseq([
				 [ Env.adsr(0.1/3,0.1,0.8,0.2,1,-6) ]
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\pan, 0.1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snaretuned,
			\out, BusDef(\fx1, \audio),
			\sustain, 0.04,
			\adsr, Pseq([
				 [ Env.adsr(0.1/2,0.1,0.8,0.1,1,-6) ]
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,1,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\pan, 0.1/2,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \stickfight,
			\out, BusDef(\fx1, \audio),
			\fac1, Pseq([1,0.8]*1.1,inf),
			\sustain, Pseq([0.1,0.05],inf),
			\isRest, Pseq([
				Pseq({[
					1,0,1,1, 1,1,1,0,
					1,0,1,0, 1,0,1,0, 
					1,0,1,1, 1,0,1,0, 
					1,0,0,0, 1,0,0,0,
					1,1,0,1, 0,0,0,0,
					0,0,0,0, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
				].clump(8).choose}.dup(8).flat,inf)
			],inf).coin.not,
			\isRest, Pseq([
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8 * (1 + (0.01 * Pseq([-1,1],inf))),
			\amp, 0.1 * Pseq([1,0.4],inf) * 0.3 * Pseq([
				1
			],inf),
		),
		Pbind(
			\instrument, \phycymbal,
			\out, BusDef(\fx1, \audio),
			\sustain, 0.1/3,
			\adsr, Pseq([
				 [ Env.adsr(0.001,0.1,1.8,0.07,1,-3) ],
				 [ Env.adsr(0.002,0.1,0.8,0.04,1,-3) ],
			],inf).stutter(2),
			\pan, -0.1,
			\isRest, Pseq([
				1,1,1,1, 
			],inf).coin.not,
			\rel, Pseq([
				1,1,1,1, 1,1,8,1,
			],inf)*0.1,
			\dur, 1/8,
			\sustain, Pseq([
				0.05, 0.02, 0.05, 0.02,
				0.05, 0.02, 1/6/~t, 0.02,
			],inf)/2,
			\amp, 0.1/2,
			\amp, Pkey(\amp) * Pseq([
				1, 0.7, 0.9, 0.5,
				Plazy({ Pseq([
					1, 0.7, 0.9, 0.5,
				].scramble,1) }),
			],inf),
		),

		
	].collect({ arg x; Pbind(\dur, Pkey(\dur)*2) <> x }))
).play;
)

///////////////////////////////////

~t = 185/4/60; TempoClock.default.tempo = ~t;

(
Pdef(\smp, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\out, BusDef(\fx1, \audio),
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 1.4,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \playersec,
			\out, BusDef(\fx1, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\freq, 200,
			\legato, 0.9,
			\gain, 0.2,
			\dur, 8,
			\amp, 0.1,
		);
	])
).play;
)

(
Pdef(\smp, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\out, BusDef(\fx1, \audio),
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\out, BusDef(\fx1, \audio),
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.7,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \phyhat,
			\out, BusDef(\fx1, \audio),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 1,1,1,1,
			],inf).coin.not,
			\sustain, 0.01,
			\dur, 1/8,
			\amp, 0.1/8,
		),
		Pbind(
			\instrument, \phycymbal,
			\out, BusDef(\fx1, \audio),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 1.01,
			\dur, 1/8,
			\amp, 0.4,
		),
		//Pbind(
		//	\instrument, \playersec,
		//	\out, BusDef(\fx1, \audio),
		//	\bufnum, BufDef('voices/feynman.flac'),
		//	\pos, Pseq([
		//		1.9,0.5,2,0.6,
		//		1.9,0.5,2.1,0.6,
		//		1.9,0.5,2,0.6,
		//		1.5,0.5,2.1,0.6,
		//	],inf),
		//	\legato, 0.2,
		//	\gain, 0.2,
		//	\dur, 1/8,
		//	\amp, 0.1,
		//),
		Pbind(
			\instrument, \playersec,
			\out, BusDef(\fx1, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				1.9,0.5,2,0.6,
				1.9,0.5,2.1,0.6,
				1.9,0.5,2,0.6,
				1.5,0.5,2.1,0.6,
			],inf),
			\legato, Pseq([
				0.8,0.1,
			],inf),
			\gain, 0.3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec_fx,
			\out, BusDef(\fx1, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				4,
				2,
			],inf).stutter(8),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,1,1,0,
			],inf).coin.not,
			\legato, Pseq([
				Pser([
					4.2,
				],8*2),
			],inf),
			\gain, 0.3,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
).play;
)

(
SynthDef(\playersec_fx, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.5,0],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,0.5,0],[0.1,0.8]), 1);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * SinOsc.ar(\amplfo.kr(8*~t)).range(env1,1);
	sig = sig + FreqShift.ar(sig, SinOsc.kr(\shiftlfo.kr(4*~t)).range(env2,1));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
MenuSpecDef(\patkitdef_synthdefs).addUnique(\playersec_fx);
)

(
Pdef(\smp, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\out, BusDef(\fx1, \audio),
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \snapkick,
			\isRest, Pseq([
				0,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\lag, 0.04,
			\dur, 1,
			\amp, 0.1,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\out, BusDef(\fx1, \audio),
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \phyhat,
			\out, BusDef(\fx1, \audio),
			\isRest, Pseq([
				0,0,1,0, 0,1,1,1,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,1,0,0, 1,1,1,1,
			],inf).coin.not,
			\sustain, 0.01,
			\dur, 1/8,
			\amp, 0.1/8,
		),
		Pbind(
			\instrument, \phycymbal,
			\out, BusDef(\fx1, \audio),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 1.01,
			\dur, 1/8,
			\amp, 0.4,
			\isRest, true,
		),
		//Pbind(
		//	\instrument, \playersec,
		//	\out, BusDef(\fx1, \audio),
		//	\bufnum, BufDef('voices/feynman.flac'),
		//	\pos, Pseq([
		//		1.9,0.5,2,0.6,
		//		1.9,0.5,2.1,0.6,
		//		1.9,0.5,2,0.6,
		//		1.5,0.5,2.1,0.6,
		//	],inf),
		//	\legato, 0.2,
		//	\gain, 0.2,
		//	\dur, 1/8,
		//	\amp, 0.1,
		//),
		Pbind(
			\instrument, \sibass,
			\degree, Pseq([
				0,\r,\r,\r,
				0,\r,0,\r,
				0,\r,\r,\r,
				0,\r,\r,-4,
			],inf),
			\legato, Pseq([
				4,1,1,1,
				1,1,1,1,
				4,1,1,1,
				2.9,1,1,0.61,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\out, BusDef(\fx1, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				1.9,0.5,2,0.6,
				1.9,0.5,2.1,0.6,
				1.9,0.5,2,0.6,
				1.5,0.5,2.1,0.6,
			],inf),
			\legato, Pseq([
				1.8,0.1, 0.8,0.1,
			],inf),
			\gain, 0.5,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec_fx,
			\out, BusDef(\fx1, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				4,
				2,
			],inf).stutter(8),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\speed, 1.2,
			\legato, Pseq([
				Pser([
					8.2,
				],8*2),
			],inf),
			\gain, 0.6,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
).play;
)

(
Pdef(\smp, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\out, BusDef(\fx1, \audio),
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \snapkick,
			//\out, BusDef(\fx1, \audio),
			\isRest, Pseq([
				0,0,1,0, 0,0,0,1,
				0,0,0,1, 0,0,0,0,
				0,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\lag, 0.04,
			\dur, 1/8,
			\amp, 0.1,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\out, BusDef(\fx1, \audio),
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\out, BusDef(\fx1, \audio),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\gain, 0.8,
			\lag, 0.1,
			\pos, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \phyhat,
			\out, BusDef(\fx1, \audio),
			\isRest, Pseq([
				0,0,1,0, 0,1,1,1,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,1,0,0, 1,1,1,1,
			],inf).coin.not,
			\sustain, 0.01,
			\dur, 1/8,
			\amp, 0.1/8,
		),
		Pbind(
			\instrument, \phycymbal,
			\out, BusDef(\fx1, \audio),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 1.01,
			\dur, 1/8,
			\amp, 0.4,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\out, BusDef(\fx1, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				1.9,0.5,2,0.6,
				1.9,0.5,2.1,0.6,
				1.9,0.5,2,0.6,
				1.5,0.5,2.1,0.6,
			],inf) +0.3,
			\legato, 0.6,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				0,1,1,1, 1,0,1,1, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,1, 0,1,1,0,
			],inf).coin.not,
			\speed, 4.0,
			\gain, 0.2,
			\dur, 1/16,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pseq([
				0,\r,\r,\r,
				0,\r,0,\r,
				0,\r,\r,\r,
				0,\r,\r,-4,
			],inf),
			\legato, Pseq([
				4,1,1,1,
				1,1,1,1,
				4,1,1,1,
				2.9,1,1,0.61,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\out, BusDef(\fx1, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				1.9,0.5,2,0.6,
				1.9,0.5,2.1,0.6,
				1.9,0.5,2,0.6,
				1.5,0.5,2.1,0.6,
			],inf),
			\legato, Pseq([
				1.8,0.1, 0.8,0.1,
			],inf),
			\gain, 0.5,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec_fx,
			\out, BusDef(\fx1, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				4,
				2,
			],inf).stutter(8),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\speed, 1.2,
			\legato, Pseq([
				Pser([
					8.2,
				],8*2),
			],inf),
			\gain, 0.6,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		//Pbind(
		//	\instrument, \amb,
		//	\freq, 800,
		//	\dur, 4,
		//	\amp, 0.1,
		//),
	])
).play;
)

(
SynthDef(\amb, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * [1,2,1/2] * ( 1 + ( SinOsc.ar([1,2,3,4,5.23,1.12]*100) * 10 )));
	sig = WhiteNoise.ar + sig;
	sig = BPF.ar(sig, SinOsc.kr(1/3 * [1,1.2,1/23] * 1/100).range(200,10000), 0.1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum * 0.5;
	Out.ar(out, sig);
}).add;
);


