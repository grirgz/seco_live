
(
	ProtoDef(\ParamRack, (
		new: { arg self, items;
			self = ProtoClass((parent: self));
		
			self.items = items;
		
			self;
		},

		params: { arg self;
			self.items.select(_.isKindOf(Param));
		},

		controller_: { arg self, cont;
			self[\controller] = cont;
			cont.startControl( (knobs: self.params) );
		},

		edit: { arg self;
			WindowDef(\paramRack, { arg def, players, params;
				VLayout (
					HLayout (
						StaticText.new.string_("controller"), 
						Param(Message(self), \controller, TagSpecDef(\ControllerDef_capabilities_knobs)).asPopUpMenu,
					),
					* self.items.collect({ arg item;
						ParamGroupLayout.formEntry(item)
					}) ++ [nil]
				)
			}).front(self.players, self.params)
		},
	));
);

// END

(
Pdef(\bla, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
ProtoDef(\ParamRack).new([
	Pdef(\bla),
	Param(Pdef(\bla), \lpfr, ControlSpec(1/4,4,\lin)),
	Param(Pdef(\bla), \diff, ControlSpec(0.0001,0.1,\exp)),
	Param(Pdef(\bla), \adsr -> \times -> 0 ),
	Param(Pdef(\bla), \adsr, ParamEnvSpec.adsr(\unipolar)),
]).edit;
)

(
ParamGroup([
	Param(Pdef(\bla), \lpfr, ControlSpec(1/4,4,\lin)),
	Param(Pdef(\bla), \diff, ControlSpec(0.0001,0.1,\exp)),
	Param(Pdef(\bla), \adsr -> \times -> 0 ),
	Param(Pdef(\bla), \adsr, ParamEnvSpec.adsr(\unipolar)),
]).edit
)
