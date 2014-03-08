~name = \v;

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=1000, rq=0.3,
		friction=( 1.75584e-5), mass= 2.69789;
	var sig, sig1, sig2, sig3;
	var imp, klank, rusty;
	imp = Impulse.ar(0);
	sig = Ringz.ar(imp, \freqtab.kr([800, 1071, 1153, 1723,1000]));

	sig = Friction.ar(sig, friction:friction, mass:mass);
	//sig = sig.sum;
	sig = LPF.ar(sig, ffreq, rq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.8)),gate,doneAction:doneAction);
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

