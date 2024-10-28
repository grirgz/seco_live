
(
	// problem: y is relative to view but view move
WindowDef(\SplitView, {
	var layout;
	var viewtop = View.new;
	var viewbottom = View.new;
	var border = View.new;
	var clickpos = 0;
	var bottomheight = 100, clickheight = 0;
	viewbottom.fixedHeight = bottomheight;
	viewbottom.background = Color.green;
	border.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		clickpos = y;
		//clickpos = viewbottom.bounds.origin.y + y;
		clickheight = bottomheight;
	}); 
	border.mouseMoveAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseMoveAction");

		[clickpos, y, (clickpos - y)].debug("clickpos");
		bottomheight = clickheight + (clickpos - y);
		viewbottom.fixedHeight = bottomheight;
		
	});
	border.background = Color.red;
	border.fixedHeight = 10;
	layout = VLayout(
		viewtop,
		border,
		viewbottom
	);
	layout

}).front;
)

(
	// using bottom view as mouse receiver
	// same problem but smoother
WindowDef(\SplitView, {
	var layout;
	var viewtop = View.new;
	var viewbottom = View.new;
	var border = View.new;
	var clickpos = 0;
	var bottomheight = 100, clickheight = 0;
	viewbottom.fixedHeight = bottomheight;
	viewbottom.background = Color.green;
	viewbottom.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		clickpos = y;
		//clickpos = viewbottom.bounds.origin.y + y;
		clickheight = bottomheight;
	}); 
	viewbottom.mouseMoveAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseMoveAction");

		//y = view.bounds.origin.
		[clickpos, y, (clickpos - y)].debug("clickpos");
		bottomheight = clickheight + (clickpos - y);
		viewbottom.fixedHeight = bottomheight;
		
	});
	border.background = Color.red;
	border.fixedHeight = 10;
	layout = VLayout(
		viewtop,
		border,
		viewbottom
	);
	layout

}).front;
)

(
	// using mainview
	// smooth !
WindowDef(\SplitView, {
	var layout;
	var viewtop = View.new;
	var viewbottom = View.new;
	var border = View.new;
	var clickpos = 0;
	var bottomheight = 100, clickheight = 0;
	var mainview = View.new;
	viewbottom.fixedHeight = bottomheight;
	viewbottom.background = Color.green;
	mainview.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		clickpos = y;
		//clickpos = viewbottom.bounds.origin.y + y;
		clickheight = bottomheight;
	}); 
	mainview.mouseMoveAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseMoveAction");

		//y = view.bounds.origin.
		[clickpos, y, (clickpos - y)].debug("clickpos");
		bottomheight = clickheight + (clickpos - y);
		viewbottom.fixedHeight = bottomheight;
		
	});
	border.background = Color.red;
	border.fixedHeight = 10;
	layout = VLayout(
		viewtop,
		border,
		viewbottom
	);
	mainview.layout = layout;
	mainview;


}).front;
)

(
	// using mainview, but only accept click in border
	// works and is smooth !
WindowDef(\SplitView, {
	var layout;
	var viewtop = View.new;
	var viewbottom = View.new;
	var border = View.new;
	var clickpos = nil, clickheight = nil;
	var bottomheight = 100;
	var mainview = View.new;
	viewbottom.fixedHeight = bottomheight;
	viewbottom.background = Color.green;
	mainview.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		[border.bounds.origin, border.bounds.extent  ].debug("bouds");
		if(y.inclusivelyBetween(border.bounds.origin.y, border.bounds.origin.y + border.bounds.extent.y)) {
			clickpos = y;
			clickheight = bottomheight;
		};
	}); 
	mainview.mouseUpAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		clickpos = nil;
		clickheight = nil;
	});
	mainview.mouseMoveAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseMoveAction");

		if(clickpos.notNil) {

			//y = view.bounds.origin.
			[clickpos, y, (clickpos - y)].debug("clickpos");
			bottomheight = clickheight + (clickpos - y);
			viewbottom.fixedHeight = bottomheight;
		};
		
	});
	border.background = Color.red;
	border.fixedHeight = 10;
	layout = VLayout(
		viewtop,
		border,
		viewbottom
	);
	mainview.layout = layout;
	mainview;


}).front;
)


/////////
(
	// real class
WindowDef(\SplitView, { arg def, top, bottom, bottomheight=100;
	var layout;
	var viewtop;
	var viewbottom;
	var border = View.new;
	var clickpos = nil, clickheight = nil;
	//var bottomheight = 100;
	var mainview = View.new;
	top = top ?? { HLayout() };
	bottom = bottom ?? { HLayout() };
	if(top.isKindOf(Layout)) {
		viewtop = View.new;
		viewtop.layout = top;
	} {
		viewtop = top;
	};
	if(bottom.isKindOf(Layout)) {
		viewbottom = View.new;
		viewbottom.layout = bottom;
	} {
		viewbottom = bottom;
	};
	viewbottom.fixedHeight = bottomheight;
	viewbottom.background = Color.red;
	mainview.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		[border.bounds.origin, border.bounds.extent  ].debug("bouds");
		if(y.inclusivelyBetween(border.bounds.origin.y, border.bounds.origin.y + border.bounds.extent.y)) {
			clickpos = y;
			clickheight = bottomheight;
		};
	}); 
	mainview.mouseUpAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		clickpos = nil;
		clickheight = nil;
	});
	mainview.mouseMoveAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseMoveAction");

		if(clickpos.notNil) {

			//y = view.bounds.origin.
			[clickpos, y, (clickpos - y)].debug("clickpos");
			bottomheight = clickheight + (clickpos - y);
			viewbottom.fixedHeight = bottomheight;
		};
		
	});
	border.layout = HLayout(StaticText.new.string_("---hello"));
	//border.background = Color.red;
	border.background = Color.grey;
	border.fixedHeight = 4;
	layout = VLayout(
		[viewtop, stretch:10],
		border,
		[viewbottom, stretch:0],
	).margins_(0).spacing_(0);
	mainview.layout = layout;
	mainview;


}).front;
)


(
/// test
WindowDef(\win, { arg def;
	var v1, v2;
	v1 = VLayout(
		BasicButton.new.string_("bla"),
		View.new.background_(Color.green),
		//nil
	);
	v2 = VLayout (
		BasicButton.new.string_("DSF"),
		BasicButton.new.string_("iii"),
		View.new.background_(Color.blue),
	);
	WindowDef(\SplitView).asView( v1, v2 );

	
}).front;
)
