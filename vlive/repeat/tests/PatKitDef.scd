
(
WindowDef(\win, { arg def;
	Param({ arg x, v; x.postln;  }, { 1 }).asSlider;
}).front;
);
	Param({ Pbindef(\bla).source.at(\freq).source }, { arg p, v; Pbindef(\bla, \freq, p) }).get
	Param({ Pbindef(\bla).source.at(\freq).source }, { arg v, p; Pbindef(\bla).source.at(\freq).source = v }).edit
	(
	Pbindef(\bla,
		\freq, 100,
		\dur, 1/4,
	
	).play;
	)
	Pdef(\bla).quant=8;
	Pdef(\bla).source.at(\freq).quant = 0
	Pdef(\bla).clear

	Pbindef(\bla)
	Pdef(\bla).source

PatKitDef(\bla).edit
FileSystemProject.load("libdef/drumkit.scd")
