(

var tick = 4,

grainSamps = 100,

grainHeight = 50,

grainIOI = 50,  // samples between grain onsets

grainStep = 50,  // step size between source windows

linkI = 0;



var p = Platform.resourceDir +/+ "sounds/a11wlk01.wav", f, u, w, ratioSl, d, indexSl;

var viewWidth = 500;

var buf, synth;



f = SoundFile.openRead(p);

f.seek(86965);

f.readData(d = Signal.newClear((f.sampleRate * 0.333).roundUp));

f.close;



w = Window("granular windows", Rect(800, 200, viewWidth + 4, 450));



u = UserView(w, Rect(2, 2, viewWidth, 400)).front;

u.background = Color.gray(0.1);



indexSl = EZSlider(w, Rect(2, u.bounds.bottom + 2, viewWidth, 20),

	"Grain index",

	[0, 7, \lin, 1, 0],

	{ |view|

		if(view.value != linkI) {

			linkI = view.value;

			u.refresh;

		};

	},

	linkI,

	labelWidth: 120

);



ratioSl = EZSlider(w, Rect(2, indexSl.bounds.bottom + 2, viewWidth, 20),

	"Step ratio",

	[0.25, 2, \exp],

	{ |view|

		grainStep = grainIOI * view.value;

		synth.set(\stepRatio, view.value);

		u.refresh;

	},

	1,

	labelWidth: 120

);



d = d.resamp1(viewWidth);

d = d / (d.maxValue(_.abs));



f = { |view|

	var grainStart = 0,

	grainX = 0,

	grainY = 0,

	grainCt = 0;



	var bounds = view.bounds.moveTo(0, 0),

	width = bounds.width,

	height = bounds.height,

	waveTop = height * 0.25,

	waveMid = 0.5 * (waveTop + height),

	mapY = { |x, y| Point(x, y.linlin(-1, 1, height-1, waveTop)) };



	var fg = Color.gray(0.8),

	scoreColor = Color(1, 1, 0.4, 0.5);



	var oneGrain = { |start = 0, samps = 100, plotX = 0, plotY = 0, height = 50, drawLink = false|

		var data = d[start.asInteger .. (start + samps - 1).asInteger],

		env = Env.sine(1).discretize(samps),

		top = plotY+height,

		mapY = { |x, y| Point(plotX + x, y.linlin(-1, 1, top, plotY)) };



		// envelope

		Pen.color_(fg)

		.moveTo(mapY.(0, 0));

		(1 .. samps-1).do { |i|

			Pen.lineTo(mapY.(i, env[i]));

		};

		// signal

		Pen.moveTo(mapY.(0, 0));

		(1 .. samps-1).do { |i|

			Pen.lineTo(mapY.(i, data[i] * env[i]));

		};

		Pen.stroke;

		if(drawLink) {

			Pen.color_(scoreColor)

			.moveTo(mapY.(0, 0))

			.lineTo(Point(start, waveMid))

			.moveTo(mapY.(samps-1, 0))

			.lineTo(Point(start + samps, waveMid))

			.stroke;

		};

	};



	Pen.color_(fg)

	.moveTo(Point(tick, waveTop))

	.lineTo(Point(0, waveTop))

	.lineTo(Point(0, height-1))

	.lineTo(Point(tick, height-1))

	.moveTo(Point(0, waveMid))

	.lineTo(Point(width-1, waveMid))

	.moveTo(Point(width-1, waveMid - (0.75 * tick)))

	.lineTo(Point(width-1, waveMid + (0.75 * tick)))

	.stroke;



	Pen.moveTo(mapY.(0, d[0]));

	(1 .. d.size - 1).do { |i|

		Pen.lineTo(mapY.(i, d[i]));

	};

	Pen.stroke;



	while { grainStart + grainSamps < width and: {

		grainX + grainSamps < width

	} } {

		oneGrain.(grainStart, grainSamps, grainX, grainY, grainHeight, grainCt == linkI);

		grainStart = grainStart + grainStep;

		grainX = grainX + grainIOI;

		grainY = grainHeight - grainY;

		grainCt = grainCt + 1;

	};

};

u.drawFunc = { |view| f.value(view) };

u.refresh;



w.front;

w.onClose = {

	synth.free;

	buf.free;

};



s.waitForBoot {

	buf = Buffer.read(s, p, 86965, (44100 * 0.333).roundUp);

	SynthDef(\grains, { |out = 0, bufnum, retrigFreq = 0.8, trigFreq = 20, stepRatio = 1|

		var phase = Sweep.ar(Impulse.ar(retrigFreq), stepRatio),

		grainHalfDur = trigFreq.reciprocal,

		grainDur = grainHalfDur * 2,

		trig = Impulse.ar(trigFreq) * (phase + grainDur < BufDur.kr(bufnum)),

		sig = TGrains.ar(2, trig, bufnum, 1, phase + grainHalfDur, grainDur);

		Out.ar(out, sig);

	}).add;

	s.sync;

	synth = Synth(\grains, [bufnum: buf]);

};

)
