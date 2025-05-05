TrackDef('glu1_mainTrackList').childAt(3).trackTemplate = TrackTemplateDef('NoteTimelineTrack');
TrackDef('glu1_mainTrackList').childAt(3).label = "meloloop";


TrackDef('glu1_mainTrackList').childAt(3).source = Pdef('glu1_mainTrackList.3.instr');
Pbindef('glu1_mainTrackList.3.instr',
	'instrument', 'sh101',
	'lpf', 'c5',
	'kbamt', 0,
	'lpadsr', [ Env([ 0.0, 1.0, 0.58484846353531, 0.0 ], [ 0.34308990859987, 0.058412923771233, 0.80849718528677 ], [ -1.1, -4.0, -4.0 ], 2.0) ],
);
Pdef('glu1_mainTrackList.3.instr').set(
	'envamt', 'c2'
);

