PatKitDef('part1').presetCompileStringSavePath = "ex3/part1_PatKitDef.scd";

PatKitDef('part1').targets = [
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', lag: 0, bufnum: BufDef('fix4/kick1.flac'), sustain: 1)),
	StepEvent.newFrom((adsr: Env([ 0.0, 1.0374531781629, 0.97752809524536, 0.0 ], [ 0.065516129079756, 0.064516127165858, 0.18204300105572 ], [ -4.0, -4.0, -4.0 ], 2.0), pos: 0.051655328798186, speed: 0.95652717391304, instrument: 'playersec', bufnum: BufDef('fix4/kick2.flac'), sustain: 1)),
	nil,
	nil,
	StepEvent.newFrom((instrument: 'playersec', lag: 0, bufnum: BufDef('fix4/snare1.flac'), pos: 0.04)),
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('fix3/snare1.flac'))),
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('fix3/noir.flac'))),
	nil,
	StepEvent.newFrom((gain: 0.14444274407563, pos: 1.2492970521542, lag: 0, instrument: 'playersec', bufnum: BufDef('fix4/hat2.flac'), sustain: 1)),
	StepEvent.newFrom((pos: 1.2656689342404, instrument: 'playersec', gain: 0.20809686825947, bufnum: BufDef('fix4/hat2.flac'), sustain: 1)),
	nil,
	nil,
	StepEvent.newFrom((pos: 7.0704081632653, instrument: 'playersec', speed: 0.27877868852459, bufnum: BufDef('fix3/noir.flac'), sustain: 0.62404336734694)),
];