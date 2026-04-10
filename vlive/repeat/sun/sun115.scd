// copy wicked
(
~t = 139/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("sndlib/fxsimple.scd");
)

(
SynthDef(\sdkick, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1|
	var env0, env1, env1m;
	var sig;

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
			\instrument, \sdkick,
			\env0, [ Env.new([0, 1, 0.5, 0], [0.005, 0.16, 0.01], [-4, -2, -4]) ],
			\env1, [ Env([610, 57, 45], [0.045, 0.19], [-4, -5]) ],
			\dur, 1/8,
			\isRest, Pseq([
				Pseq([
					1,0,1,0,
				],7),
				Pseq([
					1,0,1,1,
				],1),
			],inf).coin.not,
			\freqpan, 0.2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				4,
			],inf),
			\octave, 2,
			\lpf, 1880,
			\rq, 0.4,
			\envamt, 4,
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.5,0.1,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 1,
			\dur, 1/8,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1618].value,
			\bufnum, ~buflib.hat[790].value,
			\bufnum, ~buflib.hat[434].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1618].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[0].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
					Pseq([
						0,0,0,0, 1,0,0,0,
					],7),
					0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[254].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.4) ],
			],inf),
			//\legato, 8,
			\dur, 1/8,
			\gain, 0.41,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1624].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),

	])
)).play;
);

(
Pdef(\crash1, Pbind(
	\instrument, \playersec,
	\bufnum, ~buflib.hat[254].value,
	\bufnum, ~buflib.hat[1345].value,
	//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
	],1).coin.not,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,1,4.4) ],
	],inf),
	//\legato, 8,
	\dur, 1/8,
	\gain, 0.11,
));
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\crash1)
	])
)).play;
);

(
// intro
Pdef(\part, Pdef(\intro, 
	Ptpar([
		0, Ppar([

			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/kaspi.flac'),
				\pos, 1.5,
				\legato, 0.6,
				\dur, 1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\isRest, Pseq([
					1,0,
				],4).coin.not,
				\gain, 1/2,
				\out, BusDef(\ifxecho, \audio),
			),
			Pmono(\fx_echo,
				\inbus, BusDef(\ifxecho, \audio),
				\out, BusDef(\ifxverb, \audio),
				\addAction, \addToTail,
				\delay, 1.5/4/~t,
				\lpf, 1600,
				\pfmix, 1,
				\decay, 3,
				\mix, 0.2,
				\lag, 0.0009,
				\dur, 1,
			),
			Pmono(\fx_freeverb2,
				\inbus, BusDef(\ifxverb, \audio),
				\addAction, \addToTail,
				\lag, 0.0009,
				\dur, 1,
			),
		]),
		3.5, Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/kaspi.flac'),
				\pos, 1.7,
				\legato, 0.6,
				\dur, 1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\isRest, Pseq([
					1,0,
				],1).coin.not,
				\gain, 1/2,
			),
			Pbind( // reverse crash
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1345].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],1).coin.not,
				\dur, 1/8,
				\pos, 1/2/~t,
				\speed, -1,
				\legato, 8,
				\gain, 0.21,
			),
			
		]),
		4, Ppar([
			Pbind(
				\instrument, \sdkick,
				\env0, [ Env.new([0, 1, 0.5, 0], [0.005, 0.16, 0.01], [-4, -2, -4]) ],
				\env1, [ Env([610, 57, 45], [0.045, 0.19], [-4, -5]) ],
				\dur, 1/8,
				\isRest, Pseq([
					Pseq([
						1,0,1,0,
					],7),
					1,0,1,1,
				],inf).coin.not,
				\freqpan, 0.2,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					4,
				],inf),
				\octave, 2,
				\lpf, 1880,
				\rq, 0.4,
				\envamt, 4,
				\lpadsr, Pseq([
					[ Env.adsr(0.01,0.5,0.1,0.1) ],
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, 1,
				\dur, 1/8,
				\isRest, Pseq([
					0,1,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind( // crash
				\instrument, \playersec,
				\bufnum, ~buflib.hat[254].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],1).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,1.4) ],
				],inf),
				//\legato, 8,
				\dur, 1/8,
				\gain, 0.41,
			),
			
		],inf),
		12, Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1618].value,
				\bufnum, ~buflib.hat[790].value,
				\bufnum, ~buflib.hat[434].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,1,0,0,
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11/2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1618].value,
				\isRest, Pseq([
					0,0,1,0,
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11/2,
			),
			Pdef(\crash1),
		]),
		20, Ppar([
			
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.clap[0].value,
				//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 1,0,0,0,
					],7),
					0,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1624].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,1,0,1,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11,
			),
			Pdef(\crash1),
		]),

		
	])
)).play;
);

(
Pdef(\part, Pdef(\basspart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/kaspi.flac'),
			\pos, 1.5,
			\legato, 0.6,
			\dur, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\gain, 1/2,
			\out, BusDef(\ifxverb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifxverb, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				6, 5, 5, 5, 5, 5, 7, 7, 7, 6, 6, 7, 6, 6, 5, 6,
			],inf),
			\octave, Pseq([
				2, 2, 3, 2, 2, 3, 3, 2, 1, 2, 2, 1, 3, 3, 1, 2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\envamt, PmodEnv(Pseq([1,800,201,4],1), 8).loop,
			\lpf, 10,
			\rq, 0.4,
			\dur, 1/8/2,
			\amp, 0.1,
		),
		//Pbindef(\tb301)
	])
)).play;
);

///////////// bass part
(
// bass
Pdef(\part, Pdef(\bass1, 
	Pbind(
		\instrument, \sh101,
		\note, Pseq([
			6, 5, 5, 5, 5, 5, 7, 7, 7, 6, 6, 7, 6, 6, 5, 6,
		],inf),
		\octave, Pseq([
			2, 2, 3, 2, 2, 3, 3, 2, 1, 2, 2, 1, 3, 3, 1, 2,
		],inf),
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.1) ],
		],inf),
		\envamt, Pseg(Pseq([80,200,801,4],1), 8).loop,
		\lpf, 10,
		\rq, Pseg(Pseq([0.4,0.5,0.3,0.7],inf),7),
		\dur, 1/8/2,
		\amp, 0.1,
	),
		
)).play;
);

(
Pdef(\part, Pdef(\bass1, 
	Pbind(
		\instrument, \sh101,
		\note, Pseq([
			6, 5, 5, 5, 5, 5, 7, 7, 7, 6, 6, 7, 6, 6, 5, 6,
		],inf),
		\octave, Pseq([
			Ppatlace(  [
				2, 2, 3, 2, 2, 3, 3, 2, 1, 2, 2, 1, Pseq([2,3,1,3],inf).stutter(4),3 , 1, 2,
			],inf )
		],inf),
		\octave, Pseq([

			Ppatlace( 
				16.collect { arg idx;
					Prand([
						1,2,3,4,
						1,2,3,
						1,2,3,
						2, 2,
					],inf).stutter(idx+4*2)
				};
			,inf )
		],inf),
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.1) ],
		],inf),
		\envamt, Pseg(Pseq([80,200,801,4],1), 8).loop,
		\lpf, 10,
		\rq, Pseg(Pseq([0.4,0.5,0.3,0.7],inf),7),
		\dur, 1/8/2,
		\amp, 0.1,
	),
		
)).play;
);

(
Pdef(\part, Pdef(\bass1, 
	Pbind(
		\instrument, \sh101,
		\note, Pseq([
			6, 5, 5, 5, 5, 5, 7, 7, 7, 6, 6, 7, 6, 6, 5, 6,
		],inf),
		\note, Pseq([

			Ppatlace( 
				16.collect { arg idx;
					Prand([
						4,3,7
					],inf).stutter(idx+4*2)
				};
			,inf )
		],inf),
		\octave, Pseq([
			Ppatlace(  [
				2, 2, 3, 2, 2, 3, 3, 2, 1, 2, 2, 1, 3,3 , 1, 2,
			],inf )
		],inf),
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.1) ],
		],inf),
		\envamt, Pseg(Pseq([80,200,801,4],1), 8).loop,
		\lpf, 10,
		\rq, Pseg(Pseq([0.4,0.5,0.3,0.7],inf),7),
		\dur, 1/8/2,
		\amp, 0.1,
	),
		
)).play;
);

(
Pdef(\part, Pdef(\bass1, 
	Pbind(
		\instrument, \sh101,
		\note, Pseq([

			Ppatlace( 
				16.collect { arg idx;
					Prand([
						4,8,5
					],inf).stutter(idx+4*2)
				};
			,inf )
		],inf),
		\octave, Pseq([

			Ppatlace( 
				16.collect { arg idx;
					Prand([
						1,2,3,4,
						1,2,3,
						1,2,3,
						2, 2,
					],inf).stutter(idx+4*2)
				};
			,inf )
		],inf),
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.1) ],
		],inf),
		\envamt, Pseg(Pseq([80,200,801,14],1), 8,\exp).loop,
		\lpf, 10,
		\rq, Pseg(Pseq([0.4,0.5,0.3,0.7],inf),7,\exp),
		\dur, 1/8/2,
		\amp, 0.1,
	),
		
)).play;
);

(
// basspart
Pdef(\part, Pdef(\basspart, 
	Ptpar([
		0, Ppar([

			Pbind(
				\out, BusDef(\comp, \audio),
			)<> Pdef(\bass1),
			Pmono(\fx_sidechain,
				\inbus, BusDef(\comp, \audio),
				\sideinbus, BusDef(\sideinbus, \audio),
				\cpt, 0.051,
				\pregain, 1,
				\cpabove, 0.01,
				\cpbelow, 1,
				\cpclamp, 0.01,
				\cprelax, 0.1,
				\gain, 1,
				\dur, 1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/kaspi.flac'),
				\pos, 1.5,
				\legato, 0.6,
				\dur, 1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\isRest, Pseq([
					1,0,
				],4).coin.not,
				\gain, 1/2,
				\out, BusDef(\ifxecho, \audio),
			),
			Pmono(\fx_echo,
				\inbus, BusDef(\ifxecho, \audio),
				\out, BusDef(\ifxverb, \audio),
				\addAction, \addToTail,
				\delay, 1.5/4/~t,
				\lpf, 1600,
				\pfmix, 1,
				\decay, 3,
				\mix, 0.2,
				\lag, 0.0009,
				\dur, 1,
			),
			Pmono(\fx_freeverb2,
				\inbus, BusDef(\ifxverb, \audio),
				\addAction, \addToTail,
				\lag, 0.0009,
				\dur, 1,
			),
			Pdef(\crash1),
		]),
		3.5, Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/kaspi.flac'),
				\pos, 1.7,
				\legato, 0.6,
				\dur, 1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\isRest, Pseq([
					1,0,
				],1).coin.not,
				\gain, 1/2,
			),
			Pbind( // reverse crash
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1345].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],1).coin.not,
				\dur, 1/8,
				\pos, 1/2/~t,
				\speed, -1,
				\legato, 8,
				\gain, 0.21,
			),
			
		]),
		4, Ppar([
			Pbind(
				\instrument, \sdkick,
				\env0, [ Env.new([0, 1, 0.5, 0], [0.005, 0.16, 0.01], [-4, -2, -4]) ],
				\env1, [ Env([610, 57, 45], [0.045, 0.19], [-4, -5]) ],
				\dur, 1/8,
				\isRest, Pseq([
					Pseq([
						1,0,1,0,
					],7),
					1,0,1,1,
				],inf).coin.not,
				\freqpan, 0.2,
				\amp, 0.1,
				\out, BusDef(\kicktrack, \audio),
			),
			Pmono(\simpletrackmixer,
				\inbus, BusDef(\kicktrack,\audio),
				\pregain, 1,
				\postgain, 1,
				\delay, 0,
				\send0, 1,
				\sendbus0, BusDef(\sideinbus, \audio, 2),
				\dur, 1,
			),
			Pbind( // crash
				\instrument, \playersec,
				\bufnum, ~buflib.hat[254].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],1).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,1.4) ],
				],inf),
				//\legato, 8,
				\dur, 1/8,
				\gain, 0.41,
			),
			
		],inf),
		12, Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1618].value,
				\bufnum, ~buflib.hat[790].value,
				\bufnum, ~buflib.hat[434].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,1,0,0,
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11/2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1618].value,
				\isRest, Pseq([
					0,0,1,0,
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11/2,
			),
			Pdef(\crash1),
		]),
		20, Ppar([
			
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.clap[0].value,
				//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 1,0,0,0,
					],7),
					0,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1624].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,1,0,1,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11,
			),
			Pdef(\crash1),
		]),

		
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
			Pbind(
				\instrument, \sdkick,
				\env0, [ Env.new([0, 1, 0.5, 0], [0.005, 0.16, 0.01], [-4, -2, -4]) ],
				\env1, [ Env([610, 57, 45], [0.045, 0.19], [-4, -5]) ],
				\dur, 1/8,
				\isRest, Pseq([
					Pseq([
						1,0,1,0,
					],7),
					1,0,1,1,
				],inf).coin.not,
				\freqpan, 0.2,
				\amp, 0.1,
			),
	])
)).play;
);
Pbindef(\tb301).edit

// struct: 
// intro wicked:
// intro kick: 8*4 kicks, 4 kick per beat, 8 beats

//////// main

(
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(32, Pdef(\intro)),
		Pfindur(32, Pdef(\basspart)),
		
	])
)).play;
)


//////////////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind( // crash
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1345].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 8,
			\gain, 0.11,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind( // reverse crash
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1345].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\speed, -1,
			\pos, 1/~t,
			\legato, 8,
			\gain, 0.11,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1624].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[254].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.4) ],
			],inf),
			//\legato, 8,
			\dur, 1/8,
			\gain, 0.21,
		),
	])
)).play;
);

////////// expe with kicks



//////////////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\env1, [ Env([110, 42, 29], [0.025, 0.19], [-4, -5]) ],
			\dur, 1/4,
			\lpf, PmodEnv(Pseq([100,10000],1), 8,\exp).loop,
			\freqpan, 2,
			\freqpan, PmodEnv(Pseq([0.1,14],1), 8,\exp).loop,
			\amp, 0.1,
		),

	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\env1, [ Env([210, 22, 29], [0.025, 0.29], [-4, -5]) ],
			\dur, 1,
			\freqpan, 2,
			\fratio, 3,
			\amp, 0.1,
		),

	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\env1, PpatEnv([ Pseg(Pseq([100,1001],inf),8,\exp), 52, 31], [0.015, 0.09], [-4, -5]),
			\dur, 1/4,
			\freqpan, 2,
			\fratio, 3,
			\amp, 0.1,
		),

	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\env1, PpatEnv([ 
				Pseg(Pseq([100,801],inf),20,\exp), 
				Pseg(Pseq([10,81],inf),50,\exp), 
				Pseg(Pseq([10,81],inf),70,\exp), 
			], [
				Pseg(Pseq([0.01,0.045],inf),16), 
				Pseg(Pseq([0.1,0.45],inf),33)
			], [-4, -5]).trace,
			\dur, 1/4,
			\freqpan, 2,
			\fratio, 3,
			\timeScale, 14,
			\lpf, Pseg(Pseq([100,10000],1), 28,\exp).loop,
			\freqpan, 2,
			\freqpan, Pseg(Pseq([0.1,14],1), 58,\exp).loop,
			\fratio, Pseg(Pseq([0.1,14],1), 78,\exp).loop,
			\amp, 0.1,
		),

	])
)).play;
);
