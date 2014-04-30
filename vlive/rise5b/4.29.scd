(
Pdef(~name+++\cs, 
	~clip_pspawner <> Pbind(
		\track, (1..8),
		\track, (0..15),
		\track, [7],
		\track, Pseq((0..15)),
		\track, Pseq((0..7).reverse + 8),
		\clip, \r,
		\dur, 1

	)
).play
)

// END


(
Pdef(~name+++\cs, 
	~clip_pspawner <> Pbind(
		\track, (0..8),
		\track, (0..15),
		\track, [7],
		//\clip, Pseq([
		//	[\r,\r,\r,\r],
		//	[\p,\p,\p,\p],
		//]),
		\clip, Pseq([\r,\p],inf),

		\clip, Prout({ arg ev;
			var size = ev[\track].size;
			size.do { arg x;
				x.debug("xxxxxx");
				~wavearray.(\r, \p, x, size).yield;
			};
		}),
		//\clip, Pn(\p,1),
		\dur, 4

	)
).play
)

Veco(\p)
Veco.main.get_node_by_index(gt)
Veco()
Pdef(~name+++\cs).stop
~spawnclip.(8, \p)

(
~wavearray.(\r, \p, 90, 8)

)
