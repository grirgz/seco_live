
// in this file, I am testing the embeding feature of timelines

//~mytl.paraNodes[0].preview.viewport
~tp = TimelinePreview.new
~tp.mapEventList(~sub)
WindowLayout({  ~tp.view });
~tp.viewport = Rect(0,0.2,00.8,0.91); ~tp.refresh;
~tp.viewport = Rect(0,0,1,1); ~tp.refresh;
~tp.virtualBounds
~tp.virtualBounds
~tp.virtualBounds = Rect(200,-100,100,100); ~tp.refresh
(
/////////////////////////////////////////////////////////////////
"/home/ggz/code/sc/seco/vlive/demo/param/lib/timeline.scd".load;
~el = nil;
/////////////////////////////////////////////////////////////////



	SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=4000, rq=0.3;
		var sig, sig1, sig2, sig3;
		sig = LFSaw.ar(freq * [1.01,1,0.99]);
		sig = RLPF.ar(sig, ffreq, rq);
		sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
		sig = Splay.ar(sig, spread, amp, pan);
		Out.ar(out, sig);
	}).add;

	Pdef(\plop, Pbind(
		\instrument, \plop,
		\isRest, false,
		\dur, 1/8,
		\degree, Pseq((0..24),inf),
	));

	Pdef(\plop2, Pbind(
		\instrument, \plop,
		\isRest, false,
		\ffreq, 2000,
		\dur, 1/8,
		\degree, Pseq((0..24)+10,inf),
	));

	Pdef(\plop3, Pbind(
		\instrument, \plop,
		\isRest, false,
		\ffreq, 4000,
		\dur, 1/6,
		\degree, Pseq([1,2,3,4]*2,inf),
	));

	if(~el.isNil) {

		~sub = XEventList.newFrom(
			Pbind(
				\instrument, \default,
				\midinote, Pseq([54,56,57,54,57,58]+20,2),
				\midinote, Pseq([0,0,1,0,127,127,127,127]),
				\dur, 1/4,
				\amp, 0.3
			);
		);

		~el = XEventList.newFrom( 
			
				Pseq([
					Pev((
						parent: ~event_type_eventlist,
						//nodeType: \eventlist,
						eventlist: ~sub,
						sustain: 4.5,
						midinote: 0,
						dur: 7,
					)),
				],1)

		);

		XEventLoop(\pdef).list = ~el;
	};



	~zoom_bar = (
		new: { arg self;
			self = self.deepCopy;
		
			
		
			self;
		},


	);

	~clipEditor = (
		new: { arg self, model, parent;
			self = self.deepCopy;
		
			self.model = model;
			self.parent_model = parent;
			self.makeWindow;
			
		
			self;
		},

		makeUpdater: { arg self;
			self.controller.remove;
			self.controller = SimpleController(self.model).put(\refresh, {
				var ev = self.model;
				[self.type_popup, ev].debug("entering clipEditor updater");
				if(self.type_popup.isNil or: {self.type_popup.isClosed}) {
					self.controller.remove;
				} {
					switch(ev[\eventType] ? ev[\nodeType] ? ev[\type],
						\player, {
							ev.debug("clipEditor: updater: player");
							self.type_popup.value = self.type_popup.items.detectIndex({ arg x; x == \Ndef });
							self.name_popup.items = Ndef.all[\localhost].envir.keys.asArray;
							self.name_popup.value = self.name_popup.items.detectIndex({ arg x; x == ev[\key] ?? { ev[\receiver].key } });
						},
						\pattern, {
							ev.debug("clipEditor: updater: pattern");
							self.type_popup.value = self.type_popup.items.detectIndex({ arg x; x == \Pdef });
							self.name_popup.items = Pdef.all.keys.asArray;
							self.name_popup.value = self.name_popup.items.detectIndex({ arg x; x == ev[\key] ?? { ev[\receiver].key } });
						}, {

							ev.debug("clipEditor: updater: other");
						}
					)
				}


			});
		},

		makeLayout: { arg self;
			var layout;
			var header;
			var editor;
			var type_popup, name_popup;
			var model = self.model;
			type_popup = PopUpMenu.new;
			name_popup = PopUpMenu.new;
			self.name_popup = name_popup;
			self.type_popup = type_popup;
			
			type_popup.items = [
				'Pdef',
				'Ndef',
				'Timeline',
				'MidinoteTimeline'
			];
			type_popup.action = {
				switch( type_popup.items[type_popup.value],
					\Ndef, {
						name_popup.items = Ndef.all[\localhost].envir.keys.asArray;
					},
					\Pdef, {
						name_popup.items = Pdef.all.keys.asArray;
					}
				);
			};
			name_popup.items = type_popup.items[type_popup.value].asClass.all.keys.asArray;
			name_popup.action = {
				var curname = name_popup.items[name_popup.value];
				switch( type_popup.items[type_popup.value],
					\Ndef, {
						model[\nodeType] = \eventlist;
						model[\eventType] = nil;
						model[\type] = \player;
						model[\receiver] = Ref(Ndef(curname));
						model[\method] = \play;
						//model[\label] = curname;
						model[\label] = ~get_label;
						//model.changed(\refresh);
						self.parent_model.changed(\refresh);
					},
					\Pdef, {
						model[\receiver] = nil;
						model[\nodeType] = \eventlist;
						model[\eventType] = \pattern;
						model[\key] = curname;
						//model[\label] = curname;
						model[\label] = ~get_label;
						//model.changed(\refresh);
						self.parent_model.changed(\refresh);
					}
				);
			};

			header = HLayout(
				type_popup,
				name_popup,
			);
			layout = VLayout(
				header,
				editor,
			);

			self.layout = layout;
			self.layout;
		},

		makeWindow: { arg self;
			var window = Window.new;
			var layout;
			layout = self.makeLayout;
			window.layout = layout;
			//window.alwaysOnTop = true;
			window.front;

			self.makeUpdater;
			self.model.changed(\refresh);
		},

	);

	~pdefTimeline = (
		new: { arg self, eventloop;
			self = self.deepCopy;
		
			self.eventloop = eventloop;
			self.area_size = 9@1;
			self.quant_ref = Ref(Point(1/8,1));
			
			Pdef(self.eventloop.key, Plazy({
				//PtimeGatePunch(self.eventloop.list.asPattern.trace(prefix:"xxxxxxxxxxxxxxxxxxxxx"))
				var start, end;
				var eventlist = eventloop.list;
				if(self.cursor.notNil) {
					start = self.cursor.startPosition - eventlist.startTime;
					if(self.cursor.endPosition.notNil) {
						end = self.cursor.endPosition - eventlist.endTime;
					}
				};
				~timeline_pattern.(
					~eventlist_aspattern.(
						self.eventloop.list
					).trace(prefix:"xxxxxxxxxxxxxxxxxxxxx"),
					start, end
				);
				//self.eventloop.list.asPattern.trace(prefix:"xxxxxxxxxxxxxxxxxxxxx")
			}));
		
			self;
		},

		makeWindow: { arg self;
			var window = Window.new;
			var layout;
			layout = self.makeLayout;
			window.layout = layout;
			window.alwaysOnTop = true;
			window.front;	
		},

		add_track: { arg self;
			self.area_size = Point(self.area_size.x, self.area_size.y+1 );
			self.timeline.areasize = self.area_size;
			self.timeline.refreshEventList;
			self.timeline.refresh;
			self.update_track_header;
		},

		update_track_header: { arg self;
			var track_header_block = { arg x;
				var res = View.new.layout_(
					HLayout(
						XSimpleButton.new.label_("track %".format(x))
					)
				);
				//res.background_(Color.blue);
				res;
			};
			self.track_header.canvas_(
				self.track_header_view = View.new.layout_(
					VLayout(*
						self.area_size.y.collect { arg x;
							[
								track_header_block.(x),
								align: \top,
							]
						}
					).spacing_(0).margins_(0)
				);
				self.track_header_view
			).maxWidth_(100);
			self.update_track_header_size;
			self.track_header.onResize = { self.update_track_header_size };
			if(self.track_header_controller.notNil) {
				self.track_header_controller.remove;
			};
			self.track_header_controller = SimpleController(self.timeline)
				.put(\viewport, {
					"update_track_header_size: viewport".debug;
					//TODO: remove controller
					self.update_track_header_size;
				})
				.put(\areasize, {
					"update_track_header_size: areasize".debug;
					self.update_track_header_size;
					//self.update_track_header;
				})
			;
		},

		update_track_header_size: { arg self;
			//self.vrange.view.doAction;
			if(self.timeline.notNil) {
				"update_track_header_size: real updating now!".debug;
				[self.timeline.bounds.height, self.timeline.viewport.height].debug("bh, vh");
				self.track_header_view.fixedHeight = self.timeline.bounds.height / self.timeline.viewport.height;
				self.track_header.visibleOrigin = Point(0,(1-self.timeline.viewport.bottom) * self.track_header.bounds.height);
				self.timeline.viewport.top.debug("top");
[self.timeline.viewport, self.timeline.viewport.bottom, self.track_header.bounds.height, (1-self.timeline.viewport.bottom) * self.track_header.bounds.height].debug("[self.timeline.viewport, self.timeline.viewport.bottom, self.track_header.bounds.height, (1-self.timeline.viewport.bottom) * self.track_header.bounds.height]");
				self.track_header.visibleOrigin.debug("update_track_header_size: visibleOrigin");
			}
		},

		set_xquant: { arg self, quant;
			self.quant_ref.value = Point(quant, self.quant_ref.value.y);
		},

		get_xquant: { arg self;
			self.quant_ref.value.x;
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

			timeline = PdefTimelineView.new;
			~mytl = timeline;
			timeline.mouseDownAction = {|me, px, py, mod, buttonNumber, clickCount, chosennode|
				if(clickCount == 2) {
					if(chosennode.notNil) {
						~clipEditor.new(chosennode.model, self.eventloop.list)
					};
				}
			};

			timeline.quant = self.quant_ref;

			self.cursor = CursorTimeline.new;
			self.cursor.startPosition = self.eventloop.list.startTime;

			cursor_timeline = CursorTimelineView.new;
			~cursor_timeline = cursor_timeline;
			cursor_timeline.mapCursor(self.cursor);
			cursor_timeline.quant = self.quant_ref;


			ruler_x = TimelineRulerView.new;
			//ruler_y = MidinoteTimelineRulerView.new;
			locatorbar = TimelineLocatorBarView.new;
			locatorbar.mapCursor(self.cursor);

			locatorbar.quant = self.quant_ref;

			//ruler_y.mimicTimeline(timeline);
			ruler_x.mimicTimeline(timeline);
			locatorbar.mimicTimeline(timeline);
			cursor_timeline.mimicTimeline(timeline);

			hrange = TimelineScroller.new;
			hrange.mapTimeline(timeline);
			hrange.orientation = \horizontal;
			vrange = TimelineScroller.new;
			vrange.mapTimeline(timeline);
			vrange.orientation = \vertical;
			self.vrange = vrange;

			sizer = 
				HLayout(
					XSimpleButton.new.label_("<").action_({
						var point = 0 - Point(4,0);
						timeline.areasize = timeline.areasize + point;
						timeline.refresh;
					}).fixedSize_(Point(10,20)),
					XSimpleButton.new.label_(">").action_({
						var point = Point(4,0);
						timeline.areasize = timeline.areasize + point;
						timeline.refresh;
					}).fixedSize_(Point(10,20)),
				).spacing_(0)
			;


			track_header = ScrollView.new;
			track_header.hasBorder = false;
			track_header.hasVerticalScroller = false;
			track_header.hasHorizontalScroller = false;
			self.track_header = track_header;
			self.update_track_header;


			vrange.view.addAction({ arg slider;
				self.track_header_view.fixedHeight = 1/slider.range * track_header.bounds.height;
				( 1/slider.range * track_header.bounds.height ).debug("vrange.view.action: fixedHeight");
				track_header.visibleOrigin = Point(0, ( 1-slider.hi ) / slider.range) * track_header.bounds.height;
				( Point(0, ( 1-slider.hi ) / slider.range) * track_header.bounds.height ).debug("vrange.view.action: visibleOrigin");
			});

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
								~zoom_fit.(timeline);
							})
					],
					[
						//ruler_y.view,
						track_header,
						StackLayout(
							cursor_timeline.view,
							timeline.view,
						).mode_(1),
						vrange.view,
					],
					[
						nil,
						hrange.view,
						sizer,
					]
			);
			tl_layout.spacing = 0;

			quant_popup = PopUpMenu.new.items_([
				"1/32",
				"1/16",
				"1/8",
				"1/4",
				"1/2",
				"1",
				"2",
				"4",
				"8",
				"16",
			]).action_({
				self.set_xquant(quant_popup.items[quant_popup.value].interpret)
			});

			quant_popup.items.do({ arg val, x; 
				if( val.interpret.equalWithPrecision( self.get_xquant, 1/32 ) ) {
					quant_popup.value = x;
				};
			});
					//NumberBox.new.mapParam(
					//	Param({
					//		self.get_xquant;
					//	}, { arg val;
					//		self.set_xquant = val;
					//	},
					//))

			layout = VLayout(
				HLayout(
					PlayerWrapperView(Pdef(self.eventloop.key)).view,
					XSimpleButton.new.label_("[]").action_({
						self.cursor.startPosition = self.eventloop.list.startTime;
						Pdef(self.eventloop.key).stop;
						cursor_timeline.stop; // FIXME: should be automatic when stoping Pdef
					}),
					XSimpleButton.new.label_("Add track").action_({
						self.add_track;
					}),
					quant_popup,
				),
				tl_layout,
			);

			size = self.area_size;
			size.debug("size!!!");

			timeline.areasize = size;

			ruler_x.view.minSize = Point(10,10);
			//ruler_y.view.minSize = Point(40,10);
			locatorbar.view.minSize = Point(10,15);

			timeline.mapEventList(eventloop.list);
			cursor_timeline.mapEventList(eventloop.list);
			locatorbar.mapEventList(eventloop.list);

			self.timeline = timeline;
			self.layout = layout;
			"iiAZE".debug;
			layout;
		},

		asPattern: { arg self;
			Pfunc({})
			
		},

		refresh: { arg self;
			self.timeline.mapEventList(self.eventloop.list);
		},
	);
	~pt = ~pdefTimeline.new(XEventLoop(\pdef));
	~pt.makeWindow;
)

/////////////////////////////////////////////////////////////////////

(
Pbind(
	\parent, (
		label: { arg self;
			self[\key] ++ "poooo";
		},
	),
	\key, \yop,

).collect({ arg ev; ev.label.debug("kkk"); ev; }).trace.play;
)

(
	~ev  = (
		parent: ~event_type_eventlist,
		//nodeType: \eventlist,
		eventlist: ~sub,
		sustain: 4.5,
		midinote: 0,
		dur: 7,
	)
	~ev[\nodeType]
	~ev.nodeType
)


(
	Pseq([
		(
			parent: ~event_type_eventlist,
			//nodeType: \eventlist,
			eventlist: ~sub,
			sustain: 4.5,
			midinote: 0,
			dur: 7,
		),
	],1).asStream.nextN(1,Event.default).collect({ arg x; x.parent.keys.debug("x"); x.keys })
)

(
		Pev((
			parent: ~event_type_eventlist,
			//nodeType: \eventlist,
			eventlist: ~sub,
			sustain: 4.5,
			midinote: 0,
			dur: 7,
		)).asStream.next(Event.default)
)
(
	Pseq([
		Pev((
			parent: ~event_type_eventlist,
			//nodeType: \eventlist,
			eventlist: ~sub,
			sustain: 4.5,
			midinote: 0,
			dur: 7,
		))
	],1).asStream.nextN(1,Event.default).collect({ arg x; x.parent.keys.debug("x"); x.keys })
	//],1).asStream.nextN(1,Event.default).collect({ arg x;  x.keys })
)

(
	Pseq([
		Pev((
			parent: ~event_type_eventlist,
			//nodeType: \eventlist,
			eventlist: ~sub,
			sustain: 4.5,
			midinote: 0,
			dur: 7,
		))
		Pevent(
			Pbind(),
			(
				parent: ~event_type_eventlist,
				//nodeType: \eventlist,
				eventlist: ~sub,
				sustain: 4.5,
				midinote: 0,
				dur: 7,
			)
		)
	],1).asStream.nextN(7,Event.default).collect({ arg x; x.parent.keys.debug("x"); x.keys })
)
(
	Pseq([
			Pbind(*[
			parent: ~event_type_eventlist,
			//nodeType: \eventlist,
			eventlist: ~sub,
			sustain: 4.5,
			midinote: 0,
			dur: 7,
		])
	],1).asStream.nextN(7,Event.default).collect({ arg x; x.parent.keys.debug("x"); x.keys })
)
(
	Pseq([
		(
			parent: ~event_type_eventlist,
			//nodeType: \eventlist,
			eventlist: ~sub,
			sustain: 4.5,
			midinote: 0,
			dur: 7,
		),
	],1).asStream.nextN(1,~event_type_eventlist).collect({ arg x; x.parent.keys.debug("x"); x.keys })
)
~event_type_eventlist
Pbind
Padd
