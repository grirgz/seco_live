

PlayerWrapper(Pbindef(\tapme)).edit
WindowDef(\PbindefEditor).front(Pbindef(\tapme))
FileSystemProject.load("libdef/PbindefEditor.scd")


Pbindef(\bla, \instrument, \default)
Pbindef(\bla).edit
Pbindef(\bla).presetCompileString
~self.presetCompileString
~self.paramList
~self.pbindefKeysParamList
~self.instrumentParam
WindowDef(\PbindefEditor).proto.presetCompileString
FileSystemProject.load("lib/synth.scd")

Pbindef(\tapme).presetCompileString
Pbindef(\tapme).asParamGroup.presetCompileString
Pbindef(\tapme).set(\rq, 1)
PlayerWrapper(Pbindef(\tapme)).getPbindCompileString
Pbindef(\tapme).getPbindCompileString

(
WindowDef(\win, { arg def;
	Button.new
}).front;
)
WindowDef(\win).window.alwaysOnTop = true
~win.alwaysOnTop
WindowDef.useWindowViewRecallQuark = false


~w = Window.new
~w.front
~w.onClose_({ ~w.alwaysOnTop.debug("aot") })
~w.alwaysOnTop


///// test Pbindef array control
// TEST OK!


(
SynthDef(\testme_array, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * \freqtab.kr(1!3).poll).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

// test defined OK
Pbindef(\testar, \instrument, \testme_array, \freqtab, [[1,2,3]])
Pbindef(\testar).play
Pbindef(\testar).edit

Param(Pbindef(\testar), \freqtab -> \source).get; // should be unnested: ok
Param(Pbindef(\testar), \freqtab -> \source).edit

Pbindef(\testar).source.at(\freqtab).source; // should be nested: ok

// test undefined OK
Pbindef(\testar2, \instrument, \testme_array)
Pbindef(\testar2).play
Param(Pbindef(\testar2), \freqtab -> \source).edit

///// test Pbindef env control


(
SynthDef(\testme, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * \freqtab.kr(1!3).poll).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

Spec.add(\adsr, ParamEnvSpec.adsr); // must have a spec defined somewhere to work
\adsr.asSpec

Pbindef(\yeah, \instrument, \testme, \adsr, [ Env.adsr(0.2,0.1,0.8,2.1) ])
Pbindef(\yeah, \instrument, \testme, \adsr, Env.adsr(0.2,0.1,0.8,2.1)); // Pbindef does not accept without []
Pbindef(\yeah).play
Pbindef(\yeah).edit
Pbindef(\yeah3).edit
Pbindef(\yeah).asStream.next(())
Param(Pbindef(\yeah), \adsr -> \source).spec
Param(Pbindef(\yeah), \adsr -> \source).type
Param(Pbindef(\yeah), \adsr).spec
Param(Pbindef(\yeah), \adsr).type
Param(Pbindef(\yeah), \adsr -> \source).get
Param(Pbindef(\yeah), \adsr -> \source).set( Env.adsr(0.01,0.1,0.8,0.1))
Param(Pbindef(\yeah), \adsr -> \source)
Param(Pbindef(\yeah), \adsr -> \source).edit

Pbindef(\yeah).source.at(\adsr).source
Pdef(\yeah).source

Pdef(\ye)

(
SynthDef(\testmear, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * EnvGen.kr(\env1.kr(Env([0,1,0],[0.1,0.1]))));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

Pbindef(\ttt, \instrument, \testmear);
Pbindef(\ttt).edit
Pbindef(\ttt).asParamGroup.collect(_.property)
Pbindef(\ttt).asParamGroup.asPropertyDict[\freq].parent.type
onSet
Param(Pdef(\ttt), \env1).get.asEnv
[1,2,3,4,5,6,7,8].asEnv


////////// test bus mode
// seems ok
(
SynthDef(\testbus, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * \freqfac.kr(1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

Pbindef(\testbus, \instrument, \testbus)
Param(Pbindef(\testbus), \freqfac -> \source).spec
Pbindef(\testbus).edit
