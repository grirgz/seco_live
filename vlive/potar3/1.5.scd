Pdef(~name +++ \pre, Pbind(
	\isRest, Veco(~namex).isrest(16),
	\fratio, 7,
	\env0, [ Env.new([6.5, 5, 0.5, 0], [0.035, 0.06, 0.3], [-4, -2, -4]) ],
	\env0, ~penv.( Env.new([Pseq([6.5,1],inf), 5, 0.5, 0], [Pseq([0.035,0.005,0.1,0.05],inf), 0.06, 0.3], [-4, -2, -4]) ).stutter(1),
	//\env1, [ Env.new([100, 69, 29], [0.005, 0.29], [-4, -5]) ],
	\env1, [ Env.new([100, 69, 29], [0.005, 0.29], [-4, -5]).asArray ],
	//\env1, Ptuple( Env.new([Pseq([100,50],inf), 69, 29], [0.005, 0.29] ).asArray ).collect{ arg x; [x] }.stutter(4),
	//\env1, ~penv.( Env.new([Pseq([100,50],inf), 69, 29], [0.005, 0.29] )).stutter(4),
	\env1, ~penv.( Env.new([
		Pseq([100,90,50,29],inf), 
		Pseq([60,70,30,50,40],inf).stutter(1), 29], [0.005, 0.29], [-4, -5]
	)).stutter(4),
	\amp, 0.5 * Pkey(\amp),
));

// END

Penv([10,2,5],[1,2]).asStream.nextN(100)
Pdef(\bla, Pbind(
	Penv
))


	
