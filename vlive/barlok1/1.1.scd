
//// intro
(
TempoClock.default.tempo = 190/60;
~defaultQuant = 4;
Pdef.defaultQuant = ~defaultQuant;
Ndef.defaultQuant = ~defaultQuant;
~t = TempoClock.default.tempo;
Ndef(\myfx1).play;
//Tdef(\fx, {
//	"sec intro".postln;
//	inf.do {
//		Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo3));
//		RandDelayNetwork(\default).make(\myfx1, "4-1aw9-t5ta", BusDef(\fx1)); // clock + fxzoo3
//		24.wait;
//		Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
//		RandDelayNetwork(\default).make(\myfx1, "5-11e2-5bta", BusDef(\fx1)); // slow rise
//		8.wait;
//	}
//}).play;
//Pdef(~name, Pdef(\perc_p2));
Pdef(~name,

	Pseq([
		Pfindur(32,
		Pseq([
			Ptask({
				Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo3));
				RandDelayNetwork(\default).make(\myfx1, "4-1aw9-t5ta", BusDef(\fx1)); // clock + fxzoo3
				24.wait;
				Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
				RandDelayNetwork(\default).make(\myfx1, "5-11e2-5bta", BusDef(\fx1)); // slow rise
				8.wait;
			}),
			Pdef(\perc_p2),
		]))
	],inf),
).play;
)

// END

Pdef(\perc_p2).play;
Ndef(\myfx1).play;
Ndef(\myfx1).edit
	Ndef(\myfx1).put(100, nil);
