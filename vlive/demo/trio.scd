
(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var ox1 = 0;
	var oy1 = 0;
	var ox2 = 1;
	var oy2 = 1;
	var ox3 = 2;
	var oy3 = 1;
	var r1 = 1;
	var r2 = 1;
	var r3 = 1;
	var 
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


(
	~trio = { 
		arg time,
			r1 = 100,
			ox1 = 500,
			oy1 = 500,
			f1 = 1,

			r2 = 100,
			ox2 = 200,
			oy2 = 500,
			f2 = 1/2,

			r3 = 100,
			ox3 = 300,
			oy3 = 300,
			f3 = 1/3;

		var x1, y1;
		var x2, y2;
		var x3, y3;

		var o1, o2, o3;
		var p1, p2, p3;

		var l1, l2, l3;
		var perimeter, area;
		var angle1, angle2, angle3;

		o1 = Point(ox1,oy1);
		o2 = Point(ox2,oy2);
		o3 = Point(ox3,oy3);

		x1 = r1 * sin(2*pi*f1*time) + ox1;
		y1 = r1 * cos(2*pi*f1*time) + oy1;

		x2 = r2 * sin(2*pi*f2*time) + ox2;
		y2 = r2 * cos(2*pi*f2*time) + oy2;

		x3 = r3 * sin(2*pi*f3*time) + ox3;
		y3 = r3 * cos(2*pi*f3*time) + oy3;

		p1 = Point(x1,y1);
		p2 = Point(x2,y2);
		p3 = Point(x3,y3);

		l1 = p1.dist(p2);
		l2 = p2.dist(p3);
		l3 = p3.dist(p1);

		perimeter = l1 + l2 + l3;
		area = sqrt(perimeter/2 * (perimeter/2 - l1) * (perimeter/2 - l2) * (perimeter/2 - l3));

		(
			l1: l1,
			l2: l2,
			l3: l3,
			perimeter: perimeter,
			area: area,
		).debug("data");

	}
)

(
var w, h = 700, v = 700, run = true;
var starttime = TempoClock.default.beats;
w = Window("trio", Rect(40, 40, h, v), false);
w.onClose = { run = false }; // stop the thread on close
w.front;

w.drawFunc = {
    Pen.width = 2;
    Pen.use {
		var time = TempoClock.default.beats - starttime;
		var x1, y1;
		var r1 = 100;
		var ox1 = 500;
		var oy1 = 500;
		var f1 = 1;

		var x2, y2;
		var r2 = 100;
		var ox2 = 200;
		var oy2 = 500;
		var f2 = 1/2;

		var x3, y3;
		var r3 = 100;
		var ox3 = 300;
		var oy3 = 300;
		var f3 = 1/3;

		var o1, o2, o3;
		var p1, p2, p3;

		var l1, l2, l3;
		var perimeter, area;
		var angle1, angle2, angle3;

		o1 = Point(ox1,oy1);
		o2 = Point(ox2,oy2);
		o3 = Point(ox3,oy3);

		x1 = r1 * sin(2*pi*f1*time) + ox1;
		y1 = r1 * cos(2*pi*f1*time) + oy1;

		x2 = r2 * sin(2*pi*f2*time) + ox2;
		y2 = r2 * cos(2*pi*f2*time) + oy2;

		x3 = r3 * sin(2*pi*f3*time) + ox3;
		y3 = r3 * cos(2*pi*f3*time) + oy3;

		p1 = Point(x1,y1);
		p2 = Point(x2,y2);
		p3 = Point(x3,y3);

		l1 = p1.dist(p2);
		l2 = p2.dist(p3);
		l3 = p3.dist(p1);

		perimeter = l1 + l2 + l3;
		area = sqrt(perimeter/2 * (perimeter/2 - l1) * (perimeter/2 - l2) * (perimeter/2 - l3));

		(
			l1: l1,
			l2: l2,
			l3: l3,
			perimeter: perimeter,
			area: area,
		).debug("data");

		Pen.line(o1, p1);
		Pen.line(o2, p2);
		Pen.line(o3, p3);

		Pen.addArc(o1, r1,0,2pi);
		Pen.addArc(o2, r2,0,2pi);
		Pen.addArc(o3, r3,0,2pi);

		Pen.line(p1, p2);
		Pen.line(p2, p3);
		Pen.line(p3, p1);
		Pen.stroke;


		Pen
    };
};

// fork a thread to update 20 times a second, and advance the phase each time
{ while { run } { w.refresh; 0.05.wait;} }.fork(AppClock)

)
