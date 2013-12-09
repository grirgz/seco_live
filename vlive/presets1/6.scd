~name = '6';

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, rq=0.32, fratio=2.3,
						maxdelaytime=0.1,delaytime=0.1,decaytime=0.2, delayscale=0.1;
	var sig, sig1, sig2, sig3;
	var freqtab;
	var delaytab;
	freqtab = \freqtab.kr(1!8);
	sig = LFSaw.ar(freq * freqtab);
	sig = RLPF.ar(sig, freq*fratio, rq);
	
	delaytab = \delaytab.kr(1!8);
	delaytime = SinOsc.ar(delaytab) * delayscale + delaytime;
	sig = CombL.ar(sig, maxdelaytime,delaytime,decaytime) + sig;
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
	\isRest, Veco(~name).isrest(16),
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
	) <> Veco(~name).mixer)
);
