TrackDef('solo1').childAt(3).trackTemplate = TrackTemplateDef('DrumTrack');
TrackDef('solo1').childAt(3).label = 'DrumTrack';


TrackDef('solo1').childAt(3).score = Pbindef('solo1.3',
	'instrument', 'DrumTrack_player_stereo',
	'dur', 0.125,
	'gain', 0.1,
	'bufnum', BufDef('samplekit/com/HiHat/ClosedHH Stadium 2 V8.wav'),
);

