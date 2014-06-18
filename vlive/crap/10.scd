({var // rhythmoid
r = 87/59/*MouseX.kr(1,10).linexp(1,10,1/10,10)*/, d = 1/r, l = 8, // tempo, bar dur, beat levels
i = Impulse.ar(r*(2**l)), // base beat
pd = {|...a|PulseDivider.ar(*a)},
q = {|n,s=0,p=0| n=n+l; pd.(i, 2**n, s*2.pow(n-(p?0)-1)) }, // quantizer
e = {|p,d,a|EnvGen.ar(Env.perc(a?0.01,d?0.5),p)}, // perc envelope
s = {|...a|Stepper.ar(*a)},
z=Silence.ar
+Ringz.ar(LPF.ar(q.(0),1800),50,d).tanh
+SinOsc.ar(60,0,e.(q.(0)bitXor:q.(1))*3).tanh.madd(0.3)
+Ringz.ar(LPF.ar(q.(-2)bitXor:q.(0),[400,800]),90,d/2,1/2).mean.tanh
+BrownNoise.ar(e.(q.(0,1),d/4)/12*s.(q.(1),0,1,2))
+WhiteNoise.ar(e.(q.(1,1,2),d/4)/30)
+Blip.ar(360,4,e.(q.(-3)bitXor:q.(-2,1),d/8)/14)
+Formlet.ar(LPF.ar(q.(0)bitXor:q.(1,1,2),2300),350,d/8,d/2,1/2)
+Formlet.ar(LPF.ar(q.(-2,1)bitXor:q.(1,1,3),s.(q.(2),0,80,105,3).midicps),s.(q.(3),0,50,80,5).midicps,d/6,d/4,1/6)
+Saw.ar(400,e.(q.(2,(1..4),3), d/8)*s.(q.(-2),0,0,3)/2)
+Ringz.ar(LPF.ar(q.(-2),[400,800])/2,160,d,s.(q.(2),0,7,14)/14).mean.tanh
+PMOsc.ar(300,490,2,0,e.(q.(2))/6)
+PMOsc.ar(200,890,3,0,e.(q.(2,1))/8)
+Pulse.ar(2900,mul:e.(q.(3)bitXor:q.(2,1),d/3)/12)
+LFPar.ar(1900,mul:e.(q.(0,[1,2],[1,3])bitXor:q.(1,1,2),d/3,5e-3)/7)
+SelectX.ar(s.([q.(1),q.(0)].choose,0,0,3.rrand(7)), Saw.ar(Array.rand(7,500,4500),mul:e.(q.(-2)bitXor:q.(0,3,1), d/3))/19)
+Pulse.ar(s.(q.(3),0,60,80,3).midicps,0.5,e.(q.(-1,2,1),d/4)*2).tanh.madd(1/24)
+LFCub.ar(s.(q.(3),0,80,108,6).midicps).madd(Saw.ar(2490)*e.(pd.(q.(-4)bitXor:q.(-3,1),8,1), d/3)/16)
+Pluck.ar(Impulse.ar(s.(q.(4),0,80,108,6).midicps), q.(-2)bitXor:q.(0,3,1), d, d/18, d/2, -0.4).madd(e.(q.(2),d*8)/3) 
;z!2/8}.play)


// Granular display by T.Maisey.
// Position in the sound file is (obviously) on the x-axis, amplitude on the y-axis.
// The grain's transparency shows its position in its envelope (window).
// The speed of the grain shows pitch.
// ----------------------------------------------

// Requires use of Qt gui kit.:
GUI.qt;

(
var soundFile, buffer, window, fileView, grainView, granary, displayGrain;

soundFile = SoundFile.openRead(Platform.resourceDir +/+ "sounds/a11wlk01.wav");
buffer = Buffer.readChannel(s, soundFile.path, channels: [0]);

{
SynthDef(\grain, {
		|bufNum = 0, pos, dur, env = 0.05, pitch = 1, pan = 0, amp = 0.5|
		var envl, sig;
		envl = EnvGen.kr(Env.linen(env, dur, env, amp, -3), doneAction: 2);
		sig = PlayBuf.ar(1, bufNum, pitch, 0, pos.linlin(0,1,0,BufFrames.kr(bufNum))) * envl;

		Out.ar(0, Pan2.ar(sig, pan));
}).add;

	s.sync;
}.fork;

~pos = { rrand(0.2, 0.6) };
~dur = { rrand(0.1, 0.5) };
~env = { rrand(0.3, 0.5) };
~amp = { rrand(0.1, 0.7) };
~pitch = { rrand(0.5, 2) }; // pitch is a ratio
~pan = { rrand(-0.8, 0.8) };
~wait = { 0.1 }; // time between grains

~playTask = Task({ loop {
	var pos, pitch, amp, dur, env;
	Synth(\grain,
		[
			\bufNum, buffer,
			\pos, pos = ~pos.value,
			\pitch, pitch = ~pitch.value,
			\amp, amp = ~amp.value,
			\dur, dur = ~dur.value,
			\env, env = ~env.value,
			\pan, ~pan.value,
		]);
	displayGrain.value(pos, pitch, amp, dur, env);

	~wait.value.wait;
}});


// Grain display

window = Window.new("Grain display", Rect(200, 300, 740, 300));


fileView = SoundFileView().readFile(soundFile).gridOn_(false);
grainView = UserView().resize_(5);

window.layout = StackLayout(fileView, grainView).mode_(\stackAll).index_(1);
window.onClose = {p.stop};
window.front;

// Where information about currently playing grains is stored for drawFunc to access:
granary = ();

// Add a grain to the granary:
displayGrain = {|pos, pitchRatio, amp, dur, env|
	var time, routine;

// I've limited it to displaying 30 grains, but I don't see why it couldn't do more.
	if (granary.size < 30, {

		time = Date.getDate().bootSeconds;
		routine = Routine {
			granary.put(time.asSymbol, [pos, pitchRatio, amp, dur, env]);
			(dur + (env * 2)).wait;
			granary.removeAt(time.asSymbol);
		}.play
	});
};

grainView.animate = true;

grainView.drawFunc = {
	var width, height, now, fileDur;

	width = grainView.bounds.width;
	height = grainView.bounds.height;
	now = Date.getDate().bootSeconds;
	fileDur = soundFile.duration;

	Pen.fillColor = Color.white;
	Pen.strokeColor = Color.black;

	granary.keysValuesDo {|k, v|
		var xP, yP, delta, alpha;

		delta = now - k.asFloat;
		xP = (width * v[0]) + (width * ((delta * v[1]) / fileDur));
		yP = (height * (1 - v[2]));

		if( delta < (v[3] + v[4]),
			{ alpha = (delta/v[4]).clip(0,1) },
			{ alpha = 1 - ((delta - (v[3] + v[4])) / v[4]) }
		);

		Pen.translate(xP, yP); // moveTo doesn't seem to work in this context, so translate...

		Pen.addOval(Rect(0,0,10,10));
		Pen.alpha = alpha;
		Pen.fillStroke;

		Pen.translate(xP.neg, yP.neg); // ...and translate back.
	};
};

// Start the grains:
p = ~playTask.play;

)

// Try some different granular parameters:
(
~pos = { rrand(0.3, 0.8) };
~dur = { rrand(0.01, 0.05) };
~env = { 0.02 };
~amp = { rrand(0.2, 0.6) };
~pitch = { rrand(2, 4.0) };
~pan = { rrand(-0.8, 0.8) };
~wait = { 0.01 }; // time between grains
)

// Or how about these:
(
~pos = { rrand(0, 0.5) };
~dur = { rrand(0.1, 0.2) };
~env = { rrand(0.3, 0.5) };
~amp = { rrand(0.2, 0.8) };
~pitch = { rrand(0.2, 0.7) };
~pan = { rrand(-0.8, 0.8) };
~wait = { 0.1 };
)

// To stop the grains, close the grain display window or evaluate:
p.stop;




(
b = Bus.audio(s, 1);

SynthDef(\muse, {|freq, dur, vol|
	var env = EnvGen.kr(Env.linen(sustainTime: dur*0.925, attackTime: 0.075*dur, releaseTime: 0.01*dur), doneAction: 2);
	Out.ar(b, LPF.ar(Pulse.ar(freq, width: 0.5, mul: vol*env), 11000));
}).send(s);

SynthDef(\muse, {|freq, dur, vol|
	var env = EnvGen.kr(Env.linen(sustainTime: dur*0.98, attackTime: 0.01*dur, releaseTime: 0.01*dur), doneAction: 2);
	Out.ar(b, LPF.ar(Pulse.ar(freq, width: MouseX.kr(0.01, 0.99), mul: vol*env*MouseY.kr, add: Resonz.ar(Saw.ar(freq, mul: vol*env*MouseY.kr(1,0)), freq*1.2, 12)), 11000));
}).send(s);

SynthDef(\museverb, {
	Out.ar(0, Pan2.ar(FreeVerb.ar(In.ar(b), 0.45, 0.5), 0));
}).send(s);

)

(
	var counter0=0, counter1=0, shiftreg=rrand(0, pow(2,30).asInteger), handler, interval, theme, makeanote, tempo=320, basefreq=220, finefreq=0, rest=false, vol, slider, major, mminor, hminor, acc, lastmnote, mminorlook;
	var lookup;
	var mv = Synth(\museverb, [], s);
	var note = nil;
	interval = Array.with(2,8,10,20);
	theme = Array.with(5,7,25,20);
	slider = {
		|sliderval, i|
		var choice = 0;
		(sliderval == 0).if { choice = 0 }; // off
		(sliderval == 1).if { choice = 1 }; // on
		(sliderval == 2).if { choice = counter0 & 1 }; // c1/2
		(sliderval == 3).if { choice = counter0 & 2 >> 1 }; // c1
		(sliderval == 4).if { choice = counter0 & 4 >> 2 }; // c2
		(sliderval == 5).if { choice = counter0 & 8 >> 3 }; // c4
		(sliderval == 6).if { choice = counter0 & 16 >> 4 }; // c8
		(sliderval == 7).if { choice = (counter1 / 3).asInteger % 2 }; // c3
		(sliderval == 8).if { choice = (counter1 >= 6).asInteger }; // c6
		(sliderval >= 9 && (sliderval <= 39)).if { choice = (shiftreg >> (sliderval.asInteger - 9)) & 1 };
		choice;
	};		
		
	makeanote = { |freq|
		var dur;
		"makenote".postln;
		if (t == nil, { dur = 1 }, { dur = 2/t.tempo });
		
		if ((counter0 & 1) == 1 && (note != nil), 
			{note.set(\freq, freq, \vol, vol);},
			{note = Synth(\muse, [\freq, freq, \dur, dur, \vol, vol], mv, \addBefore);}
		);
	};
	
	handler = { 
		var notes, freq, parity, mnote;
		parity = theme.sum(slider).asInteger & 1;
		("shiftreg" + (shiftreg&0x7fffffff).asHexString).postln;
		notes = interval.collect(slider);
		mnote = notes[0] + (2 * notes[1]) + (4 * notes[2]);
		freq = (basefreq.cpsmidi + lookup[mnote]);
		("A"+freq).postln;
		if ((mminorlook == 1) &&
			((mnote == 5) || (mnote == 6)) &&
			(lastmnote != nil)
		, {
			if (lastmnote > mnote, {
				freq = freq - 1;
				freq.postln;
			});
		});
		lastmnote = mnote;
		freq = freq.midicps * (1 + notes[3]);
		("B"+freq).postln;
		("R"+rest).postln;
		("N"+notes.sum).postln;
		if (rest == false || (notes.sum != 0)) {
			makeanote.value(freq * finefreq);
		};
		("counter0" + counter0).postln;
		("counter1" + counter1).postln;
		if (counter0&1 == 1, {
			counter1 = (counter1+1) % 12;
			shiftreg = shiftreg << 1 | parity;
		});
		counter0 = (counter0+1) % 32;
	};
	
	Window.allWindows.do { |w| if (w.name == "The Muse") { w.close } };
	w = Window.new("The Muse", Rect(200,200,800,710));
	c = ControlSpec.new(0, 39, step: 1);
	t = TempoClock.new;
	
	EZSlider.new(w, Rect(0,0,800,75), "Interval A", c, { |ez| interval[0] = ez.value}, initAction:true);
	EZSlider.new(w, Rect(0,75,800,75), "Interval B", c, { |ez| interval[1] = ez.value}, initAction:true);
	EZSlider.new(w, Rect(0,150,800,75), "Interval C", c, { |ez| interval[2] = ez.value}, initAction:true);
	EZSlider.new(w, Rect(0,225,800,75), "Interval D", c, { |ez| interval[3] = ez.value}, initAction:true);
	EZSlider.new(w, Rect(0,300,800,75), "Theme W", c, { |ez| theme[0] = ez.value}, initAction:true);
	EZSlider.new(w, Rect(0,375,800,75), "Theme X", c, { |ez| theme[1] = ez.value}, initAction:true);
	EZSlider.new(w, Rect(0,450,800,75), "Theme Y", c, { |ez| theme[2] = ez.value}, initAction:true);
	EZSlider.new(w, Rect(0,525,800,75), "Theme Z", c, { |ez| theme[3] = ez.value}, initAction:true);
	
	EZSlider.new(w, Rect(0,600,400,40), "Volume", action: {|ez| vol = ez.value;}, initVal: 0.75, initAction:true);
	EZSlider.new(w, Rect(400,600,400,40), "Pitch", ControlSpec(0,127, step:1),action: {|ez| basefreq = ez.value.midicps;}, initVal: 32, initAction:true);
	EZSlider.new(w, Rect(0,640,400,40), "Fine Pitch", ControlSpec(1/1.0595465, 1.0595465), action: {|ez| finefreq = ez.value}, initVal: 1, initAction: true);
	~tempobutton = EZSlider.new(w, Rect(400,640,400,40), "Tempo", ControlSpec(12, 600), action: {|ez| if (t != nil) {t.tempo = ez.value / 60}}, initVal: 160, initAction: true);
	Button.new(w,Rect(0,680,80,30)).states_([["Start"],["Stop"]]).action_({
		|button|
		if ((button.value == 0), {
			"hold".postln;
			t.stop;
			t = nil;
		}, {
			"foof".postln;
			t = TempoClock.new(~tempobutton.value/60);
			mv.free;
			mv = Synth(\museverb, [], s);
			t.sched(0, { handler.value(lookup, basefreq); 1})
		});
	});
	Button.new(w,Rect(80,680,80,30)).states_([["Step"]]).action_({|button| handler.value(lookup, basefreq);});
	Button.new(w,Rect(160,680,80,30)).states_([["Reset"]]).action_({counter0 = counter1 = shiftreg = 0;});
	CheckBox.new(w, Rect(240,680,80,30), "Rest").action = { |state| rest = state.value };
	major = CheckBox.new(w, Rect(320,680,80,30), "Major").action = {
		"majorclick".postln;
		major.value.postln;
		if (major.value, {
			"majoron".postln;
			hminor.value = 0;
			mminor.value = 0;
			lookup = [0,2,4,5,7,9,11,12];
		});
		mminorlook = false;
	};
	
	hminor = CheckBox.new(w, Rect(400,680,80,30), "Harmonic").action = {
		"hmonirclick".postln;
		if (hminor.value, {
			"hmoniron".postln;
			major.value = 0;
			mminor.value = 0;
			lookup = [0,2,3,5,7,8,11,12]
		});
		mminorlook = false;
	};
	
	mminor = CheckBox.new(w, Rect(480,680,80,30), "Melodic").action = {
		"mmonirclick".postln;
		if (mminor.value, {
			"mminor".postln;
			hminor.value = 0;
			major.value = 0;
			lookup = [0,2,3,5,7,9,11,12]
		});
		mminorlook = true;
	};
	
	major.valueAction = true;
	~display = StaticText(w,Rect(0,800,40,710)).font_("Monaco").stringColor_(Color.gray(0,1));
	w.onClose = { t.stop };
	w.front;
)




( 
var w, status, limit, buttons, controls = [], one_button, data, synths, one_synth, synths_generator, 
density_one = 1/4, density_many = 1/10, type_distribution = [0.85, 0.15], // tweak it to get more or less dense pattern grid
task, resolution, direction, pos = 0, step = 1, border = 1, dims = [16,16]; // tweak dims to change size of grid
w = Window("rand-n-step+", Rect(50,250,dims[0]*22+10+250,dims[1]*22+60)).acceptsMouseOver_(true); // window init
status = StaticText(w, Rect(5, w.bounds.height - 20, w.bounds.width, 20));
limit = { ReplaceOut.ar(0, Limiter.ar(In.ar(0,2))) }.play( addAction:\addToTail ); // limiter
data = Array2D(dims[1],dims[0]); // prepare data
// and buttons
one_button = { | b, density = 0.1 |
	b.valueAction = 0; // reset
	density.coin.if({ b.valueAction = [1,2].wchoose(type_distribution) }); // tweak it
};
synths = Array.fill(dims[1], { () });
buttons = Array.fill(dims[1], { |l|
	controls = controls.add([ // control buttons
		Button( w, Rect( 10 + (22*dims[0]), 35 + (22*l), 20, 20) ).states_([['m'],['u']]).action_({ |b| // mute / unmute
			synths[l].gate = b.value.booleanValue.not.binaryValue;
		}).mouseOverAction_({ status.string = 'mute/unmute' }),
		Button( w, Rect( 10 + (22*(dims[0]+1)), 35 + (22*l), 20, 20) ).states_([['p']]).action_({ // dice pattern line
			buttons[l].do({ |b| one_button.(b, density_one) }); // tweak it
		}).mouseOverAction_({ status.string = 'randomize pattern' }),
		Button( w, Rect( 10 + (22*(dims[0]+2)), 35 + (22*l), 20, 20) ).states_([['s']]).action_({ // dice one synth
			synths[l] = one_synth.(l);
		}).mouseOverAction_({ status.string = 'randomize synth' }),
		Slider( w, Rect( 10 + (22*(dims[0]+3)), 35 + (22*l), 60, 20) ).action_({ |b| // synth amp
			synths[l].amp = b.value.linexp(0,1,1/16,16);
		}).mouseOverAction_({ status.string = 'tweak synth amp' }),
		Slider( w, Rect( 10 + (22*(dims[0]+3)+60), 35 + (22*l), 60, 20) ).action_({ |b| // synth stretch
			synths[l].stretch = b.value.linexp(0,1,1/8,8);
		}).mouseOverAction_({ status.string = 'tweak synth stretch' }),
		Slider( w, Rect( 10 + (22*(dims[0]+3)+120), 35 + (22*l), 60, 20) ).action_({ |b| // synth pan
			synths[l].pan = b.value.linlin(0,1,-1,1);
		}).mouseOverAction_({ |b| status.string = 'tweak synth pan ' })
	]);
	Array.fill(dims[0], { |i| // grid
		Button( w, Rect( 5 + (22*i), 35 + (22*l), 20, 20) ).states_([ ['-'], ['+'], ['%'] ]).action_({ 
			|b| data[l,i] = b.value 
		}).mouseOverAction_({ status.string = '"%" makes sound with 0.5 probability' }); 
	});
});
// synth gen functions and initialization
one_synth = { |i| // tweak this function to (generate and) return other synthdef names
	var name = 'rstp'++i, pan = -1.0.rand2;
	SynthDef(name, { |index = 0, amp = 1, stretch = 1, pan = 0| // args: horizontal position in grid, amplitude and stretch correction, pan
		var sig = Pan2.ar( // tweak sig to get different sound texture
			PMOsc.ar(80.exprand(10000), 1.exprand(200), 1.exprand(20)),
			pan,
			EnvGen.kr(Env(Array.rand(4, 0, 0.05.rrand(0.4)).add(0), Array.rand(3, 0.1, 1.2).add(0.1), 5.rand2), levelScale: amp, timeScale: stretch, doneAction: 2)
		);
		Out.ar(0, sig);
	}).add;
	controls[i][3].valueAction_(1.explin(1/16,16,0,1));
	controls[i][4].valueAction_(1.explin(1/8,8,0,1));
	controls[i][0].valueAction_(0);
	controls[i][5].valueAction_(pan.linlin(-1,1,0,1));
	(name: name, gate: 1, amp: 1, stretch: 1, pan: pan);
};
synths_generator = { Array.fill(dims[1], { |i| synths[i] = one_synth.(i) } ) };
synths_generator.();
// step task
task = Task({
	inf.do({
		pos = (pos + step).mod(dims[0]);
		dims[1].do({ |l|
			(buttons[l] @@ pos).font_(Font("sans", 20));
			(buttons[l] @@ (pos-step)).font_(Font("sans", 14));
			synths[l].gate.booleanValue.if({
				var args = [index: pos, amp: synths[l].amp, stretch: synths[l].stretch * TempoClock.tempo.reciprocal * resolution.reciprocal, pan: synths[l].pan ];
				switch( data[l,pos],
					1, { Synth(synths[l].name, args) },
					2, { 0.5.coin.if({ Synth(synths[l].name, args) }) }
				);  
			});
		});
		switch( pos,
			0,             { (border == -1 && step == -1).if({ direction.valueAction = 0 }) },
			(dims[0] - 1), { (border == -1 && step ==  1).if({ direction.valueAction = 1 }) }
		);	
		(TempoClock.default.tempo.reciprocal / resolution).yield;
	});
}, AppClock).play(quant:[0]);
// app buttons
Button(w, Rect(5,5, w.bounds.width - 10 / 7, 20)).states_([['reset']]).action_({ |b|
	synths_generator.();
	buttons.flat.do({ |b| one_button.(b, 0) }); // tweak it
}).mouseOverAction_({ status.string = 'reset everything' });
Button(w, Rect(w.bounds.width - 10 / 7 * 1 + 5, 5, w.bounds.width - 10 / 6, 20)).states_([['lucky?']]).action_({ |b| // lazy patterns
	buttons.flat.do({ |b| one_button.(b, density_many) }); // tweak it
}).mouseOverAction_({ status.string = 'create random pattern grid' });
Button(w, Rect(w.bounds.width - 10 / 7 * 2 + 5, 5, w.bounds.width - 10 / 7, 20)).states_([['noisy?']]).action_({ |b|
	synths_generator.();
}).mouseOverAction_({ status.string = 'randomize all synths' });
Button(w, Rect(w.bounds.width - 10 / 7 * 3 + 5, 5, w.bounds.width - 10 / 7, 20)).states_([['pause'],['play']]).action_({ |b|
	b.value.booleanValue.if({ task.pause }, { task.resume(quant:[0]) });
}).mouseOverAction_({ status.string = 'play/pause' });
direction = Button(w, Rect(w.bounds.width - 10 / 7 * 4 + 5, 5, w.bounds.width - 10 / 7, 20)).states_([['r-t-l'],['l-t-r']]).action_({ |b|
	b.value.booleanValue.if({ step = -1 }, { step = 1 });
}).mouseOverAction_({ status.string = 'change playing direction' });
Button(w, Rect(w.bounds.width - 10 / 7 * 5 + 5, 5, w.bounds.width - 10 / 7, 20)).states_([['fold'],['wrap']]).action_({ |b|
	b.value.booleanValue.if({ border = -1 }, { border = 1 });
}).mouseOverAction_({ status.string = 'behavior on the grid border' });
Slider(w, Rect(w.bounds.width - 10 / 7 * 6 + 5, 5, w.bounds.width - 10 / 7, 20)).action_({ |b|
	resolution = b.value.linlin(0, 1, 1, 8).quantize(1, 1);
	status.string = 'resolution: ' ++ resolution;
}).valueAction_(4.linlin(1,8,0,1)).mouseOverAction_({ status.string = 'change grid resulution' });
// show
w.front.onClose = { task.stop; limit.free };
status.string_('hello, point something to get hint, hopefully..');
)
