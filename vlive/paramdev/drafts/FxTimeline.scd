(

//////// FxTimeline

ParamProto.init;
FileSystemProject.loadOnce("paramdev/drafts/ModulatorStrip.scd");
FileSystemProject.loadOnce("paramdev/drafts/FxRack.scd");

ProtoClassDef(\FxTimeline, ProtoClass(( // can't use ProtoTemplateDef, clash with key and prAdd
	parent: ProtoClassDef(\ClipTimeline),
	all: { PresetDictionary.new(\fxTimeline) },
	eventType: \fxTimeline,

	new: { arg self, name;
		//"so many strange".debug;

		if(self.all[name].notNil) {
			self = self.all[name]
		} {
			self = ProtoClass((parent: ProtoClassDef(\FxTimeline)));
			self.addInstance(name).init;
		};
	
		self;
	},

	refCompileString: { arg self, name;
		if(name.isNil) {
			name = self.key.asCompileString
		};
		"ProtoInst(\\FxTimeline, %)".format(name)
	},


	addInstance: { arg self, key;
		self.key = key;
		self.all[key] = self;
		self;
	},

	edit: { arg self;
		var x = ProtoTemplateDef(\FxTimelinePanelView).new(self);
		self.editor = { x };
		x;
	},

	tracks: { arg self;
		self.fxRack.fxList;
	},

	init: { arg self;
		var fxstack = [
			\ifx_stutter,
			\ifx_chorus,
			\ifx_greyhole,
			\ifx_freeverb2,
			\ifx_limiter,
			\ifx_rlpf,
		];
		self.basicInit;
		self.areasize = Point(10, fxstack.size);

		self.fxRack = ProtoDef("%_fxRack".format(self.key).asSymbol, \InsertFxRack);
		self.fxRack.synthDefNameStack = fxstack;
		self.fxRack.fxList.do { arg fx, idx;
			fx.proxy.set(\wet, 1);
		};
		//self.eventFactory = ~class_player_event_factory.new;
		//self.eventFactory.eventLoop = self.eventloop;
		//self.eventFactory.mode = \note;
		//self.eventFactory.playmode = \gate;
		//self.eventFactory.fullrecord = false;

		self.tracks_bypassed = Set.new;
		self.recorder = ProtoTemplateDef(\SampleClipTimelineMultiTrackRecorder).new(self) !? { arg x; {x} };

		//self.clipList = ProtoClassDef(\ClipTimelineClipList).new(self) !? { arg x; {x} };
		//"=============clipTimeline: end init".debug;

		TagSpecDef('FxTimeline').addUnique(self.key -> self);
		self;
	},

	cellWidth: 1/8,

	cutPatternFunction: { arg self, parentEvent;
		// this function should be overwritten by subclasses to provide a cutting function to their pattern
		// all other patterns methods will depend on it
		{ arg sloop, offset, dur;
			var pat;
			var kitpat;

			kitpat = Pbind(
				\type, Pfunc({ arg ev;
					ev[\type].debug("----------type");
					if(ev[\type].isNil or: { ev[\type] == \note }) {
						\pattern
					} {
						ev[\type]
					};
			   	}),
				\pattern, Prout({ arg ev;
					loop {
						var fxidx;
						if(ev.isRest.not) {
							var pat;
							var modpat;
							fxidx = ev.use { ~midinote.value };
							fxidx.debug("fxidx");
							pat = self.fxRack.childAt(fxidx).asPattern;
							//modpat = self.modulatorStripView.proto.eventModel.asPattern(ev);
							modpat = ProtoTemplateDef(\ModulatorStripEventModel).asPattern(ev);
							if(modpat.notNil) {
								pat = modpat <> pat;
							};


							//if(ev[\localValues].notNil) {
								//ev.localValues.keys.do { arg key, idx;
									//if(ev.modulatorType.notNil and: { ev.modulatorType[key].notNil }) {
										//modtype = ev.modulatorType[key];
									//};
									//modtype = modtype ? \raw;
									//if(modtype == \raw) {
										//modev[key] = ev.localValues[key];
									//} {
										//if(modtype == \step) {
											//if(ev[\localSeq].notNil and: { ev[\localSeq][key].notNil }) {
												//modev[key] = PstepSeq(ev[\localSeq][key]);
											//} {
												//modev[key] = ev.localValues[key];
											//};
										//};
									//};
								//};
								//pat = Pbind(
									//* modev.keys.asArray.collect { arg key, idx;
										//[key, modev[key]]
									//}.flatten ++ [\dur, self.cellWidth];
								//) <> pat;
							//};



							//if(ev[\localValues].notNil) {
								//pat = Pn(ev[\localValues],inf) <> pat;
							//};
							//if(ev[\localSeq].notNil) {
								//pat = Pbind(
									//* ev[\localSeq].keys.asArray.collect { arg key, idx;
										//[key, PstepSeq(ev[\localSeq][key])]
									//}.flatten ++ [\dur, self.cellWidth];
								//) <> pat;
							//};
							ev = pat.yield;
						};
					}
				}),
			).trace;

			pat = sloop.cutPattern(
				//self.bypass_pattern( Pn(self.eventList.clone, 1) ), // bypassing in upstream is cpu friendlier but prevent unmuting while already in pattern
				kitpat <> Pn(self.eventList.clone, 1),
				offset,
				dur
			);
			pat = Ppar([
				pat, 
				Pfindur(dur, self.fxRack.monitorProxy),
				Pfindur(dur, self.fxRack.inputProxy), // don't know why should be after monitorProxy
			]);

			self.fxRack.inputProxy.debug("houou");
			pat.embedInStream;

		}
	},

	//track_count: { arg self;
		//self.fxRack.fxList.size;
	//},

	moveNodeTo: { arg self, fromidx, toidx;
		var map;
		if(fromidx != toidx) {
			self.fxRack.moveNodeTo(fromidx, toidx);
			map = self.generateMoveMap(fromidx, toidx);
			[fromidx, toidx].debug("idx move");
			map.debug("MAP");
			self.eventList.do { arg ev, idx;
				if(ev[\type].isNil) {
					ev[\midinote] = map[ev[\midinote]];
				};
			};
			self.eventList.changed(\refresh);
			self.changed(\tracks);
		};
	},

	generateMoveMap: { arg self, fromidx, toidx;
		var size = self.tracks.size;
		var direction, comp, compinv;
		// algo: 
		// - exterior to [fromidx, toidx] range are invarient
		// - all notes must be shifted inside the range by 1 or -1 depending the direction of move
		// - fromidx should be mapped to toidx
		if(fromidx == toidx) {
			// NOOP
		} {
			if(fromidx > toidx) { 
				direction = 1; 
				comp = { arg a, b; a < b; };
				compinv = { arg a, b; a > b; };
			} { 
				direction = -1; 
				comp = { arg a, b; a > b; };
				compinv = { arg a, b; a < b; };
			};

			size.collect { arg idx;
				if(compinv.(idx, fromidx) or: { comp.(idx, toidx) }) {
					idx
				} {
					if(idx == fromidx) {
						toidx;
					} {
						//if(comp.(idx, fromidx)) {
							idx + direction;
						//};
					};
				};

			};

		};
	},

	moveEventTo: { arg self, ev, fromidx, toidx, key=\midinote;
		var fx;
		var nextfx;
		//if(fromidx == ( toidx - 1 )) { // trick to allow inserting in last place
		//var tmp = fromidx;
		//fromidx = toidx;
		//toidx = tmp;
		//};
		if(fromidx > toidx) {

			fx = self.fxList[fromidx];
			nextfx = self.fxList[toidx];

			self.fxList[fromidx] = nil;
			self.fxList = self.fxList.insert(toidx, fx).select(_.notNil);
			GroupDef(fx.groupDefName).moveBefore(GroupDef(nextfx.groupDefName));
			ev[key] = k
		} {
			if(toidx == ( self.fxList.size-1 )) {
				var prevfx;

				fx = self.fxList.removeAt(fromidx);
				prevfx = self.fxList[toidx-1];

				self.fxList = self.fxList.add(fx);
				GroupDef(fx.groupDefName).moveAfter(GroupDef(prevfx.groupDefName));
			} {
				fx = self.fxList.removeAt(fromidx);
				nextfx = self.fxList[toidx];

				self.fxList = self.fxList.insert(toidx, fx).select(_.notNil);
				GroupDef(fx.groupDefName).moveBefore(GroupDef(nextfx.groupDefName));
			};
		};
		self.changed(\fxList);
	},

	add_track: { arg self, fx;
		
		self.fxRack.addFx(fx);
		self.fxRack.fxList.last.proxy.set(\wet, 1);
		self.editor.areasize = Point(self.editor.areasize.x, self.tracks.size ); // track_count is self.tracks.size
		self.changed(\tracks);
	},

	savePreset: { arg self, key;
		self.presetBank.savePreset(key);
	},

	loadPreset: { arg self, key;
		self.presetBank.loadPreset(key);
	},

	presetBank: { arg self;
		if(self[\presetBank_obj].isNil) {
			self[\presetBank_obj] = ProtoTemplateDef(\PresetGraphBank).new((
				main: ParamGroup([
					Param(Message(self), \eventListClone),
				].flat),
				items: {
					[
						self.fxRack.presetBank.groupDict
					]
				}
			), {
				"loadPresetHook called!!".debug;
				self.changed(\fxList);
				self.eventList.changed(\refresh);
				self.changed(\tracks);
			})
		};
		self[\presetBank_obj];
	},

)));


//// GUI


ProtoTemplateDef(\FxTimelinePanelView, (
	parent: ProtoTemplateDef(\ClipTimelinePanelView),

	//// properties

	colors: (
		selected: ParamViewToolBox.color_ligth,
		semiselected: ParamViewToolBox.color_ligth.complementary,
		deselected: Color.gray(0.7),
		
	),

	trackHeaderWidth: 200,

	selectedFx: { arg self;
		self.timeline_model.tracks.first;
	},

	selectedFxIndex: { arg self;
		self.trackSelector.selectedIndex;
	},

	selectedModulatorType_: { arg self, val;
		self[\selectedModulatorType] = val;
		self.changed(\selectedModulatorType);
		self.modulatorStripView.proto.selectedModulatorTypeAction(self.selectedEvent); // ugly
		self.modulatorStripView.refresh;
		self.updateBottomPanelHeaderView;
	},

	selectedParam_: { arg self, param;
		self[\selectedParam] = param;
		self.selectedFx.selectedParam = param;
		self.changed(\selectedParam);
	},

	//selectedParam: { arg self;
		//self.selectedFx.asParamGroup.rejectByProperty([ \adsr, \dur, \legato, \out ]).first;
	//},

	isBottomPanelVisible_: { arg self, val;
		if(val == true) {
			self.bottomPanelView.visible = true;
			self.bottomPanelVerticalScroller.visible = true;
			self.bottomPanelHeaderView.visible = true;
		} {
			self.bottomPanelView.visible = false;
			self.bottomPanelVerticalScroller.visible = false;
			self.bottomPanelHeaderView.visible = false;
		};
	},

	selectedEvent: { arg self;
		var ar = self.timeline.selectedNodes.asArray;
		if(ar.size > 0) { ar.first.model } { nil };
	},

	eventModel: { arg self;
		self.modulatorStripView.proto.eventModel;
	},

	//// commands

	add_track: { arg self, fx;
		self.timeline_model.add_track(fx);
		self.timeline.refreshEventList;
		self.timeline.refresh;
		self.update_track_header;
	},

	//// make views


	makeFxEditorView: { arg self;
		self.fxEditorView = View.new;
		self.fxEditorView.followChange(self, \selectedFx, {
			self.updateFxEditorView;
		}, false);
		//self.fxEditorView.followChange(self.timeline, \selectedNodes, {
			////self.selectedNodesAction;
			//self.changed(\selectedParam);
			////self.updateBottomPanelHeaderView;
		//}, false);
		self.fxEditorView.followChange(self, \selectedParam, {
			debug("selectedParam handler");
			self.updateBottomPanelHeaderView;

		}, false);
	},

	makeBottomPanelView: { arg self;
		self.bottomPanelView = View.new;
		//self.bottomPanelView.fixedHeight_(100);
		self.makeFxParamView;
		self.bottomPanelHeaderView = View.new;
		self.bottomPanelHeaderView.fixedSize_(self.trackHeaderWidth@100);
		self.bottomPanelVerticalScroller = TimelineScroller.new;
		self.bottomPanelVerticalScroller.fixedHeight_(100);
		self.bottomPanelVerticalScroller.orientation = \vertical;
		self.makeBottomPanelToolbar;
		self.isBottomPanelVisible = true;
	},

	makeBottomPanelToolbar: { arg self;
		self.bottomPanelToolbar = View.new;
		self.bottomPanelShowButton = BasicButton.new.string_(">")
			.fixedWidth_(20)
			.action_({ arg me;
				if(self.isBottomPanelVisible) {
					me.string = ">";
					self.isBottomPanelVisible = false;
				} {
					me.string = "^";
					self.isBottomPanelVisible = true;
				}
			})
		;
		self.makeFxEditorView;
		self.bottomPanelToolbar.layout = VLayout (
			self.fxEditorView,
			HLayout (
				self.bottomPanelShowButton,
				WindowDef(\PresetSelectorView).asView(self.timeline_model.presetBank),
			),
			//self.automationPopup,
			//self.velocityButton,
			//self.automationButton,
			//self.bottomPanelDescription,
			//self.bottomPanelValueText,
		).margins_(0);
	},


	makeLayout: { arg self;
		var clipEditor;
		//"clipTimelinePanelView.makeLayout: start init".debug;

		self[\makeVelocityView] = {}; // disable velocity view
		self.layout = VLayout(
			HLayout (
				*[
					//self.makeLeftPaneLayout,
					VLayout (
						[ProtoTemplateDef(\TimelinePanelView)[\makeLayout].(self), stretch:1],
					),
					//self.makeRightPaneLayout,
				].select(_.notNil)
			),
		);
		//"clipTimelinePanelView.makeLayout: part 2".debug;
		self.timeline.followChange(self.timeline_model, \eventFactory, {
			Log(\Param).debug("eventFactory change!!!!");
			self.timeline.eventFactory = self.timeline_model.eventFactory;
		});
		self.timeline.mouseDownAction = { arg me, px, py, mod, buttonNumber, clickCount, chosennode;
			if(clickCount == 2) {
				if(chosennode.notNil) {
					self.showClipEditor(chosennode.model);
				}
			} {
				if(buttonNumber == 1 and: { mod.isCtrl.not }) {
					self.showTimelineContextMenu(chosennode);
				} {
					var idx = self.timeline.pixelPointToGridPoint(Point(px,py)).y.asInteger;
					self.selectedEvent = chosennode !? { chosennode.model };
					self.trackSelector.selectIndex(idx);
				};
			}
		};
		self.timeline.mouseUpAction = { arg ...args;
			args.debug("mouseUpAction");
			//self.changed(\selectedParam);
		};
		self.timeline.createNodeHook = { arg newevent;
			//self.selectedEvent = newevent;
			self.selectedEvent.debug("createNodeHook");
			self.changed(\selectedParam);
		};
		//"clipTimelinePanelView.makeLayout: part 3".debug;
		self.timeline.view.followChange(self.eventloop, \list, { 
			{
				self.refresh;
			}.defer
		});
		//"clipTimelinePanelView.makeLayout: end init".debug;
		self.timeline.keyDownAction = self.getTimelineKeyDownAction;
		self.timeline.deleteSelectedNodesHook = self.deleteSelectedNodesHook;

		self.layout;
	},

	makeFxParamView: { arg self;
		var strip, stripview;
		strip = ProtoTemplateDef(\ModulatorStrip).new(self);
		stripview = strip.asView;
		
		//self.bottomPanelView.layout = self.selectedFx.asParamGroup.asView;
		self.modulatorStrip = strip;
		self.modulatorStripView = stripview;
		self.bottomPanelView.layout = VLayout(stripview).margins_([0,0,0,0]).spacing_(0)
	},

	make_header: { arg self;
		self.header_layout = HLayout(
			PlayerWrapperView(self.timeline_model).view,
			self.make_stop_button,
			BasicButton.new.label_("Debug").action_({
				self.timeline_model.changed(\tracks);
			}),
			PlayerWrapper(Pdef(\part)).asView,
			BasicButton.new.label_("Add track").action_({
				WindowDef(\ListSelectDialog).front(TagSpecDef(\SynthDef_InsertFx).list, { arg name, asso;
					self.add_track(asso.value);
				});
			}),
			self.make_quant_popup,
			self.make_undo_system_buttons,

			Param(Message(self.timeline_model.fxRack), \inBus, TagSpecDef(\BusDef)).asPopUpMenu,
			Param(Message(self.timeline_model.fxRack), \outBus, TagSpecDef(\BusDef)).asPopUpMenu,
			RecordButton(self.timeline_model, \recorder, "Rec"),
			BasicButton.new.string_("...").mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
				//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
				WindowDef(\ClipTimelineContextMenu).sourceValue(self, view, x, y).front
			}).maxWidth_(20),
		);
		
		self.header_layout;
	},

	//make_track_header: { arg self;
		//// should return the track header view
		//var track_header;
		//track_header = ScrollView.new;
		//track_header.keyDownAction = self.getTimelineKeyDownAction;
		//track_header.hasBorder = false;
		//track_header.hasVerticalScroller = false;
		//track_header.hasHorizontalScroller = false;
		//self.track_header = track_header;

		//self.verticalScroller_track_header_action = { arg self, slider;
			//if(slider.isNil) {
				////Log(\Param).debug("dont know why there is two actions with one nil: % %", self.key, self.verticalScroller.view.action.array);
			//} {

				//self.track_header_view.fixedHeight = 1/slider.range * track_header.bounds.height;
				////( 1/slider.range * track_header.bounds.height ).debug("vrange.view.action: fixedHeight");
				//track_header.visibleOrigin = Point(0, ( 1-slider.hi ) / slider.range) * track_header.bounds.height;
				////( Point(0, ( 1-slider.hi ) / slider.range) * track_header.bounds.height ).debug("vrange.view.action: visibleOrigin");
			//};
		//};

		//self.verticalScroller.view.addAction({ arg slider;
			//self.verticalScroller_track_header_action.(slider)
		//});

		//self.make_tracks_listeners;
		//self.update_track_header;

		////self.verticalScroller.view.activeLo = self.verticalScroller.view.lo; // trigger action

		//self.track_header;
	//},

	make_tracks_listeners: { arg self;
		if(self.tracks_controller.notNil) {
			self.tracks_controller.remove;
		};
		self.tracks_controller = SimpleController(self.timeline_model)
		.put(\tracks, {
			"update_track_header_size: areasize".debug;
			if(self.track_header.isNil or: {self.track_header.isClosed}) {
				self.tracks_controller.remove;
			} {
				debug("update 2");
				self.update_track_header;
				self.areasize = Point(self.areasize.x, self.timeline_model.track_count);
			}
			//self.update_track_header;
		})
		;

		self.timeline_model.changed(\tracks); // init areasize from track count
	},

	//// actions

	selectTrackAction: { arg self;
		var color_selected = self.colors.selected;
		var color_semiselected = self.colors.semiselected;
		var color_deselected = self.colors.deselected;
		{ arg subself, idx;
			var view;
			var ridx = self.timeline_model.tracks.size - 1 - idx;
			var pg;
			var key;
			debug("----#### selectTrackAction start");
			view = subself.views[ridx]; // view are reversed
			// views are reversed but view 0 at bottom still mean fx 0
			self.selectedFx = self.timeline_model.tracks[idx]; 

			pg = self.selectedFx.asParamGroup.rejectByProperty([\out, \adsr, \legato, \dur]);
			if(self.selectedEvent.notNil) {
				debug("**selectedEvent mode");
				if(self.selectedEvent.localValues.isNil) {
					self.selectedEvent.localValues = ();
					self.selectedEvent.localMod = ();
				};
				// change param to main (track) or event depending on selection
				// selectedTrackParam is always the main one
				self.selectedFxParamGroup = ParamGroup(pg.collect { arg param, idx;
					Param(self.selectedEvent.localValues, param.property, param.spec).default_(param.get)
				});
			} {
				debug("**NOselect mode");
				self.selectedFxParamGroup = pg; 
			};

			// call updateFxEditorView
			// should be before changing selectedParam so knobs can already receive the msg
			self.changed(\selectedFx); 

			if(self.selectedFx.selectedParam.notNil) {
				// self.selectedParam_ send changed message so should be after selectedTrackParam_
				self.selectedTrackParam = Param(self.selectedFx.proxy, self.selectedFx.selectedParam.propertyRoot);
				// this call updateBottomPanelHeaderView
				self.selectedParam = self.selectedFxParamGroup
					.asPropertyDict[self.selectedFx.selectedParam.propertyRoot];
			} {
				self.selectedTrackParam = pg.first;
				// this call updateBottomPanelHeaderView
				self.selectedParam = self.selectedFxParamGroup.first;
			};

			if(self.selectedEvent.notNil) {
				key = self.selectedParam.propertyRoot;
				self.selectedModulatorType = self.eventModel.getModulatorType(self.selectedEvent, key);
			};

			if(self.selectedParam == self.selectedTrackParam) {
				view.background_(color_semiselected);
			} {
				view.background_(color_selected);
			};
			//debug("selectTrackAction send changed");
			//debug("selectTrackAction finish");
		};
	},

	deselectTrackAction: { arg self;
		var color_selected = self.colors.selected;
		var color_deselected = self.colors.deselected;
		{ arg subself, idx;
			var view;
			var ridx = self.timeline_model.tracks.size - 1 - idx;
			[view, idx, ridx].debug("delesect");
			view = subself.views[ridx];
			view.background_(color_deselected);
		};
	},

	selectedNodesAction: { arg self; // deprecated by selectedEvent
		var note;
		debug("----- selectedNodesAction start");
		self.timeline.selectedNodes.debug("selectedNodes");
		if(self.timeline.selectedNodes.size > 0) {
			var trackidx;
			var key = self.selectedParam.propertyRoot;
			note = self.timeline.selectedNodes.asArray.first.model;
			note.midinote.debug("selectedNodes midinote");
			trackidx = note.midinote;
			self.selectedFx = self.timeline_model.tracks[trackidx];
			if(note[\localValues].isNil) {
				note[\localValues] = ();
			};
			self.selectedEvent = note;
			self.selectedModulatorType = self.eventModel.getModulatorType(self.selectedEvent, key);
		} {
			self.selectedEvent = nil;
			//if(self.trackSelector.notNil) {
				//self.trackSelector.selectedIndex.debug("selectedNodes follower");
				//self.trackSelector.selectIndex(self.trackSelector.selectedIndex);
			//};
			nil
		};
	},


	//// update

	updateFxEditorView: { arg self;
		self.fxEditorView.removeAll;
		self.selectedFxParamGroup.debug("--- updateFxEditorView: start");
		self.fxEditorView.layout = HLayout (
			* self.selectedFxParamGroup.asArray.collect { arg param, idx;
				var knob = param.asKnob;
				var labelview = param.asStaticTextLabel.align_(\center).attachContextMenu;
				var mouseDownAction;
				mouseDownAction = { arg view, x, y, modifiers, buttonNumber, clickCount;
					[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
					self.selectedParam = param;
					//false;
					true;
				};
				//knob.mouseDownAction = knob.mouseDownAction.addFunc(mouseDownAction);
				knob.mouseDownAction = mouseDownAction.addFunc(knob.mouseDownAction);
				labelview.mouseDownAction = labelview.mouseDownAction.addFunc(mouseDownAction);
				labelview.followChange(self, \selectedParam, {
					//[self.selectedParam, param, self.selectedFxParamGroup].debug("selectedParam labelview handler");
					if(self.selectedParam == param) {
						labelview.background_(ParamViewToolBox.color_ligth)
					} {
						labelview.background_(Color.clear)
						
					};

				}, false);
				VLayout (
					labelview,
					knob,
					param.asStaticText.align_(\center).fixedWidth_(70),
				).spacing_(10)
			} ++ [nil];
		).spacing_(10);
	},

	updateBottomPanelHeaderView: { arg self;
		var label;
		debug("----- updateBottomPanelHeaderView start");
		if(self.selectedParam == self.selectedTrackParam) {
			label = "Track %".format(self.selectedParam.propertyRoot);
		} {
			label = "Event %".format(self.selectedParam.propertyRoot);
		};
		self.bottomPanelHeaderView.removeAll;
		self.bottomPanelHeaderView.layout_(
			VLayout (
				HLayout (
					StaticText.new.string_(label),
					//BasicButton.new,
					Param(Message(self), \selectedModulatorType, TagSpec([
						\raw,
						\step,
						\modenv,
						\lfosin,
					])).asPopUpMenu,
				),
				HLayout (
					* self.modulatorStripView.proto.eventModel.asParamGroup(self.selectedEvent, self.selectedParam.propertyRoot).collect { arg param, idx;

						VLayout (
							param.asStaticTextLabel.font_(Font.default.size_(10)).align_(\center).attachContextMenu,
							param.asKnob,
							//StaticText.new.string_("0.4234"),
						).margins_(0).spacing_(5)
					} ++ [nil];
				).margins_(0).spacing_(0),

				//HLayout (
				//* 4.collect { arg item, idx;

				//VLayout (
				//StaticText.new.string_("slope").font_(Font.default.size_(10)).align_(\center),
				//Knob.new,
				////StaticText.new.string_("0.4234"),
				//).margins_(0).spacing_(5)
				//},
				//).margins_(0).spacing_(0),
				nil
			)
		);
	},


	update_track_header: { arg self;
		var track_count = self.timeline_model.track_count;
		var color_selected = self.colors.selected;
		var color_deselected = self.colors.deselected;
		var track_header_block = { arg x;
			var idx = x; // index is already reversed
			var res;
			res = View.new.layout_(
				//VLayout(
					HLayout(
						//XSimpleButton.new.label_("track %".format(x)).
						//self.track_selector.views[idx],
						//debug( "updb 2" );
						DragBoth.new.string_("x").fixedSize_(20@20).align_(\center).object_(x)
							.receiveDragHandler_({
								var oldidx = View.currentDrag;
								{ 
									// freeze when setting canvas if no defer
									self.timeline_model.moveNodeTo(oldidx, idx);
								}.defer(0.1);
							})
						,
						StaticText.new.string_(self.timeline_model.tracks[idx].label ++ "  "),
						HLayout (
							Param(Message(self.timeline_model.tracks[idx]), \muted, XBoolSpec()).asButton("M").maxWidth_(20).addAction({
								self.timeline_model.computeSoloMute;
							}),
							Param(Message(self.timeline_model.tracks[idx]), \solo, XBoolSpec()).asButton("S").maxWidth_(20).addAction({
								self.timeline_model.computeSoloMute;
							}),
						).spacing_(0)
					).spacing_(5).margins_([5,0,5,0]),
				//).spacing_(0).margins_(0)
			);
			res.mouseDownAction_({ arg view, px, py, modifiers, buttonNumber, clickCount;
				[x, view, px, py, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
				self.timeline.deselectAllNodes;
				self.selectedEvent = nil;
				self.trackSelector.selectIndex(idx)
			});
			self.trackSelector.addView(res);

			res.background_(color_deselected);
			res;
		};

		self.trackSelector = ProtoTemplateDef(\SimpleViewSelector).new;

		self.trackSelector.selectAction = self.selectTrackAction;

		self.trackSelector.deselectAction = self.deselectTrackAction;

		track_count.debug("update 3");

		self.track_header_view = View.new.layout_(
			VLayout(*
				// first view is at bottom, reverse index
				(0..track_count-1).reverse.collect { arg x;
					[
						track_header_block.(x),
						//align: \left,
						//align: \top,
						stretch:10,
					]
				}
			).spacing_(5).margins_([0,5,0,5])
		);
		self.trackSelector.selectIndex(0);
		self.track_header.removeAll;
		self.track_header.canvas_( // why does this make freeze gui when changed(\tracks) ?
			self.track_header_view
		).maxWidth_(self.trackHeaderWidth);
		self.update_track_header_size;
		self.track_header.onResize = { self.update_track_header_size };
		if(self.track_header_controller.notNil) {
			self.track_header_controller.remove;
		};
		self.track_header_controller = SimpleController(self.timeline)
		.put(\viewport, {
			//"update_track_header_size: viewport".debug;
			//TODO: remove controller
			if(self.track_header.isNil or: {self.track_header.isClosed}) {
				self.track_header_controller.remove;
			} {
				self.update_track_header_size;
			}

		})
		.put(\areasize, {
			//"update_track_header_size: areasize".debug;
			if(self.track_header.isNil or: {self.track_header.isClosed}) {
				self.track_header_controller.remove;
			} {
				self.update_track_header_size;
			}
			//self.update_track_header;
		})
		;
	},

));

//// GlobalLibrary

TagSpecDef('GlobalLibrary.category.Timeline').addUnique(\FxTimeline);
TagSpecDef('GlobalLibrary.type').addUnique(\FxTimeline);
ProtoDef(\GlobalLibrary).clipFactories[\fxTimeline] = (
	key: \fxTimeline,
	libIdKey: \FxTimeline,
	parent: ProtoDef(\GlobalLibrary).clipFactories_timeline_parent,
	classObject: "{ ProtoClassDef(%) }".format(\FxTimeline.asCompileString).interpret,
);


///////////////// test and debug

Spec.add(\time, ControlSpec(0.01,1,\exp));
Spec.add(\lpf, \freq);
Spec.add(\dry, \unipolar);
//ProtoInst(\FxTimeline, \bla1).edit;

FileSystemProject.load("libdef/synthplayrec.scd");
~t = 185/4/60; TempoClock.default.tempo = ~t;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vbreaks/Funk Brothers - Home Cookin.wav'),
			\legato, 1,
			\st, 110/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			],1),8).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, ProtoInst(\FxTimeline, \bla1).fxRack.fxBus,
		)
		
	])
));

////////

Pbindef(\bla,
	\instrument, \saw,
	\degree, PstepSeq(0!8,inf),
	\mute, PstepSeq(false!8,inf),
);

WindowDef(\testmodstrip, { arg def;
	var param = Param(Pbindef(\bla), \degree -> \stepseq, ControlSpec(0,14,\lin,0));
	var parammute = Param(Pbindef(\bla), \mute -> \stepseq, ParamBoolSpec());
	var mod;
	mod = WindowDef(\ModulatorStrip_slider);
	~mod = mod;
	VLayout (
		HLayout (
			param.asStaticTextLabel.fixedWidth_(90),
			mod.asView(param, 8),
		),
		HLayout (
			param.asStaticTextLabel.fixedWidth_(90),
			WindowDef(\ModulatorStrip_button).asView(parammute, 8),
		),
		HLayout (
			param.asStaticTextLabel.fixedWidth_(90),
			WindowDef(\ModulatorStrip_button).asView(parammute, 8),
		),
		HLayout (
			param.asStaticTextLabel.fixedWidth_(90),
			WindowDef(\ModulatorStrip_button).asView(parammute, 8),
		),
		//HLayout (
			//param.asStaticTextLabel.fixedWidth_(50),
			//WindowDef(\ModulatorStrip_slider).asView(param, 8),
		//)
	).spacing_(0)
});
//WindowDef(\testmodstrip).front;
);

//////////////////////////////////////////////////////////////////////
// END

ProtoInst(\FxTimeline, \bla2).edit;
ProtoInst(\FxTimeline, \bla1).fxRack.inputProxy.play
ProtoInst(\FxTimeline, \bla3).edit;
ProtoInst(\FxTimeline, \bla1)[\refCompileString].asCompileString
ProtoInst(\FxTimeline, \bla1).refCompileString
ProtoInst(\FxTimeline, \bla2).edit;
ProtoInst(\FxTimeline, \bla1).fxRack.edit
WindowDef(\testmodstrip).front;

ClipTimeline(\test).edit;
ProtoClassDef(\FxTimeline).new(\aze).edit
~lib = ProtoDef(\GlobalLibrary)
~id = [ \FxTimeline, \bla1 -> ProtoInst(\FxTimeline, \bla1) ]
~w = ProtoDef(\GlobalLibrary).libIdToWrapper([ \FxTimeline, \bla1 -> ProtoInst(\FxTimeline, \bla1) ])
~w.classObject.new(\bla1).edit
~w.getEvent.timeline
~ev = ~w.getEvent
~w.eventToLibId(~ev)
~lib.eventToLibId(~ev)
~lib.lib
~lib.clipFactories_keys
~lib.clipFactories.keys.asArray.sort
~lib[\clipFactories_keys]

~w.getTarget.edit
ClipTimeline(\test).presetCompileString.editorInsert
~ev = ClipTimeline(\test).eventList[1]

(
ClipTimeline('test').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('test').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 2.0, \label: 'start', \playDur: 2.0, \relDur: 2.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 2.0, \dur: 6.0, \legato: 1, \midinote: 2.0, \playDur: 6.0, \relDur: 6.0, \sustain: 3.75, \timeline: { ProtoInst(\FxTimeline, 'bla1') }, \type: 'pattern', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;




);

(
TagSpecDef('FxTimeline').addUnique(\bla1 -> ProtoInst(\FxTimeline, \bla1));
)

WindowDef(\GlobalLibrary_select).front(nil, {}, \Timeline)
WindowDef(\GlobalLibrary_select).front(nil, {})
WindowDef(\ClipTimelineContextMenu).source.asCompileString
~mod.proto.areasize
~mod.proto.viewport
~mod.proto.cellWidth

ProtoInst(\FxTimeline, \bla1).savePreset(\pre1)
ProtoInst(\FxTimeline, \bla1).loadPreset(\pre1)
ProtoInst(\FxTimeline, \bla1).fxRack.presetBank.getCurrentPreset
ProtoInst(\FxTimeline, \bla1).presetBank_obj = nil
ProtoInst(\FxTimeline, \bla1).eventList
ProtoInst(\FxTimeline, \bla1).presetBank
ProtoInst(\FxTimeline, \bla1).editor.selectedParam
ProtoInst(\FxTimeline, \bla1).editor.selectedTrackParam
ProtoInst(\FxTimeline, \bla1).editor.selectedParam == ProtoInst(\FxTimeline, \bla1).editor.selectedTrackParam
ProtoInst(\FxTimeline, \bla1).changed(\selectedParam)

ProtoInst(\FxTimeline, \bla1).edit
ProtoInst(\FxTimeline, \bla1).changed(\tracks)
ProtoInst(\FxTimeline, \bla1).fxRack[\monitorProxy].asCompileString
~s = ~group.asStream
~s.next(())[\payload].asCompileString


GroupDef

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\mkg, GroupDef.pattern(\bla, GroupDef.pattern(\bli, GroupDef.pattern(\blo))),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);




Pn
TimelineEventList
ProtoInst(\FxTimeline, \bla1).editor.areasize
ProtoInst(\FxTimeline, \bla1).editor.timeline.areasize
ProtoInst(\FxTimeline, \bla1).areasize
ProtoInst(\FxTimeline, \bla1).editor.selectedFxParamGroup
~s = ProtoInst(\FxTimeline, \bla1).asPattern.asStream
~s.next(())
ProtoDef(\bla, ProtoClassDef(\FxTimeline).new)
ProtoClassDef(\FxTimeline).new(\bla)
ClipTimeline(\fx).edit

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
SampleTimeline(\amen).buffer = BufDef(\amen)
SampleTimeline(\amen).edit
~t = 185/4/60; TempoClock.default.tempo = ~t;

(
Pdef(\stut1, 
	Pmono(\ifx_stutter,
		\out, BusDef(\ifxbus1, \audio, 2),
		\addAction, \addToTail,
		//\mix, Pseq([0,1],inf),
		\mix, 1,
		\wet, 1,
		\time, 1/4/~t,
		\group, GroupDef.pattern(\ifx1, GroupDef.pattern(\ifx, nil, \addAfter)),
		\lag, 0.0004,
		\dur, 1,
	),
);
);

(
Pdef(\chainout, 
	Pmono(\ifx_out,
		\inbus, BusDef(\ifxbus1, \audio, 2),
		\addAction, \addToTail,
		\group, GroupDef.pattern(\ifx, \addAfter),
		\lag, 0.0009,
		\dur, 1,
	),
);
);

(
// AUGUSTO !!!
Pdef(\augusto, 
	Pbind(
		\instrument, \playersec,
		\bufnum, BufDef.stereo('vbreaks/Augusto Alguero - Ballet Del Arbitro Bueno.wav'),
		\legato, 1,
		\st, 105/2/60,
		\speed, 1 * ~t / Pkey(\st),
		\pos, Pseg(Pseq([
			0, 2,
		]+0,1),2).loop / Pkey(\st),
		\dur, 1/8,
		\gain, 1/8,
		\out, BusDef(\bla1_fxRack, \audio),
	),
);
);

Pdef(\augusto).play
Pdef(\augusto).edit
(
Pdef(\help, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\group, GroupDef(\group1),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);
Pdef(\help).play
CmdPeriod.stop

Param(Pdef(\bla), \rah).xxx


(
~obj = ();
try {

	SimpleController(~obj).put(\refresh, {
		"refresh".debug;
		try {
			1.xxxx;
		} {
			"exception".debug;
		}
	})
}
)

~obj.changed(\refresh)



(
Pdef(\test, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0,Pwhite(0,7,1)],inf),
		\dur, 1,
		\out, ProtoInst(\FxTimeline, \bla1).fxRack.fxBus,
		//\out, ProtoDef(\myfx).fxBus,
		\amp, 0.1,
	)
).play;
);

Pbind(
	\instrument, \playersec,
	\bufnum, BufDef('voices/feynman.flac'),
	\pos, 0,
	\legato, 1,
	\dur, 1,
	\gain, 1,
)
ProtoInst(\FxTimeline, \bla5).fxRack.fxBus
ProtoInst(\FxTimeline, \bla1).fxRack.edit
ProtoDef(\myfx, \InsertFxRack).edit
ProtoDef(\myfx).fxBus


Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 1,
	\amp, 0.1,
),

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		//\id, Pfunc({ s.nextNodeID.debug("nid") }),
		\ids, Pfunc({ 7234 }),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);


(
);



(
~test = {
	var group;
	var first;
	var self = ProtoInst(\FxTimeline, \bla1).fxRack;
	var grouplist = self.fxList.collect { arg fx, idx;
		fx.groupDefName
	};
	first = grouplist.removeAt(0);
	// create the group list directly to be sure of the order
	group = grouplist.inject(GroupDef.pattern(first, self.groupDefPattern), { arg a, b; GroupDef.pattern(b, a, \addAfter) });
	~group = group;
	group
	 
}
)
~test.()
(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\mkg, ~test.(),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);


(
FileSystemProject.loadOnce("sndlib/buflib.scd");
PatKitDef(\kit1, [
	Pbind(
		\instrument, \playersec,
		\bufnum, ~buflib.kick[1010].value,
		\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
		\gain, 0.2,
	),
	Pbind(
		\instrument, \playersec,
		\bufnum, ~buflib.snare[1719].value,
		\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
		\gain, 0.11,
	),
	Pbind(
		\instrument, \playersec,
		\bufnum, ~buflib.hat[1064].value,
		\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
		\gain, 0.11,
	),
])
)
PatKitDef(\kit)
KitTimelineViewc
ParamProto.init
TrackDef(\myc, \TrackList).edit
(
WindowDef(\win, { arg def;
	//Knob.new.mode_(\vert)
	Param(Pdef(\bla),\lpfr).asKnob
	
}).front;
)


~ev = ()
~ev = nil
(
WindowDef(\win, { arg def;
	VLayout (
		Param(~ev, \bla).asView,
		Param(~ev, \rah).asView,
		Param(~ev, \bla).asView,
		Param(~ev, \rah).asView,
	)


	
}).front;
)
Param(~ev, \bla).wrapper

(
	WindowDef(\farfalle, {
		var canvas = UserView.new;
		canvas.drawFunc = {
			var rect = Rect(40,40,80,40);
			var rect2 = Rect(180,80,80,40);
			var rect3 = Rect(280,80,80,40);
			Pen.strokeColor = Color.blue;
			Pen.fillColor = Color.blue;

			Pen.width = 4;
			Pen.addRect(rect.insetBy(4));
			Pen.stroke;

			Pen.width = 4;
			Pen.addRect(rect.insetBy(5));
			Pen.strokeColor = Color.green;
			Pen.stroke;

			//Pen.width = 1;
			//Pen.addRect(rect.insetBy(6));
			//Pen.fillColor = Color.green;
			//Pen.fill;

			// rect 2
			Pen.addRect(rect2);
			Pen.width = 1;
			Pen.strokeColor = Color.black;
			Pen.stroke;

			Pen.width = 2;
			Pen.addRect(rect2);
			Pen.fillColor = ParamViewToolBox.color_ligth;
			Pen.fill;

			// rect 3
			Pen.addRect(rect3);
			Pen.width = 1;
			Pen.draw(3);


		};
		canvas.background_(Color.grey);
	}).front;
)


(
~drawDebug = { arg thi, myrect;
			Pen.addRect(myrect.insetBy(2));
			Pen.width = 4;
			Pen.color = thi.outlineColor;
			Pen.stroke;

			Pen.addRect(myrect.insetBy(2));
			Pen.width = 3;
			Pen.color = thi.color;
			Pen.stroke;

			Pen.width = 1;
			Pen.addRect(myrect.insetBy(2));
			Pen.color = thi.color;
			Pen.fill;
};
ClipTimeline(\bla).edit
)

ClipTimeline(\bla).edit
ClipTimeline(\bla).presetCompileString.editorInsert
~colorDebug = ParamViewToolBox.color_ligth.complementary
Color
(
ClipTimeline('bla').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'muted': false, 'recordBus': 0, 'index': 4, 'recordArmed': false, 
  'solo': false ), ( 'muted': false, 'recordBus': 0, 'index': 5, 'recordArmed': false, 
  'solo': false ) ];
{
ClipTimeline('bla').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.625, \label: 'start', \playDur: 0.625, \relDur: 0.625, \sustain: 0, \type: 'start', ),
	(\absTime: 0.625, \dur: 0.75, \legato: 1, \midinote: 3.0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.875, ),
	(\absTime: 1.375, \dur: 0.625, \legato: 1, \midinote: 4.0, \playDur: 0.625, \relDur: 0.625, \sustain: 2.0, ),
	(\absTime: 2.0, \dur: 0.125, \legato: 1, \midinote: 0.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 2.125, \dur: 0.125, \legato: 1, \midinote: 2.0, \playDur: 0.125, \relDur: 0.125, \sustain: 3.375, ),
	(\absTime: 2.25, \dur: 0.0, \legato: 1, \midinote: 1.0, \playDur: 0.0, \relDur: 0.0, \sustain: 3.75, ),
	(\absTime: 2.25, \dur: 0.625, \legato: 1, \midinote: 0.0, \playDur: 0.625, \relDur: 0.625, \sustain: 0.1, ),
	(\absTime: 2.875, \dur: 0.125, \legato: 1, \midinote: 0.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 3.0, \dur: 1.125, \legato: 1, \midinote: 5.0, \playDur: 1.125, \relDur: 1.125, \sustain: 2.25, ),
	(\absTime: 4.125, \dur: 0.25, \legato: 1, \midinote: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 4.375, \dur: 1.125, \legato: 1, \midinote: 3.0, \playDur: 1.125, \relDur: 1.125, \sustain: 2.25, ),
	(\absTime: 5.5, \dur: 0.75, \legato: 1, \midinote: 2.0, \playDur: 0.75, \relDur: 0.75, \sustain: 2.5, ),
	(\absTime: 6.25, \dur: 1.75, \legato: 1, \midinote: 0.0, \playDur: 1.75, \relDur: 1.75, \sustain: 1.625, ),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;




);

NoteTimeline(\aze).presetCompileString.editorInsert
(
NoteTimeline('aze').param = Param(Pdef('NoteTimeline_default'), 'midinote');
NoteTimeline('aze').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 1.125, \label: 'start', \playDur: 1.125, \relDur: 1.125, \sustain: 0, \type: 'start', ),
	(\absTime: 1.125, \dur: 0.125, \midinote: 67.0, \playDur: 0.125, \relDur: 0.125, \sustain: 1.625, ),
	(\absTime: 1.25, \dur: 0.5, \midinote: 62.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.75, ),
	(\absTime: 1.75, \dur: 0.375, \midinote: 51.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.625, ),
	(\absTime: 2.125, \dur: 0.25, \midinote: 45.0, \playDur: 0.25, \relDur: 0.25, \sustain: 1.125, ),
	(\absTime: 2.375, \dur: 0.25, \midinote: 78.0, \playDur: 0.25, \relDur: 0.25, \sustain: 1.875, ),
	(\absTime: 2.625, \dur: 0.625, \midinote: 51.0, \playDur: 0.625, \relDur: 0.625, \sustain: 1.25, ),
	(\absTime: 3.25, \dur: 0.25, \midinote: 69.0, \playDur: 0.25, \relDur: 0.25, \sustain: 1.625, ),
	(\absTime: 3.5, \dur: 1.0, \midinote: 59.0, \playDur: 1.0, \relDur: 1.0, \sustain: 1.125, ),
	(\absTime: 4.5, \dur: 0.125, \midinote: 63.0, \playDur: 0.125, \relDur: 0.125, \sustain: 1.5, ),
	(\absTime: 4.625, \dur: 1.375, \midinote: 65.0, \playDur: 1.375, \relDur: 1.375, \sustain: 1.375, ),
	(\absTime: 6.0, \dur: 0.0, \midinote: 68.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.5, ),
	(\absTime: 6.0, \dur: 0.25, \midinote: 73.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 6.25, \dur: 0.25, \midinote: 73.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 6.5, \dur: 0.0, \midinote: 67.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.5, ),
	(\absTime: 6.5, \dur: 0.25, \midinote: 73.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 6.75, \dur: 0.25, \midinote: 73.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 7.0, \dur: 0.25, \midinote: 73.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 7.25, \dur: 0.75, \midinote: 73.0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.25, ),
	(\absTime: 8.0, \dur: 0.0, \midinote: 67.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.5, ),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
NoteTimeline(\aze).edit
);

(2**(1..7))/3

(
	~drawDebug = { arg thi;

		var startOffset = 0;
		var labelheight = 20;
		var label = thi.label;
		var myrect;

		var rect;
		var pos;
		var previewrect;
		var labelrect;
		//var preview_background = Color.new255(101, 166, 62);
		//var label_background = Color.new255(130, 173, 105);
		var preview_background = ParamViewToolBox.color_pale;
		var label_background = ParamViewToolBox.color_ligth;
		var font = Font.default.copy;


		//if(thi.parent.parentTimeline.notNil) {
			//// we are drawing a node preview inside a node preview
			//labelheight = thi.parent.gridRectToPixelRect(thi.rect).height;
			//label_background = Color.white.lighten(ParamViewToolBox.color_pale, 0.2);
			//font.size = 9;
		//};

		//thi.enablePreview = false;
		pos = thi.origin;

		rect = thi.parent.gridRectToPixelRect(thi.rect);
		rect = rect.insetAll(0,0,1,1); // cleaner drawing
		// now rect is in screen coordinates
		previewrect = rect.insetAll(0,labelheight,0,0);
		labelrect = rect.insetAll(0,0,0,rect.height-labelheight); // should be same as handleRect but in pixel
		//Log(\Param).debug("label px rect:%", labelrect);

		//labelrect.debug("labelrect");
		//previewrect.debug("previewrect");
		//rect.debug("rect");

		//[spritenum, rect].debug("draw");


		//Pen.color = Color.red;
		//Pen.fillRect(labelrect);

		// outline

		//Pen.color = thi.outlineColor;
		//Pen.strokeRect(rect);

		//// top left triangle
		//if(startOffset.notNil and: { startOffset > 0 }) {
			//Pen.color = thi.outlineColor;
		//} {
			//Pen.color = Color.white;
		//};

		//thi.drawRectTriangle(
			//Rect(labelrect.origin.x, labelrect.origin.y, labelheight/4, labelheight/4),
			//'leftTop'
		//);
		//Pen.fill;

		//thi.drawRectDiagonal(
			//Rect(labelrect.origin.x, labelrect.origin.y, labelheight/4, labelheight/4),
			//'leftTop'
		//);
		//Pen.color = thi.outlineColor;
		//Pen.stroke;

		//// top right triangle
		//Pen.color = Color.white;

		//thi.drawRectTriangle(
			//Rect(labelrect.rightTop.x, labelrect.rightTop.y, labelheight.neg/4, labelheight/4),
			//'leftTop'
		//);
		//Pen.fill;

		//thi.drawRectDiagonal(
			//Rect(labelrect.rightTop.x, labelrect.rightTop.y, labelheight.neg/4, labelheight/4),
			//'leftTop'
		//);
		//Pen.color = thi.outlineColor;
		//Pen.stroke;

		// label

		// preview

		if(thi.enablePreview) {
			thi.initPreview;
			thi.drawPreview(previewrect);
		};
		myrect = rect;

			Pen.addRect(myrect.insetBy(4));
			Pen.width = 8;
			Pen.color = thi.outlineColor;
			Pen.stroke;

			Pen.addRect(myrect.insetBy(3));
			Pen.width = 3;
			Pen.color = thi.color;
			Pen.stroke;

			Pen.width = 1;
			Pen.addRect(myrect.insetBy(4));
			Pen.color = thi.color;
			Pen.fill;

		if(thi.selected) {
			Pen.color = label_background.complementary;
		} {
			Pen.color = label_background;
		};
		Pen.fillRect(rect.insetBy(4));
		Pen.color = preview_background;
		Pen.fillRect(previewrect.insetBy(4));

		Pen.color = Color.black;
		Pen.stringLeftJustIn(" "++label, labelrect.insetBy(4).moveBy(0,3), font);
	}
)



(
	WindowDef(\farfalle, {
		var canvas = UserView.new;
		~draw_round_box = { arg rect, smooth=1, width=1;
			var radius = smooth;
			var inradius = radius - ( width/10 );
			Pen.moveTo(Point(rect.left, rect.bottom - radius));
			Pen.lineTo(Point(rect.left, rect.top + radius));
			Pen.addAnnularWedge(Point(rect.left, rect.top)+radius, inradius,radius, 2pi/2, pi/2);
			Pen.moveTo(Point(rect.left + radius, rect.top));
			Pen.lineTo(Point(rect.right - radius, rect.top));
			Pen.addAnnularWedge(Point(rect.right - radius, rect.top + radius), inradius,radius, 3pi/2, pi/2);
			Pen.moveTo(Point(rect.right, rect.top + radius));
			Pen.lineTo(Point(rect.right, rect.bottom - radius));
			Pen.addAnnularWedge(Point(rect.right, rect.bottom) - radius, inradius,radius, 4pi/2, pi/2);
			Pen.moveTo(Point(rect.right - radius, rect.bottom ));
			Pen.lineTo(Point(rect.left + radius, rect.bottom));
			Pen.addAnnularWedge(Point(rect.left + radius, rect.bottom - radius), inradius,radius, pi/2, pi/2);
		};
		canvas.drawFunc = {
			var rect = Rect(40,40,180,140);
			var rect2 = Rect(40,40,180,140).moveBy(200,100);
			var pwidth = 10;
			Pen.strokeColor = Color.black;
			Pen.fillColor = ParamViewToolBox.color_light;
			Pen.moveTo(200@100);

			//Pen.addAnnularWedge(100@100, 9,10, 0, pi/2);
			//Pen.addRect(rect);
			//Pen.draw(3);

			Pen.color = Color.red;
			~draw_round_box.(rect.scale(4),80, pwidth);
			Pen.width = pwidth;
			//Pen.addRect(rect2);
			Pen.draw(3);
			//Pen.stroke;
			//Pen.fill;
		};
		canvas.background_(Color.grey);
	}).front;
)

(
	WindowDef(\farfalle, {
		var canvas = UserView.new;
		~draw_round_box = { arg rect, smooth=1, width=1;
			var radius = smooth;
			var inradius = radius - ( width/10 );
			Pen.moveTo(Point(rect.left, rect.bottom - radius));
			Pen.lineTo(Point(rect.left, rect.top + radius));
			Pen.addAnnularWedge(Point(rect.left, rect.top)+radius, inradius,radius, 2pi/2, pi/2);
			Pen.lineTo(Point(rect.left, rect.bottom - radius));
		};
		canvas.drawFunc = {
			var rect = Rect(40,40,180,140);
			var rect2 = Rect(40,40,180,140).moveBy(200,100);
			var pwidth = 10;
			Pen.strokeColor = Color.black;
			Pen.fillColor = ParamViewToolBox.color_light;
			Pen.moveTo(200@100);

			//Pen.addAnnularWedge(100@100, 9,10, 0, pi/2);
			//Pen.addRect(rect);
			//Pen.draw(3);

			Pen.color = Color.red;
			~draw_round_box.(rect.scale(4),80, pwidth);
			Pen.width = pwidth;
			//Pen.addRect(rect2);
			Pen.draw(3);
			//Pen.stroke;
			//Pen.fill;
		};
		canvas.background_(Color.grey);
	}).front;
)


////////////////////////////


(
Pbindef(\testmod, 
	\instrument, \saw,
	\degree, Pseq([0,3,2,Pwhite(0,7)],inf),
	\lpfr, PmodEnv(PstepSeq([1,2,1,4]*2,1), 2).loop,
	\rq, 0.3,
	\octave, 4,
	\dur, 1/2,
	\amp, 0.1,
).play;
);
Pdef(\testmod).clear;

Pbindef(\testmod).source.at(\lpfr).source.levels
Param(Message( Pbindef(\testmod).source.at(\lpfr).source.pattern.valPat ), \list).edit
PmodEnv(PstepSeq([1,2,1,4]*2,1), 2)

SampleTimeline(\bla).edit
:wa

WindowDef(\win, { arg def;
	Menu(
		MenuAction("sdf").icon_(Image("/usr/share/icons/elementary-xfce/places/i48/folder-home.png")),
		MenuAction("sdf"),
		MenuAction("sdf"),
		MenuAction("sdf"),
		MenuAction("sdf"),
	)
	
}).front;


(
WindowDef(\win, { arg def;
	var menu = Menu();
	~menu = menu;
	menu
	
}).front;
)

~menu.addAction(MenuAction("bla"))
~menu.removeAction(~menu.actions[0])
~menu.actions = [MenuAction("perferct")]
ListView

(
Pdef(\zed, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0],inf),
		\lpfr, ~pmodsynth.({ SinOsc.ar(0.3).range(1,8)  }),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);
NoteTimeline(\blz).edit
SynthDescLib


ClipTimeline(\bla).edit
NoteTimeline(\bla).edit

Pdef(\hiihih).edit
Pdef(\hiihih).play
FileSystemProject.load("libdef/ModulatorRack.scd")

ProtoDef(\PianoCenter).edit
NoteTimeline(\blaa).edit
NoteTimeline(\blaa).editor.has_selection_rect
NoteTimeline(\blaa).editor.clipboard.selection_rect
ProtoInst(\FxTimeline, \bla1).eventListClone
ProtoInst(\FxTimeline, \bla1).eventList.clone

~r = Rect(1,2,10,20)
~r.insetAll(1,2,3,4)
ClipTimeline(\bla).edit
TimelineEventList

Quarks.install("https://github.com/grirgz/param.git");

NoteTimeline(\testme).edit;
