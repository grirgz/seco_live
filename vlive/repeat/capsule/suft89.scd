
~t = 185/2/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.1, 0.4) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 1,0,1,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 1,0,1,1,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/8,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\velamp, 1/3,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		]),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.1, 0.4) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 1,0,1,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 1,0,1,1,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/8,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.2,
			\velamp, 1/3,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		]),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.1, 0.4) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 1,0,1,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 1,0,1,1,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/8,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\velamp, 1/3,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		]),
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.1, 0.4) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 1,0,1,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 1,0,1,1,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/4,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.2,
			\velamp, 1/3,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/4,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		]),
		
	])
)).play;
);

(
SynthDef(\disso, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1,1.0181, 1.0034]).mean;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\disso2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1,1.0131*2, 1.0024/2]).mean;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \disso,
			\note, Pseq([
				0,0,1,4,
			],inf).stutter(1),
			\lpfr, 2,
			\octave, 3,
			\legato, Pseq([
				2,0,1,1,
			],inf)/2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pseq([0.5,0.5,0.3,0.5].normalizeSum*8,inf),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \disso,
			\out, BusDef(\fxbus1, \audio),
			\note, Pseq([
				[0,3,7-12],
				[0,3,7-12],
				[0,3,7-12]+1,
				[0,3,7-12]+4,
			],inf)+12,
			\legato, Pseq([
				2,0,1,1,
				0,1,0,1,
			],inf)/1.2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pseq([0.5,0.5,0.3,0.5].normalizeSum*2,inf),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \disso2,
			//\out, BusDef(\fxbus1, \audio),
			\lag, 0.04,
			\note, Pseq([
				0,3,7,7
			],inf)+12 + Pseq([
				0,0,1,4,
			],inf),
			\octave, 6,
			\legato, Pseq([
				2,0,1,1,
				0,1,0,1,
			],inf)/1.2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			//\dur, Pseq([0.5,0.5,0.3,0.5].normalizeSum*2,inf),
			\dur, 2,
			\amp, 0.1,
		),
		Pmono( \rdnnap,
			\inbus, BusDef(\fxbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.95504173856142,
			'gain', 0.25172029669548,
			'fb', 0.00010795156148588,
			'delay', 0.46117477677083,
			'delay2', 0.60466190090704,
			'delay', ~pmodenv.(Pseq([1,1,0.000001,0.04],inf), 8),
			'delay2', ~pmodenv.(Pseq([1,1,0.000001,0.04],inf), 8),
			'shift', 0,
			'shift2', 0,
			'distamp', 0.76269858590234,
			'pitchlag', 0.125,
			'pitchmix', 0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5,
			'fbdistmix', 1,
			'postlpf', 17000,
			'posthpf', 710.31365523618,
			\postpfmix, 0.3,
			'wetamp', 1,
			'indelay', 0,
			'wet20', 1.0,
			'mamp', 1,
		),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([

			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\bodyenv, [ Env.linen(0.005, 0.1, 0.4) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0,0, 1,0,1,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,1, 1,0,1,1,
					0,0,0,0, 0,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					1,0,0,1, 1,0,1,1,
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/3,
				\dur, 1/8,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.2,
				\velamp, 1/3,
				\dur, 1/8,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,1,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,

					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,0,
					0,1,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/4,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
	]),
).play;
);



~rdn_to_fbstring.(RandDelayNetwork(ProtoDef(\rdn2).fxdef)).editorInsert // with outer synthdef and preset pbind
(

	SynthDef(\rdnnap, { arg out=0, gate=1;
		var sig;
		var sig2;
		var si, env = ();
		var si2;
		var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 

		thisThread.randSeed = 644110;

		sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
		si = sig;
		sig = { arg si, env;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
			si = (si * 10.rand * \distamp.kr).tanh / 2;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			si = [
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				}.value(si, env);

			].mean;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
			si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
			si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		}.value(si, env);

		//sig2 = HPF.ar(sig, \hpf.kr(14), \hprq.kr(0.1));
		//sig2 = LPF.ar(sig2, \lpf.kr(19900), \lprq.kr(1));
		//sig = SelectX.ar(\pfmix.kr(0.0), [sig, sig2]);
		sig = Limiter.ar(sig);
		LocalOut.ar(sig);

		//sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(0));
		//sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(0));
		sig2 = HPF.ar(sig, \posthpf.kr(14), \posthprq.kr(0.1));
		sig2 = LPF.ar(sig2, \postlpf.kr(19900), \postlprq.kr(1));
		sig = SelectX.ar(\postpfmix.kr(0.0), [sig, sig2]);
		sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
		sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
		sig = sig * \gain.kr(1);
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
		Out.ar(out, sig);

	}).add;

		
Pbind(
	'wet10', 1.0,
	'mix', 0.95504173856142,
	'gain', 0.25172029669548,
	'fb', 0.00010795156148588,
	'delay', 0.46117477677083,
	'delay2', 0.60466190090704,
	'shift', 0,
	'shift2', 0,
	'distamp', 0.76269858590234,
	'pitchlag', 0.125,
	'pitchmix', 0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.5,
	'fbdistmix', 1,
	'postlpf', 17000,
	'posthpf', 710.31365523618,
	'wetamp', 1,
	'indelay', 0,
	'wet20', 1.0,
	'mamp', 1,
)
		
);

rdntostring	



(
Pdef(\zed, 
	Ppar([
			Pbind(
				\instrument, \disso,
				\note, Pseq([
					0,0,1,4,
				],inf).stutter(1),
				\lpfr, 2,
				\octave, 3,
				\legato, Pseq([
					2,0,1,1,
				],inf)/2,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, Pseq([0.5,0.5,0.3,0.5].normalizeSum*8,inf),
				\amp, 0.1,
				\out, BusDef(\sendbus2, \audio),
			),
		Pbind(\out, BusDef(\sendbus3, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \disso,
				\out, BusDef(\fxbus1, \audio),
				\note, Pseq([
					[0,3,7-12],
					[0,3,7-12],
					[0,3,7-12]+1,
					[0,3,7-12]+4,
				],inf)+12,
				\legato, Pseq([
					2,0,1,1,
					0,1,0,1,
				],inf)/1.2,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, Pseq([0.5,0.5,0.3,0.5].normalizeSum*2,inf),
				\amp, 0.1,
			),
			Pbind(
				\instrument, \disso2,
				//\out, BusDef(\fxbus1, \audio),
				\lag, 0.04,
				\note, Pseq([
					0,3,7,7
				],inf)+12 + Pseq([
					0,0,1,4,
				],inf),
				\octave, 6,
				\legato, Pseq([
					2,0,1,1,
					0,1,0,1,
				],inf)/1.2,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\dur, Pseq([0.5,0.5,0.3,0.5].normalizeSum*2,inf),
				\dur, 2,
				\amp, 0.1,
			),
		]),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([

			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\bodyenv, [ Env.linen(0.005, 0.1, 0.4) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0,0, 1,0,1,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,1, 1,0,1,1,
					0,0,0,0, 0,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					1,0,0,1, 1,0,1,1,
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/3,
				\dur, 1/8,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.2,
				\velamp, 1/3,
				\dur, 1/8,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,1,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,

					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,0,
					0,1,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/4,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
	]),
).play;
);


/////////////

~protordn_to_fbstring.(ProtoDef(\rdn2)).editorInsert
(

		SynthDef(\rdnbigdist, { arg out=0, gate=1;
			var si, env = ();
			var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
			var code, rdnkey;
			
		var sig;
		var sigin;
		var del, shi;
		var del2, shi2;
		var distamp;
		var hasFreq, afreq;
		var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
		var pitchlag;
		var pitchmix;
		var fb, fb1, fb2;
		var gain;
		var mix;
		var indelay;
		//"default_make_graph".debug("!!!");
		rdnkey = rdnkey ? \default;
		code = code ? "4--";
		sig = in;
		mix = \mix.kr(0.5);
		gain = \gain.kr(1);
		fb = \fb.kr(0.001);
		del = \delay.kr(0.001,0.1);
		del2 = \delay2.kr(0.001,0.1);
		shi = \shift.kr(0);
		shi2 = \shift2.kr(0);
		distamp = \distamp.kr(1);
		pitchlag = \pitchlag.kr(1/8) / TempoClock.default.tempo;
		pitchmix = \pitchmix.kr(0);

		sig = LPF.ar(sig, \prelpf.kr(17000));
		sig = HPF.ar(sig, \prehpf.kr(17));

		sig = sig + (LocalIn.ar(2) * fb);

		sig = LPF.ar(sig, \lpf.kr(17000));
		sig = HPF.ar(sig, \hpf.kr(17));
		thisThread.randSeed = 543003;
si = sig;
sig = { arg si, env;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
si = [
			{ arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
}.value(si, env);
,
			{ arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
}.value(si, env);
,
			{ arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = [
							{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
}.value(si, env);
,
							{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = [
											{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
}.value(si, env);
,
											{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
}.value(si, env);
,
											{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
}.value(si, env);
,
											{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
}.value(si, env);

].mean;
}.value(si, env);

].mean;
}.value(si, env);
,
			{ arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
}.value(si, env);

].mean;
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
}.value(si, env);


		sig1 = sig.tanh * \fbdistamp.kr(1/2);
		sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

		sig = Limiter.ar(sig);

		sig1 = sig;
		#afreq, hasFreq = Pitch.kr(sig1).flop;
		sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
		#afreq, hasFreq = Pitch.kr(sig1).flop;
		sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
		sig = SelectX.ar(pitchmix, [sig, sig1]);

		LocalOut.ar(sig);
		sig = LPF.ar(sig, \postlpf.kr(17000));
		sig = HPF.ar(sig, \posthpf.kr(17));
		sig = Limiter.ar(sig);
		sig = sig * \wetamp.kr(1);

		indelay = \indelay.kr(0);
		sigin = DelayL.ar(in, 0.2, indelay);
		sig = SelectX.ar(mix, [sigin, sig]);
		sig = sig * gain;
		//sig.debug("end sig");
		sig;
	

			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
			Out.ar(out, sig);
		}).add;

		
Pbind(
	'wet10', 1.0,
	'mix', 0.5,
	'gain', 0.2391360215375,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0,
	'shift2', 0,
	'distamp', 1,
	'pitchlag', 0.125,
	'pitchmix', 0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.5,
	'fbdistmix', 1,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 1,
	'indelay', 0,
	'wet20', 1.0,
	'mamp', 1,
)

		
);



(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\fxbus1, \audio)) <>
		//Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([

			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\bodyenv, [ Env.linen(0.005, 0.1, 0.4) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0,0, 1,0,1,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,1, 1,0,1,1,
					0,0,0,0, 0,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					1,0,0,1, 1,0,1,1,
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/3,
				\dur, 1/8,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.2,
				\velamp, 1/3,
				\dur, 1/8,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,1,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,

					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,0,
					0,1,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/4,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pmono(\rdnbigdist,
			\inbus, BusDef(\fxbus1,\audio),
			'wet10', 1.0,
			'mix', 0.5,
			'gain', 0.2391360215375,
			'fb', 0.0111,
			'delay', 0.0000011,
			'delay2', 0.0000001,
			'shift', 0,
			'shift2', 0.1,
			'distamp', 1,
			'pitchlag', 0.125,
			'pitchmix', 0,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 0.5,
			'fbdistmix', 1,
			'postlpf', 19000,
			'posthpf', 17,
			'wetamp', 1,
			'indelay', 0,
			'wet20', 1.0,
			'mamp', 1,
		),

		
	])
)).play;
);



(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.1, 0.4) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 1,0,1,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 1,0,1,1,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/8,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\velamp, 1/3,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		]),
		Pbind(\out, BusDef(\fxbus1, \audio)) <>
		Ppar([
			
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.1, 0.4) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 1,0,1,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 1,0,1,1,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/4,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.2,
			\velamp, 1/3,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/4,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		]),
		Pmono(\rdnbigdist,
			\inbus, BusDef(\fxbus1,\audio),
			'wet10', 1.0,
			'mix', 0.5,
			'gain', 0.2391360215375,
			'fb', 0.000111,
			'delay', 0.0000011,
			'delay2', 0.0000001,
			'shift', Pseq([0,0.1],inf),
			'shift2', 0,
			'distamp', 1,
			'pitchlag', 0.125,
			'pitchmix', 0,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 0.5,
			'fbdistmix', 1,
			'postlpf', 19000,
			'posthpf', 17,
			'wetamp', 1,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
		Pmono(\rdnmalte,
			\inbus, BusDef(\sendbus1, \audio),
			\dur, 1,
	'wet10', 1.0,
	'mix', 0.60195390291997,
	'gain', 1,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001123104501833,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 27.885481717263,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 257.20161612211,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 3.9466141732283,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.0001,
	'distamp2', 3.9466141732283,
		),
		
	])
)).play;
);

~protordn_to_fbstring.(ProtoDef(\rdn)).editorInsert
(

		SynthDef(\rdnmalte, { arg out=0, gate=1;
			var si, env = ();
			var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
			var code, rdnkey;
			
		var sig;
		var sigin;
		var del, shi;
		var del2, shi2;
		var distamp;
		var hasFreq, afreq;
		var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
		var pitchlag;
		var pitchmix;
		var fb, fb1, fb2;
		var gain;
		var mix;
		var indelay;
		//"default_make_graph".debug("!!!");
		rdnkey = rdnkey ? \default;
		code = code ? "4--";
		sig = in;
		mix = \mix.kr(0.5);
		gain = \gain.kr(1);
		fb = \fb.kr(0.001);
		del = \delay.kr(0.001,0.1);
		del2 = \delay2.kr(0.001,0.1);
		shi = \shift.kr(0);
		shi2 = \shift2.kr(0);
		distamp = \distamp.kr(1);
		pitchlag = \pitchlag.kr(1/8) / TempoClock.default.tempo;
		pitchmix = \pitchmix.kr(0);

		sig = LPF.ar(sig, \prelpf.kr(17000));
		sig = HPF.ar(sig, \prehpf.kr(17));

		sig = sig + (LocalIn.ar(2) * fb);

		sig = LPF.ar(sig, \lpf.kr(17000));
		sig = HPF.ar(sig, \hpf.kr(17));
		thisThread.randSeed = 152183;
si = sig;
sig = { arg si, env;
si = (si * 10.rand * \distamp.kr).tanh / 2;
si = [
			{ arg si, env;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
}.value(si, env);
,
			{ arg si, env;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
}.value(si, env);
,
			{ arg si, env;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
}.value(si, env);
,
			{ arg si, env;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
}.value(si, env);

].mean;
si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
si = [
			{ arg si, env;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
}.value(si, env);
,
			{ arg si, env;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
}.value(si, env);
,
			{ arg si, env;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
}.value(si, env);
,
			{ arg si, env;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
}.value(si, env);

].mean;
}.value(si, env);


		sig1 = sig.tanh * \fbdistamp.kr(1/2);
		sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

		sig = Limiter.ar(sig);

		sig1 = sig;
		#afreq, hasFreq = Pitch.kr(sig1).flop;
		sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
		#afreq, hasFreq = Pitch.kr(sig1).flop;
		sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
		sig = SelectX.ar(pitchmix, [sig, sig1]);

		LocalOut.ar(sig);
		sig = LPF.ar(sig, \postlpf.kr(17000));
		sig = HPF.ar(sig, \posthpf.kr(17));
		sig = Limiter.ar(sig);
		sig = sig * \wetamp.kr(1);

		indelay = \indelay.kr(0);
		sigin = DelayL.ar(in, 0.2, indelay);
		sig = SelectX.ar(mix, [sigin, sig]);
		sig = sig * gain;
		//sig.debug("end sig");
		sig;
	

			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
			Out.ar(out, sig);
		}).add;

		
Pbind(
	'wet10', 1.0,
	'mix', 0.60195390291997,
	'gain', 1,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001123104501833,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 27.885481717263,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 257.20161612211,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 3.9466141732283,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.0001,
	'distamp2', 3.9466141732283,
)

		
);

