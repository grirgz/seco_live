
FileSystemProject.loadOnce("libdef/ParamSelectDialog.scd");
FileSystemProject.loadOnce("libdef/controllers.scd");

(
	WindowDef(\ParamSelectorView, { arg def, param, prefix="target";
		var labelView;
		var refresh = {
			labelView.string_("%: %".format(prefix, param.getRaw.fullLabel))
		};
		labelView = StaticText.new;
		refresh.();
		HLayout (
			labelView,
			BasicButton.new.string_("Last").maxWidth_(50).action_({
				param.setRaw(Param.lastTweaked);
				refresh.();
			}).mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
				[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
				
				if(buttonNumber == 1) {
					WindowDef(\ParamSelectDialog).front(nil, { arg selparam; 
						selparam.debug("selected param") ;
						param.setRaw(selparam);
						refresh.();
					}, param.getRaw);
				}
			}),
		)
		
	});

	WindowDef(\ControllerSelectorView, { arg def, param;
		var tag;
		var model;
		var pianoplayer;
		if(param.type == \array) {
			tag = \knobline;
			model = (
				controller_: { arg self, val;
					self[\controller] = val;
					param.target.addHalo(\ControllerSelectorView, param.property.asSymbol, val);
					val.startControl(param)
				},
			);
			model[\controller] = param.target.getHalo(\ControllerSelectorView, param.property.asSymbol);
		} {
			if(param.property == \midinote) {
				param = param.target;
				tag = \piano
			};
			model = (
				controller_: { arg self, val;
					self[\controller] = val;
					param.addHalo(\ControllerSelectorView, val);
					val.startControl(param)
				},
			);
			model[\controller] = param.getHalo(\ControllerSelectorView);
		};
		tag.debug("TAG");
		Param(Message(model), \controller, ControllerDef.getTagSpec(tag)).asPopUpMenu;
	});
)
