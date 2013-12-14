// set the specs

Sdef(~name, \mypreset, \preset, ~name);

}, metadata:(specs:(
	env0: \env -> [4, ControlSpec(0.001,8,\exp, 0, 1), nil, nil, Env.new([9.5, 1, 0.5, 0], [0.105, 0.16, 00.2])],
	env1: \env -> [3, ControlSpec(5,128,\lin, 0, 50), nil, nil, Env.new([210, 29, 59], [0.105, 0.29], [-4, -5])],
	env2: \env -> [3, ControlSpec(5,128,\lin, 0, 50), nil, nil, Env.new([210, 29, 59], [0.105, 0.29], [-4, -5])],
	env3: \env -> [3, ControlSpec(5,128,\lin, 0, 50), nil, nil, Env.new([210, 29, 59], [0.105, 0.29], [-4, -5])],

))).add;

Sdef(~name, \mypreset).rebuild(true)

// see presets for the y.24 nodeclip
~score_storage.all[\y][\mypreset].all[0].indices
~score_storage.all[\y][\mypreset].all[27].indices
~score_storage.all[\y][\mypreset].all.indices
~score_storage.all[\y][\mypreset].all.indices
~score_storage.all[\y][\mypreset].all[25][0] == ~score_storage.all[\y][\mypreset].all[24][1]
~score_storage.all[\y][\mypreset].all[25][0].vals.keysValuesDo{ arg k,v; v.get_val.debug(k) };
~score_storage.all[\y][\mypreset].all[27][0].vals.keysValuesDo{ arg k,v; v.get_val.debug(k) };
~score_storage.all[\y][\mypreset].all[26][0].get_event
~score_storage.all[\y][\mypreset].all[25][1]

Sdef(~name, \mypreset).all.indices
Sdef(~name, \mypreset).get(0).vals.keysValuesDo{ arg k,v; v.get_val.debug(k) };
Sdef(~name, \mypreset).get(0, 0).vals.keysValuesDo{ arg k,v; v.get_val.debug(k) };
~score_storage.all[\y][\mypreset].all[0][0].vals.keysValuesDo{ arg k,v; v.get_val.debug(k) };


////////////////////////////////////

VecoLib.load_lib
Veco.force_init;

(
SynthDef(\testme, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=300, rq=0.3;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, ffreq, rq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

PresetDef(\plop, \testme)
PresetDef(\plop).edit

(
MIDIBoard.define(1, [
	\k1, 1,
	\k2, 2,
	\but1, 35,
]);
)

MIDIBoard.map(\k1, PresetDef(\plop), \freq);
MIDIBoard.map(\k4, PresetDef(\plop), \freq);
MIDIBoard.map(\but1, { "connard".postln; });

(
Pdef(\pd, PresetDef(\plop).pbind <> Pbind(
	\instrument, \testme,
	\dur, 1,
)).play
)

