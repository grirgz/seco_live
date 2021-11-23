
//////////////////////// R2D2


(
~image = Image.new("~/code/sc/webcam/texture_bleu.jpg".standardizePath);
~pixels = ~image.pixels;
~buf = Buffer.loadCollection(Server.default, ~pixels);
~colorpixels = ~pixels.collect(Image.pixelToColor(_));
~colorpixel_to_luminance = { arg co; (0.2126 * co.red + 0.7152 * co.green + 0.0722 * co.blue) };
~framesize = 100;
)

(
~image = Image.new("~/code/sc/webcam/cameleon.jpg".standardizePath);
~pixels = ~image.pixels;
~buf = Buffer.loadCollection(Server.default, ~pixels);
~colorpixels = ~pixels.collect(Image.pixelToColor(_));
~colorpixel_to_luminance = { arg co; (0.2126 * co.red + 0.7152 * co.green + 0.0722 * co.blue) };
~framesize = 100;
)

(
~image = Image.new("~/code/sc/webcam/redflower.jpg".standardizePath);
~pixels = ~image.pixels;
~buf = Buffer.loadCollection(Server.default, ~pixels);
~colorpixels = ~pixels.collect(Image.pixelToColor(_));
~colorpixel_to_luminance = { arg co; (0.2126 * co.red + 0.7152 * co.green + 0.0722 * co.blue) };
~framesize = 100;
)

(
~image = Image.new("~/code/sc/webcam/chess2.jpg".standardizePath);
~pixels = ~image.pixels;
~buf = Buffer.loadCollection(Server.default, ~pixels);
~colorpixels = ~pixels.collect(Image.pixelToColor(_));
~colorpixel_to_luminance = { arg co; (0.2126 * co.red + 0.7152 * co.green + 0.0722 * co.blue) };
~framesize = 100;
)

(
~load_image_to_buffer = { arg path;
	~image = Image.new(path.standardizePath);
	~pixels = ~image.pixels;
	~buf = Buffer.loadCollection(Server.default, ~pixels);
	~colorpixels = ~pixels.collect(Image.pixelToColor(_));

	~hsvpixels = ~colorpixels.collect({ arg col; 
		var hsv = col.asHSV;
		var res;
		// hue, saturation, value, alpha
		//res = ( hsv[0] * 255 ).as32Bits + ( ( hsv[1] * 255 ).as32Bits >> 8 ) + ( ( hsv[1] * 255 ).as32Bits >> 16 ) + ( ( hsv[2] * 255 ).as32Bits >> 24 );
		res = ( hsv[0] * 255 ).asInteger + ( ( hsv[1] * 255 ).asInteger << 8 ) + ( ( hsv[2] * 255 ).asInteger << 16 ) + ( ( hsv[3] * 255 ).asInteger << 24 );
		//res.as32Bits;
		res;
   	});
	~bufhsv = Buffer.loadCollection(Server.default, ~hsvpixels);

	~colorpixel_to_luminance = { arg co; (0.2126 * co.red + 0.7152 * co.green + 0.0722 * co.blue) };
	~framesize = 100;
}
)

~load_image_to_buffer.("~/code/sc/webcam/chess2.jpg")

(
	// test hsv algo
	~testcolorpixels = ~colorpixels.keep(10);
	~testhsvpixels = ~testcolorpixels.collect({ arg col, idx; 
		var hsv = col.asHSV;
		var res;
		hsv.debug("hsv array: " ++ idx);
		// hue, saturation, value, alpha
		res = ( hsv[0] * 255 ).asInteger + ( ( hsv[1] * 255 ).asInteger << 8 ) + ( ( hsv[2] * 255 ).asInteger << 16 ) + ( ( hsv[3] * 255 ).asInteger << 24 );
		//res = ( hsv[0] * 255 ).asInteger;
		//res.as32Bits;
		res.debug("hsv");
   	});

	~testcolorpixelsback = ~testhsvpixels.collect { arg item, idx;
		var hue, saturation, hsvvalue, hsvalpha;
		var hsvpixel = item;
		hsvpixel.debug("hsv back");
		hue = hsvpixel & 255 / 255;
		saturation = ( hsvpixel >> 8 ) & 255 / 255;
		hsvvalue = ( hsvpixel >> 16 ) & 255 / 255;
		hsvalpha = ( hsvpixel >> 24 ) & 255 / 255;
		[hue, saturation, hsvvalue, hsvalpha].debug("hsv back: " ++ idx);
	};

)


///////////

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
	var strikefreq = 500;
	var xshift, yshift, sweepdur=20;
	var framesize = ~framesize;

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
	//gfreq = blue.linlin(~img.bluemin, ~img.bluemax, 80,2000);
	//gdur = lum.linlin(~img.lummin, ~img.lummax, 0.01,0.1);

	gfreq = lum.linlin(0, 1, 80,2000);
	gdur = blue.linlin(0, 1, 0.01,0.1);
	gpan = green.linlin(0, 1, -1,1);

	sig = GrainSin.ar(2, strike, gdur, gfreq, gpan);

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
	~make_shift_gui = {

		OSCdef(\imgposition, {|msg|
			var data = msg[3..];
			~imgmodel.xshift = data[0];
			~imgmodel.yshift = data[1];
			defer{ ~canvas.refresh };
		}, '/imgposition').permanent_(true);


		OSCdef(\imgposition).enable;
		Pdef(\part).play;
		~imgmodel = ~imgmodel ? (xshift:0, yshift:0);
		WindowDef(\imgframe, { arg def, model;
			var canvas = UserView.new;
			var scale = 4;
			~canvas = canvas;
			canvas.maxSize = Point(~framesize*scale,~framesize*scale);
			canvas.drawFunc = {
				Pen.scale(scale,scale);
				~image.drawAtPoint(Point(0,0), Rect(model.xshift,model.yshift,~framesize,~framesize));
				~image.scalesWhenResized = true;
				Pen.addRect(Rect(~framesize/2,~framesize/2,1,1));
				Pen.color = Color.red;
				Pen.fill;
			};
			canvas.background_(Color.grey);
		}).frontTop(~imgmodel);
	};
	~make_shift_gui.();
)


/////////////////////////////////////////////

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
	var strikefreq = 300;
	var gtrig, gamp;
	var xshift, yshift, sweepdur=20;
	var framesize = ~framesize;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

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
	gfreq = blue.linlin(0, 1, 80,2080);
	gdur = blue.linlin(0, 1, 0.01,0.1);
	gpan = green.linlin(0, 1, -1,1);
	gmodfreq = blue.linlin(0, 1, 80,4280);
	gindex = red.linlin(0, 1, 0,3.5);

	gamp = ( lum.linlin(0, 1, 1,0).clip(0.7,1).lag(0.02) - 0.7 * 5 );
	//gtrig = Impulse.kr(lum)

	sig = GrainSin.ar(2, strike, gdur, gfreq, gpan) * gamp;
	//sig = GrainFM.ar(2, strike, gdur, gfreq, gmodfreq, gindex, gpan) * gamp;

	sig = LeakDC.ar(sig);
	sig = HPF.ar(sig, 40);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig1 = FreeVerb2.ar(sig[0], sig[1], \fvmix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = SelectX.ar(\mix.kr(0.8), [sig, sig1]);
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

~make_shift_gui.()

Pdef(\part).play;


{ SinOsc.ar(500) ! 2 * 0.1}.play;

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFPulse.ar(freq);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
Ndef(\zed).edit

(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1,1.001] * [1,2,3] * ( SinOsc.ar(freq * 4/5) * LFNoise1.kr(0.1!3) * 0.4 + 1 )) * 0.4;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \zed,
		\degree, Pseq([[ 0,3,7 ]],inf) + Pseq([0,5,3,1],inf),
		\lpfr, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
		\rq, 0.1,
		\dur, 1/4,
		\amp, 0.1,
	)
).play;
);


/////////////////////////////

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
	var strikefreq = 300;
	var gtrig, gamp;
	var xshift, yshift, sweepdur=20;
	var framesize = ~framesize;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var pitchedInput, comb, dist, del;

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
	gfreq = blue.linlin(0, 1, 80,280);
	gdur = blue.linlin(0, 1, 0.01,0.1);
	gpan = green.linlin(0, 1, -1,1);
	gmodfreq = blue.linlin(0, 1, 80,4280);
	gindex = red.linlin(0, 1, 0,3.5);

	gamp = ( lum.linlin(0, 1, 1,0).clip(0.7,1).lag(0.02) - 0.7 * 5 );
	//gtrig = Impulse.kr(lum)

	///// synthesis

	sig = 10.collect({ arg idx;
		var ifreq = gfreq.lag(0.2) * ( ( idx+1 ) );
		del = LFNoise1.kr(1/2)*gindex;
		pitchedInput = Pulse.ar(ifreq/4 + del);
		comb = CombC.ar(pitchedInput, 1, ifreq.reciprocal , 3.3);
		dist = SoftClipAmp.ar(comb, 1) * 0.5 * gamp;
	});
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);


	sig = LeakDC.ar(sig);
	sig = HPF.ar(sig, 40);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig1 = FreeVerb2.ar(sig[0], sig[1], \fvmix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = SelectX.ar(\mix.kr(0.8), [sig, sig1]);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

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
	var strikefreq = 300;
	var gtrig, gamp;
	var xshift, yshift, sweepdur=20;
	var framesize = ~framesize;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var pitchedInput, comb, dist, del;

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
	gfreq = blue.linlin(0, 1, 80,280);
	gdur = blue.linlin(0, 1, 0.01,0.1);
	gpan = green.linlin(0, 1, -1,1);
	gmodfreq = blue.linlin(0, 1, 80,4280);
	gindex = red.linlin(0, 1, 0,3.5);

	gamp = ( lum.linlin(0, 1, 1,0).clip(0.7,1).lag(0.02) - 0.7 * 5 );
	//gtrig = Impulse.kr(lum)

	///// synthesis

	sig = 10.collect({ arg idx;
		var ifreq = freq * 1 * ( ( idx+1 ) );
		//del = LFNoise1.kr(1/2)*freq*0.05;
		del = gmodfreq;
		pitchedInput = Pulse.ar(ifreq/4 + del);
		comb = CombC.ar(pitchedInput, 1, ifreq.reciprocal , 3.3);
		dist = SoftClipAmp.ar(comb, 1) * 0.5 * gamp;
	});
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);


	sig = LeakDC.ar(sig);
	sig = HPF.ar(sig, 40);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig1 = FreeVerb2.ar(sig[0], sig[1], \fvmix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = SelectX.ar(\mix.kr(0.8), [sig, sig1]);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
~make_shift_gui.();
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
Ndef(\zed, { arg freq=150, pan=0, amp=0.1;
	var sig;
	var pitchedInput, comb, dist, del;
	sig = 10.collect({ arg idx;
		var ifreq = freq * ( ( idx+1 ) );
		del = LFNoise1.kr(1/2)*freq*0.05;
		pitchedInput = Pulse.ar(ifreq/4 + del);
		comb = CombC.ar(pitchedInput, 1, ifreq.reciprocal , 3.3);
		dist = SoftClipAmp.ar(comb, 1) * 0.5;
	});
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);

	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(3), \damp.kr(0.4));
}).play;
);

(
Ndef(\zed, { arg freq=350, pan=0, amp=0.1;
	var sig;
	var pitchedInput, comb, dist, del;
	sig = 10.collect({ arg idx;
		var ifreq = freq * ( ( idx+1 ) );
		del = LFNoise1.kr(1/2)*freq*0.05;
		pitchedInput = SinOsc.ar(ifreq/4 + del);
		comb = CombC.ar(pitchedInput, 1, ifreq.reciprocal , 3.3);
		dist = SoftClipAmp.ar(comb, 1) * 0.5;
	});
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);

	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(3), \damp.kr(0.4));
}).play;
);



///////////////////////////////// transform black and white

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
	var strikefreq = 300;
	var gtrig, gamp;
	var xshift, yshift, sweepdur=2;
	var framesize = ~framesize;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var pitchedInput, comb, dist, del;
	var door;

	strike = Impulse.ar(strikefreq);
	xshift = Phasor.ar(Impulse.kr(1/sweepdur), imgwidth/sweepdur * 1/Server.default.sampleRate,0,imgwidth);
	yshift = Duty.kr(sweepdur, 0, Dseq([
		Dseq((0..( imgwidth/framesize ).asInteger)*framesize)
	],inf));
	xpix = framesize/2 + xshift;
	ypix = framesize/2 + yshift;
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
	gfreq = blue.linlin(0, 1, 80,280);
	gdur = blue.linlin(0, 1, 0.01,0.1);
	gpan = green.linlin(0, 1, -1,1);
	gmodfreq = blue.linlin(0, 1, 80,4280);
	gindex = red.linlin(0, 1, 0,3.5);

	gamp = ( lum.linlin(0, 1, 1,0).clip(0.7,1).lag(0.02) - 0.7 * 5 );
	//gtrig = Impulse.kr(lum)
	door = blue + red + green;
	door.poll;

	///// synthesis

	sig = 10.collect({ arg idx;
		var ifreq = freq * 1 * ( ( idx+1 ) );
		//del = LFNoise1.kr(1/2)*freq*0.05;
		del = gmodfreq;
		pitchedInput = Pulse.ar(ifreq/4 + del);
		comb = CombC.ar(pitchedInput, 1, ifreq.reciprocal , 3.3);
		dist = SoftClipAmp.ar(comb, 1) * 0.5 * gamp;
	});
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * EnvGen.kr(\coloradsr.kr(Env.adsr(0.01,0.1,0.2,0.01)), door, doneAction:0) * 10;


	sig = LeakDC.ar(sig);
	sig = HPF.ar(sig, 40);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig1 = FreeVerb2.ar(sig[0], sig[1], \fvmix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = SelectX.ar(\mix.kr(0.8), [sig, sig1]);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
~make_shift_gui.();
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
	// drum
SynthDef(\grain_explorer, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var xpix, ypix;
	var strike;
	var img = \pixels.kr(~buf.bufnum);
	var imghsv = \hsvpixels.kr(~bufhsv.bufnum);
	var imgwidth = ~image.width;
	var imgheight = ~image.height;
	var pixel, hsvpixel;
	var phase;
	var gfreq, gdur, gpan;
	var blue, green, red, alpha, lum;
	var hue, saturation, hsvvalue, hsvalpha;
	var gindex, gmodfreq;
	var strikefreq = 300;
	var gtrig, gamp;
	var xshift, yshift, sweepdur=2;
	var framesize = ~framesize;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var pitchedInput, comb, dist, del;
	var door, odoor, prevdoor;
    var body, bodyFreq, bodyAmp;
    var pop, popFreq, popAmp;
    var click, clickAmp;
    var snd;


	strike = Impulse.ar(strikefreq);
	xshift = Phasor.ar(Impulse.kr(1/sweepdur), imgwidth/sweepdur * 1/Server.default.sampleRate,0,imgwidth);
	yshift = Duty.kr(sweepdur, 0, Dseq([
		Dseq((0..( imgwidth/framesize ).asInteger)*framesize)
	],inf));
	xpix = framesize/2 + xshift;
	ypix = framesize/2 + yshift;
	phase = xpix.round(1) + ( ypix.round(1) * imgwidth );
	SendReply.kr(Impulse.kr(10), "/imgposition", [xshift, yshift]);

	pixel = BufRd.ar(1, img, phase);
    blue =  pixel & 255 / 255;
    green = (pixel >> 8) & 255 / 255;
    red =   (pixel >> 16) & 255 / 255;
    alpha = (pixel >> 24) & 255 / 255;
	lum = (0.2126 * red + 0.7152 * green + 0.0722 * blue);
	//gdur = lum.linlin(~img.lummin, ~img.lummax, 0.01,0.1);

	hsvpixel = BufRd.ar(1, imghsv, phase);

	hue = hsvpixel & 255 / 255;
	saturation = ( hsvpixel >> 8 ) & 255 / 255;
	hsvvalue = ( hsvpixel >> 16 ) & 255 / 255;
	hsvalpha = ( hsvpixel >> 24 ) & 255 / 255;


	//gfreq = lum.linlin(~img.lummin, ~img.lummax, 80,2000);
	gfreq = blue.linlin(0, 1, 80,280);
	gdur = blue.linlin(0, 1, 0.01,0.1);
	gpan = green.linlin(0, 1, -1,1);
	gmodfreq = blue.linlin(0, 1, 80,4280);
	gindex = red.linlin(0, 1, 0,3.5);

	gamp = ( lum.linlin(0, 1, 1,0).clip(0.7,1).lag(0.02) - 0.7 * 5 );
	//gtrig = Impulse.kr(lum)
	door = blue + red + green;

	///// synthesis

    // body starts midrange, quickly drops down to low freqs, and trails off
	//door = Impulse.kr(8);
	//odoor = hsvvalue.lag(0.01);
	//prevdoor = ToggleFF.kr(odoor < 0.3);
	//prevdoor.poll;
	//door = odoor * prevdoor < 0.3 + ( odoor * (1-prevdoor) > 0.7 );
	door = door < 1;
	//( door * 255 ).poll;
	//door = Trig1.kr(door, 0.01);
    bodyFreq = EnvGen.ar(Env([261,261, 120, 51], [0,0.035, 0.08], curve: \exp), door);
    bodyAmp = EnvGen.ar(Env.linen(0.005, 0.1, 0.3), door, doneAction: 0);
    body = SinOsc.ar(bodyFreq) * bodyAmp;
    // pop sweeps over the midrange
    //popFreq = XLine.kr(750, 261, 0.02);
    popFreq = EnvGen.kr(\popFreq.kr(Env([750,750,267],[0,0.02])), door);
    popAmp = EnvGen.ar(Env.linen(0.001, 0.02, 0.001), door) * 0.15;
    pop = SinOsc.ar(popFreq) * popAmp;
    // click is spectrally rich, covering the high-freq range
    // you can use Formant, FM, noise, whatever
    clickAmp = EnvGen.ar( Env([0,1,0],[0.001,0.01]), door) * 0.15;
    click = LPF.ar(Formant.ar(910, 4760, 2110), 3140) * clickAmp;

    snd = body + pop + click;
    snd = snd.tanh;

	sig = snd;
	sig = sig * EnvGen.kr(\coloradsr.kr(Env.adsr(0.01,0.1,0.2,0.01)), door, doneAction:0) * 10;

	sig = LeakDC.ar(sig);
	sig = HPF.ar(sig, 40);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig1 = FreeVerb2.ar(sig[0], sig[1], \fvmix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = SelectX.ar(\mix.kr(0.0), [sig, sig1]);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

~framesize = 10;
~framesize = 100;
(
	// drum2
	// diagonal
SynthDef(\grain_explorer, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var xpix, ypix;
	var strike;
	var img = \pixels.kr(~buf.bufnum);
	var imghsv = \hsvpixels.kr(~bufhsv.bufnum);
	var imgwidth = ~image.width;
	var imgheight = ~image.height;
	var pixel, hsvpixel;
	var phase;
	var gfreq, gdur, gpan;
	var blue, green, red, alpha, lum;
	var hue, saturation, hsvvalue, hsvalpha;
	var gindex, gmodfreq;
	var strikefreq = 300;
	var gtrig, gamp;
	var xshift, yshift, sweepdur=4;
	var framesize = ~framesize;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var pitchedInput, comb, dist, del;
	var door, odoor, prevdoor;
    var body, bodyFreq, bodyAmp;
    var pop, popFreq, popAmp;
    var click, clickAmp;
    var snd;

	//framesize = 10;

	strike = Impulse.ar(strikefreq);
	xshift = Phasor.ar(Impulse.kr(1/sweepdur), imgwidth/sweepdur -1 * 1/Server.default.sampleRate,0,imgwidth);
	yshift = Duty.kr(sweepdur, 0, Dseq([
		Dseq((0..( imgwidth/framesize ).asInteger -2 )*framesize)
	],inf));
	yshift = yshift + Phasor.ar(Impulse.kr(1/sweepdur*4), imgwidth/sweepdur/18 * 1/Server.default.sampleRate,0,imgwidth);
	xpix = framesize/2 + xshift;
	ypix = framesize/2 + yshift;
	phase = xpix.round(1) + ( ypix.round(1) * imgwidth );
	SendReply.kr(Impulse.kr(10), "/imgposition", [xshift, yshift]);

	pixel = BufRd.ar(1, img, phase);
    blue =  pixel & 255 / 255;
    green = (pixel >> 8) & 255 / 255;
    red =   (pixel >> 16) & 255 / 255;
    alpha = (pixel >> 24) & 255 / 255;
	lum = (0.2126 * red + 0.7152 * green + 0.0722 * blue);
	//gdur = lum.linlin(~img.lummin, ~img.lummax, 0.01,0.1);

	hsvpixel = BufRd.ar(1, imghsv, phase);

	hue = hsvpixel & 255 / 255;
	saturation = ( hsvpixel >> 8 ) & 255 / 255;
	hsvvalue = ( hsvpixel >> 16 ) & 255 / 255;
	hsvalpha = ( hsvpixel >> 24 ) & 255 / 255;


	//gfreq = lum.linlin(~img.lummin, ~img.lummax, 80,2000);
	gfreq = blue.linlin(0, 1, 80,280);
	gdur = blue.linlin(0, 1, 0.01,0.1);
	gpan = green.linlin(0, 1, -1,1);
	gmodfreq = blue.linlin(0, 1, 80,4280);
	gindex = red.linlin(0, 1, 0,3.5);

	gamp = ( lum.linlin(0, 1, 1,0).clip(0.7,1).lag(0.02) - 0.7 * 5 );
	//gtrig = Impulse.kr(lum)
	door = blue + red + green;

	///// synthesis

    // body starts midrange, quickly drops down to low freqs, and trails off
	//door = Impulse.kr(8);
	//odoor = hsvvalue.lag(0.01);
	//prevdoor = ToggleFF.kr(odoor < 0.3);
	//prevdoor.poll;
	//door = odoor * prevdoor < 0.3 + ( odoor * (1-prevdoor) > 0.7 );
	door = door < 1;
	//( door * 255 ).poll;
	//door = Trig1.kr(door, 0.01);
    bodyFreq = EnvGen.ar(Env([261,261, 120, 51], [0,0.035, 0.08], curve: \exp), door);
    bodyAmp = EnvGen.ar(Env.linen(0.005, 0.1, 0.3), door, doneAction: 0);
    body = SinOsc.ar(bodyFreq) * bodyAmp;
    // pop sweeps over the midrange
    //popFreq = XLine.kr(750, 261, 0.02);
    popFreq = EnvGen.kr(\popFreq.kr(Env([750,750,267],[0,0.02])), door);
    popAmp = EnvGen.ar(Env.linen(0.001, 0.02, 0.001), door) * 0.15;
    pop = SinOsc.ar(popFreq) * popAmp;
    // click is spectrally rich, covering the high-freq range
    // you can use Formant, FM, noise, whatever
    clickAmp = EnvGen.ar( Env([0,1,0],[0.001,0.01]), door) * 0.15;
    click = LPF.ar(Formant.ar(910, 4760, 2110), 3140) * clickAmp;

    snd = body + pop + click;
    snd = snd.tanh;

	sig = snd;
	sig = sig * EnvGen.kr(\coloradsr.kr(Env.adsr(0.01,0.1,0.2,0.01)), door, doneAction:0) * 10;

	sig = LeakDC.ar(sig);
	sig = HPF.ar(sig, 40);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig1 = FreeVerb2.ar(sig[0], sig[1], \fvmix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = SelectX.ar(\mix.kr(0.0), [sig, sig1]);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
	// camdrum + clap
~make_shift_gui.();
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\grain_explorer,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[329].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);
