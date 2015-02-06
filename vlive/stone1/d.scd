~name = 'stone1-d';

~pdef_channel.();

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var size = 8;
	var trig;
	sig = ClipNoise.ar;
	trig = EnvGen.ar(Env([0,1,0],[0.0001,1.08]), 1);
	sig = Decay2.ar(trig, 0.001,\dec.kr(0.04), sig)/10;
	//sig = Klank.ar(Ref([{ ExpRand(100,12700.0) }!size, {Rand(0.01,0.3) }!size, {Rand(0.01,0.4) }!size]), sig);
	sig = DynKlank.ar(Ref([\freqs.kr(100!size), \amps.kr(0.01!size), \decays.kr(0.01!size)]), sig);
	4.do { arg x;
		var del;
		del = DelayL.ar(sig, 1, 0.1 * SinOsc.kr(1/(x+1)).range(1.010,1));
		sig =  del + sig;
		sig = RLPF.ar(sig, 4000/(x*1/8+1) * SinOsc.kr(1*(x+2)).range(0.1,2));
	};
	sig = HPF.ar(sig, 100);
	sig = sig / 8;
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
