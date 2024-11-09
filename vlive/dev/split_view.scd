
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
	var bordertext;
	var borderColor_default = Color.gray(0.7);
	var borderColor_hover = Color.gray(0.5);
	var borderColor_clicked = Color.gray(0.3);
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
			border.background = borderColor_clicked;
		};
	}); 
	mainview.mouseUpAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		clickpos = nil;
		clickheight = nil;
		if(y.inclusivelyBetween(border.bounds.origin.y, border.bounds.origin.y + border.bounds.extent.y)) {
			border.background = borderColor_hover;
		} {
			border.background = borderColor_default;
		};
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
	bordertext = View.new;
	bordertext = StaticText.new.string_("----------------");
	bordertext.stringColor = Color.black;
	bordertext.background = Color.grey(0.9);
	bordertext.align = \center;
	border.layout = HLayout(bordertext).spacing_(0).margins_(3);
	//border.background = Color.red;
	border.background = borderColor_default;
	border.fixedHeight = 8;
	def.windowDo{ arg win; win.acceptsMouseOver = true; };


	border.mouseEnterAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseOverAction");
		view.background = borderColor_hover;
	});
	border.mouseLeaveAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseOverAction");
		view.background = borderColor_default;
	});
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



(
	// split vertically and horizontally
WindowDef(\SplitView, { arg def, direction=\vertical, top, bottom, fixedsize=100;
	var layout;
	var viewtop;
	var viewbottom;
	var border = View.new;
	var clickpos = nil, clicksize = nil;
	//var bottomheight = 100;
	var mainview = View.new;
	var bordertext;
	var borderColor_default = Color.gray(0.7);
	var borderColor_hover = Color.gray(0.5);
	var borderColor_clicked = Color.gray(0.3);
	var layoutClass;
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
	if(direction == \vertical) {
		viewbottom.fixedWidth = fixedsize;
	} {
		viewbottom.fixedHeight = fixedsize;
	};
	viewbottom.background = Color.red;
	mainview.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		[border.bounds.origin, border.bounds.extent  ].debug("bouds");
		if(y.inclusivelyBetween(border.bounds.origin.y, border.bounds.origin.y + border.bounds.extent.y)) {
			clickpos = if(direction == \vertical) { x } { y };
			clicksize = fixedsize;
			border.background = borderColor_clicked;
		};
	}); 
	mainview.mouseUpAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		var pos, coor;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		clickpos = nil;
		clicksize = nil;
		pos = if(direction == \vertical) { x } { y };
		coor = if(direction == \vertical) { \x } { \y };
		if(pos.inclusivelyBetween(border.bounds.origin.perform(coor), border.bounds.origin.perform(coor) + border.bounds.extent.perform(coor))) {
			border.background = borderColor_hover;
		} {
			border.background = borderColor_default;
		};
	});
	mainview.mouseMoveAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseMoveAction");

		if(clickpos.notNil) {

			//y = view.bounds.origin.
			[clickpos, y, (clickpos - y)].debug("clickpos");
			fixedsize = clicksize + (clickpos - if(direction == \vertical) { x } { y });
			if(direction == \vertical) {
				viewbottom.fixedWidth = fixedsize;
			} {
				viewbottom.fixedHeight = fixedsize;
			};
		};
		
	});
	bordertext = View.new;
	//bordertext = StaticText.new.string_("----------------");
	//bordertext.stringColor = Color.black;
	bordertext.background = Color.grey(0.9);
	//bordertext.align = \center;
	border.layout = HLayout(bordertext).spacing_(0).margins_(3);
	//border.background = Color.red;
	border.background = borderColor_default;
	if(direction == \vertical) {
		border.fixedWidth = 8;
	} {
		border.fixedHeight = 8;
	};
	def.windowDo{ arg win; win.acceptsMouseOver = true; };


	border.mouseEnterAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseOverAction");
		view.background = borderColor_hover;
	});
	border.mouseLeaveAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseOverAction");
		view.background = borderColor_default;
	});

	if(direction == \vertical) {
		layoutClass = HLayout;
	} {
		layoutClass = VLayout;
	};

	layout = layoutClass.new(
		[viewtop, stretch:10],
		border,
		[viewbottom, stretch:0],
	).margins_(0).spacing_(0);
	mainview.layout = layout;
	mainview;


}).front(\horizontal);
)


~p = Point(2,4)
~p.perform(\y)

(
	// split vertically and horizontally
	// cleaned
	// almost fixed the bug: when moving border out of window it grow the window size
WindowDef(\SplitView, { arg def, direction=\vertical, top, bottom, fixedsize=100;
	var layout;
	var viewtop;
	var viewbottom;
	var border = View.new;
	var clickpos = nil, clicksize = nil;
	var mainview = View.new;
	var bordertext;
	var borderColor_default = Color.gray(0.9);
	var borderColor_hover = Color.gray(0.5);
	var borderColor_clicked = Color.gray(0.3);
	var borderColor_inside = Color.gray(0.5);
	var bordersize = 7;
	var layoutClass;

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

	if(direction == \vertical) {
		viewbottom.fixedWidth = fixedsize;
	} {
		viewbottom.fixedHeight = fixedsize;
	};

	mainview.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		var pos, coor;
		//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		//[border.bounds.origin, border.bounds.extent  ].debug("bouds");
		pos = if(direction == \vertical) { x } { y };
		coor = if(direction == \vertical) { \x } { \y };
		if(pos.inclusivelyBetween(border.bounds.origin.perform(coor), border.bounds.origin.perform(coor) + border.bounds.extent.perform(coor))) {
			clickpos = if(direction == \vertical) { x } { y };
			clicksize = fixedsize;
			border.background = borderColor_clicked;
		};
	}); 

	mainview.mouseUpAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		var pos, coor;
		//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		clickpos = nil;
		clicksize = nil;
		pos = if(direction == \vertical) { x } { y };
		coor = if(direction == \vertical) { \x } { \y };
		if(pos.inclusivelyBetween(border.bounds.origin.perform(coor), border.bounds.origin.perform(coor) + border.bounds.extent.perform(coor))) {
			border.background = borderColor_hover;
		} {
			border.background = borderColor_default;
		};
	});

	mainview.mouseMoveAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseMoveAction");

		if(clickpos.notNil) {
			var sizehint;

			//y = view.bounds.origin.
			//[clickpos, y, (clickpos - y)].debug("clickpos");
			fixedsize = clicksize + (clickpos - if(direction == \vertical) { x } { y });
			if(direction == \vertical) {
				sizehint = viewbottom.sizeHint.width;
				fixedsize = fixedsize.clip(bordersize, view.bounds.extent.x - ( sizehint+bordersize+10 ));
				viewbottom.fixedWidth = fixedsize;
			} {
				sizehint = viewbottom.sizeHint.height;
				fixedsize = fixedsize.clip(bordersize, view.bounds.extent.y - ( sizehint+bordersize+10 ));
				//viewtop.bounds.height.debug("height");
				viewbottom.fixedHeight = fixedsize;
			};
		};
		
	});

	bordertext = View.new;
	bordertext.background = borderColor_inside;
	border.layout = HLayout(bordertext).spacing_(0).margins_(( bordersize/2 ).asInteger);
	border.background = borderColor_default;
	if(direction == \vertical) {
		border.fixedWidth = bordersize;
	} {
		border.fixedHeight = bordersize;
	};
	def.windowDo{ arg win; win.acceptsMouseOver = true; };


	border.mouseEnterAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseOverAction");
		view.background = borderColor_hover;
	});
	border.mouseLeaveAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseOverAction");
		view.background = borderColor_default;
	});

	if(direction == \vertical) {
		layoutClass = HLayout;
	} {
		layoutClass = VLayout;
	};

	layout = layoutClass.new(
		[viewtop, stretch:10],
		border,
		[viewbottom, stretch:0],
	).margins_(0).spacing_(0);

	mainview.layout = layout;
	mainview;


});
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
	WindowDef(\SplitView).asView(\vertical, v1, v2 );

	
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
	WindowDef(\SplitView).asView(\vertical, v1, v2 );

	
}).front;
)


(
/// test nesting
// stil growing window bug when nested
WindowDef(\win, { arg def;
	var v1, v2;
	v1 = VLayout(
		BasicButton.new.string_("bla"),
		WindowDef(\SplitView).asView(\vertical, 
			VLayout (
				BasicButton.new.string_("hoho"),
				View.new.background_(Color.green),
			),
			VLayout (
				BasicButton.new.string_("h"),
				View.new.background_(Color.green),
			),
		)
		//nil
	);
	v2 = VLayout (
		WindowDef(\SplitView).asView(\horizontal, 
			VLayout (
				BasicButton.new.string_("DSF"),
				View.new.background_(Color.green),
			),
			VLayout (
				BasicButton.new.string_("iii"),
				View.new.background_(Color.green),
			)
		),
		//View.new.background_(Color.blue),
	);
	WindowDef(\SplitView).asView(\vertical, v1, v2 );

	
}).front;
)
