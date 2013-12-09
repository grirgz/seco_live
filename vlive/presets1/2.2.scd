(
Ndef(~name+++\freq, { arg val=200;
	val.lag(0.2);
});
Ndef(~name+++\freq).put(1, \set -> Pbind(
	//\val, Pseq([0,0,8,0].collect(~degcps.(_,4))*2,inf),
	\val, Pseq(~cdegcps.([0,8,0,-8]),inf),
	\dur, 1/2,
));
Pdef(~name +++ \pre, Pbind(
	//\freq, Pseq([50,40,55,50, 60,65,45,50],inf),
	//\degree, Pseq([0,1,2,4],inf),
	\freq, Ndef(~name+++\freq).bus.asMap,
	\freqtab, [ Array.series(8, 0.99,0.002) ],
	\freqtab, Pfunc {
		[ Array.series(8, 0.99, rrand(0.01,0.012) ) ];
	},
	\fratio, Pseq([
		Pseq([[0.1,0.5,1.01,2, 2,4,6,8], 1].flop,1),
		Pseq([[0.1,0.5,1.01,2, 2,4,6,8].reverse, 1].flop,1),
	],inf),
	\fratio, 3,
));
);

// END

[0.1,0.5] *.t [1,1.2]
[[0.1,0.5,1.01], 1].flop


Scale.major.degreeToFreq(2, 60.midicps, 1);
Scale.major.degreeToFreq(2, 60.midicps, 1);

~degcps.(1.5)
