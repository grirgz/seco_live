
~img = Image.open("~/Images/sc/truchet1.png")
(
WindowDef(\farfalle, {
	var canvas = UserView.new;
	canvas.drawFunc = {
		var num = 10;
		Pen.strokeColor = Color.red;
		Pen.fillColor = Color.blue;
		Pen.moveTo(200@100);
		num.do { arg ix;
			num.do { arg iy;
				var angle = pi/2 * [0,1,2].choose;
				var center = ~img.width/2 + Point(ix, iy);
				Pen.rotate(angle, center.x, center.y);
				Pen.drawImage(Point(ix, iy)*~img.width, ~img);
				Pen.rotate(angle.neg, center.x, center.y);
			};
		};


		//Pen.stroke;
		//Pen.fill;
		//Pen.draw(3);
	};
	canvas.background_(Color.grey);
}).front;
)

(
// first tile rotate ok
WindowDef(\farfalle, {
	var canvas = UserView.new;
	canvas.drawFunc = {
		var num = 10;
		var center = Point(0, 0)+( ~img.width/2 );
		Pen.rotate(pi/2, center.x, center.y);
		Pen.drawImage(Point(0, 0)*~img.width, ~img);
	};
	canvas.background_(Color.grey);
}).front;
)

(
// first tile rotate ok
WindowDef(\farfalle, {
	var canvas = UserView.new;
	canvas.drawFunc = {
		var num = 10;
		var center = Point(1, 0)+( ~img.width/2 );
		//Pen.rotate(pi/2, center.x, center.y);
		Pen.drawImage(Point(1, 0)*~img.width, ~img);
	};
	canvas.background_(Color.grey);
}).front;
)


Image
Image.compositingOperations;
Image.resizeModes;


~img.width
~imgrot = Image.new(~img.width, ~img.height);
~imgrot.pixels  = ~img.pixels.clump(~img.width).flop.flatten
~imgrot.pixels  = Int32Array.newFrom(~img.pixels.clump(~img.width).flop.reverse.flatten)
~imgrot.plot
~img.plot
~img.pixels.clump(~img.width).flop.flatten
~img.pixels.clump(~img.width)
~img.pixels

///////


(
~img = Image.open("~/Images/sc/truchet1.png");
~imgrot = Image.new(~img.width, ~img.height);
~imgrot.pixels  = Int32Array.newFrom(~img.pixels.clump(~img.width).reverse.flatten);
WindowDef(\farfalle, {
	var canvas = UserView.new;
	canvas.drawFunc = {
		var num = 10;
		Pen.strokeColor = Color.red;
		Pen.fillColor = Color.blue;
		Pen.moveTo(200@100);
		num.do { arg ix;
			num.do { arg iy;
				var img = [~img, ~imgrot].choose;
				Pen.drawImage(Point(ix, iy)*img.width, img);
			};
		};


		//Pen.stroke;
		//Pen.fill;
		//Pen.draw(3);
	};
	~c = canvas;
	canvas.background_(Color.grey);
}).front;
)
~c.refresh


