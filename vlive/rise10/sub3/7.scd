

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var env;
	env = EnvGen.ar(Env([0.1,1.1,4.4],[0.01,1]),gate,doneAction:2);
	sig = LFPulse.ar(freq * [1,1.001,2,1/2,2.001]);
	sig = RLPF.ar(sig, freq*\lpratio.kr(4) * env) | (sig + 1 * 5);
	sig = LeakDC.ar(sig);
	sig = sig / 5;
	sig = RLPF.ar(sig, freq*8);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

~pdef_channel.();

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.2 * Pkey(\amp),
) <> Veco(~name).mixer)
);
