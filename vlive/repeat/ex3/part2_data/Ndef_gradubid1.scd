PlayerWrapper(Ndef('gradubid1')).presetCompileStringSavePath = "ex3/part2_data/Ndef_gradubid1.scd";

Ndef('gradubid1').addHalo(\ParamGroup, 
ParamGroup([
	Param(Ndef('gradubid1'), 'freq'),
	Param(Ndef('gradubid1'), 'pan'),
	Param(Ndef('gradubid1'), 'amp')
]).presets = IdentityDictionary[

];

);
