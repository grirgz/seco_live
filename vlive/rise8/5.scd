~name = 'rise8-5';
(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var freqA = freq;
	var ampA = amp;
	var opA, opB, opC;
	opC = SinOsc.ar(\freqC.kr(100)) * \ampC.kr(1);
	opB = SinOsc.ar(\freqB.kr(100), opC) * \ampB.kr(1);
	opA = SinOsc.ar(freqA, opB) * ampA;
	sig = opA;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(~name+++\b, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var freqA = freq;
	var ampA = amp;
	var opA, opB, opC;
	opC = SinOsc.ar(\freqC.kr(100)) * \ampC.kr(1);
	opB = SinOsc.ar(\freqB.kr(700), opC) * \ampB.kr(1);
	opA = SinOsc.ar(freqA * [1,1.01,1.001], opB) * ampA;
	sig = opA;
	sig = HPF.ar(sig, 60);
	sig = LPF.ar(sig, 1120);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

Veco(~name).make_mixer;

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name+++\b,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.4 * Pkey(\amp),
) <> Veco(~name).mixer)
);

// END

~name
