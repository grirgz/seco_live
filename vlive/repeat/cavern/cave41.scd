
SampleTimeline(\blackbottom).edit
~t = 129/4/60; TempoClock.default.tempo = ~t;


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[63].value,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/blackbottom.flac'),
			\legato, 1.00,
			\speed, Pseq([
				0, 3, 7-12, 7,
			].midiratio,inf),
			\pos, 0 + (Pseq((0..15),inf).stutter(8)/8) / ~t,
			\dur, 1/8,
			\gain, 1,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[1441].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1579].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[348].value,
			//\bufnum, ~buflib.hat[800].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/4/2,
			\gain, 0.11/1.52,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/blackbottom.flac'),
			\legato, 1.00,
			\speed, Pseq([
				0, 0, 1-12, 1,
			].midiratio,inf),
			\pos, 0 + (Pseq((0..15),inf).stutter(8)/8) / ~t,
			\dur, 1/8,
			\gain, 1,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[1441].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1579].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[348].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[146].value,
			//\bufnum, ~buflib.hat[800].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/4/4,
			\gain, 0.11/1.52,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/blackbottom.flac'),
			\legato, 1.00,
			\speed, Pseq([
				Pseq([
					0, 0, 1-12, 1,
				],1),
			].midiratio,inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,0,0,
				1,1,1,0, 1,1,0,1,
				1,1,1,1, 1,1,0,0,
				1,0,1,1, 1,0,0,1,
			],inf).coin.not,
			\pos, Pseg(Pseq([
				0, 1,
			],1),32).loop / ~t,
			\dur, 1/8,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 1,
			],1),2).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1,
			\isRest, true,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[1441].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1579].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[348].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[146].value,
			//\bufnum, ~buflib.hat[800].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/4/4,
			\gain, 0.11/1.52,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/blackbottom.flac'),
			\legato, Pseg(Pseq([0.1,0.8,1],inf),8),
			\speed, Pseq([
				Pseq([
					0,0,-12,-12,
				],1),
			].midiratio,inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,0,0,
				1,1,1,0, 1,1,0,1,
				1,1,1,1, 1,1,0,0,
				1,0,1,1, 1,0,0,1,
			],inf).coin.not,
			\pos, Pseg(Pseq([
				0, 4,
			],1),32).loop / ~t,
			\dur, 1/8,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 1,
			],1),2).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1,
			\isRest, true,
		)
		
	])
)).play;
);



(
Ndef(\zed, { arg freq=100, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * [1,2] * ( Impulse.kr(8) + ( LFPulse.ar(8.01) * 0.1 + 1 ) ));
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
Ndef(\zed2, { arg freq=100, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar( LFNoise0.ar(0.1) * freq * ( Impulse.kr(8) + ( LFPulse.ar(8.01* [1,2]) * 0.1 + 1 ) ));
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
Ndef(\zed3, { arg freq=100, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq+[1,2]) * 1 + 1 )) * LFPulse.ar(4);
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);
Ndef(\zed).stop;
Ndef(\zed2).stop;


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(8.collect { arg item, idx;
			var dur, tdur=rrand(1,8.0);
			dur = rrand(0.1,tdur-0.1);
			Pseq([
				Pbind(
					\type, \rest,
					\dur, Pn(tdur - dur,1),
				),
				Pseq([
					Pfindur(dur,Pbind(
						\instrument, \playersec,
						\bufnum, BufDef('loop/blackbottom.flac'),
						\legato, 1,
						\st, 129/4/60,
						\speed, rrand(0.2,2.6) * ~t / Pkey(\st),
						\adsr, Pseq([
							[ Env.adsr(0.9,0.1,0.8,0.9) ],
						],inf),
						\pos, Pseg(Pseq([
							0.90, 1,
						],1),8).loop + rrand(0,4.0) / Pkey(\st),
						\dur, rrand(1/16,1/4),
						\gain, 1,
					)),
					Pbind(
						\type, \rest,
						\dur, Pn(tdur - dur,1),
					),
				],inf);
			],1)
			
		});
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(8.collect { arg item, idx;
			var dur, tdur=rrand(1,8.0);
			dur = rrand(0.1,tdur-0.1);
			Pseq([
				Pbind(
					\type, \rest,
					\dur, Pn(tdur - dur,1),
				),
				Pseq([
					Pfindur(dur,Pbind(
						\instrument, \playersec,
						\bufnum, BufDef('loop/blackbottom.flac'),
						\legato, 1,
						\st, 129/4/60,
						\speed, exprand(0.2,2.6) * ~t / Pkey(\st),
						\adsr, Pseq([
							[ Env.adsr(0.9,0.1,0.8,0.9) ],
						],inf),
						\pos, Pseg(Pseq([
							0.90, 4,
						],1),8).loop + rrand(0,4.0) / Pkey(\st),
						\dur, Pwhite(1/16,1/4,inf),
						\gain, 1,
					)),
					Pbind(
						\type, \rest,
						\dur, Pn(tdur - dur,1),
					),
				],inf);
			],1)
			
		});
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \granted,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
	// perc
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[930].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,0,1, 0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,1,
				1,0,0,1, 0,0,0,1, 0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\legato, 4,
			\dur, 1/8/2,
			\gain, 0.1,
		),
	Pbind(
		\instrument, \oscsampler3,
		\pos, 0.937,
		\freq, 187,
		\range, 0.0000001,
		\posenv, Pseq([
			[ Env([0.00,0.02001,0.04].integrate.postln,[0.012,8.1]) ],
		],inf),
		\finepos, 1/400,
		\legato, Pseq([
			1,0,0,0, 0,0,1,0, 0,0,4,0, 0,0,0,0,
			1,1,0,0, 0,0,1,1, 0,0,4,0, 0,0,0,0,
			4,0,0,0, 0,0,4,0, 0,0,4,0, 0,0,0,0,
			2,0,0,2, 0,0,2,0, 2,0,2,0, 0,2,0,0,
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\dur, 1/8/2,
		\fshift, 4,
		\lpmix, 1,
		\rq, 0.4,
		\hpmix, 0,
		\hpfreq, 100,
		\ffreq, Pseq([
			3000,
			//1020,5240,450,700,
		],inf) * Pwhite(0.4,1.3),
		\amp, 0.1/2,
			\bufnum, BufDef('voices/feynman.flac'),

	),
	Pbind(
		\instrument, \oscsampler3,
		\pos, 0.719,
		\freq, 187,
		\range, 0.0000001,
		\posenv, Pseq([
			[ Env([0.00,0.07001,0].integrate.postln,[0.05,8.1]) ],
		],inf),
		\finepos, 1/400,
		\legato, Pseq([
			0,0,1,0, 1,0,0,1,
			4,0,0,3, 0,0,2,0,
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\dur, 1/8,
		\fshift, 40,
		\lpmix, 1,
		\rq, 0.4,
		\hpmix, 0,
		\hpfreq, 100,
		\ffreq, Pseq([
			3000,
			//1020,5240,450,700,
		],inf) * Pwhite(0.4,1.3),
		\amp, 0.1,
			\bufnum, BufDef('voices/feynman.flac'),

	),
	Pbind(
		\instrument, \playersec,
		\bufnum, ~buflib.clap[163].value,
		\isRest, Pseq([
			0,0,0,0, 1,0,0,0,
		],inf).coin.not,
		\legato, 4,
		\dur, 1/8,
		\gain, 0.11,
	),
	Pbind(
		\instrument, \oscsampler3,
		\pos, 0.419,
		\freq, 187,
		\range, 0.0000001,
		\posenv, Pseq([
			[ Env([0.00,0.01001,0].integrate.postln,[0.41,8.1]) ],
		],inf),
		\finepos, 1/400,
		\legato, Pseq([
			4,0,0,0, 1,0,0,1,
		   	0,0,2,0, 1,0,1,1,
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\dur, 1/8,
		\fshift, 40,
		\lpmix, 1,
		\rq, 0.4,
		\hpmix, 0,
		\hpfreq, 100,
		\ffreq, Pseq([
			1020,5240,450,700,
		],inf) * Pseq([1,2,1/2],inf).stutter(4),
		\amp, 0.1/2,
			\bufnum, BufDef('voices/feynman.flac'),

	) 
	])
)).play;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \oscsampler3,
			\pos, 1.517,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.04001,0.36].integrate.postln,[0.047,8.1]) ],
			],inf),
			\finepos, 1/400,
			\legato, Pseq([
				0,0,0,0, 0,0,1,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0, 1,0,0,0, 0,0,1,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.31,0.2,0.4) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8/2,
			\fshift, 4,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 0,
			\hpfreq, 100,
			\ffreq, Pseq([
				3000,
				//1020,5240,450,700,
			],inf) * Pwhite(0.4,1.3),
			\amp, 0.1*7,
			\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('loop/pigs.flac'),

		),
		Pbind(
			\instrument, \oscsampler3,
			\pos, 3.417,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.01001,0.36].integrate.postln,[0.047,8.1]) ],
			],inf),
			\finepos, 1/400,
			\legato, Pseq([
				4,0,0,0, 0,0,1,0, 0,0,4,0, 0,0,0,0,
				2,0,0,1, 0,0,0,0, 0,0,1,0, 0,0,1,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.31,0.2,0.4) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8/2,
			\fshift, 4,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 0,
			\hpfreq, 100,
			\ffreq, Pseq([
				3000,
				//1020,5240,450,700,
			],inf) * Pwhite(0.4,1.3),
			\amp, 0.1*7,
			\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('loop/pigs.flac'),

		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \oscsampler3,
			\pos, 1.517,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.04001,0.36].integrate.postln,[0.047,8.1]) ],
			],inf),
			\finepos, 1/400,
			\legato, Pseq([
				1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.31,0.2,0.4) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8/2,
			\fshift, 4,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 1,
			\hpfreq, 400,
			\ffreq, Pseq([
				3000,
				//1020,5240,450,700,
			],inf) * Pwhite(0.4,1.3),
			\amp, 0.1*7 * Pseq([
				Pser([
					1,0.1,0.1,
					1,0.1,0.4,
				],16),
			],inf),
			\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('loop/pigs.flac'),

		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/blackbottom.flac'),
			//\legato, Pseg(Pseq([0.1,0.8,1],inf),8),
			\legato, 1,
			\speed, Pseq([
				Pseq([
					[0,4,7],
					[0,4,7],
					[0,4,7]+5,
					[0,4,7]+5,
				],inf),
				Pseq([
					0,0,4,7,
				],1),
			].midiratio,inf),
			\isRest, Pseq([
				Pseq([
					1,
				],inf),
				1,1,1,1, 1,1,0,0,
				1,1,1,0, 1,1,0,1,
				1,1,1,1, 1,1,0,0,
				1,0,1,1, 1,0,0,1,
			],inf).coin.not,
			\pos, Pseg(Pseq([0.2,0.4],inf),8).trace,
			\dur, 1/8,
			\gain, 1,
		),
	])
)).play;
);
