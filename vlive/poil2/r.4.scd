
~modkick = Pbind(
	\isRest, Pser([1,1,1,1, 1,1,1,1] < 1,1),
	\fratio, Pseq([3,0.3,4,0.2],inf),
	\amp, Pkey(\amp) / 2,
	\env0, [ Env.new([0.5, 3, 0.5, 0], [0.005, 0.16, 0.4], [-4, -2, -4]) ],
	\env1, [ Env.new([100, 39, 29], [0.005, 0.49], [-4, -5]) ],
);
//~modsnare = Pbind(\isRest, Pser([0,0,0,0, 0,0,1,0] < 1,16));
//~modhihat = Pbind(\isRest, Pser([0,1,0,1] < 1,16));
