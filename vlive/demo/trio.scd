
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
			time: time,
			l1: l1,
			l2: l2,
			l3: l3,

			p1: p1,
			p2: p2,
			p3: p3,

			o1: o1,
			o2: o2,
			o3: o3,

			r1: r1,
			r2: r2,
			r3: r3,

			f1: f1,
			f2: f2,
			f3: f3,

			ox1: ox1,
			ox2: ox2,
			ox3: ox3,

			oy1: oy1,
			oy2: oy2,
			oy3: oy3,
			perimeter: perimeter,
			area: area,
		).debug("data");

	}
)
(
		~trio.valueWithEnvir((
			time: 0,
			r1: 100,
			ox1: 500,
			oy1: 500,
			f1: 1,

			r2: 100,
			ox2: 200,
			oy2: 500,
			f2: 1/2,

			r3: 100,
			ox3: 300,
			oy3: 300,
			f3: 1/3,

		)); 
);

(
var w, h = 700, v = 700, run = true;
var starttime = TempoClock.default.beats;
w = Window("trio", Rect(40, 40, h, v), false);
w.onClose = { run = false }; // stop the thread on close
w.front;

w.drawFunc = {
    Pen.width = 2;
    Pen.use {
		var trio;
		var time = TempoClock.default.beats - starttime;

		trio = ~trio.valueWithEnvir((
			time: time,
			r1 : 100,
			ox1 : 500,
			oy1 : 500,
			f1 : 1,

			r2 : 100,
			ox2 : 200,
			oy2 : 500,
			f2 : 1/2,

			r3 : 100,
			ox3 : 300,
			oy3 : 300,
			f3 : 1/3,

		)); 

		Pen.line(trio.o1, trio.p1);
		Pen.line(trio.o2, trio.p2);
		Pen.line(trio.o3, trio.p3);

		Pen.addArc(trio.o1, r1,0,2pi);
		Pen.addArc(trio.o2, r2,0,2pi);
		Pen.addArc(trio.o3, r3,0,2pi);

		Pen.line(trio.p1, trio.p2);
		Pen.line(trio.p2, trio.p3);
		Pen.line(trio.p3, trio.p1);
		Pen.stroke;


		Pen
    };
};

// fork a thread to update 20 times a second, and advance the phase each time
{ while { run } { w.refresh; 0.05.wait;} }.fork(AppClock)

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


//////////////////////////////

(
ProtoDef(\trio, (
	r1: 100,
	ox1: 500,
	oy1: 500,
	f1: 1,

	r2: 100,
	ox2: 200,
	oy2: 500,
	f2: 1/2,

	r3: 100,
	ox3: 300,
	oy3: 300,
	f3: 1/3,

	starttime: 0,

	clock: TempoClock.default,
	play: { arg self;
		self.starttime = self.clock.beats;
	},
	stop: { arg self;
		//???
	},

	time:{ arg self;
		self.clock.beats - self.starttime;
	},

	o1: { arg self; Point(self.ox1,self.oy1) },
	o2: { arg self; Point(self.ox2,self.oy2) },
	o3: { arg self; Point(self.ox3,self.oy3) },

	x1: { arg self; self.r1 * sin(2*pi*self.f1*self.time) + self.ox1 },
	y1: { arg self; self.r1 * cos(2*pi*self.f1*self.time) + self.oy1 },

	x2: { arg self; self.r2 * sin(2*pi*self.f2*self.time) + self.ox2 },
	y2: { arg self; self.r2 * cos(2*pi*self.f2*self.time) + self.oy2 },

	x3: { arg self; self.r3 * sin(2*pi*self.f3*self.time) + self.ox3 },
	y3: { arg self; self.r3 * cos(2*pi*self.f3*self.time) + self.oy3 },

	p1: { arg self; Point(self.x1,self.y1) },
	p2: { arg self; Point(self.x2,self.y2) },
	p3: { arg self; Point(self.x3,self.y3) },

	l1: { arg self; self.p1.dist(self.p2) },
	l2: { arg self; self.p2.dist(self.p3) },
	l3: { arg self; self.p3.dist(self.p1) },

	perimeter: { arg self; self.l1 + self.l2 + self.l3 },
	area: { arg self; 
		var per = self.perimeter/2;
		sqrt(per * (per - self.l1) * (per - self.l2) * (per - self.l3)) 
	},

	data: { arg self, time;
		var envir = (parent:self, time: time);
		~trio.valueWithEnvir(envir)
	},
))
)


(
WindowDef(\trio, { arg def, trio;

	var view = UserView.new;
	var w = def.window;
	view.drawFunc = {
		var scale = view.bounds.width/1000;

		Pen.line(trio.o1*scale, trio.p1*scale);
		Pen.line(trio.o2*scale, trio.p2*scale);
		Pen.line(trio.o3*scale, trio.p3*scale);

		Pen.addArc(trio.o1*scale, trio.r1*scale,0,2pi);
		Pen.addArc(trio.o2*scale, trio.r2*scale,0,2pi);
		Pen.addArc(trio.o3*scale, trio.r3*scale,0,2pi);

		Pen.line(trio.p1*scale, trio.p2*scale);
		Pen.line(trio.p2*scale, trio.p3*scale);
		Pen.line(trio.p3*scale, trio.p1*scale);
		Pen.stroke;
	};
	if(w.notNil) {
		{ while { view.isClosed.not } { w.refresh; 0.05.wait;} }.fork(AppClock)
	};
	view;
	
}).front(ProtoDef(\trio))
)

(
Ndef(\trio, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var time = Line.kr(0,800,800) * ProtoDef(\trio).clock.tempo;
	var trio = ProtoDef(\trio).data(time);
	trio.l1.debug("ee");
	sig = SinOsc.ar(freq + trio.l2);
	sig.poll;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

// ca ne marche pas vraiment, il faut ecrire un Ndef qui calculerait en permanence les valeurs et les ecrirais sur des bus
// on peut encapsuler le Ndef dans un ProtoDef pour un acces facile aux bus (quoique les arguments du Ndef sont deja assez pratique, ce qu'il faut par contre, c'est les initialiser)


////////////////////////

