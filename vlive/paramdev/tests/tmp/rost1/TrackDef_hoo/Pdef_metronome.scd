PlayerWrapper(Pdef('metronome')).presetCompileStringSavePath = "paramdev/tests/tmp/rost1/TrackDef_hoo/Pdef_metronome.scd";

Pdef('metronome').set(
	'out', BusDef('trackMixerDef_hoo.0')
);

