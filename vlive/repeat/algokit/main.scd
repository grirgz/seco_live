
(
	s.waitForBoot {
		
		//~t = 235/4/60;

		//~t = 185/4/60; TempoClock.default.tempo = ~t;//orig
		~t = 185/4/60; TempoClock.default.tempo = ~t;
		Ndef.defaultQuant = 4;
		Pdef.defaultQuant = 4;
		
FileSystemProject.load("ex3/lib.scd");
//FileSystemProject.load("ex3/barlokkit.scd");
FileSystemProject.load("algokit/PatKitDef_algokit.scd");
FileSystemProject.load("algokit/gen.scd");
FileSystemProject.load("algokit/patterns.scd");
FileSystemProject.load("algokit/grid.scd");
	};
)

Pdef(\algo2, PdrumStep(PatKitDef(\algokit).targets, Pdef(\algo2_p3), 1, key:\kitIndex)).play
KitTimeline(\algo2,PatKitDef(\algokit)).eventList = XEventList.newFrom(Pdef(\algo2_p3));
KitTimeline(\algo2).edit;

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
