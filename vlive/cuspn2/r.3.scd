

Pdef(~name +++ \pre, Sdef(~name, \mypreset2).pbind <> Pbind(
	\fratio, 4.25,
	\env0, Pseq([
		[ Env.new([0.5, 9, 9.5, 0], [0.0005, 0.16, 0.4], [-4, -2, -4]) ],
		[ Env.new([0.5, 9, 3.5, 0], [0.0005, 0.26, 0.2], [-4, -2, -4]) ],
		//[ Env.new([1.5, 9, 9.5, 0], [0.05, 0.16, 0.1], [-4, -2, -4]) ],
	],inf).stutter(7),
	\isRest, Veco(~namex).isrest(32),
	\env1, Pseq([
		[ Env.new([040, 29, 49], [0.005, 0.29], [-4, -5]) ],
		[ Env.new([050, 23, 52], [0.005, 0.69], [-4, 5]) ],
		//[ Env.new([040, 029, 079], [0.005, 5.89], [-4, -5]) ],
	],inf).stutter(8)
));

// END

Sdef(~name, \mypreset2).edit
Sdef(~name, \mypreset2, \preset, ~name)
Sdef(~name, \mypreset).reset
Sdef(~name, \mypreset).clear

