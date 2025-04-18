TrackDef('sun85_mainTrackList').childAt(1).trackTemplate = TrackTemplateDef('DrumTrack');
TrackDef('sun85_mainTrackList').childAt(1).label = 'DrumTrack';


TrackDef('sun85_mainTrackList').childAt(1).score = Pbindef('sun85_mainTrackList.1',
	'instrument', 'DrumTrack_player_stereo',
	'dur', 0.125,
	'bufnum', BufDef('samplekit/com/Snare/Snare Neuron 1.wav'),
	'gain', 0.13223140495868,
	'adsr', [ Env([ 0, 1, 1, 0 ], [ 0.001, 0, 0.218754 ], [ -4, -4, -8 ], 2) ],
);
Pbindef('sun85_mainTrackList.1').set(
	'legato', 0.34651376846197
);

