TrackDef('bla', TrackTemplateDef(\TrackList));
TrackDef('bla').presetCompileStringSavePath = FileSystemProject.nowExecutingFolder;



TrackDef('bla').addResource(*[ TrackDef('hihi1') ]);


TrackDef('bla').loadPresetCompileString;
