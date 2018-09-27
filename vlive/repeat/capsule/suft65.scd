
~t = 176/4/60; TempoClock.default.tempo = ~t;


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 31], [0.035, 0.08], curve: \exp) ],
			\bodyenv, 
			Pseq([
				[ Env.linen(0.005, 0.1, 0.23) ],
				[ Env.linen(0.005, 0.1, 0.07) ],
				[ Env.linen(0.005, 0.1, 0.13) ],
				[ Env.linen(0.005, 0.1, 0.03) ],
			],inf),
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\speed, 1.015,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,1, 1,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 1,0,0,  0,0,0, 1,0,1,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,1,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				1,0,1, 1,0,0,  0,0,0, 1,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.2,
			\dur, 1/12,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,1, 0,1, 1,1, 1,1,
				1,1, 1,1, 1,0, 1,1,
				1,1, 1,0, 1,1, 1,1,
				1,1, 1,1, 1,0, 1,1,
				1,1, 1,1, 1,1, 0,1,
				1,1, 0,1, 1,1, 1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2 * Pseq([1,0.2],inf),
			\dur, 1/8,
			\out, BusDef(\sendbus3, \audio),
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 12,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,1,1,0, 1,0,1,1,
				],1),
				Pseq([
					0,0,0,0, 0,0,1,0,
					0,1,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					1,1,1,0, 1,0,1,1,
				],1),
				Pseq([
					0,0,0,0, 0,0,0,1,
					0,0,0,1, 0,0,1,0,
					0,0,0,0, 0,1,0,0,
					1,1,1,0, 1,0,1,1,
				],1),
				1,0,1,1, 1,0,1,1,
				0,1,1,1, 0,1,1,0,
				1,1,1,1, 0,1,1,1,
				0,1,1,0, 1,1,1,0,
			],inf).coin.not,
			\sustain, 0.1/2 * Pseq([1,2,4,1,2],inf),
			\gain, 0.1 * Pseq([1,0.6,0.6],inf),
			\dur, 1/8,
			\out, BusDef(\sendbus3, \audio),
		)),

		
	])
)).play;
)

