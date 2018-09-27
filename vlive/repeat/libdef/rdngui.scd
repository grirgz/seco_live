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
		self.changed(\outBus);
		self;
	},

	outBus: { arg self;
		PlayerWrapper(Ndef(self.fxkey)).outBus;
	},

	inBus: { arg self;
		self.inbus; // can't decide :/
	},

	inBus_: { arg self, val;
		self.inbus = val;
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
		WindowDef(\rdngui_+++self.key, WindowDef(\rdngui)).front(self)
	},

	presetCompileString: { arg self;
		RandDelayNetwork(self.fxdef).presetCompileString(self.fxkey);
	},

	code: { arg self;
		self.proxy.getHalo(\code)
	},

	proxy: { arg self;
		Ndef(self.fxkey);
	},

	rdn: { arg self;
		RandDelayNetwork(self.fxdef);
	},

	synthDefCompileString: { arg self;
		~rdn_to_string.(self.rdn);
	},

	rebuild: { arg self, fxdef, fxkey, code, inbus; // use current code instead of new one
		RandDelayNetwork(fxdef ? self.fxdef).make(fxkey ? self.fxkey, code ? self.code, inbus ? self.inbus) 
	},

	loadDefaultPreset: { arg self;
		self.fxdef = \deldefault;
		self.inbus = BusDef(\sendbus0, \audio, 2);
		self.proxy.put(100, \pset -> Pbind(
			'wet10', 1.0,
			'mix', 0.5,
			'gain', 1,
			'fb', 0.0001,
			'delay', 0.0001,
			'delay2', 0.0001,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.18504562572587,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		).keep(1));
	},
)).init;

WindowDef(\rdngui, { arg def, model;
	var fxview;

	def.windowName = model.label;
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
			Param(
				Message(model), \outBus, 
				MenuSpec([\0->0] ++ BusDef.all.keys.as(Array).sort.collect({ arg k; k -> BusDef(k).index }) )
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
