~name = \1;

SynthDef(~name, { | out=0 gate=1 freq=100, offset=0.005, doneAction=2 |
	var aEnv, fEnv, osc, flt, sig;
	fEnv = EnvGen.kr(Env.perc(0, 3), levelScale: 6000);
	//aEnv = EnvGen.kr(adsrEnv.asr(0, 1, 1), gate, doneAction: 2);
	aEnv = EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.1)), gate, doneAction:doneAction);
	osc = Mix([Saw.ar(freq * [1, 1+offset]), Pulse.ar(freq / 2, 0.5)]);
	flt = LPF.ar(osc, fEnv + 100);
	sig = flt;
	sig = sig * aEnv;
	Out.ar(out, sig);
}).add;

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1
))
);
