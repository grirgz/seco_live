
//// test specificity

/////////////////// bug: slot param with gui and spec fails
////////// ndef
(
Ndef(\ndef_array, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(\freqtab.kr([100,200,300])).mean;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

Param(Ndef(\ndef_array), \freqtab).edit
Param(Ndef(\ndef_array), \freqtab).spec
Param(Ndef(\ndef_array), \freqtab -> 1).edit
Param(Ndef(\ndef_array), \freqtab -> 1).spec
Param(Ndef(\ndef_array), \freqtab -> 1, \freq).edit // SUCCESS
Param(Ndef(\ndef_array), \freqtab -> 1, Param(Ndef(\ndef_array), \freqtab).spec).edit // SUCCESS

//////////////////////
////////// pdef
(
SynthDef(\sd_array, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(\freqtab.kr([100,200,300])).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	freqtab: ParamArraySpec(\freq),
))).add;
);


(
Pdef(\sd_array, 
	Pbind(
		\instrument, \sd_array,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);
Param(Pdef(\sd_array), \freq).type
Param(Pdef(\sd_array), \freq, \freq).type
Param(Pdef(\sd_array), \freqtab).edit
Param(Pdef(\sd_array), \freqtab).type
Param(Pdef(\sd_array), \freqtab).
Param(Pdef(\sd_array), \freqtab -> 1).edit
Param(Pdef(\sd_array), \freqtab -> 1).type // scalar
Param(Pdef(\sd_array), \freqtab -> 1).spec
Param(Pdef(\sd_array), \freqtab -> 1, \freq).edit // SUCCESS
Param(Pdef(\sd_array), \freqtab -> 1, \freq.asSpec).type // SUCCESS: scalar
Param(Pdef(\sd_array), \freqtab -> 1, \freq).type // SUCCESS: scalar
Param(Pdef(\sd_array), \freqtab -> 1, \freq).spec
Param(Pdef(\sd_array), \freqtab).at(1).type
Param(Pdef(\sd_array), \freqtab, ParamArraySpec(\freq)).at(1).type
Param(Pdef(\sd_array), \freqtab -> 1, ParamArraySpec(\freq)).type
ParamArraySpec(\freq).asSpec
ParamArraySpec(\freq)


////////// synth param

~synth = Synth(\default);
Param(~synth,\freq).edit
Param(~synth,\freq).get
~synth.isPlaying
NodeWatcher.register(~synth)
PlayerWrapper(~synth).stop

NodeWatcher

(
WindowDef(\win, { arg def;
	
	PlayerWrapper(~synth).asView;
	//Param(~synth,\freq).asView
}).front;
);

(
b = s.makeBundle(false, {
    a = Group.new(s); //create a node object
    a.register // register before creating on the server
})
)
s.listSendBundle(nil, b)

a.isPlaying
(
WindowDef(\win, { arg def;
	
	PlayerWrapper(a).asView;
	//Param(~synth,\freq).asView
}).front;
);

(
b = s.makeBundle(false, {
    a = Group.new(s); //create a node object
    a.register // register before creating on the server
})
)

Synth(\default, [\freq, 200],target: a)

a.release
a.stop
a.ends
a.isPlaying;
s.listSendBundle(nil, b); //start the node on the server
a.isPlaying;
a.isRunning;
a.run(false);
a.isRunning;
s.freeAll; //free all nodes
a.isPlaying;
a.isRunning;


////////// midi mapping


(
Pbindef(\zed2, 
	\instrument, \default,
	\degree, Pseq([0,3,1],inf),
	\dur, 1/8,
	\amp, 0.1,
).play;
);

Pbindef(\zed2).source.at(\degree).quant = 0
Pdef.defaultQuant = 4

(
MIDIdef.cc(\cc1, { arg val, channel, deviceId;
	[ val, channel, deviceId ].debug;
	//Pbindef(\zed2).source.at(\degree).source = val/4
	Pbindef(\zed2, \degree, val/4);


},51);
)

(
MIDIdef.cc(\cc1, { arg val, channel, deviceId;
	var prox, oldq;
	[ val, channel, deviceId ].debug;
	prox = Pbindef(\zed2).source.at(\degree);
	oldq = prox.quant;
	prox.quant = 0;
	prox.source = val/4;
	prox.quant = oldq;
	//Pbindef(\zed2, \degree, val/4);


},51);
)


Param(Pbindef(\zed2), \degree -> \source, ControlSpec(0,12,\lin,1,0)).midiLearn
Param(Pbindef(\zed2), \dur -> \source, ControlSpec(0.051,1,\lin,0,1)).midiLearn
Param(Pbindef(\zed2), \degree -> \source, ControlSpec(0,12,\lin,1,0)).midiUnmap
Param(Pbindef(\zed2), \degree -> \source, ControlSpec(0,12,\lin,1,0)).midiMapList
Param(Pbindef(\zed2), \dur -> \source, ControlSpec(0,12,\lin,1,0)).midiMapList
Param.getMidiMappedParams(49)

Param(Pbindef(\zed2), \degree -> \source, ControlSpec(0,12,\lin,1,0)).midiMap(50)

MIDIdef.trace

/////////////////// test MessageParam

(
	~model = (scalar: 123, bool:true, list: [12,23,4,7]);
WindowDef(\win, { arg def;
	var states = [
		["kjkj"],
		["------"],
	];
	VLayout (
		Param(Message(~model), \scalar, ControlSpec(0,200,\lin)).asView,
		Param(Message(~model), \scalar, ControlSpec(0,200,\lin)).asView,
		Param(Message(~model), \bool, ParamBoolSpec()).asButton,
		Param(Message(~model), \bool, ParamBoolSpec()).asButton,
		BoolButton.new.mapParam(Param(Message(~model), \bool, ParamBoolSpec())),
		BoolButton.new.mapParam(Param(Message(~model), \bool, ParamBoolSpec())),
		BoolButton.new.mapParam(Param(Message(~model), \bool, ParamBoolSpec())).string_("kk"),
		BoolButton.new.mapParam(Param(Message(~model), \bool, ParamBoolSpec())).string_("kk"),
		Button.new.mapParam(Param(Message(~model), \bool, ParamBoolSpec())).states_(states),
		Button.new.mapParam(Param(Message(~model), \bool, ParamBoolSpec())).states_(states),

		Param(Message(~model), \list).asMultiSlider,
		Param(Message(~model), \list -> 0).asView,
		Param(Message(~model), \list).at(1).asView,
	)

}).front;
)

/// test MessageParam slots

~model.changed(\set)
	~model = (scalar: 123, bool:true, list: [12,23,4,7]);
Param(Message(~model), \list).get
Param(Message(~model), \list -> 0).get
Param(Message(~model), \list -> 0).set(10)
WindowDef(\win).front;
ParamArraySpec
Param.trace = true

////////// inBusMode

(
WindowDef(\test, { arg def;
	BoolButton.new.string_("kjkj").action_({ arg but; but.value.debug("action!") })
	
}).front;
)
	

/////////////// stepseq

(
Pdef(\bete, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0],inf),
		\lpfr, PstepSeq([1,10,3,4,4.2]),
		\dur, 1/8,
		\amp, 0.1,
	)
);
Pdef(\bete).convertToPbindef;
);

Pdef(\bete).addSpec(\lpfr, ControlSpec(0,4,\lin))

Param( Pdef(\bete), \lpfr -> \stepseq ).get
Param( Pdef(\bete), \lpfr -> \stepseq ).spec
Param( Pdef(\bete), \lpfr -> \stepseq, ControlSpec(0,3,\lin) ).spec
Param( Pdef(\bete), \lpfr -> \stepseq ).size
Param( Pdef(\bete), \lpfr -> \stepseq ).edit
Param( Pdef(\bete), \lpfr -> \stepseq -> 0).get
Param( Pdef(\bete), \lpfr -> \stepseq -> 0).edit
Param( Pdef(\bete), \lpfr -> \stepseq -> 0).spec
~p1 = Param( Pdef(\bete), \lpfr -> \stepseq )
~p1.get
Param( Pdef(\bete), \lpfr).at(\stepseq).get
Param( Pdef(\bete), \lpfr -> 0 ).get
~p2 = Param( Pdef(\bete), \lpfr -> 0 )
~p2.get
Param( Pdef(\bete), \lpfr).at(0)
Pdef(\bete).source.at(\lpfr).source.list


/// when not a Pbindef, how should it fail ?
(
Pdef(\bete, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0],inf),
		\lpfr, PstepSeq([1,10,3,4,4.2]),
		\dur, 1/8,
		\amp, 0.1,
	)
);
);
Param( Pdef(\bete), \lpfr -> \stepseq ).get; // at not understood: a Pbind
(
Pbindef(\bete,
	\instrument, \saw,
	\degree, Pseq([0,3,4],inf),
	\lpfr, PstepSeq([1,10,3,4,4.2]),
	\dur, 1/8,
	\amp, 0.1,
)
);
Param( Pdef(\bete), \lpfr -> \stepseq -> 0 ).get; // ok
Param( Pdef(\bete), \degree -> \stepseq -> 1 ).get; // ok

(
Pbindef(\bete,
	\instrument, \saw,
	\degree, Pseq([0,3,4],inf),
	\lpfr, PstepSeq([1,10,3,4,4.2],inf),
	\dur, 1/8,
	\amp, 0.1,
).play
);
Param( Pdef(\bete), \degree -> \stepseq ).edit; // work with Pseq !!!
MKtl(\icon)[\sl].mapParam( Param( Pdef(\bete), \degree -> \stepseq ) )


(
Pbindef(\bete,
	\instrument, \saw,
	\degree, Prand([0,3,4],inf),
	\lpfr, PstepSeq([1,10,3,4,4.2],inf),
	\dur, 1/8,
	\amp, 0.1,
).play
);
Param( Pdef(\bete), \degree -> \stepseq ).edit; // work with Prand !!!
MKtl(\icon)[\sl].mapParam( Param( Pdef(\bete), \degree -> \stepseq ) )


////////////////////////////////// Pdefn

Pdefn(\bla, 2)
Pdefn(\bla, 4)
Param(Pdefn(\bla)).edit
Param(Pdefn(\bla)).get
Param(Pdefn(\bla)).set(3)

~a = TestDependant()
Pdefn(\bla).changed(\bla)
Pdefn(\bla).addDependant(~a)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\degree, Pdefn(\bla),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);


///////// Pdefn list

Pdefn(\roh, Pseq([1,4,2,5],inf))
Param(Pdefn(\roh), \bla -> \stepseq, ParamArraySpec()).edit
Param(Pdefn(\roh), \bla, ParamArraySpec()).get
Param(Pdefn(\bla)).get
Param(Pdefn(\roh)).get
Param(Pdefn(\roh), \stepseq).get
Param(Pdefn(\roh), \stepseq).edit
Param(Pdefn(\roh), \stepseq -> 1).get
Param(Pdefn(\roh), \stepseq).at.get
Param(Pdefn(\bla)).set(3)

(
Pdefn(\roh, Pseq([1,4,2,5],inf));
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pdefn(\roh),
		\dur, 1/4,
		\amp, 0.1,
	)
).play;
);
Param(Pdefn(\roh), \stepseq, ControlSpec(0,21,\lin,1)).edit
Param(Pdefn(\roh), \stepseq, ControlSpec(0,21,\lin,1)).type

(
Pdefn(\roh, PstepSeq([1,4,2,5],inf));
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pdefn(\roh),
		\dur, 1/4,
		\amp, 0.1,
	)
).play;
);
Param(Pdefn(\roh), \stepseq, ControlSpec(0,21,\lin,1)).edit
Param(Pdefn(\roh), \stepseq -> 2, ControlSpec(0,21,\lin,1)).edit
Param(Pdefn(\roh), \stepseq -> 2, ControlSpec(0,21,\lin,1)).spec
Param(Pdefn(\roh), \stepseq, ControlSpec(0,21,\lin,1)).at(0).edit
Param(Pdefn(\roh), \stepseq, ControlSpec(0,21,\lin,1)).at(0).spec
Param(Pdefn(\roh), \stepseq, ControlSpec(0,21,\lin,1)).spec

~p = Param(Pdefn(\roh), \stepseq, ControlSpec(0,21,\lin,1))
~p.label
~p.fullLabel
~p.propertyLabel

(
WindowDef(\win, { arg def;
	VLayout (
		~p.asStaticTextLabel,
		~p.asView,
	)
	
}).frontTop;
);


////////////////// PstepSeq

~p = PstepSeq([3,2,5,1],inf)


////////////////// Pbindef -> \source


(
Pbindef(\bete,
	\instrument, \saw,
	\degree, Prand([0,3,4],inf),
	\lpfr, PstepSeq([1,10,3,4,4.2],inf),
	\dur, 1/8,
	\amp, 0.1,
)
);
Pbindef(\bete).play

Param( Pdef(\bete), \dur -> \source ).edit; // work with Prand !!!
Param( Pdef(\bete), \dur -> \source ).get
Param( Pdef(\bete), \dur -> \source ).normGet
Param( Pdef(\bete), \dur -> \source ).spec
Param( Pdef(\bete), \dur  ).spec
Param( Pdef(\bete), \dur  ).get
Param( Pdef(\bete), \dur  ).at(\source).get
Param( Pdef(\bete), \dur  ).at(\source).edit
Spec.add(\dur, ControlSpec(0.01,4,\exp))

Param( Pdef(\hoho), \hihi -> \source ).parent
Param.fromWrapper(Param( Pdef(\hoho), \hihi -> \source ).parent)

// when key is not defined
Param( Pdef(\bete), \hihi  ).get
Param( Pdef(\bete), \hihi  ).default
Param( Pdef(\bete), \hihi -> \source ).get
Param( Pdef(\bete), \hihi -> \source ).set(123)
Pbindef(\bete).source.at(\hihi)
Pbindef(\bete).source.at(\hihi).source
Pbindef(\bete).source.set(\hihi, 34)
nil.source

// when Pbindef is not defined
Param( Pdef(\hoho), \hihi -> \source ).get
Param( Pdef(\hoho), \hihi -> \source ).set(123)

// default value

(
Pbindef(\pok, 
	\instrument, \saw,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1,
).play;
);

Param( Pdef(\pok), \lpfr -> \source  ).get
Param( Pdef(\pok), \lpfr -> \source  ).instrument
Param( Pdef(\pok), \lpfr -> \source  ).default
Param( Pdef(\pok), \lpfr ).default
Param( Pdef(\pok), \lpfr ).instrument

Param( Pdef(\pok), \lpfr -> \source  ).spec
(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);


////////// button state mapping

ProtoDef(\bla, (hoho:true))
(
WindowDef(\win, { arg def;
	VLayout (
		Param(Message(ProtoDef(\bla)), \hoho, ParamBoolSpec()).asButton,
	)
	
}).front;
);
