~patfx_gate.(~name+++\patfx, Pbind(
	//\reprate, Pseq([10,20,30,40],inf),
	//\isRest, Pseq([true,false],inf),
	\isRest, Veco(~namex).isrest(32),
));
currentEnvironment[~name+++\patfxquant] = 4;
