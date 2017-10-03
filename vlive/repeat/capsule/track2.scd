
(
	~master.();
Pdef(\track2_idea, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,1, 0,1,1,0,
				1,1,1,0, 1,0,1,1,
				0,0,1,0, 0,1,1,0,
				0,1,0,0, 1,0,1,0,
				1,0,1,1, 0,1,1,0,
				1,1,1,0, 1,0,1,1,
			],inf).coin.not,
			\pos, Pseq([
				Pseg(Pseq([0.04,0.04,1],inf),Pseq([1,3,0],inf)),
			],inf),
			\sustain, 0.1,
			\dur, 1/16,
			\amp, 0.1,
		)),
		Pdef(\bass) <> Pbind(
			\instrument, \distbass,
			\freq, 70 * Pseq([
				2,5/4,4/3,1,
				2,5/4,4/3,1,
				2,5/4,4/3,1,
				2,5/4,4/3, Pwhite(1,3.0,1),
				Pser([
					\r
				],16),
			]+0.5,inf),
			\lag, Pseq([0,Pwhite(0.0,0.2,3)],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
).play;
)
