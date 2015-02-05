

Pdef(~name +++ \pre, 
	
	~dPdef.(~name+++\macro) <>
	Pbind(
	\fratio, 4.25,
	\amp, Pkey(\amp) * 1/3,
	\env0, [ Env.new([1.5, 9, 9.5, 0], [0.0005, 0.16, 0.1], [-4, -2, -4]) ],
	\env1, [ Env.new([080, 49, 29], [0.005, 0.49], [-4, -5]) ],
));

// END

