Pdef(~name +++ \pre, 
	Pdef(~name+++\macro2) <>
	
	Pbind(
	\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.16, 0.8], [-4, -2, -4]) ],
	\env1, [ Env.new([110, 41, 30], [0.015, 0.29], [-4, -5]) ],
	\env3, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.016, 0.04], [-4, -2, -4]) ],
	\timeScale, 1,

	\freqpan, 0.001,
	\oscmix, 0.7,
	\osc2mix, 0.4,
	\fratio1, 2,
	\fratio2, 4,
	\distlim, 0.9,
	\distmix, 0.3,
	\pan, Pseq([
		Pser([0],17),
		Pwhite(-1.0,1.0,16-1)
	],inf).stutter(1) * 0.5,
	\spread, 0.1,
	\fratio, Pseq([0.21,2],inf).stutter(4),
	\dur, 1/8,
	\isRest, Veco(~namex).isrest(16),
	\isRest, Pseq([
		Pser([
			1,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
			1,0,0,0, 0.1,0,0,0,
			1,0,0,0, 0,0,0,0,

			1,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
			1,0,0.51,0, 0.51,0,0,0,
			1,0,0,0, 0,0,0.5,0,
		],inf),
	],inf).coin.not,
));

// END

Pdef(~name+++\macro, Pbind())
Pdef(~name+++\macro).addHalo(\instrument, nil)
Pdef(~name+++\macro).asRack.edit
Pdef(~name+++\macro).clear

Pdef(~name+++\macro2, Pbind())

Pdef(~name+++\macro2).set(\oscmix, 0.2);
Pdef(~name+++\macro2).addSpec(\oscmix, \unipolar);

Pdef(~name+++\macro2).set(\osc2mix, 0.2);
Pdef(~name+++\macro2).addSpec(\osc2mix, \unipolar);

Pdef(~name+++\macro2).set(\distmix, 0.2);
Pdef(~name+++\macro2).addSpec(\distmix, \unipolar);

Pdef(~name+++\macro2).asRack.edit
(
	
Spec.add(\env0, XEnvSpec(ControlSpec(0,9,\lin,0,0.1) ! 4, ControlSpec(0.001,4,\exp,0), ControlSpec(-9,9,\lin,0,0)),
	Env.new([0.5, 1, 0.5, 0], [0.005, 0.16, 0.8], [-4, -2, -4])
);
Spec.add(\env3, XEnvSpec(ControlSpec(0,9,\lin,0,0.1) ! 4, ControlSpec(0.001,4,\exp,0), ControlSpec(-9,9,\lin,0,0)),
	Env.new([0.5, 1, 0.5, 0], [0.005, 0.16, 0.8], [-4, -2, -4])
);
Spec.add(\env1, XEnvSpec(\freq.asSpec ! 4, ControlSpec(0.001,4,\exp,0), ControlSpec(-9,9,\lin,0,0)),
	Env.new([110, 41, 30], [0.015, 0.29], [-4, -5])
);
)

Pdef(\hey).edit
Sdef()

[0.6]
[110,53,29].midicps
