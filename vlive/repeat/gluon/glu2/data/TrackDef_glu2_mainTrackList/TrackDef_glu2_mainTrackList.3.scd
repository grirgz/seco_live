TrackDef('glu2_mainTrackList').childAt(3).trackTemplate = TrackTemplateDef('NoteTimelineTrack');
TrackDef('glu2_mainTrackList').childAt(3).label = "bass";


TrackDef('glu2_mainTrackList').childAt(3).source = Pdef('glu2_mainTrackList.3.instr');
Pbindef('glu2_mainTrackList.3.instr',
	'instrument', 'basspad',
	'amp', 0.070231919230481,
	'lpenv', [ Env([ 0.0, 1.0, 0.066345270890725, 0.0 ], [ 0.0267499950219, 0.073964216907666, 1.0 ], [ 3.0, 3.0, 3.0 ], 2.0) ],
);
Pdef('glu2_mainTrackList.3.instr').set(
	'lpenvamt', 'c8'
);

