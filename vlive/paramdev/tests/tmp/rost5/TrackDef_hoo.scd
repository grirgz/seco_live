TrackDef('hoo', TrackTemplateDef(\PlayerGrid));
TrackDef('hoo').presetCompileStringSavePath = FileSystemProject.nowExecutingFolder;



TrackDef('hoo').source = SparseArray[ SparseArray[ Pdef('metronome') ], SparseArray[  ], SparseArray[  ], SparseArray[  ], SparseArray[  ], SparseArray[  ], SparseArray[  ], SparseArray[  ], SparseArray[  ] ];
TrackDef('hoo').addResource(*IdentitySet[ Pdef('metronome') ]);


TrackDef('hoo').loadPresetCompileString;
