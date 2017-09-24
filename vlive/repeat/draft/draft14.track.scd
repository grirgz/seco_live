~t = 185/4/60; TempoClock.default.tempo = ~t; // don't know original tempo :(
(
Pdef(\intro, 
	Ppar([
		Pbind(
			\instrument, \noiser,
			\lpf, ~pmodenv.(Pseq([100,4001],inf),8),
			\lpfenv, Pfunc({ arg ev;
				[ Env([1/2,1.0,4.0,4],[0.1,0.1,0.8]) ];
			}),
			\hpf, 200,
			\hpfenv, [ Env([71,44,12,1],[0.4,0.1,0.8]) ],
			\bpf, ~pmodenv.(Pseq([100,401],inf),8),
			\bpfenv, [ Env([71,44,12,1],[0.4,0.1,0.8]) ],
			\isRest, Pseq([
				1,
			],1).coin.not,
			\tsustain, 1/2/~t,
			\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),16),
			\legato, 1,
			\dur, 4,
			\amp, 0.07,
		),
	].flat,1)
).play;
)
Pdef(\intro).clear

(
Pdef(\main, 
	Pseq([
		Pdef(\intro),
		Pfindur(24,Pdef(\drums1)),
		Pdef(\drums2),
		Pfindur(28,Pdef(\drums3)),
		Pfindur(4,Pdef(\fall)),
		Pfindur(24,
			Ppar([
				Pdef(\drums4),
				Pdef(\droneseq),
			]),
		),
		Pfindur(8, 
			Ptpar([
				0,Pdef(\drums2),	
				4,Pdef(\fall),
			]),
		),
		Pfindur(28,Pdef(\drums3)),
		Rest(1),
		Pfindur(1,Pdef(\droneseq)),
		Pfindur(3,Pdef(\drums3)),
	])
).play;
)

(
Pdef(\testmain, 
	Pseq([
		Pfindur(14,Pdef(\drums_p1)),
		Rest(1),
		Pfindur(1,Pdef(\droneseq)),

		Pfindur(14,Pdef(\drums_p2)),
		Rest(1),
		Pfindur(1,Pdef(\droneseq)),

		Pfindur(14,Pdef(\drums_p3)),
		Pfindur(1,Pdef(\droneseq)),
		Rest(1),

		Pfindur(14,Pdef(\drums_p4)),
		Pfindur(1,Pdef(\droneseq)),
		Rest(1),
		
	],inf)
).play;
)

(
Pdef(\testmain, 
	Plazy({
		var parts = [
			Pdef(\drums_p1),
			Pdef(\drums_p2),
			Pdef(\drums_p3),
			Pdef(\drums_p4),
			Pdef(\drums1),
			Pdef(\drums2),
			Pdef(\drums3),
			Pdef(\drums4),
		];
		var trans = [
			Pdef(\intro),
			Pdef(\fall),
			Ptpar([
				0,Pdef(\drums2),	
				4,Pdef(\fall),
			]),
			Pseq([
				Pfindur(1,Pdef(\droneseq)),
				Rest(1),
			]),
			Pseq([
				Rest(1),
				Pfindur(1,Pdef(\droneseq)),
			]),
			Ppar([
				Pdef(\drums4),
				Pdef(\droneseq),
			]),

		];
			Pseq([
				Pfindur(14,parts.choose),
				Pfindur(2,trans.choose),
			])
	}).loop
).play;
)

(
Pdef(\drums1, 
	Ppar([
		Pbind(
			\instrument, \trabass,
			\degree, 0,
			\octave, 3,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\lpfr, 1.1 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
			\sustain, 0.15,
			\dur, 1/8,
			\amp, 0.1
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				1,0.5,1,0.5,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1/2,
			\speed, Pseq([0.2,0.15,0.8,0.27],inf).stutter(1),
			\dur, 1/8,
			\gain, 1/2,
			\gain, 1/2 * Pswitch1(
				Pseg(Prand([0,0.5,0.2,0.8,1],inf),8) ! 4,
				Pseq([0,1,2,3],inf)
			),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\speed, Pswitch1(
				Pseg(Prand((1..8)/18 +1.1,inf),8).stutter(4)!4,
				Pseq((0..3),inf)
			),
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\sustain, Pseg(Prand([0.01,1,0.4],inf),8),
			\dur, 1/8,
			\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \noiser,
			\lpfenv, Pfunc({ arg ev;
				[ Env([1,1.0.rand,1.0.rand,1],[0.1,0.1,0.8]) ];
			}),
			\hpf, 200,
			\hpfenv, [ Env([1/2,74,42,81],[0.4,0.1,0.8]) ],
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\tsustain, 1/2/~t,
			\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),16),
			\legato, 2,
			\dur, 1/8,
			\amp, 0.07,
		),
	].flat)
).play;
)

(
Pdef(\drums2, 
	Pfindur(8,Ppar([
		Pbind(
			\instrument, \trabass,
			\degree, 0,
			\octave, 3,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\lpfr, 1.1 * Pseg(Pseq([1/2,2,4,8],inf),2/~t),
			\sustain, 0.15,
			\dur, 1/8,
			\amp, 0.1
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				1,0.5,1,0.5,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1/2,
			\speed, Pseq([0.2,0.15,0.8,0.27],inf).stutter(1),
			\dur, 1/8,
			\gain, 1/2,
			\gain, 1/2 * Pswitch1(
				Pseg(Prand([0,0.5,0.2,0.8,1],inf),8) ! 4,
				Pseq([0,1,2,3],inf)
			),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\speed, Pswitch1(
				Pseg(Pseq((1..8)/18  +1.1,inf)+ Pwhite(0.0,0.15),1).stutter(1)!4,
				Pseq((0..3),inf)
			),
			\isRest, Pseq({[
				1,0,1,0, 1,0,1,1,
				1,1,1,1, 1,1,1,1,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\sustain, 0.1,
			\dur, 1/8,
			\gain, 1 * Pseg(Pseq((1..8)/8,inf),1),
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \noiser,
			\lpfenv, Pfunc({ arg ev;
				[ Env([1,1.0.rand,1.0.rand,1],[0.1,0.1,0.8]) ];
			}),
			\hpf, 200,
			\hpfenv, [ Env([1/2,74,42,81],[0.4,0.1,0.8]) ],
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\tsustain, 1/2/~t,
			\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),16),
			\legato, 2,
			\dur, 1/8,
			\amp, 0.07,
		),
	].flat))
).play;
)

(
Pdef(\drums3, 
	Ppar([
		Pbind(
			\instrument, \trabass,
			\degree, 0,
			\octave, 3,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\lpfr, 1.1 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
			\sustain, 0.15,
			\dur, 1/8,
			\amp, 0.1
		),
		Pseq([
			Pfindur(4,PatKitDef(\sample1).asPattern(Pbind(
				\instrument, \playersec,
				\kitIndex, 4,
				//\pos, 0,
				\amplfo, 4*~t,
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/4,
				\amp, 0.1,
			))),
			Pfindur(4*3,PatKitDef(\sample1).asPattern(Pbind(
				\instrument, \playersec_fx,
				\kitIndex, 4,
				//\pos, 0,
				\amplfo, Pseq([2,4,8],inf).stutter(2*8)*~t,
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),
				\sustain, Pseq([0.1,1.5],inf).stutter(8) / ~t,
				\dur, 1/4,
				\amp, 0.1,
			))),
		],inf),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				1,0.5,1,0.5,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1/2,
			\speed, Pseq([0.2,0.15,0.8,0.27],inf).stutter(1),
			\dur, 1/8,
			\gain, 1/2,
			\gain, 1/2 * Pswitch1(
				Pseg(Prand([0,0.5,0.2,0.8,1],inf),8) ! 4,
				Pseq([0,1,2,3],inf)
			),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\speed, Pswitch1(
				Pseg(Prand((1..8)/18 +1.1,inf),8).stutter(4)!4,
				Pseq((0..3),inf)
			),
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\sustain, Pseg(Prand([0.01,1,0.4],inf),8),
			\dur, 1/8,
			\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \noiser,
			\lpfenv, Pfunc({ arg ev;
				[ Env([1,1.0.rand,1.0.rand,1],[0.1,0.1,0.8]) ];
			}),
			\hpf, 200,
			\hpfenv, [ Env([1/2,74,42,81],[0.4,0.1,0.8]) ],
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\tsustain, 1/2/~t,
			\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),16),
			\legato, 2,
			\dur, 1/8,
			\amp, 0.07,
		),
	].flat)
).play;
)

(
Pdef(\drums4, 
	Ppar([
		Pseq([
			Pfindur(4,PatKitDef(\sample1).asPattern(Pbind(
				\instrument, \playersec,
				\kitIndex, 4,
				//\pos, 0,
				\amplfo, 4*~t,
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/4,
				\amp, 0.1,
			))),
			Pfindur(4*3,PatKitDef(\sample1).asPattern(Pbind(
				\instrument, \playersec_fx,
				\kitIndex, 4,
				//\pos, 0,
				\amplfo, Pseq([2,4,8],inf).stutter(2*8)*~t,
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),
				\sustain, Pseq([0.1,1.5],inf).stutter(8) / ~t,
				\dur, 1/4,
				\amp, 0.1,
			))),
		],inf),
		//PatKitDef(\sample1).asPattern(Pbind(
		//	\kitIndex, 4,
		//	\isRest, Pseq({[
		//		1,0.5,1,0.5,
		//	].clump(8).choose}.dup(8).flat,inf).coin.not,
		//	\sustain, 0.1/2,
		//	\speed, Pseq([0.2,0.15,0.8,0.27],inf).stutter(1),
		//	\dur, 1/4,
		//	\gain, 1/2,
		//	\gain, 1/2 * Pswitch1(
		//		Pseg(Prand([0,0.5,0.2,0.8,1],inf),8) ! 4,
		//		Pseq([0,1,2,3],inf)
		//	),
		//	\amp, 0.1,
		//)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\speed, Pswitch1(
				Pseg(Prand((1..8)/18 +1.1,inf),8).stutter(4)!4,
				Pseq((0..3),inf)
			),
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\sustain, Pseg(Prand([0.01,1,0.4],inf),8),
			\dur, 1/8,
			\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \noiser,
			\lpfenv, Pfunc({ arg ev;
				[ Env([1,1.0.rand,1.0.rand,1],[0.1,0.1,0.8]) ];
			}),
			\hpf, 200,
			\hpfenv, [ Env([1/2,74,42,81],[0.4,0.1,0.8]) ],
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\tsustain, 1/2/~t,
			\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),16),
			\legato, 2,
			\dur, 1/8,
			\amp, 0.07,
		),
	].flat)
).play;
)
