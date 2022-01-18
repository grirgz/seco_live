
(
	// todo:
	// - popup to choose param type
	//		- way to save the old value
WindowDef(\PbindefEditor, (

	makePstepSeq: { arg self;
		PstepSeq(0!8,inf);
	},

	makeParamView: { arg self, param;
		var labelView, editorView, textView;
		textView = TextField.new.mapParam(param, 5).maxWidth_(60);
		labelView = StaticText.new.mapParamLabel(param).minWidth_(50);
		labelView.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
			if(buttonNumber == 1) {
				WindowDef(\OverlayMenu).front(view, x, y, { arg def;
					VLayout (
						BasicButton.new.string_("Make PstepSeq").action_({
							var entry = self.proxy.source.at(param.property);
							Log(\Param).debug("make pstepseq");
							if(entry.isNil) {
								self.proxy.source.set(param.property, self.makePstepSeq);
							} {
								entry.source = self.makePstepSeq;
							};
							self.proxy.changed(\keyForm);
						}),
						BasicButton.new.string_("Override pattern").action_({
							var entry = self.proxy.source.at(param.property);
							Log(\Param).debug("make pstepseq");
							if(entry.isNil) {
								self.proxy.source.set(param.property, Pkey(param.property));
							} {
								entry.source = Pkey(param.property);
							};
							self.proxy.changed(\keyForm);
						}),
					)
				});
			};
			true;
		});
		editorView = View.new;
		editorView.followChange(self.proxy, \keyForm, {
			Log(\Param).debug("editorView: followChange");
			editorView.removeAll;
			case(
				{ self.proxy.source.at(param.property).source.isKindOf(PstepSeq) }, {
					editorView.layout = HLayout(param.at(\stepseq).asMultiSlider).margins_(0).spacing_(0);
					textView.visible = false;
				},
				{ self.proxy.source.at(param.property).source.isKindOf(Number) }, {
					editorView.layout = HLayout(param.asSlider.orientation_(\horizontal)).margins_(0).spacing_(0);
					textView.visible = true;
					
				}, {
					editorView.layout = HLayout(param.asSlider.orientation_(\horizontal)).margins_(0).spacing_(0);
					textView.visible = true;
					
				}
			)
		});
		HLayout (
			labelView,
			editorView,
			textView,
		)	
	},

	makeParamGroupView: { arg self, pgroup;
		VLayout(
			* pgroup.collect { arg param, idx;
				self.makeParamView(param)
			} ++ [nil];
		)
	},

	makeInstrView: { arg self, proxy;
		var instrparam;
		var paramlistView = View.new;
		instrparam = Param( proxy, \instrument, TagSpecDef(\SynthDef_keys));
		instrparam.onChange({ arg view, param;
			view.removeAll;
			view.layout = self.makeParamGroupView(proxy.asParamGroup);
		}, paramlistView);
		paramlistView.layout = self.makeParamGroupView(proxy.asParamGroup);
		VLayout (
			HLayout (
				PlayerWrapper(proxy),
				instrparam.asValuePopUpMenu.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
					[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");

					if(buttonNumber == 1) {
						WindowDef(\GlobalLibrary_select).front(nil, { arg synth;
							synth.debug("synth");
							instrparam.set(synth.last.key);

						}, [\SynthDef])
					}
				}),
			),
			paramlistView,
		)
	},

	asView: { arg self, def, proxy;
		self.proxy = proxy;
		self.makeInstrView(proxy);

	},
)).front(Pbindef(\pb));
);

(
Pbindef(\pb, 
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1,
).play;
);

PdefParam.instrument(Pbindef(\pb))

Pbindef(\pb).source.at(\degree)
Pbindef(\pb).source.at(\freq)

//////////////////

// instrument selector

(
Pdef(\zed, 
	Pbind(
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);
Pdef(\zed).edit;

(
WindowDef(\win, { arg def, proxy;
	var instrparam;
	var paramlistView = View.new;
	instrparam = Param( proxy, \instrument, TagSpecDef(\SynthDef_keys));
	instrparam.onChange({ arg view, param;
		view.removeAll;
		view.layout = proxy.asParamGroup.asView;
	}, paramlistView);
	paramlistView.layout = proxy.asParamGroup.asView;
	VLayout (
		HLayout (
			PlayerWrapper(proxy),
			instrparam.asValuePopUpMenu.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
				[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");

				if(buttonNumber == 1) {
					WindowDef(\GlobalLibrary_select).front(nil, { arg synth;
						synth.debug("synth");
						instrparam.set(synth.last.key);

					}, [\SynthDef])
				}
			}),
		),
		paramlistView,
	)
	
}).front(Pdef(\zed));
);

Pdef(\zed).get(\out)

BusDef(\bla,\audio)

TagSpecDef(\Tag_SynthDef).addUnique(\o)

(
~get_by_tag = { arg tag, class;
	var res = List.new;
	Halo.lib.dictionary.keysValuesDo { arg key,val;
		if(val[\tag].keys.includes(tag)) {
			if(class.isNil or: {key.isKindOf(class)}) {
				res.add(key)
			}
		}
	};
	res;
};
~get_by_tag.(\bla).do(_.postln);
~get_by_tag.(\cool, SynthDef);
)

(
SynthDef(\saw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDesc(\saw).addTag(\cool).addTag(\bla);
SynthDesc(\leady).addTag(\cool).addTag(\lead);
);

Pdef(\zed).addTag(\hehe)

WindowDef(\PdefInstrumentEditor, { arg def, instr;
	var target = instr.source;
	var pwrapper = PlayerWrapper(target);
	var paramView = View.new;
	paramView.followChange(instr, \source, {
		pwrapper.target = target;
	});
	paramView.followChange(instr, \playerSynthDef, {
		Log(\Param).debug("paramView: followChange playerSynthDef");
		paramView.removeAll;
		paramView.layout = ParamGroupLayout.two_panes(target.asParamGroup(nil, false, [\gate, \doneAction]));
	});
	VLayout(
		HLayout (
			pwrapper.asView,
			Param(Message(instr), \playerSynthDef, TagSpecDef(\SynthDef_keys)).asPopUpMenu,
			if(target.getHalo(\edit).notNil) {
				BasicButton.new.string_("Special edit").action_({
					target.getHalo(\edit).value(target);
				})
			}
		),
		paramView,
	);
});



//////////////////////
// need to write a Param Pbindef wrapper \lpfr -> \source
