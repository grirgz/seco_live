~name = '6';

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, index=0.8, rfreq=100, ffreq=300, rq=0.1;
	var sig, sig1, sig2, sig3;
	var rfreqtab, ross;

	rfreqtab = \rfreqtab.kr([0.1,1,1.1,2,3,4,9]);
	ross = RosslerL.ar(freq:rfreq*rfreqtab, a: 0.2, b: 7.2 * rfreqtab, c: 0.7 * rfreqtab, h: 0.25, xi: 1.1, yi: 0, zi: 0);
	ffreq = SinOsc.ar(Lag.ar(ross))*ffreq*index+ffreq;
	freq = SinOsc.ar(Lag.ar(ross))*freq*index+freq;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, ffreq, rq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = sig.flat;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

Sdef(~name, \mac, \preset, [\legato, ControlSpec(0.01,4,'exp',0,0.5)]);

Veco.do { arg name;
	name.debug("namewhat");
	Veco(~name).lib.macros = { 

		[
			[ Sdef(name, \mac), \legato ]
		]
		++ ~ndef_to_macros.(name+++\lfo1);
	};
};

Veco(~name).make_mixer;

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	//\isRest, Veco(~name).isrest,
	\isRest, Veco(~name).isrest(16),
	\adsr, [Env.adsr(0.01,0.1,0.8,0.5)],
	//\sustain, 1,
	\legato, 0.5,
	\spread, 1,
	\dur, 1/8,
	\amp, 0.07 * Pkey(\amp),
) <> Veco(~name).mixer)
);

