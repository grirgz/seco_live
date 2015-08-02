
////////////// Builder

1+1
(
Builder(\plop, { arg builder, osctype=0, voices=1;

	builder.key.debug("key");
	"wtf!!!".debug;
	builder.source.debug("WTFF");

	SynthDef(builder.key, { arg out=0, freq=200, doneAction=2, gate=1, amp=0.1, pan=0, spread=0.8, fspread=0.1;

		var oscs, osc;
		var sig;
		freq = voices.clip(1,1000).asInteger.collect({
			freq * ( 1 + ( Rand(0,1) * fspread ) )
		});
		oscs = [
			{ SinOsc.ar(freq) },
			{ LFSaw.ar(freq) },
			{ LFPulse.ar(freq) },
		];
		osc = oscs[osctype];

		sig = osc.();
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:doneAction);
		sig = Splay.ar(sig, spread, amp, pan);
		Out.ar(out, sig);
	}).add;


}).build;
)

Builder(\plop).value
Builder(\plop).envir
Builder(\plop).addSpec(\osctype, ControlSpec(0,2,\lin,1));
Builder(\plop).getSpec(\osctype)

Builder.all

Param(Builder(\plop), \osctype, ControlSpec(0,2,\lin,1)).edit
Param(Builder(\plop), \osctype).spec
Param(Builder(\plop), \osctype, ControlSpec(0,2,\lin,1)).wrapper
Builder(\plop).func
Builder(\plop).func
Builder(\plop).build
nil !? { 3 }

~f = { arg a, bedo=4; }
~f.dump
~f.def.dump.prototypeFrame
~f.def.dump
~f.def.argNames


(
~steps = StepList.newFrom(1!8);
Ppredef(\plop, Pbind(
	\instrument, \plop,
	\degree, Pseq([0],inf),
	\isRest, ~steps.prest.loop,
	\dur, 1/4,
)).play;
~steps.addSpec(\list, \unipolar);
Pdef(\plop).setBusMode(\freq);
Pdef(\plop).addSpec(\fspread, ControlSpec(0.0001,1,\exp));
);

Ppredef(\plop)
Pdef(\plop).gui
Ppredef(\plop).clear
Pdef.all[\plop] = nil

(
WindowLayout({
	VLayout(
		
		StepListView(~steps).addCursor.view,
		PopUpMenu.new.items_([
			"SinOsc",
			"LFSaw",
			"LFPulse",
		]).mapParam(Param(Builder(\plop), \osctype)),
		ParamGroupLayout.two_panes([
			Param(Builder(\plop), \voices, ControlSpec(1,50,\lin,1)),
			Param(Pdef(\plop), \dur, ControlSpec(1/16,1,\exp)),
			Param(Pdef(\plop), \amp),
			Param(Pdef(\plop), \freq),
			Param(Pdef(\plop), \fspread),
			Param(Pdef(\plop), \adsr, XEnvSpec.adsr),
		])
	)
})
)

29.collect

/////////////////////////////////////////////////////////////////////: discover other gui systems

(
WindowLayout({ arg win;
	VLayout(
		//PlayerWrapperView.new(Pdef(\plop)).layout
		NumberEditor.new(1)

	)
})
)



(
// so make sure you get the NumberEditor
n=NumberEditor(440.0,\freq);
n.gui;
n.dump;
)

Editor.for(Env.perc).gui


(
WindowLayout({
	VLayout(
		~v.layout
	)
})
)
~v = PlayerWrapperView.new(Pdef(\plop))
~v.model.isPlaying
~v.model.play
~v.model.stop


Pdef(\plop).changed(\plop, \what, \yup)
Pdef(\plop).isPlaying
Pdef(\plop).play
Pdef(\plop).stop

		PlayerWrapperView.new(Pdef(\plop)).guiBody
		YourGuiClass.new((howFast:10)).gui
(howFast:10).guiClass = YourGuiClass
~model = (howFast:10);
~model.guiClass = YourGuiClass
~model.gui
~model = MyModel.new
~model.gui
~model.guiClass = YourGuiClass
Object

Number.asString.dump



GUI.skins.redFrik        //also includes a skin
RedFont.new.dump
(
var w= Window("RedGUI test", Rect(100, 200, 400, 400)).front;
w.view.decorator= FlowLayout(w.view.bounds);
Red2DSlider(w);
RedButton(w);
RedButton(w, nil, "aaa", "bbb");
RedKnob(w);
RedLevelIndicator(w).value_(0.5);
RedMultiSliderView(w);
RedNumberBox(w);
RedPopUpMenu(w);
RedPopUpTreeMenu(w);
RedSlider(w);
RedStaticText(w, "test123");
RedTextView(w);
)



a= RedEffectsRack();
b= Pbind(\degree, Pseq([0, 1, 5, 4, 3, 4], inf), \dur, 0.25).play;
a.cvs.ringMix.value_(0.5);
a.out.value= 1
a.free;
b.stop;

a.makeView(Window.new.front)


a= RedEffectsRack([RedEfxRing, RedEfxGuit, RedEfxVerb]);
b= Pbind(\degree, Pseq([0, 1, 5, 4, 3, 4], inf), \dur, 0.25).play;
a.cvs.verbMix.input= 0.5;
a.cvs.guitMix.input= 1;
a.free;
b.stop



a= RedEffectsRack();
b= Pbind(\degree, Pseq([0, 1, 5, 4, 3, 4], inf), \dur, 0.25).play;
c= RedEffectsRackGUI(a);
a.cvs.ringMix.value_(0.5);
a.free;
b.stop;
c.close;

//--
a= RedEffectsRack([RedEfxRing, RedEfxGuit, RedEfxVerb, RedEfxRing]);
b= Pbind(\degree, Pseq([0, 1, 5, 4, 3, 4], inf), \dur, 0.25).play;
c= RedEffectsRackGUI(a);
c.redEffectsRack.efxs;
a.cvs.verbMix.value= 0.5;
a.cvs.verbDamp.value= 0.7;
a.free;
b.stop;
c.close;

//--
a= RedEffectsRack(RedEffectModule.subclasses);
b= Pbind(\degree, Pseq([0, 1, 5, 4, 3, 4], inf), \dur, 0.25).play;
c= RedEffectsRackGUI(a);
c.redEffectsRack.efxs;
a.cvs.verbMix.value= 0.5;
a.free;
b.stop;
c.close;




(
var p;
p = Patch({ arg freq; SinOsc.ar(freq,0,0.3) });
w = Window("patch",Rect(0,0,800,200)).front;

SynthConsole(p,w)
    .play
    .record("SoundFiles/testy.aiff") // sets defaultPath for the prompt dialog
    .formats
    .stop
    .scope
    .fftScope
    .tempo // gui the default Tempo
)
x = Mx.new.app;
x.gui
x = Mx.new.app;
x.gui
(
	SaveConsole(
				Array.rand(16,10,200),
						nil, // no previous path
								nil
	) //no layout
		.print // prints object
			.save
				.saveAs

)
o


(
    Instr("minimoog.two",{ arg nn=1, freq=440,int1=5,int2 = -5,width1=0.1,width2=0.1,width3=0.1,
            ffreqInterval=0,rq=0.4;
        var p;

		p = { SinOsc.ar(exprand(60,5000.0)) } ! nn.asInteger;
		nn.debug("nn");

        RLPF.ar(Mix(p),freq * ffreqInterval.midiratio,rq)
            * EnvGen.kr(Env.perc,doneAction: 2)

    }, [
        StaticIntegerSpec(1,500)
]);

    Pbind(
        \type, \instr,
        \instr, "minimoog.two",
        // note is converted to freq by things in NotePlayer
        \note,Prand([10,20,30,40],inf),
\nn, Pseq([10,20,100,1,1],inf),
        // args are passed into the function
        //\int1, Prand([-3,0,7,11,13],inf),
        \dur, 1/4,
    ).play
)

p = Patch("minimoog.two")
p.play;
p.gui
p.set(\nn, 100)
Patch("minimoog.two").nn.value = 100
Patch("minimoog.two").nn.gui

    Instr("minimoog.two",{ arg freq=440,int1=5,int2 = -5,width1=0.1,width2=0.1,width3=0.1,
            ffreqInterval=0,rq=0.4;
        var p;

		p = { SinOsc.ar(10000.0.rand) } ! 4;

        RLPF.ar(Mix(p),freq * ffreqInterval.midiratio,rq)
            * EnvGen.kr(Env.perc,doneAction: 2)

    });



//right now this works, but only with simple ugenGraphs, no Samples,Envs etc.
(Patch({ Saw.ar(400) }).wrap2( 0.5) ).gui


// not yet
(Patch({ Saw.ar(400) }).wrap2( KrNumberEditor(0.5,[0.0,1.0]) ) ).gui

//(somePatch * EnvPlayer.new(Env.newClear(10)) ).topGui
o



(
Instr(\saw, { arg freq=200,amp=0.5;
        LFSaw.ar(freq,0.0, amp);
});
    
Instr(\rlpf, { arg in,freq=200,rq=0.1;
        RLPF.ar(in, freq, rq);
});
    

i = Instr("saw") <>> Instr("rlpf");

i.gui
)

Instr("sawrlpf", {
	Instr("saw") <>> Instr("rlpf");
})

~p = Patch(CompositeInstr("saw", "rlpf"),[
	72.419167004918,
	0.5,
	300.26214578163,
	0.11351493047699
]);

~p.gui

(
Pdef(\plop, Pbind(
	\type, \instr,
	\instr, "saw",
	\note, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);


(
Instr(\bubbles, { arg speed = 0.4, amp=0.4;
        var f, zout;
        f = LFSaw.kr(speed, 0, 24, LFSaw.kr([8,7.23], 0, 3, 80)).midicps;
        zout = CombN.ar(SinOsc.ar(f, 0, 0.04), 0.2, 0.2, 4);
        zout * amp
});

// the patch specifies the actual values to be used
p = Patch(\bubbles,
        [
                0.01 // speed is a fixed float of 0.01
                // but amp is not specified, so the default 0.4 from the Instr function is used
        ]);

// but notice that it is a KrNumberEditor that was created, and it inits to the default 0.4
// from the instr function
p.gui;

)
p.play

(
	Patch(\bubbles,
		[
			                KrNumberEditor(0.01,\speed)
							        
		]).gui

)

p = Patch({ arg freq=440; SinOsc.ar( freq  )  });
// with no args supplied, a KrNumberEditor was made as input for \freq
p.args.dump;

p.play;

// each arg name automagically becomes an attribute of the patch object
p.freq;
p.freq.gui

// set its value
p.freq.value = 300

// look for the input for the 'freq' arg
// and sends it the .set(500) message if it responds to that
p.set(\freq, 500)



(
s.boot;

Instr("saw",{ arg freq=400; Saw.ar(freq) * EnvGen.kr(Env.perc,doneAction:2)});

p = Patch("saw",[KrNumberEditor(300,\freq)]);

Sheet({ arg f;
    p.gui(f);
    ActionButton(f,"asEvent",{
        p.asEvent.play.postln
    });
});

)

(
Sheet({ arg f;
	var view;
	view = View.new(f);
	p.gui(f);
	view.layout = HLayout(
		Button.new,
		Button.new,
	);
	view.
	Button.new(f).states_([[ "hello" ]]);
	ActionButton(f,"asEvent",{
		p.asEvent.play.postln
	});
});
)



(
s.waitForBoot{
        a= RedMixStereo(10, 14, 0);
        Pbind(\degree, 0, \out, 10).play;
        Pbind(\degree, 4, \out, 14).play;
        c= RedMixGUI(a);
}
)

c.parent;
c.redMix==a;
c.close;

(
w= Window("lkj", Rect(100, 200, 500, 500));
w.front;
w.view.decorator= FlowLayout(w.view.bounds, 10@10, 10@10);
a= RedMixStereo(10, 14, 0);
Pbind(\degree, 0, \out, 10).play;
Pbind(\degree, 4, \out, 14).play;
a.gui(w);
w.view.decorator.nextLine;
a.gui(w);
)

(
w= Window("hgf", Rect(100, 200, 500, 500));
w.front;
v= CompositeView(w, Rect(10, 10, 400, 400)).background_(Color.blue).decorator= FlowLayout(Rect(0, 0, 300, 300));
a= RedMixStereo(10, 14, 0);
Pbind(\degree, 0, \out, 10).play;
Pbind(\degree, 4, \out, 14).play;
a.gui(v);
v.decorator.nextLine;
a.gui(v);
)

CV
CV.viewDictionary
