// cover:state your name

~t = 125/2/60; TempoClock.default.tempo = ~t;



(
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1483].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[140].value,
			\bufnum, ~buflib.snare[1729].value,
			\bufnum, ~buflib.snare[2084].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[640].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		
	])
)).play;
);

(
// for compressor
Pdef(\part, Pdef(\drums1comp, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1483].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kicktrack,\audio),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sideinbus, \audio, 2),
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[140].value,
			\bufnum, ~buflib.snare[1729].value,
			\bufnum, ~buflib.snare[2084].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[640].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\kickcomp, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1483].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kicktrack,\audio),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sideinbus, \audio, 2),
			\dur, 1,
		),
		
	])
)).play;
);

//////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				6, 6, 13, 13, 7,7+12,14,7,
				//6,1,7,2,
			],inf),
			\octave, 3,
			\envamt, 2,
			\dur, 1/4 * (1 + (0.33 * Pseq([1,-1],inf))),
			\amp, 0.1/2,
		),
		
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
				//6, \r, 6, 13, \r, 13, 
				//7, \r, 14, \r, 7+12,14,
				6, \r, 6, 13, \r, 13, 
				7, \r, 7, \r, 13,7,
			],inf),
			\octave, 2,
			\envamt, 2,
			\dur, 1/2/3,
			\amp, 0.1/2,
		),
		
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
				6,  6, 13,  13, 
				7,  14, \r, 7+12, \r, 14,
				6,  6, 13,  13, 
				7,  7, 13, 7, \r,
			],inf),
			\octave, 2,
			\envamt, 2,
			\rq, 0.4,
			\lpf, 400,
			\dur, 1/2/3,
			\dur, Pseq([
				5,3,5,3,5,3, 1,3,1,3,
				5,3,5,3,5,3, 3,3,2,
			],inf)/8/2,
			\legato, Pseq([
				1,2/3,1,2/3,1,1/3, 1,1/2,1,2/3,
				1,2/3,1,2/3,1,2/3, 1,1,1,
			],inf),
			//\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1/2,
		),
		
	])
)).play;
);

//////////////// compare

SampleTimeline(\junk).buffer = BufDef("~/tmp/junk.wav") // bass of ref track
SampleTimeline(\junk).edit
SampleTimeline(\myjunk).edit // record my version of bass
(
// similar bass timbre
// compare original and sample
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pseq([
			Pfindur(4,Pbind(
				\instrument, \sh101,
				\note, Pseq([
					6,  6, 13,  13, 
					7,  14, \r, 7+12, \r, 14,
					6,  6, 13,  13, 
					7,  7, 13, 7, \r,
				],inf),
				\octave, 2,
				\envamt, 1,
				\rq, 0.5,
				\lpf, Pkey(\freq)*4,
				\dur, 1/2/3,
				\dur, Pseq([
					5,3,5,3,5,3, 1,3,1,3,
					5,3,5,3,5,3, 3,3,2,
				],inf)/8/2,
				\legato, Pseq([
					1,2/3,1,2/3,1,1/3, 1,1/2,1,2/3,
					1,2/3,1,2/3,1,2/3, 1,1,1,
				],inf),
				//\legato, 0.1,
				\lpadsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\amp, 0.1/2,
			)),
			Pfindur(4,SampleTimeline(\junk).asPattern),
		],inf),
		
	])
)).play;
);

(
// add compressor
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1comp),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				6,  6, 13,  13, 
				7,  14, \r, 7+12, \r, 14,
				6,  6, 13,  13, 
				7,  7, 13, 7, \r,
			],inf),
			\octave, 2,
			\envamt, 1,
			\rq, 0.5,
			\lpf, Pkey(\freq)*4,
			\dur, 1/2/3,
			\dur, Pseq([
				5,3,5,3,5,3, 1,3,1,3,
				5,3,5,3,5,3, 3,3,2,
			],inf)/8/2,
			\legato, Pseq([
				1,2/3,1,2/3,1,1/3, 1,1/2,1,2/3,
				1,2/3,1,2/3,1,2/3, 1,1,1,
			],inf),
			//\legato, 0.1,
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1/2,
			\out, BusDef(\comp, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\comp, \audio),
			\sideinbus, BusDef(\sideinbus, \audio),
			\addAction, \addToTail,
			\lag, 0.001,
			\cpt, 0.005,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.051,
			\gain, 1,
			\dur, 1,
		),

	])
)).play;
);




///////////////// better drums

(
Pdef(\part, Pdef(\basscomp, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				6,  6, 13,  13, 
				7,  14, \r, 7+12, \r, 14,
				6,  6, 13,  13, 
				7,  7, 13, 7, \r,
			],inf),
			\octave, 2,
			\envamt, 1,
			\rq, 0.5,
			\lpf, Pkey(\freq)*4,
			\dur, 1/2/3,
			\dur, Pseq([
				5,3,5,3,5,3, 1,3,1,3,
				5,3,5,3,5,3, 3,3,2,
			],inf)/8/2,
			\legato, Pseq([
				1,2/3,1,2/3,1,1/3, 1,1/2,1,2/3,
				1,2/3,1,2/3,1,2/3, 1,1,1,
			],inf),
			//\legato, 0.1,
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1/2,
			\out, BusDef(\comp, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\comp, \audio),
			\sideinbus, BusDef(\sideinbus, \audio),
			\addAction, \addToTail,
			\lag, 0.001,
			\cpt, 0.005,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.051,
			\gain, 1,
			\dur, 1,
		),

	])
)).play;
);

(
Pdef(\part, Pdef(\drums2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1483].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[140].value,
			\bufnum, ~buflib.snare[1729].value,
			\bufnum, ~buflib.snare[2084].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/3,
		),
		Pbind( // ghost snare
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.snare[140].value,
			\bufnum, ~buflib.snare[1729].value,
			\bufnum, ~buflib.snare[2084].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\lpf, 8000,
			\hpf, 1000,
			\legato, 0.5,
			\adsr, Pseq([
				[ Env.adsr(0.02,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/4,
		),
		Pbind( // ghost clap
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.snare[140].value,
			\bufnum, ~buflib.snare[1729].value,
			\bufnum, ~buflib.snare[2084].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\lpf, 8000,
			\hpf, 2000,
			\legato, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[640].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\drums2comp, 
	Ppar([
		Pdef(\kickcomp),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[140].value,
			\bufnum, ~buflib.snare[1729].value,
			\bufnum, ~buflib.snare[2084].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/3,
		),
		Pbind( // ghost snare
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.snare[140].value,
			\bufnum, ~buflib.snare[1729].value,
			\bufnum, ~buflib.snare[2084].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\lpf, 8000,
			\hpf, 1000,
			\legato, 0.5,
			\adsr, Pseq([
				[ Env.adsr(0.02,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/4,
		),
		Pbind( // ghost clap
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.snare[140].value,
			\bufnum, ~buflib.snare[1729].value,
			\bufnum, ~buflib.snare[2084].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\lpf, 8000,
			\hpf, 2000,
			\legato, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[640].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\basscomp),
		Pdef(\drums2comp),
	])
)).play;
);
