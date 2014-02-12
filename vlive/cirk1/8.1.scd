//Pdef(~name)
Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\isRest, Pseq([Veco(~name).isrest(16,1),Pn(true,4),Pn(false,4)],inf) ,
	\speed, Pseq([
		0.1,0.2,0.3,0.1,
		0.4,0.02,0.3,0.1,
		0.1,0.2,0.3,0.1,
		0.4,0.52,0.3,0.1,
	],inf)+Pwhite(0,0.01),
));

// END

Buffer
	BufDef(\camion).numFrames /
