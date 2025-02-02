// TODO: finish "Add param" button

(
//FileSystemProject.loadOnce("libdef/CustomTrackList.scd");
//FileSystemProject.loadOnce("libdef/PbindefEditor.scd");
FileSystemProject.loadOnce("libdef/synthplayrec.scd");

//////// KitSeqGridTrack
// to be used as a CustomTrackTemplate and contains a the KitSeqGrid .grid

TrackTemplateDef(\KitSeqGridTrack, (
	parent: TrackTemplateDef(\CustomInstrumentTrack),

	grid: { arg self;
		self[\grid] = ProtoDef(( self.trackKey++\_grid ).asSymbol, TrackTemplateDef(\KitSeqGrid));
		self[\grid].parentGrid = { self.parentTrack };
		self[\grid];
	},

	childAt: { arg self, idx;
		self.grid.linePlayerAt(idx)
	},
	editInstrument: { arg self;
		//self.grid.chooseKitDialog;

		WindowDef(\KitSequencer).front(self.grid, self.activeIndex)
	},

));
TagSpecDef(\CustomTrackTemplate).addUnique(\KitSeqGridTrack -> TrackTemplateDef(\KitSeqGridTrack));



//////// KitSeqGrid

TrackTemplateDef(\KitSeqGrid, (
	parent: TrackTemplateDef(\TrackList),
	childClass: { TrackTemplateDef(\KitSeqTrack) },
	sectionClass: { TrackTemplateDef(\KitSeqSection) },
	kit_: { arg self, kit;
		self[\kit] = kit;
		32.do { arg idx;
			self.childAt(idx); // create 32 children if existing
		};
	},

	areasizex: { arg self;
		// used for preview size
		if(self.parentGrid.notNil) {
			self.parentGrid.areasizex
		} {
			self[\areasizex_obj]
		};
	},
	areasizex_: { arg self, val;
		if(self.parentGrid.notNil) {
			self.parentGrid.areasizex = val;
		} {
			self[\areasizex_obj] = val;
		};
	},

	chooseKitDialog: { arg self;
		WindowDef(\GlobalLibrary_select).front(nil, { arg val;
			self.kit = val.last.value;
		}, \Kit);
		
	},

	gridPattern: { arg self;
		self[\gridPattern] = EventPatternProxy.new.source_(Pbind());
		self[\gridPattern];
	},

	editProperties: { arg self;
		WindowDef(\grid_properties, { arg def;
			VLayout (
				HLayout (
					BasicButton.new.string_("Choose kit").action_({
						self.chooseKitDialog;
					}),
					BasicButton.new.string_("Edit kit").action_({
						self.kit.edit;
					}),
					StaticText.new.string_("kit: %".format(self.kit.key)),
				),
				Param(self.gridPattern, \stretch, \dur).asView,
				HLayout (
					Param(Message(self), \defaultSeqSize, ControlSpec(0,256,\lin,1,8)).asStaticTextLabel,
					Param(Message(self), \defaultSeqSize, ControlSpec(0,256,\lin,1,8)).asTextField,
				),
				nil
			)
			
		}).front;
	},
));

TrackTemplateDef(\KitSeqSection, (
	///// section for KitSeqGrid and also children of KitSeqGridTrack

	parent: TrackTemplateDef(\TrackListSection),

	//outBus_: { arg self;
		
	//},
	//outBus: { arg self;
		//0
	//},

	asPreview: { arg self;
		var view;
		var areasize;
		"pourquoi---------".debug;
		view = WindowDef(\KitSequencerPreview).asView(self);
		areasize = view.proto.areasize;
		// Problem: areasizex is in parent grid
		areasize.x = self.parentTrack.areasizex ?? { areasize.x };
		view.proto.areasize = areasize;
		view;

		//View.new.layout_(
			//VLayout (*
				//self.existingChildren.keep(4).collect { arg child, idx;
					//child.asPreview;
				//};

			//)
		//)
		
	},

	stepDur_: { arg self, val;
		self[\stepDur] = val;
		self.existingChildren.do { arg item, idx;
			item.stepDurParam.set(val)
		};
	},
	stepDur: 1/8,

	edit: { arg self;
		//WindowDef(\win, { arg def;
			//View.new.layout_(
				//VLayout (*
					//self.existingChildren.collect { arg child, idx;
						//child.asPreview;
					//};

				//)
			//)
		//}).front;
		//self.parentTrack.selectedPart = self.index;
		//self.parentTrack.edit;
		//WindowDef(\KitSequencer).front(self.parentTrack, self.index)
		
	},

	makeScore: { arg self;
		"hello i make score3!".postln;
		self.parentTrack.existingChildren.do { arg child, idx;
			self.childAt(child.index).makeScore;
		};
		
	},
));

TrackTemplateDef(\KitSeqTrack, (
	parent: TrackTemplateDef(\CustomTrack),
	childClass: { TrackTemplateDef(\KitSeqTrackPart) },
	outBus: { arg self;
		if(self.isEmpty.not) {
			Param(self.kitItemTarget, \out).get.debug("get")
		}
	},
	outBus_: { arg self, val;
		if(self.isEmpty.not) {
			Param(self.kitItemTarget, \out).setBus(val.debug("set"))
		}
	},
	isEmpty: { arg self;
		if(self.parentTrack.kit.notNil and: { self.parentTrack.kit.childAt(self.index).isEmpty.not }) {
			false
		} {
			true
		};
	},

	editInstrument: { arg self;
		WindowDef(\sampler).front(self.parentTrack.kit.childAt(self.index).target)
		
	},


	kitItemPattern: { arg self;
		if(self.parentTrack.kit.notNil) {
			self.parentTrack.kit.getPattern(self.index)
		};
	},

	kitItemTarget: { arg self;
		if(self.parentTrack.kit.notNil) {
			self.parentTrack.kit.childAt(self.index).targetData
		};
	},
	kitItem: { arg self;
		if(self.parentTrack.kit.notNil) {
			self.parentTrack.kit.childAt(self.index)
		}
	},
	kitItemProxy: { arg self;
		self.kitItemTarget;
	},

));
TrackTemplateDef(\KitSeqTrackPart, (
	parent: TrackTemplateDef(\CustomTrackPart),
	outBus: { arg self;
		if(self.isEmpty.not) {
			self.score.source.at(\out).source;
		} ??  { self.parentTrack.outBus };
	},
	outBus_: { arg self, val;
		[self.score, val].debug("setting outBus");
		if(self.isEmpty.not) {
			self.score.source.at(\out).source = val;
			//Pbindef(self.score.key, \out, val)
		}
	},
	asPreview: { arg self;
		WindowDef(\KitSeqTrackPart_preview).asView(self.score, self.previewSlots, self.parentTrack.parentTrack.defaultSeqSize).mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
			if(buttonNumber == 1) {
				self.edit;
				
			};
		});
	},
	gridPattern: { arg self;
		self.parentTrack.parentTrack.gridPattern ?? { Pbind() }
	},
	makeScore: { arg self;
		self.score = Pbindef(self.trackKey+++\score, \dur, 1/8);
		self.score.addHalo(\instrument, self.parentTrack.kitItem.instrument);
		self.source = Pdef(self.trackKey+++\pat, self.gridPattern <> Pbind(\isRest, Pkey(\kitseq).coin.not) <> self.score <> self.parentTrack.kitItemPattern);
	},

	stepDurParam: { arg self;
		Param(Pbindef(self.trackKey+++\score), \dur);
	},

	edit: { arg self;
		WindowDef(( self.trackKey++\_editor ).asSymbol, { arg def;
			var seq;
			var refresh;
			var pgview = View.new;
			var pbindefEditorView;
			seq = WindowDef(\stepseq_butlist).asView(self.score, \kitseq);
			refresh = {
				pgview.removeAll;
				//pgview.layout = self.score.asParamGroup.select({ arg p; p.isSet }).asView;
				pbindefEditorView = WindowDef(\PbindefEditorParams).asView(self.score);
				pbindefEditorView.proto.showOnlySetParams = true;
				pbindefEditorView.proto.showSynthDefParams = true;
				pgview.layout = VLayout(pbindefEditorView);
			};
			refresh.();

			VLayout (
				HLayout (
					StaticText.new.string_("size"),
					Param(Message(seq), \listSize, ControlSpec(0,256,\lin,1,0)).asTextField,
					BasicButton.new.string_("Add param").action_({
						Menu(*
							self.score.asParamGroup.reject({ arg p; p.isSet }).collect { arg param, idx;
								MenuAction(param.label, { 
									var val, proxy = self.parentTrack.kitItemTarget;
									val = Param(proxy, param.property).get;
									self.score.set( param.property, val);
									refresh.();
								});
							}
						).front
					}),
					BasicButton.new.string_("Edit preview").action_({
						WindowDef(\win, { arg def;
							var tagspec;
							if(self.previewSlots.isNil) {
								self.previewSlots = List.newFrom([\kitseq, nil, nil, nil]);
							};
							tagspec =  TagSpec([\nil, \kitseq, \speed, \lpf, \pan, \amp, \gain]);
							VLayout (*
								self.previewSlots.collect { arg item, idx;
									Param(self.previewSlots, idx, tagspec).asPopUpMenu
								}
							)
							
						}).front;
					}),
					BasicButton.new.string_("...").action_({
						pbindefEditorView.showGeneralOverlayMenu();
					}),
				),
				seq,
				pgview,
			)
		}).front;
	},
	
));

//// GUI

WindowDef(\KitSeqTrackPart_preview, { arg def, pdef, prop, defaultSize;
	var defaultVal = 0;
	defaultSize = defaultSize ? 8;
	prop = prop ? \kitseq;
	if(prop.isKindOf(SequenceableCollection)) {
		View.new.layout_(VLayout (*
			prop.select(_.notNil).collect { arg propitem, idx;
				if(propitem.notNil) {
					// TODO: check param type and use PbindefEditor GUI for preview except stepseq
					//WindowDef(\stepseq_butlist).asView(pdef, propitem, defaultSize);

					WindowDef(\PbindefEditorParamView).asView(Param(pdef, propitem)).children[1].minHeight_(10);
				} {
					//StaticText.new.string_("nil")
					nil

				}
			}
		).margins_(0).spacing_(0))
	} {
		//WindowDef(\stepseq_butlist).asView(pdef, prop, defaultSize);
		if(prop == \kitseq and: {pdef.source.at(prop).source.isKindOf(PstepSeq).not}) {
			// NOTE: use List instead of Array because Array not implemented in Param
			Pbindef(pdef.key, prop, PstepSeq(List.newFrom(defaultVal!defaultSize),inf));
		};
		WindowDef(\PbindefEditorParamView).asView(Param(pdef, prop));
	};
});

WindowDef(\stepseq_butlist, { arg def, pdef, prop, defaultSize;
	var defaultVal = 0;
	var spec = ControlSpec(0,1,\lin,1,0);
	var view = View.new;
	var param;
	var refresh;
	defaultSize = defaultSize ? 8;
	prop = prop ? \kitseq;
	param = Param( pdef, prop -> \stepseq, spec);
	pdef.convertToPbindef;
	if(pdef.source.at(prop).source.isKindOf(PstepSeq).not) {
		// NOTE: use List instead of Array because Array not implemented in Param
		Pbindef(pdef.key, prop, PstepSeq(List.newFrom(defaultVal!defaultSize),inf));
	};
	refresh = {
		view.removeAll;
		view.layout_(HLayout(*
			param.collect { arg subp, idx;
				subp.asButton(" ").minWidth_(10).maxHeight_(100);
			};
		).margins_(0));
	};
	view.followChange(param.target, \listSize, {
		refresh.()
	});
	view.addUniqueMethod(\listSize_, { arg me, val;
		[me,val].debug("listSize_");
		param.set(param.get.wrapExtend(val));
		param.target.changed(\listSize);
	});
	view.addUniqueMethod(\listSize, { arg me;
		param.get.debug("listSize");
		param.get.size;
	});
	//refresh.();
	view;
});

//// Debug

TrackDef(\KitSeqGrid, TrackTemplateDef(\KitSeqGrid));
FileSystemProject.loadOnce("capsule/PatKitDef_comkit.scd");
TrackDef(\KitSeqGrid).kit = PatKitDef(\comkit);
Spec.add(\kitseq, \unipolar);
)

// END
{ SinOsc.ar(500) ! 2 * 0.1}.play;

TrackDef(\KitSeqGrid).edit
TrackDef(\KitSeqGrid)[\edit].asCompileString
TrackDef(\KitSeqGrid).existingChildren.size
TrackDef(\KitSeqGrid).kit.getPattern(0)
TrackDef(\KitSeqGrid).childAt(0).kitItemTarget

Pbindef(\bla, \out, nil).play
PatKitDef(\comkit).edit

TrackDef(\KitSeqGrid).kit = PatKitDef(\kitrand2);
TrackDef(\KitSeqGrid).kit = PatKitDef(\comkit);
PlayerWrapper(TrackDef(\KitSeqGrid).kit.childAt(0).target).outBus
PlayerWrapper(TrackDef(\KitSeqGrid).kit.childAt(0).target).wrapper
TrackDef(\KitSeqGrid).kit.childAt(0).proxy
StepEvent
TrackDef(\KitSeqGrid).childAt(5).kitItemTarget.instrument
TrackDef(\KitSeqGrid).childAt(0).kitItemTarget[\pan]
TrackDef(\KitSeqGrid).childAt(12,0).score.envir
TrackDef(\KitSeqGrid).childAt(0,0).score
TrackDef(\KitSeqGrid).childAt(0,1).outBus = nil
TrackDef(\KitSeqGrid).childAt(0,1).play
TrackDef(\KitSeqGrid).childAt(0,12).outBus
TrackDef(\KitSeqGrid).childAt(0,1).score.play
TrackDef(\KitSeqGrid).childAt(0,1).makeScore
TrackDef(\KitSeqGrid).childAt(0,0).score.play
Pbindef(TrackDef(\KitSeqGrid).childAt(0,1).score.key, \out, nil)
Pbindef(TrackDef(\KitSeqGrid).childAt(0,0).score.key).source.at(\out).source


TrackDef(\myc, TrackTemplateDef(\CustomTrackList)).edit

~t = 185/4/60; TempoClock.default.tempo = ~t;

~p = Param(Pdef)
Param(TrackDef(\myc2).childAt(0,0).childAt(0).score, \kitseq -> \stepseq).get.size
PatKitDef(\comkit).edit
Param.trace=true
TrackDef(\myc2).isPlaying
TrackDef(\myc2)[\isPlaying].asCompileString
TrackDef(\myc2).children[0].isPlaying
TrackDef(\myc2).children[0][\isPlaying].asCompileString
TrackDef(\myc2).children[0].activeChild
TrackDef(\myc2, TrackTemplateDef(\CustomTrackList)).childAt(0,0).edit
TrackDef(\myc).childAt(0).trackTemplate = TrackTemplateDef(\KitSeqGridTrack)
TrackDef(\myc).childAt(0).grid = TrackDef(\KitSeqGrid)
TrackDef(\myc).childAt(0).grid.kit
TrackDef(\myc).childAt(0,0)[\outBus].asCompileString
TrackDef(\myc).childAt(0).grid.linePlayerAt(0)
TrackDef(\myc).childAt(0).grid.lineClass.parent.value
TrackDef(\myc).childAt(0,0)[\isEmpty].asCompileString
TrackDef(\myc).childAt(0,0).existingChildren
TrackDef(\myc).childAt(0).grid.kit
TrackDef(\myc).childAt(0).grid = nil
TrackDef(\myc).childAt(0).grid.existingChildren
TrackDef(\myc).childAt(0).grid.childAt(0,0).isEmpty
TrackDef(\myc).childAt(0).grid.linePlayerAt(0).childAt(0)

TrackDef(\KitSeqGrid).edit
TrackDef(\KitSeqGrid).clear
TrackDef(\KitSeqGrid).children
TrackDef(\KitSeqGrid).existingChildren
TrackDef(\KitSeqGrid).childAt(0,0).isEmpty
TrackDef(\KitSeqGrid).childAt(0).kitItemPattern
TrackDef(\KitSeqGrid).childAt(0,0).proxy.play
TrackDef(\KitSeqGrid).childAt(0,0)[\play].asCompileString
TrackDef(\KitSeqGrid).childAt(0,0).parentTrack.kitItemPattern
TrackDef(\KitSeqGrid).childAt(0,0).score.source.at(\kitseq).source.list
TrackDef(\KitSeqGrid).kit.childAt(0).target.asPattern



(
FileSystemProject.loadOnce("sndlib/buflib.scd");
~drums = [
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
	Pbind(
		\instrument, \playersec,
		\bufnum, ~buflib.snare[1719].value,
		\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
		\isRest, Pseq([
			0,0,0,0, 1,0,0,0,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.11,
	),
	Pbind(
		\instrument, \playersec,
		\bufnum, ~buflib.hat[1064].value,
		\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
		\isRest, Pseq([
			1,0,1,0, 1,0,1,0,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.11,
	),
];
PatKitDef(\kitrand2, ~drums)
)

////////////


(
Pbindef(\xxx, 
	\instrument, \saw,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1,
).play;
);
Pbindef(\xxx).edit
Pbindef('NoteTimelineTrack.0.instr').source = Pbindef(\xxx).source
Pbindef(\xxx).presetCompileString.editorInsert
PlayerWrapper(Pbindef(\xxx)).presetCompileString
Pbindef('xxx',
	'instrument', 'saw',
	'amp', 0.1,
	'out', TrackMixerDef('Pbindef_xxx'),
	'lpfr', ParamCombinator.new,
	'rq', 0.2726618705036,
	'octave', 4.0,
	'dur', Prout({ arg ev;
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
			}),
	'ctranspose', 0.0,
);

MenuAction

~m = Menu()
~m.

/////////////////////////// Knob param group

(
Pdef(\testme, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

Param(Pdef(\testme), \lpfr).
Pdef(\testme).asParamGroup.select({ arg p; p.type == \scalar })

//FileSystemProject.load("libde")
ParamProto.init;
(
WindowDef(\knoblayout, { arg def, pg;
	var font;
	var view = View.new(nil, 500@700);
	//def.windowDo { arg win;
		//win.view.decorator = FlowLayout();
	//};
	font = Font.default.copy.size_(8);
	view.addFlowLayout;
	//Button.new(view);
	//Knob.new(view, 10@10);
	pg.selectByType(\scalar).do { arg param, idx;
		View.new(view, 80@100).layout_(VLayout (
			ParamViewToolBox.attachContextMenu(param, param.asStaticTextLabel.align_(\center)),
			param.asKnob,
			//Knob.new(view, 30@30).mapParam(param),
			param.asTextField.font_(font),
		))
	};
	view;
	
}).front(Pdef(\testme).asParamGroup);
)

//////////// test list param

~list = List.newFrom(nil!4);
(
// scalar ok (but error with nil)
WindowDef(\win, { arg def;
	Param(~list, \list, \pan).asView
	
}).front;
)
(
WindowDef(\win, { arg def;
	var tagspec = TagSpec([\bla, \bli, \blo]);
	var param;
	param = Param(~list, 0, tagspec);
	[param.property, param.wrapper, param.spec].debug("param");
	param.asPopUpMenu;
	
}).front;
)


(bla:3).putAll(( bla:4 ))
