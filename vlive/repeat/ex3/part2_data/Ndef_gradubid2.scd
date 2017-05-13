PlayerWrapper(Ndef('gradubid2')).presetCompileStringSavePath = "ex3/part2_data/Ndef_gradubid2.scd";

Ndef('gradubid2').addHalo(\ParamGroup, 
ParamGroup([
	Param(Ndef('gradubid2'), 'freq'),
	Param(Ndef('gradubid2'), 'pan'),
	Param(Ndef('gradubid2'), 'amp')
]).presets = IdentityDictionary[

];

);
