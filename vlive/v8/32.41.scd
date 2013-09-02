(
Ndef(~name+++\freq, { arg val=200;
	val.lag(0.2);
});
Ndef(~name+++\freq).put(1, \set -> Pbind(
	//\val, Pseq([0,1,9,4].collect({ arg x; ~degcps.(x,5)}),inf),
	\deg, Pseq([
		0,1,0,1, 0,1,6,5, 0,6,0,6, 5,1,6,5,
	],inf),
	\val, Pfunc{ arg ev; ev[\deg].debug("DEG"); ~degcps.(ev[\deg],5)},
	\dur, 1/4,
));
Pdef(~name +++ \pre, Pbind(
	//\freq, Pseq([50,40,55,50, 60,65,45,50],inf),
	//\degree, Pseq([0,1,2,4],inf),
	\freq, Ndef(~name+++\freq).bus.asMap,
	\dur, 1/4,
	//\amp, Pkey(\amp) * 1.2,
	\freqtab, Pfunc {

		[ Array.series(8, 0.99, rrand(0.001,0.7) ) ];
	},
	\freqtab, [ Array.series(8, 0.99,1.014) ],
	\fratio, Pseq([
		Pseq([[0.1,0.5,1.01,2, 2,4,6,8], 1].flop,1),
		Pseq([[0.1,0.5,1.01,2, 2,4,6,8].reverse, 1].flop,1),
	],inf),
));
);
