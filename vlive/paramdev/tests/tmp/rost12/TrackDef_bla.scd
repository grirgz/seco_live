TrackDef('bla', TrackTemplateDef(\TrackList));
TrackDef('bla').presetCompileStringSavePath = FileSystemProject.nowExecutingFolder;



TrackDef('bla').addResource(*[ NoteTimeline('hello'), TrackDef('hihi1') ]);


TrackDef('bla').loadPresetCompileString;
