Pdef(~name +++ \pre, Pbind(
	\maxdelaytime, 0.15,
	\delaytime, Pwhite(0.0001,0.010),
	\ifreq, Pseq([3,5.2,2,4.33],inf),
	\ifreq, Pwhite(4.1,18.1),
	\legato, 1.5,
	\dur, 1/8 * Pwhite(0.9,1.9),
));
