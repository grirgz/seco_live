
(
	Pdef(\rand, 
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\pos, 0.04,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\pos, 0.04+( 12/8/~t ),
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\pos, Pwhite(0,2.0),
				\speed, Pseg(Pseq([0,4],inf),8),
				\pos, Pseg(Pseq([0,1,1/4],inf),1),
				\dur, 1/16,
				\amp, 0.1,
			)
		])
	).play;
);



(
	Pdef(\rand, 
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\pos, 0.04,
				\isRest, Pseq([
					1,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\pos, Pwhite(0,2.0),
				\speed, Pseg(Pseq([0,4],inf),8),
				\speed, 0.5,
				\pos, Pseg(Pseq([0,1/8],inf),1),
				\legato, 2,
				\dur, 1/16,
				\amp, 0.1,
			)
		])
	).play;
);

(
	~master.();
	Pdef(\rand, 
		Pbind(\out, BusDef(\sendbus1))<>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\pos, 0.04,
				\isRest, Pseq([
					1,0, 1,0, 0,0,0,0, 
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\pos, 0.04+( 12/8/~t ),
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\pos, 0.04+( 2/8/~t ),
				\isRest, Pseq([
					1,0,
				],inf).coin.not,
				\sustain, 0.01,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\pos, Pwhite(0,2.0),
				\speed, Pseq([1.2,0.8],inf)*1,
				\pos, Pseg(Pseq([0,1/8],inf),1),
				\pos, Pseq([0,1/8],inf) + Pseq([0,1,2,1, 2,4,2,4]/40,inf).stutter(4),
				\isRest, Pseq([
					1,1,1,1, 0,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,0,1,1, 1,1,0.51,1,
					1,1,1,1, 1,1,0.51,1,
				],inf).coin.not,
				\legato, 1.0,
				\dur, 1/16,
				\amp, 0.1/2,
			)
		])
	).play;
);

(
	~master.();
	Pdef(\rand, 
		Pbind(\out, BusDef(\sendbus1))<>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\pos, 0.04,
				\isRest, Pseq([
					1,0, 1,0, 0,0,0,0, 
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\pos, 0.04+( 12/8/~t ),
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\pos, 0.04+( 2/8/~t ),
				\isRest, Pseq([
					1,0,
				],inf).coin.not,
				\sustain, 0.01,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop/clean7_135bpm.flac'),
				\pos, Pwhite(0,2.0),
				\speed, Pseq([1.2,0.8],inf)*1,
				\pos, Pseg(Pseq([0,1/8],inf),1),
				\pos, Pseq([0,1/8],inf) + Pseq([0,1,2,1, 2,4,2,4]/40,inf).stutter(4),
				\isRest, Pseq([
					1,1,1,1, 0,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,0,1,1, 1,1,0.51,1,
					1,1,1,1, 1,1,0.51,1,
				],inf).coin.not,
				\legato, 1.0,
				\dur, 1/16,
				\amp, 0.1/2,
			)
		])
	).play;
);
