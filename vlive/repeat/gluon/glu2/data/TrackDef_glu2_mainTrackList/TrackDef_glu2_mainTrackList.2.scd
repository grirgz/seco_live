TrackDef('glu2_mainTrackList').childAt(2).trackTemplate = TrackTemplateDef('DrumTrack');
TrackDef('glu2_mainTrackList').childAt(2).label = "hat";


TrackDef('glu2_mainTrackList').childAt(2).score = Pbindef('glu2_mainTrackList.2',
	'instrument', 'DrumTrack_player_stereo',
	'dur', 0.125,
	'gain', 0.1,
	'bufnum', BufDef('samplekit/com/HiHat/ClosedHH ThirtyThrees 2.wav'),
);

