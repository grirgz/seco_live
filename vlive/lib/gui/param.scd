

WindowDef(\vertical_paramgroup, { arg def, paramGroup;
	var mainview = View.new;
	var scroll = ScrollView.new.canvas_(mainview).hasHorizontalScroller_(false).hasBorder_(false);
	paramGroup.debug("paramGroup");
	mainview.layout = 
		VLayout(*
			paramGroup.collect({ arg p;
				HLayout(
					p.asStaticTextLabel.fixedWidth_(80).maxHeight_(10).font_(Font.default.size_(11)),
					p.asSlider.fixedWidth_(260).orientation_(\horizontal).maxHeight_(20),
					p.asTextField.fixedWidth_(80).maxHeight_(20).font_(Font.default.size_(11)),
				).spacing_(0).margins_(0)
			}) ++ [nil]
		).spacing_(0).margins_(0);
	VLayout(
		scroll,
	);

});
