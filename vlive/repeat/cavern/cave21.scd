~t = 96/2/60; TempoClock.default.tempo = ~t;
(
~master = {
	ProtoDef(\simpleMixer).play;
	ProtoDef(\FxManager).play;
	ProtoDef(\fxMixer).play;
	//ProtoDef(\rdn).play;
	//ProtoDef(\rdn2).play;
	//ProtoDef(\rdn3).play;
};
~master.();
)


(
	// intro
Pdef(\part, Pdef(\intro1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1308].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1613].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				0,1.2,
			],inf),
			\legato, 1,
			\dur, 1,
			\gain, 1/8,
		)
		
	])
)).play;
);

(
	// intro variations
Pdef(\part, Pdef(\introvar1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1308].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1613].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				0,\r,
			],inf),
			\legato, 1,
			\dur, 1,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				1.2,
			],inf),
			\legato, 1,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				2,0,0,1, 0,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/8,
		)
		
	])
)).play;
);

(
	// intro variations
Pdef(\part, Pdef(\introvar2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1308].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1613].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				0,\r,
			],inf),
			\legato, 1,
			\dur, 1,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				0.1,0.3,0.4,0.5,
			],inf),
			\legato, 1,
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 1,0,0,  0,0,0, 1,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 1,0,0,  1,0,0, 0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\gain, 1/8,
		)
		
	])
)).play;
);

(
	// intro variations 3
Pdef(\part, Pdef(\introvar3, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1308].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1613].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				0,\r,\r,\r,
				0,\r,\r,\r,
				0,\r,\r,\r,
				0,0,0,0,
			],inf),
			\legato, Pseq([
				2,2,2,2,
				2,2,2,2,
				2,2,2,2,
				1,1,1,1,
				
			],inf),
			\dur, 1/2,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				0.1,0.3,0.4,0.5,
			],inf),
			\legato, 1,
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 1,0,0,  0,0,0, 1,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 1,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\gain, 1/8,
		)
		
	])
)).play;
);

(
	// main intro
Pdef(\part, Pdef(\mainintro, 
	Pseq([
		Pfindur(2,Pdef(\intro1)),
		//Pfindur(2,Pdef(\introvar1)),
		Pfindur(4,Pdef(\introvar2)),
		Pfindur(2,Pdef(\introend)),
		Pfindur(16,Pdef(\part1b)),
	])
)).play;
);

(
	// intro2
Pdef(\part, Pdef(\introend, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1308].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1613].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				0,//1.2,
			],inf),
			\legato, 1,
			\dur, 1/2,
			\gain, 1/8,
		)
		
	])
)).play;
);

(
	// part 1
Pdef(\part, Pdef(\exp1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1308].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1613].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1077].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 0,0,1,1,
				1,0,0,0, 0,1,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 0,0,0,0,
				1,1,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				4,0,6,7,
			],inf),
			\legato, Pseq([
				4,0,0,0, 0,0,0,1,
				1/2,0,0,0, 0,0,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\lpf, 3000,
			\octave, 2,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				0,0,0,5.2,
			],inf),
			\legato, 1,
			\legato, Pseq([
				2.5,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				0,0,0,10.2,
			],inf),
			\legato, 1,
			\legato, Pseq([
				0,0,0,0, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1,
			\gain, 1/8,
		),
		
	])
)).play;
);


(
	// part 1
Pdef(\part, Pdef(\exp2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1308].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1613].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1077].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				4,0,6,7,
			],inf),
			\legato, Pseq([
				4,0,0,0, 0,0,0,1,
				1/2,0,0,0, 0,0,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\lpf, 3000,
			\octave, 2,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				0,0,0,0,
			],inf)+7,
			\legato, 1,
			\legato, Pseq([
				2.5,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1,
			\gain, 1/8,
		)
		
	])
)).play;
);

(
	// part 1
Pdef(\part, Pdef(\exp2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1308].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1613].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1077].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				4,0,6,7,
			],inf),
			\legato, Pseq([
				4,0,0,0, 0,0,0,1,
				1/2,0,0,0, 0,0,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\lpf, 3000,
			\octave, 2,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				0,0,0,0,
			],inf)+10,
			\legato, 1,
			\legato, Pseq([
				2.5,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/2,
			\gain, 1/8,
		)
		
	])
)).play;
);

(
	// scratch 1
Pdef(\part, Pdef(\exp1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1308].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1613].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1077].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				4,0,6,7,
			],inf),
			\legato, Pseq([
				4,0,0,0, 0,0,0,1,
				1/2,0,0,0, 0,0,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\lpf, 3000,
			\octave, 2,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\speed, Ndef(\scratch1, { 
				LFTri.kr(4 * ~t * ( LFTri.kr(2 * ~t) * 1 + 1 )).abs * EnvGen.kr(Env([0,-1,0],[0.8,0.8]), Impulse.kr(1/4*~t)) + 1;
		   	}).quant_(Pdef.defaultQuant).asMap,
			\pos, Pseq([
				0,0,0,5.2,
			],inf),
			\legato, 1,
			\legato, Pseq([
				2.5,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1,
			\gain, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				0,0,0,10.2,
			],inf),
			\legato, 1,
			\legato, Pseq([
				0,0,0,0, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1,
			\gain, 1/8,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				0,1.2,
			],inf).stutter(6),
			\isRest, Pseq([
				1,0,1, 1,1,1,
			],inf).coin.not,
			\legato, 1,
			\dur, 1/6,
			\gain, 1/8,
		)
		
	])
)).play;
);

(
	// scratch 2
Pdef(\part, Pdef(\exp1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1308].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1613].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1077].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				4,0,6,7,
			],inf),
			\legato, Pseq([
				4,0,0,0, 0,0,0,1,
				1/2,0,0,0, 0,0,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\lpf, 3000,
			\octave, 2,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\speed, Ndef(\scratch1, { 
				LFTri.kr(4 * ~t * ( LFTri.kr(2 * ~t) * 1 + 1 )).abs * EnvGen.kr(Env([0,-1,0],[0.8,0.8]), Impulse.kr(1/4*~t)) + 1;
		   	}).quant_(Pdef.defaultQuant).asMap,
			\pos, Pseq([
				0,0,0,5.2,
			],inf),
			\legato, 1,
			\legato, Pseq([
				2.5,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1,
			\gain, 1/6,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				0,0,0,10.2,
			],inf),
			\legato, 1,
			\legato, Pseq([
				0,0,0,0, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\speed, 1/4,
			\pos, Pseq([
				14.1,10.4,12,10.9,
				11.2,10.4,12,10.9,
			],inf).stutter(6),
			\isRest, Pseq([
				1,0,0, 1,0,0, 1,0,1, 1,1,1,
				3,0,0, 0,0,1, 1,0,1, 0,0,1,
				1,0,1, 1,0,0, 1,0,1, 1,1,1,
				0,0,4, 0,0,1, 0,0,1, 0,0,1,
			] * 0.9 +0.1,inf).coin.not,
			\legato, 1,
			\dur, 1/12,
			\gain, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\speed, 1,
			\pos, Pseq([
				0,0,0,0,
			],inf)+10.1,
			\legato, 1,
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,1,
				0,0,1, 1,0,0,  0,0,1, 0,0,1,
				12,0,0, 0,0,0,  0,0,0, 0,0,0,

				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,1,
				0,0,0, 1,0,1,  0,0,1, 0,0,1,
				12,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\gain, 1/8,
		)
		
	])
)).play;
);

(
	// part 1
Pdef(\part, Pdef(\part1b, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1308].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1613].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1077].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				4,0,6,7,
			],inf),
			\legato, Pseq([
				4,0,0,0, 0,0,0,1,
				1/2,0,0,0, 0,0,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\lpf, 3000,
			\octave, 2,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				0,0,0,5.2,
			],inf),
			\legato, 1,
			\legato, Pseq([
				2.5,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				Pn(9,3),3,
			],inf),
			\legato, 1,
			\legato, Pseq([
				1,1,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1,
			\gain, 1/8,
		)
		
	])
)).play;
);

(
	// part 2
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1308].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1613].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1077].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				Pn(9,3),3,
			],inf),
			\legato, 1,
			\legato, Pseq([
				1,1,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1,
			\gain, 1/8,
		)
		
	])
)).play;
);

(
	// part 3
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1308].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1613].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1077].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				Pn(2,11),12,
				Pn(6,3),13,
			],inf),
			\speed, Pseg(Pseq([1,1.1],1),4).loop,
			\legato, 1,
			\legato, Pseq([
				1,1,1,1,
			],inf),
			\lag, Pseq([
				Pn(0,3),0.1,
				Pn(0,3),0.052,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\gain, 1/8,
		)
		
	])
)).play;
);

(
	~master.();
	// part 3
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1308].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1613].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1077].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				Pn(2,11),12,
				Pn(6,3),13,
			],inf),
			\speed, Pseg(Pseq([1,1.1],1),4).loop,
			\legato, 1,
			\legato, Pseq([
				1,1,1,1,
			],inf),
			\lag, Pseq([
				Pn(0,3),0.1,
				Pn(0,3),0.052,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\gain, 1/8,
			\out, BusDef(\mixer3, \audio),
		)
		
	])
)).play;
);

Ndef(\rdn).clear

(
	// other
	~master.();
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1308].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1613].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[156].value,
			\isRest, (Pseq([
				1,0,0,0, 1,0,0,0, 
				1,0,1,0, 1,0,1,0, 
				Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				],1)/2,
				Pseq([
					1,0,1,0, 1,0,1,0, 
					1,0,1,0, 1,0,1,0, 
				],1)/2,
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,0,0, 1,0,1,0,
				1,1,1,1, 1,0,1,0,
			],inf) * Pseq([0.51,1],inf) ).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1077].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0, 
				1,0,1,0, 1,0,1,0, 
				Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				],1)/2,
				Pseq([
					1,0,1,0, 1,0,1,0, 
					1,0,1,0, 1,0,1,0, 
				],1)/2,
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,0,0, 1,0,1,0,
				1,1,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				Pn(7.9,12),
				Pn(8.1,4),
			],inf),
			//\speed, Pseg(Pseq([1,1.1],1),4).loop,
			\speed, Pseq([ Pn(1,3), Pn(2/3,Prand([3,2])) ],inf).stutter(8),
			\legato, 1,
			\legato, Pseq([
				1,0,0,1, 0,1,1,1,
				0,1,1,0, 1,1,0,0,
				1,1,1,1, 1,1,1,1,
				0,1,1,0, 1,1,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,1,1,
			],inf) * Pseg(Pseq([1,1/7],inf),8),
			\lag, Pseq([
				0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\mixer3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				0,0,0,5.2,
			],inf),
			\legato, 1,
			\legato, Pseq([
				2.2,0,0,0, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1,
			\gain, 1/8,
			\out, BusDef(\mixer4, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 1/4, 0, 1,
				3/4, 1, 0, 1,
				1/2, 1, 3/4, 1, 
			],1),1/2).loop / Pkey(\st),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0.5,0.5,0.5, 0.5,0.5,0.5,0.5,
				0,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/2,
			\out, BusDef(\mixer5, \audio),
		),
		
	])
)).play;
);
Pdef(\part).clear;

(
	// other
	~master.();
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1308].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1613].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[156].value,
			\isRest, (Pseq([
				1,0,0,0, 1,0,0,0, 
				1,0,1,0, 1,0,1,0, 
				Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				],1)/2,
				Pseq([
					1,0,1,0, 1,1,1,1, 
					1,0,1,1, 1,0,1,1, 
					1,0,1,0, 1,0,1,0, 
					1,0,1,0, 1,0,1,0, 
				],1)/2,
				1,0,1,0, 1,1,1,1, 
				1,0,1,1, 1,0,1,1, 
				1,1,1,0, 1,1,1,0, 
				1,0,0,0, 1,0,1,0,
				1,1,1,1, 1,0,1,0,
			],inf) * Pseq([0.51,1],inf) ).coin.not,
			\gain, 0.11 * Pseq([1,0.4,0.7,0.4],inf) * Pwhite(0.8,1,inf),
			\dur, 1/8,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1077].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0, 
				1,0,1,0, 1,0,1,0, 
				Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				],1)/2,
				Pseq([
					1,0,1,0, 1,0,1,0, 
					1,0,1,0, 1,0,1,0, 
				],1)/2,
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,0,0, 1,0,1,0,
				1,1,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([1,0.4,0.7,0.4],inf) * Pwhite(0.8,1,inf),
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, Pgauss(0.5,0.1,inf) * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				2/5, 1, 2/5, 3/5,
				0, 1/4, 0, 1,
				2/4, 1, 2/5, 3/5,
				1/2, 1, 3/4, 1, 
			],1),1/2).loop / Pkey(\st),
			\isRest, Pseq([
				1,0.5,0.5,0.5, 1,0.5,0.5,0.5,
				1,0,0,0, 1,1,1,1,
				0,1,1,0, 1,0,1,1,
				1,0.5,0.5,0.5, 0.5,0.5,0.5,0.5,
				0,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/2,
			\out, BusDef(\mixer5, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				0,0,0,5.2,
				4,0,0,5.2,
			],inf),
			\legato, 1,
			\legato, Pseq([
				2.5,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\mixer4, \audio),
			\dur, 1,
			\gain, 1/8,
		)
		
	])
)).play;
);

(
	// other
	~master.();
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1308].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1613].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[156].value,
			\isRest, (Pseq([
				1,0,0,0, 1,0,0,0, 
				1,0,1,0, 1,0,1,0, 
				Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				],1)/2,
				Pseq([
					1,0,1,0, 1,1,1,1, 
					1,0,1,1, 1,0,1,1, 
					1,0,1,0, 1,0,1,0, 
					1,0,1,0, 1,0,1,0, 
				],1)/2,
				1,0,1,0, 1,1,1,1, 
				1,0,1,1, 1,0,1,1, 
				1,1,1,0, 1,1,1,0, 
				1,0,0,0, 1,0,1,0,
				1,1,1,1, 1,0,1,0,
			],inf) * Pseq([0.51,1],inf) ).coin.not,
			\gain, 0.11 * Pseq([1,0.4,0.7,0.4],inf) * Pwhite(0.8,1,inf),
			\dur, 1/8,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1077].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0, 
				1,0,1,0, 1,0,1,0, 
				Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				],1)/2,
				Pseq([
					1,0,1,0, 1,0,1,0, 
					1,0,1,0, 1,0,1,0, 
				],1)/2,
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,0,0, 1,0,1,0,
				1,1,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([1,0.4,0.7,0.4],inf) * Pwhite(0.8,1,inf),
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, Pgauss(0.5,0.1,inf) * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				2/5, 1, 2/5, 3/5,
				0, 1/4, 0, 1,
				2/4, 1, 2/5, 3/5,
				1/2, 1, 3/4, 1, 
			],1),1/2).loop / Pkey(\st),
			\isRest, Pseq([
				1,0.5,0.5,0.5, 1,0.5,0.5,0.5,
				1,0,0,0, 1,1,1,1,
				0,1,1,0, 1,0,1,1,
				1,0.5,0.5,0.5, 0.5,0.5,0.5,0.5,
				0,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/2,
			\out, BusDef(\mixer5, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				8,0,0,9,
				9,0,9,5.2,
			],inf),
			\legato, 1,
			\legato, Pseq([
				0.6,0,0,0,
			   	0,0,0,0,
				2.5,0,0,1,
				1,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\mixer4, \audio),
			\dur, 1/2,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\speed, ~pmodenv.(Pseq([1,0.82],1), 2).loop,
			\pos, Pseq([
				12,13.2,0,9,
				9,0,9,5.2,
				13,13.2,0,9,
				9,0,9.9,5.2,
			],inf),
			\legato, 1,
			\legato, Pseq([
				2.5,0,0,0,
				0,0,2,0,
				0,2.5,0,0,
				0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\mixer4, \audio),
			\dur, 1/2,
			\gain, 1/8,
		)
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\speed, Pwhite(0.4,2),
			\pos, Pseq([
				Pwhite(0.1,15),
			],inf),
			\legato, 1,
			\legato, Pseq([
				Pwhite(0.1,1),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\mixer4, \audio),
			\dur, Pwhite(0.1/3,0.4),
			\gain, 1/8,
		)
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\speed, Pgauss(1,0.02),
			\pos, Pseq([
				Pseg(Pseq([0,1],1),8),
			],inf),
			\legato, 1,
			\legato, Pseq([
				Pwhite(0.1,1),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\mixer4, \audio),
			\dur, Pwhite(0.1/3,0.4),
			\gain, 1/8,
		)
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1/2,
			\st, 92.10/4/60,
			\speed, Pgauss(0.8,0.1) * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				4/10, 1/10,
			]+3,1),4).loop / Pkey(\st),
			\isRest, Pseq([
				1,0.4,0.9,
			],inf).coin.not,
			\dur, 1/9,
			\gain, ~pmodenv.(Pseq(1/[1,2,3,8,1,4] * 0.11,1), 11).loop,
			\out, BusDef(\mixer0, \audio),
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\speed, Pgauss(1,0.02),
			\pos, Pseq([
				Pseg(Pseq([8,2],1),8),
			],inf),
			\legato, 1,
			\legato, Pseq([
				Pwhite(0.1,1),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\mixer4, \audio),
			\dur, Pwhite(0.1/3,0.1),
			\gain, 1/8,
		)
	])
)).play;
);

Ndef(\fx4).end

(
SynthDef(\longfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,2.8]), 1);
	env2 = EnvGen.kr(Env([1,2,1],[0.1,2.8]), 1);
	sig = SinOscFB.ar(freq * ( SinOsc.ar(\fmfac.kr(1) * freq) * \fmamp.kr(0.51) * env1 * ( SinOsc.ar(env2) * 1 + 1 ) + 1 ), \fb.kr(1));
	sig1 = SinOscFB.ar(freq * ( SinOsc.ar(\fmfac2.kr(1) * freq, 1) * \fmamp.kr(0.51) * env1 * ( SinOsc.ar(env2) * 1 + 1 ) + 1 ), \fb2.kr(1));
	//sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);
	sig = [sig, sig1];
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		PmonoArtic( \longfm,
			\note, Pseq([
				0,3,7,3
			],inf),
			\legato, Pseq([
				1,1,1,0.9,
			],inf),
			\octave, 3,
			\fb, ~pmodenv.(Pseq([0,1],1), 4).loop,
			\fmfac, ~pmodenv.(Pseq([1/3,1/2,1,1/4],1), 9).loop,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\mixer0, \audio),
		),
		PmonoArtic( \longfm,
			\note, Pseq([
				0,7,
			],inf),
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,0.9,
			],inf),
			\octave, 6,
			\fb, ~pmodenv.(Pseq([0,1],1), 4).loop,
			\fmfac, ~pmodenv.(Pseq([1/3,1/2,1,1/4],1), 9).loop,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\mixer1, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		PmonoArtic( \longfm,
			\note, Pseq([
				0,0,-1,-1,0,-3,
			],inf),
			\legato, Pseq([
				1,1,1,0.9,
			],inf),
			\octave, 3,
			\fb, ~pmodenv.(Pseq([0,1],1), 4).loop,
			\fmfac, ~pmodenv.(Pseq([1/3,1/2,1,1/4],1), 9).loop,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\mixer2, \audio),
		),
		PmonoArtic( \longfm,
			\note, Pseq([
				0,6,0,5,0,4,
			],inf),
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,0.9,
			],inf),
			\octave, 6,
			\fb, ~pmodenv.(Pseq([0,1],1), 4).loop,
			\fmfac, ~pmodenv.(Pseq([1/3,1/2,1,1/4],1), 9).loop,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\mixer4, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		PmonoArtic( \longfm,
			\note, Pseq([
				0,0,-1,-1,0,-3,
			],inf),
			\legato, Pseq([
				1,1,1,0.9,
			],inf),
			\octave, 3,
			\fb, ~pmodenv.(Pseq([0,1],1), 4).loop,
			\fmfac, ~pmodenv.(Pseq([1/3,1/2,1,1/4],1), 9).loop,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\mixer2, \audio),
		),
		PmonoArtic( \longfm,
			\note, Pseq([
				0,6,0,5,0,4,
			],inf),
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,0.9,
			],inf),
			\octave, 6,
			\fb, ~pmodenv.(Pseq([0,1],1), 4).loop,
			\fmfac, ~pmodenv.(Pseq([1/3,1/2,1,1/4],1), 9).loop,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\mixer4, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				0,1.2,
			],inf),
			\legato, 1/2,
			\dur, 2,
			\gain, 1/8,
			\out, BusDef(\mixer3, \audio),
		)
		
	])
)).play;
);

ProtoDef(\piano).startControl()

(
	// algo kick
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\gain, 0.1,
			\isRest, Pseq([
				Prout({ arg ev;
					var tab = [ 1,0,0];
					var idx, idx2, val;
					var cursor = 0;
					loop{
						idx = tab.size.rand;
						idx2 = idx + [-1, 1].choose % tab.size;
						val = rrand(-1.0,1);
						tab[idx] = (tab[idx] + val).clip(0,1);
						tab[idx2] = (tab[idx2] - val).clip(0,1);
						tab.size.do { arg cursor;
							//ev.debug("ev");
							ev[\gain] = tab[cursor] * 0.1;
							ev = tab[cursor].yield;
							//cursor = cursor + 1 % tab.size;
						};
						tab.debug("tab");
					}
				}),
			],inf).coin.not,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);

(
// algo kick and hat
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[219].value,
			\gain, 0.1,
			\isRest, Pseq([
				Prout({ arg ev;
					var tab, idx, idx2, val;
					var cursor = 0;
					tab = [ 1,0,0];
					//tab = [ 1,0,0,0, 0,0,0,0];
					//tab = [ 1,0,0, 1,0,0];
					//tab = [ 1,0,0, 1,0,0, 1,0,0];
					loop{
						idx = tab.size.rand;
						idx2 = idx + [-1, 1].choose % tab.size;
						val = rrand(-1.0,1);
						tab[idx] = (tab[idx] + val).clip(0,1);
						tab[idx2] = (tab[idx2] - ( val * 2 )).clip(0,1);
						tab.size.do { arg cursor;
							//ev.debug("ev");
							ev[\gain] = tab[cursor] * 0.1;
							ev = tab[cursor].yield;
							//0.1.coin.if{ 0.yield; }
							//cursor = cursor + 1 % tab.size;
						};
						tab.debug("tab");
					}
				}),
			],inf).coin.not,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2211].value,
			\bufnum, ~buflib.snare[1800].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],4),
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0.3,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0.3,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1809].value,
			\gain, 0.11,
			\isRest, Pseq([
				Prout({ arg ev;
					var tab = [ 1,0,1,0, 1,0,1,0];
					var idx, idx2, val;
					var cursor = 0;
					loop{
						idx = tab.size.rand;
						idx2 = idx + [-1, 1].choose % tab.size;
						val = rrand(-1.0,1);
						tab[idx] = (tab[idx] + val).clip(0,1);
						tab[idx2] = (tab[idx2] - val).clip(0,1);
						tab.size.do { arg cursor;
							//ev.debug("ev");
							ev[\gain] = tab[cursor] * 0.1;
							ev = tab[cursor].yield;
							//cursor = cursor + 1 % tab.size;
						};
						tab.debug("tab");
					}
				}),
			],inf).coin.not,
			\dur, 1/8,
		),
	])
)).play;
);



(
// algo kick and hat variation
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[219].value,
			\gain, 0.1,
			\isRest, Pseq([
				Prout({ arg ev;
					var tab, idx, idx2, val;
					var cursor = 0;
					tab = [ 1,0,0];
					//tab = [ 1,0,0,0, 0,0,0,0];
					//tab = [ 1,0,0, 1,0,0];
					//tab = [ 1,0,0, 1,0,0, 1,0,0];
					loop{
						idx = tab.size.rand;
						idx2 = idx + [-1, 1].choose % tab.size;
						val = rrand(-1.0,1);
						tab[idx] = (tab[idx] + val).clip(0,1);
						tab[idx2] = (tab[idx2] - ( val * 2 )).clip(0,1);
						tab.size.do { arg cursor;
							//ev.debug("ev");
							ev[\gain] = tab[cursor] * 0.1;
							ev = tab[cursor].yield;
							//0.1.coin.if{ 0.yield; }
							//cursor = cursor + 1 % tab.size;
						};
						tab.debug("tab");
					}
				}),
			],inf).coin.not,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2211].value,
			\bufnum, ~buflib.snare[1800].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],4),
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0.3,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0.3,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1809].value,
			\gain, 0.11,
			\isRest, Pseq([
				Prout({ arg ev;
					var tab = [ 1,0,1,0, 1,0,1,0];
					var idx, idx2, val;
					var cursor = 0;
					loop{
						idx = tab.size.rand;
						idx2 = idx + [-1, 1].choose % tab.size;
						val = rrand(-1.0,1);
						tab[idx] = (tab[idx] + val).clip(0,1);
						tab[idx2] = (tab[idx2] - val).clip(0,1);
						tab.size.do { arg cursor;
							//ev.debug("ev");
							ev[\gain] = tab[cursor] * 0.1;
							ev = tab[cursor].yield;
							//cursor = cursor + 1 % tab.size;
						};
						tab.debug("tab");
					}
				}),
			],inf).coin.not,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\speed, Pgauss(1,0.02),
			\pos, Pseq([
				Pseg(Pseq([0,1],1),8),
			],inf),
			\legato, 1,
			\legato, Pseq([
				Pwhite(0.1,1),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\mixer4, \audio),
			\dur, Pwhite(0.1/3,0.4),
			\gain, 1/8,
		)
	])
)).play;
);

(
// algo kick and hat variation
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[219].value,
			\gain, 0.1,
			\isRest, Pseq([
				Prout({ arg ev;
					var tab, idx, idx2, val;
					var cursor = 0;
					//tab = [ 1,0,0];
					//tab = [ 1,0,0,0, 0,0,0,0];
					//tab = [ 1,0,0, 1,0,0];
					tab = [ 1,0,0, 1,0,0, 1,0,0];
					loop{
						idx = tab.size.rand;
						idx2 = idx + [-1, 1].choose % tab.size;
						val = rrand(-1.0,1);
						tab[idx] = (tab[idx] + val).clip(0,1);
						tab[idx2] = (tab[idx2] - ( val * 2 )).clip(0,1);
						tab.size.do { arg cursor;
							//ev.debug("ev");
							ev[\gain] = tab[cursor] * 0.1;
							ev = tab[cursor].yield;
							//0.1.coin.if{ 0.yield; }
							//cursor = cursor + 1 % tab.size;
						};
						tab.debug("tab");
					}
				}),
			],inf).coin.not,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2211].value,
			\bufnum, ~buflib.snare[1800].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],4),
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0.3,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0.3,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1809].value,
			\gain, 0.11,
			\isRest, Pseq([
				Prout({ arg ev;
					var tab = [ 1,0,1,0, 1,0,1,0];
					var idx, idx2, val;
					var cursor = 0;
					loop{
						idx = tab.size.rand;
						idx2 = idx + [-1, 1].choose % tab.size;
						val = rrand(-1.0,1);
						tab[idx] = (tab[idx] + val).clip(0,1);
						tab[idx2] = (tab[idx2] - val).clip(0,1);
						tab.size.do { arg cursor;
							//ev.debug("ev");
							ev[\gain] = tab[cursor] * 0.1;
							ev = tab[cursor].yield;
							//cursor = cursor + 1 % tab.size;
						};
						tab.debug("tab");
					}
				}),
			],inf).coin.not,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1190].value,
			\gain, 0.11,
			\isRest, Pseq([
				Prout({ arg ev;
					var tab = [ 0,0,1,0, 0,0,1,0];
					var idx, idx2, val;
					var cursor = 0;
					loop{
						idx = tab.size.rand;
						idx2 = idx + [-1, 1].choose % tab.size;
						val = rrand(-1.0,1);
						tab[idx] = (tab[idx] + val).clip(0,1);
						tab[idx2] = (tab[idx2] - val).clip(0,1);
						tab.size.do { arg cursor;
							//ev.debug("ev");
							ev[\gain] = tab[cursor] * 0.1;
							ev = tab[cursor].yield;
							//cursor = cursor + 1 % tab.size;
						};
						tab.debug("tab");
					}
				}),
			],inf).coin.not,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1914].value,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\dur, Prand([1/12,1/6,1/3,1/8],inf),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\speed, Pgauss(1,0.02),
			\pos, Pseq([
				Pseg(Pseq([0,1],1),8),
			],inf),
			\legato, 1,
			\legato, Pseq([
				Pwhite(0.1,1),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\mixer4, \audio),
			\dur, Prand([1/12,1/6,1/8,1/4,1/2],inf),
			\gain, 1/8,
		),
	])
)).play;
);

ProtoDef(\fxMixer).stop

(
	~master.();
// algo kick and hat variation with break
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[219].value,
			\gain, 0.1,
			\isRest, Pseq([
				Prout({ arg ev;
					var tab, idx, idx2, val;
					var cursor = 0;
					//tab = [ 1,0,0];
					//tab = [ 1,0,0,0, 0,0,0,0];
					//tab = [ 1,0,0, 1,0,0];
					tab = [ 1,0,0, 1,0,0, 1,0,0];
					7.do{
						idx = tab.size.rand;
						idx2 = idx + [-1, 1].choose % tab.size;
						val = rrand(-1.0,1);
						tab[idx] = (tab[idx] + val).clip(0,1);
						tab[idx2] = (tab[idx2] - ( val * 2 )).clip(0,1);
						tab.size.do { arg cursor;
							//ev.debug("ev");
							ev[\gain] = tab[cursor] * 0.1;
							ev = tab[cursor].yield;
							//0.1.coin.if{ 0.yield; }
							//cursor = cursor + 1 % tab.size;
						};
						tab.debug("tab");
					}
				}),
				Pseq([
					0,0,0,0, 0,0,0,0,
				],1),
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2211].value,
			\bufnum, ~buflib.snare[1800].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],4),
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0.3,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0.3,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1809].value,
			\gain, 0.11,
			\isRest, Pseq([
				Prout({ arg ev;
					var tab = [ 1,0,1,0, 1,0,1,0];
					var idx, idx2, val;
					var cursor = 0;
					7.do{
						idx = tab.size.rand;
						idx2 = idx + [-1, 1].choose % tab.size;
						val = rrand(-1.0,1);
						tab[idx] = (tab[idx] + val).clip(0,1);
						tab[idx2] = (tab[idx2] - val).clip(0,1);
						tab.size.do { arg cursor;
							//ev.debug("ev");
							ev[\gain] = tab[cursor] * 0.1;
							ev = tab[cursor].yield;
							//cursor = cursor + 1 % tab.size;
						};
						tab.debug("tab");
					}
				}),
				Pseq([
					0,0,0,0, 0,0,0,0,
				],1),
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1190].value,
			\gain, 0.11,
			\isRest, Pseq([
				Prout({ arg ev;
					var tab = [ 0,0,1,0, 0,0,1,0];
					var idx, idx2, val;
					var cursor = 0;
					7.do{
						idx = tab.size.rand;
						idx2 = idx + [-1, 1].choose % tab.size;
						val = rrand(-1.0,1);
						tab[idx] = (tab[idx] + val).clip(0,1);
						tab[idx2] = (tab[idx2] - val).clip(0,1);
						tab.size.do { arg cursor;
							//ev.debug("ev");
							ev[\gain] = tab[cursor] * 0.1;
							ev = tab[cursor].yield;
							//cursor = cursor + 1 % tab.size;
						};
						tab.debug("tab");
					}
				}),
				Pseq([
					0,0,0,0, 0,0,0,0,
				],1),
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1914].value,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\dur, Prand([1/12,1/6,1/3,1/8],inf),
			\gain, 0.11,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\speed, Pgauss(1,0.02),
			\pos, Pseq([
				Pseg(Pseq([0,1],1),8),
			],inf),
			\legato, 1,
			\legato, Pseq([
				Pwhite(0.1,1),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\mixer4, \audio),
			\dur, Prand([1/12,1/6,1/8,1/4,1/2],inf),
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\pos, Pseq([
				0,1.2,
			],inf),
			\legato, 1/2,
			\dur, 2,
			\gain, 1/8,
			\out, BusDef(\mixer3, \audio),
		)
	])
)).play;
);


(
SynthDef(\orge, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = Grain	
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
SynthDef(\bassamp, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, pitch_stretch=1, pos=0, gdur=0.1, gfreq=100, mbufnum=0;
	var sig;
	var clk = Impulse.ar(gfreq);
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	pos = pos + LFNoise1.kr(10,mul:0.1);
	freq = freq * [1,1.001,1.0002,2];
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos + [1,0.3,1.3,0.8] * \postabscale.kr(0.1) % BufDur.kr(mbufnum), gdur, pan, 1) * [1,1,1,0.1];
	sig.debug("sig");
	sig1 = LFSaw.ar(freq * ( sig * \fmamp.kr(2.9) + 1 )).mean;
	sig1 = RLPF.ar(sig1, \lpfr.kr(4.1) * freq, \rq.kr(0.5));
	sig.debug("sig");
	sig2 = SinOsc.ar(freq * ( sig * \fmamp.kr(2.9) + 1 )).mean;
	sig3 = SelectX.ar(\oscmix.kr(0.8), [sig1, sig2]);
	sig = SelectX.ar(\mix.kr(0.0), [sig, sig3]);
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bassamp,
			\mbufnum, BufDef.mono('loop/lovin.flac'),
			\note, Pseq([
				0,3,1,1
			],inf).stutter(4),
			\legato, Pseq([
				4,0,0,0, 0,0,1,0,
				2,0,4,0, 0,0,1,0,
				4,0,0,0, 0,0,1,0,
				2,0,4,0, 0,1,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\mix, ~pmodenv.(Pseq([
				0,0.3,0,0,
			],inf), Pseg(Pseq([0.01,1],inf),8)),
			\pos, Pseg(Pseq([0,2],inf),2),
			\postabscale, ~pmodenv.(Pseq([0.1,2,1,4],1), 8).loop,
			\gdur, 0.08,
			\octave, 4,
			\gfreq, Pkey(\freq)/4,
			\gfreq, Pseg(Pseq([1,0.1,10],inf),4),
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		PmonoArtic(
			\bassamp,
			\freq, ~pmodenv.(Pseq([10,100,80]*3,1), 2).loop,
			\gfreq, ~pmodenv.(Pseq([0.1,2,1,4],1), Pseg(Pseq([0,8],inf),8)).loop,
			\mix, ~pmodenv.(Pseq([0.4,0,1],1), Pseq((1..8))).loop,
			\oscmix, ~pmodenv.(Pseq([0,1],1), 4).loop,
			\legato, Pseq([
				1,1,1,0.4,
			],inf),
			\dur, PdurStutter(Pseq((1..8),inf), 1/2),
			\amp, 0.1,
		),
		
	])
)).play;
);



(
Instr(\randfm, { arg gate=1, pan=0, amp=0.1, freqratio=1, ratio=0.9, rel=0.1, impfreq=1;
	var sig;
	var fun = { arg x; 
		SinOsc.ar(rrand(0.1,1000.0) * [0.99,1.01] * freqratio * ( x * ratio + 1 ) ) 
		* EnvGen.kr(Env([0,1,0],[0.1,rel]), Impulse.kr(rrand(1,16)/2 * ~t));
	};
	sig = DC.ar(0);
	16.do {
		sig = fun.(sig);
	};
	sig = sig * 0.5;
	sig = sig * amp;
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,1,0.1),gate,doneAction:2);
	//Out.ar(out, sig);
	//sig = Pan2.ar(sig, pan, amp);
});
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\type, \instr,
			\instr, \randfm,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);



(
    Instr("minimoog.two",{ arg freq=440,int1=5,int2 = -5,width1=0.1,width2=0.1,width3=0.1,
            ffreqInterval=0,rq=0.4;
        var p;

        p=Pulse.ar([ freq  * int1.midiratio, freq, freq * int2.midiratio],
                [ width1,width2,width3],0.3);

        RLPF.ar(Mix(p),freq * ffreqInterval.midiratio,rq)
            * EnvGen.kr(Env.perc,doneAction: 2)

    });

    Pbind(
        \type, \instr,
        \instr, "minimoog.two",
        // note is converted to freq by things in NotePlayer
        \note,Prand([10,20,30],inf),
        // args are passed into the function
        \int1, Prand([-3,0,7,11,13],inf),
        \dur, 0.5
    ).play
)
