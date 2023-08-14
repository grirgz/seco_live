
// visu


(
	WindowDef(\farfalle, {
		var canvas = UserView.new;
		canvas.drawFunc = {
			Pen.translate(x: 0, y: ~frame);
			Pen.strokeColor = Color.red;
			Pen.fillColor = Color.blue;
			Pen.moveTo(200@100);

			Pen.lineTo(250@200);
			Pen.lineTo(300@200);
			Pen.lineTo(200@250);
			Pen.lineTo(100@200);
			Pen.lineTo(150@200);
			Pen.lineTo(200@100);

			//Pen.stroke;
			//Pen.fill;
			Pen.draw(3);
		};
		~canvas = canvas;
		canvas.background_(Color.grey);
	}).front;
	Tdef(\animator, {
		var clock = TempoClock.default;
		var startBeat = clock.beats;
		var framerate = 100;
		100000.do { arg item, idx;
			~frame = ( clock.beats - startBeat * framerate ).round;
			~frame.debug("frame");
			defer {
				~canvas.refresh;
			};
			( 1/framerate ).wait;
		};
	});
	Tdef(\animator).play;
)




(
	WindowDef(\farfalle, {
		var canvas = UserView.new;
		canvas.drawFunc = {
			//Pen.translate(x: 0, y: ~frame);
			~stains.do { arg stain, idx;
				stain.draw;
			};
		};
		~canvas = canvas;
		canvas.background_(Color.grey);
	}).front;
	Tdef(\animator, {
		var clock = TempoClock.default;
		var startBeat = clock.beats;
		var framerate = 50;
		var rowcount;
		var generateNewStains;
		~stains = List.new;
		generateNewStains = { arg list;
			var stainlib;
			var stain;
			stainlib = (
				fleche: { arg self;
					Pen.use {

						Pen.translate(x: self.xposition, y: self.yposition);
						Pen.scale(1/10,1/10);
						self.rotate = self.rotate ?? { rrand(0,2pi) };
						Pen.rotate(self.rotate);
						Pen.strokeColor = Color.red;
						Pen.fillColor = Color.blue;
						Pen.moveTo(200@100);

						Pen.lineTo(250@200);
						Pen.lineTo(300@200);
						Pen.lineTo(200@250);
						Pen.lineTo(100@200);
						Pen.lineTo(150@200);
						Pen.lineTo(200@100);

						//Pen.stroke;
						//Pen.fill;
						Pen.draw(3);
					}
				},
				rond: { arg self;
					Pen.use {

						Pen.translate(x: self.xposition, y: self.yposition);
						self.color = self.color ?? { Color.rand };
						self.ovalsize = self.ovalsize ?? { rrand(1,30) };
						Pen.strokeColor = Color.red;
						Pen.fillColor = self.color;
						Pen.fillOval(Rect(0,0,self.ovalsize,self.ovalsize));
					}
					
				},


			);
			stain = (
				yposition: -50,
				xposition: rrand(-100, ~canvas.bounds.width),
				draw: stainlib[stainlib.keys.choose]
			);

			list.add(stain);

		};

		block { arg break;
			100000.do { arg item, idx;
				~frame = ( clock.beats - startBeat * framerate ).round;
				~frame.debug("frame");
				if(~canvas.isClosed) {
					"canvas closed".debug;
					break.value;
				};
				defer {
					rowcount = ~canvas.bounds.height;
					~stains.copy.do({ arg stain;
						//[ stain.yposition, rowcount ].debug("yp, rowc");
						stain.yposition = stain.yposition + 1;
						if(stain.yposition > rowcount) {
							~stains.remove(stain);
						};
					});
					~stains.size.debug("stains size");
					generateNewStains.(~stains);
					~canvas.refresh;
				};
				( 1/framerate ).wait;
			};
		}
	});
	Tdef(\animator).play;
)




(
	WindowDef(\farfalle, {
		var canvas = UserView.new;
		canvas.drawFunc = {
			//Pen.translate(x: 0, y: ~frame);
			~stains.do { arg stain, idx;
				stain.draw;
			};
		};
		~canvas = canvas;
		canvas.background_(Color.grey);
	}).front;
	Tdef(\animator, {
		var clock = TempoClock.default;
		var startBeat = clock.beats;
		var framerate = 50;
		var rowcount;
		var generateNewStains;
		~stains = List.new;
		generateNewStains = { arg list;
			var stainlib;
			var stain;
			stainlib = (
				//fleche: { arg self;
					//Pen.use {

						//Pen.translate(x: self.xposition, y: self.yposition);
						//Pen.scale(1/10,1/10);
						//self.rotate = self.rotate ?? { rrand(0,2pi) };
						//Pen.rotate(self.rotate);
						//Pen.strokeColor = Color.red;
						//Pen.fillColor = Color.blue;
						//Pen.moveTo(200@100);

						//Pen.lineTo(250@200);
						//Pen.lineTo(300@200);
						//Pen.lineTo(200@250);
						//Pen.lineTo(100@200);
						//Pen.lineTo(150@200);
						//Pen.lineTo(200@100);

						////Pen.stroke;
						////Pen.fill;
						//Pen.draw(3);
					//}
				//},
				creu: { arg self;
					Pen.use {

						Pen.translate(x: self.xposition, y: self.yposition);
						self.color = self.color ?? { Color.rand };
						self.ovalsize = self.ovalsize ?? { rrand(1,30) };
						Pen.strokeColor = self.color;
						Pen.fillColor = self.color;

						Pen.line(Point(0,0),Point(10,0));
						Pen.stroke;

						Pen.color = Color.gray;
						Pen.line(Point(10,0),Point(20,0));
						Pen.stroke;

						Pen.color = Color.black;
						Pen.line(Point(20,0),Point(30,0));
						Pen.stroke;

						Pen.color = self.color;
						Pen.line(Point(30,0),Point(40,0));
						Pen.stroke;

					}
					
				},


			);
			~previousxpos = ~previousxpos ?? { rrand(0, ~canvas.bounds.width) };
			stain = (
				yposition: -50,
				//xposition: rrand(-100, ~canvas.bounds.width),
				xposition: ~previousxpos + [-1,1].choose,
				draw: stainlib[stainlib.keys.choose]
			);
			~previousxpos = stain.xposition;

			list.add(stain);

		};

		block { arg break;
			100000.do { arg item, idx;
				~frame = ( clock.beats - startBeat * framerate ).round;
				~frame.debug("frame");
				if(~canvas.isClosed) {
					"canvas closed".debug;
					break.value;
				};
				defer {
					rowcount = ~canvas.bounds.height;
					~stains.copy.do({ arg stain;
						//[ stain.yposition, rowcount ].debug("yp, rowc");
						stain.yposition = stain.yposition + 1;
						if(stain.yposition > rowcount) {
							~stains.remove(stain);
						};
					});
					~stains.size.debug("stains size");
					generateNewStains.(~stains);
					~canvas.refresh;
				};
				( 1/framerate ).wait;
			};
		}
	});
	Tdef(\animator).play;
)


(
	WindowDef(\farfalle, {
		var canvas = UserView.new;
		canvas.drawFunc = {
			//Pen.translate(x: 0, y: ~frame);
			~slides.do { arg slide, idx;
				slide.stains.do { arg stain, idx;
					stain.draw;
				};
			};
		};
		~canvas = canvas;
		canvas.background_(Color.grey);
	}).front;
	Tdef(\animator, {
		var clock = TempoClock.default;
		var startBeat = clock.beats;
		//var framerate = 8;
		var framerate = 50;
		var rowcount;
		var generateNewStains;
		var generateNewSlide;
		var slideCount = 0;
		~stains = List.new;
		~slides = List.new;
		generateNewSlide = {
			var slide = (
				color: Color.rand,
				stains: List.new,
				index: slideCount,
				nextStain: { arg self, break;
					var newstain;
					self.xposition = self.xposition ?? { rrand(0, ~canvas.bounds.width) };
					rowcount = ~canvas.bounds.height;
					self.stains.copy.do({ arg stain;
						//[ stain.yposition, rowcount ].debug("yp, rowc");
						//stain.debug("stain");
						stain.yposition = stain.yposition + 1;
						if(stain.yposition > rowcount) {
							self.stains.remove(stain);
						};
					});
					self.stains.size.debug("slide % stains size".format(self.index));
					newstain = self.generateNewStain;
					if(newstain.isKindOf(Frame)) {
						newstain.debug("FRAME!!!");
						~breakanimator = true;
					};
					if(newstain.isKindOf(DebugFrame)) {
						newstain.debug("DEBUGFRAME!!!");
						~breakanimator = true;
					};
					self.stains.add( newstain );
				},
				generateNewStain: { arg self;
					var stain;
					self.previousxpos = self.previousxpos ? self.xposition;
					[self.previousxpos, self.xposition].debug("prev, xpos");
					stain = (
						yposition: -50,
						xposition: self.previousxpos + [-1,1].choose,
						color: { arg stain; self.color },
						draw: { arg self;
							Pen.use {

								Pen.translate(x: self.xposition, y: self.yposition);
								self.color = self.color ?? { Color.rand };
								self.ovalsize = self.ovalsize ?? { rrand(1,30) };
								Pen.strokeColor = self.color;
								Pen.fillColor = self.color;

								Pen.line(Point(0,0),Point(10,0));
								Pen.stroke;

								Pen.color = Color.gray;
								Pen.line(Point(10,0),Point(20,0));
								Pen.stroke;

								Pen.color = Color.black;
								Pen.line(Point(20,0),Point(30,0));
								Pen.stroke;

								Pen.color = Color.gray;
								Pen.line(Point(30,0),Point(40,0));
								Pen.stroke;

								Pen.color = self.color;
								Pen.line(Point(40,0),Point(50,0));
								Pen.stroke;

							}

						},
					);
					self.previousxpos = stain.xposition;
					stain;
					
				},

			);
			slideCount = slideCount+1;
			slide;
		};

		block { arg break;
			~slides = 6.collect{ generateNewSlide.() };
			100000.do { arg item, idx;
				~frame = ( clock.beats - startBeat * framerate ).round;
				~frame.debug("frame");
				if(~canvas.isClosed) {
					"canvas closed".debug;
					break.value;
				};
				defer {
					~slides.do { arg slide, idx;
						slide.nextStain;
					};
					~canvas.refresh;
				};
				if(~breakanimator == true) {
					break;
				};
				( 1/framerate ).wait;
			};
		}
	});
	Tdef(\animator).play;
)

\Cm7.asNotes
[\Cm_eb, \Fm, \Gm, \Cm_g, \Cm_eb, \Fm, \Gm_d, \Cm].asNote;
[\Cm_eb, \Fm, \Gm, \Cm_g, \Cm_eb, \Fm, \Gm_d, \Cm].chordProg;
[\Cmaj11].chordProg
ChordSymbol.shapes.keys
d
Note

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				\CM,\CM7,\Cmaj9,\Cmaj11
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);
