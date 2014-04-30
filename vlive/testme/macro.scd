
(Platform.userExtensionDir ++ "/seco/seco/vecolib/midi.scd").load

	VecoLib.lib[\class_midi_cc_controller].new_wrapper([Ndef(\plop), \freq, \freq.asSpec])
(

~macro = ~class_rack.new(~name, \myrack, [
	[Ndef(\plop), \freq],
	[Ndef(\plop), \ffreq],
	[Ndef(\plop), \freqscale, ControlSpec(0.001,4,\exp,0,1)],
	[Pdef(\blah), \freq],
	[Pdef(\blah), \ffreq],
	[Pdef(\blah), \freqscale],
]);
)
~macro.map_midi

~preset = ~macro.save_preset
~preset2 = ~macro.save_preset
~preset
~macro.load_preset(~preset)
~macro.load_preset(~preset2)
~preset[[\ndef, \plop, \freq]]
~macro.controllers
~macro.morph(0.5, [~preset, ~preset2])
(
~macro.map_midi;
//MIDIBoard.map(\s1, Ndef(\plop), \freqscale, .asSpec);
~macro.set_preset_list([~preset, ~preset2]);
MIDIBoard.map(\s2, Ndef(\plop), \freq, \freq.asSpec);
MIDIBoard.map(\s3, ~macro, \morph);
)
Array.geom(8,1/4,2) ** 1.001
(
Ndef(\plop).put(0, { arg freq=200, pan=0, amp=0.1, spread=0.8, ffreq=4000, rq=0.4, freqscale=1, drive=100, distamp=0.3, mixdist=0.5;
	var sig;
	var sig2;
	var lagtime=0.8;
	freq = freq.lag(lagtime);
	ffreq = ffreq.lag(lagtime);
	freq = freq * (Array.geom(8,1/4,2) ** freqscale);
	freq = freq.fold(1,19000);
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, ffreq, rq);
	sig = DelayC.ar(sig, 0.1,0.1*SinOsc.ar(1).range(0,0.1)) + sig;
	sig2 = (sig * drive).clip2(0.5) * distamp;
	sig = SelectX.ar(mixdist, [sig, sig2]);
	sig = Splay.ar(sig, spread, amp, pan);
}).play;
);
Ndef(\plop).edit
Ndef(\plop).clear

VecoLib.lib[\class_rack].new_from_object(Ndef(\plop)).make_window
VecoLib.lib[\class_rack].new_from_object(Ndef(\plop)).map_midi
VecoLib.lib[\class_rack].new_from_object(Ndef(\plop)).params

Ndef(\plop).asRack.edit
(
Rack(
	[
		[Ndef(\plop), \freq]
	] ++ Ndef(\plop).asRack.params
)
)

~a = XArraySpec( \freq.asSpec ! 15  ) // array of size 15
~a = XArraySpec( [\freq, \unipolar]  ) // array of size two
~a = XArraySpec( [\freq, \unipolar], [1,2]  ) // default value
~a.size;
~a.default;
~a.array;
~a.isMonoSpec; // all items use the same spec


~b = XEnvSpec( \freq.asSpec ! 5, \dur.asSpec, \bipolar.asSpec) // env with 5 segments (times have 4 values)
~b = XEnvSpec( [\freq.asSpec, \lofreq.asSpec] , [\dur.asSpec, \unipolar.asSpec], \bipolar.asSpec) // 2 segment, different spec for each segment
~b = XEnvSpec( \freq.asSpec ! 5, \dur.asSpec, \bipolar.asSpec, Env([10,30,10,420],[1,2,1,2])) // default value
~b.default.asCompileString
~b.levels;
~b.curves;
~b.times;
~b.isMonoSpec;

~b = XEnvSpec( \freq.asSpec ! 5, \dur.asSpec, \bipolar.asSpec) // env with 5 segments (times have 4 values)
~a = XArraySpec( [\freq, \unipolar], [1,2]  ) // array of size two

Env([10,20,30,10,420],[1,2,1,2]).levels.size
~a = XArraySpec( \freq.asSpec ! 15, 1 ! 17  ) // array of size 15

\curves.asSpec
\unipolar.asSpec.asArray.wrapExtend(5)

(
Ndef(\plop).put(1, \set -> Pbind(
	\degree, Pseq([0,2,4],inf),
	//\freq, Pseq([100,200,400],inf),
	\dur, 1,
	
));
)
Ndef(\plop).unmap(\freq)

~class_mi
~map_ndef_to_knobs.(\plop, exclude:[\pan, \amp,\spread])
Ndef(\plop).controlNames

[
	[\freq],
	[\ffreq],
	[\rq],
	[\freqscale, C],
]

(
	
Spec.add(\freqscale, ControlSpec(0.001,4,\exp,0,1));
Spec.add(\drive, ControlSpec(0,100,\lin,0,1));
)

///////////////:


(
SynthDef(\blah, { arg out=0, freq=200, pan=0, amp=0.1, spread=0.8, ffreq=4000, rq=0.4, freqscale=1, drive=100, distamp=0.3, mixdist=0.5, gate=1;
	var sig;
	var sig2;
	var lagtime=0.8;
	freq = freq.lag(lagtime);
	ffreq = ffreq.lag(lagtime);
	freq = freq * (Array.geom(8,1/4,2) ** freqscale);
	freq = freq.fold(1,19000);
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, ffreq, rq);
	sig = DelayC.ar(sig, 0.1,0.1*SinOsc.ar(1).range(0,0.1)) + sig;
	sig2 = (sig * drive).clip2(0.5) * distamp;
	sig = SelectX.ar(mixdist, [sig, sig2]);
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,1,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}, metadata:(specs:(
	freq: ControlSpec(30,14000,\exp, 0, 100),
	ffreq: ControlSpec(30,15000,\exp, 0, 400),
	freqscale: ControlSpec(1/8,4,\exp, 0, 1),
	mixdist: \unipolar.asSpec,
))).add;
);


(
Pdef(\blah, Pbind());
Pdef(\blahmain, 
	(Pbind(
		\instrument, \blah,
		\legato, 1,
	) <>
	Pdef(\blah))
);
Pdef(\blahmain).play
)



Pdef(\blah).setBusMode(\freq)
Pdef(\blah).addHalo(\instrument, \blah)

VecoLib.lib[\class_rack].new_from_object(Pdef(\blah)).make_window
VecoLib.lib[\class_rack].new_from_object(Pdef(\blah)).map_midi
Pdef(\blah).get(\pan)

Pdef(\blah).setBusMode( \pan )
Pdef(\blah).setBusMode( * Pdef(\blah).envir.keys.as(Array) )
 Pdef(\blah).envir.keys.as(Array)

Pdef(\blah).clear
Pdef(\blah).remove
Pdef(\blah).adieu

Pdef(\blah).set(\freq, 400)
Pdef(\blah).getSpec(\freq)
Pdef(\blah).getSpec(\xxx)
Pdef(\blah).addSpec(\freq, ControlSpec(30,200,\lin,0,30))
Pdef(\blah).adieu
Pdef(\blah).addHalo(\instrument, \blah)
Pdef(\blah).getHalo(\spec)
VecoLib.lib[\get_spec].(\freq, Pdef(\blah).getHalo(\instrument))
Pdef(\blah).addHalo(\spec, nil)
Pdef(\blah).setBusMode(\freq)
Pdef(\blah).setBusMode(\ffreq)
~macro.map_midi;
~sp = Halo.at(Pdef(\blah), \spec)
~sp.parent = ()
~sp[\freq]
~bus = Bus.control(s, 1)
~bus.getSynchronous
~bus.set(100)
~bus.set(400)
~bus2 = Bus.control(s, 1)
~bus.getSynchronous
~bus2.set(100)
~bus.set(400)
Pdef(\blah).set(\ffreq, ~bus.asMap)
Pdef(\blah).set(\freq, ~bus2.asMap)
Pdef(\blah).set(\freq, 700)
Pdef(\blah).set(\ffreq, ~bus.asMap)
Pdef(\blah).map(\ffreq, ~bus)
Pdef(\blah).set(\ffreq, Bus.control(s, 1))
\c2.asBus
~map = \c2;
~map[0];
Bus.asMap
Event
Pdef.clear
Pdef(\blah).checkSpec
Pdef.edit

/////////////////////////////////////////////////////////////////////

(
~ffreqtabsize = 8;
SynthDef(\blarray, { arg out=0, amp=0.1, freq=200, rq=0.4, gate=1, pan=0, spread=0.8;
	var sig;
	var sig2;
	var lagtime=0.8;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \ffreqtab.kr(100!~ffreqtabsize), rq);
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.1,0.1,1,0.1)),gate,doneAction:2);
	Out.ar(out, sig);
}, metadata:(specs:(
	freq: ControlSpec(30,14000,\exp, 0, 100),
	ffreqtab: XArraySpec(\freq ! ~ffreqtabsize),
	adsr: XEnvSpec(\unipolar ! 4, \dur, \bipolar, Env.adsr(0.1,0.1,1,0.1)),
))).add;
);



(
Pdef(\blarray, Pbind());
Pdef(\blarray).addHalo(\instrument, \blarray);
Pdef(\blahmain, 
	Pdef(\blarray) <>
	Pbind(
		\instrument, \blarray,
		\dur, 1/2,
	) 
);
Pdef(\blahmain).play;
)


Env

Pdef(\blarray).setBusMode(\freq)
Pdef(\blarray).envir
Pdef(\blarray).envir.adsr.asCompileString
Pdef(\blarray).get(\ffreqtab)
Pdef(\blarray).set(\legato, 0.1)
Pdef(\blarray).set(\dur, 0.4)
Pdef(\blarray).unset(\legato)

~a = Rack.newFrom(Pdef(\blarray));
Pdef(\blarray).asRack.edit;
Pdef(\blarray).asRack.map_midi;
~a = Pdef(\blarray).asRack
~a.map_midi;
~a.edit;

~pre1 = ~a.save_preset
~pre2 = ~a.save_preset
~pre3 = ~a.save_preset
~a.load_preset(~pre1)
~a.load_preset(~pre2)
~a.set_preset_list([~pre1, ~pre2])
~a.set_val(\morph,0.1)
~pre1
~b = Rack([[~a, \morph], [Pdef(\blarray),\dur, ControlSpec(1/16,4,\exp,0,1/16)]])
~b.map_midi
Pdef(\blarray).envir
~a.controllers[[\pdef,\blarray, \freq]].target_set(100)
~a.controllers[[\pdef,\blarray, \freq]].target_set(50)
Pdef(\blarray).set(\freq, Pseq([100,50,200],inf))
Pbindef(\blarray, \freq, Pseq([100,50,200],inf))
Pbindef(\blarray, \freq, nil)
Pdef(\blarray).get(\freq)


VecoLib.lib[\class_rack].new_from_object(Pdef(\blarray)).make_window
VecoLib.lib[\class_rack].new_from_object(Pdef(\blarray)).map_midi
~a = VecoLib.lib[\class_rack].new_from_object(Pdef(\blarray))
~a = Rack.newFrom(Pdef(\blarray))
Pdef(\blarray).asRack.edit
~a.make_window
~a = Rack([[Pdef(\blarray), \freq, \freq.asSpec]])
~a = Rack([Pdef(\blarray), \freq])
~a.edit
~a.map_midi
ControlSpec
~pre1 = ~a.save_preset
~pre2 = ~a.save_preset
~a.load_preset(~pre1)
~a.load_preset(~pre2)
VecoLib.lib[\class_rack].new(\bla, \rah)
~a.controllers[[\pdef, \blarray, \freq]].target_wrappers[0].target_set(100)
~a[\load_preset]
~pre1 == ~pre2
~a.controllers[[\pdef, \blarray, \ffreqtab]].set_norm_val([0.4,0.4,0.4,0.4])
~spec = ~a.controllers[[\pdef, \blarray, \adsr]].target_spec
~spec.array
~spec = XArraySpec(\freq ! 4)
~a.controllers[[\pdef, \blarray, \adsr]].get_norm_val.asCompileString
~a.controllers[[\pdef, \blarray, \adsr]].get_val.asCompileString
~a.controllers[[\pdef, \blarray, \adsr]].get_val.times


Pdef(\blarray).get(\adsr).asCompileString

Pdef(\blarray).get(\pan)
Pdef(\blarray).remove

Pdef(\blarray).setBusMode( \pan )
Pdef(\blarray).setBusMode( * Pdef(\blarray).envir.keys.as(Array) )
Pdef(\blarray).envir.keys.as(Array)

Pdef(\blarray).clear
Pdef(\blarray).remove
Pdef(\blarray).adieu

