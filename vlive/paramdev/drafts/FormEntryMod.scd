
WindowDef(\FormEntryMod, { arg def, param;
	var slider;
	var midview = View.new;
	var updateMidView;
	var labelWidth = 90;
	updateMidView = {

		if(param.hasCombinator) {
			var combi = param.getCombinator;
			[param, param.hasCombinator, param.getCombinator, combi].debug("paramsrc combi");
			[param.getCombinator.existingInputRanges ].debug("has combi");
			//slider = paramsrc.asSlider.orientation_(\horizontal);
			slider = param.asSlider.orientation_(\horizontal);

			midview.removeAll;
			midview.layout = HLayout (
				//paramsrc.getCombinator.baseParam.asSlider.orientation_(\horizontal),
				slider,
				* combi.existingInputRanges.collect { arg subp, idx;
					var modlabel;
					var obj;
					var knob;
					obj = combi.inputObjects[idx];
					modlabel = try {obj.label} ?? { obj.asCompileString };
					knob = subp.asKnob.fixedSize_(25@25).toolTip_(modlabel);
					knob.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
						[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
						if(buttonNumber == 1) {
							Menu(
								MenuAction("Remove modulation", {
									combi.clearInput(subp.subIndex);
									updateMidView.();
								}),
								MenuAction("Reset value", {
									subp.set(0);
								}),
							).front;
							false;
						};
					})
				}
			).spacing_(4).margins_(0);
		} {
			slider = param.asSlider.orientation_(\horizontal);
			midview.layout = HLayout(slider).margins_(0).spacing_(0);
		};
		slider.canReceiveDragHandler = {
			true
		};
		slider.receiveDragHandler = { arg view, x, y;
			var pc;
			var obj;
			[View.currentDrag, view, x, y].debug("receiveDragHandler");
			obj = View.currentDrag;
			[param.get, param.getRaw, param.hasCombinator].debug("receiveDragHandler: before combi");
			pc = ParamCombinator(param);
			[param.get, param.getRaw, param.hasCombinator].debug("receiveDragHandler: after combi");
			pc.mapObjectToInput(obj);
			[param.get, param.getRaw, param.hasCombinator].debug("receiveDragHandler: after combi2");
			//updateMidView.();
		};
		slider.followChange(param.target, \combinator, { arg view, obj, msg, prop;
			if(prop == param.propertyRoot) {
				updateMidView.();
			};
	   
		})
	};
	updateMidView.();
	if(param.type == \scalar) {
		HLayout (
			param.asStaticTextLabel.fixedWidth_(labelWidth).attachContextMenu,
			midview,
			param.asTextField.fixedWidth_(60),
		)

	} {
		var pv = param.asView;
		pv.labelView.fixedWidth_(labelWidth);
		pv;
	};
});

