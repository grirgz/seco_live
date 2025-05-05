PlayerWrapper(Pdef('metronome')).presetCompileStringSavePath = "paramdev/tests/tmp/rost5/Pdef_metronome.scd";

Pdef('metronome').set(
	'out', BusDef('trackMixerDef_hoo.0'),
	'amp', 0.0625
);

