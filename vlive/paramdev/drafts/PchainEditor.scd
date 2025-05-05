
(
WindowDef(\PchainEditor, { arg def, pdef;
	var beforep, midp, afterp;
	pdef = pdef ? Pdef(\pchaintest);
	if(pdef.source.isKindOf(Pchain).not) {
		pdef.source = EventPatternProxy(Pbind()) <> EventPatternProxy(PbindProxy()) <> EventPatternProxy(Pbind());
	};
	afterp = pdef.source.patterns[0];
	midp = pdef.source.patterns[1];
	beforep = pdef.source.patterns[2];
	VLayout (
		HLayout (
			PlayerWrapper(pdef).asView,
			StaticText.new.string_("Before"),
			Param(Message(beforep), \source, TagSpecDef(\Pdef)).asPopUpMenu,
			StaticText.new.string_("After"),
			Param(Message(afterp), \source, TagSpecDef(\Pdef)).asPopUpMenu,
		),
		WindowDef(\PbindefEditor).asView(midp)
	)
}).front;
)

	~pdef = Pdef(\pchaintest);
	~pdef.source = EventPatternProxy.new <> EventPatternProxy.new <> EventPatternProxy.new;
	~pdef.source.patterns
	Pchain.
	~pdef.source.patterns[1].source = PbindProxy.new;
	~pdef.source.patterns[0].source = Pbind.new;
	~pdef.source.patterns[2].source = Pbind.new;
	Param(~pdef.source.patterns[1], \freq).edit
	~pdef.play;
	EventPatternProxy(Pbind()).source
	(
	Pdef(\myinstr, 
		Pbind(
			\instrument, \sh101,
		)
	);
	);
	(
	Pdef(\empty, 
		Pbind(
		)
	);
	);
