TrackDef('solo1').childAt(0).trackTemplate = TrackTemplateDef('DrumTrack');
TrackDef('solo1').childAt(0).label = 'DrumTrack';


TrackDef('solo1').childAt(0).score = Pbindef('solo1.0',
	'instrument', 'DrumTrack_player_stereo',
	'dur', 0.125,
	'gain', 0.1,
	'bufnum', BufDef.stereo('samplekit/com/Kick/Kick 707X 1.wav'),
);

