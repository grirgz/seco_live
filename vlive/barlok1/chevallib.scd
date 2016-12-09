Ndef(\fx1).addSpec(\deltran1, ControlSpec(-1,5,\lin, 0,1));
Ndef(\fx1).addSpec(\deltran2, ControlSpec(-1,5,\lin,0,0));
Ndef(\fx1).addSpec(\deltran3, ControlSpec(-1,5,\lin,0,0));

BusDef(\fx1, \audio, 2);

	(
		Pdef(\smpdrum1, Ppar([
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\kick],
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 2,
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\kick],
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0.21, 1,0,0.3,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\pos, 0.02,
				\legato, 1,
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\snare],
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\legato, Pseq([8,8,2,8,2,2],inf).stutter(16),
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\snare],
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,1,0,0,
				],inf).coin.not,
				\pos, 0.04,
				\dur, 1/8,
				\legato, 1,
				\amp, 0.1
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\snare],
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\pos, 0.01,
				\dur, 1/8,
				\legato, 1,
				\amp, 0.1
			),

			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\hat],
				\speed, 0.6,
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					1,0, 1,0, 1,0, 1,0,
					0,0, 0,0, 1,0, 1,0,
					0,1, 1,0, 1,0, 1,0,
					0,0, 0,0, 1,0, 1,0,
					1,0, 1,0, 1,0.5, 1,0,
					0,0, 0,0, 1,0, 1,0,
					0.61,1, 1,0, 0,1, 1,0,
					0,0, 0,0, 1,0, 1,0,
				],inf).coin.not,
				\pos, 0.01/~t + Pseq([1.1,0.1,0.2,0],inf).stutter(2),
				\dur, 1/8,
				\legato, Pseq([
					1/2,1/4,1/4,1/4,
					1/2,1/4,1,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,

					1/2,1/4,2,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
				],inf),
				\amp, 0.1
			),

	]));
	Pdef(\smpdrum1).set(\out, BusDef(\fx1));
	//Pdef(\drum1).set(\out, 0);
	//Pdef(\main, Pdef(\smpdrum1)).play;
	//Ndef(\fx1).play;
	);

	(
		Pdef(\smpdrum2, Ppar([
			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\kick],
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,1,0,
					1,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					4,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				],inf),
				\pos, Pseq([
					Pseq([
						0
					],1),
					Pseq([
						0.02
					],7),
				],inf)/~t,
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\snare],
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\legato, Pseq([8,8,2,8,2,2],inf).stutter(16),
				\legato, 1,
				\amp, 0.2
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\snare],
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\pos, 0.04/~t,
				\dur, 1/8,
				\legato, Pseq([8,8,2,8,2,2],inf).stutter(16),
				\legato, 2,
				\amp, 0.2
			),

		PmonoArtic(\snaphihat,
			\dur, 1/8,
			\itrig, Pseq([
				1,1,1,1,
			],inf),
			//\out, 0,
			\rel, Pseq([
				1,0.2,1,0, 1,0,1,0,
				1,0,1,0.51, 1,0.2,1,0,
				1,0,1,0, 1,0,1,0,
				1,0.2,0.4,0.2, 1,0,1,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,1,0,
			],inf)/20,
			\level, Pseq([1,1.2,1.1,1.4],inf).stutter(4)/2,
			\amp, Pkey(\amp) * Pseq([
				1,0.3,0.5,0.3,
			],inf),
			\isRest, Pkey(\rel).collect(_ <= 0),
			\legato, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],15),
				1,1,1,1, 1,1,1,0.99,
			],inf),
			\amp, 0.1/2
		),


	]));
	Pdef(\smpdrum2).set(\out, BusDef(\fx1));
	//Pdef(\smpdrum2).set(\out, 0);
	//Pdef(\main, Pdef(\smpdrum2)).play;
	//Ndef(\fx1).play;
	);

	(
		Pdef(\smpdrum3, Ppar([
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\kick],
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 2,
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\kick],
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0.21, 1,0,0.3,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\pos, 0.02,
				\legato, 1,
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\snare],
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,

					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\pos, Pseq([
					0, Pn(0.1,7),
				],inf).stutter(1)/~t,
				\dur, 1/8,
				\legato, Pseq([1,2,2,3,2,2],inf).stutter(16),
				\amp, 0.2
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\snare],
				\degree, Pseq([0],inf),
				\speed, -0.8,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\pos, 1/8/~t,
				\dur, 1/8,
				\legato, 2,
				\gain, 0.5,
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\snare],
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\pos, 0.01,
				\dur, 1/8,
				\legato, 1,
				\amp, 0.1
			),

			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\hat],
				\speed, 0.5,
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					Pser([1,0,0,0],16),

					Pser([1,0],8),
					0,0,0,0, 1,0.51,1,0.61,

					Pser([1,0,1,0],8),
					Pser([1,0.2,0.5,0.1],4), Pser([1,0],4),

					Pser([1,0,0,0],8),
					0,0,0,0, 1,1,1,1,

				],inf).coin.not,
				\pos, 0.01/~t + Pseq([1.1,0.1,0.2,0],inf).stutter(2),
				\dur, 1/8,
				\legato, Pseq([
					1/2,1/4,1/4,1/4,
					1/2,1/4,1,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,

					1/2,1/4,2,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
				],inf)*2,
				\gain, 1/2,
				\amp, 0.1
			),

	]));
	Pdef(\smpdrum3).set(\out, BusDef(\fx1));
	//Pdef(\drum1).set(\out, 0);
	//Pdef(\main, Pdef(\smpdrum3)).play;
	//Ndef(\fx1).play;
	);

	(
		~name = \smpdrum4;
		Pdef(~name, Ppar([
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\kick],
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, Pseq([
					2,1,1,1, 1,1,1,1,
				],inf),
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\snare],
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,1,0,0,
					0,0,0,0, 1,0,0,0,
					1,0,0,0, 0,1,0,0,
				],inf).coin.not,
				\legato, Pseq([
					4,1,1,1, 1,1,1,1,
				],inf)/2,
				\lag, Pseq([
					0,Pseq([0.17],7),
				],inf),
				\pos, Pseq([
					0,0,0.1,0.1, 0.1,1/2,0,0,
				],inf)/~t,
				\dur, 1/8,
				\gain, 1.4,
				\amp, 0.2
			),

			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\hat],
				\speed, 1.0,
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					Pser([1,0,1,0],16),


				],inf).coin.not,
				\pos, 0.01/~t + Pseq([1.1,0.1,0.2,0],inf).stutter(2),
				//\pos, 0.01,
				\pos, Pseq([
					0,0,0,0,
					0,0.1,0.01,0,
				],inf).stutter(2),
				\dur, 1/8,
				\legato, Pseq([
					1/2,1/4,1/4,1/4,
					1/2,1/4,1,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,

					1/2,1/4,2,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
				],inf)*2,
				\gain, 1/2,
				\amp, 0.1
			),

	]));
	Pdef(~name).set(\out, BusDef(\fx1));
	//Pdef(\drum1).set(\out, 0);
	//Pdef(\main, Pdef(~name)).play;
	//Ndef(\fx1).play;
	);

	(
		~name = \smpdrum5;
		Pdef(~name, Ppar([
			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\kick],
				\isRest, Pseq([
					1,0,1,0, 1,0,0,1,
					0,0,1,0, 1,0,1,0,
					1,0,1,1, 1,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,1,0, 1,0,0,1,
					0,0,0,0, 0,0,0,0,
					1,0,1,1, 1,0,0,0,
					0,0,0,0, 0,0,0,0,

				],inf).coin.not,
				\pos, Pseq([
					Pseq([
						0,Pn(2.18,7),
					],2),
					Pseq([
						0,Pn(1.08,7),
					],2),
				],inf).stutter(1)/~t,
				\legato, Pseq([
					2,1,1,1, 1,1,1,1,
				],inf),
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\snare],
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,1,0,0,
					0,0,0,0, 0,0,0,0,
					1,1,0,0, 0,1,0,0,

					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,1,0,0,
					0,0,0,1, 0,0,0,0,
					1,1,0,0, 0,1,0,0,
				],inf).coin.not,
				\legato, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					2,1,1,1, 1,1,1,1,
					2,1,1,1, 1,1,1,1,
				],inf),
				\lag, Pseq([
					0,Pseq([0.02],7),
				],inf),
				\pos, Pseq([
					0,1,0.1,0.1, 0.1,1/2,0,0,
					0,1,0.1,0.1, 0.1,1/2,0,0,
					0.01,1,0.1,0.1, 0.1,1/2,0,0,
					0.01,1,0.1,0.1, 0.1,1/2,0,0,
				],inf)/~t,
				\dur, 1/8,
				\gain, 1.4,
				\amp, 0.2
			),

			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\hat],
				\speed, 1.0,
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					Pser([1,0,1,0],16),
					Pser([1,0,1,0],8),
					Pser([0,0,0,0],8),
				],inf).coin.not,
				\pos, 0.01/~t + Pseq([1.1,0.1,0.2,0],inf).stutter(2),
				//\pos, 0.01,
				\pos, Pseq([
					0,0,0,0,
					0,0.1,0.01,0,
				],inf).stutter(2),
				\dur, 1/8,
				\legato, Pseq([
					1/2,1/4,1/4,1/4,
					1/2,1/4,1,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,

					1/2,1/4,2,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
				],inf)*2,
				\legato, Pseq([
					1/2
				],inf)*2,
				\gain, 1/8*0,
				\amp, 0.1
			),

	]));
	Pdef(~name).set(\out, BusDef(\fx1));
	//Pdef(\drum1).set(\out, 0);
	//Pdef(\main, Pdef(~name)).play;
	//Ndef(\fx1).play;
	);

	(
		~name = \smpdrum6;
		Pdef(~name, Ppar([
			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\kick],
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,

					1,0,1,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,0,
				],inf).coin.not,
				\pos, Pseq([
					Pseq([
						0,Pn(0.08,7),
					],2),
					Pseq([
						2,Pn(2.10,7),
					],2),
				],inf).stutter(1)/~t,
				\legato, Pseq([
					2,1,1,1, 1,1,1,1,
				],inf),
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\snare],
				\isRest, Pseq([
					0,0,0,0, 0,1,1,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0,
					1,0,0,0, 1,0,0,0,

					0,0,0,0, 0,1,1,0,
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,

				],inf).coin.not,
				\legato, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					2,1,1,1, 1,1,1,1,
					2,1,1,1, 1,1,1,1,
				],inf),
				\lag, Pseq([
					0,Pseq([0.02],7),
				],inf),
				\pos, Pseq([
					0,1,0.1,0.1, 0.1,1/2,0.1,2.01,
					0,1,0.1,0.1, 0.1,1/2,0,0,
					0.01,1,0.1,0.1, 0.1,1/2,0.1,0.1,
					0.01,1,0.1,0.1, 0.1,1/2,0,0.1,
				],inf)/~t,
				\dur, 1/8,
				\gain, 1.4,
				\amp, 0.2
			),

			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\hat],
				\speed, 1.0,
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					Pser([1,0,1,0],16),
					Pser([1,0,1,0],8),
					Pser([0,0,0,0],8),
				],inf).coin.not,
				\pos, 0.01/~t + Pseq([1.1,0.1,0.2,0],inf).stutter(2),
				//\pos, 0.01,
				\pos, Pseq([
					0,0,0,0,
					0,0.1,0.01,0,
				],inf).stutter(2),
				\dur, 1/8,
				\legato, Pseq([
					1/2,1/4,1/4,1/4,
					1/2,1/4,1,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,

					1/2,1/4,2,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
				],inf)*2,
				\legato, Pseq([
					1/2
				],inf)*2,
				\gain, 1/8*0,
				\amp, 0.1
			),

	]));
	Pdef(~name).set(\out, BusDef(\fx1));
	//Pdef(\drum1).set(\out, 0);
	//Pdef(\main, Pdef(~name)).play;
	//Ndef(\fx1).play;
	);

	(
		~name = \smpdrum7;
		Pdef(~name, Ppar([
			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\kick],
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
					0,0,0,0, 1,0,0,0,

					1,0,1,0, 0,1,1,0,
					0,0,0,0, 1,0,0,0,
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					1,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\pos, Pseq([
					Pseq([
						0,Pn(0.00,7),
					],2),
					Pseq([
						2,Pn(2.10,7),
					],2),
				],inf).stutter(1)/~t,
				\legato, Pseq([
					2,1,1,1, 1,1,1,1,
				],inf),
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\snare],
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
				],inf).coin.not,
				\legato, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					2,1,1,1, 1,1,1,1,
					2,1,1,1, 1,1,1,1,
				],inf),
				\lag, Pseq([
					0,Pseq([0.0],7),
				],inf),
				\pos, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
					],32),
					0,1,0.1,0.1, 0.1,1/2,0.1,2.01,
					0,1,0.1,0.1, 0.1,1/2,0.1,0,
					0.01,1,0.1,0.1, 0.1,1/2,0.1,0.1,
					0.01,1,0.1,0.1, 0.1,1/2,0,0.1,
				],inf)/~t,
				\dur, 1/8,
				\gain, 1.4,
				\amp, 0.2
			),

			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\hat],
				\speed, 1.0,
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					Pser([1,0,1,0],16),
					Pser([1,0,1,0],8),
					Pser([0,0,0,0],8),
				],inf).coin.not,
				\pos, 0.01/~t + Pseq([1.1,0.1,0.2,0],inf).stutter(2),
				//\pos, 0.01,
				\pos, Pseq([
					0,0,0,0,
					0,0.1,0.01,0,
				],inf).stutter(2),
				\dur, 1/8,
				\legato, Pseq([
					1/2,1/4,1/4,1/4,
					1/2,1/4,1,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,

					1/2,1/4,2,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
				],inf)*2,
				\legato, Pseq([
					1/2
				],inf)*2,
				\gain, 1/8*0,
				\amp, 0.1
			),

	]));
	Pdef(~name).set(\out, BusDef(\fx1));
	//Pdef(\drum1).set(\out, 0);
	//Pdef(\main, Pdef(~name)).play;
	//Ndef(\fx1).play;
	);
