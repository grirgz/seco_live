~name = '5';

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=500;
	var sig, sig1, sig2, sig3;
	freq = \freqtab.kr(Array.geom(8, 1,0.99)) * freq;
	sig = LFSaw.ar(freq);
	sig = LPF.ar(sig, ffreq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.0001,0.1,0.8,0.001)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);
(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\freqtab, [Array.geom(8, 1,0.85)],
	//\freq, 100,
	\ffreq, 4500,
	\legato, 1.8,
	\dur, 1/4,
	\amp, 0.7 * Pkey(\amp),
) <> Veco(~name).mixer)
);
