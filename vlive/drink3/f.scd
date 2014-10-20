~name = 'drink3-f';

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var env;
	freq = freq.lag(\flag.kr(0.1));
	env = EnvGen.ar(Env([0.1,1.1,4.4],[0.01,1]),gate,doneAction:0);
	sig = SinOsc.ar(freq * [1,1.001]);
	sig = sig + LFPulse.ar(freq * [1,1.001]);
	//sig = sig + LFPulse.ar(XLine.kr(8000,0.001,0.08));
	//sig = SinOsc.ar(freq, SinOsc.kr(freq*[1,2,4,8]));
	//sig = SinOsc.ar(freq, XLine.kr(1000,0.001,0.01)) * 2;
	sig1 = SinOsc.ar(freq, SinOsc.kr(XLine.kr(1000,0.001,0.11)));
	sig = SinOsc.ar(freq * [1,1/2,2,1.001], sig1 * \ampB.kr(1));
	sig = SelectX.ar(\select1.kr(0.5), [sig, sig1]);

	//sig = RLPF.ar(sig, freq*\lpratio.kr(4) * env) | (sig + 1 * 5);
	sig = LeakDC.ar(sig);
	//sig = sig / 5;
	sig = RLPF.ar(sig, (freq*[1.01,2.1,2,1] * \lfratio.kr(1)).clip(10,18000));
	sig = sig * EnvGen.ar(\iadsr.kr(Env.adsr(0.01,0.1,0.8,0.01)),\igate.kr(1),doneAction:0);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);


(
SynthDef(~name+++\b, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var env;
	freq = freq.lag(\flag.kr(0.1));
	env = EnvGen.ar(Env([0.1,1.1,4.4],[0.01,1]),gate,doneAction:0);
	sig = SinOsc.ar(freq * [1,1.001]);
	sig = sig + LFPulse.ar(freq * [1,1.001,2,2.01,1/2]);
	//sig = sig + LFPulse.ar(XLine.kr(8000,0.001,0.08));
	//sig = SinOsc.ar(freq, SinOsc.kr(freq*[1,2,4,8]));
	//sig = SinOsc.ar(freq, XLine.kr(1000,0.001,0.01)) * 2;
	sig1 = SinOsc.ar(freq, SinOsc.kr(\fmfreq.kr(1000)));
	sig = SinOsc.ar(freq * [1,1/2,2,1.001], sig1 * \ampB.kr(1));
	sig = SelectX.ar(\select1.kr(0.5), [sig, sig1]);

	//sig = RLPF.ar(sig, freq*\lpratio.kr(4) * env) | (sig + 1 * 5);
	sig = LeakDC.ar(sig);
	//sig = sig / 5;
	sig = RLPF.ar(sig, (freq*[1.01,2.1,2,1] * \lfratio.kr(1)).clip(10,18000));
	sig = sig * EnvGen.ar(\iadsr.kr(Env.adsr(0.01,0.1,0.8,0.01)),\igate.kr(1),doneAction:0);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(~name+++\c, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var env;
	freq = freq.lag(\flag.kr(0.1));
	env = EnvGen.ar(Env([0.1,1.1,4.4],[0.01,1]),gate,doneAction:0);
	sig = SinOsc.ar(freq * [1,1.001]);
	sig = sig + LFPulse.ar(freq * [1,1.001]);
	//sig = sig + LFPulse.ar(XLine.kr(8000,0.001,0.08));
	//sig = SinOsc.ar(freq, SinOsc.kr(freq*[1,2,4,8]));
	//sig = SinOsc.ar(freq, XLine.kr(1000,0.001,0.01)) * 2;
	sig1 = SinOsc.ar(freq, SinOsc.kr(XLine.kr(1000,0.001,4.11)));
	sig = SinOsc.ar(freq * [1,1/2,2,1.001], sig1 * \ampB.kr(1));
	sig = SelectX.ar(\select1.kr(0.5), [sig, sig1]);

	//sig = RLPF.ar(sig, freq*\lpratio.kr(4) * env) | (sig + 1 * 5);
	sig = LeakDC.ar(sig);
	//sig = sig / 5;
	sig = RLPF.ar(sig, (freq*[1.01,2.1,2,1] * \lfratio.kr(1)).clip(10,18000));
	sig = sig * EnvGen.ar(\iadsr.kr(Env.adsr(0.01,0.1,0.8,0.01)),\igate.kr(1),doneAction:0);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	4.do {  sig = HPF.ar(sig, 100); };
	4.do {  sig = LPF.ar(sig, 500); };
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

// END

236.midicps
