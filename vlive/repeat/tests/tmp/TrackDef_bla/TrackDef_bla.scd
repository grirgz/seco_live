TrackDef('bla', TrackTemplateDef(\CustomTrackList));
TrackDef('bla').presetCompileStringSavePath = PathName(thisProcess.nowExecutingPath).pathOnly;



TrackDef('bla').loadPresetCompileString;
