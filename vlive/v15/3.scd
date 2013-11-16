~name = \3;

(
SynthDef(\explode, {arg i_out, freq = 200, gate = 1, pan=0.5, amp=0.1, lpfreq=1000, sat=500, verbamp=0.4, room=0.5, mixverb=0.5,
						bpfreq1=100,bpfreq2=2000, bpfreq3=1000, rq=0.3;
	var ae,sig;

	ae = EnvGen.kr(\asr.kr(Env.asr(0, 1, 1.05, 1, 0)), gate, doneAction:2);
	sig = Impulse.ar(0);
	sig = BPF.ar(sig, [bpfreq1, bpfreq2, bpfreq3], rq);
	sig = sig.sum;
	sig = LPF.ar(FreeVerb2.ar(sig,sig,mixverb,room,verbamp),freq);
	sig = (sig*sat).tanh;
	sig = LPF.ar(sig,lpfreq);
	Out.ar(i_out, amp*ae*sig);
}).add;
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, \explode,
	\degree, Pseq([0],inf),
	//\isRest, Veco(~name).isrest,
	\dur, 4,
	\amp, 0.4 * Pkey(\amp),
) <> Veco(~name).mixer)
);

// END

(
SynthDef(\explode, {arg i_out, freq = 200, gate = 1, pan=0.5, amp=0.1, lpfreq=1000, sat=500, verbamp=0.4, room=0.5, mixverb=0.5;
	var ae,sig;

	ae = EnvGen.kr(\asr.kr(Env.asr(0, 1, 1.05, 1, 0)), gate, doneAction:2);
	sig = Impulse.ar(0);
	sig = LPF.ar(FreeVerb2.ar(sig,sig,mixverb,room,verbamp),freq);
	sig = (sig*sat).tanh;
	sig = LPF.ar(sig,lpfreq);
	Out.ar(i_out, amp*ae*sig);
}).add;
);
