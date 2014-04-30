Pdef(~name +++ \pre, 

	Sdef(~name, \mypreset).pbind <>
	
	Pbind(
	\isRest, Veco(~namex).isrest(32),
	\fratio, Pseq([1.5,2.3,2.7,2.1,1.8],inf).stutter(1),
	\fratio, 2,
	\amp, Pstutter(1, 
		Pseq([
			1,0.1,0.5,0.1,
		],inf) * Pswitch1([Pseg(Pseq([1,0],inf),8), 1.01],Pseq([0,1],inf))+0.1
	) * Pkey(\amp),
	//\release, Pseq([0.1,0.7, 0.5,0.1, 1.1]/2,1),
	//\release, Pn(0.21,1),
	\pan, Pstutter(2, 
		Pseq([
			0,-1,1, 0.4,
		],inf) * Pswitch1([Pseg(Pseq([1,0],inf),8).asStream, 0.01],Pseq([0,1],inf))
	) / 2,
	\rq, 0.9,
));

// END

Sdef(~name, \mypreset).edit
