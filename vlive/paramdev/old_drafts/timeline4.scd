// in this file, clipTimeline ancient draft
// and PtimeGate testing

Pspawner
XEventLoop(\pdef).list
4*0.125*1
XEventLoop(\pdef).list
XEventLoop(\pdef).list.print
PtimeGatePunch(XEventLoop(\pdef).list.asPattern.trace(prefix:"yyyyyyyyyyyy"), 0).play
PtimeGate(XEventLoop(\pdef).list.asPattern.trace(prefix:"yyyyyyyyyyyy")).play
XEventLoop(\pdef).asPattern
Ptrace
(
Pdef(\plopx, Pbind(
	\instrument, \default,
	\degree, Pseq([0],10),
	\dur, 1,
	\amp, 0.1
)).play;
);
Pdef(\plopx).isPlaying

~el
~el = nil;
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
		\degree, Pseq([1,2,3,4],inf),
	));

	Pdef(\plop2, Pbind(
		\instrument, \plop,
		\isRest, false,
		\ffreq, 2000,
		\dur, 1/8,
		\degree, Pseq([1,2,3,4]+10,inf),
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
				~timeline_pattern.(self.eventloop.list.asPattern.trace(prefix:"xxxxxxxxxxxxxxxxxxxxx"))
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
			ruler_x = TimelineRulerView.new;
			//ruler_y = MidinoteTimelineRulerView.new;
			locatorbar = TimelineLocatorBarView.new;

			//ruler_y.mimicTimeline(timeline);
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
						timeline.view,
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


////////////////////////////////////////////////
/////////////// testing PtimeGate

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



///////////////////////////////

(
Ndef(\syn1, { arg freq=300;
	var sig;
	sig = SinOsc.ar(freq * [1,1.01]);
});
Ndef(\syn2, { arg freq=400;
	var sig;
	sig = LFSaw.ar(freq * [1,1.01]);
});

Ndef(\syn3, { arg freq=400;
	var sig;
	sig = LFSaw.ar(freq * [1,1.01] * ( 1 + ( SinOsc.kr(1/16).lag(4) * 1 )));
});
)

Ndef(\main, Ndef(\syn1));
Ndef(\main).set(\freq, 500)
Ndef(\syn1).set(\freq, 500)

(
Ndef(\main).put(0, Ndef(\syn1));
Ndef(\main).put(1, Ndef(\syn2));
Ndef(\main).put(10, \filter -> { arg in; in * 0.1 });
)
Ndef(\main).put(1, Ndef(\syn3));
Ndef(\main).play;


{ SinOsc.kr(1/8).lag([0,2,4,8]) }.plot(16)

{ LagUD.kr(SinOsc.kr(1/1),0,[0,8]) }.plot(4)



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
],1));

XEventList.newFrom(Pdef(\pscore)).print

Ndef.all[\localhost].envir.keys
