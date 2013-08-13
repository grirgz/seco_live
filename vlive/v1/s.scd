~name = \s;


(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, range=200, carrier=300;
	var sig;
	sig = LFPulse.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * range + carrier;
	Out.kr(out, sig);
}).add;
)

(
Pdef(~name, Pbind(
	\instrument, ~name,
	\range, 500,
	\carrier, 700,
	\freq, 1.4,
	\dur, 2.4,
	\out, ~mybus,
));
)
Pdef(~name).quant = 1
