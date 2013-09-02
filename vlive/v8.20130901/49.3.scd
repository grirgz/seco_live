

Pdef(~name +++ \pre, Pbind(
	\maxdelaytime, 0.15,
	\delaytime, 1/Pseq([50,90,100,80,60],inf),
	\decaytime, Pwhite(0.1,1.710),
	\isRest, Veco(~name).isrest,
	\ifreq, Pwhite(4.1,18.1),
	\ifreq, Pseq([1,2,8,4,2],inf)*Ptempo(),
	\legato, 2.5,
	\dur, 1/8 * Pseq([1,3,2,4],inf),
	\dur, 1/8,
));
