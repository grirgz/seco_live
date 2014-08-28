~name = 'sub1-6';

~pdef_channel.();

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var env1;
	freq = freq.lag(0.6);
	env1 = EnvGen.ar(Env.adsr(0.04,0.1,0.1,0.1),gate,doneAction:0);
	sig = LFTri.ar(freq * [1,2.001,2.002,1.003,0.5]);
	sig = sig + SinOsc.ar(freq * [1,2.001,1.002,2.003,0.5], sig * 10);

	sig = BPF.ar(sig, freq * [1/2,1,2], \rq.kr(0.9));
	//sig = sig + SinOsc.ar(freq * 2 * [1,1.01,1.02,1.03]);

	//sig = sig * EnvGen.ar(\iadsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),\iamp.kr(1),doneAction:0);
	sig = sig * \iamp.kr(1);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(~name+++\b, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var env1;
	freq = freq.lag(0.6);
	env1 = EnvGen.ar(Env.adsr(0.04,0.1,0.1,0.1),gate,doneAction:0);
	sig = LFPulse.ar(freq * [1,2.001,2.002,1.003,0.5]);
	sig = sig + LFSaw.ar(freq * [1,2.001,1.002,2.003,0.5], sig * 10);

	sig = BPF.ar(sig, freq * [1/2,1,2] , \rq.kr(0.9));
	sig = SelectX.ar(SinOsc.kr(4).unipolar, [sig , sig * SinOsc.ar(freq * 2 * [1,1.01,1.02,1.03] * env1)]);

	//sig = sig * EnvGen.ar(\iadsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),\iamp.kr(1),doneAction:0);
	sig = sig * \iamp.kr(1);
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
