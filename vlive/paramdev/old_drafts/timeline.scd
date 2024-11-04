
(
	w = Window.new;
	~layout = HLayout.new;
	w.layout = ~layout;
	~wid = MyWidget.new;
	~layout.add(~wid.view);
	w.front;
	)
(


	w = Window.new(bounds:Rect(800,0,500,700));
	~layout = HLayout.new;
	w.layout = ~layout;
	~wid = TimelineView.new;
	~layout.add(~wid.view);

	~pat = Pbind(
		\instrument, \default,
		//\midinote, Pseq([0,1,2,52,62,120,127],inf),
		\midinote, Pseq([0,1,2,6,12,17,120,125],inf),
		\dur, 1/8,
	);
	//~pat = Pbind(
	//	\instrument, \default,
	//	\midinote, Pseq([0,1],inf),
	//	\dur, 1/8,
	//);

	~notes = ~pat.asStream.nextN(10, Event.default);
	~size = 2@128;
	~time = 0;
	~notesize = 10@10;
	w.front;
	w.alwaysOnTop = true;
	~wid.view.refresh;
	~wid.bounds.debug("bounds");
	~wid.bounds.debug("bounds2");

	//~wid.viewport = Rect(0,0,0.1,0.1);
	~wid.viewport = Rect(0,0,1,1);
	//~wid.viewport = Rect(0,0,1,20/128);
	~wid.areasize = Point(2,128);
	~wid.bounds.debug("bounds");
	~notes.do { arg note;
		//~wid.createNode1(~time/~size.x, ( note[\midinote].debug("ass") /  ~size.y ).debug("what"), 1/8, Color.red);
		~wid.createNode(~time, note[\midinote], 1/8, Color.red);
		~time = ~time + note[\dur];
	};
)

Rect(1,2,10,20) * 2
Rect(0,0,0.1,0.1).extent
Rect(0,0,1,1) / 2

	~wid.viewport = Rect(0,0,1,1); ~wid.refresh;
	~wid.viewport = Rect(1/8 /2,0,1,1); ~wid.refresh;
	~wid.viewport = Rect(0, 110/128,1,1); ~wid.refresh;

(


	w = Window.new(bounds:Rect(800,0,500,700));
	~layout = HLayout.new;
	w.layout = ~layout;
	~vlayout = VLayout.new;
	~wid = TimelineView.new;
	~layout.add(~vlayout);
	~hrange = RangeSlider.new;
	~hrange.orientation = \horizontal;
	~vrange = RangeSlider.new;
	~vrange.orientation = \vertical;
	~layout.add(~vrange);
	~vlayout.add(~wid.view);
	~vlayout.add(~hrange);

	~wid.viewport = Rect(0,0,1,1);
	~vrange.action = { arg slider;
		var range = slider.range.clip(0.0001,1); // prevent division by 0

		[slider.hi, slider.lo, slider.range].debug("slider v");
		~wid.viewport.top = (1-slider.hi) / range;
		~wid.viewport.height = range;
		[~wid.viewport, slider.hi, slider.lo, slider.range].debug("range action");
		~wid.refresh;
	};
	~hrange.action = { arg slider;
		var range = slider.range.clip(0.0001,1); // prevent division by 0
		~wid.viewport.left = slider.lo / range;
		~wid.viewport.width = range;
		[~wid.viewport, slider.hi, slider.lo, slider.range].debug("range action");
		~wid.refresh;
	};

	~pat = Pbind(
		\instrument, \default,
		//\midinote, Pseq([0,1,2,52,62,120,127],inf),
		\midinote, Pseq([0,1,2,6,12,17,120,125],inf),
		\dur, 1/8,
	);
	//~pat = Pbind(
	//	\instrument, \default,
	//	\midinote, Pseq([0,1],inf),
	//	\dur, 1/8,
	//);

	~notes = ~pat.asStream.nextN(10, Event.default);
	~size = 2@128;
	~time = 0;
	~notesize = 10@10;
	w.front;
	w.alwaysOnTop = true;
	~wid.view.refresh;
	~wid.bounds.debug("bounds");
	~wid.bounds.debug("bounds2");

	//~wid.viewport = Rect(0,0,0.1,0.1);
	//~wid.viewport = Rect(0,0,1,20/128);
	~wid.areasize = Point(2,128);
	~wid.bounds.debug("bounds");
	~notes.do { arg note;
		//~wid.createNode1(~time/~size.x, ( note[\midinote].debug("ass") /  ~size.y ).debug("what"), 1/8, Color.red);
		~wid.createNode(~time, note[\midinote], Point(1/8,1), Color.green);
		~time = ~time + note[\dur];
	};
)

~rect = Rect(0,1,2,3)
~rect = Rect(0,0,0,0)
~rect.origin.x = 5
~rect
~rect.top = 1

~wid.pixelRectToNormRect(Rect(300,200, 0,0))
~wid.pixelRectToNormRect(Rect.fromPoints(Point(300,200), Point(0,0)))
Rect.fromPoints(Point(300,200), Point(300,200)+Point(0,0))
DrawGrid.test( \freq.asSpec.grid, \amp.asSpec.grid  );
DrawGrid.test( BlankGridLines.new, \midinote.asSpec.grid  );
DrawGrid.test( ControlSpec(0,2,\lin,0,1,"s").grid, \midinote.asSpec.grid  );
nil.asGrid

\delay.asSpec


// change the model
/////////////////////////////:


(
	~event_rel_to_abs = { arg li;	
		var res = List.new, elm, time;
		0.for(li.size-1) { arg x;
			elm = li[x].copy;
			[x, elm].debug("event_rel_to_abs: iter");
			if(x == 0) {
				elm.time = 0;
			} {
				elm.time = li[x-1].dur + res[x-1].time;
			};
			res.add(elm);
		};
		if(res[0].time == 0 and: {res[0].type == \rest}) {
			//res.debug("event_rel_to_abs: before droping rest");
			res = res.drop(1);
			//res.debug("event_rel_to_abs: after droping rest");
		};
		res;
	};

	~event_abs_to_rel = { arg li;	
		var res = List.new, elm, time;
		0.for(li.size-1) { arg x;
			//x.debug("iter");
			elm = li[x].copy;
			if(x == 0) {
				//elm.time = 0;
			} {
				res[x-1].dur = elm.time - res[x-1].time;
			};
			res.add(elm);
		};
		res;
	};

	~add_start_node = { arg li;
		var res = li.copy;
		var ev;
		if( res[0][\time] != 0 ) {
			ev = (
				time: 0,
				isRest: true,
			);
			res = res.insert(0, ev);
		};
		res;
	};

	~event_sort = { arg list;
		var res = List.new;
		list = list.copy.sort({ arg a,b; a[\time] < b[\time] });
	};


	w = Window.new(bounds:Rect(800,0,500,700));
	~layout = HLayout.new;
	w.layout = ~layout;
	~vlayout = VLayout.new;
	~wid = TimelineView.new;
	~layout.add(~vlayout);
	~hrange = RangeSlider.new;
	~hrange.orientation = \horizontal;
	~vrange = RangeSlider.new;
	~vrange.orientation = \vertical;
	~layout.add(~vrange);
	~vlayout.add(~wid.view);
	~vlayout.add(~hrange);

	~wid.viewport = Rect(0,0,1,1);
	~vrange.action = { arg slider;
		var range = slider.range.clip(0.0001,1); // prevent division by 0
		~wid.viewport.top = (1-slider.hi) / range;
		~wid.viewport.height = range;
		[~wid.viewport, slider.hi, slider.lo, slider.range].debug("range action");
		~wid.refresh;
	};
	~hrange.action = { arg slider;
		var range = slider.range.clip(0.0001,1); // prevent division by 0
		~wid.viewport.left = slider.lo / range;
		~wid.viewport.width = range;
		[~wid.viewport, slider.hi, slider.lo, slider.range].debug("range action");
		~wid.refresh;
	};

	~pat = Pbind(
		\instrument, \default,
		//\midinote, Pseq([0,1,2,52,62,120,127],inf),
		\midinote, Pseq([0,1,2,6,12,17]+40,inf),
		\dur, 1/2,
	);
	//~pat = Pbind(
	//	\instrument, \default,
	//	\midinote, Pseq([0,1],inf),
	//	\dur, 1/8,
	//);

	~notes = ~pat.asStream.nextN(10, Event.default);


	~size = 8@128;
	~time = 0;
	~notesize = 10@10;
	w.front;
	w.alwaysOnTop = true;
	~wid.view.refresh;
	~wid.bounds.debug("bounds");
	~wid.bounds.debug("bounds2");

	//~wid.viewport = Rect(0,0,0.1,0.1);
	//~wid.viewport = Rect(0,0,1,20/128);
	~wid.areasize = ~size;
	~wid.bounds.debug("bounds");
	~model = Dictionary.new;

	~wid.createNodeHook = { arg node, nodeidx;
		var new_event;
		var point;
		var key = \midinote;
		point = ~wid.normPointToGridPoint(node.origin);
		[nodeidx, node.origin, point].debug("createNodeHook");
		new_event = (
			time: point.x,
			sustain: ~wid.normPointToGridPoint(node.extent).x,
		);
		new_event[key] = point.y;
		~model[nodeidx] = new_event;
		~update_event_list.();
	};

	~wid.deleteNodeHook = { arg node, nodeidx;
		[node, nodeidx].debug("deleteNodeHook");
		~model[nodeidx] = nil;
		~update_event_list.();
	};

	~update_event_list = { arg timeline;
		var res;
		res = ~model.values;
		res.debug("update_event_list1");
		res = ~event_sort.(res);
		res.debug("update_event_list2");
		res = ~add_start_node.(res);
		res.debug("update_event_list3");
		res = ~event_abs_to_rel.(res);
		res.debug("update_event_list4");
		res.last[\dur] = ~size.x - res.last[\time];
		~notes = res;
	};

	~wid.nodeTrackAction = { arg node, nodeidx, gnodeloc;
		var point = gnodeloc;
		var key = \midinote;
		[node, nodeidx, point].debug("node, idx, point");
		~model[nodeidx][\time] = point.x;
		~model[nodeidx][key] = point.y;
		~update_event_list.();
	};

	~notes.do { arg note, noteidx;
		var sus;
		sus = note[\legato]*note[\dur];

		note.use{ ~sustain.value }.debug("ssss");
		note[\sustain].asCompileString.debug("sus");
		[~time, note[\midinote], note[\legato]].debug("loop create node: time, midi");
		~wid.createNode(~time, note[\midinote], Point(note.use{~sustain.value},1), Color.green);
		~time = ~time + note[\dur];
	};
)

(
	Pdef(\hey, 
		Pbind(
			\stretch, 1
		) <>
		Plazy({ Pseq(~notes) }).loop
	).play
)
~notes
~model.do ({ arg ev; [ev[\dur], ev[\time], ev[\midinote]].debug("note:") })

~notes.do ({ arg ev; [ev[\time],ev[\dur], ev[\midinote], [ev[\]]].debug("note: time, dur, midi") })
~notes.do ({ arg ev; ev.debug("note:") })

~model.keys

~wid.normPointToGridPoint(~wid.paraNodes[1].nodeloc)

// add graphical resize of sustain
/////////////////////////////:


(
	~event_rel_to_abs = { arg li;	
		var res = List.new, elm, time;
		0.for(li.size-1) { arg x;
			elm = li[x].copy;
			[x, elm].debug("event_rel_to_abs: iter");
			if(x == 0) {
				elm.time = 0;
			} {
				elm.time = li[x-1].dur + res[x-1].time;
			};
			res.add(elm);
		};
		if(res[0].time == 0 and: {res[0].type == \rest}) {
			//res.debug("event_rel_to_abs: before droping rest");
			res = res.drop(1);
			//res.debug("event_rel_to_abs: after droping rest");
		};
		res;
	};

	~event_abs_to_rel = { arg li;	
		var res = List.new, elm, time;
		0.for(li.size-1) { arg x;
			//x.debug("iter");
			elm = li[x].copy;
			if(x == 0) {
				//elm.time = 0;
			} {
				res[x-1].dur = elm.time - res[x-1].time;
			};
			res.add(elm);
		};
		res;
	};

	~add_start_node = { arg li;
		var res = li.copy;
		var ev;
		if( res[0][\time] != 0 ) {
			ev = (
				time: 0,
				isRest: true,
			);
			res = res.insert(0, ev);
		};
		res;
	};

	~event_sort = { arg list;
		var res = List.new;
		list = list.copy.sort({ arg a,b; a[\time] < b[\time] });
	};


	w = Window.new(bounds:Rect(800,0,500,700));
	~layout = HLayout.new;
	w.layout = ~layout;
	~vlayout = VLayout.new;
	~wid = TimelineView.new;
	~layout.add(~vlayout);
	~hrange = RangeSlider.new;
	~hrange.orientation = \horizontal;
	~vrange = RangeSlider.new;
	~vrange.orientation = \vertical;
	~layout.add(~vrange);
	~vlayout.add(~wid.view);
	~vlayout.add(~hrange);

	~wid.viewport = Rect(0,0,1,1);
	~vrange.action = { arg slider;
		var range = slider.range.clip(0.0001,1); // prevent division by 0
		~wid.viewport.top = (1-slider.hi) / range;
		~wid.viewport.height = range;
		[~wid.viewport, slider.hi, slider.lo, slider.range].debug("range action");
		~wid.refresh;
	};
	~hrange.action = { arg slider;
		var range = slider.range.clip(0.0001,1); // prevent division by 0
		~wid.viewport.left = slider.lo / range;
		~wid.viewport.width = range;
		[~wid.viewport, slider.hi, slider.lo, slider.range].debug("range action");
		~wid.refresh;
	};

	~pat = Pbind(
		\instrument, \default,
		//\midinote, Pseq([0,1,2,52,62,120,127],inf),
		\midinote, Pseq([0,1,2,6,12,17]+40,inf),
		\dur, 1/2,
	);
	~pat = Pbind(
		\instrument, \default,
		//\midinote, Pseq([0,1,2,52,62,120,127],inf),
		//\midinote, ~xx.(t)Pseq([0,1,2,6,12,17]+40,inf),
		\midinote, Pseq([0,1,2,6,12,17]+40,inf),
		\dur, 1/2,
	);
	//~pat = Pbind(
	//	\instrument, \default,
	//	\midinote, Pseq([0,1],inf),
	//	\dur, 1/8,
	//);

	~notes = ~pat.asStream.nextN(10, Event.default);


	~size = 8@128;
	~time = 0;
	~notesize = 10@10;
	w.front;
	w.alwaysOnTop = true;
	~wid.view.refresh;
	~wid.bounds.debug("bounds");
	~wid.bounds.debug("bounds2");

	//~wid.viewport = Rect(0,0,0.1,0.1);
	//~wid.viewport = Rect(0,0,1,20/128);
	~wid.areasize = ~size;
	~wid.bounds.debug("bounds");
	~model = Dictionary.new;

	~wid.createNodeHook = { arg node, nodeidx;
		var new_event;
		var point;
		var key = \midinote;
		point = ~wid.normPointToGridPoint(node.origin);
		[nodeidx, node.origin, point].debug("createNodeHook");
		new_event = (
			time: point.x,
			sustain: ~wid.normPointToGridPoint(node.extent).x,
		);
		new_event[key] = point.y;
		~model[nodeidx] = new_event;
		~update_event_list.();
	};

	~wid.deleteNodeHook = { arg node, nodeidx;
		[node, nodeidx].debug("deleteNodeHook");
		~model[nodeidx] = nil;
		~update_event_list.();
	};

	~update_event_list = { arg timeline;
		var res;
		res = ~model.values;
		res.debug("update_event_list1");
		res = ~event_sort.(res);
		res.debug("update_event_list2");
		res = ~add_start_node.(res);
		res.debug("update_event_list3");
		res = ~event_abs_to_rel.(res);
		res.debug("update_event_list4");
		res.last[\dur] = ~size.x - res.last[\time];
		~notes = res;
	};

	~wid.nodeTrackAction = { arg node, nodeidx, gnodeloc;
		var point = gnodeloc;
		var key = \midinote;
		[node, nodeidx, point].debug("node, idx, point");
		~model[nodeidx][\time] = point.x;
		~model[nodeidx][key] = point.y;
		~model[nodeidx][\sustain] = ~wid.normPointToGridPoint(node.extent).x * TempoClock.default.tempo;
		~update_event_list.();
	};

	~notes.do { arg note, noteidx;
		var sus;
		sus = note[\legato]*note[\dur];

		note.use{ ~sustain.value }.debug("ssss");
		note[\sustain].asCompileString.debug("sus");
		[~time, note[\midinote], note[\legato]].debug("loop create node: time, midi");
		~wid.createNode(~time, note[\midinote], Point(note.use{~sustain.value},1), Color.green);
		~time = ~time + note[\dur];
	};
	~wid.enableQuant = false;
) 

(
	Pdef(\hey, 
		Pbind(
			\stretch, 1
		) <>
		Plazy({ Pseq(~notes) }).loop
	).play
)

//////////////////////////////////////////////////
////// encapsulate



(
	~event_rel_to_abs = { arg li;	
		var res = List.new, elm, time;
		0.for(li.size-1) { arg x;
			elm = li[x].copy;
			[x, elm].debug("event_rel_to_abs: iter");
			if(x == 0) {
				elm.time = 0;
			} {
				elm.time = li[x-1].dur + res[x-1].time;
			};
			res.add(elm);
		};
		if(res[0].time == 0 and: {res[0].type == \rest}) {
			//res.debug("event_rel_to_abs: before droping rest");
			res = res.drop(1);
			//res.debug("event_rel_to_abs: after droping rest");
		};
		res;
	};

	~event_abs_to_rel = { arg li;	
		var res = List.new, elm, time;
		0.for(li.size-1) { arg x;
			//x.debug("iter");
			elm = li[x].copy;
			if(x == 0) {
				//elm.time = 0;
			} {
				res[x-1].dur = elm.time - res[x-1].time;
			};
			res.add(elm);
		};
		res;
	};

	~add_start_node = { arg li;
		var res = li.copy;
		var ev;
		if( res[0][\time] != 0 ) {
			ev = (
				time: 0,
				isRest: true,
			);
			res = res.insert(0, ev);
		};
		res;
	};

	~event_sort = { arg list;
		var res = List.new;
		list = list.copy.sort({ arg a,b; a[\time] < b[\time] });
	};


	w = Window.new(bounds:Rect(800,0,500,700));
	~layout = HLayout.new;
	w.layout = ~layout;
	~vlayout = VLayout.new;
	~wid = TimelineView.new;
	~layout.add(~vlayout);
	~hrange = RangeSlider.new;
	~hrange.orientation = \horizontal;
	~vrange = RangeSlider.new;
	~vrange.orientation = \vertical;
	~layout.add(~vrange);
	~vlayout.add(~wid.view);
	~vlayout.add(~hrange);

	~wid.viewport = Rect(0,0,1,1);
	~vrange.action = { arg slider;
		var range = slider.range.clip(0.0001,1); // prevent division by 0
		~wid.viewport.top = (1-slider.hi) / range;
		~wid.viewport.height = range;
		[~wid.viewport, slider.hi, slider.lo, slider.range].debug("range action");
		~wid.refresh;
	};
	~hrange.action = { arg slider;
		var range = slider.range.clip(0.0001,1); // prevent division by 0
		~wid.viewport.left = slider.lo / range;
		~wid.viewport.width = range;
		[~wid.viewport, slider.hi, slider.lo, slider.range].debug("range action");
		~wid.refresh;
	};

	~pat = Pbind(
		\instrument, \default,
		//\midinote, Pseq([0,1,2,52,62,120,127],inf),
		\midinote, Pseq([0,1,2,6,12,17]+40,inf),
		\dur, 1/2,
	);
	~pat = Pbind(
		\instrument, \default,
		//\midinote, Pseq([0,1,2,52,62,120,127],inf),
		//\midinote, ~xx.(t)Pseq([0,1,2,6,12,17]+40,inf),
		\midinote, Pseq([0,1,2,6,12,17]+40,inf),
		\dur, 1/2,
	);
	//~pat = Pbind(
	//	\instrument, \default,
	//	\midinote, Pseq([0,1],inf),
	//	\dur, 1/8,
	//);

	~notes = ~pat.asStream.nextN(10, Event.default);


	~size = 8@128;
	~time = 0;
	~notesize = 10@10;
	w.front;
	w.alwaysOnTop = true;
	~wid.view.refresh;
	~wid.bounds.debug("bounds");
	~wid.bounds.debug("bounds2");

	//~wid.viewport = Rect(0,0,0.1,0.1);
	//~wid.viewport = Rect(0,0,1,20/128);
	~wid.areasize = ~size;
	~wid.bounds.debug("bounds");
	~model = Dictionary.new;

	~wid.createNodeHook = { arg node, nodeidx;
		var new_event;
		var point;
		var key = \midinote;
		point = ~wid.normPointToGridPoint(node.origin);
		[nodeidx, node.origin, point].debug("createNodeHook");
		new_event = (
			time: point.x,
			sustain: ~wid.normPointToGridPoint(node.extent).x,
		);
		new_event[key] = point.y;
		~model[nodeidx] = new_event;
		~update_event_list.();
	};

	~wid.deleteNodeHook = { arg node, nodeidx;
		[node, nodeidx].debug("deleteNodeHook");
		~model[nodeidx] = nil;
		~update_event_list.();
	};

	~update_event_list = { arg timeline;
		var res;
		res = ~model.values;
		res.debug("update_event_list1");
		res = ~event_sort.(res);
		res.debug("update_event_list2");
		res = ~add_start_node.(res);
		res.debug("update_event_list3");
		res = ~event_abs_to_rel.(res);
		res.debug("update_event_list4");
		res.last[\dur] = ~size.x - res.last[\time];
		~notes = res;
	};

	~wid.nodeTrackAction = { arg node, nodeidx, gnodeloc;
		var point = gnodeloc;
		var key = \midinote;
		[node, nodeidx, point].debug("node, idx, point");
		~model[nodeidx][\time] = point.x;
		~model[nodeidx][key] = point.y;
		~model[nodeidx][\sustain] = ~wid.normPointToGridPoint(node.extent).x * TempoClock.default.tempo;
		~update_event_list.();
	};

	~notes.do { arg note, noteidx;
		var sus;
		sus = note[\legato]*note[\dur];

		note.use{ ~sustain.value }.debug("ssss");
		note[\sustain].asCompileString.debug("sus");
		[~time, note[\midinote], note[\legato]].debug("loop create node: time, midi");
		~wid.createNode(~time, note[\midinote], Point(note.use{~sustain.value},1), Color.green);
		~time = ~time + note[\dur];
	};
	~wid.enableQuant = false;
) 

~timeline = EventBuffer.new;
~timeline.edit;
	~pat = Pbind(
		\instrument, \default,
		//\midinote, Pseq([0,1,2,52,62,120,127],inf),
		//\midinote, ~xx.(t)Pseq([0,1,2,6,12,17]+40,inf),
		\midinote, Pseq([0,1,2,6,12,17]+40,inf),
		\dur, 1/2,
	);
~timeline.write(~pat, 10)
~timeline.recordMidi(\piano)

);
(
	Pdef(\hey, 
		Pbind(
			\stretch, 1
		) <>
		~timeline.lazy.loop
	).play
)


EventList
List
ZTimeline.list
ZEventTimeline.seq
PZEventTimeline()

(
(
	midinote:60,
	sustain: 1,
).play
)

EventList


~el = EventList.new;
~el.edit // create a timeline window


- fonctionalités
	- utilisable dans les patterns
	- enregistrement en temps reel
	- utilisable pour les notes mais aussi percu et autres evenements (pattern change, ...)
	- editable en GUI




(
	a = EventList[];

	// add some time-stamped events to it
	a.start;
	a.addEvent((absTime: 0, midinote: 50, sustain:1));    // events should begin with time 0;
	a.addEvent((absTime: 0.3, midinote: 47, sustain:1));
	a.addEvent((absTime: 0.52, midinote: 42, sustain:1));
	a.addEvent((absTime: 0.72, midinote: 52, sustain:1));
	a.addEvent((absTime: 0.93, midinote: 54, sustain:1));
	//a.finish(1.88);
	a.finish(3.88);

)
a.changed(\refresh)
Pn(a).play
(

	w = Window.new(bounds:Rect(800,0,500,700));
	~layout = HLayout.new;
	w.layout = ~layout;
	~vlayout = VLayout.new;
	~wid = TimelineView.new;
	~layout.add(~vlayout);
	~hrange = RangeSlider.new;
	~hrange.orientation = \horizontal;
	~vrange = RangeSlider.new;
	~vrange.orientation = \vertical;
	~layout.add(~vrange);
	~vlayout.add(~wid.view);
	~vlayout.add(~hrange);

	~wid.viewport = Rect(0,0,1,1);
	~vrange.action = { arg slider;
		var range = slider.range.clip(0.0001,1); // prevent division by 0
		~wid.viewport.top = (1-slider.hi) / range;
		~wid.viewport.height = range;
		[~wid.viewport, slider.hi, slider.lo, slider.range].debug("range action");
		~wid.refresh;
	};
	~hrange.action = { arg slider;
		var range = slider.range.clip(0.0001,1); // prevent division by 0
		~wid.viewport.left = slider.lo / range;
		~wid.viewport.width = range;
		[~wid.viewport, slider.hi, slider.lo, slider.range].debug("range action");
		~wid.refresh;
	};

	~size = 8@128;
	~time = 0;
	~notesize = 10@10;
	w.front;
	w.alwaysOnTop = true;
	~wid.view.refresh;
	~wid.bounds.debug("bounds");
	~wid.bounds.debug("bounds2");

	//~wid.viewport = Rect(0,0,0.1,0.1);
	//~wid.viewport = Rect(0,0,1,20/128);
	~wid.areasize = ~size;
	~wid.bounds.debug("bounds");

	~wid.mapEventList(a);
	~wid.refresh;

)


~a = [4,1,3,4]
~a.sort
~a
(
	a = EventList[];

	// add some time-stamped events to it
	a.start;
	a.addEvent((absTime: 0, midinote: 0, sustain:1));    // events should begin with time 0;
	a.addEvent((absTime: 0.52, midinote: 2, sustain:1));
	a.addEvent((absTime: 0.3, midinote: 127, sustain:1));
	a.addEvent((absTime: 0.72, midinote: 128, sustain:1));
	a.addEvent((absTime: 0.93, midinote: 14, sustain:1));
	a.finish(1.88);

)
a.print
a.reorder


(
	a = EventList[];

	// add some time-stamped events to it
	a.start;
	a.addEvent((absTime: 0, midinote: 0, sustain:1));    // events should begin with time 0;
	a.addEvent((absTime: 0.3, midinote: 42, sustain:1));
	a.addEvent((absTime: 0.52, midinote: 20, sustain:1));
	a.addEvent((absTime: 0.72, midinote: 58, sustain:1));
	a.addEvent((absTime: 0.93, midinote: 54, sustain:1));
	a.finish(3.88);

)

EventPattern
Pattern
~s = a.asPattern.asStream
~s.next(Event.default)

(
	
	Pdef(\plop, 
		Pbind(
			\instrument, \plop,
			\lpf, Pseq([1000,2000,300,500,1200,5000,8000],inf),
			\rq, Pseq([0.1,0.7,0.3,0.5,0.3],inf),
			\rq, Ndef(\lfo1, { SinOsc.kr(1/4).range(0.1,1)  }),

			\dist, Ndef(\lfo2, { SinOsc.kr(1/14).range(1,100)  }),
			\adsr, Plazy({ arg ev;
				Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1+1.rand) ],
					[ Env.adsr(0.01+0.1.rand,0.1,0.8,0.1) ],
				],1)
			}).loop,
		) <> Pn(a) 
	).play
)
(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var lfo1;
	var lfo2;
	lfo1 = LFNoise1.kr(2 ! 3).range(1.0,1.5);
	lfo2 = LFNoise1.kr(2 ! 3).range(0.1,1.5);
	lfo1 = XLine.kr(lfo1, 0.1, lfo2);
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpf.kr(800) * lfo1, \rq.kr(0.5));
	sig = (sig * \dist.kr(10) * [1,1.1,0.9] * lfo1).tanh;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan * Rand(rrand(-1,1)/4 ! sig.size), amp).flop;
	sig.debug("sig");
	Out.ar(out, sig);
}).store;
);
a.print


(
a = EventList.newFrom(
	Pbind(
		\midinote, Pseq([40,41,42, 43,48,50],inf),
		\dur, 1/4,
	)
)
)
a.print

(
	~eventfactory = (
		new: { arg self, pat;
			self = self.deepCopy;
		
			self.pat = pat;
			self.resetFactory;
			
		
			self;
		},

		resetFactory: { arg self;
			self.str = self.pat.asStream;
		},

		generateNext: { arg self, index=60, velocity=1;
			var ev = self.str.next(Event.default);
			var xyevent = ();
			"what".debug;
			xyevent[\midinote] = index;
			xyevent[\velocity] = velocity;
			
			[ev, xyevent, ev.copy.putAll(xyevent)];
		},

		voice: { arg self, index, velocity=1;
			var evs = self.generateNext(index);
			var ev = evs[2].copy;
			ev[\latency] = Ref(nil);
			ev.play;
		},

		timeline: { arg self, index, velocity=1;
			var evs = self.generateNext(index, velocity);
			var ev = evs[1];
			ev;
		},

		score: { arg self, index, velocity=1;
			var evs = self.generateNext(index, velocity);
			var ev = evs[0];
			ev;
		}


	);

	~ef = ~eventfactory.new(
		Pbind(
			\instrument, \plop,
			\lpf, Pseq([1000,2000,300,500,1200,5000,8000],inf),
			\rq, Pseq([0.1,0.7,0.3,0.5,0.3],inf),
		)
	);
	~ef.resetFactory;
	~ef.str.next(Event.default);

	~ef.generateNext;
	~ef.voice(60)
	~ef.score
)

(a:1, b:2).putAll((c:122, b:23))



EventLoop(\clip).list


EventLoop(\clip).clear
~timeline.refresh
~timeline.refreshEventList
~timeline.timeline.refreshEventList
		(
		 ~timeline.timeline.mygrid = { arg bounds, areasize, viewport;

							areasize.x * viewport.width 
							+ ( areasize.x * viewport.origin.x ).debug("other end");
			 "FUCKCK".debug;
				DrawGrid(
					//Rect.fromPoints(areasize * viewport.origin, bounds.rightBottom),
					Rect(0 - (viewport.origin.x * bounds.width),0 - (viewport.origin.y * bounds.height), bounds.width / viewport.width, bounds.height / viewport.height),
					
					//Rect(10,0,bounds.width+100,bounds.height), 
					DenseGridLines(ControlSpec(
							0,8,
							//( areasize.x * viewport.origin.x ).debug("start"), 
							//( areasize.x * viewport.origin.x ).debug("end"), 
							\lin,
							0,
							0
					)).density_(1),
					//DenseGridLines(\midinote.asSpec).density_(8).labelDensity_(2)
					MidinoteGridLines(\midinote.asSpec).density_(8).labelDensity_(2)
				);
			};
			~timeline.timeline.refresh;
		)


		(
				DrawGrid.test(
					DenseGridLines(ControlSpec(
							0,8,
							\lin,
							0,
							0
					)).density_(1),
					MidinoteGridLines(\midinote.asSpec).density_(8).labelDensity_(2)
				);
		)




EventLoop(\e).list.print

GridLines

DenseGridLines(\midinote.asSpec).getParams(0,128, 000,1000)
							timeline.refresh;
							MIDIKeyboard.new
							MIDIKeyboard



(
k = MIDIKeyboard.new;

k.keyDownAction_({arg note; "Key down : ".post; note.postln;});

k.keyUpAction_({arg note; "Key up : ".post; note.postln;});

k.keyTrackAction_({arg note; "Key tracking : ".post; note.postln;});

k.showScale([0, 2, 4, 6, 8, 10], 48, Color.new(0.4, 0.6,0.8));
)

(
~tv = {
	var window = Window.new;
	var layout;
	layout = HLayout(
		~t = MIDIKeyboardView.new.view
	);
	window.layout = layout;
	//window.alwaysOnTop = true;
	window.front;
}.value;
)

(
	WindowDef(\pianokeyboard, { arg def, target;
		var kb = MIDIKeyboardView.new;
		if(target.notNil) {
			var player = ~seqPlayerGroup.new(target);
			kb.keyDownAction = { arg midinote;
				player.elAt(midinote).play;
			};
			kb.keyDownAction = { arg midinote, old;
				if(old.notNil) {
					player.elAt(old).stop;
				};
				player.elAt(midinote).play;
			};
			kb.keyUpAction = { arg midinote;
				player.elAt(midinote).stop;
			};
		};
		kb.asView;
	}).front(Pdef(\plop1));

)


/////////////////////////////////


(
Pdef(\plop1, Pbind(
	\instrument, \default,
	\degree, Pseq([0,4,5,8],inf),
	\dur, 1/8,
	\amp, 0.1
)).play;
);

(
Pdef(\plop2, Pbind(
	\instrument, \default,
	\degree, Pseq([0,2],inf),
	\octave, 3,
	\dur, 1/2,
	\amp, 0.1
)).play;
);



(
~build_pspawner = { arg patterns, el;
	Pspawner({ arg sp;
		var seq;
		block { arg break;
			el.list.do { arg ev;
				switch(ev[\type],
					\start, {
						sp.wait(ev[\dur]);
					},
					\end, {
						break.value;
					},
					{
						sp.par(
							Pfindur(
								ev[\sustain], // FIXME: tempo ?
								patterns[ev[\midinote]]
							)
						);
						sp.wait(ev[\dur])
					}
				)
			};
		}
	})
};

~part = [
	Pdef(\plop1),
	Pdef(\plop2),
];
~pat = ~build_pspawner.(~part, EventLoop(\clip));
~pat.play;
)
	~clip_recorder.(EventLoop(\clip));


////////////////////////////////////////////:


(
~build_pspawner = { arg patterns, el;
	Pspawner({ arg sp;
		var seq;
		block { arg break;
			el.list.do { arg ev;
				switch(ev[\type],
					\start, {
						sp.wait(ev[\dur]);
					},
					\end, {
						break.value;
					},
					{
						sp.par(
							Pfindur(
								ev[\sustain], // FIXME: tempo ?
								patterns[ev[\midinote]]
							)
						);
						sp.wait(ev[\dur])
					}
				)
			};
		}
	})
};
	~midinoteTimeline = (
		new: { arg self, eventloop;
			self = self.deepCopy;
		
			self.eventloop = eventloop;
			self.area_size = 8@128;
			
		
			self;
		},

		makeLayout: { arg self;
			var layout;
			var vlayout, timeline, vrange, hrange, size;
			var eventloop = self.eventloop;
			"AZE".debug;
			layout = HLayout.new;
			self.layout = layout;
			vlayout = VLayout.new;
			timeline = TimelineView.new;
			layout.add(vlayout);
			hrange = RangeSlider.new;
			hrange.orientation = \horizontal;
			vrange = RangeSlider.new;
			vrange.orientation = \vertical;
			layout.add(
				VLayout(
					vrange,
					HLayout(
						XSimpleButton.new.label_("<").action_({
							timeline.areasize = timeline.areasize - Point(4,0);
							timeline.refresh;
						}).fixedSize_(Point(10,20)),
						XSimpleButton.new.label_(">").action_({
							timeline.areasize = timeline.areasize + Point(4,0);
							timeline.refresh;
						}).fixedSize_(Point(10,20)),
					).spacing_(0)
				)
			);
			vlayout.add(timeline.view);
			vlayout.add(hrange);

			timeline.viewport = Rect(0,0,1,1);
			vrange.action = { arg slider;
				var range = slider.range.clip(0.0001,1); // prevent division by 0
				timeline.viewport.top = (1-slider.hi) / range;
				timeline.viewport.height = range;
				[timeline.viewport, slider.hi, slider.lo, slider.range].debug("range action");
				timeline.refresh;
			};
			hrange.action = { arg slider;
				var range = slider.range.clip(0.0001,1); // prevent division by 0
				timeline.viewport.left = slider.lo / range;
				timeline.viewport.width = range;
				[timeline.viewport, slider.hi, slider.lo, slider.range].debug("range action");
				timeline.refresh;
			};

			size = self.area_size;
			size.debug("size!!!");
			timeline.view.refresh;
			//timeline.viewport = Rect(0,0,0.1,0.1);
			//timeline.viewport = Rect(0,0,1,20/128);
			timeline.areasize = size;
			timeline.mapEventList(eventloop.list);
			timeline.refresh;
			self.timeline = timeline;
			self.layout = layout;
			"iiAZE".debug;
			layout;
		},

		refresh: { arg self;
			self.timeline.mapEventList(self.eventloop.list);
		},
	);
	~pitch_recorder = { arg eventloop;

		var window = Window.new;
		var layout;
		var recb, stopb, playb;
		var updateRecState = {
			var view = recb;
			if(eventloop.isRecording) {
				view.background = Color.red;
			} {
				view.background = Color.white;
			};
		};
		var timeline;
		var newevent = { arg midival;
			var ev;
			var playev;
						"youfuck!!!".debug;
			ev = (midinote:midival, sustain:1/4);
			playev = ev.copy;
			playev[\latency] = Ref(nil);
			eventloop.recordEvent(ev);
			playev.play;
		};
		"hii	".debug;
		timeline = ~midinoteTimeline.new(eventloop);
		"iihii	".debug;
		//~timeline = timeline;

		layout = 
		VLayout (
			timeline.makeLayout,
			HLayout (
				recb = XSimpleButton.new.action_({ arg view;
					eventloop.startRec(false);
					timeline.refresh;
					updateRecState.();
				})
				.label_("Rec"),
				XSimpleButton.new.action_({
					eventloop.stopRec;
					timeline.refresh;
					updateRecState.();
				})
				.label_("Stop"),
				XSimpleButton.new.action_({
					eventloop.play;
				})
				.label_("Play"),
			),
			HLayout.new(*
				12.collect { arg x;
					var midival = x+0 *2;
					XSimpleButton.new.action_({
						"fuck!!!".debug;
						newevent.(midival);
					})
					.label_(midival.asString)
			
				}
			),
			VLayout (
				Button.new,
				MIDIKeyboardView.new(nil, Rect(0,0,150,150))
					.keyDownAction_({ arg midival;
						newevent.(midival);
					})
					.keyTrackAction_({ arg midival;
						newevent.(midival);
					})
				
				.view.minHeight_(50),
			);


		);
		 timeline.timeline.mygrid = { arg bounds, areasize, viewport;

							areasize.x * viewport.width 
							+ ( areasize.x * viewport.origin.x ).debug("other end");
			 "FUCKCK".debug;
				DrawGrid(
					//Rect.fromPoints(areasize * viewport.origin, bounds.rightBottom),
					Rect(0 - (viewport.origin.x * bounds.width),0 - (viewport.origin.y * bounds.height), bounds.width / viewport.width, bounds.height / viewport.height),
					
					//Rect(10,0,bounds.width+100,bounds.height), 
					DenseGridLines(ControlSpec(
							0,areasize.x,
							//( areasize.x * viewport.origin.x ).debug("start"), 
							//( areasize.x * viewport.origin.x ).debug("end"), 
							\lin,
							0,
							0
					)).density_(1),
					//DenseGridLines(\midinote.asSpec).density_(8).labelDensity_(2)
					MidinoteGridLines(\midinote.asSpec).density_(8).labelDensity_(2)
				);
			};
		"iiiiihii	".debug;

		window.layout = layout;
		window.alwaysOnTop = true;
		window.front;
	};
	~clipTimeline = (
		parent: ~midinoteTimeline,
		new: { arg self, eventloop;
			self = self.deepCopy;
		
			"what ?".debug;
			self.eventloop = eventloop;
			self.area_size = 8@4;
			
		
			self;
		},
	);
	~clip_recorder = { arg eventloop;

		var window = Window.new;
		var layout;
		var recb, stopb, playb;
		var updateRecState = {
			var view = recb;
			if(eventloop.isRecording) {
				view.background = Color.red;
			} {
				view.background = Color.white;
			};
		};
		var timeline;
		var newevent = { arg midival;
			var ev;
			var playev;
						"youfuck!!!".debug;
			ev = (midinote:midival, sustain:1/4);
			playev = ev.copy;
			playev[\latency] = Ref(nil);
			eventloop.recordEvent(ev);
			playev.play;
		};
		"hii	".debug;
		timeline = ~clipTimeline.new(eventloop);
		"iihii	".debug;
		//~timeline = timeline;

		layout = 
		VLayout (
			timeline.makeLayout,
			HLayout (
				recb = XSimpleButton.new.action_({ arg view;
					eventloop.startRec(false);
					timeline.refresh;
					updateRecState.();
				})
				.label_("Rec"),
				XSimpleButton.new.action_({
					eventloop.stopRec;
					timeline.refresh;
					updateRecState.();
				})
				.label_("Stop"),
				XSimpleButton.new.action_({
					eventloop.play;
				})
				.label_("Play"),
			),
			HLayout.new(*
				12.collect { arg x;
					var midival = x+0 *1;
					XSimpleButton.new.action_({
						"fuck!!!".debug;
						newevent.(midival);
					})
					.label_(midival.asString)
			
				}
			),
			VLayout (
				Button.new,
				//MIDIKeyboardView.new(nil, Rect(0,0,150,150))
				//	.keyDownAction_({ arg midival;
				//		newevent.(midival);
				//	})
				//	.keyTrackAction_({ arg midival;
				//		newevent.(midival);
				//	})
				//
				//.view.minHeight_(50),
			);

			~yspec = ControlSpec(0,3, \lin,1);
		 timeline.timeline.mygrid = { arg bounds, areasize, viewport;

							areasize.x * viewport.width 
							+ ( areasize.x * viewport.origin.x ).debug("other end");
			 "FUCKCK".debug;
				DrawGrid(
					//Rect.fromPoints(areasize * viewport.origin, bounds.rightBottom),
					Rect(0 - (viewport.origin.x * bounds.width),0 - (viewport.origin.y * bounds.height), bounds.width / viewport.width, bounds.height / viewport.height),
					
					//Rect(10,0,bounds.width+100,bounds.height), 
					DenseGridLines(ControlSpec(
							0,areasize.x,
							//( areasize.x * viewport.origin.x ).debug("start"), 
							//( areasize.x * viewport.origin.x ).debug("end"), 
							\lin,
							0,
							0
					)).density_(1),
					//DenseGridLines(\midinote.asSpec).density_(8).labelDensity_(2)
					MidinoteGridLines(~yspec).density_(1).labelDensity_(1)
				);
			};

		);
		"iiiiihii	".debug;

		window.layout = layout;
		window.alwaysOnTop = true;
		window.front;
	};
	~timeline_of_timeline = { arg eventloop;
		var window = Window.new;
		var layout;
		var recb, stopb, playb;
		var updateRecState = {
			var view = recb;
			if(eventloop.isRecording) {
				view.background = Color.red;
			} {
				view.background = Color.white;
			};
		};
		var timeline;
		var newevent = { arg midival;
			var ev;
			var playev;
						"youfuck!!!".debug;
			ev = (midinote:midival, sustain:1/4);
			playev = ev.copy;
			playev[\latency] = Ref(nil);
			eventloop.recordEvent(ev);
			playev.play;
		};
		"hii	".debug;
		timeline = ~clipTimeline.new(eventloop);
		"iihii	".debug;
		//~timeline = timeline;

		layout = 
		VLayout (
			HLayout(*
				timeline.area_size.y.collect({ arg x;
					XSimpleButton.new.action_({
						~pitch_recorder.(EventLoop(\pr_+++x))
					}).label_("timeline"+(x+1))
				})
			),
			timeline.makeLayout,
			HLayout (
				recb = XSimpleButton.new.action_({ arg view;
					eventloop.startRec(false);
					timeline.refresh;
					updateRecState.();
				})
				.label_("Rec"),
				XSimpleButton.new.action_({
					eventloop.stopRec;
					timeline.refresh;
					updateRecState.();
				})
				.label_("Stop"),
				XSimpleButton.new.action_({
					eventloop.play;
				})
				.label_("Play"),
			),
			HLayout.new(*
				12.collect { arg x;
					var midival = x+0 *1;
					XSimpleButton.new.action_({
						"fuck!!!".debug;
						newevent.(midival);
					})
					.label_(midival.asString)
			
				}
			),
			VLayout (
				Button.new,
				//MIDIKeyboardView.new(nil, Rect(0,0,150,150))
				//	.keyDownAction_({ arg midival;
				//		newevent.(midival);
				//	})
				//	.keyTrackAction_({ arg midival;
				//		newevent.(midival);
				//	})
				//
				//.view.minHeight_(50),
			);

			~yspec = ControlSpec(0,3, \lin,1);
		 timeline.timeline.mygrid = { arg bounds, areasize, viewport;

							areasize.x * viewport.width 
							+ ( areasize.x * viewport.origin.x ).debug("other end");
			 "FUCKCK".debug;
				DrawGrid(
					//Rect.fromPoints(areasize * viewport.origin, bounds.rightBottom),
					Rect(0 - (viewport.origin.x * bounds.width),0 - (viewport.origin.y * bounds.height), bounds.width / viewport.width, bounds.height / viewport.height),
					
					//Rect(10,0,bounds.width+100,bounds.height), 
					DenseGridLines(ControlSpec(
							0,areasize.x,
							//( areasize.x * viewport.origin.x ).debug("start"), 
							//( areasize.x * viewport.origin.x ).debug("end"), 
							\lin,
							0,
							0
					)).density_(1),
					//DenseGridLines(\midinote.asSpec).density_(8).labelDensity_(2)
					MidinoteGridLines(~yspec).density_(1).labelDensity_(1)
				);
			};

		);
		"iiiiihii	".debug;

		window.layout = layout;
		window.alwaysOnTop = true;
		window.front;
		
	};
	// timeline of eventloops
	~make_timeline_of_eventloops = {
		var window = Window.new;
		var layout;
		var tot;
		var firstel;
		var a;

		a = EventList[];

		// add some time-stamped events to it
		a.start;
		a.addEvent((absTime: 0, midinote: 50, sustain:1/4));    // events should begin with time 0;
		a.addEvent((absTime: 0.3, midinote: 47, sustain:1/4));
		a.addEvent((absTime: 0.52, midinote: 42, sustain:1/4));
		a.addEvent((absTime: 0.72, midinote: 52, sustain:1/4));
		a.addEvent((absTime: 0.93, midinote: 54, sustain:1/4));
		//a.finish(1.88);
		a.finish(1.50);
		firstel = EventLoop.newInstance;
		firstel.list = a;


		tot = EventList[];
		tot.start;
		tot.addEvent((
			absTime: 1, 
			midinote: 1, 
			nodeType: \eventloop,
			eventloop: firstel,
			sustain:4
		)); 
		tot.finish(8);


		~timeline = TimelineView.new;
		~timeline.eventFactory = { arg pos;
			var el = EventLoop.newInstance;
			el.list.start;
			el.list.finish(1);
			(
				absTime: pos.x, 
				label: "unnamed_"++(100.rand),
				midinote: pos.y, 
				nodeType: \eventloop,
				eventloop: el,
				sustain:1/4,
			); 
		};
		~timeline.keyDownAction = { arg me, key, modifiers, unicode, keycode;
			if(key == $e) {
				var el = ~timeline.chosennode.model[\eventloop].debug("EEEEEEEEE");
				~pitch_recorder.(el);

			}
		};
		~timeline.areasize = 10@4;
		~timeline.mapEventList(tot);
		layout = VLayout(
			~timeline.view
		);
		window.layout = layout;
		//window.alwaysOnTop = true;
		window.front;
	};
	~make_timeline_of_eventloops.();
	//~pitch_recorder.(EventLoop(\e));
	//~clip_recorder.(EventLoop(\clip));
	//~timeline_of_timeline.(EventLoop(\tot));
)
EventLoop(\e).list.print

(
Pdef(\plop1, Pbind(
	\instrument, \default,
	\degree, Pseq([0,4,5,8],inf),
	\dur, 1/8,
	\amp, 0.1
)).play;
);

(
Pdef(\plop2, Pbind(
	\instrument, \default,
	\degree, Pseq([0,2],inf),
	\octave, 3,
	\dur, 1/2,
	\amp, 0.1
)).play;
);
(
~part = [
	Pdef(\plop1),
	Pdef(\plop2),
].collect({ arg pat, x;
	Pn(EventLoop(\pr_+++x).list) <> pat
});
~pat = ~build_pspawner.(~part, EventLoop(\tot));
~pat.play;
)



(
var scroll = ScrollView(bounds:Rect(0,0,300,300).center_(Window.availableBounds.center));
var canvas = View();
var layout;
var i = 0;

var makeEntry = {
    var view = View().background_(Color.rand).layout_(
        HLayout(
            TextField().string_( ("This is entry number " + i.asString) ),
            Button().states_([["Delete"]]).action_({view.remove; i = i - 1;})
        )
    );
    i = i + 1;
    view;
};

layout = VLayout();
layout.add ( View().background_(Color.black).layout_(
    HLayout(
        Button().states_([["Add"]]).action_({ layout.insert(makeEntry.(), i) }),
        nil // stretch remaining empty space
    )
));

canvas.layout = layout;
10.do { canvas.layout.add( makeEntry.() ) };
canvas.layout.add(nil); // stretch remaining empty space

scroll.canvas = canvas;
scroll.front;
)


(
w = Window.new;

b = ScrollView(w, Rect(0, 0, 300, 300)).hasBorder_(true);
c = CompositeView(b, Rect(0, 0, 500, 500)); // 'canvas' is this big
c.decorator = FlowLayout(c.bounds); // now we can use a decorator

Slider2D(c, Rect(0, 0, 240, 240));
Slider2D(c, Rect(0, 0, 240, 240));
Slider2D(c, Rect(0, 0, 240, 240));

c.decorator.nextLine;
w.front;
)


(
var drawFunc;
w = Window.new;

a = ScrollView(w, Rect(40, 40, 300, 300));
b = ScrollView(w, Rect(0, 40, 40, 300)).hasHorizontalScroller_(false).hasVerticalScroller_(false);
c = ScrollView(w, Rect(40, 0, 300, 40)).hasHorizontalScroller_(false).hasVerticalScroller_(false);
b.background = Color.grey;
c.background = Color.grey;

d = UserView(a, Rect(0, 0, 620, 620));
e = UserView(b, Rect(0, 0, 40, 630));
f = UserView(c, Rect(0, 0, 630, 40));

a.action = { var origin;
    origin = a.visibleOrigin;
    b.visibleOrigin = 0@(origin.y);
    c.visibleOrigin = (origin.x)@0;
};

drawFunc = {
    30.do({arg i;
        (i+1).asString.drawAtPoint((i+1 * 20)@0, Font("Courier", 9), Color.black);
    });
};

d.drawFunc = {
    Pen.use({
        Pen.translate(0, 5);
        drawFunc.value;
    });
    Pen.translate(15, 0).rotate(0.5pi);
    drawFunc.value;
};

e.drawFunc = {
    Pen.translate(40, 0).rotate(0.5pi);
    drawFunc.value;
};

f.drawFunc = {
    Pen.translate(0, 25);
    drawFunc.value;
};

w.front;
)

(
	
	var window = Window.new;
	var layout;
	var cview = View.new;
	var scrollview;
	cview.layout = VLayout(*
		20.collect({ arg x;
			XSimpleButton.new.label_("bla"+x)
			//.minHeight_(100)
		})
	);
	layout = HLayout(
		scrollview = ScrollView.new.canvas_(cview).hasVerticalScroller_(false)
			.hasBorder_(false),
		XSimpleButton.new.label_("ksdfjksj"),
		UserView.new.background_(Color.blue).fixedWidth_(100),
		RangeSlider.new.orientation_(\vertical).action_({ arg view;
			view.lo.debug("range");
			scrollview.visibleOrigin = Point(0,view.lo * 100);
			//cview.resizeTo( cview.bounds.width,view.range * 100);
			cview.fixedHeight = view.range * 3500;
		
		})
	);
	window.layout = layout;
	//window.alwaysOnTop = true;
	window.front;
)


(
	// timeline preview
	~make = {
		var window = Window.new;
		var layout;

		a = EventList[];

		// add some time-stamped events to it
		a.start;
		a.addEvent((absTime: 0, midinote: 40, sustain:1/4));    // events should begin with time 0;
		a.addEvent((absTime: 0.3, midinote: 42, sustain:1/4));
		a.addEvent((absTime: 0.52, midinote: 46, sustain:1/4));
		a.addEvent((absTime: 0.72, midinote: 52, sustain:1/4));
		a.addEvent((absTime: 0.93, midinote: 54, sustain:1/4));
		//a.finish(1.88);
		a.finish(1.50);


		~timeline = TimelinePreview.new;
		~timeline.mapEventList(a);
		layout = VLayout(
			~timeline.view
		);
		window.layout = layout;
		//window.alwaysOnTop = true;
		window.front;
	};
	~make.();
)

(
	// timeline of timeline with preview in each clip
	~make = {
		var window = Window.new;
		var layout;
		var tot;

		a = EventList[];

		// add some time-stamped events to it
		a.start;
		a.addEvent((absTime: 0, midinote: 40, sustain:1/4));    // events should begin with time 0;
		a.addEvent((absTime: 0.3, midinote: 42, sustain:1/4));
		a.addEvent((absTime: 0.52, midinote: 46, sustain:1/4));
		a.addEvent((absTime: 0.72, midinote: 52, sustain:1/4));
		a.addEvent((absTime: 0.93, midinote: 54, sustain:1/4));
		//a.finish(1.88);
		a.finish(1.50);


		tot = EventList[];
		tot.start;
		tot.addEvent((
			absTime: 1, 
			midinote: 1, 
			nodeType: \eventlist,
			eventlist: a,
			sustain:4
		)); 
		tot.finish(8);


		~timeline = TimelineView.new;
		~timeline.eventFactory = { arg pos;
			var el = EventList.new;
			el.start;
			el.finish(1);
			(
				absTime: pos.x, 
				label: "unnamed_"++(100.rand),
				midinote: pos.y, 
				nodeType: \eventlist,
				eventlist: el,
				sustain:1/4,
			); 
		};
		~timeline.keyDownAction = { arg me, key, modifiers, unicode, keycode;
			if(key == $e) {

			}
		};
		~timeline.areasize = 10@4;
		~timeline.mapEventList(tot);
		layout = VLayout(
			~timeline.view
		);
		window.layout = layout;
		//window.alwaysOnTop = true;
		window.front;
	};
	~make.();
)


(
)

Rect(0,0,-10,-25).leftTop
Rect(0,0,-10,-25).leftBottom

(
w = Window.new.front;
w.view.background_(Color.white);
w.drawFunc = {
    10.do{
        // set the Color
        Pen.color = Color.green(rrand(0.0, 1), rrand(0.0, 0.5));
        Pen.fillRect(
            Rect(0, 0, 0.2, 0.3)
        );
		Pen.scale(2,2);
		//Pen.skew(1.0.rand, 1.0.rand);
        //Pen.perform([\stroke, \fill].choose);
    }
};
w.refresh;
)


(
w = Window.new("Transparency Layer test", Rect(400,400,430,450)).front;
w.drawFunc = {
    Color.blue.setStroke;

    Pen.use {
    Pen.setShadow(2@2, 10, Color.black);
    Pen.beginTransparencyLayer;

    Color.red.setFill;
    Pen.addOval(Rect(20,40,100,100));
    Pen.fill;

    Color.green.setFill;
    Pen.addOval(Rect(30,70,100,100));
    Pen.fill;

    Color.blue.setFill;
    Pen.addOval(Rect(60,40,100,100));
    Pen.fill;

    "With Transparency Layer".drawCenteredIn(Rect(30, 40, 100, 100), Font.default, Color.white);
    Pen.endTransparencyLayer;
    };

    Pen.use {
    Pen.translate(200, 0);
    Pen.setShadow(2@2, 10, Color.black);


    Color.red.setFill;
    Pen.addOval(Rect(20,40,100,100));
    Pen.fill;

    Color.green.setFill;
    Pen.addOval(Rect(30,70,100,100));
    Pen.fill;

    Color.blue.setFill;
    Pen.addOval(Rect(60,40,100,100));
    Pen.fill;

    "Without Transparency Layer".drawCenteredIn(Rect(30, 40, 100, 100), Font.default, Color.white);
    };

    Pen.use {
        Pen.translate(0, 200);
        Pen.setShadow(2@2, 10, Color.black);
        Pen.beginTransparencyLayer;

        Pen.push;
        Pen.addOval(Rect(20,40,170,170));
        Pen.fillAxialGradient(w.view.bounds.leftTop, w.view.bounds.rightBottom, Color.rand, Color.rand);
        Pen.pop;

        "With Transparency Layer".drawCenteredIn(Rect(20,40,170,170), Font.default, Color.white);

        Pen.endTransparencyLayer;
    };

    Pen.use {
        Pen.translate(200, 200);
        Pen.setShadow(2@2, 10, Color.black);
        Pen.addOval(Rect(20,40,170,170));
        Pen.fillAxialGradient(w.view.bounds.leftTop, w.view.bounds.rightBottom, Color.rand, Color.rand);

        "Without Transparency Layer".drawCenteredIn(Rect(20,40,170,170), Font.default, Color.white);
    };
};
w.refresh;
)



(
w = Window.new.front;
w.view.background_(Color.white);
w.drawFunc = {
    // outline the clipping path
	//Pen.use {
	Pen.push;

    Pen.moveTo(110@110);
    Pen.lineTo(290@110);
    Pen.lineTo(290@240);
    Pen.lineTo(110@240);
    Pen.lineTo(110@110);
    // now clip
    Pen.clip;

    // everything else we draw is now clipped
    Pen.fillColor = Color.yellow;
    Pen.fillRect(Rect(0,0,400,400));
    Pen.fillColor = Color.red;
    Pen.moveTo(200@100);

    Pen.lineTo(250@200);
    Pen.lineTo(300@200);
    Pen.lineTo(200@250);
    Pen.lineTo(100@200);
    Pen.lineTo(150@200);

    Pen.fill;
	//};
	Pen.pop;
    //Pen.clip;
	Pen.pop;
	Pen.scale(2,2);
    Pen.moveTo(110@110);
    Pen.lineTo(290@110);
    Pen.lineTo(290@240);
    Pen.lineTo(110@240);
    Pen.lineTo(110@110);
    // now clip
    Pen.clip;
    Pen.lineTo(250@200);
    Pen.lineTo(300@200);
    Pen.lineTo(200@250);
    Pen.lineTo(100@200);
    Pen.lineTo(150@200);

    Pen.fill;
};
w.refresh;
)


EventLoopNode.new

(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1,1.01,1.001, 1+0.1.rand]);
	sig = RLPF.ar(sig, \lpf.kr(400), \rq.kr(0.1));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\plop, 
	Ppar([
		PbindSeqDef(\h1) <>
		Pbind(
			\instrument, \plop,
			\freq, 500,
			\isRest, Pfunc({ arg ev;
				ev[\velo] > 4
			}),
		),
		PbindSeqDef(\h2) <>
		Pbind(
			\freq, 200,
			\isRest, Pfunc({ arg ev;
				//ev[\velo].debug("velo200");
				//(ev[\velo] <= 2).debug("velo200bool");
				ev[\velo] <= 2
			}),
		),
		PbindSeqDef(\h3) <>
		Pbind(
			\freq, 800,
			\isRest, Pfunc({ arg ev;
				//ev[\velo].debug("velo800");
				//(ev[\velo] <= 2).debug("velo800bool");
				ev[\velo] > 6
			}),
		),
		
	].collect({ arg pat;

	
		Pbind(
			\isRest, Pfunc({ arg ev;
				if(ev[\resty] == 0) {
					true
				} {
					ev[\isRest]
				}
			})

		)
		<> pat 
		<> Pn(PbindSeqDef(\heyi,8)) 
		<> Pbind(
			\instrument, \default,
			\velo, Pseq([1,0,4],inf),
			\degree, Pseq([0],inf),
			\dur, 1/8,
			\amp, 0.1
		)

	}))

).play;
);

Param(PbindSeqDef(\heyi), \velo, ControlSpec(0,8,\lin)).edit
Param(PbindSeqDef(\heyi), \lpf, \freq).edit
Param(PbindSeqDef(\heyi), \resty, ControlSpec(0,1,\lin,1)).edit
PbindSeqDef(\heyi).setVal(\velo, List.newFrom(2!8))
PbindSeqDef(\heyi).setVal(\lpf, 600!8)
PbindSeqDef(\heyi).setVal(\resty, 0!32)
PbindSeqDef(\heyi).setVal(\rq, 0.8)
PbindSeqDef(\heyi).get(\velo)
(
ParamGroup([
	Param(PbindSeqDef(\heyi), \velo, ControlSpec(0,8,\lin)),
	Param(PbindSeqDef(\heyi), \lpf, \freq),
	Param(PbindSeqDef(\heyi), \resty, ControlSpec(0,1,\lin,1)),
	Param(PbindSeqDef(\heyi), \rq, \rq),
	Param(PbindSeqDef(\h1), \freq, \freq),
	Param(PbindSeqDef(\h2), \freq, \freq),
	Param(PbindSeqDef(\h3), \freq, \freq),
]).edit
)
nil ? 1

(
Pdef(\bla, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);

Pseq

(
	~list = List[0,1,4,7,8];
Pdef(\plopx, Pbind(
	\instrument, \default,
	\degree, Pseq(~list,inf),
	\dur, 1/4,
	\amp, 0.1
)).play;
);

~list[0] = 14
~list.array = [4,4,4,5,8,9]
List
