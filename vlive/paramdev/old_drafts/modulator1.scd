
// in this serie, I need to build:
// - a pdef with a way to replace a knob with a stepsequencer
// - a pdef with a way to replace a knob with a curve timeline
//		- does this make any sense ? 
// - both stepsequencer and timeline
// - same with ndef
// - same with multiple pdefs
// - same with multiple pdefs and ndef and both step and curve
// - a pdef with a way to replace a knob with a ndef
// - a pdef with a way to replace a knob with a control pdef



////////////////////////////////////////// - a pdef with a way to replace a knob with a stepsequencer

(

	(
	SynthDef(\rlpf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		sig = LFSaw.ar(freq);
		sig = RLPF.ar(sig, \lpf.kr(4100), \rq.kr(0.5));
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;
	);

	~se = StepEvent.new;
	~se[\freq] = StepList[1000,500,200,400];
	~se[\dur] = 1/4;
	Pdef(\main,
		~se.asPattern.loop <>
		Pdef(\base,
			Pbind(
				\instrument, \rlpf,
				\freq, 200,
				\dur, 1,
				\amp, 0.1
			);
		
		)
	);

	Pdef(\base).addHalo(\instrument, \rlpf);
	Pdef(\main).play;
)

(
Spec.add(\stepCount, ControlSpec(1,64,\lin,1,8));
WindowLayout({
	
	VLayout(
		ParamGroupLayout.two_panes(Pdef(\base).asParamGroup),
		StepEventView.new(~se).view,
	)
})
)

///////////////////////////////

(
Spec.add(\stepCount, ControlSpec(1,64,\lin,1,8));
	SynthDef(\rlpf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		sig = LFSaw.ar(freq);
		sig = RLPF.ar(sig, \lpf.kr(4100), \rq.kr(0.5));
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;

		Pdef(\base_seq,
			Pbind(
				\instrument, \rlpf,
				\amp, Pkeyd(\amp,0.1),
			);
		
		);

	~modularizer_seq = (
		new: { arg self, base;
			self = self.deepCopy;
		
			self.base = base;
			self.param_group = base.asParamGroup;
			self.stepevent = StepEvent.new;
			self.stepevent.debug("new: stepevent");
			self.stepevent.addHalo(\instrument, self.base.getHalo(\instrument));
			self.stepevent.addHalo(\spec, self.base.getHalo(\spec));
			self.playerWrapper = PlayerWrapper(self.base);
			
		
			self;
		},

		add_modulator: { arg self, param;
			self.stepevent[param.property] = StepList[param.get].stepCount_(self.stepevent.stepCount);
			self.refresh_mod_list_view;
		},

		remove_modulator: { arg self, param;
			self.stepevent[param.property] = nil;
			self.refresh_mod_list_view;
		},

		bypass_modulator: { arg self, modu;
			modu.bypass = ( modu.bypass + 1 % 2 );
			self.refresh_mod_list_view;
		},

		refresh_mod_list_view: { arg self;
			self.stepevent.debug("refresh_mod_list_view: stepevent");
			if(self.mod_list_view.notNil) {
				var keys;
				self.mod_list_view.removeAll;
				self.param_group_dict = Dictionary.new;
				self.param_group.do ({ arg param;
					self.param_group_dict[param.property] = param 
				});
				keys = self.stepevent.keys.asList;
				keys.sortLike(self.param_group.collect(_.property));
				self.mod_list_view.layout = VLayout(
					GridLayout.rows(
						//StaticText.new.string_("fuck"),
						* keys.collect({ arg key;
							var editor;
							var steplist;
							key.debug("what??");
							steplist = self.stepevent[key];
							editor = if(steplist.isKindOf(StepList)) {
								var param;

								// propagate spec in the steplist
								param = self.param_group_dict[key];
								if(param.notNil) {
									steplist.addSpec(\list, param.spec);
								};

								//if(steplist.bypass == 1) {
								//	StaticText.new.string_("disabled");
								//} {
								//	StepListView(steplist).view;
								//}
								StepListView(steplist).setCursor.view;
							} {
								StaticText.new.string_("empty");
							};

							[
								if(steplist.bypass == 1) {
									StaticText.new.string_("[%]".format(key));
								} {
									StaticText.new.string_(key);
								},
								editor,
							]

						}) 
					),
					nil,
				);
			}
		},

		makeLayout: { arg self;
			var param_view;
			var mod_view;
			var mod_header_view, mod_list_view;
			var param_selector;

			param_view = GridLayout.rows(
				*self.param_group.collect({ arg param;
					[
						param.asStaticTextLabel,
						param.asSlider.orientation_(\horizontal),
						param.asTextField,
					]
				})
			);

			mod_header_view = HLayout(
				param_selector = PopUpMenu.new.items_(self.param_group.collect({ arg param;
					param.property;
				})),
				XSimpleButton.new.label_("+").action_({
					var modulator = self.stepevent[param_selector.items[param_selector.value]];
					if(modulator.isNil) {
						self.add_modulator(self.param_group[param_selector.value]);
					}
				}),
				XSimpleButton.new.label_("-").action_({
					var modulator = self.stepevent[param_selector.items[param_selector.value]];
					if(modulator.notNil) {
						self.remove_modulator(self.param_group[param_selector.value]);
					}
				}),
				XSimpleButton.new.label_("bypass").action_({
					var modulator = self.stepevent[param_selector.items[param_selector.value]];
					if(modulator.notNil) {
						self.bypass_modulator(modulator);
					}
				}),
				Param(Message(self.stepevent), \stepCount).asNumberBox,
			);

			mod_list_view = View.new;
			self.mod_list_view = mod_list_view;
			self.refresh_mod_list_view;

			mod_view = VLayout(
				mod_header_view,
				ScrollView.new.canvas_(mod_list_view),
			);

			self.layout = VLayout(
				self.playerWrapper.asView,
				param_view,
				mod_view,
			);
			self.layout;
		},

		makeWindow: { arg self;
			var window = Window.new;
			var layout;
			layout = self.makeLayout;
			window.layout = layout;
			//window.alwaysOnTop = true;
			window.front;
			
		},

		as_pattern: { arg self;
			(Plazy({ self.stepevent.asPattern })  <> Plazy({ self.base })).loop;
		},

	);

	Pdef(\base_seq).addHalo(\instrument, \rlpf);
	Pdef(\base_seq).addSpec(\lpf, \freq);
	~modseq = ~modularizer_seq.new(Pdef(\base_seq));
	~modseq.playerWrapper = PlayerWrapper(Pdef(\main2));
	Pdef(\main2, ~modseq.as_pattern);
	Pdef(\main2).play;
	~modseq.makeWindow;

)

~mod.stepevent
~mod.stepevent[\midinote] = StepList[50]
~mod.stepevent[\midinote].addSpec(\list, \midinote)
~mod.stepevent.asPattern.asStream.nextN(10,())
\pan.asSpec
Param(~mod.stepevent, )
~mod.param_group
Param(Pdef('base'), 'pan').spec

~mod.stepevent[\pan].asParam

sel


(
	~se = StepEvent.new;
	~se[\blax] = StepList[1,23];
	~se[\bla] = 10;
	// FIXME:
	// - stepCount knob is not updated
	WindowLayout({

		VLayout (
			Param(Message(~se), \stepCount).asView,
			Param(Message(~se), \stepCount).asNumberBox,
			StepEventView(~se).view,
		)
	})
	  
)


(
	// sortLike

	~model = [\bla, \blu, \chien, \bac];
	~list = List[\bac, \fleur, \choix, \chien];
	~model.debug("model");
	~list.debug("before");
	//~list.sortLike(~model);
	//~list.sortLike([]);
	List[].sortLike(~model).debug("fr");
	~list.debug("after");
	
)


////////////////////////////////////////// - a pdef with a way to replace a knob with a curve timeline
Param(BusDef(\bla, \control), \bus).target

	(
	SynthDef(\rlpf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
		sig = LFSaw.ar(freq * [1,1/2,1] * [1, ( 1 + ( SinOsc.kr(1/4) * 0.1 ))]);
		sig = RLPF.ar(sig, \lpf.kr(4100), \rq.kr(0.5));
		sig1 = sig * sig.fold2( ( 1 + ( SinOsc.kr(1/3*8 + Rand(1/24,1/8)) * 1 )) );
		sig2 = sig + sig.fold2( ( 1 + ( SinOsc.kr(1/2*8 + Rand(1/24,1/8)) * 1 )) );
		//sig = sig2 * ( 1+sig1 );
		sig = SelectX.ar( SinOsc.kr(1/3).range(0.3,0.71), [sig1, sig2]);
		//sig = sig2;
		//sig1 = SinOsc.ar(sig + 1  * SinOsc.kr(1/3).range(1,70) );
		//sig = sig1;
		//sig = SelectX.ar( SinOsc.kr(1/9).range(0,1), [sig, sig1]);

		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.5,0.2),gate,doneAction:2);
		sig = Pan2.ar(sig, pan, amp).flop;
		Out.ar(out, sig);
	}).add;
	)

(
"/home/ggz/code/sc/seco/vlive/demo/param/lib/timeline.scd".load;
Spec.add(\stepCount, ControlSpec(1,64,\lin,1,8));
	SynthDef(\rlpf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		sig = LFSaw.ar(freq * [1,1.01]);
		sig = RLPF.ar(sig, \lpf.kr(4100), \rq.kr(0.5));
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;

		Pdef(\base,
			Pbind(
				\instrument, \rlpf,
				\amp, Pkeyd(\amp,0.1),
			);
		
		);

	~modularizer = (
		new: { arg self, base;
			self = self.deepCopy;
		
			self.base = base;
			self.param_group = base.asParamGroup;
			self.stepevent = StepEvent.new;
			self.stepevent.debug("new: stepevent");
			self.stepevent.addHalo(\instrument, self.base.getHalo(\instrument));
			self.stepevent.addHalo(\spec, self.base.getHalo(\spec));
			self.playerWrapper = PlayerWrapper(self.base);
			
		
			self;
		},

		add_modulator: { arg self, param;
			self.stepevent[param.property] = ~envTimeline.newInstance(
				Param(BusDef(param.property, \control), param.property, param.spec)
			);
			"eeeeeeeeeeeeee".debug;
			self.refresh_mod_list_view;
		},

		remove_modulator: { arg self, param;
			self.stepevent[param.property] = nil;
			self.refresh_mod_list_view;
		},

		bypass_modulator: { arg self, modu;
			//modu.bypass = ( modu.bypass + 1 % 2 );
			self.refresh_mod_list_view;
		},

		refresh_mod_list_view: { arg self;
			self.stepevent.debug("refresh_mod_list_view: stepevent");
			if(self.mod_list_view.notNil) {
				var keys;
				self.mod_list_view.removeAll;
				self.param_group_dict = Dictionary.new;
				self.param_group.do ({ arg param;
					self.param_group_dict[param.property] = param 
				});
				keys = self.stepevent.keys.asList;
				keys.sortLike(self.param_group.collect(_.property));
				self.mod_list_view.layout = VLayout(
					GridLayout.rows(
						//StaticText.new.string_("fuck"),
						* keys.collect({ arg key;
							var editor;
							var steplist;
							key.debug("what??");
							steplist = self.stepevent[key];
							editor = if(steplist.isKindOf(StepList)) {
								var param;

								// propagate spec in the steplist
								param = self.param_group_dict[key];
								if(param.notNil) {
									steplist.addSpec(\list, param.spec);
								};

								//if(steplist.bypass == 1) {
								//	StaticText.new.string_("disabled");
								//} {
								//	StepListView(steplist).view;
								//}
								StepListView(steplist).setCursor.view;
							} {
								if(steplist.isKindOf(Event) and: { steplist.eventType == \paramTimeline }) {
									//~envTimelinePanelView.newView(steplist).debug("panel!!!!!!!!!").makeLayout;
									~envTimelinePanelView.newView(steplist).make_header_(nil).makeLayout;
								} {
									StaticText.new.string_("empty");
								}
							};

							[
								if(steplist.bypass == 1) {
									StaticText.new.string_("[%]".format(key));
								} {
									StaticText.new.string_(key);
								},
								editor,
							]

						}) 
					),
					nil,
				);
			}
		},

		makeLayout: { arg self;
			var param_view;
			var mod_view;
			var mod_header_view, mod_list_view;
			var param_selector;

			param_view = GridLayout.rows(
				*self.param_group.collect({ arg param;
					[
						param.asStaticTextLabel,
						param.asSlider.orientation_(\horizontal),
						param.asTextField,
					]
				})
			);

			mod_header_view = HLayout(
				param_selector = PopUpMenu.new.items_(self.param_group.collect({ arg param;
					param.property;
				})),
				XSimpleButton.new.label_("+").action_({
					var modulator = self.stepevent[param_selector.items[param_selector.value]];
					if(modulator.isNil) {
						self.add_modulator(self.param_group[param_selector.value]);
					}
				}),
				XSimpleButton.new.label_("-").action_({
					var modulator = self.stepevent[param_selector.items[param_selector.value]];
					if(modulator.notNil) {
						self.remove_modulator(self.param_group[param_selector.value]);
					}
				}),
				XSimpleButton.new.label_("bypass").action_({
					var modulator = self.stepevent[param_selector.items[param_selector.value]];
					if(modulator.notNil) {
						self.bypass_modulator(modulator);
					}
				}),
				Param(Message(self.stepevent), \stepCount).asNumberBox,
			);

			mod_list_view = View.new;
			self.mod_list_view = mod_list_view;
			self.refresh_mod_list_view;

			mod_view = VLayout(
				mod_header_view,
				ScrollView.new.canvas_(mod_list_view),
			);

			self.layout = VLayout(
				self.playerWrapper.asView,
				param_view,
				mod_view,
			);
			self.layout;
		},

		makeWindow: { arg self;
			var window = Window.new;
			var layout;
			layout = self.makeLayout;
			window.layout = layout;
			//window.alwaysOnTop = true;
			window.front;
			
		},

		as_pattern: { arg self;
			Ppar([
				(Plazy({ self.stepevent.asPattern })  <> Plazy({ self.base })).loop,
				Plazy({
					var list = List.new;
					self.stepevent.keys.asArray.do({ arg key;
						var val = self.stepevent[key];
						if(val.isKindOf(Event) and: { val.eventType == \paramTimeline }) {
							list.add(val.xasPattern);
						};
					});
					if(list.size == 0) {
						Event.silent(1); // FIXME: this will delay base if shorter, don't know what to do
					} {
						Ppar(list);
					};
				}).loop
			]).loop
		},

	);

	Pdef(\base).addHalo(\instrument, \rlpf);
	Pdef(\base).addSpec(\lpf, \freq);
	~mod = ~modularizer.new(Pdef(\base));
	~mod.playerWrapper = PlayerWrapper(Pdef(\main));
	Pdef(\main, ~mod.as_pattern);
	Pdef(\main).play;
	~mod.makeWindow;

)

~mod.stepevent.asPattern.asStream.nextN(10,())

\freq.asSpec.range

///////////////////////////////// make an independent module

(
"/home/ggz/code/sc/seco/vlive/demo/param/lib/timeline.scd".load;
Spec.add(\stepCount, ControlSpec(1,64,\lin,1,8));
	SynthDef(\rlpf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		sig = LFSaw.ar(freq * [1,1.01]);
		sig = RLPF.ar(sig, \lpf.kr(4100), \rq.kr(0.5));
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;

		Pdef(\base,
			Pbind(
				\instrument, \rlpf,
				\amp, Pkeyd(\amp,0.1),
			);
		
		);

	~envEventView = (
		new: { arg self, envEvent;
			self = self.deepCopy;
		
			self.base = base;
			self.param_group = base.asParamGroup;
			self.stepevent = StepEvent.new;
			self.stepevent.debug("new: stepevent");
			self.stepevent.addHalo(\instrument, self.base.getHalo(\instrument));
			self.stepevent.addHalo(\spec, self.base.getHalo(\spec));
			self.playerWrapper = PlayerWrapper(self.base);
			
		
			self;
		},

		add_modulator: { arg self, param;
			self.stepevent[param.property] = ~envTimeline.newInstance(
				Param(BusDef(param.property, \control), param.property, param.spec)
			);
			"eeeeeeeeeeeeee".debug;
			self.refresh_mod_list_view;
		},

		remove_modulator: { arg self, param;
			self.stepevent[param.property] = nil;
			self.refresh_mod_list_view;
		},

		bypass_modulator: { arg self, modu;
			//modu.bypass = ( modu.bypass + 1 % 2 );
			self.refresh_mod_list_view;
		},

		refresh_mod_list_view: { arg self;
			self.stepevent.debug("refresh_mod_list_view: stepevent");
			if(self.mod_list_view.notNil) {
				var keys;
				self.mod_list_view.removeAll;
				self.param_group_dict = Dictionary.new;
				self.param_group.do ({ arg param;
					self.param_group_dict[param.property] = param 
				});
				keys = self.stepevent.keys.asList;
				keys.sortLike(self.param_group.collect(_.property));
				self.mod_list_view.layout = VLayout(
					GridLayout.rows(
						//StaticText.new.string_("fuck"),
						* keys.collect({ arg key;
							var editor;
							var steplist;
							key.debug("what??");
							steplist = self.stepevent[key];
							editor = if(steplist.isKindOf(StepList)) {
								var param;

								// propagate spec in the steplist
								param = self.param_group_dict[key];
								if(param.notNil) {
									steplist.addSpec(\list, param.spec);
								};

								//if(steplist.bypass == 1) {
								//	StaticText.new.string_("disabled");
								//} {
								//	StepListView(steplist).view;
								//}
								StepListView(steplist).setCursor.view;
							} {
								if(steplist.isKindOf(Event) and: { steplist.eventType == \paramTimeline }) {
									//~envTimelinePanelView.newView(steplist).debug("panel!!!!!!!!!").makeLayout;
									~envTimelinePanelView.newView(steplist).make_header_(nil).makeLayout;
								} {
									StaticText.new.string_("empty");
								}
							};

							[
								if(steplist.bypass == 1) {
									StaticText.new.string_("[%]".format(key));
								} {
									StaticText.new.string_(key);
								},
								editor,
							]

						}) 
					),
					nil,
				);
			}
		},

		makeLayout: { arg self;
			var param_view;
			var mod_view;
			var mod_header_view, mod_list_view;
			var param_selector;

			param_view = GridLayout.rows(
				*self.param_group.collect({ arg param;
					[
						param.asStaticTextLabel,
						param.asSlider.orientation_(\horizontal),
						param.asTextField,
					]
				})
			);

			mod_header_view = HLayout(
				param_selector = PopUpMenu.new.items_(self.param_group.collect({ arg param;
					param.property;
				})),
				XSimpleButton.new.label_("+").action_({
					var modulator = self.stepevent[param_selector.items[param_selector.value]];
					if(modulator.isNil) {
						self.add_modulator(self.param_group[param_selector.value]);
					}
				}),
				XSimpleButton.new.label_("-").action_({
					var modulator = self.stepevent[param_selector.items[param_selector.value]];
					if(modulator.notNil) {
						self.remove_modulator(self.param_group[param_selector.value]);
					}
				}),
				XSimpleButton.new.label_("bypass").action_({
					var modulator = self.stepevent[param_selector.items[param_selector.value]];
					if(modulator.notNil) {
						self.bypass_modulator(modulator);
					}
				}),
				Param(Message(self.stepevent), \stepCount).asNumberBox,
			);

			mod_list_view = View.new;
			self.mod_list_view = mod_list_view;
			self.refresh_mod_list_view;

			mod_view = VLayout(
				mod_header_view,
				ScrollView.new.canvas_(mod_list_view),
			);

			self.layout = VLayout(
				self.playerWrapper.asView,
				param_view,
				mod_view,
			);
			self.layout;
		},

		makeWindow: { arg self;
			var window = Window.new;
			var layout;
			layout = self.makeLayout;
			window.layout = layout;
			//window.alwaysOnTop = true;
			window.front;
			
		},

		as_pattern: { arg self;
			Ppar([
				(Plazy({ self.stepevent.asPattern })  <> Plazy({ self.base })).loop,
				Plazy({
					var list = List.new;
					self.stepevent.keys.asArray.do({ arg key;
						var val = self.stepevent[key];
						if(val.isKindOf(Event) and: { val.eventType == \paramTimeline }) {
							list.add(val.xasPattern);
						};
					});
					if(list.size == 0) {
						Event.silent(1); // FIXME: this will delay base if shorter, don't know what to do
					} {
						Ppar(list);
					};
				}).loop
			]).loop
		},

	);

	Pdef(\base).addHalo(\instrument, \rlpf);
	Pdef(\base).addSpec(\lpf, \freq);
	~mod = ~modularizer.new(Pdef(\base));
	~mod.playerWrapper = PlayerWrapper(Pdef(\main));
	Pdef(\main, ~mod.as_pattern);
	Pdef(\main).play;
	~mod.makeWindow;

)
