Pdef(~name +++ \pre, 
	Pbind(
		//\midinote, Plazy({ arg ev;
		//	Pseq([45,75,12,32],1).stutter(ev[\midinote_stutter])
		//}).loop,
		//\env1, Plazy({ arg ev;

		//	[ Env.new([90, ev[\midinote], 30], [0.005, 0.49], [-4, -5]) ]
		//}).loop,
		\isRest1, Veco(~namex).isrest(32),
		\isRest2, Plazy({ arg ev;
			var pat = Pseq([
				1, 1, 0.95, 1,  1,1,1,1,
				Pser([1],8),
				0.95, 1, 1, 1,  1,1,1,1,
				Pser([1],8),
			]);
			"hey,!!!!".postln;
			pat = pat - ev[\restprob];
			//pat = pat.clip(0,1);
			pat = pat.coin;
			pat.postln;
			pat;
		}).loop,
		\isRest, Pfunc{ arg ev;
			(ev[\isRest1].not or: ev[\isRest2].not).not
		},
		//\isRest, Pkey(\isRest1),

	) <>
	Pdef(~name+++\macro) <>
	Pbind(
		\midinote_stutter, 4,
		\restprob, 0,
	\fratio, [1/2,4],
	\env0, Plazy({
		[
			[ Env.new([0.5, 7, 4.5, 0], [0.005, 0.26, 0.2], [-4, -2, -4]) ],
			[ Env.new([0.7, 5, 7.5, 0], [0.005, 0.16, 0.1], [-4, -2, -4]) ],
		]
	}).loop,
	\env0_timescale, 0.4,
	\env1, Prand([ 
		[ Env.new([70, 45, 20], [0.045, 0.79], [-4, -5]) ],
		[ Env.new([80, 45, 30], [0.015, 0.79], [-4, -5]) ],
		[ Env.new([70, 25, 30], [0.015, 0.79], [-4, 5]) ],
	],inf),
));

// END

(
~modifyarray = { 
	
}
)

~set_macro.(\k1, Pdef(~name+++\macro), \env0_timescale, ControlSpec(0.01,4,\exp, 0,1));
~set_macro.(\k2, Pdef(~name+++\macro), \midinote_stutter, ControlSpec(1,16,\lin,1,1));
~set_macro.(\k3, Pdef(~name+++\macro), \restprob, ControlSpec(0,0.5,\lin,0,0));

(
var a, b;
a = Pseq(([1, Pseq([10, 20, 30]), 2, 3, 4, 5]/5), 6).coin;	// return 6 items
b = a.asStream;
7.do({ b.next.postln; });
)
