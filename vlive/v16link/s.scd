~name = 's';

Veco(~name).lib.tracks = List[ '1', '2', '3', '4', '5' ];

Pdef(~name, 
	~clipspawner.() <>
	Pdef(~name+++\pre) <> Pbind(
		\isRest, true,
		\track, Veco(~name).lib.tracks,
		\dur, 4,
	)
);