TrackDef('glu1_mainTrackList').childAt(1).trackTemplate = TrackTemplateDef('DrumTrack');
TrackDef('glu1_mainTrackList').childAt(1).label = "kick";


TrackDef('glu1_mainTrackList').childAt(1).score = Pbindef('glu1_mainTrackList.1',
	'instrument', 'DrumTrack_player_stereo',
	'dur', 0.125,
	'gain', 0.1,
	'bufnum', BufDef('samplekit/com/Kick/Kick Alkaloid 2 V1.wav'),
);

