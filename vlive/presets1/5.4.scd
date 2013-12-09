
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([80, 50,120,40, 45,80,60,120],inf),
	\freqtab, [Array.geom(8, 1,0.85)],
	\adsr, [Env.adsr(0.0001,0.1,0.8,0.1)],
	\legato, Pseq([0.8,0.7,1],inf),
	\ffreq, 5100,
));
