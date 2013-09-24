
Pdef(~name+++\pre, PmonoArtic(~name,
	//\freq, Pseq()100,
	\degree, Pseq([0,1,5,5],inf).stutter(8),
	\degree, Pstep(Pseq([0,1,5,5],inf),2),
	\isRest, Veco(~namex).isrest(16),
	\fmin, 4.01,
	\fmin, Pseq([1,0.14,7,0.56],inf),
	\fadd, [[ 0.012,0.021,0.03 ]],
	\fadd, [[ 0,1,0,2, 0,1.2,0,1 ]],
	\ftri, [[ 0.01,0.01,0.01 ]],
	\ftri, [[ 1,4,1.1,2, 0.870,1.2,0,1 ]],
	\fdiv, 20,
	\fmax, Pseq([1,0.14,2.1,1.2, 2.6,0.2,0.3,0.4]*1,inf).stutter(1),
	\legato, Pseq([1,0.81, 1,0.99, 0.7,1.11, 1,0.69],inf).stutter(4),
	\dur, 1/8,
	\octave, 4
));

// END
Pdef(~name +++ \pre, PmonoArtic(~name,
	//\freq, Pseq()100,
	\degree, Pseq([0,1,5,5],inf).stutter(8),
	\degree, Pstep(Pseq([0,1,5,5],inf),2),
	\legato, Pseq([1,1,0.9,1,1],inf).stutter(8),
	\octave, 3
));


Pdef(~name).play
