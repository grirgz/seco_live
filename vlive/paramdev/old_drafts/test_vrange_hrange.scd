
(

	~assert_rect_equaliy = { arg a, b, msg;
		if(a == b) {
			[a,b].debug("Assertion equality TRUE, "++msg);
		} {
			[a,b].debug("Assertion equality FALSE, "++msg);
		}
	};

	~test_conversions = { arg tl, grect, gpoint;
		"======= test_conversions".debug;
		grect = grect ? Rect(4,5,1/4,1);
		gpoint = gpoint ? Point(4,5);
		~n_grect = tl.gridRectToNormRect(grect);
		~g_n_grect = tl.normRectToGridRect(~n_grect);
		[grect, ~n_grect, ~g_n_grect].debug("grect, n_grect, g_n_grect");

		~p_n_grect = tl.normRectToPixelRect(~n_grect);
		~n_p_n_grect = tl.pixelRectToNormRect(~p_n_grect);


		[~n_grect, ~p_n_grect, ~n_p_n_grect].debug("~n_grect, ~p_n_grect, ~n_p_n_grect");

		~p_grect = tl.gridRectToPixelRect(grect);
		~g_p_grect = tl.pixelRectToGridRect(~p_grect);

		[~p_n_grect, ~p_grect, grect, ~g_p_grect].debug("~p_n_grect, ~p_grect, grect, ~g_p_grect");

		~assert_rect_equaliy.(grect, ~g_n_grect, "gn");
		~assert_rect_equaliy.(grect, ~g_p_grect, "gp");
		~assert_rect_equaliy.(~n_grect, ~n_p_n_grect, "npn");
		~assert_rect_equaliy.(~p_grect, ~p_n_grect, "png");

		///////////// points

		~n_gpoint = tl.gridPointToNormPoint(gpoint);
		~g_n_gpoint = tl.normPointToGridPoint(~n_gpoint);
		[gpoint, ~n_gpoint, ~g_n_gpoint].debug("gpoint, n_gpoint, g_n_gpoint");

		~p_n_gpoint = tl.normPointToPixelPoint(~n_gpoint);
		~n_p_n_gpoint = tl.pixelPointToNormPoint(~p_n_gpoint);

		[~n_gpoint, ~p_n_gpoint, ~n_p_n_gpoint].debug("~n_gpoint, ~p_n_gpoint, ~n_p_n_gpoint");


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

		[slider.hi, slider.lo, slider.range].debug("slider v");
		//~wid.viewport.top = (1-slider.hi)/ range;
		~wid.viewport.top = slider.lo;
		~wid.viewport.height = range;
		[~wid.viewport, slider.hi, slider.lo, slider.range].debug("range action");
		~wid.refresh;
	};
	~hrange.action = { arg slider;
		var range = slider.range.clip(0.0001,1); // prevent division by 0
		[slider.hi, slider.lo, slider.range].debug("slider h");
		~wid.viewport.left = slider.lo;
		~wid.viewport.width = range;
		[~wid.viewport, slider.hi, slider.lo, slider.range].debug("range action");
		~test_conversions.(~wid);
		~wid.refresh;
	};

	~wid.mouseDownAction = { arg me, px, py;
		var gpoint = Point(px, py);
		~test_conversions.(~wid, nil, gpoint);
	};

	~pat = Pbind(
		\instrument, \default,
		//\midinote, Pseq([0,1,2,52,62,120,127],inf),
		\midinote, Pseq([0,1,2,6,12,17,120,125],inf),
		\dur, 1/8,
	);
	~el = XEventList.newFrom(~pat);
	~wid.mapEventList(~el);
	~size = 2@128;
	~time = 0;
	~notesize = 10@10;
	~wid.areasize = Point(2,128);
	w.front;
	w.alwaysOnTop = true;
	~wid.view.refresh;

	~wid.bounds.debug("bounds");
	~wid.bounds.debug("bounds2");

)

