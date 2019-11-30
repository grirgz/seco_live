
(
WindowDef(\FxManager, {
	VLayout (
		*[\rdn, \rdn2, \rdn3, \rdn4].collect({ arg key;
			var asso = key -> ProtoDef(key);
			if(asso.value[\make].isNil) {
				ProtoDef(key, ProtoTemplateDef(\rdn));
			};
			asso.key.debug("xx");
			HLayout (
				PlayerWrapper(asso.value).asView,
				BasicButton.new.string_("Edit").action_({
					asso.value.edit;
				}),
				Param(Message(asso.value), \inbus, TagSpecDef(\BusDef)).asPopUpMenu,
				Param(Message(asso.value), \outBus, TagSpecDef(\BusDef_index)).asPopUpMenu,
				Param(asso.value.proxy, \gain).asSlider.orientation_(\horizontal).fixedWidth_(170),
			)
		}) 
		++
		[\fx1, \fx2, \fx3, \fx4].collect({ arg key;
			var asso = key -> Ndef(key);
			asso.key.debug("xx");
			HLayout (
				PlayerWrapper(asso.value).asView,
				BasicButton.new.string_("Edit").action_({
					var name;
					name = "%: %".format(asso.key, asso.value.source);
					WindowDef(\NdefEditor).front(asso.value).windowName_(name);
				}),
				Param(asso.value, \inbus, TagSpecDef(\BusDef)).asPopUpMenu,
				Param(asso.value, \out, TagSpecDef(\BusDef)).asPopUpMenu,
				Param(Message(asso.value), \source, TagSpecDef(\SynthDef_fx)).asPopUpMenu,
				Param(asso.value, \gain).asSlider.orientation_(\horizontal).fixedWidth_(170),
			)
		}) 
		++ [nil]
	)
});

BusDef(\fx1, \audio, 2);
BusDef(\fx2, \audio, 2);
BusDef(\fx3, \audio, 2);
BusDef(\fx4, \audio, 2);
)

// END

PlayerWrapper(ProtoDef(\rdn).proxy).outBus
ProtoDef(\blaa).eventType
ProtoDef(\rdn).keys
WindowDef(\FxManager).front
Ndef(\fx1).edit

(
	ProtoTemplateDef(\NdefFx, (
		instrument_: { arg self, val;
			self.proxy.source = val;
		},

	));
)

ProtoDef(\rdn).inbus
ProtoDef(\rdn).presetDictionary
ProtoDef(\rdn).readPresetLib

Param(Ndef(\fx1), \out).spec.tagSpec
Param(Ndef(\fx1), \inbus).spec.tagSpec

WindowDef(\bla, { PopUpMenu.new.items_([\bla, \rah]).value_(nil) }).front
