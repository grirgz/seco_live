
~t = 185/4/60; TempoClock.default.tempo = ~t;
(
Pdef(\part, Pdef(\basedrums, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[64].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,1,0,1, 1,0,1,1,
				0,1,1,0, 0,0,0,0,
				1,1,0,1, 1,0,1,1,
				0,1,1,0, 0,0,0,0,
				1,1,0,1, 1,0,1,1,
				0,1,1,0, 0,0,0,0,
				1,1,0,1, 1,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1/2 * Pseq([
				1,0.7,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[644].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1304].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1781].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\apart1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[64].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,1,0,1, 1,0,1,1,
				0,1,1,0, 0,0,0,0,
				1,1,0,1, 1,0,1,1,
				0,1,1,0, 0,0,0,0,
				1,1,0,1, 1,0,1,1,
				0,1,1,0, 0,0,0,0,
				1,1,0,1, 1,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1/2 * Pseq([
				1,0.7,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[644].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1304].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1781].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pseq([
			//Pbind(
				//\instrument, \echhlow,
				//\freq, 200,
				//\legato, 1,
				//\dur, Pn(4,1),
				//\amp, 0.1,
				//\out, BusDef(\ifx1, \audio),
			//),
			Ppar([
				Pbind(
					\instrument, \echhlow,
					\freq, 200,
					\legato, 1,
					\dur, Pn(4,1),
					\amp, 0.1,
					\out, BusDef(\ifx1, \audio),
				),
				Pbind(
					\instrument, \woof1,
					\freq, 70,
					\tscale, 10,
					\dur, Pn(16,1),
					\isRest, Pseq([
						1,
					],inf).coin.not,
					\amp, 0.1,
				),
			]),
		],1),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\legato, 0.8,
			\lag, 0.0009,
			\adsr, Pseq([
				[ Env.adsr(1.3,0.1,0.8,0.1,1,2) ],
			],inf),
			\dur, 2,
		),
		Pbind(\instrument, \simplegran,
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono('loop/loop3b_185bpm.flac'),
			\pos, Pseq([
				1,2,Pwhite(0.1,2,1)
			],inf),
			\isRest, Pstep(Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf),1/8).coin.not,
			\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
			\gdur, ~pmodenv.(Pseq([0.1,0.02],inf), 4),
			\pitch_stretch, 2,
			\dur, PdurStutter(Prand([1,4,2,8],inf), 1/4),
			\gain, 0.1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\apart2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[64].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					0
				],8*4),
				Pseq([
					1,1,0,1, 1,0,1,1,
					0,1,1,0, 0,0,0,0,
					1,1,0,1, 1,0,1,1,
					0,1,1,0, 0,0,0,0,
					1,1,0,1, 1,0,1,1,
					0,1,1,0, 0,0,0,0,
					1,1,0,1, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1/2 * Pseq([
				1,0.7,1,
			],inf),
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		
		Pmono(\simplegran,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			//\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
			//\gdur, Ptuple([ Pseries(0.2,-0.01,8*8),Pseries(0.01,0.01,8*8) ],inf),
			\gfreq, Ptuple([ Pseries(100,1,8*8),Pseries(100,1.1,8*8) ],inf),
			\gfreq, Pseq([
				Pseq([ 0 ],8*4),
				Pseq([ 0,12 ],8*4),
				Pseq([ 24,36 ],8*4),
				0,12,24,36,
			].midiratio * 40,inf),
			\pos, Ptuple([ Pseries(0,0.01,8*8),Pseries(1,0.01,8*8) ],inf)+1,
			\pan, 0.3 * Pwhite(1,1.01,inf),
			\pitch_stretch, ~pmodenv.(Pseq([1/2,0.4,2],inf), Pexprand(0.1,20)),
			\dur, 1/4,
			\gain, 0.3,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\apart3, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[64].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,1,0,1, 1,0,1,1,
					0,1,1,0, 0,0,0,0,
					1,1,0,1, 1,0,1,1,
					0,1,1,0, 0,0,0,0,
					1,1,0,1, 1,0,1,1,
					0,1,1,0, 0,0,0,0,
					1,1,0,1, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1/2 * Pseq([
				1,0.7,1,
			],inf),
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1886].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		
		Pmono(\simplegran,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			//\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
			//\gdur, Ptuple([ Pseries(0.2,-0.01,8*8),Pseries(0.01,0.01,8*8) ],inf),
			\gfreq, Ptuple([ Pseries(100,1,8*8),Pseries(100,1.1,8*8) ],inf),
			\gfreq, Pseq([
				//Pseq([ 0 ],8*4),
				//Pseq([ 0,12 ],8*4),
				Pseq([ 24,36 ],8*4),
			].midiratio * 40,inf),
			\pos, Ptuple([ Pseries(0,0.01,8*8),Pseries(1,0.01,8*8) ],inf)+1,
			\pan, 0.3 * Pwhite(1,1.01,inf),
			\pitch_stretch, ~pmodenv.(Pseq([1/2,0.4,2],inf), Pexprand(0.1,20)),
			\dur, 1/4,
			\gain, 0.1,
		),
	])
)).play;
);

(
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\apart4, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[64].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,1,0,1, 1,0,1,1,
					0,1,1,0, 0,0,0,0,
					1,1,0,1, 1,0,1,1,
					0,1,1,0, 0,0,0,0,
					1,1,0,1, 1,0,1,1,
					0,1,1,0, 0,0,0,0,
					1,1,0,1, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1/2 * Pseq([
				1,0.7,1,
			],inf),
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1452].value,
			\bufnum, ~buflib.hat[147].value,
			\bufnum, ~buflib.hat[835].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,0,0,
				1,1,1,1, 1,0,1,0,
				0,0,0,0, 1,1,1,1,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,1,1,1,

				1,0,1,0, 1,0,1,0,
				1,0,1,1, 0,1,1,0,
				1,1,0,1, 1,1,1,1,
				0,0,0,0, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11/2,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1452].value,
			\bufnum, ~buflib.hat[147].value,
			\bufnum, ~buflib.hat[835].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,

			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11/4,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/Pseq([1,1,2,4],inf)/2 * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([
					0, 2,
				],1),2),
			],inf) / Pkey(\st),
			\dur, PdurStutter(Pseq([2,1,4,1,8,1],inf), 1/2),
			\gain, 0.5,
		),
		Pmono(\simplegran,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			//\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
			//\gdur, Ptuple([ Pseries(0.2,-0.01,8*8),Pseries(0.01,0.01,8*8) ],inf),
			\gfreq, Ptuple([ Pseries(100,1,8*8),Pseries(100,1.1,8*8) ],inf),
			\gfreq, Pseq([
				//Pseq([ 0 ],8*4),
				//Pseq([ 0,12 ],8*4),
				Pseq([ 24,36 ],8*4),
			].midiratio * 40,inf),
			\pos, Ptuple([ Pseries(0,0.01,8*8),Pseries(1,0.01,8*8) ],inf)+1,
			\pan, 0.3 * Pwhite(1,1.01,inf),
			\pitch_stretch, ~pmodenv.(Pseq([1/2,0.4,2],inf), Pexprand(0.1,20)),
			\dur, 1/4,
			\gain, 0.1,
		),
	])
)).play;
);

(
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\apart5, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[64].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,1,0,1, 1,0,1,1,
					0,1,1,0, 0,0,0,0,
					1,1,0,1, 1,0,1,1,
					0,1,1,0, 0,0,0,0,
					1,1,0,1, 1,0,1,1,
					0,1,1,0, 0,0,0,0,
					1,1,0,1, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1/2 * Pseq([
				1,0.7,1,
			],inf),
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1452].value,
			\bufnum, ~buflib.hat[835].value,
			\bufnum, ~buflib.hat[147].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,1,0,
				1,0,1,0, 1,0,0,0,
				1,1,1,1, 1,0,1,0,
				0,0,0,0, 1,1,1,1,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,1,0, 1,0,1,0,
				0,0,0,0, 1,1,1,1,

				1,0,1,0, 1,0,1,0,
				1,0,1,1, 0,1,1,0,
				1,1,0,1, 1,1,1,1,
				0,0,0,0, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11/2,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1452].value,
			\bufnum, ~buflib.hat[835].value,
			\bufnum, ~buflib.hat[147].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,

			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11/4,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/Pseq([1,1,2,4],inf) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([
					2, 3,
				],1),2),
			],inf) / Pkey(\st),
			\dur, PdurStutter(Pseq([2,1,4,1,8,1],inf), 1/2),
			\gain, 0.5,
		),
		Pbind(\instrument, \simplegran,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			//\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
			//\gdur, Ptuple([ Pseries(0.2,-0.01,8*8),Pseries(0.01,0.01,8*8) ],inf),
			\gdur, Pseq([
				0.05,0.05,0.05,0.05, 0.05,0.05,0.1,0.5,
			],inf),
			\gfreq, Ptuple([ Pseries(100,1,8*8),Pseries(100,1.1,8*8) ],inf),
			\gfreq, Pseq([
				//Pseq([ 0 ],8*4),
				//Pseq([ 0,12 ],8*4),
				Pseq([ 
					//0,0,0,0, 0,0,0,24,
					0,0,-1,-1,
				],8*4),
			].midiratio * 80*4,inf),
			//\pos, Ptuple([ Pseries(0,0.01,8*8),Pseries(1,0.01,8*8) ],inf)+1,
			\pos, 0.3 * Pwhite(1,1.01,inf),
			\pan, 0,
			\pitch_stretch, ~pmodenv.(Pseq([1/2,0.4,2],inf), Pexprand(0.1,20)),
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,1,1, 0,0,0,0,
				1,1,0,0, 1,1,1,1,
			],inf).coin.not,
			//\pitch_stretch, 1,
			\dur, 1/8,
			\gain, 1.9,
		),
	])
)).play;
);

(
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(8, Pdef(\apart1)),
		Pfindur(8, Pdef(\apart2)),
		Pfindur(8, Pdef(\apart3)),
		Pfindur(16, Pdef(\apart4)),
		Pfindur(16, Pdef(\apart5)),
	])
)).play;
)

(
SynthDef(\echhlow, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([10,420,182],[4,0.1]/~t,[1,1]),1);
	env2 = EnvGen.kr(Env([10,100,152],[4,0.1]/~t,[1,1]), 1);
	env3 = EnvGen.kr(Env([10,710,1000],[4,0.1]/~t,[1,1]), 1);
	env4 = EnvGen.kr(Env([0.1,2,0.1],[4.0,0.08]/~t), 1);
	sig = WhiteNoise.ar;
	sig = Ringz.ar(sig, rrand(70.0!8,1000),0.01).mean;
	sig = sig * ( SinOsc.ar(1700) * env4 + 1 );
	//sig = RLPF.ar(sig, env2, \rq2.kr(0.8));
	sig = RLPF.ar(sig,  [env3, env2, env1 ], \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,2.4)),gate,doneAction:2);
	sig = Pan2.ar(sig, [-1,0,1]*0.1, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\demo, 
	Pbind(
		\instrument, \echhlow,
		\freq, 200,
		\legato, 1,
		\dur, Pn(4,1),
		\amp, 0.1,
	),
).play;
)

(
SynthDef(\echhlow, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([10,420,182],[4,0.1]/~t,[1,1]),1);
	env2 = EnvGen.kr(Env([10,100,152],[4,0.1]/~t,[1,1]), 1);
	env3 = EnvGen.kr(Env([10,710,1000],[4,0.1]/~t,[1,1]), 1);
	env4 = EnvGen.kr(Env([0.1,2,0.1],[4.0,0.08]/~t), 1);
	sig = WhiteNoise.ar;
	sig = Ringz.ar(sig, rrand(70.0!8,1000),0.01).mean;
	sig = sig * ( SinOsc.ar(1700) * env4 + 1 );
	//sig = RLPF.ar(sig, env2, \rq2.kr(0.8));
	sig = RLPF.ar(sig,  [env3, env2, env1 ], \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,2.4)),gate,doneAction:2);
	sig = Pan2.ar(sig, [-1,0,1]*0.1, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\demo, 
	Pbind(
		\instrument, \echhlow,
		\freq, 200,
		\legato, 1,
		\dur, Pn(4,1),
		\amp, 0.1,
	),
).play;
)


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\instrument, \simplegran,
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono('loop/loop3b_185bpm.flac'),
			\pos, Pseq([
				1,2,Pwhite(0.1,2,1)
			],inf),
			\isRest, Pstep(Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
			],inf),1/8).coin.not,
			\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
			\gdur, ~pmodenv.(Pseq([0.1,0.02],inf), 4),
			\pitch_stretch, 2,
			\dur, PdurStutter(Prand([1,4,2,8],inf), 1/4),
			\gain, 0.1,
		),
	])
)).play;
);

(
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
SynthDef(\doublegran, { arg out=0, mix=0.5, gain=1, gate=1, mbufnum=0, pitch_stretch=1, pos=0, gdur=0.1, pan;
	var sig;
	var clk;
	var phase;
	clk = Impulse.ar(\gfreq.kr(40));
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = pos;
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, phase + [0,\dephase.kr(0)] % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig.mean * 0.6;
	sig.debug("sig");
	sig = sig * EnvGen.ar(\asr.kr(Env.asr(0.01,1,0.01)),gate,doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
)



Ndef(\woof, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var tscale = 1/2;
	sig = WhiteNoise.ar;
	sig = Saw.ar(70 * EnvGen.kr(Env([1,2,7],[2.1 * tscale,0.8]), 1) * ( SinOsc.ar(100) * 0.2  * EnvGen.kr(Env([1,20,2],[2.1,0.8], 1))+ 1 )) + sig;
	sig = LPF.ar(sig, EnvGen.ar(Env([200,5000,5000],[1.1 * tscale,0.8], [1,-1]), 1));
	sig = BPF.ar(sig, EnvGen.kr(Env([201,5000 * [1,1.1,2],1],[1.1 * tscale,0.8]), 1), 1) + ( sig/4 );
	sig = sig * EnvGen.kr(Env([0.01,0.1,1,0],[0.3,3.3 * tscale,0.008], [3,-1]), 1);
	sig = FreeVerb.ar(sig, mix:0.2, room:2.5, damp:0.5);
	sig = Compander.ar(sig, sig, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.1), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	//sig = SinOsc.ar(freq);
	pan = pan + SinOsc.ar((1..sig.size) * 100/1, mul: EnvGen.kr(Env([0,0.51,0],[1.1,0.8]), 1);); 
	sig = Pan2.ar(sig, pan, amp).mean;
	sig;
}).play;

(
SynthDef(\woof1, { arg out=0, gate=1, amp=0.1, pan=0, freq=70;
	var sig;
	var tscale = \tscale.kr(1/2);
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	sig = WhiteNoise.ar;
	lfo1 = LFNoise1.kr(21 * LFNoise1.kr(1/2).range(0.0,1.0)).range(0.5,2.0);
	lfo2 = LFNoise1.kr(21 * LFNoise1.kr(1/2).range(0.0,1.0)).range(0.5,2.0);
	sig = Saw.ar(freq * EnvGen.kr(Env([1,2,7],[2.1 * tscale,0.8]), 1) * ( SinOsc.ar(100) * 0.2  * EnvGen.kr(Env([1,20,2],[2.1,0.8], 1)) * lfo1 + 1 )) + sig;
	sig = sig * 0.5 + (Resonz.ar(sig, lfo2 * freq * 4, 0.1 ) * EnvGen.kr(Env([0,1,2],[1.1,1.8]), 1, timeScale:tscale));
	sig = sig * 1.4;
	sig = LPF.ar(sig, EnvGen.ar(Env([200,5000,5000],[1.1 * tscale,0.8], [1,-1]), 1));
	sig = BPF.ar(sig, EnvGen.kr(Env([201,5000 * [1,1.1,2],1],[1.1 * tscale,0.8]), 1), 1) + ( sig/4 );
	sig = sig * EnvGen.kr(Env([0.01,0.1,1,0],[0.3,3.3 * tscale,0.008], [3,-1]), 1);
	sig = FreeVerb.ar(sig, mix:0.2, room:2.5, damp:0.5);
	sig = Compander.ar(sig, sig, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.1), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	//sig = SinOsc.ar(freq);
	pan = pan + SinOsc.ar((1..sig.size) * 100/1, mul: EnvGen.kr(Env([0,0.51,0],[1.1,0.8]), 1);); 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\woof1,
			\freq, 70,
			\tscale, 5,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);


//////////////


(
Pdef(\part, Pdef(\bpart1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[64].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,1,1,1, 1,0,1,1, 1,1,
				0,1, 1,1,1,0,0,0, 0,0,
			],inf).coin.not,
			\dur, 1/10,
			\gain, 0.1/2 * Pseq([
				1,0.7,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[644].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1304].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1781].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1452].value,
			\bufnum, ~buflib.hat[835].value,
			\bufnum, ~buflib.hat[147].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,1,0,
				1,0,1,0, 1,0,0,0,
				1,1,1,1, 1,0,1,0,
				0,0,0,0, 1,1,1,1,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,1,0, 1,0,1,0,
				0,0,0,0, 1,1,1,1,

				1,0,1,0, 1,0,1,0,
				1,0,1,1, 0,1,1,0,
				1,1,0,1, 1,1,1,1,
				0,0,0,0, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11/2,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\bpart1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[64].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,1,1, 1,1,0,0, 1,1,1,1, 0,0,1,1, 
				1,1,0,0, 1,1,1,1, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.1/2 * Pseq([
				1,0.7,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[644].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1304].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1781].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1452].value,
			\bufnum, ~buflib.hat[835].value,
			\bufnum, ~buflib.hat[147].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,1,0,
				1,0,1,0, 1,0,0,0,
				1,1,1,1, 1,0,1,0,
				0,0,0,0, 1,1,1,1,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,1,0, 1,0,1,0,
				0,0,0,0, 1,1,1,1,

				1,0,1,0, 1,0,1,0,
				1,0,1,1, 0,1,1,0,
				1,1,0,1, 1,1,1,1,
				0,0,0,0, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11/2,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\bpart1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[64].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,1,1, 1,1,0,0, 1,1,1,1, 0,0,1,1, 
				1,1,0,0, 1,1,1,1, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.1/2 * Pseq([
				1,0.7,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[644].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[980].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			].rotate(0),inf).coin.not,
			\dur, 1/8,
			\gain, 0.41,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[27].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1304].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1781].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1452].value,
			\bufnum, ~buflib.hat[835].value,
			\bufnum, ~buflib.hat[147].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,1,0,
				1,0,1,0, 1,0,0,0,
				1,1,1,1, 1,0,1,0,
				0,0,0,0, 1,1,1,1,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,1,0, 1,0,1,0,
				0,0,0,0, 1,1,1,1,

				1,0,1,0, 1,0,1,0,
				1,0,1,1, 0,1,1,0,
				1,1,0,1, 1,1,1,1,
				0,0,0,0, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11/2,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

(
//////// for part{1-4}
ProtoDef('rdn').make('deldefault', 'rdn', "5-81EA-QELK", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.7436974789916,
	'gain', 0.2436974789916,
	'fb', 0.00026023254446898,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 6.3463059962866,
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

ProtoDef('rdn2').make('deldefault', 'rdn2', "5-E6LI-G42Q", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.0,
	'gain', 0.5672268907563,
	'fb', 0.0021338168782668,
	'delay', 0.00023428684237322,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.2492192141522,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 3936.8388945732,
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
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\bpart1, 
	Pbind(\out, BusDef(\sendbus3, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[64].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,1,0,1, 1,0,1,1,
				0,1,1,0, 0,0,0,0,
				1,1,0,1, 1,0,1,1,
				0,1,1,0, 0,0,0,0,
				1,1,0,1, 1,0,1,1,
				0,1,1,0, 0,0,0,0,
				1,1,0,1, 1,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1/2 * Pseq([
				1,0.7,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[644].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1304].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1781].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[525].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,1, 0,0,1,0,
				1,0,1,0, 1,0,1,0, 
				0,0,0,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,1, 0,0,1,0,
				1,0,1,0, 1,0,1,0, 
				0,0,0,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,1, 0,0,1,0,
				1,0,1,0, 1,0,1,0, 
				0,0,0,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,1, 0,0,1,0,
				1,0,1,0, 1,0,1,0, 
				0,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 0.2,
			\dur, 1/16,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1932].value,
			\bufnum, ~buflib.snare[1781].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\legato, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1,
				0,1,0,1, 0,1,0,1,
				0,1,1,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 1,0,0,1,
				0,1,0,1, 0,1,0,1,
				0,1,1,0, 0,1,0,0,
				1,0,1,1, 1,0,0,0,

				0,0,0,0, 1,0,0,1,
				0,1,0,1, 0,1,0,1,
				0,1,1,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 1,0,0,1,
				0,1,0,1, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1164].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,1,0,1,
				1,0,1,0, 0,0,1,0,
				1,0,1,1, 1,0,1,0,
				1,0,0,0, 0,0,1,0,

				1,0,0,0, 0,0,1,0,
				1,0,0,0, 1,0,1,1,
				1,0,1,0, 0,0,1,0,
				0,0,0,0, 1,1,1,1,

				1,0,0,0, 1,0,1,0,
				1,0,0,0, 1,0,1,0,
				1,1,1,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,

				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			].rotate(4),inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pdef(\fxseq1),

		
	])
)).play;
);

(
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\bpart1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('acapella/stardust.flac'),
			\pos, Pseq([
				2,4.1,1.3, 2,1.3, 2,1.3, 4.1,
				2,1.3, 2,4.1,1.3, 2,4.1,1.3,
			],inf) + Pseq([
				Pseg(Pseq([0,0.1],inf),8)

			],inf) - 1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.5,1,0.2,
				0.5,1,0.2,
				0.5,1,0.2,
				0.5,1,0.2,2,
				0.5,1,0.2,2,
				0.1,0.1,0.1,0.1,0.1,
				1,1,1,1, 1,1,1,1,

			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
				1,1,1,1, 0,0,1,0,
				1,0,0,0, 0,0,0,0,

				0,0,0,0, 1,0,1,0,
				0,0,0,0, 1,1,1,0,
				1,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\speed, Pseq([
				Pser([
					0,0,0,-1,
				],8*6),
				Pseq([
					-1,
				],1).stutter(8*2),
			].midiratio,inf)/2,
			\dur, 1/8,
			\gain, 1/10,
			\out, BusDef(\stutter, \audio),
		),
		Pmono(\fx_stutter,
			\time, 1/4/Prand([2,4,8,1],inf).stutter(4)/~t,
			\mix, Pseq([
				0,1,0,1,
				0,0,1,1,
				0,1,1,1,
			],inf),
			\rate, 1.0,
			\maxdelay, 10.0,
			\gain, 1.0,
			\inbus, BusDef(\stutter, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1/4,
			\out, BusDef(\sendbus4, \audio),
		),
		Pbind(\out, BusDef(\sendbus3, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[64].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,1,0,1, 1,0,1,1,
					0,1,1,0, 0,0,0,0,
					1,1,0,1, 1,0,1,1,
					0,1,1,0, 0,0,0,0,
					1,1,0,1, 1,0,1,1,
					0,1,1,0, 0,0,0,0,
					1,1,0,1, 1,0,0,0,
					0,0,0,0, 0,1,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1/2 * Pseq([
					1,0.7,1,
				],inf),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[644].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,1,0, 0,1,0,0,
					1,0,0,1, 0,0,0,0,
					0,0,1,0, 0,1,0,0,
					1,0,0,1, 0,0,0,0,
					0,0,1,0, 0,1,0,0,
					1,0,0,1, 0,0,0,0,
					0,0,1,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1304].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1781].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[525].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					0,0,0,1, 0,0,1,0,
					1,0,1,0, 1,0,1,0, 
					0,0,0,1, 1,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,1, 0,0,1,0,
					1,0,1,0, 1,0,1,0, 
					0,0,0,1, 1,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,1, 0,0,1,0,
					1,0,1,0, 1,0,1,0, 
					0,0,0,1, 1,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,1, 0,0,1,0,
					1,0,1,0, 1,0,1,0, 
					0,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 0.2,
				\dur, 1/16,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1932].value,
				\bufnum, ~buflib.snare[1781].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\legato, 0.2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\isRest, Pseq([
					0,0,0,0, 1,0,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,1,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 1,0,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,1,0, 0,1,0,0,
					1,0,1,1, 1,0,0,0,

					0,0,0,0, 1,0,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,1,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 1,0,0,1,
					0,1,0,1, 0,1,0,1,
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/16,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1164].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 1,1,0,1,
					1,0,1,0, 0,0,1,0,
					1,0,1,1, 1,0,1,0,
					1,0,0,0, 0,0,1,0,

					1,0,0,0, 0,0,1,0,
					1,0,0,0, 1,0,1,1,
					1,0,1,0, 0,0,1,0,
					0,0,0,0, 1,1,1,1,

					1,0,0,0, 1,0,1,0,
					1,0,0,0, 1,0,1,0,
					1,1,1,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,

					1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				].rotate(4),inf).coin.not,
				\dur, 1/16,
				\gain, 0.11,
			),
			Pdef(\fxseq1),


		])
	]),
)).play;
);


(
Pdef(\fxseq1, 
	Ppar([
		Prout({ arg ev;
			var rdn = ProtoDef(\rdn3).proxy;
			1000.do {
				rdn.set(\distamp, 0.5);
				3.wait;
				rdn.set(\distamp, 74);
				1.wait;
			}
		}),
		Prout({ arg ev;
			var rdn = ProtoDef(\rdn3).proxy;
			1000.do {
				rdn.set(\delay2, 0.0000005);
				(6).wait;
				rdn.set(\delay2, Ndef(\lfo1, { XLine.kr(0.00001,rrand(0.1,0.9),2/~t) }));
				(2).wait;
			}
		}),
	]),
);
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1164].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,1,0,1,
				1,0,1,0, 0,0,1,0,
				1,0,1,1, 1,0,1,0,
				1,0,0,0, 0,0,1,0,

				1,0,0,0, 0,0,1,0,
				1,0,0,0, 1,1,1,1,
				1,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,

				1,0,0,0, 1,0,1,0,
				1,0,0,0, 1,0,1,0,
				1,1,1,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,

				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 0,0,1,1,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\bpart1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('acapella/stardust.flac'),
			\pos, Pseq([
				2,4.1,1.3, 2,1.3, 2,1.3, 4.1,
				2,1.3, 2,4.1,1.3, 2,4.1,1.3,
			],inf) + Pseq([
				Pseg(Pseq([0,0.1],inf),8)
				
			],inf) - 1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.5,1,0.2,
				0.5,1,0.2,
				0.5,1,0.2,
				0.5,1,0.2,2,
				0.5,1,0.2,2,
				0.1,0.1,0.1,0.1,0.1,
				1,1,1,1, 1,1,1,1,

			],inf),
			\speed, Pseq([
				Pseq([
					0,0,0,-1,
				],4),
				Pseq([
					-1,0,-1,-2,-1,0,-1,
				],1).stutter(16),
			].midiratio,inf),
			\dur, 1/8,
			\gain, 1/10,
			\out, BusDef(\sendbus4, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('loop/pigs.flac'),
			\bufnum, BufDef('acapella/stardust.flac'),
			\legato, 1,
			\st, 80/4/60,
			\speed, 1/Pseq([2,2],inf)/2 * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([
					0, 1/8,
				],1),8) + 4,
			],inf) / Pkey(\st),
			\isRest, Pseq([
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, PdurStutter(Pseq([8,1],inf), 1/2),
			\gain, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[64].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,1,0,1, 1,0,1,1,
				0,1,1,0, 0,0,0,0,
				1,1,0,1, 1,0,1,1,
				0,1,1,0, 0,0,0,0,
				1,1,0,1, 1,0,1,1,
				0,1,1,0, 0,0,0,0,
				1,1,0,1, 1,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1/2 * Pseq([
				1,0.7,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[644].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1304].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1781].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);


///////////////////////////

ProtoDef(\rdn4).presetCompileString.editorInsert
(
ProtoDef('rdn4').make('deldefault', 'rdn4', "5-IAI6-PQVG", BusDef('sendbus4'));
Ndef('rdn4').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.77310924369748,
	'gain', 0.071428571428571,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.1787686347936,
	'pitchlag', 0.001,
	\out, BusDef(\stutter, \audio),
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 20.0,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 3.9466141732283,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.0001,
	'distamp2', 3.9466141732283,
).keep(1));

);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[64].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,1,0,1, 1,0,1,1,
				0,1,1,0, 0,0,0,0,
				1,1,0,1, 1,0,1,1,
				0,1,1,0, 0,0,0,0,
				1,1,0,1, 1,0,1,1,
				0,1,1,0, 0,0,0,0,
				1,1,0,1, 1,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1/2 * Pseq([
				1,0.7,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('acapella/stardust.flac'),
			\pos, Pseq([
				2,
			],inf) + Pseq([
				Pseg(Pseq([0,0.1],inf),8)
		
			],inf) - 1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				1
		
			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
				1,1,1,1, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
		
				0,0,0,0, 1,0,1,0,
				0,0,0,0, 1,1,1,0,
				1,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\speed, Pseq([
				Pser([
					0,0,0,-1,
				],8*6),
				Pseq([
					-1,
				],1).stutter(8*2),
			].midiratio,inf)/4,
			\dur, 1/8,
			\gain, 1/10,
			\out, BusDef(\stutter, \audio),
		),
		Pmono(\fx_stutter,
			\time, 1/4/Prand([2,4,8,1],inf).stutter(4)/~t,
			\mix, Pseq([
				0,0,0,0, 
				0,1,0,1,
				0,0,1,1,
				0,1,1,1,
			],inf),
			\rate, 1.0,
			\maxdelay, 10.0,
			\gain, 1.0,
			\inbus, BusDef(\stutter, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1/4,
			\out, BusDef(\sendbus4, \audio),
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[64].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,1,0,1, 1,0,1,1,
				0,1,1,0, 0,0,0,0,
				1,1,0,1, 1,0,1,1,
				0,1,1,0, 0,0,0,0,
				1,1,0,1, 1,0,1,1,
				0,1,1,0, 0,0,0,0,
				1,1,0,1, 1,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1/2 * Pseq([
				1,0.7,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('acapella/stardust.flac'),
			\pos, Pseq([
				Pstep(Pseq([0,1.1],inf),2)+ 2.1,
			],inf) + Pseq([
				Pseg(Pseq([0,0.1],inf),8)
		
			],inf) - 1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				1
		
			],inf),
			\legato, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\speed, Pseq([
				0,
			].midiratio,inf)/2,
			\dur, 1/8,
			\gain, 1/10,
			\out, BusDef(\stutter, \audio),
		),
		Pmono(\fx_stutter,
			\time, 1/6/Pseq([1,2,4],inf).stutter(4)/~t,
			\mix, Pseq([
				1,1,0,1,1,0,1,0,
				1,1,0,1,0,1,1,0,
				1,0,1,1,0,1,1,0,
				1,1,0,1,1,0,1,0,
				1,1,1,1, 1,0,1,1,
				1,1,1,0, 1,1,1,0,
			],inf),
			\rate, 1.0,
			\maxdelay, 10.0,
			\gain, 1.0,
			\inbus, BusDef(\stutter, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1/8,
			\out, BusDef(\sendbus4, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[64].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,1,0,1, 1,0,1,1,
				0,1,1,0, 0,0,0,0,
				1,1,0,1, 1,0,1,1,
				0,1,1,0, 0,0,0,0,
				1,1,0,1, 1,0,1,1,
				0,1,1,0, 0,0,0,0,
				1,1,0,1, 1,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1/2 * Pseq([
				1,0.7,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('acapella/stardust.flac'),
			\pos, Pseq([
				Pstep(Pseq([0,1.1],inf),2)+ 2.1,
			],inf) + Pseq([
				Pseg(Pseq([0,0.1],inf),8)
		
			],inf) - 1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				1
		
			],inf),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,1,1,
				0,0,0,0, 0,0,0,1,
				0,1,0,0, 1,1,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\speed, Pseq([
				0,
			].midiratio,inf)/2,
			\dur, 1/8,
			\gain, 1/10,
			\out, BusDef(\stutter, \audio),
		),
		Pmono(\fx_stutter,
			\time, 1/6/Pseq([1,2,4],inf).stutter(4)/~t,
			\mix, Pseq([
				1,1,0,1,1,0,1,0,
				1,1,0,1,0,1,1,0,
				1,0,1,1,0,1,1,0,
				1,1,0,1,1,0,1,0,
				1,1,1,1, 1,0,1,1,
				1,1,1,0, 1,1,1,0,
			],inf),
			\mix, 0,
			\rate, 1.0,
			\maxdelay, 10.0,
			\gain, 1.0,
			\inbus, BusDef(\stutter, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1/8,
			\out, BusDef(\sendbus4, \audio),
		),
	])
)).play;
);

//////////////////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Prout({ arg ev;
			var osc = Pseq([
				SinOsc, LFSaw,
			],inf).asStream;
			100.do {
				Ndef(\bla, { arg freq=200, pan=0, amp=0.1;
					var sig;
					sig = osc.next.ar(freq) * 0.2;
					sig = Pan2.ar(sig, pan, amp);
				}).play;
				( 1/4 ).wait;
			}
		}),
		
	])
)).play;
);


(
Pdef(\foo, 
	Prout({ arg ev;
		var osc = Pseq([
			SinOsc, LFSaw,
		],inf).asStream;
		100.do {
			Ndef(\bla, { arg freq=200, pan=0, amp=0.1;
				var sig;
				sig = osc.next.ar(freq) * 0.2;
				sig = Pan2.ar(sig, pan, amp);
			}).play;
			( 1/4 ).wait;
		}
	}),
).play;
)



/////////////////////////



(
SynthDef(\chordo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.2,1],[0.1,0.8]), 1);
	env2 = SinOsc.ar(8/1.5*~t * ( SinOsc.kr(1*~t,Rand(0.0,2)) * 1 + 1 )).range(0.1,1);
	sig1 = SinOsc.ar(freq* [1,1.0001,1/2,1/4] * [0,0.01,0.02].midiratio/4)* EnvGen.kr(Env([0,0.41,0],[0.01,0.2]), 1);
	sig2 = SinOsc.ar(freq/2 * [1,2,1/2] * 0.midiratio).fold(env1) * 0.4;
	sig3 = LFSaw.ar(freq * [1,1.01,1.006,1/2,1/4] * 0.midiratio) * EnvGen.kr(Env([0,0.51,0],[1.1,2.8], 4), 1);
	sig3 = RLPF.ar(sig3, \lpfr.kr(2.1) * EnvGen.kr(Env([1,1/2,2,1],[2,2.1,2.8]), 1) * freq, \rq.kr(0.5));
	sig4 = SinOsc.ar(freq * [2/4,1/4]) * EnvGen.kr(Env([0,0.41,0],[0.01,0.2]), 1);
	sig5 = SinOsc.ar(freq+0.1 * [0+12,0,12.01,-12.02,0-24.03].midiratio/2 * ( LFSaw.ar(freq/2) * 0.4 + 1 )) * EnvGen.kr(Env([0,0.41,0],[0.1,1.5]), 1);
	sig6 = SinOsc.ar(freq*1.001 * [1,1/2,2,1/8]  * ( SinOsc.ar(freq* [0+12,0.01,12.027,0-12.012].midiratio/2) * 1.4 + 1 )) * EnvGen.kr(Env([0,0,0.41,0],[0.3,0.8,6.5]), 1);
	sig6 = HPF.ar(sig6, 1000 * EnvGen.kr(Env([1,2,1],[4.1,0.8]), 1)) + BPF.ar(sig6, 70);
	sig = sig1 + sig2 + sig3 + sig4 + sig5 + sig6;
	sig = sig1 + sig/2;
	sig = RLPF.ar(sig, env2 * 0.1 + 1 * \lpf.kr(1000), 0.5 / (1+ env2 ));
	sig = AllpassL.ar(sig, 0.4,0.01 * [1,0.6,0.7,1.1],4.5) + ( sig * 2 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,5.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\melo, 
	Pbind(
		\instrument, \chordo,
		\adsr, Pseq([
			[ Env.adsr(0.1,0.1,0.8,4.1) ],
		],inf),
	)
)
);
ProtoDef(\piano).startControl(Pdef(\melo))


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \default,
			\degree, Pseq([[ 0,7 ]],inf),
			\dur, 4,
			\amp, 0.1/3,
		),
		//Pbind(
			//\instrument, \default,
			//\degree, Prand([
				//11,13,14
				
			//],inf),
			//\dur, Prand([1,1/2,1/4],inf),
			//\amp, 0.1/2,
		//),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\degree, Pkey(\degree) % Pstep(Pseq([64,21,14,7],inf),4),
			\dur, Pkey(\dur) * Pstep(Pseq([1,1,2,4,1/2],inf),8),
		) <>
		Ppar([
			Pbind(\degree, 0, \dur, 1/3),
			Pbind(\degree, 4 + Pseq([\r,\r,0],inf), \dur, 1/4),
			Pbind(\degree, 8, \dur, 1/5),
			Pbind(\degree, 9, \dur, 1/4),
			Pbind(\degree, 13 + Pseq([0,\r,\r,0],inf), \dur, 1/5),
			Pbind(\degree, 12+4 + Pseq([0,\r,0,0],inf), \dur, 1/2),
		])<>
		Pbind(
			\mtranspose, Pstep(Pseq([0,3],inf),4),
			\instrument, \chordo,
			\octave, 6,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			//\degree, Pseq([
				//[0,4, 8,9,13], // Cmaj11
				//[1,5, 10,11,14], // Dmin11
				//[0,4, 14-6,14-5,14-1], // major formula
				//[0,4, 14-5,14-4,14-1]+1, // minor formula
			//],inf),
			\legato, 1/2,
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);


///////////////////


(
SynthDef(\zinzin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.1]), Impulse.kr(\tfreq.kr(2*~t)));
	sig = SinOsc.ar(freq * env1);
	sig = Desstruct
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\zinzin,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);
{CrossoverDistortion.ar(SinOsc.ar([400, 404], 0, 0.2), MouseX.kr(0, 1), MouseY.kr(0, 1))}.play



//////////////////:
// auto filter


(
SynthDef(\sawautof, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * amp.linlin(0.05,0.2,0.5,4) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sawautof,
			\note, Pstep(Pseq([
				[4, 9, 12],
				[2, 7, 10],
				[5, 9, 12],
				[5, 10, 14],
			],inf),1),
			\dur, 1/8,
			\amp, 0.1 * Pseq([
				1,0.61,1.3,1,
			],inf).stutter(1)/1.5,
		),
		Ppar([0,2,5,7].collect { arg item, idx;
			Pbind(
				\instrument, \sawautof,
				\note, item,
				\legato, 0.4,
				\octave, [4,5,5,6].choose,
				\dur, Pseq([1,1,1/2,1,1/4,1/4,1].scramble,inf)/2,
				\isRest, Pseq([
					1,1,1,1, 0,0,0,0,
				].scramble,inf).coin.not,
				\amp, 0.1,
			)
		})
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \chordo,
			\note, Pstep(Pseq([
				[4, 9, 12],
				[2, 7, 10],
				[5, 9, 12],
				[5, 10, 14],
			],inf),2),
			\octave, 6,
			\lpf, 15000,
			\lpfr, 4,
			\dur, 2,
			\amp, 0.1 * Pseq([
				1,0.61,1.3,1,
			],inf).stutter(1)/1.5,
		),
		Ppar([0,2,5,7].collect { arg item, idx;
			Pfindur(2,Pbind(
				\instrument, \sawautof,
				\note, item,
				\legato, 0.4,
				\octave, [4,5,5,6].choose,
				\dur, Pseq([1,1,1/2,1,1/4,1/4,1].scramble,inf)/1,
				\isRest, Pseq([
					1,1,1,1, 0,0,0,0,
				].scramble,inf).coin.not,
				\amp, 0.1/1.7,
			)).loop
		}),
		Ppar([0,2,5,7].collect { arg item, idx;
			Pbind(
				\isRest, Pstep(Pseq([
					Pseq([
						1,0,0,0, 0,0,0,0,
					].scramble,3),
					Pseq([
						1,1,1,1, 0,0,0,0,
					].scramble,1),
				],inf),1/8).coin.not,
			) <>
			Pfindur(2,Pbind(
				\instrument, \sawautof,
				\note, item,
				\legato, 0.4,
				\octave, [5,6].choose,
				\dur, Pseq([1,1,1/2,1,1/4,1/4,1].scramble,inf)/1,
				\amp, 0.1/1.7,
			)).loop
		}),
		Ppar([0,2,5,7].collect { arg item, idx;
			Pbind(
				\isRest, Pstep(Pseq([
					Pseq([
						1,0,0,0, 0,0,0,0,
					].scramble,3),
					Pseq([
						1,1,1,1, 0,0,0,0,
					].scramble,1),
				],inf),1/4).coin.not,
			) <>
			Pfindur(2,Pbind(
				\instrument, \sawautof,
				\note, item,
				\legato, 0.4,
				\octave, [5,6].choose,
				\dur, Pseq([1,1,1/2,1,1/4,1/4,1].scramble,inf)/2,
				\amp, 0.1/1.7,
			)).loop
		}),
		Pdef(\basedrums),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \unichordo,
			\note, Pstep(Pseq([
				[4, 9, 12],
				[2, 7, 10],
				[5, 9, 12],
				[5, 10, 14],
			],inf),2),
			\octave, 5,
			\lpf, 15000,
			\lpfr, 4,
			\dur, 2,
			\hpf, 400,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \gransinfm,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\note, Pstep(Pseq([
				9,7,5,10,
			],inf),2),
			\fmffac, 100,
			\freqfac, Pseq([1,2,4,1/2],inf),
			\octave, 3,
			\fdelta, 1,
			\pos, Pseq([
				~pmodenv.(Pseq([0,0,0.03],1) + Pwhite(0,4.1).stutter(4), 2),
			],inf),
			\pitch_stretch, ~pmodenv.(Pseq([1,1/2,1/4,1/8],inf),8).loop,
			\pitch_stretch, Pwhite(0.4,0.1).stutter(4),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,0.1) ],
			],inf),
			\gfreq, Pkey(\freq),
			\dur, 1/4,
			//\out, BusDef(\sendbus1, \audio),
			\legato, Pseq([
				Pseq([
					2,0,0,1, 1,0,1,0,
					1,0,2,0, 0,0,2,0,
				],2),
				7,0,0,0, 0,0,0,0,
				2,0,0,3, 0,0,2,0,
				7,0,0,0, 0,0,0,1,
				2,0,3,0, 0,3,0,0,
			],inf),
			\gain, 0.1/2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),

		),
		Ppar([0,2,5,7].collect { arg item, idx;
			Pfindur(2,Pbind(
				\instrument, \sawautof,
				\note, item,
				\legato, 0.4,
				\octave, [5,5,6].choose,
				\dur, Pseq([1,1,1/2,1,1/4,1/4,1].scramble,inf)/1,
				\isRest, Pseq([
					1,1,1,1, 0,0,0,0,
				].scramble,inf).coin.not,
				\amp, 0.1/1.7,
			)).loop
		}),
		Ppar([0,2,5,7].collect { arg item, idx;
			Pbind(
				\isRest, Pstep(Pseq([
					Pseq([
						1,0,0,0, 0,0,0,0,
					].scramble,3),
					Pseq([
						1,1,1,1, 0,0,0,0,
					].scramble,1),
				],inf),1/8).coin.not,
			) <>
			Pfindur(2,Pbind(
				\instrument, \sawautof,
				\note, item,
				\legato, 0.4,
				\octave, [5,6].choose,
				\dur, Pseq([1,1,1/2,1,1/4,1/4,1].scramble,inf)/1,
				\amp, 0.1/1.7,
			)).loop
		}),
		Ppar([0,2,5,7].collect { arg item, idx;
			Pbind(
				\isRest, Pstep(Pseq([
					Pseq([
						1,0,0,0, 0,0,0,0,
					].scramble,3),
					Pseq([
						1,1,1,1, 0,0,0,0,
					].scramble,1),
				],inf),1/4).coin.not,
			) <>
			Pfindur(2,Pbind(
				\instrument, \sawautof,
				\note, item,
				\legato, 0.4,
				\octave, [5,6].choose,
				\dur, Pseq([1,1,1/2,1,1/4,1/4,1].scramble,inf)/2,
				\amp, 0.1/1.7,
			)).loop
		}),
		//Pdef(\basedrums),
		
	])
)).play;
);

(
SynthDef(\unichordo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.2,1],[0.1,0.8]), 1);
	env2 = SinOsc.ar(8/1.5*~t * ( SinOsc.kr(1*~t,Rand(0.0,2)) * 1 + 1 )).range(0.1,1);
	sig1 = SinOsc.ar(freq* [1,1.0001,1/2,1/4] * [0,0.01,0.02].midiratio/4)* EnvGen.kr(Env([0,0.41,0],[0.01,0.2]), 1);
	sig2 = SinOsc.ar(freq/2 * [1,2,1/2] * 0.midiratio).fold(env1) * 0.4;
	sig3 = LFSaw.ar(freq * [1,1.01,1.006,1/2,1/4] * 0.midiratio) * EnvGen.kr(Env([0,0.51,0],[1.1,2.8], 4), 1);
	sig3 = RLPF.ar(sig3, \lpfr.kr(2.1) * EnvGen.kr(Env([1,1/2,2,1],[2,2.1,2.8]), 1) * freq, \rq.kr(0.5));
	sig4 = SinOsc.ar(freq * [2/4,1/4]) * EnvGen.kr(Env([0,0.41,0],[0.01,0.2]), 1);
	sig5 = SinOsc.ar(freq+0.1 * [0+12,0,12.01,-12.02,0-24.03].midiratio/2 * ( LFSaw.ar(freq/2) * 0.4 + 1 )) * EnvGen.kr(Env([0,0.41,0],[0.1,1.5]), 1);
	sig6 = SinOsc.ar(freq*1.001 * [1,1/2,2,1/8]  * ( SinOsc.ar(freq* [0+12,0.01,12.027,0-12.012].midiratio/2) * 1.4 + 1 )) * EnvGen.kr(Env([0,0,0.41,0],[0.3,0.8,6.5]), 1);
	sig6 = HPF.ar(sig6, 1000 * EnvGen.kr(Env([1,2,1],[4.1,0.8]), 1)) + BPF.ar(sig6, 70);
	sig = sig1 + sig2 + sig3 + sig4 + sig5 + sig6;
	sig = sig1 + sig/2;
	sig = RLPF.ar(sig, env2 * 0.1 + 1 * \lpf.kr(1000), 0.5 / (1+ env2 ));
	sig = AllpassL.ar(sig, 0.4,0.01 * [1,0.6,0.7,1.1],4.5) + ( sig * 2 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,5.8)), gate, doneAction:2);
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
)




(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \basicpadxp,
			\note, Pstep(Pseq([
				[4, 9, 12],
				[2, 7, 10],
				[5, 9, 12],
				[5, 10, 14],
			],inf),2),
			\octave, 5,
			//\lpf, 15000,
			//\lpfr, 4,
			\dur, 2,
			//\hpf, 1000,
			\amp, 0.1 * Pseq([
				1,0.61,1.3,1,
			],inf).stutter(1)/1.5,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \bass_fmek,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.4) ],
			],inf),
			//\freqfac2, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\fma4env, Pseq([
				Pstep(Pseq([
					[ Env([4,1,1],[0.01,0.8]) ],
					[ Env([4,1,1],[0.01,0.8]) ],
					[ Env([4,1,1],[0.01,0.8]) ],
					[ Env([1,0.7,4],[0.1,2.8]) ],
				],inf),2),
				//[ Env([2,1,1],[0.01,0.8]) ],
				//[ Env([2,1,1],[0.1,0.8]) ],
			],inf),
			//\fma3, ~pmodenv.(Pseq([0.1,20,1,4],1), 8).loop,
			\fma1, 0.1,
			\fma2, 0.1,
			\fma3, 0.2,
			\fma4, ~pmodenv.(Pseq([2,2,8,2,1,4,1],1), 1/4).loop,
			//\fma4, 1.4,
			\freqfac3, ~pmodenv.(Pseq([1,2,8,1,2,8,1,2],inf), 1/4, 1, \step).loop,
			\freqfac2, 1,
			\freqfac1, 1,
			\legato, 0.4,
			\octave, 3,
			\note, Pstep(Pseq([
				9,7,5,10,
			],inf),2)-12,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \unichordo,
			\degree, Pseq([
				Pseq((6..0))
			],inf),
			\legato, 0.2,
			\ctranspose, 5,
			\octave, 6,
			\pan, Pseg(Pseq([-1,1],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,1.1) ],
			],inf),
			\dur, Pwhite(1/4,2,inf).round(1/4),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \unichordo,
			\degree, Pseq([
				Pseq((6..0))
			],inf),
			\legato, 0.2,
			\lpf, 4000,
			\ctranspose, 5,
			\octave, 6,
			\pan, Pseg(Pseq([-1,1],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,1.1) ],
			],inf),
			\dur, Pwhite(1/4,2,inf).round(1/4),
			\amp, 0.1,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[633].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,0,1,0, 1,0,0,1,
				0,0,0,0, 1,0,1,1,
				1,0,1,1, 0,0,1,0, 

				1,0,0,0, 1,0,1,0,
				1,0,1,0, 1,1,1,1,
				0,0,0,0, 1,0,1,0,
				1,0,1,1, 0,0,0,0, 
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.8 * Pseq([
				0.81,0.6,1,0.5,
				1,0.6,1,0.5,
			],inf),
			\gain, 0.05/2 * Pseq([
				1,0.6,1,0.5,
				0.81,0.6,1,0.5,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Bill Withers - Kissing My Love (part1).wav'),
			\legato, 1,
			\st, 183/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, 
			Pseq([
				Pseg(Pseq([
					0, 2,
				]+( 1/4 ),1),2).repeat(1),
				Pseg(Pseq([
					0, 2,
				]+( 1/4 )+4,1),2).repeat(1),
				Pseg(Pseq([
					0, 1/2,
				]+( 5/4 ),1),1/2).repeat(4),
				Pseg(Pseq([
					0, 2,
				]+3,1),1),
			],inf).loop / Pkey(\st),
			\isRest, Pseq([
				1,0,1,1, 0,0,1,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/9,
		),
	])
)).play;
);

ProtoDef(\rdn2).presetCompileString.editorInsert
(
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-E8E7-1M7C", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.17647058823529,
	'gain', 1.0,
	'fb', 0.0001,
	'delay', 0.33838551534282,
	'delay2', 0.41062499172443,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.2860080806106,
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
SynthDef(\basicpadxp, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env([1,2,1],[4.1,0.8])), 1);
	sig1 = SinOsc.ar(freq * [1,1+\det.kr(0.00001)]);
	sig2 = LFSaw.ar(freq * [1,1+\det.kr]);
	sig2 = sig2 * EnvGen.kr(\sawenv.kr(Env([0,1,0],[1.1,1.8])), 1);
	sig2 = LPF.ar(sig2, \lpf.kr(8000) * env1);

	sig1 = sig1 * Duty.kr(1/Rand(1,18)/~t, 0, Dseq([
		1,0,0,0,
	],inf));
	sig2 = sig1 * Duty.kr(1/Rand(1,18)/~t, 0, Dseq([
		1,0,0,0,
	],inf));

	sig = [sig1, sig2].sum / 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [1,-1], amp).mean;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\degree, Pseq((0..7),inf),
			\ctranspose, 5,
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basicpadxp,
			\note, Pstep(Pseq([
				[4, 9, 12],
				[2, 7, 10],
				[5, 9, 12],
				[5, 10, 14],
			],inf),2),
			\octave, 5,
			//\lpf, 15000,
			//\lpfr, 4,
			\dur, 2,
			//\hpf, 1000,
			\amp, 0.1 * Pseq([
				1,0.61,1.3,1,
			],inf).stutter(1)/1.5,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \sawautof,
			\note, Pseq([7,9],inf),
			\dur, PdurStutter(Prand([1,4,2,8,16],inf), 1/2),
			\lpfr, 3,
			\octave, Prand([
				6,[6,5],5
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			//\amp, 0.1,
			\amp, 0.1/2.7,
			\lag, -0.04,
			\out, BusDef(\sendbus3, \audio),
		),
		Ppar([0,2,5,7].collect { arg item, idx;
			Pbind(
				\isRest, Pstep(Pseq([
					Pseq([
						1,0,0,0, 0,0,0,0,
					].scramble,3),
					Pseq([
						1,1,1,1, 0,0,0,0,
					].scramble,1),
				],inf),1/4).coin.not,
			) <>
			Pfindur(2,Pbind(
				\instrument, \sawautof,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.4,0.1) ],
				],inf),
				\note, item,
				\legato, 0.4,
				\octave, [5,6].choose,
				\dur, Pseq([1,1,1/2,1,1/4,1/4,1].scramble,inf)/2,
				\amp, 0.1/1.7,
			)).loop
		}),
		
	])
)).play;
);
