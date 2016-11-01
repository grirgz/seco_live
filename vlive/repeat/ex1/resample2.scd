// use BufDef

//////////////////////// init

(
~t = 80/60;
TempoClock.default.tempo = ~t;
Ndef.defaultQuant = 4;
Pdef.defaultQuant = 4;


);

//////////////////////// record drum samples
	RandDelayNetwork(\multifb).make(\fx1, "6--", BusDef(\fx1, \audio));
	RandDelayNetwork(\multifb).make(\fx1, "5--", BusDef(\fx1, \audio));
	RandDelayNetwork(\multifbdel).make(\fx1, "5--", BusDef(\fx1, \audio));
	RandDelayNetwork(\default).make(\fx1, "5--", BusDef(\fx1, \audio));
	Ndef(\fx1).play;
	Ndef(\fx1).edit;

/////// kick
(
Ndef(\fx1).play;
Pdef(\recorder, Ppar([
	Pbind(
		\instrument, \recorder,
		\bufnum, BufDef(\kick, s.sampleRate * 4),
		\inbus, BusDef(\rec, \audio),
		\inbus, Ndef(\fx1).bus,
		\dur, Pseq([4],1),
		\amp, 0.1
	),
	Pbind(
		\instrument, \snapkick,
		\isRest, Pseq([
			Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],1),
		],inf).coin.not,
		\out, BusDef(\rec, \audio),
		\out, BusDef(\fx1, \audio),
		\dur, 1/8,
		\amp, 0.1
	),
	
])).play
)


/////// snare
Ndef(\fx1).edit
Ndef(\fx1).play;
Ndef(\lfo1).quant
(
Ndef(\fx1).set(\delay, Ndef(\lfo1, { Duty.kr(1/2/~t, 0, Dseq([
	0.4,0.002,0,0,
	0.002,0,0,0,
],inf)).lag2(1/2/~t); }))
)

Ndef(\fx1).play;
(
Pdef(\recorder_s, Ppar([
	Pbind(
		\instrument, \snapsnare,
		\isRest, Pseq([
			Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],1),
		],inf).coin.not,
		\out, BusDef(\rec, \audio),
		\out, BusDef(\fx1, \audio),
		\dur, 1/8,
		\amp, 0.1
	),
	
])).play;

Pdef(\recorder, Ppar([
	Pbind(
		\instrument, \recorder,
		\bufnum, BufDef(\snare, s.sampleRate * 4),
		\inbus, BusDef(\rec, \audio),
		\inbus, Ndef(\fx1).bus,
		\dur, Pseq([4],1),
		\amp, 0.1
	),
	
])).play
)

BufDef(\snare).play

/////// hat
(
Ndef(\fx1).play;
Pdef(\recorder, Ppar([
	Pbind(
		\instrument, \recorder,
		\bufnum, BufDef(\hat, s.sampleRate * 4),
		\inbus, BusDef(\rec, \audio),
		\inbus, Ndef(\fx1).bus,
		\dur, Pseq([4],1),
		\amp, 0.1
	),
		Pmono(\snaphihat,
			\dur, 1/8,
			\itrig, Pseq([
				1,1,1,1,
			],inf),
			//\out, 0,
			\rel, Pseq([
				8,0,1,0, 1,0,1,0,
				16,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,4,0,
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,4,0,
				44,0,0,0, 0,0,1,0,
			],inf)/20,
			\level, Pseq([1,1.2,1.1,1.4],inf).stutter(4),
			\amp, Pkey(\amp) * Pseq([
				1,0.3,0.5,0.3,
			],inf),
			\isRest, Pkey(\rel).collect(_ <= 0),
			\legato, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],15),
				1,1,1,1, 1,1,1,0.99,
			],inf),
			\amp, 0.1/2,
			\out, BusDef(\fx1, \audio),
		),
	
])).play
)

//////////////////////// record drum samples ROUND 2
	RandDelayNetwork(\multifb).make(\fx1, "6--", BusDef(\fx1, \audio));
	RandDelayNetwork(\multifb).make(\fx1, "5--", BusDef(\fx1, \audio));
	RandDelayNetwork(\default).make(\fx1, "5--", BusDef(\fx1, \audio));
	Ndef(\fx1).play;
	Ndef(\fx1).edit;

	RandDelayNetwork(\multifbdel).make(\fx1, "5--", BusDef(\fx1, \audio));
	(
	Ndef(\fx1).put(500, \filter -> { arg in;
		var sig = in;
		FreeVerb2.ar(sig[0], sig[1], \reverbmix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	})
	)
/////// kick
(
Ndef(\fx1).play;
Pdef(\recorder, Ppar([
	Pbind(
		\instrument, \recorder,
		\bufnum, BufDef(\kick2, s.sampleRate * 4),
		\inbus, BusDef(\rec, \audio),
		\inbus, Ndef(\fx1).bus,
		\dur, Pseq([4],1),
		\amp, 0.1
	),
	Pbind(
		\instrument, \snapkick,
		\isRest, Pseq([
			Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],1),
		],inf).coin.not,
		\out, BusDef(\rec, \audio),
		\out, BusDef(\fx1, \audio),
		\dur, 1/8,
		\amp, 0.1
	),
	
])).play
)


/////// snare
Ndef(\fx1).edit
Ndef(\fx1).play;
(
Ndef(\fx1).play;
Pdef(\recorder_s, Ppar([
	Pbind(
		\instrument, \snapsnare,
		\isRest, Pseq([
			Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],1),
		],inf).coin.not,
		\out, BusDef(\rec, \audio),
		\out, BusDef(\fx1, \audio),
		\dur, 1/8,
		\amp, 0.1
	),
	
])).play;

Pdef(\recorder, Ppar([
	Pbind(
		\instrument, \recorder,
		\bufnum, BufDef(\snare2, s.sampleRate * 4),
		\inbus, BusDef(\rec, \audio),
		\inbus, Ndef(\fx1).bus,
		\dur, Pseq([4],1),
		\amp, 0.1
	),
	
])).play
)

/////// hat
(
Ndef(\fx1).play;
Pdef(\recorder, Ppar([
	Pbind(
		\instrument, \recorder,
		\bufnum, BufDef(\hat2, s.sampleRate * 4),
		\inbus, BusDef(\rec, \audio),
		\inbus, Ndef(\fx1).bus,
		\dur, Pseq([4],1),
		\amp, 0.1
	),
		Pmono(\snaphihat,
			\dur, 1/8,
			\itrig, Pseq([
				1,1,1,1,
			],inf),
			//\out, 0,
			\rel, Pseq([
				8,0,1,0, 1,0,1,0,
				16,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,4,0,
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,4,0,
				44,0,0,0, 0,0,1,0,
			],inf)/20,
			\level, Pseq([1,1.2,1.1,1.4],inf).stutter(4),
			\amp, Pkey(\amp) * Pseq([
				1,0.3,0.5,0.3,
			],inf),
			\isRest, Pkey(\rel).collect(_ <= 0),
			\legato, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],15),
				1,1,1,1, 1,1,1,0.99,
			],inf),
			\amp, 0.1/2,
			\out, BusDef(\fx1, \audio),
		),
	
])).play
)



//////////////////////// make first loop

	RandDelayNetwork(\multifb).make(\fx1, "4--", BusDef(\fx1, \audio));
	Ndef(\fx1).play;
	Ndef(\fx1).edit;

	(
		Pdef(\smpdrum1, Ppar([
			Pbind(
				\instrument, \player,
				\bufnum, BufDef(\kick),
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 2,
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, BufDef(\kick),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0.21, 1,0,0.3,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\pos, 0.02,
				\legato, 1,
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, BufDef(\snare),
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\legato, Pseq([8,8,2,8,2,2],inf).stutter(16),
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, BufDef(\snare),
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,1,0,0,
				],inf).coin.not,
				\pos, 0.04,
				\dur, 1/8,
				\legato, 1,
				\amp, 0.1
			),
			Pbind(
				\instrument, \player,
				\bufnum, BufDef(\snare),
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\pos, 0.01,
				\dur, 1/8,
				\legato, 1,
				\amp, 0.1
			),

			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\hat),
				\speed, 0.6,
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					1,0, 1,0, 1,0, 1,0,
					0,0, 0,0, 1,0, 1,0,
					0,1, 1,0, 1,0, 1,0,
					0,0, 0,0, 1,0, 1,0,
					1,0, 1,0, 1,0.5, 1,0,
					0,0, 0,0, 1,0, 1,0,
					0.61,1, 1,0, 0,1, 1,0,
					0,0, 0,0, 1,0, 1,0,
				],inf).coin.not,
				\pos, 0.01/~t + Pseq([1.1,0.1,0.2,0],inf).stutter(2),
				\dur, 1/8,
				\legato, Pseq([
					1/2,1/4,1/4,1/4,
					1/2,1/4,1,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,

					1/2,1/4,2,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
				],inf),
				\amp, 0.1
			),

	]));
	Pdef(\smpdrum1).set(\out, BusDef(\fx1));
	//Pdef(\drum1).set(\out, 0);
	Pdef(\main, Pdef(\smpdrum1)).play;
	Ndef(\fx1).play;
	)


	RandDelayNetwork(\multifb).make(\fx1, "4--", BusDef(\fx1, \audio));
	Ndef(\fx1).play;
	Ndef(\fx1).edit;


////////////////: MULTI PASS



(
Ndef(\fx1).play;
Pdef(\recorder, Ppar([
	Pbind(
		\instrument, \recorder,
		\bufnum, BufDef(\kick, s.sampleRate * 4),
		\inbus, BusDef(\rec, \audio),
		\inbus, Ndef(\fx1).bus,
		\dur, Pseq([4],1),
		\amp, 0.1
	),
	Pbind(
		\instrument, \snapkick,
		\isRest, Pseq([
			Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],1),
		],inf).coin.not,
		\out, BusDef(\rec, \audio),
		\out, BusDef(\fx1, \audio),
		\dur, 1/8,
		\amp, 0.1
	),
	
])).play
)

(
Ndef(\fx1).play;
Pdef(\recorder, Ppar([
	Pbind(
		\instrument, \recorder,
		\bufnum, BufDef(\kick_p2, s.sampleRate * 4),
		\inbus, BusDef(\rec, \audio),
		\inbus, Ndef(\fx1).bus,
		\dur, Pseq([4],1),
		\amp, 0.1
	),
	Pbind(
		\instrument, \player,
		\bufnum, BufDef(\kick),
		\out, BusDef(\fx1),
		\dur, 4,
		\legato, 2,
		\gain, 1/4,
	),
	
])).play
)

(
Ndef(\fx1).play;
Pdef(\recorder, Ppar([
	Pbind(
		\instrument, \recorder,
		\bufnum, BufDef(\kick_p3, s.sampleRate * 4),
		\inbus, BusDef(\rec, \audio),
		\inbus, Ndef(\fx1).bus,
		\dur, Pseq([4],1),
		\amp, 0.1
	),
	Pbind(
		\instrument, \player,
		\bufnum, BufDef(\kick_p2),
		\out, BusDef(\fx1),
		\dur, 4,
		\legato, 2,
		\gain, 1/4,
	),
	
])).play
)
