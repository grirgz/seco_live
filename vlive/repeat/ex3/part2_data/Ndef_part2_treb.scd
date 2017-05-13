PlayerWrapper(Ndef('part2_treb')).presetCompileStringSavePath = "ex3/part2_data/Ndef_part2_treb.scd";

Ndef('part2_treb').addHalo(\ParamGroup, 
ParamGroup([
	Param(Ndef('part2_treb'), 'freq'),
	Param(Ndef('part2_treb'), 'pan'),
	Param(Ndef('part2_treb'), 'amp')
]).presets = IdentityDictionary[

];

);
