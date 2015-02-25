
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
~p = Param(Ndef(\plop), \freq, \freq);
Param.set
~p.set(45)
~p.get
~p.map(msgNum: 14)
~p.normSet(45)
~p.methods.do(_.dump)
Object.new.object

- how to handle updates of the GUI ?
	- sync
	- async
