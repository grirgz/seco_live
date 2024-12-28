
FileSystemProject.load("libdef/CustomTrackList.scd");
ParamProto.init(true)
ParamProto.init
TrackDef(\bla3, \TrackList)
TrackDef(\bla3).editGrid
TrackDef(\bla3).edit
TrackDef(\bla).presetCompileStringSavePath = "~/tmp/bla".standardizePath
TrackDef(\bla).loadPresetCompileString
WindowDef.trace = true
~playerviews.first.first.model.parentTrack

WindowDef(\bla)
(
WindowDef(\win, { arg def;
	SampleChooserView.new.view
}).front;
)
NoteTimeline(\ba).edit
(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

Pdef(\zed).edit
FileSystemProject.load("libdef/PbindefEditor.scd");
FileSystemProject.load("libdef/ModulatorRack.scd");
ParamViewToolBox.color_TextField_disabled = Color.grey(0.5)
TrackDef(\bla).presetCompileString
TrackDef(\bla).presetCompileString.editorInsert
TrackDef(\bla).savePresetCompileStringDialog
TrackDef(\bla).savePresetCompileString
TrackDef(\bla).clear
TrackDef(\bla).childAt(0).mixer.muteBySolo(false)
TrackDef(\bla).loadedFromPath 
TrackDef(\bla).childAt(1).scorePresetCompileString
FileSystemProject.resolve("tests/tmp")
(
TrackDef('bla', TrackTemplateDef(\CustomTrackList));
TrackDef('bla').presetCompileStringSavePath = PathName(thisProcess.nowExecutingPath).pathOnly;
TrackDef('bla').presetCompileStringSavePath = FileSystemProject.resolve("repeat/tests/tmp").fullPath +/+ "TrackDef_bla"



TrackDef('bla').loadPresetCompileString;

);

TrackDef('bla').childAt(0).score.asCompileString
PlayerWrapper(TrackDef('bla').childAt(0).score).presetCompileString
WindowDef(\PbindefEditor).proto[\presetCompileString].asCompileString

Pdef('NoteTimelineTrack.0.instr').asParamGroup.getSetCompileString
PlayerWrapper(Pdef('NoteTimelineTrack.0.instr')).presetCompileString
Pdef('NoteTimelineTrack.0.instr').presetCompileString

(
Pdef(\test, 
	Pbind(
		\instrument, \default,
		\degree, Pseq((0,2..30),inf),
		\octave, 3,
		\dur, 1,
		\amp, 0.1,
	)
);

Pdef(\test2, 
	Pbind(
		\instrument, \saw,
		\note, Pseq([5,4,3,5,4,Pwhite(0,5,3)],inf),
		\octave, 4,
		\dur, 1,
		\amp, 0.1,
	)
);
);
Pbindef(\test).edit
Pdef(\test).edit
Pdef(\test).set(\amp,0.2)

Pbindef(\test, \legato, 0.4)

ParamGroup.getPbindefCompileString(Pbindef(\test))
ParamGroup.getPbindefCompileString(Pdef(\test2))
ParamGroup.getPdefCompileString(Pdef(\test2))
Pbindef(\test).asCompileString
NoteTimeline(\bla).edit
ClipTimeline(\sdf).edit
ClipTimeline(\sdf).presetCompileString
ClipTimeline(\sdf).refCompileString


WindowDef(\win, { arg def;
	VLayout (
		TextField.new.string_("12"),
		TextField.new.string_("2").stringColor_(Color.grey),
	)
	
}).front;
~params[2].isSet
~params[2].wrapper


KitTimeline(\bla).edit
FileSystemProject.load("capsule/PatKitDef_comkit.scd");


(
Pdef(\full, Pdef(\bla, Pbind()) <> Pdef(\base, Pbind(\instrument, \saw)))
)

Pdef(\full).play
Param(Pdef(\bla), \freq).edit

(
Pdef(\xxx, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

Pdef(\xxx).set(\lpfr, 2)

~p = Pdef(\az) <> Pdef(\bz)
~p.class.dumpMethodList
Pchain
Param(~p.patterns.first, \lpfr).edit


FileSystemProject.loadOnce("libdef/tracks.scd");
FileSystemProject.loadOnce("libdef/drumkit.scd");
FileSystemProject.loadOnce("libdef/synthplayrec.scd");
FileSystemProject.loadOnce("libdef/MainProject.scd");

FileSystemProject.loadOnce("libdef/soundfileview.scd");
FileSystemProject.loadOnce("libdef/tracklist_buildertrack.scd");
FileSystemProject.loadOnce("libdef/default_specs.scd");
