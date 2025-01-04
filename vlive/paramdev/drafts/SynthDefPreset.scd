
(
ProtoTemplateDef(\SynthDefPresetBank, (
	new: { arg self, target;
		self = ProtoClass((parent:self));

		//if(target.isKindOf(Pdef)) {
		self.target = target;
		//};
		if(Archive.global.at(\Param, \SynthDefPresetBank, self.instrument).notNil) {
			self.loadArchive;
		};

		self;
	},

	instrument: { arg self;
		var instr = PdefParam.instrument(self.target);
		var target = self.target;
		if(instr.isNil) {
			case(
				{ target.isKindOf(Pdef) }, {
					instr = "Pdef_%".format(target.key).asSymbol;
				},
				{ target.isKindOf(Ndef) }, {
					instr = "Ndef_%".format(target.key).asSymbol;
				}, {
					"Error: chan't find instrument name for %".format(target).error;
					\error
				}
			)
		};
		instr;
	},

	presetDict: IdentityDictionary.new,

	buildPreset: { arg self;
		var preset = IdentityDictionary.new;
		var data = IdentityDictionary.new;
		preset[\data] = data;
		self.target.asParamGroup.do { arg param, idx;
			if(param.isSet) {
				data[param.propertyRoot] = param.get;
			} {
				preset[\unset] = preset[\unset].add(param.propertyRoot)
			};
		};
		preset;
	},

	hasSavedPresets: { arg self;
		self.presetDict.size > 0
	},

	savePreset: { arg self, key;
		self.presetDict[key] = self.buildPreset;
		self.saveArchive;
		self.changed(\bank);
	},

	loadPreset: { arg self, key;
		var preset;
		preset = self.presetDict[key];
		if(preset.isNil) {
			"no preset named %".format(key).error;
		} {
			self.loadPresetFromObject(preset);
		}
	},

	loadPresetFromObject: { arg self, preset;
		var pg = self.target.asParamGroup.asPropertyDict;
		pg.keys.do { arg pkey, idx;
			if(preset[\data][pkey].notNil) {
				pg[pkey].set(preset[\data][pkey])
			} {
				pg[pkey].unset;
			};
		};
		//preset[\data].keys.do { arg pkey, idx;
			//if(pg[pkey].notNil) {
				//pg[pkey].set(preset[\data][pkey])
			//};
		//};
		//preset[\unset].do { arg pkey, idx;
			//if(pg[pkey].notNil) {
				//pg[pkey].unset;
			//};
		//};
	},

	saveArchive: { arg self;
		var archive = IdentityDictionary.new;
		archive[\presetDict] = self.presetDict;
		Archive.global.put(\Param, \SynthDefPresetBank, self.instrument, archive);
	},

	loadArchive: { arg self;
		var archive;
		var presets;
		//"load Archive".debug;
		archive = self.getArchive;
		self.presetDict = archive[\presetDict];
		self.presetDict.keysValuesDo { arg k,v;
			// this loop is to workaround a bug in Ndef/Archive which load the Ndef with a nil server
			v[\data] = v[\data].collect { arg val;
				//val.class.debug("val class");
				if(val.class == Ndef) {
					//"val is a Ndef".debug;
					val.server = Server.default;
					val = val.asCompileString.interpret;
				};
				val;
			};
			self.presetDict[k][\data] = v[\data];
		};
		this.changed(\bank);
		//"end load Archive".debug;
	},

	getArchive: { arg self;
		Archive.global.at(\Param, \SynthDefPresetBank, self.instrument);
	},


	clearBank: { arg self;
		Archive.global.put(\Param, \SynthDefPresetBank, self.instrument, nil);
		self.presetDict[self.instrument] = nil;
		self.changed(\bank);
	}

));
ProtoTemplateDef(\PresetGraphBank, (

	new: { arg self, targetlist;
		self = ProtoClass((parent:self));

		self.targetList = targetlist;
		if(Archive.global.at(\Param, \PresetGraphBank, self.instrument).notNil) {
			self.loadArchive;
		};

		self;
	},

	presetBank: { arg self;
		if(self[\presetBank_obj].isNil) {
			self[\presetBank_obj] = IdentityDictionary.new;
		};
		self[\presetBank_obj];
	},

	savePreset: { arg self, key;
		var preset = IdentityDictionary.new;
		var paramList;
		preset[\targetList] = IdentityDictionary.new;
		preset[\targetList] = self.targetList;
		preset[\dataList] = self.targetList.collect { arg proxy, idx;
			ProtoTemplateDef(\SynthDefPresetBank).new(self.proxy).buildPreset;
		};
		self.paramList = self.targetList.collect { arg proxy, idx;
			proxy.asParamGroup.asArray;
		}.flatten;

		preset[\combi] = self.paramList.collect({ arg param;
			if(param.hasCombinator) {
				param -> param.getCombinator.presetCompileString;
			} {
				nil
			};
		}).select(_.notNil);

		self.presetBank[key] = preset;
	},

	loadPreset: { arg self, key;
		var preset = self.presetBank[key];
		if(preset.isNil) {
			"No preset named %".format(key).error;
		} {
			preset[\dataList].collect { arg subpreset, idx;
				ProtoTemplateDef(\SynthDefPresetBank).new(preset[\targetList][idx]).loadPresetFromObject(subpreset);
			};
			self.paramList = self.targetList.collect { arg proxy, idx;
				proxy.asParamGroup.asArray;
			}.flatten;
			self.paramList.do { arg param, idx;
				var item = preset[\combi].detect { arg x; x.key == param };
				if(item.notNil) {
					item.value.debug("Enable combi");
					item.value.interpret
				} {
					param.debug("Clear combi");
					param.clearCombinator(false);
				};
			};
		};
	},

	presetDict: { arg self;
		self.presetBank
	},

))
)

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
