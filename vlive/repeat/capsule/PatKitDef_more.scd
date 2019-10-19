PatKitDef('more').presetCompileStringSavePath = "capsule/PatKitDef_more.scd";

PatKitDef('more').targets = [
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('//home/ggz/Musique/sc/samplekit/com/Metallic/TambShake Garage V4.wav'), pan: 0.0)),
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('//home/ggz/Musique/sc/samplekit/com/Metallic/TambShake GarageX V13.wav'))),
	nil,
	nil,
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('//home/ggz/Musique/sc/samplekit/com/Hand Drum/Conga Fiasco 1.wav'))),
	nil,
	nil,
	nil,
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('//home/ggz/Musique/sc/samplekit/com/Wooden/WoodLow SessionX V6.wav'))),
];