TrackDef('tlist', TrackTemplateDef(\TrackList));
TrackDef('tlist').presetCompileStringSavePath = PathName(thisProcess.nowExecutingPath).pathOnly;
TrackDef('tlist').loadPresetCompileString;
