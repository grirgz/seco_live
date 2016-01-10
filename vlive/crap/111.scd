

ParamProto.init
DrumRack(\hip).edit
(
Pdef(\hop, DrumRack(\hip, 
	
	Ppar( [
		Pbind(
			\midinote, 0,
			\isRest, Pseq([
				1,0,0,0, 1,0,1,0,
				1,1,0,0, 1,0,0,0,
			],inf).coin.not,
		),
		Pbind(
			\midinote, 1,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
		),
		Pbind(
			\midinote, 3,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
		),
		Pbind(
			\midinote, 2,
			\lag, Pseq([0,1/4 * 0.7],inf),
			\isRest, Pseq([
				0,0,1,1, 0,0,1,1,
			],inf).coin.not,
		),
	])
	<>
	Pbind(\dur, 1/4)
)).play
)
