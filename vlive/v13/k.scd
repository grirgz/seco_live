~name = 'k';

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=300, rq=0.3, fmbase=0.5, fmscale=1;
	var sig, sig1, sig2, sig3;
	var mix;
	mix = SinOsc.ar(SinOsc.ar(0.10).range(0,45.9)).range(0,1);
	sig1 = LFSaw.ar(freq * \sawtab1.kr(Array.geom(8,1/4,2)));
	sig2 = LFSaw.ar(freq * (SinOsc.ar(\sawtab2.kr(Array.geom(8,1,0.91))) * fmscale + fmbase));
	sig = SelectX.ar(mix, [sig1,sig2]);
	sig = RLPF.ar(sig, ffreq * (\ffreqtab.kr(Array.geom(8,0.1,2).scramble) + (LFNoise1.kr(5).range(0,1) * [0.1,0.2,0.5] * 10)), rq);
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
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);

// END


