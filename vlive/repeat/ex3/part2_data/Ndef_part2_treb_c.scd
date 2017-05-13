PlayerWrapper(Ndef('part2_treb_c')).presetCompileStringSavePath = "ex3/part2_data/Ndef_part2_treb_c.scd";

Ndef('part2_treb_c').addHalo(\ParamGroup, 
ParamGroup([
	Param(Ndef('part2_treb_c'), 'freq'),
	Param(Ndef('part2_treb_c'), 'pan'),
	Param(Ndef('part2_treb_c'), 'amp')
]).presets = IdentityDictionary[

];

);
