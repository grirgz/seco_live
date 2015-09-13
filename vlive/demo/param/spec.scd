
(
Builder(\bla, { arg osctype;
	osctype.debug("osctype::");
});
Builder.addSpec(\osctype, 
	MenuSpec([
		"sinusoide" -> \sinosc,
		"scie" -> \lfsaw,
		"carré" -> \lfpulse,
	])
);

~map_popup = { arg view, param;
	if(param.spec.isKindOf(MenuSpec)) {
		view.items = param.spec.labelList.asArray;
		view.action = {
			param.set(param.spec.indexMap(view.value))
		}
	}
};

WindowLayout({ 
	var pm = PopUpMenu.new;
	~map_popup.(pm,
		Param(Builder(\bla), \osctype)
	);
	pm;
})
)

		Param(Builder(\bla), \osctype).type
		Param(Builder(\bla), \osctype).asView


(
Builder(\bla, { arg osctype = \sinosc;
	osctype.debug("osctype::");
});
Builder.addSpec(\osctype, 
	MenuSpec([
		"sinusoide" -> \sinosc,
		"scie" -> \lfsaw,
		"carré" -> \lfpulse,
	])
);

WindowLayout({ 
	var po;
	VLayout(
		Param(Builder(\bla), \osctype).asView,
		Param(Builder(\bla), \osctype).asPopUpMenu,
		PopUpMenu.new.mapParam( Param(Builder(\bla), \osctype) ),
		PopUpMenu.new.mapValueParam( Param(Builder(\bla), \osctype) ),
		po = PopUpMenu.new; Param(Builder(\bla), \osctype).mapPopUpMenu(po); po,
		po = PopUpMenu.new; Param(Builder(\bla), \osctype).mapValuePopUpMenu(po); po,
	)
})
)

Param(Builder(\bla), \osctype).asView
Param(Builder(\bla), \osctype).get

(
Builder(\bla, { arg osctype = \sinosc, quant;
	osctype.debug("osctype::");
	quant.debug("quant::");
});
Builder.addSpec(\osctype, 
	MenuSpec([
		"sinusoide" -> \sinosc,
		"scie" -> \lfsaw,
		"carré" -> \lfpulse,
	])
);
Spec.add(\quant, 
	MenuSpec([
		"0",
		"1/4",
		"1/2",
		"1"
	].collect({ arg x; x -> x.interpret }))
);

WindowLayout({ 
	var po;
	VLayout(
		Param(Builder(\bla), \osctype).asView,
		Param(Builder(\bla), \quant).asView,
		Param(Builder(\bla), \quant).asTextField,
		Param(Builder(\bla), \osctype).asTextField,
	)
})
)


(
ParamGroup([
	Param(Builder(\bla), \quant),
	Param(Builder(\bla), \osctype),
]).edit
)

(
Builder(\bla, { arg osctype, quant;
	osctype.debug("osctype::");
	quant.debug("quant::");
});
Builder.addSpec(\osctype, 
	MenuSpec([
		"sinusoide" -> \sinosc,
		"scie" -> \lfsaw,
		"carré" -> \lfpulse,
	])
);
Spec.add(\quant, 
	MenuSpec([
		"0",
		"1/4",
		"1/2",
		"1"
	].collect({ arg x; x -> x.interpret }))
);

WindowLayout({ 
	var po;
	VLayout(
		Param(Builder(\bla), \osctype).asView,
		Param(Builder(\bla), \quant).asView,
		Param(Builder(\bla), \quant).asTextField,
		Param(Builder(\bla), \osctype).asTextField,
	)
})
)


