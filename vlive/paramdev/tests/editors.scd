
(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
PlayerWrapper(Ndef(\zed)).edit


////////////// menu

(
WindowDef(\win, { arg def;
	StaticText.new.string_("hello").mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		if(buttonNumber == 1) {
			WindowDef(\testmenu).source.value(nil,"2").front;
		};
	})
	
}).front;
)
(
WindowDef(\testmenu, { arg def, arg1;
	Menu(
		MenuAction("hello", { "hello".postln; }),
		MenuAction("hello" ++ arg1, { "hello2".postln; })
	)
});
)
WindowDef(\testmenu).build
WindowDef(\testmenu).source.value.front

(
// Menu
WindowDef(\ParamGenericContextMenu, { arg def, param;
	Menu(
		MenuAction(param.fullLabel).enabled_(false),
		Param(Message(param), \inBusMode, ParamBoolSpec()).asMenuAction("Bus mode"),
		MenuAction("Override pattern", {
			if(param.target.isKindOf(EventPatternProxy)) {
				Pbindef(param.target.key, param.propertyRoot, Pkey(param.propertyRoot));
			} {
				Log(\Param).info("Can't override, not an EventPatternProxy");
			}
		}),
		MenuAction("Set Combinator mode", {
			var combi;
			combi = ParamCombinator(param).setBusMode(true);
			WindowDef(( \ParamCombinator_++param.fullLabel ).asSymbol, WindowDef(\ParamCombinatorEditor)).front(combi);
			//param.set(param.default)
		}),
		MenuAction("Set default", {
			param.set(param.default)
		}),
		MenuAction("Unset", {
			param.unset;
		}),
		MenuAction.separator,

		MenuAction("MIDI CC learn and map", {
			var midi = param.target.getHalo(\MIDIFunc, param.property);
			if(midi.notNil) {
				midi.free;
				param.target.addHalo(\MIDIFunc, param.property, nil);
			};
			midi = MIDIFunc.cc({ arg ... args;
				//args.debug("MENU MIDI Func");
				param.normSet(args[0]/127)
			}).fix.learn;
			param.target.addHalo(\MIDIFunc, param.property, midi);
		}),
		MenuAction(
			if(param.target.getHalo(\MIDIFunc, param.property).notNil) {
				"Clear MIDI (%)".format(param.target.getHalo(\MIDIFunc, param.property).msgNum);
			} {
				"Clear MIDI (not set)";
			}
		, {
				var midi = param.target.getHalo(\MIDIFunc, param.property);
				if(midi.notNil) {
					midi.free;
					param.target.addHalo(\MIDIFunc, param.property, nil);
				};
		}),

		MenuAction.separator,
		MenuAction("Spec editor", {
			WindowDef(\ParamSpecEditor).front(param)
		})
	)

});
WindowDef(\ParamGenericContextMenu).sourceValue(Param(Pdef(\bla, \lpfr))).front
);

ParamProto.init
	VLayout (
		StaticText.new.string_(param.fullLabel),
		Param(Message(param), \inBusMode, ParamBoolSpec()).asButton("Bus mode"),
		BasicButton.new.string_("Override pattern").action_({
			if(param.target.isKindOf(EventPatternProxy)) {
				Pbindef(param.target.key, param.propertyRoot, Pkey(param.propertyRoot));
			} {
				Log(\Param).info("Can't override, not an EventPatternProxy");
			}
		}),
		BasicButton.new.string_("Set Combinator mode").action_({
			var combi;
			combi = ParamCombinator(param).setBusMode(true);
			WindowDef(( \ParamCombinator_++param.fullLabel ).asSymbol, WindowDef(\ParamCombinatorEditor)).front(combi);
			//param.set(param.default)
		}),
		BasicButton.new.string_("Set default").action_({
			param.set(param.default)
		}),
		BasicButton.new.string_("Unset").action_({
			param.unset;
		}),
		HLayout (
			BasicButton.new.string_("MIDI CC learn and map").action_({
				var midi = param.target.getHalo(\MIDIFunc, param.property);
				if(midi.notNil) {
					midi.free;
					param.target.addHalo(\MIDIFunc, param.property, nil);
				};
				midi = MIDIFunc.cc({ arg ... args;
					//args.debug("MENU MIDI Func");
					param.normSet(args[0]/127)
				}).fix.learn;
				param.target.addHalo(\MIDIFunc, param.property, midi);
			}),
			midiClearButton = BasicButton.new.string_(
				if(param.target.getHalo(\MIDIFunc, param.property).notNil) {
					"Clear MIDI (%)".format(param.target.getHalo(\MIDIFunc, param.property).msgNum);
				} {
					"Clear MIDI (not set)";
				}
			).action_({
					var midi = param.target.getHalo(\MIDIFunc, param.property);
					if(midi.notNil) {
						midi.free;
						param.target.addHalo(\MIDIFunc, param.property, nil);
					};
			}),
		),
		StaticText.new.string_(""),
		StaticText.new.string_("Spec editor"),
		WindowDef(\ParamSpecEditor).embedView(def, param),
		nil
	)


	(
		~image = Image(64, 64).draw({
			Pen.fillColor = Color.blue;
			Pen.fillOval(Rect(0, 0, 64, 64));

		});

		~menu = Menu(
			MenuAction("checked", { "checked".postln  })
			.checked_(true),

			MenuAction("disabled", { "disabled".postln  })
			.enabled_(false),

			MenuAction("keyboard short", { "keyboard short".postln  })
			.shortcut_("Ctrl+Shift+N"),

			MenuAction("icon", { "icon".postln  })
			.icon_(~image),

			MenuAction("font", { "font".postln  })
			.font_(Font("Helvetica", 20, italic:true)),

			MenuAction.separator.string_("other stuff"),

			CustomViewAction(Slider().orientation_(\horizontal)).action_({ |v| v.value.postln  }),

			Menu(
				"string.toAction",
				{ "function.toAction".postln  }

			).title_("submenu")

		).front;

	)


(
~view = View().layout_(HLayout(
    ToolBar(
        MenuAction("Min", { ~slider.value = 0 }),
        MenuAction("Max", { ~slider.value = 1 }),
        CustomViewAction(
            ~slider = Slider().orientation_(\horizontal)
        ),
        Menu(
            MenuAction("Randomize", { ~multi.value = 4.collect({ 1.0.rand }) }),
            CustomViewAction(
                ~multi = MultiSliderView().drawLines_(true).elasticMode_(true).value_([0, 1, 0, 1])
            )
        ).title_("Submenu").action_({ "kjk".postln; })
    ).minWidth_(400)
)).front;
)
