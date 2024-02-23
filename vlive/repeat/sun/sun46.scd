// ver2

~t = 92/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("holis/synthdef.scd");



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\degree, Pseq([
				//4, 
				//0,1,2,3,4
				//4, 1, 4,
				0, 4, 1, 4,
			],inf),
			\ctranspose, Pseq([
				2
			],inf),
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\melo, 

		Pbind(
			\instrument, \basicbass,
			\lpf, 5000,
			\amp, 0.05,
		),
);
)
ProtoDef(\piano).startControl(Pdef(\melo))
