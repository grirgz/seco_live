TrackDef('simpleProject_mainTrackList', TrackTemplateDef(\TrackList));
TrackDef('simpleProject_mainTrackList').presetCompileStringSavePath = PathName(thisProcess.nowExecutingPath).pathOnly;
TrackDef('simpleProject_mainTrackList').loadPresetCompileString;
