PatKitDef('part1_b').presetCompileStringSavePath = "ex3/part1_PatKitDef_b.scd";

PatKitDef('part1_b').targets = [
	StepEvent.newFrom((pos: 5.3229024943311, instrument: 'playersec', speed: 0.35491935483871, bufnum: BufDef('fix3/noir.flac'), sustain: 1)),
	StepEvent.newFrom((pos: 10.291814058957, instrument: 'playersec', speed: 0.25903225806452, bufnum: BufDef('fix3/noir.flac'), sustain: 1)),
	StepEvent.newFrom((pos: 10.279092970522, instrument: 'playersec', speed: 0.38804838709677, bufnum: BufDef('fix3/noir.flac'), sustain: 1)),
	nil,
	StepEvent.newFrom((adsr: Env([ 0, 0.303371, 1.16479, 0 ], [ 0.172043, 0.677667, 0.0645162 ], [ 4, -4, -4 ], 2), speed: 0.74003804347826, bufnum: BufDef('vipere/scream.flac'), instrument: 'playersec', gain: 0.51636157096751, sustain: 1, pos: 4.6860770975057)),
	StepEvent.newFrom((adsr: Env([ 0.0, 0.84269672632217, 0.11235955357552, 0.0 ], [ 0.011752235673128, 0.91322584173852, 0.23655897378922 ], [ 4, 4, -4 ], 2), speed: 0.87045652173913, bufnum: BufDef('vipere/scream.flac'), instrument: 'playersec', gain: 0.24548619023573, sustain: 1, pos: 23.590136054422)),
];