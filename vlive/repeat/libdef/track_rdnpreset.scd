
ProtoTemplateDef(\rdnpreset_item, (
	new: { arg self, rdn;
		self = self.copy;
		self.rdn = rdn;
		self;
	},

	play: { arg self;
		self.load;
	},
	save: { arg self;
		var rdn = self.rdn;
		self.preset = (
			params: rdn.proxy.asParamGroup.collect({ arg param;
				[param.property, param.get]
			}).flat.asEvent,
			code: rdn.code,
			fxdef: rdn.fxdef,
		);
		self.changed(\preset, idx);
	},

	load: { arg self;
		var pre = self.preset;
		var rdn = self.rdn;
		if(pre.notNil) {
			pre.params.asAssociations.collect({ arg asso;
				Param(rdn.proxy, asso.key).debug("x");
				Param(rdn.proxy, asso.key).set(asso.value)
			});
			rdn.rebuild(pre.fxdef, nil, pre.code);
		}
	},

	erase: { arg self;
		self.preset = nil;
		self.changed(\preset, idx);
	},

))


// END
////////////

(
[\rdn, \rdn2, \rdn3].do { arg name, rdnidx;
	TrackDef(\pdefgrid).childAt(5+rdnidx).source = 8.collect({ arg index;
		var key = "%.%.%".format(\rdnpreset_pdefgrid, rdnindex, index).asSymbol;
		ProtoDef(key, ProtoTemplateDef(\rdnpreset_item)).rdn_(ProtoDef(name));
	})
}
)


ProtoDef(\rdnpreset1, ProtoTemplateDef(\rdnpreset).new(ProtoDef(\rdn)));
ProtoDef(\rdnpreset2, ProtoTemplateDef(\rdnpreset).new(ProtoDef(\rdn2)));
ProtoDef(\rdnpreset3, ProtoTemplateDef(\rdnpreset).new(ProtoDef(\rdn3)));
