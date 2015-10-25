

//////////// mapping MIDI to PlayerWrapper 


(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.8
)).play;
Pdef(\plop).addHalo(\instrument, \default);
);

Pdef(\plop).asParamGroup.edit
MIDIMap.learn

MIDIMap(\a1, PlayerWrapper(Pdef(\plop)))
MIDIMap(\a1, nil)


/////////////////////////// learn last tweaked

Param.lastTweaked
MIDIMap(\loop, { MIDIMap.learn })

/////////////////////////// show currently edited value

(
WindowLayout({
	var pg = Pdef(\plop).asParamGroup;
	var curval = StaticText.new;
	var editcurval = TextField.new;
	curval.string = "---";
	curval.onChange(Param, \lastTweaked, { arg view; 
		"heyxxxxxxxxxxx".debug;
		view.string = "%: %".format(Param.lastTweaked.asLabel, Param.lastTweaked.stringGet);
		editcurval.mapParam(Param.lastTweaked);
	});
	VLayout (
		VLayout(
			*pg.collect({ arg param;
				HLayout(
					param.asStaticTextLabel,
					param.asSlider.orientation_(\horizontal),
				)
			}),
		),
		HLayout(
			curval,
			editcurval,
		)
	)
})
)

~sr = SimpleController(Param).put(\yep, { "yyyy".debug })
Param.changed(\yep)

Param.changed(\lastTweaked)
Param.lastTweaked.stringGet
Param.lastTweaked.name

////////////////////////////////////// meter

// resize dont work in layouts
WindowLayout({ Server.default.serverMeter })
(
WindowLayout({ arg win; 
	ServerMeterView.new(s, win, 0@0, 0,2).view.resize_(5)
})
)

/////////////// LevelIndicator
// TODO: not on server 
// TODO: write a subclass of ServerMeterView, ServerMeterViewChannel ? which show only the channel asked and can resize

// something to meter
(
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
x = { var colum, noise, imp, delimp, mul = 1;
    imp = Impulse.kr(10);
    delimp = Delay1.kr(imp);
    colum = PlayBuf.ar(1, b, BufRateScale.kr(b), loop: 1) * mul;
    // measure rms and Peak
    SendReply.kr(imp, '/levels', [Amplitude.kr(colum), K2A.ar(Peak.ar(colum, delimp).lag(0, 3))]);
    colum;
}.play;
)

(
	// layout test
w = Window.new.front;
a = LevelIndicator(nil, nil).resize_(5);
w.layout = VLayout(Button.new, a, Button.new);
o = OSCFunc({arg msg;
    {
        a.value = msg[3].ampdb.linlin(-40, 0, 0, 1);
        a.peakLevel = msg[4].ampdb.linlin(-40, 0, 0, 1);
    }.defer;
}, '/levels', s.addr);
w.onClose = {o.free; x.free};
)

// a window and responder
// default style is coloured / solid
(
w = Window.new.front;
a = LevelIndicator(nil, nil).resize_(5);
o = OSCFunc({arg msg;
    {
        a.value = msg[3].ampdb.linlin(-40, 0, 0, 1);
        a.peakLevel = msg[4].ampdb.linlin(-40, 0, 0, 1);
    }.defer;
}, '/levels', s.addr);
w.onClose = {o.free; x.free};
)

// styles 0 and 2 support warning and critical levels
(
a.warning = -6.dbamp;
a.critical = -3.dbamp;
)

// optionally show peak level
(
a.warning = 0;
a.critical = 0;
a.drawsPeak = true;
)

// style 1 is black bars
a.style = 1

// looks good with a background
a.background = Gradient(Color.red, Color.green, \v);

// all styles can have ticks
(
a.background = Color.clear;
a.numTicks = 11; // includes 0;
a.numMajorTicks = 3;
)

// style 2 is LED
(
a.drawsPeak = false;
a.style = 2;
a.numSteps = 10;
a.numTicks = 0;
)

// style 3 is as 2, but with images
a.style = 3; // use default image

// make a custom image
(
j = Image.new(20,20);
j.draw({ arg image;
var lozenge;
lozenge = Rect(3, 3, 16, 16);
Pen.addOval(lozenge);
Pen.fillAxialGradient(1@1, 19@19, Color.new255(255, 165, 0), Color.new255(238, 232, 170));
Pen.width = 1;
Pen.strokeColor = Color.blue;
Pen.strokeOval(lozenge);
});
a.image = j;
)

// be inspired
j = Image.openURL("http://bit.ly/uSMWwp");

(
a.bounds = Rect(10, 10, 380, 80);
a.numSteps = 5;
a.image = j;
)


////////////////////////////////////// color knobs

(
WindowLayout({

	HLayout (
		* 16.collect { arg i;
			var v = Knob.new;
			if(i %8 < 4) {
				v.background_(Color.red)
			};

			v;
		}
	)
})
)





