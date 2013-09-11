(

var numX=12, numY=8, width, height, margin;

w = Window.new("CompositeView", Window.availableBounds).front;

width = (Window.availableBounds.width/numX).floor;

height = (Window.availableBounds.height/numY).floor;

margin = (width + height)/20;

w.addFlowLayout(0@0, 0@0);

t = Array.fill(numX * numY, { arg i;

    var u, n, col, moveTo, lineTo, toggle;

    col = Color.rand;

    toggle = i%2;

    n = CompositeView.new(w, Rect(0, 0, width, height))

        .background_(col);

    u=UserView(n, Rect(margin, margin, width-(margin*2), height-(margin*2))); // OK

    u.background_(col);

    u.drawFunc={|uview|

        if(toggle.asBoolean, {

            moveTo = 0@uview.bounds.height.rand;

            lineTo = uview.bounds.width@uview.bounds.height.rand;

        }, {

            moveTo = uview.bounds.width.rand@uview.bounds.height;

            lineTo = uview.bounds.width.rand@0;

         });

        Pen.moveTo(moveTo);

        Pen.lineTo(lineTo);

        Pen.stroke;

    };

    u.mouseDownAction={|view|

        col = Color.rand;

        u.background_(col);

        n.background_(col);

        toggle = (toggle - 1).abs;

    };

    u.animate_(true);

});

w.front;

)




// ************************************
// Waveshaping Synthesis (GUI)
// Patch 1 - Visualization of the basic concept
// Bruno Ruviaro, 2013-08-14
// ************************************

/*

How to start:
Select all (ctrl + A), then evaluate (ctrl + period).

SINE WAVE INPUT:
Amplitude of input is a key parameter of waveshaping synthesis.
Higher amplitudes, more distortion of original shape.
Lower amplitudes, less distortion of original shape.

TRANSFER FUNCTION:
Choose the desired amount (amplitude) for each partial, between 0-1.

OUTPUT (examples):
Choose between continuous tone, two examples of short notes, and one pattern example (Pbind).
*/

s.waitForBoot({

	/////////////////
	// Variables
	/////////////////

	var updateSineView, pBindExample, player, continuous, continuousButton, applyChangesButton, distortionBus, updateCheby, harmonics;

	distortionBus = Bus.control(s, 1); // input amp goes into this Bus
	harmonics = Array.newClear(10); // store values from Number Boxes

	/////////////////
	// Main Window
	/////////////////

	Window.closeAll;

	f = FlowView.new(
		bounds: 580@600,
		margin: 10@10, gap: 10@10)
	.background_(Color.white);

	f.onClose = {s.freeAll; player.stop};
	CmdPeriod.doOnce({Window.closeAll});

	////////////////////
	// Input Row (GUI)
	////////////////////

	// Sub-FlowView
	g = FlowView.new(f, 310@160, margin: 10@10)
	.background_(Color.red(0.8, 0.6));

	// Label: Input (sine wave)
	StaticText.new(g, 150@30)
	.string_("INPUT (sine wave)")
	.align_(\top)
	.font_(Font("Verdana", 14, true));

	g.startRow;

	// EZNumber for amplitude
	o = EZNumber.new(
		parent: g,
		bounds: Rect(0, 0, 188, 80),
		label: " ",
		controlSpec: ControlSpec(0.0, 1.0, 'lin', 0.01),
		action: {arg box;
			updateSineView.value(box.value);
			distortionBus.value = box.value;
		},
		numberWidth: 90,
		initVal: 0.5)
	// unitWidth: 0)
	.font_(Font("Verdana", 30))
	.numberView.align_(\center);

	// Init distortionBus (corresponds to input amplitude box)
	distortionBus.value = 0.5;

	g.startRow;

	// Simple label for number box
	StaticText.new(g, g.bounds.width-20@20)
	.string_("amplitude")
	.align_(\center)
	.font_(Font("Verdana", 14));

	// Plotter for Sine Wave (Input GUI)
	x = CompositeView.new(f, Rect(0, 0, 240, 160));
	a = Plotter.new("Input", parent: x)
	.value_(Signal.sineFill(1000, [1]) * 0.5)
	.setProperties(
		\backgroundColor, Color.red(0.8, 0.6));
	a.minval = -1; a.maxval = 1;
	a.refresh;

	updateSineView = {arg amp;
		a.value = Signal.sineFill(1000, [1]) * amp;
		a.minval = -1;
		a.maxval = 1;
		a.refresh;
	};

	////////////////////////////////
	// Transfer Function Row (GUI)
	////////////////////////////////

	// Sub-FlowView
	h = FlowView.new(f, 560@150, margin: 10@10)
	.background_(Color.yellow(0.9, 0.5));

	// Label Chebyshev
	StaticText.new(h, 280@30)
	.string_("TRANSFER FUNCTION (Chebyshev)")
	.align_(\top)
	// .background_(Color.red)
	.font_(Font("Verdana", 14, true));

	h.startRow;

	// Array of number boxes
	c = Array.fill(10, {arg i;
		EZNumber.new(
			parent: h,
			bounds: 50@60,
			label: (i+1).asString ++ "f",
			controlSpec: ControlSpec(0, 1, 'lin', 0.1),
			action: {arg thisBox;
				harmonics = c.collect({arg item; item.value});
				applyChangesButton.states = [["apply changes", Color.red]];
				thisBox.setColors(numNormalColor: Color.red);
			},
			initVal: 1.0.rand.round(0.1),
			layout: 'line2')
		.font_(Font("Verdana", 18))
		.setColors()
		.numberView.align_(\center);
	});

	// At start up
	harmonics = c.collect({arg item; item.value});

	// Apply changes to Chebyshev function
	applyChangesButton = Button.new(
		parent: CompositeView(h, 580@40)/*.background_(Color.red)*/,
		bounds: Rect(0, 5, 535, 27))
	.states_([["apply changes", Color.grey(0.8)]])
	.action_({arg thisButton;
		applyChangesButton.states = [["apply changes", Color.gray(0.8)]];
		c.do({arg item; item.normalColor_(Color.black)});
		updateCheby.value(harmonics);
		// if continuous note is running, stop it and play a new one
		if(continuousButton.value==1,
					{
						continuous.release;
						continuous = Synth("shaper", [\transFunc, b, \att, 1, \dist, distortionBus.asMap]);},
					{/*do nothing*/});


			});

	////////////////////////////////
	// Playback Examples Row (GUI)
	////////////////////////////////

	i = FlowView.new(f, 300@250, margin: 10@10, gap: 15@15)
	.background_(Color.green(0.4, 0.5));

	// CompositeView for Stethoscope
	y = CompositeView.new(f, Rect(0, 0, 250, 250));
	// .background_(Color.yellow(0.5));

	// Label: Input (sine wave)
	StaticText.new(i, 160@30)
	.string_("OUTPUT (examples)")
	.align_(\top)
	.font_(Font("Verdana", 14, true));

	// Scope
	Stethoscope.new(s, view: y);

	// Scope Label (and hiding space for scope options)
	k = CompositeView.new(y, Rect(2, 0, 250, 25))
	.background_(Color.white);

	// Label: Input (sine wave)
	StaticText.new(k , 230@30)
	.string_("output waveform")
	.align_(\top)
	.font_(Font("Verdana", 14, true));

	i.startRow;

	// Buttons
	continuousButton = Button.new(i, 280@50)
	.states_([["Continuous"], ["Continuous", Color.white, Color.black]])
	.action_({arg button;
		if(button.value==1,
			{continuous = Synth("shaper", [\transFunc, b, \att, 1, \dist, distortionBus.asMap])},
			{continuous.release});
	});

	Button.new(i, 132@50)
	.states_([["Short Note 1"]])
	.action_({
		// Choose duration
		var shortNoteDur = rrand(0.8, 4);
		// Play note
		{var freq = rrand(100, 300);
			LeakDC.ar(Shaper.ar(
				bufnum: b,
				in: Splay.ar(
					SinOsc.ar(
						freq: [freq, freq*1.25, freq*1.4],
						mul: EnvGen.kr(Env.perc(0.01, shortNoteDur), doneAction: 2))
		)))}.play;
		// Display amplitude change in EZNumber box
		{
			100.do({arg i;
				{o.valueAction = i.linlin(0, 99, 1, 0).round(0.01)}.defer;
				(shortNoteDur/100).wait;
			})
		}.fork;
		// button.value.postln;
	});

		Button.new(i, 132@50)
	.states_([["Short Note 2"]])
	.action_({
		// Choose duration
		var shortNoteDur = rrand(0.5, 2);
		// Play note
		{var freq = rrand(60, 400);
			LeakDC.ar(Shaper.ar(
				bufnum: b,
				in: Splay.ar(
					SinOsc.ar(
						freq: [freq, freq*2, freq*4],
						mul: EnvGen.kr(Env.perc(0.01, shortNoteDur), doneAction: 2))
		)))}.play;
		// Display amplitude change in EZNumber box
		{
			100.do({arg i;
				{o.valueAction = i.linlin(0, 99, 1, 0).round(0.01)}.defer;
				(shortNoteDur/100).wait;
			})
		}.fork;
		// button.value.postln;
	});

	Button.new(i, 280@50)
	.states_([["Pbind"], ["Pbind", Color.white, Color.black]])
	.action_({arg button;
		if(button.value==1, {player = pBindExample.play}, {player.stop; player = nil});

	});

	////////////////////////////////
	// AUDIO ///////////////////////
	////////////////////////////////


	SynthDef("shaper", {
		arg freq = 440, gate = 1, amp = 0.6, dist = 0.4, transFunc, att = 0.1, sus = 1, rel = 1;
		var snd, env;
		env = EnvGen.kr(Env.asr(att, sus, rel), gate, doneAction: 2);
		snd = Shaper.ar(transFunc, SinOsc.ar(freq, 0, Lag.kr(dist)));
		snd = LeakDC.ar(snd * env * amp);
		Out.ar(0, snd!2);
	}).add;

	// Define function to update Cheby buffer
	updateCheby = {arg array;
		// Buffer.freeAll;
		b = Buffer.alloc(s, 1024, 1, { |buf| buf.chebyMsg(array) });
		"end".postln;
	};

	// Create first with start up values
	updateCheby.value(harmonics);

	pBindExample = Pbind(
		\instrument, "shaper",
		\scale, Scale.phrygian,
		\degree, Pseq([
			Ptuple([
				Pseq([5, 6, 5, 6, 8, 7, 6, 7], 4),
				Pseq([3, 4, 3, 5, 5, 5, 5, 4], 4),
				Pseq([0, 0, 0, 2, 3, 4, 3, 1], 4)
			], 1),
			Ptuple([
				Pseq([7, 8, 9, 10, 6, 7, 8, 9, 8, 8, 7, 6, 5, 4]),
				Pseq([3, 5, 4, 4, 3, 4, 5, 4, 3, 2, 3, 4, 5, 7]),
				Pseq([-7, -8, -8, -5, -4, -6, -8, -8, -10, -9, -11, -10, -9, -9])
			])
		], inf),
		\dur, Pseq([
			Pseq([0.15, 0.15, 0.25, 0.25, 0.15, 0.15, 0.25, 0.2], 4),
			Prand([0.3, 0.43, 0.383], 14)
		], inf),
		\legato, Pseq([Pseq([0.1], 32), Pseq([0.5], 14)], inf),
		\amp, 0.5,
		\dist, Pseq([0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8], inf),
		\transFunc, Pfunc({b});
	).collect({arg event; {o.valueAction_(event[\dist])}.defer; event});


}); // end of block




// ************************************
// Waveshaping Synthesis (GUI)
// Patch 1 - Visualization of the basic concept
// Bruno Ruviaro, 2013-08-14
// ************************************

/*

How to start:
Select all (ctrl + A), then evaluate (ctrl + period).

This is a simple interface to visualize relationship between:

- input waveform (a sine wave in this example)
- transfer function
- output waveform

Amplitude of input is a key parameter of waveshaping synthesis.
Higher amplitudes, more distortion of original shape.
Lower amplitudes, less distortion of original shape.
Use the amplitude slider to check this out.

You can assume that all x and y axes are -1 to +1.

How to understand what is going on:
For any given input value (i.e., a sample value taken from the y-axis of input), the waveshaper calculates an output sample by looking up the corresponding output value (y-axis) in the transfer function. So for example, if a given input sample is at +0.9 (y-axis), the waveshaper looks up +0.9 on the x-axis of the transfer function, finds a corresponding new value between -1/+1, and that becomes the output sample.

A linear transfer function (first preset) will cause the output to be exactly the same as the input.

Note: this patch makes no sound. It is just a visual demo.

*/

(

var size = 256, inputWaveform, transferFunction, updateOutput, currentScale = 1, windowColor, buttonArray, linearFunction, chebyFunction1, chebyFunction2;

//
// TRANSFER FUNCTIONS
//

// output same as input
linearFunction = Array.fill(size+1, { |i| i-1});
// even partials
chebyFunction1 = Signal.chebyFill(size+1, [0, 1, 0, 0, 0, 1]).linlin(-1, 1, 0, size).round;
// odd partials
chebyFunction2 = Signal.chebyFill(size+1, [1, 0, 1, 0, 1, 0]).linlin(-1, 1, 0, size).round;

//
// GUI WINDOW
//

Window.closeAll;

w = Window.new("Waveshaping Synthesis - visual demo", Rect(50, 50, 610, 640), false);
w.front;
windowColor = Color.white;
w.background = windowColor;

x = CompositeView.new(w, Rect(10, 10, 500, 200)).background_(windowColor);
y = CompositeView.new(w, Rect(10, 220, 500, 200)).background_(windowColor);
z = CompositeView.new(w, Rect(10, 430, 500, 200)).background_(windowColor);

a = Plotter.new("Input", parent: x);
b = Plotter.new("Transfer", parent: y);
c = Plotter.new("Output", parent: z);

StaticText(x, Rect(5, 0, 50, 20))
.string_("input");
StaticText(y, Rect(5, 0, 200, 20))
.string_("transfer function");
StaticText(z, Rect(5, 0, 50, 20))
.string_("output");

//
// FEEDING THE PLOTS
//

// Input
inputWaveform = Signal.sineFill(size, [1]).linlin(-1, 1, 1, size).round;
// Note: linlin above returns a simple Array, not a Signal
a.value = inputWaveform;
a.setProperties(\backgroundColor, Color.red(1, 0.5));
a.setProperties(\gridOnX, false);
a.setProperties(\gridOnY, false);
a.minval = 0; a.maxval = size;
a.refresh;

// Transfer Function
transferFunction = linearFunction.copy;
b.value = transferFunction;
b.setProperties(\backgroundColor, Color.yellow(1, 0.4));
b.setProperties(\gridOnX, false);
b.setProperties(\gridOnY, false);
b.minval = 0; b.maxval = size;
b.editMode = true;
b.editFunc = {
	c.value = updateOutput.value;
	buttonArray.do{|i| i.value=0};
};
b.refresh;

// Output
updateOutput = {
	Array.fill(size, { |i|
		var inputSample, outputSample;
		inputSample = a.value.round.at(i);
		outputSample = b.value.at(inputSample);
	});
};

c.value = updateOutput.value;
c.setProperties(\backgroundColor, Color.green(0.9, 0.4));
c.setProperties(\gridOnX, false);
c.setProperties(\gridOnY, false);
c.minval = 0; c.maxval = size;
c.refresh;

// Input Amplitude Slider
d = Slider(w, Rect(520, 10, 80, 200))
.value_(1)
.background_(Color.grey(0.9, 0.9))
.focusColor_(Color.red(1, 0.3))
.knobColor_(Color.red(1, 0.3))
.action_({arg slider;
	var scale, newMax, offset, scaledArray;
	scale = slider.value.round(0.01);
	// Ignore repeated values with if/else
	if(currentScale == scale,
		{/*[currentScale, scale, "do nothing"].postln*/},
		{
			newMax = size * scale;
			offset = (size - newMax) / 2;
			scaledArray = inputWaveform.linlin(0, size, 0, newMax) + offset;
			a.value = scaledArray;
			c.value = updateOutput.value;
			a.minval = 0; a.maxval = size; a.refresh;
			c.minval = 0; c.maxval = size; c.refresh;
			currentScale = scale;
	});
});

// Preset buttons
buttonArray = Array.newClear(3);

buttonArray[0] = Button(w, Rect(520, 220, 80, 60))
.states_([
	["linear", Color.black],
	["linear", Color.black, Color.grey(0.6)]])
.value_(1)
.action_({arg button;
	if(button.value==1, {
		transferFunction = linearFunction.copy;
		b.value = transferFunction;
		b.minval = 0; b.maxval = size;
		b.refresh;
		c.value = updateOutput.value;
		c.minval = 0; c.maxval = size; c.refresh;
		buttonArray[1].value = 0;
		buttonArray[2].value = 0;
	});
});

buttonArray[1] = Button(w, Rect(520, 290, 80, 60))
.states_([
	["cheby 1", Color.black],
	["cheby 1", Color.black, Color.grey(0.6)]])
.action_({arg button;
	if(button.value==1, {
		transferFunction = chebyFunction1.copy;
		b.value = transferFunction;
		b.minval = 0; b.maxval = size;
		b.refresh;
		c.value = updateOutput.value;
		c.minval = 0; c.maxval = size; c.refresh;
		buttonArray[0].value = 0;
		buttonArray[2].value = 0;
	});
});

buttonArray[2] = Button(w, Rect(520, 360, 80, 60))
.states_([
	["cheby 2", Color.black],
	["cheby 2", Color.black, Color.grey(0.6)]])
.action_({arg button;
	if(button.value==1, {
		transferFunction = chebyFunction2.copy;
		b.value = transferFunction;
		b.minval = 0; b.maxval = size;
		b.refresh;
		c.value = updateOutput.value;
		c.minval = 0; c.maxval = size; c.refresh;
		buttonArray[0].value = 0;
		buttonArray[1].value = 0;
	});
});

50.do({
	StaticText(w, Rect(
		rrand(520, 590),
		rrand(430, 615),
		10,
		10))
.string_(".");
});

StaticText(w, Rect(520, 430, 10, 10))
.string_(".");
StaticText(w, Rect(590, 430, 10, 10))
.string_(".");
StaticText(w, Rect(520, 615, 10, 10))
.string_(".");
StaticText(w, Rect(590, 615, 10, 10))
.string_(".");

) // end of block




// ************************************

// Granular Synthesis Demo (GUI)

// Patch 2 - Granular Sampling with Multiple Files

// Bruno Ruviaro, 2013-08-21

// ************************************



/*



Use the "add files" button to load several wave or aif files.

This granulator needs mono files. If you open a stereo file,

only the left channel will be actually used.



Transp: rate of transposition in semitones.

Duration: duration of individual samples (sequential: "one sample every X seconds").

Pan: distribution of samples in the stereo field (left / right).

Amplitude: amplitude of individual samples.

Reverse: probability of a sample to be played backwards (0-100%).

Rests: probability of rests to occur (0-100%).

Overlap: smaller numbers are more 'staccato', bigger numbers more 'legato'.



Samples will be chosen randomly from any of the loaded sound files.



How to start: select all (ctrl + A), then evaluate (ctrl + enter).

(on a Mac, use the command key instead of control)



*/



s.waitForBoot({



	var win, subwin, openButton, startButton, durSlider, transpSlider, ampSlider, panSlider, restSlider, reverseSlider, overlapSlider, displayFileName, transpToRate, bufferList, staticTextList, rateLo, rateHi, durLo, durHi, panLo, panHi, ampLo, ampHi, restProb, reverseProb, overlap, pattern, player;



	// Init values

	rateLo = 1; rateHi = 1;

	durLo = 0.1; durHi = 0.2;

	panLo = 0; panHi = 0;

	ampLo = 0.3; ampHi = 0.4;

	restProb = 0.1;

	overlap = 1;

	reverseProb = 0;



	Window.closeAll;





	staticTextList = List.new;



	// Main window

	win = Window.new("Granular Sampling - Sequential, Multiple Files", Rect(50, 50, 600, 560), false).front;

	win.background = Color.grey(0.1, 0.9);

	win.onClose = { player.stop };





	// Sub view to group all sliders

	subwin = CompositeView.new(win, Rect(20, 220, 560, 325))

	// .background_(Color.red(0.4))

	;

	subwin.decorator = FlowLayout(subwin.bounds, margin: 0@0, gap: 5@10);



	// FUNCTIONS



	// Convert transpSlider values (in semitones)

	// to rate values for TGrains (1 = no transp):

	transpToRate = {arg transp; transp.linexp(-24, 24, 0.25, 4)};



	// Display file names on random places on window

	displayFileName = {arg fileName;

		var left, top, width, height;

		width = 150;

		height = 30;

		left = rrand(0, win.bounds.width-width);

		top = rrand(0, 220-height);



		staticTextList.add(

			StaticText.new(win, Rect(left, top, width, height))

			.string_(fileName.asString)

			.stringColor_(Color.gray);

		);



		openButton.front;

	};





	openButton = Button.new(win, Rect(240, 90, 120, 30))

	.states_([["add files", Color.black, Color.gray]])

	.action_({

		// Stop player if it's running:

		if(player.isNil, {"do nothing"}, { player.stop; player = nil; });

		// Let user select files:

		Dialog.openPanel(

			okFunc: {arg pathList;

				pathList.do({arg path;

					bufferList.add(Buffer.readChannel(s, path, channels: [0]));

					displayFileName.value(path.split.last);

				});

			},

			cancelFunc: { "cancelled".postln },

			multipleSelection: true);

	});





	transpSlider = EZRanger(

		parent: subwin,

		bounds: 560@30,

		label: "Transp  ",

		controlSpec: ControlSpec(

			minval:	-24, // two octaves below

			maxval: 24, // two octaves above

			warp: 'lin',

			step: 1, // step by semitones

			units: " ST"),

		action: {arg v;

			rateLo = transpToRate.value(v.lo);

			rateHi = transpToRate.value(v.hi)

		},

		initVal: [0, 0],

		labelWidth: 60,

		unitWidth: 30)

	.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);



	durSlider = EZRanger(

		parent: subwin,

		bounds: 560@30,

		label: "Duration  ",

		controlSpec: ControlSpec(

			minval:	0.05,

			maxval: 2,

			warp: 'exp',

			step: 0.01,

			units: "sec"),

		action: {arg v;

			durLo = v.lo;

			durHi = v.hi;

		},

		initVal: [durLo, durHi],

		labelWidth: 70,

		unitWidth: 30)

	.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);



	panSlider = EZRanger(

		parent: subwin,

		bounds: 560@30,

		label: "Pan     ",

		controlSpec: ControlSpec(

			minval:	-1,

			maxval: 1,

			warp: 'lin',

			step: 0.1,

			units: "L/R"),

		action: {arg v;

			panLo = v.lo;

			panHi = v.hi;

		},

		initVal: [panLo, panHi],

		labelWidth: 60,

		unitWidth: 30)

	.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);





	ampSlider = EZRanger(

		parent: subwin,

		bounds: 560@30,

		label: "Amplitude ",

		controlSpec: ControlSpec(

			minval:	0.0,

			maxval: 1,

			warp: 'lin',

			step: 0.01,

			units: "amp"),

		action: {arg v;

			ampLo = v.lo;

			ampHi = v.hi;

		},

		initVal: [ampLo, ampHi],

		labelWidth: 78,

		unitWidth: 35)

	.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);





	reverseSlider = EZSlider(

		parent: subwin,

		bounds: 560@30,

		label: "Reverse ",

		controlSpec: ControlSpec(

			minval:	0,

			maxval: 100,

			warp: 'lin',

			step: 1,

			units: "%"),

		action: {arg v;

			reverseProb = v.value/100;

		},

		initVal: reverseProb,

		labelWidth: 60,

		unitWidth: 35)

	.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);



	restSlider = EZSlider(

		parent: subwin,

		bounds: 560@30,

		label: "Rests  ",

		controlSpec: ControlSpec(

			minval:	0,

			maxval: 100,

			warp: 'lin',

			step: 1,

			units: "%"),

		action: {arg v;

			restProb = v.value/100;

		},

		initVal: 0.0,

		labelWidth: 50,

		unitWidth: 35)

	.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);



	overlapSlider = EZSlider(

		parent: subwin,

		bounds: 560@30,

		label: "Overlap ",

		controlSpec: ControlSpec(

			minval:	0.1,

			maxval: 2,

			warp: 'lin',

			step: 0.1),

		action: {arg v;

			overlap = v.value;

		},

		initVal: overlap,

		labelWidth: 63,

	/*unitWidth: 35*/)

	.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);





	// Start button

	startButton = Button.new(subwin, 560@50)

	.states_([["START", Color.black, Color.gray], ["STOP", Color.black, Color.gray]])

	.action_({arg button;

		if(button.value==1,

			{ player = pattern.play;

				("Now sampling from " ++ bufferList.size ++ " sound files").postln;

				/*bufferList.postln;

				[rateLo, rateHi].postln;

				[durLo, durHi].postln;

				[ampLo, ampHi].postln;

				"".postln;*/

			},

			{ player.stop; player = nil; });

	});



	/////////////////

	// SynthDef

	/////////////////



	SynthDef("grain-asr", {arg bufnum, rate = 1, reverse = 1, startPos = 0, gate = 1, att = 0.1, rel = 0.1, amp = 1, pan = 0;

		var env, snd;

		env = EnvGen.kr(Env.asr(att, amp, rel), gate, doneAction: 2);

		snd = PlayBuf.ar(1, bufnum, rate: rate * reverse, startPos: startPos);

		snd = snd * env;

		Out.ar(0, Pan2.ar(snd, pan));

	}).add;



	// Buffer list



	bufferList = List.newClear(1); // Prand won't like if initial list is empty



	// Pattern



	pattern = Pbind(

		\instrument, "grain-asr",

		\buffer, Prand(bufferList, inf),

		\bufnum, Pfunc({arg evt; evt.at(\buffer).bufnum}),

		\startPos, Pwhite(0, Pfunc({arg evt; evt.at(\buffer).numFrames})),

		\dur, Pwhite(Pfunc({durLo}), Pfunc({durHi})),

		\makeRest, Pif(Pfunc({ restProb.coin }), Rest, 709),

		\rate, Pwhite(Pfunc({rateLo}), Pfunc({rateHi})),

		\reverse, Pif(Pfunc({ reverseProb.coin }), -1, 1),

		\amp, Pwhite(Pfunc({ampLo}), Pfunc({ampHi})),

		\pan, Pwhite(Pfunc({panLo}), Pfunc({panHi})),

		\legato, Pfunc({overlap})

	);



	bufferList.pop; // remove 'nil', we only want actual buffers here



}); // end of block
