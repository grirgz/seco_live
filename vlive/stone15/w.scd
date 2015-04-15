
~pdef_channel.();

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.ar(Env.adsr(0.001,0.1,0.51,0.1),gate,doneAction:0);
	sig = SinOsc.ar(freq * [1,1.00001,1.0001 * SinOsc.kr(1/4).range(1.1,1)]);
	//sig = (sig*env1*10).tanh;
	sig = sig.abs > (env1 / 5 + 0.2) * sig;
	sig = RLPF.ar(sig, env1 * [100,500 * SinOsc.kr(4).range(3,1)]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
~pdef_init.(Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
))
);
