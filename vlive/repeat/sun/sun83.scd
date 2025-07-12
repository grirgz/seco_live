
(
~t = 155/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
FileSystemProject.loadOnce("holis/synthdef.scd");
FileSystemProject.loadOnce("capsule/fxheavy.scd");
)

(
SynthDef(\harpsichord_pluck, {
	|amp=0.1, freq=440, pan=0, atk=0, rel=0, trig= 1, maxdelaytime= 0.2, decaytime= 7, coef= 0.1|
	var env, sig, delay;
	env = EnvGen.kr(Env.linen(atk, decaytime, rel), doneAction: Done.freeSelf);
	sig = PinkNoise.ar(amp); //Can use white noise here, but Pink is more realistic
	delay = freq.reciprocal;
	sig = Pluck.ar(sig, trig, maxdelaytime , delay , decaytime , coef ) //fundamental
	+ Pluck.ar(sig, trig, maxdelaytime , delay/2 , decaytime , coef ); //octave higher
	Out.ar(0, Pan2.ar(sig , pan));
//Harpsichord based on Pluck Ugen
//By Zé Craum

}).add;
)

(
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1078].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1598].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[181].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,0,0,
				1,0,1,0, 1,0,0,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1173].value,
			\isRest, Pseq([
				1,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,1,1,
				1,0,1,1, 1,0,0,1,

				1,0,0,0, 1,0,1,0,
				1,0,0,1, 1,0,1,0,
				1,0,0,0, 1,1,1,0,
				1,0,1,1, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.1/4,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),

		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,4,7-12],
				[0,3,7]+5,
			],inf),
			\ffreq, PmodEnv(Pseq([1000,2000,8000],1), 8).loop,
			\dur, Pseq([3,1],inf),
			\amp, 0.1/2,
		),

		Pbind(
			\instrument, \sh101,
			\idx, Pseq([1,2,3,4]+3,inf),
			\note, Pstep(Pseq([
				[0,4,7-12],
				[0,3,7]+5,
			],inf), Pseq([3,1],inf)),
			\note, Pfunc({ arg ev;
				( ev[\note] +.x [0,0,12] ).wrapAt(ev[\idx].asInteger);
			}),
			\octave, Prand([3],inf),
			\lpf, PmodEnv(Pseq([100,2000,10000],1), 8*2).loop,
			\legato, Pseq([
				4,0,0,0, 0,0,0,0,
				4,0,0,0, 4,0,0,0,
				0,0,2,0, 2,0,2,0,
				4,0,0,0, 0,2,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pseq([1/8],inf),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\idx, Pseq([0,5,6,7, 1,2,3,4],inf),
			\note, Pstep(Pseq([
				[0,4,7-12],
				[0,3,7]+5,
			],inf), Pseq([3,1],inf)),
			\note, Pfunc({ arg ev;
				( ev[\note] +.x [-12,0,12] ).wrapAt(ev[\idx].asInteger);
			}),
			\octave, Prand([6],inf),
			\lpf, PmodEnv(Pseq([100,2000,10000],1), 8*2).loop,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0.4,0.7,0, 0,0,1,1,
			],inf).coin.not,
			\dur, Pseq([1/8],inf),
			\amp, 0.1/3,
		),
		
	])
)).play;
);



(
// from capsule/suft41.scd
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pdef(\drums1),

		// pad
			Pbind(
				\instrument, \snappad,
				\note, Pseq([
					0,10,
				],inf),
				\dur, 4,
				\amp, 0.1/2,
				\out, BusDef(\sendbus3, \audio),
			),
			Pbind(
				\instrument, \snappad,
				\note, Pseq([
					0,1,2,4,
				],inf),
				\octave, 7,
				\dur, 4,
				\amp, 0.1/2,
				\out, BusDef(\sendbus3, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus3, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,10,100,
				],inf).stutter(4),
				'delay2', 0.000000543560101,
				'distamp', 9.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 470,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 2,
			),
			Pmono(\chorusdist,
				\inbus, BusDef(\sendbus3, \audio, 2),
				\distamp, 20,
				\distpostamp, 1/1,
				\fb, 0.904,
				\distmix, 1,
				\delay, 0.00111,
				\modfreq, 4*~t * Pseq([1,2,10],inf),
				\modamp, 0.7001,
				\hpf, 500,
				\gain, 0.4,
				\dur, 4,
				\amp, 0.1,
			),
			Pmono(\fx_freqshift,
				\inbus, BusDef(\sendbus3),
				\shift, 1400,
				\mix, 1,
				\dur, 2,
			),

			// bass

			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,1,
				],inf),
				\legato, Pseq([
					//4,0,0,0, 1,0,1,1,
					2,0,0,2, 0,0,2,0,
					2,0,0,2, 0,0,2,0,
					2,0,0,2, 0,0,2,0,
					2,0,0,2, 0,0,2,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\dur, 2,
				\amp, 0.1,
				\out, BusDef(\sendbus4, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus4, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.0000600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 101.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 170,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 4,
			),
	])
)).play;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				0,10,
			],inf),
			\ffreq, PmodEnv(Pseq([1000,2000,8000],1), 8).loop,
			\dur, 4,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				0,1,2,4,
			],inf),
			\octave, 7,
			\dur, 4,
			\amp, 0.1/2,
		),
	])
)).play;
);
ProtoDef(\PianoCenter).edit
FileSystemProject.load("paramdev/drafts/PianoCenter.scd")
(
// from capsule/suft41.scd
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pseq([
			Pfindur(8,Pdef(\drums1)),
			Pfindur(8,Pdef(\drums2)),
		],inf),

		// pad
			Pbind(
				\instrument, \snappad,
				\note, Pseq([
					0,10,
				],inf),
				\dur, 4,
				\amp, 0.1/2,
				\out, BusDef(\sendbus3, \audio),
			),
			Pbind(
				\instrument, \snappad,
				\note, Pseq([
					0,1,2,4,
				],inf),
				\octave, 7,
				\dur, 4,
				\amp, 0.1/2,
				\out, BusDef(\sendbus3, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus3, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					100,
				],inf).stutter(4),
				'delay2', 0.000000543560101,
				'distamp', 9.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 470,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 2,
			),
			Pmono(\chorusdist,
				\inbus, BusDef(\sendbus3, \audio, 2),
				\distamp, 20,
				\distpostamp, 1/1,
				\fb, 0.904,
				\distmix, 1,
				\delay, 0.00111,
				\modfreq, 4*~t * Pseq([1],inf),
				\modamp, 0.7001,
				\hpf, 500,
				\gain, 0.4,
				\dur, 4,
				\amp, 0.1,
			),
			Pmono(\fx_freqshift,
				\inbus, BusDef(\sendbus3),
				\shift, 1400,
				\mix, 1,
				\dur, 2,
			),

			// bass

			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,1,
				],inf),
				\legato, Pseq([
					//4,0,0,0, 1,0,1,1,
					2,0,0,2, 0,0,2,0,
					2,0,0,2, 0,0,2,0,
					2,0,0,2, 0,0,2,0,
					2,0,0,2, 0,0,2,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\dur, 2,
				\amp, 0.1,
				\out, BusDef(\sendbus4, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus4, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.0000600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 101.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 170,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 4,
			),
	])
)).play;
)

///////////
(
Pdef(\part, Pdef(\drums2, 
	Ppar([
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, ~buflib.kick[1078].value,
			//\isRest, Pseq([
				//1,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//1,0,0,0, 1,0,0,0,
				//0,0,0,0, 0,0,1,0,
				//1,0,0,0, 0,0,1,0,
				//0,0,0,0, 0,0,0,0,
				//1,0,0,1, 0,0,1,0,
				//0,0,0,0, 0,0,0,0,
			//],inf).coin.not,
			//\dur, 1/8,
			//\gain, 0.1,
		//),
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, ~buflib.snare[1598].value,
			////\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			//\isRest, Pseq([
				//0,0,0,0, 0,0,0,0,
				//1,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//1,0,0,0, 0,0,0,0,
			//],inf).coin.not,
			//\dur, 1/8,
			//\adsr, Pseq([
				//[ Env.adsr(0.01,0.1,0.8,0.1) ],
			//],inf),
			//\gain, 0.11/2,
		//),
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, ~buflib.hat[181].value,
			////\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			//\isRest, Pseq([
				//1,0,1,0, 1,0,0,0,
				//1,0,1,0, 1,0,0,1,
				//1,0,1,0, 1,0,1,0,
				//1,0,0,1, 1,0,1,1,
			//],inf).coin.not,
			//\dur, 1/8,
			//\adsr, Pseq([
				//[ Env.adsr(0.1,0.1,0.8,0.1) ],
			//],inf),
			//\gain, 0.11/2,
		//),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1173].value,
			\isRest, Pseq([
				1,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,1,1,
				1,0,1,1, 1,0,0,1,

				1,0,0,0, 1,0,1,0,
				1,0,0,1, 1,0,1,0,
				1,0,0,0, 1,1,1,0,
				1,0,1,1, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.1/4,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\drums3, 
	Pfindur(8,Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1078].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1862].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\speed, Pseg(Pseq([1,1/4],1),1).loop,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],7),
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1598].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[181].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				0,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0,
				1,0,1,0, 0,0,1,1,
				1,1,1,1, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1173].value,
			\isRest, Pseq([
				1,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,1,1,
				1,0,1,1, 1,0,0,1,

				1,0,0,0, 1,0,1,0,
				1,0,0,1, 1,0,1,0,
				1,0,0,0, 1,1,1,0,
				1,0,1,1, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.1/4,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
	]))
)).play;
);

(
Pdef(\part, Pdef(\bass1, 
	Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,1,
				],inf),
				\legato, Pseq([
					//4,0,0,0, 1,0,1,1,
					2,0,0,2, 0,0,2,0,
					2,0,0,2, 0,0,2,0,
					2,0,0,2, 0,0,2,0,
					2,0,0,2, 0,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\dur, 2,
				\amp, 0.1,
				\out, BusDef(\fxbass, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\fxbass, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				//'delay', 0.0000600001231 * Pseq([
					//1,10,1/10
				//],inf).stutter(1),
				\delay, PmodEnv(Pseq([0.0000001,0.000002],1), 8, -3).loop,
				'delay2', 0.000000543560101,
				'distamp', 101.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 170,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 4,
			),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\bass2, 
	Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pstep(Pseq([
					0,0,0,1,
				],inf),2),
				\legato, Pseq([
					//4,0,0,0, 1,0,1,1,
					2,0,0,2, 0,0,2,0,
					2,0,0,2, 0,0,2,0,
					2,0,0,2, 0,0,2,0,
					2,0,0,2, 0,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\fxbass, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\fxbass, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				//'delay', 0.0000600001231 * Pseq([
					//1,10,1/10
				//],inf).stutter(1),
				\delay, PmodEnv(Pseq([0.0000001,0.0002,0.002],1), 8, -3).loop,
				'delay2', 0.000000543560101,
				'distamp', 101.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 170,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 4,
			),
		
	])
)).play;
);

//// flat
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\bass2),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[155].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[384].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[784].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 1,0,0,0,
				1,0,0,0, 0,0,1,0,
				1,1,1,1, 0,0,1,0,
				0,0,1,0, 1,0,0,0,

				0,0,1,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0,
				1,1,1,1, 0,0,1,0,
				0,0,1,0, 1,0,0,1,

				0,0,1,0, 1,0,0,0,
				1,0,0,0, 0,0,1,0,
				1,1,1,1, 0,0,1,0,
				0,0,1,0, 1,0,0,0,

				0,0,1,0, 1,0,0,0,
				1,0,0,0, 0,0,1,0,
				1,1,1,1, 0,0,1,1,
				0,1,1,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[264].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\legato, 2,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef.stereo('vbreaks/Grady Tate - Be Black Baby.wav'),
			\legato, 1,
			\st, 110/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\hpmix, 1,
			\hpf, 1000,
			\pos, Pseg(Pseq([
				6, 2,
			]+0,1),4).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);

///// compo
(
// cut bass and drums
Pdef(\part, Pdef(\ppart1, 
	Pfindur(32,Ppar([
		Pseq([
			Pfindur(16,Pdef(\drums1)),
			Pfindur(8,Pdef(\drums2)),
			Pfindur(8,Pdef(\drums3)),
		],inf),

		// pad
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				0,10,
			],inf),
			\dur, 4,
			\amp, 0.1/2,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				0,1,2,4,
			],inf),
			\octave, 7,
			\dur, 4,
			\amp, 0.1/2,
			\out, BusDef(\sendbus3, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				100,
			],inf).stutter(4),
			'delay2', 0.000000543560101,
			'distamp', 9.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 470,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 2,
			\out, BusDef(\pfxm1, \audio),
		),
		Pmono(\chorusdist,
			\inbus, BusDef(\sendbus3, \audio, 2),
			\distamp, 20,
			\distpostamp, 1/1,
			\fb, 0.904,
			\distmix, 1,
			\delay, 0.00111,
			\modfreq, 4*~t * Pseq([1],inf),
			\modamp, 0.7001,
			\hpf, 500,
			\gain, 0.4,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\pfxm1, \audio),
		),
		Pmono(\fx_freqshift,
			\inbus, BusDef(\sendbus3),
			\shift, 1400,
			\mix, 1,
			\dur, 2,
			\out, BusDef(\pfxm1, \audio),
		),
		Pmono(\fx_lpf,
			\inbus, BusDef(\pfxm1, \audio),
			\addAction, \addToTail,
			\lpf, 
			Pseq([
				PmodEnv(Pseq([17,17,20000],1), 8),
				PmodEnv(Pseq([17,17,20000],1), 8),
				PmodEnv(Pseq([17,17,20000],1), 16),
			],inf),
			\mix, 1,
			\lag, 0.0010,
			\dur, 1,
		),

		// voice fx
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, 0.53,
			\speed, 1.2,
			\legato, 1,
			\dur, Pseq([Rest(24.75),Pn(0.4,1)]),
			\gain, 1/4,
			\out, BusDef(\pfx1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\pfx1, \audio),
			\addAction, \addToTail,
			\delay, 1/3/~t,
			\decay,5,
			\lag, 0.0009,
			\dur, 1,
		),

		// reverb meca noise

		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[449].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\legato, 4,
			\gain, 0.1,
			\out, BusDef(\pfx2, \audio),
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[49].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\legato, 4,
			\gain, 0.1,
			\out, BusDef(\pfx2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[315].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\legato, 4,
			\gain, 0.1,
			\out, BusDef(\pfx2, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\pfx2, \audio),
			\addAction, \addToTail,
			\mix, 0.5,
			\room, 3,
			\damp,0.4,
			\gain, 2,
			\lag, 0.0009,
			\dur, 1,
		),


		// bass
		Pseq([
			Pfindur(20,Pdef(\bass1)),
			Pfindur(12,Event.silent(4)),
		],inf),
		Ptpar([
			28, Pbind(
				\instrument, \grancruhp,
				\mbufnum, BufDef.mono('vipere/rocksteady.flac'),
				\pos, ~pmodenv.(Pseq([2.4,1]+3,1), 4).loop,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,2.4) ],
				],inf),
				\gfreq, 840,
				\hpf, PmodEnv(Pseq([10000,100],1), 4).loop,
				\gdur, 0.08,
				\isRest, Pseq([
					1,0,
				],1).coin.not,
				\dur, 2,
				\gain, 13.dbamp,
			)
		])

	]))
)).play;
)


(
Pdef(\part, Pdef(\ppart2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[449].value,
			\pos,0.2,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\legato, 4,
			\gain, 0.1,
			\out, BusDef(\pfx2, \audio),
			//\isRest, true,
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\pfx2, \audio),
			\addAction, \addToTail,
			\mix, 0.5,
			\room, 3,
			\damp,0.4,
			\gain, 2,
			\lag, 0.0009,
			\dur, 1,
		),
		Pdef(\bass2),
		Ptpar([
			2, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[155].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1/2,
			),
			4,Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.clap[384].value,
				//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11/2,
			),
			8,Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[784].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 1,0,0,0,
					1,0,0,0, 0,0,1,0,
					1,1,1,1, 0,0,1,0,
					0,0,1,0, 1,0,0,0,

					0,0,1,0, 1,0,0,0,
					1,0,0,1, 0,0,1,0,
					1,1,1,1, 0,0,1,0,
					0,0,1,0, 1,0,0,1,

					0,0,1,0, 1,0,0,0,
					1,0,0,0, 0,0,1,0,
					1,1,1,1, 0,0,1,0,
					0,0,1,0, 1,0,0,0,

					0,0,1,0, 1,0,0,0,
					1,0,0,0, 0,0,1,0,
					1,1,1,1, 0,0,1,1,
					0,1,1,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11/2,
			),
			8,Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
				\bufnum, ~buflib.foley1[264].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/4,
				\legato, 2,
				\gain, 0.1,
			),
			4, Pbind(
				\instrument, \playersec_hlpf,
				\bufnum, BufDef.stereo('vbreaks/Grady Tate - Be Black Baby.wav'),
				\legato, 1,
				\st, 110/2/60,
				\speed, 1 * ~t / Pkey(\st),
				\hpmix, 1,
				\hpf, 1000,
				\pos, Pseg(Pseq([
					6, 2,
				]+0,1),4).loop / Pkey(\st),
				\dur, 1/8,
				\gain, 1/8,
			),
		])

	])
)).play;
);

(
Pdef(\part, Pdef(\main, 
	Pseq([
		Pdef(\ppart1),
		Pdef(\ppart2),
		
	])
)).play;
)

/// draft
(
Pdef(\part, Pdef(\zedpart, 
	Pfindur(16,Ppar([
		
		Pbind(
			\instrument, \harpsichord_pluck,
			\note, Pseq([
				4,11,19,
				4,11,19,
				4,11,18,
				4,11,18,
				4,11,18,
				11,
				4,9,14,
				4,9,14,
				4,9,16,
				4,9,16,
				4,9,16,
				9,
				4,11,16,
				4,11,16,
				4,11,16,
				4,11,16,
				4,11,16,
				11,
				4,11,16,
				4,11,16,
				4,11,16,
				4,11,16,
				4,11,16,
				11,
			],inf),
			\note, Pseq([
				Pseq([
					Pseq([
						4,11,19,
					],5), 11,
				],3),
				Pseq([
					4,9,19,
				],5), 11,
			],inf)-5,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.6) ],
			],inf),
			\dur, 1/8,
			\octave, 6,
			\amp, 0.1,
			\coef, PmodEnv(Pseq([0.1,0.4,0.7],1), 8).loop,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef.stereo('vbreaks/Grady Tate - Be Black Baby.wav'),
			\legato, 1,
			\st, 110/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\hpmix, 1,
			\hpf, PmodEnv(Pseq([2000,2],1), 8*2),
			\pos, Pseg(Pseq([
				6, 2,
			]+0,1),4).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pseq([
			Pmono(
				{ arg out=0, gate=1, amp=0.1, pan=0, freq=200;
					var sig;
					var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
					lfo1 = XLine.kr(0.001,2,8/~t);
					lfo2 = Duty.kr(1/16/~t, 0, Dseq([
						1,1,0.7,0.7,
						1,0,1,0,
						1,0.2,0.4,0.1,
						1,0,1,0.3,
					],inf))+0.3;
					lfo3 = SinOsc.ar(0.1*~t) * 0.4 + 1; 
					lfo3 = lfo3 * Line.kr(0.2,8,16/~t);
					sig = LFSaw.ar(freq * [1,1.0001] * ( SinOsc.ar(freq * \fmr.kr(2)) * \fmamp.kr(0.5) * lfo1 * SinOsc.ar(0.1*~t)  + 1 ));
					sig = sig.mean;
					sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * lfo3 ).clip(20,20000), \rq.kr(0.5));
					sig = sig.fold2(lfo2);
					sig = HPF.ar(sig, XLine.kr(20000.0,10,8/~t));
					//sig = sig* EnvGen.kr(Env([0,1,1,0],[0.1,6/~t,0.1]), 1);
					sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
					sig = Pan2.ar(sig, pan, amp);
					Out.ar(out, sig);
				}.asDefName,
				\note, Pstep(Pseq([
					0,0,0,0,
					0,0,0,0,
					0,0,0,0,
					0,0,0,3,
				],1),1)-5,
				\octave, 4,
				\dur, 2,
				\amp, 0.1/2,
			)
		],inf),
	]))
)).play;
);

///////////////////////////////////// sdesign
(
SynthDef(\grancruhp, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, mbufnum, gdur=0.1, gfreq=8, pos=0, pitch_stretch=1;
	var sig;
	var clk = Impulse.ar(gfreq);
	pos = pos + LFNoise1.ar(gfreq,mul:0.01);
	//pitch_stretch = pitch_stretch + LFNoise1.ar(10, mul:0.1);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = HPF.ar(sig, \hpf.kr(1000));
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \grancruhp,
			\mbufnum, BufDef.mono('vipere/rocksteady.flac'),
			\pos, ~pmodenv.(Pseq([2.4,1]+3,1), 4).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.4) ],
			],inf),
			\gfreq, 840,
			\hpf, PmodEnv(Pseq([10000,100],1), 4).loop,
			\gdur, 0.08,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\dur, 2,
			\gain, 13.dbamp,
		)
		
	])
)).play;
)


(
~gen_transi_snappad = { arg seed=1234, num=12;

	var name = \transi_snappad_v+++seed+++\_n+++num;
	fork {
		SynthDef(name, { arg gate=1, timeScale=1, freqfac=1, rel=3;
			var snd, freq;
			var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
			thisThread.randSeed = seed;
			freq = \freq.kr(440);
			lfo1 = XLine.kr(0.1,0.01,2/~t * timeScale);
			lfo2 = XLine.kr(2,0.001,2/~t * timeScale);
			lfo3 = XLine.kr(0.2,0.9,1/~t * timeScale);
			snd = num.collect { arg item, idx;
				var harms = [1,2,4,1/2,1/4];
				var isig;
				var fenv, rqenv;
				var hpenv;
				var env;
				var noisefac = rrand(0.4,2);
				isig = Pulse.ar(
					freq * LFNoise2.kr(rrand(0.4,10)).range(-0.05 * noisefac, 0.05 * noisefac).midiratio * harms.choose,
					LFNoise2.kr(rrand(0.4,10)).range(0.3, 0.7)
				);
				fenv = EnvGen.ar(Env.adsr(rrand(0.1,8),rrand(0.1,8),rrand(0.01,1),rrand(0.1,2) + rel),gate,doneAction:0, levelScale: rrand(0.5,3), timeScale:timeScale);
				hpenv = EnvGen.ar(Env.adsr(rrand(0.1,8),rrand(0.1,8),rrand(0.01,1),rrand(0.1,2) + rel),gate,doneAction:0, timeScale:timeScale);
				rqenv = EnvGen.ar(Env.adsr(rrand(0.1,8),rrand(0.1,8),rrand(0.01,1),rrand(0.1,2) + rel),gate,doneAction:0, timeScale:timeScale);
				env = EnvGen.ar(Env.adsr(rrand(0.1,8),rrand(0.1,8),rrand(0.01,1),rrand(0.1,2) + rel),gate,doneAction:0, timeScale:timeScale);
				isig = RLPF.ar(isig, ( \lpf.kr(1000) * lfo3 * ( fenv + 1 ) ).clip(20,20000), ( \rq.kr(0.5) * (rqenv + 1) ).clip(0.1,1));
				isig = RHPF.ar(isig, ( \hpf.kr(100) * ( hpenv + 1 ) ).clip(20,20000), ( \rq.kr(0.5) * (rqenv + 1) ).clip(0.1,1));
				isig = isig * env;
				isig;
			};
			// Spread across stereo field
			snd = Splay.ar(snd);
			// Sharp hi cut made by cascading three lowpass filters
			//3.do { snd = LPF.ar(snd, \ffreq.kr(1500)); };
			snd = snd * Env.asr(\at.kr(3), \sustainlevel.kr(1), rel, -4).ar(Done.freeSelf, gate);
			Out.ar(\out.kr(0), Balance2.ar(snd[0], snd[1], \pan.kr(0), \amp.kr(0.1)));
		}).add;
	};
	name;
}
)

(
// chord draft 1
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, ~gen_transi_snappad.(449,7),
			\note, Pseq([
				[3,12,19],
				[4,11,19],
				[4,10,19],
				[4,9,19],
			],inf),
			\lpf, PmodEnv(Pseq([100,2000,10000],1), 8).loop,
			\hpf, PmodEnv(Pseq([400,200,10],1), 8).loop,
			\octave, 4,
			\timeScale, 4,
			\rel, 5,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);

(
// chord draft 2
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, ~gen_transi_snappad.(449,7),
			\note, Pseq([
				[3,12,19],
				[4,11,19],
				[4,10,19],
				[4,9,19],
			],inf),
			\lpf, PmodEnv(Pseq([100,2000,10000],1), 8).loop,
			\hpf, PmodEnv(Pseq([400,200,10],1), 8).loop,
			\octave, 4,
			\timeScale, 4,
			\rel, 5,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);

(
// chord draft 3
// 4-note melody
// nice!
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\instrument, ~gen_transi_snappad.(1471,7),
			\note, Pseq([
				[0+12,4,7,21],
				[ 4,11,19 ],
				[ 5,12,21 ],
				[ 3,12,19 ],
			],inf),
			\octave, 4,
			\timeScale, 4,
			\dur, 4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, ~gen_transi_snappad.(1463,7),
			\note, Pseq([
				0,2,4,2,
				0,2,4,2,
				0,2,5,2,
				0,3,12,3,
			],inf),
			\timeScale, 0.4,
			\hpf, 400,
			\octave, 5,
			\legato, 1,
			\dur, Pseq([
				//1,1,1,1,
				2,1/2,0.5,1,
				2,1/2,0.5,1,
				1/2,1/2,1.5,1.5,
				1/2,1/2,1.5,1.5,
			],inf),
			\amp, 0.1,
		),
		
	])
)).play;
);

(
// chord draft 4
// 6-note melody
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\instrument, ~gen_transi_snappad.(1487,7),
			\note, Pseq([
				[0+12,4,7,21],
				[ 4,11,19 ],
				[ 5,12,21 ],
				[ 3,12,19 ],
			],inf),
			\octave, 4,
			\timeScale, 4,
			\dur, 4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, ~gen_transi_snappad.(1470,7),
			\note, Pseq([
				0,4,7,9,12,19,
			],inf),
			\timeScale, 0.4,
			\hpf, 400,
			\octave, 5,
			\legato, 1,
			\dur, Pseq([
				//1,1,1,1,
				2,1/2,
				2,1/2,0.5,1,
				1/2,1/2,
				1/2,1/2,1.5,1.5,
			],inf),
			\amp, 0.1,
		),
		
	])
)).play;
);

(
// flat drums, chords, pluck
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pbind(
			\instrument, \default,
			\instrument, ~gen_transi_snappad.(1487,7),
			\note, Pseq([
				[0+12,4,7,21],
				[ 4,11,19 ],
				[ 5,12,21 ],
				[ 3,12,19 ],
			],inf),
			\octave, 4,
			\timeScale, 4,
			\dur, 4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, ~gen_transi_snappad.(1470,7),
			\note, Pseq([
				0,4,7,9,12,19,
			],inf),
			\timeScale, 0.4,
			\hpf, 400,
			\octave, 5,
			\legato, 1,
			\dur, Pseq([
				//1,1,1,1,
				2,1/2,
				2,1/2,0.5,1,
				1/2,1/2,
				1/2,1/2,1.5,1.5,
			],inf),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				[7,12],
				[12,16],
				[12,17],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.7) ],
			],inf),
			\octave, 6,
			\dur, 1/8,
			\lpf, Ptuple(Pwhite(100,1000.0)!2)* Pseg(Pseq([0.5,2],1),8*2).loop,
			\isRest, Pseq([
				1,0,
				//0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1/2 * Ptuple(Pwhite(0.7,1)!2),
		),
		
	])
)).play;
);

(
// calm
Pdef(\part, Pdef(\zedpart, 
	Pfindur(64,Ppar([
		//Pdef(\drums2),
		Pbind(
			\instrument, \default,
			\instrument, ~gen_transi_snappad.(1487,7),
			\note, Pseq([
				[0+12,4,7,21],
				[ 4,11,19 ],
				[ 5,12,21 ],
				[ 3,12,19 ],
			],inf),
			\octave, 4,
			\legato, 0.4,
			\timeScale, 4,
			\dur, 4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, ~gen_transi_snappad.(1470,7),
			\note, Pseq([
				0,4,7,9,12,19,
			],inf),
			\timeScale, 0.4,
			\hpf, 400,
			\octave, 5,
			\legato, 1,
			\dur, Pseq([
				//1,1,1,1,
				2,1/2,
				2,1/2,0.5,1,
				1/2,1/2,
				1/2,1/2,1.5,1.5,
			],inf),
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				[7,12],
				[12,16],
				[12,17],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.7) ],
			],inf),
			\octave, 6,
			\dur, 1/8,
			\lpf, Ptuple(Pwhite(100,1000.0)!2)* Pseg(Pseq([0.5,2],1),8*2).loop,
			\isRest, Pseq([
				1,0,
				//0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1/2 * Ptuple(Pwhite(0.7,1)!2),
			\out, BusDef(\pfx1, \audio),
		),
		Pbind(
			\instrument, \playersec_hlpf,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[59].value,
			\isRest, Pseq([
				//1,0,1,0, 1,0,1,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					0,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\speed, Pseg(Pseq([1,1,-1.midiratio],1),8).loop,
			\hpmix, 1,
			\hpf, 200,
			\dur, 1/4,
			\legato, 2,
			\gain, 0.1/1.5,
			\out, BusDef(\pfx1, \audio),
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\pfx1, \audio),
			\addAction, \addToTail,
			\delay, 2/3/~t,
			'delay', 1.0322580645161,
			\delay, PmodEnv(Pseq([1,2/3,4/3]/~t,1), 8).loop,
			'damp', 0.44961025295079,
			'size', 0.23205358143762,
			'diff', 2.2798134381265,
			'mix', 0.31034482758621,
			\lag, 0.0009,
			\dur, 1,
		),
		
		Ptpar([
			8,Pbind(
				\instrument, \playersec_hlpf,
				//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
				\bufnum, ~buflib.foley1[30].value,
				\isRest, Pseq([
					//1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\speed, Pseg(Pseq([1,1,-1.midiratio],1),8).loop,
				\hpmix, 1,
				\hpf, 200,
				\dur, 1/4,
				\legato, 2,
				\gain, 0.1/1.5,
				\out, BusDef(\pfx1, \audio),
			),
			16, Pbind(
				\instrument, \playersec_hlpf,
				\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
				\bufnum, ~buflib.foley1[307].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\speed, Pseg(Pseq([1,1,-1.midiratio],1),8).loop,
				\hpmix, 1,
				\hpf, 200,
				\dur, 1/4,
				\legato, 2,
				\gain, 0.1/1.5,
				\out, BusDef(\pfx1, \audio),
			),
			24, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[181].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Prand([
						Pseq([
							0,0,0,0, 0,0,0,0,
						],1),
						Prand([
							Pseq([
								1,0,1,0, 1,0,0,0,
							],1),
							Pseq([
								1,0,1,0, 1,0,0,1,
							],1),
							Pseq([
								1,0,1,0, 1,0,1,0,
							],1),
							Pseq([
								1,0,0,1, 1,0,1,1,
							],1),
						],1),
					],1),
				],inf).coin.not,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.11/2 * Pwhite(0.01,1,inf),
			),
			32,Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1173].value,
				\isRest, Pseq([
					1,0,0,0, 1,1,1,1,
					1,0,0,0, 1,1,1,1,
					1,0,0,0, 1,1,1,1,
					1,0,1,1, 1,0,0,1,

					1,0,0,0, 1,0,1,0,
					1,0,0,1, 1,0,1,0,
					1,0,0,0, 1,1,1,0,
					1,0,1,1, 1,0,0,1,
				]/2,inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.11/2 * Pwhite(0.01,1,inf),
			),
		])
	]))
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\hi1).loop,
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\pos, Pseq([
				0,1,1,1, 4,1,1,1, 8,1,1,1, 12,1,1,1,
				0,1,1,1, (4..15),
				(0..13),1,1,
				(0..15),
				0,1,2,0, 4,5,1,1, (8..15),
				(0..7), 3,3,3,7, 12,13,14,12,
				0,1,2,3, 4,5,1,2, (8..15),
			].flatten,inf)/8 / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8 * Pseq([
				Pwhite(0.8,1,1),
				Pwhite(0.6,1,1),
			],inf),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\hi1).loop,
		
		Pdef(\drums4),
		Pbind(
			\instrument, ~gen_transi_snappad.(1473,2),
			\note, Pseq([
				0,4,7,9,12,19,
			],inf),
			\timeScale, 0.4,
			\hpf, 40,
			\lpf, PmodEnv(Pseq([800,8000],1), 8*2).loop,
			\octave, 5,
			\legato, 1,
			\dur, Pseq([
				//1,1,1,1,
				2,1/2,
				2,1/2,0.5,1,
				1/2,1/2,
				1/2,1/2,1.5,1.5,
			],inf)*2,
			\amp, 0.1,
		),
		
	])
)).play;
);


Pdef(\greyhole).edit
Pdef(\greyhole).addHalo(\instrument, \fx_greyhole)
Pdef(\greyhole).presetCompileString.editorInsert
Pdef(\greyhole).asParamGroup.getPbindCompileString.editorInsert
(

Pbind(
	'dur', 1.0,
	'legato', 0.8,
	'out', 0,
	'inbus', nil,
	'fb', nil,
	'modDepth', nil,
	'modFreq', nil,
	'adsr', nil,
	'gain', nil,
)

);
(
Pdef('greyhole').setVal('delay', 1.0322580645161);
Pdef('greyhole').setVal('damp', 0.44961025295079);
Pdef('greyhole').setVal('size', 0.23205358143762);
Pdef('greyhole').setVal('diff', 2.2798134381265);
Pdef('greyhole').setVal('mix', 0.31034482758621);

);


///////////////////// arrange

(
Pdef(\part, Pdef(\hi1, 
	Pfindur(64,Ppar([
		//Pdef(\drums2),

		Pbind(
			\instrument, \default,
			\instrument, ~gen_transi_snappad.(1487,7),
			\note, Pseq([
				[0+12,4,7,21],
				[ 4,11,19 ],
				[ 5,12,21 ],
				[ 3,12,19 ],
			],inf),
			\octave, 4,
			\legato, 0.4,
			\timeScale, 4,
			\dur, 4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, ~gen_transi_snappad.(1470,7),
			\note, Pseq([
				0,4,7,9,12,19,
			],inf),
			\timeScale, 0.4,
			\hpf, 400,
			\octave, 5,
			\legato, 1,
			\dur, Pseq([
				//1,1,1,1,
				2,1/2,
				2,1/2,0.5,1,
				1/2,1/2,
				1/2,1/2,1.5,1.5,
			],inf),
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				[7,12],
				[12,16],
				[12,17],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.7) ],
			],inf),
			\octave, 6,
			\dur, 1/8,
			\lpf, Ptuple(Pwhite(100,1000.0)!2)* Pseg(Pseq([0.5,2],1),8*2).loop,
			\isRest, Pseq([
				1,0,
				//0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1/2 * Ptuple(Pwhite(0.7,1)!2),
			\out, BusDef(\pfx1, \audio),
		),
		Pbind(
			\instrument, \playersec_hlpf,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[59].value,
			\isRest, Pseq([
				//1,0,1,0, 1,0,1,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					0,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\speed, Pseg(Pseq([1,1,-1.midiratio],1),8).loop,
			\hpmix, 1,
			\hpf, 200,
			\dur, 1/4,
			\legato, 2,
			\gain, 0.1/1.5,
			\out, BusDef(\pfx1, \audio),
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\pfx1, \audio),
			\addAction, \addToTail,
			\delay, 2/3/~t,
			'delay', 1.0322580645161,
			\delay, PmodEnv(Pseq([1,2/3,4/3]/~t,1), 8).loop,
			'damp', 0.44961025295079,
			'size', 0.23205358143762,
			'diff', 2.2798134381265,
			'mix', 0.31034482758621,
			\lag, 0.0009,
			\dur, 1,
		),
		
		Ptpar([
			8,Pbind(
				\instrument, \playersec_hlpf,
				//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
				\bufnum, ~buflib.foley1[30].value,
				\isRest, Pseq([
					//1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\speed, Pseg(Pseq([1,1,-1.midiratio],1),8).loop,
				\hpmix, 1,
				\hpf, 200,
				\dur, 1/4,
				\legato, 2,
				\gain, 0.1/1.5,
				\out, BusDef(\pfx1, \audio),
			),
			16, Pbind(
				\instrument, \playersec_hlpf,
				\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
				\bufnum, ~buflib.foley1[307].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\speed, Pseg(Pseq([1,1,-1.midiratio],1),8).loop,
				\hpmix, 1,
				\hpf, 200,
				\dur, 1/4,
				\legato, 2,
				\gain, 0.1/1.5,
				\out, BusDef(\pfx1, \audio),
			),
			24, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[181].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Prand([
						Pseq([
							0,0,0,0, 0,0,0,0,
						],1),
						Prand([
							Pseq([
								1,0,1,0, 1,0,0,0,
							],1),
							Pseq([
								1,0,1,0, 1,0,0,1,
							],1),
							Pseq([
								1,0,1,0, 1,0,1,0,
							],1),
							Pseq([
								1,0,0,1, 1,0,1,1,
							],1),
						],1),
					],1),
				],inf).coin.not,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.11/2 * Pwhite(0.01,1,inf),
			),
			32,Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1173].value,
				\isRest, Pseq([
					1,0,0,0, 1,1,1,1,
					1,0,0,0, 1,1,1,1,
					1,0,0,0, 1,1,1,1,
					1,0,1,1, 1,0,0,1,

					1,0,0,0, 1,0,1,0,
					1,0,0,1, 1,0,1,0,
					1,0,0,0, 1,1,1,0,
					1,0,1,1, 1,0,0,1,
				]/2,inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.11/2 * Pwhite(0.01,1,inf),
			),
		])
	]))
)).play;
);

(
Pdef(\part, Pdef(\drums4, 
	Ppar([
		//Pdef(\hi1).loop,
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1078].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1078].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,1,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\gain, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1598].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1598].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\speed, Pseq([
				Pseq([
					1
				],8*8),
				Pseq([
					1
				],8*3),
				Pseq([
					1.5
				],8),
			],inf),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
					],4),
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,1,0,0, 1,0,0,1,
					Pseq([
						0,0,0,0, 0,0,0,0,
					],4),
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,0,1,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\gain, 0.11/4,
		),

		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\st, 71/2/60,
			\speed, Pseq([
				Pseq([
					Pn(1/2,3),1,
					Pn(1/2,3),2,
				],8).stutter(8),
				Pseq([
					Pn(1/2,3),1,
					Pn(1/2,3),2,
				],4).stutter(8*2),
			],inf) * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\pos, Pseq([
				Pseq([
					\r,\r,6,\r,
				],4),
				Pseq([
					Pseq([
						2,1,6,14,
					],6),
					\r,\r,6,\r,
					2,\r,6,\r,
				],inf),
			].flatten,inf)/8 / Pkey(\st),
			\isRest, Pseq([
				1,0.5,0.7,0.4,
			],inf).coin.not,
			\hpmix, 1,
			\lpmix, 1,
			\hpf, PmodEnv(Pseq([7000,10,2000,4,10000],1), 8*2).loop,
			\lpf, PmodEnv(Pseq([2000,10000,400],1), 9).loop,
			\dur, 1/8,
			\gain, 1/8 * Pseq([
				Pwhite(0.8,1/2,1),
				Pwhite(0.6,1,1),
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\st, 71/2/60,
			\speed, 
			Pseq([
				Pstep(Pseq([1],1),1),
				Pstep(Pseq([1],1),1),
				Pstep(Pseq([1],1),1),
				Pseg(Pseq([1/2,1],1),1),
				Pstep(Pseq([1],1),1),
				Pstep(Pseq([1/2],1),1),
			],inf) * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\pos, Pseq([
				\r,\r,\r,\r, \r,\r,\r,\r,
				\r,\r,\r,\r, \r,\r,\r,\r,
				\r,\r,\r,\r, \r,\r,\r,\r,
				4,4,4,4, 4,4,4,4,

				(0..7),
				4,8,12,14, 4,8,12,14,
				(0..15),
				(0..15),

				(0..15),
				\r,\r,\r,\r, (8..11),
				(0..15),
				(0..11), \r,\r,\r,\r,

				(0..7),
				4,8,12,14, 4,8,12,14,
				(0..15),
				(0..15),
				//\r,\r,\r,\r,
				//4,4, \r,\r,
				//\r,\r,\r,\r,
				//4,\r, 12,\r,
			].flatten,inf)/8 / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8/2 * Pseq([
				Pwhite(0.8,1,1),
				Pwhite(0.6,1,1),
			],inf),
		),
		
	])
)).play;
);

(
// chord draft 2
Pdef(\part, Pdef(\pintro, 
	Ppar([
		Pbind(
			\instrument, ~gen_transi_snappad.(449,7),
			\note, Pseq([
				[3,12,19],
				[4,11,19],
				[4,10,19],
				[4,9,19],
			],inf),
			\lpf, PmodEnv(Pseq([100,2000,10000],1), 8).loop,
			\hpf, PmodEnv(Pseq([400,200,10],1), 8).loop,
			\octave, 4,
			\timeScale, 4,
			\rel, 5,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);

(
// chord draft 3
// 4-note melody
Pdef(\part, Pdef(\pintro2, 
	Ppar([
		Pbind(
			\instrument, \default,
			\instrument, ~gen_transi_snappad.(1471,7),
			\note, Pseq([
				[0+12,4,7,21],
				[ 4,11,19 ],
				[ 5,12,21 ],
				[ 3,12,19 ],
			],inf),
			\octave, 4,
			\timeScale, 4,
			\dur, 4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, ~gen_transi_snappad.(1463,7),
			\note, Pseq([
				0,2,4,2,
				0,2,4,2,
				0,2,5,2,
				0,3,12,3,
			],inf),
			\timeScale, 0.4,
			\hpf, 400,
			\octave, 5,
			\legato, 1,
			\dur, Pseq([
				//1,1,1,1,
				2,1/2,0.5,1,
				2,1/2,0.5,1,
				1/2,1/2,1.5,1.5,
				1/2,1/2,1.5,1.5,
			],inf),
			\amp, 0.1 * Pseg(Pseq([0,Pn(1,inf)],inf),8),
		),
		
	])
)).play;
);

(
// calm
Pdef(\part, Pdef(\pcalm1, 
	Pfindur(32,Ppar([
		//Pdef(\drums2),
		Pbind(
			\instrument, \default,
			\instrument, ~gen_transi_snappad.(1487,7),
			\note, Pseq([
				[0+12,4,7,21],
				[ 4,11,19 ],
				[ 5,12,21 ],
				[ 3,12,19 ],
			],inf),
			\octave, 4,
			\legato, 0.4,
			\timeScale, 4,
			\dur, 4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, ~gen_transi_snappad.(1470,7),
			\note, Pseq([
				0,4,7,9,12,19,
			],inf),
			\timeScale, 0.4,
			\hpf, 400,
			\octave, 5,
			\legato, 1,
			\dur, Pseq([
				//1,1,1,1,
				2,1/2,
				2,1/2,0.5,1,
				1/2,1/2,
				1/2,1/2,1.5,1.5,
			],inf),
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				[7,12],
				[12,16],
				[12,17],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.7) ],
			],inf),
			\octave, 6,
			\dur, 1/8,
			\lpf, Ptuple(Pwhite(100,1000.0)!2)* Pseg(Pseq([0.5,2],1),8*2).loop,
			\isRest, Pseq([
				1,0,
				//0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1/2 * Ptuple(Pwhite(0.7,1)!2),
			\out, BusDef(\pfx1, \audio),
		),
		Pbind(
			\instrument, \playersec_hlpf,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[59].value,
			\isRest, Pseq([
				//1,0,1,0, 1,0,1,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					0,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\speed, Pseg(Pseq([1,1,-1.midiratio],1),8).loop,
			\hpmix, 1,
			\hpf, 200,
			\dur, 1/4,
			\legato, 2,
			\gain, 0.1/1.5,
			\out, BusDef(\pfx1, \audio),
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\pfx1, \audio),
			\addAction, \addToTail,
			\delay, 2/3/~t,
			'delay', 1.0322580645161,
			\delay, PmodEnv(Pseq([1,2/3,4/3]/~t,1), 8).loop,
			'damp', 0.44961025295079,
			'size', 0.23205358143762,
			'diff', 2.2798134381265,
			'mix', 0.31034482758621,
			\lag, 0.0009,
			\dur, 1,
		),
		
		Ptpar([
			8,Pbind(
				\instrument, \playersec_hlpf,
				//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
				\bufnum, ~buflib.foley1[30].value,
				\isRest, Pseq([
					//1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\speed, Pseg(Pseq([1,1,-1.midiratio],1),8).loop,
				\hpmix, 1,
				\hpf, 200,
				\dur, 1/4,
				\legato, 2,
				\gain, 0.1/1.5,
				\out, BusDef(\pfx1, \audio),
			),
			16, Pbind(
				\instrument, \playersec_hlpf,
				\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
				\bufnum, ~buflib.foley1[307].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\speed, Pseg(Pseq([1,1,-1.midiratio],1),8).loop,
				\hpmix, 1,
				\hpf, 200,
				\dur, 1/4,
				\legato, 2,
				\gain, 0.1/1.5,
				\out, BusDef(\pfx1, \audio),
			),
			24, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[181].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Prand([
						Pseq([
							0,0,0,0, 0,0,0,0,
						],1),
						Prand([
							Pseq([
								1,0,1,0, 1,0,0,0,
							],1),
							Pseq([
								1,0,1,0, 1,0,0,1,
							],1),
							Pseq([
								1,0,1,0, 1,0,1,0,
							],1),
							Pseq([
								1,0,0,1, 1,0,1,1,
							],1),
						],1),
					],1),
				],inf).coin.not,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.11/2 * Pwhite(0.01,1,inf),
			),
			32,Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1173].value,
				\isRest, Pseq([
					1,0,0,0, 1,1,1,1,
					1,0,0,0, 1,1,1,1,
					1,0,0,0, 1,1,1,1,
					1,0,1,1, 1,0,0,1,

					1,0,0,0, 1,0,1,0,
					1,0,0,1, 1,0,1,0,
					1,0,0,0, 1,1,1,0,
					1,0,1,1, 1,0,0,1,
				]/2,inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.11/2 * Pwhite(0.01,1,inf),
			),
			28, Pbind(
				\instrument, \grancruhp,
				\mbufnum, BufDef.mono('vipere/rocksteady.flac'),
				\pos, ~pmodenv.(Pseq([2.4,1]+3,1), 4).loop,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,2.4) ],
				],inf),
				\gfreq, 840,
				\hpf, PmodEnv(Pseq([10000,100],1), 4).loop,
				\gdur, 0.08,
				\isRest, Pseq([
					1,0,
				],1).coin.not,
				\dur, 2,
				\gain, 13.dbamp,
			)
		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, 0.53,
			\speed, 1.2,
			\legato, 1,
			\dur, Pseq([Rest(17.75),Pn(0.4,1)]),
			\gain, 1/8,
			\out, BusDef(\pfxecho, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\pfxecho, \audio),
			\addAction, \addToTail,
			\delay, 1/3/~t,
			\decay,8,
			\lag, 0.0009,
			\dur, 1,
		),
	]))
)).play;
);
(
Pdef(\part, Pdef(\pblock1, 
	Ppar([
		Pdef(\drums1),
		Pbind(
			\instrument, \default,
			\instrument, ~gen_transi_snappad.(1487,7),
			\note, Pseq([
				[0+12,4,7,21],
				[ 4,11,19 ],
				[ 5,12,21 ],
				[ 3,12,19 ],
			],inf),
			\octave, 4,
			\timeScale, 4,
			\dur, 4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, ~gen_transi_snappad.(1470,7),
			\note, Pseq([
				0,4,7,9,12,19,
			],inf),
			\timeScale, 0.4,
			\hpf, 400,
			\octave, 5,
			\legato, 1,
			\dur, Pseq([
				//1,1,1,1,
				2,1/2,
				2,1/2,0.5,1,
				1/2,1/2,
				1/2,1/2,1.5,1.5,
			],inf),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				[7,12],
				[12,16],
				[12,17],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.7) ],
			],inf),
			\octave, 6,
			\dur, 1/8,
			\lpf, Ptuple(Pwhite(100,1000.0)!2)* Pseg(Pseq([0.5,2],1),8*2).loop,
			\isRest, Pseq([
				1,0,
				//0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1/2 * Ptuple(Pwhite(0.7,1)!2),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\pblock2, 
	Ppar([
		Pdef(\hi1).loop,
		
		Pdef(\drums4),
		Pbind(
			\instrument, ~gen_transi_snappad.(1473,2),
			\note, Pseq([
				0,4,7,9,12,19,
			],inf),
			\timeScale, 0.4,
			\hpf, 40,
			\lpf, PmodEnv(Pseq([800,8000],1), 8*2).loop,
			\octave, 5,
			\legato, 1,
			\dur, Pseq([
				//1,1,1,1,
				2,1/2,
				2,1/2,0.5,1,
				1/2,1/2,
				1/2,1/2,1.5,1.5,
			],inf)*2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\pblock3, 
	Ppar([
		Pdef(\hi1).loop,
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\pos, Pseq([
				0,1,1,1, 4,1,1,1, 8,1,1,1, 12,1,1,1,
				0,1,1,1, (4..15),
				(0..13),1,1,
				(0..15),
				0,1,2,0, 4,5,1,1, (8..15),
				(0..7), 3,3,3,7, 12,13,14,12,
				0,1,2,3, 4,5,1,2, (8..15),
			].flatten,inf)/8 / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8 * Pseq([
				Pwhite(0.8,1,1),
				Pwhite(0.6,1,1),
			],inf),
		),
		
	])
)).play;
);

(
/////// main
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(16, Pdef(\pintro)),
		Pfindur(16, Pdef(\pintro2)),
		Pfindur(64, Pdef(\pblock1try2)),
		Pfindur(32, Pdef(\pcalm1)),
		Pfindur(64, Pdef(\pblock2try2)),
		Pfindur(32, Pdef(\pblock3)),
		
	])
)).play;
)

///////////// draft
// try to combine idea 1 and idea 2


(
// cut bass and drums
Pdef(\part, Pdef(\dark, 
	Pfindur(32,Ppar([
		Pseq([
			Pfindur(16,Pdef(\drums1)),
			Pfindur(8,Pdef(\drums2)),
			Pfindur(8,Pdef(\drums3)),
		],inf),

		// pad
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0+12,4,7,21],
				[ 4,11,19 ],
				[ 5,12,21 ],
				[ 3,12,19 ],
			],inf),
			\octave, 7,
			\dur, 4,
			\amp, 0.1/2,
			\out, BusDef(\sendbus3, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				100,
			],inf).stutter(4),
			'delay2', 0.000000543560101,
			'distamp', 9.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 470,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 2,
			\out, BusDef(\pfxm1, \audio),
		),
		Pmono(\chorusdist,
			\inbus, BusDef(\sendbus3, \audio, 2),
			\distamp, 20,
			\distpostamp, 1/1,
			\fb, 0.904,
			\distmix, 1,
			\delay, 0.00111,
			\modfreq, 4*~t * Pseq([1],inf),
			\modamp, 0.7001,
			\hpf, 500,
			\gain, 0.4,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\pfxm1, \audio),
		),
		Pmono(\fx_freqshift,
			\inbus, BusDef(\sendbus3),
			\shift, 1400,
			\mix, 1,
			\dur, 2,
			\out, BusDef(\pfxm1, \audio),
		),
		Pmono(\fx_lpf,
			\inbus, BusDef(\pfxm1, \audio),
			\addAction, \addToTail,
			\lpf, 
			Pseq([
				PmodEnv(Pseq([17,17,20000],1), 8),
				PmodEnv(Pseq([17,17,20000],1), 8),
				PmodEnv(Pseq([17,17,20000],1), 16),
			],inf),
			\mix, 1,
			\lag, 0.0010,
			\dur, 1,
		),

		// voice fx
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, 0.53,
			\speed, 1.2,
			\legato, 1,
			\dur, Pseq([Rest(24.75),Pn(0.4,1)]),
			\gain, 1/4,
			\out, BusDef(\pfx1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\pfx1, \audio),
			\addAction, \addToTail,
			\delay, 1/3/~t,
			\decay,5,
			\lag, 0.0009,
			\dur, 1,
		),

		// reverb meca noise

		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[449].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\legato, 4,
			\gain, 0.1,
			\out, BusDef(\pfx2, \audio),
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[49].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\legato, 4,
			\gain, 0.1,
			\out, BusDef(\pfx2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[315].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\legato, 4,
			\gain, 0.1,
			\out, BusDef(\pfx2, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\pfx2, \audio),
			\addAction, \addToTail,
			\mix, 0.5,
			\room, 3,
			\damp,0.4,
			\gain, 2,
			\lag, 0.0009,
			\dur, 1,
		),


		// bass
		Pseq([
			Pfindur(20,Pdef(\bass1)),
			Pfindur(12,Event.silent(4)),
		],inf),
		Ptpar([
			28, Pbind(
				\instrument, \grancruhp,
				\mbufnum, BufDef.mono('vipere/rocksteady.flac'),
				\pos, ~pmodenv.(Pseq([2.4,1]+3,1), 4).loop,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,2.4) ],
				],inf),
				\gfreq, 840,
				\hpf, PmodEnv(Pseq([10000,100],1), 4).loop,
				\gdur, 0.08,
				\isRest, Pseq([
					1,0,
				],1).coin.not,
				\dur, 2,
				\gain, 13.dbamp,
			)
		])

	]))
)).play;
)
(
Pdef(\part, Pdef(\light, 
	Ppar([
		Pdef(\drums1),
			Pbind(
				\instrument, \basicbass,
				\note, Pstep(Pseq([
					Pseq([
						0, 7-12,
						7-12, 0,
						0,7-12,
						3-12,0,
					],1),

						0, 7-12,
						7-12, 0,
					5-12, 0,
					7-12, 3-12,

					0, 0,
					7-12,0,
					5-12, 0,
					7-12, 3-12,
				],inf),2),
				\legato, Pseq([
					6,0,0,0, 0,0,1,0,
					4,0,0,0, 1,0,1,1,
					6,0,0,0, 0,0,1,0,
					0,0,2,0, 0,0,2,0,

					1,0,3,0, 0,0,2,0,
					0,0,2,0, 0,0,2,0,
					1,0,2,0, 1,0,2,0,
					0,0,2,0, 0,0,2,0,

					1,5,0,0, 0,0,1,0,
					0,0,2,0, 1,0,1,1,
					6,0,0,0, 0,0,1,0,
					0,0,2,0, 0,0,2,0,

					1,0,3,0, 0,0,2,0,
					0,0,2,0, 0,0,2,0,
					1,0,3,0, 0,0,2,0,
					0,0,2,0, 0,0,2,0,

				],inf)*0.9,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\dur, 1/2,
				\amp, 0.1,
				\out, BusDef(\fxbass, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\fxbass, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				//'delay', 0.0000600001231 * Pseq([
					//1,10,1/10
				//],inf).stutter(1),
				\delay, PmodEnv(Pseq([0.0000001,0.000002],1), 8, -3).loop,
				'delay2', 0.000000543560101,
				'distamp', 101.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 170,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 4,
			),
		Pbind(
			\instrument, \default,
			\instrument, ~gen_transi_snappad.(1487,7),
			\note, Pseq([
				[0+12,4,7,21],
				[ 4,11,19 ],
				[ 5,12,21 ],
				[ 3,12,19 ],
			],inf),
			\isRest, Pseq([
				0,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\octave, 4,
			\timeScale, 4,
			\legato, 0.5,
			\dur, 4,
			\amp, 0.1,
		),
		//Pbind(
			//\instrument, ~gen_transi_snappad.(1470,7),
			//\note, Pseq([
				//0,4,7,9,12,19,
			//],inf),
			//\timeScale, 0.4,
			//\hpf, 400,
			//\octave, 5,
			//\legato, 1,
			//\dur, Pseq([
				////1,1,1,1,
				//2,1/2,
				//2,1/2,0.5,1,
				//1/2,1/2,
				//1/2,1/2,1.5,1.5,
			//],inf),
			//\amp, 0.1,
		//),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				[7,12],
				[12,16],
				[12,17],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.7) ],
			],inf),
			\octave, 6,
			\dur, 1/8,
			\lpf, Ptuple(Pwhite(100,1000.0)!2)* Pseg(Pseq([0.5,2],1),8*2).loop,
			\isRest, Pseq([
				1,0,
				//0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1/2 * Ptuple(Pwhite(0.7,1)!2),
			\isRest, true,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\bridge, 
	Ppar([
		
	])
)).play;
);

Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(32,Pdef(\ppart1)),
		Pfindur(16,Pdef(\light)),
		Pfindur(32,Pdef(\pblock1)),
		
	])
)).play;

////////// draft
// explode pblock1


(
Pdef(\part, Pdef(\pblockdraft1, 
	Ppar([
		Pseq([
			Pfindur(8,Pdef(\drums1)),
			Pfindur(8,Pdef(\drumsdraft1)),
		],inf),
		Pbind(
			\instrument, \default,
			\instrument, Pseq([
				~gen_transi_snappad.(1487,7),
				~gen_transi_snappad.(1487,7),
				~gen_transi_snappad.(1487,7),
				~gen_transi_snappad.(1794,3),
			],inf),
			\note, Pseq([
				[0+12,4,7,21],
				[ 4,11,19 ],
				[ 5,12,21 ],
				[ 3,12,19 ],
			],inf),
			\octave, 4,
			\timeScale, 4,
			\dur, 4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, ~gen_transi_snappad.(1470,7),
			\note, Pseq([
				0,4,7,9,12,19,
			],inf),
			\timeScale, 0.4,
			\hpf, 400,
			\octave, 5,
			\legato, 1,
			\dur, Pseq([
				//1,1,1,1,
				2,1/2,
				2,1/2,0.5,1,
				1/2,1/2,
				1/2,1/2,1.5,1.5,
			],inf),
			\amp, 0.1,
		),
		Pseq([
			Pfindur(14,Pbind(
				\instrument, \sh101,
				\note, Pseq([
					[7,12],
					[12,16],
					[12,17],
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.4,0.7) ],
				],inf),
				\octave, 6,
				\dur, 1/8,
				\lpf, Ptuple(Pwhite(100,1000.0)!2)* Pseg(Pseq([0.5,2],1),8*2).loop,
				\isRest, Pseq([
					1,0,
					//0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1/2 * Ptuple(Pwhite(0.7,1)!2),
			)),
			Pfindur(2,Pbind(
				\instrument, \sh101,
				\note, Pseq([
					[7,12],
					//[12,16],
					//[12,17],
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.4,0.7) ],
				],inf),
				\octave, 6,
				\lpenvamt, 10,
				\dur, 1/8,
				\lpf, 1000,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0, 
					1,0,0,0, 0,0,1,1,
					//0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1/2 * Ptuple(Pwhite(0.7,1)!2),
			)),
		],inf),
		Ptpar([
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.foley1[56].value,
				//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\speed, 1,
				\dur, 1/8,
				\gain, 0.1*1,
				\out, BusDef(\pfxreverb, \audio),
			),
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.foley1[290].value,
				//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\speed, 1,
				\dur, 1/8,
				\gain, 0.1*1,
				\out, BusDef(\pfxreverb, \audio),
			),
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.foley1[59].value,
				//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\speed, 1,
				\dur, 1/8,
				\gain, 0.1*1,
				\out, BusDef(\pfxreverb, \audio),
			),
		]),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\pfxreverb, \audio),
			\addAction, \addToTail,
			\mix, 0.5,
			\room, 3,
			\damp,0.4,
			\gain, 2,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);
(
Pdef(\part, Pdef(\pblockdraft2, 
	Ppar([
		Pseq([
			Pfindur(8,Pdef(\drums1)),
			Pfindur(8,Pdef(\drumsdraft2)),
		],inf),
		Pbind(
			\instrument, Pseq([
				~gen_transi_snappad.(1487,2),
				~gen_transi_snappad.(1487,2),
				~gen_transi_snappad.(1487,7),
				~gen_transi_snappad.(1794,3),
			],inf),
			\note, Pseq([
				[0+12,4,7,21],
				[ 4,11,19 ],
				[ 5,12,21 ],
				[ 3,12,19 ],
			],inf),
			\octave, 4,
			\timeScale, 4,
			\legato, Pseg(Pseq([0.2,1],1),16).loop,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\dur, 4,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \mellowpad,
			\note, Pseq([
				//4,7,12,9,
				[4,12, 21],
				[-1,7],
				[5,12, 19],
				[3,12, 19],
			],inf).stutter(2),
			\octave, 5,
			\timeScale, 4,
			\dur, 2,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				Pser([
					-5,-5,4,-5,
				],8*2),
				Pser([
					-3,0,5,
				],8*2),
				0,0,0,0, 0,0,0,0,
				3,0,0,0, 0,0,3-12,0,
				//[4,12, 21],
				//[-1,7],
				//[5,12, 19],
				//[3,12, 19],
			],inf).stutter(1),
			\octave, 3,
			\timeScale, 4,
			\lpf, PmodEnv(Pseq([1000,400,8000],1), Pseq([12,4])).loop,
			\dur, 1/4,
			\isRest, Pseq([
				//0,1,
				1,0,0,1, 0,0,1,1,
				1,0,0,0, 0,0,1,0,
				1,0,0,1, 0,0,1,1,
				1,0,0,0, 1,0,1,0,

				0,0,0,1, 0,0,1,1,
				1,0,0,0, 0,0,1,0,
				1,0,0,1, 1,0,1,1,
				1,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1/2,
		),

		//Pbind(
			//\instrument, ~gen_transi_snappad.(1470,7),
			//\note, Pseq([
				//0,4,7,9,12,19,
			//],inf),
			//\timeScale, 0.4,
			//\hpf, 400,
			//\octave, 5,
			//\legato, 1,
			//\dur, Pseq([
				////1,1,1,1,
				//2,1/2,
				//2,1/2,0.5,1,
				//1/2,1/2,
				//1/2,1/2,1.5,1.5,
			//],inf),
			//\amp, 0.1,
		//),
		Pseq([
			Pfindur(14,Pbind(
				\instrument, \sh101,
				\note, Pseq([
					[7,12],
					[12,16],
					[12,17],
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.4,0.7) ],
				],inf),
				\octave, 6,
				\dur, 1/8,
				\lpf, Ptuple(Pwhite(100,1000.0)!2)* Pseg(Pseq([0.5,4],1),8*2).loop,
				\isRest, Pseq([
					Prand([
						Pseq([ 1,0,0,1, 0,0,1,0, ],1),
						Pseq([ 1,0,1,1, 0,0,1,0, ],1),
						//Pseq([ 1,0,0,1, 0,0,1,0, ],1),
						//Pseq([ 1,0,1,0, 0,1,0,0, ],1),
						//Pseq([ 1,0,0,1, 0,1,0,0, ],1),
						//Pseq([ 1,0,1,0, 1,0,1,0, ],1),
					],1),
					//0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1/2 * Ptuple(Pwhite(0.7,1)!2),
			)),
			Pfindur(2,Pbind(
				\instrument, \sh101,
				\note, Pseq([
					[7,12],
					//[12,16],
					//[12,17],
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.4,0.7) ],
				],inf),
				\octave, 6,
				\lpenvamt, 10,
				\dur, 1/8,
				\lpf, 1000,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,1,
					1,0,1,0, 1,0,1,0, 
					//0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1/2 * Ptuple(Pwhite(0.7,1)!2),
			)),
		],inf),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\pblockdraft3, 
	Ppar([
		Pseq([
			Pfindur(8,Pdef(\drums1)),
			Pfindur(8,Pdef(\drumsdraft3)),
		],inf),
		Pbind(
			\instrument, \default,
			\instrument, Pseq([
				~gen_transi_snappad.(2487,7),
				~gen_transi_snappad.(2487,7),
				~gen_transi_snappad.(2487,7),
				~gen_transi_snappad.(1794,3),
			],inf),
			\note, Pseq([
				[0+12,4,7,21],
				[ 4,11,19 ],
				[ 5,12,21 ],
				[ 3,12,19 ],
			],inf),
			\octave, 4,
			\timeScale, 4,
			\dur, 4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, ~gen_transi_snappad.(1470,7),
			\note, Pseq([
				9,12,19,
				0,4,7,
			],inf),
			\timeScale, 0.4,
			\hpf, 400,
			\octave, 5,
			\legato, 1,
			\dur, Pseq([
				//1,1,1,1,
				1,1/2,0.5,1.5,
				1/2,1/2,1.5,1.5,
				2,1/2,0.5,1,
				2,1/2,
				1/2,1/2,
			],inf),
			\amp, 0.1,
		),
		Pseq([
			Pfindur(14,Pbind(
				\instrument, \sh101,
				\note, Pseq([
					[7,12],
					[12,16],
					[12,17],
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.4,0.7) ],
				],inf),
				\octave, 6,
				\dur, 1/8,
				\lpf, Ptuple(Pwhite(100,1000.0)!2)* Pseg(Pseq([0.5,4],1),8*2).loop,
				\isRest, Pseq([
					Prand([
						Pseq([ 1,0,0,1, 0,0,1,0, ],1),
						Pseq([ 1,0,1,1, 0,0,1,0, ],1),
						//Pseq([ 1,0,0,1, 0,0,1,0, ],1),
						//Pseq([ 1,0,1,0, 0,1,0,0, ],1),
						//Pseq([ 1,0,0,1, 0,1,0,0, ],1),
						//Pseq([ 1,0,1,0, 1,0,1,0, ],1),
					],1),
					//0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1/2 * Ptuple(Pwhite(0.7,1)!2),
			)),
			Pfindur(2,Pbind(
				\instrument, \sh101,
				\note, Pseq([
					[7,12],
					//[12,16],
					//[12,17],
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.4,0.7) ],
				],inf),
				\octave, 6,
				\lpenvamt, 10,
				\dur, 1/8,
				\lpf, 1000,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0, 
					1,0,0,0, 0,0,1,1,
					//0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1/2 * Ptuple(Pwhite(0.7,1)!2),
			)),
		],inf),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\drumsdraft1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1078].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1598].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[181].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,0,0,
				1,0,1,0, 1,0,0,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,1, 1,0,1,1,
				1,0,1,0, 1,0,0,0,
				1,0,1,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1173].value,
			\isRest, Pseq([
				1,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,1,1,
				1,0,1,1, 1,0,0,1,

				1,0,0,0, 1,0,1,0,
				1,0,0,1, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/4,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\drumsdraft2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1078].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1598].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1598].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[181].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,0,0,
				1,0,1,0, 1,0,0,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,1, 1,0,1,1,
				1,0,1,0, 1,0,0,0,
				1,0,1,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1173].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\sustain, 0.1/4,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\drumsdraft3, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1078].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1598].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1598].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[181].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,0,0,
				1,0,1,0, 1,0,0,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,1, 1,0,1,1,
				1,0,1,0, 1,0,0,0,
				1,0,1,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1173].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\sustain, 0.1/4,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		)
	])
)).play;
);

(
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(16, Pdef(\pblockdraft1)),
		Pfindur(16, Pdef(\pblockdraft2)),
		Pfindur(16, Pdef(\pblockdraft3)),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\pblock1try2, 
	Pfindur(64,Ppar([
		Pseq([
			Pfindur(8,Pdef(\drums1)),
			Pfindur(8,Pdef(\drumsdraft1)),
			Pfindur(8,Pdef(\drums1)),
			Pfindur(8,Pdef(\drumsdraft2)),
			Pfindur(8,Pdef(\drums1)),
			Pfindur(8,Pdef(\drumsdraft3)),
		],inf),
		Pbind(
			\instrument, \default,
			\instrument, 
				Pstep(Pseq([
					~gen_transi_snappad.(1487,7),
					~gen_transi_snappad.(2484,1),
					~gen_transi_snappad.(1487,7),
				],inf), Pseq([32,12,20],inf)),
			\note, Pseq([
				[0+12,4,7,21],
				[ 4,11,19 ],
				[ 5,12,21 ],
				[ 3,12,19 ],
			],inf),
			\octave, 4,
			\timeScale, 4,
			\dur, 4,
			\amp, 0.1,
		),
		Pseq([
			Pfindur(32+8,
				Pbind(
					\instrument, ~gen_transi_snappad.(1470,7),
					\note, Pseq([
						0,4,7,9,12,19,
					],inf),
					\timeScale, 0.4,
					\hpf, 400,
					\octave, 5,
					\legato, 1,
					\dur, Pseq([
						//1,1,1,1,
						2,1/2,
						2,1/2,0.5,1,
						1/2,1/2,
						1/2,1/2,1.5,1.5,
					],inf),
					\amp, 0.1,
				),
			),
			Pfindur(32-8,
				Pbind(
					\instrument, ~gen_transi_snappad.(1171,7),
					\note, Pseq([
						9,12,14,19,
						0,4,7,
					],inf),
					\timeScale, 0.4,
					\hpf, 400,
					\octave, 5,
					\legato, 1,
					\dur, Pseq([
						Rest(8),
						Pseq([
							4,6,2,1/2,1/2,
							2,1/2,
							4,6,2,1/2,1/2,
							1,1,1/2,
							4,6,2,1/2,1/2,
							1/2,1/2,
							4,6,2,1/2,1/2,
							1/2,1/2,1.5,1.5,
							2,1/2,0.5,1,
						],inf),
					],inf),
					\amp, 0.1,
				),
			),
		],1),
		Pseq([
			Pfindur(24,Pbind(
				\instrument, \sh101,
				\note, Pseq([
					[7,12],
					[12,16],
					[12,17],
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.4,0.7) ],
				],inf),
				\octave, 6,
				\dur, 1/8,
				\lpf, Ptuple(Pwhite(100,1000.0)!2)* Pseg(Pseq([0.5,2],1),8*2).loop,
				\isRest, Pseq([
					1,0,
					//0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1/2 * Ptuple(Pwhite(0.7,1)!2),
			)),
			Pfindur(24,Pbind(
				\instrument, \sh101,
				\note, Pseq([
					[7,12],
					[12,16],
					[12,17],
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.4,0.7) ],
				],inf),
				\octave, 6,
				\dur, 1/8,
				\lpf, Ptuple(Pwhite(100,1000.0)!2)* Pseg(Pseq([0.5,2],1),8*2).loop,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					Prand([
						Pseq([ 1,0,0,1, 0,0,1,0, ],1),
						Pseq([ 1,0,1,1, 0,0,1,0, ],1),
					],inf),
				],inf).coin.not,
				\amp, 0.1/2 * Ptuple(Pwhite(0.7,1)!2),
			)),
		],1),
		Ptpar([
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.foley1[56].value,
				//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					Pseq([
						0,0,0,0, 0,0,0,0,
					],8),
				],inf).coin.not,
				\speed, 1,
				\dur, 1/8,
				\gain, 0.1*1,
				\out, BusDef(\pfxreverb, \audio),
			),
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.foley1[290].value,
				//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					Pseq([
						0,0,0,0, 0,0,0,0,
					],8),
				],inf).coin.not,
				\speed, 1,
				\dur, 1/8,
				\gain, 0.1*1,
				\out, BusDef(\pfxreverb, \audio),
			),
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.foley1[59].value,
				//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
					],8),
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\speed, 1,
				\dur, 1/8,
				\gain, 0.1*1,
				\out, BusDef(\pfxreverb, \audio),
			),
		]),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\pfxreverb, \audio),
			\addAction, \addToTail,
			\mix, 0.5,
			\room, 3,
			\damp,0.4,
			\gain, 2,
			\lag, 0.0009,
			\dur, 1,
		),
		
	]))
)).play;
);


(
Pdef(\part, Pdef(\pblock2try2, 
	Pfindur(64,Ppar([

		Pdef(\drums4),

		//// chords
		Pbind(
			\instrument, \default,
			\instrument, ~gen_transi_snappad.(1487,7),
			\note, Pseq([
				[0+12,4,7,21],
				[ 4,11,19 ],
				[ 5,12,21 ],
				[ 3,12,19 ],
			],inf),
			\octave, 4,
			\legato, 0.4,
			\timeScale, 4,
			\dur, 4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \beechord,
			\note, Pseq([
				[0+12,4,7,21],
				[ 4,11,19 ],
				[ 5,12,21 ],
				[ 3,12,19 ],
			],inf),
			\octave, 6,
			\isRest, Pseq([
				0,0,0,0,
				0,0,0,1,
				0,0,0,0,
				0,0,1,0,
			],inf).coin.not,
			\legato, 0.91,
			\adsr, Pseq([
				[ Env.adsr(3.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 4,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				[7,12],
				[12,16],
				[12,17],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.7) ],
			],inf),
			\octave, 6,
			\dur, 1/8,
			\lpf, Ptuple(Pwhite(100,1000.0)!2)* Pseg(Pseq([0.5,2],1),8*2).loop,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,1,0,
				//0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1/2 * Ptuple(Pwhite(0.7,1)!2),
			\out, BusDef(\pfx1, \audio),
		),
		Pbind(
			\instrument, \playersec_hlpf,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[59].value,
			\isRest, Pseq([
				//1,0,1,0, 1,0,1,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					0,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\speed, Pseg(Pseq([1,1,-1.midiratio],1),8).loop,
			\hpmix, 1,
			\hpf, 200,
			\dur, 1/4,
			\legato, 2,
			\gain, 0.1/1.5,
			\out, BusDef(\pfx1, \audio),
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\pfx1, \audio),
			\addAction, \addToTail,
			\delay, 2/3/~t,
			'delay', 1.0322580645161,
			\delay, PmodEnv(Pseq([1,2/3,4/3]/~t,1), 8).loop,
			'damp', 0.44961025295079,
			'size', 0.23205358143762,
			'diff', 2.2798134381265,
			'mix', 0.31034482758621,
			\lag, 0.0009,
			\dur, 1,
		),
		
		//// foley
		Ptpar([
			60, Pbind(
			   	\instrument, \wooshnoise,
			   	\degree, Pseq([0],1),
			   	\dur, 4,
			   	\amp, 0.05,
			   )
		]),
		Pbind(
			\instrument, \playersec_hlpf,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[449].value,
			\pos,0.2,
			\hpmix, 1,
			\hpf, Pwhite(1000.0,4000,inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
			],inf).coin.not,
			\dur, 1/4,
			\legato, 4,
			\gain, 0.075,
			\out, BusDef(\pfxreverb, \audio),
			//\isRest, true,
		),
		Ptpar([
			0,Pbind(
				\instrument, \playersec_hlpf,
				//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
				\bufnum, ~buflib.foley1[30].value,
				\isRest, Pseq([
					//1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					Pseq([
						0,0,0,0, 0,0,0,0,
					],8),
				],inf).coin.not,
				\speed, Pseg(Pseq([1,1,-1.midiratio],1),8).loop,
				\hpmix, 1,
				\hpf, 200,
				\dur, 1/4,
				\legato, 2,
				\gain, 0.1/1.5,
				\out, BusDef(\pfxreverb, \audio),
			),
			16, Pbind(
				\instrument, \playersec_hlpf,
				\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
				\bufnum, ~buflib.foley1[307].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\speed, Pseg(Pseq([1,1,-1.midiratio],1),8).loop,
				\hpmix, 1,
				\hpf, Pwhite(200.0,5000,inf),
				\dur, 1/4,
				\legato, 2,
				\gain, 0.1/1.5,
				\out, BusDef(\pfxreverb, \audio),
			),
			//// end hats
			24, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[181].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Prand([
						Pseq([
							0,0,0,0, 0,0,0,0,
						],1),
						Prand([
							Pseq([
								1,0,1,0, 1,0,0,0,
							],1),
							Pseq([
								1,0,1,0, 1,0,0,1,
							],1),
							Pseq([
								1,0,1,0, 1,0,1,0,
							],1),
							Pseq([
								1,0,0,1, 1,0,1,1,
							],1),
						],1),
					],1),
				],inf).coin.not,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.11/2 * Pwhite(0.01,1,inf),
			),
			32,Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1173].value,
				\isRest, Pseq([
					1,0,0,0, 1,1,1,1,
					1,0,0,0, 1,1,1,1,
					1,0,0,0, 1,1,1,1,
					1,0,1,1, 1,0,0,1,

					1,0,0,0, 1,0,1,0,
					1,0,0,1, 1,0,1,0,
					1,0,0,0, 1,1,1,0,
					1,0,1,1, 1,0,0,1,
				]/2,inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.11/2 * Pwhite(0.01,1,inf),
			),
			// lead
			32, Pbind(
				\instrument, ~gen_transi_snappad.(1463,7),
				\note, Pseq([
					0,2,4,2,
					0,2,4,2,
					0,2,5,2,
					0,3,12,3,
				],2),
				\timeScale, 0.4,
				\hpf, 400,
				\octave, 5,
				\legato, 1,
				\dur, Pseq([
					//1,1,1,1,
					2,1/2,0.5,1,
					2,1/2,0.5,1,
					1/2,1/2,1.5,1.5,
					1/2,1/2,1.5,1.5,
				],inf),
				\amp, 0.1 * Pseg(Pseq([0,Pn(1,inf)],inf),8),
			),
		]),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\pfxreverb, \audio),
			\addAction, \addToTail,
			\mix, 0.5,
			\room, 3,
			\damp,0.4,
			\gain, 2,
			\lag, 0.0009,
			\dur, 1,
		),
		

		// lead
		Pbind(
			\instrument, ~gen_transi_snappad.(1473,2),
			\note, Pseq([
				0,4,7,9,12,19,
			],inf),
			\timeScale, 0.4,
			\hpf, 40,
			\lpf, PmodEnv(Pseq([800,8000],1), 8*2).loop,
			\octave, 5,
			\legato, 1,
			\dur, Pseq([
				//1,1,1,1,
				2,1/2,
				2,1/2,0.5,1,
				1/2,1/2,
				1/2,1/2,1.5,1.5,
			],inf)*2,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \microchord,
			\note, Pseq([
				0
			],inf),
			\octave, 4,
			\chord, Pseq([
				[ [4,7,21] ],
				[ [ 4,11,19 ] ],
				[ [ 5,12,0 ] ],
				[ [ 3,12,19 ] ],
			],inf),
			\chordfreq, Pseq([
				[ [4,7,2] ],
				[ [ 4,3,9 ] ],
				[ [ 5,4,1 ] ],
				[ [ 3,10,7 ] ],
				[ [ 6,8,7 ] ],
			],inf)*~t / Pseq([5,1,8,3],inf).stutter(4),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\dur, 4,
			\amp, -26.dbamp,
		),
		
	]))
)).play;
);

(
SynthDef(\microchord, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num= 17;
	sig = SinOsc.ar(freq * \chord.kr([0,3,7]).midiratio * LFPulse.kr(\chordfreq.kr( [1,4,7]/8*~t )).range(1,2) * ( LFSaw.ar(freq * exprand(0.4,1!num) ) * 0.04 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.01,1!num)), amp).mean;
	Out.ar(out, sig);
}).add;
);
(
Ndef(\texture1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num= 17;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		0,0,0,0,
		0,-1,-1,-1,
	].midiratio,inf));
	sig = SinOsc.ar(freq * [0,3,7].midiratio* LFPulse.kr([1,4,7]/8*~t).range(1,2) * ( LFSaw.ar(freq * exprand(0.4,1!num) ) * 0.04 + 1 ));
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.01,1!num)), amp).mean;
	sig.debug("sig") * 5;
}).play;
);

(
SynthDef(\wooshnoise, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num= 70;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = EnvGen.kr(Env([0.01,2,0.01],[0.1,0.8]*10), 1);
	sig = SinOsc.ar(exprand(50.0,4000!num)  * ( SinOsc.ar(exprand(50.0,4000!num)) * lfo1 + 1 ));
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.1,1!num)), amp).mean;
	sig = HPF.ar(sig, 400);
	sig = LPF.ar(sig, 4400);

	sig1 = SinOsc.ar(exprand(40.0,100!12));
	lfo2 = EnvGen.kr(Env([0.1,2,1],[4.1,0.8]), 1);
	sig1 = Pan2.ar(sig1, pan, amp).mean * lfo2;
	sig = sig + sig1;
	sig = HPF.ar(sig, XLine.kr(15000,100,4/~t));
	sig = sig * 20.dbamp;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\zed, 
	Pbind(
		\instrument, \wooshnoise,
		\degree, Pseq([0],inf),
		\dur, 4,
		\amp, 0.1,
	)
).play;
);


Ndef(\fond1p2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num= 70;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = EnvGen.kr(Env([0.01,2,0.01],[0.1,0.8]*10), 1);
	sig = SinOsc.ar(exprand(50.0,4000!num)  * ( SinOsc.ar(exprand(50.0,4000!num)) * lfo1 + 1 ));
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.1,1!num)), amp).mean;
	sig = HPF.ar(sig, 400);
	sig = LPF.ar(sig, 2400);

	sig1 = SinOsc.ar(exprand(40.0,100!12));
	lfo2 = EnvGen.kr(Env([0.1,2,1],[4.1,0.8]), 1);
	sig1 = Pan2.ar(sig1, pan, amp).mean * lfo2;
	sig = sig + sig1;


	sig.debug("sig") * 5;
}).play;

(
SynthDef(\beechord, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num= 10;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = EnvGen.kr(Env([0.01,1/2,1],[10.1,10.8]), 1);
	lfo2 = EnvGen.kr(Env([0.4,0.01,1/2,1],[4,10.1,10.8]), 1);
	lfo3 = EnvGen.kr(Env([0.001,0.01,1/2,1],[0.4,4.1,30.8]), 1);
	sig = Blip.ar(
		freq 
			* Select.kr( LFNoise1.kr(1/1!num).exprange(0.1,1), [  exprand(0.98,1!num),1]) 
			,
		SinOsc.ar( SinOsc.ar(exprand(1/19,10!num)).range(1/3,10)/10  ).range(1, SinOsc.ar(exprand(1/30,10!num)).exprange(1,200) )
	);
	sig1 = sig;
	sig1 = LPF.ar(sig1, 800);
	sig1 = HPF.ar(sig1, 400);

	sig2 = sig;
	sig2 = RLPF.ar(sig2, 1200 * ( SinOsc.kr([ 1/2,1/3,1/5 ]) * 0.1 + 1 ), 0.1);
	sig2 = HPF.ar(sig2, 900);
	sig = ( sig1 * lfo2 ) + ( sig * lfo3 ) + ( sig2 * lfo1 );
	sig = sig.debug("sig") * 5;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.1,1!num)), amp).mean;
	Out.ar(out, sig);
}).add;
);

Pdef(\part).clear;
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \beechord,
			\note, Pseq([
				[0,3,7],
				[0,3,7]-1,
			],inf),
			\octave, 5,
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);
