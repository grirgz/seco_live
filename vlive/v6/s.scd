~name = \s;

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, index=0.8, rfreq=100, ffreq=300, rq=0.1;
	var sig, sig1, sig2, sig3;
	var rfreqtab, ross;

	rfreqtab = \rfreqtab.kr([0.1,1,1.1,2,3,4,9]);
	ross = RosslerL.ar(freq:rfreq*rfreqtab, a: 0.2, b: 7.2 * rfreqtab, c: 0.7 * rfreqtab, h: 0.25, xi: 1.1, yi: 0, zi: 0);
	ffreq = SinOsc.ar(Lag.ar(ross))*ffreq*index+ffreq;
	freq = SinOsc.ar(Lag.ar(ross))*freq*index+freq;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, ffreq, rq);
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.00001,0.01,0.8,0.01)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);
(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	//\degree, Pseq([0],inf),
	//\isRest, Veco(~name).isrest,
	\isRest, Veco(~name).isrest(16),
	//\adsr, [Env.adsr(0.01,0.1,0.8,0.05)],
	//\sustain, 0.1,
	//\legato, 0.1,
	\dur, 1/8,
	\amp, 0.1
))
);

