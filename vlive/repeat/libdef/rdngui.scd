(
FileSystemProject.load("libdef/paramgroup_gui.scd");

Spec.add(\inbus, XBusSpec.new);
Spec.add(\gate, XGateSpec.new);
Spec.add(\indelay, ControlSpec(0,0.2,\lin));

ProtoTemplateDef(\rdn, (

	init: { arg self;
		self.fxdef = self.fxdef ? \default;
		self.fxcode = self.fxcode ? "4--";
		//self.fxkey = self.fxkey ? \fx1;
		self.inbus = self.inbus ? BusDef(\zero, \audio);
	},

	fxkey: { arg self;
		self.key;
	},

	label: { arg self;
		"%: %".format(self.key, self.fxkey);
	},

	outBus_: { arg self, val;
		PlayerWrapper(Ndef(self.fxkey)).outBus = val;
	},

	outBus: { arg self;
		PlayerWrapper(Ndef(self.fxkey)).outBus;
	},

	genfx: { arg self; 
		RandDelayNetwork(self.fxdef).make(self.fxkey, self.fxcode, self.inbus) 
	},

	play: { arg self;
		PlayerWrapper(Ndef(self.fxkey)).play;
	},

	stop: { arg self;
		PlayerWrapper(Ndef(self.fxkey)).stop;
	},

	isPlaying: { arg self;
		PlayerWrapper(Ndef(self.fxkey)).isPlaying;
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

	presetCompileString: { arg self;
		RandDelayNetwork(self.fxdef).presetCompileString(self.fxkey);
	},
)).init;

WindowDef(\rdngui, { arg def, model;
	var fxview;

	fxview = View.new;
	fxview.layout = WindowDef(\vertical_paramgroup).asView(Ndef(model.fxkey).asParamGroup);
	VLayout(
		HLayout(
			//TextField.new.action_({ arg view;
			//	model.fxdef = view.value.asSymbol;
			//}).value_(model.fxdef),
			Param(
				Message(model), \fxdef, 
				MenuSpec(RandDelayNetwork.all.keys.as(Array).sort)
			).asPopUpMenu,
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

ProtoDef(\rdn, ProtoTemplateDef(\rdn)); // backward compat and default instance

)
