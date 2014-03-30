Pdef(~name +++ \pre, Pbind(
	\prob, Pseq([0,0.5,0.2,0.7],inf),
	\isRest, Veco(~namex).isrest(32) && Pfunc{ arg e; e.prob.coin },
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\shift, Pseq([100,0,50,100,-200],inf),
	\legato, Pseq([0.1,3,0.7,1,0.5,2],inf),
	\freqfactor, Pseq([1,1.1,0.42],inf),
	\shift, 000,
	\freqfactor, 0.22,
	\freqfactor, ~midi.(\k3, 1, ControlSpec(0.01,3,\exp, 0,1)).vpattern,
	\plegato, Pseq([
		0,0,0,0,
		0,0.5,-1,0,

		0,0,0,0,
		1,0,1,0,
	],inf),
	\legato, 2 + Pfunc{ arg e; e.plegato.rand },
));

// END

\freqshift.asSpec
\rate.asSpec
