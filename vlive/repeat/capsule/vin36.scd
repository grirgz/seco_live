// drink milk
(
~t = 185/4/60; TempoClock.default.tempo = ~t;
~milkratio = ~t * 1/8/(1/12.57);
);

SampleTimeline('rec_vin36_mainTimeline_t0_201119_164209').buffer = BufDef('cliprec/rec_vin36_mainTimeline_t0_201119_164209.wav')

(
~master = {
	ProtoDef(\simpleMixer).play;
	ProtoDef(\rdn).play;
	ProtoDef(\rdn2).play;
	ProtoDef(\rdn3).play;
	ProtoDef(\rdn4).play;
	ProtoDef(\fx1).play;
	ProtoDef(\fx2).play;
};
~master.();
);


(
Pdef(\part, Pdef(\drums, 
	Pbind(\out, BusDef(\mixer0, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1533].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2590].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[333].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\drums, 
	Pbind(\out, BusDef(\mixer0, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1533].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,1,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,1,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,1,
				0,1,0,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[2590].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1135].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.6,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2590].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,1,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,1,
				0,1,0,0, 1,0,0,1,
				0,0,1,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[333].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\drums2, 
	Pbind(\out, BusDef(\mixer0, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1533].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1532].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
			]/2,inf).coin.not,
			\dur, 1/8,
			\gain, 0.1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[2590].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1135].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.6,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[333].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[333].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,1,0,1,
			]/2,inf).coin.not,
			\dur, 1/8,
			\gain, 0.31/2,
		),
	])
)).play;
);

ClipTimeline(\myclip).edit

(
Pdef(\part2, Pdef(\drumloop, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\targetSpeed, Pseq([
				1,2,2,2, 
				2,2,2,2, 
				2,2,1,2,
				2,1,1.5,2,
			],inf)/2,
			\division, 2,
			\tempoRatio, ~t/( 92.20/4/60 ),
			\speed, Pkey(\targetSpeed) * Pkey(\tempoRatio),
			\pos, Pseq([
				Pseq((0..7)/8),
			],inf) / ~t * Pkey(\tempoRatio),
			//\legato, Pseq([
				//3,0,0,1,
			//],inf),
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,1, 1,0,1,0,
				1,1,1,0, 0,1,1,1,
			],inf).coin.not,
			\out, BusDef(\mixer3, \audio),
			\gain, 1/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_vin36_mainTimeline_t0_201119_164209').buffer,
			\pos, Pseq([
				0,1,
			],inf),
			\legato, Pseq([
				1,0,2,0, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\mixer1, \audio),
			\dur, 1/4,
			\gain, 1,
		)

		
	])
)).play;
);

(
Pdef(\part2, Pdef(\drumloop, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\targetSpeed, Pseq([
				1,2,2,2, 
				2,2,2,2, 
				2,2,1,2,
				2,1,1.5,2,
			],inf)/2,
			\division, 2,
			\tempoRatio, ~t/( 92.20/4/60 ),
			\speed, Pkey(\targetSpeed) * Pkey(\tempoRatio),
			\pos, Pseq([
				Pseq((0..7)/8),
			],inf) / ~t * Pkey(\tempoRatio),
			//\legato, Pseq([
				//3,0,0,1,
			//],inf),
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\isRest, Pseq([
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,1,0,0, 1,1,0,0,
				1,0,1,0, 0,0,1,1,

				1,1,0,0, 0,1,1,0,
				0,0,0,0, 1,0,0,1,
				1,1,0,0, 1,0,0,1,
				1,0,1,1, 0,0,1,0,
			],inf).coin.not,
			\out, BusDef(\mixer3, \audio),
			\gain, 1/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_vin36_mainTimeline_t0_201119_164209').buffer,
			\pos, Pseq([
				0,1,4,3,
			],inf)/ (135/60/4) /2,
			\legato, Pseq([
				2,0,0,2, 0,0,2,0,
				2,0,0,1, 0,2,0,0,
				2,0,0,2, 0,0,2,0,
				1,0,2,0, 0,2,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\mixer1, \audio),
			\dur, 1/4,
			\gain, 1,
		)

		
	])
)).play;
);

(
Pdef(\part2, Pdef(\drumloop, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\targetSpeed, Pseq([
				1,2,2,2, 
				2,2,2,2, 
				2,2,1,2,
				2,1,1.5,2,
			],inf)/2,
			\division, 2,
			\tempoRatio, ~t/( 92.20/4/60 ),
			\speed, Pkey(\targetSpeed) * Pkey(\tempoRatio),
			\pos, Pseq([
				Pseq((0..7)/8),
			],inf) / ~t * Pkey(\tempoRatio),
			//\legato, Pseq([
				//3,0,0,1,
			//],inf),
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,1, 1,0,1,0,
				1,1,1,0, 0,1,1,1,
			],inf).coin.not,
			\out, BusDef(\mixer3, \audio),
			\gain, 1/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_vin36_mainTimeline_t0_201119_164209').buffer,
			\pos, Pseq([
				0,1,4,3,
			],inf)/ (135/60/4) /2,
			\legato, Pseq([
				4,0,0,0, 0,0,0,1,
				0,0,2,0, 0,0,0,0,
				4,0,0,0, 0,0,0,1,
				0,0,2,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\mixer1, \audio),
			\dur, 1/8,
			\gain, 1,
		)

		
	])
)).play;
);

(
Pdef(\part2, Pdef(\drumloop, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\targetSpeed, Pseq([
				1,2,2,1, 2,2,2,2, 
				2,2,1,2, 2,2,2.3,1,
				1,2,1,2, 2,2,2,2,
				1,2,2,2, 2,2,2,1,

				1,2,2,2, 2,2,2,2, 
				2,2,1,2, 2,1,1.5,2,
				1,2,2,2, 2,2,2,2, 
				2,2,1,2, 2,1,1.5,2,
			],inf)/2,
			\division, 2,
			\tempoRatio, ~t/( 92.20/4/60 ),
			\speed, Pkey(\targetSpeed) * Pkey(\tempoRatio),
			\pos, Pseq([
				Pseq([
					0,1,2,3, 3,3,0,3,
					2,0,2,2, 3,3,0,3,
					0,0,0,4, 0,1,2,3,
					1,1,1,0, 1,0,0,1,
				]/8,1),
				Pseq((0..7)/8),
			],inf) / ~t * Pkey(\tempoRatio),
			//\legato, Pseq([
				//3,0,0,1,
			//],inf),
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,1, 1,0,1,0,
				1,1,1,0, 0,1,1,1,
			],inf).coin.not,
			\out, BusDef(\mixer3, \audio),
			\gain, 1/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_vin36_mainTimeline_t0_201119_164209').buffer,
			\pos, Pseq([
				0,1,4,3,
			],inf)/ (135/60/4) /2,
			\legato, Pseq([
				4,0,0,0, 0,0,0,1,
				0,0,2,0, 0,0,0,0,
				4,0,0,0, 0,0,0,1,
				0,0,2,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\mixer1, \audio),
			\dur, 1/8,
			\gain, 1,
		)

		
	])
)).play;
);


(
Pdef(\part3, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/drinkmilk.flac'),
			\speed, ~t * 1/8/(1/12.57),
			\pos, 0.1,
			\legato, 1,
			\dur, 4,
			\gain, 1,
			//\out, BusDef(\mixer2, \audio),
			\out, BusDef(\fil, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\fil, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 1,
			\hpf, 2000,
			\gain, 4,
			\out, BusDef(\mixer2, \audio),
		),
		
	])
)).play;
);

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
)
(
Pdef(\part3, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/drinkmilk.flac'),
			\speed, ~t * 1/8/(1/12.57),
			\pos, 0.1 + ( Pseg(Pseq([0,4],1),4/( 16/4 )).loop *(1/12.57*4) ),
			\pos, 0.1 + ( Pseg(Pseq([8,12],1),4/( 16/4 )).loop *(1/12.57*4) ),
			\legato, 1,
			\dur, 1/8,
			\gain, 1,
			//\out, BusDef(\mixer2, \audio),
			\out, BusDef(\fil, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\fil, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 1,
			\hpf, 2000,
			\gain, 4,
			\out, BusDef(\mixer2, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part3, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/drinkmilk.flac'),
			\speed, ~t * 1/8/(1/12.57),
			\pos, 0.1,
			\legato, 1,
			\dur, 4,
			\gain, 1,
			//\out, BusDef(\mixer2, \audio),
			\out, BusDef(\fil, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\fil, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 1,
			\hpf, Pseq([
				~pmodenv.(Pseq([3100,3200,100,4000],1), 1/4),
				~pmodenv.(Pseq([3100,1200,1000,1000],1), 1/4),
				~pmodenv.(Pseq([310,120,100,1000],1), 1/4),
				~pmodenv.(Pseq([300,3200,100,4000],1), 1/4),
			],inf).loop,
			\gain, 4,
			\dur, 1/2,
			\out, BusDef(\mixer2, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part3, Pdef(\zed, 
	Ppar([
		Pbind(
			\gain, Pseq([
				1,1,1,1, 0,1,1,1,
				0,0,1,0, 0,1,0,1,
				1,1,1,1, 0,1,1,1,
				0,0,1,0, 0,1,0,1,
				1,0,1,0, 0,1,1,1,
				0,0,1,1, 1,1,0,1,
				1,1,1,1, 0,1,1,1,
				1,0,0,1, 0,1,0,1,
			],inf),
		) <> 
		Pmono( \playersec,
			\bufnum, BufDef('loop/drinkmilk.flac'),
			\speed, ~t * 1/8/(1/12.57),
			\pos, 0.1,
			\legato, 1,
			\dur, Pn(1/8,16*2),
			\out, BusDef(\fil, \audio),
		).loop,
		Pmono(\fx_hpf,
			\inbus, BusDef(\fil, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 1,
			\hpf, Pseq([
				~pmodenv.(Pseq([3100,3200,100,4000],1), 1/4),
				~pmodenv.(Pseq([3100,1200,1000,1000],1), 1/4),
				~pmodenv.(Pseq([310,120,100,1000],1), 1/4),
				~pmodenv.(Pseq([300,3200,100,4000],1), 1/4),
			],inf).loop,
			\gain, 4,
			\out, BusDef(\mixer2, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part3, Pdef(\zed, 
	Ppar([
		Pbind(
			\gain, Pseq([
				1,1,0,1, 0,1,0,1,
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 1,1,0,1,
				0,1,0,1, 0,1,1,1,
				
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 

				0,0,1,1, 0,0,1,1,
				0,0,1,1, 0,0,1,1,
				0,0,1,1, 0,0,1,1,
				0,0,1,1, 0,0,1,1,

				1,1,1,1, 1,0,0,1,
				0,0,1,1, 1,0,0,0,
				1,1,1,1, 1,0,0,1,
				0,0,1,1, 1,0,1,1,

				1,1,1,1, 0,0,0,1,
				0,0,1,1, 0,0,0,0,
				1,1,1,1, 0,0,0,1,
				0,0,1,1, 0,0,1,1,

				1,1,1,1, 0,1,0,1,
				0,0,1,1, 0,1,0,0,
				1,1,1,1, 0,1,0,1,
				0,0,1,1, 0,1,1,1,
			],inf),
		) <> 
		Pmono( \playersec,
			\bufnum, BufDef('loop/drinkmilk.flac'),
			\speed, ~t * 1/8/(1/12.57),
			\pos, 0.1,
			\legato, 1,
			\dur, Pn(1/8,16*2),
			\out, BusDef(\fil, \audio),
		).loop,
		Pmono(\fx_hpf,
			\inbus, BusDef(\fil, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 1,
			\hpf, 2000,
			\gain, 4,
			\out, BusDef(\mixer2, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part3, Pdef(\zed, 
	Ppar([
		Pbind(
			//\instrument, \basicbass,
			\ctranspose, Pstep(Pseq([
				0,0,5,7,
			],inf)-4, 1),
			\degree, Pseq([
				0,-3,
				0,1,
				0,5-7,
			],inf),
			\freq, Pkey(\freq) *  ~t * 1/8/(1/12.57),
			\octave, 3,
			\legato, 0.3,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpfr, 3,
			\dur, 1/8,
			\amp, 0.2,
			\out, BusDef(\mixer4, \audio),
		),
		Pbind(
			\gain, Pseq([
				1,1,1,1, 0,1,0,1,
				1,0,1,1, 0,1,0,1,
				1,1,1,1, 0,1,0,1,
				1,0,1,1, 0,1,1,1,

				1,1,1,1, 0,0,0,1,
				0,0,1,1, 0,0,0,0,
				1,1,1,1, 0,0,0,1,
				0,0,1,1, 0,0,1,1,

			],inf),
		) <> 
		Pmono( \playersec,
			\bufnum, BufDef('loop/drinkmilk.flac'),
			\speed, ~t * 1/8/(1/12.57),
			\pos, 0.1,
			\legato, 1,
			\dur, Pn(1/8,16*2),
			\out, BusDef(\fil, \audio),
		).loop,
		Pmono(\fx_hpf,
			\inbus, BusDef(\fil, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 1,
			\hpf, 2000,
			\gain, 4,
			\out, BusDef(\mixer2, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part3, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\ctranspose, Pstep(Pseq([
				0,0,5,7,
			],inf)-4, 1),
			\degree, Pseq([
				0,-3,
				0,1,
				0,5-7,
			],inf),
			\freq, Pkey(\freq) *  ~t * 1/8/(1/12.57),
			\octave, 3,
			\legato, 0.3,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,1,
				8,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,1,

				2,0,0,2, 0,0,1,0,
				0,0,1,0, 0,1,0,1,
				2,0,0,2, 0,0,1,0,
				0,0,1,0, 0,1,0,1,
				2,0,0,2, 0,0,1,0,
				0,0,1,0, 0,1,0,1,
				2,0,0,2, 0,0,1,0,
				0,0,1,0, 0,1,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpfr, 3,
			\dur, 1/8,
			\amp, 0.05,
			\out, BusDef(\mixer4, \audio),
		),
		Pbind(
			\gain, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				1,0,1,1, 0,1,0,1,
				1,1,1,1, 0,1,0,1,
				1,0,1,1, 0,1,1,1,

				1,1,1,1, 0,0,0,1,
				0,0,1,1, 0,0,0,0,
				1,1,1,1, 0,0,0,1,
				0,0,1,1, 0,0,1,1,

			],inf),
		) <> 
		Pmono( \playersec,
			\bufnum, BufDef('loop/drinkmilk.flac'),
			\speed, ~t * 1/8/(1/12.57),
			\pos, 0.1,
			\legato, 1,
			\dur, Pn(1/8,16*2),
			\out, BusDef(\fil, \audio),
		).loop,
		Pmono(\fx_hpf,
			\inbus, BusDef(\fil, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 1,
			\hrq, 0.1,
			\hpf, 8000,
			\gain, 4*2,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\gain, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
				0,0,1,0, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
				0,0,1,1, 0,0,1,1,
				0,1,0,0, 0,0,1,1,
				0,0,1,1, 0,0,1,1,
				0,1,1,1, 0,0,0,0,

			],inf),
		) <> 
		Pmono( \playersec,
			\bufnum, BufDef('loop/drinkmilk.flac'),
			\speed, ~t * 1/8/(1/12.57),
			\pos, 0.1,
			\legato, 1,
			\dur, Pn(1/8,16*2),
			\out, BusDef(\fil2, \audio),
		).loop,
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\fil2, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 1,
			\hrq, 0.1,
			\lpf, 4000,
			\hpf, 1000,
			\gain, 2,
			\out, BusDef(\mixer2, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part3, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\ctranspose, Pstep(Pseq([
				0,0,5,7,
			],inf)-4, 1),
			\degree, Pseq([
				0,-3,
				0,1,
				0,5-7,
			],inf),
			\freq, Pkey(\freq) *  ~t * 1/8/(1/12.57),
			\octave, 3,
			\legato, 0.3,
			\legato, Pseq([
				1,1,0,2, 1,0,1,0,
				0,0,1,0, 0,1,0,1,
				2,0,0,2, 0,0,1,0,
			]/2,inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpfr, 3,
			\dur, 1/8,
			\amp, 0.05,
			\out, BusDef(\mixer4, \audio),
		),
		Pbind(
			\gain, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				1,0,1,1, 0,1,0,1,
				1,1,1,1, 0,1,0,1,
				1,0,1,1, 0,1,1,1,

				1,1,1,1, 0,0,0,1,
				0,0,1,1, 0,0,0,0,
				1,1,1,1, 0,0,0,1,
				0,0,1,1, 0,0,1,1,

			],inf),
		) <> 
		Pmono( \playersec,
			\bufnum, BufDef('loop/drinkmilk.flac'),
			\speed, ~t * 1/8/(1/12.57),
			\pos, 0.1,
			\legato, 1,
			\dur, Pn(1/8,16*2),
			\out, BusDef(\fil, \audio),
		).loop,
		Pmono(\fx_hpf,
			\inbus, BusDef(\fil, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 1,
			\hrq, 0.1,
			\hpf, 5000,
			\gain, 4*2,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\gain, Pseq([
				0,0,1,0, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
				0,0,1,0, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,1,1,
				0,1,0,0, 0,0,1,1,
				0,0,1,1, 0,0,1,1,
				0,1,1,1, 0,0,0,0,
			],inf),
		) <> 
		Pmono( \playersec,
			\bufnum, BufDef('loop/drinkmilk.flac'),
			\speed, ~t * 1/8/(1/12.57),
			\pos, 0.1,
			\legato, 1,
			\dur, Pn(1/8,16*2),
			\out, BusDef(\fil2, \audio),
		).loop,
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\fil2, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 1,
			\hrq, 0.1,
			\lpf, 4000,
			\hpf, 1000,
			\gain, 4,
			\out, BusDef(\mixer2, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part3, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\ctranspose, Pstep(Pseq([
				0,0,5,7,
			],inf)-4, 1),
			\degree, Pseq([
				0,0,0,0, -5,0, -3,1,
				0,0,0,0, -5,0, -3,1,
				0,0,0,0, -5,0, -3,1,
				Pseq([ 7,3,4,3, 2,1, 6,5, ],1)-7,
				0,0,0,0, -5,0, -3,1,
				Pseq([ 7,7,6,2, 4,3, 3,5, ],1)-7,
				//0,5-7,
			],inf),
			\freq, Pkey(\freq) *  ~t * 1/8/(1/12.57),
			\octave, 3,
			\legato, 0.3,
			\legato, Pseq([
				1,1,1,1, 1,0,1,0,
				0,1,1,1, 1,1,1,1,
			]/2,inf),
			\rester, Pseq([
				1,1,1,1, 1,1,1,1,
				Pseq([ 1,2,2,1, 2,1,2,1, ]+0.2/2.5,1),
				1,1,1,1, 1,1,1,1,
				Pseq([ 1,2,2,1, 2,1,2,1, ]/1.5,1),
			],inf),
			\isRest, Pfunc({ arg ev; 
				ev[\legato] <= 0 or: ev.rester.coin.not
		   	}),
			\lpfr, 3,
			\dur, 1/8,
			\amp, 0.05,
			\out, BusDef(\mixer4, \audio),
		),
		Pbind(
			\gain, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				1,0,1,1, 0,1,0,1,
				1,1,1,1, 0,1,0,1,
				1,0,1,1, 0,1,1,1,

				1,1,1,1, 0,0,0,1,
				0,0,1,1, 0,0,0,0,
				1,1,1,1, 0,0,0,1,
				0,0,1,1, 0,0,1,1,

			],inf),
		) <> 
		Pmono( \playersec,
			\bufnum, BufDef('loop/drinkmilk.flac'),
			\speed, ~t * 1/8/(1/12.57),
			\pos, 0.1,
			\legato, 1,
			\dur, Pn(1/8,16*2),
			\out, BusDef(\fil, \audio),
		).loop,
		Pmono(\fx_hpf,
			\inbus, BusDef(\fil, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 1,
			\hrq, 0.1,
			\hpf, 5000,
			\gain, 4,
			\out, BusDef(\mixer2, \audio),
		),

		Pbind(
			\gain, Pseq([
				0,0,1,0, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
				0,0,1,0, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,1,1,
				0,1,0,0, 0,0,1,1,
				0,0,1,1, 0,0,1,1,
				0,1,1,1, 0,0,0,0,
			],inf),
		) <> 
		Pmono( \playersec,
			\bufnum, BufDef('loop/drinkmilk.flac'),
			\speed, ~t * 1/8/(1/12.57),
			\pos, 0.1,
			\legato, 1,
			\dur, Pn(1/8,16*2),
			\out, BusDef(\fil2, \audio),
		).loop,
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\fil2, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 1,
			\hrq, 0.1,
			\lpf, 5000,
			\hpf, 2000,
			\gain, 4,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\gain, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,1,0, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,1,1,
				0,1,0,0, 0,0,1,1,

				0,0,1,1, 0,0,1,1,
				0,1,1,1, 0,0,0,0,
			],inf),
		) <> 
		Pmono( \playersec,
			\bufnum, BufDef('loop/drinkmilk.flac'),
			\speed, ~t * 1/8/(1/12.57),
			\pos, 0.1,
			\legato, 1,
			\dur, Pn(1/8,16*2),
			\out, BusDef(\fil3, \audio),
		).loop,
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\fil3, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 1,
			\hrq, 0.1,
			\lpf, 2000,
			\hpf, 300,
			\gain, 1,
			\out, BusDef(\mixer2, \audio),
		),
		
	])
)).play;
);

(
	// drinkmilk2
Pdef(\part3, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\ctranspose, Pstep(Pseq([
				0,0,5,7,
			],inf)-4, 1),
			\degree, Pseq([
				0,0,0,0, -5,0, -3,1,
				0,0,0,0, -5,0, -3,1,
				0,0,0,0, -5,0, -3,1,
				Pseq([ 7,3,4,3, 2,1, 6,5, ],1)-7,
				0,0,0,0, -5,0, -3,1,
				Pseq([ 7,7,6,2, 4,3, 3,5, ],1)-7,
				//0,5-7,
			],inf),
			\freq, Pkey(\freq) *  ~t * 1/8/(1/12.57),
			\octave, 3,
			\legato, 0.3,
			\legato, Pseq([
				1,1,1,1, 1,0,1,0,
				0,1,1,1, 1,1,1,1,
			]/2,inf),
			\rester, Pseq([
				1,0.8,1,0.8, 0.9,1,1,1,
				Pseq([ 1,2,2,1, 2,1,2,1, ]+0.2/2.5,1),
				1,0.8,1,0.8, 0.9,1,1,1,
				Pseq([ 1,2,2,1, 2,1,2,1, ]/1.5,1),
			],inf),
			\isRest, Pfunc({ arg ev; 
				ev[\legato] <= 0 or: ev.rester.coin.not
		   	}),
			\lpfr, 3,
			\dur, 1/8,
			\amp, 0.05,
			\out, BusDef(\mixer4, \audio),
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\hpf, 1000,
			\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('loop/drinkmilk2.flac'),
			\dur, 1/8,
			\speed, ~t * 1/8/(1/12.57),
			\legato, 1,
			\pos, Pseq([
				Plazy({ arg ev;
					Pseq([
						Pser([
							0,0,0,1, 0,3,3,3,
							3,2,1,0, 12,12,15,15,
						].rotate(rrand(0,10))/16 + rrand(0,15) % 1,16),
						Pser([
							0,0,0,1, 0,3,3,3,
							7,7,7,1, 7,7,9,9,
						].rotate(rrand(0,10))/16 + rrand(0,15) % 1,16)+1,
					],1)
				}).loop,
				//Pseq((0..15)/16),
				//Pseq((0..15)/16)+1,
			]+8,inf) * (12.57/4)+0.4,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\gain, 1,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\gain, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,1,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,1, 0,1,0,1,
			],inf),
		) <> 
		Pmono( \playersec,
			\bufnum, BufDef('loop/drinkmilk2.flac'),
			\speed, ~t * 1/8/(1/12.57),
			\pos, 0.3 + (12.57*2),
			\legato, 1,
			\dur, Pn(1/8,16*2),
			\out, BusDef(\fil, \audio),
		).loop,
		Pmono(\fx_hpf,
			\inbus, BusDef(\fil, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 1,
			\hrq, 0.1,
			\hpf, 2000,
			\gain, 4,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1533].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\mixer0, \audio),
			\gain, 0.1/2,
		),

		
	])
)).play;
);


/////////////////

(
SynthDef(\bourd, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	lfo1 = SinOsc.ar(freq* [3,1] * 3/5) * EnvGen.kr(\adsr1.kr(Env.adsr(3.1,0.1,0.8,4.1)), gate, doneAction:0);
	lfo2 = SinOsc.ar( lfo1 * [1,3]  + 1) * EnvGen.kr(\adsr2.kr(Env.adsr(7.1,0.1,0.8,4.1)), gate, doneAction:0);
	lfo3 = SinOsc.ar( EnvGen.kr(Env([1,8,1]*3,[7.1,0.8]), 1)) * EnvGen.kr(\adsr3.kr(Env.adsr(3.1,0.1,0.8,4.1)), gate, doneAction:0);
	lfo4 = SinOsc.ar( EnvGen.kr(Env([0,4,12,-12,2].midiratio*freq,[1.1,0.8,1,1.2] * Rand(1/5,3)), 1)) * EnvGen.kr(\adsr4.kr(Env.adsr(3.1,0.1,0.8,4.1)), gate, doneAction:0);
	sig1 = SinOsc.ar(freq * ( lfo1 * 0.1 + 1 )) * lfo4;

	sig2 = LFSaw.ar(( freq/2 ) * ( lfo2 * 0.1  + 1 )) * lfo3;
	sig2 = RLPF.ar(sig2, \lpfr.kr(4.1) * freq, \rq.kr(0.5) * ( lfo3 + 1 )) * 0.5;

	sig3 = LFSaw.ar(( freq ) * ( lfo3 * 0.1  + 1 )) * lfo2;
	sig3 = RLPF.ar(sig3, \lpfr3.kr(4.1) * freq, \rq3.kr(0.5) * ( lfo3 + 1 )) * 0.5;

	sig = [sig1,sig2,sig3].mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part4, Pdef(\bourd, 
	Ppar([
		Pbind(
			\instrument, \bourd,
			\note, Pseq([
				7,9,
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4.1) ],
			],inf),
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

FileSystemProject.load("libdef/piano.scd")
(
Pdef(\melo, 
	Pbind(
		\instrument, \default,
		\freq, Pkey(\midinote).midicps * ~milkratio,
		//\freq, Pkey(\midinote).midicps,
	)
);
);

Pdef(\melo).stop;
ProtoDef(\piano).startControl(Pdef(\melo), \post)


/////////
TrackMixerDef(\mixer0).outbus

TagSpecDef(\BusDef).list

(
WindowDef(\win, { arg def;
	VLayout (
		* 18.collect { arg item, idx;
			PopUpMenu.new.items_(TagSpecDef(\BusDef_object).keyList);
		
		};
	)
	
}).front;
);

(
WindowDef(\win, { arg def;
	var model = ();
	VLayout (
		* 18.collect { arg item, idx;
			Param(Message(model), \send+++idx, TagSpecDef(\BusDef_object)).asPopUpMenu;
			//PopUpMenu.new.items_(TagSpecDef(\BusDef_object).keyList);
		
		};
	)
	
}).front;
);
