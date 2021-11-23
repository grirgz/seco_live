//////// the goal is to draw the waveform in an image then use the image to fast render the waveform


BufDef(\amen, "vipere/amenbreak.wav");
BufDef(\moeten, "voices/02_moeten.flac")
BufDef(\crepe, "field/crepe.flac");
BufDef(\oeuf, "field/oeuf.flac");
BufDef(\ukraine, "bruit1/07_ukraine.flac");
BufDef(\table, "field/table.flac");
BufDef(\scream, "vipere/scream.flac");
BufDef(\rocksteady, "vipere/rocksteady.flac");
BufDef(\metal, "vipere/metal.flac");
BufDef(\bomb, "vipere/bomb.flac");
Pbind(
	\instrument, \playersec,
	\bufnum, BufDef('voices/feynman.flac'),
	\dur, 1,
	\gain, 1,
)

SampleTimeline(\tist2).clear
SampleTimeline(\tist2).buffer = BufDef("voices/feynman.flac");
SampleTimeline(\tist2).edit
SampleTimeline(\tist2).buffer = BufDef(\amen, "vipere/amenbreak.wav");
SampleTimeline(\tist2).changed(\data)
SampleTimeline(\tist2).refreshBufferData
SampleTimeline(\tist2).bufferInfo.buffer.sampleRate

SampleTimeline(\tist2).buf
BufDef("voices/feynman.flac").numFrames/s.sampleRate

//////////////////// proof of concept drawFunc with viewport
(
SampleTimelineView.mydraw = { arg thi;

		var buf = SampleTimeline(\tist2).buffer;
		var bounds = thi.virtualBounds;
		var height = bounds.height;
		var width = bounds.width;
		var waveformImage = thi.waveformImage;
		var viewport = thi.viewport;
		var pixelPerSecond = 300; // resolution
		var xfactor = thi.areasize.x / TempoClock.default.tempo   / ( buf.numFrames/s.sampleRate ) * waveformImage.width;
		if(waveformImage.notNil) {
			//Pen.drawImage(Point(0,0), waveformImage, bounds);

			waveformImage.width.debug("wi");
			waveformImage.drawInRect(bounds, Rect(
				xfactor * viewport.origin.x,
				waveformImage.height * viewport.origin.y,
				xfactor * viewport.width,
				waveformImage.height * viewport.height
			).flipScreen(waveformImage.height));
		} {
			Log(\Param).debug("drawImageWaveform: waveformImage is nil");
		}
}
)



///////// proof of concept
(
	~draw = {
		var buf = BufDef(\amen, "vipere/amenbreak.wav");
		var size = 1200@800;
		var img = Image.new(size);
		buf.loadToFloatArray(0,-1,{ arg data;
			{
				img.draw({
					var dsize = data.size;
					data.do { arg item, idx;
						var point = Point(idx/dsize * size.x, item*size.y + size.y /2);
						Pen.lineTo(point);
					};
					Pen.stroke;
				});
				~img = img;
				img.plot;
			}.defer;
		})

	};
	~draw.();
)

(

SampleTimelineView.mydraw = {
	Pen.drawImage(0@0, ~img)
};

)
SampleTimeline(\tist2).edit


//////////// multi channel

(
	~draw = {
		var buf = BufDef(\amen, "vipere/amenbreak.wav");
		var size = 1200@800;
		var img = Image.new(size);
		buf.loadToFloatArray(0,-1,{ arg data;
			{
				img.draw({
					var yzoom = 0.8;
					var chanspacefactor = 1.8;
					var drawChannel = { arg chandata, yoffset;
						var dsize = chandata.size;
						var chanysize = size.y/buf.numChannels;
						chandata.do { arg item, idx;
							var point = Point(idx/dsize * size.x, (item * yzoom + yoffset + 1) *chanysize  /2);
							Pen.lineTo(point);
						};
						Pen.stroke;
					};
					data.clump(buf.numChannels).flop.do { arg chandata, idx;
						drawChannel.(chandata, idx * chanspacefactor)
					};
				});
				~img = img;
				img.plot;
			}.defer;
		})

	};
	~draw.();
)

//////////// multi channel + scale + drawImage

(
	~draw = {
		var buf = BufDef(\amen, "vipere/amenbreak.wav");
		var size = 1200@800;
		var img = Image.new(size);
		buf.loadToFloatArray(0,-1,{ arg data;
			{
				img.draw({
					var yzoom = 0.8;
					var chanspacefactor = 1.8;
					var drawChannel = { arg chandata, yoffset;
						var dsize = chandata.size;
						var chanysize = size.y/buf.numChannels;
						chandata.do { arg item, idx;
							var point = Point(idx/dsize * size.x, (item * yzoom + yoffset + 1) *chanysize  /2);
							Pen.lineTo(point);
						};
						Pen.stroke;
					};
					data.clump(buf.numChannels).flop.do { arg chandata, idx;
						drawChannel.(chandata, idx * chanspacefactor)
					};
				});
				~img = img;
				//img.plot;
				WindowDef(\waveform, { arg def, img;
					var view = UserView.new;
					view.drawFunc = {
						Pen.scale( view.bounds.width / img.width, view.bounds.height / img.height);
						Pen.drawImage(Point(0,0), img);
					};

					view;
					
				}).front(img);
			}.defer;
		})

	};
	~draw.();
)


//////////// multi channel + drawInRect

BufDef(\amen).numFrames / s.sampleRate
s.sampleRate
(
	~draw = {
		var buf = BufDef(\amen, "vipere/amenbreak.wav");
		var size = Point(( buf.numFrames/Server.default.sampleRate*300 ).asInteger, buf.numChannels * 100);
		buf.loadToFloatArray(0,-1,{ arg data;
			{
				var img = Image.new(size);
				img.draw({
					var yzoom = 0.8;
					var chanspacefactor = 1.8;
					var drawChannel = { arg chandata, yoffset;
						var dsize = chandata.size;
						var chanysize = size.y/buf.numChannels;
						chandata.do { arg item, idx;
							var point = Point(idx/dsize * size.x, (item * yzoom + yoffset + 1) *chanysize  /2);
							Pen.lineTo(point);
						};
						Pen.stroke;
					};
					data.clump(buf.numChannels).flop.do { arg chandata, idx;
						drawChannel.(chandata, idx * chanspacefactor)
					};
				});
				~img = img;
				//img.plot;
				WindowDef(\waveform, { arg def, img;
					var view = UserView.new;
					view.drawFunc = {
						//img.drawInRect(view.bounds); // normal
						img.drawInRect(view.bounds, Rect(0,0,img.width, img.height/2)); // half
					};

					view;
					
				}).front(img);
			}.defer;
		})

	};
	~draw.();
)

//////////////////////////////////////////////////
//////////////////////////////////////////////
// WINDOW Example:
// First create a window and draw inside of it
(
    w = Window.new;
    w.front; // comment this to copy offscreen window
    w.view.background_(Color.white);
    w.drawHook = {
        Pen.translate(100, 100);
        10.do{
            // set the Color
            Pen.color = Color.blue(rrand(0.0, 1), rrand(0.0, 0.5));
            Pen.addWedge((100.rand)@(100.rand), rrand(10, 100), 2pi.rand, 2pi.rand);
            Pen.perform([\stroke, \fill].choose);
        }
    };
    w.refresh;
)

// then grab the window
(
    i = Image.fromWindow(w);
    w.close;
    i.plot(freeOnClose:true);
)

(
    i = Image.fromWindow(w, Rect(0,0,1000,1000));
    w.close;
    i.plot(freeOnClose:true);
)

// VIEW Capture Example:
// First create a window and add some views inside of it
(
    w = Window.new.front;
    b = [10, 80].asSpec;
    c = NumberBox(w, Rect(20, 20, 60, 40));
    a = Slider(w, Rect(20, 80, 100, 40))
        .focusColor_(Color.red(alpha:0.2))
        .action_({
            c.value_(b.map(a.value).round(0.01))
    // round the float so it will fit in the NumberBox
            });
)

// then grab the window
(
    i = Image.fromWindow(w, a.bounds);
    w.close;
    i.plot(freeOnClose:true);
)
