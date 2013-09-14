Pdef(~name +++ \pre, Pbind(
	\degree, Pseq([0,1,-2,2]+8,inf),
	\freq, Ptuple([
		Pseq([090,110,120,100],inf),
		Pseq([090,110,120]*1.92,inf),
	]),
	\pitch_stretch, Pseq([0.9,1.1,1],inf).stutter(3),
	\freq, [180,100] * Pkey(\pitch_stretch),
	\scale, Scale.minor,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
		[ Env.adsr(0.1,0.1,0.8,0.4) ],
		[ Env.adsr(0.3,0.1,0.8,0.04) ],
	],inf),
	\octave, 3,
	\isRest, Veco(~name).isrest,
	\offset, 0.0001,
	\legato, Pseq([0.7,1.2,0.5],inf).stutter(2),
	\amp, 0.021,
	\offset, Pseg(Pseq([0.001,0.015],inf), 8),
	\dur, 1/4,
));
