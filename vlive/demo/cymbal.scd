

(

x = {

	var lodriver, locutoffenv, hidriver, hicutoffenv, freqs, res, thwack;
	var sig;
	locutoffenv = EnvGen.ar(Env.perc(0.5, 5)) * 20000 + 10;
	lodriver = LPF.ar(WhiteNoise.ar(0.1), locutoffenv);
	hicutoffenv = 10001 - (EnvGen.ar(Env.perc(1, 3)) * 10000);
	hidriver = HPF.ar(WhiteNoise.ar(0.1), hicutoffenv);
	hidriver = hidriver * EnvGen.ar(Env.perc(1, 2, 0.25));
	thwack = EnvGen.ar(Env.perc(0.001,0.001,1));
	freqs  = {exprand(300, 20000)}.dup(100);
	res    = Ringz.ar(lodriver + hidriver + thwack, freqs).mean;
	sig = ((res * 1) + (lodriver * 2) + thwack).dup;

	sig = sig / 10;

}.play;

)





	~freqs = {exprand(300, 14000)}.dup(100);
(
SynthDef(\cymbal, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var lodriver, locutoffenv, hidriver, hicutoffenv, freqs, res, thwack;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;

	locutoffenv = EnvGen.ar(Env.perc(0.1, 1)) * 18000 + 10;
	lodriver = LPF.ar(WhiteNoise.ar(0.1), locutoffenv);

	hicutoffenv = 10001 - (EnvGen.ar(Env.perc(0.1, 1)) * 10000);
	hidriver = HPF.ar(WhiteNoise.ar(0.1), hicutoffenv);
	hidriver = hidriver * EnvGen.ar(Env.perc(0.01, 2, 0.25));

	thwack = EnvGen.ar(Env.perc(0.001,0.001,1));
	freqs  = {exprand(300, 14000)}.dup(100);
	freqs = ~freqs;
	res    = Ringz.ar(lodriver + hidriver + thwack, freqs).mean;

	env1 = EnvGen.kr(Env([2200,70,50],[0.004,0.4]), 1);
	sig3 = LFCub.ar(env1) * 4;
	sig3 = AllpassL.ar(sig3, 0.1,0.001,0) + sig3;

	sig1 = ((res * 2) + (lodriver * 2) + ( thwack * 1 ) + (sig3)).dup;
	sig2 = lodriver + hidriver + thwack + sig3;
	sig = SelectX.ar( 0.5, [sig1, sig2]);

	//sig3 = WhiteNoise.ar + sig3;
	//sig3 = LPF.ar(sig3, env1);
	//sig = sig + sig3;

	sig = sig / 5;
	//sig = LPF.ar(sig,15000);
	sig = HPF.ar(sig, 500);
	sig = BRF.ar(sig, 700);
	sig = BRF.ar(sig, 2001);
	sig = sig * EnvGen.kr(Env([0,2,2,0],[0.3,0.18,0.09],3,1,3), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\cym, Pbind(
	\instrument, \cymbal,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\legato, Pseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,6,0,
		12,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
	],inf)/2,
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	\amp, 0.1/2
)).play;
);



