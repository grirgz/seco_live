
	RandDelayNetwork(\multifb).make(\fx1, "6--", BusDef(\fx1, \audio));


	RandDelayNetwork(\multifb).tree
	Ndef(\fx1).play
	Ndef(\fx1).edit
	{ Ndef(\fx1).sources[1].value.value(In.ar(2)) }.draw



	~rdnpresets.vieuxsimple
	~rdnpresets.simple
	~rdnpresets.hard
	~rdnpresets.hard_soft;
	Pdef(\main, Pdef(\drum1)).play;

	RandDelayNetwork(\multifb).make(\fx1, "6--", BusDef(\fx1, \audio));
	RandDelayNetwork(\multifb).getPresetCompileString(\fx1).pbcopy.vimpbpaste;
(
);

(
);

(
);

	Ndef(\fx1).edit




	///////////////////////////////////////////


(
Pdef(\snapkick, Pbind(
	\instrument, \snapkick,
	\isRest, Pseq([
		1,0,0,0, 0,1,0,0,
	],inf).coin.not,
	\dur, 1/8,
	\amp, 0.1
));
Pdef(\snapsnare, Pbind(
	\instrument, \snapsnare,
	\isRest, Pseq([
		0,0,0,0, 1,0,0,0,
	],inf).coin.not,
	\dur, 1/8,
	\amp, 0.1
));
Pdef(\snaphihat, Pbind(
	\instrument, \snaphihat,
	\isRest, Pseq([
		Pser([
			1,0,
		],8*1),
		Pser([
			1,1,
		],8),
	],inf).coin.not,
	\dur, 1/8,
	\amp, 0.1/2
));

Pdef(\main, Ppar([
	Pdef(\snapkick),
	Pdef(\snapsnare),
	Pdef(\snaphihat),
].collect({ arg x;
	Pbind(\out, BusDef(\fx1, \audio, 2)) <> x
	//Pbind(\out, 0) <> x
	//x
})));
Pdef(\main).play;
Ndef(\fx1).play;
	
)
(
Pdef(\snapkick, Pbind(
	\instrument, \snapkick,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		1,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\dur, 1/8,
	\amp, 0.1
));
Pdef(\snapsnare, Pbind(
	\instrument, \snapsnare,
	\isRest, Pseq([
		0,0,0,0, 1,0,0,1,
		0,0,1,0, 1,0,1,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\dur, 1/8,
	\amp, 0.1
));
Pdef(\snaphihat, Pbind(
	\instrument, \snaphihat,
	\isRest, Pseq([
		Pser([
			1,0,
		],8*1),
		Pser([
			1,1,
		],8),
	],inf).coin.not,
	\dur, 1/8,
	\amp, 0.1/2
));

Pdef(\main, Ppar([
	Pdef(\snapkick),
	Pdef(\snapsnare),
	Pdef(\snaphihat),
].collect({ arg x;
	Pbind(\out, BusDef(\fx1, \audio, 2)) <> x
	//Pbind(\out, 0) <> x
	//x
})));
Ndef(\fx1).set(\mamp, 1);
Pdef(\main).play;
Ndef(\fx1).play;
	
)

(
	Pdef(\drum1, Ppar([
		Pbind(
			\instrument, \snapkick,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],3),
				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,0,1, 0,1,1,0,
				],1),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snapsnare,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,1,
					0,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],3),
				Pseq([
					1,0,0,0, 1,0,0,1,
					0,0,1,0, 0,0,1,0,
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
				],1),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snaphihat,
			\isRest, Pseq([
				Pser([
					1,0,
				],8*1),
				Pser([
					1,1,
				],8),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/2
		),
	]));

Pdef(\main, Ppar([
	Pdef(\drum1),
].collect({ arg x;
	Pbind(\out, BusDef(\fx1, \audio, 2)) <> x
	//Pbind(\out, 0) <> x
	//x
})));
Pdef(\drum1).set(\out, BusDef(\fx1, \audio));
Ndef(\fx1).set(\mamp, 1);
Pdef(\main).play;
Ndef(\fx1).play;
	
)

(
Pdef(\snapkick2, Pbind(
	\instrument, \snapkick,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
		1,0,0,1, 0,1,0,1,
		1,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\dur, 1/8,
	\amp, 0.1
));
Pdef(\snapsnare2, Pbind(
	\instrument, \snapsnare,
	\isRest, Pseq([
		0,0,0,0, 1,0,0,1,
		0,0,1,0, 1,0,1,0,
		0,0,0,0, 1,0,0,0,
		0,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\dur, 1/8,
	\amp, 0.1
));
Pdef(\snaphihat2, Pbind(
	\instrument, \snaphihat,
	\isRest, Pseq([
		Pser([
			1,0,
		],8*1),
		Pser([
			1,1,
		],8),
	],inf).coin.not,
	\dur, 1/8,
	\amp, 0.1/2
));

Pdef(\main, Ppar([
	Pdef(\snapkick2),
	Pdef(\snapsnare2),
	Pdef(\snaphihat2),
].collect({ arg x;
	Pbind(\out, BusDef(\fx1, \audio, 2)) <> x
	//Pbind(\out, 0) <> x
	//x
})));
Ndef(\fx1).set(\mamp, 1);
Pdef(\main).play;
Ndef(\fx1).play;
	
)

(
~t = 1;
TempoClock.default.tempo = ~t;
Ndef.defaultQuant = 1;
Pdef.defaultQuant = 1;
)

	RandDelayNetwork(\multifb).getPresetCompileString(\fx1).pbcopy.vimpbpaste;
(
);

(
);

(
RandDelayNetwork('multifb').make('fx1', "6-2BII-7GP");
Ndef('fx1').put(100, \pset -> Pbind(
	'wet10', 0.53333333333333,
	'fb', 0.001879943549628,
	'delay', 0.00010525002852777,
	'delay2', 0.00011659144011798,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.29183146337409,
	'pitchlag', 1.0,
	'pitchmix', 0.76111111111111,
	'prelpf', 20000.0,
	'prehpf', 20.0,
	'lpf', 20000.0,
	'hpf', 20.0,
	'deltran1', 1.0444444444444,
	'deltran2', 0.51111111111111,
	'deltran3', -0.71111111111111,
	'fb2', 0.022222222222222,
	'endamp2', 17.506786696025,
	'endamp1', 1.6475489724421,
	'fb1', 0.0,
	'fbdistamp', 1.6558680225505,
	'fbdistmix', 0.92222222222222,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.35634235507941,
	'wet20', 1.0,
	'mamp', Ndef('fx1lfo_amp'),
).keep(1));
);

(
RandDelayNetwork('multifb').make('fx1', "6-4CND-T4TL");
Ndef('fx1').put(100, \pset -> Pbind(
	'wet10', 0.36111111111111,
	'fb', 0.0016152537827088,
	'delay', 0.0001755676291275,
	'delay2', 0.0011659144011798,
	'shift', -4.2222222222222,
	'shift2', 2.9444444444444,
	'distamp', 0.96726196616647,
	'pitchlag', 1.0,
	'pitchmix', 0.76111111111111,
	'prelpf', 20000.0,
	'prehpf', 20.0,
	'lpf', 20000.0,
	'hpf', 20.0,
	'deltran1', 1.0444444444444,
	'deltran2', 0.044444444444444,
	'deltran3', 1.0222222222222,
	'endamp2', 17.506786696025,
	'endamp1', 1.6475489724421,
	'fb1', 0.066666666666667,
	'fb2', 0.11111111111111,
	'fbdistamp', 2.4214595525113,
	'fbdistmix', 0.78333333333333,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.35634235507941,
	'wet20', 1.0,
	'mamp', 1.5936114584399,
).keep(1));
);

////////////////////

(
Pbind(
        \degree, Prout({ |in|
                Pseq([0, 1, 2, 3, 4]).embedInStream;
				in.debug("1");
                in = Rest.embedInStream(in);
				in.debug("2");
        })
).trace.play;
)



(
Pbind(
        \degree, Prout({ |in|
				in.debug("0");
                in = Pseq([0, 1, 2, 3, 4]).embedInStream(in);
				in.debug("1");
                in = Rest.embedInStream(in);
				in.debug("2");
        })
).trace.play;
)

//////////////////:

Ndef(\rat1, { SinOsc.ar(200)!2 });
Ndef(\rat2, { SinOsc.ar(250)!2 });
Ndef(\rat3, { 
	
	"ex1".debug;
	SinOsc.ar(280)!2 });

(
~name = \rat2;
Ndef(\by, { Ndef.ar(~name) * 0.1 }).play;
Ndef(~old).end(4,true);
~old = ~name;
)


		(
		WindowDef(\fxview, { arg def, ndefname=\fx1;
			var mainview = View.new;
			var scroll = ScrollView.new.canvas_(mainview).hasHorizontalScroller_(false).hasBorder_(false);
			mainview.layout = 
				VLayout(
					*Ndef(ndefname).asParamGroup.collect({ arg p;
						HLayout(
							p.asStaticTextLabel.fixedWidth_(80).maxHeight_(10).font_(Font.default.size_(11)),
							p.asSlider.fixedWidth_(260).orientation_(\horizontal).maxHeight_(20),
							p.asTextField.fixedWidth_(80).maxHeight_(20).font_(Font.default.size_(11)),
						).spacing_(0).margins_(0)
					}) ++ [nil]
				).spacing_(0).margins_(0);
			VLayout(
				PlayerWrapper(Ndef(ndefname)).asView,
				scroll,
			);

		}).alwaysOnTop_(true);

		)
		(
		WindowDef(\fx1, { 

			ParamGroupLayout.inline_groups(Ndef(\fx1).asParamGroup)
		}).front;

		)
