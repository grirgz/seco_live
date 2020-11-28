
(
ProtoDef(\ParamRouter, (
	paramList: [
		Param(Pdef(\bla), \lpfr),
	],
	busList: [
		BusDef(\bus1, \control),
		BusDef(\bus2, \control),
	],
	slotCount: 4,
	init: { arg self, busList, paramList;
		self.busList = self.busList ? busList;
		self.paramList = self.paramList ? paramList;
		self.busSlots = List.newFrom(BusDef(\zero, \control)!self.slotCount);
		self.paramSlots = List.newFrom(Param(Pdef(\zero),\zero)!self.slotCount);
		self.rangeSlots = List.newFrom(0!self.slotCount);
		
	},

	// problem:
	// no way to change the already defined Param in another GUI to point to the specConverter
	// a moins d'utiliser le cachedBus mais j'ai bien peur que la logique fasse qu'a un moment le param va recuperer la valeur sur la bus pour la mettre dans cachedBus et du coup on va tout perdre, sans compter le set qui set le mauvais bus quand meme

	updateRouting: { arg self;
		self.slotCount.do { arg idx;
			if(self.busSlots[idx] != BusDef(\zero) and: { self.paramSlots[idx].target != Pdef(\zero) }) {
				self.patternSlots[idx] = Pmono(
					\instrument, \specConverter,
					\inbus, self.busSlots[idx],
					\base, value,
					\out, self.paramSlot[idx].getRaw,
				)

			}
		};
	},

	edit: { arg self;
		WindowDef(\ParamRouter, { arg def;
			VLayout (
				* self.slotCount.collect({ arg idx;
					HLayout (
						Param(self.busSlots, \list, TagSpec(self.busList.collect({ arg x; x.key -> x }))).at(idx).asPopUpMenu,
						Param(self.rangeSlots, \list, ControlSpec(0,1,\lin)).at(idx).asSlider.orientation_(\horizontal),
						Param(self.paramSlots, \list, TagSpec(self.paramList.collect({ arg x; x.asLabel(\full) -> x }))).at(idx).asPopUpMenu,
					)
				}) ++ [nil]
			)
		}).front;
	},
));
ProtoDef(\ParamRouter).init;
ProtoDef(\ParamRouter).edit;
)

