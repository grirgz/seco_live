TrackDef('glu2_mainTrackList').childAt(4).trackTemplate = TrackTemplateDef('NoteTimelineTrack');
TrackDef('glu2_mainTrackList').childAt(4).label = "pluck";


TrackDef('glu2_mainTrackList').childAt(4).source = Pdef('glu2_mainTrackList.4.instr');
Pbindef('glu2_mainTrackList.4.instr',
	'instrument', 'sh101',
	'envamt', 3.3792762636848,
	'amp', 0.050237812128419,
	'lpf', 1950.105956474,
);
Pdef('glu2_mainTrackList.4.instr').set(
	'lpf', 'c7'
);

