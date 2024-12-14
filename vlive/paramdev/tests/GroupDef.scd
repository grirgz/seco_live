
GroupDef(\hello)
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \default,
			\degree, Pseq([0],inf),
			\group, GroupDef.pattern(\hello),
			\dur, 1,
			\amp, 0.1,
		)
	])
)).play;
);
(
Pdef(\zed, 
).play;
);

(
Pdef(\part2, Pdef(\zedpsdsdart, 
	Ppar([
		
		Pbind(
			\instrument, \default,
			\degree, Pseq([3],inf),
			\group, GroupDef.pattern(\hello),
			\dur, 1,
			\amp, 0.1,
		)
	])
)).play;
);
