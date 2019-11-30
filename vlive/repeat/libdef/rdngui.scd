(
FileSystemProject.load("libdef/paramgroup_gui.scd");

Spec.add(\inbus, XBusSpec.new);
Spec.add(\gate, XGateSpec.new);
Spec.add(\indelay, ControlSpec(0,0.2,\lin));

ProtoTemplateDef(\rdn, (

	init: { arg self;
		// this overwrite existing parameters when instanciating
		// but if i remove them from template, i need to call .init everywhere i instanciate
		// if i replace them by function, same problem
		self.fxdef = self.fxdef ? \default;
		self.fxcode = self.fxcode ? "4--";
		//self.fxkey = self.fxkey ? \fx1;
		self.inbus = self.inbus ? BusDef(\zero, \audio);
	},

	fxkey: { arg self;
		self.key;
	},

	fxdef_: { arg self, val;
		self[\fxdef] = val;
		self.changed(\set, \fxdef);
	},

	inbus_: { arg self, val;
		self[\inbus] = val;
		self.proxy.set(\inbus, val);
		self.changed(\set, \inbus);
	},

	fxcode_: { arg self, val;
		self[\fxcode] = val;
		self.changed(\set, \fxcode);
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

	play: { arg self;
		PlayerWrapper(Ndef(self.fxkey)).play;
	},

	stop: { arg self;
		PlayerWrapper(Ndef(self.fxkey)).stop;
	},

	isPlaying: { arg self;
		PlayerWrapper(Ndef(self.fxkey)).isPlaying;
	},

	tagSelf: { arg self;
		TagSpecDef(\ProtoDef_rdn).addUnique(self.key -> self);
	},

	make: { arg self, fxdef, fxkey, fxcode, inbus;
		fxcode.debug("fxcode");
		self.fxcode.debug("fxcode1.2");
		self.fxdef = fxdef ? self.fxdef;
		self.fxkey = fxkey ? self.fxkey;
		self.fxcode = fxcode ? self.fxcode;
		self.fxcode.debug("fxcode2");
		self.inbus = inbus ? self.inbus;
		self.rebuild(nil, nil, self.fxcode);
	},

	genfx: { arg self; // use fxcode (random code)
		RandDelayNetwork(self.fxdef).make(self.fxkey, self.fxcode, self.inbus);
		self.changed(\refresh);
	},

	rebuild: { arg self, fxdef, fxkey, code, inbus; // use current code instead of new one
		self.tagSelf;
		RandDelayNetwork(fxdef ? self.fxdef).make(fxkey ? self.fxkey, code ? self.code, inbus ? self.inbus);
		self.changed(\refresh);
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
		self.tagSelf;
		WindowDef(\rdngui_+++self.key, WindowDef(\rdngui)).front(self)
	},

	libCompileString: { arg self, name;
		var lines;
		var rdn = self;
		var preset = (
			params: rdn.proxy.asParamGroup.collect({ arg param;
				[param.property, param.get]
			}).flat.asEvent,
			code: rdn.code,
			fxdef: rdn.fxdef,
		);
		lines = "ProtoTemplateDef(\\rdn).preset(%).data = %;\n".format(*[name, preset].collect(_.asCompileString));
		lines
	},

	presetLibPath: { arg self; 
		FileSystemProject.resolve("presets/ProtoDef_rdn_preset/").fullPath
	},

	saveToPresetLib: { arg self, presetName;
		var path = "%.scd".format(self.presetLibPath +/+ presetName);
		[path, self.libCompileString(presetName)].debug("save path");
		self.libCompileString(presetName).interpret;
		File.use(path, "w") { arg file;
			file.write(self.libCompileString(presetName))
		};
	},

	readPresetLib: { arg self, presetName="";
		var path = presetName ++ "*";
		(self.presetLibPath +/+ path).pathMatch.do { arg path;
			FileSystemProject.load(path)
		}
	},

	loadFromPresetLib: { arg self, presetName;
		var pre;
		var rdn = self;
		var excluded = [\out, \inbus];
		pre = ProtoTemplateDef(\rdn).preset(presetName);
		if(pre.data.isNil) {
			self.readPresetLib(presetName);
			pre = ProtoTemplateDef(\rdn).preset(presetName);
		};
		if(pre.notNil and: {pre.data.notNil}) {
			pre.data.params.asAssociations.reject({ arg x; excluded.includes(x) }).collect({ arg asso;
				Param(rdn.proxy, asso.key).debug("x");
				Param(rdn.proxy, asso.key).set(asso.value)
			});
			rdn.fxdef = pre.data.fxdef ? rdn.fxdef;
			rdn.rebuild(pre.data.fxdef, nil, pre.data.code); 
		} {
			"Can't load empty preset".debug(presetName);
		}
	},

	preset: { arg self, presetName;
		presetName = presetName.asSymbol;
		self.presetDictionary = self.presetDictionary ?? { IdentityDictionary.new };
		self.presetDictionary[presetName] = self.presetDictionary[presetName] ?? { 
			(
				data_: { arg self, data;
					TagSpecDef(\ProtoDef_rdn_preset).addUnique(presetName);
					self[\data] = data;
				},
			)
	   	};
		self.presetDictionary[presetName]
	},

	presetCompileString: { arg self;
		var lines;
		lines = RandDelayNetwork(self.fxdef).presetCompileString(self.fxkey).split($\n);
		lines[0] = "ProtoDef(%).make(%, %, %, %);".format(*[self.key, self.fxdef, self.fxkey, self.code, self.inbus].collect(_.asCompileString));
		lines.join( $\n)
	},

	code: { arg self;
		// code is current specific code of rdn and fxcode is the generic code (eg. "4--")
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
	var popup;
	var currentCodeText;

	def.windowName = model.label;
	fxview = View.new;
	fxview.layout = WindowDef(\vertical_paramgroup).asView(Ndef(model.fxkey).asParamGroup);
	VLayout(
		VLayout (
			HLayout(
				//TextField.new.action_({ arg view;
				//	model.fxdef = view.value.asSymbol;
				//}).value_(model.fxdef),
				popup = Param(
					Message(model), \fxdef, 
					MenuSpec(RandDelayNetwork.all.keys.as(Array).sort)
				).asPopUpMenu,
				TextField.new.action_({ arg view;
					model.fxkey = view.value.asSymbol;
				}).value_(model.fxkey),
				TextField.new.action_({ arg view;
					model.fxcode = view.value.asString;
				}).value_(model.fxcode).minWidth_(40),
				currentCodeText = StaticText.new.string_(model.code).followChange(model, \refresh, { arg me;
					me.string_(model.code)
				}).font_(Font.default.size_(10)).minWidth_(65).mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
					[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
					if(clickCount == 2) {
						"code copied on clipboard".debug(model.code);
						model.code.asString.pbcopy;
					}
				}),
				PlayerWrapper(Ndef(model.fxkey)).asView, // FIXME: dynamic!
				BasicButton.new.string_("Gen Fx!").action_({
					"gen1".debug;
					model.genfx;
					//currentCodeText.string_(model.code),
					"gen2".debug;
					fxview.removeAll;
					fxview.layout = WindowDef(\vertical_paramgroup).asView(Ndef(model.fxkey).asParamGroup);
					"gen3".debug;
				}),
			
			),
			HLayout (
				BasicButton.new.string_("Load").action_({
					popup.refreshChange;

					if(ProtoTemplateDef(\rdn).presetDictionary.size == 0) {
						ProtoTemplateDef(\rdn).readPresetLib; 
					};
			
					WindowDef(\ProtoDef_rdn_loadPreset).front(model);
				}).minWidth_(35),
				BasicButton.new.string_("Save").action_({
					WindowDef(\ProtoDef_rdn_savePreset).front(model);
				}).minWidth_(35),
				Param(
					Message(model), \inbus, 
					TagSpecDef(\BusDef)
					//MenuSpec(BusDef.all.keys.as(Array).sort.collect({ arg k; k -> BusDef(k) }) )
				).asPopUpMenu,
				Param(
					Message(model), \outBus, 
					TagSpecDef(\BusDef_index)
					//MenuSpec([\0->0] ++ BusDef.all.keys.as(Array).sort.collect({ arg k; k -> BusDef(k).index }) )
				).asPopUpMenu,
				BasicButton.new.string_("Rebuild").action_({
					model.rebuild;
				}),
				
			)
		),
		fxview,
	)
});

WindowDef(\ProtoDef_rdn_savePreset, { arg def, model;
	var listview = ListView.new;
	var textfield;
	var selectAction = { arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");

		//[view.value, view.items].debug("double click select: ");
		//if(clickCount == 1 and: {view.items.size > 0}) {
			textfield.value = listitems[view.value].key
		//}
	};
	var listitems = TagSpecDef(\ProtoDef_rdn_preset).list.sort({ arg a, b; a.key.asString < b.key.asString });
	listview.items = listitems.collect({ arg x; 
		"skdjf".debug(x.value.data);
		"% [% %]".format(x.key, x.value.data.fxdef, x.value.data.code)
	});
	VLayout (
		textfield = TextField.new,
		listview.selectionAction_(selectAction),
		HLayout (
			BasicButton.new.string_("Save").action_({
				var name = textfield.value.trim();
				if(name != "") {
					name = name.asSymbol;
					if(listitems.any({ arg x; x.key == name })) {
						WindowDef(\ConfirmDialog).front("This preset already exists, are you sure ?", {
							model.saveToPresetLib(name);
							def.closeWindow;
						})
					} {
						model.saveToPresetLib(name);
						def.closeWindow;
					}
				} {
					"invalid name".debug;
				};
			}),
			BasicButton.new.string_("Cancel").action_({
				def.closeWindow;
			}),
		)
	)
});
WindowDef(\ProtoDef_rdn_loadPreset, { arg def, model;
	var listview = ListView.new;
	var textfield;
	var selectAction = { arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("selectionAction_");

		//[view.value, view.items].debug("double click select: ");
		//if(clickCount == 1 and: {view.items.size > 0}) {
			textfield.value = listitems[view.value].key
		//}
	};
	var doubleAction = { arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		if(clickCount == 2 and: {view.items.size > 0}) {
			textfield.value = listitems[view.value].key;
			model.loadFromPresetLib(textfield.value.trim());
		}
	};
	var listitems = TagSpecDef(\ProtoDef_rdn_preset).list.sort({ arg a, b; a.key.asString < b.key.asString });
	listview.items = listitems.collect({ arg x;
		"% [% %]".format(x.key, x.value.data.fxdef, x.value.data.code)
	});
	VLayout (
		textfield = TextField.new,
		listview.selectionAction_(selectAction).mouseDownAction_(doubleAction),
		HLayout (
			BasicButton.new.string_("Load").action_({
				if(textfield.value.trim() != "") {
					model.loadFromPresetLib(textfield.value.trim());
					def.closeWindow;
				} {
					"invalid name".debug;
				};
			}),
			BasicButton.new.string_("Cancel").action_({
				def.closeWindow;
			}),
		)
	)
});

ProtoDef(\rdn, ProtoTemplateDef(\rdn)); // backward compat and default instance
ProtoDef(\rdn).tagSelf;

TagSpecDef(\ProtoDef_rdn_preset, {
	ProtoTemplateDef(\rdn).presetDictionary !? { |d| d.asAssociations } ?? { [] }
});

TagSpecDef(\Editable).addUnique(\ProtoDef_rdn);


)

// END

~x = IdentityDictionary.new
~x[\dsf] = 3
~x.asAssociations
WindowDef(\ProtoDef_rdn_loadPreset).front(ProtoDef(\blabla))
ProtoDef(\blabla).clear
ProtoDef(\blabla).edit
ProtoDef(\blabla).fxdef = \default
ProtoDef(\blabla)[\fxdef_].asCompileString
ProtoDef(\blabla).changed(\set, \fxdef)
ProtoDef(\blabla, ProtoTemplateDef(\rdn));
ProtoDef(\blabla).saveToPresetLib("blu")
ProtoDef(\blabla).loadFromPresetLib("ggg")
ProtoTemplateDef(\rdn).preset("blu")
ProtoTemplateDef(\rdn).preset("ggg")
ProtoTemplateDef(\rdn).preset("ggg").data.params.keys
ProtoTemplateDef(\rdn).preset("ggg").data.fxdef
ProtoTemplateDef(\rdn).presetDictionary = nil
ProtoDef(\blabla).preset("blu").data = (bla:12)
TagSpecDef(\ProtoDef_rdn_preset).list.collect({ arg x; x.key })
TagSpecDef(\ProtoDef_rdn_preset).list
Param(Message(ProtoDef(\blabla)), \fxdef, TagSpecDef(\ProtoDef_rdn_preset)).controllerTarget
Param(Message(ProtoDef(\blabla)), \fxdef, MenuSpec({ [1->1] })).controllerTarget
