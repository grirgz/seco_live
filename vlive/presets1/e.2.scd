
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([50,90],inf),
	\sweepfmfreq, Pseq([0.1,0.5,0.40],inf),
	\sweepfmfreq, Pseq([1,5,40],inf),
	\sweepfreq, Pseq([10,30,5,60],inf),
	\sweepfreq, Pseq([100,300,500,60],inf),
	\writefreq, Pseq([
		[1,1.2],
		[47,72.2],
		[1,1.2]*4,
	],inf),
	\sigmix, 0.11,
	\sigmix, Pseg(Pseq([0.1,0.99,0.5],inf), 4),
	\filtmix, Pseg(Pseq([0.1,0.99,0.5],inf), 4),
	\ffreq, Pseq([500,800,600]*2,inf),
	\sweepscale, Pseq([300,500,0.6],inf) * Pwhite(0.8,1.56),
	\sweepscale, Pseq([0.9,0.5,0.6],inf) * Pwhite(0.8,7.56),
	\freqscale, Pseq([0.8,0.54,00.154],inf),
	\sweeprate, Pseq([4000,500,60,3000],inf) * Pwhite(0.8,1.56),
	\amp, Pkey(\amp) * 0.8,
));
