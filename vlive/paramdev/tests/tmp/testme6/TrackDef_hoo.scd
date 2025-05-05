TrackDef('hoo', TrackTemplateDef(\PlayerGrid));
TrackDef('hoo').presetCompileStringSavePath = PathName(thisProcess.nowExecutingPath).pathOnly;



TrackDef('hoo').source = SparseArray[ SparseArray[ Pdef('metronome') ], SparseArray[  ], SparseArray[  ], SparseArray[  ], SparseArray[  ], SparseArray[  ], SparseArray[  ], SparseArray[  ], SparseArray[  ] ];


TrackDef('hoo').loadPresetCompileString;
