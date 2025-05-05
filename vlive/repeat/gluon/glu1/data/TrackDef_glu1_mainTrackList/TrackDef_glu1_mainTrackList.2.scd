TrackDef('glu1_mainTrackList').childAt(2).trackTemplate = TrackTemplateDef('NoteTimelineTrack');
TrackDef('glu1_mainTrackList').childAt(2).label = "chord";


TrackDef('glu1_mainTrackList').childAt(2).source = Pdef('glu1_mainTrackList.2.instr');
Pbindef('glu1_mainTrackList.2.instr',
	'instrument', 'snappad',
);

