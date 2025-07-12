
(
~t = 185/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
)

ProtoDef(\piano).startControl(Pdef(\melo, Pbind(\instrument, \snappad)))

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[407].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
				0,0,1,0, 1,0,0,0,
				1,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
				0,0,1,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,4,7],
				[0+12,3,7]-5,
			],inf),
			\dur, 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, 
			Pseq([
				Pseg(Pseq([ 0, 2, ]+0,1),1),
				Pseg(Pseq([ 5, 2, ]+0,1),1/2),
				Pseg(Pseq([ 6, 8, ]+0,1),1/2),
				Pseg(Pseq([ 6, 7, ]+0,1),1),
				Pseg(Pseq([ 6, 8, ]+0,1),1),
			],inf).loop / Pkey(\st),
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
			\bufnum, ~buflib.kick[407].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,4,7],
				[0+12,3,7]-5,
			],inf),
			\dur, 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[684].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, 
			Pseq([
				//Pseg(Pseq([
					//0, 2,
				//]+0,1),2),
				//Pseg(Pseq([
					//2, 6,
				//]+0,1),2),
				//Pseg(Pseq([ 0, 2, ]+0,1),1),
				//Pseg(Pseq([ 6, 2, ]+0,1),1),

				//0,\r,3,\r, 0,3,3,3,
				Pseq([
					12,17,14,15,
					12,17,12,19,
					12,14,12,14,
					14,15,12,15,

					11,17,12,19,
					12,17,12,20,
					3,8.6,3,11,
					10.3,10.1,11,12,

					12,17,14,15,
					12,17,12,19,
					12,14,12,14,
					14,15,12,15,

					11,17,12,19,
					12,17,12,20,
					3,3,3,5,
					9,10,9,10,
				]/4,inf),
				//Pseg(Pseq([ 5, 3, ]+0,1),1/2),

				//Pseg(Pseq([ 0, 2, ]+0,1),1),
				//Pseg(Pseq([ 2, 4, ]+0,1),1),

				//Pseg(Pseq([ 0, 2,4 ]+0,1),1),
				//Pseg(Pseq([
					//6, 8,
				//]+0,1),2),
			],inf).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\basehi, 
	Ppar([
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,4,7],
				[0+12,3,7]-5,
			],inf),
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);
(
// drum study 1
Pdef(\part, Pdef(\drumstu1, 
	Ppar([
		//Pdef(\basehi),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, 
			Pseq([
				Pseg(Pseq([ 0, 2, ]+0,1),1),
				Pseg(Pseq([ 1, 0 ]+4.25,1),1),
				Pseg(Pseq([ 0, 2, ]+0,1),1),
				Pseg(Pseq([ 7, 6 ]+0,1),1),
			],inf).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);

(
// drum study 2
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\basehi),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, 
			Pseq([
				Pseg(Pseq([ 0, 2, ]+0,1),1),
				Pseg(Pseq([ 11, 9, 8 ]/4,1),1/2),
				Pseg(Pseq([ 0, 1, ]+6,2),1/2), Pseg(Pseq([ 2, 1/2, ]+0,1),1/2), 
				Pseg(Pseq([ 0, 1/2, ]+0,1),1/2), Pseg(Pseq([ 0, 3, ]+1,1),1/2),
			],inf).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);

(
// drum study 3
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\basehi),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, 
			Pseq([
				Pseg(Pseq([ 0, 2, ]+0,1),1),
				Pseg(Pseq([ 6, 4, ]+0,1),1),
				Pseg(Pseq([ 0, 1, ]+0,1),1/2), Pseg(Pseq([ 7, 5, ]+0,1),1/2),
				Pseg(Pseq([ 1, 3.5, ]+0,1),1/2), Pseg(Pseq([ 0, 5, ]+0,1),1/2),

				Pseg(Pseq([ 0, 2, ]+0,1),1),
				Pseg(Pseq([ 2, 3.5, ]+0,1),1/2), Pseg(Pseq([ 5, 4, ]+0,1),1/2),
				Pseg(Pseq([ 0, 1, ]+4,1),1/2), Pseg(Pseq([ 4, 5, ]+0,1),1/2),
				Pseg(Pseq([ 6, 3, ]+0,1),1),
			],inf).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);

(
// drum study 4
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\basehi),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,

				1,1,1,1, 0.91,0.91,1,1,
				1.1,1,1,1, 1,1,1,1,

				1,1,1,1, 1.2,1.2,1.2,1.2,
				1,1,1,1, 1,1,1.2,1,
			],inf) * ~t / Pkey(\st),
			\pos, 
			Pseq([
				Pseg(Pseq([ 0, 2, ]+0,1),1),
				Pseg(Pseq([ 1, 0 ]+4.25,1),1),
				Pseg(Pseq([ 0, 2, ]+0,1),1),
				Pseg(Pseq([ 7, 6 ]+0,1),1),
			],inf).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);

(
// nice
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[407].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,1,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,4,7],
				[0+12,3,7]-5,
			],inf),
			\dur, 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([

				(0..7),
				0,18,24,16, 4,3,13,3,
				0,\r,2,3, 4,5,\r,7,
				\r!8,

				(0..7),
				0,18,24,16, 4,3,13,3,
				0,\r,2,3, 4,5,\r,7,
				\r,\r,\r,\r, 4,8,4,7,

			].flat/4,inf).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Nervous 2.wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }) / 8,
			\speed, 1* ~t * Pkey(\bufdur),
			\pos, Pseq([
				\r,\r,8,\r, \r,\r,\r,\r,
				8,\r,10,\r, 12,\r,14,\r,
				\r,\r,8,\r, \r,\r,\r,\r,
				(0..7),

				\r,\r,8,\r, \r,\r,\r,\r,
				8,\r,10,\r, 12,\r,14,\r,
				\r,\r,8,\r, \r,\r,\r,\r,
				(0..3), (4..7)+18,
			].flat/8,inf).loop * Pkey(\bufdur),
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
			\bufnum, ~buflib.hat[1380].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([

				1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
				1,0,0,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[404].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,4,7],
				[0+12,3,7]-5,
			],inf),
			\dur, 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				\r,\r,\r,\r, 2,\r,\r,\r,
				\r,\r,\r,\r, (4..7),
				\r,\r,\r,\r, 2+8,\r,\r,\r,
				\r,\r,\r,\r, 2+8+8,\r,\r,\r,
				(0..3), \r,\r,\r,\r,

			].flat/4,inf).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Nervous 2.wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }) / 8,
			\speed, 1* ~t * Pkey(\bufdur),
			\pos, Pseq([
				(0..7),
				\r,\r,8,9, \r,\r,\r,\r,
				0,\r,2,3, (4..7)+8,
				\r,\r,8,\r, \r,\r,14,15,
				//\r,\r,\r,\r, (4..7),
				//\r,\r,\r,\r, (4..7)+8,
				//\r!24,
				//(24..31),
			].flat/8,inf).loop * Pkey(\bufdur),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);

(
// nice
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1077].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0,
				1,0,1,0, 
			],inf).coin.not,
			\dur, 1/8/2 * (1 + (0.36 * Pseq([1,0,-1,0],inf))),
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.09 * Pseq([
				1,0.5,0.7,0.4
			],inf),
			\lag, -0.01,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[684].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
				0,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[404].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,4,7],
				[0+12,3,7]-5,
			],inf),
			\dur, 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				\r,\r,\r,\r, 2,\r,\r,\r,
				\r,\r,\r,\r, (4..7),
				\r,\r,\r,\r, 2+8,\r,\r,\r,
				\r,\r,\r,\r, 2+8+8,\r,\r,\r,
				(0..3), \r,\r,\r,\r,

			].flat/4,inf).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Nervous 2.wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }) / 8,
			\speed, 1* ~t * Pkey(\bufdur),
			\pos, Pseq([
				(0..7),
				(0..7)+8,
			].flat/8,inf).loop * Pkey(\bufdur),
			\isRest, Pseq([
				1,0.91,0.91,0.91, 0.91,0.91,0.91,0.91,
				0.1,0.1,0.9,0.5, 0.1,0.1,0.3,0.2,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);

////////////////////////
(
Pdef(\melo, 
	Pbind(
		\instrument, \sh101,
	)
)
);
Pdef(\melo).edit
ProtoDef(\piano).startControl(Pdef(\melo))

(
Pdef(\part, Pdef(\sec1intro, 
	Ppar([
		
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,4,7],
				[0+12,3,7]-5,
			],inf),
			\dur, 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					0,4,7,4,
					12,0,4,7,
				],4*4),
				Pser([
					7+12,12,7,3,
					12,0,3,7,
				],4*4)-5,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.01) ],
				[ Env.adsr(0.1,0.1,0.8,0.01) ],
				[ Env.adsr(0.1,0.1,0.8,0.11) ],
				[ Env.adsr(0.1,0.1,0.8,0.01) ],
			],inf),
			\envamt, PmodEnv(Pseq([4,8],1), 16).loop,
			\lpf, PmodEnv(Pseq([100,200,1000],1), 8).loop,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx1, \audio),
			\delay, 1/8.5/~t,
			\decay, 1/~t,
			\mix, 0.2,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\hpf, PmodEnv(Pseq([15000,10000,20],1), 8).loop,
			\hpmix, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, 
			Pseq([
				Pseg(Pseq([ 0, 2, ]+0,1),1),
				Pseg(Pseq([ 5, 2, ]+0,1),1/2),
				Pseg(Pseq([ 6, 8, ]+0,1),1/2),
				Pseg(Pseq([ 6, 7, ]+0,1),1),
				Pseg(Pseq([ 6, 8, ]+0,1),1),
			],inf).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\sec1, 
	Ppar([
		
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,4,7],
				[0+12,3,7]-5,
			],inf),
			\ffreq, PmodEnv(Pseq([1000,12000,100],1), 4).loop,
			\dur, 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \brasspad,
			\note, Pseq([
				9,\r,9,\r, 12,\r,10,9,
			],inf),
			\dur, 1/2,
			\amp, 0.1,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
			\out, BusDef(\ifx2, \audio),
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\ifx2, \audio),
			\fb, 0.40000000596046,
			\maxdelay, 0.20000000298023,
			\delay, 0.080099999606609,
			\diff, 0.10009999275208,
			\modfreq, 0.4000003814697,
			\modamp, 0.17999998927116,
			\lpf, 15000.0,
			\hpf, 150.0,
			\mix, 0.5,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.0099999997764826, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					0,4,7,4,
					12,0,4,7,
				],4*4),
				Pser([
					7+12,12,7,3,
					12,0,3,7,
				],4*4)-5,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.01) ],
				[ Env.adsr(0.1,0.1,0.8,0.01) ],
				[ Env.adsr(0.1,0.1,0.8,0.11) ],
				[ Env.adsr(0.1,0.1,0.8,0.01) ],
			],inf),
			\envamt, PmodEnv(Pseq([4,8],1), 16).loop,
			//\lpf, PmodEnv(Pseq([100,200,1000],1), 8).loop,
			\lpf, 1000,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx1, \audio),
			\delay, 1/8.5/~t,
			\decay, 1/~t,
			\mix, 0.2,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			//\hpf, PmodEnv(Pseq([15000,10000,20],1), 8).loop,
			\hpmix, 0,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, 
			Pseq([
				Pseg(Pseq([ 0, 2, ]+0,1),1),
				Pseg(Pseq([ 5, 2, ]+0,1),1/2),
				Pseg(Pseq([ 6, 8, ]+0,1),1/2),
				Pseg(Pseq([ 6, 7, ]+0,1),1),
				Pseg(Pseq([ 6, 8, ]+0,1),1),
			],inf).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pfindur(16,Pdef(\sec1intro)),
			Pfindur(16,Pdef(\sec1)),
			Pfindur(16,Pdef(\sec2)),
		],1),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\sec2, 
	Ppar([
		
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,4,7],
				[0+12,3,7]-5,
			],inf),
			\ffreq, PmodEnv(Pseq([1000,12000,100],1), 4).loop,
			\dur, 2,
			\amp, 0.1,
			\out, BusDef(\hipass, \audio),
		),
		Pbind(
			\instrument, \brasspad,
			\note, Pseq([
				9,\r,9,\r, 12,\r,10,9,
			],inf),
			\dur, 1/2,
			\amp, 0.1,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
			\out, BusDef(\ifx2, \audio),
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\ifx2, \audio),
			\fb, 0.40000000596046,
			\maxdelay, 0.20000000298023,
			\delay, 0.080099999606609,
			\diff, 0.10009999275208,
			\modfreq, 0.4000003814697,
			\modamp, 0.17999998927116,
			\lpf, 15000.0,
			\hpf, 150.0,
			\mix, 0.5,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.0099999997764826, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\addAction, \addToTail,
			\lag, 0.0008,
			\dur, 1,
			\out, BusDef(\hipass, \audio),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					0,4,7,4,
					12,0,4,7,
				],4*4),
				Pser([
					7+12,12,7,3,
					12,0,3,7,
				],4*4)-5,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.01) ],
				[ Env.adsr(0.1,0.1,0.8,0.01) ],
				[ Env.adsr(0.1,0.1,0.8,0.11) ],
				[ Env.adsr(0.1,0.1,0.8,0.01) ],
			],inf),
			\envamt, PmodEnv(Pseq([4,8],1), 16).loop,
			//\lpf, PmodEnv(Pseq([100,200,1000],1), 8).loop,
			\lpf, 1000,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx1, \audio),
			\delay, 1/8.5/~t,
			\decay, 1/~t,
			\mix, 0.2,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\hipass, \audio),
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			//\hpf, PmodEnv(Pseq([15000,10000,20],1), 8).loop,
			\hpmix, 0,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, 
			Pseq([
				Pseg(Pseq([ 0, 2, ]+0,1),1),
				Pseg(Pseq([ 5, 2, ]+0,1),1/2),
				Pseg(Pseq([ 6, 8, ]+0,1),1/2),
				Pseg(Pseq([ 6, 7, ]+0,1),1),
				Pseg(Pseq([ 6, 8, ]+0,1),1),
			],inf).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pmono(\fx_rlpfrhpf,
			\inbus, BusDef(\hipass, \audio),
			\addAction, \addToTail,
			\hpmix, 1,
			\lpmix, 0,
			\hpf, PmodEnv(Pseq([6001,20,20,20,20],1), 4).loop,
			\lag, 0.0009,
			\gain, 1/4,
			\dur, 1,
		),
		Pbind(
			\instrument, \reese,
			\note, Pseq([
				0,0,0,0,
				4,4,\r,\r,
				4,4,0,0,
				0,0,\r,\r,
				3,3,0,0,
				7,7,\r,0,
				7,7,3,3,
				0,0,0,\r,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		PmonoArtic( \warmbass,
			\note, Pseq([
				0,0,0,0, 4,4,0,0,
				4,4,0,0, 0,0,0,0,
				3,3,0,0, 7,7,0,0,
				7,7,3,3, 0,0,0,0,
			],inf),
			\legato, Pseq([
				1,1,1,0, 1,1,1,1,
				1,1,1,1, 1,1,1,0,
				1,1,1,1, 0,0,1,1,
				1,1,1,0, 1,1,1,0,
			],inf),
			\lpf, 100,
			\lpadsr, Pseq([
				[ Env.adsr(2.1,0.1,0.8,0.1) ],
			],inf),
			\envamt, 5,
			\kbamt, 0,
			//\distamp, 100,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		PmonoArtic( \warmbass,
			\note, Pseq([
				0,0,0,0, 4,4,0,0,
				4,4,0,0, 0,0,0,0,
				3,3,0,0, 7,7,0,0,
				7,7,3,3, 0,0,0,0,
			],inf),
			\legato, Pseq([
				1,1,1,0, 1,1,1,1,
				1,1,1,1, 1,1,1,0,
				1,1,1,0, 1,1,1,1,
				0,0,0,0, 1,1,1,1,
			],inf),
			\lpf, 100,
			\lpadsr, Pseq([
				[ Env.adsr(2.1,0.1,0.8,0.1) ],
			],inf),
			\envamt, 5,
			\kbamt, 0,
			//\distamp, 100,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

////
(
SynthDef(\fx_extract, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	//sig = sig * SinOsc.ar(300);
	//sig = sig + DelayL.ar(sig, 0.2,0.0001 * ( SinOsc.kr(1/4) * 0.01 + 1 ));
	sig = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/4);
	sig = RLPF.ar(sig, ( \lpf.kr(9000.1) ).clip(20,20000), \lrq.kr(0.4));
	sig = RHPF.ar(sig, ( \hpf.kr(500.1) ).clip(20,20000), \hrq.kr(0.4));
	//sig = sig * 1.2;
	//sig = AllpassL.ar(sig, 4/~t, 0.01,4/~t) + sig;
	sig = sig * \verbpregain.kr(1.4);
	sig = FreeVerb2.ar(sig.first, sig.last, mix:\verbmix.kr(0.5), room:\room.kr(1.5), damp:\damp.kr(0.5));
	sig = sig / 8;
	sig = LPF.ar(sig, \postlpf.kr(8000));
	sig = HPF.ar(sig, \posthpf.kr(800));
	sig = SelectX.ar(\mix.kr(0.9), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[407].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,0,
				1,0,0,0, 0,1,0,0,
				1,0,0,1, 0,1,0,0,
				1,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[684].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				//0,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1004].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 0.8,0.81,1,0.8,
				1,0,1,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		//Pdef(\drumstu1),
		Pbind(
			\instrument, \fmsaw,
			\note, Pseq([
				[0,4,7] +.x [0,12],
				( [0+12,7-12,7]-5 ) +.x [0,12],
				( [0+12,4+12,7]-7 ) +.x [0,12],
				( [0+12,7-12,7]-5 ) +.x [0,12],
			],inf).stutter(1),
			\octave, 5,
			\dur, 2,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_extract,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lpf, Pseq([
				PmodEnv(Pseq([900,100,12000],1), Pseq([0.1,1.9],1)),
				//PmodEnv(Pseq([100,12000],1), 4),
			],inf).loop,
			\hpf, 400,
			\damp, 0.9,
			\postlpf, 2000,
			\room, 0.9,
			\lrq, 0.3,
			\posthpf, 400,
			\distamp, 91,
			\mix, 0.95,
			\verbpregain, 8*2,
			\gain, 1/4,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,4,7],
				[0+12,3,7]-5,
			],inf),
			\dur, 2,
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
			\bufnum, ~buflib.kick[407].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,0,
				1,0,0,0, 0,1,0,0,
				1,0,0,1, 0,1,0,0,
				1,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[684].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				//0,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1004].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 0.8,0.81,1,0.8,
				1,0,1,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		//Pdef(\drumstu1),
		Pbind(
			\instrument, \fmsaw,
			\note, Pseq([
				4,
				7,
				//[0,4,7] +.x [0,12],
				//( [0+12,7-12,7]-5 ) +.x [0,12],
				//( [0+12,4+12,7]-7 ) +.x [0,12],
				//( [0+12,7-12,7]-5 ) +.x [0,12],
			],inf).stutter(1)+12,
			\octave, 5,
			\dur, 2,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_extract,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lpf, Pseq([
				PmodEnv(Pseq([900,100,12000],1), Pseq([0.1,1.9],1)),
				//PmodEnv(Pseq([100,12000],1), 4),
			],inf).loop,
			\hpf, 400,
			\damp, 0.9,
			\postlpf, 2000,
			\room, 0.9,
			\lrq, 0.3,
			\posthpf, 400,
			\distamp, 191,
			\mix, 0.95,
			\verbpregain, 8*2,
			\gain, 1/10,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,4,7],
				[0+12,3,7]-5,
			],inf),
			\dur, 2,
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
			\bufnum, ~buflib.kick[407].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,0,
				1,0,0,0, 0,1,0,0,
				1,0,0,1, 0,1,0,0,
				1,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[684].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				//0,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1004].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 0.8,0.81,1,0.8,
				1,0,1,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		//Pdef(\drumstu1),
		PmonoArtic(
			 \fmsaw,
			\note, Pseq([
				0,4,0,0, 2,2, 0,0,
				0,4,0,0, 2,2, 0,0,
				0,0, 2,2, -2,-2, -2,-2,
				0,0, 2,2, -2,-2, -2,-2,
				//[0,4,7] +.x [0,12],
				//( [0+12,7-12,7]-5 ) +.x [0,12],
				//( [0+12,4+12,7]-7 ) +.x [0,12],
				//( [0+12,7-12,7]-5 ) +.x [0,12],
			],inf).stutter(1)-[12,24,0],
			\octave, 5,
			\dur, 1/8,
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_extract,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lpf, Pseq([
				PmodEnv(Pseq([900,4500,12000],1), Pseq([0.1,1.9],1)),
				//PmodEnv(Pseq([100,12000],1), 4),
			],inf).loop,
			\lpf, 3000,
			\hpf, PmodEnv(Pseq([1000,20,4000],1), 8).loop,
			\damp, 0.9,
			\postlpf, 12000,
			\room, 0.5,
			\lrq, 0.3,
			\posthpf, 10,
			\distamp, 191,
			\mix, 0.95,
			\verbpregain, 8*2,
			\gain, 1/10,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,4,7],
				[0+12,3,7]-5,
			],inf),
			\dur, 2,
			\amp, 0.1,
			//\isRest, true,
		),
	])
)).play;
);


/////
BufDef(\terrorbass, "cliprec/rec_rec_mainTimeline_t0_250420_224140_250420_224140.wav")


(
// nice
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[407].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,0,
				1,0,0,0, 0,1,0,0,
				1,0,0,1, 0,1,0,0,
				1,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[684].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				//0,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1004].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 0.8,0.81,1,0.8,
				1,0,1,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			//\hpf, PmodEnv(Pseq([15000,10000,20],1), 8).loop,
			\hpmix, 0,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, 
			Pseq([
				Pseq([
					12,17,14,15,
					12,17,12,19,
					12,14,12,14,
					14,15,12,15,

					11,17,12,19,
					12,17,12,20,
					3,8.6,3,11,
					10.3,10.1,11,12,

					12,17,14,15,
					12,17,12,19,
					12,14,12,14,
					14,15,12,15,

					11,17,12,19,
					12,17,12,20,
					3,3,3,5,
					9,10,9,10,
				]/4,inf),
				//(0..3)+5/4, (0..3)+0/4,
				//(0..7)/8,
				//(0..3)+8/4, (0..3)+4/2,
				//(0..7)/8,
				//(0..7)+8+5/4,
				//(0..7)/4+2,
				//Pseq([ \r,\r,8,9, 12,13,\r,\r, ]/4,1),
				//Pseg(Pseq([ 0, 4 ]+0,1),1/2),
				//Pseg(Pseq([ 0, 2 ]+0,1),1),
				//Pseg(Pseq([ 6, 2 ]+0,1),1),
			].flat,inf).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\terrorbass),
			\pos, Pseq((0..4-1)*2,inf).stutter(4),
			\legato, 1,
			\dur, 1/4,
			\gain, 1,
		)
	])
)).play;
);

(
// nice
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[407].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,0,
				1,0,0,0, 0,1,0,0,
				1,0,0,1, 0,1,0,0,
				1,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[684].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				//0,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1004].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 0.8,0.81,1,0.8,
				1,0,1,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			//\hpf, PmodEnv(Pseq([15000,10000,20],1), 8).loop,
			\hpmix, 0,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, 
			Pseq([
				Pseq([
					12,17,14,15,
					12,17,12,19,
					12,14,12,14,
					14,15,12,15,

					11,17,12,19,
					12,17,12,20,
					3,8.6,3,11,
					10.3,10.1,11,12,

					12,17,14,15,
					12,17,12,19,
					12,14,12,14,
					14,15,12,15,

					11,17,12,19,
					12,17,12,20,
					3,3,3,5,
					9,10,9,10,
				]/4,inf),
				//(0..3)+5/4, (0..3)+0/4,
				//(0..7)/8,
				//(0..3)+8/4, (0..3)+4/2,
				//(0..7)/8,
				//(0..7)+8+5/4,
				//(0..7)/4+2,
				//Pseq([ \r,\r,8,9, 12,13,\r,\r, ]/4,1),
				//Pseg(Pseq([ 0, 4 ]+0,1),1/2),
				//Pseg(Pseq([ 0, 2 ]+0,1),1),
				//Pseg(Pseq([ 6, 2 ]+0,1),1),
			].flat,inf).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\terrorbass),
			//\pos, Pseq((0..4-1)*2,inf).stutter(4),
			\pos, Pseq([
				4,4, 4,4,
				3.5,3.5, 4,4,
				2,2, 2,2,
				1,1, 1,2,
			],inf),
			\legato, 1,
			\dur, 1/4,
			\gain, 1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,4,7],
				[0+12,3,7]-5,
			],inf),
			\ffreq, PmodEnv(Pseq([1000,12000,100],1), 4).loop,
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
			\instrument, \playersec,
			\bufnum, ~buflib.kick[407].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,0,
				1,0,0,0, 0,1,0,0,
				1,0,0,1, 0,1,0,0,
				1,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[684].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				//0,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1004].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 0.8,0.81,1,0.8,
				1,0,1,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			//\hpf, PmodEnv(Pseq([15000,10000,20],1), 8).loop,
			\hpmix, 0,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, 
			Pseq([
				Pseq([
					12,17,14,15,
					12,17,12,19,
					12,14,12,14,
					14,15,12,15,

					11,17,12,19,
					12,17,12,20,
					3,8.6,3,11,
					10.3,10.1,11,12,

					12,17,14,15,
					12,17,12,19,
					12,14,12,14,
					14,15,12,15,

					11,17,12,19,
					12,17,12,20,
					3,3,3,5,
					9,10,9,10,
				]/4,inf),
				//(0..3)+5/4, (0..3)+0/4,
				//(0..7)/8,
				//(0..3)+8/4, (0..3)+4/2,
				//(0..7)/8,
				//(0..7)+8+5/4,
				//(0..7)/4+2,
				//Pseq([ \r,\r,8,9, 12,13,\r,\r, ]/4,1),
				//Pseg(Pseq([ 0, 4 ]+0,1),1/2),
				//Pseg(Pseq([ 0, 2 ]+0,1),1),
				//Pseg(Pseq([ 6, 2 ]+0,1),1),
			].flat,inf).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\terrorbass),
			//\pos, Pseq((0..4-1)*2,inf).stutter(4),
			\pos, Pseq([
				4,4, 4,4,
				3.5,3.5, 4,4,
				2,2, 2,2,
				1,1, 1,2,
			],inf),
			\legato, 1,
			\dur, 1/4,
			\gain, 1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,4,7],
				[0+12,3,7]-5,
			],inf),
			\ffreq, PmodEnv(Pseq([1000,12000,100],1), 4).loop,
			\dur, 2,
			\amp, 0.1,
		),
	])
)).play;
);
