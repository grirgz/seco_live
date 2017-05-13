
// noteTimelinePanelView with velocity panel
~noteVelocityTimelinePanelView = (
	parent: ~timelinePanelView,

	new: { arg self, timeline;
		self = ~timelinePanelView[\new].(self, timeline.eventloop);
	
		self.timeline_model = timeline;
		self.areasize = self.timeline_model.areasize;
		self.makeWindow;
	
		self;
	},

	newView: { arg self, timeline;
		self = ~timelinePanelView[\new].(self, timeline.eventloop);
	
		self.timeline_model = timeline;
		self.areasize = self.timeline_model.areasize;
	
		self;
	},

	cursor: { arg self;
		self.timeline_model.cursor;
	},

	key: { arg self;
		self.timeline_model.key;
	},

	param: { arg self;
		self.timeline_model.param;
	},


	make_header: { arg self;
		self.header_layout = HLayout(
			PlayerWrapperView(self.timeline_model).view,
			self.make_stop_button,
			Param(Message(self.timeline_model), \repeatCount, ControlSpec(1,inf,\lin)).asNumberBox,
			self.make_quant_popup,
			PlayerWrapper(Pdef(\metronome)).asView, // TODO: make a good one and define it a init
			NumberBox.new.mapParam(Param(Message(self.timeline_model.eventLoop), \currIndex, ControlSpec(0,32,\lin,1))),
			Button.new.mapParam(Param(Message(self.timeline_model.eventFactory), \isRecording, XBoolSpec())).states_([
				["Rec", Color.black, Color.white],
				["Rec", Color.black, Color.red],
			]),
		);
		
		self.header_layout;
	},


	timelineClass: { arg self;
		MidinoteTimelineView;
	},

	make_track_header: { arg self, timeline;
		//self.track_header = View.new;
		self.ruler_y = MidinoteTimelineRulerView.new;
		self.track_header = self.ruler_y;
		self.ruler_y.mimicTimeline(timeline);
		self.ruler_y.view.minWidth_(50);
	},

	timelineInstrumentParamGroup: { arg self;
		var target = self.param.target;
		target.asParamGroup
			.add( Param(target, \velocity, ControlSpec(0,127,\lin,0,64)) )
			.add( Param(target, \sustain) )
			.reject({ arg x; x.property == \legato })
		;
	},

	makeVelocityView: { arg self;
		var keyspec;
		self.velocityTimeline = VelocityTimelineView.new;
		self.velocityTimeline.fixedHeight = 150;
		self.velocityTimeline.mimicTimeline(self.timeline, \horizontal);
		self.velocityTimeline.mimicNodeSelection(self.timeline);
		self.velocityTimeline.mapParam(Param(self.param.target, \velocity, ControlSpec(0,127,\lin,0,64)));
		self.velocityTimeline.quant = Point(0,0);
		self.velocityTimeline.forbidHorizontalNodeMove = true;

		self.velocityValue = StaticText.new;
		self.velocityValue.fixedWidth = 50;
		self.velocityValue.font = Font.default.size_(10);
		//self.velocityValue.string = "XXX";

		self.refreshPosyValue = {
			var node;
			"---------------heyyyyyyyyyyyyyyy".debug;
			"heyyyyyyyyyyyyyyy".debug;
			"heyyyyyyyyyyyyyyy".debug;
			node = self.velocityTimeline.chosennode;
			if(node.notNil and: { node.model.notNil }) {
				var val =   node.model[node.posyKey];
				if(val.notNil) {
					val = val.round(0.001)
				};
				self.velocityValue.string = val;
			}

		};
		self.velocityValue.onChange(self.velocityTimeline, \nodeMoved, {
			self.refreshPosyValue;
		});
		self.velocityValue.onChange(self.velocityTimeline, \selectedNodes, {
			self.refreshPosyValue;
		});
		
		self.velocityPopUp = PopUpMenu.new;
		self.velocityPopUp.action_({ arg me;
			"velocityPopUp.action".debug;
			"velocityPopUp.actio3n".postln;
			self.velocityTimeline.mapParam(self.timelineInstrumentParamGroup[me.value]);
			self.velocityTimeline.param.debug("new param!!!");
		}).items_(
			self.timelineInstrumentParamGroup.collect({ arg x; 
				x.property;
			})
		);
		//self.velocityPopUp.mapParam(Param(Message(self.velocityTimeline), \valueKey, keyspec));
	},

	makeLayout: { arg self;
		var layout;
		var tl_layout;
		var vlayout, timeline, vrange, hrange, size;
		var eventloop = self.eventloop;
		var ruler_x, ruler_y, sizer;
		var locatorbar;
		var sizer_action;
		var cursor_timeline;
		var track_header;
		var track_header_view;
		var quant_popup;
		"AZE".debug;
		layout = HLayout.new;
		self.layout = layout;
		vlayout = VLayout.new;
		layout.add(vlayout);

		self.save_timeline_properties;
		timeline = self.makeTimelineView;
		self.timeline = timeline;
		self.load_timeline_properties;
		//timeline.areasize = self.pr_areasize.debug("==================seting areasize");
		~mytl = timeline;
		timeline.mouseDownAction = {|me, px, py, mod, buttonNumber, clickCount, chosennode|
			if(clickCount == 2) {
				if(chosennode.notNil) {
					self.clipEditorNew(chosennode.model, self.eventloop.list)
				};
			}
		};

		timeline.quant = self.quant_ref;

		self.makeVelocityView;

		//self.cursor = CursorTimeline.new;
		//self.cursor.startPosition = self.eventloop.list.startTime;

		cursor_timeline = CursorTimelineView.new;
		~cursor_timeline = cursor_timeline;
		self.cursor_timeline = cursor_timeline;
		cursor_timeline.mapCursor(self.cursor);
		cursor_timeline.quant = self.quant_ref;


		ruler_x = TimelineRulerView.new;
		ruler_x.mapCursor(self.cursor);
		ruler_x.quant = self.quant_ref;
		self.ruler_x = ruler_x;
		locatorbar = TimelineLocatorBarView.new;
		self.locatorbar = locatorbar;

		locatorbar.quant = self.quant_ref;

		ruler_x.mimicTimeline(timeline);
		locatorbar.mimicTimeline(timeline);
		cursor_timeline.mimicTimeline(timeline);

		hrange = TimelineScroller.new;
		hrange.orientation = \horizontal;
		hrange.mapTimeline(timeline);
		vrange = TimelineScroller.new;
		vrange.orientation = \vertical;
		vrange.mapTimeline(timeline);
		self.vrange = vrange;

		sizer = 
		HLayout(
			XSimpleButton.new.label_("<").action_({
				var point = Point(2,1);
				//self.areasize = self.areasize - point;
				self.areasize = self.areasize / point;
				timeline.refresh;
			}).fixedSize_(Point(10,20)),
			XSimpleButton.new.label_(">").action_({
				var point = Point(2,1);
				self.areasize = self.areasize * point;
				timeline.refresh;
			}).fixedSize_(Point(10,20)),
		).spacing_(0)
		;


		// FIXME: created even if disabled, sometime not what we want
		track_header = self.make_track_header(timeline);


		tl_layout = GridLayout.rows(
			[
				nil,
				VLayout(
					locatorbar.view,
					ruler_x.view,
				),
				XSimpleButton.new.label_("z")
					.maxWidth_(10)
					.action_({
						self.zoom_fit;
					})
			],
			[
				if(self.disable_track_header != true) {track_header},
				StackLayout(
					cursor_timeline.view,
					timeline.view,
				).mode_(1),
				vrange.view,
			],
			[
				nil,
				self.velocityTimeline.view,
				nil,
			],
			[
				nil,
				if(self.disable_hrange != true) {hrange.view},
				if(self.disable_hrange != true) {sizer},
			],
		);
		tl_layout.spacing = 0;

		layout = VLayout(
			self.make_header,
			tl_layout,
			HLayout(
				BasicButton.new.string_("V")
					.fixedWidth_(20)
					.action_({
						self.velocityTimeline.visible = self.velocityTimeline.view.visible.not;
					})
				,
				self.velocityPopUp,
				//StaticText.new.string_("Velocity: ")
				//	.font_(Font.default.size_(10))
				//,
				self.velocityValue,
				nil,
			),

		);

		size = self.areasize;
		size.debug("size!!!");

		timeline.areasize = size;

		ruler_x.view.minSize = Point(10,10);
		//ruler_y.view.minSize = Point(40,10);
		locatorbar.view.minSize = Point(10,15);

		timeline.mapEventList(eventloop.list);
		self.velocityTimeline.mapEventList(eventloop.list);
		cursor_timeline.mapEventList(eventloop.list);
		locatorbar.mapEventList(eventloop.list);

		self.timeline = timeline;
		self.layout = layout;
		"iiAZE".debug;


		//self.zoom_fit;

		self.timeline.keyDownAction = self.getTimelineKeyDownAction;

		self.timeline.view.onChange(self.eventloop, \list, { 
			self.refresh;
		});

		layout;
	},

);
