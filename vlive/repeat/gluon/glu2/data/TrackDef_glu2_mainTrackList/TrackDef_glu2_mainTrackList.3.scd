TrackDef('glu2_mainTrackList').childAt(3).trackTemplate = TrackTemplateDef('NoteTimelineTrack');
TrackDef('glu2_mainTrackList').childAt(3).label = "bass";


TrackDef('glu2_mainTrackList').childAt(3).source = Pdef('glu2_mainTrackList.3.instr');
Pbindef('glu2_mainTrackList.3.instr',
	'instrument', 'basspad',
);

