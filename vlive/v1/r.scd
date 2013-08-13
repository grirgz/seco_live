~name = \r;

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, spread=0.8;
	var sig, sig2, env1, env2;
	sig = ClipNoise.ar(1);
	sig = LPF.ar(sig, 1300);
	sig = HPF.ar(sig, 1030);
	env1 = EnvGen.ar(Env([500,20],[0.05]),gate,doneAction:0);
	sig2 = SinOsc.ar(env1 * [1,2.101,0.5]);
	sig = sig + sig2;
	sig = RLPF.ar(sig, 2400);
	sig = sig * EnvGen.ar(Env.adsr(0.001,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig.tanh + sig.distort;
	sig = FreqShift.ar(sig, 2) + sig;
	sig = sig.sum;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
)

(
Pdef(~name, Pbind(
	\instrument, ~name,
	\degree, Pseq([0,2,4]+10,inf),
	\isRest, ~sceneset.seq.prythm(3),
	\sustain, 0.1,
	\dur, 1/4,
));
)
