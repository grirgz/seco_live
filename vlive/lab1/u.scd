


~pdef_channel.();

(
// nord modular simple bass drum
SynthDef(\nm_simple_bass_drum, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var imp;
	imp = Trig.ar(Impulse.ar(1), 0.001);
	sig = imp;
	sig = RLPF.ar(sig, \lpf.kr(58), \rq.kr(0.1));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.0001,0,1,0.11)),gate,doneAction:doneAction);
	sig = sig  * 20;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, \nm_simple_bass_drum,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
