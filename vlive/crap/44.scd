// animation in function of sound


(
var width = 400, height = 400, mx = 0, my = 0, pt, r;

w = Window("animation and mouse interaction", Rect(100, 200, width, height), false);

u = UserView(w, Rect(0, 0, width, height));
u.background = Color.black;
u.animate = true; //animate this view

// allocate data in advance, for optimization:
pt = Point();
r = Rect();

u.drawFunc = {
    Pen.fillColor = Color.green;
    Pen.stringAtPoint(u.frameRate.asString, Point(10, 10)); // display frame rate
    Pen.stringAtPoint(u.frame.asString, Point(10, 30)); // display frame counter
    Pen.color = Color.white;
    pt.x=mx;
    pt.y=my;
    100.do{|i|
        Pen.moveTo(pt);
        pt.x = sin(u.frame*0.04.neg+i)*(5*i)+mx; //use .frame to drive animation
        pt.y = cos(u.frame*0.05+i)*(5*i)+my;
        r.left=pt.x;
        r.top=pt.y;
        r.width=i;
        r.height=i;
        Pen.lineTo(pt);
        Pen.fillStroke;
        Pen.addOval(r);
        Pen.fillStroke;
    };
};
u.mouseDownAction = {|v, x, y|
    mx = x;
    my = y;
};
u.mouseMoveAction = u.mouseDownAction;
w.front;
)

u.animate = false; //animation can be paused and resumed
u.animate = true;
w.close; //stops animation

///////////////////////////////////////////////////////////////////
(
var width = 400, height = 400, mx = 0, my = 0, pt, r;

w = Window("animation and mouse interaction", Rect(100, 200, width, height), false);

u = UserView(w, Rect(0, 0, width, height));
u.background = Color.black;
u.animate = true; //animate this view

// allocate data in advance, for optimization:
pt = Point();
r = Rect();
~pt = pt;
~mx = mx;
~my = my;
~r = r;

u.drawFunc = {
    Pen.fillColor = Color.green;
    Pen.stringAtPoint(u.frameRate.asString, Point(10, 10)); // display frame rate
    Pen.stringAtPoint(u.frame.asString, Point(10, 30)); // display frame counter
    Pen.color = Color.white;
    pt.x=mx;
    pt.y=my;
    100.do{|i|
        Pen.moveTo(pt);
        pt.x = sin(u.frame*0.04.neg+i)*(5*i)+mx; //use .frame to drive animation
        pt.y = cos(u.frame*0.05+i)*(5*i)+my;
        r.left=pt.x;
        r.top=pt.y;
        r.width=i;
        r.height=i;
        Pen.lineTo(pt);
        Pen.fillStroke;
        Pen.addOval(r);
        Pen.fillStroke;
    };
};
u.mouseDownAction = {|v, x, y|
    mx = x;
    my = y;
};
u.mouseMoveAction = u.mouseDownAction;
w.front;
w.alwaysOnTop = true;
)

r
(
u.drawFunc = {
	var pt = ~pt;
	var my = ~my;
	var mx = ~mx;
	var r = ~r;
    Pen.fillColor = Color.green;
    Pen.stringAtPoint(u.frameRate.asString, Point(10, 10)); // display frame rate
    Pen.stringAtPoint(u.frame.asString, Point(10, 30)); // display frame counter
    Pen.color = Color.white;
    pt.x=mx;
    pt.y=my;
    40.do{|i|
        Pen.moveTo(pt);
        pt.x = sin(~yo2*0.1.neg+i)*(5*i)+mx; //use .frame to drive animation
        pt.y = cos(~yo * 1.1.neg+( i ))*(5*i)+my;
        r.left=pt.x * ~yo.abs;
        r.top=pt.y;
        r.width=i;
        r.height=i;
		Pen.color = Color.new(( ~yo.abs+0.1 ).clip(0,1),0.5,0.5);
        //Pen.lineTo(pt);
        Pen.fillStroke;
        Pen.addOval(r);
        Pen.fillStroke;
    };
};
u.mouseDownAction = {|v, x, y|
    ~mx = x;
    ~my = y;
};
)

n = NetAddr("127.0.0.1", 57120); // local machine


(
OSCdef(\txest, { |msg, time, addr, recvPort| 
	//msg.debug("msg");
	~yo = msg.last;
}, "/yo");
OSCdef(\txest2, { |msg, time, addr, recvPort| 
	//msg.debug("msg");
	~yo2 = msg.last;
}, "/yo2");
)

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = SinOsc.kr(1.3);
	sig1 = sig1 + SinOsc.kr(0.37);
	SendReply.kr(Impulse.kr(45),"/yo", sig1, 1);
	sig = SinOsc.ar(sig1 + 1 * 300 * [1,1.01]);
	sig1 = sig.clip(0.1) * sig;
	sig2 = SinOsc.kr(0.1).range(0,1) + LFSaw.kr(0.07).range(0,1);
	SendReply.kr(Impulse.kr(45),"/yo2", sig2, 1);
	sig = SelectX.ar(sig2/2, [sig, sig1]);
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);



(
{
    SendReply.kr(Impulse.kr(3), '/the_answer', [40, 41, 42, 43] + MouseX.kr, 1905);
}.play(s);
)

o = OSCFunc({ |msg| msg.postln }, '/the_answer');


// multichannel expansion
(
{
    SendReply.kr(Impulse.kr(3),
        '/the_answer',
        values: [[40, 80], [41, 56], 42, [43, 100, 200]],
        replyID: [1905, 1906, 1907, 1908]
    );
}.play(s);
)

o.free;
