


Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([80, 50,120,40, 45,80,60,120],inf),
	\mul, Pstutter(8,Pseq([0.6,0.7,0.8,0.9, 1.1,1.2],inf)),
	\freqtab, Pn(Plazy{ arg ev;
		[Array.geom(8, 1,ev[\mul])];
	}),
	\adsr, [Env.adsr(0.0001,0.1,0.8,0.1)],
	\legato, Pseq([0.8,0.7,1],inf),
	\ffreq, 5100,
));
