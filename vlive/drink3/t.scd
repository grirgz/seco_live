~name = 'drink3-t';
(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * [1,1,1/2,2];
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(\oscmix.kr(0.8)/2, [sig1, sig2, sig3]);
	sig[2] = (sig[2]*10).tanh;
	//sig = sig * [LFPulse.kr(1/7).range(0,1),1,1,SinOsc.kr(1/42).range(0,1)];
	sig = LFPulse.ar(freq * [1,1.01,1.001]);
	sig = sig | LFPulse.ar(freq/8 * [1,1.01,1.001] *
		Duty.kr(1/2/~t, 0, Dseq([
			1,2,1/2,1,
		],inf))
	,mul:1.98);

	sig = RLPF.ar(sig, \lpf.kr(4100).lag(0.1) * [1/2,1,2,1/2],0.1);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.31)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(~name+++\mono, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * [1,1,1/2,2];
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(\oscmix.kr(0.8)/2, [sig1, sig2, sig3]);
	sig[2] = (sig[2]*10).tanh;
	//sig = sig * [LFPulse.kr(1/7).range(0,1),1,1,SinOsc.kr(1/42).range(0,1)];
	sig = LFPulse.ar(freq * [1,1.01,1.001]);
	sig = sig | LFPulse.ar(freq/8 * [1,1.01,1.001] *
		Duty.kr(1/2/~t, 0, Dseq([
			1,2,1/2,1,
		],inf))
	,mul:1.98);

	sig = RLPF.ar(sig, \lpf.kr(4100).lag(0.1) * [1/2,1,2,1/2],0.1);
	sig = sig * EnvGen.ar(\iadsr.kr(Env.adsr(0.01,0.1,0.8,0.31)),\igate.kr(1),doneAction:0);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.31)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
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
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
