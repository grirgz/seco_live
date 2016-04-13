
(
Pdef(\kick_p1, Pbind(
	\out, BusDef(\fx1),
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
		1,0,0,0, 0,0,0,1,
	],inf).coin.not,
) <> Pdef(\kick) 
).play
)


(
Pdef(\snare_p1, Pbind(
	\out, BusDef(\fx1),
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\isRest, Pseq([
		0,0,0,0, 1,0,0,0,
		0,0,0,0, 1,0,0,0,
	],inf).coin.not,
) <> Pdef(\snare) 
).play
)

(
Pdef(\hat_p1, Pbind(
	\out, BusDef(\fx1),
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\isRest, Pseq([
		1,1
	],inf).coin.not,
) <> Pdef(\hat) 
).play
)
