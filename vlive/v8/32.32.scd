(
Ndef(~name+++\freq, { arg freq=200;
	SinOsc.kr(freq).range(300,0800);
});
Ndef(~name+++\freq).put(1, \set -> Pbind(
	//\val, Pseq([0,6,0,4, 0,7, -4,4].collect(~degcps.(_,4))*2,inf),
	\freq, Pseq([0,6,0,4, 0,7, 3,4]+0.3,inf),
	\dur, 2/1,
));
Pdef(~name +++ \pre, Pbind(
	//\freq, Pseq([50,40,55,50, 60,65,45,50],inf),
	//\degree, Pseq([0,1,2,4],inf),
	\freq, Ndef(~name+++\freq).bus.asMap,
	\freqtab, [ Array.series(8, 0.99,0.002) ],
	\freqtab, Pfunc {

		[ Array.series(8, 0.99, rrand(0.001,0.7) ) ];
	},
	\fratio, Pseq([
		Pseq([[0.1,0.5,1.01,2, 2,4,6,8], 1].flop,1),
		Pseq([[0.1,0.5,1.01,2, 2,4,6,8].reverse, 1].flop,1),
	],inf),
));
);
