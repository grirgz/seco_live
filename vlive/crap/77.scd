SynthDef("opq", {
arg out, atk, dec, freq, amp=1;
var env, sig;
env = EnvGen.kr(Env.perc(atk, dec), levelScale:amp, doneAction:2);
sig = VOSIM.ar(Impulse.ar(SinOsc.ar(1.01, 0,100, freq)), freq,  SinOsc.ar(1, 0,21, 22), LFDNoise1.ar(0.9, 0.39, 0.91))!2;
//sig = sig / 40;
sig = Limiter.ar(sig);
Out.ar(out, sig*env);
}).add;


(
Pbindef(\variableff,
	\instrument, \opq,
	\scale, Scale.iraq,
	\degree,  Pseq([0, 3, 0, 3, 0, 3, 7, 9, 12], inf),
	\octave, 5,
	\dur, Pseq([1/8, 1/8, 1/8, 1/16, 1/16, 1/8, Rest(1/8)], inf),
	\atk, 0.1,
	\dec, 20,
	\amp, 1/8,
	\stretch, 20,
).play;
)

