~name = 'i';

Veco(~name).lib.tracks = List[ '34' ];

Pdef(~name, 
	~clipspawner.() <>
	Pdef(~name+++\pre) <> Pbind(
		\isRest, true,
		\track, Veco(~name).lib.tracks,
		\dur, 4,
	)
);