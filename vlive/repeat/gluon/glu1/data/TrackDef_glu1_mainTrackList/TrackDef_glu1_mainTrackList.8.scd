TrackDef('glu1_mainTrackList').childAt(8).trackTemplate = TrackTemplateDef('NoteTimelineTrack');
TrackDef('glu1_mainTrackList').childAt(8).label = 'NoteTimelineTrack';


TrackDef('glu1_mainTrackList').childAt(8).source = Pdef('glu1_mainTrackList.8.instr');
Pbindef('glu1_mainTrackList.8.instr',
	'instrument', 'formant',
	'fmf', 'c4',
	'fma', 0.56796831900719,
	'lpfr', 'c5',
	'amp', 0.060236282202483,
	'fenvamt', 'c6',
	'bwenvamt', 'c7',
	'formfreq', 'c8',
	'bwfreq', 'c9',
	'adsr', [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.015476192347705, 0.18452381063253, 0.080952389893078 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
	'fenv', [ Env([ 0.0, 1.0, 0.0 ], [ 0.0071428486279079, 0.89285718713488 ], [ 0.0, 0.0 ]) ],
	'bwenv', [ Env([ 0.0, 1.0, 0.0 ], [ 0.014285698958806, 0.88571433680398 ], [ -3.4, 0.0 ]) ],
);

