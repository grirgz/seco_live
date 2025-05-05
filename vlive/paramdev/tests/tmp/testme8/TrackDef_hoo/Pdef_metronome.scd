PlayerWrapper(Pdef('metronome')).presetCompileStringSavePath = "paramdev/tests/tmp/testme8/TrackDef_hoo/Pdef_metronome.scd";

Pdef('metronome').set(
	'out', BusDef('trackMixerDef_hoo.0'),
	'amp', 0.058153535907275
);

"somerro".throw;
