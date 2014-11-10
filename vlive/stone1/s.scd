~name = 'stone1-s';

~pdef_channel.();

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var size = 8;
	sig = ClipNoise.ar;
	sig = SinOsc.ar(4100*XLine.kr(4,0.1,1)) * sig;
	sig = sig * EnvGen.ar(Env.perc(0.01,0.01),Impulse.kr(\imprate.kr(4)),doneAction:0);
	//sig = Decay2.ar(Impulse.ar(\imprate.kr(4)), 0.1,\dec.kr(1.4), sig);
	//sig = Klank.ar(Ref([{ ExpRand(100,12700.0) }!size, {Rand(0.01,0.3) }!size, {Rand(0.01,0.4) }!size]), sig);
	sig = DynKlank.ar(Ref([\freqs.kr(100!size), \amps.kr(0.01!size), \decays.kr(0.01!size)]), sig);
	//sig = sig.tanh/2;
	sig = sig / 2;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.0001,0.1,0.8,1.1)),gate,doneAction:doneAction);
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
