
(
WindowDef(\SimpleMainPanel, { arg def;
	var meter = SimpleServerMeterView.new(nil, 0,2);
	//var meter = ServerMeterView.new;
	def.windowDo { arg win;
		win.autoRememberPosition(\SimpleMainPanel);
	};
	HLayout (
		meter.view,
		VLayout (
			HLayout (
				StaticText.new.string_("quant:"),
				Param(Message(Pdef), \defaultQuant).asTextField.fixedWidth_(50)
			),
			HLayout (
				StaticText.new.string_("tempo:"),
				Param(Message(TempoClock.default), \tempo).asTextField.fixedWidth_(50)
			),
			nil,
		),
		[VLayout (
			HLayout (
				PlayerWrapper(Pdef(\main)).asView,
				PlayerWrapper(Pdef(\part)).asView,
				PlayerWrapper(Pdef(\part2)).asView,
				PlayerWrapper(Pdef(\part3)).asView,
				PlayerWrapper(Pdef(\part4)).asView,
				nil,
			),

			HLayout (
				BasicButton.new.string_("Play master").action_({
					~master.();
				}),
				PlayerWrapper(ProtoDef(\simpleMixer)).label_("mixer").asView,
				PlayerWrapper(ProtoDef(\rdn)).asView,
				PlayerWrapper(ProtoDef(\rdn2)).asView,
				PlayerWrapper(ProtoDef(\rdn3)).asView,
				PlayerWrapper(ProtoDef(\rdn4)).asView,
			),
			HLayout (
				BasicButton.new.string_("Timeline").action_({
					ClipTimeline(\mainTimeline).edit
				}),
				BasicButton.new.string_("TrackList").action_({
					TrackDef(\mygrid, TrackTemplateDef(\TrackList)).edit;
				}),
				BasicButton.new.string_("TrackGrid").action_({
					TrackDef(\mygrid, TrackTemplateDef(\TrackList)).edit;
				}),
				BasicButton.new.string_("Main window").action_({
					WindowDef(\main).front;
				}),
				BasicButton.new.string_("PANIC").action_({
					CmdPeriod.run;
				}),
				nil,
			),
			HLayout (
				BasicButton.new.string_("Mixer").action_({
					ProtoDef(\simpleMixer).edit
				}),
				BasicButton.new.string_("Fx").action_({
					WindowDef(\FxManager).front
				}),
				BasicButton.new.string_("Workspace").action_({
					WindowDef(\WorkspaceView).front;
				}),
				BasicButton.new.string_("Sample Manager").action_({
					WindowDef(\SampleTimelineManager).front
				}),
				BasicButton.new.string_("...").action_({
					WindowDef(\SimpleMainPanelOverlayMenu).front
				}).maxWidth_(30),
				nil,
			),
		), stretch:2],
	).margins_(5).spacing_(5)
});

WindowDef(\SimpleMainPanelOverlayMenu, { arg def, model, view, x=600, y=600;
	var inview, layout;
	[x, y].debug("xy");
	def.windowDo { arg win;
		var ab = view !? {view.absoluteBounds} ? Rect(0,0,600,600);
		win.bounds = Rect(x+ab.origin.x, Window.screenBounds.height - ab.top - y, 200,100);
		win.endFrontAction = { win.close };
	};
	inview = View.new;


	layout = VLayout (
		BasicButton.new.string_("Scope").action_({
			s.scope
		}),
		BasicButton.new.string_("FreqScope").action_({
			s.freqscope
		}),
		BasicButton.new.string_("Nodes").action_({
			s.plotTree
		}),
		BasicButton.new.string_("Meter").action_({
			s.meter
		}),
		nil
	);
	//def.windowDo { arg win;
		//win.setInnerExtent(view.bounds.extent.min(20));
	//};
	inview.layout_(layout);
	
}).border_(false);
)

// END

WindowDef(\SimpleMainPanel).frontTop;




BusDef(\bla, \audio, 2).isKindOf(Bus)
1.index
(
WindowDef(\SimpleServerMeterViewTest, {
	VLayout (
		SimpleServerMeterView.new(Server.default, 0, 2, BusDef(\bla, \audio, 2)).view,
		SimpleServerMeterView.new(Server.default, 0, 2, BusDef(\bla2, \audio, 2)).view,
	)
	//View.new.layout_(HLayout(BasicButton.new))
}).front;
)

SimpleServerMeterView.serverMeterViews
~a = MultiLevelIdentityDictionary.new
~a.put(1,2,43)
~a[3][3]
~a.at(3,3)
~a.removeAt(1,2)
~a
~a[1][2]

(
Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \default,
			\out, BusDef(\bla, \audio, 2),
			\degree, Pseq([0],inf),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\out, BusDef(\bla2, \audio, 2),
			\degree, Pseq([0],inf),
			\dur, 1/4,
			\amp, 0.1,
		)
	]),
).play;
);
(
Pbind(
	\instrument, \default,
	//\out, BusDef(\bla, \audio, 2),
	\freq, 200,
	\dur, 1,
	\amp, 0.1,
).play
)
