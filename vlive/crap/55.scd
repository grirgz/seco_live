

BufDef(\scream, "vipere/scream.flac");
BufDef.mono(\scream, "vipere/scream.flac");

(
Pdef(\plopx, Pbind(
	\instrument, \stereosampler,
	\pos, 0.8,
	\speed, 1.0/2,
	\bufnum, BufDef(\scream),
	\dur, 1,
	\amp, 0.1
)).play;
);

(
Pdef(\plopx, Pbind(
	\instrument, \zegrainer2,
	\pos, 0.25,
	\time_stretch, 0.41,
	\speed, 1.0,
	\pitch_stretch, 1,
	\mbufnum, BufDef.mono(\scream),
	\dur, 4,
	\legato, 1.2,
	\amp, 0.1
)).play;
);

(
Pdef(\plopx, Pbind(
	\instrument, \zegrainer2,
	\pos, 0.25 + Pwhite(0,0.2),
	\time_stretch, 0.11 + Pwhite(0,0.5),
	\speed, 1.0,
	\pitch_stretch, 1 * Pwhite(0.4,2.2),
	\mbufnum, BufDef.mono(\scream),
	\dur, 1/8,
	\legato, 0.7,
	\amp, 0.1
)).play;
);

(
Pdef(\plopx, 
	
	Pseq([
		Pfindur(4, Pbind(\dur, 1/1)),
		Pfindur(4, Pbind(\dur, 1/2)),
		Pfindur(4, Pbind(\dur, 1/4)),
		Pfindur(4, Pbind(\dur, 1/8)),
	]) <>
	Pbind(
		\instrument, \zegrainer2,
		\pos, 0.25 + Pwhite(0,0.2),
		\pos, 0.60 + Pseq([0.01,0.01,0.02,0.03],inf),
		\time_stretch, 0.11 + Pwhite(0,0.05),
		\speed, 1.0,
		\pitch_stretch, 1,
		\mbufnum, BufDef.mono(\scream),
		\dur, 1/8,
		\legato, 0.7,
		\amp, 0.1
	)
).play;
);
