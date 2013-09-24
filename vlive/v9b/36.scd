~name = \36;

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, rq=0.3, lag=0.1;
	var sig, sig1, sig2, sig3;
	freq = freq.lag(lag);
	rq = rq.lag(lag);
	sig = SinOsc.ar(freq);
	sig = ClipNoise.ar(1);
	sig = RLPF.ar(sig, freq, rq);
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
	//\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.3 * Pkey(\amp),
) <> Veco(~name).mixer)
);
