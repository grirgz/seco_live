
(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var ffreq;
	var lfo1;
	var seq1;
	var seq2, seq3;
	sig = LFSaw.ar(freq * [1,SinOsc.kr(1).range(1,1.001)]);
	sig = sig + LFTri.ar(freq * [1,SinOsc.kr(1).range(1,1.001)]);
	ffreq = EnvGen.ar(Env.adsr(0.1,0.1,1,0.4),gate,doneAction:0) * 1000 + 50;	
	sig = RLPF.ar(sig, ffreq, 0.1);
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,1,0.1),gate,doneAction:2);
	sig = Splay.ar(sig, 0.8, amp, pan);
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
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
