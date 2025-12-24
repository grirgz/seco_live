
// amen

~t = 160/4/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\amdrums1, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/amenbreak.wav'),
			\legato, 1,
			\st, 137/4/60,
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
			\gain, 1/8,
		)

	])
)).play;
);
