
Pdef(~name +++ \pre, Pbind(
	//\freq, Pstutter(4,Pseq([80,90,095,50, 60,70],inf)),
	//\freq, Pstutter(Pseq([2,4,2,4],inf),Pseq([60,65,70,45],inf)),
	\degree, Pseq([
		1,0,3,4,
		1,3,3,0,
	],inf),
	\octave, 3,
	\ffreq, Pstutter(4,Pseq([14480,1190],inf)),
	\ffreq, Pstutter(1,Pseq([180,1190,300,50,350],inf)) * Pstutter(8,Pseq([1,2,2.5],inf)),
	\isRest, Veco(~name).isrest(16),
	\sustain, Pseq([0.1,1.1,0.4,0.1],inf),
	\freqtab, Pseq([
		[Array.geom(8, 1,0.999)],
		[Array.geom(8, 1,0.989)],
	],inf),
	\dur, 1/8,
	\adsr, [Env.adsr(0.0001,0.4,0.4,0.0001)],
));
