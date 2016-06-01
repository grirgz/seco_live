
// list example of every gui class included in the Param quark
////////////////////////////////////////////////////////////////

// Param.asView -> MultiSliderView
StepList[1,2,4].edit

// StepListView
WindowDef(\gui, { StepListView.new(StepList[1,2,4]).asView }).front

// StepListColorView
WindowDef(\gui, { StepListColorView.new(StepList[1,2,4]).asView }).front

// ~stepEventView
(
~se = StepEvent.new;
~se.instrument = \dr_kick;
~se.freq = StepList.newFrom((1..8) * 100);
~se.amp = StepList.newFrom((1..8)/8);
~se.dur = 1/4;
WindowDef(\gui, { 
	~stepEventView.new(~se).makeLayout 
}).front;
)

// ~envEventView
(
~se = StepEvent.new;
~se.instrument = \dr_kick;
~se.freq = StepList.newFrom((1..8) * 100);
~se.amp = StepList.newFrom((1..8)/8);
~se.dur = 1/4;
WindowDef(\gui, { 
	~envEventView.new(~se, ~se.asParamGroup).makeLayout 
}).front;
)

// ~stepEventCoinView
WindowDef(\gui, { ~stepEventCoinView.new(StepEvent.new).asView }).front


// PlayerWrapperView

PlayerWrapper(Pdef(\bla)).edit;
WindowLayout({ PlayerWrapperView(EventPlayerWrapper(~clipTimeline.new(\hey))).view })
WindowLayout({ PlayerWrapperView(~clipTimeline.new(\hey)).view })

// PlayerWrapperSelectorView
WindowLayout({ PlayerWrapperSelectorView(PlayerWrapper(Pdef(\bla))).view })

// PlayerWrapperSelectorView + ~view_selector
(
ParamProto.init;
WindowLayout({ 
	var players = [Pdef(\bla), Pdef(\bla2)];
	var selector = ~view_selector.new(players.size);
	var views;
	views = players.collect({ arg pla, idx;
		var selview = PlayerWrapperSelectorView(PlayerWrapper(pla)).selectAction_({ arg my, view;
			selector.select_item(idx)
		});
		selview.view;
	});
	selector.views = views;
	// after setting view to avoid error
	selector.select_action = { arg self, view;
		view.debug("selected");
		view.selected = true;
	};
	selector.deselect_action = { arg self, view;
		view.debug("deselected");
		view.selected = false;
	};
	selector.select_item(0);
	VLayout(* views ++ [ nil ]);
});
)

// PlayerWrapperSelectorView + ~view_selector_group // NOT_IMPLEMENTED
//var selector = PlayerWrapperSelectorView.selectorGroup.new; // idea ?
(
ParamProto.init;
WindowLayout({ 
	var players = [Pdef(\bla), Pdef(\bla2)];
	var selector = ~view_selector_group.new;
	VLayout(* 
		players.collect({ arg pla, idx;
			PlayerWrapperSelectorView(PlayerWrapper(pla))
			.selectAction_({ arg my, view;
				selector.select_item(idx)
			})
			.selectorGroup_(selector);
			.view;
		})
		++ [ nil ]
	);
});
)

// ~view_selector default with button

(
ParamProto.init;
WindowLayout({ 
	var players = [Pdef(\bla), Pdef(\bla2)] ++ 8.collect({ arg x; Pdef(\rah+++x) });
	var selector = ~view_selector.new(players.size, { arg idx;
		// action
		PlayerWrapper(players[idx]).togglePlay;
	}, { arg view, idx;
		// view init (by default, a XSimpleButton)
		view.label = players[idx].key;
	});
	VLayout(* selector.views ++ [ nil ]);
});
)

// ======== new gui components
(
WindowDef(\gui, { 
	SampleChooserView.new
		.label_("hello")
		.color_(Color.red)
		.action_({ arg but; but.color_(Color.black)
	})
}).front;
)



// ======== redefine basic gui components

// BasicButton (was earlier XSimpleButton)
// easier to set independently color and text
(
WindowDef(\gui, { 
	BasicButton.new
		.label_("hello")
		.color_(Color.red)
		.action_({ arg but; but.color_(Color.black)
	})
}).front;
)

// XEnvelopeView
// standard EnvelopeView doesn't provide a symetric getEnv/setEnv

(
WindowDef(\gui, { 
	var env = XEnvelopeView.new;
	env.setEnv(Env([0.1,0.12,0.32],[1,2,1])); // env level is normalized
	env.action = { arg view;
		view.getEnv.asCompileString.debug("new env!!");
		XEnvSpec(\freq!3, \delay).map(view.getEnv).asCompileString.debug("mapped env!")
	};
	//XEnvelopeView.new.getEnv(Env([0.1,0.12,0.32],[1,2,1]));
}).front;
)


// XStaticText
// no value method in StaticText make it less generic when mixed with others views
WindowDef(\gui, { XStaticText.new.value_("hello") }).front;


// ======== timelines

// ~noteTimelinePanelView
~noteTimeline.new(\line).edit

// ~envTimelinePanelView
~envTimeline.new(\line2, Param(Pdef(\bla), \fratio)).edit

// ~clipTimelinePanelView
~clipTimeline.new(\clips).edit

// ============= utils

Window.keyDownActionTest

