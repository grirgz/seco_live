Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\dur, 1/8,
	\isRest, Veco(~namex).isrest(16),
	\fmix, 0.01,
	\fratio3, Pseq([1,2,4,9, 12,1,15,1],inf).stutter(8),
	\timeScale, 1/2,
	\pan, Pseq([
		Pwrand([
			-1,0,1,

		], [0.1,1,0.1])/2 + 0.5
	],inf),
	\elpf, 9700,
	\ehpf, 500,
	\amp, Pkey(\amp) * Pseq([
		1

	],inf).stutter(4),
	\isRest, Pseq([
		1,0.5,0.5,1, 0,0.5,1,0,
		1,0,1,0, 0.5,0,1,0.5,
		1,1,1,1, 1,1,1,1,
		1,0,0,1, 0,0,1,0,
	],inf).coin.not,
	\isRest, Pseq([
		Prout({ arg ev;
			var s1, s2, s3, s4;
			var col = [
				[1,1,1,1, 1,1,1,1],
				[1,0,1,0, 1,0,1,0], 
				[0,1,1,1, 0,0,0,0], 
				[0,0,1,1, 0,0,0,0], 
			];
			var empty = [0,0,0,0, 0,0,0,0];
			var e4 = [0,0,0,0];
			var sel;

			sel = 4.collect({ 
				var res;
				res = col.choose;	
				res = 0.3.coin.if({ res }, { e4 ++ res.keep(4) });
				res;
			});

			s1 = sel[0];
			s2 = sel[1];
			s3 = sel[2];
			s4 = sel[3];
			 
			col.debug("col");
			sel.debug("sel");

			Pseq([
				Pseq(s1), 
				Pseq(empty), 

				Pseq(s2), 
				Pseq(empty), 

				Pseq(s1), 
				Pseq(s3), 

				Pseq(s1), 
				Pseq(s4), 
			]).embedInStream;

			
		}).loop,
	],inf).coin.not,
	//\isRest, Veco(~name).isrest,
));
