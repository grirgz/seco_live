(
	~algo_patlist1 = {[
		8.collect({
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

		}),
		2.collect {
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
		},
		4.collect({

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
				\gain, Pkeyd(\gain,1) * 0.5,
			);
		})
	].flatten.collect({ arg pat, idx;
		Pbind(\trackIndex, idx) <> pat 
	})};

	~algo_patlist3 = {[
		3.collect({
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

		}),
		2.collect {
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
		},
		4.collect({

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
				\gain, Pkeyd(\gain,1) * 0.5,
			);
		})
	].flatten.collect({ arg pat, idx;
		Pbind(\trackIndex, idx) <> pat 
	})};

	~algo_patlist2 = {[
		2.collect({
			Pbind(
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
			)

		}),
		2.collect({
			Pbind(
				\kitIndex, Pseq([rrand(0,3)+4],inf),
				\isRest, 
				Plazy({
					Pseq( {[
						[ 0,0,0,0, 1,0,0,0, ],
						[ 0,0,0,0, 1,0,0,0, ],
						[ 0,0.5,0,0, 1,0,0,0, ],
						[ 0,0,0,0, 1,0,0,0.51, ],
					].choose }.dup(4).flatten)
				}).loop.coin.not,
				\sustain, rrand(0.051,0.4),
				\speed, rrand(1/2,2),
				\dur, 1/8,
				\amp, 0.1
			)
		}),
		2.collect({
			Pbind(
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
				\sustain, rrand(0.051,0.14),
				\speed, rrand(1/2,2),
				\dur, 1/8,
				\amp, 0.1,
				\gain, Pkeyd(\gain,1) * 0.5,
			)
		}),
		1.collect({
			Pbind(
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
			)
		}),
	].flatten.collect({ arg pat, idx;
		Pbind(\trackIndex, idx) <> pat 
	})};
)
