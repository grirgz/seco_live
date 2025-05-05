TrackDef('bla', TrackTemplateDef(\TrackList));
TrackDef('bla').presetCompileStringSavePath = FileSystemProject.nowExecutingFolder;



TrackDef('bla').addResource(*[ TrackDef('hihi1'), Pdef('metronome') ]);


TrackDef('bla').loadPresetCompileString;
