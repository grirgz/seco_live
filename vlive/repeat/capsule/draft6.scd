(
SynthDef(\desapat1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	//env3 = \env3.kr(4000);
	env3 = EnvGen.kr(Env([5000,4002,1]+\efreq.kr(0),[0.1,0.8]*5), 1, \ts0.kr(1));
	freq = EnvGen.kr(Env([1000,200,500,100]+env3,[0.1,0.8,0.1]*5), Impulse.kr(1/1*~t), timeScale: \ts1.kr(1));
	env1 = EnvGen.kr(Env([1,2,1.5],[0.8,0.8]*5), Impulse.kr(1/8*~t), timeScale: \ts2.kr(1) );
	env4 = EnvGen.kr(Env([0,0,0.1,1.5,10],[0.1,0.1,1.8,1]*5), Impulse.kr(1/8*~t), timeScale: \ts3.kr(1) );
	sig = LFSaw.ar(freq * [1,1.23,1.001,1*( env1/100 )]).sum;
	sig = sig * ( 1 + ( LFSaw.ar(freq+( env4*40 ) * [1,1.2,1.34,1*( env1/110 )]).sum * 1 ));
	sig = CombL.ar(sig, 0.1, 1/( freq * [1,1.2] *env1 ), 0 + (sig * env4)).sum + sig/10;
	env2 = \env2.kr(1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), env2, doneAction:0);
	sig = Limiter.ar(sig);

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)
(

	// intro
	~master.();
	Pdef(\part, Pdef(\perc_intro,
		Pbind(\out, BusDef(\sendbus1))<>
		Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					Pseq([
						1,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,0,
					],2),
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
					],3),
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.48,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.01,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],3),
					0,0,0,0, 0,0,0,0,
					0,1,0,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					Pseq([
						1,0,1,0, 1,0,1,0, 1,0,1,1, 1,0,1,0,
						1,1,0,1, 1,0,1,0, 1,0,1,1, 1,0,1,0,
					],2),
					Pseq([
						1,1,1,1, 1,1,1,1, 1,0,1,1, 1,1,1,0,
						1,1,1,1, 1,0,0,0, 1,0,0,0, 1,0,1,1,
					],2),
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),

				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),

		])
	)).play;

);

(

	// intro2
	~master.();
	Pdef(\part, Pdef(\perc_intro2,
		Pbind(\out, BusDef(\sendbus1))<>
		Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					Pseq([
						1,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,0,
					],2),
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkick2,
				\isRest, Pseq([
					Pseq([
						0,0,0,1, 0,0,1,0,
						0,1,0,0, 0,0,0,1,
						0,0,0,1, 0,0,1,1,
						0,1,0,0, 0,0,0,0,
					],inf),
					Pseq([
						1,0,1,0, 0,0,0,0,
						1,0,1,0, 0,0,0,0,
						1,0,0,0, 0,0,1,0,
						1,1,0,0, 0,0,0,0,
					],1),


					1,0,0,1, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					1,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,1,

						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,1,0, 1,0,0,1,
					],3),
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.48,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,0,0, 0,0,0,0,
					],8*8),
					0,0,1,0, 0,0,0,0,
					0,1,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					Pseq([
						1,0,1,0, 1,0,1,0, 1,0,1,1, 1,1,1,0,
						1,0,1,0, 1,1,1,0, 1,0,1,0, 1,0,1,1,
					],2),
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),

				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),
			Pbind(
				\instrument, \phycymbal,
				\isRest, Pseq([
					//Pseq([
						//0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					//],2),
					Pseq([
						0,0,1,0, 0,0,1,1, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,1, 0,0,0,0, 0,0,0,0,
						0,0,1,0, 1,0,0,1, 0,0,1,0, 1,0,0,0,
						1,0,1,1, 1,0,1,0, 0,0,0,0, 0,0,0,0,
					],1),
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\sustain, Pseq([0.01,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.5,Pser([
						0.04,
					],15),
					0.05,Pser([
						0.4,0.04,
					],15),

				],inf),
				\fac1, 0.01,
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),

		])
	)).play;

);

(

	// intro3
	~master.();
	Pdef(\part, Pdef(\perc_intro3,
		Pbind(\out, BusDef(\sendbus1))<>
		Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					Pseq([
						1,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,0,
					],2),
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkick2,
				\isRest, Pseq([
					Pseq([
						0,0,0,1, 0,0,1,0,
						0,1,0,0, 0,0,0,1,
						0,0,0,1, 0,0,1,1,
						0,1,0,0, 0,0,0,0,
					],inf),
					Pseq([
						1,0,1,0, 0,0,0,0,
						1,0,1,0, 0,0,0,0,
						1,0,0,0, 0,0,1,0,
						1,1,0,0, 0,0,0,0,
					],1),


					1,0,0,1, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					1,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,1,

						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,1,0, 1,0,0,1,
					],3),
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.48,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,0,0, 0,0,0,0,
					],8*8),
					0,0,1,0, 0,0,0,0,
					0,1,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					Pseq([
						Pseq([
							1,0,0,0,
							1,0,0,0,
							1,0,0,0,
							1,0,1,0,
						],3),

						1,0,1,0,
						1,0,1,0,
						1,1,0,1,
						1,0,0,1,
					],2),
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),

				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),
			Pbind(
				\instrument, \phycymbal,
				\isRest, Pseq([
					Pseq([
					  0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					],inf),
					Pseq([
						0,0,1,0, 0,0,1,1, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,1, 0,0,0,0, 0,0,0,0,
						0,0,1,0, 1,0,0,1, 0,0,1,0, 1,0,0,0,
						1,0,1,1, 1,0,1,0, 0,0,0,0, 0,0,0,0,
					],1),
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\sustain, Pseq([0.01,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.5,Pser([
						0.04,
					],15),
					0.05,Pser([
						0.4,0.04,
					],15),

				],inf),
				\fac1, 0.01,
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/feynman.flac'),
				\bufnum, BufDef('loop/funky4_135bpm.flac'),
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\pos, Pwhite(0,2.0),
				\speed, Pswitch1(
					[
						Pseg(Pseq([0,4],inf),8),
						Pseg(Pseq([2,1],inf),8),
					],
					Pseq([0,0,0,1],inf)
				),
				\speed, Pseg(Pseq([1,1.1],inf),8),
				\pos, Pseg(Pseq([0,0.1,1/4],inf),Pseq([1,0],inf))+ Pstep(Pseq([0,1,2],inf),2),
				\dur, 1/16,
				\amp, 0.1,
				\gain, 1/8,
			),
		Pbind(
			\instrument, \desapat1,
			\efreq, 200,
			\ts3, 1,
			\ts1, 1,
			\ts0, 3.1,
			\env2, 1,
			\legato, Pseq([
				3,0,0,2, 0,0,1.2,0,
				3,0,0,12, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				3,0,0,26, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\amp, 0.1,
		),

		])
	)).play;

);

(

	// intro4
	~master.();
	Pdef(\part, Pdef(\perc_intro4,
		Pbind(\out, BusDef(\sendbus1))<>
		Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					Pseq([
						1,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,0,
					],2),
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkick2,
				\isRest, Pseq([
					Pseq([
						0,0,0,1, 0,0,1,0,
						0,1,0,0, 0,0,0,1,
						0,0,0,1, 0,0,1,1,
						0,1,0,0, 0,0,0,0,
					],inf),
					Pseq([
						1,0,1,0, 0,0,0,0,
						1,0,1,0, 0,0,0,0,
						1,0,0,0, 0,0,1,0,
						1,1,0,0, 0,0,0,0,
					],1),


					1,0,0,1, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					1,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,1,

						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,1,0, 1,0,0,1,
					],3),
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.48,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,0,0, 0,0,0,0,
					],8*8),
					0,0,1,0, 0,0,0,0,
					0,1,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					Pseq([
						Pseq([
							1,0,0,0,
							1,0,0,0,
							1,0,0,0,
							1,0,1,0,
						],3),

						1,0,1,0,
						1,0,1,0,
						1,1,0,1,
						1,0,0,1,
					],2),
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),

				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),
			Pbind(
				\instrument, \phycymbal,
				\isRest, Pseq([
					Pseq([
					  0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					],inf),
					Pseq([
						0,0,1,0, 0,0,1,1, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,1, 0,0,0,0, 0,0,0,0,
						0,0,1,0, 1,0,0,1, 0,0,1,0, 1,0,0,0,
						1,0,1,1, 1,0,1,0, 0,0,0,0, 0,0,0,0,
					],1),
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\sustain, Pseq([0.01,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.5,Pser([
						0.04,
					],15),
					0.05,Pser([
						0.4,0.04,
					],15),

				],inf),
				\fac1, 0.01,
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/feynman.flac'),
				\bufnum, BufDef('loop/funky4_135bpm.flac'),
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\pos, Pwhite(0,2.0),
				\speed, Pswitch1(
					[
						Pseg(Pseq([0,4],inf),8),
						Pseg(Pseq([2,1],inf),8),
					],
					Pseq([0,0,0,1],inf)
				),
				\speed, Pseg(Pseq([1,1.1],inf),8),
				\pos, Pseg(Pseq([0,0.1,1/4],inf),Pseq([1,0],inf))+ Pstep(Pseq([0,1,2],inf),2),
				\dur, 1/16,
				\amp, 0.1,
				\gain, 1/8,
			),

		Pbind(\instrument, \cling,
			\degree, Pseq([0],inf),
			\legato, Pseq([
				0.1, 0.1, 0.7,0.1,
			],inf)/2,
			\dur, 2,
			\amp, 0.1,
		),
		])
	)).play;

);

(

	// verse1
	~master.();
	Pdef(\part, Pdef(\perc_verse1,
		Pbind(\out, BusDef(\sendbus1))<>
		Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					Pseq([
						1,0,1,0, 0,0,1,0,
						1,1,0,0, 0,0,0,0,
						1,0,0,0, 0,0,1,0,
						1,0,0,1, 0,0,0,1,
					],1),
					Pseq([
						1,0,1,0, 0,0,0,0,
						1,0,1,0, 0,0,0,0,
						1,0,0,0, 0,0,1,0,
						1,1,0,0, 0,0,0,0,
					],1),


					1,0,0,1, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					1,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snaretuned2,
				\instrument, \snapclap,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 1,0,0,0,
					],8),
					0,0,0,0, 0,1,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.48,
			),
			Pbind(
				\instrument, \snapclap,
				\instrument, \snaretuned2,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 1,0,0,0,
					],8),
					0,0,0,0, 0,1,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.01,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,0,0, 0,0,0,0,
					],8*8),
					0,0,1,0, 0,0,0,0,
					0,1,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat,
				\isRest, Pseq([
					1,1,1,1, 1,0,1,0,
					1,0,0,1, 1,0,0,0,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.5,Pser([
						0.04,
					],15),
					0.05,Pser([
						0.4,0.04,
					],15),

				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),

		])
	)).play;

);

(
	// verse2
	~master.();
Pdef(\part, Pdef(\perc_verse2,
		Pbind(\out, BusDef(\sendbus1))<>
	Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					Pseq([
						1,0,0,0, 0,0,0,1,
						0,0,1,0, 0,0,0,0,
					],3),
					1,0,0,1, 0,0,0,0,
					0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,0,
					],3),
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,1,0,0, 1,0,0,1,
					],1),
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.48,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,0,0, 1,0,1,0, 1,0,1,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),

				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),


			/////

			Pbind(
				\instrument, \snapkick2,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,1, 0,0,1,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/16,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/8,
				\dur, 1/16,
				\amp, 0.02,
			),
			Pbind(
				\instrument, \phyhat,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,1,0,
					0,1,0,0, 1,0,0,1, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),

				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			//\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 0,1,0,0,
				],4),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					0.1,
				],8*2)*1,
			],inf),
			\gain, 0.6,
			\dur, 1/16,
		),
		
	])
)).play;
);

/////////// MAIN

(
	~master.();
Pdef(\part, Pdef(\main,
	Pseq([
		Pfindur(8, Pdef(\perc_intro)),
		Pfindur(8, Pdef(\perc_intro2)),
		Pfindur(8, Pdef(\perc_intro3)),
		Pfindur(8, Pdef(\perc_intro4)),
		Pfindur(6, Pdef(\perc_verse3)),
		Pfindur(2, Pdef(\perc_end1)),
		Pfindur(8, Pdef(\perc_verse1)),
		Pfindur(8, Pdef(\perc_verse2)),
	],inf)
)).play;
);

/////////////////// DRAFT
(
	// verse3
	~master.();
Pdef(\part, Pdef(\perc_verse3,
		Pbind(\out, BusDef(\sendbus1))<>
	Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					Pseq([
						1,0,0,0, 0,0,0,1,
						0,0,1,0, 0,0,0,0,
					],3),
					1,0,0,1, 0,0,0,0,
					0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,0,
					],3),
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,1,0,0, 1,0,0,1,
					],1),
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.48,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,0,1,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0, 0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),

				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),


			/////

			Pbind(
				\instrument, \snapkick2,
				\isRest, Pseq([
					Pser([
						1,0,0,1, 0,0,1,0, 0,1,0,0, 0,0,0,0,
						1,0,1,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
						1,0,0,1, 0,0,1,0, 0,0,0,0, 1,0,0,1,
						1,0,1,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,

						1,0,0,1, 0,0,1,0, 0,1,0,0, 1,0,0,1,
						1,0,1,0, 0,0,1,0, 0,0,0,0, 1,0,0,1,
					],16*2*3),

					1,0,1,1, 0,1,0,1, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,1,0,1, 0,1,1,1,
				],inf).coin.not,
				\dur, 1/16,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/8,
				\dur, 1/16,
				\amp, 0.02,
			),
			Pbind(
				\instrument, \phyhat,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,1,0,
					0,1,0,0, 1,0,0,1, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),

				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\isRest, Pseq([
				Pseq([
					1,1,1,0,
					1,1,1,0,
					0,0,0,0,
					0,0,0,0,
				],4),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					0.1,
				],8*2)*1,
			],inf),
			\gain, 0.6,
			\dur, 1/16,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
	// end1
	~master.();
Pdef(\part, Pdef(\perc_end1,
		Pbind(\out, BusDef(\sendbus1))<>
	Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,0,
					],3),
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,1,0,0, 1,0,0,1,
					],1),
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.48,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,1,1,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),

				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),


			/////

			Pbind(
				\instrument, \snapkick2,
				\isRest, Pseq([
					1,0,1,1, 0,1,0,1, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,1,0,1, 0,1,1,1,
				],inf).coin.not,
				\dur, 1/16,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/8,
				\dur, 1/16,
				\amp, 0.02,
			),
			Pbind(
				\instrument, \phyhat,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),

				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\isRest, Pseq([
				Pseq([
					0,0,0,0,
					0,0,0,0,
					0,0,0,0,
					1,0,1,0,
				],4),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					0.1,
				],8*2)*1,
			],inf),
			\gain, 0.6,
			\dur, 1/16,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
	// end2
	~master.();
Pdef(\part, Pdef(\perc_end1,
		Pbind(\out, BusDef(\sendbus1))<>
	Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.48,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,0,1, 0,1,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,1, 0,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,1, 0,1,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,0, 0,0,0,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),

				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),


			/////

			Pbind(
				\instrument, \snapkick2,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/16,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/8,
				\dur, 1/16,
				\amp, 0.02,
			),
			Pbind(
				\instrument, \phyhat,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0, 0,0,1,0, 0,1,0,1,
					0,0,1,0, 0,0,0,0, 0,0,1,0, 1,0,1,1,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),

				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\isRest, Pseq([
				Pseq([
					0,0,0,0,
					1,0,1,0,
				],4),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					0.1,
				],8*2)*1,
			],inf),
			\gain, 0.6,
			\dur, 1/16,
			\amp, 0.1,
		),
		
	])
)).play;
);

(

Pdef(\test, 
	Ppar([
		Pbind(
			\instrument, \desapat1,
			\efreq, 200,
			\ts3, 1,
			\ts1, 1,
			\ts0, 3.1,
			\env2, 1,
			\legato, Pseq([
				3,0,0,2, 0,0,1.2,0,
				3,0,0,12, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				3,0,0,26, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\amp, 0.1,
		),
		
	])
).play;
)




		Pmono(\desapat1,
			\freq, 200,
			\env3, Pstep(Pseq([
				5000,3100,
			],inf),1),
			\env2, Pseq([
				Pseq([
					Pseq([
						1,1,0,0, 0,0,0,0,
					],4),

					1,1,1,0, 1,1,1,0,
					1,1,1,1, 1,1,1,0,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,0,0,

					Pseq([
						1,0,0,0, 1,1,1,1,
						1,1,1,1, 0,0,1,0,
						1,0,1,0, 0,0,0,0,
						1,1,0,1, 1,1,1,1,
					],1),

					1,1,1,0, 1,1,1,0,
					1,1,1,1, 1,1,1,0,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,0,0,

					Pseq([
						1,0,1,0, 1,0,0,0,
						1,1,1,1, 0,0,1,1,
						1,1,0,0, 0,0,1,0,
						1,1,1,1, 1,1,0,1,
					],1),

					1,1,1,0, 1,1,1,0,
					1,1,1,1, 1,1,1,0,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,0,0,
				],4),
			],inf),
			\dur, 1/16,
			\amp, 0.1,
		),


////////////////////////////::



play{f=LFPar.ar(1/14).round*20+80;Splay.ar(LFPar.ar({|i|[i+1*f,i*f+(i+1/3)]}!4)>BrownNoise.ar(Pulse.ar({|i|i+1}!4,0.35))/3)}//#SuperCollider

(
SynthDef(\elegui, { arg out=0, amp=0.1, gate=1;
	var sig;
	f=LFPar.ar(1/14).round*20+80;
	sig = LFPar.ar({|i|[i+1*f,i*f+(i+1/3)]}!4)>BrownNoise.ar(Pulse.ar({|i|i+1}!4,0.35))/3;
	sig = Splay.ar(sig * amp);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\test, 
	Ppar([
		Pbind(
			\instrument, \elegui,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		);
	])
).play;
)

(
SynthDef(\elegui, { arg out=0, amp=0.1, gate=1, freq=200;
	var sig;
	var f=freq;
	sig = LFPar.ar({|i|[i+1*f+XLine.kr(1/2,1/32+i,i+1*1),i*f+(i/3*XLine.kr(1/32,1+i,i+1*1))]}!8);
	sig = sig>BrownNoise.ar( SinOsc.ar(4*[1,2,1/4,1/2]));
	sig = sig/3;
	sig = Splay.ar(sig * amp);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\test, 
	Ppar([
		Pbind(
			\instrument, \elegui,
			\note, Pseq([
				2,2,2,-1,
				2,-1,-1,-1,
			],inf),
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
		);
	])
).play;
)

(
SynthDef(\elegui, { arg out=0, amp=0.1, gate=1, freq=200, vol=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var f=freq;
	sig = LFPar.ar({|i|[i+1*f+XLine.kr(1/2,1/32+i,i+1*2),i*f+(i/3*XLine.kr(1/32,1+i,i+1*1))]}!8) * ({ arg i; i=i+1; i*(vol/i)*2 }.dup(8));
	sig = sig>BrownNoise.ar( SinOsc.ar(4*[1,2,1/4,1/2] * \mod1.kr(1/10)));
	sig1 = FreqShift.ar(sig, (1..8)* EnvGen.kr(Env([1,1,200,1],[1.1,1,1.8]), 1))+sig;
	sig = SelectX.ar( EnvGen.kr(Env([0,0,1],[1.1,1.8]), 1), [sig, sig1]);
	sig = sig/3;
	sig = Splay.ar(sig * amp);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\test, 
	Ppar([
		Pbind(
			\instrument, \elegui,
			\note, Pstep(Pseq([
				0,-1,-1,-1,
			],inf),1),
			\vol, Pseg(Pseq([1/2,0,1],inf),16),
			\legato, Pseq([
				7,0,0,0, 0,0,0,0,
				6,0,0,0, 0,0,0,0,
				3,0,0,0, 3,0,0,0,
				0.2,2.8,0,0, 0.2,0.8,1.7,0,
				15,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		);
	])
).quant_(2).play;
~master.();
Pdef(\main).quant_(2).play;
)


(
SynthDef(\evol, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,2,1],[1.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,1/8,1],[1.1,2.8]), 1);
	env3 = EnvGen.kr(Env([1,1/8,1],[2.1,2.8]), 1);
	env4 = EnvGen.kr(Env([0,0,1/8,1],[2,2.1,2.8]/1), 1);
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(72 * ( 1 + ( SinOsc.kr(1/12) * 1 ))) * env4 )));
	sig = sig * (LFSaw.ar(freq)*env1+1);
	sig = RLPF.ar(sig, \lpf.kr(10000) * env2, \rq.kr(0.5)) + ( sig );
	sig = RLPF.ar(sig, 1000 * env3, 0.5) + ( sig/4 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\test, 
	Ppar([
		Pbind(
			\instrument, \evol,
			\dur, 2,
			\amp, 0.1,
			\note, Pstep(Pseq([
				0,-1,-1,-1,
			],inf),4),
			\vol, Pseg(Pseq([1/2,0,1],inf),16),
			\legato, Pseq([
				31,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
		);
	])
).play;
~master.();
Pdef(\main).play;
);

(
SynthDef(\evoltreb, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var dis;
	env1 = EnvGen.kr(Env([0,2,1],[1.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,1/8,1],[1.1,2.8]), 1);
	env3 = EnvGen.kr(Env([1,1/8,1],[2.1,2.8]), 1);
	env4 = EnvGen.kr(Env([0,0,1/8,1],[2,2.1,2.8]), 1);
//	env1 = 1;
//	env2 = 1;
//	env3 = 1;
//	env4 = 1;
	dis = 16/10;
	sig = SinOsc.ar(freq * [1,1] * ( 1 + ( SinOsc.ar(freq*0.75354) * env4 ))).mean;
	sig = sig * (LFSaw.ar(freq )*env1+1);
	sig = RLPF.ar(sig, \lpf.kr(10000) * env2, \rq.kr(0.5)) + ( sig );
	sig = RLPF.ar(sig, 1000 * env3, 0.5) + ( sig/4 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig / 2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\evoltreb2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var dis;
	env1 = EnvGen.kr(Env([0,2,1],[1.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,1/8,1],[1.1,2.8]), 1);
	env3 = EnvGen.kr(Env([1,1/8,1],[2.1,2.8]), 1);
	env4 = EnvGen.kr(Env([0,0,1/8,1],[2,2.1,2.8]), 1);
//	env1 = 1;
//	env2 = 1;
//	env3 = 1;
//	env4 = 1;
	dis = 16/10;
	sig = SinOsc.ar(freq * [1,dis] * ( 1 + ( SinOsc.ar(freq*0.75354) * env4 ))).mean;
	sig = sig * (LFSaw.ar(freq )*env1+1);
	sig = RLPF.ar(sig, \lpf.kr(10000) * env2, \rq.kr(0.5)) + ( sig );
	sig = RLPF.ar(sig, 1000 * env3, 0.5) + ( sig/4 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig / 2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\evoltreb3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var dis;
	env1 = EnvGen.kr(Env([0,2,1],[1.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,1/8,1],[1.1,2.8]), 1);
	env3 = EnvGen.kr(Env([1,1/8,1],[2.1,2.8]), 1);
	env4 = EnvGen.kr(Env([0,0,1/8,1],[2,2.1,2.8]), 1);
//	env1 = 1;
//	env2 = 1;
//	env3 = 1;
//	env4 = 1;
	dis = SelectX.kr( SinOsc.kr(1/16).exprange(0.0001,1), [1, 16/10]);
	sig = SinOsc.ar(freq * [1,dis] * ( 1 + ( SinOsc.ar(freq*0.75354) * env4 ))).mean;
	sig = sig * (LFSaw.ar(freq )*env1+1);
	sig = RLPF.ar(sig, \lpf.kr(10000) * env2, \rq.kr(0.5)) + ( sig );
	sig = RLPF.ar(sig, 1000 * env3, 0.5) + ( sig/4 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig / 2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdefn(\chords, Pstep(Pseq([
	0,-1,0,-1,
	0,-1,-2,-1,
],inf),4));
Pdef(\evoltreb, 
	Ppar([
		Pbind(
			\instrument, Pseq([
				\evoltreb,
				\evoltreb2,
				\evoltreb3,
				\evoltreb3,
			],inf).stutter(8*4*4),
			\dur, 2,
			\amp, 0.1,
			\note, Pdefn(\chords),
			\vol, Pseg(Pseq([1/2,0,1],inf),16),
			\legato, Pseq([

				7,0,0,0, 0,0,0,0,
				7,0,0,0, 0,0,0,0,
				15,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,1, 0,2,0,0,
				7,0,0,0, 0,0,0,0,
				15,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				31,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				10,0,0,0, 0,0,0,0,
				0,0,0,1, 0,1.8,0,1,
				7,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
		);
	])
).play;
Pdef(\evolbass, 
	Ppar([
		Pbind(
			\instrument, \evol,
			\dur, 2,
			\amp, 0.1,
			\note, Pdefn(\chords),
			\vol, Pseg(Pseq([1/2,0,1],inf),16),
			\legato, Pseq([
				31,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
		);
	])
).play;
~master.();
Pdef(\main).play;
);
Pdef(\main).quant=nil
Pdef(\test).quant=nil
Pdef.defaultQuant = 2;
Ndef.defaultQuant = 2;


(
SynthDef(\chocho, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, freq2=100;
	var sig;
	var ff;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,2,20, 40,1,70,40],[1,1.1,1.8,3, 0.5,10,10]), 1);
	env2 = EnvGen.kr(Env([0,0,0,0.01, 0,0,0.71,1.1240],[1,10.1,4.8,3, 0.5,10,10]), 1);
	ff = EnvGen.kr(Env([freq,freq,freq2],[0.1,0.08]), 1);
	sig = SinOsc.ar(ff * ( 1 + ( SinOsc.ar(freq * ( 1 + ( SinOsc.ar(12) * env2 ))) * \fmamp.kr(1) * env1 )));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Limiter.ar(sig);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

Pdef(\chocho, 
	Ppar([
		PmonoArtic( \chocho,
			\note, Pdefn(\chords),
			\fmamp, 1,
			\legato, Pseq([
				1,1,1,1, 1,1,1,0.8,
				1,1,1,1, 1,1,1,0.8,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,0.8,
			],inf),
			\freq2, Pkey(\freq)*2/3,
			\dur, 1,
			\amp, 0.1/2,
		);
	])
).play;
);

(
	~master.();
Pdef(\part, Pdef(\main,
	Pseq([
		Ptpar([
			0,Pdef(\chocho),
			8,Pdef(\evolbass),
			12,Pdef(\evoltreb),
			0,Pseq([
				Pfindur(8, Pdef(\perc_intro)),
				Pfindur(8, Pdef(\perc_intro2)),
				Pfindur(8, Pdef(\perc_intro3)),
				Pfindur(6, Pdef(\perc_verse3)),
				Pfindur(2, Pdef(\perc_end1)),
				Pfindur(8, Pdef(\perc_verse1)),
				Pfindur(8, Pdef(\perc_verse2)),
			],1),
		]),
	],inf)
)).play;
);
