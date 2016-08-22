~name = 'rise10-z';

Veco(~name).lib.tracks = (0..7);

Pdef(~name, 
	~clipspawner.() <>
	Pdef(~name+++\pre) <> Pbind(
		\isRest, true,
		\track, Veco(~name).lib.tracks,
		\dur, 4,
	)
);
