
(

TrackTemplateDef(\PlayerGridSection).splitAndAssignPattern = { arg self, pat;
	var list = [];
	pat = pat ?? { Pdef(\part) };
	if(pat.source.isKindOf(Pdef)) {
		pat = pat.source;
	};
	if(pat.source.isKindOf(Ppar)) {
		var prefix = self.trackKey;
		list = pat.source.list;
		list = list.collect { arg item, idx;
			//item.debug("splitAndAssignPattern: item");
			Pdef("%_%".format(prefix, idx).asSymbol, item);
		};
	};
	self.source = list;
};

ProtoDef(\apc40).callback_scene_button = { arg self, idx;
	if(self.shiftModifier == true) {
		idx.debug("assign_splitpart");
		self.grid.sectionAtOffset(idx).splitAndAssignPattern;
		//~assign_splitpart.(self.grid, Pdef(\part), player.target.index, ( self.grid.trackKey++\_split ).asSymbol);
		self.render_grid;
		false;
	};
};

);

