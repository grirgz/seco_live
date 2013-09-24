Pdef(~name +++ \pre, Pbind(
	\freqshift, Pseq([-100,50,10],inf),
	\sintab, [Array.geom(4,1/8,2)],
	\env, [ Env([19,120,20],[0.05,0.2]) ],
	\lpfreq, Pseq([500,1000,5000,1000],inf),
));
