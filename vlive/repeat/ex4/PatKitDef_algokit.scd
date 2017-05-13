PatKitDef('algokit').presetCompileStringSavePath = "ex4/PatKitDef_algokit.scd";

PatKitDef('algokit').targets = [
	StepEvent.newFrom((lag: 0, speed: 0.63914285714286, bufnum: BufDef('amen'), instrument: 'playersec', gain: 0.63305552692557, sustain: 1, pos: 0.2027664399093)),
	StepEvent.newFrom((instrument: 'playersec', lag: 0, bufnum: BufDef('fix3/kick1.flac'), pos: 0.04)),
	StepEvent.newFrom((instrument: 'playersec', lag: 0, bufnum: BufDef('fix4/kick1.flac'), pos: 0.04)),
	StepEvent.newFrom((instrument: 'playersec', lag: 0, bufnum: BufDef('fix4/kick2.flac'), pos: 0.04)),
	StepEvent.newFrom((pos: 0.031315192743764, instrument: 'playersec', lag: 0, bufnum: BufDef('fix3/snare1.flac'), sustain: 0.062013888888889)),
	StepEvent.newFrom((pos: 0.031315192743764, instrument: 'playersec', lag: 0, bufnum: BufDef('my3/snare2.flac'), sustain: 0.062013888888889)),
	StepEvent.newFrom((gain: 1.9853509720694, pos: 0.031315192743764, lag: 0, instrument: 'playersec', bufnum: BufDef('fix4/snare1.flac'), sustain: 0.062013888888889)),
	StepEvent.newFrom((gain: 0.56467980486733, pos: 0.031315192743764, lag: 0, instrument: 'playersec', bufnum: BufDef('fix1/snare.flac'), sustain: 0.062013888888889)),
	StepEvent.newFrom((gain: 1.5796402645065, pos: 0.031315192743764, lag: 0, instrument: 'playersec', bufnum: BufDef('fix3/hat1.flac'), sustain: 0.062013888888889)),
	StepEvent.newFrom((gain: 4.0, pos: 0.031315192743764, lag: 0, instrument: 'playersec', bufnum: BufDef('fix1/hat.flac'), sustain: 0.062013888888889)),
	StepEvent.newFrom((gain: 1.5796402645065, pos: 0.031315192743764, lag: 0, instrument: 'playersec', bufnum: BufDef('fix4/hat2.flac'), sustain: 0.062013888888889)),
	StepEvent.newFrom((gain: 1.5796402645065, pos: 0.031315192743764, lag: 0, instrument: 'playersec', bufnum: BufDef('fix4/hat1.flac'), sustain: 0.062013888888889)),
];