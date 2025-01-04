(
//////// ModulatorStrip

ProtoTemplateDef(\ModulatorStrip, (
	new: { arg self, fxtimeline;
		self = ProtoClass((parent:self));
	
		self.fxTimelinePanel = {fxtimeline}; // the panel view
	
		self;
	},
	masterTimeline: { arg self;
		self.fxTimelinePanel.timeline;
		
	},

	timelineModel: { arg self;
		self.fxTimelinePanel.timeline_model;
	},

	edit: { arg self;
		WindowDef(\ModulatorStrip).front(self)
	},
	asView: { arg self;
		WindowDef(\ModulatorStrip).asView(self)
	},

	levelList: { arg self;
		if(self[\levelList_obj].isNil) {
			self[\levelList_obj] = SparseArray(16, 0);
		};
		self[\levelList_obj];
	},

));

//// GUI

WindowDef(\ModulatorStrip, (

	virtualBounds: { arg self;
		self.view.bounds.insetBy(5,10);
	},
	viewport: { arg self;
		var vp = self.masterTimeline.viewport;
		Rect(vp.origin.x, 0, vp.extent.x, 1);
	},
	masterTimeline: { arg self;
		self.model.masterTimeline;
	},
	areasize: { arg self;
		var as = self.masterTimeline.areasize;
		Point(as.x, 1);
	},
	pixelRectToNormRect: { arg self, rect;
		var bounds = self.virtualBounds;
		var x_pixel_to_norm, y_pixel_to_norm;
		var viewport = self.viewport;
		var areasize = self.areasize;

		rect = rect
		// now in pixels in screen coordinates
		.translate(0-bounds.origin)
		.flipScreen(bounds.height)
		// now in pixels in bottom coordinates
		.scale(1/bounds.extent)
		// now in normalized in bottom coordinate
		.scale(viewport.extent)
		.translate(viewport.origin)
		;

		rect;

	},

	normRectToPixelRect: { arg self, rect;
		var bounds = self.virtualBounds;
		var x_norm_to_pixel;
		var y_norm_to_pixel;
		var viewport = self.viewport;

		//viewport.debug("normRectToPixelRect viewport");

		rect = rect
			.translate(0-viewport.origin)
			.scale(1/viewport.extent)
			.scale(bounds.extent)
			// now in pixel in bottom coordinates
			.flipScreen(bounds.height)
			// now in pixel in screen coordinates
			.translate(bounds.origin) // bounds is in screen coordinates so need flipping before translating
		;

		rect;

	},

	gridRectToNormRect: { arg self, rect;
		//rect.debug("gridRectToNormRect");
		Rect.fromPoints(
			self.gridPointToNormPoint(rect.origin),
			self.gridPointToNormPoint(rect.rightBottom),
		);
	},

	normRectToGridRect: { arg self, rect;
		Rect.fromPoints(
			self.normPointToGridPoint(rect.origin),
			self.normPointToGridPoint(rect.rightBottom),
		);
	},

	gridRectToPixelRect: { arg self, rect;
		self.normRectToPixelRect(self.gridRectToNormRect(rect));
	},


	pixelRectToGridRect: { arg self, rect;
		self.normRectToGridRect(self.pixelRectToNormRect(rect));
	},

	normPointToGridPoint: { arg self, point;
		(point * self.areasize)
	},

	gridPointToNormPoint: { arg self, point;
		(point / self.areasize)
	},
	
	pixelPointToGridPoint: { arg self, point;
		self.normPointToGridPoint(self.pixelPointToNormPoint(point))
	},

	pixelPointToNormPoint: { arg self, point;
		self.pixelRectToNormRect(Rect.fromPoints(point, point+Point(0,0))).origin;
	},

	gridPointToPixelPoint: { arg self, point;
		self.normPointToPixelPoint(self.gridPointToNormPoint(point))
	},

	normPointToPixelPoint: { arg self, point;
		self.normRectToPixelRect(Rect.fromPoints(point, point+Point(0,0))).origin;
	},


	mimicTimeline: { arg self, timeline, orientation;
		var timeline_controller;
		var viewport = self.viewport;
		var areasize = self.areasize;
		var rect_copy_horizontal = { arg me, rect;
			me = me.copy;
			me.width = rect.width;
			me.origin = Point(rect.origin.x, me.origin.y);
			me;
		};
		var rect_copy_vertical = { arg me, rect;
			me = me.copy;
			me.height = rect.height;
			me.origin = Point(me.origin.x, rect.origin.y);
			me;
		};

		if(timeline_controller.notNil) {timeline_controller.remove};
		timeline_controller = SimpleController(timeline)
			.put(\viewport, {
				if(self.view.isNil or: { self.view.isClosed }) {
					timeline_controller.remove;
				} {
					//[this].debug("refresh viewport because mimicTimeline!!");
					switch(orientation,
						\horizontal, {
							self.viewport = rect_copy_horizontal.(viewport, timeline.viewport);
						},
						\vertical, {
							self.viewport = rect_copy_vertical.(viewport, timeline.viewport);
						},
						// else
						{
							self.viewport = timeline.viewport; 
						}
					);
					self.refresh;
				}
			})
			.put(\areasize, {
				if(self.view.isNil or: {self.view.isClosed}) {
					timeline_controller.remove;
				} {
					//[this].debug("refresh viewport because mimicTimeline!!");
					switch(orientation,
						\horizontal, {
							self.areasize = Point(timeline.areasize.x, areasize.y);
						},
						\vertical, {
							self.areasize = Point(areasize.x, timeline.areasize.y);
						},
						// else
						{
							self.areasize = timeline.areasize;
						}
					);
					self.refresh;
				}
			})
			.put(\lastGridPos, {
				self.lastGridPos = timeline.lastGridPos;
				//this.view.refresh;
				self.refresh;
			})
		;
		// init
		timeline.changed(\areasize);
		timeline.changed(\viewport); 

	},


	refresh: { arg self;
		self.view.refresh;
	},

	cellWidth: { arg self;
		self.model.timelineModel.cellWidth
	},

	installListeners: { arg self;
		self.view.followChange(self.model.fxTimelinePanel, \selectedFx, {
			self.refresh;
		});
		self.view.followChange(self.model.fxTimelinePanel, \selectedParam, {
			self.refresh;
		});
		
	},

	getLineEvents: { arg self;
		var idx = self.model.timelineModel.tracks.indexOf(self.model.fxTimelinePanel.selectedFx);
		var ykey = \midinote;
		var ypos;
		if(idx.notNil) {
			self.model.timelineModel.eventList.select({ arg ev;
				ypos = ev.use { currentEnvironment[ykey] };
				ypos == idx;
			})
		} {
			[]
		};
	},

	selectedParam: { arg self;
		self.model.fxTimelinePanel.selectedParam;
	},

	xkey: \absTime,
	xlenkey: \sustain,

	colors: (
		//empty: ParamViewToolBox.color_pale(0.7),
		disabled: ParamViewToolBox.color_pale.copy.alpha_(0.5),
		empty: ParamViewToolBox.color_pale,
		eventBox: ParamViewToolBox.color_dark,
		barBox: ParamViewToolBox.color_ligth,
		full: ParamViewToolBox.color_ligth,
		unset: ParamViewToolBox.color_ligth.copy.alpha_(0.6),
	),

	drawEventContent: { arg self, ev, rect;
		var key = self.selectedParam.propertyRoot;
		var len = ev[self.xlenkey];
		var xkey = self.xkey;
		var num;
		var sliderwidth = self.cellWidth;
		var maxlevel = 1;
		var penOffset = 0; // compensate don't know what
		var seqev, seq;
		var isSet = true;
		num = ( len / self.cellWidth ).asInteger;
		if(ev.localSeq.isNil) { // do not create if not existing
			seqev = ();
			isSet = false;
		} {
			seqev = ev.localSeq;
		};
		if(seqev[key].isNil) {
			seq = List.newFrom( self.selectedParam.get !num);
			isSet = false;
		} {
			seq = seqev[key];
		};
		Pen.width = 1;

		num.do { arg idx;
			var gposx = sliderwidth * idx;
			var gxoffset = ev[xkey];
			var curlevel = seq[idx];
			var rect;
			var fullrect;
			curlevel = self.selectedParam.spec.unmap(curlevel);
			rect = self.gridRectToPixelRect(Rect(gposx+gxoffset,0, sliderwidth, maxlevel * curlevel));
			//rect.debug("rect");
			rect.left = rect.left + penOffset;
			rect.bottom = rect.bottom - 4;
			rect.width = rect.width - 1;
			fullrect = rect.copy;
			//fullrect.top = self.virtualBounds.height;
			//fullrect.height = self.virtualBounds.height.neg * 0.5;
			fullrect = Rect(rect.origin.x, 6, rect.width, self.virtualBounds.height);
			//fullrect.debug("FULLRECT");
			Pen.addRect( fullrect );
			Pen.color = self.colors.empty;
			Pen.fill;

			Pen.addRect( rect );
			if(isSet) {
				Pen.color = self.colors.full;
			} {
				Pen.color = self.colors.unset;
			};
			//Pen.color = self.colors.barBox;
			Pen.stroke;
			Pen.addRect( rect );
			Pen.fill;
		};
	},

	setCellAtPos: { arg self, pxpos, val;
		var ev, node;
		var pypos;
		var gxpos, gypos;
		var idx;
		var key = self.selectedParam.propertyRoot;
		pypos = self.gridPointToPixelPoint(Point(0,self.model.fxTimelinePanel.selectedFxIndex)).y + 1;
		gypos = self.model.fxTimelinePanel.selectedFxIndex + 0.1;
		gxpos = self.pixelPointToGridPoint(Point(pxpos, 0)).x;

		node = self.model.masterTimeline.findNode(gxpos, gypos);
		if(node.notNil) {
			var xrel; // relative to event start
			val = self.selectedParam.spec.map(val);
			ev = node.model;
			ev.debug("setCellAtPos: ev");
			xrel = gxpos - ev[self.xkey]; // relative to event start
			idx	= xrel / self.cellWidth;
			if(ev.localSeq.isNil) {
				ev.localSeq = ();
			};
			if(ev.localSeq[key].isNil) {
				ev.localSeq[key] = List.newFrom( self.selectedParam.get!( ev[self.xlenkey] / self.cellWidth ) );
			};
			ev.localSeq[key][idx] = val;
			//ev[self.xlenkey] 
		} {
			
		};
		self.refresh;
	},

	asView: { arg self, def, model;
		var view = UserView.new;
		var sliderwidth; // in grid unit
		var tl;
		self.view = view;
		self.model = model;
		sliderwidth = self.cellWidth;
		//self.timeline = TimelineView.new; // for conversions
		self.mimicTimeline(model.masterTimeline, \horizontal);
		//tl = self.timeline;
		self.installListeners;

		view.drawFunc = {
			var bounds = self.virtualBounds;
			var num;
			var maxlevel = 1;
			var xkey = \absTime;
			var xlenkey = \sustain;
			var penOffset = -0; // compensate width
			//"draw".debug;
			//[bounds, self.areasize, self.pixelRectToGridRect(bounds).width].debug("width");
			num = ( self.pixelRectToGridRect(bounds).width / sliderwidth ).trunc.asInteger + 1;
			//num.debug("ModulatorStrip: num");
			self.getLineEvents.debug("line events");
			//Pen.scale(1,0.90);
			Pen.translate(0,5);
			num.do { arg idx;
				var gposx = sliderwidth * idx;
				var rect;
				var fullrect;
				rect = self.gridRectToPixelRect(Rect(gposx,0, sliderwidth, 1));
				//rect.debug("rect");
				rect.left = rect.left + penOffset;
				fullrect = rect.copy;
				//fullrect.top = self.virtualBounds.height;
				//fullrect.height = self.virtualBounds.height.neg * 0.5;
				fullrect = Rect(rect.origin.x, 6, rect.width-1, self.virtualBounds.height);
				//fullrect.debug("FULLRECT");
				Pen.addRect( fullrect );
				Pen.color = self.colors.disabled;
				Pen.fill;
			};

			self.getLineEvents.do { arg ev, idx;
				
				var curlevel = 1;
				var rect = self.gridRectToPixelRect(Rect(ev[xkey], 0, ev[xlenkey], maxlevel * curlevel));
				rect.left = rect.left + penOffset;
				rect.bottom = rect.bottom - 4;
				Pen.width = 4;
				Pen.addRect( rect );
				Pen.color = self.colors.eventBox;
				Pen.stroke;
				self.drawEventContent(ev, rect);
				
			};
		};
		view.background_(Color.white);

		view.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			var idx;
			[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
			self.setCellAtPos(x, 1 - ( y/self.virtualBounds.height ));
		});
		view.mouseMoveAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			var idx;
			//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseMoveAction");
			self.setCellAtPos(x, 1 - ( y/self.virtualBounds.height ));

		});
		view;
	},


	findCellIndex: { arg self, x;
		self.pixelPointToGridPoint(Point(x, 0)).x / self.cellWidth;
		
	},

));

//////// FxTimeline

ParamProto.init;
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
							fxidx = ev.use { ~midinote.value };
							fxidx.debug("fxidx");
							pat = self.fxRack.childAt(fxidx).asPattern;
							if(ev[\localValues].notNil) {
								pat = Pn(ev[\localValues],inf) <> pat;
							};
							if(ev[\localSeq].notNil) {
								pat = Pbind(
									* ev[\localSeq].keys.asArray.collect { arg key, idx;
										[key, PstepSeq(ev[\localSeq][key])]
									}.flatten ++ [\dur, self.cellWidth];
								) <> pat;
							};
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
				Pfindur(dur, self.fxRack.monitorProxy)
			]);

			"houou".debug;
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
		self.areasize = Point(self.areasize.x, self.tracks.size ); // areasize is deprecated, use track_count
	},
)));


//// GUI


ProtoTemplateDef(\FxTimelinePanelView, (
	parent: ProtoTemplateDef(\ClipTimelinePanelView),

	makeFxParamView: { arg self;
		var strip;
		strip = ProtoTemplateDef(\ModulatorStrip).new(self).asView;
		
		//self.bottomPanelView.layout = self.selectedFx.asParamGroup.asView;
		self.bottomPanelView.layout = VLayout(strip).margins_([0,0,0,0]).spacing_(0)
	},

	selectedFx: { arg self;
		self.timeline_model.tracks.first;
	},

	selectedFxIndex: { arg self;
		self.trackSelector.selectedIndex;
	},

	selectedParam_: { arg self, param;
		self[\selectedParam] = param;
		self.selectedFx.selectedParam = param;
		self.changed(\selectedParam);
	},

	//selectedParam: { arg self;
		//self.selectedFx.asParamGroup.rejectByProperty([ \adsr, \dur, \legato, \out ]).first;
	//},

	makeBottomPanelView: { arg self;
		self.bottomPanelView = View.new;
		//self.bottomPanelView.fixedHeight_(100);
		self.makeFxParamView;
		self.bottomPanelHeaderView = View.new;
		//self.bottomPanelHeaderView.fixedHeight_(100);
		self.bottomPanelVerticalScroller = TimelineScroller.new;
		self.bottomPanelVerticalScroller.fixedHeight_(100);
		self.bottomPanelVerticalScroller.orientation = \vertical;
		self.makeBottomPanelToolbar;
		self.isBottomPanelVisible = true;
	},

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
			self.bottomPanelShowButton,
			//self.automationPopup,
			//self.velocityButton,
			//self.automationButton,
			//self.bottomPanelDescription,
			//self.bottomPanelValueText,
		).margins_(0);
	},

	updateFxEditorView: { arg self;
		self.fxEditorView.removeAll;
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
					if(self.selectedParam == param) {
						labelview.background_(ParamViewToolBox.color_ligth)
					} {
						labelview.background_(Color.clear)
						
					};
					self.bottomPanelHeaderView.removeAll;
					self.bottomPanelHeaderView.layout_(
						VLayout (
							StaticText.new.string_(self.selectedParam.fullLabel)
						)
					);

				});
				VLayout (
					labelview,
					knob,
					param.asStaticText.align_(\center).fixedWidth_(70),
				).spacing_(10)
			} ++ [nil];
		).spacing_(10)
	},


	makeFxEditorView: { arg self;
		self.fxEditorView = View.new;
		self.fxEditorView.followChange(self, \selectedFx, {
			self.updateFxEditorView;
		}, false);
		self.fxEditorView.followChange(self.timeline, \selectedNodes, {
			var note;
			self.timeline.selectedNodes.debug("selectedNodes");
			if(self.timeline.selectedNodes.size > 0) {
				var trackidx;
				note = self.timeline.selectedNodes.asArray.first.model;
				note.midinote.debug("selectedNodes midinote");
				trackidx = note.midinote;
				self.selectedFx = self.timeline_model.tracks[trackidx];
				if(note[\localValues].isNil) {
					note[\localValues] = ();
				};
				self.selectedEvent = note;
				self.trackSelector.selectIndex(trackidx); // should be before setting selectedFxParamGroup
				//self.changed(\selectedFx);
			} {
				self.selectedEvent = nil;
				if(self.trackSelector.notNil) {
					self.trackSelector.selectedIndex.debug("selectedNodes follower");
					self.trackSelector.selectIndex(self.trackSelector.selectedIndex);
				};
				nil
			};
		});
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
			"hein?".debug;
			if(clickCount == 2) {
				if(chosennode.notNil) {
					self.showClipEditor(chosennode.model);
				}
			} {
				if(buttonNumber == 1 and: { mod.isCtrl.not }) {
					self.showTimelineContextMenu(chosennode);
				} {
					var idx = self.timeline.pixelPointToGridPoint(Point(px,py)).y.asInteger;
					self.trackSelector.selectIndex(idx);
				};
			}
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

	add_track: { arg self, fx;
		self.timeline_model.add_track(fx);
		self.timeline.refreshEventList;
		self.timeline.refresh;
		self.update_track_header;
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

			Param(Message(self.timeline_model.fxRack), \fxBus, TagSpecDef(\BusDef)).asPopUpMenu,
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
	},

	selectTrackAction: { arg self;
		var color_selected = self.colors.selected;
		var color_deselected = self.colors.deselected;
		{ arg subself, idx;
			var view;
			var ridx = self.timeline_model.tracks.size - 1 - idx;
			var pg;
			[idx, ridx].debug("what");
			view = subself.views[ridx]; // view are reversed
			[view].debug("what2");
			view.background_(color_selected);
			"2what".debug;
			[ color_selected, view.background ].debug("2what");
			// views are reversed but view 0 at bottom still mean fx 0
			self.selectedFx = self.timeline_model.tracks[idx]; 

			pg = self.selectedFx.asParamGroup.rejectByProperty([\out, \adsr, \legato, \dur]);
			if(self.selectedEvent.notNil) {
				self.selectedFxParamGroup = ParamGroup(pg.collect { arg param, idx;
					Param(self.selectedEvent.localValues, param.property, param.spec).default_(param.get)
				});
			} {
				self.selectedFxParamGroup = pg; 
			};

			if(self.selectedFx.selectedParam.notNil) {
				// change param to main or event depending on selection
				self.selectedParam = self.selectedFxParamGroup
				.asPropertyDict[self.selectedFx.selectedParam.propertyRoot];
			} {
				self.selectedParam = self.selectedFxParamGroup.first;

			};


			"3what".debug;
			self.changed(\selectedFx);
			"4what".debug;
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

	colors: (
		selected: ParamViewToolBox.color_pale,
		deselected: Color.gray(0.7),
		
	),

	update_track_header: { arg self;
		var track_count = self.timeline_model.track_count;
		var color_selected = self.colors.selected;
		var color_deselected = self.colors.deselected;
		var track_header_block = { arg x;
			var idx = x; // index is already reversed
			var res;
			debug("updb 1");
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
					).spacing_(5).margins_([5,0,0,0]),
				//).spacing_(0).margins_(0)
			);
			res.mouseDownAction_({ arg view, px, py, modifiers, buttonNumber, clickCount;
				[x, view, px, py, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
				self.timeline.deselectAllNodes;
				self.trackSelector.selectIndex(idx)
			});
			self.trackSelector.addView(res);

			debug("updb 3");
			res.background_(color_deselected);
			debug("updb 4");
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
					x.debug("xx");
					[
						track_header_block.(x),
						//align: \left,
						//align: \top,
						stretch:10,
					]
				}
			).spacing_(5).margins_(0)
		);
		self.trackSelector.selectIndex(0);
		track_count.debug("update 3.5");
		self.track_header.removeAll;
		self.track_header.canvas_( // why does this make freeze gui when changed(\tracks) ?
			self.track_header_view
		).maxWidth_(200);
		debug("update 4");
		self.update_track_header_size;
		self.track_header.onResize = { self.update_track_header_size };
		if(self.track_header_controller.notNil) {
			self.track_header_controller.remove;
		};
		debug("update 5");
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
		debug("update 6");
	},

));
ProtoInst(\FxTimeline, \bla1).edit;

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
);

// END


ProtoInst(\FxTimeline, \bla1).edit
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
	),
);
);

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
