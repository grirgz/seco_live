~name = 'w';

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=300, rq=0.3,
					mix=0.5, ffmix=0.5, ffreq2=300, fmfreq=1, fmscale=0, fmbase=1;
	var sig, sig1, sig2, sig3;
	freq = SinOsc.ar(fmfreq) * fmscale + fmbase * freq;
	sig1 = LFSaw.ar(freq * \sawtab1.kr(Array.geom(8,1/4,2)));
	sig2 = LFSaw.ar(freq * \sawtab2.kr(Array.geom(8,1,0.91)));
	sig = SelectX.ar(mix, [sig1,sig2]);
	sig1 = RLPF.ar(sig, ffreq * (\ffreqtab.kr(Array.geom(8,0.1,2).scramble)), rq);
	sig2 = RLPF.ar(sig, ffreq2 * (\ffreqtab2.kr(Array.geom(8,0.1,2).scramble)), rq);
	sig = SelectX.ar(ffmix, [sig1,sig2]);
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


