
// the goal is to have a all-in gui to plug the piano controller and play
// - kind of PbindefEditor, choose instrument, change parameters
// - choose controller
// - virtualkeyboard
// - Arpegiator
// - NoteTimelineTrack to have several buffers
// - AutomationRack
// - TODO: modify virtualkeyboard to hold notes while in arp mode

(

//// lib

//FileSystemProject.load("paramdev/drafts/arpegiator.scd");
FileSystemProject.loadOnce("paramdev/drafts/FormEntryMod.scd"); 
FileSystemProject.load("paramdev/drafts/FxRack.scd");
FileSystemProject.load("paramdev/drafts/SynthDefPreset.scd");
FileSystemProject.loadOnce("libdef/ModulatorRack.scd");

Spec.add(\velocity, ControlSpec(0,127,\lin));

~initialize_jack.();


//// PianoCenter

ProtoTemplateDef(\PianoCenter, (
	proxy: { arg self;
		//Pbindef(\PianoCenter, \initialized, true)
		Pdef(\PianoCenter).source = Pdef(\PianoCenter).source ?? { PbindProxy() }
		//Pbindef(\PianoCenter, \instrument, \saw)
	},

	playerGroup: { arg self;
		if(self[\playerGroup_obj].isNil) {
			self[\playerGroup_obj] = ProtoTemplateDef(\SeqPlayerGroup).new(self.proxy);
		};
		self[\playerGroup_obj];
	},

	arp: { arg self;
		self.playerGroup.arp;
	},

	modRack: { arg self;
		TrackDef(\PianoCenter_mod, \ModulatorRack);
	},

	modulatorDict: { arg self;
		if(self[\modDict_obj].isNil) {
			TrackDef(\PianoCenter_mod, \ModulatorRack);
			TrackDef(\PianoCenter_mod).addModulator(Ndef(\lfo1));
			TrackDef(\PianoCenter_mod).addModulator(Ndef(\lfo2));
			TrackDef(\PianoCenter_mod).addModulator(TrackTemplateDef(\StepSeqModulator));
			TrackDef(\PianoCenter_mod).addModulator(TrackTemplateDef(\StepSeqModulator));

			self[\modDict_obj] = (
				lfo1: TrackDef(\PianoCenter_mod).childAt(0),
				lfo2: TrackDef(\PianoCenter_mod).childAt(1),
				step1: TrackDef(\PianoCenter_mod).childAt(2),
				step2: TrackDef(\PianoCenter_mod).childAt(3),
				//env1: Ndef(\env1),
				//env2: Ndef(\env2),
				
			);
		};
		self[\modDict_obj];
	},

	recorder: { arg self;
		self.recorderTimeline.recorder;
	},

	recorderTimeline: { arg self;
		if(self[\recorderTimeline_obj].isNil) {
			self[\recorderTimeline_obj] = NoteTimeline(\PianoCenter_recorderTimeline, self.proxy);
			self[\recorderTimeline_obj].playerGroup = self.playerGroup;
			self[\recorderTimeline_obj][\startControl] = { arg sub; self.startControl };
			self.arp.recorder = self[\recorderTimeline_obj].recorder;
		};
		self[\recorderTimeline_obj]
	},

	fxRack: { arg self;
		ProtoDef(\PianoCenter_FxRack, \InsertFxRack);
		ProtoDef(\PianoCenter_FxRack).fxBus; // generate fx bus to be available in gui
		ProtoDef(\PianoCenter_FxRack);
	},

	clear: { arg self;
		self[\arp_recorder_obj] = nil;
		self[\normal_recorder_obj] = nil;
		self[\modDict_obj] = nil;
		self[\playerGroup_obj] = nil;
	},

	//presetBank: { arg self;
		//if(self[\presetBank_obj].isNil) {
			//self[\presetBank_obj] = IdentityDictionary.new;
		//};
		//self[\presetBank_obj];
	//},

	presetBank: { arg self;
		if(self[\presetBank_obj].isNil) {
			self[\presetBank_obj] = ProtoTemplateDef(\PresetGraphBank).new((
				main: ParamGroup([
					//Param(Message(self), \synthDefNameStack),
				].flat),
				items: {
					[
						(main:self.asParamGroup),
						self.fxRack.presetBank.presetScheme,
						self.modRack.presetBank.presetScheme,
					]
				}
			), {
				self.fxRack.changed(\fxList);
			})
		};
		self[\presetBank_obj];
	},

	savePreset: { arg self;
		var preset = IdentityDictionary.new;
		var pg = [self.asParamGroup, self.modRack.asParamGroup, self.fxRack.asParamGroup].flatten;
		pg.debug("pg");
	},

	//savePreset: { arg self, key;
		//var preset = IdentityDictionary.new;
		//preset[\synth] = ProtoTemplateDef(\SynthDefPresetBank).new(self.proxy).buildPreset;
		//preset[\mod] = self.modRack.presetCompileString;
		//preset[\fx] = self.fxRack.presetCompileString;

		//preset[\combi] = self.proxy.asParamGroup.getCombinatorList.collect({ arg asso;
			//asso.key -> asso.value.presetCompileString;
		//});
		//self.presetBank[key] = preset;
	//},

	//loadPreset: { arg self, key;
		//var preset = self.presetBank[key];
		//if(preset.isNil) {
			//"No preset named %".format(key).error;
		//} {
			//ProtoTemplateDef(\SynthDefPresetBank).new(self.proxy).loadPresetFromObject(preset[\synth]);
			//preset[\mod].interpret;
			//preset[\fx].interpret;
			//self.proxy.asParamGroup.do { arg param, idx;
				//var item = preset[\combi].detect { arg x; x.key == param };
				//if(item.notNil) {
					//item.value.debug("Enable combi");
					//item.value.interpret
				//} {
					//param.debug("Clear combi");
					//param.clearCombinator(false);
				//};
			//};
		//};
	//},

	asParamGroup: { arg self;
		self.proxy.asParamGroup.rejectSystemParams.rejectByProperty([\dur,\legato,\freq, \instrument]);
	},

	presetDict: { arg self;
		self.presetBank
	},

	getCombinatorCompileString: { arg self;
		self.asParamGroup.getCombinatorCompileString;
	},
	edit: { arg self;
		WindowDef(\PianoCenter).front(self)
	},
));

WindowDef(\PianoCenter, (
	asView: { arg self, def, model;
		var pgView = View.new;
		var toolbar;
		var modview;
		var fxview = View.new.layout_(model.fxRack.asView);
		var mainpanel = View.new;
		// View.visible seems to be lagging, this is a workaround
		"PianoCenter.asView: 1".debug;
		self.paramGroupView = pgView;
		self.model = model;
		self.fxView = fxview;
		self.def = def;

		fxview.visible = false;

		"PianoCenter.asView: 2".debug;
		pgView.followChange(model.proxy, \set, { arg view, obj, msg ...args;
			//[view, obj, msg, args].debug("vom");
			if(args.first == \instrument) {
				self.updateView;
			};
		});
		pgView.maxWidth_(1200);

		"PianoCenter.asView: 2.1".debug;
		self.updateView;
		"PianoCenter.asView: 2.2".debug;

		toolbar = self.makeToolbar;

		"PianoCenter.asView: 3".debug;
		modview = WindowDef(\ModulatorPanel).asView( 
			[\lfo1, \lfo2, \step1, \step2].collect { arg key, idx;
				key -> model.modulatorDict[key]
			};
		);

		mainpanel.layout = VLayout (
			toolbar,
			VLayout (
				[pgView, stretch:10],
				modview,
			),
			WindowDef(\TimelinePianoKeyboard).embedView(def, model.playerGroup).minHeight_(50)
		);
		"PianoCenter.asView: 4".debug;
		mainpanel.maxWidth_(1200);
		HLayout (
			mainpanel,
			fxview,
			nil
		)
	},

	makeToolbar: { arg self;
		var model = self.model;
		var hasControl = Param(Message(model.playerGroup), \hasControl, ParamBoolSpec());
		
		HLayout (
			HLayout (
				StaticText.new.string_("Controller:"),
				hasControl.asLED.fixedSize_(10@10).font_(Font.default.size_(9)),
				Param(
					Message(model.playerGroup),
					\controller, 
					ControllerDef.getTagSpec(\piano),
				).asPopUpMenu,
				nil,
			).spacing_(5),
			HLayout (
				StaticText.new.string_("Instr:"),
				Param(
					model.proxy,
					\instrument -> \source, 
					TagSpecDef(\SynthDef_keys),
				).asPopUpMenu,
				nil,
			).spacing_(5),
			//Param(Message(model), \currentPreset, self.presetBank.keys).asPopUpMenu,

			WindowDef(\PresetSelectorView).asView(model.presetBank),
			HLayout (
				StaticText.new.string_("Arp:"),
				HLayout (
					Param(
						Message(model.arp),
						\arpPreset, 
						TagSpecDef(\ArpPreset),
					).asPopUpMenu,
					PlayerWrapper(model.arp.arpProxy).asView.fixedWidth_(20).label_(""),
				).margins_(0).spacing_(0),
				nil,
			).spacing_(5),
			HLayout (
				StaticText.new.string_("Tempo:"),
				Param(
					Message(TempoClock.default),
					\tempo, 
				).asTextField,
				nil
			).spacing_(5),
			HLayout (
				BasicButton.new.string_("Timeline").action_({
					model.recorderTimeline.edit;
				}),
				RecordButton.new(model, \recorder, "Rec").view.fixedWidth_(40),
			).spacing_(0),
			BasicButton.new.string_("Fx>").action_({
				var wasVisible = self.fxView.visible;
				self.def.windowDo { arg win;
					if(wasVisible == false) {
						self.bounds_nofx = win.bounds.copy;
						win.bounds.debug("old bounds");
						//win.rememberPosition;
					};
				};
				self.fxView.visible = wasVisible.not;
				self.def.windowDo { arg win;
					wasVisible.debug("wasVisible");
					if(wasVisible == true) {
						if(self.bounds_nofx.notNil) {
							win.bounds.debug("old bounds");
							{
								win.bounds = self.bounds_nofx;
							}.defer;
							//[win.bounds, self.bounds_nofx].debug("new bounds");
							//win.recallPosition;
						};
					};
					//var bo = win.bounds.copy;
					//bo.width = bo.width - self.fxView.bounds.width;
					//win.bounds = bo;
				};
			}).fixedWidth_(30),
		).margins_(0).spacing_(10);
	},

	updateView: { arg self;
		var pgView = self.paramGroupView;
		var model = self.model;
		pgView.removeAll;
		//pgView.layout = model.proxy.asParamGroup.asView;
		pgView.layout = VLayout(
			* model.asParamGroup.collect { arg param, idx;
				WindowDef(\FormEntryMod).asView(param);
			};
		)
	},
));


////

ProtoDef(\PianoCenter, \PianoCenter);
ProtoDef(\PianoCenter).proxy.source.set(\instrument, \sh101);
ProtoDef(\PianoCenter).edit;
Ndef(\lfo1, { arg freq=1, gain=1; 
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = SinOsc.kr(freq);
	sig2 = LFTri.kr(freq);
	sig3 = LFSaw.kr(freq);
	sig4 = LFPulse.kr(freq);
	sig = SelectX.kr(\shape.kr(0)*3, [sig1, sig2, sig3, sig4]);
	sig = sig *gain;
	sig;
});
Ndef(\lfo1).addSpec(\freq, \lofreq).addSpec(\shape, \unipolar);
Ndef(\lfo2).source = Ndef(\lfo1).source;
Ndef(\lfo2).addSpec(\freq, \lofreq).addSpec(\shape, \unipolar);

Pdef(\basearp,
	Pbind(
		\dur, 1/8,
		\amp, 0.1,
		\idx, Pseq((0..3),inf),
		//\octaveshift, Pseq([0,0,-1,0,0,1],inf),
	)
);
Pdef(\slowarp,
	Pbind(
		\dur, 1/4,
		\legato, 0.8,
		\amp, 0.1,
		\idx, Pseq((0..3),inf),
		//\octaveshift, Pseq([0,0,-1,0,0,1],inf),
	)
);
TagSpecDef(\ArpPreset).addUnique(\basearp).addUnique(\slowarp);
s.boot;
)

// END
///////////////////////

// TODO
// - now save all mod and fx and not use compilestring
// - all in bus mode ?

ProtoDef(\PianoCenter).edit;
ProtoTemplateDef(\PianoCenter).modRack.presetCompileString
ProtoTemplateDef(\PianoCenter).fxRack.presetCompileString.editorInsert
ProtoTemplateDef(\PianoCenter).fxRack.asParamGroup.do({ arg x; x.debug("--") })
ProtoTemplateDef(\PianoCenter).fxRack.asParamGroup
ProtoTemplateDef(\PianoCenter).fxRack.fxList[0].asCompileString
ProtoTemplateDef(\PianoCenter).modRack.childAt(0).presetScheme.items
ProtoTemplateDef(\PianoCenter).presetBank_obj = nil
ProtoTemplateDef(\PianoCenter).edit
ProtoTemplateDef(\PianoCenter).presetBank.printTree
ProtoTemplateDef(\PianoCenter).presetBank.printCurrentPreset
ProtoTemplateDef(\PianoCenter).asParamGroup.asPropertyDict.keys
ProtoTemplateDef(\PianoCenter).proxy.asParamGroup.asPropertyDict.keys

~param.hasCombinator
~param.target.getHalo
Message

Dictionary
ProtoTemplateDef(\PianoCenter).presetBank[\aa][\combi].asCompileString
~p = Param(Pbindef(\PianoCenter), \lpfr)
~p.set(2)
~p.wrapper.accessor
~p.isSet
~p.target.envir
~p2 = Param(Pbindef(\PianoCenter), \lpfr)
~p == ~p2
~p.identityHash
~p2.identityHash
~p.hash
~p2.hash
ProtoTemplateDef(\PianoCenter).presetBank[\aa][\combi][Param(Pbindef(\PianoCenter), \lpfr)]
ProtoTemplateDef(\PianoCenter).presetBank[\aa][\combi][~p]
ProtoTemplateDef(\PianoCenter).presetBank[\aa][\combi][~p2]
ProtoTemplateDef(\PianoCenter).presetBank[\bb][\combi].asAssociations.first.value.interpret
ProtoTemplateDef(\PianoCenter).presetBank[\bb][\combi].asAssociations
ProtoTemplateDef(\PianoCenter).presetBank[\zzz][\combi]
Knob.background

ProtoTemplateDef(\PianoCenter).modDict_obj = nil
ProtoTemplateDef(\PianoCenter).clear
ProtoTemplateDef(\PianoCenter).proxy.asParamGroup.asPropertyDict[\lpfr].getCombinator.inputObjects[0].param
ProtoTemplateDef(\PianoCenter).proxy.asParamGroup.asPropertyDict[\lpfr].getCombinator.inputObjects[0].presetCompileString
ProtoTemplateDef(\PianoCenter).proxy.asParamGroup.asPropertyDict[\lpfr].getCombinator.targetParam
ProtoTemplateDef(\PianoCenter).proxy.asParamGroup.asPropertyDict[\lpfr].getCombinator.existingInputObjects
ProtoTemplateDef(\PianoCenter).getCombinatorCompileString.editorInsert
(
ParamCombinator(Param(Pbindef('PianoCenter'), 'spread')).mapObjectToInput(Ndef('lfo1'), range: 0.4);

);
(
ParamCombinator(Param(Pbindef('PianoCenter'), 'spread')).mapObjectToInput(Ndef(\lfo1), range: 0.4);

);
(
ParamCombinator(Param(Pbindef('PianoCenter'), 'spread')).mapObjectToInput(TrackDef('PianoCenter_mod').childAt(1), range: -1.0);
ParamCombinator(Param(Pbindef('PianoCenter'), 'spread')).mapObjectToInput('freq', range: 1.0);
ParamCombinator(Param(Pbindef('PianoCenter'), 'lpfr')).mapObjectToInput('velocity', range: 1.0);
ParamCombinator(Param(Pbindef('PianoCenter'), 'lpfr')).mapObjectToInput('freq', range: -0.66869897645844);
ParamCombinator(Param(Pbindef('PianoCenter'), 'lpfr')).mapObjectToInput(TrackDef('PianoCenter_mod').childAt(0), range: 0.51647461527232);

);
(
ParamCombinator(Param(Pbindef('PianoCenter'), 'spread')).mapObjectToInput(TrackDef('PianoCenter_mod').childAt(1), range: 0);
ParamCombinator(Param(Pbindef('PianoCenter'), 'spread')).mapObjectToInput('freq', range: 0);
ParamCombinator(Param(Pbindef('PianoCenter'), 'lpfr')).mapObjectToInput('velocity', range: 0);
ParamCombinator(Param(Pbindef('PianoCenter'), 'lpfr')).mapObjectToInput('freq', range: 0);
ParamCombinator(Param(Pbindef('PianoCenter'), 'lpfr')).mapObjectToInput(TrackDef('PianoCenter_mod').childAt(0), range: 0);

);
(
ParamCombinator(Param(Pbindef('PianoCenter'), 'lpfr')).mapObjectToInput('velocity', range: 0);
ParamCombinator(Param(Pbindef('PianoCenter'), 'lpfr')).mapObjectToInput('freq', range: 0);

);
(
ParamCombinator(Param(Pbindef('PianoCenter'), 'lpfr')).mapObjectToInput(TrackDef('PianoCenter_mod').childAt(0), range: 0);
ParamCombinator(Param(Pbindef('PianoCenter'), 'lpfr')).mapObjectToInput('freq', range: 0);
ParamCombinator(Param(Pbindef('PianoCenter'), 'lpfr')).mapObjectToInput('freq', range: 0);

);
(
ParamCombinator(Param(Pbindef('PianoCenter'), 'lpfr')).mapObjectToInput(TrackDef('PianoCenter_mod').childAt(0), range: 0);
ParamCombinator(Param(Pbindef('PianoCenter'), 'lpfr')).mapObjectToInput('velocity', range: 0);

);
(
ParamCombinator(Param(Pbindef('PianoCenter'), 'lpfr')).mapObjectToInput(TrackDef('PianoCenter_mod').childAt(0), range: 0);

);
(
ParamCombinator(Param(Pbindef('PianoCenter'), 'spread')).mapObjectToInput(TrackDef('PianoCenter_mod').childAt(1), range: 0);
ParamCombinator(Param(Pbindef('PianoCenter'), 'spread')).mapObjectToInput('freq', range: 0);
ParamCombinator(Param(Pbindef('PianoCenter'), 'spread')).mapObjectToInput('freq', range: 0);
ParamCombinator(Param(Pbindef('PianoCenter'), 'spread')).mapObjectToInput(TrackDef('PianoCenter_mod').childAt(1), range: 0);

);
(
ParamCombinator(Param(Pbindef('PianoCenter'), 'spread')).mapObjectToInput(TrackDef('PianoCenter_mod').childAt(1), range: 0);
ParamCombinator(Param(Pbindef('PianoCenter'), 'spread')).mapObjectToInput('freq', range: 0);
ParamCombinator(Param(Pbindef('PianoCenter'), 'spread')).mapObjectToInput('freq', range: 0);
ParamCombinator(Param(Pbindef('PianoCenter'), 'spread')).mapObjectToInput(TrackDef('PianoCenter_mod').childAt(1), range: 0);

);
(
ParamCombinator(Param(Pbindef('PianoCenter'), 'spread')).mapObjectToInput(TrackDef('PianoCenter_mod').childAt(1), range: 0);
ParamCombinator(Param(Pbindef('PianoCenter'), 'spread')).mapObjectToInput(freq, range: 0);
ParamCombinator(Param(Pbindef('PianoCenter'), 'spread')).mapObjectToInput(freq, range: 0);
ParamCombinator(Param(Pbindef('PianoCenter'), 'spread')).mapObjectToInput(TrackDef('PianoCenter_mod').childAt(1), range: 0);

);
(
ParamCombinator(Param(Pbindef('PianoCenter'), 'lpfr')).mapObjectToInput(TrackDef('PianoCenter_mod').childAt(1), range: 0);ParamCombinator(Param(Pbindef('PianoCenter'), 'lpfr')).mapObjectToInput(TrackDef('PianoCenter_mod').childAt(1), range: 0);
);
(
ParamCombinator(Param(Pbindef('PianoCenter'), 'lpfr')).mapObjectToInput(TrackDef('PianoCenter_mod').childAt(0), range: 0.133220710146);
);
~pr = ProtoTemplateDef(\PianoCenter).proxy
~pr.asParamGroup.getParamCompileString
ParamGroup
PlayerWrapper(~pr).getPbindCompileString
TrackDef(\PianoCenter_mod).edit
TrackDef(\PianoCenter_mod).childAt(0).source

ParamProto.init(true)

NoteTimeline(\bla).edit
ControllerDef
~t = 185/2/60; TempoClock.default.tempo = ~t;
~install.()
~pc.edit

~p = Param(ProtoTemplateDef(\PianoCenter).proxy, \lpfr)
~p.hasCombinator
~p.get
~p.getRaw
~pc = ~p.getCombinator
~pc = ~param.getCombinator
~pc.edit
~pc.nextFreeInput
~pc.proxy.get(\inputs)
~pc.mapNodeProxyToInput(Ndef(\lfo2))
~pc.inputObjects
Ndef(\lfo1).asMap
~param.at(\source).getRaw.inputParam.get
~param.at(\source).getRaw.asMap
~param.at(\source).spec
~param.getCombinator.targetParam.spec
~pc.proxy.get(\out)
~pc.proxy.asMap
~pc.targetParam.getRaw
~pc.inputObjects.first.label
~pc.inputObjects.first.label
~pc.inputObjects.first.proxy.source
~pc.inputObjects.first.proxy.play
~pc.inputObjects.first.isPlaying
~pc.inputObjects.first.proxy.source.isPlaying
~param

ScrollView
TagSpecDef(\ArpPreset).valueList
ProtoTemplateDef(\PianoCenter).proxy.play
ProtoTemplateDef(\PianoCenter).controller
ProtoTemplateDef(\PianoCenter).arp.inArpMode
ProtoTemplateDef(\PianoCenter).recorder.inArpMode
ProtoTemplateDef(\PianoCenter).recorder.inArpMode
ProtoTemplateDef(\PianoCenter).arpPreset
ProtoTemplateDef(\PianoCenter).arpProxy.source
ProtoTemplateDef(\PianoCenter).arpProxy.play
ProtoTemplateDef(\PianoCenter).arpProxy.play
ProtoTemplateDef(\PianoCenter).playerGroup_obj = nil
~currentNotes.select(_.notNil)


~pg = ProtoTemplateDef(\SeqPlayerGroup).new(Pbindef(\PianoCenter))
~pg.elAt(60).play
Param(Message(ProtoTemplateDef(\PianoCenter)), \arpPreset, TagSpecDef(\ArpPreset))

(
)


(
ProtoTemplateDef(\PianoCombinator, (
	combiList: [
		(source: nil, range: 0, target: nil),
		(source: nil, range: 0, target: nil),
		(source: nil, range: 0, target: nil),
		(source: nil, range: 0, target: nil),
	],

	proxy: { arg self;
		ProtoTemplateDef(\PianoCenter).proxy;
	},

	install: { arg self;
		self.combiList.do { arg item, idx;
			if(item.source.notNil and: { item.target.notNil }) {
				var pc = ParamCombinator(item.target);
				var pcidx;
				pcidx = pc.mapPatternKeyToInput(item.source);
				[pc, pcidx, item.source].debug("installed");
			};
			
		};
		
	},

	targetSpec: { arg self;
		TagSpec( self.proxy.asParamGroup.collect({ arg p; p.propertyRoot -> p }) )
	},

));
WindowDef(\PianoCombinator, { arg def, model;
	var routerlayout;
	var sources = [
		nil,
		\freq,
		\velocity,
	];
	routerlayout = VLayout (
		* model.combiList.collect { arg item, idx;
			HLayout (
				Param(item, \source, TagSpec(sources)).asPopUpMenu,
				Param(item, \range, \bipolar).asSlider.orientation_(\horizontal),
				Param(item, \target, model.targetSpec).asPopUpMenu,
			)
		} ++ [nil];
		
	);
	VLayout (
		BasicButton.new.string_("Install").action_({
			model.install;
		}),
		routerlayout,
	)
	
}).front(ProtoTemplateDef(\PianoCombinator));

)



///////////////// test velocity combinator


(
Spec.add(\velocity, ControlSpec(0,127,\lin));
Pbindef(\testcombi, 
		\instrument, \saw,
		\degree, Pseq([0,Pwhite(0,7,1)],inf),
		\velocity, Pseq([1,60, 100],inf),
		\dur, 1,
		\amp, 0.1,
);
);
Pbindef(\testcombi).play

~p = Param(Pdef(\testcombi), \lpfr -> \source)
~p.set(2)
~pc = ParamCombinator(~p)
~pc.mapPatternKeyToInput(\velocity)
~pc.edit
~pv = Param(Pdef(\testcombi), \velocity).edit

Param(Ndef(\lfo1), \shape).isSynthDefParameter
Param(Ndef(\lfo1), \shape).instrument

Ndef(\lfo1).wakeUp
/////////////////////kkkkkkk


////////////////// pattern recorder

(
	ProtoTemplateDef(\PatternRecorder, (
		new: { arg self, pat;
			
		},

		signalPattern: { arg self;
			Pbind(
				\callback, { arg ev;
					self.asPlayerEvent = ev;
					self.changed(\play);
					thisThread.clock.sched(ev.use { ~sustain.value }, { self.changed(\stop) })
				}
			);
		},

		//asPlayerEvent: { arg self;
			//self.recordedEvent;
		//},

		makeListener: { arg self, fun;
			self.controller.remove;
			self.controller = SimpleController(self).put(\play, {
				debug("play ev");
				fun.(self, \play);
			}).put(\stop, {
				debug("stop ev");
				fun.(self, \stop);
			});
			self.controller;
		},

	));
ParamProto.init;
)

(
Pdef(\torec, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0,2,4,1],inf),
		\dur, 1/2,
		\amp, 0.1,
	)
	<>
	ProtoTemplateDef(\PatternRecorder).signalPattern
).play;
);

~rec= ProtoTemplateDef(\PlayerGroupRecorder).new(ProtoTemplateDef(\PatternRecorder))
~rec.eventList
~rec.startRecording
~rec.stopRecording

ProtoTemplateDef(\PatternRecorder).makeListener({ arg ...args; args.debug("args") })

(
)
ProtoTemplateDef(\PianoCenter).recorderTimeline.eventList.collect({ arg x; x.type })
ProtoTemplateDef(\PianoCenter).recorderTimeline.eventList[1]


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

ControllerDef


(
	WindowDef(\ArpNoteTimeline, { arg def, noteTimeline;
		var arpView;
		noteTimeline = noteTimeline ?? { NoteTimeline(\testarp) };

		VLayout (
			arpView,
			NoteTimeline(\hoho).asView
		)
		
	}).front;
)

(
	FileSystemProject.load("paramdev/drafts/arpegiator.scd");
s.boot;
~initialize_jack.();
	ProtoTemplateDef(\ArpPat, (
		proxy: { arg self;
			Pdef(\defpat, Pbind(\instrument, \saw))
		},

		//// controller

		playerGroup: { arg self;
			if(self[\playerGroup_obj].isNil) {
				self[\playerGroup_obj] = ProtoTemplateDef(\SeqPlayerGroup).new(self.proxy)
			};
			self[\playerGroup_obj];
		},

		//// arp

		arp: { arg self;
			if(self[\arp_obj].isNil) {
				self[\arp_obj] = ProtoTemplateDef(\Arpegiator).new(self.playerGroup);
			};
			self[\arp_obj]
		},

	));
	WindowDef(\ArpPat, { arg def, model;

		HLayout (
			PlayerWrapper(model.proxy),
			HLayout (
				StaticText.new.string_("Controller:"),
				//hasControl.asButton("X"),
				Param(
					Message(model.playerGroup),
					\controller, 
					ControllerDef.getTagSpec(\piano),
				).asPopUpMenu,
				nil,
			).spacing_(5),
			HLayout (
				StaticText.new.string_("Arp:"),
				model.arp.asArpButton,
				nil,
			).spacing_(5),
			HLayout (
				StaticText.new.string_("Tempo:"),
				Param(
					Message(TempoClock.default),
					\tempo, 
				).asTextField,
				nil
			).spacing_(5),
		).margins_(10).spacing_(10);
		
	}).front(ProtoTemplateDef(\ArpPat));

Pdef(\basearp,
	Pbind(
		\dur, 1/8,
		\amp, 0.1,
		\idx, Pseq((0..3),inf),
		//\octaveshift, Pseq([0,0,-1,0,0,1],inf),
	)
);
Pdef(\slowarp,
	Pbind(
		\dur, 1/4,
		\legato, 0.8,
		\amp, 0.1,
		\idx, Pseq((0..3),inf),
		//\octaveshift, Pseq([0,0,-1,0,0,1],inf),
	)
);
TagSpecDef(\ArpPreset).addUnique(\basearp).addUnique(\slowarp);
)


(
	WindowDef(\LED, { arg param;

		StaticText.new.string_("◉").stringColor_(Color.green)
	}).front
)

(
	~model = (isActive:true);
	WindowDef(\win, { arg def;
		//Param(~model, \isActive, ParamBoolSpec()).asLED.fixedSize_(8@8).font_(Font.default.size_(8))
		Param(~model, \isActive, ParamBoolSpec()).asLED
	}).front;
)


///////////

~protordn_to_fbstring.(ProtoDef(\rdn)).editorInsert
(

SynthDef(\rdn_terrorbass, { arg out=0, gate=1;
	// code: 5-AC2A-D7LV
	var si, env = ();
	var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
	var code, rdnkey;

	var sig;
	var sigin;
	var del, shi;
	var del2, shi2;
	var distamp;
	var hasFreq, afreq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var pitchlag;
	var pitchmix;
	var fb, fb1, fb2;
	var gain;
	var mix;
	var indelay;
	//"default_make_graph".debug("!!!");
	rdnkey = rdnkey ? \default;
	code = code ? "4--";
	sig = in;
	mix = \mix.kr(0.5);
	gain = \gain.kr(1);
	fb = \fb.kr(0.001);
	del = \delay.kr(0.001,0.1);
	del2 = \delay2.kr(0.001,0.1);
	shi = \shift.kr(0);
	shi2 = \shift2.kr(0);
	distamp = \distamp.kr(1);
	pitchlag = \pitchlag.kr(1/8) / TempoClock.default.tempo;
	pitchmix = \pitchmix.kr(0);

	sig = LPF.ar(sig, \prelpf.kr(17000));
	sig = HPF.ar(sig, \prehpf.kr(17));

	sig = sig + (LocalIn.ar(2) * fb);

	sig = LPF.ar(sig, \lpf.kr(17000));
	sig = HPF.ar(sig, \hpf.kr(17));
	thisThread.randSeed = 433855.0;
	si = sig;
	sig = { arg si, env;
		si = (si * 10.rand * \distamp.kr).tanh / 2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = [
			{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = [
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					}.value(si, env);

				].mean;
				si = (si * 10.rand * \distamp.kr).tanh / 2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
			}.value(si, env);
			,
			{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = [
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					}.value(si, env);

				].mean;
			}.value(si, env);

		].mean;
	}.value(si, env);


	sig1 = sig.tanh * \fbdistamp.kr(1/2);
	sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

	sig = Limiter.ar(sig);

	sig1 = sig;
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	sig = SelectX.ar(pitchmix, [sig, sig1]);

	LocalOut.ar(sig);
	sig = LPF.ar(sig, \postlpf.kr(17000));
	sig = HPF.ar(sig, \posthpf.kr(17));
	sig = Limiter.ar(sig);
	sig = sig * \wetamp.kr(1);

	indelay = \indelay.kr(0);
	sigin = DelayL.ar(in, 0.2, indelay);
	sig = SelectX.ar(mix, [sigin, sig]);
	sig = sig * gain;
	//sig.debug("end sig");
	sig;


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0,1,0.001)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

		
Pbind(
	'wet10', 1.0,
	'mix', 0.52521008403361,
	'gain', 0.43697478991597,
	'fb', 0.0001,
	'delay', 0.55962764453196,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.12605042016807,
	'distamp', 57.610839222447,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
)

		
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\note, Pseq([
				0,5,3,-3,
			],inf),
			\lpfr, 5,
			\legato, 0.8,
			\octave, 3,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\pfx1, \audio),
		),
		Pmono(\rdn_terrorbass,
			\inbus, BusDef(\pfx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <> 
Pbind(
	'wet10', 1.0,
	'mix', 0.52521008403361,
	'gain', 0.13697478991597,
	'fb', 0.0001,
	'delay', 0.50002764453196,
	'delay2', 0.1001,
	'shift', 0.1,
	'shift2', 0.02605042016807,
	'distamp', 57.610839222447,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
)
		
	])
)).play;
);



~t = 150/2/60; TempoClock.default.tempo = ~t;
(
// galope
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[688].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\pifx1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\pifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\decay, 2,
			\mix, 0.2,
			\delay, 3/8/~t,
			\dur, 1,
		),
		
		Pbind(
			\instrument, \saw,
			\note, Pseq([
				0,5,3,-3,
			],inf),
			\lpfr, 5,
			\legato, 0.8,
			\octave, 3,
			\dur, 2,
			\amp, 0.2,
			\out, BusDef(\pfx1, \audio),
		),
		Pmono(\rdn_terrorbass,
			\inbus, BusDef(\pfx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <> 
Pbind(
	'wet10', 1.0,
	'mix', 0.52521008403361,
	'gain', 0.43697478991597,
	'fb', 0.0001,
	'delay', 0.50002764453196,
	'delay2', 0.1001,
	'shift', 0.1,
	'shift2', 0.02605042016807,
	'distamp', 57.610839222447,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
)
	])
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
	])
)).play;
);

(
Pdef(\zert, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

Pdef(\zert).edit

(
Pdef(\huhu, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

Pdef(\huhu).edit

ParamGroupDef(\SynthDef_saw).presets.keys
ParamGroupDef(\SynthDef_saw).do(_.postln)

NoteTimeline

Pdef(\edit).edit
Pdef(\edit, Pbind()).play


(
Tdef(\wwww, {
	"heel".debug;
	

})
)

Fdef(\bla, )



ClipTimeline(\bla).edit

(
Tdef(\hello, {
	var pp;
	3.do { arg item, idx;
		pp = (degree:idx).play;
		1.wait;
		pp.stop;
	};
})
)


(
Fdef(\mais, {
	var pp;
	3.do { arg item, idx;
		pp = (degree:idx*2).play;
		fork {
			1.wait;
			pp.stop;
		}
	};
})
)

PlayerWrapper(Fdef(\mais)).label

Fdef(\mais).value
Fdef(\mais).findKey
Fdef(\mais).findKey
Fdef.all.findKeyForValue(Fdef(\mais))
p = ProxySpace.new.push
~aa = { arg freq=100; SinOsc.ar(freq)*0.1!2  }
~aa.play
currentEnvironment.findKeyForValue(~aa)
~aa.key
p.pop
~aa
~n = NodeProxy()
~n.key
{
	
var a = NodeProxy(); a.key.debug("k");
}.value

(
f = SynthDef.new(\flux , {
    var sig, amp, env;
    env = EnvGen.kr (
        Env.new([0,1,0], [10,10], [1, -1]),
        doneAction: 2);
    amp = SinOsc.kr({ExpRand(0, 2)}!8).range(0,1);
    sig = SinOsc.ar({ExpRand(50,1200)}!8);
    sig = sig * amp * env;
    sig = Splay.ar(sig) * 0.5;
    Out.ar(0,sig);
}).add;
)

f = Synth.new(\flux);

Line
(
Pdef(\melo, 
	Pbind(
		\instrument, \default,
		\amp, 0.05,
	)
)
);
ProtoDef(\piano).startControl(Pdef(\melo))



		self.proxy.asParamGroup.getCombinatorCompileString();
		self().proxy().bla().rah()
