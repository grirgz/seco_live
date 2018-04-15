// Aztec death whistle

(
SynthDef(\scream, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(\freqenv.kr(Env([1,2,1,1],[0.4,4,1])), gate);
	freq = freq * [1,2,4] * LFNoise1.kr(1/3!4, mul:0.01, add:0.1 );
	freq = freq * ( env1);
	freq = freq.clip(20,19999);
	sig1 = Formant.ar(freq, freq*2, \formbw.kr(10000)) * \formamp.kr(1);
	sig2 = BPF.ar(WhiteNoise.ar, freq, \rq.kr(0.2))*\bpfamp.kr(10);
	sig3 = LFPulse.ar(freq)* \pulseamp.kr(1);
	sig = sig1 + sig2 + sig3;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.7)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}, metadata:(specs:(
	freqenv: XEnvSpec(ControlSpec(0.01,3))
))).add;
);


(
Pdef(\demo, Pdef(\xdemo, 
	Ppar([
		Pdef(\ktl, Pbind(
			\instrument, \scream,
		)) <>
		Pbind(
			\freq, 200,
			\dur, 4,
			\legato, 0.45,
			\amp, 0.1,
		),
	])
)).play;
)


WindowDef(\PdefEditor).front( Pdef(\ktl) )

Pdef(\ktl).envir[\freqenv] = nil

Pdef(\ktl).asParamGroup.presetCompileString.editorInsert
(
ParamGroup([
	Param(Pdef('ktl'), 'dur'),
	Param(Pdef('ktl'), 'legato'),
	Param(Pdef('ktl'), 'amp'),
	Param(Pdef('ktl'), 'pan'),
	Param(Pdef('ktl'), 'freq'),
	Param(Pdef('ktl'), 'freqenv'),
	Param(Pdef('ktl'), 'formbw'),
	Param(Pdef('ktl'), 'formamp'),
	Param(Pdef('ktl'), 'rq'),
	Param(Pdef('ktl'), 'bpfamp'),
	Param(Pdef('ktl'), 'pulseamp'),
	Param(Pdef('ktl'), 'adsr')
]).presets_(IdentityDictionary[
	'current' -> [ 1.0, 0.8, 0.33149678604224, 0.0, 12271.814546826, Env([ 1, 2, 1.5, 1 ], [ 0.4, 4, 1 ], [ 0, 0, 0 ]), 8097.6892585373, 0.45986329782677, 0.10779004537346, 2.6510915231298, 0.38815334473564, Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.21627445352983 ], [ -4, -4, -1 ], 2) ]
]);

);


(
Pdef(\demo, Pdef(\xdemo, 
	Ppar([
		Pbind(
			\freq, [12000,10000,13000],
		)<>
		Pdef(\ktl, Pbind(
			\instrument, \scream,
		)) <>
		Pbind(
			\dur, 4,
			\legato, 0.45,
			\amp, 0.1,
		),
	])
)).play;
)
