
(
	s.waitForBoot {
		
		//~t = 235/4/60;

		//~t = 185/4/60; TempoClock.default.tempo = ~t;//orig
		~t = 185/4/60; TempoClock.default.tempo = ~t;
		Ndef.defaultQuant = 4;
		Pdef.defaultQuant = 4;
		
FileSystemProject.load("ex3/lib.scd");
FileSystemProject.load("libdef/piano.scd");
//FileSystemProject.load("ex3/barlokkit.scd");
FileSystemProject.load("algokit/samplersynth.scd");
FileSystemProject.load("algokit/synthdefs.scd");
FileSystemProject.load("algokit/libfun.scd");
FileSystemProject.load("algokit/flow/kitlib.scd");
FileSystemProject.load("algokit/pmodenv.scd");
FileSystemProject.load("algokit/PatKitDef_algokit.scd");
FileSystemProject.load("algokit/PatKitDef_scapkit.scd");
FileSystemProject.load("algokit/kits/PatKitDef_drumwork.scd");
FileSystemProject.load("algokit/kits/PatKitDef_sample1.scd");
FileSystemProject.load("algokit/kits/PatKitDef_kitsec.scd");
FileSystemProject.load("algokit/gen.scd");
FileSystemProject.load("algokit/patlist.scd");
FileSystemProject.load("algokit/kitlib.scd");
FileSystemProject.load("algokit/scorelib.scd");
FileSystemProject.load("algokit/patterns.scd");
FileSystemProject.load("algokit/grid.scd");
	};
)

// END

ProtoDef(\piano).startControl(Pdef(\melo))

Pdef(\algo2, PdrumStep(PatKitDef(\algokit).targets, Pdef(\algo2_p3), 1, key:\kitIndex)).play
KitTimeline(\algo2,PatKitDef(\algokit)).eventList = XEventList.newFrom(Pdef(\algo2_p3));
KitTimeline(\algo2).edit;
PatKitDef(\algokit).edit

Pdef(\algo2, PdrumStep(PatKitDef(\algokit).targets, Pdef(\algo2_p4), 1, key:\kitIndex)).play
Pdef(\algo2, PdrumStep(PatKitDef(\algokit).targets, Pdef(\algo2_p5), 1, key:\kitIndex)).play

(
~set = ~generate_set.(Pdef(\algo2_p3), 8);
//~sort_cells_by_rest.(~set);
~sort_rows_by_rest.(~set);
~monogrid = ~generate_monogrid.(~set);
TrackDef(\algogrid_0).clear;
TrackDef(\algogrid_0, TrackTemplateDef(\playergrid));
TrackDef(\algogrid_0).source = ~monogrid;
"DONE".debug;
)
TrackDef(\algogrid_0).activate
