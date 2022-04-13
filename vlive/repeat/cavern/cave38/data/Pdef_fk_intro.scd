PlayerWrapper(Pdef('fk_intro')).presetCompileStringSavePath = "repeat/cavern/cave38/data/Pdef_fk_intro.scd";

Pdef('fk_intro').set('dur', 1.0);
Pdef('fk_intro').set('legato', 0.8);
Pdef('fk_intro').set('out', BusDef('trackMixerDef_cave38_mainTrackGrid.0'));
Pdef('fk_intro').set('freq', #{
					(~midinote.value + ~ctranspose).midicps * ~harmonic;
				});
Pdef('fk_intro').set('amp', #{ ~db.dbamp });
Pdef('fk_intro').set('pan', 0.0);
