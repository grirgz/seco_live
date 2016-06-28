
Param 


How to control a pattern parameter with GUI and controller ?

(
SynthDef(\sound1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fm=1, fmamp=0.5, lpf=2, rq=0.3;
	var sig;
	freq = freq * ( 1 + ( SinOsc.ar(fm * freq) * fmamp ));
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, lpf * freq, rq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\pat1,
	Pbind(
		\instrument, \sound1,
		\degree, Pseq([1,2,4],inf),
		\dur, 1,
		\amp, 0.1
	);
).play;
)
Param(Pdef(\pat1), \fm, ControlSpec(0,10,\lin)).edit;


Nice, how if I want a panel to edit every parameter of the SynthDef \sound1 ?

Pdef(\pat1).asParamGroup.edit

Cool, but it's a bit ugly, i want to build my own GUI


(
	~win = Window.new;
	~params = Pdef(\pat1).asParamGroup;
	~win.layout = VLayout(
		StaticText.new.string_("My pat1 editor"),
		HLayout(
			* ~params.collect({ arg param;
				VLayout(
					param.asStaticTextLabel,
					param.asKnob.fixedSize_(50@50),
					param.asStaticText,
				)
			})
		)
	);
	~win.front;
)

Let's introduce a little feature which manage the window for you: replace the current window if already existing and remember size and position
The last value of the function is used as the content of the window

(
WindowDef(\pdef_editor, {
	var params, win;
	params = Pdef(\pat1).asParamGroup;
	VLayout(
		StaticText.new.string_("My pat1 editor"),
		HLayout(
			* params.collect({ arg param;
				VLayout(
					param.asStaticTextLabel,
					param.asKnob.fixedSize_(50@50),
					param.asStaticText,
				)
			})
		)
	);
}).front
)

You can also pass arguments when creating, let's use this feature to make the GUI independant of the controller Pdef:
The first argument is always the WindowDef instance, the others are the arguments passed to .front


(
WindowDef(\pdef_editor, { arg me, pdef;
	var params, win;
	win = me.window; // access to window to set title, 
	if(win.notNil) { // check because there is maybe no window
		me.window.name = "My Win"; 
	};
	me.window.debug("WINDOW????");
	pdef = pdef ? Pdef(\pat1); // default pdef
	params = pdef.asParamGroup;
	VLayout(
		StaticText.new.string_("My % editor".format(pdef.key)),
		HLayout(
			* params.collect({ arg param;
				VLayout(
					param.asStaticTextLabel,
					param.asKnob.fixedSize_(50@50),
					param.asStaticText,
				)
			})
		)
	);
}).front
)

(
Pdef(\pat2, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);

WindowDef(\pdef_editor).front(Pdef(\pat2));
WindowDef(\pdef_editor2, WindowDef(\pdef_editor).source); // create another editor as a copy of the first
WindowDef(\pdef_editor2).front(Pdef(\pat1));

// now create a window with two pdef editor
(
WindowDef(\main, {
	VLayout(
		WindowDef(\pdef_editor).asView(Pdef(\pat1)),
		WindowDef(\pdef_editor).asView(Pdef(\pat2)),
	)
}).front
)


Now let's build a sequencer



(
Pdef(\seq1, 
	StepEventDef(\seq1)
);
)

StepEventDef(\seq1)[\degree] = StepList[1,2,3,4];
StepEventDef(\seq1)[\amp] = StepList.newFrom([1,2,3,4]/4);
StepEventDef(\seq1)[\instrument] = \sound1;
StepEventDef(\seq1)[\lpf] = 10;
StepEventDef(\seq1)[\dur] = 1/4;
StepEventDef(\seq1).repeats = inf;
StepEventDef(\seq1);
StepEventDef(\seq1)[\degree].addSpec(\list, ControlSpec(-28,28,\lin,1));
StepEventDef(\seq1)[\amp].addSpec(\list, \unipolar);
StepEventDef(\seq1).addSpec(\amp, \unipolar);
Param(StepEventDef(\seq1), \lpf, \freq).edit

StepEventDef(\seq1).asPattern.asStream.next(());

(
	WindowDef(\seq1, {
		var se = StepEventDef(\seq1);
		VLayout(
			HLayout(
				PlayerWrapper(Pdef(\seq1)).asView,
				HLayout(
					StaticText.new.string_("Size:"),
					Param(Message(se), \stepCount).asNumberBox.fixedWidth_(40),
				).margins_([20,0]),
				HLayout(
					StaticText.new.string_("Repeats:"),
					Param(Message(se), \repeats).asNumberBox.fixedWidth_(40),
				),
				[nil, stretch:1],
			),

			VLayout( *
				se.keys.asList.collect { arg key;
					HLayout(
						StaticText.new.string_(key).fixedWidth_(100),
						if(se[key].isKindOf(StepList)) {
							var view = StepListColorView.new(se[key]).setCursor;
							view.asView;
						} {
							if(se[key].isKindOf(Number)) {
								StepListColorView.new(ParamGroup([Param(se, key)])).asView;
							} {
								HLayout(
									Param(se, key).asTextField.fixedWidth_(200),
									nil
								)
							}
						},
					)
				}
				++ [nil]
			).spacing_(0)
		)

	}).front;
)
[Param(Pdef(\pat1), \freq)].asParam
ParamGroup([Param(Pdef(\pat1), \freq), Param(Pdef(\pat2), \freq)]).asParam
WindowDef(\gg, { ListParamLayout.knob([Param(Pdef(\pat1), \freq)]) }).front
WindowDef(\gg, { StepListColorView.new([Param(Pdef(\pat1), \freq)]).asView }).front
WindowDef(\gg, { StepListColorView.new(ParamGroup([Param(Pdef(\pat1), \freq)])).asView }).front
WindowDef(\gg, { StepListColorView.new(Param(List[1,2], \list)).asView }).front
WindowDef(\gg, { ListParamLayout.knob(Param(List[1,2], \list)) }).front
WindowDef(\gg, { ListParamLayout.knob(Param(List[1,2], \list)) }).front

(
WindowDef(\gg, { 
	~sc = StepListColorView.new(nil, { arg param;
		param.asSlider
	});
	~sc.asView
}).front
)

~sc.mapStepList(StepList.newFrom(1!32), { arg p; p.asKnob.fixedWidth_(45) })

(
	// select line with popup
	WindowDef(\eline, { arg me, se, key;
		if(se[key].isKindOf(StepList)) {
			var view = StepListColorView.new(se[key]).setCursor;
			HLayout(view.asView).spacing_(0).margins_(0);
		} {
			if(se[key].isKindOf(Number)) {
				HLayout(StepListColorView.new(ParamGroup([Param(se, key)])).asView).spacing_(0).margins_(0);
			} {
				HLayout(
					Param(se, key).asTextField.fixedWidth_(200),
					nil
				).spacing_(0).margins_([0,13])
			}
		};
	});
	//WindowDef(\eline).front(StepEventDef(\seq1), \amp);


	WindowDef(\seq1, { arg me, se;
		var valview;
		se = se ? StepEventDef(\seq1);
			valview = View.new;

			HLayout(
				PlayerWrapper(se[\playertarget].debug("playertarrr") ?? { Pdef(se.key, se) }).asView,
				Param(Message(se), \stepCount).asNumberBox.fixedWidth_(40),
				Param(Message(se), \repeats).asNumberBox.fixedWidth_(40),
				PopUpMenu.new.items_(se.keys.asArray.sort).action_({ arg view;
					valview.removeAll;
					if(view.items.size > 0) {
						valview.layout = WindowDef(\eline).asView(se, view.items[view.value].asSymbol).debug("view!!");
					};
				}).valueAction_(0).fixedWidth_(100),
				valview,
				nil,
			)

	});

	WindowDef(\parseq, { arg me, selist;
		VLayout(*
			selist.collect({ arg se;
				[WindowDef(\seq1).asView(se), stretch:0]
			})
			++ [ nil ]
		).spacing_(0)
	});

	WindowDef(\parseq).front([
		StepEventDef(\seq1),
		StepEventDef(\seq2),
		StepEventDef(\seq3),
	]);
)

StepEventDef(\seq1).keys.asList.sort
StepEventDef(\seq2).keys.asList.sort
(
)

StepEventDef(\seq2)
StepEventDef(\seq2).putAll((
	\degree: StepList[1,2,3,4],
	\amp: StepList.newFrom([1,2,3,4]),
	\instrument: \sound1,
));


StepEventDef(\seq3).repeats = inf
StepEventDef(\seq3).dur = 1/8
StepEventDef(\seq3).playertarget = Ndef(\seq3)
StepEventDef(\seq3).putAll((
	\freq: StepList[100,300,1200,702],
));
(
Ndef(\seq3).put(0, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
Ndef(\seq3).put(1, \set -> StepEventDef(\seq3).asPattern);
);

StepEventDef(\seq3).asPattern.asStream.next(())
StepEventDef(\seq3)
Ndef(\seq3).set(\out, BusDef(\bus1, \audio, 2).index)
