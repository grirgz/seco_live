
Pdef(~name +++ \pre, Pbind(
	\maxdelaytime, 0.15,
	\delaytime, Pexprand(0.0001,0.0100).round(0.0007) * Pseq([1,1,2,4,],inf),
	\decaytime, Pwhite(0.5,5.710),
	//\decaytime, 1/Pwhite(70.0,5000),
	\delaytime, 1/Pseq([100,500,1000],inf),
	\delaytime, 1/Pwhite(70.0,15000),
	\ifreq, Pseq([3,5.2,2,4.33],inf),
	\ifreq, 0.400,
	\ifreq, Pwhite(0.1,1.1),
	\legato, 2.5,
	\dur, Pwhite(0.1,0.3),
	\dur, 1/8 * Pseq([1,3,2,4],inf),
));
