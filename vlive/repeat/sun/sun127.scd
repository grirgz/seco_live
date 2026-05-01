
// try again using TrackList CodeFileTrack and controller


(
~t = 127/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("libdef/CodeFileTrack.scd");
)

FileSystemProject("sun/sun127").open;
FileSystemProject("sun/sun127").close
FileSystemProject("sun/sun127").saveProject;
//FileSystemProject.current.addResource(TrackDef(\hey, \CodeFileGrid))
TrackDef(\hey).edit
ProtoDef(\apc40).startControl(TrackDef(\hey))

(
Pdef(\part, Pdef(\testme, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);
