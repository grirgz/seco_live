
TrackDef(\bla, \CustomTrackList)
TrackDef(\bla).edit
TrackDef(\bla).presetCompileString = 
TrackDef(\bla).presetCompileString.editorInsert
TrackDef(\bla).savePresetCompileString
TrackDef(\bla).loadedFromPath 
FileSystemProject.resolve("tests/tmp")
(
TrackDef('bla', TrackTemplateDef(\CustomTrackList));
TrackDef('bla').presetCompileStringSavePath = PathName(thisProcess.nowExecutingPath).pathOnly;
TrackDef('bla').presetCompileStringSavePath = FileSystemProject.resolve("repeat/tests/tmp").fullPath +/+ "TrackDef_bla"



TrackDef('bla').loadPresetCompileString;

);

Pdef('NoteTimelineTrack.0.instr').asParamGroup.getSetCompileString
PlayerWrapper(Pdef('NoteTimelineTrack.0.instr')).presetCompileString
Pdef('NoteTimelineTrack.0.instr').presetCompileString
