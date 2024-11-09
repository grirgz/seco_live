// see also ndefpreset.scd track_rdnpreset.scd and mixerPreset.scd

(
ProtoDef(\NdefParamGroupDef, (
	// when put in a playergrid, you can define for each cell which preset name from ParamGroup is used
	// then when you play the cell, the preset is loaded into the Ndef in source
	// contrary to NdefPreset, the preset is stored in ParamGroupDef instead of the cell itself

	protoClass: \NdefParamGroupDef,

	new: { arg self, ndef, preset_name=\default;
		var newself = ProtoClass();
		newself.parent = self;
	
		newself.source = ndef;
		newself[\preset] = preset_name;
		newself;
	},

	load: { arg self, name;
		self.paramGroup.load(( name ? self.preset ) ? \default );
	},

	save: { arg self, name;
		self.paramGroup.save(( name ? self.preset ) ? \default);
	},

	source_: { arg self, source;
		self[\source] = source;
		ParamGroupDef.update(self.sourcekey, self.source.asParamGroup);
	},

	preset_: { arg self, name;
		self[\preset] = name;
		self.changed(\preset);
	},

	paramGroup: { arg self;
		ParamGroupDef(self.sourcekey)
	},

	sourcekey: { arg self;
		\ndefpreset_+++self.source.key
	},

	play: { arg self;
		self.load;
	},

	isPlaying: { arg self;
		false
	},

	edit: { arg self;
		self.editor.front(self);
	},

	editor: { arg self;
		WindowDef(self.sourcekey, { arg def, me;
			var target;
			var pg;
			var key;
			key = me.source.key;
			target = me.source;
			pg = me.paramGroup;
			VLayout(
				HLayout(
					PlayerWrapper(target).asView,
					WindowDef(\PresetSelectorView).asView(pg),
					BasicButton.new.string_("save preset").action_({ me.save; }),
					BasicButton.new.string_("load preset").action_({ me.load; }),
					Param(Message(me), \preset, TagSpec(me.paramGroup.presets.keys)).asPopUpMenu,
					StaticText.new.followChange(me, \preset, { arg view;
						view.string = me.preset;
					})
				),
				ParamGroupLayout.two_panes(pg)
			);
		});
	},


));

ProtoDef(\NdefPreset, (
	// When connected, the params come from the Ndef, else they come from the preset
	// Capture save the ndef params values to the unique preset
	// Playing the NdefPreset apply the preset to the Ndef
	// Can be put in a playergrid to store and load different ndef presets
	// When not connected, you can modify each preset without changing the running sound
	// The benefit over NdefParamGroupDef is you can still load presets from ParamGroupDef so you can share
	// but you don't have to store every preset so you don't clutter system presets


	protoClass: \NdefPreset,

	new: { arg self, ndef;
		var newself = ProtoClass();
		newself.parent = self;
	
		newself.source = ndef;
		newself;
	},


	label: { arg self;
		"% %".format(self.source.key, self.key);
	},

	preset: { arg self;
		if(self[\stepEvent].isNil) {
			self[\stepEvent] = StepEvent.new;
			self.capture;
		};
		self[\stepEvent]
	},

	preset_: { arg self, val;
		self[\stepEvent] = val;
		if(self.connected) {
			self.play;
		};
		self.changed(\params);
	},

	capture: { arg self, name;
		self.paramGroup.do({ arg x;
			self.preset[x.property] = x.get;
			self.preset.changed(\set, x.property);
		})
	},

	source_: { arg self, source;
		self[\source] = source;
		ParamGroupDef.update(self.sourcekey, self.source.asParamGroup.sort({ arg a, b; a.property.asString > b.property.asString}));
	},


	paramGroup: { arg self;
		ParamGroupDef(self.sourcekey)
	},

	sourcekey: { arg self;
		\ndefpreset_+++self.source.key
	},

	play: { arg self;
		self.source.set(*self.paramGroup.collect({ arg x; [ x.property, self.preset[x.property] ?? { x.get } ] }).flatten);
		self.isPlaying = false;
	},

	stop: { arg self;
		self.isPlaying = false;
	},


	isPlaying: { arg self;
		false
	},

	edit: { arg self;
		self.editor.front(self);
	},

	params: { arg self;
		var sort = { arg a, b; a.property.asString < b.property.asString};
		if(self.connected) {
			self.paramGroup.asList.sort(sort);
		} {
			self.preset.keys.as(Array).sort.collect({ arg key; Param(self.preset, key, Param(self.source, key).spec) });
		}
		
	},

	connected_: { arg self, val;
		self[\connected] = val;
		if(val == false) {
			self.capture;
		};
		self.changed(\params);
	},

	connected: { arg self;
		false;
	},

	editor: { arg self;
		WindowDef(self.sourcekey, { arg def, me;
			var target;
			var pg;
			var key;
			var paramsview = View.new;
			key = me.source.key;
			target = me.source;
			paramsview.onChange(me, \params, { arg view;
				var pg = me.params;
				view.removeAll;
				view.layout = ParamGroupLayout.two_panes(pg)
			});
			me.changed(\params);
			VLayout(
				HLayout(
					PlayerWrapper(me).asView,
					PlayerWrapper(target).asView,
					WindowDef(\PresetSelectorView).asView(me.paramGroup),
					BasicButton.new.string_("Capture").action_({ me.capture }),
					Param(Message(me), \connected, XBoolSpec.new).asButton.string_("Connect"),
				),
				paramsview
			);
		});
	},

	presetCompileString: { arg self;
		"ProtoDef(%).preset = %;".format(self.key.asCompileString, self.preset.asCompileString)
	},
))
)

// END

// ==================================================

///// demo
(
Ndef(\testpre, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(\fmf1.kr(2/1)*~t * ( 1 + ( SinOsc.ar(\fmf2.kr(1/2)*~t) * 1 ))) * 1 )));
	sig = Pan2.ar(sig, pan, amp);
});
);
(
TrackDef(\testpre, TrackDef(\playergrid)).source = [
	//8.collect { arg x; ProtoDef(\myndef+++x, ProtoDef(\NdefParamGroupDef).new(Ndef(\testpre))); },
	8.collect { arg x; ProtoDef(\myndef+++x, ProtoDef(\NdefPreset).new(Ndef(\testpre))); },
	[
		Ndef(\testpre)
	]

]
)
TrackDef(\testpre).edit;


////////////////////////


//// test NdefParamGroupDef

ProtoDef(\testme, ProtoDef(\NdefParamGroupDef).new(Ndef(\testpre)))
ProtoDef(\testme).edit
ProtoDef(\testme).clear
ProtoDef(\testme).keys
ProtoDef(\testme).paramGroup.presets
Ndef(\testpre).edit
Ndef(\testpre).clear
Ndef(\testpre).play

(
TrackDef(\testprepg, TrackTemplateDef(\playergrid)).source = [
	//8.collect { arg x; ProtoDef(\myndef+++x, ProtoDef(\NdefParamGroupDef).new(Ndef(\testpre))); },
	8.collect { arg x; ProtoDef(\myndefpg+++x, ProtoDef(\NdefParamGroupDef).new(Ndef(\testpre))); },
	[
		Ndef(\testpre)
	]

]
)
TrackDef(\testprepg).edit;

//////////////////////

ProtoDef(\myndef0).edit
ParamGrouDef(\)
ProtoDef(\myndef0).paramGroup.asList



ProtoDef(\myndef1).clear;
ProtoDef(\myndef0, ProtoDef(\NdefPreset).new(Ndef(\testpre)));
ProtoDef(\myndef0).edit;
ProtoDef(\myndef0).params
ProtoDef(\myndef0).preset
ProtoDef(\myndef0).presetCompileString
ProtoDef(\myndef0).presetCompileStringSavePath
PlayerWrapper(ProtoDef(\myndef0)).savePresetCompileStringDialog
PlayerWrapper(ProtoDef(\myndef0)).savePresetCompileString
PlayerWrapper(ProtoDef(\myndef0)).target.savePresetCompileString
PlayerWrapper(ProtoDef(\myndef0)).loadPresetCompileString
PlayerWrapper(ProtoDef(\myndef0)).presetCompileStringSavePath
PlayerWrapper(ProtoDef(\myndef0)).targetKey
PlayerWrapper(ProtoDef(\myndef0)).wrapper
PlayerWrapper(ProtoDef(\myndef0)).asCompileString


ProtoDef(\myndef0, ProtoDef(\NdefParamGroupDef).new(Ndef(\testpre))).edit
ProtoDef(\myndef0).preset = \qsd
ProtoDef(\myndef0).play
ProtoDef(\myndef1, ProtoDef(\NdefParamGroupDef).new(Ndef(\testpre))).edit
ProtoDef(\myndef1).preset = \aze
ProtoDef(\myndef1).play

Ndef(\testpre).fadeTime = 1;

(
Pdef(\testpre, Pbind(
	\instrument, \default,
	\type, \player,
	\receiver, {PlayerWrapper(Ndef(\testpre))},
	\degree, Pseq([0],inf),
	\dur, 8,
	\legato, 0.8,
	\amp, 0.1
)).play;
);

(
Pdef(\testpre, Pbind(
	\instrument, \default,
	\type, \pattern,
	\receiver, {PlayerWrapper(Ndef(\testpre))},
	\degree, Pseq([0],inf),
	\dur, 8,
	\legato, 0.8,
	\amp, 0.1
)).play;
)

(
Pdef(\testprepre, Pbind(
	\instrument, \default,
	\type, \player,
	\receiver, Pseq([
		{PlayerWrapper(ProtoDef(\myndef0))},
		{PlayerWrapper(ProtoDef(\myndef1))},
	],inf),
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\legato, 0.8,
	\amp, 0.1
)).play;
);




~ss = StepEvent.new
~ss[\bla] = 4
~ss.asParamGroup(~ss)

	
]
