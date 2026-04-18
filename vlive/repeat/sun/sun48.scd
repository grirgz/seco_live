
(
~t = 155/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
FileSystemProject.loadOnce("holis/synthdef.scd");
//BufDef.reload('vipere/mia.flac');
SynthDef(\simplegran, { arg out=0, mix=0.5, gain=1, gate=1, mbufnum=0, pitch_stretch=1, pos=0, gdur=0.1, pan;
	var sig;
	var clk;
	var phase;
	clk = Impulse.ar(\gfreq.kr(40));
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = pos;
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, phase % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.ar(\asr.kr(Env.asr(0.01,1,0.01)),gate,doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1065].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1067].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1521].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[82].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,1,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[96].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1, 0,1, 0,1, 0,1,
				0,1, 0,0, 0,0, 0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vipere/mia.flac'),
			\legato, 1,
			\st, 138/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
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
			\bufnum, ~buflib.kick[1065].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1067].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1521].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[82].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,1,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[96].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1, 0,1, 0,1, 0,1,
				0,1, 0,0, 0,0, 0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vipere/mia.flac'),
			\st, 138/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, 0,
			\legato, Pseq([
				6,0,0,0, 0,0,6,0,
				0,0,0,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
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
			\bufnum, ~buflib.kick[1065].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1067].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,1, 0,0,1,0,
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1521].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[82].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,1,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[96].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1, 0,1, 0,1, 0,1,
				0,1, 0,0, 0,0, 0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vipere/mia.flac'),
			\st, 138/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, 0,
			\legato, Pseq([
				3,0,0,2, 0,0,3,0,
				0,0,2,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/8,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1065].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1067].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,1, 0,0,1,0,
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1521].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[82].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,1,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[96].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1, 0,1, 0,1, 0,1,
				0,1, 0,0, 0,0, 0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),

		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pdef(\drums1),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vipere/mia.flac'),
			\st, 138/4/60,
			\speed, 1 * ~t / Pkey(\st) * Pstep(Pseq([
				0, 0,0,2,
			],inf).midiratio, 1/2),
			\pos, 0,
			\legato, Pseq([
				3,0,0,2, 0,0,3,0,
				0,0,2,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);


/////////////

(
Pdef(\melo, 
	Pbind(
		\instrument, \default,
	)
)
);
FileSystemProject.load("libdef/piano.scd");
ProtoDef(\piano).startControl(Pdef(\melo))
ProtoDef(\piano).keys
ProtoDef(\piano).playergroup.elAt(0)[\play].asCompileString
ProtoDef(\piano).playergroup.elAt(0).play
Pdef(\melo).stop
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pdef(\drums1),
		Pbind(
			\instrument, \simplegran,
			\mbufnum, BufDef.mono('vipere/mia.flac'),
			\st, 138/4/60,
			\pitch_stretch, 1  * Pstep(Pseq([
				0, 0,0,5,
				0, 0,0,5,
				0, 0,0,5,
				-3, -3,-3,5-12,
			],inf).midiratio, 1/2),
			//\pos, ~pmodenv.(Pseq([0,1],1), 1/8* ~t / Pkey(\st)).loop,
			\pos, ~pmodenv.(Pseq([0,1],1), 1/4 / ~t* 138/4/60 ).loop,
			\legato, Pseq([
				3,0,0,2, 0,0,3,0,
				0,0,2,0, 4,0,0,0,
				0.8,1,0.7,1, 2,0,0,1,
				0,0.3,2,0, 4,0,0,0.3,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \saw,
			\lpfr, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\legato, Pseg(Pseq([0.9,0.1],inf),8*4),
			\adsr, Pseq([
				PpatEnv.adsr.(Pseq([0.041,0.01],inf),0.1,0.8,Pseq([0.1,0.01],inf)),
			],inf),
			\note, Pseq([
				Pseq([
					Pser([
						2,6,9,6,
					],8*3),
					Pser([
						2,6,11,2,
					],8*1),
				],3),
				Pser([
					4,6,9,6,
				],8*2),
				Pser([
					4,1,9,1,
				],8*2),
			],inf),
			\octave, Pseq([
				Pn(5,Pseq([1,5],inf)),6,Pn(7,Pwhite(1,3,1)),4
			],inf).stutter(3),
			\dur, 1/16,
			\amp, 0.1 * Pseq([
				Pwhite(0.8,1,1),
				Pwhite(0.1,0.5,1),
				Pwhite(0.1,0.7,1),
				Pwhite(0.1,0.5,1),
				Pwhite(0.1,0.5,1),
			],inf),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pdef(\drums1),
		Pbind(
			\instrument, \simplegran,
			\mbufnum, BufDef.mono('vipere/mia.flac'),
			\st, 138/4/60,
			\pitch_stretch, 1  * Pstep(Pseq([
				0, 7,2,7,
			]-2,inf).midiratio, 2/1),
			//\pos, ~pmodenv.(Pseq([0,1],1), 1/8* ~t / Pkey(\st)).loop,
			\pos, ~pmodenv.(Pseq([0,1,0.5],1), 1/4 / ~t* 138/4/60 ).loop,
			\legato, Pseq([
				2,0,2,0, 0,0,1,0,
				0,0,2,0, 2,0,1,1,
				4,0,0,0, 0,0,1,0,
				0,1,1,2, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \saw,
			\lpfr, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\legato, Pseg(Pseq([0.9,0.1],inf),8*4),
			\adsr, Pseq([
				PpatEnv.adsr.(Pseq([0.041,0.01],inf),0.1,0.8,Pseq([0.1,0.01],inf)),
			],inf),
			\note, Pseq([
				Pseq([
					Pser([
						0,4,7,4,
					],8*2),
					Pser([
						0,4,7,4,
					],8*2)+7,
					Pser([
						0,3,7,3,
					],8*2)+2,
					Pser([
						0,4,7,4,
					],8*2)+7,
				],3),
				//Pser([
					//4,6,9,6,
				//],8*2),
				//Pser([
					//4,1,9,1,
				//],8*2),
			],inf),
			\octave, Pseq([
				Pn(5,Pseq([1,5],inf)),6,Pn(7,Pwhite(1,3,1)),4
			],inf).stutter(3),
			\dur, 1/8,
			\amp, 0.1 * Pseq([
				Pwhite(0.8,1,1),
				Pwhite(0.1,0.5,1),
				Pwhite(0.1,0.7,1),
				Pwhite(0.1,0.5,1),
				Pwhite(0.1,0.5,1),
			],inf),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pdef(\drums1),
		Pbind(
			\instrument, \simplegran,
			\mbufnum, BufDef.mono('vipere/mia.flac'),
			\st, 138/4/60,
			\pitch_stretch, 2  * Pstep(Pseq([
				0, 7,2,7,
			]-2,inf).midiratio, 2/1),
			\gdur, PmodEnv(Pseq([0.01,0.2,0.1,0.4],1), 8).loop,
			\gfreq, PmodEnv(Pseq([1,20,40,1,40],1), 1).loop,
			//\pos, ~pmodenv.(Pseq([0,1],1), 1/8* ~t / Pkey(\st)).loop,
			//\pos, ~pmodenv.(Pseq([0,1,0.5],1), 1/4 / ~t* 138/4/60 ).loop,
			\pos, PmodEnv(Pseq([0.2,0.6,1,0,1],1), 1/1).loop,
			\legato, Pseq([
				2,0,2,0, 0,0,1,0,
				0,0,2,0, 2,0,1,1,
				4,0,0,0, 0,0,1,0,
				0,1,1,2, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \saw,
			\lpfr, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\legato, Pseg(Pseq([0.9,0.1],inf),8*4),
			\adsr, Pseq([
				PpatEnv.adsr.(Pseq([0.041,0.01],inf),0.1,0.8,Pseq([0.1,0.01],inf)),
			],inf),
			\note, Pseq([
				Pseq([
					Pser([
						0,4,7,4,
					],8*2),
					Pser([
						0,4,7,4,
					],8*2)+7,
					Pser([
						0,3,7,3,
					],8*2)+2,
					Pser([
						0,4,7,4,
					],8*2)+7,
				],3),
				//Pser([
					//4,6,9,6,
				//],8*2),
				//Pser([
					//4,1,9,1,
				//],8*2),
			],inf),
			\octave, Pseq([
				Pn(5,Pseq([1,5],inf)),6,Pn(7,Pwhite(1,3,1)),4
			],inf).stutter(3),
			\dur, 1/8,
			\amp, 0.1 * Pseq([
				Pwhite(0.8,1,1),
				Pwhite(0.1,0.5,1),
				Pwhite(0.1,0.7,1),
				Pwhite(0.1,0.5,1),
				Pwhite(0.1,0.5,1),
			],inf),
		),
		
	])
)).play;
);

FileSystemProject.load("capsule/PatKitDef_ksh.scd");
FileSystemProject.load("capsule/PatKitDef_bat.scd");
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				Pser([
					0,0,0, -5,0,0, 0,0,0, 0,0,4,
					0,0,-5, 0,0,0, 0,0,0, 0,0,4,
				],12*2),
				Pser([
					7,7,-3, 7,7,7, 7,7,5, 7,7,7,
				],12*2),
				Pser([
					2,2,-3, 2,2,2, 2,2,5, 2,2,2,
				],12*2),
				Pser([
					7,7,-3, 7,7,7, 7,7,5, 7,7,7,
				],12*2),
			],inf),
			\lpf, 302,
			\legato, Pseq([
				3,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 2,0,1,  2,0,1, 3,0,0,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/12,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1306].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				1,0,0, 0,0,0,  0,1,0, 0,0,0,
			],inf).coin.not,
			\sustain, 0.1/4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\dur, 1/12,
			\gain, 0.3 * Pseq([
				1,
			],inf),
			\out, BusDef(\drums, \audio),
		),
		PatKitDef(\ksh2b).asPattern(Pbind( // snare
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,1,  0,0,0, 1,0,0,
			],inf).coin.not,
			\sustain, 0.1/4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\dur, 1/12,
			\gain, 0.4 * Pseq([
				1,0.8,1,1,0.9,
			],inf),
			\out, BusDef(\drums, \audio),
		)),
		PatKitDef(\ksh2b).asPattern(Pbind( // ghost snare
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,1,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,1, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				1,0,1, 0,0,0,  0,0,0, 0,0,0,
			],inf).coin.not,
			\sustain, 0.1/4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\dur, 1/12,
			\gain, 0.2 * Pseq([
				1,0.8,1,1,0.9,
			],inf),
			\out, BusDef(\drums, \audio),
		)),
		PatKitDef(\ksh2b).asPattern(Pbind( // hat
			\kitIndex, 9,
			\isRest, Pseq([
				0,0,0, 1,0,1, 0,0,0, 1,0,0,
				0,0,0, 1,0,1, 0,0,0, 1,0,1,
				1,1,0, 1,0,1, 0,0,0, 1,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/12,
			\gain, 0.2 * Pseq([
				1,0.7,0.2, 1,0.7,0.2, 1,0.7,0.2, 1,0.7,0.9,
				1,0.7,0.2, 1,0.7,0.2, 1,0.7,0.8, 1,0.7,0.2,
			],inf),
			\amp, 0.1,
			\out, BusDef(\drums, \audio),
		)),
		PatKitDef(\ksh2b).asPattern(Pbind( // 4-floor hat, muted
			\kitIndex, 9,
			\isRest, Pseq([
				1,0,1,0,
				1,1,0,1,
				1,0,1,0,
				1,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/16,
			\gain, 0.2 * Pseq([
				1,1,1, 0.2,
			],inf),
			\amp, 0.1,
			\out, BusDef(\drums, \audio),
			\isRest, true,
		)),
		PatKitDef(\ksh2b).asPattern(Pbind( // muted hat, don't know
			\kitIndex, 9,
			\isRest, Pseq([
				1,0,0, 0,0,0, 1,0, 0,0, 1,0, 
				0,0,1, 1,0,1, 1,0, 0,0, 0,0, 
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/24,
			\gain, 0.2 * Pseq([
				1,1,1,
				1,0.2,0.2,
			],inf),
			\amp, 0.1,
			\out, BusDef(\drums, \audio),
			\isRest, true,
		)),

		Pmono(\simpletrackmixer,
			\inbus, BusDef(\drums),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0,
			\sendbus0, BusDef(\sendbus0, \audio, 2),
			\dur, 1,
		),

		Pbind(
			\instrument, \organ,
			\out, BusDef(\organs, \audio),
			\note, Pseq([
				Pser([
					[0,4,7-12]+12,
				],12*2),
				Pser([
					[2,7,11-12]+12,
				],12*2),
				Pser([
					[2,5,11-12]+12,
				],12*2),
				Pser([
					[2,7,11-12]+12,
				],12*2),
			],inf),
			\sustain, Ptuple(Pwhite(0.02,0.05)!4),
			\isRest, Pseq([
				0,0,0, 1,0,0, 0,0,0, 1,0,0,
			],inf).coin.not,
			\dur, 1/12,
			\amp, 0.1 * Pseq([
				1
			],inf),
		),
		Pbind(
			\instrument, \organ,
			\out, BusDef(\organs, \audio),
			\note, Pseq([
				Pser([
					0,
				],12*2),
				Pser([
					7,
				],12*2),
				Pser([
					2,
				],12*2),
				Pser([
					2,
				],12*2),
			],inf),
			\sustain, Pwhite(0.04,0.08),
			\isRest, Pseq([
				1,0,0, 0,0,0, 1,0,0, 0,0,0,
				1,0,0, 0,0,1, 0,0,1, 0,0,0,
				0,0,1, 0,0,0, 1,0,0, 0,0,0,
			],inf).coin.not,
			\dur, 1/12,
			\amp, 0.1 * Pseq([
				1
			],inf),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\organs),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0,
			\sendbus0, BusDef(\sendbus0, \audio, 2),
			\dur, 1,
		),


		Pbind(
			\instrument, \simplegran,
			\mbufnum, BufDef.mono('vipere/mia.flac'),
			\st, 138/4/60,
			\pitch_stretch, 2  * Pstep(Pseq([
				0, 7,2,7,
			]-2,inf).midiratio, 2/1),
			\gdur, PmodEnv(Pseq([0.01,0.2,0.1,0.4],1), 8).loop,
			\gfreq, PmodEnv(Pseq([1,20,40,1,40],1), 1).loop,
			//\pos, ~pmodenv.(Pseq([0,1],1), 1/8* ~t / Pkey(\st)).loop,
			//\pos, ~pmodenv.(Pseq([0,1,0.5],1), 1/4 / ~t* 138/4/60 ).loop,
			\pos, PmodEnv(Pseq([0.2,0.6,1,0,1],1), 1/1).loop,
			\legato, Pseq([
				2,0,2,0, 0,0,1,0,
				0,0,2,0, 2,0,1,1,
				4,0,0,0, 0,0,1,0,
				0,1,1,2, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \sh101,
			\legato, Pseg(Pseq([0.1,0.1],inf),8*4),
			\adsr, Pseq([
				//PpatEnv.adsr(Pseq([0.041,0.01],inf),0.1,0.8,Pseq([0.1,0.01],inf)),
				PpatEnv.adsr(Pseq([0.01],inf),0.1,0.4,Pseq([0.01,0.05],inf)),
			],inf),
			\note, Pseq([
				Pseq([
					Pser([
						0,4,7,4,
					],8*2),
					Pser([
						0,4,7,4,
					],8*2)+7,
					Pser([
						0,3,7,3,
					],8*2)+2,
					Pser([
						0,4,7,4,
					],8*2)+7,
				],3),
				//Pser([
					//4,6,9,6,
				//],8*2),
				//Pser([
					//4,1,9,1,
				//],8*2),
			],inf),
			\octave, Pseq([
				Pn(5,Pseq([1,5],inf)),6,Pn(7,Pwhite(1,3,1)),4
			],inf).stutter(3),
			\dur, 1/8,
			\amp, 0.1 * Pseq([
				Pwhite(0.8,1,1),
				Pwhite(0.1,0.5,1),
				Pwhite(0.1,0.7,1),
				Pwhite(0.1,0.5,1),
				Pwhite(0.1,0.5,1),
			],inf),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pdef(\part1),
			Pdef(\part2),
			Pdef(\part3),
			Pdef(\part4),
		],1),
		
	])
)).play;
);


//////////////////:
// more cut


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1065].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1067].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1521].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[82].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,1,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[96].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1, 0,1, 0,1, 0,1,
				0,1, 0,0, 0,0, 0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vipere/mia.flac'),
			\legato, 1,
			\st, 138/4/60,
			\speed, 0.72 * ~t / Pkey(\st),
			\pos, Pseq([
				Pseq([
					(0..7)/8,
				].flat.stutter(8),1),
				//(0..7)/8+1,
				//(0..7)/8+2,
				//(0..7)/8+3,
				//Pstep(Pseq([4,6,2,1],inf),1/4),
				
			].flat,inf) / Pkey(\st),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\smp, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\smp, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\hpf, 1000,
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
			\bufnum, ~buflib.kick[1065].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1067].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1521].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[82].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,1,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[96].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1, 0,1, 0,1, 0,1,
				0,1, 0,0, 0,0, 0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vipere/mia.flac'),
			\legato, 1,
			\st, 138/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				Pseq([
					0,5,6,
				].flat.stutter(8)/8,1),
				Pseq([
					7.5,1,
				].flat.stutter(4)/8,1),
				//(0..7)/8+1,
				//(0..7)/8+2,
				//(0..7)/8+3,
				//Pstep(Pseq([4,6,2,1],inf),1/4),
				
			].flat,inf) / Pkey(\st),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,1,1,
			],inf).coin.not,
			//\adsr, Pseq([
				//[ Env.adsr(0.01,0.3,0.4,0.1) ],
			//],inf),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\smp, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\smp, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\hpf, 1000,
			\lpf, PmodEnv(Pseq([1001,10000],1), 8).loop,
			\dur, 1,
		),
		
	])
)).play;
);
