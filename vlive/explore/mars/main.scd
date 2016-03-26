

(
Pdef(\part1_dry, Ppar([
	Pdef(\kick),
	Pdef(\snare),
	Pdef(\snarehat),
	Pdef(\hat),
].collect({ arg x; Pbind(\dur, Pkey(\dur) * 1, \out, 0) <> x }))).play;
)

(
Pdef(\part1_wet, Ppar([
	Pdef(\kick),
	Pdef(\snare),
	Pdef(\snarehat),
	Pdef(\hat),
].collect({ arg x; Pbind(\dur, Pkey(\dur) * 1, \out, BusDef(\fx1, \audio)) <> x }))).play;
)

(
Pdef(\part2_wet, Ppar([
	Pdef(\kick_var2),
	Pdef(\snare_var2),
	Pdef(\snarehat_var2),
	Pdef(\hat_var2),
].collect({ arg x; Pbind(\dur, Pkey(\dur) * 1, \out, BusDef(\fx1, \audio)) <> x }))).play;
);

(
Pdef(\part2_dry, Ppar([
	Pdef(\kick_var2),
	Pdef(\snare_var2),
	Pdef(\snarehat_var2),
	Pdef(\hat_var2),
].collect({ arg x; Pbind(\dur, Pkey(\dur) * 1, \out, Pkeyd(\out,0)) <> x }))).play;
);

(
Pdef(\part3_dry, Ppar([
	Pbind( \isRest, Pseq([
		1,0,1,0, 1,0,1,0,
	],inf).coin.not ) <> Pdef(\kick_var2),
	//Pdef(\snare_var2),
	//Pdef(\snarehat_var2),
	//Pdef(\hat_var2),
].collect({ arg x; Pbind(\dur, Pkey(\dur) * 1, \out, 0) <> x })));
);

(
Pdef(\part3_wet, Ppar([
	Pbind( \isRest, Pseq([
		1,0,1,0, 1,0,1,0,
	],inf).coin.not ) <> Pdef(\kick_var2),
	//Pdef(\snare_var2),
	//Pdef(\snarehat_var2),
	//Pdef(\hat_var2),
].collect({ arg x; Pbind(\dur, Pkey(\dur) * 1, \out, BusDef(\fx1)) <> x })));
);

Pdef(\part1).stop;
Pdef(\part2).stop;

RandDelayNetwork(\default).make(\fx1, "5--", BusDef(\fx1, \audio));
Ndef(\fx1).play;
Ndef(\fx1).edit;
RandDelayNetwork(\default).make(\fx1, "5-T1KJ-J6JA5", BusDef(\fx1, \audio)); // cool distobass


/////////////:
(
Pdef(\part2_dry, Ppar([
	Pdef(\kick_var2),
	Pbind(\out, BusDef(\fx1)) <> Pdef(\snare_var2),
	Pdef(\snarehat_var2),
	Pdef(\hat_var2),
].collect({ arg x; Pbind(\dur, Pkey(\dur) * 1, \out, Pkeyd(\out,0)) <> x }))).play;
);
