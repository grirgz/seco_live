Pdef(~name +++ \pre, Pbind(
	\isRest, Veco(~namex).isrest(32),
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\shift, Pseq([100,0,50,100,-200],inf),
	\legato, Pseq([0.1,3,0.7,1,0.5,2],inf),
	\shift, 000,
	\freqdiff, 0.8,
	\legato, Pseq([1,2,1,0.5],inf),
	\legato, Pseq([
		1,0.5,
		1,0.1,
		1,0.8,
		1,0.4,

		1,1.0,
		1,0.1,
		0.1,0.8,
		1,0.4,
	],inf) * Pswitch1([Pseg(Pseq([1,0],inf),8).asStream, 1.01],Pseq([0,1],inf))+0.1,
	//\legato, 0.1,
	\freqfactor, Pseq([1.1,0.42]*1/2,inf),
).trace);
