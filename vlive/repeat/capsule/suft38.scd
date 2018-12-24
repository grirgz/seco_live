
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
