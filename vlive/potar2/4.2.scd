

Pdef(~name +++ \pre, 
	
	~lmorphpat.(
		[
			Sdef(~name, \mypreset).getsub(0).pbind,
			Sdef(~name, \mypreset).getsub(1).pbind,
			Sdef(~name, \mypreset).getsub(2).pbind,
		],
		//Pseq([0,0.5,1],inf)
		Sdef(~name, \morph).get_active_score.vals[\morph].valpattern
	)
	<>
	//Sdef(~name, \mypreset).pdef <>
	Pbind(
	\env2x, Pseq([0,1,0,1, 0,2,1,1],inf).stutter(2),
	\env2x, Pseq([
		Pseq([0],8),
		Pseq([1,0,2,0],2).stutter(2),
	],inf),
	\env2, Pindex([
		[Env.new([60, 80, 27.5], [0.115, 0.06], [-4, -2, -4]) ],
		[Env.new([60, 70, 47.5], [0.015, 0.6], [-4, -2, -4]) ],
		[Env.new([60, 40, 47.5], [0.005, 0.6], [-4, -2, -4]) ],
	],Pkey(\env2x),inf),
	\env2, [Env.new([10, 20, 87.5], [0.005, 0.6], [-4, -2, -4]) ],
	\rq, 0.2,
	\mixclip, Pseq([0,0.5,0,1],inf),
	\isRest, Veco(~namex).isrest(16),
	\sawamp, 0.07,
	\sawtab, [ [1,0.7,0.85,1] ],
	\envx, Pseq([0,5,2,3, 0,2,4,3],inf).stutter(4),
	\env1, Pindex([
		[Env.new([042, 39, 34], [0.015, 0.29], [-4, -5]) ],
		[Env.new([040, 19, 24], [0.045, 0.09], [-4, -5]) ],
		[Env.new([059, 24, 14], [0.045, 0.09], [-4, -5]) ],
		[Env.new([039, 39, 24], [0.045, 0.09], [-4, -5]) ],

		[Env.new([040, 19, 24], [0.045, 0.09], [-4, -5]) ],
		[Env.new([039, 24, 14], [0.045, 0.09], [-4, -5]) ],
		[Env.new([039, 39, 24], [0.045, 0.09], [-4, -5]) ],
		[Env.new([042, 39, 24], [0.045, 0.09], [-4, -5]) ],
	],Pkey(\envx),inf),
	\env0, [Env.new([0.0, 1, 0.5, 0], [0.015, 0.16, 00.14], [-4, -2, -4]) ],
	\env2, [Env.new([30, 40, 17.5], [0.015, 0.6], [-4, -2, -4]) ],
	\env3, [Env.new([17, 80, 17.5], [0.015, 0.6], [0, -2, -4]) ],
	\env1, [Env.new([012, 45, 34], [0.015, 0.29], [-4, -5]) ],
	\fratio, Pseq([1.5,3],inf),
	\fratio, 1,
));

// END

Sdef(~name, \mypreset)
