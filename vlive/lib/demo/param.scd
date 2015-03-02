
~p = Param([Pdef(\hello), \freq, \freq.asSpec]);
~p.asSlider;
~p.asKnob;
~p.asStaticText;
~p.asNameStaticText; // show the name of Param
~p.asTextField;
~p.asTextField;
~p.asMidiResponder;
MIDIMap()
MIDIdef(\hey, ~p.asMidiResponder)
MIDIMap(~p, msgNum, chan, msgType, srcID)
---- uses
- map midi
- map OSC
- gui
- save/load
- presets/morphing ?

---- object types
- pdef
- ndef,
- ndef volume
- volume
- synth
- bus
- multichannel bus
- cached bus
- list
- Ref
- envir var
- function (button, noteOn)
- function (setter, getter (what for normGet/normSet ?))

---- param types
- scalar
- env
- array
- boolean (button, noteOn)

---- update type
- sync
- async


---- mode
- busmode
- midiblock
- softSet
- multi target ?? (implemented via ParamGroup)

---- particularities
- set Pdef instrument via Halo ?
- set Pdef spec via Halo addSpec


NdefParam : Param
	- set
	- get
	- normSet
	- normGet
	- softSet
	- normSoftSet
	- spec
	- asString (name)
	- macrokey (better name ? it's to have a Param definition without reference to object, but just litterals)


Param
	- *new dispatch to subclassses (or each method dispatch ?)
		- maybe better to hold instance in Param
	- asSlider
	- asMIDIResponderFunc

- the cache need to be handled by Param and not in bus because if we switch bus mode..
	- no, i don't see why

ParamPdef(\plop, \instrument, \bla, \freq, 60)
- need to init the Pdef(\plop, Pbind()) to be able to use it with Param as a param holder

Slider.new.mapParam(~p)

~pg = ParamGroup([
	[Pdef(\hello), \freq, \freq.asSpec],
	[Pdef(\hello), \lpf, \freq.asSpec],
])

(
	{
		~pg.do({ arg param; MIDIdef(\)param.asSlider; })
		HLayout.new(~pg.collect({ arg param; param.asSlider; }))
	}

)

- it's difficult to fix a set of important parameters (channel, msgType, etc) a MIDIMap
- it's cumbersome to have to define a name for MIDIdef
- with MIDIFunc, you have to free it before assigning a new Param
- we need to handle the freeing of old responder when assigning a new Param. It seems to need a MIDIBoard for that, MIDIdef can't do this
	- without specifying the srcID, we can't know the name of the placeholder, but a placeholder without srcID will not be replaced if now we specify a srcID
		- maybe this is not a problem, if the user want to specify a srcID then no more, he is responsible for its malheur
	- so the final is we use a dict of midi param to store last midi val and assigned Param, then MIDIBoard use this framework

- need to take in account that for midiblock, it need a reference value from the midi controller independant of the Param
	- is there a moment where a midi message from two channel, knobs or srcID must represent the same midi controller ?
		- maybe a controller which have different mode but we want to ignore that ?
		- maybe when disconnecting ? but not very common
		- some controller control using velocity, some other need to ignore velocity
	- maybe just have a dict [msgNum, channel, msgType, srcId] which store last used value, and it's used only in midi responder (asMidiResponder)
- handy to have a string representing the name of the Param

CachedBus for remembering the last value set

--- current impl
- in current implementation, the Object wrapper is bundled with midi responder, maybe we want
	- an object wrapper which respond to
		- set
		- get
		- normSet
		- normGet
		- softSet
		- normSoftSet
		- spec
		- asString (name)
		- macrokey (better name ? it's to have a Param definition without reference to object, but just litterals)
	- a midiresponder which handle midiblock and store last used value
		- maybe this should be a class method, storing midival in a classvar dict ?
- the class_midi_cc_controller is in fact a place holder where a wrapper can be installed, but the midi num never change
	- instead, Param is a kind of literal, holding no real values as values are holded in target class and MIDIBoard for midi value

-------------

- the main use of Param is to map midi controller to it in order to control a Pdef/Ndef/etc parameter
- the second main use is to map GUI to it


Object.method
Number.method

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

~p = Param(Ndef(\plop), \freq, \freq);
Param(Ndef(\plop), \freq, \freq).hash;
Param.set
~p.set(145)
~p.get
~p.map(msgNum: 64)
~p.normSet(45)
~p.methods.do(_.dump)
Object.new.object

MIDIMap(~p, msgNum:64);
MIDIMap.free(msgNum:64);
MIDIMap(~p, msgNum:64);

- how to handle updates of the GUI ?
	- sync
	- async

NdefGui

MIDIdef.cc(\test, { arg ...args; args.debug("args") }).learn
~m = MIDIFunc({ arg ...args; args.debug("args") }, 64, msgType:\control)

Pdef(\plop) === Pdef(\plop)
"kkk" === "kkk"

(
{
	o = ();
	o.win = Window.new;
	o.slider = Slider.new;
	o.slider.mapParam(~p);
	o.win.layout = HLayout.new(o.slider);
	o.win.front;
	
}.value;
)

o.slider.getHalo(\simpleController).put(\set, { arg ...args; args.debug("wTF") })

MIDIIn.connectAll


// TODO
- midiblock
- refresh gui


wrapper.whatkkk
~p.target_object

~p.set(145)
Ndef(\plop).changed(\set, \freq)
~s = SimpleController(Ndef(\plop))
~s.put(\set, { arg ... args; args.debug("whatkkk") })
~s.actions

aenv
xxxx
    
(
	~t= 1;
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var fmf;
	freq = 100 * Duty.kr(1/2/~t, 0, Dseq([
		[0,3,9,15],
		[0,4,7,11],
		[0,2,7,11],
	],inf)).midiratio;
	"salut les amis".postln;
	sig = SinOsc.ar(1000);
	sig = 0;
	sig = SinOsc.ar(100 * [1,1.001,2]) * (1+ ( SinOsc.kr(1).range(0,1)* LFSaw.ar(1414) ) );
	//sig = sig.sum;

	sig = Pan2.ar(sig, 0, amp);
	//sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
}).play;
);


(
	~t= 1;
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		1,0,4,0,
		1+12,0+12,4,0,
	],inf)).midiratio * [1, 1/2, 2] * [1,1.00001,1.000001];
	sig = LFSaw.ar(freq * ( 1 + ( SinOsc.kr(freq) * SinOsc.kr(1/4).range(0,10) * 1 )) );
	sig = SinOsc.ar(freq) + sig;
	sig = RLPF.ar(sig, \lpf.kr(11000) * SinOsc.kr( Duty.kr(1/~t, 0, Dseq([
		1,2,7,0,
	],inf))*~t).range(0,1), \rq.kr(0.5));
	sig = sig * Duty.kr(1/16/~t, 0, Dseq([
		1,0,0,0,
		0,0,0,0,
	],inf));
	sig = CombL.ar(sig, 1,1/8/~t,2) + sig;
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
	//sig = Pan2.ar(sig, pan, amp);
}).play;
);

Ndef(\plop).dependants

~p = Param(Ndef(\plop), \freq, \freq.asSpec); // create a reference to a Ndef parameter with a spec
Slider.new.mapParap(~p); // now the slider control the ndef parameter
MIDIMap(~p, 64) // now the midi controller number 64 control the ndef parameter
(
{
	o = ();
	o.win = Window.new;
	o.slider = Slider.new;
	o.win.onClose.debug("kkk");
	//o.win.onClose = o.win.onClose.addFunc( {debug("kjdfkdfjk closed")} ) ;
	o.slider.mapParam(~p);
	o.win.layout = HLayout.new(o.slider);
	o.win.front;
	
}.value;
)
nil.add({1})
nil.addFunc({1})
debug("wkkj")
o.win.close
o.slider.parent
o.slider.unmapParam;
o.slider.mapParam(~p)
o.slider.getHalo(\simpleController)
o.win.onClose[0].asCompileString
View
GUI.qt


///////////////////////////////// Pdef
Pdef(\bla, Pbind())
~p = Param(Pdef(\bla), \freqx, \freq.asSpec); // create a reference to a Ndef parameter with a spec
~p.set(15)
~p.set(25)
~p.get
~p.wrapper.inBusMode
~p.wrapper.set(14)
~p.wrapper.setBusMode
Pdef(\bla).get(\freqx)
Pdef(\bla).getVal(\freqx)
Pdef(\bla).set(\freqx,555)
Pdef(\bla).setVal(\freqx,555)

///////////////////////////////// Pdef
Pdef(\bla, Pbind())
~p = Param(Pdef(\bla), \freq, \freq.asSpec); // create a reference to a Ndef parameter with a spec
~p.set(15)
~p.set(250)
~p.get.asCompileString
~p.wrapper.inBusMode
~p.wrapper.set(14)
~p.wrapper.setBusMode
Pdef(\bla).get(\freq)
Pdef(\bla).getVal(\freqx)
Pdef(\bla).set(\freqx,555)
Pdef(\bla).setVal(\freqx,555)

(
{
	o = ();
	o.win = Window.new;
	o.slider = Slider.new;
	o.win.onClose.debug("kkk");
	//o.win.onClose = o.win.onClose.addFunc( {debug("kjdfkdfjk closed")} ) ;
	o.slider.mapParam(~p);
	o.win.layout = HLayout.new(o.slider);
	o.win.front;
	
}.value;
)

(
Pdef(\plop, Pdef(\bla) <> Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);

////////////////////////////////////////// array ???

~p = Param(Pdef(\bla), \freq, XArraySpec(\freq ! 3))
~p.set([150,250,452])
~p.get

Pdef(\bla, Pbind())
Pdef(\bla).get(\freq)
Pdef(\bla).unset(\freq)
~p0 = Param(Pdef(\bla), \freq, XArraySpec(\freq ! 8)).at(0); 
~p0 = Param(Pdef(\bla), \freq, XArraySpec(\freq ! 8)).at(0); 
MIDIMap(~p.at(0), 64) 

~p.get
~p.at(0).get
~p0.get
~p0.set(1000)

~midibay.do { arg num, x;
	MIDIMap(~p.at(x), num) 
}

~p.asMultiSlider;
Ndef

~p = Param(Ndef(\plopx), \freq, XArraySpec(\freq ! 8))
~p.set(~p.spec.default)
Ndef(\plopx).get(\freq)
Ndef(\plopx).setn(\freq, 400!8)
Ndef(\plopx).setn(\freq, 300!8)

(
Ndef(\plopx, { arg freq, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(\freq.kr(100!8));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

//////////////////////////////////////////////////// TEST

(
SynthDef(\yep, { arg out=0, amp=0.1, gate=1, pan=0;
	var sig;
	sig = SinOsc.ar(\freq.kr(100!3).poll);
	//sig = SinOsc.ar(\freq.kr(100!3));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\bla, Pbind());
Pdef(\plop, Pdef(\bla) <> Pbind(
	\instrument, \yep,
	\dur, 1,
	\amp, 0.1
).trace).play;
);

~p.get
~p.getRaw
~p.set(450) // dont work in bus mode :(

~p = Param(Pdef(\bla), \freq, XArraySpec(\freq ! 3))
~p.set([450,1250,452]) // dont work in bus mode :(
~p.set([655,250,452])
~p.get
Pdef(\bla).get(\freq)

~p.wrapper.inBusMode()
~p.wrapper.target.setBusMode(\freq, true, true)
~p.wrapper.target.inBusMode(\freq)
~p.wrapper.class
~p.wrapper.setBusMode(\freq)
~p.setBusMode
~p.setBusMode(false)

Pdef(\bla, Pbind());
Pdef(\bla).get(\freq)
Pdef(\bla).set(\freq, 1100)
Pdef(\bla).getVal(\freq)
Pdef(\bla).setVal(\freq, [1100, 255,477])
Pdef(\bla).setBusMode(\freq)
Pdef(\bla).setBusMode(\freq, false)

~bus = Pdef(\bla).get(\freq).asCachedBus(3)
~bus = Pdef(\bla).get(\freq)[0][0].asCachedBus
~bus.get
~bus.set(100)
~bus.set(400)
~bus.get(_.debug)
~bus

~p.at(1).set(100)

Pbind
EventStreamPlayer
)==*

~bus2 = Bus.control(s, 3)
~bus2.asMap
~bus = Bus.control(s, 3)
~bus.setn([100,200,300])
~bus.set(100,200,300)
~bus.get(_.debug)

~bus.value

~buss = [ Bus.control(s,1), Bus.control(s,1), Bus.control(s,1)]
~bussm = ~buss.collect(_.asMap)
~buss[0].get(_.debug)
~buss[0].set(1000)
~buss[1].set(200)
(
Pdef(\plop, Pbind(
	\instrument, \yep,
	\freq, [ ~bussm ],
	\dur, 1,
	\amp, 0.1
)).trace.play;
);

(
{
	o = ();
	o.win = Window.new;
	o.slider = Slider.new;
	o.win.onClose.debug("kkk");
	//o.win.onClose = o.win.onClose.addFunc( {debug("kjdfkdfjk closed")} ) ;
	o.slider = MultiSliderView.new.size_(3);
	o.slider.action = { arg xthis; ~p.normSet(xthis.value.debug("args fuck")); };
	//o.slider.mapParam(~p);
	o.win.layout = HLayout.new(o.slider);
	o.win.front;
	
}.value;
)
XArraySpec(\freq ! 3)
~p = Param(Pdef(\bla), \freq, XArraySpec(\freq ! 3))
~p.set([450,250,452]) // dont work in bus mode :(
~p.set([255,250,452])
~p.get

~p.numChannels
(
{
	o = ();
	o.win = Window.new;
	o.slider = Slider.new;
	o.win.onClose.debug("kkk");
	//o.win.onClose = o.win.onClose.addFunc( {debug("kjdfkdfjk closed")} ) ;
	o.slider = ~p.asMultiSlider;
	//o.slider = MultiSliderView.new.size_(3);
	//o.slider.action = { arg xthis; ~p.normSet(xthis.value.debug("args fuck")); };
	//o.slider.mapParam(~p);
	o.win.layout = HLayout.new(o.slider);
	o.win.front;
	
}.value;
)

o.slider.reference = [0.2,0.3,0.4]
o.slider.reference = 0!3
o.slider.value

~bus2 = Bus.control(s, 3);
~bus2.asMap;
~bus2.setn([400,2200,1300])
(
Pdef(\plop, Pbind(
	\instrument, \yep,
	\freq, [ ~bus2.asMap ],
	\dur, 1,
	\amp, 0.1
)).trace.play;
);


////////////////////////////////// spec


(
SynthDef(\yep, { arg out=0, amp=0.1, gate=1, pan=0;
	var sig;
	sig = SinOsc.ar(\freq.kr(100!3).poll);
	//sig = SinOsc.ar(\freq.kr(100!3));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}, metadata:(
	specs: (
		freq: XArraySpec(\freq!3)
	)
)).add;
);

(
Pdef(\bla, Pbind());
Pdef(\plop, Pdef(\bla) <> Pbind(
	\instrument, \yep,
	\dur, 1,
	\amp, 0.1
).trace).play;
);

Pdef(\bla).addHalo(\instrument, \yep)
~p = Param(Pdef(\bla), \freq)
~p.spec
~p.set([450,1250,452]) // dont work in bus mode :(
~p.set([655,250,452])
~p.get
Pdef(\bla).get(\freq)


///////// NDEF


(
Ndef(\bla, { arg pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(\freq.kr(100!8).poll);
	sig = Pan2.ar(sig, pan, amp).flop.mean;
	sig.debug;
}).play;
);

(
Ndef(\bla1, { arg pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(\freq.kr(100).poll);
	sig = Pan2.ar(sig, pan, amp).flop.mean;
	sig.debug;
}).play;
);

Ndef(\bla).clear

~p = Param(Ndef(\bla), \bipolar)
~p = Param(Ndef(\bla), \xxx)
Ndef(\bla).addSpec(\xxx, ControlSpec(0,1215,\lin,0,1))
Param.toSpec(nil, \bipolar)
~p.spec
~p.wrapper.toSpec(nil)
nil ? 4
Ndef(\bla).getSpec(\freq)
Ndef(\bla).setSpec(\freq)
~p = Param(Ndef(\bla), \freq, XArraySpec(\freq!8))
~p.set([450,1250,452]) // dont work in bus mode :(
~p.set(~p.spec.default)
~p.get
Ndef(\bla).get(\freq)
Ndef(\bla).setn(\freq, [100,212,1555])
Ndef(\bla).set(\freq, [100,212,1555])
Ndef(\bla).set(\freq, 1555)
Ndef(\bla1).set(\freq, 1555)

(
{
	o = ();
	o.win = Window.new;
	o.slider = ~p.asMultiSlider;
	o.slider.elasticMode = 1;
	o.win.layout = HLayout.new(o.slider);
	o.win.front;
	
}.value;
)



(
var size;
size = 350 / 6;
w = Window.new;
w.view.decorator = FlowLayout(w.view.bounds);
m = MultiSliderView(w, Rect(0, 0, 350, 100));
m.value_(Array.fill(size, {0.01}));
m.isFilled_(true); // width in pixels of each stick
m.indexThumbSize_(2.0); // spacing on the value axis
m.gap_(4);
w.front;
)

// rotate the above graph
(
m.bounds_(Rect(0, 0, 100, 350));
m.indexIsHorizontal_(false);
)


(
n=4;

w = Window("MultiSlider Options", Rect(200, Window.screenBounds.height-550, 600, 450));
f={
    w.view.decorator = FlowLayout( w.view.bounds, 10@10, 10@2 );
    m = MultiSliderView(w,Rect(0,0,580,200)); // default thumbWidth is 13
    m.value=Array.fill(n, {|v| 0.5+((0.3*v).sin*0.25)});
    m.action = { arg q;q.value.postln; };

    StaticText(w,380@18).string_("indexThumbSize or thumbSize");
    Slider(w,580@10).action_({arg sl; m.indexThumbSize=sl.value*24}).value_(0.5);
    StaticText(w,380@18).string_("valueThumbSize");
    Slider(w,580@10).action_({arg sl; m.valueThumbSize=sl.value*24}).value_(0.5);
    StaticText(w,580@18).string_("xOffset or gap");
    Slider(w,580@10).action_({arg sl; m.xOffset=sl.value*50});
    StaticText(w,580@18).string_("startIndex");
    Slider(w,580@10).action_({arg sl; m.startIndex = sl.value *m.size};);

    CompositeView(w,580@10);//spacer
    Button(w,100@20).states_([["RESET",Color.red]])
        .action_({ w.view.removeAll; f.value; });
    h=StaticText(w,450@18).string_("").stringColor_(Color.yellow);
    Button(w,100@20).states_([["elasticMode = 0"],["elasticMode = 1",Color.white]])
        .action_({|b| m.elasticMode = b.value});
    Button(w,160@20).states_([["indexIsHorizontal = false"],["indexIsHorizontal = true",Color.white]])
        .action_({|b| m.indexIsHorizontal = b.value.booleanValue}).value_(1);
    Button(w,120@20).states_([["isFilled = false"],["isFilled = true",Color.white]])
        .action_({|b| m.isFilled = b.value.booleanValue});
    Button(w,120@20).states_([["drawRects = false"],["drawRects = true",Color.white]])
        .action_({|b| m.drawRects = b.value.booleanValue}).valueAction_(1);
    Button(w,100@20).states_([["drawLines = false"],["drawLines = true",Color.white]])
        .action_({|b| m.drawLines = b.value.booleanValue});
    Button(w,160@20).states_([["readOnly = false"],["readOnly = true",Color.white]])
        .action_({|b| m.readOnly = b.value.booleanValue});
    Button(w,120@20).states_([["showIndex = false"],["showIndex = true",Color.white]])
        .action_({|b| m.showIndex = b.value.booleanValue});
    Button(w,120@20).states_([["reference = nil"],["reference filled",Color.white],["reference random",Color.yellow]])
        .action_({|b| b.value.booleanValue.if({
            (b.value>1).if(
                {m.reference=Array.fill(n, {1.0.rand})},
                {m.reference=Array.fill(m.size, {0.5})});
                },{ q=m.value;m.reference=[]; h.string="reference can't be returned to nil presently. please hit RESET."}
            )
        });
    Button(w,180@20).states_([["fillColor = Color.rand"]]).action_({m.fillColor=Color.rand});
    Button(w,180@20).states_([["strokeColor = Color.rand"]]).action_({m.strokeColor=Color.rand});
    Button(w,180@20).states_([["background = Color.rand"]]).action_({m.background=Color.rand});

};
f.value;
w.front;

)
