Pdef(~name +++ \pre, Pbind(
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
	\isRest, Pkey(\isRest1),
	//\fratio, [1/2,4],
	\env0, [
		[ Env.new([0.5, 7, 4.5, 0], [0.005, 0.26, 0.2], [-4, -2, -4]) ],
		[ Env.new([0.7, 5, 7.5, 0], [0.005, 0.16, 0.1], [-4, -2, -4]) ],
	],
	\env0, 
		[ Env.new([0.7, 5, 7.5, 0], [0.005, 0.16, 0.1], [-4, -2, -4]) ],
	\env1, Prand([ 
		[ Env.new([70, 45, 20], [0.045, 0.79], [-4, -5]) ],
		[ Env.new([80, 45, 30], [0.015, 0.79], [-4, -5]) ],
		[ Env.new([70, 25, 30], [0.015, 0.79], [-4, 5]) ],
	],inf),
	\midinote, Pseq([45,75,12,32],inf).stutter(4),
	\midinote, ~midi.(\k1, 100, \freq.asSpec).valpattern.cpsmidi,
	\hpfreq, ~midi.(\k2, 45, \freq.asSpec).valpattern,
	\lpfreq, ~midi.(\k3, 450, \freq.asSpec).valpattern,
	\env1, Plazy({ arg ev;

		[ Env.new([90, ev[\midinote], 30], [0.005, 0.19], [-4, -5]) ]
	}).loop,
));

// END
\midi.asSpec

(
var a, b;
a = Pseq(([1, Pseq([10, 20, 30]), 2, 3, 4, 5]/5), 6).coin;	// return 6 items
b = a.asStream;
7.do({ b.next.postln; });
)
