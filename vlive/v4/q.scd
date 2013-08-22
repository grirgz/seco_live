~name = \q;

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, minrange=100, maxrange=300;
	var sig, sig1, sig2, sig3;
	sig = SinOsc.ar([freq,freq+0.1]);
	sig = sig.range(minrange,maxrange);
	sig = sig.sum ;
	sig1 = EnvGen.ar(\adsr.kr(Env.adsr(0.0001,0.1,0.8,0.1)),gate,doneAction:doneAction);
	//sig.poll;
	Out.kr(out, sig);
}).add;
);
(
Pdef(~name, Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\freq, 2*8 / Ptempo(),
	\group, ~modgroup,
	\maxrange, 100,
	\minrange, 60,
	\legato, 1,
	\out, ~mybus[1],
	\dur, 8,
	\dur, 4*8,
	\amp, 0.1
))
);

~mybus[1].set(780)
