
Pdef(~name +++ \pre, Pbind(
	\env0, [Env.new([0.0, 1, 0.5, 0], [0.115, 0.06, 00.1], [-4, -2, -4]) ],
	\env2, [Env.new([20, 10, 0.5, 0], [0.015, 0.06, 00.1], [-4, -2, -4]) ],
	\sawtab, [ [1,0.5,1.25,2] ],
	\env1, Pseq([
		[Env.new([052, 19, 34], [0.045, 0.09], [-4, -5]) ],
		[Env.new([050, 19, 14], [0.045, 0.09], [-4, -5]) ],
		[Env.new([039, 29, 14], [0.045, 0.09], [-4, -5]) ],
		[Env.new([039, 39, 24], [0.045, 0.09], [-4, -5]) ],
	],inf).stutter(8),
	\fratio, Pseq([1.5,3],inf),

	\env0, [Env.new([0.0, 1, 0.5, 0], [0.015, 0.06, 00.4], [-4, -2, -4]) ],
	\env2, [Env.new([37, 50, 17.5], [0.005, 0.06], [0, -2, -4]) ],
	\env3, [Env.new([40, 48, 47.5], [0.015, 0.16], [-4, -2, -4]) ],
	\rq, 0.4,
	\mixclip, 0.9,
	\sawamp, 0.07,
	\sawtab, [ [1,0.7,0.85,1] ],
	\env1, Pseq([
		[Env.new([032, 29, 34], [0.045, 0.09], [-4, -5]) ],
		[Env.new([040, 19, 24], [0.005, 0.09], [-4, -5]) ],
		[Env.new([039, 24, 14], [0.005, 0.09], [-4, -5]) ],
		[Env.new([039, 39, 24], [0.045, 0.09], [-4, -5]) ],

		[Env.new([040, 19, 24], [0.045, 0.09], [-4, -5]) ],
		[Env.new([039, 24, 14], [0.045, 0.09], [-4, -5]) ],
		[Env.new([039, 39, 24], [0.005, 0.09], [-4, -5]) ],
		[Env.new([042, 39, 24], [0.045, 0.09], [-4, -5]) ],
	],inf).stutter(4),
	\fratio, Pseq([1.5,3],inf),
));