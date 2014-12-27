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
			x.debug("iter");
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

	~event_sort = { arg list;
		var res = List.new;
		list = list.so
	
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
	~model = List.new;

	~wid.createNodeHook = { arg node;
		var new_event;
		var point;
		var key = \midinote;
		point = ~wid.normPointToGridPoint(node.origin.x);
		point.debug("createNodeHook");
		new_event = (
			time: point.x,
		);
		new_event[key] = point.y;
		~model.add(new_event);
		~update_event_list.();
	};

	~update_event_list = { arg timeline;
		~notes = ~event_abs_to_rel.(~model);
	};

	~wid.nodeTrackAction = { arg node;
		var point;
		var key = \midinote;
		~model[node.spritenum][\time] = point.x;
		~model[node.spritenum][key] = point.y;
		~update_event_list.();
	};


	~eventtimeline = (
		~sortEvents = { arg events;
		
		}
	);

	~node_to_model_dict = Dictionary.new;

	~notes.do { arg note, noteidx;
		//~wid.createNode1(~time/~size.x, ( note[\midinote].debug("ass") /  ~size.y ).debug("what"), 1/8, Color.red);
		~wid.createNode(~time, note[\midinote], Point(1/8,1), Color.green);

		~list[noteidx].add(note);
		~time = ~time + note[\dur];
	};
)
