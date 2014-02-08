~name = '36';

SynthDef(~name, { arg out = 0, freq=800, sustain=0.001, amp=0.5, pan = 0, attack=0.002, decay=2.6;
	var window;
	var sig;
	window = Env.perc(attack, sustain, amp * AmpCompA.kr(freq));
	sig = Ringz.ar(PinkNoise.ar(0.1), freq, decay);
	sig = Pan2.ar(sig, pan) * EnvGen.ar(window, doneAction:2);
	Out.ar(out, sig);
}).add;

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
