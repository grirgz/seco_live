(
Ndef(~name+++\freq, { arg freq=200;
	SinOsc.kr(freq).range(300,4800);
});
Ndef(~name+++\freq).put(1, \set -> Pbind(
	//\val, Pseq([0,6,0,4, 0,7, -4,4].collect(~degcps.(_,4))*2,inf),
	//\freq, Pseq([0,6,0,4, 0,7, 3,4]+0.3,inf),
	\freq, Pseq([0,2,0,4, 0,8, 2,4]+0.01,inf)*Ptempo(),
	\dur, 2/1,
));
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([60,40,55,50, 80,65,45,50]*8,inf),
	\freq, Pseq([
		1160,1150,1000,1000,
		1160,1120,1300,1100,
	],inf).stutter(8),
	//\degree, Pseq([0,1,2,4],inf),
	\freq, Ndef(~name+++\freq).bus.asMap,
	\freqtab, [ Array.series(8, 0.99,0.002) ],
	\freqtab, Pfunc {

		[ Array.series(8, 0.99, rrand(0.001,0.7) ) ];
	},
	\freqtab, Pfunc {

		[ Array.geom(8, 1/5, 0.72) ];
	},
	\delayrange, 0.01,
	\delaytab, Pfunc {

		[ Array.series(8, 0.09, rrand(0.001,0.07) ) ];
	},
	\amp, Pkey(\amp) * 2.8,
	\legato, Pseq([1,1.5,1.1,1.2],inf).stutter(2),
	\adsr, [ Env.adsr(0.1,0.1,0.8,0.004) ],
	\fratio, Pseq([
		Pseq([[0.1,0.5,1.01,2, 2,4,6,8], 1].flop,1),
		Pseq([[0.1,0.5,1.01,2, 2,4,6,8].reverse, 1].flop,1),
	],inf),
	\fratio, 1,
));
);
