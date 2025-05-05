TrackDef('glu2_mainTrackList').childAt(1).trackTemplate = TrackTemplateDef('DrumTrack');
TrackDef('glu2_mainTrackList').childAt(1).label = "snare";


TrackDef('glu2_mainTrackList').childAt(1).score = Pbindef('glu2_mainTrackList.1',
	'instrument', 'DrumTrack_player_stereo',
	'dur', 0.125,
	'gain', 0.1,
	'bufnum', BufDef.stereo('samplekit/com/Snare/Rimshot Gong V5.wav'),
);

