~name = 'd';

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=4000, rq=0.3;
	var sig, sig1, sig2, sig3;
	var env1;
	//freq = SinOsc.kr(freq*4) * Linen.kr(gate, 0.01,0.1) + 1 * freq;
	env1 = Linen.kr(gate, 0.051,0.21)*0.01;
	freq = freq * Array.series(8,0.99,env1);
	ffreq = ffreq * Array.series(8,0.99,env1);
	sig = LFSaw.ar(freq);
	sig = sig + SinOsc.ar(freq);
	sig = RLPF.ar(sig, ffreq, rq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

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
