~name = 'c';

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=300, rq=0.3, mix1=0.5, tabspread=1;
	var sig, sig1, sig2, sig3;
	var tab;
	tab = Array.series(8,-1,1/4) * tabspread;
	sig1 = LFSaw.ar(freq + tab);
	sig2 = SinOsc.ar(freq + tab);
	sig = SelectX.ar(mix1, [sig1, sig2]);

	sig = RLPF.ar(sig, ffreq + tab, rq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	//sig = sig * 0.002;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

~newfx.(\fx);

Ndef(~name+++\fx, {
	var in = In.ar(BusDef(~name+++\fx),2);
	var sig;
	var sig1,sig2,sig3,sig4,sig5;
	sig = in;
	sig = CombL.ar(sig, 0.4,t/8,4) + sig;
	sig;
});

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\out, BusDef(~name+++\fx),
	\dur, 1/8,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
