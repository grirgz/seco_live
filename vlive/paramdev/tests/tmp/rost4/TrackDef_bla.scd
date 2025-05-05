TrackDef('bla', TrackTemplateDef(\TrackList));
TrackDef('bla').presetCompileStringSavePath = FileSystemProject.nowExecutingFolder;



TrackDef('bla').addResource(*IdentitySet[ TrackTimeline('bla') ]);


TrackDef('bla').loadPresetCompileString;
