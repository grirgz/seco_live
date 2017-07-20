
(
Pdef(\treb, Pseq([
	Ppar([
		Pbind(
			\instrument, \lead,
			\degree, Pseq([0],inf),
			\freq, [100,252,424],
			\fold, Pseg(Pseq([0,1],inf),8),
			\isRest, Pseq([
				0,0,0,0,
				1,0,0,0,
			],inf).coin.not,
			\legato, 3,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \criz,
			\degree, Pseq([0],inf),
			\freq, [100,252,424] * 4,
			\lag, Ptuple(
				3.collect({ arg x;
					Pseg(Pseq([0+x,1]/10,inf),8);
				})
			),
			\fold, Pseg(Pseq([0,1],inf),16),
			\isRest, Pseq([
				1,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
			],inf).coin.not,
			\legato, 3,
			\dur, 1/8,
			\amp, 0.1
		)
	]),
]));
Pdef(\treb).play;
);

(
Pdef(\treb, Pseq([
	Ppar([
		Pbind(
			\instrument, \lead,
			\degree, Pseq([0],inf),
			\freq, [100,252,424],
			\fold, Pseg(Pseq([1,0],inf),8),
			\isRest, Pseq([
				Pser([1],2*3),
				Pser([1,0],2*1),
			],inf).coin.not,
			\legato, 0.3,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \criz,
			\degree, Pseq([0],inf),
			\freq, [100,252,424] * 4,
			\lag, Ptuple(
				3.collect({ arg x;
					Pseg(Pseq([0+x,1]/10,inf),8);
				})
			),
			\fold, Pseg(Pseq([0,1],inf),16),
			\isRest, Pseq([
				1,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
			],inf).coin.not,
			\isRest, Pseq([
				Pser([1],2*3),
				Pser([1,0],2*1),
			],inf).coin.not,
			\legato, 0.8,
			\dur, 1/8,
			\amp, 0.1
		)
	]),
]));
Pdef(\treb).play;
);

(
Pdef(\treb, Pseq([
	Ppar([
		Pbind(
			\instrument, \criz,
			\degree, Pseq([0],inf),
			\freq, Pseq([70,80,68,80],inf).stutter(8),
			\fold, Pseg(Pseq([0.8,1],inf),8),
			\lpfr, Pseg(Pseq([4,1],inf),8),
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 0.3,
			\legato, Pseq({[
				3,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
			].clump(8).choose}.dup(8).flat,inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.3
		),
		Pbind(
			\instrument, \criz,
			\degree, Pseq([0],inf),
			\freq, Pseq([70,80,68,80]*4,inf).stutter(8),
			\fold, Pseg(Pseq([0.8,1],inf),8),
			\lpfr, Pseg(Pseq([4,1],inf),8),
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 0.3,
			\legato, Pseq({[
				3,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
			].clump(8).choose}.dup(8).flat,inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1
		),
	]),
]));
Pdef(\treb).play;
);

