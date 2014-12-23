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
		~wid.createNode(~time, note[\midinote], 1/8, Color.green);
		~time = ~time + note[\dur];
	};
)

~rect = Rect(0,1,2,3)
~rect = Rect(0,0,0,0)
~rect.origin.x = 5
~rect
~rect.top = 1
