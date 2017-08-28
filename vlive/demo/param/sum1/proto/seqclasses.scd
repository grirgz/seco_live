
// list example of every gui class included in the Param quark
////////////////////////////////////////////////////////////////

///////////// Windows

//// WindowLayout
// build automatically a window around the view code, accept layouts and views
// just a conveniant way to avoid rewritting Window.new and grouping GUI code in a function
(
WindowLayout({
	VLayout(
		Button.new,
		Button.new,
	)
})
)

//// WindowDef
// solve the recurrent problem of having a new window each time you run your code
// remember size and position of window
// easy way to store and recall GUIs

(
WindowDef(\mygui, {
	VLayout(
		Button.new,
		Button.new,
	)
}).front
)

WindowDef(\mygui).front;
WindowDef(\mygui).frontTop; // always on top

////////////////////////////////////////////// Param simple GUI

Param(Pdef(\bla), \lpf).edit; // a simple gui for quick testing

(
	WindowDef(\gui, {
		var param = Param(Pdef(\bla), \lpf);
		HLayout(
			param.asView, // default is asKnob
			param.asKnob,
			param.asSlider,
			param.asTextField,
			param.asStaticTextLabel,
			param.asNumberBox,
			param.asStaticText,
			param.asButton,
		)
	}).front
)

//// params of type Array
// see also ParamListLayout for other layouts of arrays
// FIXME: this is bugged

(
	WindowDef(\gui, {
		var param = Param(Pdef(\bla), \freqs, XArraySpec(\freq!4));
		VLayout(
			param.asView, // default is asMultiSlider
			param.asMultiSlider,
			param.asTextField,
			param.asStaticTextLabel,
			param.asStaticText,
		)
	}).front
)

//// params of type Env
Pdef(\bla).set(\freqs, nil)

(
	WindowDef(\gui, {
		var param = Param(Pdef(\bla), \env, XEnvSpec(\freq!4, \delay));
		VLayout(
			param.asView, // default is asEnvelopeView
			param.asEnvelopeView,
			param.asTextField,
			param.asStaticTextLabel,
			param.asStaticText,
		)
	}).front
)

//// params of type index in a list
// bug: with Pdef, it think it's a bus since it's a symbol

(
	WindowDef(\gui, {
		var param = Param((type:\saw), \type, MenuSpec([\sin, \saw, \pulse]));
		param.type.debug("param type");
		VLayout(
			param.asView, // default is asPopUpMenu which is PopUp on value
			param.asPopUpMenu,
			PopUpMenu.new.mapValueParam(param),
		)
	}).front
)

//// indexPopup
// FIXME: maybe asPopUpMenu should detect index type MenuSpec automatically like mapPopUpMenu

(
	WindowDef(\gui, {
		var param = Param((type:1), \type, MenuSpec.index([\sin, \saw, \pulse])); 
		HLayout(
			param.asIndexPopUpMenu
		)
	}).front
)

//////////////////////////////////////////////

// Param.asView -> MultiSliderView
StepList[1,2,4].edit

// StepListView
WindowDef(\gui, { StepListView.new(StepList[1,2,4]).asView }).front

// StepListColorView
WindowDef(\gui, { StepListColorView.new(StepList[1,2,4]).asView }).front

// ListParamLayout

WindowDef(\gui, { ListParamLayout.knob(Param(StepList[1,2,4], \list)) }).front
WindowDef(\gui, { ListParamLayout.button(Param(StepList[1,2,4], \list)) }).front
WindowDef(\gui, { ListParamLayout.slider(Param(StepList[1,2,4], \list)) }).front
WindowDef(\gui, { ListParamLayout.gridButton(Param(StepList[1,2,4], \list)) }).front // due to bug now solved, deprecated
WindowDef(\gui, { ListParamLayout.valuePopup(Param(StepList[\c,\a, \b,\b], \list), [\a,\b,\c]) }).front
WindowDef(\gui, { ListParamLayout.indexPopup(Param(StepList[2,0,1,1], \list), [\a,\b,\c]) }).front


// full ListParamLayout example
(
~line = StepList.newFrom([200,1000,200,100].mirror.mirror);
~symline = StepList.newFrom([\a,\c,\c,\b].mirror);
~idxline = StepList.newFrom([0,1,2,1].mirror);
~pc = PseqCursor(~line,inf);
Pdef(\test, Pbind(
	\instrument, \default,
	\freq, ~pc,
	\dur, 1,
	\amp, 1.1
).trace).play;

WindowDef(\gui, { 
	var knobs;

	// custom processing thought .viewlist
	knobs = ListParamLayout.knob(~line.asParam);
	knobs.viewlist.do({ arg vi; vi.color_([Color.white, Color.red, Color.blue, Color.green]) });

	VLayout (
		knobs,
		ListParamLayout.knob(~line.asParam),
		ListParamLayout.slider(~line.asParam),
		ListParamLayout.button(~line.asParam),
		ListParamLayout.cursor(~line.asParam),
		ListParamLayout.valuePopup(~symline.asParam, [\a,\b,\c]),
		ListParamLayout.indexPopup(~idxline.asParam, [\a,\b,\c]),

		// boxes
		View.new.layout_(VLayout (
			ListParamLayout.button(~line.asParam),
			ListParamLayout.cursor(~line.asParam),
		)).background_(Color.grey),
		View.new.layout_(VLayout (
			ListParamLayout.knob(~line.asParam),
			ListParamLayout.slider(~line.asParam),
		)).background_(Color.white),

		ListParamLayout.gridButton(~line.asParam), // no fixed width currently
	)
}).front
)

// custom widget ListParamLayout
// explain what is the point compared to HLayout(param.collect(makecell)) ?
// maybe use .onChange

(
WindowDef(\gui, { 
	ListParamLayout.new(Param(StepList[2,0,1,1], \list), { arg param;
		var view = TextField.new;
		view.value = param.get;
		view.action = { arg vi;
			param.set(vi.value)
		};
	});
}).front;
)

////////// Cursor

// ListParamLayout cursor with List

(
~list = List.newFrom([200,1000,200,100]);
Pdef(\test, Pbind(
	\instrument, \default,
	\freq, PseqCursor(~list,inf),
	\dur, 1,
	\amp, 1.1
).trace).play;

WindowDef(\gui, { 
	var param = Param(~list, \list);

	VLayout (
		ListParamLayout.slider(param),
		ListParamLayout.cursor(param),
	)
}).front
)

// ListParamLayout cursor with StepList

(
~list = StepList.newFrom([200,1000,200,100]);
Pdef(\test, Pbind(
	\instrument, \default,
	//\freq, PseqCursor(~list,inf),
	\freq, Pn(~list.asPattern,inf),
	\dur, 1,
	\amp, 1.1
).trace).play;

WindowDef(\gui, { 
	var param = ~list.asParam;

	VLayout (
		ListParamLayout.slider(param),
		ListParamLayout.cursor(param),
	)
}).front
)

// custom cursor

(
~list = StepList.newFrom([200,1000,200,100].mirror.mirror);
Pdef(\test, Pbind(
	\instrument, \default,
	\freq, Pn(~list), // call .asPattern implicitely when embbeded in Pn
	\dur, 1,
	\amp, 1.1
).trace).play;

WindowDef(\gui, { 
	VLayout (
		ListParamLayout.slider(~list.asParam),
		HLayout(*
			~list.asParam.collect({ arg elm, idx;
				var view = TextField.new;
				view.fixedWidth = 40;

				ListParamLayout.addCursor(
					idx, view, ~list.asParam, { view.value_("\\o/") }, { view.value_("_o_") } );
				view;
			})
			++ [nil]
		)
	)
}).front
)

////////////////// ParamGroupLayout
/// not really extraordinary, just conveniant layouts for re-use when building GUI for groups of Param

// asView default to ParamGroupLayout.two_panes
(
~pg = ParamGroup([
	Param(Pdef(\bla), \freq),
	Param(Pdef(\bla), \hpf),
	Param(Pdef(\bla), \env, XEnvSpec(\amp!4,\delay)),
	Param(Pdef(\bla), \rings, XArraySpec(\amp!4)),
	Param(Pdef(\bla), \amp),
]);
WindowDef(\gui, { ~pg.asView; }).front;
)

// two_panes

(
~pg = ParamGroup([
	Param(Pdef(\bla), \freq),
	Param(Pdef(\bla), \hpf),
	Param(Pdef(\bla), \env, XEnvSpec(\amp!4,\delay)),
	Param(Pdef(\bla), \rings, XArraySpec(\amp!4)),
	Param(Pdef(\bla), \amp),
]);
WindowDef(\gui, { ParamGroupLayout.two_panes(~pg); }).front;
)

// two_panes become horizontal when lot of param

(
~pg = ParamGroup([
	Param(Pdef(\bla), \freq),
	Param(Pdef(\bla), \hpf),
	Param(Pdef(\bla), \hpf),
	Param(Pdef(\bla), \hpf),
	Param(Pdef(\bla), \hpf),
	Param(Pdef(\bla), \hpf),
	Param(Pdef(\bla), \hpf),
	Param(Pdef(\bla), \env, XEnvSpec(\amp!4,\delay)),
	Param(Pdef(\bla), \rings, XArraySpec(\amp!4)),
	Param(Pdef(\bla), \amp),
]);
WindowDef(\gui, { ParamGroupLayout.two_panes(~pg); }).front;
)

// short param labels

(
~pg = ParamGroup([
	Param(Pdef(\bla), \freq),
	Param(Pdef(\bla), \hpf),
	Param(Pdef(\bla), \env, XEnvSpec(\amp!4,\delay)),
	Param(Pdef(\bla), \rings, XArraySpec(\amp!4)),
	Param(Pdef(\bla), \amp),
]);
WindowDef(\gui, { ParamGroupLayout.two_panes(~pg, \short); }).front;
)

// block (two_panes with a label band and short labels)
// FIXME: should not expand vertically like this, no ?

(
~pg = ParamGroup([
	Param(Pdef(\bla), \freq),
	Param(Pdef(\bla), \hpf),
	Param(Pdef(\bla), \env, XEnvSpec(\amp!4,\delay)),
	Param(Pdef(\bla), \rings, XArraySpec(\amp!4)),
	Param(Pdef(\bla), \amp),
]);
WindowDef(\gui, { ParamGroupLayout.block("my group", ~pg); }).front;
)

// player block (two_panes with a band with a player button)

(
~pg = ParamGroup([
	Param(Pdef(\bla), \freq),
	Param(Pdef(\bla), \hpf),
	Param(Pdef(\bla), \env, XEnvSpec(\amp!4,\delay)),
	Param(Pdef(\bla), \rings, XArraySpec(\amp!4)),
	Param(Pdef(\bla), \amp),
]);
WindowDef(\gui, { ParamGroupLayout.player_block(Pdef(\bla), ~pg); }).front;
)
// player_block with custom layout
(
~pg = ParamGroup([
	Param(Pdef(\bla), \freq),
	Param(Pdef(\bla), \hpf),
	Param(Pdef(\bla), \amp),
]);
WindowDef(\gui, { 
	ParamGroupLayout.player_block(Pdef(\bla), ~pg, HLayout(
		PopUpMenu.new, 
		XStaticText.new.value_("rah")
	));
}).front;
)

// player_preset_block with custom layout (currently use Proto class for preset selector)
// why no color band ?
(
ParamProto.init; // to load preset selector proto class
~pg = ParamGroup([
	Param(Pdef(\bla), \freq),
	Param(Pdef(\bla), \hpf),
	Param(Pdef(\bla), \amp),
]);
WindowDef(\gui, { 
	ParamGroupLayout.player_preset_block(Pdef(\bla), ~pg, XStaticText.new.value_("rah"));
}).front;
)

// inline_groups
// display scalar params by group of 8 horizontal sliders then big params in a horizontal scrolling band
(
//ParamProto.init; // to load preset selector proto class
~pg = ParamGroup([
	Param(Pdef(\bla), \freq),
	Param(Pdef(\bla), \hpf),
	Param(Pdef(\bla), \amp),
	Param(Pdef(\bla), \amp),
	Param(Pdef(\bla), \amp),
	Param(Pdef(\bla), \amp),
	Param(Pdef(\bla), \amp),
	Param(Pdef(\bla), \env, XEnvSpec(\amp!4,\delay)),
	Param(Pdef(\bla), \rings, XArraySpec(\amp!4)),
	Param(Pdef(\bla), \amp),
	Param(Pdef(\bla), \amp),
	Param(Pdef(\bla), \amp),
]);
WindowDef(\gui, { 
	ParamGroupLayout.inline_groups(~pg);
}).front;
)


////////////////////


// ~stepEventView
(
ParamProto.init;
~se = StepEvent.new;
~se.instrument = \dr_kick;
~se.freq = StepList.newFrom((1..8) * 100);
~se.amp = StepList.newFrom((1..8)/8);
~se.dur = 1/4;
WindowDef(\gui, { 
	VLayout(
		~stepEventView.new(~se).makeLayout,
		HLayout(
			PlayerWrapper(Pdef(\yep, ~se.asPattern)).asView,
			Param(Message(~se), \repeats, ControlSpec(1,inf,\lin,1,1)).asTextField,
		),
	)
}).front;
~se.repeats = 8;
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


/////////////////////////////////////////////////// // ======== timelines

/////// simple editor

// ~noteTimelinePanelView
~noteTimeline.new(\line).edit

// ~envTimelinePanelView
~envTimeline.new(\line2, Param(Pdef(\bla), \fratio)).edit

// ~clipTimelinePanelView
~clipTimeline.new(\clips).edit

///////////////////// views

// TimelineView

WindowDef(\gui, { ~tv = TimelineView.new; ~tv.mapEventList(~noteTimeline.new(\line).eventList); ~tv.view }).front

// TimelinePreview

WindowDef(\gui, { ~tv = TimelinePreview.new; ~tv.mapEventList(~noteTimeline.new(\note1).eventList); ~tv.view }).front


//////////////////////////////////////////////////////// ============= utils

Window.keyDownActionTest

/////////////////////////////////////// Context menu
(


WindowDef(\popup, {
		VLayout(
			Knob.new.mouseDownAction_({ arg view, x, y, mod, mouseButton;
				var menu = MenuSpec(
					[
						"Setmode" -> { "k".debug },
						"remove" -> { "xxxk".debug },
					]
				);
				ContextMenuWindow(menu.labelList.asArray).front(view, x, y, mouseButton).action_({ arg me, idx;
					menu.valueList[idx].value

				});
				false; // dont pass the click to Knob
			})
		)

}).front;

)
