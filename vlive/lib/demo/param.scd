// Done
- Param.asView
- rewrite MIDIBoard
- write ParamGroup
- write wrapper for
	- statictext
	- textfield

// TODO:
- what to do to prevent using method for env on scalar, and mismatching types in general, and what about env specific methods
- how work shapeNumber in Env.asArray
- write a list of features / documentation to see more clearly
- get default value in target
- Param.unset (set default target value)
- Param.unset (unset Pdef and Ndef)
- handle lists and dictionaries
- XEnvSpec.adsr (asr, perc)
- Param.at(\attack) (decay, sustain, release)
- Param.levelsAt(0)
- Param.timesAt(0)
- Param.curveAt(0)
- write tests
- handle
	- Ndef volume
	- Archive list and dict
	- Tempo
	- Master volume
- MIDIMap.learn
- OSCMap
- Pdef.asParamGroup.edit

// version 2

- write a gui with button and zoom for XEnvelopeView
- other type of param
	XGateSpec : Spec {
	XTrigSpec : Spec {
	XBusSpec : Spec {
	XSampleSpec : XBusSpec {
	XWavetableSpec : XBusSpec {
	XBusSpec : Spec {
	XInBusSpec : Spec {
	XOutBusSpec : Spec {
- write wrapper for
	- slider2D
	- popupmenu

/////////////////////////////////
- spec source
	- param arg
	- halo
	- synthdef spec metadata
		- instrument name from halo
		- instrument name from pattern introspection
	- arg name in Spec
	- default value
	- param structure (\adsr -> \levels -> 0)
	- default spec

- ndef spec source
	- param arg
	- halo
	- arg name in Spec
	- default value
	- param structure (\adsr -> \levels -> 0)
	- default spec

- pdef spec source
	- param arg
	- halo
	- synthdef spec metadata
		- instrument name from halo
		- instrument name from pattern introspection
	- arg name in Spec
	- default value of synthdef if instr found
	- value in pdef
	- param structure (\adsr -> \levels -> 0)
	- default spec

- default value
	- synthdesc default
	- ndef default
	- spec default


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
- tempo
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
- boolean (button, noteOn, trig.tr)
- gate

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

(
Ndef(\plop, { arg freq=200, freq2=300, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar([ freq, freq2 ]).mean;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
~list = [
	Param(Ndef(\plop), \freq, \freq),
	Param(Ndef(\plop), \freq2, \freq),
];
)

Ndef(\plop).clear
Ndef(\plop).dependants 
Ndef(\plop).releaseDependants
Ndef(\plop).dependants.do(_.remove)
Ndef(\plop).set(\freq, 100)
~list[0].set(100)

~list.do({ arg x; x.target.releaseDependants });

(
~makegui2 = { arg fun;
	var win;
	var widget;
	win = Window.new;
	//widget = fun.();
	win.layout = HLayout.new(*~list.collect({ arg x; x.asView }));
	//win.layout = HLayout.new([Slider.new, Slider.new]);
	win.alwaysOnTop = true;
	win.front;
};
~makegui2.()
)

~makegui.({ HLayout.new(*~list.collect(_.asView)) })

(
w = Window().front;
a = { Button(w) } ! 10;
w.layout = HLayout(*a);
);


(
	
)

(
Ndef(\ndef_scalar, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
~p = Param(Ndef(\ndef_scalar), \freq, \freq);
);

(
{
	o = ();
	o.win = Window.new;
	o.win.alwaysOnTop = true;

	//o.slider = StaticText.new;
	o.slider = XStaticText.new;
	o.slider.value = ~p.get;
	o.win.layout = HLayout.new(o.slider);
	o.win.front;
	
}.value;
)
(
{
Ndef(\ndef_scalar, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
~p = Param(Ndef(\ndef_scalar), \freq, \freq);

	o = ();
	o.win = Window.new;
	o.win.alwaysOnTop = true;

	//o.slider = StaticText.new;
	o.slider = StaticText.new;
	o.slider2 = Slider.new;
	o.slider3 = StaticText.new;
	o.slider4 = TextField.new;
	o.slider5 = Button.new;
	o.slider5.states = [
		["plop"],
		["bla"],
		["rahhhh"],
	];
	o.slider.mapParam(~p);
	o.slider2.mapParam(~p);
	o.slider3.mapParamLabel(~p);
	o.slider4.mapParam(~p);
	o.slider5.mapParam(~p);
	//o.slider6.mapParam(~p);
	//o.slider4.action = { arg view;
	//	view.value.debug("WTFF")
	//};
	o.win.layout = VLayout.new(o.slider, o.slider2, o.slider3, o.slider4, o.slider5);
	o.win.front;
	
}.value;
)
o.slider.value = "plop"
200.asStringPrec(6).asCompileString

o.slider5.states.size


(
	~fiou = { arg x;
		var size = 0;
		//if(size <= 1) {
		//	size = 2;
		//};
		x.linlin(0,size-1,0,1);
	};
	~fiou.(1);
)


(
~b = SimpleButton(nil,"push me",{
 "you pushed me".postln
});
~b.action = { arg view;
	~b.label = ~b.view.states[0][0].scramble;
	~b.color = Color.rand;
	~b.background = Color.rand;
	
}


)

ParamGroup(ParamGroup(~list))

ParamPreset(\myfx, [
	[Pdef(\plop), \freq],
	[Pdef(\plop), \lpfreq],
	[Pdef(\plop), \rq],
	[Ndef(\echo), \shift1],
	[Ndef(\echo), \shift2],
]);

ParamPreset(\myfx).save(\hello)
ParamPreset(\myfx).load(\hello)
ParamPreset(\myfx).erase(\hello)

ParamPreset(\myfx).erase(\hello)


(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfreq.kr(100), \rq.kr(0.3));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	rq: ControlSpec(0.001,4,\lin, 0, 1),
	lpfreq: \freq,
	freq: \freq,
))).add;

BusDef(\fx1, \audio);

Pdef(\plop, Pbind(
	\instrument, \default,
	\out, BusDef(\fx1),
	\legato, 0.1,
	\dur, 1,
	\amp, 0.1
));

Ndef(\echo, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var del = 0.2;
	sig = InFeedback.ar(BusDef(\fx1),2);
	sig1 = DelayL.ar(sig, 1,del);
	sig1 = FreqShift.ar(sig1, \shift1.kr(100));
	sig2 = DelayL.ar(sig1, 1,del);
	sig2 = FreqShift.ar(sig2, \shift2.kr(300));
	sig = [sig, sig1, sig2].mean;
});

Spec.add(\shift, ControlSpec(-800,800,\lin,0,1));
Ndef(\echo).addSpec(\shift1, \shift.asSpec);
Ndef(\echo).addSpec(\shift2, \shift.asSpec);

~list = [
	[Pdef(\plop), \freq],
	[Pdef(\plop), \lpfreq],
	[Pdef(\plop), \rq],
	[Ndef(\echo), \shift1],
	[Ndef(\echo), \shift2],
];

ParamPreset(\mypreset, ~list);

~makeguix = { arg list;
	o = ();
	o.win = Window.new;
	o.win.alwaysOnTop = true;

	
	o.playout = HLayout(*list.collect { arg param;
		param = param.asParam;
		VLayout(
			param.asStaticTextLabel,
			param.asSlider,
			param.asStaticText,
		);
	});
	o.mlayout = VLayout(
		o.playout,
		HLayout(
			VLayout(
				XSimpleButton.new.label_("load preset1").action_({ ParamPreset(\mypreset).load(\preset1) }),
				XSimpleButton.new.label_("save preset1").action_({ ParamPreset(\mypreset).save(\preset1) }),
			),
			VLayout(
				XSimpleButton.new.label_("load preset2").action_({ ParamPreset(\mypreset).load(\preset2) }),
				XSimpleButton.new.label_("save preset2").action_({ ParamPreset(\mypreset).save(\preset2) }),
			),
		)
	);

	o.win.layout = o.mlayout;

	o.win.front;
	
};
~makeguix.(~list);

);


~pg = ParamGroup(~list)
~pg.save(\yop)
~pg.load(\yop)
~pg.array
ParamPreset(\mypreset, ~list)
ParamPreset(\mypreset).save(\yip)
ParamPreset(\mypreset).load(\yip)
ParamPreset(\mypreset).group.presets
MIDIMap.key(\k1, ParamPreset(\mypreset).at(0))
MIDIMap.key(\k1, Param([Pdef(\plop), \freq]))
MIDIMap(Param([Pdef(\plop), \freq]), msgNum:16)
MIDIdef.cc(\bla, { arg ... args; args.debug("lll") }, msgNum:16)
MIDIdef.cc(\bla, { arg ... args; args.debug("lll") }).learn

ParamPreset(\mypreset).do { arg p,x; MIDIMap.key(\k+++(x+1), p) }

/////////////////////////////////////////////// MIDI

(
MIDIMap.permanent = true;
MIDIMap.define([nil, ~icon_device_id], [
	\left, \note -> 91,
	\right, \note -> 92,

	\stop, \note -> 93,
	\play, \note -> 94,

	\record, \note -> 95,
	\loop, \note -> 86,

	\k1, 16,
	\k2, 17,
	\k3, 18,
	\k4, 19,
	\k5, 20,
	\k6, 21,
	\k7, 22,
	\k8, 23,
	\k9, 12,

	\s1, [13,0],
	\s2, [13,1],
	\s3, [13,2],
	\s4, [13,3],
	\s5, [13,4],
	\s6, [13,5],
	\s7, [13,6],
	\s8, [13,7],
	\s9, [13,8],

	\a1, \note -> 16,
	\a2, \note -> 17,
	\a3, \note -> 18,
	\a4, \note -> 19,
	\a5, \note -> 20,
	\a6, \note -> 21,
	\a7, \note -> 22,
	\a8, \note -> 23,
	\a9, \note -> 48,

	\c1, \note -> 8,
	\c2, \note -> 9,
	\c3, \note -> 10,
	\c4, \note -> 11,
	\c5, \note -> 12,
	\c6, \note -> 13,
	\c7, \note -> 14,
	\c8, \note -> 15,
	\c9, \note -> 49,

]);
);




(
~makegui = { arg list;
	var win, playout, mlayout;
	win = Window.new;
	win.alwaysOnTop = true;

	playout = GridLayout.columns(*list.collect { arg param;
		param = param.asParam;
		[
			[ param.asStaticTextLabel.minHeight_(50), align:\center],
			[ param.asView],
			[ param.asStaticText.minWidth_(70), align:\center ],
		]
	});
	list.do { arg val, x;
		playout.setColumnStretch(x,1);
	};

	mlayout = VLayout(
		playout,
		HLayout(
			VLayout(
				XSimpleButton.new.label_("load preset1").action_({ list.load(\preset1) }),
				XSimpleButton.new.label_("save preset1").action_({ list.save(\preset1) }),
			),
			VLayout(
				XSimpleButton.new.label_("load preset2").action_({ list.load(\preset2) }),
				XSimpleButton.new.label_("save preset2").action_({ list.save(\preset2) }),
			),
		)
	);

	win.layout = mlayout;
	win.front;
	
};
ParamPreset(\mypreset, ~list);
~makegui.(ParamPreset(\mypreset));
//Pdef(\plop).play;
//Ndef(\echo).play;

);


41.type

(
Ndef(\ndef_array, { arg pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(\freq.kr(100!3));
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

Ndef(\ndef_array).set(\freq, [720,150,600]);
Ndef(\ndef_array).set(\freq, [220,350,700]);

~p = Param(Ndef(\ndef_array), \freq, XArraySpec(\freq!3));

~p.get;
~p.get == ( 100!3 );
~p.set([120,150,780]); // must reload the ndef to take effect :( ndef bug
~p.get == [120,150,780];
~p.normGet;
~p.normSet([0.5,0.2,0.4]);



(
~list = [
	[Pdef(\plop), \freq],
	[Pdef(\plop), \lpfreq],
	[Pdef(\plop), \rq],
	[Ndef(\echo), \shift1],
	[Ndef(\echo), \shift2],
];
~pg = ParamPreset(\hello, ~list);
)
~pg.edit;
~pg.save(\preset1)
~pg.save(\preset2)
~pg.save(\preset3)
~pg.load(\preset1)
~m = ParamMorpher(~pg, [\preset1, \preset2, \preset3]);
~m
~m.edit
~m.set(0)
~m.set(1)
~m.set(0.6)
~m.set(1.6)
~m.normSet(0.6)
~m.normSet(0.2)
~m = ParamMorpher(\mypreset, [\preset1, \preset2, \preset3]);
~m = ParamMorpher(\mypreset, [\preset2, \preset4]);
~m = ParamMorpherDef(\mymorpher, ~pg, [\preset2, \preset4]);
~m = ParamMorpherDef(\mymorpher, \mypreset, [\preset2, \preset4]);
~m.set(2) // last preset
~m.normSet(1) // last preset
MIDIMap(\k1, ~m) 
MIDIMap(\k1, Param(ParamMorpher(\mypreset, [\preset2, \preset4]))) 

Pdef(\plop).play;
Ndef(\echo).play;

~slider.mapParam(~m)



Ndef(\ndef_scalar).send
NodeMap
thisProcess.nowExecutingPath.asString

(
Ndef(\ndef_array, { arg pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(\freq.kr(100!3));
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
~p = Param(Ndef(\ndef_array), \freq, XArraySpec(\freq!3));
~p.edit
);


~p.get;
~p.get == ( 100!3 );
~p.set([120,150,780]); // must reload the ndef to take effect :( ndef bug
~p.get == [120,150,780];
~p.normGet;
~p.normSet([0.5,0.2,0.4]);
~p.normSet([0.5,0.2,0.4]); 

~list
ParamPreset(\mypreset, ~list);
ParamPreset(\mypreset, ~list);
ParamPreset(\mypreset, ~list);
Archive.at(\ParamPreset)

(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfreq.kr(100), \rq.kr(0.3));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	rq: ControlSpec(0.001,4,\lin, 0, 1),
	lpfreq: \freq,
	freq: \freq,
))).add;

BusDef(\fx1, \audio);

Pdef(\plop, 
	Pdef(\macro, Pbind()) <> // use another Pdef to control keys present in the pattern
	Pbind(
	\instrument, \plop,
	\out, BusDef(\fx1),
	//\legato, 0.1, // key must be absent to be controlled
	\dur, 1,
	\amp, 0.2
));

Ndef(\echo, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var del = 0.2;
	sig = InFeedback.ar(BusDef(\fx1),2);
	sig = CombL.ar(sig!8, 1,( \delay.kr(0.01) * \delaytab.kr(1!8) ).lag(0.1),\decay.kr(1)) + sig;
	sig = sig.sum;
	//sig = EnvGen.ar(Env([1,2,1],[0.1,0.8]), Onsets.kr(),doneAction:2);
	sig.debug("sig");
	sig = sig.tanh;
});

Spec.add(\shift, ControlSpec(-800,800,\lin,0,1));
Spec.add(\dur, ControlSpec(1/16,4,\lin,0,1));
Spec.add(\legato, ControlSpec(0.01,4,\lin,0,1));
Spec.add(\adsr, XEnvSpec(ControlSpec(0.03,3,\lin)!4));
Ndef(\echo).addSpec(\delaytab, XArraySpec(ControlSpec(0.01,2,\lin)!8));
Ndef(\echo).addSpec(\delay, ControlSpec(0.0001,1,\exp,0,1));
Ndef(\echo).addSpec(\decay, ControlSpec(0,8,\lin,0,1));
Pdef(\macro).addHalo(\instrument, \plop);
Pdef(\plop).addHalo(\instrument, \plop);

// make list of params
~list = [
	[Pdef(\macro), \dur],
	[Pdef(\plop), \legato],
	[Pdef(\plop), \freq],
	[Pdef(\plop), \lpfreq],
	[Pdef(\plop), \rq],
	[Ndef(\echo), \delay],
	[Ndef(\echo), \decay],
	[Ndef(\echo), \delaytab],
	[Pdef(\plop), \adsr],
];

Pdef(\plop).play;
Ndef(\echo).play;
)
XEnvSpec(ControlSpec(0.03,3,\lin)!5).times

	Param([Pdef(\plop), \freq]).set(1410)
(\delaytab -> 0).asString
(\delaytab -> 0).asCompileString
(\delaytab -> 0).postln
(\delaytab -> 0).debug
Param(Ndef(\echo), \delaytab -> 0)
Param(Ndef(\echo), \delaytab)
Param(Ndef(\echo), \delaytab -> 1).set(0.1)
Param(Pdef(\plop), \adsr -> \times -> 0).set(0.704)
Param(Pdef(\plop), \adsr -> \times -> 0).set(0.00704)
Param(Pdef(\plop), \adsr -> \times -> 0)
Param(Pdef(\plop), \adsr -> \times -> 0).get
Param(Pdef(\plop), \adsr).get.asCompileString
\bla -> \rah -> \bla -> \niaK

Param([Pdef(\plop), \adsr]).get.asCompileString
	Param([Pdef(\plop), \adsr]).set(Param([Pdef(\plop), \adsr]).get)
ParamGroup(~list).edit
ParamGroup(~list).at(7).asLabel
ParamGroup(~list).at(7).asCompileString
ParamGroup(~list).at(7).asString
ParamGroup(~list).at(7).type
ParamGroup(~list).at(7).get.collect({ arg x; x.debug("x") })
ParamGroup(~list).at(8).get.collect({ arg x; x.debug("x") })
ParamGroup(~list).at(8).get.collect({ arg x; x.debug("x") })
ParamGroup(~list).at(8).type.asCompileString
ParamGroup(~list).at(8).get.asCompileString
Ndef(\echo).edit

	Param([Pdef(\plop), \freq]).set(100)

	Param([Pdef(\plop), \adsr]).asString
	Param([Pdef(\plop), \adsr]).asCompileString
	Param([Pdef(\plop), \adsr]).debug("fggu")
	Debug
	Post << Param([Pdef(\plop), \adsr])
	Param([Pdef(\plop), \adsr]).default
	Param([Pdef(\plop), \adsr]).edit
	Param([Pdef(\plop), \adsr]).type
	Param([Ndef(\echo), \delaytab]).type
	Param([Ndef(\echo), \delaytab]).spec
	Ndef(\echo).getSpec(\delaytab)
	Param([Pdef(\plop), \adsr]).wrapper.instrument
	Param([Pdef(\plop), \adsr]).get.asCompileString
	Pdef(\plop).getVal(\adsr)
	Param.getSynthDefDefaultValue(\adsr, \plop).asEnv.asCompileString
	~e = Param.getSynthDefDefaultValue(\adsr, \plop).asEnv
	~e.releaseNode
ParamGroup(~list).at(1).spec
\freq.asSpec
Pdef(\plop).setBusMode(\lpfreq)
Pdef(\plop).setBusMode(\freq)
Pdef(\plop).get(\lpfreq)
Pdef(\plop).getVal(\lpfreq)

////////////////////////////////////////////////////////////
/// Example 4
/// Preset morphing



(
~makegui = { arg list, presets;
	var win, playout, mlayout;
	var morpher;
	win = Window.new;
	win.alwaysOnTop = true;

	playout = HLayout(*list.collect { arg param;
		var lay;
		param = param.asParam;
		lay = VLayout(
			// create a label, a knob and a value label from the param
			param.asStaticTextLabel.align_(\center),
			param.asView,
			param.asStaticText.minWidth_(80).align_(\center),
		); 
		[lay, \stretch:1];
	});

	morpher = ParamMorpher(list, presets);

	mlayout = VLayout(
		[playout, stretch:1],
		HLayout(*
			presets.collect({ arg preset, x;
				VLayout(
					XSimpleButton.new.label_("load " ++ preset).action_({ morpher.set(x) }),
					XSimpleButton.new.label_("save " ++ preset).action_({ list.save(preset) }),
				);
			})
		),
		Slider.new.orientation_(\horizontal).mapParam(morpher)
	);

	win.layout = mlayout;
	win.front;
	
};
ParamPreset(\mypreset2, ~list);
~makegui.(ParamPreset(\mypreset2), [\preset1, \preset2, \preset4]);
Pdef(\plop).play;
Ndef(\echo).play;

);

ParamPreset(\mypreset2).getPreset(\preset1)
ParamPreset(\mypreset2).getPreset(\preset4)

~e = Env([1,2,1],[0.1,0.8])
~e.asCompileString
~e.perform(\levels)[0] = 4

UnitTest.gui
UnitTestScript.gui
UnitTestScript.findTestScripts
UnitTest.new.assertEquals(1,1)

		~classPaths = Class.allClasses .collectAs({ |class| class.filenameSymbol.asString.dirname.postln }, Set);

XArraySpec( ControlSpec(0,1,\lin,0,1)!4).asString.asCompileString
XArraySpec( ControlSpec(0,1,\lin,0,1)!4).asCompileString
XArraySpec([ ControlSpec(0, 1, 'linear', 0, 1, ""), ControlSpec(0, 1, 'linear', 0, 1, ""), ControlSpec(0, 1, 'linear', 0, 1, ""), ControlSpec(0, 1, 'linear', 0, 1, "")  ], [ 1, 1, 1, 1  ])
XArraySpec( ControlSpec(0,1,\lin,0,1)!4).debug("plop")
\freq.asSpec
