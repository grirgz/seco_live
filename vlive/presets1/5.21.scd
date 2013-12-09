
Pdef(~name +++ \pre, Pbind(
	\freq, Pstutter(4,Pseq([80,90,095,50, 60,70],inf)),
	\freq, Pstutter(Pseq([2,4,2,4],inf),Pseq([60,55,50,45],inf)),
	\ffreq, Pstutter(4,Pseq([14480,1190],inf)),
	\ffreq, Pstutter(1,Pseq([180,1190,300,50,350],inf)) * Pstutter(8,Pseq([1,2,2.5],inf)),
	\isRest, Veco(~name).isrest(16),
	\sustain, 0.2,
	\freqtab, Pseq([
		[Array.geom(8, 1,0.999)],
		[Array.geom(8, 1,0.989)],
		[Array.geom(8, 1,0.979)],
	],inf),
	\dur, 1/8,
	\adsr, [Env.adsr(0.0001,0.4,0.8,0.0001)],
));
