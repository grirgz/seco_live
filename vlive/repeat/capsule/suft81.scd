~t = 185/2/60; TempoClock.default.tempo = ~t;
~t = 135/2/60; TempoClock.default.tempo = ~t; // to compose

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
					1,0,1,0, 0,0,1,0,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,1,0,
					1,0,0,0, 0,0,0,1,
					1,0,0,1, 0,0,1,0,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,1,0,
					1,0,0,0, 0,0,0,1,
					1,1,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
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
				\kitIndex, 4,
				\isRest, Pseq([
					//0,0,0,0, 1,0,0,0,
					//0,0,0,0, 1,0,0,0,
					//0,0,0,0, 1,1,0,0,
					//0,0,0,0, 1,0,0,1,
			
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,1,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					0,0,1,0, 0,0,1,0,
					1,0,1,1, 1,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/5,
				\dur, 1/8,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,1,0,0,
					0,0,0,0, 1,0,0,1,
			
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 1,0,0,0,
			
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,1,1, 0,0,1,0,
			
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.152,
				\gain, 0.2,
				\dur, 1/8,
			)),
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
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,1,0,
					1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
			),
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
				\kitIndex, 4,
				\isRest, Pseq([
					//0,0,0,0, 1,0,0,0,
					//0,0,0,0, 1,0,0,0,
					//0,0,0,0, 1,1,0,0,
					//0,0,0,0, 1,0,0,1,
			
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,1,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					0,0,1,0, 0,0,1,0,
					1,0,1,1, 1,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/5,
				\dur, 1/8,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,1,0,0,
					0,0,0,0, 1,0,0,1,
			
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 1,0,0,0,
			
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,1,1, 0,0,1,0,
			
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.152,
				\gain, 0.2,
				\dur, 1/8,
			)),
		]),
		Pmono(\rdnring,
			\inbus, BusDef(\sendbus1),
			\dur, 1,
		) <> Pbind(
	'mix', 0.04251074739002,
	'gain', 1,
	'fb', 0.0001,
	'delay', 0.00016538167833957,
	'delay2', 0.13371916345322,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 4.0195378685327,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 4.47619047619048,
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
	])
)).play;
);

~rdn_to_fbstring.(RandDelayNetwork(ProtoDef(\rdn).fxdef)).editorInsert // with outer synthdef and preset pbind
(

	SynthDef(\rdnring, { arg out=0, gate=1;
		var sig;
		var sig2;
		var si, env = ();
		var si2;
		var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 

		thisThread.randSeed = 106608;

		sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
		si = sig;
		sig = { arg si, env;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
			si = [
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
					si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
					si = [
						{ arg si, env;
							si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
						}.value(si, env);
						,
						{ arg si, env;
							si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
						}.value(si, env);
						,
						{ arg si, env;
							si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
						}.value(si, env);
						,
						{ arg si, env;
							si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
						}.value(si, env);

					].mean;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
					si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
				}.value(si, env);

			].mean;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
			si = [
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
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
		//sig2 = HPF.ar(sig, \posthpf.kr(14), \posthprq.kr(0.1));
		//sig2 = LPF.ar(sig2, \postlpf.kr(19900), \postlprq.kr(1));
		//sig = SelectX.ar(\postpfmix.kr(0.0), [sig, sig2]);
		sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
		sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
		sig = sig * \gain.kr(1);
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
		Out.ar(out, sig);

	}).add;

		
Pbind(
	'wet10', 1.0,
	'mix', 0.44251074739002,
	'gain', 1,
	'fb', 0.0001,
	'delay', 0.00016538167833957,
	'delay2', 0.12371916345322,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.0195378685327,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
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

