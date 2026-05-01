TrackDef('sun127_mainTrackGrid', TrackTemplateDef(\PlayerGrid));
TrackDef('sun127_mainTrackGrid').presetCompileStringSavePath = FileSystemProject.nowExecutingFolder;



TrackDef('sun127_mainTrackGrid').source = SparseArray[ SparseArray[ Pdef('testme') ], SparseArray[  ], SparseArray[  ], SparseArray[  ], SparseArray[  ], SparseArray[  ], SparseArray[  ], SparseArray[  ], SparseArray[  ] ];


TrackDef('sun127_mainTrackGrid').loadPresetCompileString;
