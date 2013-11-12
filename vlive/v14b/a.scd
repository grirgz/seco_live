~name = \a;

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig1 = LFSaw.ar(freq * 1 + (0.04 * [1,-1]));
	sig2 = LFSaw.ar(freq * 0.99 );
	sig3 = LFSaw.ar(freq * 1 );
	sig = sig1 + sig2 + sig3;
	sig = (sig*50).tanh;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

~newfxmix.(\fx);
Veco(~name).make_mixer;

(
Ndef(~name+++\fx).isource= { arg ffreq=300, rq=0.3, choose=1, freqshift=40, time=2;
	var in = In.ar(BusDef(~name+++\fx),2);
	var sig;
	var sig1,sig2,sig3,sig4,sig5;
	var ramp;
	sig = in;
	sig1 = RLPF.ar(sig, ffreq, rq);
	ramp = Sweep.kr(Impulse.kr(1/time), 1/time * freqshift) * -1;
	sig2 = FreqShift.ar(sig, ramp);
	sig = SelectX.ar(choose, [sig1, sig2]);
	sig;
};
Ndef(~name+++\fx).quant=4;
);


~num_beats = 1;

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\out, BusDef(~name+++\fx),
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
