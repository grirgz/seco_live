(
SynthDef(\synth_0, {|out = 0, freq = 440, gate = 1, amp = 0.1, att = 0.1, rel = 0.02|
    Out.ar(out, SinOsc.ar(freq, mul: amp) * EnvGen.ar(Env.asr(att, 1, rel), gate, doneAction: 2))
}).add;

SynthDef(\synth_1, {|out = 0, freq = 440, gate = 1, amp = 0.01, att = 0.1, rel = 0.02|
    Out.ar(out, Saw.ar(freq, mul: amp) * EnvGen.ar(Env.asr(att, 1, rel), gate, doneAction: 2))
}).add;

SynthDef(\synth_2, {|out = 0, freq = 440, gate = 1, amp = 0.01, att = 0.1, rel = 0.02|
        Out.ar(out, Pulse.ar(freq, mul: amp) * EnvGen.ar(Env.asr(att, 1, rel), gate, doneAction: 2))
}).add;

SynthDef(\synth_3, {|out = 0, freq = 440, gate = 1, amp = 0.01, att = 0.1, rel = 0.02|
    Out.ar(out, Formant.ar(freq, mul: amp) * EnvGen.ar(Env.asr(att, 1, rel), gate, doneAction: 2))
}).add;



// define scores and layers of patterns

~ptrack_1 = Ptuple([
        Pbind(
                \instrument, \synth_1,
                \amp, 0.1
        ),

        Pbind(
                \instrument, \synth_0,
                \ctranspose, 2,
                \amp, 0.3
        )
]);

~ptrack_2 = Ptuple([
        Pbind(
                \instrument, \synth_1,
                \amp, 0.1
        ),
        Pbind(
                \instrument, \synth_2,
                \ctranspose, 12.3,
                \amp, 0.1
        ),
        Pbind(
                \instrument, \synth_3,
                \ctranspose, 23.7,
                \amp, 0.1
        )
]);

~pscore_1 = Pbind(
        \dur, 0.2,
        \note, Pwhite(0, 5)
);

~pscore_2 = Pbind(
        \dur, 0.3,
        \note, Pwhite(-5, 5)
);

~track = ~ptrack_1;
~score = ~pscore_1;
Pdef(\score, ~pscore_1);
Pdef(\track, ~ptrack_1);
//PchainT(Pdef(\score), Pdef(\track)).play
PchainT(Pdef(\track), Pdef(\score)).play
)

(isRest:true).asStream
(isRest:true).next(())

Pdef(\track, ~ptrack_2)
Pdef(\track, ~ptrack_1)
Pdef(\score, ~pscore_2)


// make an event list pattern

t = PchainT(PL(\score), PL(\track));

//play it

x = t.play


// replace score on the fly

~score = ~pscore_2;


// replace track on the fly

~track = ~ptrack_2;

x.stop;



With Pdef you can at least make this


// play 50 event lists by some basic operations using Pseq and Ppar

t = PchainT(Pdef(\score), Pdef(\track)).iter;
Ppar(t.nextN(50, ()).flop.collect(Pseq(_))).play


// replace and go on

Pdef(\track, ~ptrack_2)

// etc


// this works also, but replacement of track fails

Pfindur
Pattern
Pbind
().asEvent



(
	var bounds = Rect(10,10,150,18);
	a = Image.new(SCDoc.helpSourceDir +/+ "images/Swamp.png");
    w = Window.new("Image background");
    l = Knob.new(w, bounds)        .backgroundImage_(a, 5, 1, bounds);
    w.front;
    //a.free;
 // safe
 )
	a = Image.new(SCDoc.helpSourceDir +/+ "images/Swamp.png");


(
	b = 1.0;
    a = Image.new(SCDoc.helpSourceDir +/+ "images/Swamp.png");
    r = Rect(20,3,40,40);
    w = Window.new("Image background" /*, textured:false*/ );
    w.view.background_(Color.gray);
    w.view.backgroundImage_(a, 5, b, r);
    w.front;
)


(
WindowLayout({
	
    a = Image.new(SCDoc.helpSourceDir +/+ "images/Swamp.png");
	StackLayout(
		View.new.backgroundImage_(a, 0, 0).acceptsMouse_(false),
		Button.new.action_({ " yeahh!".debug("heh") }),
		
	).mode_(1)
})
)



(
	i = Image.new(       
	// "http://supercollider.sourceforge.net/theme/sc01/icon.supercollider.gif"  
	SCDoc.helpSourceDir +/+ "images/icon.supercollider.png"   
);

    w = Window.new("Image", Rect(120, 400, 360, 180)).front;
    w.onClose_({ i.free });
 // free the image when the window is closed    
 Slider.new(w).action_({ arg me; ~rot = me.value * 2pi; w.refresh; });
 w.drawHook_({  
	 Pen.rotate(~rot, 60,60);
	 i.drawInRect(Rect(40,40,50,50), Rect(10,10,50,50), 2, 1.0);
 // only a section 
 });
)
