Pdef(~name +++ \pre, Pbind(
	//\freq, Pseq([
	//	40,50,45,50,
	//]*2,inf).stutter(2),
	\legato, Pseq([1,0.4,1.2],inf),
	\legato, Pn(Pseries(0.1,0.05,32).stutter(4)),
	\legato, 1.0,
	\legato, Pseq([
		1,0.4,1.2,
		0.1,0.2,0.1,0.3,
	],inf),
	\isRest, Veco(~namex).isrest(16),
	//\midinote, Pseq([29+12, 29+24],inf),
	//\midinote, Pseq([29+12, 29+12+3, 29+24, 29+12+7],inf),
	//\freq, Pseq([
	//	Pser([80],32),
	//	Pser([83],32),
	//],inf),
	\fmfreq, ~midi.(\k2,50,\freq.asSpec),
	\octave, 3,
	\scale, Scale.minor,
	\freq, Pseq([
		100,70,100,7000,
		100,2000,100,4000,
		1000,2000,3000,2000,
		3000,4000,3000,2000,
	],inf) * ~midi.(\k3,1,ControlSpec(0.01,2,\exp, 0,1)).valpattern,
));

// END

TempoClock.default.tempo = 88/60
