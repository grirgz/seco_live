TrackDef('sun85_mainTrackList').childAt(5).trackTemplate = TrackTemplateDef('NoteTimelineTrack');
TrackDef('sun85_mainTrackList').childAt(5).label = 'NoteTimelineTrack';


TrackDef('sun85_mainTrackList').childAt(5).source = Pdef('sun85_mainTrackList.5.instr');
Pbindef('sun85_mainTrackList.5.instr',
	'instrument', 'flutepad',
	'lpf', 679.63115180042,
);
Pdef('sun85_mainTrackList.5.instr').set(
	'legato', 0.17992814792496
);

