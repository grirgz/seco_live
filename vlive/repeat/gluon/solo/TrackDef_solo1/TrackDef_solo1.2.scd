TrackDef('solo1').childAt(2).trackTemplate = TrackTemplateDef('DrumTrack');
TrackDef('solo1').childAt(2).label = 'DrumTrack';


TrackDef('solo1').childAt(2).score = Pbindef('solo1.2',
	'instrument', 'DrumTrack_player_stereo',
	'dur', 0.125,
	'gain', 0.1,
	'bufnum', BufDef('samplekit/com/HiHat/ClosedHH GarageX 2 V10.wav'),
);

