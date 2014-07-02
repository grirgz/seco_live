~name = \j;

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	//freq = freq + SinOsc.kr({ Rand(100.1,2) }!16,0,0.5*freq);
	sig = LFSaw.ar(freq * ({ Rand(0.1,2) }!16));
	sig = sig + Gendy1.ar(4, [1,2,3,4], SinOsc.kr(1),4,420,3000);
	//sig = Fb ({ arg fb;
	//	var fsig = fb * 0.9 + sig;
	//	//fsig = RHPF.ar(fsig, 100);
	//	fsig = fsig.tanh
	//
	//});
	//sig = CombL.ar(sig, 0.1,0.002,1) + sig;
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
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
