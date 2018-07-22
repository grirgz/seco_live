

///////////////// multiply or divise dur and freq by the naturals
(
	Pdef(\durserie, Ppar(
		8.collect({ arg x;
			Pbind(
				\instrument, \default,
				\freq, 200 * (x+1),
				\sustain, 0.1,
				\dur, 1/(x+1) * 2,
				\amp, 0.1
			);
		})
	)).play;
);
(
	Pdef(\durserie, Ppar(
		8.collect({ arg x;
			Pbind(
				\instrument, \default,
				\freq, 200 * (x+1),
				\sustain, 0.1,
				\dur, 1/8 * (x+1),
				\amp, 0.1
			);
		})
	)).play;
);

(
	Pdef(\durserie, Ppar(
		8.collect({ arg x;
			Pbind(
				\instrument, \default,
				\freq, 3200 / (x+1),
				\sustain, 0.1,
				\dur, 1/8 * (x+1),
				\amp, 0.1
			);
		})
	)).play;
);

(
	Pdef(\durserie, Ppar(
		8.collect({ arg x;
			Pbind(
				\instrument, \default,
				\freq, 3200 / (x+1),
				\sustain, 0.1,
				\dur, 2 / (x+1),
				\amp, 0.1
			);
		})
	)).play;
);

///////////////// add or substract dur and freq by the naturals
// which is equivalent of adding some offset to the previous method
(
	Pdef(\durserie, Ppar(
		8.collect({ arg x;
			Pbind(
				\instrument, \default,
				\freq, 200 + (x+1*200),
				\sustain, 0.1,
				\dur, 1/4+(x/16),
				\amp, 0.1
			);
		})
	)).play;
);


/////////////// with midinote

(
	Pdef(\durserie, Ppar(
		8.collect({ arg x;
			Pbind(
				\instrument, \default,
				\midinote, 70 - (x*2+1),
				\sustain, 0.1,
				\dur, 1/8 * (x+1),
				\amp, 0.1
			);
		})
	)).play;
);


////////////// with perc

(
Pdef(\durserie, Pdef(\zed, 
	Ppar(
		[5,1,2,8,6].collect { arg pos, x;
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, pos,
				\sustain, 0.1,
				\dur, 1/8 * (x+1),
			));
		}
	)
)).play;
)

(
Pdef(\durserie, Pdef(\zed, 
	Ppar(
		[5,1,2,8,6].collect { arg pos, x;
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, pos,
				\isRest, Pseq([
					1, Pseq([0],( 6-x+1 ).abs),
				],inf).coin.not,
				\sustain, 0.1,
				\speed, rrand(0.8,1.2),
				\dur, 1/8 * (x+1)/4,
			));
		}
	)
)).play;
)


(
Pdef(\durserie, Pdef(\zed, 
	Ppar(
		[5,1,2,8,6].collect { arg pos, x;
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, pos,
				\sustain, 0.1,
				\dur, ( 1/8 * x )+1/4,
			));
		}
	)
)).play;
)


(
Pdef(\durserie, Pdef(\zed, 
	Ppar([
		Ppar(
			8.collect({ arg x;
				Pbind(
					\instrument, \default,
					\freq, 2200 / (x+1) / Pseq([1,2,3],inf),
					\sustain, 0.1,
					\dur, 1/8 * (x+1),
					\amp, 0.1
				);
			})
		),
		Ppar(
			[5,1,2,8,6,0].collect { arg pos, x;
				PatKitDef(\rim).asPattern(Pbind(
					\kitIndex, pos,
					\sustain, 0.1,
					\dur, 1/8 * (x+2),
				));
			}
		)
	]),
)).play;
)


(
Pdef(\durserie, Pdef(\zed, 
	Ppar([
		Ppar(
			8.collect({ arg x;
				Pbind(
					\instrument, \default,
					\freq, 500 + (x*100* Pseq([1,2,3,4,5],inf)),
					\sustain, 0.1,
					\dur, 1/8 * (x+1),
					\amp, 0.1
				);
			})
		),
		Ppar(
			[5,1,2,8,6,0].collect { arg pos, x;
				PatKitDef(\rim).asPattern(Pbind(
					\kitIndex, pos,
					\sustain, 0.1,
					\dur, 1/8 * (x+2),
				));
			}
		)
	]),
)).play;
)
