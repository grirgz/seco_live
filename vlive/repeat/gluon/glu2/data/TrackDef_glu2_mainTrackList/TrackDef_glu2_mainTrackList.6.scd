TrackDef('glu2_mainTrackList').childAt(6).trackTemplate = TrackTemplateDef('DrumTrack');
TrackDef('glu2_mainTrackList').childAt(6).label = "clap";


TrackDef('glu2_mainTrackList').childAt(6).score = Pbindef('glu2_mainTrackList.6',
	'instrument', 'DrumTrack_player_stereo',
	'dur', 0.125,
	'gain', 0.1,
	'bufnum', BufDef.stereo('samplekit/com/Clap/Clap RZ1 V2.wav'),
);

