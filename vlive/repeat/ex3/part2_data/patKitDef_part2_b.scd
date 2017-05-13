PatKitDef('part2_b').presetCompileStringSavePath = "ex3/part2_data/patKitDef_part2_b.scd";

PatKitDef('part2_b').targets = [
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('loop/loop3.flac'))),
	StepEvent.newFrom((adsr: Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.0010000000474975, 0.0, 0.063763445960508 ], [ -4.0, -4.0, -4.0 ], 2.0), pos: 1.1533786848073, gain: 0.78047270174185, instrument: 'playersec', bufnum: BufDef('loop/loop3.flac'), sustain: 1)),
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('loop/loop3.flac'), pos: 3.7769387755102, sustain: 1)),
	nil,
	StepEvent.newFrom((instrument: 'playersec', gain: 0.47541529819068, bufnum: BufDef('fix3/hurl.flac'), pos: 0.04)),
	StepEvent.newFrom((pos: 1.0854875283447, instrument: 'playersec', gain: 0.42981290323152, bufnum: BufDef('fix3/hurl.flac'), sustain: 1)),
	nil,
	nil,
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('loop/loop4.flac'))),
	StepEvent.newFrom((pos: 0.31906976744186, instrument: 'playersec', bufnum: BufDef('loop/loop4.flac'))),
	StepEvent.newFrom((pos: 1.1562790697674, instrument: 'playersec', bufnum: BufDef('loop/loop4.flac'))),
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('loop/loop4.flac'), pos: 4.3513832199546, sustain: 1)),
	nil,
	nil,
	nil,
];