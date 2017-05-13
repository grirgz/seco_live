PatKitDef('part2').presetCompileStringSavePath = "ex3/part2_data/patKitDef_part2.scd";

PatKitDef('part2').targets = [
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('fix3/kick1.flac'))),
	nil,
	nil,
	nil,
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('fix3/snare1.flac'))),
	nil,
	nil,
	nil,
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('fix1/hat.flac'))),
];