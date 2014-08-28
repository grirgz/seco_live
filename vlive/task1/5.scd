

~pdef_channel.();

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var env1;
	env1 = EnvGen.ar(Env.adsr(0.04,0.1,0.1,0.1),gate,doneAction:0);
	sig = LFSaw.ar(freq * [1,1/2.001,1/2.002,2.003,0.5]);
	sig = sig + LFPulse.ar(freq * [1,1/2.001,1/2.002,2.003,0.5]);

	sig = RLPF.ar(sig, [1000,200], \rq.kr(0.3));
	//sig = sig + SinOsc.ar(freq * 2 * [1,1.01,1.02,1.03]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(~name+++\b, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var env1;
	env1 = EnvGen.ar(Env.adsr(0.04,0.1,0.1,0.1),gate,doneAction:0);
	sig = LFSaw.ar(freq * [1,1/2.001,1/2.002,2.003,0.5]);
	sig = sig + LFPulse.ar(freq * [1,1/2.001,1/2.002,2.003,0.5]);

	sig = RLPF.ar(sig, [1000,200] * (1 + SinOsc.kr(\wfreq.kr(8)).range(-1,1.1)), \rq.kr(0.3));
	//sig = sig + SinOsc.ar(freq * 2 * [1,1.01,1.02,1.03]);
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
	\amp, 0.2 * Pkey(\amp),
) <> Veco(~name).mixer)
);
