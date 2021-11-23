(
    ~alpha = 1.0;
    ~image = Image.new(SCDoc.helpSourceDir +/+ "images/Swamp.png");
    ~bounds = Rect(20, 3, 40, 40);
    ~window = Window.new("Image background");
    ~window.view.background_(Color.gray);
    ~window.view.setBackgroundImage(~image, 5, ~alpha, ~bounds);
    ~window.front;
)

~image = Image.new("~/Images/Capture d’écran_2019-04-21_11-52-50.png".standardizePath);
~image = Image.new("~/Images/Capture d’écran_2019-12-19_00-00-39.png".standardizePath);
~image = Image.new("~/code/sc/webcam/texture_bleu.jpg".standardizePath);
~pixels = ~image.pixels

~image.loadPixels(~pixels)
~image.invert

(
~loadImage = { arg img;
	var greens=0, reds=0, blues=0;
	var colorpixels;
	img.loadPixels(~pixels);
	colorpixels = ~pixels.collect(Image.pixelToColor(_));
	colorpixels.collect({ arg pixel;
		greens = greens + pixel.green;
		blues = blues + pixel.blue;
		reds = reds + pixel.red;
	});
	Pdef(\imagesnd, Ppar([
		Pbind(
			\instrument, \default,
			\freq, 70* greens/colorpixels.size * 20,
			\dur, 1,
			\amp, 0.1 * greens/colorpixels.size * 10,
		),
		Pbind(
			\instrument, \default,
			\freq, 570* blues/colorpixels.size * 10,
			\dur, 1,
			\amp, 0.1 * blues/colorpixels.size * 10,
		),
		Pbind(
			\instrument, \default,
			\freq, 3070 * reds/colorpixels.size * 10,
			\dur, 1,
			\amp, 0.1 * reds/colorpixels.size * 10,
		),
	]).trace).play;

};
~loadImage.(~image);
)


(
~loadImage = { arg img;
	var greens=0, reds=0, blues=0;
	var colorpixels;
	img.loadPixels(~pixels);
	colorpixels = ~pixels.collect(Image.pixelToColor(_));
	colorpixels.collect({ arg pixel;
		greens = greens + pixel.green;
		blues = blues + pixel.blue;
		reds = reds + pixel.red;
	});
	Pdef(\imagesnd, Ppar([
		Pbind(
			\instrument, \default,
			\freq, 70* greens/colorpixels.size * 20,
			\dur, 1,
			\amp, 0.1 * greens/colorpixels.size * 10,
		),
		Pbind(
			\instrument, \default,
			\freq, 570* blues/colorpixels.size * 10,
			\dur, 1,
			\amp, 0.1 * blues/colorpixels.size * 10,
		),
		Pbind(
			\instrument, \default,
			\freq, 3070 * reds/colorpixels.size * 10,
			\dur, 1,
			\amp, 0.1 * reds/colorpixels.size * 10,
		),
	]).trace).play;

};
~loadImage.(~image);
)

~buf = Buffer.loadCollection(Server.default, ~pixels);
~buf.duration
~image.width
~image.height
~imgmin = ~pixels.minItem
~imgmax = ~pixels.maxItem
~colorpixels = ~pixels.collect(Image.pixelToColor(_));
~colorpixels[0].asHSV[2]
~colorpixels[0].green asHSV[2]
(0.2126 * ~colorpixels[0].red + 0.7152 * ~colorpixels[0].green + 0.0722 * ~colorpixels[0].blue)
~luminance = 
Color
~colorpixels.minItem(_.blue)
~colorpixel_to_luminance = { arg co; (0.2126 * co.red + 0.7152 * co.green + 0.0722 * co.blue) }
(
~img = (
	bluemin: ~colorpixels.minItem(_.blue).blue,
	bluemax: ~colorpixels.maxItem(_.blue).blue,
	redmin: ~colorpixels.minItem(_.red).red,
	redmax: ~colorpixels.maxItem(_.red).red,
	greenmin: ~colorpixels.minItem(_.green).green,
	greenmax: ~colorpixels.maxItem(_.green).green,
	alphamin: ~colorpixels.minItem(_.alpha).alpha,
	alphamax: ~colorpixels.maxItem(_.alpha).alpha,
	lummin: ~colorpixel_to_luminance.(~colorpixels.minItem(~colorpixel_to_luminance)),
	lummax: ~colorpixel_to_luminance.(~colorpixels.maxItem(~colorpixel_to_luminance)),
);
)
~img
Int32Array
2**32/2

    ~green = (~pixels[0] >> 8) & 255 / 255
	Image.pixelToColor(~pixels[0]).green
(
SynthDef(\grain_explorer, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var xpix, ypix;
	var strike;
	var img = \pixels.kr(~buf.bufnum);
	var imgwidth = ~image.width;
	var imgheight = ~image.height;
	var imgmin = ~imgmin;
	var imgmax = ~imgmax;
	var pixel;
	var phase;
	var gfreq, gdur, gpan;
	var blue, green, red, alpha, lum;
	var strikefreq = 500;
	strike = Impulse.ar(strikefreq);
	sig = SinOsc.ar(freq);
	xpix = LFNoise1.ar(strikefreq).unipolar * 100 + Phasor.ar(Impulse.kr(1/20), imgwidth/20 * 1/Server.default.sampleRate,0,imgwidth).poll;
	ypix = LFNoise1.ar(strikefreq).unipolar * 100 + Duty.kr(20, 0, Dseq([
		Dseq((0..( imgwidth/100 ).asInteger)*100)
	],inf)).poll;
	phase = xpix.round(1) + ( ypix.round(1) * imgwidth );




	pixel = BufRd.ar(1, img, phase);
    blue =  pixel & 255 / 255;
    green = (pixel >> 8) & 255 / 255;
    red =   (pixel >> 16) & 255 / 255;
    alpha = (pixel >> 24) & 255 / 255;
	lum = (0.2126 * red + 0.7152 * green + 0.0722 * blue);
	//gfreq = blue.linlin(~img.bluemin, ~img.bluemax, 80,2000);
	//gdur = lum.linlin(~img.lummin, ~img.lummax, 0.01,0.1);

	gfreq = lum.linlin(~img.lummin, ~img.lummax, 80,2000);
	gdur = blue.linlin(~img.bluemin, ~img.bluemax, 0.01,0.1);
	gpan = green.linlin(~img.greenmin, ~img.greenmax, -1,1);

	sig = GrainSin.ar(2, strike, gdur, gfreq, gpan.poll);

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\grain_explorer,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\grain_explorer, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var xpix, ypix;
	var strike;
	var img = \pixels.kr(~buf.bufnum);
	var imgwidth = ~image.width;
	var imgheight = ~image.height;
	var imgmin = ~imgmin;
	var imgmax = ~imgmax;
	var pixel;
	var phase;
	var gfreq, gdur, gpan;
	var blue, green, red, alpha, lum;
	var gindex, gmodfreq;
	var strikefreq = 500;
	var xshift, yshift;
	var gtrig, gamp;
	strike = Impulse.ar(strikefreq);
	sig = SinOsc.ar(freq);
	xshift = Phasor.ar(Impulse.kr(1/20), imgwidth/20 * 1/Server.default.sampleRate,0,imgwidth);
	yshift = Duty.kr(20, 0, Dseq([
		Dseq((0..( imgwidth/100 ).asInteger)*100)
	],inf));
	xpix = LFNoise1.ar(strikefreq).unipolar * 100 + xshift;
	ypix = LFNoise1.ar(strikefreq).unipolar * 100 + yshift;
	phase = xpix.round(1) + ( ypix.round(1) * imgwidth );
	SendReply.kr(Impulse.kr(10), "/imgposition", [xshift, yshift]);

	pixel = BufRd.ar(1, img, phase);
    blue =  pixel & 255 / 255;
    green = (pixel >> 8) & 255 / 255;
    red =   (pixel >> 16) & 255 / 255;
    alpha = (pixel >> 24) & 255 / 255;
	lum = (0.2126 * red + 0.7152 * green + 0.0722 * blue);
	//gdur = lum.linlin(~img.lummin, ~img.lummax, 0.01,0.1);

	//gfreq = lum.linlin(~img.lummin, ~img.lummax, 80,2000);
	gfreq = blue.linlin(~img.bluemin, ~img.bluemax, 2080,80);
	gdur = blue.linlin(~img.bluemin, ~img.bluemax, 0.01,0.1);
	gpan = green.linlin(~img.greenmin, ~img.greenmax, -1,1);
	gmodfreq = blue.linlin(~img.bluemin, ~img.bluemax, 4280,80);
	gindex = red.linlin(~img.redmin, ~img.redmax, 0,3.5);

	gamp = ( lum.linlin(~img.lummin, ~img.lummax, 1,0).clip(0.7,1).lag(0.02) - 0.7 * 5 ).poll;
	//gtrig = Impulse.kr(lum)

	//sig = GrainSin.ar(2, strike, gdur, gfreq, gpan.poll);
	sig = GrainFM.ar(2, strike, gdur, gfreq, gmodfreq, gindex, gpan) * gamp;

	sig = LeakDC.ar(sig);
	sig = HPF.ar(sig, 40);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

SendReceive


WindowDef(\imgframe, { arg def, model;
	var view = View.new;
	View.
	canvas	
	
}).front;

(
OSCdef(\imgposition, {|msg|
    var data = msg[3..];
	~imgmodel.xshift = data[0];
	~imgmodel.yshift = data[1];
	defer{ ~canvas.refresh };
}, '/imgposition');
)

Pdef(\part).play;
~imgmodel = (xshift:0, yshift:0);
~imgmodel
(
	WindowDef(\imgframe, { arg def, model;
		var canvas = UserView.new;
		~canvas = canvas;
		canvas.maxSize = Point(100,100);
		canvas.drawFunc = {
			~image.drawAtPoint(Point(0,0), Rect(model.xshift,model.yshift,100,100));
		};
		canvas.background_(Color.grey);
	}).front(~imgmodel);
)


/////////////////////////// with buffer

~image = Image.new("~/code/sc/webcam/texture_bleu.jpg".standardizePath);
~pixels = ~image.pixels;
~buf = Buffer.loadCollection(Server.default, ~pixels);
~colorpixels = ~pixels.collect(Image.pixelToColor(_));
~colorpixel_to_luminance = { arg co; (0.2126 * co.red + 0.7152 * co.green + 0.0722 * co.blue) };
~framesize = 300;
(
~img = (
	bluemin: ~colorpixels.minItem(_.blue).blue,
	bluemax: ~colorpixels.maxItem(_.blue).blue,
	redmin: ~colorpixels.minItem(_.red).red,
	redmax: ~colorpixels.maxItem(_.red).red,
	greenmin: ~colorpixels.minItem(_.green).green,
	greenmax: ~colorpixels.maxItem(_.green).green,
	alphamin: ~colorpixels.minItem(_.alpha).alpha,
	alphamax: ~colorpixels.maxItem(_.alpha).alpha,
	lummin: ~colorpixel_to_luminance.(~colorpixels.minItem(~colorpixel_to_luminance)),
	lummax: ~colorpixel_to_luminance.(~colorpixels.maxItem(~colorpixel_to_luminance)),
);
)


(
SynthDef(\grain_explorer, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var xpix, ypix;
	var strike;
	var img = \pixels.kr(~buf.bufnum);
	var imgwidth = ~image.width;
	var imgheight = ~image.height;
	var pixel;
	var phase;
	var gfreq, gdur, gpan;
	var blue, green, red, alpha, lum;
	var gindex, gmodfreq;
	var strikefreq = 500;
	var xshift, yshift;
	var gtrig, gamp;
	var bufnum = \bufnum.kr(BufDef.mono('voices/feynman.flac'));
	var bufimgratio = BufDur.kr(bufnum)/(imgwidth*imgheight);
	var gpos;
	var gpitch;
	var framesize = ~framesize;
	var sweepdur = 20;
	strike = Impulse.ar(strikefreq);
	xshift = Phasor.ar(Impulse.kr(1/sweepdur), imgwidth/sweepdur * 1/Server.default.sampleRate,0,imgwidth);
	yshift = Duty.kr(sweepdur, 0, Dseq([
		Dseq((0..( imgwidth/framesize ).asInteger)*framesize)
	],inf));
	xpix = LFNoise1.ar(strikefreq).unipolar * framesize + xshift;
	ypix = LFNoise1.ar(strikefreq).unipolar * framesize + yshift;
	phase = xpix.round(1) + ( ypix.round(1) * imgwidth );
	SendReply.kr(Impulse.kr(10), "/imgposition", [xshift, yshift]);

	pixel = BufRd.ar(1, img, phase);
    blue =  pixel & 255 / 255;
    green = (pixel >> 8) & 255 / 255;
    red =   (pixel >> 16) & 255 / 255;
    alpha = (pixel >> 24) & 255 / 255;
	lum = (0.2126 * red + 0.7152 * green + 0.0722 * blue);
	//gdur = lum.linlin(~img.lummin, ~img.lummax, 0.01,0.1);

	//gfreq = lum.linlin(~img.lummin, ~img.lummax, 80,2000);
	gfreq = blue.linlin(~img.bluemin, ~img.bluemax, 5080,180);
	gdur = blue.linlin(~img.bluemin, ~img.bluemax, 0.1,0.2).poll;
	gpan = green.linlin(~img.greenmin, ~img.greenmax, -1,1);
	gmodfreq = blue.linlin(~img.bluemin, ~img.bluemax, 4280,80);
	gindex = red.linlin(~img.redmin, ~img.redmax, 0,3.5);

	gamp = ( lum.linlin(~img.lummin, ~img.lummax, 1,0).clip(0.7,1).lag(0.02) - 0.7 * 5 );
	gpitch = red.linlin(~img.redmin, ~img.redmax, 0.9,1.1);
	//gtrig = Impulse.kr(lum)

	//sig = GrainSin.ar(2, strike, gdur, gfreq, gpan.poll);
	//sig = GrainFM.ar(2, strike, gdur, gfreq, gmodfreq, gindex, gpan) * gamp;
	gpos = ( phase * bufimgratio );
	//sig = GrainBuf.ar(2, strike, gdur, bufnum, 1, ( phase * bufimgratio ).poll) * gamp;
	sig = TGrains.ar(2, strike, bufnum, gpitch*4, gpos % BufDur.kr(bufnum), gdur, pan, gamp)* 3 * 2;

	sig = LeakDC.ar(sig);
	sig = HPF.ar(sig, 40);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\grain_explorer,
			\freq, 200,
			\bufnum, BufDef.mono('loop/loveyoumore.flac'),
			\bufnum, BufDef.mono('loop/lovin.flac'),
			\bufnum, BufDef.mono('voices/feynman.flac'),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
OSCdef(\imgposition, {|msg|
    var data = msg[3..];
	~imgmodel.xshift = data[0];
	~imgmodel.yshift = data[1];
	defer{ ~canvas.refresh };
}, '/imgposition').permanent_(true);
)


(
	OSCdef(\imgposition).enable;
	Pdef(\part).play;
	~imgmodel = ~imgmodel ? (xshift:0, yshift:0);
	WindowDef(\imgframe, { arg def, model;
		var canvas = UserView.new;
		~canvas = canvas;
		canvas.maxSize = Point(~framesize,~framesize);
		canvas.drawFunc = {
			~image.drawAtPoint(Point(0,0), Rect(model.xshift,model.yshift,~framesize,~framesize));
		};
		canvas.background_(Color.grey);
	}).frontTop(~imgmodel);
)

(
SynthDef("help-EnvDetect",{Out.ar(0,Pan2.ar(
SinOsc.ar(440,0,0.3*EnvDetect.ar(LFNoise1.ar(20), MouseX.kr(0.001,0.1,'exponential'), MouseY.kr(0.001,0.1,'exponential'))) 
,0.0))
}).play
)


(
SynthDef("help-EnvDetect",{Out.ar(0,Pan2.ar(
LFSaw.ar(EnvDetect.ar(LFNoise1.ar(11,100,200), MouseX.kr(2,0.0001,'exponential'), MouseY.kr(2,0.0001,'exponential')),0,0.3*EnvDetect.ar(LFSaw.ar(7), MouseX.kr(0.001,1,'exponential'), MouseY.kr(0.001,1,'exponential'))) 
,0.0))
}).play
)

b = Buffer.alloc(s, 2048, 1);
(
x = {
    var in, chain, freq, rq, centroid;

    //freq = LFPar.kr(0.3).exprange(100, 1000);
    freq = MouseY.kr(1000, 100, 1);
    in = Blip.ar(freq, MouseX.kr(1, 100, 1));
    chain = FFT(LocalBuf(2048), in);
    centroid = SpecCentroid.kr(chain);
    centroid.poll(10);
    in.dup * 0.1

}.play
)

x.free;

SCMIRAudioFile
SpecCentroid
