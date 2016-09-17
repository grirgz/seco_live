
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


(
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
	RecordBuf.ar(sig, bufnum, offset:0, recLevel:1, preLevel:0, run:1, loop:0, trigger:1, doneAction:2);
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
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.01),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig * \gain.kr(1));
}).add;
);

Ndef(\fx1).edit
(
Ndef(\fx1).play;
Pdef(\recorder, Ppar([
	Pbind(
		\instrument, \recorder,
		\bufnum, ~bufs[\snare],
		\inbus, BusDef(\rec, \audio),
		\inbus, Ndef(\fx1).bus,
		\dur, Pseq([4],1),
		\amp, 0.1
	),
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

~bufs[\snare].plot
~bufs[\snare].play
~bufs[\kick].play

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
		PmonoArtic(\snaphihat,
			\dur, 1/8,
			\itrig, Pseq([
				1,1,1,1,
			],inf),
			//\out, 0,
			\rel, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
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
			\amp, 0.1/4
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


	// Main
	(
	Ndef(\fx1).play;
		Pdef(\main, 
			Pseq([
				Pfindur(16,Pbind(\out, 0) <>Pdef(\smploop1)),
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
