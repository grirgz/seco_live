(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/amenbreak.wav'),
			\legato, 1,
			\st, 137/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			],1),2).loop / Pkey(\st) + 0.1,
			\dur, 1/8,
			\gain, 1/8,
		)
		
	])
)).play;
);
//////////////
(
BufDef(\amen, "vipere/amenbreak.wav");
Pdef(\amen, Pbind(
	\instrument, \playersec,
	\bufnum, BufDef(\amen),
	\degree, Pseq([0],inf),
	\speed, 4*~t/(137/60),
	\speed, 2*~t/(137/60),
	\pos, Prand([0,2],inf)*( 137/60 ),
	\legato, 1,
	\dur, 2,
	\amp, 0.1
)).play;
);

/////////////////
// TODO: find how to play the whole file without hole at any tempo
(
BufDef(\amen, "vipere/amenbreak.wav");
Pdef(\amen, Pbind(
	\instrument, \playersec,
	\bufnum, BufDef(\amen),
	\degree, Pseq([0],inf),
	\speed, 4*~t/(137/60),
	\speed, 1/2*~t/(137/60),
	\pos, Pseg(Pseq([0,1],inf),8),
	\legato, 0.9981,
	\dur, 16,
	\pos, Pkey(\dur) * Pkey(\speed) * Pseq([
		0,
	],inf) / 2,
	\amp, 0.1
)).play;
);

(
BufDef(\amen, "vipere/amenbreak.wav");
Pdef(\amen, Pfindur(32,Pmono(
	 \playersec,
	\bufnum, BufDef(\amen),
	\degree, Pseq([0],inf),
	\speed, 4*~t/(137/60),
	\speed, 1/2*~t/(137/60),
	\pos, Pseg(Pseq([0,1],inf),8),
	\legato, 0.9981,
	\dur, 1,
	\pos, Pkey(\dur) * Pkey(\speed) * Pseq([
		0,
	],inf) / 2,
	\amp, 0.1
)).loop).play;
);

/////////////////////////////////////////

(
	~t = 137/1/60; TempoClock.default.tempo = ~t;
Pdef(\amen, 
	Pseq([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\amen),
			\degree, Pseq([0],inf),
			\speed, 2*~t/(137/60),
			\speed, 1*~t/(137/60),
			\pos, Pseq([0],1)*( 137/60 ),
			\legato, 1,
			\gain, 1/18,
			\dur, 2,
			\amp, 0.1
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\amen),
			\degree, Pseq([0],inf),
			\speed, 2*~t/(137/60),
			\speed, 1*~t/(137/60),
			\pos, Pseq([2],inf)*( 137/60 ),
			\legato, 1,
			\gain, 1/18,
			\dur, 1,
			\dur, PdurStutter(Prand([4,2,1],4), 1/4) * 4,
			\amp, 0.1
		),
	],inf),
).play;
);

(
	~t = 150/1/60; TempoClock.default.tempo = ~t;
Pdef(\amen, 
	Pseq([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\amen),
			\degree, Pseq([0],inf),
			\speed, 2*~t/(137/60),
			\speed, 1*~t/(137/60),
			\pos, Pseq((0..15)/15,1)*4/(137/60),
			\legato, 1,
			\gain, 1/18,
			\dur, 1,
			\amp, 0.1
		),
	],inf),
).play;
);

(
	~t = 150/2/60; TempoClock.default.tempo = ~t;
Pdef(\amen, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\amen),
			\degree, Pseq([0],inf),
			\speed, 2*~t/(137/60),
			\speed, 2*~t/(137/60),
			\pos, Pseq((0..15)/16,inf)*16/(137/60),
			\legato, 1,
			\gain, 1/18,
			\dur, 1,
			\amp, 0.1
		),
	],inf),
).play;
);

(
	~t = 150/2/60; TempoClock.default.tempo = ~t;
Pdef(\amen, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\amen),
			\degree, Pseq([0],inf),
			\speed, 2*~t/(137/60),
			\speed, 2*~t/(137/60),
			\pos, Pseq((0..15)/16,inf)*8/(137/60),
			\legato, 1,
			\gain, 1/18,
			\dur, 1,
			\amp, 0.1
		),
	],inf),
).play;
);

(
	~t = 150/2/60; TempoClock.default.tempo = ~t;
Pdef(\amen, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\amen),
			\degree, Pseq([0],inf),
			\speed, 2*~t/(137/60),
			\speed, 2*~t/(137/60),
			\pos, Pseq([0,3,1,1,3,4,2,1],inf)*1/(137/60),
			\legato, 1,
			\gain, 1/18,
			\dur, 1/2,
			\amp, 0.1
		),
	],inf),
).play;
);

////////////: pigs
//
// 	a / ( b / c ) 	= 	( a * c ) / b
// 	a / b / c 		= 	a / ( b * c )

// calcul du tempo
//		1 loop = 2.606 secondes
//		durée en minute = 2.606 / 60
//		frequence est l'inverse de la durée : bpm = 60 / 2.606
//		ajustement de la taille du beat a une mesure en multipliant par 4
// 		bpm = 60 / 2.606 * 4 = 92.09516500 =~ 92.10
//
//		pour plus de precision, il mesurer prendre la loop la plus grande possible
//		4 loop = 10.417
//		bpm = 60 / 10.417 * 4 * 4 = 92.15705
//
//		a l'oreille, 
//			si le tempo est trop haut, les drums du sample sont trop en retard et le sample fini trop tot
//			si trop bas, les drums du sample sont trop en avance et ca fini avant la fin du sample
//
//		a partir d'un tempo de 92.2, on aurait une durée de:
//		dur = 60 / bpm * 4 = 60 / 92.2 * 4 = 2.60303

// sampleTempo = beat per second = 92.10/60 / 4
//		sampleTempo is divided by 4 if currentTempo is divided by 4 to have 1 beat = 1 loop
// speed = targetSpeed * currentTempo / sampleTempo
//		the more the tempo, the more the sample should be played fast
// pos = beatPos / sampleTempo
//		pos is in seconds
//		speed is already taken in account in pos
//		since speed take in account tempo, no need to use ~t
//		if currentTempo = sampleTempo, for example when recording a pattern, then you can use
//			pos = beatPos / ~t
//			beatPos = pos * ~t
// dur = 1 / targetSpeed
//		if tempo is very high, one beat is a very tiny fraction of a second
// tempoRatio = currentTempo/sampleTempo
//		the more the tempo, the more the ratio
//
// computing pos:
//		pos(speed, beatPos) = beatPos / currentTempo * TempoRatio
//		pos(speed, beatPos) = beatPos / currentTempo * (currentTempo / sampleTempo)
//		pos(speed, beatPos) = beatPos / sampleTempo


// 1 loop de drum de pigs dure 2.61 secondes, ca donne 1 beat avec un tempo de 92.2/4 bpm (92.2/4/60 bps)
//		beatPos = pos / ~t
//		beatPos = 2.61 / ( 92.2 / 4 / 60 ) = 6.79
// 		tempo = 92.2 / 60 = 1.536666
//		1 beat = 1second / ~t = 1 / ( 1.5366 / 4 ) = 2.6030 seconds
//		secPos = beatPos / ~t
//		2.6030 = 1 / ( 1.5366 / 4 )

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\speed, 1 * (~t/( 92.20/4/60 )),
			\dur, 2,
			\gain, 1,
		)

(
	// OK: proof that 1 beat = 1 loop with this tempo
	// in reality, a loop is 4 beats, but with divide the tempo by 4
	~t = 92.10/4/60; TempoClock.default.tempo = ~t;
Pdef(\part3, Pdef(\zed3, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\pos, Pseq([
				0,
			],inf),
			\dur, 1,
			\gain, 1,
		)
		
	])
)).play;
);
(
	// OK: proof that 2nd measure start at 2.61 seconds
	~t = 92.10/4/60; TempoClock.default.tempo = ~t;
Pdef(\part3, Pdef(\zed3, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 0.81,
			\pos, Pseq([
				2.61,
			],inf),
			\dur, 1,
			\gain, 1,
		)
		
	])
)).play;
);

(
	// OK: proof that we need to divide by tempo to get the 2nd measure
	// convert 1 beat into pos=2.61
	~t = 92.10/4/60; TempoClock.default.tempo = ~t;
Pdef(\part3, Pdef(\zed3, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 0.81,
			\pos, Pseq([
				0,1,2,3,
			],inf) / ~t, // in reality it is sampleTempo, but it is the same than tempo here
			\dur, 1,
			\gain, 1,
		)
		
	])
)).play;
);

(
	// OK: proof of working of pos: when speed is doubled, pos should not be changed (PlayBuf.ar)
	// but \dur should be divided by \speed
	~t = 92.10/4/60; TempoClock.default.tempo = ~t;
Pdef(\part3, Pdef(\zed3, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 0.81,
			\speed, 1.67,
			\pos, Pseq([
				1,
			],inf) / ~t,
			\dur, 1 / Pkey(\speed),
			\gain, 1,
		)
		
	])
)).play;
);

(
	// OK: proof of playing sample at another tempo: \speed should be multiplied by (~t/SampleTempo)
	// where SampleTempo is divided by 4 like ~t
	// \dur should not be changed
	~t = 122.20/4/60; TempoClock.default.tempo = ~t;
Pdef(\part3, Pdef(\zed3, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 0.81,
			\speed, 1 * ~t / ( 92.10/4/60 ),
			\pos, Pseq([
				0,
			],inf),
			\dur, 1,
			\gain, 1,
		)
		
	])
)).play;
);

(
	// OK: proof of playing 2nd measure of sample at another tempo, with normal relative speed
	~t = 122.20/4/60; TempoClock.default.tempo = ~t;
Pdef(\part3, Pdef(\zed3, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 0.81,
			\speed, (~t/( 92.10/4/60 )),
			\pos, Pseq([
				0, 1, 2, 3,
			],inf) / ~t * (~t/( 92.10/4/60 )),
			\dur, 1,
			\gain, 1,
		)
		
	])
)).play;
);

(
	////////// Ultimate Proof
	// OK: proof of relation between \speed, \dur and \pos
	~t = 102.20/4/60; TempoClock.default.tempo = ~t;
	~t = 72.20/4/60; TempoClock.default.tempo = ~t;
	// speed = targetSpeed * tempoRatio
	// pos = beatPos / currentTempo * tempoRatio
	// dur = 1 / targetSpeed
Pdef(\part3, Pdef(\zed3, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 0.81,
			\targetSpeed, 2,
			\sampleTempo, 92.10/4/60,
			\speed, Pkey(\targetSpeed) * ~t / Pkey(\sampleTempo),
			\pos, Pseq([
				0, 1, 2, 3,
			],inf) / Pkey(\sampleTempo),
			\dur, 1/Pkey(\targetSpeed),
			\gain, 1,
		)
		
	])
)).play;
);

(
	////////// Ultimate Proof alternate
	// OK: proof of relation between \speed, \dur and \pos
	~t = 122.20/4/60; TempoClock.default.tempo = ~t;
	~t = 102.20/4/60; TempoClock.default.tempo = ~t;
	// speed = targetSpeed * tempoRatio
	// pos = beatPos / currentTempo * tempoRatio
	// dur = 1 / targetSpeed
Pdef(\part3, Pdef(\zed3, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 0.81,
			\targetSpeed, 2,
			\tempoRatio, ~t/( 92.20/4/60 ),
			\speed, Pkey(\targetSpeed) * Pkey(\tempoRatio),
			\pos, Pseq([
				0, 1, 2, 3,
			],inf) / ~t * Pkey(\tempoRatio),
			\dur, 1/Pkey(\targetSpeed),
			\gain, 1,
		)
		
	])
)).play;
);


(
	// working with division of beat to make breakbeat
	// here pos is divided by \division for (0..7) to remain a continuous play
	// \dur need to be divided by \division for having shorter notes as segments are shorter
	~t = 122.20/4/60; TempoClock.default.tempo = ~t;
	~t = 102.20/4/60; TempoClock.default.tempo = ~t;
Pdef(\part3, Pdef(\zed3, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 0.81,
			\targetSpeed, 1,
			\division, 4,
			\tempoRatio, ~t/( 92.20/4/60 ),
			\speed, Pkey(\targetSpeed) * Pkey(\tempoRatio),
			\pos, Pseq([
				0, 1, 2, 3,
			],inf)/Pkey(\division) / ~t * Pkey(\tempoRatio),
			\dur, 1/Pkey(\targetSpeed)/Pkey(\division),
			\gain, 1,
		)
		
	])
)).play;
);

(
	// good way to make breakbeat:
	// use a small \dur, do not divide \pos, use 0, 1 as measures, the start of each measure is cool
Pdef(\part3, Pdef(\zed3, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\targetSpeed, 1,
			\division, 2,
			\tempoRatio, ~t/( 92.20/4/60 ),
			\speed, Pkey(\targetSpeed) * Pkey(\tempoRatio),
			\pos, Pseq([
				Pseq((0..7)/8),
				Pseq((0..7)/4),
				0, 1, 2, 3,
				Pseq((0..3)/4+3),
			],inf) / ~t * Pkey(\tempoRatio),
			//\legato, Pseq([
				//3,0,0,1,
			//],inf),
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/Pkey(\targetSpeed)/8,
			\gain, 1,
		)
		
	])
)).play;
);

(
	// better to not change \dur with speed to keep time, but changing speed give good results
Pdef(\part3, Pdef(\zed3, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\targetSpeed, Pseq([1,1,1,2],inf),
			\division, 2,
			\tempoRatio, ~t/( 92.20/4/60 ),
			\speed, Pkey(\targetSpeed) * Pkey(\tempoRatio),
			\pos, Pseq([
				Pseq((0..7)/8 + (1/2)),
				Pseq((0..7)/8),
				Pseq((0..7)/4),
				0, 1, 2, 3,
				Pseq((0..3)/4+3),
			],inf) / ~t * Pkey(\tempoRatio),
			//\legato, Pseq([
				//3,0,0,1,
			//],inf),
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\mixer3, \audio),
			\gain, 1,
		)
		
	])
)).play;
);

(
	//// poorman's timeStretch
	// cut the sample to change its tempo without changing the pitch
Pdef(\part3, Pdef(\zed3, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1.3,
			\targetSpeed, 1,
			\sampleTempo, 92.15/4/60,
			\speed, Pkey(\targetSpeed),
			\pos, Pseq([
				Pseq((0..63))/16
			],inf) / Pkey(\sampleTempo),
			\dur, 1/16,
			\gain, 1,
		)
		
	])
)).play;
);

(
	// compare with adapted speed changing the pitch
Pdef(\part3, Pdef(\zed3, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\targetSpeed, 1,
			\tempoRatio, ~t/( 92.15/4/60 ),
			\speed, Pkey(\targetSpeed) * Pkey(\tempoRatio),
			\pos, Pseq([
				0, 1, 2, 3,
			],inf) / ~t * Pkey(\tempoRatio),
			\dur, 1/Pkey(\targetSpeed),
			\gain, 1,
		)
		
	])
)).play;
)

(
	//// poorman's pitchStretch
	// vary speed to change to pitch with same tempo
Pdef(\part3, Pdef(\zed3, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1.3,
			\sampleTempo, 92.15/4/60,
			\speed, Pseg(Pseq([1,2,1/2],inf),8),
			\pos, Pseq([
				Pseq((0..63))/16
			],inf) / Pkey(\sampleTempo),
			\dur, 1/16,
			\gain, 1,
		)
		
	])
)).play;
);

(
	//// poorman's tape stutter
	// vary speed to change to pitch with same tempo
Pdef(\part3, Pdef(\zed3, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1.3,
			\sampleTempo, 92.15/4/60,
			\freeze, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,1,0,
				1,1,1,0, 0,0,0,0,
				0,0,0,0, 1,1,1,0,
			],inf),
			\pos, Pseq([
						Prout({ arg ev;
							var str = Pseq((0..63)/16,inf).asStream;
							var memory;
							inf.do {
								var val = str.next;
								if(ev[\freeze] == 1) {
									if(memory.isNil) {
										memory = val;
									};
									ev = memory.yield(ev);
								} {
									ev = val.yield(ev);
									memory = nil;
								}
							}
						})
			],inf) / Pkey(\sampleTempo),
			\dur, 1/16,
			\gain, 1,
		)
		
	])
)).play;
);

(
	// random variations + freeze
Pdef(\part3, Pdef(\zed3, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1.3,
			\sampleTempo, 92.15/4/60,
			//\speed, Pseg(Pseq([1,2,1/2],inf),Pseq([1,4,2,1/2],inf)),
			//\speed, Ndef(\lfo1, { SinOsc.kr(1/8 * ( SinOsc.kr(0.3) * 1 + 1 )).range(1/2,2) }),

			\freeze, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				Prand(
					[
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,1,0,
					1,1,1,0, 0,0,0,0,
					0,0,0,0, 1,1,1,0,
					].clump(8).collect(Pseq(_))
				,1),
			],inf),
			\pos, Pseq([
						Prout({ arg ev;
							var str = Pseq([
								Pser((0..63)/16,8),
								Pser((0..63)+48/16,8),
								Pser((0..63)/16,8),
								Pser((0..63),4)+Pwhite(0,16,inf)+8/16,
								Pser((0..63),4)+12/16,
							],inf).asStream;
							var memory;
							inf.do {
								var val = str.next;
								if(ev[\freeze] == 1) {
									if(memory.isNil) {
										memory = val;
									};
									ev = memory.yield(ev);
								} {
									ev = val.yield(ev);
									memory = nil;
								}
							}
						})
			],inf) / Pkey(\sampleTempo),
			\dur, 1/16,
			\gain, 1,
		)
		
	])
)).play;
);

////////////////////////////////////////////////////

// split
(
	// dnb
Pdef(\part3, Pdef(\zed3, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\targetSpeed, 1,
			\division, 8,
			\tempoRatio, ~t/( 92.20/4/60 ),
			\speed, Pkey(\targetSpeed) * Pkey(\tempoRatio),
			\pos, Pseq([
				0, 1, 2, 3,
				4, 5, 6, 7,
			],inf)/Pkey(\division) / ~t * Pkey(\tempoRatio),
			//\legato, Pseq([
				//3,0,0,1,
			//],inf),
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/Pkey(\targetSpeed)/Pkey(\division),
			\gain, 1,
		)
		
	])
)).play;
);


				(
					(
						Pseq([
							1,1,1,1, 0,0,0,0,
							1,1,1,1, 1,1,1,1,
						],inf)
					).asStream.nextN(10)
				)

				(
				Pclutch( 
					Pseq((0..63)),
					Pseq([
						1,1,1,1, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
					],inf)
				).asStream.nextN(10)
				)


~t = 185/4/60; TempoClock.default.tempo = ~t;
~t = 92.20/4/60; TempoClock.default.tempo = ~t;

(
	~t = 82.20/4/60; TempoClock.default.tempo = ~t;
Pdef(\part3, Pdef(\zed3, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1719].value,
			\sustain, 0.11,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1360].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\targetSpeed, 1,
			\tempoRatio, ~t/( 92.20/4/60 ),
			\speed, Pkey(\targetSpeed) * Pkey(\tempoRatio),
			\pos, Pseq([
				3,
			],inf) / ~t * Pkey(\tempoRatio),
			\dur, 1/Pkey(\targetSpeed),
			\gain, 1,
		)
		
	])
)).play;
);


(
	// dnb
Pdef(\part3, Pdef(\zed3, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\speed, 1,
			\loop, 0,
			\pos, Pseq([
				100,10,10,
				0,1/8
			],inf) * ~t,
			\dur, 1/2,
			\gain, 1,
		)
		
	])
)).play;
);

/////////////////////////////////
/// change pitch according to tempo
Pbind(
	//\instrument, \basicbass,
	\note, Pstep(Pseq([
		0,0,5,7,
	],inf)-4, 1),
	\freq, Pkey(\freq) *  ~t * 1/8/(1/12.57), // here!!! (size of mesure: 12.57s)
	\octave, 3,
	\legato, 0.3,
	\legato, Pseq([
		0,0,0,0, 2,0,0,0,
	],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	\lpfr, 3,
	\dur, 1/8,
	\amp, 0.6,
	\out, BusDef(\mixer5, \audio),
),
