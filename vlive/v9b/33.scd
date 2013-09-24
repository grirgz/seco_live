~name = \33;

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	//var sig, sig2, sig3;
	sig = freq;
	sig2 = LFPar.ar({|i|[i+1*sig,i*sig+(i+1/3)]}!4);
	sig3 = Pulse.ar({|i|i+1}!4,0.35);
	sig = Splay.ar(sig2 > BrownNoise.ar(sig3)/3);
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
	\amp, 0.3
))
);

// END

(
play{ arg fre
	var sig, sig2, sig3;
	sig = freq;
	sig2 = LFPar.ar({|i|[i+1*sig,i*sig+(i+1/3)]}!4);
	sig3 = Pulse.ar({|i|i+1}!4,0.35);
	Splay.ar(sig2 > BrownNoise.ar(sig3)/3);
	SinOsc.ar(sig);

}//#SuperCollider
)
