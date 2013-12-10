~name = 's';

Veco(~name).lib.tracks = nil;

Pdef(~name, 
	~clipspawner.() <>
	Pdef(~name+++\pre) <> Pbind(
		\isRest, true,
		\track, Veco(~name).lib.tracks,
		\dur, 4,
	)
);