
(
"htisworks!!".debug;
FileSystemProject.addPath("~/code/sc/seco/vlive/repeat/");
FileSystemProject(\proto1).open;
);

(
ParamProto.init;
MKtl(\lp, "novation-launchpad-s");
FileSystemProject(\proto1).load("perc.scd");
FileSystemProject(\proto1).load("tracks.scd");
FileSystemProject(\proto1).defaultQuant = 4;
FileSystemProject(\proto1).tempo = 80/60;
FileSystemProject(\proto1).edit = { TrackDef(\main).edit };
FileSystemProject(\proto1).activate = { TrackDef(\main).activate };
);

(
TrackDef(\main, TrackDef(\playergrid));
TrackDef(\main).childAt(0,0).source = Pdef(\kick);
TrackDef(\main).childAt(1,0).source = Pdef(\snare);
TrackDef(\main).childAt(2,0).source = Pdef(\hat);
TrackDef(\main).childAt(3,0).source = Pdef(\lide);
TrackDef(\main).childAt(4,0).source = Pdef(\hydro);
TrackDef(\main).childAt(4,1).source = Pdef('hydro.1');
TrackDef(\main).childAt(4,2).source = Pdef('hydro.2');
//TrackDef(\main).childAt((0..4)).collect(_.quant_(8));
TrackDef(\main).activate;
)


// END

TrackDef(\main).edit
ParamProto.init(true);
FileSystemProject(\proto1).edit
~trackTimeline.new(\tracks, TrackDef(\main)).edit

FileSystemProject(\proto1).isOpening
FileSystemProject(\proto1).isOpeningxx = 3
FileSystemProject(\proto1).isOpening = false 
FileSystemProject(\proto1).isOpening 
FileSystemProject.paths
FileSystemProject.resolve("~".standardizePath)
FileSystemProject.resolve("proto1")
FileSystemProject.cwd = "proto1"
FileSystemProject.cwd
FileSystemProject.defaultProject
FileSystemProject.load("init.scd")
FileSystemProject.addPath("~/")
PathName("/").exists
PathName("~").isAbsolutePath
PathName("~".standardizePath).isFile
PathName("~".standardizePath).isFolder
PathName("~".standardizePath).isAbsolutePath
PathName("~").isFolder

"~/".standardizePath
FileSystemProject

'/home'.addHalo(\isLoading, true)
