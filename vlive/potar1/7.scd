~name = '7';

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, rq=0.32, fratio=2.3, shift=0;
	var sig, sig1, sig2, sig3;
	freq = freq + shift;
	sig = LFSaw.ar(freq * [1,1.01,1.01]);
	sig = RLPF.ar(sig, freq*fratio, rq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);


Veco(~name).make_mixer;
~swing = (1 + (0.06 * Pseq([-1,1],inf)));
Sdef(~name, \mynotes, \notes);
Sdef(~name, \mypreset, \preset, ~name);
Sdef(~name, \pat, \preset, [\legato, ControlSpec(0.01,2,'exp',0,1), \pitch, \unipolar.asSpec]);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	//\isRest, Veco(~name).isrest(16),
	//\dur, 1/4 * ~swing,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);

(
Veco(~name).lib.macros = [
	[Sdef(~name, \mypreset), \shift, \freq.asSpec,],
	[Sdef(~name, \pat), \legato,],
	[Ndef(~name+++'lfo1'), \freq, \lofreq.asSpec,],
	[Ndef(~name+++'lfo1'), \mul, \unipolar.asSpec,],
	[Sdef(~name, \pat), \pitch,],
];
);
