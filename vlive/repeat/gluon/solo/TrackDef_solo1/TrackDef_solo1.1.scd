TrackDef('solo1').childAt(1).trackTemplate = TrackTemplateDef('DrumTrack');
TrackDef('solo1').childAt(1).label = 'DrumTrack';


TrackDef('solo1').childAt(1).score = Pbindef('solo1.1',
	'instrument', 'DrumTrack_player_stereo',
	'dur', 0.125,
	'gain', 0.073825503355705,
	'bufnum', BufDef('samplekit/com/Snare/Snare GarageX 2 V12.wav'),
	'adsr', [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.0010000000474975, 0.0, 0.19934911324475 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
);

