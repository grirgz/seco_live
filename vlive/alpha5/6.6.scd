
(
Ndef(~name+++\fx, { arg freq=90, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var freq2;
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
	//freq = env2;
	freq = LFSaw.kr(1/4*~t).range(90,50);
	freq = Duty.kr(1/8/~t, 0, Dseq([
		//Dstutter(8,
		//	Dseq([
		//		90,50,
		//		190,50,
		//		90,50,
		//		790,50,
		//	],1),
		//),
		Dstutter(1,
			Dseq([
				90, 90, 90, 90,
				90, 190, 90, 90,
				50, 50, 50, 50,
				50, 50, 50, 50,
				90,50, 190,50,
				790,50, 190,50,
				50, 50, 50, 50,
				50, 50, 50, 50,
			],1),
		),
		Dstutter(1,
			Dseq([
				90, 90, 90, 90,
				90, 190, 90, 90,
				450, 50, 50, 50,
				50, 90, 50, 50,
				90,50, 190,50,
				790,50, 190,50,
				50, 50, 50, 50,
				50, 50, 1450, 50,
			],1),
		),
	],inf)).lag(
		Duty.kr(1/8/~t, 0, Dseq([
			Dstutter(8,
				Dseq([
					8,1,1,1,
					0,0,1,1,
					0,0,1,1,
					2,0,0,0,
				],1),
			),
		],inf)) / ~t
	);
	env1 = Duty.kr(1/4/~t, 0, Dseq([
		1,0,0,0,
		1,0,0,0,
		1,0,0,0,
		4,1,0,0,
	],inf)).lag(0.01)+1;
	env4 = Duty.kr(1/~t, 0, Dseq([
		1,0,0,0,
		1,0,1,0,
		1,0,1,0,
		1,1,1,1,
	],inf));
	env5 = Duty.kr(1/~t, 0, Dseq([
		1,0,1,0,
		1,0,1,0,
		1,1,1,1,
		1,0,0,0,
	],inf));
	env6 = Duty.kr(1/~t, 0, Dseq([
		8,8,8,8,
		16,4,8,8,
		2,1,4,1,
		8,1,4,1,
		2,1,4,1,
		0,0,0,0,
		8,1,4,1,
	],inf));
	//freq = freq * ( 1 + ( SinOsc.ar(freq*2 * env1) * 1 ));
	sig = LFSaw.ar(freq * [1,2.001,1.0001]);
	freq2 = freq * Duty.kr(1/~t, 0, Dseq([
		1,4,2,8,
		1,1/2,1,1/4,
		8,1,4,1,
	],inf)).lag(
		Duty.kr(1/~t, 0, Dseq([
			1,0,2,0,
		],inf))
	);
	sig1 = SinOsc.ar(freq2);
	sig1 = sig1 + Pulse.ar(freq2);
	sig = SelectX.ar( SinOsc.kr(env1*~t * [1,1.1,1.001]).range(0,1), [sig, sig1]);
	//sig = (sig*10).fold2(0.9) + sig;
	sig = CombL.ar(sig, 4/~t, 1/8/8/(env5+1)/~t,env4/~t) + sig;
	sig = (sig*10).tanh;
	sig = RLPF.ar(sig, 700 * SinOsc.kr(1/8 * [1,3]).range(1,10), 0.1);
	sig1 = sig * LFPulse.kr(env6*~t,0,0.9).range(0,1);
	sig = SelectX.ar(
		Duty.kr(1/~t, 0, Dseq([
			1,0,0,0,
		],inf))
		, [sig, sig1]);
	//sig = sig * Duty.kr(1/~t, 0, Dseq([
	//	1,1,1,1,
	//	1,1,1,1,
	//	1,0,1,1,
	//	1,1,1,1,

	//	1,1,1,1,
	//	1,0,1,1,
	//	1,0,0,0,
	//	1,0,1,0,
	//],inf));
	//sig = sig * LFPulse.kr(3*~t,0,0.9).range(1,2);
	sig = Pan2.ar(sig, SinOsc.kr((1..sig.size)*~t).range(-1,1), amp).flop;
	sig = sig / 4;
})
);
