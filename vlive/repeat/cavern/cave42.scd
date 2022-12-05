

~t = 82/4/60; TempoClock.default.tempo = ~t;
~t = 118/4/60; TempoClock.default.tempo = ~t;
TrackDef(\cave42rec, TrackTemplateDef(\CustomTrackList))
TrackDef(\cave42rec).edit

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\lag, 0.1) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[163].value,
				\isRest, Pseq([
					1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1602].value,
				\isRest, Pseq([
					0,0,1,0, 
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		]),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\lag, 0.08,
			\out, BusDef(\sendbus1, \audio),
		
		) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[163].value,
				\isRest, Pseq([
					1,0,0,1, 0,0,1,0,
					0,1,1,0, 0,0,0,1,
					1,0,0,1, 0,0,1,0,
					0,1,1,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
					0,1,1,0, 0,0,1,0,
					//1,0,0,0, 0,0,0,1,
				],inf).coin.not,

				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1602].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		].collect { arg pat, idx;
			Pbind(\dur, Pkey(\dur) * (1 + (0.50 * Pseq([1,-1],inf))))
			<> pat

			
		})
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\lag, 0.08,
			\out, BusDef(\sendbus1, \audio),
		
		) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[163].value,
				\isRest, Pseq([
					1,0,0,1, 0,0,1,0,
					0,1,0,0, 0,0,0,0,
					//1,0,0,0, 0,0,0,1,
				],inf).coin.not,

				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1602].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		].collect { arg pat, idx;
			Pbind(\dur, Pkey(\dur) * (1 + (0.50 * Pseq([1,-1],inf))))
			<> pat

			
		})
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[163].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1602].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
Pdef(\melo, 
	Pbind(
		\instrument, \bilin,
	)
);
);

ProtoDef(\piano).startControl(Pdef(\melo))
ProtoDef(\piano).edit
Param(Pdef(\piano), \adsr -> \release).edit
Param(Pdef(\melo), \adsr -> \release).edit

Param(Pdef('NoteTimelineTrack.1.instr'), \adsr -> \release).midiLearn

(
Pdef(\bilin, 
	Pbind(
		\instrument, \bilin,
	)
);
);

NoteTimeline(\note)


(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\note, Pseries(0,3,22),
		\octave, 3,
		\dur, 1/16,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\note, Pseries(0,7,22),
		\octave, 3,
		\dur, 1/16,
		\amp, 0.1,
	)
).play;
);

(
Ndef(\zed, { arg freq=2000, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	lfo1 = LFNoise1.ar(1).range(0.1,1000);
	lfo2 = LFNoise1.ar(1).range(0.1,10);
	env1 = EnvGen.kr(Env([2,1/18,1/8],[0.001,0.8]), Impulse.kr(lfo2));
	env2 = EnvGen.ar(Env([0,0,1,0],[0,0.01,0.08]), Impulse.ar(lfo2));
	sig = SinOsc.ar(freq * env1) * env2;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


~t = 195/2/60; TempoClock.default.tempo = ~t; // madlads get out
~t = 96/2/60; TempoClock.default.tempo = ~t;
96*2
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,5,6,12,
			],inf),
			\dur, 1,
			\octave, 3,
			\amp, 0.2,
			\lag, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/madlads_getout.flac'),
			\legato, 1,
			\st, 96/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 1,
			],1),2).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/2,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,5,6,12,
			],inf),
			\dur, 1,
			\octave, 3,
			\amp, 0.2,
			\lag, 0.1,
		),
		Pseq([
			Pfindur(1,Pbind( // mod2a
				\instrument, \playersec,
				\bufnum, BufDef('loop/madlads_getout.flac'),
				\legato, 0.7,
				\st, 96/4/60,
				\speed, 1/2 * ~t / Pkey(\st),
				\pos, Pseg(Pseq([
					0,1,
				],1),1/2) / Pkey(\st),
				\pos, Pseq([
					0,0.1,1/4,1/4
				],inf),
				\dur, 1/4,
				\gain, 1/2,
			)),
			Pbind( // mod2b
				\instrument, \playersec,
				\bufnum, BufDef('loop/madlads_getout.flac'),
				\legato, 1,
				\st, 96/4/60,
				\speed, 1/2 * ~t / Pkey(\st),
				\pos, Pseg(Pseq([
					3/4,7/8,3/4,3/4,
				],1),1/2) / Pkey(\st),
				//\pos, 3/4,
				\dur, 1/4,
				\gain, 1/2,
			),

			Pbind( // mod1a
				\instrument, \playersec,
				\bufnum, BufDef('loop/madlads_getout.flac'),
				\legato, 0.7,
				\st, 96/4/60,
				\speed, 1/2 * ~t / Pkey(\st),
				\pos, Pseg(Pseq([
					0,1,
				],1),1/2) / Pkey(\st),
				\dur, 1/4,
				\gain, 1/2,
			),
			Pbind( // mod1b
				\instrument, \playersec,
				\bufnum, BufDef('loop/madlads_getout.flac'),
				\legato, 1/2,
				\st, 96/4/60,
				\speed, 1/2 * ~t / Pkey(\st),
				\pos, Pseg(Pseq([
					3/4,7/8,
				],1),1/2) / Pkey(\st),
				//\pos, 3/4,
				\dur, 1/2,
				\gain, 1/2,
			),

			Pbind( // normal
				\instrument, \playersec,
				\bufnum, BufDef('loop/madlads_getout.flac'),
				\legato, 1,
				\st, 96/4/60,
				\speed, 1/2 * ~t / Pkey(\st),
				\pos, Pseg(Pseq([
					0, 1,
				],1),2) / Pkey(\st),
				\dur, 1/8,
				\gain, 1/2,
			),
			Pbind( // low legato
				\instrument, \playersec,
				\bufnum, BufDef('loop/madlads_getout.flac'),
				\legato, Pseq([
					1/2
				],inf),
				\st, 96/4/60,
				\speed, 1/2 * ~t / Pkey(\st),
				\pos, Pseg(Pseq([
					0, 1,
				],1),2) / Pkey(\st),
				\dur, 1/8,
				\gain, 1/2,
			),
			Pbind( // only kick snare
				\instrument, \playersec,
				\bufnum, BufDef('loop/madlads_getout.flac'),
				\legato, 1/2,
				\st, 96/4/60,
				\speed, 1/2 * ~t / Pkey(\st),
				\pos, Pseg(Pseq([
					0, 1,
				],1),2) / Pkey(\st),
				\dur, 1/2,
				\gain, 1/2,
			),
		],inf),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,5,6,12,
			],inf),
			\dur, 1,
			\octave, 3,
			\amp, 0.2,
			\lag, 0.1,
		),
		Pseq([
			Pbind( // low legato
				\instrument, \playersec,
				\bufnum, BufDef('loop/madlads_getout.flac'),
				\legato, Pseq([
					1,1,0.51,0.52,0.5,
					1,0.7,1,0.7,
				],inf),
				\st, 96/4/60,
				\speed, 1/2 * Pseq([1,1,1,1,1,4/6,5/6,3/6],inf) * ~t / Pkey(\st),
				\speed, 1/2 * Pseq([1,1,1,1, 1,1,1,4/6],inf) * ~t / Pkey(\st),
				\pos, Pseg(Pseq([
					0,
				   	1, 1/2, 0/4, 3/4,
				],1),Pseq([1,1,2],inf)) / Pkey(\st),
				\dur, 1/2,
				\gain, 1/2,
			),
		],inf),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[232].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\lag, 0.081,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[168].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,0,1,0,
				1,0,1,0, 1,1,1,0,
				1,0,1,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\lag, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,5,6,12,
			],inf),
			\dur, 1,
			\octave, 3,
			\amp, 0.2,
			\lag, 0.1,
		),
		Pseq([
			Pbind( // low legato
				\instrument, \playersec,
				\bufnum, BufDef('loop/madlads_getout.flac'),
				\legato, Pseq([
					1,1,0.51,0.52,0.5,
					1,0.7,1,0.7,
				],inf),
				\st, 96/4/60,
				\speed, 1/2 * Pseq([1,1,1,1,1,4/6,5/6,3/6],inf) * ~t / Pkey(\st),
				\speed, 1/2 * Pseq([1,1,1,1, 1,1,1,4/6],inf) * ~t / Pkey(\st),
				\pos, Pseg(Pseq([
					0,
				   	1, 1/2, 1, 3/4,
				],1),Pseq([1,1,2],inf)) / Pkey(\st),
				\dur, 1/8,
				\pos, Pseq([
					0,1/4,0,3/4,1/4,
				],inf),
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\gain, 1/2,
			),
		],inf),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[232].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\lag, 0.081,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[168].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,0,1,0,
				1,0,1,0, 1,1,1,0,
				1,0,1,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\lag, 0.1,
		),
		
	])
)).play;
);
