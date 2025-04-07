
(
SynthDef(\sawadsr, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\myenv.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

// see argument envadsr is not recognized properly, it is treated as an Array
Pbindef(\test, \instrument, \sawadsr).edit; 
Pdef(\testspec, Pbind(\instrument, \sawadsr)).edit;
Ndef(\testndef, \sawadsr).asParamGroup.edit;
Param(Pdef(\testspec), \myenv).type; // the recognized type is \array, should be \env
Param(Pdef(\testspec), \myenv).spec; // a ParamArraySpec

// there is several ways to define the spec of \myenv

// you can specify the env directly in Param
Param(Pdef(\testspec), \myenv, ParamEnvSpec.adsr).edit;

// you can add it with JitLib .addSpec
Pdef(\testspec).addSpec(\myenv, ParamEnvSpec.adsr);
Pdef(\testspec).edit; // now it is recognized as an Env

// you can add it to global specs
Spec.add(\myenv, ParamEnvSpec.adsr)

// you can define it in the synthdef
(
SynthDef(\sawadsr, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\myenv.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}, metadata:(specs:(
	myenv: ParamEnvSpec.adsr,
))).add;
);
