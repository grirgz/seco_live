
~t = 192/4/60; TempoClock.default.tempo = ~t;

// demo
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,0,1, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
		)),
		
	])
)).play;
);
PatKitDef(\comkit).edit

///////////////////////////////////////////////
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,

				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,1,
				1,1,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,0,1,0,

				1,0,1,0, 1,0,1,0,
				1,1,0,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,1,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
		)),
		
	])
)).play;
);





(
	// funky
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				-1, 0,
			],inf).stutter(2),
			\octave, 3,
			\legato, Pseq([
				4,0,0,0,
				0,0,0,0, 
				0,0,0,0,
			   	0,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/8,
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.0001,0.1,0.8,0.2) ],
			],inf),
			\sustain, 0.1,
			\dur, 1/8,
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.0001,0.1,0.8,0.2) ],
			],inf),
			\sustain, 0.1,
			\velamp, 1/2,
			\dur, 1/8,
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 12,
			\isRest, Pseq([
				1,0,0,0, 1,0,1,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.0001,0.1,0.8,0.2) ],
			],inf),
			\sustain, Pseq([0.3,0.05,0.051,0.051],inf),
			\dur, 1/8,
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 13,
			\isRest, Pseq([
				0,0,0,0, 0,1,0,1,
				0,1,0,0, 0,0,0,1,

				0,0,0,0, 0,1,0,1,
				0,1,1,0, 0,0,0,1,

				0,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.0001,0.1,0.8,0.02) ],
			],inf),
			\velamp, 1/2,
			\sustain, Pseq([0.13,0.16],inf),
			\dur, 1/8,
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 1,1,0,0,
				1,0,1,1, 0,0,0,0,
				0,0,0,0, 0,1,1,0,
				0,1,1,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.0001,0.1,0.8,0.02) ],
			],inf),
			\velamp, 1,
			\sustain, 0.1,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/lovereggae.wav'),
			\speed, ~pmodenv.(Pseq([1,1/4],inf).stutter(2), Prand([1],inf)),
			\legato, 1.5,
			\pos, Pseq([
				Prand((1..8)/8)
			],inf),
			\pos, Pseq((1..8)/4,inf),
			\dur, 1/2+Prand([1/4,1/8,1/16],inf),
			\dur, 1,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/lovereggae.wav'),
			//\speed, ~pmodenv.(Pseq([1,1.02,1,0.91,1,2,1/2],inf).stutter(2), Prand([0.1,1],inf)),
			\legato, 1,
			//\speed, 1 * ( -3+12-5 ).midiratio,
			\pos, 3.67 + (
				Pseq([
					0.6,0.7,
					0.65,0.68,
				],inf)+5.2
			),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/lovereggae.wav'),
			//\speed, ~pmodenv.(Pseq([1,1.02,1,0.91,1,2,1/2],inf).stutter(2), Prand([0.1,1],inf)),
			\legato, 1,
			//\speed, 1 * ( -3+12-5 ).midiratio,
			\pos, 3.67 + (
				Pseq([
					0.6,0.7,
					0.65,0.29,
				],inf)+5.8
			),
			\legato, Pseq([
				0,0,0,0, 0,0,0,1,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 0,0,0,1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/3,
		),

		
	])
)).play;
);



(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				-1, 0,
			],inf).stutter(2),
			\octave, 3,
			\legato, Pseq([
				4,0,0,0,
				0,0,0,0, 
				0,0,0,0,
			   	0,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,1,0,

				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,1,0,
				1,0,0,0.51, 0,0,0,1,
				1,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/8,
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.0001,0.1,0.8,0.2) ],
			],inf),
			\sustain, 0.1,
			\dur, 1/8,
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.0001,0.1,0.8,0.2) ],
			],inf),
			\sustain, 0.1,
			\velamp, 1/2,
			\dur, 1/8,
		)),

		// hat

		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 12,
			\isRest, Pseq([
				1,0,0,0, 1,0,1,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.0001,0.1,0.8,0.2) ],
			],inf),
			\sustain, Pseq([0.3,0.05,0.051,0.051],inf),
			\dur, 1/8,
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 13,
			\isRest, Pseq([
				0,0,0,0, 0,1,0,1,
				0,1,0,0, 0,0,0,1,

				0,0,0,0, 0,1,0,1,
				0,1,1,0, 0,0,0,1,

				0,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.0001,0.1,0.8,0.02) ],
			],inf),
			\velamp, 1/2,
			\sustain, Pseq([0.13,0.16],inf),
			\dur, 1/8,
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 1,1,0,0,
				1,0,1,1, 0,0,0,0,
				0,0,0,0, 0,1,1,0,
				0,1,1,0, 0,0,0,0,

				0,0,1,0, 1,1,0,0,
				1,0,1,1, 0,0,1,0,
				0,0,0,1, 0,1,1,0,
				0,1,1,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.0001,0.1,0.8,0.02) ],
			],inf),
			\velamp, 1,
			\sustain, 0.1,
			\dur, 1/8,
		)),

		/// smp

		//Pbind(
			//\instrument, \playersec,
			//\bufnum, BufDef('vipere/lovereggae.wav'),
			//\speed, ~pmodenv.(Pseq([1,1/4],inf).stutter(2), Prand([1],inf)),
			//\legato, 1.5,
			//\pos, Pseq([
				//Prand((1..8)/8)
			//],inf),
			//\pos, Pseq((1..8)/4,inf),
			//\dur, 1/2+Prand([1/4,1/8,1/16],inf),
			//\dur, 1,
			//\gain, 1,
		//),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/lovereggae.wav'),
			//\speed, ~pmodenv.(Pseq([1,1.02,1,0.91,1,2,1/2],inf).stutter(2), Prand([0.1,1],inf)),
			\legato, 1,
			//\speed, 1 * ( -3+12-5 ).midiratio,
			\speed, -1,
			\pos, 3.67 + (
				Pseq([
					0.6,0.7,
					0.65,0.68,
				],inf)+5.2
			),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/lovereggae.wav'),
			//\speed, ~pmodenv.(Pseq([1,1.02,1,0.91,1,2,1/2],inf).stutter(2), Prand([0.1,1],inf)),
			\legato, 1,
			//\speed, 1 * ( -3+12-5 ).midiratio,
			\pos, 3.67 + (
				Pseq([
					0.6,0.7, 0.65,0.09,
					0.6,0.7, 0.65,0.29,
				],inf)+4.15
			),
			\legato, Pseq([
				0,0,0,0, 0,0,0,1,
				1,0,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,1,

				0,0,0,0, 0,0,0,1,
				1,0,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,1, 1,0,1,1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/3,
			\isRest, true,
		),
		NoteTimeline(\piano).asPattern,

		
	])
)).play;
);
		NoteTimeline(\piano).edit
		NoteTimeline(\piano).presetCompileString.editorInsert
(
NoteTimeline('piano').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 1.5, \label: 'start', \playDur: 1.5, \relDur: 1.5, \sustain: 0, \type: 'start', ),
	(\absTime: 1.5, \dur: 0.125, \midinote: 97.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.625, \dur: 0.0, \midinote: 94.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 1.625, \dur: 0.125, \midinote: 86.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.75, \dur: 0.125, \midinote: 79.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.875, \dur: 1.375, \midinote: 72.0, \playDur: 1.375, \relDur: 1.375, \sustain: 0.1, ),
	(\absTime: 3.25, \dur: 0.25, \midinote: 97.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 3.5, \dur: 0.125, \midinote: 97.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 3.625, \dur: 0.0, \midinote: 94.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 3.625, \dur: 0.125, \midinote: 86.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 3.75, \dur: 0.125, \midinote: 79.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 3.875, \dur: 0.125, \midinote: 72.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);




////////////


(
Pdef(\part2, Pdef(\zed2, 
	Ppar([
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,1,0,

				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,1,0,
				1,0,0,0.51, 0,0,0,1,
				1,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
		
	])
)).play;
);
Pdef(\part2).stop

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				-1, 0,
			],inf).stutter(2),
			\octave, 3,
			\legato, Pseq([
				4,0,0,0,
				0,0,0,0, 
				0,0,0,0,
			   	0,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,1,0,

				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,1,0,
				1,0,0,0.51, 0,0,0,1,
				1,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/3,
				\dur, 1/8,
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.1,0.8,0.2) ],
				],inf),
				\sustain, 0.1,
				\dur, 1/8,
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.1,0.8,0.2) ],
				],inf),
				\sustain, 0.1,
				\velamp, 1/2,
				\dur, 1/8,
			)),
		]),

		Pbind(
			\lag, 0.04,
		) <> Ppar([
			
			// hat
			
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 12,
				\isRest, Pseq([
					1,0,0,0, 1,0,1,0,
					1,0,0,0, 1,0,1,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.1,0.8,0.2) ],
				],inf),
				\sustain, Pseq([0.3,0.05,0.051,0.051],inf),
				\dur, 1/8,
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 13,
				\isRest, Pseq([
					0,0,0,0, 0,1,0,1,
					0,1,0,0, 0,0,0,1,
			
					0,0,0,0, 0,1,0,1,
					0,1,1,0, 0,0,0,1,
			
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.1,0.8,0.02) ],
				],inf),
				\velamp, 1/2,
				\sustain, Pseq([0.13,0.16],inf),
				\dur, 1/8,
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0,0, 1,1,0,0,
					1,0,1,1, 0,0,0,0,
					0,0,0,0, 0,1,1,0,
					0,1,1,0, 0,0,0,0,
			
					0,0,1,0, 1,1,0,0,
					1,0,1,1, 0,0,1,0,
					0,0,0,1, 0,1,1,0,
					0,1,1,0, 0,0,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.1,0.8,0.02) ],
				],inf),
				\velamp, 1,
				\sustain, 0.1,
				\dur, 1/8,
			)),
			
			/// smp
			
			//Pbind(
				//\instrument, \playersec,
				//\bufnum, BufDef('vipere/lovereggae.wav'),
				//\speed, ~pmodenv.(Pseq([1,1/4],inf).stutter(2), Prand([1],inf)),
				//\legato, 1.5,
				//\pos, Pseq([
					//Prand((1..8)/8)
				//],inf),
				//\pos, Pseq((1..8)/4,inf),
				//\dur, 1/2+Prand([1/4,1/8,1/16],inf),
				//\dur, 1,
				//\gain, 1,
			//),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('vipere/lovereggae.wav'),
				//\speed, ~pmodenv.(Pseq([1,1.02,1,0.91,1,2,1/2],inf).stutter(2), Prand([0.1,1],inf)),
				\legato, 1,
				//\speed, 1 * ( -3+12-5 ).midiratio,
				\speed, -1,
				\pos, 3.67 + (
					Pseq([
						0.6,0.7,
						0.65,0.68,
					],inf)+5.2
				),
				\legato, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\gain, 1/3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('vipere/lovereggae.wav'),
				//\speed, ~pmodenv.(Pseq([1,1.02,1,0.91,1,2,1/2],inf).stutter(2), Prand([0.1,1],inf)),
				\legato, 1,
				//\speed, 1 * ( -3+12-5 ).midiratio,
				\pos, 3.67 + (
					Pseq([
						0.6,0.7, 0.65,0.09,
						0.6,0.7, 0.65,0.29,
					],inf)+4.15
				),
				\legato, Pseq([
					0,0,0,0, 0,0,0,1,
					1,0,1,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,1,1,
			
					0,0,0,0, 0,0,0,1,
					1,0,1,1, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					1,0,0,1, 1,0,1,1,
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.3) ],
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\gain, 1/3,
				\isRest, true,
			),
			NoteTimeline(\piano).asPattern,
		]),

		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,0,0,0,
				-1, -1, -1, -1, 
				0,0,0,0,
				-1, -1, 1, 1, 
			],inf).stutter(2),
			\octave, 3,
			\legato, Pseq([
				1,0,0,0,
				4,0,0,0,
				0,1,0,0,
				0,0,2,0,
				4,0,0,0,
				1,1,1,0,
				4,0,0,0,
				0,0,2,0,
			],inf) * Pseg(Pseq([1,0.1],inf),8),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,1, 0,0,1,1,

			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,1,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,1,
					0,0,0,0, 0,0,1,1,
					0,0,0,0, 0,1,1,0,
					0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/3,
				\dur, 1/8,
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.1,0.8,0.2) ],
				],inf),
				\sustain, 0.1,
				\dur, 1/8,
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.1,0.8,0.2) ],
				],inf),
				\sustain, 0.1,
				\velamp, 1/2,
				\dur, 1/8,
			)),
		]),

		Pbind(
			\lag, 0.04,
		) <> Ppar([
			
			// hat
			
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 12,
				\isRest, Pseq([
					1,0,0,0, 1,0,1,0,
					1,0,0,0, 1,0,1,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.1,0.8,0.2) ],
				],inf),
				\sustain, Pseq([0.3,0.05,0.051,0.051],inf),
				\dur, 1/8,
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 13,
				\isRest, Pseq([
					0,0,0,0, 0,1,0,1,
					0,1,0,0, 0,0,0,1,
			
					0,0,0,0, 0,1,0,1,
					0,1,1,0, 0,0,0,1,
			
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.1,0.8,0.02) ],
				],inf),
				\velamp, 1/2,
				\sustain, Pseq([0.13,0.16],inf),
				\dur, 1/8,
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0,0, 1,1,0,0,
					1,0,1,1, 0,0,0,0,
					0,0,0,0, 0,1,1,0,
					0,1,1,0, 0,0,0,0,
			
					0,0,1,0, 1,1,0,0,
					1,0,1,1, 0,0,1,0,
					0,0,0,1, 0,1,1,0,
					0,1,1,0, 0,0,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.1,0.8,0.02) ],
				],inf),
				\velamp, 1,
				\sustain, 0.1,
				\dur, 1/8,
			)),
			
			/// smp
			
			//Pbind(
				//\instrument, \playersec,
				//\bufnum, BufDef('vipere/lovereggae.wav'),
				//\speed, ~pmodenv.(Pseq([1,1/4],inf).stutter(2), Prand([1],inf)),
				//\legato, 1.5,
				//\pos, Pseq([
					//Prand((1..8)/8)
				//],inf),
				//\pos, Pseq((1..8)/4,inf),
				//\dur, 1/2+Prand([1/4,1/8,1/16],inf),
				//\dur, 1,
				//\gain, 1,
			//),

			Pbind(\out, BusDef(\sendbus3, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('vipere/lovereggae.wav'),
					//\speed, ~pmodenv.(Pseq([1,1.02,1,0.91,1,2,1/2],inf).stutter(2), Prand([0.1,1],inf)),
					\legato, 1,
					//\speed, 1 * ( -3+12-5 ).midiratio,
					\speed, -1,
					\pos, 3.67 + (
						Pseq([
							0.6,0.7,
							0.65,0.68,
						],inf)+5.2
					),
					\legato, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,0,
					],inf),
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.4) ],
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\dur, 1/8,
					\gain, 1/3,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('vipere/lovereggae.wav'),
					//\speed, ~pmodenv.(Pseq([1,1.02,1,0.91,1,2,1/2],inf).stutter(2), Prand([0.1,1],inf)),
					\legato, 1,
					//\speed, 1 * ( -3+12-5 ).midiratio,
					\pos, 3.67 + (
						Pseq([
							0.6,0.7, 0.65,0.09,
							0.6,0.7, 0.65,0.29,
						],inf)+4.15
					),
					\legato, Pseq([
						0,0,0,0, 0,0,0,1,
						1,0,1,1, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,1, 0,0,1,1,
				
						0,0,0,0, 0,0,0,1,
						1,0,1,1, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
						1,0,0,1, 1,0,1,1,
					],inf),
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.3) ],
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\dur, 1/8,
					\gain, 1/3,
				),
			]),
		]),

		
	])
)).play;
);

// sans hat
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,0,0,0,
				-1, -1, -1, -1, 
				0,0,0,0,
				-1, -1, 1, 1, 
			],inf).stutter(2),
			\octave, 3,
			\legato, Pseq([
				1,0,0,0,
				4,0,0,0,
				0,1,0,0,
				0,0,2,0,
				4,0,0,0,
				1,1,1,0,
				4,0,0,0,
				0,0,2,0,
			],inf) * Pseg(Pseq([1,0.1],inf),8),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,1, 0,0,1,1,

			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,1,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,1,
					0,0,0,0, 0,0,1,1,
					0,0,0,0, 0,1,1,0,
					0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/3,
				\dur, 1/8,
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.1,0.8,0.2) ],
				],inf),
				\sustain, 0.1,
				\dur, 1/8,
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.1,0.8,0.2) ],
				],inf),
				\sustain, 0.1,
				\velamp, 1/2,
				\dur, 1/8,
			)),
		]),

		Pbind(
			\lag, 0.04,
			\isRest, true,
			//\out, BusDef(\sendbus3, \audio),
		) <> Ppar([
			
			// hat
			
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 12,
				\isRest, Pseq([
					1,0,0,0, 1,0,1,0,
					1,0,0,0, 1,0,1,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.1,0.8,0.2) ],
				],inf),
				\sustain, Pseq([0.3,0.05,0.051,0.051],inf),
				\dur, 1/8,
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 13,
				\isRest, Pseq([
					0,0,0,0, 0,1,0,1,
					0,1,0,0, 0,0,0,1,
			
					0,0,0,0, 0,1,0,1,
					0,1,1,0, 0,0,0,1,
			
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.1,0.8,0.02) ],
				],inf),
				\velamp, 1/2,
				\sustain, Pseq([0.13,0.16],inf),
				\dur, 1/8,
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0,0, 1,1,0,0,
					1,0,1,1, 0,0,0,0,
					0,0,0,0, 0,1,1,0,
					0,1,1,0, 0,0,0,0,
			
					0,0,1,0, 1,1,0,0,
					1,0,1,1, 0,0,1,0,
					0,0,0,1, 0,1,1,0,
					0,1,1,0, 0,0,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.1,0.8,0.02) ],
				],inf),
				\velamp, 1,
				\sustain, 0.1,
				\dur, 1/8,
			)),
			
			/// smp
			
			//Pbind(
				//\instrument, \playersec,
				//\bufnum, BufDef('vipere/lovereggae.wav'),
				//\speed, ~pmodenv.(Pseq([1,1/4],inf).stutter(2), Prand([1],inf)),
				//\legato, 1.5,
				//\pos, Pseq([
					//Prand((1..8)/8)
				//],inf),
				//\pos, Pseq((1..8)/4,inf),
				//\dur, 1/2+Prand([1/4,1/8,1/16],inf),
				//\dur, 1,
				//\gain, 1,
			//),

		]),

			Pbind(\out, BusDef(\sendbus3, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('vipere/lovereggae.wav'),
					//\speed, ~pmodenv.(Pseq([1,1.02,1,0.91,1,2,1/2],inf).stutter(2), Prand([0.1,1],inf)),
					\legato, 1,
					//\speed, 1 * ( -3+12-5 ).midiratio,
					\speed, -1,
					\pos, 3.67 + (
						Pseq([
							0.6,0.7,
							0.65,0.68,
						],inf)+5.2
					),
					\legato, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,0,
					],inf),
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.4) ],
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\dur, 1/8,
					\gain, 1/3,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('vipere/lovereggae.wav'),
					//\speed, ~pmodenv.(Pseq([1,1.02,1,0.91,1,2,1/2],inf).stutter(2), Prand([0.1,1],inf)),
					\legato, 1,
					//\speed, 1 * ( -3+12-5 ).midiratio,
					\pos, 3.67 + (
						Pseq([
							0.6,0.7, 0.65,0.09,
							0.6,0.7, 0.65,0.29,
						],inf)+4.15
					),
					\legato, Pseq([
						0,0,0,0, 0,0,0,1,
						1,0,1,1, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,1, 0,0,1,1,
				
						0,0,0,0, 0,0,0,1,
						1,0,1,1, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
						1,0,0,1, 1,0,1,1,
					],inf),
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.3) ],
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\dur, 1/8,
					\gain, 1/3,
				),
			]),
		
	])
)).play;
);

///////////////////////////////// RDN
////////////

ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef(\rdn, ProtoTemplateDef(\rdn));
ProtoDef('rdn').make('del3full', 'rdn', "4-E0I9-3V6P", BusDef(\sendbus1));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 1.0582025961843,
	'fb', 0.0016961738370862,
	'delay', 0.0001,
	'delay2', 0.0001,
	'delay3', 0.0001,
	'distamp', 2.3656450378955,
	'distamp2', 2.2322328540381,
	'distamp3', 2.8156575412238,
	'shift', 0.0,
	'shift2', 0.0,
	'shift3', 0.0,
	'shiftmix', 0.0,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'stereo', 0.0,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
).keep(1));

);

ProtoDef(\rdn2).presetCompileString.editorInsert
(
ProtoDef(\rdn2, ProtoTemplateDef(\rdn));
ProtoDef('rdn2').make('deldefault', 'rdn2', "4-QRVK-N8PH", BusDef(\sendbus2));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.5,
	'gain', 0.73901997269246,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.00014725404276241,
	'shift', 0,
	'shift2', 0,
	'distamp', 1,
	'pitchlag', 0.125,
	'pitchmix', 0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.5,
	'fbdistmix', 1,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 1,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

ProtoDef(\rdn3).presetCompileString.editorInsert
(
ProtoDef('rdn3').make('deldefault', 'rdn3', "5-6ER2-BJ02", BusDef(\sendbus3));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0052997797722,
	'gain', 0.73901997269246,
	'fb', 0.0001,
	'delay', 0.10195378685327,
	'delay2', 0.24828928805603,
	'shift', 0,
	'shift2', 0,
	'distamp', 3.3512751331888,
	'pitchlag', 0.0090778539919376,
	'pitchmix', 0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.5,
	'fbdistmix', 1,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 1,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);


////////////////////////////////////////////////////////////////////////////////
///////////// GRID

(
FileSystemProject.load("libdef/pdeftrack.scd");
FileSystemProject.load("libdef/apc.scd");
ProtoDef(\apc40).activate(TrackDef(\pdefgrid));
ProtoDef(\apc40).map_rdn_to_bank(0, \rdn, [\fb, \delay, \delay2, \delay3,    nil, \distamp, \distamp2, \distamp3]);
ProtoDef(\apc40).map_rdn_to_bank(1, \rdn2, [\fb, \delay, \delay2, \delay3,    nil, \distamp, \distamp2, \distamp3]);
ProtoDef(\apc40).map_rdn_to_bank(2, \rdn3, [\fb, \delay, \delay2, \delay3,    nil, \distamp, \distamp2, \distamp3]);
ProtoDef(\apc40).activate_bank_selector;
)


TrackDef(\pdefgrid).edit
TrackDef(\pdefgrid).clear
ProtoDef(\apc40).ktl
ProtoDef(\apc40).ktl.sendSpecialMessage(\setLiveMode);




////////////////////////////

// bass
(
Pdef(\pdefgrid0_0, 
	Pbind(
		\instrument, \basicbass,
		\note, Pseq([
			-1, 0,
		],inf).stutter(2),
		\octave, 3,
		\legato, Pseq([
			4,0,0,0,
			0,0,0,0, 
			0,0,0,0,
			0,0,1,0,
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\dur, 1/8,
		\amp, 0.1,
		//\out, BusDef(\sendbus1, \audio),
	)
);
);

// kick


(
Pdef(\pdefgrid1_0, 
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,1,0,

				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,1,0,
				1,0,0,0.51, 0,0,0,1,
				1,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
);
);

(
Pdef(\pdefgrid1_1, 
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
);
);

// snare

(
Pdef(\pdefgrid2_0, 
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/3,
				\dur, 1/8,
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.1,0.8,0.2) ],
				],inf),
				\sustain, 0.1,
				\dur, 1/8,
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.1,0.8,0.2) ],
				],inf),
				\sustain, 0.1,
				\velamp, 1/2,
				\dur, 1/8,
			)),
		]),
);
);

(
Pdef(\pdefgrid2_1, 
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,1,
					0,1,0,1, 0,1,1,0,
					0,0,1,0, 0,0,0,1,
					0,1,0,1, 0,0,0,1,
					0,0,1,0, 0,0,0,1,
					0,1,0,1, 0,1,1,1,
					0,0,1,0, 0,0,0,1,
					0,1,1,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/3,
				\dur, 1/8,
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.1,0.8,0.2) ],
				],inf),
				\sustain, 0.1,
				\dur, 1/8,
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,1,0,1,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.1,0.8,0.2) ],
				],inf),
				\sustain, 0.1,
				\velamp, 1/2,
				\dur, 1/8,
			)),
		]),
);
);

// hat

(
Pdef(\pdefgrid3_0, 
		Pbind(
			\lag, 0.04,
		) <> Ppar([
			
			// hat
			
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 12,
				\isRest, Pseq([
					1,0,0,0, 1,0,1,0,
					1,0,0,0, 1,0,1,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.1,0.8,0.2) ],
				],inf),
				\sustain, Pseq([0.3,0.05,0.051,0.051],inf),
				\dur, 1/8,
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 13,
				\isRest, Pseq([
					0,0,0,0, 0,1,0,1,
					0,1,0,0, 0,0,0,1,
			
					0,0,0,0, 0,1,0,1,
					0,1,1,0, 0,0,0,1,
			
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.1,0.8,0.02) ],
				],inf),
				\velamp, 1/2,
				\sustain, Pseq([0.13,0.16],inf),
				\dur, 1/8,
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0,0, 1,1,0,0,
					1,0,1,1, 0,0,0,0,
					0,0,0,0, 0,1,1,0,
					0,1,1,0, 0,0,0,0,
			
					0,0,1,0, 1,1,0,0,
					1,0,1,1, 0,0,1,0,
					0,0,0,1, 0,1,1,0,
					0,1,1,0, 0,0,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.1,0.8,0.02) ],
				],inf),
				\velamp, 1,
				\sustain, 0.1,
				\dur, 1/8,
			)),
		])
);
);

(
Pdef(\pdefgrid3_1, 
		Pbind(
			\lag, 0.04,
		) <> Ppar([
			
			// hat
			
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 12,
				\legato, Pseq([
					4,0,0,0, 4,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.1,0.8,0.1) ],
				],inf),
				\sustain, Pseq([0.3,0.05,0.051,0.051],inf),
				\dur, 1/8,
			)),
		])
);
);

// piano
(
Pdef(\pdefgrid4_0, 
			NoteTimeline(\piano).asPattern,
);
);


(
Pdef(\pdefgrid4_1, 
		Pbind(
			\instrument, \down,
			\freq, 1520,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 12,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus3, \audio),
		),
);
);

(
Pdef(\pdefgrid4_2, 
	Ppar([
		PatKitDef(\more).asPattern(Pbind(
			\kitIndex, 1,
			\legato, Pseq([
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 1,0,0,0,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 1,0,0,1,
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 1,0.1,0.1,0,
			].rotate(16+4),inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\velamp, 1/3,
			\out, BusDef(\sendbus3, \audio),
			\dur, 1/8,
		)),
	]),
);
);

(
	// samples
Pdef(\pdefgrid5_0, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/lovereggae.wav'),
			//\speed, ~pmodenv.(Pseq([1,1.02,1,0.91,1,2,1/2],inf).stutter(2), Prand([0.1,1],inf)),
			\legato, 1,
			//\speed, 1 * ( -3+12-5 ).midiratio,
			\speed, -1,
			\pos, 3.67 + (
				Pseq([
					0.6,0.7,
					0.65,0.68,
				],inf)+5.2
			),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/lovereggae.wav'),
			//\speed, ~pmodenv.(Pseq([1,1.02,1,0.91,1,2,1/2],inf).stutter(2), Prand([0.1,1],inf)),
			\legato, 1,
			//\speed, 1 * ( -3+12-5 ).midiratio,
			\pos, 3.67 + (
				Pseq([
					0.6,0.7, 0.65,0.09,
					0.6,0.7, 0.65,0.29,
				],inf)+4.15
			),
			\legato, Pseq([
				0,0,0,0, 0,0,0,1,
				1,0,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,1,
		
				0,0,0,0, 0,0,0,1,
				1,0,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,1, 1,0,1,1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/3,
			\isRest, true,
		),
	]),
);
);

(
Pdef(\pdefgrid5_1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/lovereggae.wav'),
			\speed, ~pmodenv.(Pseq([1,1/4],inf).stutter(2), Prand([1],inf)),
			\legato, 1.5,
			\pos, Pseq([
				Prand((1..8)/8)
			],inf),
			\pos, Pseq((1..8)/4,inf),
			\dur, 1/2+Prand([1/4,1/8,1/16],inf),
			\dur, 1,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/lovereggae.wav'),
			//\speed, ~pmodenv.(Pseq([1,1.02,1,0.91,1,2,1/2],inf).stutter(2), Prand([0.1,1],inf)),
			\legato, 1,
			//\speed, 1 * ( -3+12-5 ).midiratio,
			\pos, 3.67 + (
				Pseq([
					0.6,0.7,
					0.65,0.68,
				],inf)+5.2
			),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/lovereggae.wav'),
			//\speed, ~pmodenv.(Pseq([1,1.02,1,0.91,1,2,1/2],inf).stutter(2), Prand([0.1,1],inf)),
			\legato, 1,
			//\speed, 1 * ( -3+12-5 ).midiratio,
			\pos, 3.67 + (
				Pseq([
					0.6,0.7,
					0.65,0.29,
				],inf)+5.8
			),
			\legato, Pseq([
				0,0,0,0, 0,0,0,1,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 0,0,0,1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/3,
		),
	]),
);
);

// more

(
Pdef(\pdefgrid6_0, 
	Pbind(\lag, 0.04) <>
	Ppar([
		PatKitDef(\more).asPattern(Pbind(
			\kitIndex, 0,
			\legato, Pseq([
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 1,0,0,0,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 1,0,0,1,
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 1,0.1,0.1,0,
			].rotate(8),inf)*Pseq([
				1,0,1,0,
				1,0,1,0,
				1,0,1,0,
				1,0,1,0,
				1,0.1,1,0,
				1,0,1,0,
				1,0,1,0.1,
				1,0,1,0,
				1,0.1,1,0.1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\velamp, 1/3,
			\dur, 1/16,
		)),
		PatKitDef(\more).asPattern(Pbind(
			\kitIndex, 1,
			\legato, Pseq([
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 1,0,0,0,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 1,0,0,1,
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 1,0.1,0.1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\velamp, 1/3,
			\dur, 1/8,
		)),
	]),
);
);


(
Pdef(\pdefgrid6_1, 
	Pbind(\lag, 0.04) <>
	Ppar([
		PatKitDef(\more).asPattern(Pbind(
			\kitIndex, 0,
			\legato, Pseq([
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 1,0,0,0,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 1,0,0,1,
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 1,0.1,0.1,0,
			].rotate(8+4),inf)*Pseq([
				1,0,1,0,
				1,0,1,0,
				1,0,1,0,
				1,0,1,0,
				1,0.1,1,0,
				1,0,1,0,
				1,0,1,0.1,
				1,0,1,0,
				1,0.1,1,0.1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\velamp, 1/3,
			\dur, 1/16,
		)),
		PatKitDef(\more).asPattern(Pbind(
			\kitIndex, 1,
			\legato, Pseq([
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 1,0,0,0,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 1,0,0,1,
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 1,0.1,0.1,0,
			].rotate(4),inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\velamp, 1/3,
			\dur, 1/8,
		)),
	]),
);
);

// fx

(
Pdef(\pdefgrid7_0, 
	Ptask({
		ProtoDef(\rdn).play;
		ProtoDef(\rdn2).play;
		1.wait;
	})
);
);
//////////////////////

(
~master = {
	ProtoDef(\rdn).play;
	ProtoDef(\rdn2).play;
	ProtoDef(\rdn3).play;
};
~master.();
)

PatKitDef(\more).edit
PatKitDef(\more).presetCompileStringSavePath = "capsule/PatKitDef_more.scd"


SampleTimeline(\bla).edit
Prand(SampleTimeline(\bla).asPatternSlices,inf).play
BusDef(\bla, \audio)
SampleTimeline(\bla).edit
{ SinOsc.ar(500 * ( SinOsc.kr(1) * 1 + 1 )) ! 2 * 0.1}.play;

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(100 * ( SinOsc.kr(0.1 * ( SinOsc.kr(1) * 1 + 1 )) * 1 + 1 )) * 1 + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play(BusDef(\bla).index, 2);
);
Ndef(\zed).play(0,2)




(
SynthDef(\down, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([2,1.1,1],[0.1,0.8]), 1);
	freq = freq * [0,5,11,-9].midiratio;
	sig1 = LFPulse.ar(freq * env1).mean;

	sig2 = SinOsc.ar(freq * ( SinOsc.ar(1) * 1 + 1 )).mean;

	sig3 = SinOsc.ar(freq * ( SinOsc.ar(1 * ( SinOsc.kr(0.1) * 1 + 1 )) * ( SinOsc.kr(10) * 1 + 1 ) + 1 )).mean;
	sig4 = LFSaw.ar(freq * ( SinOsc.ar(1 * ( SinOsc.kr(0.2) * 1 + 1 )) * ( SinOsc.kr(10) * 1 + 1 ) + 1 )).mean;

	sig = [sig1,sig2,sig3,sig4].sum;

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\addme, Pdef(\zed, 
	Ppar([
		
	])
)).play;
);




NoteTimeline(\piano).outBus = BusDef(\sendbus3)

SampleTimeline(\dechire).edit
SampleTimeline(\dechire).buffer = BufDef('/tmp/rec_dechire_190604_012741.wav')
SampleTimeline(\dechire).loopMaster = ProtoClassDef(\LoopMaster).new(SampleTimeline(\dechire))
SampleTimeline(\dechire).loopMaster 

(
Pdef(\part, Pdef(\zed, 
	Ppar([

		Pfindur(1/2,
			Pbind(
				\startSeconds, Pkey(\startSeconds) + Prand([0,1/4,-1/4,1/8,1/2],inf),
			) <>
			SampleTimeline(\dechire).asPatternSlice("hey")
		).loop,
		
	])
)).play;
);

Document.current.string_("hh")
Document.current
Document.dir
"bla.scd".loadRelative;
SCVim.vimServerName = "SCVIM"

////////////////////////


(
SynthDef(\multi, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo2 = ( SinOsc.kr(\lfofreq.kr(1),1) * 1 + 1 );
	lfo1 = Duty.kr(1/8/~t*lfo2, 0, Dseq([
		1,0,0,0,Dseq((1..8))
	],inf));
	freq = freq * [1, lfo1 * 0.21 + 1];
	sig = SinOsc.ar(freq).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \multi,
			\degree, Pseq([0],inf),
			\lfofreq, Pwhite(0.01,100,inf),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \multi,
			\note, Pseq([3,4],inf),
			\lfofreq, Pwhite(0.01,100,inf),
			\dur, 2/3,
			\amp, 0.1,
		),
	]),
).play;
);
