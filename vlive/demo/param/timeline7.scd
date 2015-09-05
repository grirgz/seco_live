XEventLoop(\pdef).list.print
XEventLoop(\pdef).list

~str = XEventLoop(\pdef).list.asPattern.asStream
~str.next(Event.default)
//////////////////// cursor
(
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
		~el = XEventList.newFrom( 
			
			Pbind(
				\nodeType, \eventlist,
				\eventType, \pattern,
				\label, Pkey(\key),
			) <>
			Pseq([
			(
				key: \plop2,
				sustain: 0.5,
				midinote: 1,
				dur: 3,
			),
			(
				key: \plop,
				sustain: 0.5,
				midinote: 1,
				dur: 1,
			),
			(
				key: \plop2,
				sustain: 2.0,
				midinote: 1,
				dur: 3,
			),
		],1));

		XEventLoop(\pdef).list = ~el;
	};

	~zoom_fit = { arg timeline;
		var maxy=0, miny=127;
		var range;
		timeline.model.do { arg ev, x;
			var midi = ev.use { ev.midinote };
			[x, maxy, miny, midi, ev].debug("zoom_fit: midi");
			if(midi.notNil) {
				[x, midi].debug("zoom_fit, notnil");
				if(midi > maxy) {
					maxy = midi;
				};
				if(midi < miny) {
					miny = midi;
				};
			}
		};
		[timeline.viewport, timeline.viewport.top, maxy/timeline.areasize.y, timeline.viewport.height, (maxy-miny)/timeline.areasize.y].debug("ZOOM ZOOOOOOOOOOOOOOOOOOOOM viewport before");
		[timeline.areasize].debug("areasize");
		range = (maxy-miny+1)/timeline.areasize.y;
		timeline.viewport.top = (miny/timeline.areasize.y).debug("top");
		timeline.viewport.height = range;

		//timeline.viewport.top = 42/128;
		//timeline.viewport.height = ((54-42)/128);

		timeline.viewport.debug("ZOOM ZOOOOOOOOOOOOOOOOOOOOM viewport");

		timeline.changed(\viewport);
		timeline.refresh;
	};

	/*
	a = Rect(0,0,1,1)
	a.top
	a.top = 0.2
	a
	a.bottom 
	a.bottom = 0.3
	a.height = 0.1
	*/

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
						model[\type] = \player;
						model[\receiver] = Ref(Ndef(curname));
						model[\method] = \play;
						model[\label] = curname;
						//model.changed(\refresh);
						self.parent_model.changed(\refresh);
					},
					\Pdef, {
						model[\nodeType] = \eventlist;
						model[\eventType] = \pattern;
						model[\key] = curname;
						model[\label] = curname;
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
			self.area_size = 9@2;
			
			Pdef(self.eventloop.key, Plazy({
				//PtimeGatePunch(self.eventloop.list.asPattern.trace(prefix:"xxxxxxxxxxxxxxxxxxxxx"))
				//~timeline_pattern.(self.eventloop.list.asPattern.trace(prefix:"xxxxxxxxxxxxxxxxxxxxx"))
				self.eventloop.list.asPattern.trace(prefix:"xxxxxxxxxxxxxxxxxxxxx")
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

		makeLayout: { arg self;
			var layout;
			var tl_layout;
			var vlayout, timeline, vrange, hrange, size;
			var eventloop = self.eventloop;
			var ruler_x, ruler_y, sizer;
			var locatorbar;
			var sizer_action;
			var cursor_timeline;
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

			cursor_timeline = CursorTimelineView.new;
			~cursor_timeline = cursor_timeline;


			ruler_x = TimelineRulerView.new;
			//ruler_y = MidinoteTimelineRulerView.new;
			locatorbar = TimelineLocatorBarView.new;

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
				).spacing_(0);

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
						nil,
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

			layout = VLayout(
				PlayerWrapperView(Pdef(self.eventloop.key)).view,
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

////////////////////////////////////////////////////

(
	{
		var window = Window.new;
		var layout;
		layout = VLayout(
			StackLayout(
				UserView.new.drawFunc_({
					Pen.line(Point(60,0), Point(100,100));
					Pen.stroke
				}),
				UserView.new.drawFunc_({
					Pen.line(Point(0,0), Point(100,100));
					Pen.stroke
				}),
				//UserView.new,
			).mode_(1)
		);
		window.layout = layout;
		//window.alwaysOnTop = true;
		window.front;
	}.value
)

~cursor_timeline.play
