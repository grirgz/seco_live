

(
Pdef(\poly,
	Ppar([
		Pbind(
			\dur, 1/(1..9).choose * 4,
			\isRest, false,
		) <> ~kitlib.hiphop.kick,
		Pbind(
			\dur, 1/(1..9).choose * 8,
			\isRest, false,
		) <> ~kitlib.hiphop.kick,
		Pbind(
			\dur, 1/(1..9).choose * 4,
			\isRest, false,
		) <> ~kitlib.hiphop.snare,
		Pbind(
			\dur, 1/(1..9).choose * 8,
			\isRest, false,
		) <> ~kitlib.hiphop.snare,
		Pbind(
			\dur, 1/(1..9).choose * 2,
			\isRest, false,
		) <> ~kitlib.hiphop.hat,
		Pbind(
			\dur, 1/(1..9).choose * 4,
			\isRest, false,
		) <> ~kitlib.hiphop.hat,
		Pbind(
			\dur, 1/(1..9).choose * 4,
			\isRest, false,
		) <> ~kitlib.hiphop.hat,
	]),
).play;
)

(
Pdef(\poly,
	Plazy({
		//var kicks = 8.collect({ [~kitlib.klak.kick, ~kitlib.trap.kick, ~kitlib.hiphop.kick].choose });
		//var snares = 8.collect({ [~kitlib.trap.snare].choose });
		//var hats = 8.collect({ [~kitlib.trap.hat, ~kitlib.hiphop.hat, ~kitlib.tek.hat].choose });
		var kicks = 8.collect({ [~kitlib.hiphop.kick].choose });
		var snares = 8.collect({ [~kitlib.hiphop.snare].choose });
		var hats = 8.collect({ [~kitlib.hiphop.hat].choose });


		Pseq([
			Pfindur(4,
				Ppar([
					Pbind(
					) <> kicks[0],
					Pbind(
					) <> kicks[1],
					Pbind(
					) <> snares[0],
					Pbind(
					) <> snares[1],
					Pbind(
					) <> hats[0],
					Pbind(
					) <> hats[1],
					Pbind(
					) <> hats[2],
				]),
			),
			Pfindur(4,
				Ppar([
					Pbind(
						\dur, 1/(1..9).choose * 1,
						\isRest, false,
					) <> kicks[0],
					Pbind(
						\dur, 1/(1..9).choose * 2,
						\isRest, false,
					) <> kicks[1],
					Pbind(
						\dur, 1/(1..9).choose * 1,
						\isRest, false,
					) <> snares[0],
					Pbind(
						\dur, 1/(1..9).choose * 2,
						\isRest, false,
					) <> snares[1],
					Pbind(
						\dur, 1/(1..9).choose * 1,
						\isRest, false,
					) <> hats[0],
					Pbind(
						\dur, 1/(1..9).choose * 2,
						\isRest, false,
					) <> hats[1],
					Pbind(
						\dur, 1/(1..9).choose * 2,
						\isRest, false,
					) <> hats[2],
				]),
			),
		],1);
	}).loop
).play;
)
