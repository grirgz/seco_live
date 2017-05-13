PlayerWrapper(Ndef('part2_treb_b')).presetCompileStringSavePath = "ex3/part2_data/Ndef_part2_treb_b.scd";

Ndef('part2_treb_b').addHalo(\ParamGroup, 
ParamGroup([
	Param(Ndef('part2_treb_b'), 'freq'),
	Param(Ndef('part2_treb_b'), 'pan'),
	Param(Ndef('part2_treb_b'), 'amp')
]).presets = IdentityDictionary[

];

);
