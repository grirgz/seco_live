
~fib = ~fibmod.(10);
~fib.next

(
	~fibmod = { arg mod;
		var rout = Routine({
			var a = 1;
			var b = 1;
			a.yield;
			b.yield;
			1000.do { arg x;
				var xa = a, xb = b;
				a = xb;
				b = (xa+xb);
				if(mod.notNil) {
					b = b % mod;
				};
				b.yield;
			}
		});
		rout;

	};
	WindowDef(\farfalle, {
		var canvas = UserView.new;
		canvas.drawFunc = {
			var total = ~modulo;
			var center = Point(400,400);
			var radius = 350;
			var numberToPoint = { arg num;
				var angle = (num / total) * 2*pi;
				Point( sin(angle)* radius, cos(angle)*radius ) + center;
			};
			var fib = ~fibmod.(~modulo);
			Pen.strokeColor = Color.blue;
			Pen.fillColor = Color.blue;
			Pen.moveTo(center);
			Pen.strokeOval(Rect.fromPoints(center-radius, center+radius));
			Pen.strokeColor = Color.red;
			Pen.moveTo(numberToPoint.(1));
			~iterations.do { arg c;
				var x = fib.next;
				//[x, numberToPoint.(x)].debug("x");
				Pen.lineTo(numberToPoint.(x));
			};
				Pen.stroke;
		};
		~canvas = canvas;
		canvas.background_(Color.grey);
	}).frontTop;

)
~modulo = 12; ~canvas.refresh;


(
Tdef(\farf, {
	500.do { arg x;
		x= x+10020;
   
		x.debug("x");
		{
		~modulo = x; ~canvas.refresh;
		}.defer;
		500.do { arg i;
			~iterations = i;
			0.001.wait;
			{
				~modulo = x; ~canvas.refresh;
			}.defer;
		};

		( 1/2 ).wait;
	}
}).play
)
