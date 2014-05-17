Pdef(~name +++ \pre, Pbind(
	\dur, 1/8,
	\isRest1, Veco(~namex).isrest(32),
	\isRest2, Plazy({
		Pseq([
			1, 1, 0.95, 1,  1,1,1,1,
			Pser([1],8),
			0.95, 1, 1, 1,  1,1,1,1,
			Pser([1],8),
		]).coin
	}).loop,
	\isRest, Pfunc{ arg ev;
		(ev[\isRest1].not or: ev[\isRest2].not).not
	},
	\fratio, [1/2,4],
	\env0, [ Env.new([0.5, 7, 4.5, 0], [0.005, 0.16, 0.1], [-4, -2, -4]) ],
		//[ Env.new([0.0, 1, 7.5, 0], [0.005, 0.46, 0.7], [-4, -2, -4]) ],
	\env1, [ Env.new([70, 45, 20], [0.045, 0.79], [-4, -5]) ],
	\env1, Pseq([ 
		[ Env.new([70, 45, 20], [0.045, 0.79], [-4, -5]) ],
		[ Env.new([80, 45, 30], [0.015, 0.79], [-4, -5]) ],
		[ Env.new([70, 25, 30], [0.015, 0.79], [-4, 5]) ],
	],inf),
	\env1, Pseq([ 
		[ Env.new([70, 25, 30], [0.015, 0.09], [-4, -5]) ],
	],inf),
));

// END

(
var a, b;
a = Pseq(([1, Pseq([10, 20, 30]), 2, 3, 4, 5]/5), 6).coin;	// return 6 items
b = a.asStream;
7.do({ b.next.postln; });
)
