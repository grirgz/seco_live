PatKitDef('scapkit').presetCompileStringSavePath = "algokit/PatKitDef_scapkit.scd";

PatKitDef('scapkit').targets = [
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('fix4/kick1.flac'))),
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('fix4/kick2.flac'))),
	StepEvent.newFrom((instrument: 'playersec', speed: 0.88490647482014, bufnum: BufDef('bass/bass4.flac'), pos: 0.08)),
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('scape/scape1.flac'))),
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('fix4/snare2.flac'))),
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('fix4/snare3.flac'))),
	StepEvent.newFrom((instrument: 'playersec', speed: 0.76981294964029, bufnum: BufDef('fix3/snare1.flac'), pos: 0.04)),
	nil,
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('fix1/hat.flac'), pos: 2.3791609977324, sustain: 1)),
	StepEvent.newFrom((gain: 0.84769276862235, pos: 0.4907029478458, speed: -1.2, instrument: 'playersec', bufnum: BufDef('fix4/hat1.flac'), sustain: 1)),
];