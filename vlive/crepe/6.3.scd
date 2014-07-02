(

Pdef(~name +++ \pre, 
	Pbind(
		\dur, 1/8,
		\legato, 0.2,
		\mbufnum, BufDef.mono(\crepe),
		\amp, 494 * Pkey(\amp) * 0.4,
		//\lag, -0.01,
		//\time_stretch, 0.41,
		//\pos, Pkey(\pos) + 0.111,
		\pos, Pseq([0.3,0.2,0.4,0.7],inf).stutter(16) + Pwhite(0.0,0.0001).stutter(4) + Pwhite(0.0,0.01).stutter(16*4),
	) <>
	Sdef(~name, \mypreset).pbind <>
	
	Pbind(
	\pos, 0.0348,
	\legato, 1,
	\sustain, 0.4,
	\dur, 1/2,
	\time_stretch, 0.011,
	\pitch_stretch, 1,
	\freq, 100,
));
);

~set_macro.(\k1, Sdef(~name, \mypreset), \time_stretch);
~set_macro.(\k2, Sdef(~name, \mypreset), \pitch_stretch);
~set_macro.(\k3, Sdef(~name, \mypreset), \pos, \unipolar.asSpec);

// END

