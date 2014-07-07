Pdef(~name +++ \pre, Pbind(
	\freq, 498,
	\freq, Pseq([
		700,500,1600,

	],inf),
	\dur, 1/2,
	\legato, 0.1,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
	],inf),
	\isRest, false,
));

// END

( 'instrument': '7', 'legato': 0.1, 'degree': 0, 'dur': 0.5,   'amp': 0.1, 'isRest': false, 'freq': 700, 'adsr': [ Env([ 0.0, 1.0, 0.8, 0.0  ], [ 0.1, 0.1, 0.1  ], -4.0, 2)  ]  )

(
Pdef(\ciop, Pbind(
	\instrument, \default,
	\degree, Pseq([0,1,2],inf),
	\degree, Pfunc({~freq}),
	\dur, 1,
	\amp, 0.7
)).play;
);
~freq = 1;
a = Environment.new
a.push
a.parent = topEnvironment
~freq = 0
~freqa = 2
~freqa = 0
topEnvironment.push
(
Pdef(\ciop, Pbind(
	\instrument, \default,
	\degree, Pseq([0,1,2],inf),
	\degree, Pfunc({~freq}),
	\octave, 4,
	\dur, 1/3,
	\amp, 0.7
)).play;
);

(
Pdef(\ciopA, Pbind(
	\instrument, \default,
	\degree, Pseq([0,1,2],inf),
	\degree, Pfunc({~freq}),
	\octave, 4,
	\dur, 1/3,
	\amp, 0.7
)).play;
);


~show = { ~bla.debug("bla") }
~bla = 1
~show.value
~bla = 2
a.push
topEnvironment.push
a.includesKey(\show)
a.at(\show)
Dictionary
