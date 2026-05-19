
(
Pdef(\part, Pdef(\pp, 
	Pdpar([
		bass: Pbind(
			\instrument, \default,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		kick: Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\comp, \audio),
		),
		comp: Pmono(\simplecomp,
			\inbus, BusDef(\comp, \audio),
			\cpt, 0.01,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdparf(Pdef(\pp), [
			bass: Pbind(\amp, Pkey(\amp) * 2),
			out: BusDef(\myfx),

		])
	])
)).play;
);

Plet
(
~fun = { arg x ...aa;
	[x, aa].debug("kj");
}
)
~fun.([ az:1,er:2 ]) // ok
~fun.( az:1,er:2 )
