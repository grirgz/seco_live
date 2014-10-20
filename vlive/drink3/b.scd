

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig= Impulse.ar(0);
	sig = Decay.ar(sig,0.1);
	//sig= Ringz.ar(sig, TRand.kr([130,120,600], [5000,5000,5000], sig), LFNoise1.kr(1.1!3).range(0.1,0.5));
	sig= Ringz.ar(sig, \rfreqtab.kr([100,110,120,96,100,100,100,100]), \rringtab.kr([1,1,1,1,1,1,1,1]/10));
	//sig= Ringz.ar(sig, [100,110,120]/2, LFNoise1.kr(1.1!3).range(0.3,0.5)/70);
	sig = sig / 9;

	sig = HPF.ar(sig, \hpf.kr(100));
	sig = LPF.ar(sig, \lpf.kr(500));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.4,0.1,0.8,0.1)), gate, doneAction:2);
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
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
