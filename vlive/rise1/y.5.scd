Pdef(~name +++ \pre, 

	Sdef(~name, \mypreset).pbind <>
	
	Pbind(
	//\isRest, Pseq([
	//	Veco(~namex).isrest(32,1), Pn(false,2),
	//],inf),
	\isRest, Veco(~namex).isrest(32),
	\fratio, Pseq([1.5,2.3,2.7,2.1,1.8],inf).stutter(1),
	\fratio, 2,
	\legato, 0.01,
	\sustain, 0.01,
	//\release, Pseq([0.1,0.7, 0.5,0.1, 1.1]/2,1),
	//\release, Pn(0.21,1),
	\rq, 0.9,
));

// END

Sdef(~name, \mypreset).edit
