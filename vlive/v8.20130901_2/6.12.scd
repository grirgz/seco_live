
Pdef(~name +++ \pre, Pbind(
	\freq, Pstutter(4,Pseq([80,90,095,50, 60,70],inf)),
	\freq, Pstutter(1,Pseq([60,50,54],inf)),
	\ffreq, Pstutter(4,Pseq([14480,1190],inf)),
	\ffreq, Pstutter(1,Pseq([180,1190,3000],inf)),
	\sustain, 0.4,
	\freqtab, [Array.geom(8, 1,0.999)],
	\adsr, [Env.adsr(0.0001,0.1,0.8,0.0001)],
));
