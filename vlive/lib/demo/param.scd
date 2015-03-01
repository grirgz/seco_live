
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
