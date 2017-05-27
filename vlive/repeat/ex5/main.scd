
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
FileSystemProject.load("algokit/patlist.scd");
FileSystemProject.load("algokit/kitlib.scd");
FileSystemProject.load("algokit/scorelib.scd");
FileSystemProject.load("algokit/patterns.scd");
FileSystemProject.load("algokit/grid.scd");
	};
)
