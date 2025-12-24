
// improvise with synthdef in libs

(
FileSystemProject.load("sun/main.scd");
~t = 130/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("sndlib/mysynthdefault.scd");
FileSystemProject.load("sndlib/synthbasic.scd");
FileSystemProject.load("sndlib/buflib.scd");
)


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[805].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[35].value,
			\isRest, Pseq([
				0,0,1,0, 1,0,0,1,
				1,0,0,1, 0,1,0,0,
				0,0,1,0, 0,1,0,1,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[880].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.5,
				1,0.5,
			],inf),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,
			],inf),
			\envamt, 4,
			\dur, 1,
			\amp, 0.1,
			\isRest, true,
		),
	])
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[805].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[35].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[880].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
				0,1,1,0, 1,0,1,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,0,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.5,
				1,0.5,
			],inf),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\envamt, 4,
			\lpf, Pseg(Pseq([200,1000],inf),8),
			\legato, Pseq([
				Pseg(Pseq([0.1,1],inf),8),
			],1),
			\adsr, Pseq([
				PpatEnv.adsr(Pseg(Pseq([0.01,0.1],inf),8),0.1,0.8,0.1)
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \rolandsupersaw,
			\note, Pseq([
				[0,4,7],
				[0,4,7],
				[-1,4,7],
				[0,4,7],
			],inf).stutter(4) + Pseq([0,-2],inf).stutter(8*2),
			\lpf, Pseg(Pseq([1000,6000],inf),8),
			\octave, 5,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.2,1.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \mellowpad,
			\note, Pseq([
				[0,4,7],
				[0,4,7],
				[-1,4,7],
				[0,4,7],
			],inf).stutter(4) + Pseq([0,-2],inf).stutter(8*2),
			\lpenvamt, 5,
			\lpf, 300,
			\octave, 4,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				2,0,0,2, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/5,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \reese,
			\note, Pseq([
				Pseq([
					0,4,2,
				],1).stutter(8),
				0,0,0,0, -3,1,-1,1,
			],inf).trace,
			\lpf, 3000,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 2,0,2,0,
				//0,0,0,0, 2,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\lpadsramt, 2,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \reese,
			\note, Pseq([
				Pseq([
					0,4,2,-3
				],1)
			],inf).trace,
			\legato, Pseq([
				1
				//0,0,0,0, 2,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\lpf, 100,
			\lpadsramt, Pseg(Pseq([1,20],inf),8),
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \rolandreese,
			\note, Pseq([
				Pseq([
					0,4,2,-3
				],1)
			],inf).trace,
			\legato, Pseq([
				1
				//0,0,0,0, 2,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\lpf, 100,
			\lpadsramt, Pseg(Pseq([1,20],inf),8),
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \reese2,
			\note, Pseq([
				Pseq([
					0,4,2,-3
				],1)
			],inf).trace,
			\legato, Pseq([
				1
				//0,0,0,0, 2,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\det, 0.01,
			//\lpf, 5000,
			\lpadsramt, Pseg(Pseq([1,20],inf),8),
			\dur, 1/8,
			\amp, 0.3,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \mellowpad,
			\note, Pseq([
				[0,4,7],
				[-1,4,7],
			],inf).stutter(8),
			\lpenvamt, 5,
			\lpf, 300,
			\octave, 5,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/5,
		),
	])
)).play;
);
