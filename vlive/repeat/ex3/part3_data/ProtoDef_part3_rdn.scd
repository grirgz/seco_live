PlayerWrapper(ProtoDef('part3_rdn')).presetCompileStringSavePath = "ex3/part3_data/ProtoDef_part3_rdn.scd";

RandDelayNetwork('default').make('part3_rdn', "4-I04S-1DL");
Ndef('part3_rdn').put(100, \pset -> Pbind(
	
).keep(1));
