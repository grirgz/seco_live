~t = 185/4/60; TempoClock.default.tempo = ~t;

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
			sig = HPF.ar(sig, \posthpf.kr(17));
			sig = LPF.ar(sig, \postlpf.kr(19900));
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
		Pmono(\chorusdist,
			\inbus, BusDef(\drumbus, \audio),
			\freq, 200,
			\distamp, 20,
			\distpostamp, 1/1,
			\fb, 0.404,
			\distmix, 1,
			\delay, 0.00111,
			\modfreq, 4*~t,
			\modamp, 0.0001,
			\hpf, 500,
			\gain, 0.9,
			\dur, 1,
			\amp, 0.1,
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

		// snare

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
				\gain, 0.019,
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

		// hat

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
			//\out, BusDef(\bassmixer, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\bassmixer),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0,
			\sendbus0, BusDef(\sendbus0, \audio, 2),
			\dur, 1,
		),

		///////

		Pbind(
			\instrument, \iron,
			\freq, 3200 * [1,1.123,1.32123],
			\fmr, ~pmodenv.(Pseq([1,2,1,4]/2,inf), 8),
			\legato, 1,
			\diff, ~pmodenv.(Pseq([0.1,0.000002,1,0.001],inf), 3),
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
		Pmono(\chorusdist,
			\inbus, BusDef(\snarebus, \audio),
			\freq, 200,
			\distamp, 20,
			\distpostamp, 1/2,
			\fb, 0.904,
			\distmix, 1,
			\delay, 0.00071,
			\modfreq, 10*~t,
			\modamp, 0.0001,
			\hpf, 500,
			\gain, 0.9,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\snaremixer, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\snaremixer),
			\pregain, 1,
			\postgain, 1,
			\delay, 0.04,
			\send0, 1,
			\sendbus0, BusDef(\bassbus, \audio, 2),
			\dur, 1,
		),

		Pmono(\chorusdist,
			\inbus, BusDef(\hatbus, \audio),
			\freq, 200,
			\distamp, 20,
			\distpostamp, 1/2,
			\fb, 0.104,
			\distmix, 1,
			\delay, 0.00071,
			\modfreq, 1*~t,
			\modamp, 0.0001,
			\hpf, 500,
			\gain, 0.8,
			\dur, 1,
			\amp, 0.1,
		),

		Pmono(\chorusdistlim,
			\inbus, BusDef(\bassmixer, \audio),
			\freq, 200,
			\distamp, 7,
			\distpostamp, 1,
			\fb, 0.704,
			\distmix, 1,
			\delay, 0.00071 * Pseq([
				1,3,2,1,
				1,1/2,1/2,
			],inf),
			\delay, ~pmodenv.(Pseq(1/[1,20,100,4],inf), 8),
			\modfreq, 1*~t * Pseq([
				1,1,1,4,
				4,4,4,4,
				100, 100, 100,
				200, 100, 100,
			],inf),
			\modamp, 0.0101 * Pseq([
				10, 10, 10, 10,
				10, 10, 10, 10,
				1, 1, 1, 1,
				1, 1, 1, 1,
				2, 2, 2, 2,
			],inf),
			\hpf, 500,
			\gain, 0.7,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		
	])
)).play;
)

Pdef(\part).clear;

(
SynthDef(\tok, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * EnvGen.kr(\env.kr( Env([8,1.1/4,1/4],[0.01,0.8]) ), gate));
	sig = RHPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.15));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.04)), gate, doneAction:0);
	sig = sig + WhiteNoise.ar(0.2);
	sig = sig * EnvGen.kr(\adsr2.kr(Env.adsr(0.01,0.1,0.8,0.4,1,-4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
		Pbind(
			\instrument, \iron,
			\note, Pstep(Pseq([
				0,4,8,-1,
			],inf),1/2),
			\octave, 6,
			\env1, Pseq([
				[ Env([1,0.9,1],[0.1,0.8],[1,-1]) ],
				[ Env([0.1,0.9,1],[0.1,0.8],[1,-1]) ],
				[ Env([1,1.2,1],[0.1,0.8],[1,-1]) ],
			],inf),
			\hpf, 400,
			\gain,8,
			\fmr, Pseq([
				1/8,
			],inf),
			\lpfr, 1,
			\rq, 0.7,
			\foldbias, 1.5,
			\foldlevel, 0.0,
			\diff, 0.02 * Pseq([1],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1,1,-2) ],
			],inf),
			\trigenv, 1,
			\fmamp, 1.5,
			\legato, Pseq([
					0.1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			//\out, BusDef(\sendbus2, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \tok,
			\note, Pstep(Pseq([
				0,4,18,-1,
			],inf),1),
			\octave, 6,
			\legato, Pseq([
					0.1,0,
			],inf)/2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
			\distpreamp, 10,
			\isRest, true,
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \pluck,
			\note, Pstep(Pseq([
				0,4,8,-1,
			],inf),1/2),
			\octave, 6,
			\legato, Pseq([
					0.1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
			\isRest, true,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00101099467303085,
			'delay', 0.0011001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 141.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 1700,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1/4
			],inf),
			'posthpf', 17 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
		Pbind(
			\instrument, \iron,
			\note, Pstep(Pseq([
				0,4,8,-1,
			],inf),1/2),
			\octave, 6,
			\env1, Pseq([
				[ Env([1,0.9,1],[0.1,0.8],[1,-1]) ],
				[ Env([0.1,0.9,1],[0.1,0.8],[1,-1]) ],
				[ Env([1,1.2,1],[0.1,0.8],[1,-1]) ],
			],inf),
			\hpf, 400,
			\gain,8,
			\fmr, Pseq([
				1/8,
			],inf),
			\lpfr, 1,
			\rq, 0.7,
			\foldbias, 1.5,
			\foldlevel, 0.0,
			\diff, 0.02 * Pseq([1],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1,1,-2) ],
			],inf),
			\trigenv, 1,
			\fmamp, 1.5,
			\legato, Pseq([
					0.1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			//\out, BusDef(\sendbus2, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \tok,
			\note, Pstep(Pseq([
				0,4,18,-1,
			],inf),1),
			\octave, 6,
			\legato, Pseq([
					0.1,0,
			],inf)/2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
			\distpreamp, 10,
			\isRest, true,
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \pluck,
			\note, Pstep(Pseq([
				0,4,8,-1,
			],inf),1/2),
			\octave, 6,
			\legato, Pseq([
					0.1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
			\isRest, true,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00101099467303085,
			'delay', 0.0011001231 * Pseq([
				12.midiratio,17.midiratio,1,1, 1,1,1,1,
			],inf).stutter(1) * 2,
			'delay2', 0.000000543560101 * 8*8,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 141.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 1700,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1/4
			],inf),
			'posthpf', 17 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
		Pbind(
			\instrument, \iron,
			\note, Pstep(Pseq([
				0,4,8,-1,
			],inf),1/2),
			\octave, 6,
			\env1, Pseq([
				[ Env([1,0.9,1],[0.1,0.8],[1,-1]) ],
				[ Env([0.1,0.9,1],[0.1,0.8],[1,-1]) ],
				[ Env([1,1.2,1],[0.1,0.8],[1,-1]) ],
			],inf),
			\hpf, 400,
			\gain,8,
			\fmr, Pseq([
				1/8,
			],inf),
			\lpfr, 1,
			\rq, 0.7,
			\foldbias, 1.5,
			\foldlevel, 0.0,
			\diff, 0.02 * Pseq([1],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1,1,-2) ],
			],inf),
			\trigenv, 1,
			\fmamp, 1.5,
			\legato, Pseq([
					0.1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \tok,
			\note, Pstep(Pseq([
				0,4,18,-1,
			],inf),1),
			\octave, 6,
			\legato, Pseq([
				//	0.1,0,
				1,0,0,0,
				1,0,1,0,
				1,1,0,0,
				1,0,0,1,
			],inf)/12,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0,
				1,0,1,0,
				1,1,0,0,
				1,0,0,1,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
			\distpreamp, 10,
			\isRest, true,
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00101099467303085,
			'delay', 0.0011001231 * Pseq([
				1,1,1,2, 1,3,2,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 141.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 1700,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1/4
			],inf),
			'posthpf', 17 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \pluck,
			\note, Pstep(Pseq([
				0,4,8,-1,
			],inf),1/2),
			\octave, 6,
			\legato, Pseq([
					0.1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus3, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			'wet10', 1.0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00101099467303085,
			'delay', 0.4111001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 141.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 1700,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1/4
			],inf),
			'posthpf', 517 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
	])
)).play;
)

(
	~pjitter = { arg x;
		Prout({ arg ev;
			x.stutter(2).clump(2).asStream.do({ arg x;
				x.debug("x");
				ev = Pseq([x.first, -1 * x.last]+1).embedInStream
			});
			ev;
		});
   
	};
~pjitter.(Pseq([0,0.1],inf)).asStream.nextN(10)
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
		Pbind(
			\instrument, \iron,
			\note, Pstep(Pseq([
				0,1,1,-1,
			],inf),1/2),
			\octave, 6,
			\env1, Pseq([
				[ Env([1,0.9,1],[0.1,0.8],[1,-1]) ],
				[ Env([0.1,0.9,1],[0.1,0.8],[1,-1]) ],
				[ Env([1,1.2,1],[0.1,0.8],[1,-1]) ],
			],inf),
			\hpf, 400,
			\gain,8,
			\fmr, Pseq([
				1/8,
			],inf),
			\lpfr, 1,
			\rq, 0.7,
			\foldbias, 1.5,
			\foldlevel, 0.0,
			\diff, 0.02 * Pseq([1],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1,1,-2) ],
			],inf),
			\trigenv, 1,
			\fmamp, 1.5,
			\legato, Pseq([
					0.1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \tok,
			\note, Pstep(Pseq([
				0,4,18,-1,
			],inf),1),
			\octave, 6,
			\legato, Pseq([
				//	0.1,0,
				1,0,0,0,
				1,0,1,0,
				1,1,0,0,
				1,0,0,1,
			],inf)/12,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0,
				1,0,1,0,
				1,1,0,0,
				1,0,0,1,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
			\distpreamp, 10,
			\isRest, true,
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00101099467303085,
			'delay', 0.0011001231 * Pseq([
				1,1,1,2, 1,3,2,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 141.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 1700,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1/4
			],inf),
			'posthpf', 17 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \pluck,
			\note, Ptuple([
				Pstep(Pseq([
					5,6,5,9,
					5,5,7,9,
				],inf),1/2),
				Pseq([
					0,1
				],inf).stutter(4),
			]),
			\octave, 6,
			\legato, Pseq([
					0.1,0.1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8 ,
			\dur, 1/8 * ~pjitter.(Pseq([0.4,0.1],inf)),
			\amp, 0.1,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \pluck,
			\note, 
				Pseq([
					9,8
				],inf).stutter(4),
			\octave, 5,
			\legato, Pseq([
					0.1,0.4,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8 * ~pjitter.(Pseq([0.4,0.1],inf)),
			\dur, 1/1 ,
			\amp, 0.1,
			\out, BusDef(\sendbus3, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			'wet10', 1.0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00101099467303085,
			'delay', 0.4111001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 141.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 1700,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1/4
			],inf),
			'posthpf', 517 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
	])
)).play;
)



(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
		Pbind(
			\instrument, \iron,
			\note, Pstep(Pseq([
				0,4,8,-1,
			],inf),1/2),
			\octave, 6,
			\env1, Pseq([
				[ Env([1,0.9,1],[0.1,0.8],[1,-1]) ],
				[ Env([0.1,0.9,1],[0.1,0.8],[1,-1]) ],
				[ Env([1,1.2,1],[0.1,0.8],[1,-1]) ],
			],inf),
			\hpf, 400,
			\gain,8,
			\fmr, Pseq([
				1/8,
			],inf),
			\lpfr, 1,
			\rq, 0.7,
			\foldbias, 1.5,
			\foldlevel, 0.0,
			\diff, 0.02 * Pseq([1],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1,1,-2) ],
			],inf),
			\trigenv, 1,
			\fmamp, 1.5,
			\legato, Pseq([
					0.1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			//\out, BusDef(\sendbus2, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \tok,
			\note, Pstep(Pseq([
				0,4,8,-1,
			],inf),1/2),
			\octave, 6,
			\legato, Pseq([
					0.1,0,
			],inf)/2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
			\distpreamp, 10,
			\isRest, true,
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 0,0,
				1,1, 0,0,
				0,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \pluck,
			\note, Pstep(Pseq([
				0,4,8,-1,
			],inf),1/2),
			\octave, 6,
			\legato, Pseq([
					0.1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
			\isRest, true,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00101099467303085,
			'delay', 0.0001001231 * Pseq([
				5,10,10,10,
				5,10,10,5,10,10,
				100,
				100,
				1/10,
				1/10,
				1/10,
			],inf).stutter(1),
			'delay2', 0.100000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 141.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 1700,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1/2
			],inf),
			'posthpf', 17 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.0101099467303085,
			'delay', 0.0001001231 * Pseq([
				5,10,10,10,
				5,10,10,5,10,10,
				100,
				100,
				1/10,
				1/10,
				1/10,
			],inf).stutter(1),
			'delay2', 0.100000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 141.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 170,
			'lpf', 1700,
			'hpf', 170,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19000 * Pseq([
				1
			],inf),
			'posthpf', 1700 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
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
					0,1,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.051,
				\speed, Pseq([
					1,1, 1,1, 1,1,
					1,1, 1,1, 1,1,
					1.1, 1.1,
					1.1, 1.1,
				],inf),
				\gain, 0.077,
				\dur, 1/8,
			)),
		]),
		Pmono(\rdnshot,
			\inbus, BusDef(\snarebus),
			\dur, 1,
			\addAction, \addToTail,
			\lag, 0.0005,
			'mix', 0.5,
			'gain', 1/4,
			'fb', 0.00009281392423591,
			'delay', 0.00003628679593558,
			'delay2', 0.00028635146473,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 2.1683753109874,
			'pitchlag', 0.17526592085368,
			'pitchmix', 0.87394957983193,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 15,
			'fbdistamp', 7.65607499380699,
			'fbdistmix', 0.96638655462185,
			'postlpf', 19402.265930714,
			'posthpf', 20.0,
			'wetamp', 1,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'delay3', 0.0001,
		),
		Pmono(\chorusdist,
			\inbus, BusDef(\snarebus, \audio),
			\freq, 200,
			\distamp, 20,
			\distpostamp, 1/1,
			\fb, 0.404,
			\distmix, 1,
			\delay, 0.00111,
			\modfreq, 4*~t,
			\modamp, 0.0001,
			\hpf, 500,
			\gain, 0.4,
			\dur, 1,
			\amp, 0.1,
		),


		// hat

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
			\dur, 1/8,
			\addAction, \addToTail,
			\lag, 0.0005,
			'mix', 0.9,
			'gain', 1/1,
			'fb', 0.00009281392423591,
			'delay', 0.0000113628679593558,
			'delay2', 0.010828635146473 * Pseq([
				1,1,1,2,
				1,1,5,1,
				1,5,1,1,
				1,2,1,10,
			],inf),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 0.4683753109874,
			'pitchlag', 0.17526592085368,
			'pitchmix', 0.87394957983193,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 97,
			'fbdistamp', 0.65607499380699,
			'fbdistmix', 0.96638655462185,
			'postlpf', 15402.265930714,
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


/////////////////


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
		Pbind(
			\instrument, \iron,
			\note, Pstep(Pseq([
				0,4,8,-1,
			],inf),1/2),
			\octave, 6,
			\env1, Pseq([
				[ Env([1,0.9,1],[0.1,0.8],[1,-1]) ],
				[ Env([0.1,0.9,1],[0.1,0.8],[1,-1]) ],
				[ Env([1,1.2,1],[0.1,0.8],[1,-1]) ],
			],inf),
			\hpf, 400,
			\gain,8,
			\fmr, Pseq([
				1/8,
			],inf),
			\lpfr, 1,
			\rq, 0.7,
			\foldbias, 1.5,
			\foldlevel, 0.0,
			\diff, 0.02 * Pseq([1],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1,1,-2) ],
			],inf),
			\trigenv, 1,
			\fmamp, 1.5,
			\legato, Pseq([
					0.1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			//\out, BusDef(\sendbus2, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \tok,
			\note, Pstep(Pseq([
				0,4,18,-1,
			],inf),1),
			\octave, 6,
			\legato, Pseq([
					0.1,0,
			],inf)/2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\xsendbus2, \audio),
		),
		//Pbind(
			//\instrument, \snapkickx,
			//\dur, 1/8,
			//\isRest, Pseq([
				//1,0,1,0,
			//],inf).coin.not,
			//\amp, 0.1,
			//\out, BusDef(\xsendbus1, \audio),
			//\distpreamp, 10,
		//),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[4].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\xsendbus1, \audio),
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[934].value,
			\isRest, Pseq([
				//1,0,1,0, 1,0,1,0,
				0,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[349].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.11 * Pseq([
				0.5,0.8,0.5,0.7,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[580].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\xsendbus2, \audio),
		),
		Pbind(
			\instrument, \pluck,
			\note, Pstep(Pseq([
				0,4,8,-1,
			],inf),1/2),
			\octave, 6,
			\legato, Pseq([
					0.1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\xsendbus2, \audio),
			\isRest, true,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\xsendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.95714285714286,
			'gain', 0.20,
			'fb', 0.00101099467303085,
			'delay', 0.0011001231 * Pseq([
				1,2,4,4,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 141.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 1700,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1/4
			],inf),
			'posthpf', 17 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			\posthpf, PmodEnv(Pseq([4000,214,40],1), 8).loop,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\basstrack, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\xsendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.25714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00101099467303085,
			'delay', 0.0000011001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 141.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 1700,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1/4
			],inf),
			'posthpf', 17 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\kicktrack, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.031,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[934].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,0, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);

(
SynthDef(\basicfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod;
	mod = SinOsc.ar(freq * \mratio.kr(1)) * \modAmp.kr(1);
	sig = SinOsc.ar(freq * \cratio.kr(1) + mod);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[4].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],7),
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[934].value,
			\isRest, Pseq([
				//1,0,1,0, 1,0,1,0,
				Pseq([
					0,
				],8*4*1),
				Pseq([
					1,1,
				],8*8*4),
				Pseq([
					0,
				],8*8*2),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[349].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pser([
					0
				],8*8*2),
				Pser([
					1,1,1,1,
				],8*8*2),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.11 * Pseq([
				0.5,0.8,0.5,0.7,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[580].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],7),
					0,1,1,0, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/2,
		),
		
		Pbind(
			\instrument, \tok,
			\note, Pstep(Pseq([
				0,4,18,-1,
			],inf),1),
			\octave, 6,
			\legato, Pseq([
					0.1,0,
			],inf)/2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\xsendbus2, \audio),
		),
		//Pbind(
			//\instrument, \snapkickx,
			//\dur, 1/8,
			//\isRest, Pseq([
				//1,0,1,0,
			//],inf).coin.not,
			//\amp, 0.1,
			//\out, BusDef(\xsendbus1, \audio),
			//\distpreamp, 10,
		//),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\xsendbus2, \audio),
		),
		Pbind(
			\instrument, \pluck,
			\note, Pstep(Pseq([
				0,4,8,-1,
			],inf),1/2),
			\octave, 6,
			\legato, Pseq([
					0.1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\xsendbus2, \audio),
			\isRest, true,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\xsendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.95714285714286,
			'gain', 0.20,
			'fb', 0.00101099467303085,
			'delay', 0.0011001231 * Pseq([
				1,2,4,4,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 141.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 1700,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1/4
			],inf),
			'posthpf', 17 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			\posthpf, PmodEnv(Pseq([4000,214,40],1), 8).loop,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\basstrack0, \audio),
			\isRest, true,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\xsendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.25714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00101099467303085,
			'delay', 0.0000011001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 141.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 1700,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1/4
			],inf),
			'posthpf', 17 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\kicktrack, \audio),
		),
		Pmono(\tracksummer,
			\inbus, BusDef(\basstrack0),
			\inbus2, BusDef(\basstrack0b),
			\addAction, \addToTail,
			\lag, 0.0007,
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0,
			\sendbus0, BusDef(\sendbus0, \audio, 2),
			\out, BusDef(\basstrack, \audio),
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.031,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,-2,4,
				0,-2,0,6,
			],inf),
			\octave, [4,6],
			\lpf, PmodEnv(Pseq([8100,1200],1), 32,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,1.1) ],
			],inf),
			\rq, Pseg(Pseq([0.5,0.3],inf),16),
			\legato, 0.4,
			\envamt, 15,
			\dur, 1/8,
			\amp, 0.1/2,
			\lag, -0.04,
			//\out, BusDef(\basstrack0b, \audio),
			//\out, BusDef(\hic, \audio),
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\fx_freeverb2fil,
			\inbus, BusDef(\hic, \audio),
			\addAction, \addToTail,
			\room, PmodEnv(Pseq([1,2],10), 8).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \basicfm,
			\note, Pseq([
				0,0,-2,4,
				0,-2,0,6,
			],inf),
			\fb, 0.9,
			\modAmp, PmodEnv(Pseq([200,2000],1), 32,\exp).loop,
			\octave, 3,
			\lpf, PmodEnv(Pseq([400,1200],1), 32,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\rq, Pseg(Pseq([0.5,0.3],inf),16),
			\legato, Pseq([
				3,0,0,1,
				3,0,0,1,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsramt, 8,
			\dur, 1/8,
			\amp, 0.1/2,
			//\out, BusDef(\basstrack0b, \audio),
			//\out, BusDef(\hic, \audio),
			\out, BusDef(\basstrack0b, \audio),
		),
	])
)).play;
)


~protordn_to_fbstring.(ProtoDef(\rdn2)).editorInsert
(

SynthDef(\rdn_acidisto, { arg out=0, gate=1;
	// code: 5-BSLK-K6KN
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
	thisThread.randSeed = 662167.0;
	si = sig;
	sig = { arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = (si * 10.rand * \distamp.kr).tanh / 2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
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


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0,1,0.001)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

		
Pbind(
	'wet10', 1.0,
	'mix', 0.85714285714286,
	'gain', 0.21848739495798,
	'fb', 0.0044139963348665,
	'delay', 0.0001,
	'delay2', 0.10195378685327,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 89.038909412967,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 288.86429294546,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
)

		
);



(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[4].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],7),
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[934].value,
			\isRest, Pseq([
				//1,0,1,0, 1,0,1,0,
				Pseq([
					0,
				],8*4*1),
				Pseq([
					1,1,
				],8*8*4),
				Pseq([
					0,
				],8*8*2),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[349].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pser([
					0
				],8*8*2),
				Pser([
					1,1,1,1,
				],8*8*2),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.11 * Pseq([
				0.5,0.8,0.5,0.7,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[580].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],7),
					0,1,1,0, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/2,
		),
		
		Pmono(\tracksummer,
			\inbus, BusDef(\basstrack0),
			\inbus2, BusDef(\basstrack0b),
			\addAction, \addToTail,
			\lag, 0.0005,
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0,
			\sendbus0, BusDef(\sendbus0, \audio, 2),
			\out, BusDef(\basstrack, \audio),
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.031,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,-2,4,
				0,-2,0,6,
			],inf),
			\octave, [4,6],
			\lpf, PmodEnv(Pseq([8100,1200],1), 32,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,1.1) ],
			],inf),
			\rq, Pseg(Pseq([0.5,0.3],inf),16),
			\legato, 0.4,
			\envamt, 15,
			\dur, 1/8,
			\amp, 0.1/2 * Pseq([
				1,1,1,1/4,
			],inf),
			\lag, -0.04,
			//\out, BusDef(\basstrack0b, \audio),
			//\out, BusDef(\hic, \audio),
			\out, BusDef(\hic, \audio),
		),
		Pmono(\rdn_acidisto,
			\inbus, BusDef(\hic, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <> Pbind(
			'wet10', 1.0,
			'mix', 0.85714285714286,
			\mix, 1,
			'gain', 0.21848739495798,
			'fb', 0.0044139963348665,
			//'delay', PmodEnv(Pseq([0.0001,0.72],1), 8,\exp).loop,
			\delay, Pexprand(0.0001,0.71,inf).stutter(32),
			'delay2', PmodEnv(Pseq([0.01001,0.000072],1), 32,\exp).loop,
			//'delay2', 0.000010195378685327,
			'shift', 0.01,
			'shift2', 0.01,
			'distamp', Pwhite(1,24.0,inf).stutter(32),
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 288.86429294546,
			\posthpf, PmodEnv(Pseq([5000,1000,424,200,200],1), 8).loop,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
		Pbind(
			\instrument, \basicfm,
			\note, Pseq([
				0,0,-2,4,
				0,-2,0,6,
			],inf),
			\fb, 0.9,
			\modAmp, PmodEnv(Pseq([200,2000],1), 32,\exp).loop,
			\octave, 3,
			\lpf, PmodEnv(Pseq([400,1200],1), 32,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\rq, Pseg(Pseq([0.5,0.3],inf),16),
			\legato, Pseq([
				3,0,0,1,
				3,0,0,1,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsramt, 8,
			\dur, 1/8,
			\amp, 0.1/2,
			//\out, BusDef(\basstrack0b, \audio),
			//\out, BusDef(\hic, \audio),
			\out, BusDef(\basstrack0b, \audio),
		),
	])
)).play;
)


(
SynthDef(\tekick, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1|
	var env0, env1, env1m;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sig;
	var env2, env3;

	//freqpan = [-1,0,1] * freqpan;
	env0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.005, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([210, 62, 59], [0.045, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	
	sig = LFPulse.ar(env1 * freqpan, 0, 0.5, 1, -0.5);
	sig = sig + WhiteNoise.ar(1);
	sig = LPF.ar(sig, env1*fratio);
	sig = sig + SinOsc.ar(env1, 0.5);
	sig = LPF.ar(sig, \lpf.kr(2000));
	
	//sig = sig * 1.2;
	//sig = sig.clip2(1);
	env3 = EnvGen.kr(Env([1,2,0.01],[0.1,0.8]), 1);
	sig4 = sig * \distamp.kr(3) * env3;
	sig1 = sig4.clip2(1);
	sig2 = sig4.distort(1);
	sig3 = sig4.tanh(1);
	env2 = EnvGen.kr(Env([0,1,0],[0.1,0.1]), 1);
	sig5 = (SelectX.ar(\distmix.kr(0)*2, [sig1, sig2, sig3]) * \distamt.kr(0.1) * env2);
	sig5 = HPF.ar(sig5, 50);
	sig = sig + sig5;

	sig = sig * env0;
	sig = Pan2.ar(sig, pan, amp);
	
	OffsetOut.ar(out, sig);
}, metadata:(specs:(
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).add;
)


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \tekick,
			\fratio, 1.5,
			\timeScale, 1.0,
			\knote, Pseq([
				31,35
			],inf).midicps.stutter(16),
			\env1, Pfunc({ arg ev;
				[ Env.new([400, ev[\knote],ev[\knote]], [0.025, 0.29], [-4, -5]) ]
			}),
			\env0, [ Env.new([0, 1, 0.5, 0], [0.005, 0.16, 00.2], [-4, -2, -4]) ],
			\lpf, 2000.0,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \tekick,
			\fratio, 1.5,
			\timeScale, 1.0,
			\knote, Pseq([
				31,35
			],inf).midicps.stutter(16),
			\env1, Pfunc({ arg ev;
				[ Env.new([400, ev[\knote],ev[\knote]], [0.025, 0.29], [-4, -5]) ]
			}),
			\env0, [ Env.new([0, 1, 0.5, 0], [0.005, 0.16, 00.2], [-4, -2, -4]) ],
			\lpf, 2000.0,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\kick, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kick),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\kicktrack, \audio, 2),
			\send1, 1,
			\sendbus1, BusDef(\sendbus1, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.051,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[4].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],7),
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[934].value,
			\isRest, Pseq([
				//1,0,1,0, 1,0,1,0,
				Pseq([
					0,
				],8*4*1),
				Pseq([
					1,1,
				],8*8*4),
				Pseq([
					0,
				],8*8*2),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[349].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pser([
					0
				],8*8*2),
				Pser([
					1,1,1,1,
				],8*8*2),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.11 * Pseq([
				0.5,0.8,0.5,0.7,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[580].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],7),
					0,1,1,0, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/2,
		),
		
		Pmono(\tracksummer,
			\inbus, BusDef(\basstrack0),
			\inbus2, BusDef(\basstrack0b),
			\addAction, \addToTail,
			\lag, 0.0005,
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0,
			\sendbus0, BusDef(\sendbus0, \audio, 2),
			\out, BusDef(\basstrack, \audio),
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.031,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,-2,4,
				0,-2,0,6,
			],inf),
			\octave, [4,6],
			\lpf, PmodEnv(Pseq([8100,1200],1), 32,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,1.1) ],
			],inf),
			\rq, Pseg(Pseq([0.5,0.3],inf),16),
			\legato, 0.4,
			\envamt, 15,
			\dur, 1/8,
			\amp, 0.1/2 * Pseq([
				1,1,1,1/4,
			],inf),
			\lag, -0.04,
			//\out, BusDef(\basstrack0b, \audio),
			//\out, BusDef(\hic, \audio),
			//\out, BusDef(\hic, \audio),
			\out, BusDef(\sendbus3, \audio),
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\hic, \audio),
			\out, BusDef(\hic2, \audio),
			\addAction, \addToTail,
			\size, 0.1,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\rdn_acidisto,
			\inbus, BusDef(\hic2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <> Pbind(
			'wet10', 1.0,
			'mix', 0.85714285714286,
			\mix, 1,
			'gain', 0.21848739495798,
			'fb', 0.0044139963348665,
			//'delay', PmodEnv(Pseq([0.0001,0.72],1), 8,\exp).loop,
			\delay, Pexprand(0.0001,0.71,inf).stutter(32),
			\delay, 0.00001,
			'delay2', PmodEnv(Pseq([0.00011,0.000072],1), 32,\exp).loop,
			//'delay2', 0.000010195378685327,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', Pwhite(1,24.0,inf).stutter(32),
			'distamp', 4,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 288.86429294546,
			\posthpf, PmodEnv(Pseq([5000,1000,424,200,200],1), 8).loop,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
		Pbind(
			\instrument, \basicfm,
			\note, Pseq([
				0,0,-2,4,
				0,-2,0,6,
			],inf),
			\fb, 0.9,
			\modAmp, PmodEnv(Pseq([200,2000],1), 32,\exp).loop,
			\octave, 3,
			\lpf, PmodEnv(Pseq([400,1200],1), 32,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\rq, Pseg(Pseq([0.5,0.3],inf),16),
			\legato, Pseq([
				3,0,0,1,
				3,0,0,1,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsramt, 8,
			\dur, 1/8,
			\amp, 0.1/2,
			//\out, BusDef(\basstrack0b, \audio),
			//\out, BusDef(\hic, \audio),
			\out, BusDef(\basstrack0b, \audio),
		),
	])
)).play;
)

(
SynthDef(\varsawbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	freq = freq * \freqfac.kr(1);
	sig = VarSaw.ar(freq * [1,1.001], width: SinOsc.ar(1/2,pi/2) );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = LPF.ar(sig, \lpf.kr(20000));
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[4].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],7),
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[934].value,
			\isRest, Pseq([
				//1,0,1,0, 1,0,1,0,
				Pseq([
					0,
				],8*4*1),
				Pseq([
					1,1,
				],8*8*4),
				Pseq([
					0,
				],8*8*2),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[349].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pser([
					0
				],8*8*2),
				Pser([
					1,1,1,1,
				],8*8*2),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.11 * Pseq([
				0.5,0.8,0.5,0.7,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[580].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],7),
					0,1,1,0, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/2,
		),
		
		Pmono(\tracksummer,
			\inbus, BusDef(\basstrack0),
			\inbus2, BusDef(\basstrack0b),
			\addAction, \addToTail,
			\lag, 0.0007,
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0,
			\sendbus0, BusDef(\sendbus0, \audio, 2),
			\out, BusDef(\basstrack, \audio),
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.031,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,-2,4,
				0,-2,0,6,
			],inf),
			\octave, [4,6],
			\lpf, PmodEnv(Pseq([8100,1200],1), 32,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,1.1) ],
			],inf),
			\rq, Pseg(Pseq([0.5,0.3],inf),16),
			\legato, 0.4,
			\envamt, 15,
			\dur, 1/8,
			\amp, 0.1/2 * Pseq([
				1,1,1,1/4,
			],inf),
			\lag, -0.04,
			//\out, BusDef(\basstrack0b, \audio),
			//\out, BusDef(\hic, \audio),
			\out, BusDef(\hic, \audio),
			//\out, BusDef(\sendbus3, \audio),
		),
		//Pmono(\fx_greyhole,
			//\inbus, BusDef(\hic, \audio),
			//\out, BusDef(\hic2, \audio),
			//\addAction, \addToTail,
			//\size, 0.1,
			//\lag, 0.0009,
			//\dur, 1,
		//),
		Pmono(\rdn_acidisto,
			\inbus, BusDef(\hic, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <> Pbind(
			'wet10', 1.0,
			'mix', 0.85714285714286,
			\mix, 1,
			'gain', 0.21848739495798,
			'fb', 0.0044139963348665,
			//'delay', PmodEnv(Pseq([0.0001,0.72],1), 8,\exp).loop,
			\delay, Pexprand(0.0001,0.71,inf).stutter(32),
			\delay, 0.00001,
			'delay2', PmodEnv(Pseq([0.00011,0.00072],1), 32,\exp).loop,
			//'delay2', 0.000010195378685327,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', Pwhite(1,24.0,inf).stutter(32),
			'distamp', 4,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 288.86429294546,
			\posthpf, PmodEnv(Pseq([5000,1000,424,200,200],1), 8).loop,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
		Pmono(\rdnshot,
			\inbus, BusDef(\hic),
			\dur, 1,
			\addAction, \addToTail,
			\lag, 0.0005,
			'mix', 1,
			'gain', 1/4,
			'fb', 0.00009281392423591,
			'delay', 0.22013628679593558,
			'delay2', 0.79828635146473,
			'delay2', PmodEnv(Pseq([0.1,1],1), 32,\exp).loop,
			'shift', 0.0,
			'shift2', 0.01,
			'distamp', 1.1683753109874,
			'pitchlag', 0.17526592085368,
			'pitchmix', 0.87394957983193,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 0.65607499380699,
			'fbdistmix', 0.96638655462185,
			'postlpf', 10402.265930714,
			'posthpf', 5000.0,
			\postlpf, PmodEnv(Pseq([14000,3200,11000],1), 8,\exp).loop,
			\posthpf, PmodEnv(Pseq([8000,2200,3000],1), 8,\exp).loop,
			'wetamp', 1,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'delay3', 0.0001,
		),
		Pbind(
			\instrument, \varsawbass,
			\note, Pseq([
				Pseq([
					0,0,0,0,
					0,0,6,0,
					0,0,0,0,
					0,0,0,6,
				],inf).stutter(2),
				4,0,-2,4,
				6,-2,0,6,
			],inf),
			\octave, 3,
			\lpf, PmodEnv(Pseq([2400,7200],1), 32,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\legato, Pseq([
				Pser([
					2,0,2,0, 2,0,2,0,
					1,1,1,1, 2,0,2,0,
					2,0,2,0, 2,0,2,0,
					2,0,1,1, 1,1,2,0,

					2,0,2,0, 2,0,2,0,
					2,0,2,0, 2,0,1,1,
					2,0,2,0, 2,0,2,0,
					2,0,1,1, 1,1,2,0,
				],8*7),
				0,0,0,0, 0,0,0,0,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/2,
			//\out, BusDef(\basstrack0b, \audio),
			//\out, BusDef(\hic, \audio),
			//\out, BusDef(\basstrack0b, \audio),
			\out, BusDef(\bass, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\bass),
			\pregain, 1,
			\postgain, 1,
			\addAction, \addToTail,
			\lag, 0.0005,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\bassfx, \audio, 2),
			\dur, 1,
		),
		Pmono(\rdnshot,
			\inbus, BusDef(\bassfx, \audio, 2),
			\out, BusDef(\basstrack0b, \audio),
			\dur, 1,
			\addAction, \addToTail,
			\lag, 0.0006,
			'mix', 1,
			'gain', 1/4,
			'fb', 0.00009281392423591,
			'delay', 0.00022013628679593558,
			'delay2', 0.11079828635146473,
			'delay2', PmodEnv(Pseq([0.1,1],1), 32,\exp).loop,
			'shift', 0.0,
			//'shift2', 0.0+ Pseq([0,0,0,0.1, 0,0,0.2,1],inf),
			//'shift2', 0.0+ Pseq([8,0,1,0, 4,0,1,0],inf),
			'distamp', 0.2683753109874 * Pseg(Pseq([1,14],1),32).loop,
			'pitchlag', 0.17526592085368,
			'pitchmix', 0,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 0.65607499380699,
			'fbdistmix', 0.96638655462185,
			//'postlpf', 10402.265930714,
			//'posthpf', 5000.0,
			\postlpf, PmodEnv(Pseq([8400,3200,11100],1), 8,\exp).loop,
			\posthpf, PmodEnv(Pseq([880,220,1300],1), 8,\exp).loop,
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
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[4].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],7),
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[934].value,
			\isRest, Pseq([
				//1,0,1,0, 1,0,1,0,
				Pseq([
					0,
				],8*4*1),
				Pseq([
					1,1,
				],8*8*4),
				Pseq([
					0,
				],8*8*2),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[349].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pser([
					0
				],8*8*2),
				Pser([
					1,1,1,1,
				],8*8*2),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.11 * Pseq([
				0.5,0.8,0.5,0.7,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[580].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],7),
					0,1,1,0, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/2,
		),
		
		Pmono(\tracksummer,
			\inbus, BusDef(\basstrack0),
			\inbus2, BusDef(\basstrack0b),
			\addAction, \addToTail,
			\lag, 0.0007,
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0,
			\sendbus0, BusDef(\sendbus0, \audio, 2),
			\out, BusDef(\basstrack, \audio),
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.031,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pbind( // piano
			\instrument, \sh101,
			\note, Pseq([
				0,0,-2,4,
				0,-2,0,6,
			],inf),
			\octave, [4,6],
			\lpf, PmodEnv(Pseq([8100,1200],1), 32,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,1.1) ],
			],inf),
			\rq, Pseg(Pseq([0.5,0.3],inf),16),
			\legato, 0.4,
			\envamt, 15,
			\dur, 1/8,
			\amp, 0.1/2 * Pseq([
				1,1,1,1/4,
			],inf),
			\lag, -0.04,
			//\out, BusDef(\basstrack0b, \audio),
			//\out, BusDef(\hic, \audio),
			\out, BusDef(\hic, \audio),
			//\out, BusDef(\sendbus3, \audio),
		),
		//Pmono(\fx_greyhole,
			//\inbus, BusDef(\hic, \audio),
			//\out, BusDef(\hic2, \audio),
			//\addAction, \addToTail,
			//\size, 0.1,
			//\lag, 0.0009,
			//\dur, 1,
		//),
		Pmono(\rdn_acidisto,
			\inbus, BusDef(\hic, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <> Pbind(
			'wet10', 1.0,
			'mix', 0.85714285714286,
			\mix, 1,
			'gain', 0.21848739495798,
			'fb', 0.0044139963348665,
			//'delay', PmodEnv(Pseq([0.0001,0.72],1), 8,\exp).loop,
			\delay, Pexprand(0.0001,0.71,inf).stutter(32),
			\delay, 0.00001,
			'delay2', PmodEnv(Pseq([0.00011,0.00072],1), 32,\exp).loop,
			//'delay2', 0.000010195378685327,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', Pwhite(1,24.0,inf).stutter(32),
			'distamp', 4,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 288.86429294546,
			\posthpf, PmodEnv(Pseq([5000,1000,424,200,200],1), 8).loop,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
		Pmono(\rdnshot,
			\inbus, BusDef(\hic),
			\dur, 1,
			\addAction, \addToTail,
			\lag, 0.0005,
			'mix', 1,
			'gain', 1/4,
			'fb', 0.00009281392423591,
			'delay', 0.22013628679593558,
			'delay2', 0.79828635146473,
			'delay2', PmodEnv(Pseq([0.1,1],1), 32,\exp).loop,
			'shift', 0.0,
			'shift2', 0.01,
			'distamp', 1.1683753109874,
			'pitchlag', 0.17526592085368,
			'pitchmix', 0.87394957983193,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 0.65607499380699,
			'fbdistmix', 0.96638655462185,
			'postlpf', 10402.265930714,
			'posthpf', 5000.0,
			\postlpf, PmodEnv(Pseq([14000,3200,11000],1), 8,\exp).loop,
			\posthpf, PmodEnv(Pseq([8000,2200,3000],1), 8,\exp).loop,
			'wetamp', 1,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'delay3', 0.0001,
		),
		Pbind( // bass
			\instrument, \varsawbass,
			\note, Pseq([
				Pseq([
					0,0,0,0,
					0,0,6,0,
					0,0,0,0,
					0,0,0,6,
				],inf).stutter(2),
				4,0,-2,4,
				6,-2,0,6,
			],inf),
			\octave, 3,
			\lpf, PmodEnv(Pseq([2400,7200],1), 32,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\legato, Pseq([
				Pser([
					4,0,0,0, 4,0,0,0,
					4,0,0,0, 4,0,0,0,
					4,0,0,0, 4,0,0,0,
					3,0,0,3, 0,0,2,0,
					3,0,0,3, 0,0,2,0,
					3,0,0,3, 0,0,2,0,
					4,0,0,0, 4,0,0,0,
					2,0,1,1, 4,0,0,0,
					4,0,0,0, 4,0,0,0,
					4,0,0,0, 3,0,0,1,
				],8*14),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8/2,
			\amp, 0.1/2,
			//\out, BusDef(\basstrack0b, \audio),
			//\out, BusDef(\hic, \audio),
			//\out, BusDef(\basstrack0b, \audio),
			\out, BusDef(\bass, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\bass),
			\pregain, 1,
			\postgain, 1,
			\addAction, \addToTail,
			\lag, 0.0005,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\bassfx, \audio, 2),
			\dur, 1,
		),
		Pmono(\rdnshot,
			\inbus, BusDef(\bassfx, \audio, 2),
			\out, BusDef(\basstrack0b, \audio),
			\dur, 1,
			\addAction, \addToTail,
			\lag, 0.0006,
			'mix', 1,
			'gain', 1/4,
			'fb', 0.00009281392423591,
			'delay', 0.00022013628679593558,
			'delay2', 0.11079828635146473,
			'delay2', PmodEnv(Pseq([0.1,1],1), 32,\exp).loop,
			'shift', 0.0,
			//'shift2', 0.0+ Pseq([0,0,0,0.1, 0,0,0.2,1],inf),
			//'shift2', 0.0+ Pseq([8,0,1,0, 4,0,1,0],inf),
			'distamp', 0.2683753109874 * Pseg(Pseq([1,14],1),32).loop,
			'pitchlag', 0.17526592085368,
			'pitchmix', 0,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 0.65607499380699,
			'fbdistmix', 0.96638655462185,
			//'postlpf', 10402.265930714,
			//'posthpf', 5000.0,
			\postlpf, PmodEnv(Pseq([8400,3200,11100],1), 8,\exp).loop,
			\posthpf, PmodEnv(Pseq([880,220,1300],1), 8,\exp).loop,
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
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[4].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],7),
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[934].value,
			\isRest, Pseq([
				//1,0,1,0, 1,0,1,0,
				Pseq([
					0,
				],8*4*1),
				Pseq([
					1,1,
				],8*8*4),
				Pseq([
					0,
				],8*8*2),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[349].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pser([
					0
				],8*8*2),
				Pser([
					1,1,1,1,
				],8*8*2),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.11 * Pseq([
				0.5,0.8,0.5,0.7,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[580].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],7),
					0,1,1,0, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/2,
		),
		
		Pmono(\tracksummer,
			\inbus, BusDef(\basstrack0),
			\inbus2, BusDef(\basstrack0b),
			\addAction, \addToTail,
			\lag, 0.0007,
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0,
			\sendbus0, BusDef(\sendbus0, \audio, 2),
			\out, BusDef(\basstrack, \audio),
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.031,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pbind( // piano
			\instrument, \sh101,
			\note, Pseq([
				0,0,-2,4,
				0,-2,0,6,
			],inf),
			\octave, 6,
			\lpf, PmodEnv(Pseq([100,1200],1), 32,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,1.1) ],
			],inf),
			\rq, Pseg(Pseq([0.5,0.3],inf),16),
			\legato, 0.4,
			\envamt, 5,
			\dur, 1/8,
			\amp, 0.1/2 * Pseq([
				1,1,1,1/2,
			],inf),
			//\lag, -0.04,
			//\out, BusDef(\basstrack0b, \audio),
			//\out, BusDef(\hic, \audio),
			\out, BusDef(\hic, \audio),
			//\out, BusDef(\sendbus3, \audio),
		),
		Pmono(\fx_freeverb2fil,
			\inbus, BusDef(\hic, \audio),
			\addAction, \addToTail,
			\room, 2,
			\mix, PmodEnv(Pseq([1,0,0],1), 16).loop,
			\hpf, PmodEnv(Pseq([1000,24],1), 32).loop,
			\lpf, PmodEnv(Pseq([4001,20000],1), 32).loop,
			\lag, 0.0009,
			\dur, 1,
		),

		Pbind( // bass
			\instrument, \varsawbass,
			\note, Pseq([
				Pseq([
					0,0,0,0,
					0,0,-2,-2,
					0,0,0,0,
					0,0,0,6,
				],inf).stutter(2),
				4,0,-2,4,
				6,-2,0,6,
			],inf),
			\octave, 3,
			\lpf, PmodEnv(Pseq([2400,7200],1), 32,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\legato, Pseq([
				Pser([
					4,0,0,0, 4,0,0,0,
					3,0,0,3, 0,0,2,0,
					4,0,0,0, 4,0,0,0,
					4,0,0,0, 4,0,0,0,

					4,0,0,0, 4,0,0,0,
					2,0,1,1, 4,0,0,0,
					4,0,0,0, 4,0,0,0,
					4,0,0,0, 3,0,0,1,

					4,0,0,0, 4,0,0,0,
					3,0,0,1, 2,0,2,0,
					4,0,0,0, 4,0,0,0,
					4,0,0,0, 4,0,0,0,

					4,0,0,0, 4,0,0,0,
					3,0,0,1, 2,0,2,0,
					3,0,0,3, 0,0,2,0,
					2,0,1,1, 1,0,2,0,

				],8*14),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8/2,
			\amp, 0.1/2,
			//\out, BusDef(\basstrack0b, \audio),
			//\out, BusDef(\hic, \audio),
			//\out, BusDef(\basstrack0b, \audio),
			\out, BusDef(\bass, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\bass),
			\pregain, 1,
			\postgain, 1,
			\addAction, \addToTail,
			\lag, 0.0005,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\bassfx, \audio, 2),
			\dur, 1,
		),
		Pmono(\rdnshot,
			\inbus, BusDef(\bassfx, \audio, 2),
			\out, BusDef(\basstrack0b, \audio),
			\dur, 1,
			\addAction, \addToTail,
			\lag, 0.0006,
			'mix', 1,
			'gain', 1/4,
			'fb', 0.00009281392423591,
			'delay', 0.00022013628679593558,
			'delay2', 0.00011079828635146473,
			//'delay2', PmodEnv(Pseq([0.1,1],1), 32,\exp).loop,
			'shift', 0.0,
			//'shift2', 0.0+ Pseq([0,0,0,0.1, 0,0,0.2,1],inf),
			//'shift2', 0.0+ Pseq([8,0,1,0, 4,0,1,0],inf),
			'distamp', 0.2683753109874 * Pseg(Pseq([1,14],1),32).loop,
			'pitchlag', 0.17526592085368,
			'pitchmix', 0,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 0.65607499380699,
			'fbdistmix', 0.96638655462185,
			//'postlpf', 10402.265930714,
			//'posthpf', 5000.0,
			\postlpf, PmodEnv(Pseq([8400,3200,11100],1), 8,\exp).loop,
			\posthpf, PmodEnv(Pseq([4880,220,1300],1), 8,\exp).loop,
			'wetamp', 1,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'delay3', 0.0001,
		),

		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[ 0,6 ],
				[ 0,6,13, ],
				[ 0,6 ],
				[ 0,6,12, ],

				[ 0,6 ],
				[ 0,6,13, ],
				[ 0,6 ],
				[ 0,7,12, ],
			],inf),
			\octave, [5,6],
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\pad, \audio),
		),
		Pmono(\fx_freeverb2fil,
			\inbus, BusDef(\pad, \audio),
			\addAction, \addToTail,
			\delay, PmodEnv(Pseq([0.001,0.12],1), 32,\exp).loop,
			\wetfmix, 1,
			\room, 2,
			\wetlpf, 17100,
			\wethpf, 1100,
			\fmix, 1,
			\lpf, 20000,
			\hpf, PmodEnv(Pseq([1000,20],1), 32,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
)


(
SynthDef(\smploop, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, speed=1, pos=0, bufnum, loop=1;
	var sig;
	var trigger = Impulse.ar(freq);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:2, loop: loop);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\smplooprlpf, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, speed=1, pos=0, bufnum, loop=1;
	var sig;
	var trigger = Impulse.ar(freq);
	var lpenv, lpfreq;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:2, loop: loop);
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.2)), gate, doneAction:0) * \lpadsramt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	sig = RLPF.ar(sig, ( \lpf.kr(330) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \smploop,
			\bufnum, BufDef('voices/feynman.flac'),
			\note, Pseq([
				0,3,4,5,
			],inf),
			\pos, 0.8,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \smplooprlpf,
			\bufnum, BufDef('voices/feynman.flac'),
			\note, Pseq([
				0,3,4,5,
			],inf),
			\octave, 3,
			\speed, 1/2,
			\pos, Pseg(Pseq([0.1,0.101],inf),64),
			\rq, 0.3,
			\lpadsramt, 10,
			\lpf, Pseg(Pseq([121,1700],1), 8).loop,
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[4].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],7),
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.031,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\sideout, BusDef(\sendbus1, \audio),
			\dur, 1,
		),
		Pbind(
			\instrument, \smplooprlpf,
			\bufnum, BufDef('voices/feynman.flac'),
			\note, Pseq([
				0,0,3,0,
				-4,4,3,-2,
			],inf),
			\octave, 3,
			\speed, 1/2,
			\pos, Pseg(Pseq([0.1,0.101],inf),64),
			\rq, 0.3,
			\lpadsramt, 10,
			\lpf, Pseg(Pseq([121,1700],1), 8).loop,
			\dur, 1/8,
			\amp, 0.1/3,
			\out, BusDef(\basstrack, \audio),
		),
	])
)).play;
);


~protordn_to_fbstring.(ProtoDef(\rdn)).editorInsert
(

SynthDef(\rdn_distkick, { arg out=0, gate=1;
	// code: 5-CRQB-9H6P
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
	thisThread.randSeed = 312537.0;
	si = sig;
	sig = { arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = (si * 10.rand * \distamp.kr).tanh / 2;
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
		si = [
			{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = (si * 10.rand * \distamp.kr).tanh / 2;
			}.value(si, env);
			,
			{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			}.value(si, env);
			,
			{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			}.value(si, env);
			,
			{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
				si = [
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
						si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
						si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
						si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
						si = [
							{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
							}.value(si, env);
							,
							{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
							}.value(si, env);

						].mean;
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
						si = (si * 10.rand * \distamp.kr).tanh / 2;
						si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
					}.value(si, env);

				].mean;
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


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0,1,0.001)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

		
Pbind(
	'wet10', 1.0,
	'mix', 0.17647058823529,
	'gain', 0.7436974789916,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0010195378685327,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 20.86064493472,
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
	'wetamp', 0.46579739809918,
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

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[4].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pser([
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,1, 1,0,1,0,
					1,0,0,0, 1,0,0,1,
				],8*15),
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.1,
			\lag, -0.04,
			\out, BusDef(\kick, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kick),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 1,
			\delay, 0.04,
			\sendbus0, BusDef(\sendkick, \audio, 2),
			\dur, 1,
		),
		Pmono(\rdn_distkick,
			\inbus, BusDef(\sendkick, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1/4,
		) <> Pbind(
			'wet10', 1.0,
			'mix', 0.3,
			'gain', 0.3436974789916,
			'fb', 0.0001,
			'delay', 0.0001,
			'delay2', 0.0010195378685327 * Pseq([
				1,1,1,1, 1,4,4,8,
			],inf).stutter(2),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 0.86064493472,
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
			'wetamp', 0.46579739809918,
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
