
// moved to quark

// END
//////////////////////

(
Pdef(\hoho, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
);
);

(
Pdef(\hihi, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
);
);

Pdef(\hoho).edit
Pdef(\hihi).edit
Param.trace = true
ParamProto.init(true)
ProtoTemplateDef(\S)

~b = ProtoTemplateDef(\SynthDefPresetBank).new(Pdef(\hoho))
~b.instrument
~b.savePreset(\bla)
~b.presetDict[\bla]
~b.presetDict[\preset1][\unset]
Pdef(\hoho).asParamGroup.asPropertyDict[\spread].get
// TODO: add .changed(\set) in .unset


(
ProtoTemplateDef(\PresetGraphBank).new(
	(
		main: [ Param(Pdef(\bla), \rah) ]
	)
).printTree
)

(
ProtoTemplateDef(\PresetGraphBank).new(
	(
		main: [ Param(Pdef(\bla), \rah) ],
		name: "aaze",
		items: {
			[
				(main: {
					[ Param(Pdef(\bla), \rah) ]
				}),
				(main: {
					[ Param(Pdef(\bla), \rah) ]
				}),
			]
		}
	)
).printTree;
)
