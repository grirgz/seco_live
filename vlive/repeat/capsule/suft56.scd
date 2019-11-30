(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\lag, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.2,
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
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,1,1,1,
				0,0,0,0, 1,1,1,1,
			],inf).coin.not,
			\sustain, 0.1/4,
			\lag, 1,
			\gain, 0.2* Pseq([
				1,0.6,
			],inf),
			//\lag, Pseq([0,0.025],inf),
			\dur, 1/16,
		)),

		Pbind(
				\note, Pseq([
					0,-1,-2,-3
				],inf).stutter(2),
		)<>
		Ppar([
			Pbind(
				\instrument, \simpleacid,
				\isRest, Pseq([
					1,0,0,0, 1,1,1,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
					1,1,0,0, 1,0,1,1,
					1,1,1,0, 0,0,0,0,
				],inf).coin.not,
				\legato, Pseg(Pseq([0.1,1],inf),8),
				\lpfr, ~pmodenv.(Pseq([1,2,1,4,1/2],inf), Prand([1/7,1/9,1/3,1/4,1/8,1],inf)),
				\dur, 1/8,
				\amp, 0.1/2,
				\out, BusDef(\sendbus1, \audio),
			),
			Pbind(
				\instrument, \simpleacid,
				\note, Pseq([
					0,1,2,
				],inf).stutter(8),
				\octave, 6,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, Pseg(Pseq([1,0.1],inf),8),
				\lpfr, ~pmodenv.(Pseq([1,2,1,4,1/2]/2,inf), Prand([1/7,1/9,1/3,1/4,1/8,1],inf)),
				\dur, 1/8,
				\amp, 0.1/2,
				\out, BusDef(\sendbus1, \audio),
			),
		]),
		Pmono(\fater,
			\inbus, BusDef(\sendbus1),
			\mix, 0.71,
			\pulse, Pseq([
				1,0,0,1,0,0,1,0,
				1,0,0,1,0,0,1,0,
				1,0,0,1,0,0,1,0,
				1,1,0,1,0,1,1,0,
				1,0,0,1,0,0,1,0,
				1,0,0,1,0,0,1,0,
				1,0,1,1,0,1,0,0,
				1,0,0,1,1,0,1,1,
			],inf),
			\pulselag, Pseg(Pseq([0,0,1],inf),4),
			\shiftfac, Pseg(Pseq([0,100],inf),8),
			\dur, 1/8,
		),
		
	])
)).play;
)


(
SynthDef(\fater, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = FreqShift.ar(sig, [ [1,2,3,4,5,6,7,8]* \shiftfac.kr(0.01)  ]) + sig;
	sig.debug("sig");
	sig = Splay.ar(sig, 1, 1, 0);
	sig.debug("sig");
	sig = sig.mean;
	sig.debug("sig");
	sig = sig * \pulse.kr(1).lag(\pulselag.kr(1.01));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


////////////////////////

~t = 185/4/60; TempoClock.default.tempo = ~t;

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\speed, 0.9,
				\sustain, 0.2,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('vipere/ridecast.flac'),
				\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
				\isRest, Pseq([
					1,0, 0,0,
					1,0, 0,0,
				],inf).coin.not,
				\legato, 1,
				\gain, 1,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1, 1,1, 0,0, 0,0,
					0,0, 1,1, 1,0, 1,0,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
			Pbind(
				\instrument, \simpleacid,
				\note, Pseq([
					0,1,-2,-1,
					-5,0,-3,-1,
				],inf),
				\dur, Prout({ arg ev;
					var ar = Pseq([Prand([1,0.23,0.2],3),2],inf).asStream.nextN(4);
					var ar2 = Pseq([Prand([1,0.23,0.2],3),2],inf).asStream.nextN(4);
					ar.postln;
						1000.do {
							ar2 = Pseq([Prand([1,0.23,0.2],3),2],inf).asStream.nextN(4);
							4.do { arg fac;
								ar.normalizeSum.blend(ar2.normalizeSum, fac/8).do { arg val;
									val = val*2;
									ev = val.yield;
								}
							};
							ar = ar2;
						};
						ev;
				}).loop,
				\isRest, Pseq([
					1,1,1,0,
				],inf).coin.not,
				\amp, 0.1/5,
			),
		]),
		
	])
)).play;
)


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
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
)



~rdn_to_fbstring.(RandDelayNetwork(ProtoDef(\rdn).fxdef)).editorInsert
(

		SynthDef(\tfhl, { arg out=0, gate=1;
			var sig;
			var sig2;
			var si, env = ();
			var si2;
			var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 

			thisThread.randSeed = 72881;

			sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
			si = sig;
			sig = { arg si, env;
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
si = [
			{ arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = (si * 10.rand * \distamp.kr).tanh / 2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
}.value(si, env);
,
			{ arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
}.value(si, env);
,
			{ arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = (si * 10.rand * \distamp.kr).tanh / 2;
		si = [
							{ arg si, env;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
}.value(si, env);
,
							{ arg si, env;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
}.value(si, env);
,
							{ arg si, env;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
}.value(si, env);
,
							{ arg si, env;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
}.value(si, env);

].mean;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
}.value(si, env);
,
			{ arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = [
							{ arg si, env;
				si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
				si = [
											{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
}.value(si, env);
,
											{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
}.value(si, env);
,
											{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
						si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
						si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
}.value(si, env);
,
											{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
						si = [
															{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
}.value(si, env);
,
															{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
}.value(si, env);

].mean;
}.value(si, env);

].mean;
}.value(si, env);
,
							{ arg si, env;
				si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
				si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
}.value(si, env);
,
							{ arg si, env;
				si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
				si = [
											{ arg si, env;
						si = (si * 10.rand * \distamp.kr).tanh / 2;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
}.value(si, env);
,
											{ arg si, env;
						si = (si * 10.rand * \distamp.kr).tanh / 2;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
}.value(si, env);

].mean;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
}.value(si, env);
,
							{ arg si, env;
				si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
}.value(si, env);

].mean;
}.value(si, env);

].mean;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
si = (si * 10.rand * \distamp.kr).tanh / 2;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
si = (si * 10.rand * \distamp.kr).tanh / 2;
si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = [
			{ arg si, env;
		si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
}.value(si, env);
,
			{ arg si, env;
		si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
}.value(si, env);
,
			{ arg si, env;
		si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
}.value(si, env);
,
			{ arg si, env;
		si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
}.value(si, env);

].mean;
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
	'mix', 0.54327130178234,
	'gain', 1.1138893662396,
	'fb', 0.0001,
	'delay', 0.048873746316244,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.0495627369223,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 20000.0,
	'prehpf', 17,
	'lpf', 20000.0,
	'hpf', 20.0,
	'fbdistamp', 0.10970856762123,
	'fbdistmix', 0.97478991596638,
	'postlpf', 20000.0,
	'posthpf', 20.0,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 0.41461695597968,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', 0.0,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.25808615404181,
	'distamp2', 1.1450475699383,
)

		
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
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
		Pmono(\tfhl,
			\inbus, BusDef(\sendbus1),
			\dur, 1/4,
			'wet10', 1.0,
			'mix', 0.54327130178234,
			'gain', 0.2138893662396,
			'fb', 0.000001,
			\fb, ~pmodenv.(Pseq([0,0.00002,0.000000001],inf), 2),
			'delay', 0.018873746316244 * Pseq([
				Pseq([
					1,1/123,
				],2),
				1/321,2
			],inf),
			'delay2', 0.0000001,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.1495627369223,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 20000.0,
			'prehpf', 17,
			'lpf', 20000.0,
			'hpf', 20.0,
			'fbdistamp', 0.10970856762123,
			'fbdistmix', 0.97478991596638,
			'postlpf', 20000.0,
			'posthpf', 20.0,
			'wetamp', 0.18504562572587,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'distamp3', 0.41461695597968,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
			'shift3', 0.0,
			'shiftmix', 0.0,
			'stereo', 0.0,
			'delay3', 0.25808615404181,
			'distamp2', 1.1450475699383,
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono(\tfhl,
			\inbus, BusDef(\sendbus2),
			\dur, 1/4,
			'wet10', 1.0,
			'mix', 1,
			'gain', 10.4138893662396,
			'fb', 0.000001,
			\fb, ~pmodenv.(Pseq([0,0.00002,0.000000001],inf), 2),
			'delay', 0.000000018873746316244 * Pseq([
				Pseq([
					1,1/123,
				],2),
				1/321,2
			],inf),
			'delay2', 0.2000001,
			'delay2', ~pmodenv.(Pseq([0.001,0.2,0.00001,0.0004],inf), 2),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 0.1495627369223,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 20000.0,
			'prehpf', 17,
			'lpf', 20000.0,
			'hpf', 20.0,
			'fbdistamp', 0.10970856762123,
			'fbdistmix', 0.97478991596638,
			'postlpf', 20000.0,
			'posthpf', 2000.0,
			\postpfmix, 1,
			'wetamp', 0.18504562572587,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'distamp3', 0.41461695597968,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
			'shift3', 0.0,
			'shiftmix', 0.0,
			'stereo', 0.0,
			'delay3', 0.25808615404181,
			'distamp2', 1.1450475699383,
		),
		
	])
)).play;
)


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,1,0,1, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
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
		Pmono(\tfhl,
			\inbus, BusDef(\sendbus1),
			\dur, 1/4,
			'wet10', 1.0,
			'mix', 0.54327130178234,
			'gain', 0.2138893662396,
			'fb', 0.000001,
			\fb, ~pmodenv.(Pseq([0,0.00002,0.000000001],inf), 2),
			'delay', 0.018873746316244 * Pseq([
				Pseq([
					1,1/123,
				],2),
				1/321,2
			],inf),
			'delay2', 0.0000001,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.1495627369223,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 20000.0,
			'prehpf', 17,
			'lpf', 20000.0,
			'hpf', 20.0,
			'fbdistamp', 0.10970856762123,
			'fbdistmix', 0.97478991596638,
			'postlpf', 20000.0,
			'posthpf', 20.0,
			'wetamp', 0.18504562572587,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'distamp3', 0.41461695597968,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
			'shift3', 0.0,
			'shiftmix', 0.0,
			'stereo', 0.0,
			'delay3', 0.25808615404181,
			'distamp2', 1.1450475699383,
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus2, \audio),
		),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					1,0,0,1, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\out, BusDef(\sendbus2, \audio),
			)),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/feynman.flac'),
				\dur, 1/3,
				\pos, 1.2 + Pseq([1,0.3,0.1],inf),
				\speed, 1.2,
				\gain, 1,
				\out, BusDef(\sendbus2, \audio),
			),
		Pmono(\tfhl,
			\inbus, BusDef(\sendbus2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 1,
			'gain', 10.4138893662396,
			'fb', 0.000001,
			\fb, ~pmodenv.(Pseq([0,0.00002,0.000000001],inf), 2),
			'delay', 0.01000018873746316244 * Pseq([
				Pseq([
					1,1/123,
				],2),
				1/321,2
			],inf),
			'delay2', 0.2000001,
			'delay2', ~pmodenv.(Pseq([0.000001,0.00002,0.00001,0.02, 0.0004],inf), 2),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 0.1495627369223 * Pseq([1,1,2,1,1,2,1,2],inf),
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 20000.0,
			'prehpf', 17,
			'lpf', 20000.0,
			'hpf', 20.0,
			'fbdistamp', 0.10970856762123,
			'fbdistmix', 0.97478991596638,
			'postlpf', 20000.0,
			'posthpf', 2000.0,
			\postpfmix, 1,
			'wetamp', 0.18504562572587,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'distamp3', 0.41461695597968,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
			'shift3', 0.0,
			'shiftmix', 0.0,
			'stereo', 0.0,
			'delay3', 0.25808615404181,
			'distamp2', 1.1450475699383,
		),
		
	])
)).play;
)
