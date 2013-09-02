~name = \7;

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, tsustain=0.2, 
	fmrange=400, fmfreq=300;
	var sig, sig1, sig2, sig3;
	var env1;
	var modsig1;
	var cartab, fmtab;
	var freqtab;
	env1 = EnvGen.kr(\env1.kr(Env([0.01,2,0.1,2],[0.001,0.8,0.1].normalizeSum)), gate, timeScale:tsustain);
	fmtab = \fmtab.kr([1,2,3,4,5,6,7,8]) * fmfreq * env1;
	modsig1 = SinOsc.ar(fmtab);
	cartab = \cartab.kr([1,2,3,4,5,6,7,8]) * fmrange * env1;
	freqtab = \freqtab.kr([1,2,3,4,5,6,7,8].normalizeSum);
	sig = LFSaw.ar(modsig1 * cartab + freq);
	sig2 = SinOsc.ar(freqtab * freq);
	sig = sig + sig2;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.0001,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	//\freq, Pseq([100,500],inf),
	\instrument, ~name,
	\degree, Pseq([0,1,5,1],inf),
	\fmrange, 0.50,
	\isRest, Veco(~name).isrest,
	\octave, 5,
	\dur, 1/8,
));

);
