

~pdef_channel.();

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	freq = freq * ((0..7)/7 - 0.5 * \fspread.kr(0.001) + 1);
	sig = SinOsc.ar(freq* \freqfac.kr(1));
	sig = LFCub.ar(freq/2)/8 + sig;
	sig = RLPF.ar(sig, \lpf.ar(100), \rq.kr(0.4));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(~name+++\b, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var fspread;
	freq = freq * ((0..7)/7 - 0.5 * \fspread.kr(0.001) + 1);
	sig = SinOsc.ar(freq* \freqfac.kr(1));
	sig = LFCub.ar(freq/2)/8 + sig;

	sig1 = sig * LFSaw.ar( \ringfreq.kr(1) * freq );
	sig = SelectX.ar( \mix1.kr(1), [sig, sig1]);

	sig = RLPF.ar(sig, \lpf.ar(100), \rq.kr(0.4));

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
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
