
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

/////////////////////////////////////////////////////////////////////:

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
