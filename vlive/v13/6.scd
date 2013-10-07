~name = \6;

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, mix=0.4;
	var sig, sig1, sig2, sig3;
	sig = SinOsc.ar(freq * [1.01, 1, 0.99, 2,   2.001, 0.5]) * [1,1,1,0.3, 0.3,1];
	sig2 = LFSaw.ar(freq * [1,1.001,0.99]) /2;
	sig2 = RLPF.ar(sig2, freq * 8/2);
	sig = SelectX.ar(mix, [sig, sig2]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
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
	\dur, 1/4,
	\amp, 0.2 * Pkey(\amp),
	) <> Veco(~name).mixer)
);
