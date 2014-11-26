
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 200;
	var trig1, trig2, trig3;
	var env1, env2, env3;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var fspread;
	trig1 = TDuty.kr(1/~t, 0, Dseq([
		1,0,0,0,
	],inf));
	env1 = EnvGen.kr(Env([0,1,0],[4.1,4.8]), 1);
	fspread = env1;
	freq = freq * ((0..7)/7 - 0.5 * fspread + 1);
	sig1 = SinOsc.ar(freq);
	sig2 = LFSaw.ar(freq);
	sig = SelectX.ar(env1, [sig1, sig2]);
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
