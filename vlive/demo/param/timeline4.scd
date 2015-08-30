
(
	if(~el.isNil) {
		~el = EventList.new;
		a = ~el;
			a.start;
			a.addEvent((absTime: 0, midinote: 50, sustain:1/4));    // events should begin with time 0;
			a.addEvent((absTime: 0.3, midinote: 47, sustain:1/4));
			a.addEvent((absTime: 0.52, midinote: 42, sustain:1/4));
			a.addEvent((absTime: 0.72, midinote: 52, sustain:1/4));
			a.addEvent((absTime: 0.93, midinote: 54, sustain:1/4));
			//a.finish(1.88);
		a.finish(1.50);
		EventLoop(\pdef).list = a;
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
			self.area_size = 8@128;
			
		
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

			timeline = MidinoteTimelineView.new;
			~mytl = timeline;
			ruler_x = TimelineRulerView.new;
			ruler_y = MidinoteTimelineRulerView.new;
			locatorbar = TimelineLocatorBarView.new;

			ruler_y.mimicTimeline(timeline);
			ruler_x.mimicTimeline(timeline);
			locatorbar.mimicTimeline(timeline);

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
						ruler_y.view,
						timeline.view,
						vrange.view,
					],
					[
						nil,
						hrange.view,
						sizer,
					]
			);
			layout.spacing = 0;

			size = self.area_size;
			size.debug("size!!!");

			timeline.areasize = size;

			ruler_x.view.minSize = Point(10,10);
			ruler_y.view.minSize = Point(40,10);
			locatorbar.view.minSize = Point(10,15);

			timeline.mapEventList(eventloop.list);
			locatorbar.mapEventList(eventloop.list);

			self.timeline = timeline;
			self.layout = layout;
			"iiAZE".debug;
			layout;
		},

		refresh: { arg self;
			self.timeline.mapEventList(self.eventloop.list);
		},
	);
	~pt = ~pdefTimeline.new(EventLoop(\pdef));
	~pt.makeWindow;

)


////////////////////////////////////////////////

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
		\degree, Pseq([1,2,3,4],inf),
	));

	Pdef(\plop2, Pbind(
		\instrument, \plop,
		\isRest, false,
		//\ffreq, 2000,
		\dur, 1/4,
		\degree, Pseq([1,2,3,4]+10,inf),
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
		sustain: 2.0,
		dur: 4,
	),
	(
		key: \plop,
		sustain: 2,
		dur: 4,
	),
],10));

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
		PtimeGate(Pdef(\pscore1c))
		<> PtimeGate(Pdef(\pscore1b))
		<> PtimeGate(Pdef(\pscore_ffreq))
		//<> PtimeGate(Pdef(\pscore2))
	)

).play;

//~ev = Event.silent(2).loop.asStream;
//~ev = a
//~ev.next(())

//Pdef(\main, 
//
//	Ptrace(
//
//		Pspawn(
//			Pbind(
//				\pattern, Pfunc({ arg ev; 
//					ev.use({
//						Pfindur( ev[\sustain].(ev), Pdef(ev[\key].(ev)) )
//					})
//				}),
//				\sustain, Pfunc({ arg ev; Pdef(ev[\sustain]) }),
//				\method, \par,
//			)
//			<>
//			Pdef(\pscore)
//		)
//		<>
//		Pspawn(
//			Pbind(
//				\pattern, Pfunc({ arg ev; 
//					ev.use({
//						Pfindur( ev[\sustain].(ev), Pdef(ev[\key].(ev)) )
//					})
//				}),
//				\sustain, Pfunc({ arg ev; Pdef(ev[\sustain]) }),
//				\method, \par,
//			)
//			<>
//			Pdef(\pscore2)
//		)
//
//	)
//
//).play

)

Pdef(\pscore).asStream.do({ arg ev; ev.postln("plop") }, ()).play

(
	////////////////////////////////////////////
	/// 1 in, 2 out: proof that's _impossible_
	////////////////////////////////////////////
	// to output a value, you should call yield, and yield automatically pull a value from the input stream
	// that's why it's Pdrumstep(drumrack, score) and not Pdrumstep(drumrack) <> score
	// note also that Pdrumstep(drumrack) <> score is Pchain(drumrack, score) so finally <> is not so important
	// we should think of it as a banal binary operator or two argument function

	// Pdrumstep take one in and many after

	Pdef(\proof, 
		Ptrace(
			Prout({ arg ev;
				while({ ev.notNil }) {
					(degree: 10).yield;
					ev = ev.yield(ev);
				}
			})
			<>
			Pbind(
				\degree, Pseq([1,2,3,4,5,6,7,8,9]),
				\dur, 1/4,
			)
		)
	
	
	).play;

)


Pseg

(
	Pdef(\yep,
		Pbind(\dur, 1/2)
		<>
		Pstep(
			Pdef(\plop),
			Pseq([1,3,1])
		) 

	)

	.play
)

