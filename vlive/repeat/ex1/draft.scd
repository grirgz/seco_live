
(
Ndef(\regul, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(freq * (1..8) * ( 1 + ( SinOsc.kr(10 * SinOsc.kr(1/4).range(0,1)) * SinOsc.kr(1/7).exprange(0.01,10) )));
	//sig = sig + SinOsc.kr(10).range(0,1);
	//sig = LeakDC.ar(sig);
	sig = BPF.ar(sig, freq, 0.1) * 4;
	sig = Pan2.ar(sig, SinOsc.kr((1..8)).range(0,1), amp).mean * 4;
}).play;
);



(
	Pdef(\drum1, Ppar([
		Pbind(
			\instrument, \snapkick,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 1,0,0,1,
					0,0,0,0, 0,0,0,0,
				],3),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snapsnare,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,0,0,
				],3),
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],1),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snapclap,
			\isRest, Pseq([
				Pseq([
					0,1,1,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,1,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,1,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

				],3),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		),
		PmonoArtic(\snaphihat,
			\isRest, Pseq([
				//Pser([
				//	1,0,
				//],8*1),
				Pser([
					1,0,1,0,
					1,0,1,0,
				],8),
			],inf).coin.not,
			\dur, 1/8,
			\itrig, Pseq([
				1,1,1,1,
			],inf),
			\rel, Pseq([
				0.0,0,0.0,0,
				0.1,0,0.1,0,
				0.1,0,0.1,0,
				0.1,0,0,0,
				
				0.0,0,0.1,0,
				0.1,0,0.1,0,
				0.1,0,0.1,0,
				1,0,1,0,

				0.0,0,0.1,0,
				0.1,0,0.1,0,
				0.1,0,0.1,0,
				0.1,0,1,0,

				0.0,0,0.1,0,
				0.1,0,0.1,0,
				0.0,0,0.1,0,
				1,0,0,0,
				//8,
			],inf)-( 0.1-(0.1/16) )*4,
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

	Pdef(\drum1).set(\out, 0);
	Pdef(\main, Pdef(\drum1)).play;
)


~pv = PatternGroupPlayer(Pbind(\midinote));
~pv.
MIDIMap(\piano, ~pv)
MIDIdef(\piano, {
	
	~pv.noteOn(12);
	~pv.noteOff(12);
})

Button.new.action = {
	~pv.noteOn(12)
}

- simple use case:
	- connect midi keyboard to a pattern/ndef
	- connect gui keyboard to a pattern/ndef
	- mono mode
	- arp
	- sustain mode

(
	Pdef(\drum1, Ppar([
		Pbind(
			\instrument, \snapkick,
			\isRest, Pseq([
				Pseq([
				//	1,0,1,0, 0,0,0,0,
				//	0,0,0,0, 0,0,1,0,
				//	1,0,0,0, 1,0,0,0,
				//	0,0,0,0, 0,0,0,0,

				//	1,0,0,0, 0,0,1,0,
				//	0,0,0,0, 0,0,1,0,
				//	1,0,0,0, 1,0,1,0,
				//	0,0,0,0, 0,0,0,0,
				//	1,0,0,0, 1,0,0,0,
				//	0,0,0,0, 0,0,1,0,
				//	1,0,0,0, 0,0,0,0,
				//	0,0,0,0, 0,0,0,0,
				//Pseq([
				//	1,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
				//	0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
				//	0,0,0,0, 0,0,0,1, 0,0,1,0, 0,0,0,0,
				//	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				//],4),
				1,0,1,0, 0,1,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,1,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,1,
				0,0,0,0, 0,0,1,0,


				],3),
			],inf).coin.not,
			\out, BusDef(\fx1),
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snapsnare,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],3),
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],1),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snapclap,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],3),
			],inf).coin.not,
			\dur, 1/8+( 1/16 ),
			\amp, 0.1
		),
		PmonoArtic(\snaphihat,
			\isRest, Pseq([
				//Pser([
				//	1,0,
				//],8*1),
				Pser([
					1,0,1,0,
					1,0,1,0,
				],8),
			],inf).coin.not,
			\dur, 1/8,
			\itrig, Pseq([
				1,1,1,1,
			],inf),
			\rel, Pseq([
				Pser([
					0,
				],8),
				Pser([
					0.1,
				],8),
				Pser([
					0,0,0,0, 0,0,2,0,
				],8),
				Pser([
					0.1,0,
				],8),
				//8,
			],inf)-( 0.1-(0.1/16) )*4,
			\rel, Pseq([
				Pser([
					0,0,0.1,0, 0.1,0,0.2,0,
					0.1,0,0.1,0, 0,0,0.1,0,
					0,0,0.1,0, 0.1,0,0.1,0,
					0,0,0.1,0, 0,0.1,0.1,0,

					0,0,0.1,0, 0.1,0,0.2,0,
					0,0,0.1,0, 0,0,0.1,0,
					0,0,0.1,0, 0.2,0,0,0,
					0.1,0,0.1,0, 0,0,0.1,0,
				],64),
			],inf)-( 0.1-(0.1/16) )*4,
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

	Pdef(\drum1).set(\out, BusDef(\splitter));
	//Pdef(\drum1).set(\out, 0);
	Pdef(\main, Pdef(\drum1)).play;
)

(
Ndef(\splitter, {
	var sig = InFeedback.ar(\inbus.kr(BusDef(\splitter, \audio)), 2); 
	Out.ar(BusDef(\fx1).index, sig);	
	Out.ar(BusDef(\fx2).index, sig);	
	DC.ar(0)!2;
}).play;
)
	RandDelayNetwork(\multifb).make(\fx1, "4--", BusDef(\fx1, \audio));
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
RandDelayNetwork('multifb').make('fx2', "4-JO0I-C7LQ");
Ndef('fx2').put(100, \pset -> Pbind(
	'wet10', 0.47222222222222,
	'fb', 0.0042231162034804,
	'delay', 0.00015058363542798,
	'delay2', 0.030823992397451,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 2.2736076250426,
	'pitchlag', 0.63095734448019,
	'pitchmix', 0.83888888888889,
	'prelpf', 17000,
	'prehpf', 20.0,
	'lpf', 17000,
	'hpf', 20.0,
	'fb1', 0,
	'deltran1', 5.7860164424345,
	'deltran2', 1.6653063380805,
	'deltran3', 0.85454321526521,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 1,
	'postlpf', 20000.0,
	'posthpf', 44.774422771367,
	'wetamp', 0.93559571119222,
	'wet20', 1.0,
	'mamp', 0.96726196616647,
).keep(1));
);

(
RandDelayNetwork('multifb').make('fx1', "4-59A9-GBOQ");
Ndef('fx1').put(100, \pset -> Pbind(
	'wet10', 0.49444444444444,
	'fb', 0.00030429604425138,
	'delay', 0.032442260791716,
	'delay2', 0.00026437611857491,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 2.0800838230519,
	'pitchlag', 0.042986623470823,
	'pitchmix', 0.5,
	'prelpf', 20000.0,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'deltran1', 0.7,
	'deltran2', 3.4,
	'deltran3', 3.2666666666667,
	'fbdistamp', 3.6937523489595,
	'fbdistmix', 0.93333333333333,
	'postlpf', 20000.0,
	'posthpf', 17,
	'wetamp', 1,
	'wet20', 1.0,
	'mamp', 0.27303626552375,
).keep(1));
);



(
	Pdef(\drum1, Ppar([
		Pbind(
			\instrument, \snapkick,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,1,0,
					1,0,0,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				Pseq([
					1,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,1, 0,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],4),
				1,0,1,0, 0,1,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,1,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,1,
				0,0,0,0, 0,0,1,0,


				],3),
			],inf).coin.not,
			\out, BusDef(\fx1),
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snapsnare,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],3),
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],1),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snapclap,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],3),
			],inf).coin.not,
			\dur, 1/8+( 1/16 ),
			\amp, 0.1
		),
		PmonoArtic(\snaphihat,
			\isRest, Pseq([
				//Pser([
				//	1,0,
				//],8*1),
				Pser([
					1,0,1,0,
					1,0,1,0,
				],8),
			],inf).coin.not,
			\dur, 1/8,
			\itrig, Pseq([
				1,1,1,1,
			],inf),
			\rel, Pseq([
				Pser([
					0,
				],8),
				Pser([
					0.1,
				],8),
				Pser([
					0,0,0,0, 0,0,2,0,
				],8),
				Pser([
					0.1,0,
				],8),
				//8,
			],inf)-( 0.1-(0.1/16) )*4,
			\rel, Pseq([
				Pser([
					0,0,0.1,0, 0.1,0,0.2,0,
					0.1,0,0.1,0, 0,0,0.1,0,
					0,0,0.1,0, 0.1,0,0.1,0,
					0,0,0.1,0, 0,0.1,0.1,0,

					0,0,0.1,0, 0.1,0,0.2,0,
					0,0,0.1,0, 0,0,0.1,0,
					0,0,0.1,0, 0.2,0,0,0,
					0.1,0,0.1,0, 0,0,0.1,0,
				],64),
			],inf)-( 0.1-(0.1/16) )*4,
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

	Pdef(\drum1).set(\out, BusDef(\splitter));
	//Pdef(\drum1).set(\out, 0);
	Pdef(\main, Pdef(\drum1)).play;
)


(
~bufs = ~bufs ? ();
[\kick, \snare, \hat].do ({ arg x; 
	if(~bufs[x].notNil) {
		~bufs.free;
	};
	~bufs[x] = Buffer.alloc(s, s.sampleRate*4/~t, 2);
})
)

~bufs_save = ~bufs.copy;
~bufs = nil
[~bufs_save, ~bufs].debug

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
	Out.ar(out, sig);
}).add;
SynthDef(\playerbeat, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1;
	var sig;
	var sig1;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.01),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\main, Ppar([
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
Pdef(\main, Ppar([
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
				\amp, 0.1
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
				\amp, 0.1
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
			\amp, 0.1/2
		),


	]));
	Pdef(\smpdrum1).set(\out, BusDef(\fx1));
	//Pdef(\drum1).set(\out, 0);
	Pdef(\main, Pdef(\smpdrum1)).play;
	Ndef(\fx1).play;
	)

	(
	Ndef(\fx1).play;
		Pdef(\plop, 
			Pseq([
				Pfindur(16,Pdef(\smpdrum1)),
				Pfindur(16,Pbind(\out, 0) <>Pdef(\smploop1)),
			],2)
		).play;
	)

	RandDelayNetwork(\multifb).make(\fx1, "4--", BusDef(\fx1, \audio));
	Ndef(\fx1).play;
	Ndef(\fx1).edit;


	~bufs[\loop] = Buffer.alloc(s, s.sampleRate*8/~t, 2)
	(
		Pdef(\recorder, 
			Pbind(
				\instrument, \recorder,
				\bufnum, ~bufs[\loop],
				\inbus, BusDef(\rec, \audio),
				\inbus, Ndef(\fx1).bus,
				\dur, Pseq([4],1),
				\amp, 0.1
			)
		).play;
	)


	(
		Pdef(\smploop1, Ppar([
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\loop],
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 8,
				\dur, 1/8,
				\amp, 0.1
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\loop],
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\pos, 1/~t,
				\legato, 8,
				\dur, 1/8,
				\amp, 0.1
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\loop],
				\isRest, Pseq([
					0,0,0,0, 0,1,0,0,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\pos, 9/8/~t + Pwhite(0,1.0/4),
				\legato, 1,
				\dur, 1/4,
				\amp, 0.1
			),
	]));
	Pdef(\smploop1).set(\out, BusDef(\fx1));
	//Pdef(\drum1).set(\out, 0);
	Pdef(\main, Pdef(\smploop1)).play;
	Ndef(\fx1).play;
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
	Pdef(\smploop1).set(\out, BusDef(\fx1));
	//Pdef(\drum1).set(\out, 0);
	Pdef(\main, Pdef(\smploop1)).play;
	Ndef(\fx1).play;
	)


/////////////////




	(
		//~bufs[\vocal] = ~bufs[\vocal] ? { Buffer.alloc(s, s.sampleRate*) }
		BufDef(\moeten, "voices/02_moeten.flac");
		Pdef(\smpvoc1, Ppar([
			Pbind(
				\instrument, \playerbeat,
				//\bufnum, ~bufs[\loop],
				\bufnum, BufDef(\moeten),
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 8,
				\dur, 1/8,
				\gain, 0.1
			),
			Pbind(
				\instrument, \playerbeat,
				//\bufnum, ~bufs[\loop],
				\bufnum, BufDef(\moeten),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0.6,0.91,1, 1,0.1,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\pos, 1/2/~t + Pseg(Pseq([0,1],inf),8),
				\legato, 1,
				\dur, 1/8,
				\gain, 0.1
			),
			Pbind(
				\instrument, \playerbeat,
				//\bufnum, ~bufs[\loop],
				\bufnum, BufDef(\moeten),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\pos, Pseq([1,2,3,4],inf).stutter(4)/4/~t,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.1
			),
	]));
	//Pdef(\smpvoc).set(\out, BusDef(\fx1));
	Pdef(\smpvoc1).set(\out, 0);
	Pdef(\main, Pdef(\smpvoc1)).play;
	//Ndef(\fx1).play;
	)

	~bufs[\loop].play
	(
	Ndef(\fx1).play;
		Pdef(\main, 
			
			Pseq([
				// part 1

				Pfindur(16,Pbind(\out, 0) <>Pdef(\smploop1)),
				Ppar([
					Pfindur(16,Pdef(\smpvoc1)),
					Pfindur(16,Pdef(\smpdrum1)),
				]),
				Pfindur(16,Pbind(\out, 0) <>Pdef(\smploop1)),
				Ppar([
					Pfindur(16,Pdef(\smpvoc1)),
					Pfindur(16,Pdef(\smpdrum1)),
				]),

				// break
				Pfindur(8,Pdef(\smpvoc1)),

				// part2
				Ppar([
					Pseq([
						Pfindur(8,Pdef(\smpvoc1)),
						Pfindur(8,Pdef(\smpvoc2)),
						Pfindur(8,Pdef(\smpvoc3)),
						//Rest(8),
					],1),
					Pseq([
						Pfindur(16,Pbind(\out, 0) <>Pdef(\smploop1)),
						Pfindur(16,Pdef(\smpdrum1)),
					],1)
				]),

				// part3
				Ppar([
					Pfindur(16,Pdef(\smpvoc1)),
					Pfindur(16,Pbind(\out, 0) <>Pdef(\smploop1)),
				]),
				Ppar([
					Pfindur(8,Pdef(\smpvoc2)),
					Pfindur(16,Pdef(\smpdrum1)),
				]),
				Ppar([
					Pfindur(16,Pdef(\smpvoc1)),
					Pfindur(16,Pbind(\out, 0) <>Pdef(\smploop1)),
				]),
				Ppar([
					Pfindur(16,Pdef(\smpvoc3)),
					Pfindur(16,Pdef(\smpdrum1)),
				]),
				Pfindur(8,Pbind(\out, 0) <>Pdef(\smploop1)),
			],1),
		).play;
	)

	(
		//~bufs[\vocal] = ~bufs[\vocal] ? { Buffer.alloc(s, s.sampleRate*) }
		BufDef(\moeten, "voices/02_moeten.flac");
		Pdef(\smpvoc1, Ppar([
			Pbind(
				\instrument, \playerbeat,
				//\bufnum, ~bufs[\loop],
				\bufnum, BufDef(\moeten),
				\isRest, Pseq([

					1,1,1,1, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 1,1,0,1,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, Pseq([
					1,1,1,1,1,1,1,1,
					4,1,1,1,1,1,1,1,
				],inf)*2,
				\pos, Pseq([2,2.5,3,3.5]/1.8,inf).stutter(8)/~t,
				\pos, Pseg(Pseq([0,4,0,2],inf),4).stutter(4)/~t,
				\dur, 1/8,
				\gain, 0.2
			),
	]));
	Pdef(\smpvoc1).set(\out, BusDef(\fx1));
	//Pdef(\smpvoc1).set(\out, 0);
	//Pdef(\main, Pdef(\smpvoc1)).play;
	//Ndef(\fx1).play;
	)

	(
		//~bufs[\vocal] = ~bufs[\vocal] ? { Buffer.alloc(s, s.sampleRate*) }
		BufDef(\moeten, "voices/02_moeten.flac");
		Pdef(\smpvoc2, Ppar([
			Pbind(
				\instrument, \playerbeat,
				//\bufnum, ~bufs[\loop],
				\bufnum, BufDef(\moeten),
				\isRest, Pseq([

					1,0,1,0.71, 0,1,1,0,
					1,0,0,0, 0,0,0,0,
					1,0,0.71,1, 1,0,0.41,1,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, Pseq([
					1,1,1,1,1,1,1,1,
					4,1,1,1,1,1,1,1,
				],inf)*2,
				\pos, Pseq([2,2.5,3,3.5]/1.8,inf).stutter(8)/~t,
				\pos, Pseg(Pseq([3.4,4,3.45,5]/1.8,inf),4).stutter(4)/~t,
				\dur, 1/8,
				\gain, 0.2
			),
	]));
	Pdef(\smpvoc2).set(\out, BusDef(\fx1));
	//Pdef(\smpvoc2).set(\out, 0);
	Pdef(\main, Pdef(\smpvoc2)).play;
	Ndef(\fx1).play;
	)

	(
		//~bufs[\vocal] = ~bufs[\vocal] ? { Buffer.alloc(s, s.sampleRate*) }
		BufDef(\moeten, "voices/02_moeten.flac");
		Pdef(\smpvoc3, Ppar([
			Pbind(
				\instrument, \playerbeat,
				//\bufnum, ~bufs[\loop],
				\bufnum, BufDef(\moeten),
				\isRest, Pseq([

					1,0,1,0.71, 0,1,1,0,
					1,0,0,0, 0,0,0,0,
					1,0,0.71,1, 1,0,0.41,1,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, Pseq([
					1,1,1,1,1,1,1,1,
					4,1,1,1,1,1,1,1,
				],inf)*2,
				\pos, Pseg(Pseq(( [3.4,4,3.45,5]+2.8 )/1.8,inf),4).stutter(4)/~t,
				\dur, 1/8,
				\gain, 0.2
			),
	]));
	Pdef(\smpvoc3).set(\out, BusDef(\fx1));
	//Pdef(\smpvoc3).set(\out, 0);
	Pdef(\main, Pdef(\smpvoc3)).play;
	Ndef(\fx1).play;
	)
