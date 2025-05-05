TrackDef('glu2_mainTrackList').childAt(0).trackTemplate = TrackTemplateDef('DrumTrack');
TrackDef('glu2_mainTrackList').childAt(0).label = "kick";


TrackDef('glu2_mainTrackList').childAt(0).score = Pbindef('glu2_mainTrackList.0',
	'instrument', 'DrumTrack_player_stereo',
	'dur', 0.125,
	'gain', 0.1,
	'bufnum', BufDef.stereo('samplekit/com/Kick/Kick FM7 3 V4.wav'),
);

