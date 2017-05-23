
(
	~patlist = {[
		Pbind(
			\kitIndex, Pseq([rrand(0,3)],inf),
			\isRest, Pseq( {[
				[ 1,0,0,0, 0,0,0,0, ],
				[ 1,1,0,0, 0,0,0,0, ],
				[ 1,0,1,0, 0,0,0,0, ],
				[ 1,0,1,0.5, 0,0,0,0, ],
				[ 1,0,0.21,0.5, 0,0,0,0, ],
				[ 1,0,0,0, 0,0,1,0, ],
				[ 1,0,1,0, 0,0,0,1, ],
				[ 1,0,0,1, 0,0,0,0, ],
				[ 1,0,0,0, 1,0,0,0, ],
				[ 1,0,0,1, 0,0,1,0, ],
				[ 1,0,1,0, 0,1,0,0, ],
				[ 1,1,1,1, 0,0,0,0, ],
				[ 1,0,1,1, 0,0,0,0, ],
			].choose }.dup(4).flatten ,inf).coin.not,
			\sustain, rrand(0.051,0.4),
			\speed, rrand(1/2,2),
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\kitIndex, Pseq([rrand(0,3)+8],inf),
			\isRest, Pseq( {[
				[ 1,0,1,0,  ],
				[ 1,0,1,0,  ],
				[ 1,0,0,0,  ],
				[ 0,0,1,0,  ],
				[ 1,1,1,1,  ],
				[ 1,0.5,1,0,  ],
				[ 1,0.2,1,0.2,  ],
				[ 1,0.2,0.81,0.2,  ],
			].choose }.dup(4).flatten ,inf).coin.not,
			\sustain, rrand(0.051,0.1),
			\speed, rrand(1/2,2),
			\dur, 1/8,
			\amp, 0.1,
			\gain, Pkeyd(\gain,1) * Pseq({
				[
					1,0,0,0,
					1,0,1,0,
					0.5,0.7,1,0.7,
					0.5,0.7,0.3,0.7,
					1.0,0.7,0.3,0.7,
					0.5,0.7,1,0.7,
					0.2,0.7,1,0.7,
				].clump(4).choose
			}.dup(4).flatten ,inf),
		),
		Pbind(
			\kitIndex, Pseq([rrand(0,3)+4],inf),
			\isRest, Pseq( {[
				[ 0,0,0,0, 1,0,0,0,  ],
				[ 0,0,0,0, 1,0,0,0,  ],
				[ 0,0,0,0, 1,0,0,0.5,  ],
				[ 0,0.5,0,0, 1,0,0,0,  ],
				[ 0,0.5,0,0, 0,0,0.5,0,  ],
				[ 0,0,0,1, 0,0,0,1,  ],
				[ 0,0,1,0, 1,0,0,1,  ],
			].choose }.dup(4).flatten ,inf).coin.not,
			\sustain, rrand(0.051,0.2),
			\speed, rrand(1/2,2),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\kitIndex, Pseq([rrand(0,3)+4],inf),
			\isRest, Pseq( {[
				[ 
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],
				[ 
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,1,0,0,
				],
				[ 
					0,0,1,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],
				[ 
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
				],
				[ 
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,1,
				],
				[ 
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 1,0,0,0,
				],
			].choose }.dup(4).flatten ,inf).coin.not,
			\sustain, rrand(0.051,0.4),
			\speed, rrand(1/2,2),
			\dur, 1/8,
			\amp, 0.4
		),
		Pbind(
			\kitIndex, Pseq([rrand(0,3)+4],inf),
			\isRest, Pseq( {[
				[ 
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],
				[ 
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,1,0,0,
				],
				[ 
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],
				[ 
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],
				[ 
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],
			].choose }.dup(4).flatten ,inf).coin.not,
			\sustain, rrand(0.051,0.6),
			\speed, rrand(1/2,2),
			\dur, 1/8,
			\amp, 0.4
		),
		Pbind(
			\kitIndex, Pseq([rrand(0,11)],inf),
			\isRest, Pseq( {[
				[ 
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					[
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0.5,0,0.5,
						0,0,1,1, 1,1,1,1,
						0,0,0,0, 1,1,1,1,
						0,0,0,0, 0,0,1,1,
						0,0,0.4,0, 1,1,1,1,
						0,0,0,0, 1,0,1,0,
						0,0,0,0, 0,0,1,0,
						0,0.7,0,0, 0,0,1,0,
						1,0,1,0, 1,0,1,0,
					].clump(8).choose,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					[
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						0,0,0,0, 1,1,1,1,
						0,0,0,0, 1,0,1,0,
						0,0,0,0, 0,0,1,0,
						0,0.7,0,0, 0,0,1,0,
					].clump(8).choose,
					[
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,0,0,
						1,0,1,0, 1,0,1,0,
						1,1,1,0, 1,0,1,1,
						0,0,0,0, 1,1,1,1,
					].clump(8).choose,
				].flatten,
			].choose }.dup(4).flatten ,inf).coin.not,
			\sustain, rrand(0.051,0.2),
			\speed, rrand(1/2,2),
			\dur, 1/8,
			\amp, 0.4
		),


		Plazy({

			Pseq([
				Pbind(
					\instrument, \default,
					\isRest, Pser([
						0,
					],128/8/2).coin.not,
					\freq, 200,
					\dur, 1,
					\amp, 0.1
				),

				Pfindur(128/8/2,Pbind(
					\kitIndex, Pseq([rrand(0,3)+8],inf),
					\isRest, 
					Pseq([
						Pseq( {[
							[ 1,0,1,0,  ],
							[ 1,0,1,0,  ],
							[ 1,0,0,0,  ],
							[ 0,0,1,0,  ],
							[ 1,1,1,1,  ],
							[ 1,0.5,1,0,  ],
							[ 1,0.2,1,0.2,  ],
							[ 1,0.2,0.81,0.2,  ],
						].choose }.dup(4).flatten ,8)
					],inf).coin.not,
					\sustain, rrand(0.051,0.1),
					\speed, rrand(1/2,2),
					\dur, [1/8,1/4,1/16].choose,
					\amp, 0.1,
					\gain, Pkeyd(\gain,1) * Pseq( { [
						1,0,0,0,
						1,0,1,0,
						0.5,0.7,1,0.7,
						0.5,0.7,0.3,0.7,
						1.0,0.7,0.3,0.7,
						0.5,0.7,1,0.7,
						0.2,0.7,1,0.7,
					].clump(4).choose }.dup(4).flatten ,inf),
				))
			])
		}).loop,
	]};

	Pdef(\algo2_p3, 
		Plazy({
			Pfindur(128/8, Ppar(
				~patlist.value.collect({ arg pat, idx; 
					Pbind(\trackIndex, idx) <> pat 
				})));
		}).loop
	);
);


(

	Pdef(\algo2_p4, 
		Plazy({
			var patlist;
			var patlist2, patlist3;
			var pat1, pat2, pat3;
			patlist = {[
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
						\amp, 0.1
					);
				})
			].flatten};


			patlist2 = {[
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
									[ 1,0,1,0, 1,1,1,0, ],
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
				Pbind(
					\kitIndex, Pseq([rrand(0,3)+4],inf),
					\isRest, Pseq( {[
						[ 1,0,1,0, 1,0,1,0, ],
						[ 0,0,0,0, 0,0,0,1, ],
						[ 0,0,0,0, 1,1,0,1, ],
					].choose }.dup(4).flatten ,inf).coin.not,
					\sustain, rrand(0.051,0.4),
					\speed, rrand(1/2,2),
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, Pseq([rrand(0,3)+8],inf),
					\isRest, Pseq( {[
						[ 1,1, ],
						[ 1,0, ],
						[ 1,0,0,1 ],
					].choose }.dup(4).flatten ,inf).coin.not,
					\sustain, rrand(0.051,0.4),
					\speed, rrand(1/2,2),
					\dur, 1/8,
					\amp, 0.1
				),
			].flatten};
			patlist3 = {[
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
									[ 1,0,1,0, 1,1,1,0, ],
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
				Pbind(
					\kitIndex, Pseq([rrand(0,3)+4],inf),
					\isRest, Pseq( {[
						[ 1,0,1,0, 1,0,1,0, ],
						[ 0,0,0,0, 0,0,0,1, ],
						[ 0,0,0,0, 1,1,0,1, ],
					].choose }.dup(4).flatten ,inf).coin.not,
					\sustain, rrand(0.051,0.4),
					\speed, rrand(1/2,2),
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, Pseq([rrand(0,3)+8],inf),
					\isRest, Pseq( {[
						[ 1,1, ],
						[ 1,0, ],
						[ 1,0,0,1 ],
					].choose }.dup(4).flatten ,inf).coin.not,
					\sustain, rrand(0.051,0.4),
					\speed, rrand(1/2,2),
					\dur, 1/8,
					\amp, 0.1
				),
			].flatten};

			pat1 = patlist.value.collect({ arg pat, idx; 
				Pbind(\trackIndex, idx) <> pat 
			});
			pat2 = patlist.value.collect({ arg pat, idx; 
				Pbind(\trackIndex, idx) <> pat 
			});
			pat3 = patlist.value.collect({ arg pat, idx; 
				Pbind(\trackIndex, idx) <> pat 
			});

			Pseq([
				Pfindur(7, Ppar(pat1)),
				Pfindur(1, Ppar(pat2)),
				Pfindur(7, Ppar(pat1)),
				Pfindur(1, Ppar(pat3)),

				Pfindur(7, Ppar(pat2)),
				Pfindur(1, Ppar(pat1)),
				Pfindur(7, Ppar(pat3)),
				Pfindur(1, Ppar(pat1)),
			],1);
		}).loop
	);
);

(

	Pdef(\algo2_p5, 
		Plazy({
			var patlist;
			var patlist2, patlist3;
			var pat1, pat2, pat3;
			patlist = {[
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
						\gain, Pkeyd(\gain,1) * 0.6,
					);
				})
			].flatten.collect({ arg pat, idx;
				Pbind(\trackIndex, idx) <> pat 
			})};

			pat1 = patlist.value;
			pat2 = patlist.value;
			pat3 = patlist.value;

			"oooo".postln;
			Pseq([
				Pfindur(8*4 -1, Ppar(pat1.collect(~restpat_intro))),
				Pfindur(1, Ppar(pat1.select({ 0.2.coin }))),

				Pfindur(7, Ppar(pat1)),
				Pfindur(1, Ppar(pat2)),

				Pfindur(7, Ppar(pat1)),
				Pfindur(1, Ppar(pat3)),

				Pfindur(7, Ppar(pat1.select({ 0.5.coin }))),
				Pfindur(1, Ppar(pat2.select({ 0.5.coin }))),

				Pfindur(7, Ppar(pat2)),
				Pfindur(1, Ppar(pat1)),
				Pfindur(7, Ppar(pat3)),
				Pfindur(1, Ppar(pat1)),

				Pfindur(7, Ppar(pat1.select({ 0.5.coin }))),
				Pfindur(1, Ppar(pat2.select({ 0.5.coin }))),

				Pfindur(6, Ppar(
					pat1.collect(~restpat_only_hat)
					++ [ pat1.select(~is_kick).first ]
				)),
				Pfindur(1, Ppar(
					pat1.collect(~restpat_only_hat)
				)),
				Pfindur(1, Ppar(
					pat1.collect(~restpat_only_hat)
					++ pat2.collect(~restpat_only_hat)
				)),

				Pfindur(7, Ppar(
					pat2.collect(~restpat_only_kick)
					++ pat1.collect(~restpat_only_hat)
					++ pat3.collect(~restpat_only_snare)
				));
				Pfindur(1, Ppar(
					[]
					//++ pat2.collect(~restpat_only_kick)
					++ pat1.collect(~restpat_only_hat)
					++ pat3.collect(~restpat_only_snare)
				));

				Pfindur(8*4, Ppar(pat1.collect(~restpat_outro))),
				//Pfindur(1, Ppar(pat1.select({ 0.2.coin }))),

			],1);
		}).loop
	);
);

(

	Pdef(\algo2, 
		Plazy({
			var patlist;
			var patlist2, patlist3;
			var pat1, pat2, pat3;

			patlist = ~algo_patlist1;
			pat1 = patlist.value;
			pat2 = patlist.value;
			pat3 = patlist.value;

			"oooox".postln;
			Pseq([
				Pseq(3.collect{ arg x;
					Pseq([
						Pfindur(3/2, ~kiterize.(
							Ppar(pat1.select(~is_kick).keep(2+( x*2 )))
						)),
						Pfindur(1/2, ~kiterize.(
							Ppar(pat1.select(~is_kick).drop(2).keep(2+( x*2 )))
						)),
					],1)
				},1),
				Pseq(2.collect{
					Pseq([
						Pfindur(1/2, ~kiterize.(
							Ppar(pat1.select(~is_kick).keep(3))
						)),
						Pfindur(1/2, ~kiterize.(
							Ppar(pat1.select(~is_kick).drop(2).keep(3))
						)),
					],1)
				},1),
				Pfindur(4, ~kiterize.(
					Ppar(pat1.select(~is_kick))
				)),
				Pfindur(4, 
					Ppar( [
						~kiterize.( Ppar( pat1.select(~is_kick))),
						Pdef(\algonote) 
					])
				),

			],1);
		}).loop
	);
);

(

	Pdef(\algo2, 
		Plazy({
			var patlist;
			var patlist2, patlist3;
			var pat1, pat2, pat3;

			patlist = ~algo_patlist1;
			pat1 = patlist.value;
			pat2 = patlist.value;
			pat3 = patlist.value;

			"oooox".postln;
			Pseq([
				Pseq(8.collect{ arg x;
					Pseq([
						Pfindur(1/2, ~kiterize.(
							Ppar(pat1.select(~is_kick).keep(1+x))
						)),
						Pfindur(1/2, ~kiterize.(
							Ppar(pat2.select(~is_kick).keep(1+x))
						)),
					],1);
				},1),
				Pseq(8.collect{ arg x;
					Pseq([
						Pfindur(1/2, ~kiterize.(
							Ppar(pat1.select(~is_kick).keep(4))
						)),
						Pfindur(1/2, ~kiterize.(
							Ppar(
								pat2.select(~is_kick).keep(4) 
								++ pat1.select(~is_hat)
							)
						)),
					],1)
				},1),
				Ppar([
					Pseq(8.collect{ arg x;
						Pseq([
							Pfindur(1/2, ~kiterize.(
								Ppar(
									pat1.select(~is_kick).keep(4)
								)
							)),
							Pfindur(1/2, ~kiterize.(
								Ppar(
									pat2.select(~is_kick).keep(4) 
								)
							)),
						],1)
					},1),
					Pfindur(8, ~kiterize.(
						Ppar(
							pat1.select(~is_hat)
						)
					)),
				]),
				Pseq(4.collect{ arg x;
					Pseq([
						Pfindur(1/2, ~kiterize.(
							Ppar(
								pat1.select(~is_kick).keep(4)
								++ pat1.select(~is_hat)
								++ pat1.select(~is_snare)
							)
						)),
						Pfindur(1/2, ~kiterize.(
							Ppar(
								pat2.select(~is_kick).keep(4) 
								++ pat1.select(~is_hat)
								++ pat1.select(~is_snare)
							)
						)),
						Pfindur(1/2, ~kiterize.(
							Ppar(
								pat1.select(~is_kick).keep(4)
								++ pat2.select(~is_hat)
								++ pat1.select(~is_snare)
							)
						)),
						Pfindur(1/2, ~kiterize.(
							Ppar(
								pat1.select(~is_hat)
								++ pat1.select(~is_snare)
							)
						)),
					],1)
				},1),
				Pfindur(4, ~kiterize.(
					Ppar(
						pat1.select(~is_kick).keep(4)
						++ pat1.select(~is_hat)
						++ pat1.select(~is_snare)
					)
				)),
				Pfindur(4, ~kiterize.(
					Ppar(
						pat1.select(~is_kick).keep(4)
						++ pat2.select(~is_kick).keep(4)
						++ pat1.select(~is_hat).keep(2)
						++ pat2.select(~is_hat).keep(2)
						++ pat1.select(~is_snare)
					)
				)),

			],1);
		}).loop
	);
);

// END


Pdef(\algo2, ~kiterize.(Pdef(\algo2_p5))).play
Pdef(\algo2).play;
false.asInteger

