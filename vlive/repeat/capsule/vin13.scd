
{ SinOsc.ar(200) * 0.1 ! 2 }.play;
{ SinOsc.ar(700) }.play;
{ SinOsc.ar(900) }.play;


(
Pdef(\part, Pdef(\zed1, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0, 1, 2, 3,
				5, 1, 2, 3,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,1,0,0, 1,0,1,0,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed2, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0, 1, 2, 3,
				5, 1, 2, 3,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			]+0.2,inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Pseq([
			Pfindur(4, Pdef(\zed1)),
			Pfindur(4, Pdef(\zed2)),
		],inf),
		
	])
)).play;
);
