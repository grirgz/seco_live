
Pdef(~name +++ \pre, Pbind(
	\maxdelaytime, 0.15,
	\delaytime, Pexprand(0.0001,0.0100).round(0.0007) * Pseq([1,1,2,4,],inf),
	\delaytime, 1/Pseq([100,500,1000],inf),
	\decaytime, Pwhite(0.1,1.710),
	\ifreq, Pseq([3,5.2,2,4.33],inf),
	\ifreq, Pwhite(4.1,18.1),
	\legato, 2.5,
	\dur, 1/8 * Pseq([1,3,2,4],inf),
));
