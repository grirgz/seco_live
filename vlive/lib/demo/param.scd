// TODO:
- Param.asView
- what to do to prevent using method for env on scalar, and mismatching types in general, and what about env specific methods
- how work shapeNumber in Env.asArray
- write a gui with button and zoom for XEnvelopeView
- write a list of features / documentation to see more clearly
- rewrite MIDIBoard
- write ParamGroup
- get default value in target
- Param.unset (set default target value)
- Param.unset (unset Pdef and Ndef)
- write wrapper for
	- statictext
	- textfield
	- slider2D
	- popupmenu
- handle lists and dictionaries
- write tests

/////////////////////////////////

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
- dictionary
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
Param.fromList([ \freq, \freq, \freq ])
Param.fromDictionary((lp: \freq, hp:\freq, fm:\freq ))

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
~p.set([450,1250,452]) 
~p.set([655,250,452])
~p.get
Pdef(\bla).get(\freq)


///////// NDEF
// ndef dont work in array mode, am i crazy ?


(
Ndef(\bla, { arg pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(\freq.kr(100!3).poll);
	sig.debug("sig1");
	sig = Pan2.ar(sig, pan, amp).mean;
	sig.debug("sig");
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
~p = Param(Ndef(\bla), \freq, XArraySpec(\freq!3))
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


///////// NDEF
// ndef dont work in array mode, am i crazy ?
// test
// seems not :((((


(
Ndef(\xbla, { arg pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(\xfreq.kr(100!3).poll);
	sig.debug("sig1");
	sig = Pan2.ar(sig, pan, amp).mean;
	sig.debug("sig");
}).play;
);

Ndef(\xbla).clear

Ndef(\xbla).get(\xfreq)
Ndef(\xbla).setn(\xfreq, [100,212,1555])
Ndef(\xbla).set(\xfreq, [100,212,1555])
Ndef(\xbla).set(\xfreq, 1555)
///////////////////////////// ENV Pdef

XEnvSpec(\freq!3, \sustain!3).curves

(
SynthDef(\yep, { arg out=0, amp=0.1, gate=1, pan=0;
	var sig;
	var freq;
	freq = EnvGen.ar( \freqenv.kr(Env([100,1000,200], [0.2,0.2])),gate,doneAction:0);
	sig = SinOsc.ar(freq);
	//sig = SinOsc.ar(\freq.kr(100!3));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}, metadata:(
	specs: (
		freqenv: XEnvSpec(\freq!3, \sustain!3)
	)
)).add;
);


(
Pdef(\bla, Pbind());
Pdef(\plop, 
	
	(Pbind(
		\printme, Pfunc({ arg ev; ev[\freqenv].asCompileString.debug("freqenv!") })
	)
	<>
	Pdef(\bla) <> Pbind(
	\instrument, \yep,
	\dur, 1,
	\amp, 0.1
)).trace).play;
);

(
Pdef(\plop, Pbind(
	\freqenv, [ Env([400,100,3000],[0.1,0.3]) ],
	//\freqenv, Env([400,100,3000],[0.1,0.3]), // don't work
	\instrument, \yep,
	\dur, 1,
	\amp, 0.1
).trace).play;
);

Pdef(\bla).set(\freqenv, Env([4000,100,300],[0.1,0.3]))
Pdef(\bla).set(\freqenv, Env([400,100,700],[0.1,0.3]))
Pdef(\bla).set(\freqenv, [Env([400,100,700],[0.1,0.3])])
Pdef(\bla).setVal(\freqenv, Env([400,100,700],[0.1,0.3]))
Pdef(\bla).get(\freqenv)
Pdef(\bla).get(\freqenv).asCompileString
Pdef(\bla).asStream.next(Event.default)

~p = Param(Pdef(\bla), \freqenv, XEnvSpec(\freq!3, \sustain!3))
~p.set(Env([4000,100,300],[0.1,0.3]))
~p.set(Env([3400,130,1300],[0.1,0.3]))
~p.get.asCompileString
~p.wrapper
~env = Env([4000,100,300],[0.1,0.3])
~env.isSequenceableCollection
Env([4000,100,300],[0.1,0.3])

///////////////////////////// ENV Ndef

(
Ndef(\blax, { arg amp=0.1, pan=0;
	var sig;
	var freq;
	freq = EnvGen.ar( \freqenv.kr(Env([100,1000,200], [0.2,0.2])),Impulse.kr(1),doneAction:0);
	sig = SinOsc.ar(freq);
	//sig = SinOsc.ar(\freq.kr(100!3));
	sig = Pan2.ar(sig, pan, amp);
}).play
);
Ndef(\blax).clear
Ndef(\blax).set(\freqenv, Env([3400,130,1300],[0.1,0.3]));
~p = Param(Ndef(\blax), \freqenv, XEnvSpec(\freq!3, \sustain!3))
~p.set(Env([4000,100,300],[0.1,0.3]))
~p.set(Env([3400,130,1300],[0.1,0.3]))
~p.get.asCompileString


///////////////////////////////// env gui

\curves.asSpec

\sustain.asSpec
\freq.asSpec
~env = Env([4000,100,300],[0.1,0.9]);
~spec = XEnvSpec(\freq!3, \sustain!3);
~spec.unmap(~env).asCompileString
~env.times
(
{
Spec.add(\sustain, ControlSpec(0,16,\lin,0,1));
~env = Env([4000,100,300],[1,4.3],[40.1,7]);
~spec = XEnvSpec(\freq!3, \sustain!3);
	o = ();
	o.win = Window.new;
	o.win.alwaysOnTop = true;


	o.slider = XEnvelopeView.new(nil, Rect(0, 0, 230, 80))
		.drawLines_(true)
		.selectionColor_(Color.red)
		.drawRects_(true)
		.step_(0)
		.thumbSize_(10)
		//.setEnv(~env)
		.setEnv(~spec.unmap(~env, true))
		.keepHorizontalOrder_(true);

	o.slider.grid = Point(1/16,1/8);
	o.slider.totalDur = ~spec.times[0].unmap(10);
	o.slider.gridOn = true;
	//o.slider.zoomFit;
	o.win.layout = HLayout.new(o.slider);
	o.win.front;
	
}.value;
)

o.slider.zoomFit
o.slider.totalDur = ~spec.times[0].umap(1)
o.slider.totalDur = ~spec.times[0].unmap(8)
o.slider.totalDur = ~spec.times[0].unmap(16)
o.slider.totalDur = ~spec.times[0].unmap(2).debug("yep")
o.slider.totalDur
~spec.times[0].map(o.slider.totalDur)
o.slider.value = [ [0,0.2,4.3], [0,0.2,1.0] ]
o.slider.timeScale = 1/o.slider.duration
o.slider.timeScale  = 1
o.slider.timeScale  = ~spec.times[0].unmap(1)
o.slider.timeScale  
o.slider.duration
o.slider.grid = Point(1/32,1/8)
o.slider.grid = Point(o.slider.duration * o.slider.timeScale / 4,0.1)
\freq.asSpec.grid.dump

o.slider.getEnv.asCompileString
~spec.map(o.slider.getEnv).asCompileString
o.slider.getEnv.asCompileString == ~spec.unmap(~env).asCompileString
o.slider.getEnv == ~spec.unmap(~env)
[ o.slider.getEnv.asCompileString, ~spec.unmap(~env).asCompileString ]

~envview_getEnv.(o.slider).asCompileString == ~spec.unmap(~env).asCompileString
[ ~envview_getEnv.(o.slider).asCompileString , ~spec.unmap(~env).asCompileString ]

~spec.map(o.slider.getEnv).asCompileString


(
	~setEnv = { arg xthis, env;
		var times;
		env.times.debug("settimes");
		times = env.times.integrate;
		times.debug("settimes");
		times = [0] ++ times;
		times.debug("settimes");
		if( times.last > 0 ) {times = times / times.last};
		times.debug("settimes");
		xthis.value = [times, env.levels];
		xthis.curves = env.curves;
		xthis;
	};
~envview_getEnv = { arg envview;
	var curves;
	var times;
	var levels;
	var env;
	times.debug("times");
	times = envview.value[0];
	times.debug("times2");
	times = times.drop(1);
	times.debug("times3");
	times = times.differentiate;
	times.debug("times4");
	levels = envview.value[1];
	curves = envview.curves;
	env = Env.new(levels, times, curves);
	env
};
~setEnv.((), ~spec.unmap(~env)).debug("setEnv");
[  ~spec.unmap(~env).asCompileString, ~envview_getEnv.(o.slider).asCompileString ].debug("in, out");
~envview_getEnv.(o.slider).asCompileString == ~spec.unmap(~env).asCompileString;
)

(
{
	o = ();
	o.win = Window.new;


			o.slider = EnvelopeView.new(nil, Rect(0, 0, 230, 80))
				.drawLines_(true)
				.selectionColor_(Color.red)
				.drawRects_(true)
				.step_(0)
				.thumbSize_(10)
				.keepHorizontalOrder_(true)
				.value_(self.controller.get_norm_xy);
			self.env_view = slider;
			self.env_view.selectIndex(1);
			self.env_view.action = { arg env;
				if(env.index == 0 and: { env.x > 0 }) {
					env.x = 0;
				};
				self.controller.set_norm_xy(env.value);
				self.update_label;
				self.update_knobs;
			};
			self.env_view.mouseDownAction = { arg view, x, y, mod;
				self.mouse_down_point = Point(x,y);
				self.mouse_down_index = view.index;
				self.mouse_down_time_scale = self.controller.time_scale;
			};
			self.env_view.mouseUpAction = { arg view, x, y, mod;
				self.update_knobs;
				if(mod.isShift) {
					self.env_view.selectIndex(self.mouse_down_index)
				}
			};
			self.env_view.mouseMoveAction = { arg view, x, y, mod;
				var val;
				if(mod.isShift) {
					val = x - self.mouse_down_point.x;
					self.controller.time_scale = self.mouse_down_time_scale + (val/500);
					self.update_env;
				}
			};

	o.win.layout = HLayout.new(o.slider);
	o.win.front;
	
}.value;
)


//////////////////////////// env gui act on param

(
Ndef(\blax, { arg amp=0.1, pan=0;
	var sig;
	var freq;
	freq = EnvGen.ar( \freqenv.kr(Env([100,1000,200], [0.2,0.2])),Impulse.kr(1),doneAction:0);
	sig = SinOsc.ar(freq);
	//sig = SinOsc.ar(\freq.kr(100!3));
	sig = Pan2.ar(sig, pan, amp);
}).play
);
Ndef(\blax).clear
Ndef(\blax).set(\freqenv, Env([3400,130,1300],[0.1,0.3]));
(
Spec.add(\sustain, ControlSpec(0,16,\lin,0,1));
~p = Param(Ndef(\blax), \freqenv, XEnvSpec(\freq!3, \sustain!3));
~p.set(Env([4000,100,300],[0.1,0.3]));
)
~p.set(Env([3400,130,1300],[0.1,0.3]))
~p.get.asCompileString
~p.normGet.asCompileString

(
{
	o = ();
	o.win = Window.new;
	o.win.alwaysOnTop = true;


	o.slider = XEnvelopeView.new(nil, Rect(0, 0, 230, 80))
		.drawLines_(true)
		.selectionColor_(Color.red)
		.drawRects_(true)
		.step_(0)
		.thumbSize_(10)
		//.setEnv(~env)
		.setEnv(~p.normGet)
		.keepHorizontalOrder_(true);

	o.slider.action = { arg self;
		var val = self.value;
		if( val[0][0] != 0) {
			val[0][0] = 0;
			self.value = val;
		};
		~p.normSet(self.getEnv);
	};
	o.slider.elasticSelection = false;
	o.slider.grid = Point(~p.spec.times[0].unmap(1/8),1/8).debug("gridxx");
	o.slider.totalDur = ~p.spec.times[0].unmap(2);
	o.slider.gridOn = true;
	//o.slider.zoomFit;
	o.win.layout = HLayout.new(o.slider);
	o.win.front;
	
}.value;
)
o.slider.zoomFit
o.slider.totalDur
~spec.m
~p.spec.times[0].map(o.slider.totalDur)



(
// use shift-click to keep a node selected
w = Window("envelope", Rect(150 , Window.screenBounds.height - 250, 250, 100)).front;
w.view.decorator = FlowLayout(w.view.bounds);

b = EnvelopeView(w, Rect(0, 0, 230, 80))
    .drawLines_(true)
    .selectionColor_(Color.red)
    .drawRects_(true)
    .resize_(5)
    .step_(0.05)
    .action_({arg b; [b.index, b.value].postln})
    .thumbSize_(5)
    .value_([[0.0, 0.1, 0.5, 1.0],[0.1,1.0,0.8,0.0]]);
w.front;
)

// show grid
b.gridOn_(true);

// show Env
b.setEnv(Env.asr(0.5,1, 0.2));

// make the first point unmoveable
(
b.setEditable(0,false);
)

(
w = Window("envelope", Rect(150 , Window.screenBounds.height - 250, 400, 150)).front;
w.view.decorator = FlowLayout(w.view.bounds);

b = EnvelopeView(w, Rect(0, 0, 350, 100))
    .thumbSize_(5)
    .drawLines_(true)
    .fillColor_(Color.green)
    .selectionColor_(Color.red)
    .drawRects_(true)
    .value_([(0.0, 0.1 .. 1.0), (0.0, 0.1 .. 1.0)])
    .setEditable(0,false);
)

(
r = Routine({
    var j = 0;
    20.do({ arg i;
        b.selectIndex((b.size - 1).rand.abs);
        0.1.wait;
        b.x_(1.0.rand.abs);
        b.y_(1.0.rand.abs);
    });
    b.selectIndex(-1);
});
AppClock.play(r);
)


//////////////////////////// env gui act on param

(
Ndef(\blax, { arg amp=0.1, pan=0;
	var sig;
	var freq;
	freq = EnvGen.ar( \freqenv.kr(Env([100,1000,200], [0.2,0.2]).asArray),Impulse.kr(1),doneAction:0);
	sig = SinOsc.ar(freq);
	//sig = SinOsc.ar(\freq.kr(100!3));
	sig = Pan2.ar(sig, pan, amp);
}).play
);

[ [10,20,30] ].unbubble.unbubble
[10].unbubble.unbubble
[10].bubble.bubble

Ndef(\blax).clear
Ndef(\blax).set(\freqenv, Env([3400,130,1300],[0.1,0.3]));
(
Spec.add(\sustain, ControlSpec(0,16,\lin,0,1));
~p = Param(Ndef(\blax), \freqenv, XEnvSpec(\freq!3, \sustain!3));
~p.set(Env([4000,100,300],[0.1,0.3]));
)
~p.set(Env([3400,130,1300],[0.1,0.3]))
~p.get.asCompileString
~p.normGet.asCompileString

(
{
	o = ();
	o.win = Window.new;
	o.win.alwaysOnTop = true;

	o.slider = ~p.asEnvelopeView;
	o.win.layout = HLayout.new(o.slider);
	o.win.front;
	
}.value;
)

/////////////////// get default value in target

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

Ndef(\plop).get(\freq)
Ndef(\blax).get(\freqenv).asEnv.asCompileString
Ndef(\blax).unset(\freqenv)
Ndef(\plop).unset(\freq)

Env([3400,130,1300],[0.1,0.3],[-2,2]).asCompileString.debug("in"); Env([3400,130,1300],[0.1,0.3],[-2,2],1,0).asArray.asEnv.asCompileString



		SynthDescLib.global.synthDescs[\synthdef_scalar].controlDict[\freq].defaultValue

(
~pbind = Pbind(
	\instrument, \plop,
	\bla, \kra
);
)
~pbind.patternpairs
1/0.025

{SinOsc.kr(1) }.plot(1)


Ndef(\plop, { 
	\freq.kr = SinOsc.kr(0.2); 
	SinOsc.ar(\freq.kr(100))
}).play; 
Ndef(\lfo, { SinOsc.ar(1/2).range(50,300)  }); 
Ndef(\plop2).map(Ndef(\lfo));

Ndef(\plop, { 
	var lfo = SinOsc.kr(0.2); 
	Out.kr(~bus, lfo);
	SinOsc.ar(lfo)
}).play; 
Ndef(\plop2, { 
	SinOsc.ar(\freq.kr)
}).play; 
Ndef(\plop2).map(\freq, ~bus)


