~name = \36;

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=300, rq=0.3;
	var sig, sig1, sig2, sig3;
	//sig = SinOsc.ar(freq, LFTri.kr(freq).range(0,pi/2));
	sig = LFSaw.ar(freq);
	ffreq = LFNoise1.kr(t/2).range(10,SinOsc.kr(0.1).range(100,1500));
	sig = RLPF.ar(sig, ffreq, rq);

	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest(32),
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);

// END

TempoClock.default.tempo = t = 1
