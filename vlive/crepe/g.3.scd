Pdef(~name +++ \pre, 
	Pbind(
		\dur, 2**Pkey(\pdur) * 1/8,
		\legato, 1,
		\sawtab, Plazy({ arg ev;
			Pseq([
				[ { ev[\randsawtab].rand} ! 8 + ev[\freq]];
			])
		}).loop,

	) <>
	
	~dPdef.(~name+++\mod) <>
	
	Pbind(
		\pdur, 1,
	\freq, 400 * (2**([0/12,2/12,5/12])),
	\freq, Pseq([
		(2**([0/12,2/12,5/12])),
		(2**([5/12,8/12,10/12])),
		(2**([6/12,8/12,11/12])),
		(2**([7/12,9/12,12/12])),

		(2**([0/12,2/12,5/12])),
		(2**([5/12,3/12,10/12])),
		(2**([1/12,8/12,11/12])),
		(2**([7/12,9/12,12/12])),
	],inf).stutter(4) * Pseq([400, [400,200], [400,100,800], [100,200,400]],inf).stutter(1),
	\dur, 1/2,
	\randsawtab, 10,
	\adsr, Pseq([
		[ Env.adsr(0.20,0.1,0.8,0.4) ],
	],inf),
	\sigmix, Pseg(Pseq([0.2,0.8,Pwhite(0.0,8,1),Pwhite(0.0,8,1)],inf),16),
	\detune, Pseq([1,0,5,-8],inf).stutter(8) * 2,
	\legato, 0.051,
	//\amp, Pseq([1,0.5,0.7,0.3],inf).stutter(1) * Pkey(\amp) * Pseq([1,0.8,1,0.8,1,0.4],inf).stutter(8),
	\amp, 1 * Pkey(\amp),
));

// END


