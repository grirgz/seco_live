~name = '7';

SynthDef(~name, { arg out=0, gate=1, freq=100, offset=0.005, doneAction=2, amp=0.1, freqscale=0.8, ffreq=100;
	var aEnv, fEnv, osc, flt, sig;
	//fEnv = EnvGen.kr(Env.perc(0, 3), levelScale: 6000);
	freq = EnvGen.kr(\fenv.kr( Env([0,1,0], [0.01,0.1], [-9,9]), gate)) * freqscale * freq + freq;
	fEnv = EnvGen.kr(\ffenv.kr( Env([0,1,0]*6000, [0.0,3]), gate));
	//aEnv = EnvGen.kr(adsrEnv.asr(0, 1, 1), gate, doneAction: 2);
	aEnv = EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.1)), gate, doneAction:doneAction);
	osc = Mix([Saw.ar(freq * [1, 1+offset, 1-offset]), Pulse.ar(freq / 2, 0.5)]);
	flt = RLPF.ar(osc, fEnv + ffreq);
	sig = flt;
	sig.postln;
	sig = sig * aEnv;
	sig = Splay.ar(sig, 0.8, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	fenv: \env -> [nil, \unipolar.asSpec, nil, nil, Env([0,1,0], [0.01,0.1], [-9,9])],
	ffenv: \env -> [nil, \freq.asSpec, nil, nil, Env([0,1,0], [0.01,0.1], [-9,9])],
	offset: ControlSpec(0.000001,0.1,\exp, 0,0.001),
	//	duration: ControlSpec(0.001,4,\lin, 0, 1)
))).add;

Sdef(~name, \mypreset, \preset, ~name);
(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest(16),
	\dur, 1/4,
	\amp, 0.05 * Pkey(\amp),
	//\bla, Pfunc({ arg ev; ev[\amp].postln; }),
) <> Veco(~name).mixer)
);
// END

Sdef(~name, \mypreset).rebuild(true)
Sdef(~name, \mypreset).edit
