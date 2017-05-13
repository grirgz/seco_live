PlayerWrapper(Ndef('testpre')).presetCompileStringSavePath = "ex3/test_data/Ndef_testpre.scd";

Ndef('testpre').addHalo(\ParamGroup, 
ParamGroup([
	Param(Ndef('testpre'), 'freq'),
	Param(Ndef('testpre'), 'pan'),
	Param(Ndef('testpre'), 'amp'),
	Param(Ndef('testpre'), 'fmf1'),
	Param(Ndef('testpre'), 'fmf2')
]).presets = IdentityDictionary[

];

);
