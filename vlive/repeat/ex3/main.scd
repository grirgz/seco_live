
// components:
// - drumkits - PatKitDef
//		- StreamPlayer
// - TrackDef grid
// 		- mixers
//		- PlayerWrapper
//		- TrackDef playerwrapper
// - recorder - ProtoDef(\recorder)
// - track recorder
// - sampler
// - rdn fx
// 		- rdn gui

// files
// - main.scd
// - lib.scd
// - projectlib.scd
// - projectfx.scd

(
	s.waitForBoot {
		
		//~t = 235/4/60;
		~t = 285/4/60;
		TempoClock.default.tempo = ~t;
		Ndef.defaultQuant = 4;
		Pdef.defaultQuant = 4;
		
FileSystemProject.load("ex3/lib.scd");
FileSystemProject.load("ex3/barlokkit.scd");
//FileSystemProject.load("ex3/zeldalib.scd");
//FileSystemProject.load("ex3/zeldafx.scd");
	};
)



// END
ParamProto.init(true)
