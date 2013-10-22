~name = '37';

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.1, freq=200, doneAction=2, ffreq=300, rq=0.3, oscmix=0.95,
		fmscale=1, fmbase=1, fmfreq=1;
	var sig, sig1, sig2, sig3;

	sig = Impulse.ar(8) * WhiteNoise.ar(1);
	//sig = sig.lag(0.1);
	sig = DynKlank.ar(`[LFNoise1.kr([1,5,10]).range(151,700),0.1,0.5], sig)/1;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)),gate,doneAction:doneAction);
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


