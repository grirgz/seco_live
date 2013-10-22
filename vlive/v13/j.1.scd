Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([100,60]*4,inf).stutter(2) + Pseg(Pseq([0,0,-5],inf),Pseq([6,0.5,0.5],inf)),
	\isRest, Veco(~name).isrest(32),
	\ffreq, Pseq([2000,100,200,300, 2000,100,1000,300],inf),
	\ffreqtab,Pn(Plazy({
		Pseq([[Array.geom(8,0.1,2).scramble]],32)
	})),

	\dur, 1/8,
));
