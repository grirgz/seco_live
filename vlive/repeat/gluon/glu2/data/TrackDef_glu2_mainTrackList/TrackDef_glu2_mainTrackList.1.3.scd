

TrackDef('glu2_mainTrackList').childAt(1, 3).score = Pbindef('glu2_mainTrackList.1.3',
	'seq', PstepSeq([ 0, 0, 0, 0, 1.0, 0, 0, 0 ], inf),
	'velamp', PstepSeq([ 1, 1, 1, 1, 1, 1, 1, 1 ], inf),
	'coin', PstepSeq([ 1, 1, 1, 1, 1, 1, 1, 1 ], inf),
);
Pbindef('glu2_mainTrackList.1.3').set(
	'out', BusDef('fx1')
);

