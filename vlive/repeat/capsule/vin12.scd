// pharmaceutical cleanroom

~t = 90/4/60; TempoClock.default.tempo = ~t;
(
~master = {
	ProtoDef(\rdn).play;
	ProtoDef(\rdn2).play;
	ProtoDef(\rdn3).play;
};
~master.();
)

(
	~swing=0.3;
Pdef(\part, Pdef(\zed, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1158].value,
			\isRest, Pseq([

				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,1,1,

				1,0,0,0, 0,0,1,1,
				0,1,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1362].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1359].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,1,0,
			],inf).coin.not,
			\lag, 0.132,
			\sustain, 0.05,
			\dur, 1/8,
			\gain, 0.51,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1154].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,1,1,0,
				1,0,1,0, 1,1,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11,
		),
		
	])
)).play;
);

(
	~swing=0.3;
Pdef(\part, Pdef(\zed, 
	Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1154].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,1, 
					1,0,1,0, 1,0,0,0, 
					1,1,1,0, 1,0,1,0, 
					1,0,1,0, 1,0,0,1, 

					1,0,0,0, 1,1,1,0,
					1,0,1,0, 0,0,0,1,
					1,0,1,0, 1,0,1,0,
					1,1,0,1, 0,1,1,0,
				],inf).coin.not ,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),

				\gain, 0.11,
				\sustain, Pseq([0.10,0.02],inf),
				\gain, Pkey(\gain) * Pseq([1,0.6],inf),
				\out, BusDef(\sendbus2, \audio),
			),
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, -1,1,-1,0,
				],inf),
				\lpf, 4000,
				\octave, 3,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),
				\legato, Pseq([
					Pseq([
						8,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						6,0,0,0, 0,0,6,0,
						0,0,0,0, 4,0,0,0,
						2,0,2,0, 0,0,1,0,
						0,1,0,0, 4,0,0,0,
					],inf),
					Pseq([
						8,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf),
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
		
					4,0,0,0, 0,0,2,0,
					0,0,0,0, 0,2,0,0.5,
		
					Pseq([
						3,0,0,3, 0,0,3,0,
						0,0,0,0, 4,0,0,0,
					8,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0.5,0,
					],1),

		
						8,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
		
					8,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0.5,
		
					Pseq([
						3,0,0,3, 0,0,3,0,
						0,0,0,0, 4,0,0,0,
					8,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0.5,0,
					],1),
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\sendbus2, \audio),
			),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1158].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1362].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1762].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,0,1,
					0,1,0,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.61,
				\isRest, true,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1354].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,1,
		
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1155].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
					1,0,0,1, 0,0,1,0, 
					1,0,1,0, 0,1,0,0, 
					1,0,0,1, 0,1,0,0, 
					1,1,0,1, 1,0,0,0, 
				],inf).coin.not ,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),

				\gain, 0.11,
				\sustain, Pseq([0.15,0.02],inf),
				\gain, Pkey(\gain) * Pseq([1,0.6],inf)
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1154].value,
				\isRest, Pseq([
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),

				\gain, 0.11 * Pseq([
					1,1,1,4, 1,1,1,1,
					1,1,1,1, 1,4,1,1,
					
				],inf),
				\sustain, Pseq([0.15,0.02],inf),
				\gain, Pkey(\gain) * Pseq([1,0.2],inf),
				\isRest, true,
			),
		
		])
	]),
)).play;
);




(
	~swing=0.3;
Pdef(\part, Pdef(\zed, 
	Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1154].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,1, 
					1,0,1,0, 1,0,0,0, 
					1,1,1,0, 1,0,1,0, 
					1,0,1,0, 1,0,0,1, 

					1,0,0,0, 1,1,1,0,
					1,0,1,0, 0,0,0,1,
					1,0,1,0, 1,0,1,0,
					1,1,0,1, 0,1,1,0,
				],inf).coin.not ,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),

				\gain, 0.11,
				\sustain, Pseq([0.10,0.02],inf),
				\gain, Pkey(\gain) * Pseq([1,0.6],inf),
				\out, BusDef(\sendbus2, \audio),
			),
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, -1,1,-1,0,
				],inf),
				\lpf, 4000,
				\octave, 3,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),
				\legato, Pseq([
					Pseq([
						8,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						6,0,0,0, 0,0,6,0,
						0,0,0,0, 4,0,0,0,
						2,0,2,0, 0,0,1,0,
						0,1,0,0, 4,0,0,0,
					],inf),
					Pseq([
						8,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf),
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
		
					4,0,0,0, 0,0,2,0,
					0,0,0,0, 0,2,0,0.5,
		
					Pseq([
						3,0,0,3, 0,0,3,0,
						0,0,0,0, 4,0,0,0,
					8,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0.5,0,
					],1),

		
						8,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
		
					8,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0.5,
		
					Pseq([
						3,0,0,3, 0,0,3,0,
						0,0,0,0, 4,0,0,0,
					8,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0.5,0,
					],1),
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\sendbus2, \audio),
			),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1158].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1362].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1762].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,0,1,
					0,1,0,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.61,
				\isRest, true,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1354].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,1,
		
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1155].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
					1,0,0,1, 0,0,1,0, 
					1,0,1,0, 0,1,0,0, 
					1,0,0,1, 0,1,0,0, 
					1,1,0,1, 1,0,0,0, 
				],inf).coin.not ,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),

				\gain, 0.11,
				\sustain, Pseq([0.15,0.02],inf),
				\gain, Pkey(\gain) * Pseq([1,0.6],inf)
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1154].value,
				\isRest, Pseq([
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),

				\gain, 0.11 * Pseq([
					1,1,1,4, 1,1,1,1,
					1,1,1,1, 1,4,1,1,
					
				],inf),
				\sustain, Pseq([0.15,0.02],inf),
				\gain, Pkey(\gain) * Pseq([1,0.2],inf),
				\isRest, true,
			),
		
		])
	]),
)).play;
);

(
Pdef(\part, Pdef(\perc1, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1158].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,

					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,0,1, 1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1362].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1158].value,
				\isRest, Pseq([
					1,0,0, 0,0,0, 1,0,1, 1,0,0,
					1,0,0, 0,0,0, 1,0,1, 1,0,1,
					1,0,0, 0,0,1, 1,0,1, 1,0,0,
					1,0,0, 0,0,0, 1,0,1, 1,0,1,

					1,0,0, 0,0,0, 1,0,1, 1,0,0,
					1,0,0, 0,0,0, 1,0,1, 1,0,1,
					1,0,0, 0,0,1, 1,0,1, 1,0,0,
					1,1,0, 1,0,1,  1,0,0, 1,1,1,
				],inf).coin.not,
				\dur, 1/12,
				//\dur, Pkey(\dur) * (1 + (~swing * Pseq([0,1,0,-1],inf))),
				\gain, 0.3,
			),
		
		]),
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, -1,1,-1,0,
				],inf),
				\lpf, 4000,
				\octave, 3,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),
				\legato, Pseq([
					Pseq([
						8,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						6,0,0,0, 0,0,6,0,
						0,0,0,0, 4,0,0,0,
						2,0,2,0, 0,0,1,0,
						0,1,0,0, 4,0,0,0,
					],inf),
					Pseq([
						8,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf),
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
		
					4,0,0,0, 0,0,2,0,
					0,0,0,0, 0,2,0,0.5,
		
					Pseq([
						3,0,0,3, 0,0,3,0,
						0,0,0,0, 4,0,0,0,
					8,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0.5,0,
					],1),

		
						8,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
		
					8,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0.5,
		
					Pseq([
						3,0,0,3, 0,0,3,0,
						0,0,0,0, 4,0,0,0,
					8,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0.5,0,
					],1),
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\sendbus2, \audio),
			),
		
	])
)).play;
);


BufDef(\wishing, "acapella/Edo G Ft. Masta Ace - Wishing (Acapella)-1.flac")
SampleTimeline(\wishing).buffer = BufDef(\wishing)
SampleTimeline(\wishing).edit
ClipTimeline(\vin12_p1).edit
ClipTimeline(\vin12_p1).samplesPresetCompileString.editorInsert
(

(
SampleTimeline('rec_vin12_p1_t1_200216_195941').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 96.0, \label: 'start', \playDur: 96.0, \relDur: 96.0, \sustain: 0, \type: 'start', ),
	(\absTime: 96.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_vin12_p1_t1_200216_195941').buffer = BufDef('./rec_vin12_p1_t1_200216_195941.wav');
SampleTimeline('rec_vin12_p1_t1_200216_232429').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 12.0, \label: 'start', \playDur: 12.0, \relDur: 12.0, \sustain: 0, \type: 'start', ),
	(\absTime: 12.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_vin12_p1_t1_200216_232429').buffer = BufDef('./rec_vin12_p1_t1_200216_232429.wav');
SampleTimeline('rec_vin12_p1_t2_200216_193941').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 108.0, \label: 'start', \playDur: 108.0, \relDur: 108.0, \sustain: 0, \type: 'start', ),
	(\absTime: 108.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_vin12_p1_t2_200216_193941').buffer = BufDef('./rec_vin12_p1_t2_200216_193941.wav');
SampleTimeline('wishing').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 94.0, \label: 'start', \playDur: 94.0, \relDur: 94.0, \sustain: 0, \type: 'start', ),
	(\absTime: 94.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('wishing').buffer = BufDef('wishing');
SampleTimeline('rec_vin12_p1_t1_200216_211303').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 114.0, \label: 'start', \playDur: 114.0, \relDur: 114.0, \sustain: 0, \type: 'start', ),
	(\absTime: 114.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_vin12_p1_t1_200216_211303').buffer = BufDef('./rec_vin12_p1_t1_200216_211303.wav');
SampleTimeline('rec_vin12_p1_t1_200216_212021').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 8.0, \label: 'start', \playDur: 8.0, \relDur: 8.0, \sustain: 0, \type: 'start', ),
	(\absTime: 8.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_vin12_p1_t1_200216_212021').buffer = BufDef('./rec_vin12_p1_t1_200216_212021.wav');
SampleTimeline('rec_vin12_p1_t2_200216_192348').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 76.0, \label: 'start', \playDur: 76.0, \relDur: 76.0, \sustain: 0, \type: 'start', ),
	(\absTime: 76.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_vin12_p1_t2_200216_192348').buffer = BufDef('./rec_vin12_p1_t2_200216_192348.wav');
)

);



BufDef.clear(\wishing)
BufDef.all[\wishing] = nil

(
Pdef(\part, Pdef(\intro, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1158].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					1,0,0,1, 1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1362].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
		
		]),
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, -1,1,-1,0,
				],inf),
				\lpf, 4000,
				\octave, 3,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),
				\legato, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						8,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf),
					Pseq([
						8,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf),
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
		
					4,0,0,0, 0,0,2,0,
					0,0,0,0, 0,2,0,0.5,
		
					Pseq([
						3,0,0,3, 0,0,3,0,
						0,0,0,0, 4,0,0,0,
					8,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0.5,0,
					],1),

		
						8,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
		
					8,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0.5,
		
					Pseq([
						3,0,0,3, 0,0,3,0,
						0,0,0,0, 4,0,0,0,
					8,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0.5,0,
					],1),
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\sendbus2, \audio),
			),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\perc1ghost, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1158].value,
				\isRest, Pseq([
					Prand([
						Pseq([
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0.1,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,1,
							1,0,0,0, 0,0,0,1,
							1,0,1,1, 0,1,0,1,
							1,0,0,0, 0,0,1,0,
						],1),
						Pseq([
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0.1,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,1,
							0,0,1,0, 0,1,0,1,
							1,0,0,0, 0,0,0,1,
							1,0,0,0, 0,0,1,0,
						],1),
						Pseq([
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,1,
							1,1,0.51,1, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0.2,1,
						],1),
					],1),
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1612].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					Prand([
						Pseq([
							0,0,0,0, 0,0,0,0,
							0,1,0,0, 1,0,0,0,
							0,0,0,0, 1,0,0,0,
							0,0,0,0, 0,0,1,0,
						],1),
						Pseq([
							0,0,0,0, 1,0,0,0,
							0,0,0,0, 1,0,0,0,
							0,0,0,0, 1,0,0,0,
							0,0,0,0, 0,0,1,0,
						],1),
					],1),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1158].value,
				\isRest, Pseq([
					Prand([
						Pseq([
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							1,0,1,0, 1,0,1,0,
						],1),
						Pseq([
							1,0,0,0, 1,1,1,0,
							0,1,0,0, 1,0,0,0,
							1,0,0,0, 1,0,0,0,
							1,0,0,1, 1,1,1,0,
						],1),
						Pseq([
							1,0,0,0, 1,0,0,0,
							1,0,1,0, 1,0,1,1,
							1,0,0,0, 1,0,0,0,
							1,0,0,1, 1,1,1,0,
						],1),
					],1),
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([0,1,0,-1],inf))),
				\gain, 0.3,
			),
		
		]),
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, -1,1,-1,0,
				],inf),
				\lpf, 4000,
				\octave, 3,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),
				\legato, Pseq([
					Pseq([
						8,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						6,0,0,0, 0,0,6,0,
						0,0,0,0, 4,0,0,0,
						2,0,2,0, 0,0,1,0,
						0,1,0,0, 4,0,0,0,
					],inf),
					Pseq([
						8,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf),
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
		
					4,0,0,0, 0,0,2,0,
					0,0,0,0, 0,2,0,0.5,
		
					Pseq([
						3,0,0,3, 0,0,3,0,
						0,0,0,0, 4,0,0,0,
					8,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0.5,0,
					],1),

		
						8,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
		
					8,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0.5,
		
					Pseq([
						3,0,0,3, 0,0,3,0,
						0,0,0,0, 4,0,0,0,
					8,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0.5,0,
					],1),
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\sendbus2, \audio),
			),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\intro2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1110].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
			\gain, 0.3,
		),
		
	])
)).play;
);


(
SynthDef(\ambifall, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	RandSeed.kr(1,1000);
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
	sig = ( WhiteNoise.ar + 0.8 ) * LFSaw.ar({ exprand(10.0,10000) }!20 * ( 1 + ( SinOsc.ar((1..4).rand(0.0)/18 * XLine.kr(1,121200,80)) * 1/41 * XLine.kr(1,180,60) )));
	sig = DelayC.ar(sig, 0.2, {rrand(1/5,1/10000) * ( 1 + ( SinOsc.ar((1..2).rand(0.0)/18 * XLine.kr(1,121200,60)) * 1/41 * XLine.kr(1,180,60) ))}!4) + sig / 2;
	sig = DelayC.ar(sig, 0.2, {rrand(1/5,1/10000) * XLine.kr(1,1/1000,14)}!4) + sig / 2;
	sig = sig + BPF.ar(
		sig, 
		{ ( exprand(100.0,10000) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(20,20000) }!10,
		{ ( rand(0.01,1) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(0.01,1) }!10
	);
	sig = BRF.ar(
		sig, 
		{ ( exprand(100.0,10000) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(20,20000) }!10,
		{ ( rand(0.01,1) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(0.01,1) }!10
	);
	sig = LeakDC.ar(sig);
	sig = LPF.ar(sig, 17000 * XLine.kr(1/100,1,4));
	sig = sig * 5 * 3;
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\ambifall2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	RandSeed.kr(1,1000);
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
	sig = ( WhiteNoise.ar + 0.8 ) * LFSaw.ar({ exprand(10.0,10000) }!20 * ( 1 + ( SinOsc.ar((1..4).rand(0.0)/18 * XLine.kr(1,121200,80)) * 1/41 * XLine.kr(freq,freq/1.3,60) )));
	sig = DelayC.ar(sig, 0.2, {rrand(1/5,1/10000) * ( 1 + ( SinOsc.ar((1..2).rand(0.0)/18 * XLine.kr(1,121200,60)) * 1/41 * XLine.kr(1,180,60) ))}!4) + sig / 2;
	sig = DelayC.ar(sig, 0.2, {rrand(1/5,1/10000) * XLine.kr(1,1/1000,14)}!4) + sig / 2;
	sig = sig + BPF.ar(
		sig, 
		{ ( exprand(100.0,10000) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(20,20000) }!10,
		{ ( rand(0.01,1) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(0.01,1) }!10
	);
	sig = BRF.ar(
		sig, 
		{ ( exprand(100.0,10000) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(20,20000) }!10,
		{ ( rand(0.01,1) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(0.01,1) }!10
	);
	sig = LeakDC.ar(sig);
	sig = LPF.ar(sig, 17000 * XLine.kr(1/100,1,4));
	sig = sig * 5 * 3;
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\ambifall3, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
	sig = ( WhiteNoise.ar + 0.8 ) * LFSaw.ar({ exprand(10.0,10000) }!20 * ( 1 + ( SinOsc.ar((1..4).rand(0.0)/18 * XLine.kr(1,121200,80)) * 1/41 * XLine.kr(1,0.1,60) )));
	sig = DelayC.ar(sig, 0.2, {rrand(1/5,1/10000) * ( 1 + ( SinOsc.ar((1..2).rand(0.0)/18 * XLine.kr(42,11200,60)) * 1/41 * XLine.kr(1,180,60) ))}!4) + sig / 2;
	sig = DelayC.ar(sig, 0.2, {rrand(1/5,1/10000) * XLine.kr(1/1000,1/20001,14)}!4) + sig / 2;
	sig = sig + BPF.ar(
		sig, 
		{ ( exprand(100.0,15000) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(20,20000) }!10,
		{ ( rand(0.01,1) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(0.01,1) }!10
	);
	sig = BRF.ar(
		sig, 
		{ ( exprand(100.0,15000) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(20,20000) }!10,
		{ ( rand(0.01,1) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(0.01,1) }!10
	);
	sig = LeakDC.ar(sig);
	sig = LPF.ar(sig, 17000 * XLine.kr(1,1/100,4));
	sig = sig * 5 * 3;
	sig = sig.mean;
	//sig = sig.clip;
	//sig = Compander.ar(sig, sig, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.009), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = Limiter.ar(sig, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,4.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);
(
Pdef(\part, Pdef(\ambifall3, 
		Pbind(
			\instrument, \ambifall3,
			\freq, 200,
			\dur, Pn(4,1),
			\amp, 0.2,
		),
)).play;
);
(
Pdef(\part, Pdef(\ambifall3loop, 
	Ppar([
		Pseq([
			Pmono(\ambifall3,
				\freq, 2,
				\dur, Pseq([1],2),
				\amp, 0.1,
			),
			Event.silent(2),
		],inf),
	])
)).play;
);
(
Pdef(\part, Pdef(\ambifall2, 
	Pbind(\instrument, \ambifall2,
		\freq, 2,
		\legato, 1,
		\dur, Pseq([2],1),
		\amp, 0.1,
	),
)).play;
);
(
Pdef(\part, Pdef(\ambifall, 
	Ppar([
		Pmono(\ambifall,
			\freq, 200,
			\dur, Pseq([1],8),
			\amp, 0.1,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\ambifall3perc, 
	Ppar([
		Pseq([
			Pmono(\ambifall3,
				\freq, 2,
				\dur, Pseq([1],2),
				\amp, 0.1,
			),
			Event.silent(2),
		],inf),
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1158].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,

					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,0,1, 1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1362].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1158].value,
				\isRest, Pseq([
					1,0,0, 0,0,0, 1,0,1, 1,0,0,
					1,0,0, 0,0,0, 1,0,1, 1,0,1,
					1,0,0, 0,0,1, 1,0,1, 1,0,0,
					1,0,0, 0,0,0, 1,0,1, 1,0,1,

					1,0,0, 0,0,0, 1,0,1, 1,0,0,
					1,0,0, 0,0,0, 1,0,1, 1,0,1,
					1,0,0, 0,0,1, 1,0,1, 1,0,0,
					1,1,0, 1,0,1,  1,0,0, 1,1,1,
				],inf).coin.not,
				\dur, 1/12,
				//\dur, Pkey(\dur) * (1 + (~swing * Pseq([0,1,0,-1],inf))),
				\gain, 0.3,
			),
		
		]),
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, -1,1,-1,0,
				],inf),
				\lpf, 4000,
				\octave, 3,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),
				\legato, Pseq([
					Pseq([
						8,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						6,0,0,0, 0,0,6,0,
						0,0,0,0, 4,0,0,0,
						2,0,2,0, 0,0,1,0,
						0,1,0,0, 4,0,0,0,
					],inf),
					Pseq([
						8,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf),
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
		
					4,0,0,0, 0,0,2,0,
					0,0,0,0, 0,2,0,0.5,
		
					Pseq([
						3,0,0,3, 0,0,3,0,
						0,0,0,0, 4,0,0,0,
					8,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0.5,0,
					],1),

		
						8,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
		
					8,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0.5,
		
					Pseq([
						3,0,0,3, 0,0,3,0,
						0,0,0,0, 4,0,0,0,
					8,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0.5,0,
					],1),
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\sendbus2, \audio),
			),
		
	])
	])
)).play;
);


(\fall, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = ( WhiteNoise.ar + 0.8 ) * LFSaw.ar({ exprand(10.0,10000) }!20 * ( 1 + ( SinOsc.ar((1..4).rand(0.0)/18 * XLine.kr(1,121200,80)) * 1/41 * XLine.kr(1,180,60) )));
	sig = DelayC.ar(sig, 0.2, {rrand(1/5,1/10000) * ( 1 + ( SinOsc.ar((1..2).rand(0.0)/18 * XLine.kr(1,121200,60)) * 1/41 * XLine.kr(1,180,60) ))}!4) + sig / 2;
	sig = DelayC.ar(sig, 0.2, {rrand(1/5,1/10000) * XLine.kr(1,1/1000,14)}!4) + sig / 2;
	sig = sig + BPF.ar(
		sig, 
		{ ( exprand(100.0,10000) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(20,20000) }!10,
		{ ( rand(0.01,1) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(0.01,1) }!10
	);
	sig = BRF.ar(
		sig, 
		{ ( exprand(100.0,10000) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(20,20000) }!10,
		{ ( rand(0.01,1) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(0.01,1) }!10
	);
	sig = LeakDC.ar(sig);
	sig = LPF.ar(sig, 17000 * XLine.kr(1/100,1,4));
	sig = sig * 5 * 3;
	sig = sig.mean;
	sig = sig * amp;
	sig;
}).play;





