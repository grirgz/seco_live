PlayerWrapper(ProtoDef('part3_rdn2')).presetCompileStringSavePath = "ex3/part3_data/ProtoDef_part3_rdn2.scd";

RandDelayNetwork('default').make('part3_rdn2', "4-I04S-1DL");
Ndef('part3_rdn2').put(100, \pset -> Pbind(
	
).keep(1));
