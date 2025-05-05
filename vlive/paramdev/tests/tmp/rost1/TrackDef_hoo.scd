TrackDef('hoo', TrackTemplateDef(\PlayerGrid));
TrackDef('hoo').presetCompileStringSavePath = FileSystemProject.nowExecutingFolder;



TrackDef('hoo').source = SparseArray[ SparseArray[ Pdef('metronome') ], SparseArray[ TrackDef('bla') ], SparseArray[  ], SparseArray[  ], SparseArray[  ], SparseArray[  ], SparseArray[  ], SparseArray[  ], SparseArray[  ] ];


TrackDef('hoo').loadPresetCompileString;
