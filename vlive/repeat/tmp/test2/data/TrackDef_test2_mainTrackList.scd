TrackDef('test2_mainTrackList', TrackTemplateDef(\TrackList));
TrackDef('test2_mainTrackList').presetCompileStringSavePath = PathName(thisProcess.nowExecutingPath).pathOnly;
TrackDef('test2_mainTrackList').loadPresetCompileString;
