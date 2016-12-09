
//// intro
(
Ndef(\myfx1).play;
//Pdef(~name, Pdef(\perc_p2));
Pdef(~name,
	Pfindur(32,
		Pseq([
			Ptask({

		"sec part1".postln;
				Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
				RandDelayNetwork(\default).make(\myfx1, "6-gi1n-i413", BusDef(\fx1)); // bass
				24.wait;
				RandDelayNetwork(\default).make(\myfx1, "6-bzir-ugkl", BusDef(\fx1)); // calm
				4.wait;
				//RandDelayNetwork(\default).make(\myfx1, "5-41e2-5bta", BusDef(\fx1)); // feedback
				RandDelayNetwork(\default).make(\myfx1, "6-yzir-lual", BusDef(\fx1)); // bass disto
				4.wait;
			}),
			Pdef(\perc_scar2),
		])
	).loop
).play;
)

// END

Pdef(\perc_p2).play;
Ndef(\myfx1).play;
Ndef(\myfx1).edit
