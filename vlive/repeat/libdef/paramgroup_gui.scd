
	WindowDef(\vertical_paramgroup, { arg def, paramGroup;
		var mainview = View.new;
		var scroll = ScrollView.new.canvas_(mainview).hasHorizontalScroller_(false).hasBorder_(false);
		paramGroup.debug("paramGroup");
		scroll.fixedWidth_(80+80+260+15);
		mainview.layout = 
		VLayout(*
			paramGroup.reject({ arg p;
				[ p, p.type ].debug("param");
				//p.type != \scalar;
				false;
			}).collect({ arg p;
				if(p.property == \bufnum) {
					var pop = PopUpMenu.new;
					p.spec = MenuSpec( BufDef.all.keys.as(Array).sort.collect({ arg key;
						key -> BufDef(key).bufnum;
					}));
					HLayout(
						p.asStaticTextLabel.fixedWidth_(80).maxHeight_(10).font_(Font.default.size_(11)),
						p.asPopUpMenu.fixedWidth_(260).maxHeight_(20),
						p.asTextField.fixedWidth_(80).maxHeight_(20).font_(Font.default.size_(11)),
					).spacing_(0).margins_(0)
				} {

					switch(p.type,
						\env, {
							VLayout(
								HLayout(
									p.asStaticTextLabel.fixedWidth_(76).maxHeight_(10).font_(Font.default.size_(11)),
									p.asTextField.fixedWidth_(340).maxHeight_(20),
								).spacing_(0).margins_(0),
								[p.asEnvelopeView.fixedWidth_(400).maxHeight_(80), align:\right]
							).spacing_(0).margins_(0)
						},
						\scalar, {
							HLayout(
								p.asStaticTextLabel.fixedWidth_(80).maxHeight_(10).font_(Font.default.size_(11)),
								p.asSlider.fixedWidth_(260).orientation_(\horizontal).maxHeight_(20),
								p.asTextField.fixedWidth_(80).maxHeight_(20).font_(Font.default.size_(11)),
							).spacing_(0).margins_(0)
						}
					);
				}
			}).reject(_.isNil) ++ [nil]
		).spacing_(0).margins_(0);
		VLayout(
			scroll,
		);

	});
