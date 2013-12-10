~name = 'u';

Veco(~name).lib.tracks = List[ '1', '2', '3', '4', '5' ];

Pdef(~name, 
	~clipspawner.() <>
	Pdef(~name+++\pre) <> Pbind(
		\isRest, true,
		\lag, -0.1,
		\ccc, Pfunc{ TempoClock.default.beats.postln; 1; },
		\track, Veco(~name).lib.tracks,
		\dur, 4,
	)
);
