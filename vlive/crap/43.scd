/////////////////////////////////////////////////////////////////
// context menu

(
	// no layout
{
var contextMenu;
   
	w= Window.new().front;
	b= Button()
	.states_([["black", Color.black, Color.white], ["white", Color.white, Color.black]]);
	~b2 = Button()
	.states_([["bxlack", Color.black, Color.white], ["wxhite", Color.white, Color.black]]);
	~hl = HLayout.new;
	w.layout = ~hl;
	~hl.add(b);
	~hl.add(~b2);
   
	contextMenu= {|view, x, y, mod, butNum|
		var menu;
		if(butNum==1, {
			menu= ListView(w, Rect(x+view.bounds.origin.x, y+view.bounds.origin.y, 170, 140))
			.focusLostAction_({menu.remove; })
			.background_(Color.white)
			.items_(["remove", "cancel", "something"])
			.mouseUpAction_({|menu, x, y|
				case {menu.value == 0} { "remove".postln; }
					{menu.value == 1} { "cancelled".postln; }
					{menu.value == 2} { "something".postln; };
				menu.remove;
				view.enabled = true;
			});
			menu.focus;
			w.view.enabled = false;
		});
		if(butNum==0, { menu.remove });
	};
   
	w.view.mouseDownAction = { arg vi;
		w.view.enabled = true;
	};
	b.mouseDownAction = contextMenu;
   
}.value;
)

/////////////////////////////////////////////////////////////////


(
{
var contextMenu;
   
	w= Window.new().front;
	b= Button(w, Rect(100, 100, 200, 200))
	.states_([["black", Color.black, Color.white], ["white", Color.white, Color.black]]);
   
	contextMenu= {|view, x, y, mod, butNum|
		var menu;
		if(butNum==1, {
			menu= ListView(view, Rect(x, y, 170, 140))
			.focusLostAction_({menu.remove; })
			.background_(Color.white)
			.items_(["remove", "cancel", "something"])
			.mouseUpAction_({|menu, x, y|
				case {menu.value == 0} { view.remove }
					{menu.value == 1} { "cancelled".postln; }
					{menu.value == 2} { "something".postln; };
				menu.remove;
			});
			menu.focus;
		});
		if(butNum==0, { menu.remove });
	};
   
	b.mouseDownAction = contextMenu;
   
}.value;
)


(
{
var contextMenu;
   
	w= Window.new().front;
	b= Button.new
	.states_([["black", Color.black, Color.white], ["white", Color.white, Color.black]]);
	~view = Button.new;
	~sl = StackLayout.new;
	~hl = HLayout.new;

	w.layout = ~sl;
	~sl.add(~view);
	~view.layout = ~hl;
	~hl.add(b);
   
	contextMenu= {|view, x, y, mod, butNum|
		var menu;
		if(butNum==1, {
			menu= ListView()
			.focusLostAction_({menu.remove; })
			.background_(Color.white)
			.items_(["remove", "cancel", "something"])
			.mouseUpAction_({|menu, x, y|
				case {menu.value == 0} { view.remove }
					{menu.value == 1} { "cancelled".postln; }
					{menu.value == 2} { "something".postln; };
				menu.remove;
			});
			~sl.add(menu);
			menu.focus;
		});
		if(butNum==0, { menu.remove });
	};
   
	//w.view.mouseDownAction = contextMenu;
	~view.mouseDownAction = contextMenu;
   
}.value;
)

(
{
var contextMenu;
   
	w= Window.new().front;
	b= Button.new
	.states_([["black", Color.black, Color.white], ["white", Color.white, Color.black]]);
	~view = View.new;
	~sl = StackLayout.new;
	~hl = HLayout.new;

	w.layout = ~sl;
	~view.layout = ~hl;
	~hl.add(b);
	~sl.add(~view);
	//~sl.add(StaticText.new.string_("hello"));
	~sl.mode = 1;
   
	~view.mouseMoveAction = { arg view, x, y, modifiers, buttonNumber, clickCount;
		[x, y, modifiers, buttonNumber, clickCount].debug("move");

		~menu.mouseDownEvent (x, y, modifiers, 0, 1)
	};
	contextMenu= {|view, x, y, mod, butNum, click|
		var menu;
		"heeeeeeeeeeeeeeeeppp".debug;
		[x,y, click].debug("click");
		if(butNum==1, {
			~mview= CompositeView.new;
			~menu = ListView(~mview, Rect(x+view.bounds.origin.x,y+view.bounds.origin.y,100,100));
			~mview.mouseDownAction = { arg vi;
				~mview.remove;
			};
			menu = ~menu;
			menu
			.focusLostAction_({~mview.remove; })
			.background_(Color.white)
			.items_(["remove", "cancel", "something"])
			.mouseUpAction_({|menu, x, y|
				case {menu.value == 0} { "noooo".postln; }
					{menu.value == 1} { "cancelled".postln; }
					{menu.value == 2} { "something".postln; };
				~sl.index = 0;
				~mview.remove;
			});
			
			//~menu.moveTo(100,100);
			~menu.maxSize = ~menu.sizeHint;
			~sl.add(~mview);
			~sl.index = 1;
			menu.focus;
		});
		if(butNum==0, { menu.remove });
	};
   
	//w.view.mouseDownAction = contextMenu;
	//~view.mouseDownAction = contextMenu;
	b.mouseDownAction = contextMenu;
   
}.value;
)


~menu.moveTo(10,10);

//////////////////////////////////////////////////////////////////////////////////////////:
// clean implementation

(
~contextMenuView = (
	new: { arg self;
		self = self.deepCopy;
	
		
		self.view = View.new;
		self.stacklayout = StackLayout.new;
		self.stacklayout.add(self.view);
		self.stacklayout.mode = 1;
	
		self;
	},
	layout_: { arg self, val;
		val.debug("layout!!!!");
		self.view.layout = val;
	},
	layout: { arg self, val;
		self.view.layout
	},

	keyResponder: { arg self, item_actions;
		var res;
		var close_menu;
		close_menu = {
			self.mview.remove;
			self.stacklayout.index = 0;
		};

		res = { |view, x, y, mod, butNum, click|
			var menu;
			"heeeeeeeeeeeeeeeeppp".debug;
			[x,y, click].debug("click");
			if(butNum==1, {
				self.mview = CompositeView.new;
				self.menu = ListView(self.mview, Rect(x+view.bounds.origin.x,y+view.bounds.origin.y,100,100));
				self.mview.mouseDownAction = { arg vi;
					close_menu.();
				};
				self.menu
				.focusLostAction_({ close_menu.() })
				.background_(Color.white)
				.items_( item_actions.collect(_.key) )
				.mouseUpAction_({|menu, x, y|
					item_actions[menu.value].value.value;
					close_menu.();
				});
				
				//[self.menu.maxSize, self.menu.sizeHint].debug("11x");
				[self.menu.sizeHint].debug("11x");
				self.menu.fixedSize = self.menu.sizeHint;
				[self.menu.sizeHint].debug("11");
				self.stacklayout.add(self.mview);
				self.stacklayout.index = 1;
				self.menu.focus;
			});
			if(butNum==0, { close_menu.() });
		};
		res;
	}
);

~cm = ~contextMenuView.new;
	w= Window.new().front;
	b= Button.new
	.states_([["black", Color.black, Color.white], ["white", Color.white, Color.black]]);
	w.layout = ~cm.stacklayout;
	~hl = HLayout.new;
	~cm.layout = ~hl;
	~hl.add(b);
	b.mouseDownAction = ~cm.keyResponder([
		"hello" -> { "quoi".postln },
		"bla" -> { "cri".postln },
		"ibla" -> { "criii".postln },
		"ibla" -> { "criii".postln },
		"ibla" -> { "criii".postln },
		"ibla" -> { "criii".postln },
		"iiiiiiiiiiiiiiiiiiiiibla" -> { "criii".postln },
		"ibla" -> { "criii".postln },
		"ibla" -> { "criii".postln },
		"ibla" -> { "criii".postln },
		"ibla" -> { "criii".postln },
	])

)


/////// need a new borderless window because the menu don't pass out the window
// features
// - eat the click which cancel the menu
// - menu size should be auto adapted (seems to don't work)
// - should not be cropped by end of widget or end of window
// - can use layouts (and if possible view)
// - if click is not released, focus mouse (seems not possible)
// - submenus (would be nice, but too much work)

// stacklayout can eat the cancel click but is cropped by window border
// first solution can't use layouts
// window solution can't eat the cancel click
// alpha don't work on window

(
w = Window.new("plop", border:false).front;
w.alpha = 1.0;
)

(
~contextMenuView = (
	new: { arg self;
		self = self.deepCopy;
	
		
		self.view = View.new;
		self.stacklayout = StackLayout.new;
		self.stacklayout.add(self.view);
		self.stacklayout.mode = 1;
	
		self;
	},
	layout_: { arg self, val;
		val.debug("layout!!!!");
		self.view.layout = val;
	},
	layout: { arg self, val;
		self.view.layout
	},

	keyResponder: { arg self, item_actions;
		var res;
		var close_menu;
		close_menu = {
			//self.mview.remove;
			//self.stacklayout.index = 0;
			self.mview.close;
		};

		res = { |view, x, y, mod, butNum, click|
			var menu;
			"heeeeeeeeeeeeeeeeppp".debug;
			[view.bounds, Window.screenBounds,view.mapToGlobal(Point(0,0)), x,y, click].debug("click");
			if(butNum==1, {
				var point;
				var sizeh;
				point = view.mapToGlobal(view.bounds.origin);
				point = Window.screenBounds.extent - view.absoluteBounds.origin;
				point = view.mapToGlobal(Point(x,y));
				point.debug("point");
				//self.mview = Window.new(border:false, bounds:view.mapToGlobal(view.bounds.origin));
				//self.mview = Window.new(border:false, bounds:Rect(point.x+x,point.y+y,100,100));
				//self.mview = Window.new(border:false, bounds:Rect(0,0,100,100));
				self.mview = Window.new(border:false, bounds:Rect(point.x,Window.screenBounds.height-(point.y+100),400,400));
				self.menu = ListView(self.mview, Rect(0,0,100,100));
				self.mview.view.mouseDownAction = { arg vi;
					close_menu.();
				};
				self.menu
				.focusLostAction_({ close_menu.() })
				.background_(Color.white)
				.items_( item_actions.collect(_.key) )
				.mouseUpAction_({|menu, x, y|
					item_actions[menu.value].value.value;
					close_menu.();
				});
				
				sizeh = self.menu.sizeHint.asPoint;
				sizeh.debug("sizeh");
				self.mview.bounds = (Rect(point.x,Window.screenBounds.height-(point.y+sizeh.y),sizeh.x,sizeh.y));
				self.mview.alpha = 0;
				self.menu.bounds = (Rect(0,0,sizeh.x,sizeh.y));
				self.mview.front;
				//[self.menu.maxSize, self.menu.sizeHint].debug("11x");
				[self.menu.sizeHint].debug("11x");
				//self.menu.fixedSize = self.menu.minSizeHint.asPoint;
				self.menu.fixedSize = self.menu.sizeHint.asPoint;
				//self.menu.fixedSize = Point(10,10);
				[self.menu.sizeHint].debug("11");
				//self.stacklayout.add(self.mview);
				//self.stacklayout.index = 1;
				//self.menu.focus;
			});
			if(butNum==0, { close_menu.() });
		};
		res;
	}
);

~cm = ~contextMenuView.new;
	w= Window.new().front;
	w.acceptsClickThrough = false;
	b= Button.new
	.states_([["black", Color.black, Color.white], ["white", Color.white, Color.black]]);
	~hl = HLayout.new;
	w.layout = ~hl;
	~hl.add(b);
	b.mouseDownAction = ~cm.keyResponder([
		"hello" -> { "quoi".postln },
		"bla" -> { "cri".postln },
		//"ibla" -> { "criii".postln },
		//"ibla" -> { "criii".postln },
		//"ibla" -> { "criii".postln },
		//"ibla" -> { "criii".postln },
		//"iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiibla" -> { "criii".postln },
		//"ibla" -> { "criii".postln },
		//"ibla" -> { "criii".postln },
		//"ibla" -> { "criii".postln },
		//"ibla" -> { "criii".postln },
		//"ibla" -> { "criii".postln },
		//"ibla" -> { "criii".postln },
		//"ibla" -> { "criii".postln },
		//"ibla" -> { "criii".postln },
		//"ibla" -> { "criii".postln },
		//"ibla" -> { "criii".postln },
		//"ibla" -> { "criii".postln },
		//"ibla" -> { "criii".postln },
	])

)

//////////////////////////////////////////////////////////////////////////////////////////:
// other stuff

(
var text, canvas;
text = TextView().string_("Hello world!").keyDownAction_({canvas.refresh});
canvas = UserView().acceptsMouse_(false).drawFunc_({
    var b = canvas.bounds();
    var str = text.string;
    Pen.translate( b.center.x, b.center.y );
    Pen.fillColor = text.palette.baseText.alpha_(0.1);
    str.do { |c|
        var x = 40.0.rand + 10.0;
        var r = c.asString.bounds.center_(0@0);
        Pen.push;
        Pen.rotate( 1.0.rand );
        Pen.translate( rand2(-0.3,0.3) * b.width, rand2(-0.3,0.3) * b.width );
        Pen.scale( x, x );
        Pen.stringCenteredIn(c.asString, r);
        Pen.pop;
    }
}).refresh;
w=Window().layout_( StackLayout( canvas, text ).mode_(\stackAll) ).front;
)


(
var colors = [Color.blue, Color.red, Color.green];
a = Window.new;
q = 3;

b = Button(a, Rect(0, 0, 160, 20));

b.states = Array.fill(q, { arg i;
    [i.asString, Color.white, colors.wrapAt(i)]
});

b.action = { arg butt;
    p.visible = false;
    p = c.at(butt.value);
    p.visible = true;
};

c = Array.fill(q, { arg i;
    b = CompositeView(a, Rect(0, 25, 300, 300));
    b.background = colors[i].alpha_(0.2);
    b.visible = false;
    b;
});

5.do{ arg i; Slider(c[0], Rect(10, i * 30 + 10, 150, 25)).value_(1.0.rand) };
5.do{ arg i; Slider(c[1], Rect(i * 30 + 10, 10, 25, 150)).value_(1.0.rand) };
Slider2D(c[2], Rect(10, 10, 155, 150)).x_(1.0.rand).y_(1.0.rand);

p = c.at(0); // previous
p.visible = true; // show first one

a.front;
)


(
w = Window.new.front;
v = CompositeView.new(w, w.view.bounds.insetBy(10)).background_(Color.rand);
v.decorator = FlowLayout(v.bounds);

l = "SUPERCOLLIDER".scramble;
t = Array.fill(9, {arg i; var n, r, q;
    n = CompositeView.new(v, Rect(20, 20, 121, 121)).background_(Color.rand);
    q = StaticText(n, n.bounds.moveTo(0,0).insetBy(25)).string_(l[i]).align_(\center);
    q.enabled = true;
    q.font = Font("Geneva", 10);
    q.background_(Color.rand);
    q.mouseDownAction = {
        n.background_(Color.rand);
        q.font=q.font.size_(5 + q.font.size + 7 % 60)
    };
});
)

(
    b = 1.0;
    a = Image.new(SCDoc.helpSourceDir +/+ "images/Swamp.png");
    r = Rect(20,3,40,40);
    w = Window.new("Image background" /*, textured:false*/ );
    w.view.background_(Color.gray);
    w.view.backgroundImage_(a, 5, b, r);
    w.front;
)

(
    a = Image.new(SCDoc.helpSourceDir +/+ "images/Swamp.png");
    w = Window.new("Image background");
    l = Slider2D.new(w, Rect(10,10,200,200))
        .backgroundImage_( a, 5, 1, Rect(0,0,10,10) );
    w.front;
    a.free; // safe
)

(
    var bounds = Rect(10,10,150,18);
    a = Image.new(SCDoc.helpSourceDir +/+ "images/Swamp.png");
    w = Window.new("Image background");
    l = Slider.new(w, bounds)
//        .backgroundImage_(a);
;
    w.front;
    a.free; // safe
)
