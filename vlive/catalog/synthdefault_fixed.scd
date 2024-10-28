
// see also libdef/mysynthdefault.scd

SynthDef(\violin, {
	| out=0, freq=200, gate=1, amp=0.1, pan=0 |
	var env = EnvGen.kr(Env.asr(0.1, 1, 0.1), gate, doneAction:2);
	var sig = VarSaw.ar(
		freq,
		width:LFNoise2.kr(1).range(0.2, 0.8)*SinOsc.kr(5, Rand(0.0, 1.0)).range(0.7,0.8)
	)*0.25;
	sig = sig * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
//It is also used for simulating Farfisa organ and flutes
//by nicolaariutti
//http://sccode.org/1-5as
}).add;

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \violin,
			\note, Pseq([
				0,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);
