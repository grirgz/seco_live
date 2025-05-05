TrackDef('bla', TrackTemplateDef(\TrackList));
TrackDef('bla').presetCompileStringSavePath = PathName(thisProcess.nowExecutingPath).pathOnly;



TrackDef('bla').addResource(*[ TrackTimeline('bla'), TrackTimeline('bla') ]);


TrackDef('bla').loadPresetCompileString;
