
Ndef(~name+++\fx).put(0, { arg amp=0.1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var det;
	freq = Duty.kr(1/4/~t, 0, Dseq([
		Dstutter(2,
			(50+Dseq([10,50,80,89],inf)) * 2
		),
	],inf));
	freq = 2 * freq;
	det = Duty.kr(1/~t, 0, Dseq([
		0.1,0.004,0.0004,0.01,
	],inf)).lag(0.7);
	//det = det * SinOsc.ar(SinOsc.kr(1/18).range(1,80));
	sig1 = LFSaw.ar(freq * 1 + (det * [1,-1]));
	sig2 = LFSaw.ar(freq * 0.99 );
	sig3 = LFSaw.ar(freq * 1 );
	sig3 = sig3 + LFSaw.ar(freq * 1/4 );
	sig = sig1 + sig2 + sig3;
	sig = RLPF.ar(sig, SinOsc.kr( Duty.kr(1/2/~t, 0, Dseq([
		8,4,2,6,
	],inf))*~t).range(0,1) * 0.9 + 1 * Duty.kr(1/~t, 0, Dseq([
		Dseq([
			1000, 1000, 1000, 1000, 
			8000, 2000, 2000, 8100,
			1000, 4000, 1000, 1000, 
			1000, 1000, 1000, 1000, 
		],8),
	],inf)).lag(0.1));
	sig = (sig * Duty.kr(1/8/~t, 0, Dseq([
		1,0,0,0,
		0,0,0,0,
		1,0,Drand([0,10,500,100]),0,
		0,1,1,1,
		Drand([
			Dseq([
				10,0,0,0,
				0,0,100,1,
				1,0,0,0,
				0,1,100,1,
			],1),
			Dseq([
				10,0,100,50,
				0,0,100,1,
				1,0,0,0,
				0,1,100,1,
			],1),
			Dseq([
				0,0,100,1,
				10,0,100,50,
				0,1,100,1,
				1,0,100,0,
			],1),
		],1),
	],inf))).tanh;
	sig = sig / 4;
	//sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, spread, amp, pan);
	sig;
});

// END

Ndef(~name+++\fx).clear
~replace
