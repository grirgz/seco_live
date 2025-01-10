///// NoteTimeline with automation

(
Pdef(\instr, 
	Pbind(
		\instrument, \saw,
	)
).play;
);

NoteTimeline(\bla, Pdef(\instr)).edit

///// PbindefEditor


FileSystemProject.load("libdef/ModulatorRack.scd");
FileSystemProject.load("cavern/ifxsimple.scd");
Pbindef(\test, \instrument, \saw).edit

Pdef(\test).play
Pdef(\test).play
TrackMixerDef(\Pbindef_test).edit
TrackDef(\ModulatorRack).edit


ClipTimeline(\myrec).edit

//// PianoCenter

FileSystemProject.load("paramdev/drafts/PianoCenter.scd");
ProtoDef(\PianoCenter).edit

//// FxTimeline

FileSystemProject.load("paramdev/drafts/FxTimeline.scd");
FileSystemProject.load("libdef/pmodenv.scd");
ProtoInst(\FxTimeline, \test).edit
