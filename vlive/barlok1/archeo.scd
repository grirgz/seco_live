(
	TempoClock.default.tempo = 190/60;
	Pdef.defaultQuant = 0;
	Ndef.defaultQuant = 0;
	Tdef.defaultQuant = 0;
	~t = TempoClock.default.tempo;
	s.waitForBoot {
		FileSystemProject.load("barlok1/archeolib.scd")
	};

)

Main.version
(
	Pdef(\main).stop;
	Ndef(\myfx1).play;
	Tdef(\fx).play;
	Pdef(\archeo).play;
)


// END

Pdef(\archeo).clear;
(
)
Tdef(\fx).quant
Tdef(\fx).quant = nil
Tdef(\fx).quant = [4, -0.1]
Tdef.defaultQuant = 0

( 6*32 )+128+( 6*32 )+( 2*32 ) /  190
6*32

Ndef(\myfx1).clear
Ndef(\myfx1).edit
Ndef(\myfx1).quant = 0;
(
~defaultQuant = 0;
Pdef.defaultQuant = ~defaultQuant;
Ndef.defaultQuant = ~defaultQuant;
Tdef.defaultQuant = ~defaultQuant;
)

Pdef(\kick).stop
Pdef(\main, Pbind(\dur, 8, \isRest, false)<> Pdef(\kick))

(
Ndef(\myfx1).play;
Pdef(\main, Pdef(\perc_scar2)).play;
)
(
Pdef(\main,
	Ppar([
		Pbind(\dur, 8, \isRest, false)<> Pdef(\kick),
		Pbind(\dur, 4, \isRest, Pseq([
			0,1
		],inf).coin.not)<> Pdef(\basicsnare),
	]),
)
)

Pdef(\hat).play
Pdef(\hat).clear
