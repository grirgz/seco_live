// track_ox
// BROKEN
~t = 135/4/60; TempoClock.default.tempo = ~t;

// use master for simpleMixer
// use rdn2 as routable fx
// use sendbus3 as sidechain input

FileSystemProject.load("lib/synth.scd")
	ProtoDef(\simpleMixer).edit
	ProtoDef(\simpleMixer).tracks[0].proxy.send
	ProtoDef(\simpleMixer).stop;

ProtoDef(\simpleMixer).tracks[0].proxy.set(\send3, 1);
ProtoDef(\simpleMixer).edit; // need to run this!!!
Ndef(\rdn3).clear

(
	~mymaster.();
	~master.();
	// static drone
//ProtoDef(\simpleMixer).play;
Pdef(\part, Pdef(\oxstatic,
	Ppar([
		4.collect {
			Pmono(  \droblip,
				\freq, Pseq([
					exprand(100.0,14000),
					exprand(100.0,14000),
				],inf).stutter([2,4,6,8].choose).stutter(4),
				\dur, 1,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,0,1,1,
					1,0,1,1,
			
				].scramble,inf)*0.1/4,
			);
		},
		1.collect {
			Pmono(  \droblipbass,
				\freq, Pseq([
					exprand(60.0,80),
					exprand(60.0,80),
				],inf).stutter([2,4,6,8].choose).stutter(4),
				\dur, 2,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,0,
				],inf)*0.1,
			);
		},

		Pmono(\comp,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\fx1, \audio),
			\sidebus, BusDef(\sendbus3, \audio),
			\cpt, 0.021,
			\cpabove, 0.1,
			\mix, 1,
			\dur, 1,
			\amp, 0.1,
		),

				Pbind(
					\out, BusDef(\mixer2),
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,0, 1,0,1, 1,0,0, 1,0,0,
						1,0,0, 1,0,1, 1,0,0, 1,0,0,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.05,0.1,0.8,0.02) ],
					],inf),
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.1,0.01,0.01

					],inf),
					\dur, 1/12,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0132,
				),
				Pbind(
					\out, BusDef(\mixer0),
					\instrument, \snapkick,
					\isRest, Pseq([
						1,0,0, 1,0,1,  0,0,1, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

						1,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						1,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
					],inf).coin.not,
					\sustain, 0.01,
					\dur, 1/12,
					\amp, 0.2,
				),
				Pbind(
					\instrument, \playersec,
					\out, BusDef(\mixer0),
					//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
					\bufnum, ~buflib.kick[966].value,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,1,
						1,0,0,1, 0,0,1,0,
					],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\gain, 0.21,
				),
				Pbind( // hi snare
					\out, BusDef(\mixer1),
					\instrument, \playersec,
					\bufnum, ~buflib.snare[760].value,
					\isRest, Pseq([
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/12,
					\gain, 0.2,
					\amp, 0.1/2,
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\bufnum, ~buflib.hat[778].value,
					\isRest, Pseq([
						0,0,0,1, 1,0,0,1,
						0,0,0,0, 0,1,0,0,
						0,0,0,0, 0,0,1,0,
						0,1,0,1, 0,0,1,1,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,1,1,1,
						1,0,1,0, 1,0,1,0, 
						

					],inf).coin.not,
					\pan, Pseq([1,-1],inf),
					\spread, 0.1,
					\sustain, 0.01 * Pseq([2,1,3,1/2, 1/2,1/4, Pseq([1.2,1/2,0.7,0.3],3)],inf) + Pwhite(0.001,0.051) * Pseg(Pseq([0.01,1],inf),8),
					\speed, ( Pseq([
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,1,1,
					],inf) * Pwhite(0.01,0.051) ) + 1,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1, )],
					],inf),
					\dur, 1/16,
					\gain, 0.21,
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\bufnum, ~buflib.hat[1364].value,
					\isRest, Pseq([
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 0,1,0,1,
						1,0,1,1, 1,1,1,1,
						1,1,1,1, 0,1,0,1,

						1,1,0,0, 1,0,0,1,
						1,1,1,1, 0,1,0,1,
						1,0,1,0, 1,1,1,1,
						1,1,1,1, 1,1,1,1,

						1,1,1,1, 0,0,0,0,
						1,0,1,0, 1,0,1,0, 
						1,1,1,0, 1,0,1,1,

					],inf).coin.not,
					\pan, Pseq([1,-1],inf),
					\spread, 0.1,
					\sustain, 0.01 * Pseq([2,1,3,1/2, 1/2,1/4, Pseq([1.2,1/2,0.7,0.3],3)],inf) + Pwhite(0.001,0.051) * Pseg(Pseq([0.01,1],inf),8),
					\speed, ( Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,1,1,
					],inf) * Pwhite(0.01,0.051) ) + 1,
					\lag, Pseq([0,0.1],inf) * Pwhite(0.0001,0.1),
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.2,1,-4) ],
					],inf),
					\dur, 1/8,
					\gain, 0.21,
				),
				Pbind( // low snare
					\out, BusDef(\drumchain, \audio),
					\instrument, \snaretuned,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.13) ],
					],inf),
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
						0,0,1, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,1, 0,0,0,
					],inf).coin.not,
					//\lag, 0.120/~t,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/4,
					\isRest, true,
				),
	].flat),
));
Pdef(\part).play;
);

ProtoDef(\simpleMixer).edit
ProtoDef(\rdn2).edit
ProtoDef(\rdn).edit
Ndef(\ota).play
Ndef(\ota).stop

(
	// waving drone
~mymaster.();
~master.();
Pdef(\part, Pdef(\oxwave,
	Ppar([
		4.collect {
			Pmono(  \droblip,
				\freq, ~pmodenv.(Pseq([exprand(100.0,14000),exprand(100.0,14000)],inf), 8),
				\dur, 1,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,0,1,1,
					1,0,1,1,
			
				].scramble,inf)*0.1/4,
			);
		},
		1.collect {
			Pmono(  \droblipbass,
				\freq, Pseq([
					exprand(60.0,80),
					exprand(60.0,80),
				],inf).stutter([2,4,6,8].choose).stutter(4),
				\dur, 2,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,0,
				],inf)*0.1,
			);
		},

		Pmono(\concombre,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\fx1, \audio),
			\sidebus, BusDef(\sendbus3, \audio),
			\cpt, 0.021,
			\cpabove, 0.1,
			\dur, 1,
			\amp, 0.1,
		),

				Pbind(
					\out, BusDef(\mixer2),
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,0, 1,0,1, 1,0,0, 1,0,0,
						1,0,0, 1,0,1, 1,0,0, 1,0,0,
						1,0,1, 1,0,1, 1,0,0, 1,0,1,
						1,0,0, 1,1,0, 0,1,1, 1,0,0,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.05,0.1,0.8,0.02) ],
					],inf),
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.1,0.01,0.01

					],inf),
					\dur, 1/12,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0132,
				),
				Pbind(
					\out, BusDef(\mixer0),
					\instrument, \snapkick,
					\isRest, Pseq([

						1,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						1,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
					],inf).coin.not,
					\sustain, 0.01,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind(
					\instrument, Pseq([\playersec_zix2],inf).stutter(8*4),
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						2.2
					],inf).stutter(1),
					\isRest, Pseq([
						3,0,0,
					],inf).coin.not,
					\speed, 0.95,
					\legato, Pseq([
						Pser([
							0.4,0.1,0.1,
							0.2,0.1,0.1,
						],8*2)*2,
					],inf),
					\legato, Pseq([
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 0,0,1, 1,0,0,

							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 1,0,0, 2,0,0,
							20,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind(
					\instrument, Pseq([\playersec_zix2],inf).stutter(8*4),
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						0.1
					],inf).stutter(1),
					\isRest, Pseq([
						3,0,0,
					],inf).coin.not,
					\speed, 1,
					\legato, Pseq([
						Pser([
							0.4,0.1,0.1,
							0.2,0.1,0.1,
						],8*2)*2,
					],inf),
					\legato, Pseq([
						18,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,1, 0,0,1,

						18,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0, 0,0,0,

						18,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

						0,0,0, 0,0,0, 0,0,1, 0,1,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,1, 0,1,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // hi snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/2,
				),
				Pbind( // low snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.13) ],
					],inf),
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 0,0,0,  0,0,1, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 1,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,1, 0,0,0,
					],inf).coin.not,
					//\lag, 0.120/~t,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/4,
				),
	].flat),
)).play;
);

(
	// end waving bass & drone
~mymaster.();
~master.();
Pdef(\part, Pdef(\oxendwave,
	Ppar([
		4.collect {
			Pmono(  \droblip,
				\freq, ~pmodenv.(Pseq([exprand(100.0,14000)!3,exprand(100.0,14000)].flatten,inf), 4),
				\dur, 1,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,0,1,1,
					1,0,1,1,
			
				].scramble,inf)*0.1/4,
			);
		},
		1.collect {
			Pmono(  \droblipbass,
				\freq, Pseq([
					~pmodenv.(Pseq([exprand(60.0,80)!3,exprand(60.0,180)].flatten,inf), 4),
				],inf).stutter([2,4,6,8].choose).stutter(4),
				\dur, 2,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,0,
				],inf)*0.1,
			);
		},

		Pmono(\concombre,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\fx1, \audio),
			\sidebus, BusDef(\sendbus3, \audio),
			\cpt, 0.021,
			\cpabove, 0.1,
			\dur, 1,
			\amp, 0.1,
		),

				Pbind(
					\out, BusDef(\mixer2),
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,0, 1,0,1, 1,0,0, 1,0,0,
						1,0,0, 1,0,1, 1,0,0, 1,0,0,
						1,0,1, 1,0,1, 1,0,0, 1,0,1,
						1,0,0, 1,1,0, 0,1,1, 1,0,0,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.05,0.1,0.8,0.02) ],
					],inf),
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.1,0.01,0.01

					],inf),
					\dur, 1/12,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0132,
				),
				Pbind(
					\out, BusDef(\mixer0),
					\instrument, \snapkick,
					\isRest, Pseq([

						1,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						1,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
					],inf).coin.not,
					\sustain, 0.01,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind(
					\instrument, Pseq([\playersec_zix2],inf).stutter(8*4),
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						2.2
					],inf).stutter(1),
					\isRest, Pseq([
						3,0,0,
					],inf).coin.not,
					\speed, 0.95,
					\legato, Pseq([
						Pser([
							0.4,0.1,0.1,
							0.2,0.1,0.1,
						],8*2)*2,
					],inf),
					\legato, Pseq([
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 0,0,1, 1,0,0,

							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 1,0,0, 2,0,0,
							20,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind(
					\instrument, Pseq([\playersec_zix2],inf).stutter(8*4),
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						0.1
					],inf).stutter(1),
					\isRest, Pseq([
						3,0,0,
					],inf).coin.not,
					\speed, 1,
					\legato, Pseq([
						Pser([
							0.4,0.1,0.1,
							0.2,0.1,0.1,
						],8*2)*2,
					],inf),
					\legato, Pseq([
						18,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,1, 0,0,1,

						18,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0, 0,0,0,

						18,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

						0,0,0, 0,0,0, 0,0,1, 0,1,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,1, 0,1,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // hi snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/2,
				),
				Pbind( // low snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.13) ],
					],inf),
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 0,0,0,  0,0,1, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 1,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,1, 0,0,0,
					],inf).coin.not,
					//\lag, 0.120/~t,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/4,
				),
	].flat),
)).play;
);

(
	// fastbass
~master.();
Pdef(\part, Pdef(\oxfast,
	Ppar([
		1.collect {
			Pmono(  \droblip,
				\freq, Pseq([9,0],inf).midiratio* 65*8,
				\dur, 1/4,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,0,1,1,
					1,0,1,1,
			
				].scramble,inf)*0.1/4,
			);
		},
		1.collect {
			Pmono(  \droblipbass,
				\freq, Pseq([
					~pmodenv.(Pseq([exprand(60.0,80)!3,exprand(60.0,180)].flatten,inf), 4),
				],inf).stutter([2,4,6,8].choose).stutter(4),
				\dur, 1/2,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,0,
				],inf)*0.1,
				\isRest, true,
			);
		},

		Pmono(\concombre,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\fx1, \audio),
			\sidebus, BusDef(\sendbus3, \audio),
			\cpt, 0.021,
			\cpabove, 0.1,
			\dur, 1,
			\amp, 0.1,
		),

				Pbind(
					\out, BusDef(\mixer2),
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,0, 1,0,0, 1,0,0, 1,0,0,
						1,0,0, 1,0,0, 1,0,0, 1,0,0,
						1,0,0, 1,0,0, 1,0,0, 1,0,0,
						1,0,1, 1,1,0, 1,1,0, 1,1,0,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.05,0.1,0.8,0.02) ],
					],inf),
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.1,0.01,0.01

					],inf),
					\dur, 1/12,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0132,
				),
				Pbind(
					\out, BusDef(\mixer0),
					\instrument, \snapkick,
					\isRest, Pseq([

						1,0,0, 1,0,0,  0,0,0, 0,0,1,
						1,0,0, 1,0,0,  0,0,0, 0,0,0,
						1,0,0, 1,0,0,  0,0,0, 0,0,1,
						1,0,0, 1,0,0,  0,0,1, 0,0,0,

						1,0,0, 1,0,0,  0,0,0, 0,0,1,
						1,0,0, 1,0,0,  0,0,0, 0,0,0,
						1,0,0, 0,0,1,  0,0,0, 0,0,1,
						1,0,1, 1,0,0,  0,0,0, 0,0,0,

						1,0,0, 1,0,0,  0,0,0, 0,0,1,
						1,0,0, 1,0,0,  0,0,0, 0,0,0,
						1,0,0, 1,0,0,  0,0,1, 0,0,1,
						1,0,0, 1,0,1,  0,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.01,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // oscsmp bass
					\instrument, \playersec_osc,
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						2.2
					],inf).stutter(1),
					\trigfreq, 65,
					\pos, ~pmodsynth.({ 
						SinOsc.kr(1/20).range(0,0.01)+1.7 + Duty.kr(1/8/~t, 0, Dseq([
							0,Dwhite(0.1,0.4,1),0,0,
						],inf)) 
					}),
					\speed, 0.95,
					\legato, Pseq([
							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							6,0,0, 0,0,0, 0,0,0, 0,0,00.81,
							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							6,0,0, 0,0,0, 0,0,1, 0,0,00.8,

							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							6,0,0, 0,0,0, 0,0,0, 0,0,00.81,
							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							4,0,0, 0,1,0, 0,0,1, 0,0,00.81,

							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							6,0,0, 0,0,0, 0,0,0, 0,0,00.81,
							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							3,0,0, 3,0,0, 0,0,0, 0,0,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // oscsmp lead
					\instrument, \playersec_osczig_fat,
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						2.2
					],inf).stutter(1),
					\trigfreq, Pseq([
						 {
							(0..24).choose
						}.dup(7).sort.reverse.midiratio * 65*16,
						 {
							(0..24).choose
						}.dup(1).sort.reverse.midiratio * 65*16,
						 {
							(0..24).choose
						}.dup(7).sort.reverse.midiratio * 65*16,
						 {
							(0..24).choose
						}.dup(1).sort.reverse.midiratio * 65*16,
					].flatten,inf).stutter(12),
					\pos, ~pmodsynth.({ 
						SinOsc.kr(1/32).range(0,0.1)+0.3  +
						SinOsc.kr(2 * ( 1 + ( SinOsc.kr(1/82) * 4 ))).range(0,0.01) 
					}),
					\speed, 0.95,
					\legato, Pseq([
							9,0,0, 0,0,0, 0,0,0, 0,0,0,
							6,0,0, 0,0,0, 0,0,0, 3,0,0,
							9,0,0, 0,0,0, 0,0,0, 0,0,0,
							2,0,0, 0,0,0, 1,1,0, 2,0,0,
					],inf),
					\rq, 0.2,
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\lpmix, 1,
					\lpfr, 0.7,
					\gain, 0.2,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // hi snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/2,
				),
				Pbind( // low snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.13) ],
					],inf),
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 0,0,0,  0,0,1, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 1,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,1, 0,0,0,
					],inf).coin.not,
					//\lag, 0.120/~t,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/4,
				),
	].flat),
)).play;
);


(
	// fastbass 2
~master.();
Pdef(\part, Pdef(\oxfast2,
	Ppar([
		1.collect {
			Pmono(  \droblip,
				\freq, Pseq([9,0],inf).midiratio* 65*8,
				\dur, 1/4,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,0,1,1,
					1,0,1,1,
			
				].scramble,inf)*0.1/4,
			);
		},
		1.collect {
			Pmono(  \droblipbass,
				\freq, Pseq([
					~pmodenv.(Pseq([exprand(60.0,80)!3,exprand(60.0,180)].flatten,inf), 4),
				],inf).stutter([2,4,6,8].choose).stutter(4),
				\dur, 1/2,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,0,
				],inf)*0.1,
				\isRest, true,
			);
		},

		Pmono(\concombre,
			\group, Pdefn(\fxgroup),
			\inbus, BusDef(\fx1, \audio),
			\sidebus, BusDef(\fx1, \audio),
			\cpt, 0.021,
			\cpabove, 0.1,
			\dur, 1,
			\amp, 0.1,
		),

				Pbind(
					\instrument, \phyhat3,
					\out, BusDef(\mixer2),
					\isRest, Pseq([
						1,0,0, 1,0,0, 1,0,0, 1,0,0,
						1,0,0, 1,0,0, 1,0,0, 1,0,0,
						1,0,0, 1,0,0, 1,0,0, 1,0,0,
						1,0,1, 1,1,0, 1,1,0, 1,1,0,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.05,0.1,0.8,0.02) ],
					],inf),
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.1,0.01,0.01

					],inf),
					\dur, 1/12,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0132,
				),
				Pbind(
					\instrument, \snapkick,
					\out, BusDef(\mixer0),
					\isRest, Pseq([

						1,0,0, 1,0,0,  0,0,0, 0,0,1,
						1,0,0, 1,0,0,  0,0,0, 0,0,0,
						1,0,0, 1,0,0,  0,0,0, 0,0,1,
						1,0,0, 1,0,0,  0,0,1, 0,0,0,

						1,0,0, 1,0,0,  0,0,0, 0,0,1,
						1,0,0, 1,0,0,  0,0,0, 0,0,0,
						1,0,0, 0,0,1,  0,0,0, 0,0,1,
						1,0,1, 1,0,0,  0,0,0, 0,0,0,

						1,0,0, 1,0,0,  0,0,0, 0,0,1,
						1,0,0, 1,0,0,  0,0,0, 0,0,0,
						1,0,0, 1,0,0,  0,0,1, 0,0,1,
						1,0,0, 1,0,1,  0,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.01,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // oscsmp bass
					\instrument, \playersec_osc,
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						2.2
					],inf).stutter(1),
					\trigfreq, 65,
					\pos, ~pmodsynth.({ 
						SinOsc.kr(1/20).range(0,0.01)+1.7 + Duty.kr(1/8/~t, 0, Dseq([
							0,Dwhite(0.1,0.4,1),0,0,
						],inf)) 
					}),
					\speed, 0.95,
					\legato, Pseq([
							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							6,0,0, 0,0,0, 0,0,0, 0,0,00.81,
							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							6,0,0, 0,0,0, 0,0,1, 0,0,00.8,

							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							6,0,0, 0,0,0, 0,0,0, 0,0,00.81,
							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							4,0,0, 0,1,0, 0,0,1, 0,0,00.81,

							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							6,0,0, 0,0,0, 0,0,0, 0,0,00.81,
							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							3,0,0, 3,0,0, 0,0,0, 0,0,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),

				Pmono(\oscsampler3,
					\finepos, Pseq([0,0,0.0004,0.01004],inf) + Pseq([0,0.1,0.20,0.25],inf).stutter(8),
					\fineposlag, 0.4,
					\pos, 1.2,
					\freq, 65 * Pseq([
						[0,9,8],
						[0,7,2],
					],inf).midiratio.stutter(4) * 4,
					\ffreq, ~pmodenv.(Pseq([100,3200,4000,10000],inf), 8),
					\bufnum, BufDef('voices/feynman.flac'),
					\ffreqtab, Pseq([[Array.geom(8,1.0,1.01).postln]],inf),
					\range, 0.0001,
					\posenv, Pseq([
						[ Env([0.00,0.014,0.0].integrate.postln,[0.42,8.4]) ],
					],inf),
					\amp, 0.1/2,
					\dur, 1,
				),
				Pbind( // hi snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/2,
					\instrument, \playersec,
					\bufnum, ~buflib.snare[924].value,
					\sustain, 0.2,
					\gain, 0.3,
				),
				Pbind( // low snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.13) ],
					],inf),
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 0,0,0,  0,0,1, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 1,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,1, 0,0,0,
					],inf).coin.not,
					//\lag, 0.120/~t,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/4,
				),
	].flat),
)).play;
);

(
	// short
~master.();
Pdef(\part, Pdef(\oxtrans1,
	Ppar([
		1.collect {
			Pmono(  \droblip,
				\freq, exprand(100.0,14000),
				\dur, 1/3,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,1,0,
					0,0,0,
			
				],inf)*0.1/4,
			);
		},
		1.collect {
			Pmono(  \droblip,
				\freq, exprand(100.0,14000),
				\dur, 1/6,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					0,0,0, 0,0,0,
					1,0,1, 1,0,0,
			
				],inf)*0.1/4,
			);
		},
		1.collect {
			Pmono(  \droblipbass,
				\freq, 65,
				\dur, 1/12,
				//\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					1,1,1, 1,1,1,  0,0,0, 0,0,0,
				],inf)*0.1,
			);
		},

		Pmono(\concombre,
			\group, Pdefn(\fxgroup),
			\inbus, BusDef(\fx1, \audio),
			\sidebus, BusDef(\fx1, \audio),
			//\sidebus, BusDef(\sendbus3, \audio),
			\cpt, 0.021,
			\cpabove, 0.1,
			\dur, 1,
			\amp, 0.1,
		),

				Pbind(
					\out, BusDef(\mixer2),
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,0, 1,0,0, 1,0,0, 1,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.05,0.1,0.8,0.02) ],
					],inf),
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.1,0.01,0.01

					],inf),
					\dur, 1/12,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0132,
				),
				Pbind(
					\out, BusDef(\mixer0),
					\instrument, \snapkick,
					\isRest, Pseq([

						1,0,0, 1,0,0,  1,0,0, 1,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
					],inf).coin.not,
					\sustain, 0.01,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // hi snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						1,0,0, 0,0,0,  0,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/2,
					\instrument, \playersec,
					\bufnum, ~buflib.snare[949].value,
					\sustain, 0.2,
					\gain, 0.3,
				),
				Pbind( // low snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.13) ],
					],inf),
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

					],inf).coin.not,
					//\lag, 0.120/~t,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/4,
				),
				Pbind(
					\instrument, Pseq([\playersec_zix2],inf).stutter(8*4),
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						2.2
					],inf).stutter(1),
					\isRest, Pseq([
						3,0,0,
					],inf).coin.not,
					\speed, 0.95,
					\legato, Pseq([
						Pser([
							0.4,0.1,0.1,
							0.2,0.1,0.1,
						],8*2)*2,
					],inf),
					\legato, Pseq([
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 1,0,0, 2,0,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind(
					\instrument, Pseq([\playersec_zix2],inf).stutter(8*4),
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						0.1
					],inf).stutter(1),
					\isRest, Pseq([
						3,0,0,
					],inf).coin.not,
					\speed, 1,
					\legato, Pseq([
						Pser([
							0.4,0.1,0.1,
							0.2,0.1,0.1,
						],8*2)*2,
					],inf),
					\legato, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,1, 0,0,1,

					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
	].flat),
)).play;
);

(
	// short2
~mymaster.();
~master.();
Pdef(\part, Pdef(\oxtrans2,
	Ppar([
		1.collect {
			Pmono(  \droblip,
				\freq, exprand(100.0,14000),
				\dur, 1/3,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,1,0,
					0,0,0,
			
				],inf)*0.1/4,
			);
		},
		1.collect {
			Pmono(  \droblip,
				\freq, exprand(100.0,14000),
				\dur, 1/6,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					0,0,0, 0,0,0,
					1,0,1, 1,0,0,
			
				],inf)*0.1/4,
			);
		},
		1.collect {
			Pmono(  \droblipbass,
				\freq, 65,
				\dur, 1/12,
				//\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					1,1,1, 1,1,1,  0,0,0, 0,0,0,
				],inf)*0.1,
			);
		},

		Pmono(\concombre,
			\group, Pdefn(\fxgroup),
			\inbus, BusDef(\fx1, \audio),
			\sidebus, BusDef(\sendbus3, \audio),
			\cpt, 0.021,
			\cpabove, 0.1,
			\dur, 1,
			\amp, 0.1,
		),

				Pbind(
					\out, BusDef(\mixer2),
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,0, 1,0,0,  1,0,0, 1,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.05,0.1,0.8,0.02) ],
					],inf),
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.1,0.01,0.01

					],inf),
					\dur, 1/12,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0132,
				),
				Pbind(
					\out, BusDef(\mixer0),
					\instrument, \snapkick,
					\isRest, Pseq([
						1,0,0, 1,0,0, 0,0,0, 0,0,1,
						1,0,0, 0,0,1,  1,0,1, 1,0,0,

					],inf).coin.not,
					\sustain, 0.01,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // hi snare
					\out, BusDef(\mixer1),
					\isRest, Pseq([
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/2,
					\instrument, \playersec,
					\bufnum, ~buflib.snare[213].value,
					\sustain, 0.1,
					\gain, 0.3,
				),
				Pbind( // low snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.13) ],
					],inf),
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

					],inf).coin.not,
					//\lag, 0.120/~t,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/4,
				),
				Pbind(
					\instrument, Pseq([\playersec_zix2],inf).stutter(8*4),
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						2.2
					],inf).stutter(1),
					\isRest, Pseq([
						3,0,0,
					],inf).coin.not,
					\speed, 0.95,
					\legato, Pseq([
						Pser([
							0.4,0.1,0.1,
							0.2,0.1,0.1,
						],8*2)*2,
					],inf),
					\legato, Pseq([
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 1,0,0, 2,0,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind(
					\instrument, Pseq([\playersec_zix2],inf).stutter(8*4),
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						0.1
					],inf).stutter(1),
					\isRest, Pseq([
						3,0,0,
					],inf).coin.not,
					\speed, 1,
					\legato, Pseq([
						Pser([
							0.4,0.1,0.1,
							0.2,0.1,0.1,
						],8*2)*2,
					],inf),
					\legato, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,1, 0,0,1,

					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
	].flat),
)).play;
);

(
	// static endbar
~mymaster.();
~master.();
Pdef(\part, Pdef(\oxstatic_endbar,

	Ppar([
		4.collect {
			Pmono(  \droblip,
				\freq, Pseq([
					exprand(100.0,14000),
					exprand(100.0,14000),
				],inf).stutter([2,4,6,8].choose).stutter(4),
				\dur, 1,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,
					1,
					0,
					0,
				],inf)*0.1/4,
			);
		},
		1.collect {
			Pmono(  \droblipbass,
				\freq, Pseq([
					exprand(60.0,80),
					exprand(60.0,80),
				],inf).stutter([2,4,6,8].choose).stutter(4),
				\dur, 2,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,0,
				],inf)*0.1,
			);
		},

		Pmono(\comp,
			\group, Pdefn(\fxgroup),
			\inbus, BusDef(\fx1, \audio),
			\sidebus, BusDef(\sendbus3, \audio),
			\cpt, 0.021,
			\cpabove, 0.1,
			\dur, 1,
			\amp, 0.1,
		),

				Pbind(
					\out, BusDef(\mixer2),
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,0, 1,0,1, 1,0,0, 1,0,0,
						1,0,0, 1,0,1, 1,0,0, 1,0,0,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.05,0.1,0.8,0.02) ],
					],inf),
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.1,0.01,0.01

					],inf),
					\dur, 1/12,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0132,
				),
				Pbind(
					\out, BusDef(\mixer0),
					\instrument, \snapkick,
					\isRest, Pseq([

						1,0,0, 0,0,0,  0,0,0, 0,0,0,
						1,0,0, 0,0,0,  0,0,0, 0,0,1,
						1,0,0, 0,0,1,  1,0,1, 1,0,0,
						1,0,0, 0,0,1,  0,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.01,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // hi snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/2,
				),
				Pbind( // low snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.13) ],
					],inf),
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 0,0,0,
					],inf).coin.not,
					//\lag, 0.120/~t,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/4,
				),
				Pbind(
					\instrument, Pseq([\playersec_zix2],inf).stutter(8*4),
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						2.2
					],inf).stutter(1),
					\isRest, Pseq([
						3,0,0,
					],inf).coin.not,
					\speed, 0.95,
					\legato, Pseq([
						Pser([
							0.4,0.1,0.1,
							0.2,0.1,0.1,
						],8*2)*2,
					],inf),
					\legato, Pseq([
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 4,0,0, 0,1,0,
							0,0,0, 0,0,2, 0,0,2, 0,1,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // oscsmp lead
					\instrument, \playersec_osczig_fat,
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						2.2
					],inf).stutter(1),
					\trigfreq, Pseq([
						 {
							(0..24).choose
						}.dup(7).sort.reverse.midiratio * 65*16,
						 {
							(0..24).choose
						}.dup(1).sort.reverse.midiratio * 65*16,
						 {
							(0..24).choose
						}.dup(7).sort.reverse.midiratio * 65*16,
						 {
							(0..24).choose
						}.dup(1).sort.reverse.midiratio * 65*16,
					].flatten,inf).stutter(12),
					\pos, ~pmodsynth.({ 
						SinOsc.kr(1/32).range(0,0.1)+0.3  +
						SinOsc.kr(2 * ( 1 + ( SinOsc.kr(1/82) * 4 ))).range(0,0.01) 
					}),
					\speed, 0.95,
					\legato, Pseq([
							0,0,0, 0,0,0,  0,0,0, 0,0,0,
							0,0,0, 0,0,0,  0,0,0, 0,0,0,
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							6,0,0, 0,0,0, 0,0,0, 3,0,0,
					],inf),
					\rq, 0.2,
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\lpmix, 1,
					\lpfr, 0.7,
					\gain, 0.2,
					\dur, 1/12,
					\amp, 0.1,
				),
	].flat),

)).play;
);

(
	// fast endbar
~mymaster.();
~master.();
Pdef(\part, Pdef(\oxfast_endbar,

	Ppar([
		1.collect {
			Pmono(  \droblip,
				\freq, Pseq([9,0],inf).midiratio* 65*8,
				\dur, 1/4,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,0,1,1,
					1,0,1,1,
			
				].scramble,inf)*0.1/4,
			);
		},

		Pmono(\concombre,
			\group, Pdefn(\fxgroup),
			\inbus, BusDef(\fx1, \audio),
			\sidebus, BusDef(\sendbus3, \audio),
			\cpt, 0.021,
			\cpabove, 0.1,
			\dur, 1,
			\amp, 0.1,
		),

				Pbind(
					\out, BusDef(\mixer2),
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,0, 1,0,0, 1,0,0, 1,0,0,
						1,0,0, 1,0,0, 1,0,0, 1,0,0,
						0,0,0, 1,1,1,  0,0,0, 0,0,0,
						0,0,0, 1,1,1,  0,0,0, 0,0,0,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.05,0.1,0.8,0.02) ],
					],inf),
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.1,0.01,0.01

					],inf),
					\dur, 1/12,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0132,
				),
				Pbind(
					\out, BusDef(\mixer0),
					\instrument, \snapkick,
					\isRest, Pseq([

						1,0,0, 1,0,0,  0,0,0, 0,0,1,
						1,0,0, 1,0,0,  0,0,0, 0,0,0,
						1,0,0, 1,1,0,  0,0,0, 1,0,1,
						1,0,1, 1,0,1,  1,0,0, 1,0,1,
					],inf).coin.not,
					\sustain, 0.01,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // hi snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/2,
				),
				Pbind( // low snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.13) ],
					],inf),
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 0,0,0,  0,0,1, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 1,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,1, 0,0,0,
					],inf).coin.not,
					//\lag, 0.120/~t,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/4,
				),
				Pbind( // oscsmp bass
					\instrument, \playersec_osc,
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						2.2
					],inf).stutter(1),
					\trigfreq, 65,
					\pos, ~pmodsynth.({ 
						SinOsc.kr(1/20).range(0,0.01)+1.7 + Duty.kr(1/8/~t, 0, Dseq([
							0,Dwhite(0.1,0.4,1),0,0,
						],inf)) 
					}),
					\speed, 0.95,
					\legato, Pseq([
							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							6,0,0, 0,0,0, 0,0,0, 0,0,00.81,
							1,0,0, 0,0,0, 1,0,0, 0,0,00,
							0,0,0, 0,0,0, 1,0,0, 3,0,00,

					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // oscsmp lead
					\instrument, \playersec_osczig_fat,
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						2.2
					],inf).stutter(1),
					\trigfreq, Pseq([
						 {
							(0..24).choose
						}.dup(7).sort.reverse.midiratio * 65*16,
						 {
							(0..24).choose
						}.dup(1).sort.reverse.midiratio * 65*16,
						 {
							(0..24).choose
						}.dup(7).sort.reverse.midiratio * 65*16,
						 {
							(0..24).choose
						}.dup(1).sort.reverse.midiratio * 65*16,
					].flatten,inf).stutter(12),
					\pos, ~pmodsynth.({ 
						SinOsc.kr(1/32).range(0,0.1)+0.3  +
						SinOsc.kr(2 * ( 1 + ( SinOsc.kr(1/82) * 4 ))).range(0,0.01) 
					}),
					\speed, 0.95,
					\legato, Pseq([
							9,0,0, 0,0,0, 0,0,0, 0,0,0,
							6,0,0, 0,0,0, 0,0,0, 3,0,0,
							9,0,0, 0,0,0, 0,0,0, 0,0,0,
							2,0,0, 0,0,0, 1,1,0, 2,0,0,
					],inf),
					\rq, 0.2,
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\lpmix, 1,
					\lpfr, 0.7,
					\gain, 0.2,
					\dur, 1/12,
					\amp, 0.1,
				),
	].flat),

)).play;
);

//////////////// MAIN

Ndef(\rdn2).end
(
~mymaster.();
~master.();
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(12,
			Pdef(\oxstatic),
		),
		Pfindur(4,
			Pdef(\oxstatic_endbar),
		),
		Pfindur(12,
			Pdef(\oxfast),
		),
		Pfindur(4,
			Pdef(\oxfast_endbar),
		),
		Pfindur(12,
			Pdef(\oxwave),
		),
		Pfindur(4,
			Pdef(\oxstatic_endbar),
		),
		Pfindur(12,
			Pdef(\oxfast2),
		),
		Pfindur(4,
			Pdef(\oxfast_endbar),
		),
		Pfindur(12,
			Pdef(\oxendwave),
		),
		Pfindur(4,
			Pdef(\oxtrans2),
		),
		
	])
)).play;
)

Pdef(\part,Pdef(\oxstatic_endbar)).play
Pdef(\part).clear;
