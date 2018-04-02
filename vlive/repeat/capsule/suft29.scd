~t = 102/60; TempoClock.default.tempo = ~t;

(
SynthDef(\echhhi, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([10,10420,182],[0.04,5.1]/~t,[1,1]),1);
	env2 = EnvGen.kr(Env([10,10100,152],[0.04,4.1]/~t,[1,1]), 1);
	env3 = EnvGen.kr(Env([10,710,1000],[4,0.1]/~t,[1,1]), 1);
	env4 = EnvGen.kr(Env([0.1,2,0.1],[4.0,0.08]/~t), 1);
	sig = WhiteNoise.ar;
	sig = Ringz.ar(sig, rrand(70.0!8,1000),0.01).mean;
	sig = sig * ( SinOsc.ar(7700) * env4 + 1 );
	//sig = RLPF.ar(sig, env2, \rq2.kr(0.8));
	sig = RHPF.ar(sig,  [env3, env2, env1 ], \rq.kr(0.5));
	sig = LPF.ar(sig,  15000, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,2.4)),gate,doneAction:2);
	sig = Pan2.ar(sig, [-1,0,1]*0.1, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\demo, 
	Pbind(
		\instrument, \echhhi,
		\freq, 200,
		\legato, 1,
		\dur, Pn(2,1),
		\adsr, Pseq([
			[ Env.adsr(0.1,0.1,0.8,0.1) ],
		],inf),
		\amp, 0.1/2,
	),
).play;
)


(
SynthDef(\hardnoise, { arg out=0, gate=1, freq=200, pan=0, amp=0.1;
	var sig;
	var in;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		1,0,0,0,
		4,4,3,3,
	],inf)).midiratio;
	in = LocalIn.ar(10);
	sig = Dust.ar(freq * \dustfac.kr(1));
	sig = Ringz.ar(sig, freq, \ringz.kr(0.1));
	//sig = (sig + 0.05) * (SinOsc.ar(freq));
	sig = sig + (in * \fbfac.kr(1.4));
	sig = LPF.ar(sig, freq * SinOsc.ar((1..10)*freq).range(1,8.02));
	//sig = sig * 0.7;
	sig = sig.tanh;
	sig = FreqShift.ar(sig, [0.01,0]) + sig;
	LocalOut.ar(sig);

	sig = sig/ 2;

	sig = Pan2.ar(sig, SinOsc.kr((1..10)) * 0.1, amp).flop;
	sig = LeakDC.ar(sig);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
)

(
SynthDef(\tich, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1000,10000,10420],[0.04,5.1]/~t,[1,1]),1);
	env2 = EnvGen.kr(Env([1520,1000,1000],[0.04,4.1]/~t,[1,1]), 1);
	env3 = EnvGen.kr(Env([1010,1710,1000],[0.04,4.1]/~t,[1,1]), 1);
	env4 = EnvGen.kr(Env([0.1,2,0.1],[4.0,1.08]/~t), 1);
	sig = WhiteNoise.ar;
	sig = Ringz.ar(sig, rrand(70.0!8,1000),0.01).mean;
	sig = sig * ( SinOsc.ar(7700) * env4 + 1 );
	//sig = RLPF.ar(sig, env2, \rq2.kr(0.8));
	sig = RHPF.ar(sig,  [env3, env2, env1 ], \rq.kr(0.5));
	sig = LPF.ar(sig,  15000, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0.1,0.8,2.4)),gate,doneAction:2);
	sig = Pan2.ar(sig, [-1,0,1]*0.1, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\demo, 
	Pbind(
		\instrument, \tich,
		\freq, 200,
		\legato, 1/8,
		\dur, Pn(2,1),
		\adsr, Pseq([
			[ Env.adsr(0.001,0.1,0.8,4.1) ],
		],inf),
		\amp, 0.1/2,
	),
).play;
)


(
Pdef(\part, Pdef(\kij_part1, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,

				1,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.4,
			\lag, 0.04,
			\amp, 0.1,
			\out, BusDef(\master1, \audio),
		),	
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],6),
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 1,0,1,0,
						//1,0,0,0, 0,0,0,0,
						//1,0,0,1, 0,0,1,0,
					],1),
				],inf).coin.not,
				\sustain, 0.4,
				\gain, 0.2,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
						0,0,1,0, 1,0,1,0,
						0,0,1,0, 1,0,1,0,
					]/2,6),
					Pseq([
						1,1,1,1, 1,1,1,1,
					]/2,4),
				],inf).coin.not,
				\sustain, 0.1 + Pwhite(0,0.02),
				\gain, 0.1 * Pseq([
					3/4,2/3,3/4,2/3,3/4,
				],inf) + Pwhite(0,0.02),
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					Pser([
						1,1,
					],8*6),
					Pser([
						1,0, 0,0, 
					],8*2),
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/4,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1 * Pseg(Pseq([1,80,80001,1],inf),4),
			],inf).stutter(1),
			'delay2', 0.000000543560099,
			'distamp', 0.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 300,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
			\out, BusDef(\master1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560099,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 7300,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
			\out, BusDef(\master1, \audio),
		),



		////// bass


			Pbind(
				\instrument, \mouais,
				\fb, Pseq([
					0.1,
				],inf),
				\selectffac, Pseq([
					0.2, 
				],inf),
				\fspread, Pseq([
					1/11112,
					1/11212,
				],inf),
				\legato, Pseq([
					1,0,1,0, 2,0,1,0,
					2,0,1,0, 3,0,0,1,
					1,0,1,0, 1,0,1,0,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\note, Pseq([
						-5,
				],inf).stutter(12),
				\detune, Pseq([
					0,0,0.1,1,
				],inf).stutter(8),
				\octave, 3,
				\dur, 1/8,
				\amp, 0.1,
				//\lag, 0.04,
				\out, BusDef(\bassbus1, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\bassbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000000001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 0.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 0.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
			\out, BusDef(\master1, \audio),
			),

			// smp

		Pbind(
			\instrument, \envgrain,
			\mbufnum, BufDef.mono('vipere/metal.flac'),
			\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
			\pos, Pseq([
				1.8,
				1.8,
				0.8,
			],inf).stutter(6),
			\posenv, Pseq([
				[ Env([0,0.2,0],[0.02,1.8]) ]
			],inf),
			\pitchenv, Pseq([
				[ Env([1,1,1],[0.1,2.8]) ]
			],inf),
			\pitchenv, Pseq([
				[ Env([1,1,8],[0.1,2.8]) ]
			],inf),
			\gfreqenv, Pseq([
				[ Env([4,1,1],[0.1,2.8]) ]
			],inf),
			\gdurenv, Pseq([
				[ Env([1,1,8],[0.1,2.8]) ]
			],inf),
			\freq, 120,
			\gfreq, Pkey(\freq),
			\gdur, 0.19,
			\posrandamp, 0.01,
			\posrandfreq, 20,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Ppatlace([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				3,0,0,0, 4,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\pitch_stretch, 1,
			\dur, 1/8,
			\gain, 1/4,
			\amp, 0.1,
			//\out, BusDef(\csendbus2, \audio),
			\out, BusDef(\master1, \audio),
		),

		////// chhh

	Pbind(
		\instrument, \echhhi,
		\freq, 200,
		\legato, 1,
		\dur, Pseq([Rest(6+8),2,Rest(16)],inf),
		\adsr, Pseq([
			[ Env.adsr(0.7,0.1,0.8,0.1) ],
		],inf),
		\lag, 0.04,
		\amp, 0.1/2,
	),
	Pbind(
		\instrument, \tich,
		\freq, 200,
		\legato, 1/8,
		\dur, Pseq([Rest(16),2,Rest(6+8)],inf),
		\adsr, Pseq([
			[ Env.adsr(0.001,0.1,0.8,4.1) ],
		],inf),
		\lag, 0.04,
		\amp, 0.1/2,
	),

	//// hardnoise

	Pmono(\hardnoise,
		\freq, 200,
		\dur, 1,
		\amp, 0.1,
		\out, BusDef(\noisebus, \audio),
	),
	Pseq([
		Pmono(\fx_rhpf,
			\inbus, BusDef(\noisebus),
			\addAction, \addToTail,
			\lag, 0.0001,
			\hpf, Pseq([
				~pmodenv.(Pseq([20000,15000,10000,100,10],1), 4), // 4*(5-1)=16 beats
				Pn(10,16),
			],1),
			\mix, Pstep(Pseq([
				1,
			],inf),16),
			\dur, 1,
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\noisebus),
			\addAction, \addToTail,
			\lag, 0.0001,
			\lpf, Pseq([
				~pmodenv.(Pseq([20,150,1000,10000,20000],1), 4),
				Pn(20000,16),
			],1),
			\mix, Pstep(Pseq([
				1,
			],inf),16),
			\dur, 1,
		),
	],inf),


		// master

		Pseq([
			Pmono(\fx_rlpf,
				\inbus, BusDef(\master1),
				\addAction, \addToTail,
				\lag, 0.001,
				\lpf, 500,
				\mix, Pstep(Pseq([
					0,1,
				],1),16),
				\dur, 1,
			),
			Pmono(\fx_rhpf,
				\inbus, BusDef(\master1),
				\addAction, \addToTail,
				\lag, 0.001,
				\hpf, 9500,
				\mix, Pstep(Pseq([
					0,1,
				],inf),16),
				\dur, 1,
			),
		],inf),
	])
)).play;
)

(
Pdef(\part, Pdef(\main, 
	Ppar([
		Pdef(\kij_part1),
		Pdef(\kij_part2),
		
	])
)).play;
)


(
Pdef(\part, Pdef(\kij_part2, 
	Ppar([


		// master

		Pmono(\fx_rhpf,
			\inbus, BusDef(\master),
			\addAction, \addToTail,
			\lag, 0.001,
			\rq, 1,
			\hpf, 800,
			\mix, Pstep(Pseq([
				1,
			],inf),16),
			\dur, 1,
		),
	])
)).play;
)

