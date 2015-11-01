
(
Ndef(~name+++\fx, { arg freq=90, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env2 = Duty.kr(4/~t, 0, Dseq([
		90,70,100,70,
	],inf));
	env2 = SelectX.kr(
		Duty.kr(1/16/~t, 0, Dseq([
			1,0,0,0,
			0,1,0,0,
			1,0,1,0,
			1,1,1,1,
			1,1,1,1,
			0,0,0,0,
			0,0,0,0,
		],inf))
		, [env2, 70]);
	freq = env2;
	env1 = Duty.kr(1/4/~t, 0, Dseq([
		1,0,0,0,
		1,0,0,0,
		1,0,0,0,
		4,1,0,0,
	],inf)).lag(0.01)+1;
	freq = freq * ( 1 + ( SinOsc.ar(freq*2 * env1) * 1 ));
	sig = LFSaw.ar(freq * [1,1.001,1.0001]);
	sig1 = SinOsc.ar(freq);
	sig = SelectX.ar( SinOsc.kr(env1*~t * [1,1.1,1.001]).range(0,1), [sig, sig1]);
	//sig = (sig*10).fold2(0.9) + sig;
	sig = RLPF.ar(sig, 700 * SinOsc.kr(1/8 * [1,3]).range(1,10), 0.1);
	sig = sig * Duty.kr(1/~t, 0, Dseq([
		1,1,1,1,
		1,1,1,1,
		1,1,1,1,
		1,1,1,0,
	],inf));
	sig = sig * LFPulse.kr(8*~t,0,0.7).range(0,1);
	sig = Pan2.ar(sig, SinOsc.kr((1..sig.size)*~t).range(-1,1), amp).flop;
	sig = sig / 4;
})
);
