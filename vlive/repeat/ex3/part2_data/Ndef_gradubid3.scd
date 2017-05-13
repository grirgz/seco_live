PlayerWrapper(Ndef('gradubid3')).presetCompileStringSavePath = "ex3/part2_data/Ndef_gradubid3.scd";

Ndef('gradubid3').addHalo(\ParamGroup, 
ParamGroup([
	Param(Ndef('gradubid3'), 'freq'),
	Param(Ndef('gradubid3'), 'pan'),
	Param(Ndef('gradubid3'), 'amp')
]).presets = IdentityDictionary[

];

);
