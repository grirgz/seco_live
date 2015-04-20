

~pdef_channel.();

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.1, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var fspread = 0.00001;
	freq = freq * [1/2,1,2];
	sig = LFCub.ar(freq * ((0..7)/7 - 0.5 * fspread + 1));
	sig = sig.tanh;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
~pdef_init.(Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
))
);
