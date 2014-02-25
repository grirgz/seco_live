Pdef(~name +++ \pre, 
	Pbind(
	\fratio, Pseq([1.5,2.3,2.7,2.1,1.8],inf).stutter(1),
	//\release, Pseq([0.1,0.7, 0.5,0.1, 1.1]/2,1),
	//\release, Pn(0.21,1),
	\rq, Pseq([0.1,0.5,00.02,0.9],inf),

	) <>

	Sdef(~name, \mypreset).pbind <>
	
	Pbind(
	\isRest, Veco(~namex).isrest(32),
	\fratio, 2,
	\env1, [Env([ 10, 49, 18.34  ], [ 0.05, 0.09  ], [ -4, 5  ])],
	\env0, [Env([ 0.5, 1, 0.5, 0  ], [ 0.45, 0.06, 0.1  ], [ -4, -2, -4  ])], 
	\fratio, Pseq([1.5,2.3,2.7,2.1,1.8],inf).stutter(1),
	//\release, Pseq([0.1,0.7, 0.5,0.1, 1.1]/2,1),
	//\release, Pn(0.21,1),
	\rq, Pseq([0.1,0.9],inf),
));

// END

Sdef(~name, \mypreset).edit
	Sdef(~name, \mypreset).get_active_score.get_event[\env1][0].asCompileString
	Sdef(~name, \mypreset).get_active_score.get_event[\env0][0].asCompileString

