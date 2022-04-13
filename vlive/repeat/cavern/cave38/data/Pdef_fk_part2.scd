PlayerWrapper(Pdef('fk_part2')).presetCompileStringSavePath = "repeat/cavern/cave38/data/Pdef_fk_part2.scd";

Pdef('fk_part2').set('dur', 1.0);
Pdef('fk_part2').set('legato', 0.8);
Pdef('fk_part2').set('out', BusDef('trackMixerDef_cave38_mainTrackGrid.0'));
Pdef('fk_part2').set('freq', #{
					(~midinote.value + ~ctranspose).midicps * ~harmonic;
				});
Pdef('fk_part2').set('amp', #{ ~db.dbamp });
Pdef('fk_part2').set('pan', 0.0);
