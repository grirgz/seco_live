(
Pdef(~name +++ \pre, Pbind(
	\lfo3, Pseq([
		0.5,0.05,
		0.1,0.05,
		0.1,0.1,
		0.4,0.1,
	],inf).stutter(2) * Pseq([1,0.1],inf),
	\env0, Pfunc({ arg ev;
		[ Env.new([0.5, 1, 0.5, 0], [0.005, ev[\lfo3], 0.4], [-4, -2, -4]) ];
	}),
	\lfo2, Pseq([
		Prout({ arg ev;
			var arr = [
				30,40,40,50,
				30,45,40,50,
			];
			var arr2;
			100.do {
				arr = arr.swap(arr.size.rand, arr.size.rand);
				//arr.debug("arr");
				arr2 = arr.copy.swap(7,6);
				Pseq(arr,1).embedInStream;
				Pseq(arr2,1).embedInStream;
			};
		}).loop,
	],inf).stutter(2),
	\env1, Pseq([
		Pfunc({ arg ev;
			[ Env.new([71, ev[\lfo2], 29], [0.015, 0.29], [-4, -5]) ];
		}),
	],1),
	\hpfreq, Pseq([
		20,
	],inf).stutter(2),
	\hpfreq, ~pswapping.([
		100,50,30,500,
		35,56,47,58,
	], Pwhite(0,7), Pwhite(0,7), 2,3, 2).stutter(2).loop,
	\pan, Pseq([
		Pser([0],17),
		Pwhite(-1.0,1.0,16-1)
	],inf).stutter(1) * 0.5,
	\spread, 0.1,
	\isRest, Pseq([
		1,0,1,0,
		1,0,1,0,
	],inf).coin.not,
));
)

// END

[0.6]

(
~pswapping = { arg array, lo1, hi1, lo2, hi2, rep=inf;
	Prout({ arg ev;
		var arr2;
		var arr = array.copy;
		lo1 = lo1.asStream;
		hi1 = hi1.asStream;
		lo2 = lo2.asStream;
		hi2 = hi2.asStream;
		rep.do { arg x;
			[x,arr].debug("arr");
			arr = arr.swap(lo1.next, hi1.next);
			arr2 = arr.copy.swap(lo2.next,hi2.next);
			Pseq(arr,1).embedInStream;
			Pseq(arr2,1).embedInStream;
			//nil.embedInStream;
		};
		//nil.embedInStream;
	});
};
)
