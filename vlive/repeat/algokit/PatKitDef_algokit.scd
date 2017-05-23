PatKitDef('algokit').presetCompileStringSavePath = "algokit/PatKitDef_algokit.scd";

PatKitDef('algokit').targets = SparseArray[
	StepEvent.newFrom((lag: 0, speed: 0.63914285714286, bufnum: BufDef('fix1/kick.flac'), instrument: 'playersec', gain: 1.4157532574816, sustain: 1, pos: 0.04)),
	StepEvent.newFrom((instrument: 'playersec', lag: 0, bufnum: BufDef('fix3/kick1.flac'), pos: 0.04)),
	StepEvent.newFrom((instrument: 'playersec', lag: 0, bufnum: BufDef('fix4/kick1.flac'), pos: 0.04)),
	StepEvent.newFrom((instrument: 'playersec', lag: 0, bufnum: BufDef('fix4/kick2.flac'), pos: 0.04)),
	StepEvent.newFrom((pos: 0.031315192743764, instrument: 'playersec', lag: 0, bufnum: BufDef('fix3/snare1.flac'), sustain: 0.062013888888889)),
	StepEvent.newFrom((pos: 0.031315192743764, instrument: 'playersec', lag: 0, bufnum: BufDef('my3/snare2.flac'), sustain: 0.062013888888889)),
	StepEvent.newFrom((gain: 1.9853509720694, pos: 0.031315192743764, lag: 0, instrument: 'playersec', bufnum: BufDef('fix4/snare1.flac'), sustain: 0.062013888888889)),
	StepEvent.newFrom((gain: 0.56467980486733, pos: 0.031315192743764, lag: 0, instrument: 'playersec', bufnum: BufDef('fix1/snare.flac'), sustain: 0.062013888888889)),
	StepEvent.newFrom((gain: 0.74908432788892, pos: 0.031315192743764, lag: 0, instrument: 'playersec', bufnum: BufDef('fix3/hat1.flac'), sustain: 0.062013888888889)),
	StepEvent.newFrom((gain: 4.0, pos: 0.031315192743764, lag: 0, instrument: 'playersec', bufnum: BufDef('fix1/hat.flac'), sustain: 0.062013888888889)),
	StepEvent.newFrom((gain: 1.5796402645065, pos: 0.031315192743764, lag: 0, instrument: 'playersec', bufnum: BufDef('fix4/hat2.flac'), sustain: 0.062013888888889)),
	StepEvent.newFrom((gain: 1.0877884747708, pos: 0.031315192743764, lag: 0, instrument: 'playersec', bufnum: BufDef('fix4/hat1.flac'), sustain: 0.062013888888889)),
	StepEvent.newFrom((instrument: 'playersec', lag: 0, bufnum: BufDef('fix1_extra/kick2.flac'), pos: 0.04)),
	StepEvent.newFrom((instrument: 'playersec', lag: 0, bufnum: BufDef('fix1_extra/largesnare.flac'), pos: 0.04)),
	StepEvent.newFrom((instrument: 'playersec', lag: 0, bufnum: BufDef('fix1_extra/hat3.flac'), pos: 0.04)),
	StepEvent.newFrom((instrument: 'playersec', lag: 0, bufnum: BufDef('fix1_extra/bell1.flac'), pos: 0.04)),
];
