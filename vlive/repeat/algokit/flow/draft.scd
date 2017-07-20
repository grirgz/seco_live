
Pdef(\drums).set(\out, BusDef(\fbfx, \audio))
(
Pdef(\drums, 
	Plazy({
		var kitfun = {(
			kick1: PatKitDef(\sample1).asPattern(Pbind( // kick 1
				\kitIndex, 0,
				\isRest, Pseq({[
					1,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					1,0,0,1, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
					1,0,0,0, 0,0,0,1,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\freq, 200,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1
			)),
			kick2: PatKitDef(\algokit).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq({[
					1,0,0,0, 0,0,0,0,
				].clump(8).choose}.dup(4).flat,inf).coin.not,
				\dur, 1/8,
				\sustain, 0.1,
				\out, BusDef(\fbfx, \audio),
			)),
			snare1: PatKitDef(\sample1).asPattern(Pbind( // snare
				\kitIndex, 4,
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\freq, 200,
				\sustain, Pseq({rrand(0.05,0.2)}!8,inf).stutter(8),
				\dur, 1/8,
				\amp, 0.1
			)),
			snare2: PatKitDef(\algokit).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,1,0,
					1,1,1,1, 1,1,1,1,
				].clump(8).choose}.dup(4).flat,inf).coin.not,
				\speed, 0.7,
				\dur, 1/8,
				\sustain, 0.031,
			)),
				smallsnare1: PatKitDef(\sample1).asPattern(Pbind( // contre temps
					\kitIndex, 4,
					\isRest, Pseq({[
						0,0,0,0, 0,0,1,0, 
						0,0,0,0, 0,0,0,0, 
						0,0,0,0, 0,0,0,0, 
						0,1,0,0, 0,0,0,0, 
						0,0,1,0, 0,0,0,0, 
						0,0,0,0, 0,1,0,0, 
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\pos, 0.04+0.1,
					\sustain, 0.081,
					\dur, 1/8,
					\amp, 0.1
				)),
			hat1: PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 10,
				\isRest, Pseq({[
					1,0,1,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,1,0,
					1,1,1,1, 0,1,1,1,
				].clump(4).choose.dup(2)}.dup(8).flat,inf).coin.not,
				\freq, 200,
				\dur, 1/16,
				\gain, Pseq([
					1,0.5,
					0.3,0.5,
				],inf)*0.9,
				\sustain, Pseq([0.02,0.02,0.08,0.02]/2,inf),
				\amp, 0.1
			)),

			///// guitar

			bassguitar1: PatKitDef(\sample1).asPattern(Pbind( // bass guitar
				\kitIndex, 12,
				\isRest, Pseq({[
					1,0,0,0, 0,0,0,0, 
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\freq, 200,
				\sustain, 0.4,
				\dur, 1/4,
				\amp, 0.1
			)),
			trebguitar1: PatKitDef(\sample1).asPattern(Pbind( // treb guitar
				\kitIndex, 14,
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0, 
					0,0,0,0, 1,0,1,0, 
					0,0,0,0, 0,0,0,0, 
					0,0,0,0, 0,0,1,0, 
					0,0,0,0, 0,0,0,1, 
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\freq, 200,
				\sustain, 0.4,
				\dur, 1/4,
				\amp, 0.1
			)),
				smallbassguitar1: Pbind( // small bass guitar
					\kitIndex, 12,
					\isRest, Pseq({[
						1,0,0,0, 0,0,0,0, 
						0,0,0,0, 0,0,0,0, 
						1,1,0,0, 0,0,0,0, 
						1,0,1,0, 1,0,1,0, 
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 0,0,0,0,
						0,0,0,0, 1,1,1,1,
						1,0,1,0, 0,0,0,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\gain, Pseq([
						0.3,0.5,1,0.5,
					],inf),
					\sustain, 0.1,
					\dur, 1/16,
					\amp, 0.1
				),

			// tone

			bass1: Pbind(
				\instrument, \riser,
				\freq, 50 * Pseg(Pseq([1.8,1],inf),2),
				\dur, 1/8,
				\legato, 0.1,
				\amp, 0.1,
				\out, BusDef(\fbfx, \audio),
			),
			bass2: Pbind(
				\instrument, \riser,
				\freq, 50 * Pseg(Pseq([1.8,1],inf),2),
				\dur, 1/2,
				\legato, 0.9,
				\amp, 0.1,
				\out, BusDef(\fbfx, \audio),
			),
			chord1: Pbind(
				\instrument, \criz,
				\freq, 50 * 12 * ([0,3,7]-4).midiratio,
				\isRest, Pseq([
					0,1,
				],inf).coin.not,
				\dur, 1/1,
				\legato, 0.5,
				\amp, 0.1/3,
				\out, BusDef(\fbfx, \audio),
			),
			skank1: Pbind(
				\instrument, \riser2,
				\freq, 50 * 6 * Pseq([
					Pfin(16*4,Pseq([
						Pser([0,3,7]-4,1/4*16),
						Pser([0,3,7]-1,1/4*16),
					],inf)),
					Pfin(16*4,Pseq([
						Pser([0,3,7]-4,1*16),
						Pser([0,3,7]-1,1*16),
					],inf)),
				],inf).midiratio,
				\isRest, Pseq([
					Pser([
						0.5,1,
					],3*8),
					Pser([
						0,0,0,
					],1*8),
					Pser([
						0.5,0.5,1,
					],3*8),
					Pser([
						0,0,0,
					],1*8),
				],inf).coin.not,
				\lpfr, 1,
				\dur, 1/4,
				\legato, 0.5,
				\amp, 0.1,
				\out, BusDef(\fbfx, \audio),
			),
			skank2: Pbind(
				\instrument, \criz,
				\freq, 50 * 12 * (Pseq([
					[0,3,7]-4,
					[-2,2,7]-4,
				],inf).stutter(16)).midiratio ,
				\isRest, Pseq([
					Pseq({[
						0,1,0,1,
						0,0,0,1,
						0,1,0,0,
						1,1,1,1,
						0,0,0,0,
						0,0,0,0,
					].clump(4).choose}.dup(8).flat,inf)
				],inf).coin.not,
				\dur, 1/8,
				\legato, 1,
				\adsr, Pseq([
					Pseq([
						[ Env.adsr(0.001,0.1,0.8,0.001) ],
						[ Env.adsr(0.001,0.1,0.8,0.11) ],
						[ Env.adsr(0.001,0.1,0.8,0.001) ],
						[ Env.adsr(0.001,0.1,0.8,0.001) ],
					],inf).stutter(2),
				],1),
				\sustain, Pseq([0.03,0.06, 0.03, 0.06, 0.03, Prand([0.06,0.2],1)],inf).stutter(2) * Pseq([1/2,1/2,1/2,1],inf).stutter(8),
				\amp, 0.1,
				\out, BusDef(\fbfx, \audio),
			),
			bass3: Pbind(
				\instrument, \riser2,
				\freq, 50 * 12 * ([1/2]) * (Pseq([
					0-4,
					-2 -4,
				],inf).stutter(16)).midiratio ,
				\isRest, Pseq([
					Pseq({[
						1,0,0,0,
						1,1,0,0,
						1,0,1,0,
					].clump(4).choose}.dup(8).flat,inf)
				],inf).coin.not,
				\dur, 1/8,
				\legato, 1,
				\adsr, Pseq([
					Pseq([
						[ Env.adsr(0.001,0.1,0.8,0.001) ],
						[ Env.adsr(0.001,0.1,0.8,0.11) ],
						[ Env.adsr(0.001,0.1,0.8,0.001) ],
						[ Env.adsr(0.001,0.1,0.8,0.001) ],
					],inf).stutter(2),
				],1),
				\legato, Pseq([0.3,0.5, 0.3, 0.5, 0.3, Prand([0.06,0.2],1)],inf).stutter(2) * Pseq([1/2,1/2,1/2,1],inf).stutter(8),
				\amp, 0.4,
				\out, BusDef(\fbfx, \audio),
			),
		)};
		var kit1 = kitfun.value;

		Pseq([
			Ppar([
				Pbind(
					\isRest, Pseq([
						1,1,1,1, 1,0,1,0,
					],inf).coin.not,
					\freq, 50 * Pseg(Pseq([1,1,1,1.8],inf),1/2) *( 12-3 ).midiratio,
				) <> kit1.bass1,
				kit1.kick1,
				kit1.kick2,
				kit1.snare1,
				kit1.snare2,
				kit1.skank2,
				kit1.hat1,
				//kit1.bassguitar1,
				//kit1.smallbassguitar1,
				//kit1.trebguitar1,
				

				//kit1.chord1,
			]),
		]);

	})
).play;
Pdef(\fxpat).play;
)

Pdef(\drums).stop;
Pdef(\fxpat).stop;

(
Pdef(\fxpat, 
	Ppar([
		PmonoArtic(\fbfx,
			\inbus, BusDef(\fbfx, \audio),
			//\fb, Pseq([1,1.2,0.4,2.1],inf),
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,0.11,
			],inf),
			\preamp, 1,
			\startamp, 1,
			\foadd, 1.0,
			\fomul, 3,
			\delay, Pseg(Pseq([
				0.0001,0.0001,0.0001,0.0001,
				0.00001,0.00001,0.001,0.00001,
				0.0001,0.0001,0.0001,0.0001,
				0.00001,0.00001,0.0051,0.00001,
			],inf),1/2),
			\delay2, 0.000001,
			\delay2, Pseg(Pseq([
				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.001,0.0001,
				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.001,0.0001,
				0.005, 0.005, 0.005, 0.005,
				0.005, 0.005, 0.005, 0.005,
				0.005, 0.005, 0.005, 0.005,
				0.005, 0.005, 0.005, 0.005,
			],inf),1/2),
			\distmix, Pseq([
				{
					Pseq([
						0,0.7,0.1,0.8
					],1).stutter(rrand(1,8))
				}.dup(8)
			].flat,inf).stutter(1),
			\distmix, 0.2,
			\hpf, 40,
			\mix, 0.9,
			\postamp, 1/2,
			\lagdelay, 1/8/~t,
			\fb, 0.00010,
			\dur, 1/4,
			\out, BusDef(\sendbus0, \audio),
			//\dur, 1/4,
		
		)
		
	])
).play;
)

ProtoDef(\rdn).edit
ProtoDef(\rdn).loadDefaultPreset
