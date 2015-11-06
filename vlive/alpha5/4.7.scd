
(
Ndef(~name+++\fx, { arg freq=90, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = Duty.kr(1/8/~t, 0, Dseq([
		1,0,0,0,
		1,0,0,0,
		1,0,0,0,
		4,1,0,0,
	],inf)).lag(0.01);
	freq = freq * ( 1 + ( SinOsc.ar(freq*2 * env1 * ~t) *1 ));
	sig = LFSaw.ar(freq * [1,1.001,2]);
	sig1 = SinOsc.ar(freq);
	sig = SelectX.ar( SinOsc.kr(4 * ~t * [1,1.1,1.001]).range(0,1), [sig, sig1]);
	sig = LPF.ar(sig, 1700);
	sig = Pan2.ar(sig, SinOsc.kr((1..sig.size) * ~t).range(-1,1), amp).flop;
})
);
