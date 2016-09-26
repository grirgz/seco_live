

	RandDelayNetwork(\multifb).make(\fx1, "4--", BusDef(\fx1, \audio));
	RandDelayNetwork(\multifb).make(\fx1, "5--", BusDef(\fx1, \audio));
	Ndef(\fx1).play;
	Ndef(\fx1).edit;

	RandDelayNetwork(\multifb).make(\fx2, "4--", BusDef(\fx2, \audio));
	Ndef(\fx2).play;
	Ndef(\fx2).edit;

	Ndef(\fx1).put(100, nil)
	Ndef(\fx2).put(100, nil)

	
	RandDelayNetwork(\multifb).getPresetCompileString(\fx1).pbcopy.vimpbpaste

	RandDelayNetwork(\multifb).getPresetCompileString(\fx2).pbcopy.vimpbpaste

//////////////////////// init

(
~t = 80/60;
TempoClock.default.tempo = ~t;
Ndef.defaultQuant = 4;
Pdef.defaultQuant = 4;


~bufs = ~bufs ? ();
[\kick, \snare, \hat, \loop].do ({ arg x; 
	if(~bufs[x].notNil) {
		~bufs.free;
	};
	~bufs[x] = Buffer.alloc(s, s.sampleRate*4/~t, 2);
})
)

(

SynthDef(\recorder, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum;
	var sig;
	var sig1;
	sig = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig1 = EnvGen.ar(Env.adsr(0.01,0,1,0.01),gate,doneAction:0);
	RecordBuf.ar(sig, bufnum, offset:0, recLevel:1, preLevel:\prelevel.kr(0), run:1, loop:0, trigger:1, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\player, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1;
	var sig;
	var sig1;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.01),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig * \gain.kr(1));
}).add;
SynthDef(\playerbeat, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1;
	var sig;
	var sig1;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig * \gain.kr(1));
}).add;
);

//////////////////////// record drum samples
	RandDelayNetwork(\multifb).make(\fx1, "6--", BusDef(\fx1, \audio));
	RandDelayNetwork(\multifb).make(\fx1, "5--", BusDef(\fx1, \audio));
	RandDelayNetwork(\default).make(\fx1, "5--", BusDef(\fx1, \audio));
	Ndef(\fx1).play;
	Ndef(\fx1).edit;

/////// kick
(
Ndef(\fx1).play;
Pdef(\recorder, Ppar([
	Pbind(
		\instrument, \recorder,
		\bufnum, ~bufs[\kick],
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
	
])).play
)
(
Pdef(\recorder, Ppar([
	Pbind(
		\instrument, \recorder,
		\bufnum, ~bufs[\snare],
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
		\bufnum, ~bufs[\hat],
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


~bufs[\snare].plot
~bufs[\snare].play
~bufs[\kick].play
~bufs[\hat].play

//////////////////////// make first loop

	RandDelayNetwork(\multifb).make(\fx1, "4--", BusDef(\fx1, \audio));
	Ndef(\fx1).play;
	Ndef(\fx1).edit;

	(
		Pdef(\smpdrum1, Ppar([
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\kick],
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
				\bufnum, ~bufs[\kick],
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
				\bufnum, ~bufs[\snare],
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
				\bufnum, ~bufs[\snare],
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
				\bufnum, ~bufs[\snare],
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
				\bufnum, ~bufs[\hat],
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


//////////////////////// record first loop

	~bufs[\loop].play;
	(
	~bufs[\loop] = ~bufs[\loop] ? Buffer.alloc(s, s.sampleRate*8/~t, 2);
	Ndef(\fx1).play;
		Pdef(\recorder, 
			Ppar([
				Pseq([
					Pbind(
						\instrument, \recorder,
						\bufnum, ~bufs[\loop],
						\inbus, Ndef(\fx1).bus,
						\dur, Pseq([8],1),
						\amp, 0.1
					),
					Ptask({ "Done".debug; }),
				],1),
				Pfindur(32,Pdef(\smpdrum1)),
			])
		).play;
	)


//////////////////////// resample first loop
	(
		Pdef(\smploop1, 
			Pseq([
				Ppar([
					Pbind(
						\instrument, \player,
						\bufnum, ~bufs[\loop],
						\isRest, Pseq([
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
						],1).coin.not,
						\legato, 16*2,
						\dur, 1/8,
						\amp, 0.1,
					),
				]),
				Ppar([
					Pbind(
						\instrument, \player,
						\bufnum, ~bufs[\loop],
						\isRest, Pseq([
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
						],1).coin.not,
						\legato, 16*2,
						\dur, 1/8,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \player,
						\bufnum, ~bufs[\loop],
						\isRest, Pseq([
							1,0,0,1, 0,0,1,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
						],1).coin.not,
						\legato, 1,
						\dur, 1/8,
						\amp, 0.1,
					),
				]),
				Ppar([
					Pbind(
						\instrument, \player,
						\bufnum, ~bufs[\loop],
						\isRest, Pseq([
							1,0,0,0, 1,0,0,0,
							0,0,0,0, 0,0,1,0,
							1,0,0,0, 0,0,1,0,
							0,0,0,0, 0,0,0,0,
						],2).coin.not,
						\legato, 4,
						\legato, Pseq([
							4,1,1,1, 1,1,1,1,
							4,1,1,1, 1,1,4,1,
						],inf),
						\dur, 1/8,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \playerbeat,
						\bufnum, ~bufs[\loop],
						\isRest, Pseq([
							0,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							1,0,0,1, 0,0,1,0,
						],2).coin.not,
						\pos, 1/~t,
						\legato, Pseq([
							1,1,1,1, 1,1,1,1,
							4,1,1,1, 1,1,1,1,
							1,1,1,1, 1,1,1,1,
							4,1,1,1, 1,1,1,1,

							1,1,1,1, 1,1,1,1,
							4,1,1,1, 1,1,1,4,
							1,1,1,1, 1,1,1,1,
							4,1,1,4, 1,1,4,1,
						],inf),
						\dur, 1/8,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \playerbeat,
						\bufnum, ~bufs[\loop],
						\isRest, Pseq([
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,

							1,0,1,0, 1,0,1,0,
							0,0,0,0, 1,0,0,0,
							0,0,1,0, 0,0,1,0,
							0,0,0,0, 0,0,0,0,
						],1).coin.not,
						\pos, 1/2/~t,
						\legato, Pseq([
							1,1,1,1, 1,1,1,1,
							4,1,1,1, 1,1,1,4,
							1,1,1,1, 1,1,1,1,
							4,1,1,4, 1,1,4,1,
						],inf),
						\dur, 1/8,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \playerbeat,
						\bufnum, ~bufs[\loop],
						\isRest, Pseq([
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,

							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,1,0,
							0,0,1,0, 0,0,0,0,
						],1).coin.not,
						\pos, 7/6/~t,
						\legato, Pseq([
							1,1,1,1, 1,1,1,1,
							4,1,1,1, 1,1,1,4,
							1,1,1,1, 1,1,1,1,
							4,1,4,4, 1,1,1,1,
						],inf),
						\dur, 1/8,
						\amp, 0.3,
					),
				])
			],inf)
		);
	//Pdef(\smploop1).set(\out, BusDef(\fx1));
	Pdef(\smploop1).set(\out, 0);
	//Pdef(\drum1).set(\out, 0);
	Pdef(\main, Pdef(\smploop1)).play;
	Ndef(\fx1).play;
	)

	Ndef(\fx1).send;

//////////////////////// // Main

	(
	Ndef(\fx1).play;
		Pdef(\main, 
			Pseq([
				Pfindur(16,Pbind(\out, 0) <>Pdef(\smploop1)),
				Pfindur(16,Pbind(\out, 0) <>Pdef(\smploop2)),
				Pfindur(16,Pdef(\smpdrum1)),
			],2)
		).play;
	)

(
RandDelayNetwork('multifb').make('fx1', "5-I4P2-GSSS");
Ndef('fx1').put(100, \pset -> Pbind(
	'wet10', 0.54444444444444,
	'fb', 0.0094868329805051,
	'delay', 0.1,
	'delay2', 0.00010525002852777,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 300.0,
	'pitchlag', 0.14677992676221,
	'pitchmix', 1.0,
	'prelpf', 20000.0,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 20.0,
	'deltran1', 2.4666666666667,
	'deltran2', 1.5666666666667,
	'deltran3', 3.7,
	'fbdistamp', 6.9591084953625,
	'fbdistmix', 0.93888888888889,
	'postlpf', 20000.0,
	'posthpf', 17,
	'wetamp', 0.27303626552375,
	'wet20', 1.0,
	'mamp', 2.2230095692183,
	'fb1', 1.7763568394003e-15,
	'fb2', 0.0,
).keep(1));
);

/////////////////////////////////////////////////////////

	(
		Pdef(\smploop2, 
			Pseq([
				Ppar([
					Pbind(
						\instrument, \player,
						\bufnum, ~bufs[\loop],
						\isRest, Pseq([
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
						],inf).coin.not,
						\legato, Pseq([1!8,4].flat,inf),
						\dur, 1/8,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \playerbeat,
						\bufnum, ~bufs[\loop],
						\isRest, Pseq([
							0,0,1,0, 0,0,1,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,1, 0,0,1,0,
							0,0,0,0, 0,0,0,0,

							0,0,0,0, 0,0,1,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,1,0,
							0,0,0,0, 0,0,0,0,
						],inf).coin.not,
						\pos, Pseq([0,0.15,],inf).stutter(32)/~t,
						\legato, Pseq([4,2,1,2,4,1],inf),
						\dur, 1/8,
						\amp, 0.1,
					),

					Pbind(
						\instrument, \playerbeat,
						\bufnum, ~bufs[\loop],
						\isRest, Pseq([
							0,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,1,0,
						],inf).coin.not,
						\pos, Pseq([
							1,1,1,1, 1,1,1,1,
							1,1,1,1, 1,1,1,1,
							1,1,1,1, 1,1,1,1,
							1,1,1,1, 1.2,1,1,1,
						],inf)/~t,
						\legato, Pseq([
							1,1,1,1, 1,1,1,1,
							4,1,1,1, 1,1,1,1,
							1,1,1,1, 1,1,1,1,
							2,4,1,1, 2,1,1,1,
							
						],inf),
						\dur, 1/8,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \playerbeat,
						\bufnum, ~bufs[\loop],
						\isRest, Pseq([
							1,0,
							1,0,
							1,0,
							1,0,
							1,0,
							0,0,
							1,1,
							1,0,
							1,0,
							1,0,
							0,0,
						],inf).coin.not,
						\pos, 0.75/~t,
						\legato, Pseq([0.2,0.1,0.5,0.1],inf).stutter(2),
						\dur, 1/8,
						\amp, 0.1/4,
					),
				]),
			],inf)
		);
	Pdef(\smploop2).set(\out, BusDef(\fx1));
	//Pdef(\smploop2).set(\out, 0);
	//Pdef(\drum1).set(\out, 0);
	Pdef(\main, Pdef(\smploop2)).play;
	Ndef(\fx1).play;
	)

	RandDelayNetwork(\multifb).make(\fx1, "5--", BusDef(\fx1, \audio));
	Ndef(\fx1).play;
	Ndef(\fx1).edit;

	(
	Ndef(\fx1).put(500, \filter -> { arg in;
		in = BPeakEQ.ar(
			in,
			1000,
			1.5, // rq
			8,
			0.5
		);
		BHiShelf.ar(
			in,
			8000,
			0.1, // rq
			1,
			0.5
		);

	});
	)

	(
		Pdef(\smpdrum2, Ppar([
			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\kick],
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,1,0,
					1,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					4,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				],inf),
				\pos, Pseq([
					Pseq([
						0
					],1),
					Pseq([
						0.02
					],7),
				],inf)/~t,
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\snare],
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\legato, Pseq([8,8,2,8,2,2],inf).stutter(16),
				\legato, 1,
				\amp, 0.2
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\snare],
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\pos, 0.04/~t,
				\dur, 1/8,
				\legato, Pseq([8,8,2,8,2,2],inf).stutter(16),
				\legato, 2,
				\amp, 0.2
			),

		PmonoArtic(\snaphihat,
			\dur, 1/8,
			\itrig, Pseq([
				1,1,1,1,
			],inf),
			//\out, 0,
			\rel, Pseq([
				1,0.2,1,0, 1,0,1,0,
				1,0,1,0.51, 1,0.2,1,0,
				1,0,1,0, 1,0,1,0,
				1,0.2,0.4,0.2, 1,0,1,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,1,0,
			],inf)/20,
			\level, Pseq([1,1.2,1.1,1.4],inf).stutter(4)/2,
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
			\amp, 0.1/2
		),


	]));
	Pdef(\smpdrum2).set(\out, BusDef(\fx1));
	//Pdef(\smpdrum2).set(\out, 0);
	Pdef(\main, Pdef(\smpdrum2)).play;
	Ndef(\fx1).play;
	)

	~bufs[\loop2].play
	(
	~bufs[\loop2] = ~bufs[\loop2] ?? { Buffer.alloc(s, s.sampleRate*8/~t, 2) };
	Ndef(\fx1).play;
		Pdef(\recorder, 
			Ppar([
				Pseq([
					Pbind(
						\instrument, \recorder,
						\bufnum, ~bufs[\loop2],
						\inbus, Ndef(\fx1).bus,
						\dur, Pseq([8],1),
						\amp, 0.1
					),
					Ptask({ "Done".debug; }),
				],1),
				Pfindur(32,Pdef(\smpdrum2)),
			])
		).play;
	)
	(
		~loop = ~bufs[\loop2];
		Pdef(\smp2loop1, 
			Pseq([
				Ppar([
					Pbind(
						\instrument, \player,
						\bufnum, ~loop,
						\isRest, Pseq([
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
						],inf).coin.not,
						\legato, Pseq([1!8,4].flat,inf),
						\dur, 1/8,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \playerbeat,
						\bufnum, ~loop,
						\isRest, Pseq([
							0,0,1,0, 0,0,1,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,1, 0,0,1,0,
							0,0,0,0, 0,0,0,0,

							0,0,0,0, 0,0,1,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,1,0,
							0,0,0,0, 0,0,0,0,
						],inf).coin.not,
						\pos, Pseq([0,0.15,],inf).stutter(32)/~t,
						\legato, Pseq([4,2,1,2,4,1],inf),
						\dur, 1/8,
						\amp, 0.1,
					),

					Pbind(
						\instrument, \playerbeat,
						\bufnum, ~loop,
						\isRest, Pseq([
							0,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,1,0,
						],inf).coin.not,
						\pos, Pseq([
							1,1,1,1, 1,1,1,1,
							1,1,1,1, 1,1,1,1,
							1,1,1,1, 1,1,1,1,
							1,1,1,1, 1.2,1,1,1,
						],inf)/~t,
						\legato, Pseq([
							1,1,1,1, 1,1,1,1,
							4,1,1,1, 1,1,1,1,
							1,1,1,1, 1,1,1,1,
							2,4,1,1, 2,1,1,1,
							
						],inf),
						\dur, 1/8,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \playerbeat,
						\bufnum, ~loop,
						\isRest, Pseq([
							1,0,
							1,0,
							1,0,
							1,0,
							1,0,
							0,0,
							1,1,
							1,0,
							1,0,
							1,0,
							0,0,
						],inf).coin.not,
						\pos, 0.75/~t,
						\legato, Pseq([0.2,0.1,0.5,0.1],inf).stutter(2),
						\dur, 1/8,
						\amp, 0.1/4,
					),
				]),
			],inf)
		);
	Pdef(\smp2loop1).set(\out, BusDef(\fx1));
	//Pdef(\smploop2).set(\out, 0);
	//Pdef(\drum1).set(\out, 0);
	Pdef(\main, Pdef(\smp2loop1)).play;
	Ndef(\fx1).play;
	)

(
		~loop = ~bufs[\loop2];
		~name = \smp2loop2;
		Pdef(~name, 
			Pseq([
				Ppar([
					Pbind(
						\instrument, \playerbeat,
						\bufnum, ~loop,
						\speed, 1.0,
						\isRest, Pseq([
							1,0,1,0, 0,0,0,0,
							1,0,0,0, 0,0,1,0,
							1,0,0,0, 1,0,0,0,
							1,0,0,0, 0,0,1,0,

							1,0,0,1, 0,0,1,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,1, 0,0,1,0,
						],inf).coin.not,
						\pos, Pseq([
							0,0,0.01,0, 0,0,0,0,
							1,1,1,1, 1,1,1,1,
							0,0,0.01,0, 0,0,0,0.03,
							1,1,1,1, 1,1,1.01,1,
						],inf)/~t,
						\legato, Pseq([
							2,1,1,1, 1,1,1,1,
							1,1,1,1, 1,1,1,1,
							2,1,1,1, 1,1,1,1,
							4,1,1,1, 1,1,1,1,
						].flat,inf),
						\dur, 1/8,
						\gain, 1.0,
					),
					Pbind(
						\instrument, \playerbeat,
						\bufnum, ~loop,
						\speed, 1.0,
						\isRest, Pseq([
							1,0, 1,0, 1,0, 1,0,
							1,0, 1,0.5, 1,0, 1,0,
							1,0, 1,0, 1,0, 1,0,
							0,0, 0,0.15, 0,0, 0.1,0,

							1,1, 0,0, 0,1, 1,0,
							1,0, 1,0.5, 1,0, 1,0,
							1,0, 1,0, 1,0, 1,0,
							0,0, 0,0.15, 0,0, 0.1,0,
						],inf).coin.not,
						\pos, Pseq([
							4.9,
						],inf)/~t,
						\pos, 0.77477477477478,
						\pos, Pkey(\pos)/~t,
						\legato, Pseq([
							1,1,1,1, 1,1,1,1,
						].flat,inf)/2,
						\dur, 1/8,
						\amp, 0.1,
						\gain, 1/2,
					),
				])
			],inf)
		);
	Pdef(~name).set(\out, BusDef(\fx1));
	//Pdef(~name).set(\out, 0);
	Pdef(\main, Pdef(~name)).play;
	Ndef(\fx1).play;
	)

	
	
	
	(
		Pdef(\smpdrum3, Ppar([
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\kick],
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 2,
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\kick],
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
				\instrument, \playerbeat,
				\bufnum, ~bufs[\snare],
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,

					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\pos, Pseq([
					0, Pn(0.1,7),
				],inf).stutter(1)/~t,
				\dur, 1/8,
				\legato, Pseq([1,2,2,3,2,2],inf).stutter(16),
				\amp, 0.2
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\snare],
				\degree, Pseq([0],inf),
				\speed, -0.8,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\pos, 1/8/~t,
				\dur, 1/8,
				\legato, 2,
				\gain, 0.5,
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\snare],
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
				\bufnum, ~bufs[\hat],
				\speed, 0.5,
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					Pser([1,0,0,0],16),

					Pser([1,0],8),
					0,0,0,0, 1,0.51,1,0.61,

					Pser([1,0,1,0],8),
					Pser([1,0.2,0.5,0.1],4), Pser([1,0],4),

					Pser([1,0,0,0],8),
					0,0,0,0, 1,1,1,1,

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
				],inf)*2,
				\gain, 1/2,
				\amp, 0.1
			),

	]));
	Pdef(\smpdrum3).set(\out, BusDef(\fx1));
	//Pdef(\drum1).set(\out, 0);
	Pdef(\main, Pdef(\smpdrum3)).play;
	Ndef(\fx1).play;
	)

	RandDelayNetwork(\multifb).make(\fx1, "5--", BusDef(\fx1, \audio));
	Ndef(\fx1).play;
	Ndef(\fx1).edit;

	(
		~name = \smpdrum4;
		Pdef(~name, Ppar([
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\kick],
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, Pseq([
					2,1,1,1, 1,1,1,1,
				],inf),
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\snare],
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,1,0,0,
					0,0,0,0, 1,0,0,0,
					1,0,0,0, 0,1,0,0,
				],inf).coin.not,
				\legato, Pseq([
					4,1,1,1, 1,1,1,1,
				],inf)/2,
				\lag, Pseq([
					0,Pseq([0.17],7),
				],inf),
				\pos, Pseq([
					0,0,0.1,0.1, 0.1,1/2,0,0,
				],inf)/~t,
				\dur, 1/8,
				\gain, 1.4,
				\amp, 0.2
			),

			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\hat],
				\speed, 1.0,
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					Pser([1,0,1,0],16),


				],inf).coin.not,
				\pos, 0.01/~t + Pseq([1.1,0.1,0.2,0],inf).stutter(2),
				//\pos, 0.01,
				\pos, Pseq([
					0,0,0,0,
					0,0.1,0.01,0,
				],inf).stutter(2),
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
				],inf)*2,
				\gain, 1/8,
				\amp, 0.1
			),

	]));
	Pdef(~name).set(\out, BusDef(\fx1));
	//Pdef(\drum1).set(\out, 0);
	Pdef(\main, Pdef(~name)).play;
	Ndef(\fx1).play;
	)

	(
		~name = \smpdrum5;
		Pdef(~name, Ppar([
			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\kick],
				\isRest, Pseq([
					1,0,1,0, 1,0,0,1,
					0,0,1,0, 1,0,1,0,
					1,0,1,1, 1,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,1,0, 1,0,0,1,
					0,0,0,0, 0,0,0,0,
					1,0,1,1, 1,0,0,0,
					0,0,0,0, 0,0,0,0,

				],inf).coin.not,
				\pos, Pseq([
					Pseq([
						0,Pn(2.18,7),
					],2),
					Pseq([
						0,Pn(1.08,7),
					],2),
				],inf).stutter(1)/~t,
				\legato, Pseq([
					2,1,1,1, 1,1,1,1,
				],inf),
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\snare],
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,1,0,0,
					0,0,0,0, 0,0,0,0,
					1,1,0,0, 0,1,0,0,

					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,1,0,0,
					0,0,0,1, 0,0,0,0,
					1,1,0,0, 0,1,0,0,
				],inf).coin.not,
				\legato, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					2,1,1,1, 1,1,1,1,
					2,1,1,1, 1,1,1,1,
				],inf),
				\lag, Pseq([
					0,Pseq([0.02],7),
				],inf),
				\pos, Pseq([
					0,1,0.1,0.1, 0.1,1/2,0,0,
					0,1,0.1,0.1, 0.1,1/2,0,0,
					0.01,1,0.1,0.1, 0.1,1/2,0,0,
					0.01,1,0.1,0.1, 0.1,1/2,0,0,
				],inf)/~t,
				\dur, 1/8,
				\gain, 1.4,
				\amp, 0.2
			),

			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\hat],
				\speed, 1.0,
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					Pser([1,0,1,0],16),
					Pser([1,0,1,0],8),
					Pser([0,0,0,0],8),
				],inf).coin.not,
				\pos, 0.01/~t + Pseq([1.1,0.1,0.2,0],inf).stutter(2),
				//\pos, 0.01,
				\pos, Pseq([
					0,0,0,0,
					0,0.1,0.01,0,
				],inf).stutter(2),
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
				],inf)*2,
				\legato, Pseq([
					1/2
				],inf)*2,
				\gain, 1/8*0,
				\amp, 0.1
			),

	]));
	Pdef(~name).set(\out, BusDef(\fx1));
	//Pdef(\drum1).set(\out, 0);
	Pdef(\main, Pdef(~name)).play;
	Ndef(\fx1).play;
	)

	(
		~name = \smpdrum6;
		Pdef(~name, Ppar([
			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\kick],
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,

					1,0,1,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,0,
				],inf).coin.not,
				\pos, Pseq([
					Pseq([
						0,Pn(0.08,7),
					],2),
					Pseq([
						2,Pn(2.10,7),
					],2),
				],inf).stutter(1)/~t,
				\legato, Pseq([
					2,1,1,1, 1,1,1,1,
				],inf),
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\snare],
				\isRest, Pseq([
					0,0,0,0, 0,1,1,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0,
					1,0,0,0, 1,0,0,0,

					0,0,0,0, 0,1,1,0,
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,

				],inf).coin.not,
				\legato, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					2,1,1,1, 1,1,1,1,
					2,1,1,1, 1,1,1,1,
				],inf),
				\lag, Pseq([
					0,Pseq([0.02],7),
				],inf),
				\pos, Pseq([
					0,1,0.1,0.1, 0.1,1/2,0.1,2.01,
					0,1,0.1,0.1, 0.1,1/2,0,0,
					0.01,1,0.1,0.1, 0.1,1/2,0.1,0.1,
					0.01,1,0.1,0.1, 0.1,1/2,0,0.1,
				],inf)/~t,
				\dur, 1/8,
				\gain, 1.4,
				\amp, 0.2
			),

			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\hat],
				\speed, 1.0,
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					Pser([1,0,1,0],16),
					Pser([1,0,1,0],8),
					Pser([0,0,0,0],8),
				],inf).coin.not,
				\pos, 0.01/~t + Pseq([1.1,0.1,0.2,0],inf).stutter(2),
				//\pos, 0.01,
				\pos, Pseq([
					0,0,0,0,
					0,0.1,0.01,0,
				],inf).stutter(2),
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
				],inf)*2,
				\legato, Pseq([
					1/2
				],inf)*2,
				\gain, 1/8*0,
				\amp, 0.1
			),

	]));
	Pdef(~name).set(\out, BusDef(\fx1));
	//Pdef(\drum1).set(\out, 0);
	Pdef(\main, Pdef(~name)).play;
	Ndef(\fx1).play;
	)

	(
		~name = \smpdrum7;
		Pdef(~name, Ppar([
			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\kick],
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
					0,0,0,0, 1,0,0,0,

					1,0,1,0, 0,1,1,0,
					0,0,0,0, 1,0,0,0,
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					1,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\pos, Pseq([
					Pseq([
						0,Pn(0.00,7),
					],2),
					Pseq([
						2,Pn(2.10,7),
					],2),
				],inf).stutter(1)/~t,
				\legato, Pseq([
					2,1,1,1, 1,1,1,1,
				],inf),
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\snare],
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
				],inf).coin.not,
				\legato, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					2,1,1,1, 1,1,1,1,
					2,1,1,1, 1,1,1,1,
				],inf),
				\lag, Pseq([
					0,Pseq([0.0],7),
				],inf),
				\pos, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
					],32),
					0,1,0.1,0.1, 0.1,1/2,0.1,2.01,
					0,1,0.1,0.1, 0.1,1/2,0.1,0,
					0.01,1,0.1,0.1, 0.1,1/2,0.1,0.1,
					0.01,1,0.1,0.1, 0.1,1/2,0,0.1,
				],inf)/~t,
				\dur, 1/8,
				\gain, 1.4,
				\amp, 0.2
			),

			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\hat],
				\speed, 1.0,
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					Pser([1,0,1,0],16),
					Pser([1,0,1,0],8),
					Pser([0,0,0,0],8),
				],inf).coin.not,
				\pos, 0.01/~t + Pseq([1.1,0.1,0.2,0],inf).stutter(2),
				//\pos, 0.01,
				\pos, Pseq([
					0,0,0,0,
					0,0.1,0.01,0,
				],inf).stutter(2),
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
				],inf)*2,
				\legato, Pseq([
					1/2
				],inf)*2,
				\gain, 1/8*0,
				\amp, 0.1
			),

	]));
	Pdef(~name).set(\out, BusDef(\fx1));
	//Pdef(\drum1).set(\out, 0);
	Pdef(\main, Pdef(~name)).play;
	Ndef(\fx1).play;
	)
