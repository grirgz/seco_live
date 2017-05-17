
	(
	~gen1 = {
		var randcode = [
			0.1+rrand(0,0.4),
			rrand(1/2,2),
			rrand(1,32)/8,
			[1/4,1/8,1/2,1,2,3,1/4,1/8].choose,
			rrand(1,32)/8,
			log(2**rrand(1,14))/2
		];
		var x = 12.rand;

		Pbind(
			\kitIndex, Pseq([x],inf),
			\isRest, Pseq( [
				[ 1,1,1,1,  ],
				[ 1,1,0,0,  ],
				[ 0,0,1,1,  ],
				[ 1,0,0,0,  ],
				[ 0,0,1,0,  ],
				[ 1,0,0,1,  ],
				[ 0,0,1,0,  ],
				[ 0,1,0,0,  ],
			].choose ,inf).coin.not,
			\sustain, randcode[0],
			\speed, randcode[1],
			\dur, randcode[3],
			\lag, randcode[4]/~t,
			\amp, 0.1
		).trace(prefix:"yepmapoule")
	};
	~gen2 = {
		var randcode = [
			0.1+rrand(0,0.4),
			rrand(1/2,2),
			rrand(1,32)/8,
			[1/4,1/8,1/2,1,2,3,1/4,1/8].choose,
			rrand(1,32)/8,
			log(2**rrand(1,14))/2
		];
		var x = 12.rand;

		Pbind(
			\kitIndex, Pseq([x],inf),
			\isRest, Pseq( {[
				[ 1,1,1,1,  ],
				[ 1,1,0,0,  ],
				[ 0,0,1,1,  ],
				[ 1,0,0,0,  ],
				[ 0,0,1,0,  ],
				[ 1,0,0,1,  ],
				[ 0,0,1,0,  ],
				[ 0,1,0,0,  ],
			].choose }.dup(2).flatten ,inf).coin.not,
			\sustain, randcode[0],
			\speed, randcode[1],
			\dur, randcode[3],
			\lag, randcode[4]/~t,
			\amp, 0.1
		).trace(prefix:"yepmapoule")
	};

	~kiterize = { arg pat;
		PdrumStep(PatKitDef(\algokit).targets, pat, 1, key:\kitIndex)
	};
	)
