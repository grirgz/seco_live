PatKitDef('part3').presetCompileStringSavePath = "ex3/part3_data/patKitDef_part3.scd";

PatKitDef('part3').targets = [
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('loop/loop4.flac'))),
	StepEvent.newFrom((instrument: 'playersec')),
];