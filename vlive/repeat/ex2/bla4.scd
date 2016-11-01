~recmodel.edit
(
	~name = \smpdrum1;
	Pdef(~name, Ppar([
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\kick),
			\isRest, Pseq([

				1,0,0,0, 0,0,0,1,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,1,
				0,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,1,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,1,0, 1,0,0,1,
				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,1,0,0,
				0,0,1,0, 1,0,0,0,

			],inf).coin.not,
			\pos, 0.04,
			\sustain, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) * 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\snare2),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],3*2),
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,1,0,
				],1),
			],inf).coin.not,
			\pos, 0.04,
			\sustain, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				4,1,1,1, 1,1,1,1,
			],inf).stutter(1) * 0.3,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\hat),
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,1, 1,0,
				1,0, 1,0, 1,1, 1,1,
				1,0, 0,0, 0,0, 1,0,

				1,1, 0,0, 1,0, 1,0,
				1,0, 1,1, 1,0, 1,0,
				1,1, 1,0, 1,0, 1,1,
				1,0, 0,0, 0,0, 1,0,
			],inf).coin.not,
			\pos, Pseq([0.02, 0.12],inf).stutter(2) + 0.04,
			\speed, 1,
			\sustain, Pseq([
				4,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				4,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,4,1,
			],inf)*0.02,
			\dur, 1/4,
			\gain, 1/1,
			\gain, Pkey(\gain) * Pseq([
				1,0.5,
				0.3,0.5,
			],inf),
		),

	].collect({ arg pat;
		//Pbind(\out, BusDef(\fx1)) <> pat
		Pbind(\gain, Pkey(\gain) * 2, \dur, Pkey(\dur) /2) <> pat
		
	})));
	Pdef(~name).set(\out, BusDef(\fx1));
	//Pdef(~name).set(\out, 0);
	Pdef(\main, Pdef(~name)).play;
	Ndef(\fx2).play;
)

(
	~name = \smpdrum2;
	Pdef(~name, Ppar([
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\kick),
			\isRest, Pseq([

				1,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

			],inf).coin.not,
			\pos, 0.04,
			\sustain, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) * 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\snare2),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
				],3),
			],inf).coin.not,
			\pos, 0.04,
			\sustain, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				2,1,1,1, 1,1,1,1,
			],inf).stutter(1) * 0.3,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\snare2),
			\isRest, Pseq([
				Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
					],4*3),

					0,0,1,0, 0,0,0,0,
					0,0,0,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 0,1,1,0,
				],3),
			],inf).coin.not,
			\pos, 0.12,
			\sustain, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) * 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\hat),
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,1, 1,0,
				1,0, 1,0, 1,1, 1,1,
				1,0, 0,0, 0,0, 1,0,

				1,1, 0,0, 1,0, 1,0,
				1,0, 1,1, 1,0, 1,0,
				1,1, 1,0, 1,0, 1,1,
				1,0, 0,0, 0,0, 1,0,
			],inf).coin.not,
			\pos, Pseq([0.02, 0.12],inf).stutter(2) + 0.04,
			\speed, 1,
			\sustain, Pseq([
				4,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				4,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,4,1,
			],inf)*0.02,
			\dur, 1/4,
			\gain, 1/1,
			\gain, Pkey(\gain) * Pseq([
				1,0.5,
				0.3,0.5,
			],inf),
		),

	].collect({ arg pat;
		//Pbind(\out, BusDef(\fx1)) <> pat
		Pbind(\gain, Pkey(\gain) * 2, \dur, Pkey(\dur) /2) <> pat
		
	})));
	Pdef(~name).set(\out, BusDef(\fx1));
	//Pdef(~name).set(\out, 0);
	Pdef(\main, Pdef(~name)).play;
	Ndef(\fx2).play;
)

(
	~name = \smpdrum3;
	Pdef(~name, Ppar([
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\kick),
			\isRest, Pseq([

				1,0,0,0, 0,0,0,1,
				0,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,

			],inf).coin.not,
			\pos, 0.04,
			\sustain, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) * 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\snare2),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],3),
			],inf).coin.not,
			\pos, 0.04,
			\sustain, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				4,1,1,1, 1,1,1,1,
			],inf).stutter(1) * 0.3,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\snare2),
			\isRest, Pseq([
				Pseq([
					0,1,0,0, 1,1,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 0,1,1,0,
				],3),
			],inf).coin.not,
			\pos, 0.12,
			\sustain, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) * 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\hat),
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,1, 1,0,
				1,0, 1,0, 1,1, 1,1,
				1,0, 0,0, 0,0, 1,0,

				1,1, 0,0, 1,0, 1,0,
				1,0, 1,1, 1,0, 1,0,
				1,1, 1,0, 1,0, 1,1,
				1,0, 0,0, 0,0, 1,0,
			],inf).coin.not,
			\pos, Pseq([0.02, 0.12],inf).stutter(2) + 0.04,
			\speed, 1,
			\sustain, Pseq([
				4,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				4,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,4,1,
			],inf)*0.02,
			\dur, 1/4,
			\gain, 1/1,
			\gain, Pkey(\gain) * Pseq([
				1,0.5,
				0.3,0.5,
			],inf),
		),

	].collect({ arg pat;
		//Pbind(\out, BusDef(\fx1)) <> pat
		Pbind(\gain, Pkey(\gain) * 2, \dur, Pkey(\dur) /2) <> pat
		
	})));
	Pdef(~name).set(\out, BusDef(\fx1));
	//Pdef(~name).set(\out, 0);
	Pdef(\main, Pdef(~name)).play;
	Ndef(\fx2).play;
)

(
	//Pdef(~name).set(\out, 0);
	Pdef(\main, 
		Pseq([
			Pfindur(32,Pdef(\smpdrum1)),
		//	Pfindur(32,Pdef(\smpdrum2)),
		],2),
	).play;
	Ndef(\fx2).play;
)

(
	~name = \smpdrum4;
	Pdef(~name, Ppar([
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\kick),
			\isRest, Pseq([

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

			],inf).coin.not,
			\pos, 0.04,
			\sustain, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) * 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\snare2),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],3),
			],inf).coin.not,
			\pos, 0.04,
			\sustain, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) * 0.3,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\tmp16),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],3),
			],inf).coin.not,
			\pos, 0.04 + (1/8/~t),
			\sustain, Pseq([
				4,2,1,1, 1,1,1,1,
			],inf).stutter(1) * 0.3,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1/2,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\tmp16),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,0,1, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
				],3),
			],inf).coin.not,
			\pos, 0.04 + Pseq([
				1.2,1/2,1,2,
				1.2,1/4,1,2,
				
			],inf)/~t,
			\speed, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, -1,1,1,1,
				1,1,1,1, 1,1,1,1,
			],inf)*( 0.91 ),
			\sustain, Pseq([
				1,1,1,1, 4,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) * 0.3,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1/2,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\hat),
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,1, 1,0,
				1,0, 1,0, 1,1, 1,1,
				1,0, 0,0, 0,0, 1,0,

				1,1, 0,0, 1,0, 1,0,
				1,0, 1,1, 1,0, 1,0,
				1,1, 1,0, 1,0, 1,1,
				1,0, 0,0, 0,0, 1,0,
			],inf).coin.not,
			\pos, Pseq([0.02, 0.12],inf).stutter(2) + 0.04,
			\speed, 1,
			\sustain, Pseq([
				4,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				4,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,4,1,
			],inf)*0.02,
			\dur, 1/4,
			\gain, 1/1,
			\gain, Pkey(\gain) * Pseq([
				1,0.5,
				0.3,0.5,
			],inf),
		),

	].collect({ arg pat;
		//Pbind(\out, BusDef(\fx1)) <> pat
		Pbind(\gain, Pkey(\gain) * 2, \dur, Pkey(\dur) /2) <> pat
		
	})));
	Pdef(~name).set(\out, BusDef(\fx1));
	//Pdef(~name).set(\out, 0);
	Pdef(\main, Pdef(~name)).play;
	Ndef(\fx2).play;
)

(
	~name = \smpdrum5;
	Pdef(~name, Ppar([
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\kick),
			\isRest, Pseq([

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

			],inf).coin.not,
			\pos, 0.04,
			\sustain, Pseq([
				8,1,1,1, 1,1,1,1,
				4,1,1,1, 1,1,1,1,
				2,1,1,1, 1,1,1,1,
				4,1,1,1, 1,1,1,1,
			],inf).stutter(1) * 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\snare2),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],3),
			],inf).coin.not,
			\pos, 0.04,
			\sustain, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) * 0.3,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\tmp16),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
				],3),
			],inf).coin.not,
			\pos, 0.04 + Pseq([
				1,0,1,2,
				
			],inf)/~t,
			\speed, -0.41,
			\sustain, Pseq([
				1,1,1,1, 4,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) * 0.3,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1/2,
		),
		Prout({ arg ev;
			//loop {
			Pseq([
				Event.silent(4),
				Event.silent(1/4),
				Pfindur(1.9 - ( 1/4 ), Pbind(
					\instrument, \playerbeat,
					\bufnum, BufDef(\tmp16),
					\isRest, Pseq([
						Pseq([
							1,
						],3),
					],inf).coin.not,
					\pos, 0.04 + (0/~t) + 2.0.rand,
					\sustain, Pseq([
						1
					],inf).stutter(1) * 0.1 + 0.01.exprand(0.5),
					\adsr, Pseq([
						[ Env.adsr(0.001,0.1,0.8,0.1) ],
					],inf),
					\dur, ( 1/2.0 ).rand+0.1,
					//\dur, 1/8,
					\gain, 1/2,
				)),
				Event.silent(2.1),
			],1).embedInStream(ev);
			//}
		}).loop.trace,
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\hat),
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,1, 1,0,
				1,0, 1,0, 1,1, 1,1,
				1,0, 0,0, 0,0, 1,0,

				1,1, 0,0, 1,0, 1,0,
				1,0, 1,1, 1,0, 1,0,
				1,1, 1,0, 1,0, 1,1,
				1,0, 0,0, 0,0, 1,0,
			],inf).coin.not,
			\pos, Pseq([0.02, 0.12],inf).stutter(2) + 0.04,
			\speed, 1,
			\sustain, Pseq([
				4,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				4,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,4,1,
			],inf)*0.02,
			\dur, 1/4,
			\gain, 1/1,
			\gain, Pkey(\gain) * Pseq([
				1,0.5,
				0.3,0.5,
			],inf),
		),

	].collect({ arg pat;
		pat
		//Pbind(\out, BusDef(\fx1)) <> pat
		//Pbind(\gain, Pkey(\gain) * 2, \dur, Pkey(\dur) /2) <> pat
		
	})));
	Pdef(~name).set(\out, BusDef(\fx1));
	//Pdef(~name).set(\out, 0);
	Pdef(\main, Pdef(~name)).play;
	Ndef(\fx2).play;
)

(
Pdef(\main,
		Prout({ arg ev;
			loop {
				ev = Pfindur(2,Pbind(
					\instrument, \playerbeat,
					\bufnum, BufDef(\snare2),
					\isRest, Pseq([
						Pseq([
							1,
						],3),
					],inf).coin.not,
					\pos, 0.04 + (0/~t),
					\sustain, Pseq([
						1
					],inf).stutter(1) * 0.3,
					\adsr, Pseq([
						[ Env.adsr(0.001,0.1,0.8,0.1) ],
					],inf),
					\dur, ( 1/2.0 ).rand+0.1,
					//\dur, 1/8,
					\gain, 1/2,
				)).embedInStream(ev);
				ev = Event.silent(2).yield;
			}
		}),
	).play;
)
