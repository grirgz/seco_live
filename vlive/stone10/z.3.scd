
(
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var env1;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var fspread;
	var trigs;

	freq = 140;
	trigs = Impulse.kr((1..3)/3 + \pulsephase.kr(0.1));
	fspread = \fspread.kr(0.1);
	//sig = SinOsc.ar(1700 * [1,2,3] * SinOsc.kr((1..10)/400).range(1,1.01)) * (1..10) * SinOsc.kr(1/7 * (1..10)/1).range(0,2);
	sig = LFSaw.ar(470 * ((0..10)/10 - 0.5 * fspread + 1));
	
	sig = RLPF.ar(sig, [ 500,700,1000 ]);
	sig = sig * EnvGen.kr(Env([0,1,1,0],[0.01,\sus.kr(0.1),0.01]), trigs);
	//sig = SinOsc.ar(freq, sig1);
	//sig = RHPF.ar(sig,700);
	//sig = RLPF.ar(sig,900);

	sig = sig / 4;

	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;
	sig;
});

~set_macro.(\k1, Ndef(~name+++\fx), \sus, \amp);
~set_macro.(\k2, Ndef(~name+++\fx), \pulsephase, \amp);
~set_macro.(\k3, Ndef(~name+++\fx), \fspread, \amp);

)
