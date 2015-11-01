
(
Ndef(~name+++\fx, { arg freq=90, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var freq2;
	env1 = EnvGen.kr(Env([10,80,40],[0.01,0.08]), Impulse.kr(4*~t));
	env2 = Duty.kr(1/~t, 0, Dseq([
		1,1,2,2,
		1/4,1,2,2,
		1,1/2,1,2,
		1/4,1,2,2,
	],inf));
	sig = LFSaw.ar( env1); 
	sig = FreqShift.ar(sig, freq * env2)+sig;
	sig = Pan2.ar(sig, SinOsc.kr((1..sig.size)*~t).range(-1,1), amp).flop;
	sig = sig / 4;
})
);
