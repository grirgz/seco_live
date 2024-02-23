
~t = 190/4/60; TempoClock.default.tempo = ~t;


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1417].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,1,
				Plazy({ arg ev;
					Pseq([
						0,0,0,0, 0,0,0,0,
					],rrand(1,5))
				}),
				0,0,1,0, 1,0,0,0,
				Plazy({ arg ev;
					Pseq([
						0,0,0,0, 0,0,0,0,
					],rrand(1,5))
				}),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\ifx2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[355].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				Plazy({ arg ev;
					Pseq([
						0,0,0,0, 0,0,0,0,
					],rrand(1,5))
				}),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.21,
			\out, BusDef(\ifx2, \audio),
		),
		Pfindur(32,Pmono(\fuller,
			\fspread, ~pmodenv.(Pseq([0.001,0.1,1],1), 8).loop,
			\midinote, 36,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		)),		
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\verbmix, 1.0,
			\room, 2.5,
			\damp, 0.5,
			\mix, 0.5,
			\gain, 1.0,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\ifx2, \audio),
			\delay, 2.0/~t,
			\damp, 0.0,
			\size, 0.1,
			\diff, 0.03700001716614,
			\fb, 0.89999997615814,
			\modDepth, 1.00000000149012,
			\modFreq, 2.0,
			\mix, 0.5,
			\gain, 1.0,
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
			\bufnum, ~buflib.kick[1417].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,1,
				Plazy({ arg ev;
					Pseq([
						0,0,0,0, 0,0,0,0,
					],rrand(1,5))
				}),
				0,0,1,0, 1,0,0,0,
				Plazy({ arg ev;
					Pseq([
						0,0,0,0, 0,0,0,0,
					],rrand(1,5))
				}),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\ifx2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[355].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				Plazy({ arg ev;
					Pseq([
						0,0,0,0, 0,0,0,0,
					],rrand(1,5))
				}),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.21,
			\out, BusDef(\ifx2, \audio),
		),
		Pfindur(32*2,Pmono(\fuller,
			\fspread, ~pmodenv.(Pseq([0.00001,0.001,0.002,0.1],1), 8).loop,
			\lpfr, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\note, Pseq([
				0,-3,
			],inf),
			\octave, 2,
			\dur, 8,
			\amp, 0.1,
			//\out, BusDef(\ifx1, \audio),
			\out, BusDef(\sendbus1, \audio),
		)),		
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\verbmix, 1.0,
			\room, 2.5,
			\damp, 0.5,
			\mix, 0.5,
			\gain, 1.0,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\ifx2, \audio),
			\delay, 2.0/~t,
			\damp, 0.0,
			\size, 0.1,
			\diff, 0.03700001716614,
			\fb, 0.89999997615814,
			\modDepth, 1.00000000149012,
			\modFreq, 2.0,
			\mix, 0.5,
			\gain, 1.0,
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
			\bufnum, ~buflib.kick[1417].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2435].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\legato, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[355].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.51,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vbreaks/Funk Brothers - Home Cookin.wav'),
			\legato, 1,
			\st, 110/2/60,
			\speed, 1.1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			],1),8).loop / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0.7,0.9,0.6, 1,0.7,0.9,0.6,
				0,0,0,0, 0,1,1,1, 
				1,0.7,0.9,0.6, 1,0.7,0.9,0.6,
				0.3,0.3,0.3,0.3, 0.3,0.9,0.9,0.9, 
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
		),
		Pfindur(32*2,Pmono(\fullerchord,
			\fspread, ~pmodenv.(Pseq([0.00001,0.001,0.002,0.1],11), 8).loop,
			\lpfr, ~pmodenv.(Pseq([1,2,1,4,1,12],11), 8).loop,
			\chord, Pseq([
				[ ( [0,3,7,10,14,17] +.x ( 12 * (0..6) ) ) ],
				[ ( [0,3,7,9,13,16] +.x ( 12 * (0..6) ) ) ],
				[ ( [0,3,7,9,14,17] +.x ( 12 * (0..6) ) ) ],
				[ ( [0,3,7,10,13,17] +.x ( 12 * (0..6) ) ) ],
			],inf),
			\note, Pseq([
				0,-3,
			],inf),
			\octave, 2,
			\dur, 8,
			\amp, 0.1,
			//\out, BusDef(\ifx1, \audio),
			\out, BusDef(\sendbus1, \audio),
		)),		
	])
)).play;
);



(
	// good
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1417].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.25,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2435].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\legato, Pseq([
				//Pseq([
					//0.2,
				//],8*12),
				Pseq([
					0.2, 0.2, 0.2, 0.2,
					1,1,1,1, 1,0.1,0.1,0.1,
					0.9,
				],8*4),
			],inf) * Pseq([
				0.8,0.8,0.8,0.8, 1,0.8,0.8,0.8,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,

				0,0,0,0, 1,0,0,0,
				0,0,0,1, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,1,1,0, 1,0,0,1,

			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				0.7,0.7,0.7,0.7, 1,0.7,0.7,0.7,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1433].value,
			\bufnum, ~buflib.hat[751].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					0,0,1,0, 0,0,1,0,
				],8),
				Pseq([
					1,0,1,0, 1,0,1,0, 
				],8),
				Pseq([
					0,1,1,0, 1,0,1,0,
					1,0,0,1, 1,0,1,0,
				],8),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.06,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[355].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 

				1,0,1,0, 1,0,1,1, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,1, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 

				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,1, 1,0,0,0, 

				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.51,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vbreaks/Funk Brothers - Home Cookin.wav'),
			\legato, 1,
			\st, 110/2/60,
			\speed, 1.1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			],1),8).loop / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				0.5,0.5,0.5, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0.5,0.5,0.5, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0.7,0.9,0.6, 1,0.7,0.9,0.6,
				0,0,0,0, 0,1,1,1, 
				1,0.7,0.9,0.6, 1,0.7,0.9,0.6,
				0.3,0.3,0.3,0.3, 0.3,0.9,0.9,0.9, 
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			\st, 272/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+4,1),2).loop / Pkey(\st),
			\isRest, Pseq([
				//1,0.7,0.9,0.6, 1,0.7,0.9,0.6,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					1,1,0,1, 0.5,0.5,0.5,0.5,
					1,1,0,1, 0.5,0.5,0.5,0.5,
					0,0,1,0, 0.5,0.5,0.5,0.5,
					1,1,0,1, 0.5,0.5,0.5,0.5,
				],8),
				//1,0.7,0.9,0.6, 1,0.7,0.9,0.6,
				//0.3,0.3,0.3,0.3, 0.3,0.9,0.9,0.9, 
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),

			\dur, 1/8,
			\gain, 1/8,
		),
		Pfindur(32*2,Pmono(\fullerchord,
			\fspread, ~pmodenv.(Pseq([0.00001,0.001,0.002,0.1],11), 8).loop,
			\lpfr, ~pmodenv.(Pseq([1,2,1,4,1,12],11), 8).loop,
			\chord, Pseq([
				[ ( [0,3,7,10,14,17] +.x ( 12 * (0..6) ) ) ],
				[ ( [0,3,7,9,13,16] +.x ( 12 * (0..6) ) ) ],
				[ ( [0,3,7,9,14,17] +.x ( 12 * (0..6) ) ) ],
				[ ( [0,3,7,10,13,17] +.x ( 12 * (0..6) ) ) ],
			],inf),
			\note, Pseq([
				0,-3,
			],inf),
			\octave, 2,
			\dur, 8,
			\amp, 0.1,
			//\out, BusDef(\ifx1, \audio),
			\out, BusDef(\sendbus1, \audio),
		)),		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1417].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.25,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2435].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\legato, Pseq([
				//Pseq([
					//0.2,
				//],8*12),
				Pseq([
					0.2, 0.2, 0.2, 0.2,
					1,1,1,1, 1,0.1,0.1,0.1,
					0.9,
				],8*4),
			],inf) * Pseq([
				0.8,0.8,0.8,0.8, 1,0.8,0.8,0.8,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,

				0,0,0,0, 1,0,0,0,
				0,0,0,1, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,1,1,0, 1,0,0,1,

			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				0.7,0.7,0.7,0.7, 1,0.7,0.7,0.7,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1433].value,
			\bufnum, ~buflib.hat[751].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					0,0,1,0, 0,0,1,0,
				],8),
				Pseq([
					1,0,1,0, 1,0,1,0, 
				],8),
				Pseq([
					0,1,1,0, 1,0,1,0,
					1,0,0,1, 1,0,1,0,
				],8),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.06,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[355].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 

				1,0,1,0, 1,0,1,1, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,1, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 

				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,1, 1,0,0,0, 

				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.51,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vbreaks/Funk Brothers - Home Cookin.wav'),
			\legato, 1,
			\st, 110/2/60,
			\speed, 1.1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			],1),8).loop / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				0.5,0.5,0.5, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0.5,0.5,0.5, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0.7,0.9,0.6, 1,0.7,0.9,0.6,
				0,0,0,0, 0,1,1,1, 
				1,0.7,0.9,0.6, 1,0.7,0.9,0.6,
				0.3,0.3,0.3,0.3, 0.3,0.9,0.9,0.9, 
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			\st, 272/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+4,1),2).loop / Pkey(\st),
			\isRest, Pseq([
				//1,0.7,0.9,0.6, 1,0.7,0.9,0.6,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					1,1,0,1, 0.5,0.5,0.5,0.5,
					1,1,0,1, 0.5,0.5,0.5,0.5,
					0,0,1,0, 0.5,0.5,0.5,0.5,
					1,1,0,1, 0.5,0.5,0.5,0.5,
				],8),
				//1,0.7,0.9,0.6, 1,0.7,0.9,0.6,
				//0.3,0.3,0.3,0.3, 0.3,0.9,0.9,0.9, 
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),

			\dur, 1/8,
			\gain, 1/8,
		),
		Pfindur(32*2,Pmono(\fullerchord,
			\fspread, ~pmodenv.(Pseq([0.00001,0.001,0.002,0.1],11), 8).loop,
			\lpfr, ~pmodenv.(Pseq([1,2,1,4,1,12],11), 8).loop,
			\chord, Pseq([
				[ ( [0,3,7,10,14,17] +.x ( 12 * (0..6) ) ) ],
				[ ( [0,3,7,9,13,16] +.x ( 12 * (0..6) ) ) ],
				[ ( [0,3,7,9,14,17] +.x ( 12 * (0..6) ) ) ],
				[ ( [0,3,7,10,13,17] +.x ( 12 * (0..6) ) ) ],
			],inf),
			\note, Pseq([
				0,-3,
			],inf),
			\octave, 2,
			\dur, 8,
			\amp, 0.1,
			//\out, BusDef(\ifx1, \audio),
			\out, BusDef(\sendbus1, \audio),
		)),		
		Pfindur(32*2,Pmono(\fullerchord,
			\fspread, ~pmodenv.(Pseq([0.00001,0.001],11), 8).loop,
			\lpfr, ~pmodenv.(Pseq([1,1/2],11), 8).loop,
			\chord, Pseq([
				[ ( [0,3,7,10,14,17] +.x ( 0!6 ) ) ],
			],inf),
			\note, Pseq([
				0,0,0,-1,0,0,0,-3,
			],inf),
			\octave, 2,
			\dur, 1,
			\amp, 0.1,
			//\out, BusDef(\ifx1, \audio),
			\out, BusDef(\sendbus2, \audio),
		)),		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1417].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.25,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2435].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\legato, Pseq([
				//Pseq([
					//0.2,
				//],8*12),
				Pseq([
					0.2, 0.2, 0.2, 0.2,
					1,1,1,1, 1,0.1,0.1,0.1,
					0.9,
				],8*4),
			],inf) * Pseq([
				0.8,0.8,0.8,0.8, 1,0.8,0.8,0.8,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,

				0,0,0,0, 1,0,0,0,
				0,0,0,1, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,1,1,0, 1,0,0,1,

			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				0.7,0.7,0.7,0.7, 1,0.7,0.7,0.7,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1433].value,
			\bufnum, ~buflib.hat[751].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					0,0,1,0, 0,0,1,0,
				],8),
				Pseq([
					1,0,1,0, 1,0,1,0, 
				],8),
				Pseq([
					0,1,1,0, 1,0,1,0,
					1,0,0,1, 1,0,1,0,
				],8),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.06,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[355].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 

				1,0,1,0, 1,0,1,1, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,1, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 

				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,1, 1,0,0,0, 

				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.51,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vbreaks/Funk Brothers - Home Cookin.wav'),
			\legato, 1,
			\st, 110/2/60,
			\speed, 1.1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			],1),8).loop / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\pos, Pseq([
				Pseq([ 
					0!12,
					(0..3)
				
				].flat,inf) + Pseq((0..21)*3+7,inf).stutter(1),
				
			],inf)/8/ Pkey(\st),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,0,1, 1,0,1,1,
			]/1.5,inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vbreaks/Funk Brothers - Home Cookin.wav'),
			\legato, 1,
			\st, 110/2/60,
			\speed, 1.1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			],1),8).loop / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\pos, Pseq([
				Pseq([ 
					0!12,
					(0..3)
				
				].flat,inf) + Pseq((0..21)*2,inf).stutter(8*3),
				
			],inf)/8/ Pkey(\st),
			\isRest, Pseq([
				0,0,1,0, 0,0,0,0,
				0,1,1,0, 0,0,0,0,
			]/1.1,inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vbreaks/Funk Brothers - Home Cookin.wav'),
			\legato, 1,
			\st, 110/2/60,
			\speed, 1.1 * Pwhite(0.99,1.01,inf) * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			],1),8).loop / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\pos, Pseq([
				Pseq([ 
					38!4,
					38!4,
					38!4,
					(0..3)+38
				
				].flat,inf) + Pseq((0..21)-20,inf).stutter(8*4),
				
			],inf)/8/ Pkey(\st),
			\isRest, Pseq([
				0.5,0.5,0.5, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0.5,0.5,0.5, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0.7,0.9,0.6, 1,0.7,0.9,0.6,
				0,0,0,0, 0,1,1,1, 
				1,0.7,0.9,0.6, 1,0.7,0.9,0.6,
				0.3,0.3,0.3,0.3, 0.3,0.9,0.9,0.9, 
			],inf).coin.not,
			\isRest, Pseq([
				1,0,0,1, 1,1,1,1,
				1,0,0,1, 1,1,1,1,
				1,0,0,1, 1,1,1,1,
				1,0,0,1, 1,1,1,1,

				1,0,0,1, 1,1,1,1,
				1,0,0,1, 1,1,1,1,
				1,0,0,1, 1,1,1,1,
				1,0,0,1, 1,1,0,1,

				1,0,0,1, 1,1,1,1,
				1,0,0,1, 1,1,1,1,
				1,0,0,1, 1,1,1,1,
				1,0,0,1, 1,1,1,1,

				1,0,0,1, 1,1,1,1,
				1,0,0,1, 1,1,1,1,
				1,0,0,1, 1,1,1,1,
				1,1,0,1, 0,0,0,1,
			]/1.1,inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
		),
	])
)).play;
);

(
SynthDef(\fuller, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var chord = [0,3,7,12,7-12].midiratio;
	sig = chord.collect { arg tone;
		SinOsc.ar(freq * tone * ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1));
	};
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
	~chanOpener = { arg door, array;
		array * ( door - ((0..array.size-1)/(array.size) ).postln * array.size ).clip(0,1);
	};
SynthDef(\fuller, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var chord = ( [0,3,7] +.x ( 12 * (0..6) ) ).midiratio;
	sig = chord.collect { arg tone;
		SinOsc.ar(freq * tone * ((0..7)/7 - 0.5 * \fspread.kr(0.01) + 1));
	};
	//sig = sig.flop.mean;
	sig = sig.flat;
	sig = ~chanOpener.( Line.ar(0,1,40), sig );
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
	~chanOpener = { arg door, array;
		array * ( door - ((0..array.size-1)/(array.size) ).postln * array.size ).clip(0,1);
	};
SynthDef(\fuller, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var chord = ( [0,3,7,10,14] +.x ( 12 * (0..5) ) ).midiratio;
	sig = chord.collect { arg tone;
		var isig;
		isig = LFSaw.ar(freq * tone * ((0..7)/7 - 0.5 * \fspread.kr(0.01) + 1));
		isig = RLPF.ar(isig, ( \lpfr.kr(1.1) * freq * tone ).clip(20,20000), \rq.kr(0.5));
		isig;
	};
	sig = ~chanOpener.( Line.ar(0,1,40), sig );
	sig = sig.mean * 4.4;
	//sig = sig.flat * 1.10;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
	~chanOpener = { arg door, array;
		array * ( door - ((0..array.size-1)/(array.size) ).postln * array.size ).clip(0,1);
	};
SynthDef(\fullerchord, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var chord = \chord.kr( ( [0,3,7,10,14,17] +.x ( 12 * (0..6) ) ) ).midiratio;
	sig = chord.collect { arg tone;
		var isig;
		isig = LFSaw.ar(freq * tone * ((0..7)/7 - 0.5 * \fspread.kr(0.01) + 1));
		isig = RLPF.ar(isig, ( \lpfr.kr(1.1) * freq * tone ).clip(20,20000), \rq.kr(0.5));
		isig;
	};
	sig = ~chanOpener.( Line.ar(0,1,40), sig );
	sig = sig.mean * 4.4;
	//sig = sig.flat * 1.10;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


///// chanOpener draft
(
	~chanOpener = { arg door, array;
		array * ( door - ((0..array.size-1)/(array.size) ).postln * array.size ).clip(0,1);
	};
	~chanOpener.(0.21,1!10)
)

(
	~chanOpener = { arg door, array;
		[
			array[0] * ( door * 10 ).clip(0,1),
			array[1] * ( door - 0.1 * 10 ).clip(0,1),
			array[2] * ( door - 0.2 * 10 ).clip(0,1),
			array[3] * ( door - 0.3 * 10 ).clip(0,1),
		]
	};
	~chanOpener.(0.15,[1,1,1,1])
)


////////////////////////////////////////////////////////////
/// bees


(
SynthDef(\bee, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, freqfac=1, ampfac=1, facfac=1;
	var sig;
	var pearlamp, pearlfreq;
	pearlfreq = { arg depth, isig=1;
		depth.do { arg idx;
			var fac = 2**(idx) * facfac;
			isig = isig * ( LFNoise1.ar(fac*2*freqfac).bipolar * 1/fac/4*ampfac + 1 )
		};
		isig;
	};
	sig = LFPulse.ar(pearlfreq.(4, freq));
	sig = RHPF.ar(sig, ( \lpfr.kr(4.1) * pearlfreq.(4,freq) ).clip(20,20000), \rq.kr(0.5) * pearlfreq.(4));
	//sig = SinOsc.ar(freq) ;
	sig = pearlfreq.(4, sig);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan + ( pearlfreq.(1) - 1 *4), amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono( \bee,
			\freq, 70,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\ruche, 
	Ppar([
		Pspawner({ arg sp;
			1000.do { arg item, idx;

				sp.par(
					Pfindur(rrand(10.0,40), Pmono( \bee,
						\freq, rrand(50.0,110.0),
						\freqfac, rrand(1/5,5),
						\adsr, Pseq([
							[ Env.adsr(3.1,0.1,0.8,1.1) ],
						],inf),
						\dur, 1,
						\amp, 0.1,
					)),

				);
				rrand(5.0,11).wait;
			};
		}),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\ruche, 
	Ppar([
		Pspawner({ arg sp;
			20.do { arg item, idx;

				sp.par(
					Pfindur(rrand(10.0,40), Pmono( \bee,
						\freq, rrand(50.0,110.0),
						\freqfac, rrand(1/5,5),
						\ampfac, 0.5,
						\adsr, Pseq([
							[ Env.adsr(3.1,0.1,0.8,1.1) ],
						],inf),
						\dur, 1,
						\amp, 0.1,
					)),

				);
				rrand(2.0,6).wait;
			};
		}),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\ruche, 
	Ppar([
		Pspawner({ arg sp;
			20.do { arg item, idx;

				sp.par(
					Pfindur(rrand(10.0,40), Pmono( \bee,
						\freq, exprand(50.0,410.0),
						\freqfac, rrand(1/5,5),
						\ampfac, exprand(0.1,1),
						\lpfr, rrand(1.0,6),
						\adsr, Pseq([
							[ Env.adsr(3.1,0.1,0.8,1.1) ],
						],inf),
						\dur, 1,
						\amp, 0.1,
					)),

				);
				rrand(2.0,6).wait;
			};
		}),
		
	])
)).play;
);

(
	// risset
Pdef(\part, Pdef(\ruche, 
	Ppar([
		Pspawner({ arg sp;
			40.do { arg item, idx;

				sp.par(
					Pfindur(40, Pmono( \bee,
						\freq, ~pmodenv.(Pseq([1,8]*50,1), 8).loop,
						\freqfac, exprand(1/5,5),
						\ampfac, exprand(0.1,1),
						\lpfr, rrand(1.0/6,6),
						\adsr, Pseq([
							[ Env.adsr(4.1,0.1,0.8,4.1) ],
						],inf),
						\dur, 1,
						\amp, 0.1,
					)),

				);
				//rrand(102.0,6).wait;
				1.wait;
			};
		}),
		
	])
)).play;
);

(
SynthDef(\beemutante, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, freqfac=1, ampfac=1, facfac=1;
	var sig;
	var pearlamp, pearlfreq;
	pearlamp = { arg depth, isig=1;
		depth.do { arg idx;
			var fac = 2**(idx) * facfac;
			isig = isig * ( LFNoise1.ar(fac*2*freqfac).bipolar * 1/fac/4*ampfac + 1 )
		};
		isig;
	};
	pearlfreq = { arg depth, isig=1;
		depth.do { arg idx;
			var fac = 2**(idx) * facfac;
			isig = isig * ( LFNoise1.ar(fac*2*freqfac).bipolar * 1/fac/4*ampfac + 1 );
			isig = isig * (Duty.kr(exprand(0.1,2), 0, Dseq([
				1,4,1/2,2
			],inf)) * 1/fac*ampfac + 1);
		};
		isig;
	};
	sig = LFPulse.ar(pearlfreq.(4, freq));
	sig = RHPF.ar(sig, ( \lpfr.kr(4.1) * pearlfreq.(4,freq) ).clip(20,20000), ( \rq.kr(0.5) * pearlfreq.(4) ).clip(0.1,1));
	//sig = SinOsc.ar(freq) ;
	sig = pearlamp.(4, sig);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan + ( pearlfreq.(1) - 1 *4), amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\ruche, 
	Ppar([
		Pspawner({ arg sp;
			40.do { arg item, idx;

				sp.par(
					Pfindur(40, Pmono( \beemutante,
						\freq, ~pmodenv.(Pseq([1,8]*50,1), 8*8).loop,
						\freqfac, exprand(1/5,5),
						\ampfac, exprand(0.1,1),
						\lpfr, rrand(1.0/6,6),
						\adsr, Pseq([
							[ Env.adsr(4.1,0.1,0.8,4.1) ],
						],inf),
						\dur, 1,
						\amp, 0.1,
					)),

				);
				//rrand(102.0,6).wait;
				1.wait;
			};
		}),
		
	])
)).play;
);


[0,1] *.t [0,1]

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, 200,
			//\bla, Pseq((1..7)).integrate.trace,
			//\bla, Pseries().trace,
			\bla, ~islice.(Pseq((0..70)), 2, 10, 3).trace,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

Pseq((1..7)).integrate


(
~islice = { arg pat, start, end, step;
	Pselect({ arg it; it[0] % step == 0 }, Ptuple([Pseries(),Pdrop(start, Pfinval(end, pat))])).collect({ arg it; it[1] });
}
)

~islice.( Pseq((0..70)), 2, 40, 3 ).asStream.nextN(15)

(
Pseq((1..10)).do { arg item, idx;
	item.postln
	
};
)
