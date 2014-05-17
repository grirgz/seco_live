Pdef(~name +++ \pre, Pbind(
	\isRest, Veco(~namex).isrest(32),
	\env0, Pstep(Pfunc({ 
		[ Env.new([0.0, 7.5 + 2.0.rand, 4.5 + 4.0.rand, 0], [0.115, 0.06, 0.8 + 0.2.rand], [-4, -2, -4]) ];
	}),8),
	\env1, [ Env.new([120, 59, 29], [0.005, 0.49], [-4, -5]) ],
	\env1, Pstep(Pfunc({
		[ Env.new([120, 59, 29 + 5.0.rand], [0.005, 0.49], [-4, -5]) ]
	}), 8),
	\isRest, false,
	\env0, [ Env.new([0.5, 4, 7.5, 0], [0.105, 0.16, 1.1], [-4, -2, -4]) ],
	\isRest, Pstep(Pseq([
		Pn(false,31),
		true,
	],inf), 1/2),
	\isRest, Pstep(Pseq([
		Pn(0,16),
		1,
		Pn(0,15),
	],inf), 1/2) > 0,
	\isRest, Pstep(Pseq([
		Pn(0,31),
		1,
	],inf), 1/2) > 0,
	\dur, PdurStutter(Pseq([
		2,2,2,2,
		2,2,2,4,
		2,2,2,2,
		2,2,2,3,

		2,2,2,2,
		2,2,2,4,
		2,2,2,2,
		2,2,2,2,

	],inf),1),
	\dur, PdurStutter(Pseq([
		2,2,2,2,
		2,2,2,4,
		2,2,2,2,
		2,2,2,2,
	],inf),1),
	\pan, Pstep(Pseq([
		0.5,-0.2,0,0,   0,0,0,0,
		-0.5,0.2,0,0,   0,0,0,0,
	],inf), 1/2),
	//\dur, Pseq([1,3, 1,1,1,1]/2,inf)
	\dur, Pseq([1,3, 1,1,1,1]/2,inf),
	\dur, PdurStutter(Pseq([
		2,2,2,2,
		2,2,2,4,
		2,2,2,2,
		2,2,2,2,
	]/2,inf),1/2),
));



// END

(
var bla = { arg x, y; x * y }
3 bla: 2
	
)
s.quit
