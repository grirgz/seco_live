~name = \u;

Veco(~name).make_mixer;

SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, spread=0.8;
    var sig;
    var tab;
    tab = \tab.kr(1 ! 15);
    sig = LFSaw.ar(freq * tab.abs);
    sig = sig * LFPulse.ar(freq * tab.abs);
    sig = sig.sum;
    sig = RLPF.ar(sig, Rand(10,freq*2) + 100 * SinOsc.ar(tab.abs/10).range(0.01,Rand(2,17)));
    //sig = sig.sum;
    sig = sig / 10;
    sig = sig.tanh;
    sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1+ExpRand(0.001,0.2)),gate,doneAction:2);
    //sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig.clip2(1);
    Out.ar(out, sig);
}).add;

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.4 * Pkey(\amp),
) <> Veco(~name).mixer)
);
