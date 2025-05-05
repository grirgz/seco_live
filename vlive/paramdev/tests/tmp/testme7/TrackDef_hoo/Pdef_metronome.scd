PlayerWrapper(Pdef('metronome')).presetCompileStringSavePath = "paramdev/tests/tmp/testme7/TrackDef_hoo/Pdef_metronome.scd";

Pdef('metronome').set(
	'out', BusDef('trackMixerDef_hoo.0')
);

"somerror".throw;

