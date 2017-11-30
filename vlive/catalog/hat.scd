

(
	SynthDef(\cymbalsimple, { | out = 0, pan = 0.0 |
		var sig, env;
		env = EnvGen.ar(Env.perc(0.01, 2, curve: -4), doneAction: 2);
		sig = HPF.ar(Ringz.ar(WhiteNoise.ar(0.1), {exprand(1000, 20000)}.dup(100)).mean, 4000);
		Out.ar(out, Pan2.ar(sig * env, pan));
	}).add;
	SynthDef(\cymbalsimple2, { | out = 0, pan = 0.0 |
		var sig, env;
		var env1, env2, env3, env4, env5, env6, env7, env8;
		var freqs;
		env = EnvGen.ar(Env.perc(0.01, 2, curve: -4), doneAction: 2);
		env1 = EnvGen.kr(Env([0,1,0],[0.01,0.08]), 1);
		freqs = {exprand(30, 20000)}.dup(50) ++ {exprand(1020, 10000)}.dup(50);
		sig = HPF.ar(Ringz.ar(WhiteNoise.ar(0.1), freqs).mean, ( 1.1- env1 )*4000);
		sig = sig + EnvGen.ar(Env.perc(0.001,0.001,1), levelScale:1/2);
		sig = sig + LPF.ar(WhiteNoise.ar(0.1),EnvGen.ar(Env.perc(0.5,5,1))* 20000+10,mul:2);
		sig = sig / 3;
		Out.ar(out, Pan2.ar(sig * env, pan));
	}).add;
)



(
SynthDef(\cymbaldan, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var lodriver, locutoffenv, hidriver, hicutoffenv, freqs, res, thwack;

	locutoffenv = EnvGen.ar(Env.perc(0.5, 5)) * 20000 + 10;
	lodriver = LPF.ar(WhiteNoise.ar(0.1), locutoffenv);

	hicutoffenv = 10001 - (EnvGen.ar(Env.perc(1, 3)) * 10000);
	hidriver = HPF.ar(WhiteNoise.ar(0.1), hicutoffenv);
	hidriver = hidriver * EnvGen.ar(Env.perc(1, 2, 0.25));

	thwack = EnvGen.ar(Env.perc(0.001,0.001,1));

	freqs  = {exprand(300, 20000)}.dup(100);
	res    = Ringz.ar(lodriver + hidriver + thwack, freqs).mean;
	sig = ((res * 1) + (lodriver * 2) + thwack);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,1.1,1,-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);



(
Pdef(\demo, 
	Pseq([
		Pbind(
			\instrument, Pseq([
				\cymbalsimple,
				\cymbalsimple2,
				\cymbaldan,
			],inf),
			\freq, 200,
			\dur, 1/4,
			\amp, 0.1,
		)
	])
).play;
)


