
Ndef(~name+++\fx).put(0, { arg amp=0.1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var det;
	freq = Duty.kr(1/8/~t, 0, Dseq([
		80 * Dseq([
			Dseq([
				0,7,6,2,
			].midiratio,1),
		],1),
	],inf));
	freq = SinOsc.kr(1/24) * XLine.kr(0.001,1,24) + 1 * freq;
	det = Duty.kr(1/~t, 0, Dseq([
		0.1,0.004,0.0004,0.01,
	],inf)).lag(0.7);
	//det = det * SinOsc.ar(SinOsc.kr(1/18).range(1,80));
	sig1 = LFSaw.ar(freq * 1 + (det * [1,-1]));
	sig2 = LFSaw.ar(freq * 0.99 );
	sig3 = LFSaw.ar(freq * 1 );
	sig = sig1 + sig2 + sig3;
	sig = (sig*50).tanh;
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
	sig = sig / 4;
	//sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, spread, amp, pan);
	sig;
});

// END

Ndef(~name+++\fx).clear
~replace
