(

ProtoDef(\rdn, (
	init: { arg self;
		self.fxdef = self.fxdef ? \default;
		self.fxcode = self.fxcode ? "4--";
		self.fxkey = self.fxkey ? \fx1;
		self.inbus = self.inbus ? BusDef(\zero, \audio);
	},

	genfx: { arg self; 
		RandDelayNetwork(self.fxdef).make(self.fxkey, self.fxcode, self.inbus) 
	},

	enablefx_: { arg self, val;
		self[\enablefx] = val;
		if(val == true) {
			Ndef(self.fxkey).play;
		} {
			Ndef(self.fxkey).stop;
		}
	},

	edit: { arg self;
		WindowDef(\rdngui).front(self)
	},
)).init;

WindowDef(\rdngui, { arg def, model;
	var fxview;

	fxview = View.new;
	fxview.layout = WindowDef(\vertical_paramgroup).asView(Ndef(model.fxkey).asParamGroup);
	VLayout(
		HLayout(
			TextField.new.action_({ arg view;
				model.fxdef = view.value.asSymbol;
			}).value_(model.fxdef),
			TextField.new.action_({ arg view;
				model.fxkey = view.value.asSymbol;
			}).value_(model.fxkey),
			TextField.new.action_({ arg view;
				model.fxcode = view.value.asString;
			}).value_(model.fxcode),
			Param(
				Message(model), \inbus, 
				MenuSpec(BusDef.all.keys.as(Array).sort.collect({ arg k; k -> BusDef(k) }) )
			).asPopUpMenu,
			PlayerWrapper(Ndef(model.fxkey)).asView, // FIXME: dynamic!
			BasicButton.new.string_("Gen Fx!").action_({
				"gen1".debug;
				model.genfx;
				"gen2".debug;
				fxview.removeAll;
				fxview.layout = WindowDef(\vertical_paramgroup).asView(Ndef(model.fxkey).asParamGroup);
				"gen3".debug;
			}),

		),
		fxview,
	)
});

ProtoDef(\rdn).edit
)
