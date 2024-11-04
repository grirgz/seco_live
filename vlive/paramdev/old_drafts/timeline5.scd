///////////////
// in this file, I try to combine multiple timeline into one view and has a common locator bar and scrollbars
// the problem is that everything else is not common : selection, can't move some block on another row
//////////////////////////////

~el = nil;
(
	if(~el.isNil) {
		~el = XEventList.newFrom( 
			
			Pbind(
				\nodeType, \eventlist,
				\label, Pkey(\key),
				\midinote, 0,
			) <>
			Pseq([
			(
				key: \plop2,
				sustain: 2.0,
				dur: 3,
			),
			(
				key: \plop,
				sustain: 0.5,
				dur: 1,
			),
			(
				key: \plop2,
				sustain: 2.0,
				dur: 3,
			),
		],1));

		EventLoop(\pdef).list = ~el;
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

	~pdefTimeline = (
		new: { arg self, eventloop;
			self = self.deepCopy;
		
			self.eventloop = eventloop;
			self.area_size = 9@1;
			
		
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
			var vlayout, timeline, vrange, hrange, size;
			var eventloop = self.eventloop;
			var ruler_x, ruler_y, sizer;
			var locatorbar;
			var sizer_action;
			"AZE".debug;
			layout = HLayout.new;
			self.layout = layout;
			vlayout = VLayout.new;
			layout.add(vlayout);

			timeline = PdefTimelineView.new;
			~mytl = timeline;
			//ruler_x = TimelineRulerView.new;
			////ruler_y = MidinoteTimelineRulerView.new;
			//locatorbar = TimelineLocatorBarView.new;

			////ruler_y.mimicTimeline(timeline);
			//ruler_x.mimicTimeline(timeline);
			//locatorbar.mimicTimeline(timeline);

			//hrange = TimelineScroller.new;
			//hrange.mapTimeline(timeline);
			//hrange.orientation = \horizontal;
			//vrange = TimelineScroller.new;
			//vrange.mapTimeline(timeline);
			//vrange.orientation = \vertical;

			//sizer = 
			//	HLayout(
			//		XSimpleButton.new.label_("<").action_({
			//			var point = 0 - Point(4,0);
			//			timeline.areasize = timeline.areasize + point;
			//			timeline.refresh;
			//		}).fixedSize_(Point(10,20)),
			//		XSimpleButton.new.label_(">").action_({
			//			var point = Point(4,0);
			//			timeline.areasize = timeline.areasize + point;
			//			timeline.refresh;
			//		}).fixedSize_(Point(10,20)),
			//	).spacing_(0);

			//layout = GridLayout.rows(
			//		[
			//			nil,
			//			VLayout(
			//				locatorbar.view,
			//				ruler_x.view,
			//			),
			//			XSimpleButton.new.label_("z")
			//				.maxWidth_(10)
			//				.action_({
			//					~zoom_fit.(timeline);
			//				})
			//		],
			//		[
			//			//ruler_y.view,
			//			nil,
			//			timeline.view,
			//			vrange.view,
			//		],
			//		[
			//			nil,
			//			hrange.view,
			//			sizer,
			//		]
			//);
			layout = HLayout(timeline.view);
			//layout.spacing = 0;

			size = self.area_size;
			size.debug("size!!!");

			timeline.areasize = size;

			//ruler_x.view.minSize = Point(10,10);
			//ruler_y.view.minSize = Point(40,10);
			//locatorbar.view.minSize = Point(10,15);

			timeline.mapEventList(eventloop.list);
			//locatorbar.mapEventList(eventloop.list);

			self.timeline = timeline;
			self.layout = layout;
			"iiAZE".debug;
			layout;
		},

		refresh: { arg self;
			self.timeline.mapEventList(self.eventloop.list);
		},
	);

	~multiTimeline = (
		new: { arg self;
			self = self.deepCopy;
		
			
		
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

		make_vrange: { arg self;
			self.ruler_y_view = RangeSlider.new;
			self.ruler_y_view.action = { arg slider;
				self.timelines_view.fixedHeight = 1/slider.range * self.timelines_scrollview.bounds.height;
				self.timelines_scrollview.visibleOrigin = Point(0, ( 1-slider.hi ) / slider.range) * self.timelines_scrollview.bounds.height;
			
			};
			//~vrange.action = { arg slider;
			//	var range = slider.range.clip(0.0001,1); // prevent division by 0

			//	[slider.hi, slider.lo, slider.range].debug("slider v");
			//	~wid.viewport.top = (1-slider.hi) / range;
			//	~wid.viewport.height = range;
			//	[~wid.viewport, slider.hi, slider.lo, slider.range].debug("range action");
			//	~wid.refresh;
			//};
			
			self.ruler_y_view;
		},

		makeLayout: { arg self;
			var layout;
			var timelines_layout;
			var timelines;
			var vlayout, timeline, vrange, hrange, size;
			var eventloop;
			var ruler_x, ruler_y, sizer;
			var locatorbar;
			var sizer_action;
			var timelines_view;
			var timelines_scrollview;
			timelines = [
				~pdefTimeline.new(EventLoop(\pdef)),
				~pdefTimeline.new(EventLoop(\pdef)),
				~pdefTimeline.new(EventLoop(\pdef)),
				~pdefTimeline.new(EventLoop(\pdef)),
				~pdefTimeline.new(EventLoop(\pdef)),
				~pdefTimeline.new(EventLoop(\pdef)),
				~pdefTimeline.new(EventLoop(\pdef)),
				~pdefTimeline.new(EventLoop(\pdef)),
				~pdefTimeline.new(EventLoop(\pdef)),
			];
			self.timelines = timelines;
			timelines_layout = VLayout(*
				timelines.collect({ arg x; 
					x.makeLayout;
					x.timeline.debug("timeline---");
					//x.timeline.view.minHeight_(100);
					x.layout;
					//View.new.layout_(x.layout).minHeight_(200);
				})
			).spacing_(0).margins_(0);
			timelines_view = View.new.layout_(timelines_layout);
			self.timelines_view = timelines_view;
			//timelines_view = ScrollView.new.layout_(timelines_layout);
			timelines_scrollview = ScrollView.new.canvas_(timelines_view);
			timelines_scrollview.hasBorder = false;
			timelines_scrollview.hasVerticalScroller = false;
			self.timelines_scrollview = timelines_scrollview;

			timeline = timelines[0].timeline;
			eventloop = timelines[0].eventloop;

			"multiTimelines".debug;
			layout = HLayout.new;
			self.layout = layout;
			vlayout = VLayout.new;
			layout.add(vlayout);

			ruler_x = TimelineRulerView.new;
			//ruler_y = MidinoteTimelineRulerView.new;
			locatorbar = TimelineLocatorBarView.new;

			//ruler_y.mimicTimeline(timeline);
			ruler_x.mimicTimeline(timeline);
			locatorbar.mimicTimeline(timeline);
			//timeline.mimicTimeline(timelines[1].timeline);
			//timelines[1].timeline.mimicTimeline(timeline);
			timelines.reduce({ arg a, b; b.timeline.mimicTimeline(a.timeline); a });

			hrange = TimelineScroller.new;
			hrange.mapTimeline(timeline);
			hrange.orientation = \horizontal;
			//vrange = TimelineScroller.new;
			//vrange.mapTimeline(timeline);
			//vrange.orientation = \vertical;
			vrange = self.make_vrange;

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

			layout = GridLayout.rows(
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
						timelines_scrollview,
						//[timelines_view, columns:2],
						vrange,
						//vrange.view,
					],
					[
						nil,
						hrange.view,
						sizer,
					]
			);
			layout.spacing = 0;

			ruler_x.view.minSize = Point(10,10);
			//ruler_y.view.minSize = Point(40,10);
			locatorbar.view.minSize = Point(10,15);

			timeline.mapEventList(eventloop.list);
			locatorbar.mapEventList(eventloop.list);
			//layout = timelines_layout;

			self.layout = layout;
			layout;
		},
		
	);
	~pt = ~multiTimeline.new;
	~pt.makeWindow;

)


////////////////////////////////////////////////
/////////////// testing PtimeGatePunch

(

	(
	SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=4000, rq=0.3;
		var sig, sig1, sig2, sig3;
		sig = LFSaw.ar(freq * [1.01,1,0.99]);
		sig = RLPF.ar(sig, ffreq, rq);
		sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
		sig = Splay.ar(sig, spread, amp, pan);
		Out.ar(out, sig);
	}).add;
	);

	Pdef(\plop, Pbind(
		\instrument, \plop,
		\isRest, false,
		\dur, 1/8,
		\degree, Pseq((0..23),inf),
	));

	Pdef(\plop2, Pbind(
		\instrument, \plop,
		\isRest, false,
		\ffreq, 8000,
		\dur, 1/4,
		\degree, Pseq((0..23)+08,inf),
	));

	Pdef(\plop_amp, Pbind(
		\amp, 0.4,
	));

	Pdef(\plop_ffreq, Pbind(
		\ffreq, Pseq([3550,6700,11000],inf),
		\amp, 0.4,
	));

	Pdef(\plop_ffreq2, Pbind(
		\ffreq, Pseq([3550,6700,11000]/2,inf),
		\amp, 0.4,
	));

Pdef(\pscore, Pseq([
	(
		key: \plop2,
		sustain: 2.0,
		dur: 3,
	),
	(
		key: \plop,
		sustain: 0.5,
		dur: 1,
	),
	(
		key: \plop2,
		sustain: 2.0,
		dur: 3,
	),
],10));

Pdef(\pscore1b, Pseq([
	(
		key: \plop2,
		sustain: 2.0,
		dur: 2,
	),
	(
		key: \plop,
		sustain: 4,
		dur: 4,
	),
],10));

Pdef(\pscore1c, Pseq([
	(
		key: \plop2,
		sustain: 3.0,
		dur: 4,
	),
	(
		key: \plop,
		sustain: 3,
		dur: 4,
	),
],1));

Pdef(\pscore2, Pseq([
	(
		key: \plop_amp,
		sustain: 2,
		dur: 4.5,
	),
	(
		key: \plop_amp,
		sustain: 2.0,
		dur: 4,
	),
],10));

Pdef(\pscore_ffreq, Pseq([
	(
		key: \plop_ffreq,
		sustain: 1,
		dur: 4.5,
	),
	(
		key: \plop_ffreq2,
		sustain: 1.0,
		dur: 4,
	),
],10));


~ppdef = { arg score;
	Prout({ arg ev;
		score.asStream.do ({ arg sev;
			[sev, ev].debug( "ppdef: sev, ev" );
			if(sev[\key].notNil) {
				var wait_time;
				ev = Pfindur(sev.use({sev[\sustain].(sev)}), Pdef(sev[\key])).embedInStream(ev);
				wait_time = sev.use { sev[\dur].(sev) - sev[\sustain].(sev) };
				wait_time.debug("wait_time");
				ev = Event.silent(sev.use({sev[\dur].(sev) - sev[\sustain].(sev)})).embedInStream(ev);
			} {
				debug( "rest" );
				ev = Event.silent(sev.use({sev[\sustain].(sev)})).embedInStream(ev);
			}
		
		}, ev)
	
	})
	
};

//~ppdef.(Pdef(\pscore)).trace.play;
//Pdef(\pscore).trace.play
Pdef(\main, 
	Ptrace(
		//~ppdef.(Pdef(\pscore1c))
		//PtimeGatePunch(Pdef(\pscore1c), 0.5)
		Pfindur(3, PtimeGatePunch(Pdef(\pscore1c), 1.5))
		//PtimeGate(Pdef(\pscore1c))
		//3/ ( 1/4 )
		//9+12
		//<> PtimeGate(Pdef(\pscore1b))
		//<> PtimeGate(Pdef(\pscore_ffreq))
		//<> PtimeGate(Pdef(\pscore2))
	).loop

).play;

//~ev = Event.silent(2).loop.asStream;
//~ev = a
//~ev.next(())

)

Event.partialEvents.playerEvent.eventTypes.keys.do({arg x; x.asCompileString.postln})
Event.partialEvents.playerEvent.eventTypes[\load].asCompileString
Event.partialEvents.playerEvent.eventTypes[\tree].asCompileString
Event.partialEvents.playerEvent.eventTypes[\setProperties].asCompileString
Event.partialEvents.playerEvent.eventTypes[\player].asCompileString



(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Pdef(\startndef, Pbind(
	\type, \setProperties,
	\receiver, Pfunc({Ndef(\plop)}),
	\args, [\play],
	\dur, 1,
)).play;
);

(
Pdef(\startndefxxx, DebugPbind(
	\type, \player,
	//\method, \stop,
	\receiver, Ref(Ndef(\plop)),
	\legato, 0.3,
	\dur, 4,
)).play;
);



Ndef(\lfo1, { SinOsc.ar(XLine.kr(100,500,20))!2 * 0.1 }).play



////////////////////////////////////////////////////////
/// PtimeGatePunch : testing durations



(

	(
	SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=4000, rq=0.3;
		var sig, sig1, sig2, sig3;
		sig = LFSaw.ar(freq * [1.01,1,0.99]);
		sig = RLPF.ar(sig, ffreq, rq);
		sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
		sig = Splay.ar(sig, spread, amp, pan);
		Out.ar(out, sig);
	}).add;
	);

	Pdef(\plop, Pbind(
		\instrument, \plop,
		\isRest, false,
		\dur, 1/4,
		\degree, Pseq((0..3),inf),
	));

	Pdef(\plop2, Pbind(
		\instrument, \plop,
		\isRest, false,
		\ffreq, 8000,
		\dur, 1/8,
		\degree, Pseq((0..3)+08,inf),
	));



Pdef(\pscore1c, Pseq([
	(
		key: \plop,
		sustain: 0.5,
		dur: 4,
	),
	(
		key: \plop2,
		sustain: 3.0,
		dur: 4,
	),
],1));


//~ppdef.(Pdef(\pscore)).trace.play;
//Pdef(\pscore).trace.play
Pdef(\main, 
	Ptrace(
		//~ppdef.(Pdef(\pscore1c))
		//PtimeGatePunch(Pdef(\pscore1c), 0.5)
		//PtimeGatePunch(Pdef(\pscore1c), 0),
		PtimeGatePunch(XEventLoop(\pdef).list.asPattern),
		//PtimeGate(Pdef(\pscore1c))
		//3/ ( 1/4 )
		//9+12
		//<> PtimeGate(Pdef(\pscore1b))
		//<> PtimeGate(Pdef(\pscore_ffreq))
		//<> PtimeGate(Pdef(\pscore2))
	).loop

).play;

//~ev = Event.silent(2).loop.asStream;
//~ev = a
//~ev.next(())

)
