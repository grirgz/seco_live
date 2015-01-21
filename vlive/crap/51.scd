(
	w = Window.new();
	~label = StaticText.new(w, Rect(10,10,200,100));
	w.view.keyDownAction = { |view, char, mod, unicode, keycode, key|
		[view, char, mod, unicode, keycode, key].postln;
		~label.string = [char, mod, unicode, keycode, key].join(", ");
	};
	w.front;
)

(
	w = Window.new();
	~button = Button.new(w);
	~states = [
		["hello", Color.black, Color.white], // normal
		["hello", Color.white, Color.black], // flash
	];

	~button.states = [ ~states[0] ];
	~button.action = { arg but;
		"action!!".postln;
	};
	w.view.keyDownAction = { |view, char, mod, unicode, keycode, key|
		[view, char, mod, unicode, keycode, key].postln;
		~button.valueAction = 0;
		~button.states = [ ~states[1] ];
	};
	w.view.keyUpAction = { |view, char, mod, unicode, keycode, key|
		[view, char, mod, unicode, keycode, key].postln;
		~button.states = [ ~states[0] ];
	};
	w.front;
)
~button.valueAction = 1

(
	w = Window.new();
	w.layout = HLayout.new;
	~canvas = UserView.new;
	w.layout.add(~canvas);
	~maxX = 300;
	~maxY = 300;
	~cellsize = ( 5@5 ) * 3;
	~cellsize = 1@1;
	~canvas.drawFunc = {
		Pen.lineTo(0@0);
		Pen.lineTo(100@100);
		Pen.stroke;
		~curpos = Point(~maxX/2, ~maxY/2);
		~sdirection = Pseq([
			1@0, // right
			0@1, // down
			-1 @ 0, // left
			0@ -1, // up
		],inf).asStream;
		~count = 30;
		~count.do { arg x;
			//x = x +1;
			~direction = ~sdirection.next;
			//if(x == 0) { x = 1 };
			(x/2).asInteger.do { arg y;
				[x,y].debug("x,y");

				[ ~curpos, ~direction ].debug("writing");
				Pen.addRect(Rect(~curpos.x, ~curpos.y, ~cellsize.x, ~cellsize.y));	
				Pen.fillColor = Color(0.00,0.0,1.000*x/~count);
				Pen.fill;
				~curpos = ~curpos + (~direction * ~cellsize);
				[ ~curpos, ~direction ].debug("moving");
				//~curpos = ~curpos + (~direction * ~cellsize)
				//Rect(~curpos.x, ~curpos.y)
			};
			//~curpos = ~curpos + (~direction * ~cellsize);
		};
		Pen.addRect(Rect(1, 1, ~maxX, ~maxY));	
		Pen.stroke;

	};
	w.front;
)

(
~spiral_do = { arg count, fun;
	var direction = 1@0;
	var curpos = 0@0;
	var i = 0;
	count.do { arg x;
		direction = ((0-direction.y)@direction.x);
		(x/2).asInteger.do { arg y;
			fun.(curpos, i);
			i = i + 1;
			curpos = curpos + direction;
		};
	};
};
~spiral_do.(30, { arg x; x.postln; });
)

(
	w = Window.new();
	w.layout = HLayout.new;
	~canvas = UserView.new;
	w.layout.add(~canvas);
	~maxX = 300;
	~maxY = 300;
	~cellsize = ( 5@5 ) * 3;
	//~cellsize = 1@1;
	~canvas.drawFunc = {
		Pen.lineTo(0@0);
		Pen.lineTo(100@100);
		Pen.stroke;
		~curpos = Point(~maxX/2, ~maxY/2);
		~sdirection = Pseq([
			1@0, // right
			0@1, // down
			-1 @ 0, // left
			0@ -1, // up
		],inf).asStream;
		~count = 30;
		~spiral_do.(~count, { arg point, x;
			point = ~curpos + (point * ~cellsize);
			Pen.addRect(Rect(point.x, point.y, ~cellsize.x, ~cellsize.y));	
			Pen.fillColor = Color(0.00,0.0,1.000*x/~count);
			Pen.fill;
		});
		Pen.addRect(Rect(1, 1, ~maxX, ~maxY));	
		Pen.stroke;

	};
	w.front;
)

~direction = 1@0;
~direction = ~direction.rotate(pi/2).round(0.01);
~direction = ((0-~direction.y)@~direction.x);

[1,0] * ( [-1,-1] + 1 ) * -1
[0,1] * ( [1,1] - 1 ) * -1

