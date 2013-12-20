Pdef(~name +++ \pre, Pbind(
	//\freq, Pseq([
	//	40,50,45,50,
	//]*2,inf).stutter(2),
	\legato, Pseq([1,0.4,1.2],inf),
	\legato, Pn(Pseries(0.1,0.05,32).stutter(4)),
	\legato, 2.5,
	\isRest, Veco(~namex).isrest(64),
	//\midinote, Pseq([29+12, 29+24],inf),
	//\midinote, Pseq([29+12, 29+12+3, 29+24, 29+12+7],inf),
	//\freq, Pseq([
	//	Pser([80],32),
	//	Pser([83],32),
	//],inf),
	\octave, 3,
	\scale, Scale.minor,
	\degree, Pseq([
		[4-7,6-7,8-7],[1+7,3,5-7],[5-7,7-7,9-7],[2+7,4,6-7],
	],inf).stutter(8)
));

// END

TempoClock.default.tempo = 88/60
