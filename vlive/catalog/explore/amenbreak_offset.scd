
~t = 172/4/60; TempoClock.default.tempo = ~t;

(
// offset technique
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/amenbreak.wav'),
			\legato, 1,
			\st, 137/4/60,
			\speed, 0.91 * ~t / Pkey(\st),
			\pos, Pseq([
				(0..7)
			].flat,inf) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,3,1,4, 4,0,-5,3,
				0,1,1,-1, 0,0,0,0,
			],inf) /8/ Pkey(\st),
			\dur, 1/8,
			//\legato, 0.3,
			\gain, 1/8,
		)
		
	])
)).play;
);



(
// try other samples
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Nervous 2.wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/8 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),8).loop * Pkey(\bufdur) * 1/8,
			\pos, Pseq([
				(0..15)
			].flat,inf) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,3,1,4, 4,0,-5,3,
				0,1,1,-1, 0,0,0,0,
			],inf) /8/8* Pkey(\bufdur),
			\dur, 1/8,
			\gain, 1/8,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),8).loop / Pkey(\st),
			\pos, Pseq([
				(0..15)
			].flat,inf) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,-2,0, 4,0,-5,3,
				0,1,1,-1, 0,0,0,0,
			],inf) /8/ Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\stut, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\stut, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				//0,0,0,0, 0,0,1,0,
				//0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,
			],inf),
			\rate, 1,
			\time, Pstep(Pseq([1/4,1/8,1/4],inf),1/4)/~t,
			\time, 1/16/~t,
			\dur, Pser([1/8],inf),
			\amp, 0.1,
		),
	])
)).play;
);
