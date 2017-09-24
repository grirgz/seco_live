(
Pdef(\drums_p4, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.31,
			\dur, 1/4,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\instrument, \playersec_fx,
			\kitIndex, 4,
			//\pos, 0,
			\amplfo, Pseq([11],inf)*~t,
			\shiftlfo, Pseq([7],inf)*~t,
			\isRest, Pseq({[
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.2,
			\dur, 1/4,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \trabass,
			\octave, 3,
			\isRest, Pseq([
				Pser([
					1,0,0,0,
				],16*4),
				Pser([
					1,0,1,0,
				],16*4),
				Pser([
					1,0.5,1,0.5,
				],16*4),
				Pser([
					1,0.8,1,0.9,
				],16*4),
			],inf).coin.not,
			\lpfr, 1.1 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
			\rq, 0.1 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
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
			\dur, 1/4,
			\gain, 1/2,
			\gain, 1/2 * Pswitch1(
				Pseg(Prand([0,0.5,0.2,0.8,1],inf),8) ! 4,
				Pseq([0,1,2,3],inf)
			),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,0,1,0, 1,0,1,0,
			].rotate(1).clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,0,0, 1,1,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\speed, Pseg(Prand((1..8)/19 + 1.3,inf),8),
			\dur, 1/8,
			\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
			\amp, 0.1,
		)),
		//Pbind(
		//	\instrument, \bizar,
		//	\freq, 200 * Pseg(Prand([3,1,2,1]/0.814,inf),8),
		//	\fold, 1 * Pseg(Prand([3,1,2,1]/1.814,inf),8),
		//	\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
		//	\dur, 1/8,
		//	\amp, 0.1
		//),
		//Ppar(
		//	{Pbind(
		//		\instrument, \bizar2,
		//		\freq, 200 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
		//		\diff, 0.001 * Pseg(Prand([100,3,1,2,1]/0.814,inf),16),
		//		\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),16),
		//		\lpfr, 4 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
		//		\rq, 1 * Pseg(Prand([0.01,0.5,0.2,0.81],inf),8),
		//		\amdetune, 0.01 * Pseg(Prand([0.01,0.5,0.2,0.81],inf),8),
		//		\isRest, Pseq([
		//			Pseq({[
		//			1,1,1,1, 1,1,1,1,
		//			1,0,1,0, 1,0,1,0,
		//			1,0,0,0, 1,0,0,0,
		//			0,0,1,0, 0,0,1,0,
		//			].clump(4).choose}.dup(8).flat,inf)
		//		],inf).coin.not,
		//		\dur, 1/[8,4,16,1,2].choose,
		//		\amp, 0.1/4,
		//	)} ! 4,
		//),
		//Pbind(
		//	\isRest, Pstep(Pseq([
		//		Prand([
		//			Pseq([ 1,0,1,0, ],1),
		//			Pseq([ 1,1,0,0, ],1),
		//			Pseq([ 0,0,1,1, ],1),
		//		],inf),
		//	],inf),1).coin.not,
		//) <>
		Pbind(
			\instrument, \bizar3,
			\tsustain, 4,
			//\freq, Pwhite(100,1000.0,inf).stutter(Prand([8,4,2,16],inf)),
			\degree, Pwhite(0,12,inf).stutter(Prand([8,4,2,16],inf)),
			\detune, Pseg(Pseq([0,1000],inf),8),
			\dur, PdurStutter(Prand([1,4,2,8],inf), 2),
			\amp, 0.1/8,
			\amp, Pkey(\amp) * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
		) ! 4,
		//Pbind(
		//	\instrument, \bizar2,
		//	\tsustain, 4,
		//	//\freq, Pwhite(100,1000.0,inf).stutter(Prand([8,4,2,16],inf)),
		//	\degree, Pwhite(-12,12,inf).stutter(Prand([8,4,2,16],inf)),
		//	\isRest, Pstep(Pseq([
		//			Pseq([ 1,0,1,0, ],1),
		//	],inf),1).coin.not,
		//	\detune, Pseg(Pseq([0,1000],inf),8),
		//	\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
		//	\amp, 0.1/4,
		//),
		//Pbind(
		//	\instrument, \bizar2,
		//	\tsustain, 4,
		//	\freq, Pwhite(100,1000.0,inf).stutter(Prand([8,4,2,16],inf)),
		//	//\degree, Pwhite(0,12,inf).stutter(Prand([8,4,2,16],inf)),
		//	\isRest, Pstep(Pseq([
		//			Pseq([ 0,1,0,1, ],1),
		//	],inf),1).coin.not,
		//	//\detune, Pseg(Pseq([0,1000],inf),8),
		//	\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
		//	\amp, 0.1/4,
		//),
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
);
(
Pdef(\drums_p3, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.31,
			\dur, 1/4,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\instrument, \playersec_fx,
			\kitIndex, 4,
			//\pos, 0,
			\amplfo, Pseq([4,5,6,11,9,10],inf)*~t,
			\shiftlfo, Pseq([5,3,7,6,12],inf)*~t,
			\isRest, Pseq({[
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 1.0,
			\dur, 1/2,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \trabass,
			\degree, 0,
			\octave, 3,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\lpfr, 1.1 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
			\rq, 0.1 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
			\sustain, 0.90,
			\dur, 1/1,
			\amp, 0.1
		),
		Pbind(
			\instrument, \trabass,
			\octave, 3,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,1, 0,1,0,1,
				1,0,0,1, 0,0,1,0,
				1,1,0,0, 1,1,0,1,
			],inf).coin.not,
			\lpfr, 1.1 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
			\rq, 0.1 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
			\sustain, 0.45,
			\lag, 1/4/~t,
			\dur, 1/1,
			\amp, 0.1
		),
		Pbind(
			\instrument, \trabass,
			\octave, 3,
			\isRest, Pseq([
				Pseq([
					1,0,1,1, 0,1,1,1,
					1,0,1,1, 0,1,1,0,
					1,0,1,1, 0,0,1,0,
					1,0,1,0, 1,0,1,0,
				],16),
				Pseq([
					1,0,0,1, 0,0,1,0,
				],16*4),
			],inf).coin.not,
			\lpfr, 1.1 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
			\rq, 0.1 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
			\sustain, 0.45,
			\lag, 1/2/~t,
			\dur, 1/1,
			\amp, 0.1
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				1,0.5,1,0.5,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1/2,
			\speed, Pseq([0.2,0.15,0.8,0.27],inf).stutter(1),
			\dur, 1/4,
			\gain, 1/2,
			\gain, 1/2 * Pswitch1(
				Pseg(Prand([0,0.5,0.2,0.8,1],inf),8) ! 4,
				Pseq([0,1,2,3],inf)
			),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\speed, Pseg(Prand((1..8)/19 + 1.3,inf),8),
			\dur, 1/16,
			\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
			\amp, 0.1,
		)),
		//Pbind(
		//	\instrument, \bizar,
		//	\freq, 200 * Pseg(Prand([3,1,2,1]/0.814,inf),8),
		//	\fold, 1 * Pseg(Prand([3,1,2,1]/1.814,inf),8),
		//	\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
		//	\dur, 1/8,
		//	\amp, 0.1
		//),
		//Ppar(
		//	{Pbind(
		//		\instrument, \bizar2,
		//		\freq, 200 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
		//		\diff, 0.001 * Pseg(Prand([100,3,1,2,1]/0.814,inf),16),
		//		\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),16),
		//		\lpfr, 4 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
		//		\rq, 1 * Pseg(Prand([0.01,0.5,0.2,0.81],inf),8),
		//		\amdetune, 0.01 * Pseg(Prand([0.01,0.5,0.2,0.81],inf),8),
		//		\isRest, Pseq([
		//			Pseq({[
		//			1,1,1,1, 1,1,1,1,
		//			1,0,1,0, 1,0,1,0,
		//			1,0,0,0, 1,0,0,0,
		//			0,0,1,0, 0,0,1,0,
		//			].clump(4).choose}.dup(8).flat,inf)
		//		],inf).coin.not,
		//		\dur, 1/[8,4,16,1,2].choose,
		//		\amp, 0.1/4,
		//	)} ! 4,
		//),
		//Pbind(
		//	\isRest, Pstep(Pseq([
		//		Prand([
		//			Pseq([ 1,0,1,0, ],1),
		//			Pseq([ 1,1,0,0, ],1),
		//			Pseq([ 0,0,1,1, ],1),
		//		],inf),
		//	],inf),1).coin.not,
		//) <>
		Pbind(
			\instrument, \bizar3,
			\tsustain, 4,
			//\freq, Pwhite(100,1000.0,inf).stutter(Prand([8,4,2,16],inf)),
			\degree, Pwhite(0,12,inf).stutter(Prand([8,4,2,16],inf)),
			\detune, Pseg(Pseq([0,1000],inf),8),
			\dur, PdurStutter(Prand([1,4,2,8],inf), 2),
			\amp, 0.1/8,
			\amp, Pkey(\amp) * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
		) ! 4,
		//Pbind(
		//	\instrument, \bizar2,
		//	\tsustain, 4,
		//	//\freq, Pwhite(100,1000.0,inf).stutter(Prand([8,4,2,16],inf)),
		//	\degree, Pwhite(-12,12,inf).stutter(Prand([8,4,2,16],inf)),
		//	\isRest, Pstep(Pseq([
		//			Pseq([ 1,0,1,0, ],1),
		//	],inf),1).coin.not,
		//	\detune, Pseg(Pseq([0,1000],inf),8),
		//	\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
		//	\amp, 0.1/4,
		//),
		//Pbind(
		//	\instrument, \bizar2,
		//	\tsustain, 4,
		//	\freq, Pwhite(100,1000.0,inf).stutter(Prand([8,4,2,16],inf)),
		//	//\degree, Pwhite(0,12,inf).stutter(Prand([8,4,2,16],inf)),
		//	\isRest, Pstep(Pseq([
		//			Pseq([ 0,1,0,1, ],1),
		//	],inf),1).coin.not,
		//	//\detune, Pseg(Pseq([0,1000],inf),8),
		//	\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
		//	\amp, 0.1/4,
		//),
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
);

(
Pdef(\drums_p2, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.31,
			\dur, 1/4,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\instrument, \playersec_fx,
			\kitIndex, 4,
			//\pos, 0,
			\amplfo, 8*~t,
			\isRest, Pseq({[
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 1.0,
			\dur, 1/2,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \trabass,
			\degree, 0,
			\octave, 3,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\lpfr, 1.1 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
			\rq, 0.1 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
			\sustain, 0.10,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \trabass,
			\octave, 3,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,1, 0,1,0,1,
				1,0,0,1, 0,0,1,0,
				1,1,0,0, 1,1,0,1,
			],inf).coin.not,
			\lpfr, 1.1 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
			\rq, 0.1 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
			\sustain, 0.05,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \trabass,
			\octave, 3,
			\isRest, Pseq([
				Pseq([
					1,0,1,1, 0,1,1,1,
					1,0,1,1, 0,1,1,0,
					1,0,1,1, 0,0,1,0,
					1,0,1,0, 1,0,1,0,
				],16),
				Pseq([
					1,0,0,1, 0,0,1,0,
				],16*4),
			],inf).coin.not,
			\lpfr, 1.1 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
			\rq, 0.1 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
			\sustain, 0.05,
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
			\dur, 1/4,
			\gain, 1/2,
			\gain, 1/2 * Pswitch1(
				Pseg(Prand([0,0.5,0.2,0.8,1],inf),8) ! 4,
				Pseq([0,1,2,3],inf)
			),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\speed, Pseg(Prand((1..8)/19 + 1.3,inf),8),
			\dur, 1/16,
			\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
			\amp, 0.1,
		)),
		//Pbind(
		//	\instrument, \bizar,
		//	\freq, 200 * Pseg(Prand([3,1,2,1]/0.814,inf),8),
		//	\fold, 1 * Pseg(Prand([3,1,2,1]/1.814,inf),8),
		//	\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
		//	\dur, 1/8,
		//	\amp, 0.1
		//),
		//Ppar(
		//	{Pbind(
		//		\instrument, \bizar2,
		//		\freq, 200 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
		//		\diff, 0.001 * Pseg(Prand([100,3,1,2,1]/0.814,inf),16),
		//		\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),16),
		//		\lpfr, 4 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
		//		\rq, 1 * Pseg(Prand([0.01,0.5,0.2,0.81],inf),8),
		//		\amdetune, 0.01 * Pseg(Prand([0.01,0.5,0.2,0.81],inf),8),
		//		\isRest, Pseq([
		//			Pseq({[
		//			1,1,1,1, 1,1,1,1,
		//			1,0,1,0, 1,0,1,0,
		//			1,0,0,0, 1,0,0,0,
		//			0,0,1,0, 0,0,1,0,
		//			].clump(4).choose}.dup(8).flat,inf)
		//		],inf).coin.not,
		//		\dur, 1/[8,4,16,1,2].choose,
		//		\amp, 0.1/4,
		//	)} ! 4,
		//),
		//Pbind(
		//	\isRest, Pstep(Pseq([
		//		Prand([
		//			Pseq([ 1,0,1,0, ],1),
		//			Pseq([ 1,1,0,0, ],1),
		//			Pseq([ 0,0,1,1, ],1),
		//		],inf),
		//	],inf),1).coin.not,
		//) <>
		Pbind(
			\instrument, \bizar3,
			\tsustain, 4,
			//\freq, Pwhite(100,1000.0,inf).stutter(Prand([8,4,2,16],inf)),
			\degree, Pwhite(0,12,inf).stutter(Prand([8,4,2,16],inf)),
			\detune, Pseg(Pseq([0,1000],inf),8),
			\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
			\amp, 0.1/8,
			\amp, Pkey(\amp) * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
		) ! 4,
		//Pbind(
		//	\instrument, \bizar2,
		//	\tsustain, 4,
		//	//\freq, Pwhite(100,1000.0,inf).stutter(Prand([8,4,2,16],inf)),
		//	\degree, Pwhite(-12,12,inf).stutter(Prand([8,4,2,16],inf)),
		//	\isRest, Pstep(Pseq([
		//			Pseq([ 1,0,1,0, ],1),
		//	],inf),1).coin.not,
		//	\detune, Pseg(Pseq([0,1000],inf),8),
		//	\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
		//	\amp, 0.1/4,
		//),
		//Pbind(
		//	\instrument, \bizar2,
		//	\tsustain, 4,
		//	\freq, Pwhite(100,1000.0,inf).stutter(Prand([8,4,2,16],inf)),
		//	//\degree, Pwhite(0,12,inf).stutter(Prand([8,4,2,16],inf)),
		//	\isRest, Pstep(Pseq([
		//			Pseq([ 0,1,0,1, ],1),
		//	],inf),1).coin.not,
		//	//\detune, Pseg(Pseq([0,1000],inf),8),
		//	\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
		//	\amp, 0.1/4,
		//),
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
);

(
Pdef(\drums_p1, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.31,
			\dur, 1/4,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\instrument, \playersec_fx,
			\kitIndex, 4,
			//\pos, 0,
			\amplfo, 4*~t,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 1.9,
			\dur, 1/2,
			\amp, 0.1,
		)),
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
		Pbind(
			\instrument, \trabass,
			\octave, 3,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\lpfr, 1.1 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
			\sustain, 0.65,
			\dur, 1/2,
			\amp, 0.1
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				1,0.5,1,0.5,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1/2,
			\speed, Pseq([0.2,0.15,0.8,0.27],inf).stutter(1),
			\dur, 1/4,
			\gain, 1/2,
			\gain, 1/2 * Pswitch1(
				Pseg(Prand([0,0.5,0.2,0.8,1],inf),8) ! 4,
				Pseq([0,1,2,3],inf)
			),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\speed, Pseg(Prand((1..8)/19 + 1.3,inf),8),
			\dur, 1/16,
			\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
			\amp, 0.1,
		)),
		//Pbind(
		//	\instrument, \bizar,
		//	\freq, 200 * Pseg(Prand([3,1,2,1]/0.814,inf),8),
		//	\fold, 1 * Pseg(Prand([3,1,2,1]/1.814,inf),8),
		//	\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
		//	\dur, 1/8,
		//	\amp, 0.1
		//),
		//Ppar(
		//	{Pbind(
		//		\instrument, \bizar2,
		//		\freq, 200 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
		//		\diff, 0.001 * Pseg(Prand([100,3,1,2,1]/0.814,inf),16),
		//		\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),16),
		//		\lpfr, 4 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
		//		\rq, 1 * Pseg(Prand([0.01,0.5,0.2,0.81],inf),8),
		//		\amdetune, 0.01 * Pseg(Prand([0.01,0.5,0.2,0.81],inf),8),
		//		\isRest, Pseq([
		//			Pseq({[
		//			1,1,1,1, 1,1,1,1,
		//			1,0,1,0, 1,0,1,0,
		//			1,0,0,0, 1,0,0,0,
		//			0,0,1,0, 0,0,1,0,
		//			].clump(4).choose}.dup(8).flat,inf)
		//		],inf).coin.not,
		//		\dur, 1/[8,4,16,1,2].choose,
		//		\amp, 0.1/4,
		//	)} ! 4,
		//),
		//Pbind(
		//	\isRest, Pstep(Pseq([
		//		Prand([
		//			Pseq([ 1,0,1,0, ],1),
		//			Pseq([ 1,1,0,0, ],1),
		//			Pseq([ 0,0,1,1, ],1),
		//		],inf),
		//	],inf),1).coin.not,
		//) <>
		Pbind(
			\instrument, \bizar2,
			\tsustain, 4,
			//\freq, Pwhite(100,1000.0,inf).stutter(Prand([8,4,2,16],inf)),
			\degree, Pwhite(0,12,inf).stutter(Prand([8,4,2,16],inf)),
			\detune, Pseg(Pseq([0,1000],inf),8),
			\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
			\amp, 0.1/8,
			\amp, Pkey(\amp) * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
		) ! 4,
		//Pbind(
		//	\instrument, \bizar2,
		//	\tsustain, 4,
		//	//\freq, Pwhite(100,1000.0,inf).stutter(Prand([8,4,2,16],inf)),
		//	\degree, Pwhite(-12,12,inf).stutter(Prand([8,4,2,16],inf)),
		//	\isRest, Pstep(Pseq([
		//			Pseq([ 1,0,1,0, ],1),
		//	],inf),1).coin.not,
		//	\detune, Pseg(Pseq([0,1000],inf),8),
		//	\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
		//	\amp, 0.1/4,
		//),
		//Pbind(
		//	\instrument, \bizar2,
		//	\tsustain, 4,
		//	\freq, Pwhite(100,1000.0,inf).stutter(Prand([8,4,2,16],inf)),
		//	//\degree, Pwhite(0,12,inf).stutter(Prand([8,4,2,16],inf)),
		//	\isRest, Pstep(Pseq([
		//			Pseq([ 0,1,0,1, ],1),
		//	],inf),1).coin.not,
		//	//\detune, Pseg(Pseq([0,1000],inf),8),
		//	\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
		//	\amp, 0.1/4,
		//),
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
);


{Mix.new([Pulse.ar([30, 60], SinOsc.ar([0.03, 0.11], mul: 1.5), mul: 0.3), SinOsc.ar(15, mul:{LeakDC.ar(LFDNoise0.ar([rrand(0.1, 10), rrand(0.1, 10)]))}), Pulse.ar([3000, 6000], SinOsc.ar([0.03, 0.11], mul: 1.5), mul: 0.3), SinOsc.ar(3000, mul:{LeakDC.ar(LFDNoise0.ar([rrand(0.1, 5), rrand(0.1, 5)]))})]) !2 }.scope;
