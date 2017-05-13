

(
PatKitDef(\barlok1).targets = [
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('fix3/kick1.flac'))),
	StepEvent.newFrom((instrument: 'playersec', adsr: Env([ 0, 1, 1, 0 ], [ 0.004, 0, 0.01 ], [ -4, -4, -4 ], 2), bufnum: BufDef('/home/ggz/Musique/sc/reckit/fix3/kick1.flac'), pos: 0.08)),
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
	StepEvent.newFrom((adsr: Env([ 0, 1, 1, 0 ], [ 0.01, 0, 0.1 ], [ -4, -4, -4 ], 2), speed: 1.000875, bufnum: BufDef('fix3/hurl.flac'), instrument: 'playersec', gain: 0.70786947024746, sustain: 1, pos: 0.25433106575964)),
];
);

// END

PatKitDef(\barlok1).edit
PatKitDef(\barlok1).presetCompileString
