(
	~kitlib = ~kitlib ?? { () };
	~kitlib.rhiphop = (
		kick: { arg self;
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
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
				\dur, 1/8,
				\gain, 0.3,
			)
		},

		snare: { arg self;
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
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
				\dur, 1/8,
				\gain, 0.61,
			)
		},

		hat: { arg self;
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
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
				\dur, 1/8,
				\gain, 0.31,
			)

		},

		hatlong: { arg self;
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
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
				\dur, 1/8,
				\gain, 0.31,
			)
		},

	);
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Plazy({ 
			Pbind(
				\speed, rrand(1/2,2,inf),
			) <> 
			Pfindur([2,4,8].choose*4, ~kitlib.rhiphop.kick.value) 
		}).loop,
		Plazy({ Pfindur([2,4,8].choose*4, ~kitlib.rhiphop.kick.value) }).loop,
		Plazy({ Pfindur([2,4,8].choose*4, ~kitlib.rhiphop.snare.value) }).loop,
		Plazy({ 
			Pbind(
				\speed, rrand(1/2,2,inf),
				\isRest, 
				Plazy({
					Pseq( {[
						[ 0,0,0,0, 0,0,0,0, ],
						[ 0,0,0,0, 0,0,0,0, ],
						[ 0,0.5,0,0, 0,0,0,0, ],
						[ 0.5,0,0,0, 0,0,0,0, ],
						[ 0,0,0.5,0, 0,0,0,0, ],
						[ 0,0,0,0, 1,0,0,0.51, ],
					].choose }.dup(4).flatten)
				}).loop.coin.not,

			) <> 
			Pfindur([2,4,8].choose*4, ~kitlib.rhiphop.snare.value) 
		}).loop,
		Plazy({ Pfindur([2,4,8].choose*4, ~kitlib.rhiphop.hat.value) }).loop,
		Plazy({ Pfindur([2,4,8].choose*4, ~kitlib.rhiphop.hat.value) }).loop,
		Plazy({ 
			Pbind(
				\speed, rrand(1/2,2,inf),
			) <> 
			Pfindur([2,4,8].choose*4, ~kitlib.rhiphop.hat.value) 
		}).loop,
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Plazy({ 
			Pbind(
				\speed, rrand(1/2,2,inf),
			) <> 
			Pfindur([2,4,8].choose*4, ~kitlib.rhiphop.kick.value) 
		}).loop,
		Plazy({ Pfindur([2,4,8].choose*4, ~kitlib.rhiphop.kick.value) }).loop,
		Plazy({ Pfindur([2,4,8].choose*4, ~kitlib.rhiphop.kick.value) }).loop,
		Plazy({ Pfindur([2,4,8].choose*4, ~kitlib.rhiphop.kick.value) }).loop,
		Plazy({ Pfindur([2,4,8].choose*4, ~kitlib.rhiphop.snare.value) }).loop,
		Plazy({ 
			Pbind(
				\speed, rrand(1/2,2,inf),
				\isRest, 
				Plazy({
					Pseq( {[
						[ 0,0,0,0, 0,0,0,0, ],
						[ 0,0,0,0, 0,0,0,0, ],
						[ 0,0.5,0,0, 0,0,0,0, ],
						[ 0.5,0,0,0, 0,0,0,0, ],
						[ 0,0,0.5,0, 0,0,0,0, ],
						[ 0,0,0,0, 1,0,0,0.51, ],
					].choose }.dup(4).flatten)
				}).loop.coin.not,

			) <> 
			Pfindur([2,4,8].choose*4, ~kitlib.rhiphop.snare.value) 
		}).loop,
		Plazy({ 
			Pbind(
				\speed, rrand(1/2,2,inf),
				\isRest, 
				Plazy({
					Pseq( {[
						[ 0,0,0,0, 0,0,0,0, ],
						[ 0,0,0,0, 0,0,0,0, ],
						[ 0,0.5,0,0, 0,0,0,0, ],
						[ 0.5,0,0,0, 0,0,0,0, ],
						[ 0,0,0.5,0, 0,0,0,0, ],
						[ 0,0,0,0, 1,0,0,0.51, ],
					].choose }.dup(4).flatten)
				}).loop.coin.not,

			) <> 
			Pfindur([2,4,8].choose*4, ~kitlib.rhiphop.snare.value) 
		}).loop,
		Plazy({ 
			Pbind(
				\speed, rrand(1/2,2,inf),
				\dur, 1/16,
				\isRest, 
				Plazy({
					Pseq([
						Pseq([0],8*12),
						Pseq( {[
							[ 1,0,1,0, 1,0,1,0, ]*0.5+0.3,
							[ 1,0,1,0, 1,0,1,0, ]*0.2+0.3,
							[ 0,0,0,0, 0,0,0,0, ]+0.3,
							[ 0,0,0,0, 1,0,0,0.51, ],
						].choose }.dup(4).flatten),
					],1);
				}).loop.coin.not,

			) <> 
			Pfindur([2,4,8].choose*4, ~kitlib.rhiphop.snare.value) 
		}).loop,
		Plazy({ Pfindur([2,4,8].choose*4, ~kitlib.rhiphop.hat.value) }).loop,
		Plazy({ Pfindur([2,4,8].choose*4, ~kitlib.rhiphop.hat.value) }).loop,
		Plazy({ Pfindur([2,4,8].choose*4, ~kitlib.rhiphop.hat.value) }).loop,
		Plazy({ 
			Pbind(
				\speed, rrand(1/2,2,inf),
			) <> 
			Pfindur([2,4,8].choose*4, ~kitlib.rhiphop.hat.value) 
		}).loop,
		Plazy({ 
			Pbind(
				\speed, rrand(1/2,2,inf),
			) <> 
			Pfindur([2,4,8].choose*4, ~kitlib.rhiphop.hat.value) 
		}).loop,
	])
)).play;
);
