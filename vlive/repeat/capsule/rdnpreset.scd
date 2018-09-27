
(
ProtoTemplateDef(\rdnpreset, (
	new: { arg self, rdn;
		self = self.copy;
		self.rdn = rdn;
		self.presets= self.presets.copy ?? SparseArray.new;
		self;
	},

	save: { arg self, idx;
		var rdn = self.rdn;
		self.presets[idx] = (
			params: rdn.proxy.asParamGroup.collect({ arg param;
				[param.property, param.get]
			}).flat.asEvent,
			code: rdn.code,
			fxdef: rdn.fxdef,
		);
		self.changed(\preset, idx);
	},

	load: { arg self, idx;
		var pre = self.presets[idx];
		var rdn = self.rdn;
		if(pre.notNil) {
			pre.params.asAssociations.collect({ arg asso;
				Param(rdn.proxy, asso.key).debug("x");
				Param(rdn.proxy, asso.key).set(asso.value)
			});
			rdn.rebuild(pre.fxdef, nil, pre.code);
		}
	},

	erase: { arg self, idx;
		self.presets[idx] = nil;
		self.changed(\preset, idx);
	},

));

WindowDef(\rdnpreset, { arg def, rdnpreset_list;
	VLayout(*
		rdnpreset_list.collect({ arg rdnpreset;
			var lay = VLayout (
				StaticText.new.string_(rdnpreset.rdn.label),
				HLayout (*
					8.collect({ arg idx;
						BasicButton.new.string_(idx).action_({
							rdnpreset.load(idx)
						}).mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
							[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
							if(buttonNumber == 1) {
								rdnpreset.save(idx)
							};
							if(buttonNumber == 2) {
								rdnpreset.erase(idx)
							};
						}).onChange(rdnpreset, \preset, { arg view;
							if(rdnpreset.presets[idx].isNil) {
								view.background = Color.white;
							} {
								view.background = Color.yellow;
							}
						})
					})
				)
			);
			rdnpreset.changed(\preset);
			lay;

		}) ++ [nil]
	)
})
)

// END

WindowDef(\rdnpreset).front([ProtoDef(\rdnpreset1), ProtoDef(\rdnpreset2), ProtoDef(\rdnpreset3)]);
(
ProtoDef(\rdnpreset1, ProtoTemplateDef(\rdnpreset).new(ProtoDef(\rdn)));
ProtoDef(\rdnpreset2, ProtoTemplateDef(\rdnpreset).new(ProtoDef(\rdn2)));
ProtoDef(\rdnpreset3, ProtoTemplateDef(\rdnpreset).new(ProtoDef(\rdn3)));
)
ProtoDef(\rdnpreset1).clear
ProtoDef(\rdnpreset2).clear
ProtoDef(\rdnpreset3).clear
ProtoDef(\rdnpreset1).presets[1]
ProtoDef(\rdnpresetx).presets[1] = 123
ProtoDef(\rdnpresetx).presets


ProtoDef(\rdnpreset1).presets[1] = nil
Param(ProtoDef(\rdn).proxy, \inbus).set(BusDef(\sendbus1))
Param(ProtoDef(\rdn).proxy, \inbus).get
