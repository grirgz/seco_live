
// traplike


(
FileSystemProject.load("sun/main.scd");
~t = 128/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("sndlib/mysynthdefault.scd");
FileSystemProject.load("sndlib/synthbasic.scd");
FileSystemProject.load("sndlib/buflib.scd");
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 4,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,1, 0,1,0,0,
				0,0,1,0, 0,1,0,1
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/amenbreak.wav'),
			\legato, 1,
			\st, 137/2/60,
			\speed, 0.9 * ~t / Pkey(\st),
			\pos, Pseq([
				//[0,1,2,3]/8+1,

				(0..7)/8+1,
				//[0,2,3,0, 2,3,14,15]/8+1,
				[0,3,2,0, 1,3,6,10]/8+1,
				[3,10,11,12, 8,9,10,11]/8+1,
				(0..7)/8+3,

				//(0..7)/8+2,
				//[0,2,3,0, 2,3,0,2+8]/8+1,
				//[0,3,3,4, 8,12,0,2+8]/8+1,
				//(0..3)/8+1.25,
			].flat,inf) / Pkey(\st) + 0.01,
			\dur, 1/8,
			\isRest, Pseq([
				0,1,0,0, 1,1,1,0,
				0,0,1,1, 0,0,1,1,
				0,0,1,1, 1,1,1,0,
				0,0,0,0, 0,0,1,1,
			],inf).coin.not,
			\gain, 1/8,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,-4,
			],inf).stutter(8*2) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,4,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,-4,
			],inf),
			\octave, 3,
			\envamt, PmodEnv(Pseq([0.5,1,9],1), 8*2).loop,
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.1,1,3)
			],inf),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0, 3,5,
			],inf),
			\lpf, PmodEnv(Pseq([100,1000,4000,10000],1), 8).loop,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 4,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,1, 0,1,0,0,
				0,0,1,0, 0,1,0,1
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/amenbreak.wav'),
			\legato, 1,
			\st, 137/2/60,
			\speed, 0.9 * ~t / Pkey(\st),
			\pos, Pseq([
				//[0,1,2,3]/8+1,

				(0..7)/8+1,
				//[0,2,3,0, 2,3,14,15]/8+1,
				[0,3,2,0, 1,3,6,10]/8+1,
				[3,10,11,12, 8,9,10,11]/8+1,
				(0..7)/8+3,

				//(0..7)/8+2,
				//[0,2,3,0, 2,3,0,2+8]/8+1,
				//[0,3,3,4, 8,12,0,2+8]/8+1,
				//(0..3)/8+1.25,
			].flat,inf) / Pkey(\st) + 0.01,
			\dur, 1/8,
			\isRest, Pseq([
				0,1,0,0, 1,1,1,0,
				0,0,1,1, 0,0,1,1,
				0,0,1,1, 1,1,1,0,
				0,0,0,0, 0,0,1,1,
			],inf).coin.not,
			\gain, 1/8,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 4,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1281].value,
			\bufnum, ~buflib.kick[1015].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,0,0,0,
				0,0,0,0, 0,0,1,0,

				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,0,0, 
				0,0,0,0, 1,1,1,1,
				0,0,1,1, 0,1,0,0,
				0,0,1,0, 0,1,0,1
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/amenbreak.wav'),
			\legato, 1,
			\st, 137/2/60,
			\speed, 0.9 * ~t / Pkey(\st),
			\pos, Pseq([
				//[0,1,2,3]/8+1,

				[0,0,0,0, 1,3,6,10]/8+1,
				(0..7)/8+1,
				//[0,2,3,0, 2,3,14,15]/8+1,
				[0,3,2,0, 1,3,6,10]/8+1,
				[3,10,11,12, 8,9,10,11]/8+1,
				(0..7)/8+3,

				//(0..7)/8+2,
				//[0,2,3,0, 2,3,0,2+8]/8+1,
				//[0,3,3,4, 8,12,0,2+8]/8+1,
				//(0..3)/8+1.25,
			].flat,inf) / Pkey(\st) + 0.01,
			\dur, 1/8,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 1,1,1,0,
				0,0,1,1, 0,0,1,1,
				0,0,1,1, 1,1,1,0,
				0,0,0,0, 0,0,1,1,
			],inf).coin.not,
			\gain, 1/8,
		)
		
	])
)).play;
);

// rdn bass
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,-6
			],inf).stutter(8*2),
			\legato, Pseq([
				14,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				14,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,1,0, 1,0,1,0,
				6,0,0,0, 0,0,0,1,
				3,0,0,0, 3,0,0,0,
				6,0,0,0, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 4,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1281].value,
			\bufnum, ~buflib.kick[1015].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,1,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2 * Pseq([1,0.3],inf),
			\gain, 0.11 * Pseq([1,0.8],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/amenbreak.wav'),
			\legato, 1,
			\st, 137/2/60,
			\speed, 0.9 * ~t / Pkey(\st),
			\pos, Pseq([
				//[0,1,2,3]/8+1,

				[0,0,0,0, 1,3,6,10]/8+1,
				(0..7)/8+1,
				//[0,2,3,0, 2,3,14,15]/8+1,
				[0,3,2,0, 1,3,6,10]/8+1,
				[3,10,11,12, 8,9,10,11]/8+1,
				(0..7)/8+3,

				//(0..7)/8+2,
				//[0,2,3,0, 2,3,0,2+8]/8+1,
				//[0,3,3,4, 8,12,0,2+8]/8+1,
				//(0..3)/8+1.25,
			].flat,inf) / Pkey(\st) + 0.01,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,1,1,1,
			],inf).coin.not,
			\gain, 1/8,
		)
		
	])
)).play;
);

(
// filter rdn
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,-6
			],inf).stutter(8*2),
			\legato, Pseq([
				14,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				14,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,1,0, 1,0,1,0,
				6,0,0,0, 0,0,0,1,
				3,0,0,0, 3,0,0,0,
				6,0,0,0, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\rfx1, \audio),
			\addAction, \addToTail,
			\lag, 0.00091,
			\dur, 1/8,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				1,0,0,1, 1,0,1,1,
				1,1,0,1, 0,0,2,0,
				8,0,0,0, 0,0,0,0,
				4,0,0,0, 1,1,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 4,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1281].value,
			\bufnum, ~buflib.kick[1015].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,1,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2 * Pseq([1,0.3],inf),
			\gain, 0.11 * Pseq([1,0.8],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/amenbreak.wav'),
			\legato, 1,
			\st, 137/2/60,
			\speed, 0.9 * ~t / Pkey(\st),
			\pos, Pseq([
				//[0,1,2,3]/8+1,

				[0,0,0,0, 1,3,6,10]/8+1,
				(0..7)/8+1,
				//[0,2,3,0, 2,3,14,15]/8+1,
				[0,3,2,0, 1,3,6,10]/8+1,
				[3,10,11,12, 8,9,10,11]/8+1,
				(0..7)/8+3,

				//(0..7)/8+2,
				//[0,2,3,0, 2,3,0,2+8]/8+1,
				//[0,3,3,4, 8,12,0,2+8]/8+1,
				//(0..3)/8+1.25,
			].flat,inf) / Pkey(\st) + 0.01,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,1,1,1,
			],inf).coin.not,
			\gain, 1/8,
		)
		
	])
)).play;
);
(
// filter rdn
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,-6
			],inf).stutter(8*2),
			\legato, Pseq([
				14,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				14,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,1,0, 1,0,1,0,
				6,0,0,0, 0,0,0,1,
				3,0,0,0, 3,0,0,0,
				6,0,0,0, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\rfx1, \audio),
			\addAction, \addToTail,
			\lag, 0.00091,
			\dur, 1/8,
			\legato, Pseq([
				16,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,3,0,0,
				16,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,2, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\note, Pseq([
				Pser([
					-12,
					[ 7-12,0, ],
					[ 7-12,0, ],
				],8*3),
				Pseq([
					[3-12,9-12,0,3],
				],8),
			],inf).stutter(1),
			\octave, 5,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\lag, -0.04,
			//\out, BusDef(\sendbus2, \audio),
		),



		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 4,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1281].value,
			\bufnum, ~buflib.kick[1015].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,1,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2 * Pseq([1,0.3],inf),
			\gain, 0.11 * Pseq([1,0.8],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/amenbreak.wav'),
			\legato, 1,
			\st, 137/2/60,
			\speed, 0.9 * ~t / Pkey(\st),
			\pos, Pseq([
				//[0,1,2,3]/8+1,

				[0,0,0,0, 1,3,6,10]/8+1,
				(0..7)/8+1,
				//[0,2,3,0, 2,3,14,15]/8+1,
				[0,3,2,0, 1,3,6,10]/8+1,
				[3,10,11,12, 8,9,10,11]/8+1,
				(0..7)/8+3,

				//(0..7)/8+2,
				//[0,2,3,0, 2,3,0,2+8]/8+1,
				//[0,3,3,4, 8,12,0,2+8]/8+1,
				//(0..3)/8+1.25,
			].flat,inf) / Pkey(\st) + 0.01,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,1,1,1,
			],inf).coin.not,
			\gain, 1/8,
		)
		
	])
)).play;
);



////////////
(
// 3 note bass
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,-1,-4,
			],inf).stutter(8*2) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,4,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,-4,
			],inf),
			\octave, 3,
			\envamt, PmodEnv(Pseq([0.5,1,9],1), 8*2).loop,
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.1,1,3)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 4,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1281].value,
			\bufnum, ~buflib.kick[1015].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,0,0,0,
				0,0,0,0, 0,0,1,0,

				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,0,0, 
				0,0,0,0, 1,1,1,1,
				0,0,1,1, 0,1,0,0,
				0,0,1,0, 0,1,0,1
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/amenbreak.wav'),
			\legato, 1,
			\st, 137/2/60,
			\speed, 0.9 * ~t / Pkey(\st),
			\pos, Pseq([
				//[0,1,2,3]/8+1,

				[0,0,0,0, 1,3,6,10]/8+1,
				(0..7)/8+1,
				//[0,2,3,0, 2,3,14,15]/8+1,
				[0,3,2,0, 1,3,6,10]/8+1,
				[3,10,11,12, 8,9,10,11]/8+1,
				(0..7)/8+3,

				//(0..7)/8+2,
				//[0,2,3,0, 2,3,0,2+8]/8+1,
				//[0,3,3,4, 8,12,0,2+8]/8+1,
				//(0..3)/8+1.25,
			].flat,inf) / Pkey(\st) + 0.01,
			\dur, 1/8,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 1,1,1,0,
				0,0,1,1, 0,0,1,1,
				0,0,1,1, 1,1,1,0,
				0,0,0,0, 0,0,1,1,
			],inf).coin.not,
			\gain, 1/8,
			\isRest, true,
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
				-5,-6,-1,
			],inf),
			\octave, 3,
			\dur, 1/2,
			\amp, 0.3,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				-5,-6,-1,-1,
			],inf).stutter(8*2) + Pseq([
				0,0,0,0, 0,0,0,0,
			],inf),
			\octave, 3,
			\envamt, PmodEnv(Pseq([0.5,1,9],1), 8*2).loop,
			\dur, 1/8,
			\legato, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseq([
				1,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,1, 0,0,1,0,
				0,1,1,0, 1,0,1,1,
			],inf).coin.not,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 4,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1281].value,
			\bufnum, ~buflib.kick[1015].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,0,0,0,
				0,0,0,0, 0,0,1,0,

				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,0,0, 
				0,0,0,0, 1,1,1,1,
				0,0,1,1, 0,1,0,0,
				0,0,1,0, 0,1,0,1
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/amenbreak.wav'),
			\legato, 1,
			\st, 137/2/60,
			\speed, 0.9 * ~t / Pkey(\st),
			\pos, Pseq([
				//[0,1,2,3]/8+1,

				[0,0,0,0, 1,3,6,10]/8+1,
				//(0..7)/8+1,
				////[0,2,3,0, 2,3,14,15]/8+1,
				//[0,3,2,0, 1,3,6,10]/8+1,
				//[3,10,11,12, 8,9,10,11]/8+1,
				//(0..7)/8+3,

				//(0..7)/8+2,
				//[0,2,3,0, 2,3,0,2+8]/8+1,
				//[0,3,3,4, 8,12,0,2+8]/8+1,
				//(0..3)/8+1.25,
			].flat,inf) / Pkey(\st) + 0.01,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,0, 0,1,1,0,
				0,0,1,0, 0,0,1,0,
				0,1,0,0, 0,0,1,0,
				0,0,1,0, 0,1,1,0,
				0,1,0,0, 1,1,1,0,
				0,0,1,0, 0,1,1,0,
			],inf).coin.not,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\vel, 0.80000001192093,
			\modIndex, Pwhite(0.2,0.5,inf),
			\mix, 0.20000000298023,
			\lfoSpeed, 0.40000000596046,
			\lfoDepth, 0.10000000149012,
			\asr, [ [ 0.0, 2.0, 1.0, -99.0, 1.0, 0.0, 5.0, -4.0, 0.0, 0.10000000149012, 5.0, -4.0 ] ],
			\note, Pseq([
				Pseq([
					Prand([ 1,2,4,6, ],4),\r,
				],2),
				Pseq([ -1,1,2,4,\r,],2),
				Pseq([ -3,-1,1,2,\r,],2),
				Pseq([ -3,-1,1,2,\r,],2),
				//-4,-3,-1,1,\r,
			],inf),
			\octave, 5,
			\dur, Pseq([
				//Pwhite(0.01,1/8,4),1,
				Plazy({ arg ev;
					var str = Pwhite(0.01,1/8,4).asStream;
					var arr = str.nextN(4);
					Pseq([ Pseq(arr), 1 - arr.sum])
				}).loop,
			],inf),
			\lag, 1/2/~t,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				-5,-6,-1,-1,
			],inf).stutter(8*2) + Pseq([
				0,0,0,0, 0,0,0,0,
			],inf),
			\octave, 3,
			\envamt, PmodEnv(Pseq([0.5,1,9],1), 8*2).loop,
			\dur, 1/8,
			\legato, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseq([
				1,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,1, 0,0,1,0,
				0,1,1,0, 1,0,1,1,
			],inf).coin.not,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 4,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1281].value,
			\bufnum, ~buflib.kick[1015].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,0,0,0,
				0,0,0,0, 0,0,1,0,

				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,0,0, 
				0,0,0,0, 1,1,1,1,
				0,0,1,1, 0,1,0,0,
				0,0,1,0, 0,1,0,1
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/amenbreak.wav'),
			\legato, 1,
			\st, 137/2/60,
			\speed, 0.9 * ~t / Pkey(\st),
			\pos, Pseq([
				//[0,1,2,3]/8+1,

				[0,0,0,0, 1,3,6,10]/8+1,
				//(0..7)/8+1,
				////[0,2,3,0, 2,3,14,15]/8+1,
				//[0,3,2,0, 1,3,6,10]/8+1,
				//[3,10,11,12, 8,9,10,11]/8+1,
				//(0..7)/8+3,

				//(0..7)/8+2,
				//[0,2,3,0, 2,3,0,2+8]/8+1,
				//[0,3,3,4, 8,12,0,2+8]/8+1,
				//(0..3)/8+1.25,
			].flat,inf) / Pkey(\st) + 0.01,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,0, 0,1,1,0,
				0,0,1,0, 0,0,1,0,
				0,1,0,0, 0,0,1,0,
				0,0,1,0, 0,1,1,0,
				0,1,0,0, 1,1,1,0,
				0,0,1,0, 0,1,1,0,
			],inf).coin.not,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\vel, 0.80000001192093,
			\modIndex, Pseg(Pwhite(0.2,0.5,inf),4),
			\mix, Pseg(Pwhite(0.2,0.6,inf),5),
			\lfoSpeed, 0.40000000596046,
			\lfoDepth, 0.10000000149012,
			\note, Pseq([
				\r,\r,\r,\r,
				6,4,6,4, 2,6,1,4,
				Pseq([ -1,1,2,4,\r,],2),
				Pseq([ -3,-1,\r,],2),
				// 24
				Pseq([ -3,-1,2,\r,],2),
				Pseq([ \r,\r,-3, -1,2,\r,],1),
				Pseq([ \r,\r,-3, \r,\r,\r,],1),
				Pseq([ \r,\r,-3, \r,2,\r,],1),
				Pseq([ -1,2,\r, \r,-1,2,],1),
				Pseq([ \r,\r,-1,\r,],1),
				//-4,-3,-1,1,\r,
			],inf),
			\isRest, Pseq([
				1,1,1,0.81, 1,1,0.81,0.81,
				Pseq([
					0.8
				],8),
			],inf).coin.not,
			\octave, 5,
			\dur, 1/8,
			//\lag, 1/2/~t,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				-5,-6,-1,-1,
			],inf).stutter(8*2) + Pseq([
				0,0,0,0, 0,0,0,0,
			],inf),
			\octave, 3,
			\envamt, PmodEnv(Pseq([0.5,1,9],1), 8*2).loop,
			\dur, 1/8,
			\legato, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseq([
				1,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,1, 0,0,1,0,
				0,1,1,0, 1,0,1,1,
			],inf).coin.not,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 4,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1281].value,
			\bufnum, ~buflib.kick[1015].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,0,0,0,
				0,0,0,0, 0,0,1,0,

				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,0,0, 
				0,0,0,0, 1,1,1,1,
				0,0,1,1, 0,1,0,0,
				0,0,1,0, 0,1,0,1
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/amenbreak.wav'),
			\legato, 1,
			\st, 137/2/60,
			\speed, 0.9 * ~t / Pkey(\st),
			\pos, Pseq([
				//[0,1,2,3]/8+1,

				[0,0,0,0, 1,3,6,10]/8+1,
				//(0..7)/8+1,
				////[0,2,3,0, 2,3,14,15]/8+1,
				//[0,3,2,0, 1,3,6,10]/8+1,
				//[3,10,11,12, 8,9,10,11]/8+1,
				//(0..7)/8+3,

				//(0..7)/8+2,
				//[0,2,3,0, 2,3,0,2+8]/8+1,
				//[0,3,3,4, 8,12,0,2+8]/8+1,
				//(0..3)/8+1.25,
			].flat,inf) / Pkey(\st) + 0.01,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,0, 0,1,1,0,
				0,0,1,0, 0,0,1,0,
				0,1,0,0, 0,0,1,0,
				0,0,1,0, 0,1,1,0,
				0,1,0,0, 1,1,1,0,
				0,0,1,0, 0,1,1,0,
			],inf).coin.not,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\vel, 0.80000001192093,
			\modIndex, Pseg(Pwhite(0.2,0.5,inf),4),
			\mix, Pseg(Pwhite(0.2,0.6,inf),5),
			\lfoSpeed, 0.40000000596046,
			\lfoDepth, 0.10000000149012,
			\note, Pseq([
				\r,\r,\r,\r,
				6,4,6,4, 2,6,1,4,
				Pseq([ -1,1,2,4,\r,],2),
				Pseq([ -3,\r,-1,],2),
				// 24
				Pseq([ -3,\r,-1,2,],2),
				Pseq([ 2,\r,-3, \r,\r,-1,],1),
				Pseq([ \r,\r,-3, \r,\r,\r,],1),
				Pseq([ \r,\r,-3, \r,2,\r,],1),
				Pseq([ -1,2,\r, \r,-1,2,],1),
				Pseq([ \r,\r,-1,\r,],1),
				//-4,-3,-1,1,\r,
			],inf),
			\isRest, Pseq([
				1,1,1,0.81, 1,1,0.81,0.81,
				Pseq([
					0.8
				],8),
			],inf).coin.not,
			\octave, 5,
			\dur, 1/8,
			//\lag, 1/2/~t,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\vel, 0.80000001192093,
			\modIndex, Pseg(Pwhite(0.2,0.5,inf),4),
			\mix, Pseg(Pwhite(0.2,0.6,inf),5),
			\lfoSpeed, 0.40000000596046,
			\lfoDepth, 0.10000000149012,
			\note, Pseq([
				//\r,\r,\r,6, 4,\r,\r,\r,
				//\r,\r,-1,2, -3,\r,\r,\r,
				//\r,\r,-1,2, 
				Pseq([
					-3,\r,-1,2,
				],inf),
			],inf),
			\isRest, Pseq([
				1,
				//1,1,1,0.81, 1,1,0.81,0.81,
				//Pseq([
					//0.8
				//],8),
			],inf).coin.not,
			\octave, 5,
			\dur, 1/8,
			//\lag, 1/2/~t,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				9,7,6,6,
				4,2,-1,-1,
			],inf),
			\octave, 6,
			\dur, 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				9,9,6,\r,
				4,7,-1,\r,
			],inf).stutter(8),
			\octave, 6,
			\dur, 2/8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0.51,0,
			],inf).coin.not,
			\amp, 0.3,
		),
		
	])
)).play;
);

////
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				-5,-6,-1,-1,
			],inf).stutter(8*2) + Pseq([
				0,0,0,0, 0,0,0,0,
			],inf),
			\octave, 3,
			\envamt, PmodEnv(Pseq([0.5,1,9],1), 8*2).loop,
			\dur, 1/8,
			\legato, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseq([
				1,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,1, 0,0,1,0,
				0,1,1,0, 1,0,1,1,
			],inf).coin.not,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 4,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1281].value,
			\bufnum, ~buflib.kick[1015].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,1, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,0,1, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/amenbreak.wav'),
			\legato, 1,
			\st, 137/2/60,
			\speed, 0.9 * ~t / Pkey(\st),
			\pos, Pseq([
				//[0,1,2,3]/8+1,

				Pseq([
					(0..7)/8+1,
					[0,0,0,0, 1,3,6,10]/8+1,
				].flat,2),
					(0..7)/8+1,
					(0..7)/8+1,
				////[0,2,3,0, 2,3,14,15]/8+1,
				//[0,3,2,0, 1,3,6,10]/8+1,
				//[3,10,11,12, 8,9,10,11]/8+1,
				//(0..7)/8+3,

				//(0..7)/8+2,
				//[0,2,3,0, 2,3,0,2+8]/8+1,
				//[0,3,3,4, 8,12,0,2+8]/8+1,
				//(0..3)/8+1.25,
			].flat,inf) / Pkey(\st) + 0.01,
			\dur, 1/8,
			\isRest, Pseq([
			   	0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,1,
			   	1,1,0,1, 0,1,0,0,
				0,0,0,0, 0,0,1,1,

			   	0,0,0,0, 0,0,1,0,
				0,1,1,0, 1,1,0,0,
			   	1,1,0,0, 1,1,0,0,
				0,0,1,1, 1,1,0,0,
			],inf).coin.not,
			\gain, 1/8,
		),
		Ppar([
			Pbind(
				\note, -1,
				\dur, 1/2,
				\isRest, Pseq([
					1,0,0.5,0.6, 0.6,0.5,0,0,
					//1,0,1,1, 1,1,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\sustain, 0.4,
			),
			Pbind(
				\note, 2,
				\dur, 1.2,
				\isRest, Pseq([
					1,1,0,1,
				],inf).coin.not,
			),
			Pbind(
				\note, 4,
				\dur, 2.2,
				\isRest, Pseq([
					0,1,0,1,1,
				],inf).coin.not,
				\octave, Prand([5,6],inf)
			),
			Pbind(
				\note, 5,
				\dur, 3.1,
				\isRest, Pseq([
					0,1,1,0,
				],inf).coin.not,
			),
			Pbind(
				\note, Pseq([6,6,9],inf),
				\dur, 2.3,
				\isRest, Pseq([
					0,0,1,1,
				],inf).coin.not,
				\octave, Prand([5,6],inf)
			),
		].collect { arg pat, idx;
			pat <>
			Pbind(
				\instrument, \sh101,
				\vel, 0.80000001192093,
				\modIndex, Pseg(Pwhite(0.2,0.5,inf),4),
				\mix, Pseg(Pwhite(0.2,0.6,inf),5),
				\lfoSpeed, 0.40000000596046,
				\lfoDepth, 0.10000000149012,
				\note, Pseq([
					//\r,\r,\r,6, 4,\r,\r,\r,
					//\r,\r,-1,2, -3,\r,\r,\r,
					//\r,\r,-1,2, 
					Pseq([
						//-3,\r,-1,2,
						[-3,-1,2]
					],inf),
				],inf),
				\lpf, PmodEnv(Pseq([100,2000,14000],1), 8).loop,
				\isRest, Pseq([
					1,
					//1,1,1,0.81, 1,1,0.81,0.81,
					//Pseq([
					//0.8
					//],8),
				],inf).coin.not,
				\octave, 5,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.41,0.1,0.8,1.1) ],
				],inf),
				\sustain, Pseq([
					0.3,0.1,0.6,
				],inf),
				//\out, BusDef(\ifx1, \audio),
				//\lag, 1/2/~t,
				\amp, 0.071 * Pseg(Pseq([1,Pwhite(0.6,1,3)],inf),1/4),
			);
		},inf),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				-5,-6,-1,-1,
			],inf).stutter(8*2) + Pseq([
				0,0,0,0, 0,0,0,0,
			],inf),
			\octave, 3,
			\envamt, PmodEnv(Pseq([0.5,1,9],1), 8*2).loop,
			\dur, 1/8,
			\legato, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseq([
				1,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,1, 0,0,1,0,
				0,1,1,0, 1,0,1,1,
			],inf).coin.not,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 4,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1281].value,
			\bufnum, ~buflib.kick[1015].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,1, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,0,1, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/amenbreak.wav'),
			\legato, 1,
			\st, 137/2/60,
			\speed, 0.9 * ~t / Pkey(\st),
			\pos, Pseq([
				//[0,1,2,3]/8+1,

				Pseq([
					(0..7)/8+1,
					[0,0,0,0, 1,3,6,10]/8+1,
				].flat,2),
					(0..7)/8+1,
					(0..7)/8+1,
				////[0,2,3,0, 2,3,14,15]/8+1,
				//[0,3,2,0, 1,3,6,10]/8+1,
				//[3,10,11,12, 8,9,10,11]/8+1,
				//(0..7)/8+3,

				//(0..7)/8+2,
				//[0,2,3,0, 2,3,0,2+8]/8+1,
				//[0,3,3,4, 8,12,0,2+8]/8+1,
				//(0..3)/8+1.25,
			].flat,inf) / Pkey(\st) + 0.01,
			\dur, 1/8,
			\isRest, Pseq([
			   	0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,1,
			   	1,1,0,1, 0,1,0,0,
				0,0,0,0, 0,0,1,1,

			   	0,0,0,0, 0,0,1,0,
				0,1,1,0, 1,1,0,0,
			   	1,1,0,0, 1,1,0,0,
				0,0,1,1, 1,1,0,0,
			],inf).coin.not,
			\gain, 1/8,
		),
		Ppar([
			Pbind(
				\note, -1,
				\dur, 1/2,
				\isRest, Pseq([
					1,0,0.5,0.6, 0.6,0.5,0,0,
					//1,0,1,1, 1,1,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\sustain, 0.4,
			),
			Pbind(
				\note, 2,
				\dur, 1.2/2,
				\isRest, Pseq([
					1,1,0,1,
				],inf).coin.not,
			),
			Pbind(
				\note, 4,
				\dur, 2.2/2,
				\isRest, Pseq([
					0,1,0,1,1,
				],inf).coin.not,
				\octave, Prand([5,6],inf)
			),
			Pbind(
				\note, 5,
				\dur, 3.1/2,
				\isRest, Pseq([
					0,1,1,0,
				],inf).coin.not,
			),
			Pbind(
				\note, Pseq([6,6,9],inf),
				\dur, 2.3/2,
				\isRest, Pseq([
					0,0,1,1,
				],inf).coin.not,
				\octave, Prand([5,6],inf)
			),
		].collect { arg pat, idx;
			pat <>
			Pbind(
				\instrument, \sh101,
				\vel, 0.80000001192093,
				\modIndex, Pseg(Pwhite(0.2,0.5,inf),4),
				\mix, Pseg(Pwhite(0.2,0.6,inf),5),
				\lfoSpeed, 0.40000000596046,
				\lfoDepth, 0.10000000149012,
				\note, Pseq([
					//\r,\r,\r,6, 4,\r,\r,\r,
					//\r,\r,-1,2, -3,\r,\r,\r,
					//\r,\r,-1,2, 
					Pseq([
						//-3,\r,-1,2,
						[-3,-1,2]
					],inf),
				],inf),
				\lpf, PmodEnv(Pseq([100,2000,14000],1), 8).loop,
				\isRest, Pseq([
					1,
					//1,1,1,0.81, 1,1,0.81,0.81,
					//Pseq([
					//0.8
					//],8),
				],inf).coin.not,
				\octave, 5,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.41,0.1,0.8,1.1) ],
				],inf),
				\sustain, Pseq([
					0.3,0.1,0.6,
				],inf),
				//\out, BusDef(\ifx1, \audio),
				//\lag, 1/2/~t,
				\amp, 0.071 * Pseg(Pseq([1,Pwhite(0.6,1,3)],inf),1/4),
			);
		},inf),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

//////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.foley1[222].value,
			\bufnum, ~buflib.foley1[116].value,
			\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\crushglitch, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var bufnum = ~buflib.foley1[116].value;
	var trigger = Impulse.ar(10);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * 0.91, trigger, startPos: (0.1*BufFrames.kr(bufnum)), doneAction:0, loop: 0);
	sig = sig * 7 * 1;
	//sig = SinOsc.ar(freq);
	sig = SinOsc.ar(freq * ( LFSaw.kr(4) * 0.1 + 1 )) + sig;
	sig = LFSaw.ar(freq*1.1 * ( LFSaw.kr(4) * 0.5 + 1 )) + sig;
	sig = DelayL.ar(sig, \maxdelay.kr(0.4), \delay.kr(0.01) * ( LFSaw.kr(4.1) * 0.31 + 1 )) + sig;
	//sig = RHPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(20,20000), \rq.kr(0.5));
	//sig = sig * Pulse.ar(freq/4);
	sig = FreqShift.ar(sig, -100 * ( SinOsc.kr(5) * 0.51 + 1 ) ) + sig;
	sig = sig * 0.2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \crushglitch,
			\note, Pseq([
				0,4,3,1,
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);


(
SynthDef(\slurpzig, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = XLine.kr(1,0.5,1);
	lfo2 = XLine.kr(0.1,1,1);
	sig1 = SinOsc.ar(freq * lfo1 * ( SinOsc.kr(10) * 0.51 + 1 ) * ( SinOsc.kr(1) * 0.51 + 1 ));
	sig2 = LFSaw.ar(freq/2 * [1,1.001,1.002] * ( SinOsc.kr(10) * 0.1 + 1 ) * ( SinOsc.kr(1) * 0.51 + 1 )).sum;
	sig = SelectX.ar(lfo2, [sig2, sig1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \slurpzig,
			\freq, 1200,
			\dur, 2,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				-5,-6,-1,-1,
			],inf).stutter(8*2) + Pseq([
				0,0,0,0, 0,0,0,0,
			],inf),
			\octave, 3,
			\envamt, PmodEnv(Pseq([0.5,1,9],1), 8*2).loop,
			\dur, 1/8,
			\legato, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseq([
				1,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,1, 0,0,1,0,
				0,1,1,0, 1,0,1,1,
			],inf).coin.not,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 4,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1281].value,
			\bufnum, ~buflib.kick[1015].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,1, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,0,1, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/amenbreak.wav'),
			\legato, 1,
			\st, 137/2/60,
			\speed, 0.9 * ~t / Pkey(\st),
			\pos, Pseq([
				//[0,1,2,3]/8+1,

				Pseq([
					(0..7)/8+1,
					[0,0,0,0, 1,3,6,10]/8+1,
				].flat,2),
					(0..7)/8+1,
					(0..7)/8+1,
				////[0,2,3,0, 2,3,14,15]/8+1,
				//[0,3,2,0, 1,3,6,10]/8+1,
				//[3,10,11,12, 8,9,10,11]/8+1,
				//(0..7)/8+3,

				//(0..7)/8+2,
				//[0,2,3,0, 2,3,0,2+8]/8+1,
				//[0,3,3,4, 8,12,0,2+8]/8+1,
				//(0..3)/8+1.25,
			].flat,inf) / Pkey(\st) + 0.01,
			\dur, 1/8,
			\isRest, Pseq([
			   	0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,1,
			   	1,1,0,1, 0,1,0,0,
				0,0,0,0, 0,0,1,1,

			   	0,0,0,0, 0,0,1,0,
				0,1,1,0, 1,1,0,0,
			   	1,1,0,0, 1,1,0,0,
				0,0,1,1, 1,1,0,0,
			],inf).coin.not,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \slurpzig,
			\freq, 1200,
			\dur, 2,
			\isRest, Pseq([
				0,0,0,1,
			],inf).coin.not,
			\amp, 0.1/3,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 4,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1281].value,
			\bufnum, ~buflib.kick[1015].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \slurpzig,
			\freq, 1200,
			\dur, 2,
			\isRest, Pseq([
				0,0,0,1,
			],inf).coin.not,
			\amp, 0.1/3,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 4,
			\gain, 0.1,
		),
		
	])
)).play;
);


(
SynthDef(\bluarg, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	freq= 1000;
	lfo1 = XLine.kr(0.1,1,1);
	lfo2 = EnvGen.kr(Env([4,0.1,1],[0.01,0.8]), 1);
	sig = SinOsc.ar(freq * lfo2 * ( SinOsc.ar(423 * lfo2) * 0.51 + 1 ) * ( SinOsc.kr(3 * ( SinOsc.kr(1) * 1 + 1 )) * 1 + 1 ));
	sig = sig + WhiteNoise.ar( EnvGen.kr(Env([0,1,0.1,0.1],[0.01,0.08,0.08]), 1) );
	sig = RLPF.ar(sig, \lpf.kr(1000) * lfo2, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);

(
SynthDef(\fmcpxbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	//freq= 400;
	lfo1 = EnvGen.kr(Env([100,0.1,0],[0.01,0.8]), 1);
	lfo1 = Pulse.ar(freq*2) * freq;
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq * ( SinOsc.ar(freq) * 0.1 + 1 )) * lfo1 + 1 ));
	sig1 = SinOsc.ar(freq);
	lfo2 = XLine.kr(0.1,1,1);
	//sig = HPF.ar(sig,1000);
	sig = SelectX.ar(lfo2, [sig1, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);

(
SynthDef(\fmcpxbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	//freq= 400;
	lfo1 = EnvGen.kr(Env([100,0.1,0],[0.01,0.8]), 1);
	lfo1 = Pulse.ar(10 * XLine.kr(1,0.1,1)) * 44;
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq * ( SinOsc.ar(freq/2) * 0.0 + 1 )) * lfo1 + 1 ));
	sig1 = SinOsc.ar(freq * ( SinOsc.ar(freq) * 1 + 1 ));
	lfo2 = XLine.kr(0.1,1,1);
	//sig = HPF.ar(sig,1000);
	//sig = SelectX.ar(lfo2, [sig1, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fmcpxbass,
			\note, Pseq([
				0,4,3,-3,
			],inf),
			\octave, 5,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

///////


(
SynthDef(\peigne, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	//freq= 400;
	lfo1 = EnvGen.kr(Env([100,0.1,0],[0.01,0.8]), 1);
	lfo1 = Pulse.ar(10 * XLine.kr(1,0.1,1)) * 44;
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq * ( SinOsc.ar(freq/2) * 0.0 + 1 )) * lfo1 + 1 ));
	sig1 = SinOsc.ar(freq * ( SinOsc.ar(freq) * 1 + 1 ));
	lfo2 = XLine.kr(0.1,1,1);
	//sig = HPF.ar(sig,1000);
	//sig = SelectX.ar(lfo2, [sig1, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 4,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1281].value,
			\bufnum, ~buflib.kick[1015].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \slurpzig,
			\freq, 1200,
			\dur, 2,
			\isRest, Pseq([
				0,0,0,1,
			],inf).coin.not,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \peigne,
			\freq, Pstep(Pseq([200,400]),8),
			\dur, 1/3,
			\legato, Pseq([
				1,1,1,
				1,1,1,
				1,1,1,
				0,0,0,
				1,1,1,
				1,1,2,
				0,0,0,
				0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1/3,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 4,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1281].value,
			\bufnum, ~buflib.kick[1015].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \slurpzig,
			\freq, 1200,
			\dur, 2,
			\isRest, Pseq([
				0,0,0,1,
			],inf).coin.not,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \peigne,
			\freq, Pstep(Pseq([200,400]),8),
			\dur, 1/8,
			\legato, Pseq([
				3,0,0,3, 0,0,2,0, 
				0,0,0,0, 2,0,2,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1/3,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 4,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1281].value,
			\bufnum, ~buflib.kick[1015].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		
	])
)).play;
);
(
Pdef(\part, Pdef(\drums2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 1,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1281].value,
			\bufnum, ~buflib.kick[1015].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\isRest, true,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 4,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1281].value,
			\bufnum, ~buflib.kick[1015].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \slurpzig,
			\freq, 1200,
			\dur, 2,
			\isRest, Pseq([
				0,0,0,1,
			],inf).coin.not,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \peigne,
			\freq, Pstep(Pseq([200,400]),8),
			\dur, PdurStutter(Pseq([3!3,Rest(3)!3, 3,8,Rest(3)!6].flat,inf), 1),
			\legato, Pseq([
				1
			],inf)*0.9,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1/3,
		),
		Pmono(\rise1,
			\freq, 2000,
			\dur, 1,
			\len, 6,
			\amp, 0.1,
		).keep(8).loop,
	])
)).play;
);

(
SynthDef(\rise1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, len=6;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	//freq= 400;
	lfo1 = EnvGen.kr(Env([100,0.1,0],[0.01,0.8]), 1);
	lfo1 = SinOsc.ar(freq/2) * XLine.kr(1,30,len/~t);
	lfo3 = XLine.kr(1,33,len/~t);
	lfo4 = XLine.kr(1,3,len/~t);
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq * ( SinOsc.ar(freq/2) * lfo3 + 1 )) * lfo1 + 1 ));
	sig1 = SinOsc.ar(freq*2 * ( SinOsc.ar(freq) * lfo3 + 1 ));
	sig = sig + sig1;
	sig = DelayL.ar(sig, \maxdelay.kr(0.4), \delay.kr(0.001) * lfo3 * [1,1.01]) + sig;
	sig = DelayL.ar(sig, \maxdelay.kr(0.4), 0.01 * lfo4) + sig;
	lfo2 = XLine.kr(0.1,1,1);
	sig = sig * 0.3;
	sig = sig* EnvGen.kr(Env([0.1,1,0],[len/~t,0.1],2), 1);
	//sig = HPF.ar(sig,1000);
	//sig = SelectX.ar(lfo2, [sig1, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 4,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1281].value,
			\bufnum, ~buflib.kick[1015].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \slurpzig,
			\freq, 1200,
			\dur, 2,
			\isRest, Pseq([
				0,0,0,0,
				0,0,0,1,
			],inf).coin.not,
			\amp, 0.1/3,
		),
		Plazy({ arg ev;
			var pat = Pmono(\rise1,
				\freq, 2000,
				\dur, 1/4,
				\len, 6,
				\amp, 0.1,
			);
			Pseq([
				pat.keep(4*4),
				pat.keep(6),
				pat.keep(4),
				pat.keep(4),
				pat.keep(4),
			],inf);
			
		}).loop,
	])
)).play;
);

ClipTimeline(\smp).edit
ClipTimeline(\smpscore).edit

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pmono(\rise1,
			\freq, 2000,
			\dur, 1,
			\len, 6,
			\amp, 0.1,
		).keep(8).loop,
	])
)).play;
);
16/3
2**(1..6)/3

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\drums1),
		Pseq([
			//Pmono(\rise1,
				//\freq, 2000,
				//\dur, 1,
				//\len, 6,
				//\amp, 0.1,
			//).keep(8),
			Pmono(\rise1,
				\freq, 2000,
				\dur, 8/6,
				\len, 6,
				\amp, 0.1,
			).keep(1),
			Pmono(\rise1,
				\freq, 2000,
				\dur, 8/6/2,
				\len, 6,
				\amp, 0.1,
			).keep(1).repeat(4),
			//Rest(4 - (8/6) - (8/6/2 * 3))
		],inf),
	])
)).play;
);
8 - (8/6) - (8/6/2 * 3)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\drums1),
		Pbind(
			\instrument, \rise1,
			\freq, 2000,
			\legato, 1,
			\dur, Pseq([ 8, 4!4 ].flat/6, inf),
			\amp, 0.1,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\drums1),
		Pbind(
			\instrument, \rise1,
			\freq, 2000,
			\legato, 1,
			\dur, Pseq([ 8, 4,4,6,2 ].flat/6, inf),
			\amp, 0.1,
		),
	])
)).play;
);

//////////////



(
SynthDef(\beeptrembl, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		//Pdef(\drums1),
		Pbind(
			\instrument, \kick808,
			\amp, 0.1,
			\dist, 4,
		),
		Pbind(
			\instrument, \beeptrembl,
			\note, 7,
			\dur, 1,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		
	])
)).play;
);


/////////////////


(
SynthDef(\sdkick808, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1, gate=1|
	var env0, env1, env1m;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	//freqpan = [-1,0,1] * freqpan;
	env0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.005, 0.16, 00.2], [-4, -2, -4], releaseNode:2));
	env1 = \env1.kr(Env.new([210, 62, 59], [0.045, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, gate:gate, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	
	sig = LFPulse.ar(env1 * freqpan, 0, 0.5, 1, -0.5);
	sig = sig + WhiteNoise.ar(1);
	sig = LPF.ar(sig, env1*fratio);
	sig = sig + SinOsc.ar(env1, 0.5);
	sig = LPF.ar(sig, \lpf.kr(2000));
	
	sig1 = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = SelectX.ar(\distmix.kr(0.5), [sig, sig1]);

	sig = sig * env0;
	sig = Pan2.ar(sig, pan, amp);
	
	OffsetOut.ar(out, sig);
}, metadata:(specs:(
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick808,
			\env0, [ Env.new([0, 1, 0.8, 0], [0.005, 0.16, 00.2], [-4, -2, -4], 2) ],
			\dur, 1/8,
			\legato, 8,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
		),
		Pdef(\drums1),
	])
)).play;
);

(
SynthDef(\glitch1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	freq = freq * XLine.kr(1,0.4,10);
	sig = LFSaw.ar(freq * Rand(1,1.01!4) * ( SinOsc.ar( freq * Rand(1,1.01!4) ) * 1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\glitch2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, fac1=1, len=1;
	var sig;
	freq = freq * SinOsc.ar(1*fac1, mul: XLine.kr(1,0.4,len));
	sig = LFSaw.ar(freq * Rand(1,1.01!4) * ( SinOsc.ar( freq * Rand(1,1.01!4) * ( SinOsc.kr(1) * 100 + 1 ) ) * 1 + 1 ));
	sig = RLPF.ar(sig, \lpf.kr(10000) * XLine.kr(1,0.1,len), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \glitch2,
			\note, Pseq([
				0,0,-1,-1,
			],inf).stutter(16),
			\octave, 8,
			\fac1, PmodEnv(Pseq([1,10],1), 4).loop,
			[\legato, \dur], Pseq([
				Ptuple([ 
					Pser([
						1,
					],6),
					1/3
				]),
				Ptuple([ 
					Pser([
						1
					],1),
					2
				]),
				Ptuple([ 
					Pser([
						2,0,1,
					],6),
					1/3
				]),
				Ptuple([ 
					Pser([
						1
					],1),
					2
				]),
			],inf),
			\len, Pkey(\legato) * Pkey(\dur) / ~t,
			\len, 4,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \glitch1,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				Pser([
					0
				],8*2*3),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \sdkick808,
			\env0, [ Env.new([0, 1, 0.8, 0], [0.005, 0.16, 00.2], [-4, -2, -4], 2) ],
			\dur, 1/8,
			\legato, 8,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\isRest, true,
		),
		Pdef(\drums1),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \glitch2,
			\note, Pseq([
				0,0,-1,-1,
			],inf).stutter(16),
			\octave, 4,
			\fac1, PmodEnv(Pseq([1,10],1), 4).loop,
			\dur, 1/8,
			\legato, Pseq([
				0,0,2,0, 0,0,2,0,
				4,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\len, Pkey(\legato) * Pkey(\dur) / ~t,
			\len, 4,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \glitch1,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				Pser([
					0
				],8*2*3),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \sdkick808,
			\env0, [ Env.new([0, 1, 0.8, 0], [0.005, 0.16, 00.2], [-4, -2, -4], 2) ],
			\dur, 1/8,
			\legato, 8,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\isRest, true,
		),
		Pdef(\drums1),
	])
)).play;
);


//////////////////



(
Pdef(\part, Pdef(\fill1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 4,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/amenbreak.wav'),
			\legato, 1,
			\st, 137/2/60,
			\speed, 0.9 * ~t / Pkey(\st),
			\pos, Pseq([
				[9,4,5,3]/8+0,

				//(0..7)/8+1,
				////[0,2,3,0, 2,3,14,15]/8+1,
				//[0,3,2,0, 1,3,6,10]/8+1,
				//[3,10,11,12, 8,9,10,11]/8+1,
				//(0..7)/8+3,

				//(0..7)/8+2,
				//[0,2,3,0, 2,3,0,2+8]/8+1,
				//[0,3,3,4, 8,12,0,2+8]/8+1,
				//(0..3)/8+1.25,
			].flat,inf) / Pkey(\st) + 0.01,
			\dur, 1/8,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\gain, 1/8,
		)
		
	])
)).play;
);


(
Pdef(\part, Pdef(\fill2, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 4,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1281].value,
			\bufnum, ~buflib.kick[1015].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \slurpzig,
			\freq, 1200,
			\dur, 2,
			\isRest, Pseq([
				0,0,0,0,
				0,0,0,1,
			],inf).coin.not,
			\amp, 0.1/3,
		),
		Plazy({ arg ev;
			var pat = Pmono(\rise1,
				\freq, 2000,
				\dur, 1/4,
				\len, 6,
				\amp, 0.1,
			);
			Pseq([
				pat.keep(4*4),
				pat.keep(6),
				pat.keep(4),
				pat.keep(4),
				pat.keep(4),
			],inf);
			
		}).loop,
	])
)).play;
);

(
Pdef(\part, Pfindur(2,Pdef(\fill3, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				-5,-6,-1,
			],inf),
			\octave, 3,
			\dur, 1/2 * Pseq([Pn(1,2),Rest(1),Pn(1/4,8)]),
			\amp, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,1,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	])
))).play;
);

(
Pdef(\part, Pdef(\fill4, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 4,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,0,0,
				1,0,1,0, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/amenbreak.wav'),
			\legato, 1,
			\st, 137/2/60,
			\speed, 0.9 * ~t / Pkey(\st),
			\pos, Pseq([
				[3,0,2,1]/8+2,
				[4,6,2,1]/8+2,

				//(0..7)/8+1,
				////[0,2,3,0, 2,3,14,15]/8+1,
				//[0,3,2,0, 1,3,6,10]/8+1,
				//[3,10,11,12, 8,9,10,11]/8+1,
				//(0..7)/8+3,

				//(0..7)/8+2,
				//[0,2,3,0, 2,3,0,2+8]/8+1,
				//[0,3,3,4, 8,12,0,2+8]/8+1,
				//(0..3)/8+1.25,
			].flat,inf) / Pkey(\st) + 0.01,
			\dur, 1/8,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\gain, 1/8,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pfindur(2*3,Pdef(\drums1)),
			Pfindur(2, Pdef(\fill4)),
			Pfindur(2*3,Pdef(\drums1)),
			Pfindur(2, Pdef(\fill2)),
		],3),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\drums1),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,-1,-4,
			],inf).stutter(8*2) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,4,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,-4,
			],inf),
			\octave, 3,
			\freq, PmodEnv(Pseq([60,40,12],1), 1).loop,
			\envamt, PmodEnv(Pseq([0.5,1,9],1), 8*2).loop,
			\dur, 1/4,
			\legato, 2,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.1,1,3)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/amenbreak.wav'),
			\legato, 1,
			\st, 137/2/60,
			\speed, 0.9 * Pseg(Pseq([1/2,1.1],inf),8) * ~t / Pkey(\st),
			\pos, Pseq([
				4.7/8,
				3/8,

				//(0..7)/8+1,
				////[0,2,3,0, 2,3,14,15]/8+1,
				//[0,3,2,0, 1,3,6,10]/8+1,
				//[3,10,11,12, 8,9,10,11]/8+1,
				//(0..7)/8+3,

				//(0..7)/8+2,
				//[0,2,3,0, 2,3,0,2+8]/8+1,
				//[0,3,3,4, 8,12,0,2+8]/8+1,
				//(0..3)/8+1.25,
			].flat,inf) / Pkey(\st) + 0.01,
			\dur, 1/16,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0, 
				0,0,0,0, 0,0,0,0,

				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0, 
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\gain, 1/8,
		)
	])
)).play;
);


(
SynthDef(\glitch3, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = XLine.kr(1,0.1,4);
	freq = freq * ( SinOsc.kr(8*~t * lfo1) * 1 + 1 ) * lfo1;
	sig = SinOsc.ar(freq * ( LFTri.ar(freq * ((0..3)/3 - 0.5 * \fspread.kr(0.02) + 1)) * 1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \glitch3,
			\freq, [123,423,545],
			\dur, 2,
			\legato, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\glitch4, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = XLine.kr(1,0.1,4);
	lfo2 = XLine.kr(1,1.1,4);
	freq = freq * ( SinOsc.kr(8*~t * lfo1) * 1 + 1 ) * lfo2;
	sig = SinOsc.ar(freq * ( LFTri.ar(freq * ((0..3)/3 - 0.5 * \fspread.kr(0.02) + 1)) * 1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \glitch4,
			\freq, [83,93,75],
			\dur, 2,
			\legato, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\glitch5, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = XLine.kr(8,8.1,4);
	lfo2 = XLine.kr(1,1.1,4);
	freq = freq * ( SinOsc.kr(8*~t * lfo1) * 1 + 1 ) * lfo2;
	sig = SinOsc.ar(freq * ( LFTri.ar(freq * ((0..3)/3 - 0.5 * \fspread.kr(0.02) + 1)) * 1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pbind(
			\instrument, \glitch5,
			\freq, [83,93,75]*Pstep(Pseq([1,1.5],inf),8),
			\dur, 2,
			\isRest, Pseq([
				1,1,1,0,
			],inf).coin.not,
			\legato, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, Pstep(Pseq([\glitch1,\glitch2,\glitch3,\glitch4],inf),8),
			\freq, [83,93,75],
			\dur, 2,
			\isRest, Pseq([
				0,0,0,1,
			],inf).coin.not,
			\legato, 1,
			\amp, 0.1,
		),
	])
)).play;
);


(
SynthDef(\glitch6, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	lfo1 = XLine.kr(1,8.1,4);
	lfo2 = XLine.kr(1,1.01,4);
	lfo3 = XLine.kr(0.1,1.01,4/~t);
	freq = freq * ( SinOsc.ar(freq*2+0.001*~t * lfo1) * lfo3 + 1 ) * lfo2;
	sig = LFSaw.ar(freq * ( SinOsc.ar(freq*2 * ((0..3)/3 - 0.5 * \fspread.kr(1.2) + 1) * ( SinOsc.ar(freq/2) * lfo3 + 1 )) * lfo3 + 1 ));
	sig = RLPF.ar(sig, ( \lpfr.kr(4.1) * env1 * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \glitch6,
			\freq, [83,93,75]*4,
			\dur, 2,
			\legato, 1,
			\amp, 0.1/3,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pbind(
			\instrument, \glitch6,
			//\freq, [83,93,75]*4,
			\note, Pseq([
				[0,4,7,9],
				[-1,4,7,6],
			],inf),
			\dur, 2,
			\legato, 1,
			\amp, 0.1/3,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\out, BusDef(\comp1side, \audio)) <>
		Pdef(\drums1),
		Pbind(
			\instrument, \glitch6,
			\freq, [83,93,75]* Pstep(Pseq([3,4],inf),8),
			\fspread, 0.01,
			\dur, 2,
			\legato, 1,
			\amp, 0.1/3,
			\out, BusDef(\comp1, \audio,2),
		),
		Pmono(\fx_sidechain,
			\pregain, 1.0,
			\cpt, 0.0099999997764826,
			\cpbelow, 1.0,
			\cpabove, 0.0089999996125698,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\mix, 1.0,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\sidegain, 1.0,
			\inbus, BusDef(\comp1, \audio),
			\sideinbus, BusDef(\comp1side, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),

		
	])
)).play;
);


////

(
SynthDef(\woble1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var wsig;
	freq = freq * LFNoise1.kr(1/2!4,mul:0.01,add:1);
	wsig = ( SinOsc.ar(\wfreq.kr(1/~t)) * \wamp.kr(1) + 1 );
	sig = SinOsc.ar(freq * wsig + ( LFTri.ar(freq*2) * 800 + 200 ));
	sig1 = Ringz.ar(sig, freq * \bpfr.kr(1) * wsig, 4.4,mul:1.01) + sig;
	sig1 = Compander.ar(sig1, sig1, \cpt.kr(1), \cpbelow.kr(1.001), \cpabove.kr(0.009), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig1 = sig1 * 2;
	sig = SelectX.ar(\mix.kr(0.51), [sig, sig1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pbind(
			\instrument, \woble1,
			\note, Pseq([
				0,0,12,
				0,0,12,
				0,12,
			],inf),
			\octave, 3,
			\wfreq, 1/2*~t,
			\bpfr, PmodEnv(Pseq(1/[1,2,1,4],1), 8).loop,
			\wfreq, PmodEnv(Pseq([1/8,8]*~t,1), 8*2).loop,
			\wamp, 0.5,
			\dur, Pseq([
				1/3!(3*3),
				1/8!(8*1),
			].flat,inf),
			\amp, 0.07,
		),
	])
)).play;
);

(
SynthDef(\woble2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var wsig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo2 = XLine.kr(0.21,0.001,3);
	lfo1 = LFNoise1.ar(1/40!4) * lfo2 + 1;

	sig = LFSaw.ar(freq * lfo1, Rand(0!4,1.2));


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pbind(
			\instrument, \woble2,
			\note, Pseq([
				0,0,12,
				0,0,12,
				0,12,
			],inf),
			\octave, 3,
			\wfreq, 1/2*~t,
			\bpfr, PmodEnv(Pseq(1/[1,2,1,4],1), 8).loop,
			\wfreq, PmodEnv(Pseq([1/8,8]*~t,1), 8*2).loop,
			\wamp, 0.5,
			\dur, Pseq([
				4,
			].flat,inf),
			\amp, 0.07,
		),
	])
)).play;
);

(
SynthDef(\woble3, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var wsig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var len=2;
	lfo2 = XLine.kr(0.1,0.001,len);
	lfo1 = LFNoise1.ar(1/40!4) * lfo2 + 1;

	env1 = EnvGen.kr(\env1.kr(Env.adsr(0.1,2.0,0.1,0.1)), gate, doneAction:0) * 4;
	env2 = EnvGen.kr(\env2.kr(Env.adsr(0.1,2.0,0.01,0.1)), gate, doneAction:0) * 2;
	sig = LFSaw.ar(freq * lfo1 * ( SinOsc.ar(freq*2) * env1 + 1 ), Rand(0!4,0.01));
	sig2 = LFTri.ar(freq*4 * ( SinOsc.ar(freq/2) * env2 + 1 ));
	sig = SelectX.ar(\mix.kr(0.5), [sig, sig2]);


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pbind(
			\instrument, \woble3,
			\note, Pseq([
				0,0,12,
				0,0,12,
				0,12,
			],inf),
			\mix, PmodEnv(Pseq([0,1,0],1), 19).loop,
			\octave, 3,
			\wfreq, 1/2*~t,
			\bpfr, PmodEnv(Pseq(1/[1,2,1,4],1), 8).loop,
			\wfreq, PmodEnv(Pseq([1/8,8]*~t,1), 8*2).loop,
			\wamp, 0.5,
			\dur, Pseq([
				4,
			].flat,inf),
			\amp, 0.07,
		),
	])
)).play;
);

(
SynthDef(\woble4, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var wsig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var len=2;
	lfo2 = XLine.kr(0.1,0.001,len);
	lfo1 = LFNoise1.ar(1/40!4) * lfo2 + 1;
	wsig = ( SinOsc.ar(\wfreq.kr(1/~t)) * \wamp.kr(1) + 1 );
	freq = freq * wsig;

	env1 = EnvGen.kr(\env1.kr(Env.adsr(0.1,2.0,0.1,0.1)), gate, doneAction:0) * 4;
	env2 = EnvGen.kr(\env2.kr(Env.adsr(0.1,2.0,0.01,0.1)), gate, doneAction:0) * 2;
	sig = LFSaw.ar(freq * lfo1 * ( SinOsc.ar(freq*2) * env1 + 1 ), Rand(0!4,0.01));
	sig2 = LFTri.ar(freq*4 * ( SinOsc.ar(freq/2) * env2 + 1 ));
	sig = SelectX.ar(\mix.kr(0.5), [sig, sig2]);


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pbind(
			\instrument, \woble4,
			\note, Pseq([
				0,0,12,
				0,0,12,
				0,12,
			],inf),
			\mix, PmodEnv(Pseq([0,1,0],1), 19).loop,
			\octave, 3,
			\wfreq, 1/2*~t,
			\bpfr, PmodEnv(Pseq(1/[1,2,1,4],1), 8).loop,
			\wfreq, Pseg(Pseq([4/3!1,3!1].flat*~t,inf),8),
			\legato, Pseq([
				Pn(1,3),
				Pn(0.5,1),
			],inf),
			\wamp, 0.5,
			\dur, Pseq([
				4,
			].flat,inf),
			\amp, 0.07,
		),
	])
)).play;
);



(
SynthDef(\worise1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	freq = freq * XLine.kr(1,2,3);
	sig = LFSaw.ar(freq * LFNoise1.kr(1,mul:1,add:1) * ( SinOsc.ar(freq) * SinOsc.ar(3!4) * 3 + 1 ));
	sig = HPF.ar(sig, XLine.kr(1000,10000,2/~t));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pfindur(2*3,Pdef(\drums1)),
			Pfindur(2, Pdef(\fill2)),
			Pfindur(2*3,Pdef(\drums1)),
			Pfindur(2, Pdef(\fill4)),
			Pfindur(2*3,Pdef(\drums1)),
			Pfindur(2, Pdef(\fill1)),
			Pfindur(2*3,Pdef(\drums1)),
			Pfindur(2, Pdef(\fill3)),
		],3),
		Pbind(
			\instrument, \worise1,
			\note, Pseq([
				0,
			],inf),
			\octave, 6,
			\dur, 2,
			\legato, 1,
			\isRest, Pseq([
				0,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \woble4,
			\note, Pseq([
				0,0,12,
				0,0,12,
				0,12,
			],inf),
			\mix, PmodEnv(Pseq([0,1,0],1), 19).loop,
			\octave, 3,
			\wfreq, 1/2*~t,
			\bpfr, PmodEnv(Pseq(1/[1,2,1,4],1), 8).loop,
			\wfreq, Pseg(Pseq([4/3!1,3!1].flat*~t,inf),8),
			\legato, Pseq([
				Pn(1,3),
				Pn(0.5,1),
			],inf),
			\wamp, 0.5,
			\dur, Pseq([
				4,
			].flat,inf),
			\amp, 0.07,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pfindur(2*3,Pdef(\drums1)),
			Pfindur(2, Pdef(\fill2)),
		],inf),
		Pbind(
			\instrument, \woble3,
			\note, Pseq([
				0,
			],inf),
			\mix, PmodEnv(Pseq([0,1,0],1), 19).loop,
			\octave, 3,
			\wfreq, 1/2*~t,
			\bpfr, PmodEnv(Pseq(1/[1,2,1,4],1), 8).loop,
			\wfreq, PmodEnv(Pseq([1/8,8]*~t,1), 8*2).loop,
			\wamp, 0.5,
			\legato, Pseq([
				2,0,2,0, 2,0,2,0,
				0,0,0,0, 2,0,1,1,
				2,0,0,0, 0,1,2,0,
				0,0,0,1, 2,0,2,0,
				2,0,2,0, 2,0,2,0,
				0,0,0,0, 2,0,1,1,
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pseq([
				1/8,
			].flat,inf),
			\amp, 0.07,
		),
		Pbind(
			\instrument, \woble3,
			\note, Pseq([
				0,
			],inf),
			\mix, PmodEnv(Pseq([0,1,0],1), 19).loop,
			\octave, 5,
			\wfreq, 1/2*~t,
			\bpfr, PmodEnv(Pseq(1/[1,2,1,4],1), 8).loop,
			\wfreq, PmodEnv(Pseq([1/8,8]*~t,1), 8*2).loop,
			\wamp, 0.5,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,1,1, 2,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				2,0,1,1, 4,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pseq([
				1/8,
			].flat,inf),
			\amp, 0.05,
		),
	])
)).play;
);

///// rdn

//ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-EOHQ-U4E4", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.7436974789916,
	'gain', 0.42857142857143,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 5.4890324509216,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);
//ProtoDef(\rdn2).presetCompileString.editorInsert
(
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-FFTD-CTBS", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.77791010151461,
	'gain', 0.29831932773109,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 4.6117477677083,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pfindur(2*3,Pdef(\drums1)),
			Pfindur(2, Pdef(\fill2)),
		],inf),
		Pbind(
			\instrument, \woble1,
			\note, Pseq([
				0,
			],inf),
			\mix, PmodEnv(Pseq([0,1,0],1), 19).loop,
			\octave, 3,
			\wfreq, 1/2*~t,
			\bpfr, PmodEnv(Pseq(1/[1,2,1,4],1), 8).loop,
			\wfreq, PmodEnv(Pseq([1/8,8]*~t,1), 8*2).loop,
			\wamp, 0.5,
			\legato, Pseq([
				2,0,2,0, 2,0,2,0,
				0,0,0,0, 2,0,1,1,
				2,0,0,0, 0,1,2,0,
				0,0,0,1, 2,0,2,0,
				2,0,2,0, 2,0,2,0,
				0,0,0,0, 2,0,1,1,
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pseq([
				1/8,
			].flat,inf),
			\amp, 0.07,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \woble3,
			\note, Pseq([
				0,
			],inf),
			\mix, PmodEnv(Pseq([0,1,0],1), 19).loop,
			\octave, 5,
			\wfreq, 1/2*~t,
			\bpfr, PmodEnv(Pseq(1/[1,2,1,4],1), 8).loop,
			\wfreq, PmodEnv(Pseq([1/8,8]*~t,1), 8*2).loop,
			\wamp, 0.5,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,1,1, 2,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				2,0,1,1, 4,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pseq([
				1/8,
			].flat,inf),
			\amp, 0.05,
			\lag, -0.04,
			\out, BusDef(\sendbus2, \audio),
		),
	])
)).play;
);

(
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pfindur(2*3,Pdef(\drums1)),
			Pfindur(2, Pdef(\fill2)),
		],inf),
		Pbind(
			\instrument, \woble1,
			\note, Pseq([
				-8,-5,
			],inf).stutter(32),
			//\mix, PmodEnv(Pseq([0,1,0],1), 19).loop,
			\mix, 0.9,
			\octave, 3,
			//\wfreq, 1/2*~t,
			//\bpfr, PmodEnv(Pseq(1/[1,2,1,4],1), 8).loop,
			\bpfr, 4,
			\wfreq, Pkey(\freq),
			\wamp, 0.5,
			\legato, Pseq([
				8*3,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pseq([
				1/8,
			].flat,inf),
			\amp, 0.07,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \woble3,
			\note, Pseq([
				-5,
			],inf),
			\mix, PmodEnv(Pseq([0,1,0],1), 19).loop,
			\octave, 5,
			\wfreq, 1/2*~t,
			\bpfr, PmodEnv(Pseq(1/[1,2,1,4],1), 8).loop,
			\wfreq, PmodEnv(Pseq([1/8,8]*~t,1), 8*2).loop,
			\wamp, 0.5,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pseq([
				1/8,
			].flat,inf),
			\amp, 0.05,
			\lag, -0.04,
			\out, BusDef(\sendbus2, \audio),
		),
	])
)).play;
);

(
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		//Pseq([
			//Pfindur(2*3,Pdef(\drums1)),
			//Pfindur(2, Pdef(\fill2)),
		//],inf),
		Pseq([
			Pfindur(2*3,Pdef(\drums1)),
			Pfindur(2, Pdef(\fill2)),
			Pfindur(2*3,Pdef(\drums1)),
			Pfindur(2, Pdef(\fill4)),
			Pfindur(2*3,Pdef(\drums1)),
			Pfindur(2, Pdef(\fill1)),
			Pfindur(2*3,Pdef(\drums1)),
			Pfindur(2, Pdef(\fill3)),
		],13),
		Pbind(
			\instrument, Pseq([
				\woble1,
				\woble2,
				\woble3,
				\woble4,
			],inf).stutter(32*4),
			\note, Pseq([
				-8,-5,
			],inf).stutter(32),
			//\mix, PmodEnv(Pseq([0,1,0],1), 19).loop,
			\mix, 0.9,
			\octave, 3,
			//\wfreq, 1/2*~t,
			//\bpfr, PmodEnv(Pseq(1/[1,2,1,4],1), 8).loop,
			\bpfr, 4,
			\wfreq, Pkey(\freq),
			\wamp, 0.5,
			\legato, Pseq([
				8*3,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pseq([
				1/8,
			].flat,inf),
			\amp, 0.07,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \woble3,
			\note, Pseq([
				-5,
			],inf),
			\mix, PmodEnv(Pseq([0,1,0],1), 19).loop,
			\octave, 5,
			\wfreq, 1/2*~t,
			\bpfr, PmodEnv(Pseq(1/[1,2,1,4],1), 8).loop,
			\wfreq, PmodEnv(Pseq([1/8,8]*~t,1), 8*2).loop,
			\wamp, 0.5,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0,


				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,2,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,3,0, 0,3,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pseq([
				1/8,
			].flat,inf),
			\amp, 0.05,
			\lag, -0.04,
			\out, BusDef(\sendbus2, \audio),
		),
	])
)).play;
);

(
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		//Pseq([
			//Pfindur(2*3,Pdef(\drums1)),
			//Pfindur(2, Pdef(\fill2)),
		//],inf),
		Pseq([
			Pfindur(2*3,Pdef(\drums1)),
			Pfindur(2, Pdef(\fill2)),
			Pfindur(2*3,Pdef(\drums1)),
			Pfindur(2, Pdef(\fill4)),
			Pfindur(2*3,Pdef(\drums1)),
			Pfindur(2, Pdef(\fill1)),
			Pfindur(2*3,Pdef(\drums1)),
			Pfindur(2, Pdef(\fill3)),
		],13),
		Pbind(
			\instrument, Pseq([
				\woble1,
				\woble2,
				\woble3,
				\woble4,
			],inf).stutter(32*4),
			\note, Pseq([
				-8,-5,
			],inf).stutter(32),
			//\mix, PmodEnv(Pseq([0,1,0],1), 19).loop,
			\mix, 0.9,
			\octave, 3,
			//\wfreq, 1/2*~t,
			//\bpfr, PmodEnv(Pseq(1/[1,2,1,4],1), 8).loop,
			\bpfr, 4,
			\wfreq, Pkey(\freq),
			\wamp, 0.5,
			\legato, Pseq([
				8*3,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				Prand([
					Pseq([
						8*3,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],1),

					Pseq([
						5,0,0,0, 0,0,5,0,
						0,0,0,0, 12,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],1),
					
					Pseq([
						8*3,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],1),
					
					Pseq([
						2,0,2,0, 1,1,0,0,
						1,1,1,1, 0,0,0,0,
						0,0,0,0, 4,0,0,0,
						0,0,0,0, 0,0,0,0,
					],1),
				],1),

				//5,0,0,0, 0,0,5,0,
				//0,0,0,0, 12,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//8*3,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pseq([
				1/8,
			].flat,inf),
			\amp, 0.07,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \woble3,
			\note, Pseq([
				-5,
			],inf),
			\mix, PmodEnv(Pseq([0,1,0],1), 19).loop,
			\octave, 5,
			\wfreq, 1/2*~t,
			\bpfr, PmodEnv(Pseq(1/[1,2,1,4],1), 8).loop,
			\wfreq, PmodEnv(Pseq([1/8,8]*~t,1), 8*2).loop,
			\wamp, 0.5,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0,


				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,2,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,3,0, 0,3,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pseq([
				1/8,
			].flat,inf),
			\amp, 0.05,
			\lag, -0.04,
			\out, BusDef(\sendbus2, \audio),
		),
	])
)).play;
);

/////////////////////

(
SynthDef(\wubass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	freq = freq * \fmul.kr(1);
	lfo4 = XLine.kr(1,0.90,2);
	lfo1 = Pulse.kr(\amf.kr(3*~t)).range(0,0.1 * lfo4) + 1;
	lfo3 = XLine.kr(1/10,10,4);
	lfo2 = LFNoise1.kr(1!4) * 0.001 * lfo3 + 1;
	sig = LFSaw.ar(freq * lfo1 * lfo2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\drums2),
		Pbind(
			\instrument, \wubass,
			\note, Pseq([
				Pstep(
					Pseq([
						-4,-4,-4,-6
						-4,-3,-8,-9
					],inf),
				2),
			],inf),
			\fmul, PmodEnv(Pseq([1,1,1,2],1), 1/8).loop,
			\octave, 3,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				4,0,0,0, 4,0,0,0,
				7,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\drums2),
		Pbind(
			\instrument, \wubass,
			\note, Pseq([
				Pstep(
					Pseq([
						-4,-4,-4,-6
						-4,-3,-8,-9
					],inf),
				2),
			],inf),
			\fmul, PmodEnv(Pseq([
				1,1,1,1,1,1,1,2,
				1,1,1,1,1,1/2,1,1,
			],1), 1/8).loop,
			\octave, 3,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				4,0,0,0, 4,0,0,0,
				7,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
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
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 1,
			\gain, 0.1,
			\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1281].value,
			\bufnum, ~buflib.kick[1015].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,1,1,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \wubass,
			\note, Pseq([
				Pstep(
					Pseq([
						-4,-4,-4,-6
						-4,-3,-8,-9
					],inf),
				2),
			],inf),
			\fmul, Pseq([
				PmodEnv(Pseq([
					1,1,1,1,1,1,1,2,
				],1), 1/8),
				PmodEnv(Pseq([
					1,1,1,1,1,1/2,1,1,
				],1), 1/8),
				PmodEnv(Pseq([
					1,1,1,1,2,1,1,1,
				],1), 1/8),
				PmodEnv(Pseq([
					1,1,1,1,1,1/2,1,1,
				],1), 1/8),
			],inf),
			\octave, 3,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				4,0,0,0, 4,0,0,0,
				7,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.04,
			\out, BusDef(\bassbus, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\bassbus, \audio),
			\sideinbus, BusDef(\kickbus,\audio),
			\pregain, 1.0,
			\cpt, 0.0099999997764826,
			\cpbelow, 1.0,
			\cpabove, 0.0089999996125698,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.04000000149012,
			\mix, 1.0,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\sidegain, 1.0,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 1,
			\gain, 0.1,
			\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1281].value,
			\bufnum, ~buflib.kick[1015].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,1,1,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \wubass,
			\note, Pseq([
				Pstep(
					Pseq([
						-4,-4,-4,-6
						-4,-3,-8,-9
					],inf),
				2),
			],inf),
			\fmul, Pseq([
				PmodEnv(Pseq([
					1,1,1,1,1,1,1,2,
				],1), 1/8),
				PmodEnv(Pseq([
					1,1,1,1,1,1/2,1,1,
				],1), 1/8),
				PmodEnv(Pseq([
					1,1,1,1,2,1,1,1,
				],1), 1/8),
				PmodEnv(Pseq([
					1,1,1,1,1,1/2,1,1,
				],1), 1/8),
			],inf),
			\octave, 3,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				4,0,0,0, 4,0,0,0,
				7,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.04,
			\out, BusDef(\bassbus, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\bassbus, \audio),
			\sideinbus, BusDef(\kickbus,\audio),
			\pregain, 1.0,
			\cpt, 0.0099999997764826,
			\cpbelow, 1.0,
			\cpabove, 0.0089999996125698,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.04000000149012,
			\mix, 1.0,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\sidegain, 1.0,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \wubass,
			\note, Pseq([
				0,1,4,-1
				-2,1,4,-1
			],inf).stutter(4),
			\octave, 5,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				6,0,0,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.041,
			\isRest, true,
		),
	])
)).play;
);


///////////////


// make drum rythm, then change drum by strange sound
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,1,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1 * 0.8,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],3),

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 2,
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\legato, 0.51,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.2) ],
			],inf),
			\gain, 0.09* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
	])
)).play;
);

(
SynthDef(\wubass2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	freq = freq * \fmul.kr(1);
	lfo4 = XLine.kr(1,0.90,2);
	lfo1 = Pulse.kr(\amf.kr(3*~t)).range(0,1).lag(0.01);
	lfo3 = XLine.kr(1/10,10,4);
	lfo2 = LFNoise1.kr(1!4) * \fspread.kr(0.001) * lfo3 + 1;
	sig = LFSaw.ar(freq  * lfo2)* lfo1;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,1,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1 * 0.8,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],3),

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 2,
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\legato, 0.51,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.2) ],
			],inf),
			\gain, 0.09* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \wubass2,
			\note, Pseq([
				0,-12,12,
			],inf).stutter(4),
			\octave, 3,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				6,0,0,0, 0,0,2,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\amf, Pseq([
				1,2,4,
			],inf)*~t,
			\fspread, Pseq([
				1,0.1,0.000001,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.041,
		),
	])
)).play;
);

(
SynthDef(\wubass3, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	freq = freq * \fmul.kr(1);
	lfo4 = XLine.kr(1,0.90,2);
	lfo1 = Pulse.kr(\amf.kr(3*~t)).range(0,1).lag(0.01);
	lfo3 = XLine.kr(1/10,10,4);
	lfo2 = LFNoise1.kr(1!4) * \fspread.kr(0.001)  + 1;
	lfo6 = EnvGen.kr(Env([0,1,0],[0.01,0.1]), \xtrig.tr(1));
	lfo7 = EnvGen.kr(Env([0,1,0],[0.05,1.4]), \xtrig.tr(1));
	lfo5 = ( SinOsc.ar(freq* \fmr.kr(1/2)) * \fmamp.kr(7.5) * lfo7 + 1 );
	sig = LFSaw.ar(freq  * lfo2 * lfo5);
	sig = RLPF.ar(sig, \lpf.kr(100) * ( lfo7 * 14 + 1 ), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\waw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	freq = freq * \fmul.kr(1);
	lfo4 = XLine.kr(1,0.90,2);
	lfo1 = Pulse.kr(\amf.kr(3*~t)).range(0,1).lag(0.01);
	lfo3 = XLine.kr(1/10,10,4);
	lfo2 = LFNoise1.kr(1!4) * \fspread.kr(0.001)  + 1;
	lfo6 = EnvGen.kr(Env([0,1,0],[0.01,0.1]), \xtrig.tr(1));
	lfo7 = EnvGen.kr(Env([0,1,0],[0.05,\xtrigrel.kr(1.4)]), \xtrig.tr(1));
	lfo5 = ( SinOsc.ar(freq* \fmr.kr(1/2)) * \fmamp.kr(7.5) * lfo7 + 1 );
	sig = LFSaw.ar(freq  * lfo2 * lfo5);
	sig = RLPF.ar(sig, \lpf.kr(100) * ( lfo7 * \lpma.kr(14) + 1 ), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\wawoct, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	freq = freq * \fmul.kr(1);
	lfo4 = XLine.kr(1,0.90,2);
	lfo1 = Pulse.kr(\amf.kr(3*~t)).range(0,1).lag(0.01);
	lfo3 = XLine.kr(1/10,10,4);
	lfo2 = LFNoise1.kr(1!4) * \fspread.kr(0.001)  + 1;
	lfo6 = EnvGen.kr(Env([0,1,0],[0.01,0.1]), \xtrig.tr(1));
	lfo7 = EnvGen.kr(Env([0,1,0],[0.05,\xtrigrel.kr(1.4)]), \xtrig.tr(1));
	lfo5 = ( ( SinOsc.ar(freq* [1/4,1/2,1,2,3,4]) * \fmoct.kr(0.5!6) * LFNoise1.kr(( 1/4 )!6).range(0,1) ).mean * \fmamp.kr(7.5) * lfo7 + 1 );
	sig = LFSaw.ar(freq  * lfo2 * lfo5);
	sig = RLPF.ar(sig, \lpf.kr(100) * ( lfo7 * \lpma.kr(14) + 1 ), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,1,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1 * 0.8,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],3),

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 2,
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\legato, 0.51,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.2) ],
			],inf),
			\gain, 0.09* Pseq([
				1,Pn(0.8,7)
			],inf),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \wubass2,
			\note, Pseq([
				0,-12,12,
			],inf).stutter(4),
			\octave, 3,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				6,0,0,0, 0,0,2,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\amf, Pseq([
				1,2,4,
			],inf)*~t,
			\fspread, Pseq([
				1,0.1,0.000001,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.041,
		),
		Pmono(
			 \wubass3,
			\note, Pstep(Pseq([
				0,5,4,3,
			],inf),2),
			\xtrig, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 1,0,1,0,
			],inf),
			\dur, Pn(1/16,8*8*8),
			\amp, 0.1/2,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,1,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1 * 0.8,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],3),

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 2,
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\legato, 0.51,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.2) ],
			],inf),
			\gain, 0.09* Pseq([
				1,Pn(0.8,7)
			],inf),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \wubass2,
			\note, Pseq([
				0,-12,12,
			],inf).stutter(4),
			\octave, 3,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				6,0,0,0, 0,0,2,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\amf, Pseq([
				1,2,4,
			],inf)*~t,
			\fspread, Pseq([
				1,0.1,0.000001,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.041,
		),
		Pbind(
			\instrument, \waw,
			\note, Pseq([
				Pseq([
					0,-12,5,
					12,-12,5,
					0,-12,
					-12,0,5,
					12,10,5,
					-12,0,
				],4),

				12,-12,5,
				12,-12,5,
				0,-12,
				-12,0,5,
				-12,0,5,
				-12,0,
				Pser([
					0,0,12,0, 0,0,0,0,
				],8*2),

				0,-12,5,
				0,-12,5,
				-12,-12,
				-12,0,5,
				-12,0,5,
				-12,0,
				Pser([
					0,0,12,0, 0,0,0,0,
				],8*2),
			],inf),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0,
				0,0,0,0, 0,0,0,0,
				3,0,0,3, 0,0,2,0,
				3,0,0,3, 0,0,3,0,
				0,3,0,0, 3,0,0,0,
				0,0,1,1, 1,1,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/3,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,1,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1 * 0.8,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],3),

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 2,
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\legato, 0.51,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.2) ],
			],inf),
			\gain, 0.09* Pseq([
				1,Pn(0.8,7)
			],inf),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \wubass2,
			\note, Pseq([
				0,-12,12,
			],inf).stutter(4),
			\octave, 3,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				6,0,0,0, 0,0,2,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\amf, Pseq([
				1,2,4,
			],inf)*~t,
			\fspread, Pseq([
				1,0.1,0.000001,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.041,
		),
		Pbind(
			\instrument, \waw,
			\note, Pseq([
				[0,4,7],
				[0,7,10],
				[0,5,9],
				[0,5,8],
			],inf).stutter(8*4),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0,
				0,0,0,0, 0,0,0,0,
				3,0,0,3, 0,0,2,0,
				3,0,0,3, 0,0,3,0,
				0,3,0,0, 3,0,0,0,
				0,0,1,1, 1,1,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/3,
			\isRest, true,
		),
		Pbind(
			\instrument, \wawoct,
			\note, Pseq([
				4,
				7,
				5,
				5,
			],inf).stutter(8*4),
			\lpf, 100,
			\lpma, PmodEnv(Pseq([1,34],1), 8*2).loop,
			\fmamp, PmodEnv(Pseq([1,12],1), 8*2).loop,
			//\fmoct, [ [0.51,0,0,0,0,0] ],
			\octave, 6,
			\legato, Pseq([
				0,0,0,0, 0,3,0,0,
				6,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,1,0,
				3,0,0,3, 0,0,1,1,
			],inf)*0.7,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.8) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \waw,
			\note, Pseq([
				[7],
				[10],
				[9],
				[8],
			],inf).stutter(8*4),
			\octave, 5,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0,
				0,0,0,0, 0,0,0,0,
				3,0,0,3, 0,0,2,0,
				3,0,0,3, 0,0,3,0,
				0,3,0,0, 3,0,0,0,
				0,0,1,1, 1,1,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					0,11,
				],8*4),
				Pser([
					0,10,
				],8*4),
				Pser([
					0,5,
				],8*4),
				Pser([
					0,8,
				],8*4),
			],inf),
			\envamt, PmodEnv(Pseq([1,10],1), 8*2).loop,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1,
				],2),

				1,0,0,0, 0,0,0,0,
				0,1,0,1, 0,1,1,1,

				Pseq([
					1,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1,
				],3),

				1,0,0,0, 0,0,1,1,
				1,1,0,0, 1,1,1,1,

				Pseq([
					1,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1,
				],1),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/2,
		),
	])
)).play;
);

//////////////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\drum, Pseq([
				Plazy({ arg ev;
					Pseq([
						0,Pseq({ [0,1].choose }.dup(7)),
						1,Pseq({ [0,1].choose }.dup(7)),
					],8)
				}).loop
			],inf),
			\bufnum, Pkey(\drum).collect { arg idx;
				if(idx > 0) {
					~buflib.snare[1822].value;
				} {
					~buflib.kick[1414].value;
				};
			},
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0.2,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,1,
				],7),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/4,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\drum, Pseq([
				Plazy({ arg ev;
					Pseq([
						0,Pseq({ [0,1].choose }.dup(7)),
						1,Pseq({ [0,1].choose }.dup(7)),
					],8)
				}).loop
			],inf),
			\bufnum, Pkey(\drum).collect { arg idx;
				if(idx > 0) {
					~buflib.snare[1822].value;
				} {
					~buflib.kick[1414].value;
				};
			},
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				Pseq([ 1,0.2, ],4),
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					1,1,
				],7),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.5,0.7,0.3

			],inf),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\drum, Pseq([
				Plazy({ arg ev;
					Pseq([
						0,Pseq({ [0,1].choose }.dup(7)),
						1,Pseq({ [0,1].choose }.dup(7)),
					],8)
				}).loop
			],inf),
			\bufnum, Pkey(\drum).collect { arg idx;
				if(idx > 0) {
					~buflib.snare[1822].value;
				} {
					~buflib.kick[1414].value;
				};
			},
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,Pser([ 0.2,0.5, ],7),
				1,Pser([ 0.2,0.5, ],7),
				//Pser([ 1,0.2, ],8),
				//Pser([ 1,0.2, ],8),
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					1,1,
				],7),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.5,0.7,0.3

			],inf) * Pseq([
				Prand([0,0.5,1],inf)
			],inf),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\drum, Pseq([
				Plazy({ arg ev;
					Pseq([
						0,Pseq({ [0,1].choose }.dup(7)),
						1,Pseq({ [0,1].choose }.dup(7)),
					],8)
				}).loop
			],inf),
			\bufnum, Pkey(\drum).collect { arg idx;
				if(idx > 0) {
					~buflib.snare[1822].value;
				} {
					~buflib.kick[1414].value;
				};
			},
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,Pser([ 0.2,0.5, ],7),
				1,Pser([ 0.2,0.5, ],7),
				//Pser([ 1,0.2, ],8),
				//Pser([ 1,0.2, ],8),
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1 * Pseq([
				2,1,1,1, 1,1,1,1,
			],inf)/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, 
			Plazy({ arg ev;
				var set = [
					1,1,1,1, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,1,1,1, 
					1,1,1,1, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,1,0, 
					0,0,1,0, 0,0,1,0, 
					0,0,0,0, 1,0,0,0, 
				].clump(8);
				Pseq([
					set.choose,
					set.choose,
					set.choose,
					set.choose,
				].flat,4).coin.not
			}).loop,
			\dur, 1/8,
			//\gain, 0.11 * Pseq([
				//1,0.5,0.7,0.3
			//],inf) * Pseq([
				//Prand([0,0.5,1],inf)
			//],inf),
			\gain, 0.11,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\drum, Pseq([
				Plazy({ arg ev;
					Pseq([
						0,Pseq({ [0,1].choose }.dup(7)),
						1,Pseq({ [0,1].choose }.dup(7)),
					],8)
				}).loop
			],inf),
			\bufnum, Pkey(\drum).collect { arg idx;
				if(idx > 0) {
					~buflib.snare[1822].value;
				} {
					~buflib.kick[1414].value;
				};
			},
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,Pser([ 0.2,0.5, ],7),
				1,Pser([ 0.2,0.5, ],7),
				//Pser([ 1,0.2, ],8),
				//Pser([ 1,0.2, ],8),
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1 * Pseq([
				2,1,1,1, 1,1,1,1,
			],inf)/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, 
			Plazy({ arg ev;
				var set = [
					1,1,1,1, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,1,1,1, 
					1,1,1,1, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,1,0, 
					0,0,1,0, 0,0,1,0, 
					0,0,0,0, 1,0,0,0, 
				].clump(8);
				Pseq([
					set.choose,
					set.choose,
					set.choose,
					set.choose,
				].flat,4).coin.not
			}).loop,
			\dur, 1/8,
			//\gain, 0.11 * Pseq([
				//1,0.5,0.7,0.3
			//],inf) * Pseq([
				//Prand([0,0.5,1],inf)
			//],inf),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sdkick808,
			\note, Pseq([
				10,
			],inf),
			\legato, Pseq([
				16,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 3,0,0,0,
				4,0,0,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
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
			\instrument, \playersec,
			\drum, Pseq([
				Plazy({ arg ev;
					Pseq([
						0,Pseq({ [0,1].choose }.dup(7)),
						1,Pseq({ [0,1].choose }.dup(7)),
					],8)
				}).loop
			],inf),
			\bufnum, Pkey(\drum).collect { arg idx;
				if(idx > 0) {
					~buflib.snare[1822].value;
				} {
					~buflib.kick[1414].value;
				};
			},
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,Pser([ 0.2,0.5, ],7),
				1,Pser([ 0.2,0.5, ],7),
				//Pser([ 1,0.2, ],8),
				//Pser([ 1,0.2, ],8),
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1 * Pseq([
				2,1,1,1, 1,1,1,1,
			],inf)/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, 
			Plazy({ arg ev;
				var set = [
					1,1,1,1, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,1,1,1, 
					1,1,1,1, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,1,0, 
					0,0,1,0, 0,0,1,0, 
					0,0,0,0, 1,0,0,0, 
				].clump(8);
				Pseq([
					set.choose,
					set.choose,
					set.choose,
					set.choose,
				].flat,4).coin.not
			}).loop,
			\dur, 1/8,
			//\gain, 0.11 * Pseq([
				//1,0.5,0.7,0.3
			//],inf) * Pseq([
				//Prand([0,0.5,1],inf)
			//],inf),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \wubass2,
			\note, Pseq([
				Pstep(
					Pseq([
						-4,
						-4,
						-4,
						-9
					],inf),
				2),
			],inf),
			\amf, ~t * Pstep(Pseq([
				8,8,
				8,4,3,
				8,8,
				
			],inf),1),
			\fmul, PmodEnv(Pseq([
				1,1,1,1,1,1,1,2,
				1,1,1,1,1,1/2,1,1,
			],1), 1/8).loop,
			\octave, 3,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				4,0,0,0, 4,0,0,0,
				7,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \wubass3,
			\note, Pseq([
				0,-2,
			],inf),
			\rel, 4/~t,
			\octave, 6,
			\dur, 1/8,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				16,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1/2,
		),
	])
)).play;
);


[(1..100),(101..200)].plot
[(1..100),(101..200)].flop.plot
[5, 6, 7, 6.5, 4.5, 3.5].plot("Some data")
{ |i| { |j| j + 1 * (i + 1) % 6 }.dup(100) }.dup(5).plot("Some 2-d data");



//////////////////////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1 * Pseq([
				2,1,1,2,1,1,2,2,
				1,1,2,1,1,2,1,1,
				
			]/2,inf).stutter(2),
		),
		//Pbind(
			//\instrument, \playersec,
			////\bufnum, ~buflib.kick[1281].value,
			//\bufnum, ~buflib.kick[1015].value,
			////\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			//\isRest, Pseq([
				//0,0,0,0, 0,0,0,0,
				//0,0,0,1, 1,0,0,1,
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 1,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
			//],inf).coin.not,
			//\dur, 1/8,
			//\gain, 0.1,
		//),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, ( Pseq([
				1,0,0,1, 0,0,1,0,
				1,0,0,1, 0,0,0,1,
				1,0,1,1, 0,0,1,0,
				1,1,0,1, 0,0,1,0,
			],inf).stutter(2) * Pseq([1,0],inf) ).coin.not,
			\dur, 1/8,
			\legato, [1/2,1],
			\speed, [1.01,1],
			//\lag, Ptuple([0,Pwhite(0.03,0.07,inf)]),
			\lag, Ptuple([0,Pbrown(0.03,0.07,0.002,inf)]),
			//\lag, [0,0.03],
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 1,0,1,0,
				0,1,1,0, 1,1,0,1,
				1,0,1,0, 1,1,0,1,
				1,0,1,0, 1,0,1,1,
				//Pseq([
					//0,0,1,0, 1,0,1,0,
				//],7),
				//0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,1,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,1, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,

				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,1, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				//1,0.7,0.9,0.5,
				//0.1,0.5,0.8,1,
			],inf),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1 * Pseq([
				2,1,1,2,1,1,2,2,
				1,1,2,1,1,2,1,1,
				
			]/2,inf).stutter(2),
		),
		//Pbind(
			//\instrument, \playersec,
			////\bufnum, ~buflib.kick[1281].value,
			//\bufnum, ~buflib.kick[1015].value,
			////\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			//\isRest, Pseq([
				//0,0,0,0, 0,0,0,0,
				//0,0,0,1, 1,0,0,1,
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 1,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
			//],inf).coin.not,
			//\dur, 1/8,
			//\gain, 0.1,
		//),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, ( Pseq([
				1,0,0,1, 0,0,1,0,
				1,0,0,1, 0,0,0,1,
				1,0,1,1, 0,0,1,0,
				1,1,0,1, 0,0,1,0,
			],inf).stutter(2) * Pseq([1,0],inf) ).coin.not,
			\dur, 1/8,
			\legato, [1/2,1],
			\speed, [1.01,1],
			//\lag, Ptuple([0,Pwhite(0.03,0.07,inf)]),
			\lag, Ptuple([0,Pbrown(0.03,0.07,0.002,inf)]),
			//\lag, [0,0.03],
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 1,0,1,0,
				0,1,1,0, 1,1,0,1,
				1,0,1,0, 1,1,0,1,
				1,0,1,0, 1,0,1,1,
				//Pseq([
					//0,0,1,0, 1,0,1,0,
				//],7),
				//0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,1,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,1, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,

				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,1, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				//1,0.7,0.9,0.5,
				//0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					-1,\r,
				],7),
				Pseq([
					3,\r,
				],1),
				Pseq([
					0,\r,
				],7),
				Pseq([
					3,\r,
				],1),
			],inf),
			\lpf, Pseq([
				400,800,2000,
				400,800,2000,
				400,800,
			],inf).stutter(2),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \superpw,
			\note, Pseq([
				Pseq([ 10, ],8),
				10,8,7,0, 0,0,0,0,
				Pseq([ 5, ],8),
				8,10,7,0, 0,0,0,0,
				Pseq([ 3, ],8),
				8,7,5,0, 0,0,0,0,
				Pseq([ 0, ],8),
				5,3,3,0, 0,0,0,0,
			],inf),
			\octave, 5,
			\legato, 1/3,
			\adsr, Pseq([
				[ Env.adsr(0.03,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				7,0,0,0, 0,0,0,0,
				1,1,6,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

//////////////////:


// create a time cluster of sound, dividing the time in two opposed sides
// then try to create some continuity
// then create opposite side or just play with one side against silence
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				//Pseq([
					//0,0,1,0, 1,0,1,0,
				//],7),
				//0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,1,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				//1,0.7,0.9,0.5,
				//0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				5,7,0,5,
			],inf).stutter(16),
			\octave, 3,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,
			],inf),
			\lpf, 500,
			\envamt, 10,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1 * Pseq([
				2,1,1,2,1,1,2,1,
			],inf)/2,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				//Pseq([
					//0,0,1,0, 1,0,1,0,
				//],7),
				//0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,1,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				//1,0.7,0.9,0.5,
				//0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				5,7,0,5,
			],inf).stutter(16),
			\octave, 3,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,
			],inf),
			\lpf, 500,
			\envamt, 10,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1 * Pseq([
				2,1,1,2,1,1,2,1,
			],inf)/2,
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
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				//Pseq([
					//0,0,1,0, 1,0,1,0,
				//],7),
				//0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,1,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				//1,0.7,0.9,0.5,
				//0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				5,7,0,5,
			],inf).stutter(16),
			\octave, 3,
			\lpf, 400,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 0,1,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 0,1,0,1,
				1,0,0,0, 1,0,0,1,
				1,0,1,0, 0,1,0,1,
				1,0,0,0, 1,0,1,1,
				1,0,1,1, 0,1,0,1,
				1,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0, 0,0,0,-1,
				Pseq([ 0,0,0,0, 0,0,0,-2, ]+7,1),
				0,0,0,0, 0,0,0,-1,
				0,0,0,0, 0,0,0,-1,

				0,0,0,0, 0,0,0,-1,
				Pseq([ 0,0,0,0, 0,0,0,5, ]-1,1),
				0,0,0,0, 0,0,0,-1,
				0,0,0,0, 0,0,0,-1,
			],inf),
			\lpf, PmodEnv(Pseq([500,2500],1), 8*4).loop,
			\envamt, 10,
			\octave, 5,
			\dur, 1/4,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\vel, 0.80000001192093,
			\modIndex, 0.20000000298023,
			\mix, 0.70000000298023,
			\mix, PmodEnv(Pseq([0,1],1), 8*4).loop,
			\lfoSpeed, 0.40000000596046,
			\lfoDepth, 0.10000000149012,
			\note, Pseq([
				0,0,-5,
			],inf),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		
		Pbind(
			\instrument, \Piano_rhodeySC,
			\vel, 0.80000001192093,
			\modIndex, 0.70000000298023,
			\mix, 0.70000000298023,
			\mix, PmodEnv(Pseq([0,1],1), 8*8).loop,
			\lfoSpeed, 0.40000000596046,
			\lfoDepth, 0.10000000149012,
			\note, Pseq([
				-3,-5,
			],inf),
			\octave, 5,
			\dur, 1/4,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pstep(Pseq([
				[5,7,12],
				[7,11,14],
				[0,4,7],
				[5,7,12],
			],inf),2),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,1,0,0, 1,0,0,1,
				0,0,0,0, 0,0,0,1, 
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 1,0,1,0,
				1,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,0,0, 1,0,1,1, 
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
				0,0,1,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 1,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,1, 1,0,1,0,
				0,0,0,0, 0,0,1,0,
				//Pseq([
					//0,0,1,0, 1,0,1,0,
				//],7),
				//0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,1,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 1,1,0,1,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 1,1,0,1,
				1,0,1,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				//1,0.7,0.9,0.5,
				//0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				5,7,0,5,
			],inf).stutter(16),
			\octave, 3,
			\lpf, 400,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 0,1,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 0,1,0,1,
				1,0,0,0, 1,0,0,1,
				1,0,1,0, 0,1,0,1,
				1,0,0,0, 1,0,1,1,
				1,0,1,1, 0,1,0,1,
				1,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0, 0,0,0,-1,
				Pseq([ 0,0,0,0, 0,0,0,-2, ]+7,1),
				0,0,0,0, 0,0,0,-1,
				0,0,0,0, 0,0,0,-1,

				0,0,0,0, 0,0,0,-1,
				Pseq([ 0,0,0,0, 0,0,0,5, ]-1,1),
				0,0,0,0, 0,0,0,-1,
				0,0,0,0, 0,0,0,-1,
			],inf),
			\lpf, PmodEnv(Pseq([500,2500],1), 8*4).loop,
			\envamt, 10,
			\octave, 5,
			\dur, 1/4,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\vel, 0.80000001192093,
			\modIndex, 0.20000000298023,
			\mix, 0.70000000298023,
			\mix, PmodEnv(Pseq([0,1],1), 8*4).loop,
			\lfoSpeed, 0.40000000596046,
			\lfoDepth, 0.10000000149012,
			\note, Pseq([
				0,0,-5,
			],inf),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		
		Pbind(
			\instrument, \Piano_rhodeySC,
			\vel, 0.80000001192093,
			\modIndex, 0.70000000298023,
			\mix, 0.70000000298023,
			\mix, PmodEnv(Pseq([0,1],1), 8*8).loop,
			\lfoSpeed, 0.40000000596046,
			\lfoDepth, 0.10000000149012,
			\note, Pseq([
				-3,-5,
			],inf),
			\octave, 5,
			\dur, 1/4,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pstep(Pseq([
				[5,7,12],
				[7,11,14],
				[0,4,7],
				[5,7,12],
			],inf),2),
			\octave, 5,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);


//////////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1281].value,
			\bufnum, ~buflib.kick[1015].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
	])
)).play;
);
