TrackDef('test3_mainTrackList', TrackTemplateDef(\TrackList));
TrackDef('test3_mainTrackList').presetCompileStringSavePath = PathName(thisProcess.nowExecutingPath).pathOnly;



TrackDef('test3_mainTrackList').loadPresetCompileString;
