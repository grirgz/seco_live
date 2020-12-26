
~t = 185/4/60; TempoClock.default.tempo = ~t;


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bilin,
			\note, Prand([
				6,8,
				6,8,\r,
				6,8,\r,
				10,11
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				Pseq( (1..12).mirror1 ),
			],inf),
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pspawner({ arg sp;
	   
			loop {
				sp.par(Pbind(
					\instrument, \default,
					\note, Pseq([
						Pseq((0..5).collect({ arg x; x + ( ( (1..5).choose-3 ) * 12 ) }).scramble-2),
					],inf),
					\dur, 1/4,
					\lag, ( 1/4 ).rand,
					\amp, 0.1,
				));
				1.wait;
			}
		})
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pspawner({ arg sp;
	   
			loop {
				sp.par(Pbind(
					\instrument, \default,
					\note, Pseq([
						Pseq((0..5).scramble-2 + ( (1..15).choose-7 )),
					],inf),
					\dur, 1/4,
					\lag, ( 1/4 ).rand,
					\amp, 0.1,
				));
				1.wait;
			}
		})
		
	])
)).play;
);
