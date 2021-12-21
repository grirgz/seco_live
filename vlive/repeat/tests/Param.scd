
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
	
