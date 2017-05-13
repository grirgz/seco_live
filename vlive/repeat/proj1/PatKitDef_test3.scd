PatKitDef('test3').presetCompileStringSavePath = "proj1/PatKitDef_test3.scd";

PatKitDef('test3').targets = [
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('fix3/kick1.flac'))),
	StepEvent.newFrom((instrument: 'playersec', adsr: Env([ 0, 1, 1, 0 ], [ 0.004, 0, 0.01 ], [ -4, -4, -4 ], 2), bufnum: BufDef('fix3/kick1.flac'), pos: 0.08)),
	nil,
	nil,
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('fix3/snare1.flac'))),
	nil,
	nil,
	nil,
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('my3/snare2.flac'), pos: 0.031065759637188, sustain: 1)),
	nil,
	nil,
	nil,
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('fix1/hat.flac'))),
	StepEvent.newFrom((adsr: Env([ 0, 1, 1, 0 ], [ 0.01, 0, 0.1 ], [ -4, -4, -4 ], 2), speed: 1.000875, bufnum: BufDef('fix1/hat.flac'), instrument: 'playersec', gain: 0.70786947024746, sustain: 1, pos: 0.25433106575964)),
	StepEvent.newFrom((instrument: 'playersec', gain: 0.6601092936861, bufnum: BufDef('fix1/hat.flac'), lag: 0)),
];