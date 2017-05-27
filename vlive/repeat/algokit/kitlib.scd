
(
	~kitlib = ~kitlib ? ();
	~kitlib.kit = { arg self, pat;
		~kiterize.(pat);
	};
	~kitlib.randscore = { arg self, scorekey;
		var scorekit = [\hiphop, \dnb, \tek, \trap].choose;
		~kitlib.postln;
		~kitlib[scorekit][scorekey].();
	};
	~kitlib.restToLegato = { arg self, ar, legato, repeat=inf;
		Plazy({
			var count = 1;
			var arval = ar.value.debug("arval");
			var leg = arval.reverse.collect({ arg val;
				if(val == 0) {
					count = count+1;
				} {
					val = count;
					count = 1;
				};
				val;
			}).reverse.debug("leg");
			Ptuple([Pseq(arval,repeat).coin.not, Pseq(leg, repeat)*legato]);
		});
	};
	~kitlib.hiphop = (
		kick: { arg self;
			~kitlib.kit(Pbind(
				\kitIndex, Pseq([rrand(0,3)],inf),
				\isRest, 
				Plazy({
					Pseq( {[
						[ 1,0,1,0, 0,0,0,0, ],
						[ 1,1,0,0, 0,0,0,0, ],
						[ 1,0,0,1, 0,0,0,0, ],
						[ 1,0,0,0, 0,0,0,0, ],
					].choose }.dup(4).flatten)
				}).loop.coin.not,
				\sustain, rrand(0.051,0.4),
				\speed, rrand(1/2,2),
				\dur, 1/8,
				\amp, 0.1
			))
		},

		snare: { arg self;
			~kitlib.kit(Pbind(
				\kitIndex, Pseq([rrand(0,3)+4],inf),
				\isRest, 
				Plazy({
					Pseq( {[
						[ 0,0,0,0, 1,0,0,0, ],
						[ 0,0,0,0, 1,0,0,0, ],
						[ 0,0.5,0,0, 1,0,0,0, ],
						[ 0.5,0,0,0, 1,0,0,0, ],
						[ 0,0,0.5,0, 1,0,0,0, ],
						[ 0,0,0,0, 1,0,0,0.51, ],
					].choose }.dup(4).flatten)
				}).loop.coin.not,
				\sustain, exprand(0.091,0.4),
				\speed, rrand(1/2,2),
				\dur, 1/8,
				\amp, 0.1
			))
		},

		hat: { arg self;
			~kitlib.kit(Pbind(
				\kitIndex, Pseq([rrand(0,3)+8],inf),
				\isRest, 
				Plazy({
					Pseq( {[
						[ 0,0,1,0, 1,0,1,0, ],
						[ 1,1,1,1, 0,0,0,0, ],
						[ 1,0,0,0, 1,0,0,0, ],
						[ 0,0,1,1, 0,0,1,1, ],
						[ 1,1,1,0, 0,0,1,0, ],
					].choose }.dup(4).flatten)
				}).loop.coin.not,
				\sustain, [
					rrand(0.051,0.14),
					exprand(0.041,0.24),
				].choose,
				\speed, rrand(1/2,2),
				\dur, 1/8,
				\amp, 0.1,
				\gain, Pkeyd(\gain,1) * 0.5,
			))

		},

		hatlong: { arg self;
			~kitlib.kit(Pbind(
				\kitIndex, Pseq([rrand(0,3)+8],inf),
				\isRest, 
				Plazy({
					Pseq( {[
						[ 0,0,0,0, 0,0,1,0, ],
						[ 0,0,0,0, 0,0,0,0, ],
						[ 0,0,0,0, 0,0,0,0, ],
						[ 0,0,1,0, 0,0,0,0, ],
					].choose }.dup(4).flatten)
				}).loop.coin.not,
				\sustain, rrand(0.051,0.54),
				\speed, rrand(1/2,2),
				\dur, 1/8,
				\amp, 0.1,
				\gain, Pkeyd(\gain,1) * 0.5,
			))
		},

	);

	~kitlib.tek = (
		kick: { arg self;

			~kitlib.kit(

				Pbind(
					\kitIndex, Pseq([rrand(0,3)],inf),
					\isRest, 
					Plazy({
						Pseq([
							Pseq( {[
								[ 1,0,1,0, 1,0,1,0, ],
								[ 1,0,1,0, 1,0,1,0, ],
								[ 1,0,1,0, 1,0,1,0, ],
								[ 1,1,1,0, 1,0,1,0, ],
								[ 1,0,1,1, 1,0,1,0, ],
								[ 1,0,1,0, 1,1,1,0, ],
								[ 1,0,1,0, 1,0,1,1, ],
							].choose }.dup(3).flatten ,1),
							Pseq([
								1,0,0,0, 1,0,0,0,

								Pseq( {[
									[ 1,0,1,0, 1,0,1,1, ],
									[ 1,0,1,1, 1,0,0,0, ],
									[ 1,0,0,0, 1,0,0,0, ],
									[ 1,0,1,0, 1,0,0,0, ],
									[ 1,1,0,0, 1,0,0,0, ],
									[ 0,0,0,0, 0,0,0,0, ],
								].choose }.dup(1).flatten ,1)
							])
						],1).coin.not;
					}).loop,
					\sustain, rrand(0.051,0.4),
					\speed, rrand(1/2,2),
					\dur, Pseq([Pn(1/8,8*3), Pn(1/16,16)],inf),
					\amp, 0.1
				)
			)

		},

		snare: { arg self;

			~kitlib.kit(
				Pbind(
					\kitIndex, Pseq([rrand(0,3)+4],inf),
					\isRest, Pseq( {[
						[ 1,0,0,0, 1,0,0,0, ],
						[ 0,0,0,0, 1,1,0,0, ],
						[ 0,0,0,0, 1,0,0,0, ],
						[ 0,0,0,0, 1,0,0,0, ],
						[ 0,0,0,0, 1,0,1,0, ],
						[ 0,1,0,0, 1,0,0,0, ],
						[ 0,0,0,0, 1,0,0,1, ],
					].choose }.dup(8).flatten ,inf).coin.not,
					\sustain, rrand(0.051,0.2),
					\speed, rrand(1/2,2),
					\dur, 1/8,
					\amp, 0.1
				);
			)
		},

		hat: { arg self;
			~kitlib.kit(
				Pbind(
					\kitIndex, Pseq([rrand(0,3)+8],inf),
					\isRest, Pseq( {[
						[ 0,1,0,0,  0,1,1,0 ],
						[ 0,0,1,0,  0,0,1,0 ],
						[ 1,0,1,0,  1,0,1,0 ],
						[ 1,0,1,0,  1,0,1,0 ],
						[ 1,0,0,0,  1,0,0,0 ],
						[ 1,0,0,1,  1,0,1,0 ],
						[ 1,1,1,0,  1,0,1,0 ],
						[ 0,1,1,0,  1,0,1,1 ],
					].choose }.dup(16).flatten ,inf).coin.not,
					\sustain, rrand(0.051,0.1),
					\pos, rrand(0.04,0.2),
					\speed, rrand(1/2,2),
					//\lag, [0,1/16,1/5,0,0].choose / ~t,
					\dur, 1/8,
					\dur, [1/8,1/16,1/4,1/8].choose,
					\amp, 0.1,
					\gain, Pkeyd(\gain,1) * 0.6,
				);
			)
		},

	);

	~kitlib.klak = (
		kick: { arg self;
			~kitlib.kit(Pbind(
				\kitIndex, Pseq([rrand(0,3)],inf),
				\isRest, 
				Plazy({
					Pseq( {[
						[ 1,0,0,0, 1,0,0,0, ],
						[ 1,0,1,0, 1,0,1,0, ],
						[ 1,1,0,0, 1,1,0,1, ],
					].choose }.dup(1).flatten,4)
				}).loop.coin.not,
				\sustain, rrand(0.051,0.04),
				\speed, rrand(1/2,2),
				\dur, 1/16,
				\amp, 0.1
			))
			
		},
		kicknosync: { arg self;
			~kitlib.kit(Pbind(
				\kitIndex, Pseq([rrand(0,3)],inf),
				\isRest, 
				Plazy({
					Pseq( {[
						[ 1,0,0,0, 1,0,0,0, ],
						[ 1,0,1,0, 1,0,1,0, ],
						[ 1,1,0,0, 1,1,0,1, ],
					].choose }.dup(1).flatten,4)
				}).loop.coin.not,
				\sustain, rrand(0.051,0.04),
				\speed, rrand(1/2,2),
				\dur, 1/16 * rrand(1/2,8),
				\amp, 0.1
			))
			
		},
		kicklongnosync: { arg self;
			~kitlib.kit(Pbind(
				\kitIndex, Pseq([rrand(0,3)],inf),
				\isRest, 
				Plazy({
					Pseq( {[
						[ 1,0,0,0, 1,0,0,0, ],
						[ 1,0,1,0, 1,0,1,0, ],
						[ 1,1,0,0, 1,1,0,1, ],
					].choose }.dup(1).flatten,4)
				}).loop.coin.not,
				\sustain, rrand(0.051,0.4),
				\speed, rrand(1/2,2),
				\dur, 1/16 * rrand(1/2,8),
				\amp, 0.1
			))
			
		},

	);

	~kitlib.heavy = (
		kick: { arg self;
			~kitlib.kit(Pbind(
				\kitIndex, Pseq([0+12],inf),
				[\isRest, \legato], Plazy({
					var ar = {[
						[ 1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,1,0, ],
						[ 1,0,0,1, 0,0,1,0, 0,0,0,0, 0,0,1,0, ],
						[ 1,0,0,0, 0,0,1,0, 0,1,0,0, 0,0,0,0, ],
						[ 1,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,1, ],
						[ 1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, ],
						//[ 1,1,0,0, 0,0,0,0, ],
						//[ 1,0,0,1, 0,0,0,0, ],
						//[ 1,0,0,0, 0,0,0,0, ],
					].choose }.dup(4).flatten;
					var count = 1;
					var leg = ar.reverse.collect({ arg val;
						if(val == 0) {
							count = count+1;
						} {
							val = count;
							count = 1;
						};
						val;
					}).reverse.debug("leg");
					Ptuple([Pseq(ar,inf).coin.not, Pseq(leg,inf)-rrand(0.01,0.4)]);
				}).loop,
				//\sustain, exprand(0.251,1.1),
				\speed, rrand(1/2,2),
				\dur, 1/8,
				\amp, 0.1
			))
		},

		snare: { arg self;
			~kitlib.kit(Pbind(
				\kitIndex, Pseq([1+12],inf),
				[\isRest, \legato], ~kitlib.restToLegato({
					{[
						[ 0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0, ],
						[ 0,0.41,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0, ],
						[ 0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0.4,0,0, ],
						[ 0,0,0,0, 0,0.4,0,0, 1,0,0,0, 0,0,0,0, ],
					].choose }.dup(4).flatten
				}, 0.8).loop,
				\sustain, exprand(0.051,0.7),
				\speed, rrand(1/2,2),
				\dur, 1/8,
				\amp, 0.1
			))
		},

		hat: { arg self;
			~kitlib.kit(Pbind(
				\kitIndex, Pseq([rrand(2,3)+12],inf),
				[\isRest, \legato], Plazy({
					var ar = {[
						[ 1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0, ],
						[ 0,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,0,0, ],
						[ 0,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0, ],
						[ 0,0,0,0, 1,0,0,0, 0,0,1,0, 1,0,1,1, ],
						[ 0,0,0,0, 0,0,0,0, 0,1,0,0, 1,0,0,1, ],
						[ 0,0,0,0, 1,0,0,1, 0,0,0,0, 0,1,0,0, ],
					].choose }.dup(4).flatten;
					var count = 1;
					var leg = ar.reverse.collect({ arg val;
						if(val == 0) {
							count = count+1;
						} {
							val = count;
							count = 1;
						};
						val;
					}).reverse.debug("leg");
					Ptuple([Pseq(ar).coin.not, Pseq(leg)-rrand(0.01,0.4)]);
				}),
				//\sustain, rrand(0.051,1.14),
				\speed, rrand(1/2,2),
				\dur, 1/8,
				\amp, 0.1,
				\gain, Pkeyd(\gain,1) * 0.5,
			))

		},

		voice: { arg self;
			~kitlib.kit(Pbind(
				\kitIndex, Pseq([rrand(0,5)+16],inf),
				[\isRest, \legato], ~kitlib.restToLegato({
					{[
						[ 1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, ],
						[ 0,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,0,0, ],
						[ 0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0, ],
						[ 0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0, ],
						[ 1,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, ],
						[ 1,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0, ],
						[ 1,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,0,0, ],
						[ 1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0, ],
					].choose }.dup(4).flatten
				}, rrand(0.1,0.9)).loop,
				\legato, [
					Pkey(\legato),
					rrand(0.5,1),
				].choose,
				\pos, rrand(0,4.8),
				\speed, rrand(1/8,1),
				\dur, 1/8,
				\amp, 0.1
			))
			
		},
		shortvoice: { arg self;
			~kitlib.kit(Pbind(
				\kitIndex, Pseq([rrand(0,5)+16],inf),
				[\isRest, \legato], ~kitlib.restToLegato({
					{[
						[ 1,0,0,0, 0,0,0,0,  ],
						[ 0,0,1,0, 1,1,0,0,  ],
						[ 1,0,0,0, 0,1,0,0,  ],
						[ 0,0,0,0, 1,0,0,0,  ],
						[ 0,0,1,0, 0,0,0,0,  ],
						[ 0,0,0,0, 0,0,0,0,  ],
						[ 0,0,0,0, 1,0,1,0,  ],
						[ 0,0,1,0, 0,0,0,0,  ],
						[ 0,0,1,0, 0,0,0,1,  ],
						[ 0,0,1,0, 0,0,1,0,  ],
						[ 0,0,0,0, 0,0,1,0,  ],
						[ 0,0,0,0, 1,0,0,0,  ],
						[ 0,0,0,0, 0,0,0,0,  ],
					].choose }.dup(4).flatten
				}, rrand(0.1,0.9)).loop,
				\sustain, exprand(0.051,0.51),
				\pos, rrand(0,4.8),
				\speed, rrand(1/8,1),
				\dur, 1/8,
				\amp, 0.1
			))
			
		},
	);

	~kitlib.dnb = (
		kick: { arg self;

			~kitlib.kit(

				Pbind(
					\kitIndex, Pseq([rrand(0,3)],inf),
					\isRest, 
					Plazy({
						Pseq([
							Pseq( {[
								[ 1,0,1,0, 0,0,0,0, ],
								[ 1,0,0,0, 0,0,1,0, ],
								[ 1,0,0,0, 0,0,0,1, ],
								[ 0,0,1,0, 0,1,0,0, ],
								[ 0,0,1,0, 0,0,0,0, ],
							].choose }.dup(3).flatten ,1),
							Pseq([
								1,0,0,0, 1,0,0,0,

								Pseq( {[
									[ 1,0,1,1, 0,0,0,0, ],
								].choose }.dup(1).flatten ,1)
							])
						],1).coin.not;
					}).loop,
					\sustain, rrand(0.051,0.2),
					\speed, rrand(1/2,2),
					\dur, 1/16,
					\amp, 0.1
				)
			)

		},

		snare: { arg self;

			~kitlib.kit(
				Pbind(
					\kitIndex, Pseq([rrand(0,3)+4],inf),
					\isRest, Pseq( {[
						[ 0,0,0,0, 1,0,0,0, ],
					].choose }.dup(8).flatten ,inf).coin.not,
					\sustain, rrand(0.051,0.2),
					\speed, rrand(1/2,2),
					\dur, 1/16,
					\amp, 0.1
				);
			)
		},

		hat: { arg self;
			~kitlib.kit(
				Pbind(
					\kitIndex, Pseq([rrand(0,3)+8],inf),
					\isRest, Pseq( {[
						[ 0,0,1,0,  0,0,1,0 ],
						[ 1,0,1,0,  1,0,1,0 ],
						[ 1,1,1,1,  1,1,1,1 ],
					].choose }.dup(16).flatten ,inf).coin.not,
					\sustain, rrand(0.051,0.1),
					\pos, rrand(0.04,0.2),
					\speed, rrand(1/2,2),
					//\lag, [0,1/16,1/5,0,0].choose / ~t,
					\dur, 1/8,
					\dur, [1/8,1/16,1/4,1/8].choose,
					\amp, 0.1,
					\gain, Pkeyd(\gain,1) * 0.6,
				);
			)
		},

	);

	~kitlib.trap = (
		kickbass: { arg self;
			Pbind(
				\instrument, \default,
				\freq, 100,
				\legato, 0.9,
				\dur, Prout({
					x = [1/4,1/8,1/2].choose;
					( 2 - x ).yield;
					( x ).yield;
				}).loop,
				\amp, 0.3
			);
		},
		kick: { arg self;
			~kitlib.kit(Pbind(
				\kitIndex, Pseq([rrand(0,3)],inf),
				\isRest, 
				Plazy({
					Pseq( {[
						[ 1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,1,0, ],
						[ 1,0,0,1, 0,0,1,0, 0,0,0,0, 0,0,1,0, ],
						[ 1,0,0,0, 0,0,1,0, 0,1,0,0, 0,0,0,0, ],
						[ 1,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,1, ],
						//[ 1,1,0,0, 0,0,0,0, ],
						//[ 1,0,0,1, 0,0,0,0, ],
						//[ 1,0,0,0, 0,0,0,0, ],
					].choose }.dup(4).flatten)
				}).loop.coin.not,
				\sustain, exprand(0.251,1.1),
				\speed, rrand(1/2,1),
				\dur, 1/8,
				\amp, 0.1
			))
		},

		snare: { arg self;
			~kitlib.kit(Pbind(
				\kitIndex, Pseq([rrand(0,3)+4],inf),
				\isRest, 
				Plazy({
					Pseq( {[
						[ 0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0, ],
						[ 0,0.41,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0, ],
						[ 0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0.4,0,0, ],
						[ 0,0,0,0, 0,0.4,0,0, 1,0,0,0, 0,0,0,0, ],
					].choose }.dup(4).flatten)
				}).loop.coin.not,
				\sustain, rrand(0.051,0.4),
				\speed, rrand(1/2,2),
				\dur, 1/8,
				\amp, 0.1
			))
		},

		hat: { arg self;
			~kitlib.kit(Pbind(
				\kitIndex, Pseq([rrand(0,3)+8],inf),
				\isRest, 
				Plazy({
					Pseq( {[
						[ 1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0, ],
						[ 0,0,0,0, 1,0,0,0, 0,0,1,0, 1,0,1,1, ],
						[ 0,0,0,0, 0,0,0,0, 0,1,0,0, 1,0,0,1, ],
						[ 0,0,0,0, 1,0,0,1, 0,0,0,0, 0,1,0,0, ],
					].choose }.dup(4).flatten)
				}).loop.coin.not,
				\sustain, rrand(0.051,0.14),
				\speed, rrand(1/2,2),
				\dur, 1/8,
				\amp, 0.1,
				\gain, Pkeyd(\gain,1) * 0.5,
			))

		},

		hatlong: { arg self;
			~kitlib.kit(Pbind(
				\kitIndex, Pseq([rrand(0,3)+8],inf),
				\isRest, 
				Plazy({
					Pseq( {[
						[ 0,0,0,0, 0,0,1,0, ],
						[ 0,0,0,0, 0,0,0,0, ],
						[ 0,0,0,0, 0,0,0,0, ],
						[ 0,0,1,0, 0,0,0,0, ],
					].choose }.dup(4).flatten)
				}).loop.coin.not,
				\sustain, rrand(0.051,0.54),
				\speed, rrand(1/2,2),
				\dur, 1/4,
				\amp, 0.1,
				\gain, Pkeyd(\gain,1) * 0.5,
			))
		},

	);
)
