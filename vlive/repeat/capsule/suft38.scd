
ProtoDef(\rdn).edit
1
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
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

	SynthDef(\rdnshot, { arg out=0, gate=1;
		var sig;
		var si, env = ();
		var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 

		thisThread.randSeed = 66853;

		sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
		si = sig;
		sig = { arg si, env;
			si = HPF.ar(si, \hpf.kr(17));
			si = LPF.ar(si, \lpf.kr(19900));
			BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 ); // leave it for random exactitude
			si = [
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = (si * 10.rand * \distamp.kr).tanh / 2;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
					si = [
						{ arg si, env;
							si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
						}.value(si, env);
						,
						{ arg si, env;
							si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
						}.value(si, env);

					].mean;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = (si * 10.rand * \distamp.kr).tanh / 2;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
					si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
				}.value(si, env);

			].mean;
			si = (si * 10.rand * \distamp.kr).tanh / 2;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
			si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
			si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		}.value(si, env);

		sig = Limiter.ar(sig);
		LocalOut.ar(sig);

		//sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(0));
		//sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(0));
			si = HPF.ar(si, \posthpf.kr(17));
			si = LPF.ar(si, \postlpf.kr(19900));
		sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
		sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
		sig = sig * \gain.kr(1);
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
		Out.ar(out, sig);

	}).add;


	Pbind(
		'wet10', 1.0,
		'mix', 0.5,
		'gain', 1,
		'fb', 0.00099281392423591,
		'delay', 0.00013628679593558,
		'delay2', 0.49828635146473,
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 2.1683753109874,
		'pitchlag', 0.17526592085368,
		'pitchmix', 0.87394957983193,
		'prelpf', 17000,
		'prehpf', 17,
		'lpf', 17000,
		'hpf', 17,
		'fbdistamp', 0.65607499380699,
		'fbdistmix', 0.96638655462185,
		'postlpf', 15402.265930714,
		'posthpf', 20.0,
		'wetamp', 1,
		'indelay', 0.04,
		'wet20', 1.0,
		'mamp', 1,
		'delay3', 0.0001,
	)


);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\drumbus, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
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
		Pmono(\rdnshot,
			\inbus, BusDef(\drumbus),
			\dur, 1,
			\addAction, \addToTail,
			\lag, 0.0005,
			'mix', 0.5,
			'gain', 1/4,
			'fb', 0.00009281392423591,
			'delay', 0.12013628679593558,
			'delay2', 0.09828635146473,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 2.1683753109874,
			'pitchlag', 0.17526592085368,
			'pitchmix', 0.87394957983193,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 0.65607499380699,
			'fbdistmix', 0.96638655462185,
			'postlpf', 19402.265930714,
			'posthpf', 20.0,
			'wetamp', 1,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'delay3', 0.0001,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,0,1,2,
			],inf),
			\octave, 3,
			\lpf, 500,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\bassbus, \audio),
		),
		Pmono(\rdnshot,
			\inbus, BusDef(\bassbus),
			\dur, 1,
			\addAction, \addToTail,
			\lag, 0.0005,
			'mix', 1,
			'gain', 1/8,
			'fb', 0.00109281392423591,
			'delay', 0.00000028679593558,
			'delay2', 0.00100035146473,
			'shift', 0.1,
			'shift2', 0.1,
			'distamp', 2.1683753109874,
			'pitchlag', 0.17526592085368,
			'pitchmix', 0.07394957983193,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 0.65607499380699,
			'fbdistmix', 0.96638655462185,
			'postlpf', 19402.265930714,
			'posthpf', 20.0,
			'wetamp', 1,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'delay3', 0.0001,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\drumbus, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
			),
		]),
		Pmono(\rdnshot,
			\inbus, BusDef(\drumbus),
			\dur, 1,
			\addAction, \addToTail,
			\lag, 0.0005,
			'mix', 0.5,
			'gain', 1/4,
			'fb', 0.00009281392423591,
			'delay', 0.12013628679593558,
			'delay2', 0.09828635146473,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 2.1683753109874,
			'pitchlag', 0.17526592085368,
			'pitchmix', 0.87394957983193,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 0.65607499380699,
			'fbdistmix', 0.96638655462185,
			'postlpf', 19402.265930714,
			'posthpf', 20.0,
			'wetamp', 1,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'delay3', 0.0001,
		),
		Pbind(\out, BusDef(\snarebus, \audio)) <>
		Ppar([
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
					0,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					1,0,0,1, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.051,
				\speed, Pseq([
					1,1, 1,1, 1,1,
					1,1, 1,1, 1,1,
					1.1, 1.1,
					1.1, 1.1,
				],inf),
				\gain, 0.015,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,
					0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pmono(\rdnshot,
			\inbus, BusDef(\snarebus),
			\dur, 1,
			\addAction, \addToTail,
			\lag, 0.0005,
			'mix', 0.5,
			'gain', 1/4,
			'fb', 0.00009281392423591,
			'delay', 0.12013628679593558,
			'delay2', 0.09828635146473,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 2.1683753109874,
			'pitchlag', 0.17526592085368,
			'pitchmix', 0.87394957983193,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 97,
			'fbdistamp', 0.65607499380699,
			'fbdistmix', 0.96638655462185,
			'postlpf', 19402.265930714,
			'posthpf', 20.0,
			'wetamp', 1,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'delay3', 0.0001,
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
				\out, BusDef(\hatbus, \audio),
			),
		Pmono(\rdnshot,
			\inbus, BusDef(\hatbus),
			\dur, 1,
			\addAction, \addToTail,
			\lag, 0.0005,
			'mix', 0.5,
			'gain', 1/6,
			'fb', 0.00009281392423591,
			'delay', 0.5000013628679593558,
			'delay2', 0.0000828635146473,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 2.1683753109874,
			'pitchlag', 0.17526592085368,
			'pitchmix', 0.87394957983193,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 97,
			'fbdistamp', 0.65607499380699,
			'fbdistmix', 0.96638655462185,
			'postlpf', 19402.265930714,
			'posthpf', 20.0,
			'wetamp', 1,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'delay3', 0.0001,
		),

		// amp

		Pmono(\kr_amplitude,
			\inbus, BusDef(\snarebus),
			\out, BusDef(\ampkr, \control),
			\ampscale, 100000,
			\ampbias, 0.2,
			\poll, 4,
			\dur, 1,
		),

		// bass

		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,0,1,2,
			],inf),
			\octave, 3,
			\amplag, 1,
			\lpf, 5000,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\bassbus, \audio),
		),
		Pmono(\rdnshot,
			\inbus, BusDef(\bassbus),
			\dur, 1/16,
			\addAction, \addToTail,
			\lag, 0.0005,
			'mix', 1,
			'gain', 1/8,
			'fb', 0.00109281392423591,
			'delay', 0.00000028679593558,
			'delay2', 0.00100035146473,
			'shift', 0.1,
			'shift2', 0.1,
			'distamp', 2.1683753109874,
			'pitchlag', 0.17526592085368,
			'pitchmix', 0.07394957983193,
			'prelpf', 19000,
			'prehpf', 17,
			//'lpf', 19000,
			//'hpf', 1700,
			\hpf, BusDef(\ampkr).asMap,
			\hpf, Pseq([
				10,10,10,10,
				10,10,200,
				100,10,200,
			],inf),
			'fbdistamp', 0.65607499380699,
			'fbdistmix', 0.96638655462185,
			'postlpf', 19402.265930714,
			'posthpf', 20.0,
			'wetamp', 1,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'delay3', 0.0001,
		),

		///////

		Pbind(
			\instrument, \iron,
			\freq, 3200 * [1,1.123,1.32123],
			\fmr, 1/2,
			\legato, 1,
			\diff, 0.0001,
			\lpfr, 2,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\hibus, \audio),
		),
		Pmono(\rdnshot,
			\inbus, BusDef(\hibus),
			\dur, 1/16,
			\addAction, \addToTail,
			\lag, 0.0005,
			'mix', 1,
			'gain', 1/8,
			'fb', 0.00009281392423591,
			'delay', 0.00000028679593558,
			'delay2', 0.00000035146473,
			'shift', 0.1,
			'shift2', 0.1,
			'distamp', 0.1683753109874,
			'pitchlag', 0.17526592085368,
			'pitchmix', 0.07394957983193,
			'prelpf', 19000,
			'prehpf', 17,
			//'lpf', 19000,
			'hpf', 7700,
			'fbdistamp', 0.65607499380699,
			'fbdistmix', 0.96638655462185,
			'postlpf', 19402.265930714,
			'posthpf', 180.0,
			'wetamp', 1,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'delay3', 0.0001,
		),
		
	])
)).play;
)

Pdef(\part).clear;
