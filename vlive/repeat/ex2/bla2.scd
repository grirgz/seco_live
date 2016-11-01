
RandDelayNetwork(\default).make(\fx1, "5--", BusDef(\fx1, \audio));
Ndef(\fx1).edit



(
SynthDef(\bell, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fspread=0.5;
	var sig;
	var freqs, res, amps;

	freqs = { 40.exprand(8041) * LFNoise1.kr(1/38).exprange(0.1,1) } ! 20;
	freqs = freqs.collect({ arg fr;
		SelectX.kr(fspread, [freq, fr]);
	});
	res = { 0.1.exprand(0.2) } ! 20;
	amps = { 0.1.exprand(0.2) } ! 20;
	sig = DynKlang.ar(Ref([ freqs, res, amps ]))/1;
	sig.debug("sig");
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,1.1,0.8,1.4)),gate,doneAction:2);
	sig.debug("sig");
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\bell, Pbind(
	\instrument, \bell,
	\degree, Pseq([0],inf),
	\freq, 110,
	\fspread, 0.17,
	\octave, 3,
	\dur, 4,
	\legato, 0.2,
	\amp, 0.1,
	\out, BusDef(\fx1),
)).play;
);

Ndef(\fx1).play


~recmodel.edit

SynthDesc(\snapkick).asParamGroup(Pdef(\recman))
Ndef(\fx1).asParamGroup.first.type
RandDelayNetwork(\default).make(\fx1, "5--", BusDef(\fx1, \audio));

Param.freeAllSimpleControllers

Ndef(\fx1).clear
(
WindowDef(\test, {
var bu = BasicButton.new;
bu.action_({ arg v; v.value.debug("v") });
bu.value = 1;
bu
	
}).front;
)

Ndef(\fx1).isPlaying.asInteger
Ndef(\fx1).isPlaying
~recmodel.edit
BufDef.all
(
BufDef(\kick, s.sampleRate * 4);
BufDef(\kick2, s.sampleRate * 4);
BufDef(\kick3, s.sampleRate * 4);
BufDef(\tmp4, s.sampleRate * 4);
BufDef(\snare, s.sampleRate * 4);
BufDef(\snare2, s.sampleRate * 4);
BufDef(\snare3, s.sampleRate * 4);
BufDef(\hat, s.sampleRate * 4);
BufDef(\tmp16, s.sampleRate * 16);
)
BufDef(\kick).play
BufDef(\snare).play
BufDef(\snare).saveDialog

~loadbufs.()
~loadbufs.([\kick, \kick2, \kick3, \snare, \snare2, \snare3, \hat], "test2")
				Pbind(
					\instrument, \player,
					\bufnum, BufDef(\kick),
					\legato, 1,
					\dur, Pn(1,1),
				).play;


	(
		Pdef(\smpdrum1, Ppar([
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\kick),
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\pos, 0.12,
				\sustain, 0.7,
				\dur, 1/4,
				\gain, 1,
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\kick3),
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 1,0,0.71,0,
						0,0,0.3,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 1,0,0,0,
					],1),
					Pseq([
						0,0,0,0, 0,0,1,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,1,0,
					],1),
				],inf).coin.not,
				\pos, Pseq([0.2,0.17]/3,inf)+0.01,
				\pos, 0.19 + Pseq([0,0.1,0.1,0.2]/4,inf).stutter(4),
				\lag, 0.00,
				\sustain, Pseq([0.3,0.1],inf).stutter(8),
				\dur, 1/8,
				\gain, 1,
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\snare3),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\pos, 0.1,
				\sustain, 0.8,
				\dur, 1/4,
				\gain, 2,
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\snare),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0,
				],inf).coin.not,
				\pos, 0.2,
				\sustain, 0.5,
				\dur, 1/4,
				\gain, 1,
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\snare),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,

					0,0,0,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\pos, Pseq([0.2,0.3],inf).stutter(16),
				\sustain, 0.2,
				\dur, 1/8,
				\gain, 1,
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\hat),
				\isRest, Pseq([
					1,0.3,1,0.3,
				],inf).coin.not,
				\pos, Pseq([0.08,0.01],inf),
				\sustain, Pseq([
					Pser([
						0.1,
					],16),
					Pser([
						0.1,
					],16),
					Pser([
						0.1,0.2,
					],16),
					Pser([
						0.1,0.1,0.4,0.1,
						0.1,0.1,0.4,0.1,
						0.1,0.4,0.1,0.1,
						0.4,0.1,0.4,0.1,
					],16),
				],inf),
				\dur, 1/4,
				\amp, 0.2
			),

	]));
	//Pdef(\smpdrum1).set(\out, BusDef(\fx1));
	Pdef(\smpdrum1).set(\out, 0);
	Pdef(\main, Pdef(\smpdrum1)).play;
	Ndef(\fx1).play;
	)

	~recgui.()
	Pdef(\src).clear

(
Pdef(\bell, Pbind(
	\instrument, \bell,
	\degree, Pseq([0],inf),
	\freq, 110,
	\fspread, 0.17,
	\octave, 3,
	\dur, 1/4,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.1) ],
	],inf),
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
		0,0,1,0, 0,0,0,0,
	],inf).coin.not,
	\sustain, Pseq([
		1,0,0,0, 0,0,0,0,
		0,0,1/4,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 1/2,0,0,0,
	],inf)/~t,
	\isRest, Pkey(\sustain) <= 0,
	\legato, 0.2,
	\amp, 0.1,
	\out, BusDef(\fx1),
)).play;
);

(
Pdef(\bell, Pbind(
	\instrument, \bell,
	\degree, Pseq([0],inf),
	\freq, 110,
	\fspread, 0.17,
	\octave, 3,
	\dur, 4,
	\legato, 0.2,
	\amp, 0.1,
	\out, BusDef(\fx1),
)).play;
);
Pdef(\bell).stop;

(
Pdef(\bass1, Pbind(
	\instrument, \default,
	\degree, Pseq([
		0,2,-1,3, 0,2,-1,3,
		-3,0,-2,3, 0,2,-1,3,
	],inf),
	\octave, 3,
	\dur, 1/4,
	\sustain, Pseq([
		1,0,1,0, 0,0,0,0,
		1,0,8,0, 0,0,0,0,
	],inf)/7/~t,
	\isRest, Pkey(\sustain) <= 0,
	\out, BusDef(\fx1),
	\amp, 0.1
)).play;
);

(
Pdef(\bass1, Pbind(
	\instrument, \default,
	\note, Pseq([
		Pser([
			0
		],8),
		Pser([
			-1
		],8),
	],inf)-3,
	\octave, 4,
	\dur, 1/4,
	\sustain, Pseq([
		4,0,0,0, 4,0,0,0,
		1,0,0,0, 2,0,0,0,
		9,0,0,0, 0,0,0,0,
		1,0,0,0, 0,0,0,0,

		9,0,0,0, 0,0,0,0,
		1,0,0,0, 0,0,0,0,
		9,0,0,0, 0,0,0,0,
		1,0,0,0, 0,0,0,0,

		9,0,0,0, 0,0,0,0,
		1,0,0,0, 0,0,0,0,
		3,0,2,0, 2,0,3,0,
		1,0,0,0, 0,0,0,0,

		9,0,0,0, 0,0,0,0,
		9,0,0,0, 0,0,0,0,
		9,0,0,0, 0,0,0,0,
		1,0,0,0, 0,0,0,0,
	],inf)/4/~t,
	\isRest, Pkey(\sustain) <= 0,
	\out, BusDef(\fx1),
	\amp, 0.1
)).play;
);

	(
		~name = \smpdrum2;
		Pdef(~name, Ppar([
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\kick3),
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\pos, 0.12,
				\sustain, 0.7,
				\dur, 1/4,
				\gain, 1,
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\kick2),
				\isRest, Pseq([
					0,0,1,0, 1,0,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,1,0,0,
				],inf).coin.not,
				\pos, 0.310,
				\speed, -0.71,
				\sustain, 0.4,
				\dur, 1/4,
				\gain, 1,
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\snare3),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\pos, 0.1,
				\sustain, 0.8,
				\dur, 1/4,
				\gain, 2,
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\snare2),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\pos, 0.1,
				\sustain, 0.2,
				\dur, 1/4,
				\gain, 2,
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\hat),
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 
					Prand([
						Pseq([
							1,0,1,0,
						],1),
						Pseq([
							1,1,1,1,
						],1),
						Pser([
							0.5,
						],4),
					],1),

					1,0,0,0, 1,0,0,0,
					Prand([
						Pseq([
							1,0,1,0,
						],1),
						Pseq([
							1,1,1,1,
						],1),
						Pser([
							0.5,
						],4),
					],1),
					1,0,0,0, 
				],inf).coin.not,
				\pos, Pseq([
					Pseq([
						0.09, 0.08,
					],1),
					Pseq([
						0.14, 0.14,
					],1),
				],inf),
				\sustain, Pseq([
					Pser([
						0.05, 0.05, 0.05, 0.15,
						0.05, 0.05, 0.05, 0.15,
						0.05, 0.05, 0.05, 0.15,
						0.15, 0.05, 0.05, 0.15,
					],16),
				],inf),
				\dur, 1/8,
				\amp, 0.2
			),

	]));
	//Pdef(~name).set(\out, BusDef(\fx1));
	Pdef(~name).set(\out, 0);
	Pdef(\main, Pdef(~name)).play;
	Ndef(\fx1).play;
	)

	(
		~name = \smpdrum3;
		Pdef(~name, Ppar([
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\kick2),
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\pos, 0.02,
				\sustain, 0.7,
				\dur, 1/4,
				\gain, 1,
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\kick3),
				\isRest, Pseq([
					0,0,0,1, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\pos, 0.05/~t,
				\speed, 0.9,
				\sustain, Pseq([
					Pser([
						0.2,
					],8),
					Pser([
						0.4,
					],8),
					
				],inf),
				\dur, 1/4,
				//\out, BusDef(\fx1),
				\gain, 1,
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\snare3),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\pos, 0.08,
				\sustain, Pseq([0.3,0.8],inf).stutter(16),
				\dur, 1/4,
				//\out, BusDef(\fx1),
				\gain, 1,
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\snare3),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 0,1,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\pos, 0.2,
				\sustain, Pseq([1,1, 0.1,0.2, 0.1,0.1, 0.1,0.1],inf).stutter(1),
				\dur, 1/4,
				//\out, BusDef(\fx1),
				\gain, 1,
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\snare3),
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\pos, 0.8/~t,
				\speed, -0.5,
				\sustain, 1.2,
				\dur, 1/4,
				\gain, 1,
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\snare3),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\pos, 0.8/~t,
				\speed, -0.8,
				\sustain, 0.6,
				\dur, 1/4,
				\gain, 1,
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\hat),
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 
					Prand([
						Pseq([
							1,0,1,0,
						],1),
						Pseq([
							1,1,1,1,
						],1),
						Pser([
							0.5,
						],4),
					],1),

					1,0,0,0, 1,0,0,0,
					Prand([
						Pseq([
							1,0,1,0,
						],1),
						Pseq([
							1,1,1,1,
						],1),
						Pser([
							0.5,
						],4),
					],1),
					1,0,0,0, 
				],inf).coin.not,
				\pos, Pseq([
					Pseq([
						0.09, 0.08,
					],1),
					Pseq([
						0.14, 0.14,
					],1),
				],inf),
				\sustain, Pseq([
					Pser([
						0.05, 0.05, 0.05, 0.15,
						0.05, 0.05, 0.05, 0.15,
						0.05, 0.05, 0.05, 0.15,
						0.15, 0.05, 0.05, 0.15,
					],16),
				],inf),
				\dur, 1/8,
			),

	]));
	//Pdef(~name).set(\out, BusDef(\fx1));
	Pdef(~name).set(\out, 0);
	Pdef(\main, Pdef(~name)).play;
	Ndef(\fx1).play;
	)

	(
		~name = \smpdrum4;
		Pdef(~name, Ppar([
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\kick3),
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\pos, 0.12,
				\sustain, 0.7,
				\dur, 1/4,
				\gain, 1,
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\kick3),
				\isRest, Pseq([
					1,1,0,1, 1, 0,0,1,
					0,1,1,0, 1,0,1,0,
					0,1,1,0, 1,0,1,0,
					0,1,0,1, 1,0,0,0,
				],inf).coin.not,
				\pos, 0.14/~t + Pseq([0,0.3],inf),
				\speed, Pseq([1,-1],inf),
				\sustain, Pseq([
					Pser([
						0.2,0.2,
					],8),
					
				],inf),
				\dur, 1/4,
				//\out, BusDef(\fx1),
				\gain, 1,
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\snare3),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\pos, 0.1,
				\sustain, 0.8,
				\dur, 1/4,
				//\out, BusDef(\fx1),
				\gain, 1,
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\snare3),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 0,1,0,0,
				],inf).coin.not,
				\pos, Pseq([0.2,0.3],inf),
				\sustain, 0.2,
				\dur, 1/4,
				//\out, BusDef(\fx1),
				\gain, 1,
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\snare3),
				\isRest, Pseq([
					0,0,0,0, 1,1,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 1,0,1,1,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\pos, 0.8/~t,
				\speed, -0.5,
				\sustain, Pseq([0,0.1],inf)+0.2,
				\dur, 1/4,
				\gain, 1,
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\snare3),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\pos, 0.8/~t,
				\speed, -0.9,
				\sustain, 1.0,
				\dur, 1/4,
				\gain, 1,
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\snare3),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\pos, 0.8/~t,
				\speed, -0.8,
				\sustain, 0.6,
				\dur, 1/4,
				\gain, 1,
			),

	]));
	//Pdef(~name).set(\out, BusDef(\fx1));
	Pdef(~name).set(\out, 0);
	Pdef(\main, Pdef(~name)).play;
	Ndef(\fx1).play;
	)

	(
		~name = \smpdrum5;
		Pdef(~name, Ppar([
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\kick3),
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,

					1,0,0,1, 0,0,0,1,
					0,0,0,0, 0,0,1,0,

					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\pos, 0.12,
				\sustain, 0.7,
				\dur, 1/4,
				\gain, 1,
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\snare3),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\pos, 0.1,
				\sustain, 0.8,
				\dur, 1/4,
				//\out, BusDef(\fx1),
				\gain, 1,
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\snare3),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 1,1,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,1,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 1,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,1,0,
					0,0,1,1, 0,1,1,0,
				],inf).coin.not,
				\pos, 0.2,
				\sustain, 0.2,
				\dur, 1/8,
				//\out, BusDef(\fx1),
				\gain, 1,
			),

	]));
	//Pdef(~name).set(\out, BusDef(\fx1));
	Pdef(~name).set(\out, 0);
	Pdef(\main, Pdef(~name)).play;
	Ndef(\fx1).play;
	)

	(
	Pdef(\plok, 
		Pbind(
			\instrument, \zigsamp,
			//\degree, Pseq([0,3,5,4],inf).stutter(8) + [0,3,7],
			\octave, 4,
			\bufnum, BufDef(\ukraine),
			\bufnum, BufDef(\metal),
			\bufnum, BufDef(\oeuf),
			\bufnum, BufDef(\snare),
			\hpfreq, 50,
			\ffreq, 4700,
			//\freq, Pseq([100,1000,10000,10],inf).stutter(8),
			\range, 0,
			\framerange, 33,
			\posenv, [ Env([0.021,0.81,0.1,0.0, 0.0], [1.8,0.1,0.1,0.1]) ],
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.5,0.16) ],
			],inf),
			\timeScale, 2,
			\levelScale, 1.51,
			//\out, BusDef(\fx1),
			\pos, 0,
			//\pos, 0.2,
			\hpmix, 0,
			\lpmix, 0,
			//\sustain, 1,
			//\legato, a[8].linlin(0,9,0.1,0.5),
			\legato, 1,
			\isRest, Pseq([
				1,0,0,0,
				1,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.4
		)
	).play;
	)

(
SynthDef(\zigsamp, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, pos=0, finepos=0, range=0.01,
						lpmix=0.5, ffreq=500, rq=0.1, spread=0.8, fshift=0;
	// env longer
	var ou, ou2;
	var osc;
	var bufsig;
	var phase;
	var ffreqtab;
	osc = SinOsc.ar(freq*[1.001,0.999,1]);
	//osc = osc.sum;
	pos = EnvGen.kr(\posenv.kr(Env([1,0,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])),gate, levelScale:\levelScale.kr(1), timeScale:\timeScale.kr(1)) + pos;
	range = (range + (\framerange.kr(0)/BufFrames.ir(bufnum)));
	phase = osc * range + pos + finepos.lag(\fineposlag.kr(0));

	bufsig = BufRd.ar(2, bufnum, phase*BufFrames.ir(bufnum), 1);
	bufsig = bufsig.sum;
	ou = bufsig;
	ffreqtab = \ffreqtab.kr(1!8);
	ou = FreqShift.ar(ou, fshift);
	ou2 = RLPF.ar(ou, (ffreq * ffreqtab).clip(10,18000), rq);
	ou = SelectX.ar(lpmix, [ou, ou2]);
	ou2 = HPF.ar(ou, (\hpfreq.kr(180) * ffreqtab).clip(10,18000));
	ou = SelectX.ar(\hpmix.kr(0), [ou, ou2]);

	ou2 = (ou * \distpreamp.kr(18)).tanh / \distamp.kr(1);
	ou = SelectX.ar(\distmix.kr(0), [ou, ou2]);
	ou.debug("oscsampler4");
	ou = ou.clump(2).flop.collect({
		DelayL.ar(ou, 0.02,0.02.rand) + ou;
	})/3;
	ou.debug("oscsampler4, 2");
	ou = ou.flat;
	ou.debug("oscsampler4, 3");
	ou = Splay.ar(ou, spread, amp, pan);

	ou = ou * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	
	Out.ar(out, ou);
}, metadata:(specs:(
	finepos: ControlSpec(-0.001,0.001,\lin, 0, 1),
	range: ControlSpec(-0.01,0.01,\lin, 0, 1),
	adsr: \env -> [nil, nil, nil, nil, Env.adsr(0.01,0.1,0.8,0.1)],
	posenv: \env -> [nil, nil, nil, nil, Env([1,0,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])],
	fshift: ControlSpec(-2000,2000,\lin,0,0),
	spread: \unipolar.asSpec,
	lpmix: \unipolar.asSpec,
	pos: \unipolar.asSpec,
))).add;
BufDef(\metal, "vipere/metal.flac");
BufDef(\oeuf, "field/oeuf.flac");
BufDef(\ukraine, "bruit1/07_ukraine.flac");
)

Ndef(\fx1).clear

Plo
File.getCwd


(
	~savebuf = { arg buf, numFrames=( -1 ), startFrame=0;
		Dialog.savePanel({ arg file;
			buf.write(file, "FLAC", numFrames:numFrames, startFrame:startFrame);
		});
	};
)
~savebuf.(BufDef(\kick))
~savebuf.(BufDef(\kick2))
~savebuf.(BufDef(\kick3))
~recmodel.edit

~savebufs.([\kick, \kick2, \kick3, \snare, \snare2, \snare3, \hat], "test2")

~savebuf.(BufDef(\snare3))
BufDef(\snare3).play

BufDef.loadDialog(\kick)
BufDef.loadDialog(\kick2)
BufDef.loadDialog(\kick3)
FileDialog.openDialog


	(
		Pdef(\smpdrum1, Ppar([
			Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\kick3),
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\pos, 0.12,
				\sustain, 0.7,
				\dur, 1/8,
				\gain, 1,
			),

	]));
	//Pdef(\smpdrum1).set(\out, BusDef(\fx1));
	Pdef(\smpdrum1).set(\out, 0);
	Pdef(\main, Pdef(\smpdrum1)).play;
	Ndef(\fx1).play;
	)

	BufDef(\bla, s.sampleRate * 4)
	BufDef(\bla).loadDialog
