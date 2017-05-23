
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


	~restpat_rand = { arg pp;
		Pbind(
			\isRest, ( 
				Pstep(
					Plazy({
						Pseq({[
							[ 1,1,1,1, 0,0,0,0, ],
							[ 1,1,1,1, 1,1,1,1, ],
							[ 0,0,0,0, 1,1,1,1, ],
							[ 1,0,1,0, 1,0,1,0, ],
							[ 1,0,0,0, 1,0,0,0, ],
							[ 1,1,0,0, 1,1,0,0, ],
							[ 0,0,1,1, 0,0,1,1, ],
						].choose }.dup(2).flatten,2);

					}).loop, 2
				) * Pkey(\isRest).collect(_.asInteger) 
			).coin.not,
		) <> pp
	};
	~restpat_intro = { arg pp, ppidx;
		Pbind(
			\isRest, ( 
				Pstep(
					Plazy({
						Pseq({[
							8.collect({ arg x;
								( 0!x ) ++ ( 1!(8-x) )
							}).scramble
						].flatten.wrapAt(ppidx) }.dup(1).flatten,1);
					}).loop, 4
				) * Pkey(\isRest).collect(_.asInteger) 
			).coin.not,
		) <> pp
	};
	~restpat_outro = { arg pp, ppidx;
		Pbind(
			\isRest, ( 
				Pstep(
					Plazy({
						Pseq({[
							8.collect({ arg x;
								( 1!x ) ++ ( 0!(8-x) )
							}).scramble
						].flatten.wrapAt(ppidx) }.dup(1).flatten,1);
					}).loop, 4
				) * Pkey(\isRest).collect(_.asInteger) 
			).coin.not,
		) <> pp
	};
	~restpat_only_hat = { arg pp, ppidx;
		Pbind(
			\isRest, Plazy({ arg ev;
				ev[\kitIndex].inclusivelyBetween(0+8,3+8)
			}).loop.not,
		) <> pp
	};
	~restpat_only_snare = { arg pp, ppidx;
		Pbind(
			\isRest, Plazy({ arg ev;
				ev[\kitIndex].inclusivelyBetween(0+4,3+4)
			}).loop.not,
		) <> pp
	};
	~restpat_only_kick = { arg pp, ppidx;
		Pbind(
			\isRest, Plazy({ arg ev;
				ev[\kitIndex].inclusivelyBetween(0,3)
			}).loop.not,
		) <> pp
	};
	~restseq = { arg pat, seq;
		Pbind(
			\isRest, ( seq * Pkey(\isRest).not.collect(_.asInteger) ).coin.not
		) <> pat
	};
	~reststep = { arg pat, seq, seqt=1;
		~restseq.(pat, Pstep(seq, seqt));
	};
	~is_kick = { arg pp;
		var ev = pp.asStream.next(Event.default);
		ev[\kitIndex].inclusivelyBetween(0,3);
	};
	~is_snare = { arg pp;
		var ev = pp.asStream.next(Event.default);
		ev[\kitIndex].inclusivelyBetween(0+4,3+4);
	};
	~is_hat = { arg pp;
		var ev = pp.asStream.next(Event.default);
		ev[\kitIndex].inclusivelyBetween(0+8,3+8);
	};

	)
