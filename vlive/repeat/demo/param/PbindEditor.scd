
(
FileSystemProject.load("libdef/default_specs.scd");
FileSystemProject.load("libdef/controllers.scd");
FileSystemProject.load("cavern/ifxsimple.scd");
FileSystemProject.load("libdef/soundfileview.scd");
FileSystemProject.load("libdef/synthplayrec.scd");
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(30,19000), \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
Spec.add(\lpfr, ControlSpec(0.1,4,\exp,0,1.1));
SynthDesc(\saw).addTag(\cool).addTag(\note);

SynthDef(\sawtab, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * \lptab.kr([1,1,1]) * freq ).mean.clip(30,19000), \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
SynthDesc(\saw).addTag(\cool).addTag(\note);

Ndef(\lfo1, { arg lofreq=2.5; SinOsc.kr(lofreq).unipolar  });
Ndef(\lfo2, { arg lofreq=4.5; LFPulse.kr(lofreq).unipolar  });
Ndef(\lfo3, { arg lofreq=1.5; LFSaw.kr(lofreq).unipolar  });
Ndef(\macro1, { arg unipolar=0.5; unipolar  });
TagSpecDef(\ParamCombinatorInput).addUnique(\lfo1 -> Ndef(\lfo1));
TagSpecDef(\ParamCombinatorInput).addUnique(\lfo2 -> Ndef(\lfo2));
TagSpecDef(\ParamCombinatorInput).addUnique(\lfo3 -> Ndef(\lfo3));
TagSpecDef(\ParamCombinatorInput).addUnique(\macro1 -> Ndef(\macro1));

SynthDef(\modadsr, { arg out=0, gate=1, levelScale=1, levelBias=0;
	var sig;
	sig = EnvGen.kr(\adsr.kr(Env.adsr(0.4,0.1,0.8,0.1)), gate, levelScale: levelScale, levelBias: levelBias, doneAction:2);
	Out.kr(out, sig);
}).add;

ProtoTemplateDef(\PdefEditor_InlineEnv, (
	eventType: \inlineEnv,
	new: { arg self, uniqkey, spec;
		self = ProtoClass((parent: self));
		self.spec = spec ?? { \unipolar.asSpec };
		self.busKey = uniqkey;
		self.baseEvent = (levelBias: self.spec.minval, levelScale: 1 );
		self.baseEvent.addSpec(\levelScale, ControlSpec(0.1,4,\exp));
		self.baseEvent.addSpec(\levelBias, self.spec);
	
		
	
		self;
	},

	synthName: { arg self;
		\modadsr;
	},

	getParam: { arg self, key;
		Param(self.baseEvent, key);
	},

	bus: { arg self;
		BusDef(self.busKey, \control);
	},

	asParamGroup: { arg self;
		SynthDesc(self.synthName).asParamGroup(self.baseEvent)
	},

	asPattern: { arg self;
		Prout({ arg ev;
			var envev;
			var spec = self.spec;

			loop {
				envev = self.baseEvent.copy;
				[\sustain, \legato, \dur].do { arg key, idx;
					envev[key] = ev[key];
				};
				envev[\instrument] = \modadsr;
				envev[\out] = self.bus;
				envev[\levelScale] = spec.range * ( self.baseEvent.levelScale ? 1 );
				envev[\levelBias] = spec.minval + ( self.baseEvent.levelBias ? 0 );
				envev.debug("envev");
				ev[\finish] = ev[\finish].addFunc({
					envev.play;
				});
				ev = envev[\out].asMap.yield;
			};
			ev
		});
	},

	editor: { arg self;
		WindowDef(\PdefEditor_InlineEnv, { arg def, pgroup;
			var envparam;
			var lay;
			var fpgroup;
			var exkeys = [\out, \gate];
			Log(\Param).debug("PdefEditor_InlineEnv in, pgroup: %", pgroup);
			// can't use block{} because interpreter bug
			[\adsr, \asr, \env].collect { arg ekey;
				pgroup.detect { arg param; param.propertyRoot == ekey  } !? { arg sel;
					envparam = sel
				}
			};
			envparam.debug("envparam");
			if(envparam.notNil) {
				exkeys = exkeys ++ [ envparam.propertyRoot ];
			};
			fpgroup = pgroup.reject({ arg x; exkeys.includes(x.propertyRoot) });
			fpgroup.debug("fpgroup");
			fpgroup.debug("fpgroup2");
			lay = VLayout (
				//VLayout(BasicButton.new.string_("Tu me soule"))
				if(envparam.notNil) {
					envparam.asEnvelopeView;
				},
				HLayout (
					* fpgroup.collect { arg param, idx;
						HLayout (
							param.asStaticTextLabel.align_(\right).maxWidth_(70),
							param.asKnob.maxSize_(Point(20,20)),
						).margins_(0).spacing_(10)
					};
				).spacing_(0).margins_(0)
			);
			//lay = BasicButton.new.string_("soouuule");
			//View.new.layout_(lay)
			//View.new;
			lay;

		});
	},

	asView: { arg self;
		self.editor.asView(self.asParamGroup);
		//VLayout(BasicButton.new.string_("Tu me soule"))
	},

	edit: { arg self;
		self.editor.front(self.asParamGroup);
	},

	asStream: { arg self;
		self.asPattern.asStream;
	},

	streamArg: { arg self;
		self.asStream;
	},
));
);


(
	~t = 1; TempoClock.default.tempo = ~t;
Pbindef(\pb, 
	\instrument, \default,
	\degree, PstepSeq([0,3,5,1],inf),
	\dur, 1,
	\amp, 0.1,
);
Pbindef(\pb2, 
	\instrument, \saw,
	\lpfr, 2.1,
	\degree, PstepSeq([0,3,5,1],inf),
	\dur, 1,
	\amp, 0.1,
);
Pbindef(\pb3, 
	\instrument, \saw,
	\lpfr, Pwhite(0.1,0.7)*4,
	\degree_steps, PstepSeq([0,3,5,1],inf),
	\chord, [0,2b,4],
	\degree, Pkey(\degree_steps) + Pkey(\chord),
	\dur, 1,
	\amp, 0.1,
);
Pbindef(\pb4, 
	\instrument, \saw,
	\lpfr, Pwhite(0.1,0.7)*4,
	\root, PstepSeq([0,3,5,1],inf),
	\degree, [0,2b,4],
	\dur, 1,
	\amp, 0.1,
);
Pbindef(\pb5, 
	\instrument, \default,
	\degree, 0,
	\dur, 1,
	\amp, 0.1,
);
Pbindef(\pb6, 
	\instrument, \sawtab,
	\degree, 0,
	\dur, 1,
	\amp, 0.1,
);
);

(
BufDef(\moeten, "voices/02_moeten.flac");
BufDef(\amen, "vipere/amenbreak.wav");
Pbindef(\pb7, 
	\instrument, \playersec,
	\bufnum, BufDef(\amen),
	\gain, 0.1,
).play;
)
Pbindef(\pb).clear
Pbindef(\pb2).clear
(
	// todo:
	// - \source bus mode

WindowDef(\PdefPostPianoKeyboard, { arg def, pdef;
	var kb = MIDIKeyboardView.new;
	kb.mapPattern(pdef, \post);
	def.windowDo { arg win;
		win.setInnerExtent(800,120)
	};
	kb.asView;
});

WindowDef(\PbindefEditor, (

	isPstepSeqParam: { arg self, param;
		param.get.isKindOf(PstepSeq)
	},

	showParamOverlayMenu: { arg self, param, editorView, textView, view, x, y;
		WindowDef(\OverlayMenu).front(view, x, y, { arg def;
			var midiClearButton;
			var typePopup;
			var specEditorView = View.new;
			//Log(\Param).debug("showParamOverlayMenu: param % % %", param, param.type, param.parent.type);
			VLayout (
				* [
					//if(param.type == \array) {
						//HLayout (
							//StaticText.new.string_("List size"),
							//Param(Message(param), \size, ControlSpec(1,32,\lin,1,4)).asNumberBox.maxWidth_(100)
						//)
					//},
					TextField.new.mapParam(param),
					if(param.parent.type == \scalar) {
						// can change only scalar parameter
						typePopup = PopUpMenu.new.items_(self.paramForms).action_({ arg view;
							textView.unmapParam;
							Log(\Param).debug("editorView.layout.innerView %", editorView.layout.innerView);
							editorView.layout.innerView.unmapParam;
							self.setParamForm(param, self.paramForms[view.value], editorView);
							def.closeWindow;
						}).value_(self.paramForms.indexOf(self.getParamForm(param)));
						HLayout (
							StaticText.new.string_("Param form"),
							typePopup,
						);
					},
					if(self.sustainKeys.includes(param.propertyRoot)) {
						HLayout (
							StaticText.new.string_("Mode:"),
							Param(Message(self), \legatoSustainMode, TagSpec(self.sustainKeys)).asPopUpMenu,
						)
					},
					if(self.noteKeys.includes(param.propertyRoot)) {
						HLayout (
							StaticText.new.string_("Mode:"),
							Param(Message(self), \noteMode, TagSpec(self.noteKeys)).asPopUpMenu,
						)
					},
					StaticText.new.string_(""),
					Param(Message(param), \inBusMode, ParamBoolSpec()).asButton("Bus mode"),
					HLayout (
						BasicButton.new.string_("Add modulator").action_({
							WindowDef(\ListSelectDialog).front(TagSpecDef(\ParamCombinatorInput).list, {
								arg selected, asso;
								var combi;
								var inputidx; 
								//"1".debug;
								combi = ParamCombinator(param.parent,6);
								//"2".debug;
								//WindowDef(( \ParamCombinator_++param.fullLabel ).asSymbol, WindowDef(\ParamCombinatorEditor)).front(combi);
								//param.set(param.default)
								[param, param.wrapper, combi].debug("param");
								param.set(combi);
								//"3".debug;
								inputidx = self.combinatorNextInputIndex(combi);
								//"4".debug;
								if(inputidx.notNil) {
								//"5".debug;
									combi.inBusMode = true;
								//"6".debug;
									combi.inputParam.at(inputidx).set(asso.value.asMap);
								//"7".debug;
									//self.addModulatorLine(asso.key); // done by keyForm
									self.proxy.changed(\keyForm, param);
								//"8".debug;
									self.updateModulatorView;
								//"9".debug;
								} {
									Log(\Param).error("No combinator slot available");
								}
							});
						}),
						BasicButton.new.string_("Combinator").action_({
							var combi;
							combi = ParamCombinator(param.parent).setBusMode(true);
							param.set(combi);
							WindowDef(( \ParamCombinator_++param.fullLabel ).asSymbol, WindowDef(\ParamCombinatorEditor)).front(combi);
							//param.set(param.default)
							self.proxy.changed(\keyForm, param);
						}),
					),
					HLayout (
						BasicButton.new.string_("Default").action_({
							param.set(param.default)
						}),
						BasicButton.new.string_("Unset").action_({
							param.unset;
						}),
						BasicButton.new.string_("Remove").action_({
							param.unset;
							self.updateParamGroupView;
							def.closeWindow;
							//self.proxy.changed(\keyForm, param);
						}),
						BasicButton.new.string_("Refresh").action_({
							self.proxy.changed(\keyForm, param);
							def.closeWindow;
						}),
					),
					//BasicButton.new.string_("Make PstepSeq").action_({

						//param.set( self.makePstepSeq );
						//self.proxy.changed(\keyForm, param);
					//}),
					if(param.type == \scalar) {
						HLayout (
							BasicButton.new.string_("MIDI CC learn").action_({
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
						);
					},
					if(param.type == \array or: { param.get.isSequenceableCollection }) {
						var model;
						self.arrayControllerDict = self.arrayControllerDict ?? { IdentityDictionary.new };
						model = self.arrayControllerDict[param.propertyRoot] ?? { ProtoClass((
							arrayController_: { arg me, con;
								me[\arrayController] = con;
								self.setArrayController(param, con)
							},
						)) };
						self.arrayControllerDict[param.propertyRoot] = model;
						HLayout(
							StaticText.new.string_("controller:"),
							Param(
								Message(model),
								\arrayController, 
								ControllerDef.getTagSpec(\knobline)
							).asPopUpMenu.allowsReselection_(true),
						);
					},
					StaticText.new.string_(""),
					BasicButton.new.string_("> Spec editor").maxWidth_(100).background_(Color.clear).action_({
						specEditorView.layout = HLayout(WindowDef(\ParamSpecEditor).embedView(def, param)).margins_(0).spacing_(5);
						//specEditorView;
						//WindowDef(\ParamSpecEditor).front(param)
					}),
					specEditorView,
				].select(_.notNil) ++ [nil]
			)
		});
		
	},

	showCombinatorOverlayMenu: { arg self, param, combi, idx, view, x, y;
		WindowDef(\OverlayMenu).front(view, x, y, { arg def;
			VLayout (
				* [
					combi.rangeParam.at(idx).asView,
					combi.inputParam.at(idx).spec_(TagSpecDef(\ParamCombinatorInput_asMap)).asPopUpMenu,
					//combi.inputParam.at(1).spec_(TagSpecDef(\ParamCombinatorInput_asMap)).asPopUpMenu,
					//combi.inputParam.at(2).spec_(TagSpecDef(\ParamCombinatorInput_asMap)).asPopUpMenu,
					BasicButton.new.string_("Remove").action_({
						combi.inputParam.at(idx).set(0);
						param.set(combi.baseParam.get);
						self.proxy.changed(\keyForm, param);
					}),
				].select(_.notNil) ++ [nil]
			)
		});
		
	},

	showGeneralOverlayMenu: { arg self, view, x, y;
		WindowDef(\OverlayMenu).front(view, x, y, { arg def;
			var addParamPopup = PopUpMenu.new;
			def.windowDo { arg win;
				win.setInnerExtent(300,100);
			};
			VLayout (
				//Param(Message(self), \legatoSustainMode, TagSpec([\legato, \sustain])).asPopUpMenu,
				//Param(Message(self), \noteMode, TagSpec([\freq, \midinote, \note, \degree])).asPopUpMenu,

				HLayout (
					addParamPopup.items_(self.optionalEventKeys),
					BasicButton.new.string_("Add param").action_({
						if(addParamPopup.value == ( self.optionalEventKeys.size - 1 )) {
							// last value is 'Add custom param'
							WindowDef(\ListSaveDialog).front(self.optionalEventKeys.drop(-1), { arg selected;
								self.addParam(selected);
								self.updateParamGroupView;
							})
						} {
							self.addParam(self.optionalEventKeys[addParamPopup.value]);
							self.updateParamGroupView;
						};
					}),
				),
				Param(Message(self), \showSynthDefParams, ParamBoolSpec()).asButton("Show SynthDef params"),
				Param(Message(self), \isNoteTimelineModeEnabled, ParamBoolSpec()).asButton.string_("NoteTimeline mode"),
				BasicButton.new.string_("Piano keyboard").action_({ 
					//model.debug("m");
					//model.target.debug("t");
					WindowDef(\PdefPostPianoKeyboard).front(
						//Pbind(\type, \note, \NoteTimeline, 1, \dur, 1) 
						self.strippedPattern
					)
				}),
				HLayout(
					StaticText.new.string_("piano controller:"),
					Param(
						Message(self),
						\pianoController, 
						ControllerDef.getTagSpec(\piano)
					).asPopUpMenu.allowsReselection_(true),
				),
				HLayout(
					StaticText.new.string_("slider controller:"),
					Param(
						Message(self),
						\sliderController, 
						ControllerDef.getTagSpec(\knobline)
					).asPopUpMenu.allowsReselection_(true),
				),
				BasicButton.new.string_("Refresh").action_({
					self.updateParamGroupView;
					self.updateModulatorView;
					self.updateFxView;
				}),
			)
		});
		
	},

	showMixerOverlayMenu: { arg self, view, x, y;
		WindowDef(\OverlayMenu).front(view, x, y, { arg def;
			VLayout (
				Param(Message(self), \isMixerEnabled, ParamBoolSpec()).asButton.string_("Enable mixer"),
				BasicButton.new.string_("Show mixer").action_({
					if(self.isMixerEnabled) {
						self.mixer.edit;
					}
				}),
				BasicButton.new.string_("Add fx").action_({
					self.addFx;
				}),
				nil,
			)
		});
	},

	hiddenParamList: { arg self;
		if(self.isNoteTimelineModeEnabled) {
			self.noteKeys ++ self.sustainKeys
		} {
			[]
		}
	},

	makeParamView: { arg self, param;
		var labelView, editorView, textView;
		var minWidth_right = 60;
		textView = TextField.new.mapParam(param, 5).maxWidth_(minWidth_right);
		labelView = StaticText.new.string_(param.propertyRoot).minWidth_(70);
		labelView.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
			if(buttonNumber == 1) {
				self.showParamOverlayMenu(param, editorView, textView, view, x, y);
			};
			true;
		});
		//Log(\Param).debug("makeParamView: %", param);
		editorView = View.new;
		editorView.followChange(self.proxy, \keyForm, { arg view, model, msg, cparam ...args;
			var val;
			var bigheight = 80;
			var innerView;
			//if(true) {
			//[view, model, msg, args].debug("args");
			//[param, cparam].debug("followChange test");
			if(param === cparam) {
				Log(\Param).debug("editorView: followChange: %, %", param.property, param.spec);
				editorView.removeAll;
				editorView.maxHeight_(bigheight);
				val = param.getRaw;
				//val.debug("val");
				case(
					//{ val.isNil }, {
						//// param removed, do nothing
					//},
					{ param.propertyRoot == \dur and: {self.isNoteTimelineModeEnabled} }, {
						val.debug("makeParamView: dur NoteTimeline");
						editorView.layout = HLayout([ innerView = self.noteTimeline.asPreview, stretch:10 ]).margins_(0).spacing_(0);
						textView.visible = false;
					},
					//{ [\freq, \midinote, \note, \degree].includes(param.propertyRoot) and: {self.isNoteTimelineModeEnabled} }, {
					//editorView.layout = HLayout([ self.noteTimeline.asPreview, stretch:10 ]).margins_(0).spacing_(0);
					//textView.visible = false;
					//},
					//{ val.isKindOf(PstepSeq) }, {
					//editorView.layout = HLayout(param.parent.at(\stepseq).asMultiSlider).margins_(0).spacing_(0);
					//textView.visible = false;
					//},
					{ param.spec.isKindOf(ParamBufferSpec) }, {
						var load = BasicButton.new.string_("Load").fixedWidth_(minWidth_right).action_({
							WindowDef(\filedialog_sample).front(nil, { arg path;
								switch(param.spec.numChannels,
									1, { param.set(BufDef.mono(path).bufnum) },
									2, { param.set(BufDef.stereo(path).bufnum) },
									{ param.set(BufDef(path).bufnum) }
								);
								{
									param.spec.tagSpec.changed(\list);
									param.sendChanged;
								}.defer(0.1);

							})
						});
						val.debug("makeParamView: buffer");
						~param = param;
						if(param.spec.isKindOf(ParamAudioBufferSpec)) {
							if(param.spec.startParamName.notNil) {
								editorView.layout = VLayout(
									self.paramAsSoundFileView(param),
									HLayout (
										[innerView = param.asPopUpMenu, stretch: 10],
										load,
									)
								).margins_(0);
							} {
								editorView.layout = HLayout(
									//[innerView = WindowDef(\ParamAsSoundFileView).asView(param), stretch:10],
									[innerView = param.asPopUpMenu, stretch: 10],
									load,
								).margins_(0);
							}
						} {
							editorView.layout = HLayout(
								//[innerView = WindowDef(\ParamAsSoundFileView).asView(param), stretch:10],
								[innerView = param.asPopUpMenu, stretch: 10],
								load,
							).margins_(0);
						};
						//editorView.layout = HLayout(
							//[innerView = BasicButton.new.string_("kjkjkj"), stretch:10],
						//).margins_(0);
						innerView.addUniqueMethod(\unmapParam, {}); // no param to unmap
						textView.visible = false;
					},
					{ param.spec.isKindOf(TagSpec) }, {
						val.debug("makeParamView: bus");
						editorView.layout = HLayout(
							[param.asPopUpMenu, stretch:10],
						).margins_(0);
						textView.visible = false;
					},
					{ param.spec.isKindOf(ParamBusSpec) }, {
						val.debug("makeParamView: bus");
						editorView.layout = HLayout(
							if(self.isMixerEnabled) {
								var slider;
								var stack;
								var meterout = CompactServerMeterView(nil, 0,2, self.mixer.recbus);
								meterout.ticksView.minWidth_(6);
								meterout.orientation_(\horizontal);
								slider = Slider.new.orientation_(\horizontal).background_(Color.clear);
								slider.mapParam(self.mixer.getParam(\postfader));
								stack = StackLayout(
									slider, 
									meterout.view,
								).mode_(\stackAll);
								[stack, stretch:10];
							} {
								[param.asPopUpMenu, stretch:10];
							},
							BasicButton.new.string_("...").maxWidth_(60).mouseUpAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
								[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
								self.showMixerOverlayMenu(view, x, y);

							})
						).margins_(0);
						textView.visible = false;
					},
					{ val.value.isKindOf(ProtoClass) and: { val.value.eventType == \inlineEnv } }, {
						[val, val.value].debug("makeParamView: inlineEnv");
						innerView = val.value.asView;
						Log(\Param).debug("innerView %", innerView);
						editorView.layout = HLayout([ innerView, stretch:10 ]).margins_(0).spacing_(0);
						Log(\Param).debug("xxx");
						innerView.addUniqueMethod(\unmapParam, {}); // no param to unmap
						textView.visible = false;
					},
					{ val.value.isKindOf(ProtoClass) and: { val.value.eventType == \envTimeline } }, {
						[val, val.value].debug("makeParamView: ParamTimeline");
						editorView.layout = HLayout([ innerView = val.value.asPreview, stretch:10 ]).margins_(0).spacing_(0);
						innerView.addUniqueMethod(\unmapParam, {}); // no param to unmap
						textView.visible = false;
					},
					{ val.isKindOf(ParamCombinator) }, {
						var mod;
						var knobs;
						self.modulators = self.modulators ?? { List.new };
						val.debug("makeParamView: ParamCombinator");
						knobs = self.combinatorInputCount(val).collect { arg idx;

							self.modulators.debug("WTF modulators");
							mod = Ndef( TagSpecDef(\ParamCombinatorInput_asMap).unmapKey(
								val.inputParam.at(idx).get 
							));
							mod.debug("mod");
							if(self.modulators.includes(mod).not) {
								self.modulators.add(mod);
							};

							val.rangeParam.at(idx).asKnob.maxSize_(20).mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
								[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
								if(buttonNumber == 1) {
									self.showCombinatorOverlayMenu(param, val, idx, view, x, y);
									false;
								}
							})
						};
						editorView.layout = HLayout(
							innerView = val.baseParam.asSlider.orientation_(\horizontal),
							* knobs
						).margins_(0);
						textView.mapParam(val.baseParam, 5);
						//textView.visible = true;

					}, 
					{ val.isKindOf(SequenceableCollection) }, {
						// Pattern multichannel expansion
						//		Param is scalar but should be treated as array according to Pbindef value
						//		Note that PstepSeq also fall in this switch case
						innerView = param.asMultiSlider.attachContextMenu;
						val.debug("makeParamView: chord");
						editorView.layout = HLayout(innerView).margins_(0).spacing_(0);
						textView.visible = false;

					}, 
					{ val.isKindOf(Pattern) }, {
						val.debug("makeParamView: pattern");
						editorView.layout = HLayout(innerView = param.asTextField).margins_(0).spacing_(0);
						textView.visible = false;

					}, 
					{ param.type == \array }, {
						innerView = param.asMultiSlider.maxHeight_(bigheight).attachContextMenu;
						editorView.layout = HLayout(innerView).margins_(0).spacing_(0);
						textView.visible = false;
					},
					{ param.type == \env }, {
						editorView.layout = HLayout(innerView = param.asEnvelopeView.maxHeight_(bigheight)).margins_(0).spacing_(0);
						textView.visible = false;
					},
					{ param.type == \scalar }, {
						val.debug("makeParamView: scalar");
						editorView.layout = HLayout(innerView = param.asSlider.orientation_(\horizontal)).margins_(0).spacing_(0);
						//textView.visible = true;

					}, 
					{
						val.debug("makeParamView: default");
						editorView.layout = HLayout(innerView = param.asSlider.orientation_(\horizontal)).margins_(0).spacing_(0);
						//textView.visible = true;

					}
				);
				if(editorView.layout.notNil) {
					editorView.layout.addUniqueMethod(\innerView, { innerView });
				};
			}
		}, false);
		self.proxy.changed(\keyForm, param);
		if(self.hiddenParamList.includes(param.propertyRoot)) {
			HLayout()
		} {
			HLayout (
				labelView,
				editorView,
				textView,
			)	
		}
	},

	paramAsSoundFileView: { arg self, param;
		var spec = param.spec;
		var target = param.target;
		//var buf = param.get;
		WindowDef(\soundfileview).asView(
			//BufDef(spec.tagSpec.unmapKey(param.get)),
			param,
			spec.startParamName !? { Param(target, spec.startParamName -> \source) },
			spec.sustainParamName !? { Param(target, spec.sustainParamName -> \source) },
			spec.endParamName !? { Param(target, spec.endParamName -> \source) },
			spec.speedParamName !? { Param(target, spec.speedParamName -> \source) },
			spec.startType ? \unipolar,
			spec.sustainType ? \beats,
			spec.endType ? \unipolar,
		);
	},

	makeFxView: { arg self;
		self.fxView = View.new;
		self.updateFxView;
		self.fxView;
	},

	updateFxView: { arg self;
		self.fxView.removeAll;
		if(self.isMixerEnabled) {
			self.fxView.layout = WindowDef(\TrackMixerDef_fxlist).asView(self.mixer, self.mixer.fxCount ? 0).margins_(0)
		};
	},


	makeModulatorView: { arg self;
		self.modulatorView = View.new;
		self.updateModulatorView;
		self.modulatorView;
	},

	updateModulatorView: { arg self;
		self.modulatorView.removeAll;
		self.modulatorView.layout = VLayout(
			* self.modulators.collect { arg mod, idx;
				HLayout (
					PlayerWrapperView(mod),
					BasicButton.new.string_("Edit").action_({
						WindowDef(\NdefEditor).front(mod);
					}),
					//mod.asParamGroup.first.asSlider.orientation_(\horizontal),
					mod.asParamGroup.first.asView,
				)
			}
		).margins_(0)
	},

	makeParamGroupView: { arg self, pgroup;
		var lay = VLayout(
			* pgroup.collect { arg param, idx;
				self.makeParamView(param)
			} ++ [nil];
		);
		self.updateModulatorView;
		lay;
	},

	updateParamGroupView: { arg self, view, proxy;
		view = view ? self.paramlistView;
		proxy = proxy ? self.proxy;
		view.removeAll;
		view.layout = self.makeParamGroupView(self.paramList);
		~plist = self.paramList;
	},

	makeInstrView: { arg self, proxy;
		var instrparam;
		var paramlistView = View.new;
		instrparam = Param( proxy, \instrument -> \source, TagSpecDef(\SynthDef_keys));
		instrparam.onChange({ arg view, param;
			self.updateParamGroupView(view, proxy);
		}, paramlistView);
		self.instrumentParam = instrparam;
		self.paramlistView = paramlistView;
		self.updateParamGroupView(paramlistView, proxy);
		//paramlistView.layout = self.makeParamGroupView(proxy.asParamGroup);
		VLayout (
			HLayout (
				PlayerWrapper(proxy),
				instrparam.asValuePopUpMenu.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
					//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");

					if(buttonNumber == 1) {
						WindowDef(\GlobalLibrary_select).front(nil, { arg synth;
							//synth.debug("synth");
							instrparam.set(synth.last.key);

						}, [\SynthDef])
					}
				}),
				BasicButton.new.string_("...").maxWidth_(30).mouseUpAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
					//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
					
					self.showGeneralOverlayMenu(view, x, y);
				}),
			),
			ScrollView.new.canvas_(
				paramlistView
			).hasBorder_(false),
		)
	},

	/// data

	makePstepSeq: { arg self, default=0;
		PstepSeq(default!8,inf);
	},

	defaultMixer: { arg self;
		TrackMixerDef("Pbindef_%".format(self.proxy.key).asSymbol)
	},

	mixer: { arg self;
		var val = Param(self.proxy, \out -> \source).get;
		if(val.isKindOf(ProtoClass) and: { val.inbus.notNil }) {
			val;
		} {
			self.defaultMixer;
		};
	},

	noteTimeline: { arg self;
		NoteTimeline("Pbindef_%".format(self.proxy.key).asSymbol)
	},

	strippedPattern: { arg self;
		// remove NoteTimeline keys (\midinote, \type, \play, etc) to be able to use the pattern in a keyboard

		//var exkeys = [\midinote, \play, \dur, \NoteTimeline];

		self.noteTimelineProxy = self.noteTimelineProxy ?? {
			EventPatternProxy.new.source_( 
				self.proxy <>
				Pbind(\disableNoteTimeline, true)
			);
		};
		self.noteTimelineProxy;


		//EventPatternProxy.new.source_( // because Param can't take Prout as target

			//Prout({ arg ev;
				//ev[\midinote] = ev[\save_midinote];
				//ev[\type] = \note;
				//ev[\NoteTimeline] = nil;
				//ev[\play] = nil;
				//ev.yield;
			//}).loop <>
			//self.proxy
			//<>
			//Prout({ arg ev;
				//ev[\save_midinote] = ev[\midinote];
				//ev.yield;
			//}).loop;
		//)
		
	},

	paramList: { arg self;
		var plist = List.new;
		var cust = self.noteParamList ++ self.customParamList;
		var pbkeys;
		if(self.showSynthDefParams == true) {
			plist.addAll(self.proxy.asParamGroup(nil, false, [\freq, \gate, \doneAction]).as(Array));
		};
		//[ cust ++ plist ].debug("pbjkeys");
		pbkeys = self.pbindefKeysParamList(cust ++ plist);
		plist.addAll(pbkeys);
		plist.addAll(cust);
		plist.collect({ arg p; 
			if(p.at(\source).get.isKindOf(PstepSeq)) {
				p.at(\stepseq)
			} {
				p.at(\source);
			}
		});
	},

	pbindefKeysParamList: { arg self, exclude;
		var exkeys = Set.newFrom(exclude.collect(_.propertyRoot)) 
			++ [\instrument, \NoteTimeline]
			++ self.noteKeys
			++ self.sustainKeys;
		self.proxy.source.pairs.clump(2).flop.first.reject({ arg k; exkeys.includes(k) }).collect { arg key, idx;
			Param(self.proxy, key)
		};
	},

	noteParamList: { arg self;
		[
			Param(self.proxy, self.noteMode),
			Param(self.proxy, self.legatoSustainMode),
		]
	},

	addFx: { arg self;
		if(self.isMixerEnabled) {
			self.mixer.fxCount = self.mixer.fxCount ? 0;
			self.mixer.insertFxAt(self.mixer.fxCount);
			self.mixer.fxCount = self.mixer.fxCount + 1;
		};
		self.updateFxView;
	},

	addModulatorLine: { arg self, modkey;
		self.modulators = self.modulators ?? { List.new };
		self.modulators.add( Ndef(modkey)  );
		self.updateModulatorView;
	},

	noteKeys: [\freq, \midinote, \note, \degree],
	sustainKeys: [\legato, \sustain],
	optionalEventKeys: [
		\octave, 
		\root,
		\scale,
		\strum,
		\detune,
		\stretch, 
		\lag, 
		\mtranspose, 
		\ctranspose, 
		'Add custom param'
	],
	paramForms: [\scalar, \stepseq, \chord, \text, \timeline, \inlineEnv],

	getParamForm: { arg self, param;
		case(
			{ param.parent.at(\source).get.isKindOf(PstepSeq) }, {
				\stepseq
			},
			{ var val = param.parent.at(\source).getRaw; val.isKindOf(ProtoClass) and: { val.eventType == \envTimeline } }, {
				\timeline
			},
			{ var val = param.parent.at(\source).getRaw; val.isKindOf(ProtoClass) and: { val.eventType == \inlineEnv } }, {
				\inlineEnv
			},
			{ param.parent.at(\source).get.isKindOf(Pattern) }, {
				\text
			},
			{ param.parent.at(\source).get.isKindOf(SequenceableCollection) }, {
				\chord
			}, {
				\scalar
			}
		)
	},

	setParamForm: { arg self, param, form, editorView;
		var default;
		switch(form,
			\scalar, { 
				editorView.removeAll;
				param.parent.at(\source).set( param.default );
				self.updateParamGroupView;
			   	// can't use changed(\keyForm) because param need to change property by .paramList
			},
			\stepseq, { 
				editorView.removeAll;
				//editorView.layout.slider.unmapParam;
				default = param.default;
				if(default.isSequenceableCollection) {
					default = default.first;
				};
				param.set( self.makePstepSeq(default) );
				self.updateParamGroupView;
			},
			\chord, { 
				//editorView.layout.slider.unmapParam;
				editorView.removeAll;
				default = param.default;
				if(default.isSequenceableCollection) {
					default = default.first;
				};
				param.parent.at(\source).set( default!3 );
				self.updateParamGroupView; 
			},
			\text, { 
				//editorView.layout.slider.unmapParam;
				editorView.removeAll;
				//default = param.default;
				//if(default.isSequenceableCollection) {
					//default = default.first;
				//};
				param.parent.at(\source).set( "Pn( % )".format(self.proxy.source.at(param.propertyRoot).source.asCompileString).interpret );
				self.updateParamGroupView; 
			},
			\timeline, {
				var pt, busparam;
				editorView.removeAll;
				busparam = Param(BusDef("Pbindef_%_%".format(self.proxy.key, param.propertyRoot).asSymbol, \control), \value, param.spec);
				//busparam.set(param.get); // to test
				pt = ParamTimeline("Pbindef_%_%".format(self.proxy.key, param.propertyRoot).asSymbol, busparam);
				pt.inlineModeEnabled = true;
				param.parent.at(\source).setRaw( pt );
				self.updateParamGroupView; 
				
			},
			\inlineEnv, {
				var pt, busparam;
				editorView.removeAll;
				Log(\Param).debug("create inlineEnv %", param);
				pt = ProtoTemplateDef(\PdefEditor_InlineEnv).new("Pbindef_%_%".format(self.proxy.key, param.propertyRoot).asSymbol, param.spec);
				param.parent.at(\source).setRaw( pt );
				self.updateParamGroupView; 
				
			}
		);
		
	},

	combinatorInputCount: { arg self, combi;
		self.combinatorNextInputIndex(combi) ?? combi.size;
	},

	combinatorNextInputIndex: { arg self, combi;
		combi.inputParam.as(Array).detectIndex { arg p; p.get == 0 };
	},

	/// controllers

	pianoController_: { arg self, con;
		self[\pianoController] = con;
		con.startControl(
			self.strippedPattern;
		)
	},

	sliderController_: { arg self, con;
		self[\sliderController] = con;
		con.startControl(self.paramList.select({ arg p; p.type == \scalar }));
	},

	setArrayController: { arg self, param, con;
		con.startControl(param)
	},

	/// modes

	showSynthDefParams_: { arg self, val;
		//self[\showSynthDefParams] = val;
		~pbindefEditor_showSynthDefParams = val;
		self.updateParamGroupView;
	},
	showSynthDefParams: {
		~pbindefEditor_showSynthDefParams ? false
	},

	isNoteTimelineModeEnabled_: { arg self, val;
		if(val == true) {
			self.removeParam(\dur);
			self.noteTimeline.param = Param(self.strippedPattern, \midinote);
			self.proxy.source.set(\NoteTimeline, { self.noteTimeline });
			// TODO: move Prout to NoteTimeline().asDurPattern
			self.proxy.source.set(\dur, Prout({ arg ev;
				ev.debug("PbindefEditor NoteTimeline dur Prout");
				if(ev[\disableNoteTimeline] == true) {
					loop {
						ev = ev[\dur].yield;
					}
				} {
					var pat;
					ev.debug("PbindefEditor NoteTimeline dur now in pattern mode");
					pat = ev[\NoteTimeline].value.asPattern;
					pat.do { arg val;
						ev.putAll(val);
						//ev[\midinote] = val[\midinote];
						//ev[\type] = val[\type];
						//ev[\sustain] = val[\sustain];
						ev = val.dur.yield;
					};
				};
				ev;
			}));
		} {
			self.removeParam(\NoteTimeline);
			self.proxy.source.set(\dur, 1);
		};
		self.updateParamGroupView
	},

	isNoteTimelineModeEnabled: { arg self;
		self.proxy.source.at(\dur).source.isKindOf(Prout) and: {
			var val;
			val = self.proxy.source.at(\NoteTimeline).source.value;
			val.isKindOf(ProtoClass) and: { val.eventType == \noteTimeline }
		}
	},

	isMixerEnabled: { arg self;
		var val = Param(self.proxy, \out -> \source).get;
		val.isKindOf(ProtoClass) and: { val.inbus.notNil }
	},

	isMixerEnabled_: { arg self, val;
		if(val == true) {
			Param(self.proxy, \out -> \source).set(self.defaultMixer);
		} {
			Param(self.proxy, \out -> \source).set(0);
		};
		self.updateParamGroupView;
	},

	legatoSustainMode_: { arg self, mode;
		switch(mode,
			\legato, { 
				self.addParam(\legato, Param(self.proxy, \sustain -> \source).get / Param(self.proxy, \dur -> \source).get );
				self.removeParam(\sustain);
		   	},
			\sustain, { 
				self.addParam(\sustain, Param(self.proxy, \legato -> \source).get * Param(self.proxy, \dur -> \source).get );
				//self.removeParam(\legato); // not required, \sustain take precedence
				self.updateParamGroupView
		   
			},
		);
		self.updateParamGroupView

	},

	legatoSustainMode: { arg self;
		if(self.proxy.source.pairs.clump(2).any { arg pair, idx;
			pair.first == \sustain
		}) {
			\sustain
		} {
			\legato
		};
	},

	noteMode: { arg self;
		var keys = self.proxy.source.pairs.clump(2).flop.first;
		case(
			{ keys.includes(\freq) }, {
				\freq
			},
			{ keys.includes(\midinote) }, {
				\midinote
			},
			{ keys.includes(\note) }, {
				\note
			},
			{ keys.includes(\degree) }, {
				\degree
			}, {
				\freq
			}
		);
	},

	noteMode_: { arg self, val;
		switch(val,
			\freq, { 
				self.addParam(\freq, 200);
			},
			\midinote, {  
				self.removeParam(\freq);
				self.addParam(\midinote, 60);
			},
			\note, {  
				self.removeParam(\freq);
				self.removeParam(\midinote);
				self.addParam(\note, 0);
			},
			\degree, {  
				self.removeParam(\freq);
				self.removeParam(\midinote);
				self.removeParam(\note);
				self.addParam(\degree, 0);
			},
		);
		self.updateParamGroupView;
	},

	removeParam: { arg self, key;
		if(self.proxy.source.at(key).notNil) { // if no key defined, Pbindef add it back!
			self.proxy.source.set(key, nil);
		}
	},

	addParam: { arg self, key, val;
		if(self.proxy.source.at(key).isNil) { // if already defined, do not change it
			self.proxy.source.set(key, val ?? { Param(self.proxy, key).default });
		}
	},

	asView: { arg self, def, proxy;
		var modview = self.makeModulatorView;
		~self = self;
		self.proxy = proxy;
		self.customParamList = [
			Param(self.proxy, \dur),
		];
		VLayout (
			[self.makeInstrView(proxy), stretch:10],
			self.modulatorView,
			self.makeFxView,
		)

	},
));

//WindowDef(\PbindefEditor).front(Pbindef(\pb5));
//WindowDef(\test, WindowDef(\PbindefEditor)).front(Pbindef(\test, \instrument, \default));
WindowDef(\test, WindowDef(\PbindefEditor)).front(Pbindef(\pb7));

Spec.add(\legato, ControlSpec(0.05,2,\exp,0,0.8));
Spec.add(\dur, ControlSpec(1/32,10,\lin,0,1));
Spec.add(\sustain, ControlSpec(0.05,4,\exp));
Spec.add(\degree, ControlSpec(0,14,\lin,1));
Spec.add(\mtranspose, ControlSpec(0,14,\lin,1));
Spec.add(\root, ControlSpec(0,14,\lin,1));
Spec.add(\note, ControlSpec(0,24,\lin,1));
Spec.add(\ctranspose, ControlSpec(0,24,\lin,1));
Spec.add(\midinote, ControlSpec(1,126,\lin,1,60));
Spec.add(\octave, ControlSpec(1,7,\lin,1,4));
Spec.add(\scale, TagSpecDef(\scale, { Scale.all.parent.asAssociations } ));
Spec.add(\bufnum, ParamAudioBufferSpec()
	.startParamName_(\pos)
	.numChannels_(2)
	.startType_(\seconds)
	.sustainParamName_(\sustain)
);
//SynthDesc(\playersec).addSpec(\out, ControlSpec(0,20,\lin));
SynthDesc(\playersec).specs[\pos] = ControlSpec(0,20,\lin);
SynthDesc(\playersec).specs[\velamp] = \unipolar.asSpec;
);
Scale.at(\ionian)
Scale.all.parent.asPairs.clump(2).collect(_.postln)
Scale.all.parent.asAssociations

NoteTimeline(\Pbindef_pb).edit
~self.modulators
~self.isMixerEnabled
~self.noteMode
~self.noteTimeline.edit
~plist
~self.mixer.insertFxAt(0).synthName
~self.modulators
~self.getParamForm(Param(~self.proxy, \lpfr -> \stepseq))
Param(~self.proxy, \lpfr -> \stepseq).get
Param(~self.proxy, \lpfr -> \source).get
~self.paramList.select{ arg p; p.propertyRoot == \lpfr }
Param(~self.proxy, \dfggd -> \source).get
Param(~self.proxy, \dfggd -> \source).type
Param(~self.proxy, \dfggd -> \stepseq).get
Param(~self.proxy, \dfggd -> \stepseq).type
Pbindef(\pb).source.at(\sustain).source
Pbindef(\pb).source.removeAt(\sustain)
Pbindef(\pb).source.set(\sustain, nil)
~self.noteMode = \degree
~self.noteMode = \freq
~self.noteMode = \midinote
~self.noteMode = \note
Pbindef(\pb).source.pairs.clump(2).flop.first
Pbindef(\pb).source.set(\degree, nil)
Pbindef(\pb).source.set(\freq, nil)
Pbindef(\pb).source.set(\midinote, nil)
Pbindef(\pb).source.set(\note, nil)
Pbindef(\pb).source.set(\degree, 0)
Pbindef(\pb).source.set(\lpfr, nil)
Pbindef(\pb).source.at(\midinote)
Pbindef(\pb).source.at(\NoteTimeline).source.value
Pbindef(\pb).source.at(\dur).source.value
Pbindef(\pb2).source.at(\amp).source.value
Pbindef(\pb).play
Pbindef(\pb).source.pairs
TrackMixerDef(\Pbindef_pb).edit
TrackMixerDef(\Pbindef_pb).clear
PbindProxy
Param(Pbindef(\pb), \legato).get
Param(Pbindef(\pb), \legato -> \source).get
Param(Pbindef(\pb), \legato -> \source).edit
Param(Pbindef(\pb), \degree -> \source).spec
Param(Pbindef(\pb), \degree -> \source).type
Param(Pbindef(\pb), \lpfr -> \source).type
Param(Pbindef(\pb), \lpfr -> \source).isDefined

Param(Pbindef(\pb6), \lptab -> \source).type
Param(Pbindef(\pb6), \lptab -> \source).get
Param(Pbindef(\pb6), \lpfr -> \source).get
Param(Pbindef(\pb6), \lpfr -> \source).getRaw
Param(Pbindef(\pb6), \lpfr -> \source).set([3,2,1])
Pbindef(\pb6).source.at(\lptab).source
Pbindef(\pb6).source.at(\adsr).source
Pbindef(\pb6).source.at(\lpfr).source
Pbindef(\pb6).source.at(\lpfr).source = [1,2,3]
Param(Pbindef(\pb6), \lptab).get
Param(Pbindef(\pb6), \lptab).set([1,2,3])
Param(Pbindef(\pb6), \adsr).get
Pbindef(\pb6).get(\lptab)
Pbindef(\pb6).get(\adsr)


(
Pdef(\zed, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0],inf),
		//\adsr, Pseq([
			//Env.adsr(0.1,0.1,0.8,1.1),
		//],inf),
		\adsr, Env.adsr(0.1,0.1,0.8,1.1),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
Pbindef(\zed, 
	\instrument, \saw,
	\degree, Pseq([0],inf),
	\adsr, Pseq([
		Env.adsr(0.1,0.1,0.8,1.1),
	],inf),
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,1.1) ],
	],inf),
	//\adsr, Env.adsr(0.1,0.1,0.8,1.1),
	\adsr, [ Env.adsr(0.1,0.1,0.8,1.1) ],
	\dur, 1,
	\amp, 0.1,
).play;
);

PdefParam.instrument(Pbindef(\pb))

Pbindef(\pb).source.at(\degree)
Pbindef(\pb).source.at(\freq)
Pbindef(\pb, \stretch, 1/2)

(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(30,19000), \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

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
				//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");

				if(buttonNumber == 1) {
					WindowDef(\GlobalLibrary_select).front(nil, { arg synth;
						//synth.debug("synth");
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
SynthDef(\sin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDesc(\saw).addTag(\cool).addTag(\note);
SynthDesc(\sin).addTag(\cool).addTag(\note);
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

// OK! see tests/param.scd

////////////
// NoteTimeline tests

NoteTimeline(\bla).edit

(
Pbindef(\zed, 
	\instrument, \default,
	//\degree, Pseq([0],inf),
	\NoteTimeline, {NoteTimeline(\bla)},
	\dur, Prout({ arg ev;
		var pat = ev[\NoteTimeline].value.asPattern;
		pat.do { arg val;
			ev.putAll(val);
			//ev[\midinote] = val[\midinote];
			//ev[\type] = val[\type];
			//ev[\sustain] = val[\sustain];
			ev = val.dur.yield;
		};
	}),
	\amp, 0.1,
).play;
);
Pbindef(\zed).clear
(
NoteTimeline(\bla)[\asStream]= { arg self, inval; self.asPattern.asStream(inval) };
NoteTimeline(\bla)[\embedInStream]= { arg self, inval; self.asPattern.embedInStream( inval ) };
NoteTimeline(\bla)[\streamArg]= { arg self, inval; self.asStream(inval) };
)
NoteTimeline(\bla).eventType
NoteTimeline(\bla).keys

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\bla, Pbind(
			\instrument, \default,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
Pdefn(\ba, Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 1,
	\amp, 0.1,
))
)
Pdefn(\ba).asStream.nextN(10,0)

(
Pdef(\gri, 
	Pbind(
		\instrument, \default,
		//\degree, Pseq([0],inf),
		\dur, Prout({ arg ev;
			var pat = NoteTimeline(\bla).asPattern;
			pat.do { arg val;
				ev[\midinote] = val[\midinote].debug("midinote");
				ev = val.dur.yield;
			};
		}),
		\amp, 0.1,
	)
).play;
);


(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out.poll, sig);
}).add;
);
(
Pdef(\zed, 
	DebugPbind(
		\instrument, \saw,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
		//\out, BusDef(\trackMixerDef_bla, \audio),
		\out, TrackMixerDef(\bla3),
	).trace
).play;
TrackMixerDef(\bla3).play;
);

(
Pbindef(\zed, 
	\instrument, \saw,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1,
	\out, TrackMixerDef(\bla4),
).play;
TrackMixerDef(\bla4).play;
);

TrackMixerDef(\bla3).streamArg.asCompileString
TrackMixerDef(\bla3).asStream
TrackMixerDef(\bla4).streamArg.next
TrackMixerDef(\bla3).next
TrackMixerDef(\bla3).next = 3
TrackMixerDef(\bla3)[\next] = 3
TrackMixerDef(\bla4).next
123.streamArg.next
123.next
PbindProxy
Pbindef(\zed).source.set(\out, TrackMixerDef(\Pbindef_pb))
~p = PatternProxy.new
~p.source = TrackMixerDef(\bla3).asStream
~p.asStream.nextN(10,())

TrackMixerDef(\bla).edit
TrackMixerDef(\bla)
TrackMixerDef(\bla).play
Pattern

		Param(Pbindef(\pb), \out -> \source).get.isKindOf(TrackMixerDef)
		Param(Pbindef(\pb), \out -> \source).get.isKindOf(ProtoClass) and: {  }

//// next ???

Pseq([1,2,4]).streamArg(false).next
~p = Pseq([1,2,4]);
~r = Routine { arg inval; loop { inval = ~p.next(inval).yield } }
~r.next
Prout({}) === Prout({})

TrackMixerDef(\bla)[\asUgenInput] = { arg self; self.inbus }
TrackMixerDef(\bla)[\embedInStream] = { arg self; self.inbus.embedInStream }
TrackMixerDef(\bla)[\asStream] = { arg self; self.inbus.asStream }
TrackMixerDef(\bla).inbus.rate
TrackMixerDef(\Pbindef_pb).next
TrackMixerDef(\Pbindef_pb).clear
TrackMixerDef(\Pbindef_pb).next
TrackMixerDef(\Pbindef_pb).play
TrackMixerDef(\Pbindef_pb).stop
TrackMixerDef(\Pbindef_pb).asStream.next
TrackMixerDef(\Pbindef_pb).edit

/// test speed
// OK!

(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(30,19000), \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
Spec.add(\lpfr, ControlSpec(0.1,4,\exp,0,1.1));
);

(
Pbindef(\pb, 
	\instrument, \saw,
	\degree, PstepSeq([0,3,5,1],inf),
	\dur, 1/2,
	\amp, 0.1,
).play;
);

Param(Pbindef(\pb), \lpfr).edit
Pbindef(\pb).play
(
MIDIdef.cc(\ttt, { arg val, ccNum, channel;
	//[ ccNum, channel, val ].debug;
	Pbindef(\pb).set(\lpfr, Spec.specs[\lpfr].map(val/127))
	
}).learn;
)
Spec.specs[\adsr]
Spec.specs[\lpfr]


/////////// Pmod

(
SynthDef(\sawx, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(30,19000), \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
)

(
 Pdef(\bbb, Pbind(\lpfr, Pmod({ SinOsc.kr(1/4).range(0.3, 2) })) <>
Pbind(
   //\degree, Pseq([1, 3, 5, 3], inf),
   \degree, Pseq([[0,3],[0,4]],inf),
   \instrument, \sawx,
)).play
)


//////// param combinator




Ndef(\lfo1).wakeUp
~self.modulators.first.play

NoteTimeline(\bla, Pdef(\bla, Pbind(\instrument, \sawx))).edit


//////// chords



(
Pbindef(\pb3, 
	\instrument, \saw,
	\lpfr, Pwhite(0.1,0.7)*4,
	\degree_steps, PstepSeq([0,3,5,1],inf),
	\chord, [0,2b,4],
	\degree, Pkey(\degree_steps) + Pkey(\chord),
	\dur, 1,
	\amp, 0.1,
).play;
)


//// knob size

(
WindowDef(\win, { arg def;
	VLayout (
		Knob.new.minSize_(Point(1,1)),
		Param(Pbindef(\pb), \lpfr).asKnob.minSize_(Point(1,1)),
	)
}).front;
);


////// change param type

(
Pbindef(\pty, 
	\instrument, \default,
	\degree, PstepSeq([0,3,1,2],inf),
	\dur, 1/2,
	\amp, 0.1,
).play;
);

(
WindowDef(\win, { arg def, param;
	var pview = View.new;
	var slider;
	if(param.parent.at(\source).get.isKindOf(PstepSeq)) {
		slider = param.asMultiSlider;
	} {
		slider = param.parent.at(\source).asSlider;
	};

	pview.layout = VLayout (
		slider
	);
	VLayout (
		pview,
		BasicButton.new.string_("del").action_({
			pview.removeAll;
			
		}),
		BasicButton.new.string_("set").action_({
			~p.parent.at(\source).set(1);
			
		}),
		BasicButton.new.string_("del set").action_({
			pview.removeAll;
			 {
				~p.parent.at(\source).set(1);
			}.defer(1)
			
		}),
	)
	
}).front(~p);
);

~p = Param(Pbindef(\pty), \degree -> \stepseq)
~p.parent.at(\source).set(1)
~p.parent.at(\source).set(PstepSeq([1,4,2,6],inf))
~p.get
~bla = 1.3
~bla = nil


//////// nestOn nestOff synth array handling

(
Pbindef(\zed, 
	\instrument, \sawtab,
	\degree, Pseq([0],inf),
	\rq, PstepSeq([0.3,0.5],inf),
	\dur, 1,
	\amp, 0.1,
).play;
);

Param(Pbindef(\zed), \lptab -> \source).get
Param(Pbindef(\zed), \lptab -> \source).set([2,0.4,2])
Param(Pbindef(\zed), \lptab -> \source).shouldBeNested
Param(Pbindef(\zed), \freq -> \source).shouldBeNested
Param(Pbindef(\zed), \freq -> \source).set([123,432,566])
Param(Pbindef(\zed), \freq -> \source).set(566)
Param(Pbindef(\zed), \freq -> \source).wrapper.propertyPath
Param(Pbindef(\zed), \freq -> \source).wrapper.property
Param(Pbindef(\zed), \lptab -> 0).wrapper.propertyPath
Param(Pbindef(\zed), \lptab -> 0).propertyPath
Param(Pbindef(\zed), \lptab).type
Param(Pbindef(\zed), \lptab -> \source).type
Param(Pbindef(\zed), \freq).type
Param(Pbindef(\zed), \freq -> \source).type
Param(Pbindef(\zed), \rq).type
Param(Pbindef(\zed), \rq -> \source).type
Param(Pbindef(\zed), \rq -> \stepseq).type
PdefParam.instrument(Pbindef(\zed))
Param.toSynthDefSpec(nil, \lptab, \sawtab)
Param.getSynthDefDefaultValue(\lptab, \sawtab)
Pbindef(\zed).source.at(\lptab).source
\lptab.asSpec




TrackMixerDef(\bli).insertFxAt(0).getParam(\gain).default
TrackMixerDef(\bli).insertFxAt(0).synthName
Param.getSynthDefDefaultValue(\gain, \ifx_default)



////////////// inBusMode


Param(Pbindef(\pb6), \lpfr).inBusMode
Param(Pbindef(\pb6), \lpfr -> \source).inBusMode
Param(Pbindef(\pb6), \lpfr -> \source).inBusMode_(true)
Param(Pbindef(\pb6), \lpfr -> \source).get
Param(Pbindef(\pb6), \lpfr -> \source).set(4)
Pbindef(\pb6).source.at(\lpfr).source



/////////////////// final test


(
Pbindef(\hoho, 
	\instrument, \default,
	\degree, PstepSeq([0,4,2,1],inf),
	\dur, 1,
	\amp, 0.1,
).play;
);
Pbindef(\hoho).clear
Pbindef(\hoho).play

WindowDef(\PbindefEditor).front(Pbindef(\hoho))
Param(Pbindef(\hoho), \degree -> \source).get
Param(Pbindef(\hoho), \degree -> \source).set(1)
Pbindef(\hoho).source.at(\degree).source
Param(Pbindef(\pb6), \ctranspose -> \source).at(1).get
Param(Pbindef(\pb6), \ctranspose -> \source).size
Param(Pbindef(\pb6), \lpfr -> \source).inBusMode
Param(Pbindef(\pb6), \lpfr).inBusMode



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		
	])
)).play;
);



		(
		Pbindef(\kick,
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufidx, PstepSeq([0,1,3],inf),
			\bufnum, Pswitch1(
{
~buflib.kick[~buflib.kick.size.rand.debug("k")].value
} ! 8,
				Pkey(\bufidx),
			),
			\step, PstepSeq((0..4),inf),
			\isRest, Pfunc({ arg ev; ev[\step].coin.not }),
			\dur, 1/8,
			\gain, 0.4 * Pkey(\step),
		)
		)
		Pbindef(\kick).play
		Spec.add(\step, \unipolar)
		Spec.add(\pos, \unipolar)
WindowDef(\PbindefEditor).front(Pbindef(\kick))
Pbindef(\kick).clear
TrackDef(\tlist, )

		(
		Pbindef(\amen,
			\instrument, \player,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, BufDef(\amen),
			//\bufidx, PstepSeq([0,1,3],inf),
			//\bufnum, Pswitch1(
//{
//~buflib.kick[~buflib.kick.size.rand.debug("k")].value
//} ! 8,
				//Pkey(\bufidx),
			//),
			\step, PstepSeq((0..4),inf),
			\isRest, Pfunc({ arg ev; ev[\step].coin.not }),
			\dur, 1/8,
			\gain, 0.4 * Pkey(\step),
		)
		)
WindowDef(\amen,WindowDef(\PbindefEditor)).front(Pbindef(\amen))
WindowDef(\kick,WindowDef(\PbindefEditor)).front(Pbindef(\hoho))

KitTimeline(\bla).edit



(
SynthDef(\fmbellp, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * EnvGen.kr(\freqenv.kr(Env([1,1.002,0.998,1],[0.1,0.8])), gate);
	sig1 = SinOsc.ar(freq * \fac1.kr(2.6706) + \det1.kr(0.13)) * \fmamp.kr(2) + 1; 
	sig2 = SinOsc.ar(freq * \fac2.kr(0.9998) * sig1 + \det2.kr(0));
	sig3 = SinOsc.ar(freq * \fac3.kr(2.6629) * sig1 + \det3.kr(2.04));
	sig4 = LFCub.ar(freq * \fac4.kr(0.9991) * sig1 + \det4.kr(2.14));
	sig5 = SinOsc.ar(freq * \fac5.kr(2.6656) * sig1 + \det5.kr(-2));
	sig6 = SinOsc.ar(freq * \fac6.kr(1) * sig1 + \det6.kr(1.84));
	//sig = sig2 + sig3 + sig4 + sig5 + sig6;
	sig = [sig1, sig2, sig3, sig4, sig5, sig6] * DC.ar(\opamptab.kr([0,0.5,0.5, 0.5,0.5,0.5]));
	//sig.debug("sig");
	//sig = sig /34;
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0,1,2.1,1,-1) ),gate,doneAction:2);
	sig = Pan2.ar(sig, pan + \pantab.kr([ 0, -0.5, -0.5, 0.5, 0.5, 0]), amp).sum;
	Out.ar(out, sig);
}, metadata:(specs:(
	freqenv: ParamEnvSpec( ControlSpec(0.1,2,\lin) ),
	pantab: ParamArraySpec(\pan.asSpec),
	opamptab: ParamArraySpec(\gain.asSpec),
	fac1: ControlSpec(0.1,8,\lin,0,1),
	fac2: ControlSpec(0.1,8,\lin,0,1),
	fac3: ControlSpec(0.1,8,\lin,0,1),
	fac4: ControlSpec(0.1,8,\lin,0,1),
	fac5: ControlSpec(0.1,8,\lin,0,1),
	fac6: ControlSpec(0.1,8,\lin,0,1),
	det1: ControlSpec(0,10,\lin,0,0),
	det2: ControlSpec(0,10,\lin,0,0),
	det3: ControlSpec(0,10,\lin,0,0),
	det4: ControlSpec(0,10,\lin,0,0),
	det5: ControlSpec(0,10,\lin,0,0),
	det6: ControlSpec(0,10,\lin,0,0),
))).add;
SynthDesc(\fmbellp).addTag(\cool).addTag(\note);
)

(
Pbindef(\fmbellp, 
	\instrument, \fmbellp,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1,
).play;
);

WindowDef(\fmbellp, WindowDef(\PbindefEditor)).front(Pbindef(\fmbellp))

WindowDef(\test, WindowDef(\PbindefEditor)).front(Pbindef(\test, \instrument, \default))
WindowDef(\test, WindowDef(\PbindefEditor)).front(Pbindef(\pb2))

MIDIdef.noteOn(\piano).remove
MIDIdef.noteOff(\piano_off).remove

SampleTimeline(\cdh).edit

NoteTimeline(\bla).edit
NoteTimeline(\bla).recorder[\startRecordingHook].asCompileString
NoteTimeline(\bla).recorder.startRecordingHook = { 123 }
NoteTimeline(\bla).controller
NoteTimeline(\bla).param = nil
NoteTimeline(\wow).edit
NoteTimeline(\wow).controller
NoteTimeline(\ii2).edit
ControllerDef.getTagSpec(\piano).list.asDict[\generic_piano]
~t
temp
NoteTimeline(\bla2, Pdef(\saw, Pbind(\instrument, \saw))).edit
NoteTimeline(\bla2).startControl

~pr = PbindProxy(\instrument, \saw)
~pr.play;
Param( ~pr, \freq )
Param( ~pr, \freq ).edit

ParamTimeline(\bla).class
ParamTimeline(\bla).asCompileString
Param(Pbindef(\pb5), \lpfr -> \source).getRaw
Pbindef(\pb5).source.at(\legato).source.isKindOf(ProtoClass)
Pbindef(\pb5).source.at(\legato).source.value.eventType 
Pbindef(\pb2).source.at(\lpfr).source.value.clear
Pbindef(\pb2).source.at(\lpfr).source.asStream.next(())
Pbindef(\pb2).source.at(\lpfr).source.streamArg.next(())
Pbindef(\pb2).source.at(\lpfr).source.streamArg
Pbindef(\pb2).source.at(\lpfr).source
Pbindef(\pb2).source.at(\lpfr).source = nil;
Pbindef(\pb2).source.at(\lpfr).source.edit
Pbindef(\pb2).source.at(\lpfr).source.clear
Pbindef(\pb2).source.at(\lpfr).source[\clear].asCompileString
Pbindef(\pb2).source.at(\lpfr).source.key
Pbindef(\pb2).source.at(\lpfr).source.param.target.getSynchronous
Pbindef(\pb2).asStream.next(())

Param(BusDef(\bla, \control), \value).get
Param(BusDef(\bla, \control), \value).set(10)


(
m = Menu(
    a = MenuAction("Option A"),
    b = MenuAction("Option B")
).title_("Event Example");
f = {
    |action, what, value|
    "MenuAction '%' sent event %, value = %".format(action.string, "\\" ++ what, value).postln;
    if (what == \hovered) { "Hovering over: %".format(action).postln };
    if (what == \triggered) { "Action triggered: %".format(value).postln; m.destroy };
};
a.addDependant(f);
b.addDependant(f);
m.onClose_({ a.removeDependant(f); b.removeDependant(f) }).front;
)


WindowDef(\sdkfj, { arg def;
	
m = Menu(
    a = MenuAction("Option A"),
    b = MenuAction("Option B")
).title_("Event Example");
m

}).front;
~plist.collect(_.property)


//////////////// env mode


(
SynthDef(\saw2, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1).poll * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pbindef(\bla, 
	\instrument, \saw2,
	\degree, Pseq([0],inf),
	\legato, 0.2,
	\freq, Prout({ arg ev;
		var envev;
		var spec = \freq.asSpec;
	   
		loop {
			envev = ev.copy;
			envev[\instrument] = \modadsr;
			envev[\out] = BusDef(\blabli, \control);
			envev[\levelScale] = spec.range;
			envev[\levelBias] = spec.minval;
			envev.debug("envev");
			ev[\finish] = ev[\finish].addFunc({
				envev.play;
			});
			ev = envev[\out].asMap.yield;
		};
		ev
	}),
	\dur, 1,
	\amp, 0.1,
).play;
);
\lpfr.asSpec.range;
(
Pbindef(\bla2, 
	\instrument, \saw2,
	\degree, Pseq([0],inf),
	\legato, 0.2,
	\note, Pseq([
		0,4,2,5,
	],inf),
	\lpfr, Prout({ arg ev;
		var envev;
		var spec = \lpfr.asSpec;
	   
		loop {
			envev = ev.copy;
			envev[\instrument] = \modadsr;
			envev[\out] = BusDef(\blabli, \control);
			envev[\levelScale] = spec.range;
			envev[\levelBias] = spec.minval;
			envev.debug("envev");
			ev[\finish] = ev[\finish].addFunc({
				envev.play;
			});
			ev = envev[\out].asMap.yield;
		};
		ev
	}),
	\dur, 1,
	\amp, 0.1,
).play;
);


(
//~pr.edit;
~pr = ProtoTemplateDef(\PdefEditor_InlineEnv).new(\bla3_lpfr, \lpfr.asSpec);
WindowDef(\win, { arg def;
	HLayout (
		~pr.asView.debug("view"),
	)
	
}).front;
)
WindowDef.tryModeEnabled = false

(
Pbindef(\bla3, 
	\instrument, \saw2,
	\degree, Pseq([0],inf),
	\legato, 0.2,
	\note, Pseq([
		0,4,2,5,
	],inf),
	\lpfr, ProtoTemplateDef(\PdefEditor_InlineEnv).new(\bla3_lpfr, \lpfr.asSpec),
	\dur, 1,
	\amp, 0.1,
).play;
);

~pr = ProtoTemplateDef(\PdefEditor_InlineEnv).new(\bla3_lpfr, \lpfr.asSpec)

~pr.asParamGroup.edit
~pr.edit
(
WindowDef(\win, { arg def;
	HLayout (
		~pr.asView.debug("view"),
	)
	
}).front;
);

(
Pbindef(\bla3, 
	\instrument, \saw2,
	\degree, Pseq([0],inf),
	\legato, 0.2,
	\note, Pseq([
		0,4,2,5,
	],inf),
	\lpfr, ~pr,
	\dur, 1,
	\amp, 0.1,
).play;
);

~ev = ();
Param(~ev, \bla).spec
~ev.addSpec(\bla, \unipolar.asSpec)

(
	
	var res = block { arg break;
		//break.value(123)
		432;
	};
	res.debug("res");
)
~param.spec

WindowDef(\ParamAsSoundFileView).edit(~param)

(
WindowDef(\win, { arg def;
	WindowDef(\ParamAsSoundFileView).asView(~param)
	
}).front;
);

(
WindowDef(\win, { arg def;
	var param = ~param;
	var spec = param.spec;
	var target = param.target;
	//var buf = param.get;
	//param.spec.tagSpec.unmapKey(param.get.bufnum).debug("file");
	WindowDef(\soundfileview).asView(
		//BufDef(spec.tagSpec.unmapKey(param.get)),
		param,
		spec.startParamName !? { Param(target, spec.startParamName -> \source) },
		spec.sustainParamName !? { Param(target, spec.sustainParamName -> \source) },
		spec.endParamName !? { Param(target, spec.endParamName -> \source) },
		spec.speedParamName !? { Param(target, spec.speedParamName -> \source) },
		spec.startType ? \unipolar,
		spec.sustainType ? \beats,
		spec.endType ? \unipolar,
	);
}).front;
);
.get
BufDef(\amen).plot
~param.get
~param.spec.startParamName

BufDef(\amen, "vipere/amenbreak.wav");
BufDef(\moeten, "voices/02_moeten.flac")
BufDef(\crepe, "field/crepe.flac");
BufDef(\oeuf, "field/oeuf.flac");
BufDef(\ukraine, "bruit1/07_ukraine.flac");
BufDef(\table, "field/table.flac");
BufDef(\scream, "vipere/scream.flac");
BufDef(\rocksteady, "vipere/rocksteady.flac");
BufDef(\metal, "vipere/metal.flac");
BufDef(\bomb, "vipere/bomb.flac");
