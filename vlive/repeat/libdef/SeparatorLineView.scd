
(
	WindowDef(\SeparatorLineView, { arg def, txt;
		var canvas = UserView.new;
		canvas.drawFunc = { arg self;
			var width = self.bounds.width;
			var height = self.bounds.height;
			var sideoffset = 5;
			var mid = height / 2 * 2; // *2 to compensate scaling
			Pen.scale(1,1/2);

			Pen.fillColor = Color.white;
			Pen.strokeColor = Color.white;
			Pen.addRect(Rect.fromPoints(Point(sideoffset, mid+2), Point(width-sideoffset, mid-2)));
			Pen.draw(3);

			Pen.strokeColor = Color.fromHexString("#84888c");
			Pen.fillColor = Color.fromHexString("#84888c");
			Pen.addRect(Rect.fromPoints(Point(sideoffset, mid), Point(width-sideoffset-2, mid-2)));
			Pen.draw(3);




			//Pen.stroke;
			//Pen.fill;
		};
		//canvas.background_(Color.red);
		if(txt.notNil) {
			View.new.layout_(
				HLayout (
					[ StaticText.new.string_(txt), stretch:0 ],
					[ WindowDef(\SeparatorLineView).asView, stretch:10, \align:\mid ],
				).margins_(0)
			)
		} {
			canvas;
		};
	});
	//WindowDef(\SeparatorLineView).front;
)

// END




(
	WindowDef(\farfalle, {
		var canvas = UserView.new;
		canvas.drawFunc = { arg self;
			var width = self.bounds.width;
			var height = self.bounds.height;
			var sideoffset = 20;
			var mid = height / 2;
			Pen.fillColor = Color.blue;

			Pen.strokeColor = Color.white;
			Pen.moveTo(Point(sideoffset, mid));
			Pen.lineTo(Point(width-sideoffset, mid));
			Pen.draw(3);

			Pen.strokeColor = Color.grey;
			Pen.moveTo(Point(sideoffset, mid));
			Pen.lineTo(Point(width-sideoffset-1, mid));
			Pen.draw(3);

			Pen.strokeColor = Color.white;
			Pen.moveTo(Point(sideoffset, mid-1));
			Pen.lineTo(Point(width-sideoffset, mid+1));
			Pen.draw(3);



			//Pen.stroke;
			//Pen.fill;
		};
		canvas.background_(Color.clear);
	}).front;
)

(
	WindowDef(\farfalle, {
		var canvas = UserView.new;
		canvas.drawFunc = { arg self;
			var width = self.bounds.width;
			var height = self.bounds.height;
			var sideoffset = 20;
			var mid = height / 2;

			Pen.fillColor = Color.white;
			Pen.strokeColor = Color.white;
			Pen.addRect(Rect.fromPoints(Point(sideoffset, mid+2), Point(width-sideoffset, mid-2)));
			Pen.draw(3);

			Pen.strokeColor = Color.fromHexString("#84888c");
			Pen.fillColor = Color.fromHexString("#84888c");
			Pen.addRect(Rect.fromPoints(Point(sideoffset, mid), Point(width-sideoffset-2, mid-2)));
			Pen.draw(3);




			//Pen.stroke;
			//Pen.fill;
		};
		canvas.background_(Color.clear);
	}).front;
)

