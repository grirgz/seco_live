~t = 300/4/60; TempoClock.default.tempo = ~t;

/// expand sun27.scd
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-TU0B-6MP6", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.49159663865546,
	'gain', 0.68243243243243,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.53838436220335,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.2492192141522,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

(
Pdef(\part3, Pdef(\notecloud, 
	Ppar([
		
		Pbind(
			\mtranspose, Pstep(Pseq([0,3,0,0,4,3,0,0],inf),4),
		)<>
		Ppar( 20.collect { arg item, idx;
			Pbind(
				\instrument, [\basicpad, \sinchord].choose,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\degree, \Cm9.asDegrees.choose + [0,7,14].choose,
				\legato, 0.2,
				\dur, rrand(0.1,2.4),
				\isRest, Pshuf([
					1,0,0,0,
				],inf).coin.not,
				\octave, 3,
				\out, BusDef(\sendbus1, \audio),
				\amp, 0.1,
			)
		}),
	])
)).play;
);

(
	ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\mtranspose, Pstep(Pseq([0,3,0,0,4,3,0,0],inf),4),
		)<>
		Ppar( 20.collect { arg item, idx;
			Pbind(
				\instrument, [\basicpad, \sinchord].choose,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\degree, \Cm9.asDegrees.choose + [0,7,14].choose,
				\legato, 0.2,
				\dur, rrand(0.1,2.4),
				\isRest, Pshuf([
					1,0,0,0,
				],inf).coin.not,
				\octave, 3,
				\out, BusDef(\sendbus1, \audio),
				\amp, 0.1,
			)
		}),
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0.4,0, 0.3,0,0.3,0,
				0,0,0.5,0.5, 0,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.15 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.15 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('loop/pigs.flac'),
			\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			\st, 272/8/60,
			\speed, 1/Pseq([1,1,2,4],inf) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([
					0, 4,
				],1),4),
				Pseg(Pseq([
					2, 3,
				],1),2),
				Pseg(Pseq([
					1, 2,
				],1),2),
			],inf) / Pkey(\st),
			\dur, PdurStutter(Pseq([1,1,1,4,2,1,8],inf), 1/2),
			\gain, 0.1,
		),
	])
)).play;
);

