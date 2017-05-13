PlayerWrapper(Ndef('part2_zip')).presetCompileStringSavePath = "ex3/part2_data/Ndef_part2_zip.scd";

Ndef('part2_zip').addHalo(\ParamGroup, 
ParamGroup([
	Param(Ndef('part2_zip'), 'freq'),
	Param(Ndef('part2_zip'), 'pan'),
	Param(Ndef('part2_zip'), 'amp')
]).presets = IdentityDictionary[

];

);
