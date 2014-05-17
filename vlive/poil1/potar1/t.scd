~name = \t;

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq= 400, rq=0.4, shift=0;
	var sig, sig1, sig2, sig3;
	freq = freq + shift;
	sig = LFSaw.ar(freq * [1.01,0.99,1,0.98]);
	sig = RLPF.ar(sig, ffreq, rq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

Sdef.force(~name, \omg, \preset, [\ffreq, \freq.asSpec, \shift, ControlSpec(-1000,1000,\lin,0,0)]);
//Sdef(~name, \omg).get(0).vals[\ffreq].set_bus_mode(true);
Veco(~name).make_mixer;

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

Sdef(~name, \omg).get(0).vals[\ffreq].set_bus_mode(true);
Sdef(~name, \omg).get(0).vals[\shift].set_bus_mode(true);

Veco(~name).lib.macros = [
	[Sdef(~name, \omg), \ffreq],
	[Sdef(~name, \omg), \shift],
];
// END
Sdef(~name, \omg).edit
