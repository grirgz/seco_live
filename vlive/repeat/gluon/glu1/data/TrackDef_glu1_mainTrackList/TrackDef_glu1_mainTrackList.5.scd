TrackDef('glu1_mainTrackList').childAt(5).trackTemplate = TrackTemplateDef('DrumTrack');
TrackDef('glu1_mainTrackList').childAt(5).label = "hat";


TrackDef('glu1_mainTrackList').childAt(5).score = Pbindef('glu1_mainTrackList.5',
	'instrument', 'DrumTrack_player_stereo',
	'dur', 0.125,
	'gain', 0.031746031746032,
	'bufnum', BufDef('samplekit/com/HiHat/ClosedHH Dragon 1 V2.wav'),
);

