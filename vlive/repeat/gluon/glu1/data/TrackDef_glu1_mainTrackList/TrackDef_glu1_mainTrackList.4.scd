TrackDef('glu1_mainTrackList').childAt(4).trackTemplate = TrackTemplateDef('DrumTrack');
TrackDef('glu1_mainTrackList').childAt(4).label = "snare";


TrackDef('glu1_mainTrackList').childAt(4).score = Pbindef('glu1_mainTrackList.4',
	'instrument', 'DrumTrack_player_stereo',
	'dur', 0.0625,
	'gain', 0.081761006289308,
	'bufnum', BufDef('samplekit/com/Snare/Snare Gothik 4 V3.wav'),
);
Pbindef('glu1_mainTrackList.4').set(
	'legato', 1.111156303378
);

