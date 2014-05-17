~name = \y;


(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, hpfreq=100, lpfreq=10000;
	var sig, sig1, sig2, sig3;
	var size = 9;
	var freqs = \freqs.kr(100!9);
	sig = size.collect{ arg x;
		Klank.ar(`[freqs[x]*(1..42)],WhiteNoise.ar(0.0005)) * LFNoise1.kr(x).range(0,1);
	};
	sig.postln;
	//sig = SinOsc.kr(50);
	sig = HPF.ar(sig, hpfreq);
	sig = LPF.ar(sig, lpfreq);
	sig = sig + DelayN.ar(sig, 0.01,0.01 * [1,1.2]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,1.1)),gate,doneAction:doneAction);
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
	\freqs, Plazy({
		[ { 100.rand } ! 9 ].postln;
	}).loop,
	\freqs, Plazy({
		Pseq([
			[ { 100.rand } ! 9 ],
			[ { 1000.rand } ! 9 ],
		])
	}).loop,
	\hpfreq, Pseq([10, 1000],inf),
	\lpfreq, Pseq([1000, 10000],inf),
	\lpfreq, 1000,
	\dur, 1,
	\legato, 0.2,
	\isRest, false,
	\amp, 4.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
