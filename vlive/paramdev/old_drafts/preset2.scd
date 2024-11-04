
///// write a full eventclass for preset popup menu
ParamProto.init

(
Pdef(\plop, Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 1,
	\amp, 0.1
));
Pdef(\plop).addHalo(\instrument, \default);
ParamGroupDef(\plop, Pdef(\plop).asParamGroup);
)

(
WindowLayout({
	//var pg = Pdef(\plop).asParamGroup;
	var pg = ParamGroupDef(\plop);
	VLayout(
		EventClass.presetSelectorView.(pg),
		pg.asView,
		nil,
	)
})
)

////////////// tests

Pdef(\plop).asParamGroup.edit
Pdef(\plop).asParamGroup.editor
~pg = Pdef(\plop).asParamGroup;
		EventClass.presetSelectorView(~pg)
		EventClass.presetSelectorView.(~pg)


//////////////////////////////////// preset list

(
Pdef(\plop, Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 1,
	\amp, 0.1
));
Pdef(\plop).addHalo(\instrument, \default);
ParamGroupDef(\plop, Pdef(\plop).asParamGroup);
PresetListMorpher(ParamGroupDef(\plop));
)

(

WindowLayout({
	//var pg = Pdef(\plop).asParamGroup;
	var pg = ParamGroupDef(\plop);
	var morpher = PresetListMorpher(ParamGroupDef(\plop));
	VLayout(
		EventClass.presetSelectorView.(pg),
		pg.asView,
		EventClass.presetListMorpherView.(pg),
		nil,
	)
})
)
