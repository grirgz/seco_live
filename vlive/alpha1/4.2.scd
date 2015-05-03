
(
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var freq2;
	var pan;

	freq = 100*1;
	freq = Duty.kr(1/~t, 0, Dseq([
		Dseq([1,0,4,0,],1) + Dstutter(Drand([1,2,3],inf),
			Drand([0,-12,0,0],4)
		),
		
	],inf)).midiratio * freq;
	freq2 = (-20!8).rand;
	sig = SinOsc.ar(freq + ( freq2 / 8));
	sig = sig * ( 1 + ( FreqShift.ar(sig, freq2 * SinOsc.kr(41/4).range(0,1)) * SinOsc.kr(1/4).range(0,1) ) );
	sig = sig / 2;
	
	amp = amp * \gain.kr(1);
	sig = sig * EnvGen.kr(\iadsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), Trig.kr(\itrig.tr(1),\isustain.kr(1)), doneAction:0);

	sig = sig + CombL.ar(sig, 1, 1/8/8 * (1..8) * LFNoise1.kr(1/8 * (1..8)/8).range(0.8,2.0), 1, mul:0.1);
	sig = sig + CombL.ar(sig, 1, 1/8/8 * (1..8) * LFNoise1.kr(1/8 * (1..8)/8).range(0.8,2.0), 1, mul:0.1);
	sig = (sig*23* LFNoise1.kr(1/8 * (1..8)).range(0,1)).tanh;
	sig = LPF.ar(sig, 1000 * LFNoise1.kr(1/4* (1..8)/8).range(0.1,2.0));

	sig = sig * EnvGen.kr(\iadsr2.kr(Env.adsr(0.1,0.1,0.8,0.1)), Trig.kr(\itrig2.tr(1),\isustain2.kr(1)), doneAction:0);

	//sig = BPF.ar(sig, freq * LFNoise1.kr(1/2 * (1..8)/16).range(0.4,1.4),0.11);
	sig = BPF.ar(sig, \bpf.kr(70),\bprq.kr(0.11));
	sig = sig * 16 * 1;
	//sig = sig.tanh;
	//sig = sig * 6;

	pan = 0;
	//pan = Duty.kr(1/~t, 0, Dseq([
	//	Drand([
	//		Dseq([
	//			1,0,-1,0,
	//		],1) * Drand([1,0.3,0.5],inf),
	//		Dseq([
	//			1,0.3,
	//		],1),
	//		Dseq([
	//			-1,-0.3,
	//		],1),
	//	],1),
	//],inf));
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size * pan, amp).mean;
	sig;
});

Ndef(~name+++\fx).put(1, \set -> Pbind(
	\itrig, Pseq([1,1],inf),
	\isustain, 0.01,
	\iadsr, Plazy({ arg ev;
		Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.03) ],
			[ Env.adsr(0.01,0.1,0.8,0.23) ],
			[ Env.adsr(0.01,0.1,0.8,0.53) ],
		],1).stutter(Prand([1,2,3,4,10],inf));
	}).loop,
	\dur, 1/4,
));
Ndef(~name+++\fx).put(2, \set -> Pbind(
	\isustain2, Pseq([0.01,0.08,0.04],inf),
	\iadsr2, Plazy({ arg ev;
		Pwalk([
			[ Env.adsr(0.01,0.1,0.8,2.53) ],
			[ Env.adsr(0.08,0.1,0.8,2.53) ],
			[ Env.adsr(0.08,0.1,0.8,7.53) ],
			[ Env.adsr(0.01,0.1,0.8,0.53) ],
			[ Env.adsr(0.01,0.1,0.8,2.53) ],
			[ Env.adsr(0.01,0.1,0.8,1.53) ],
		],Pseq([1,1,1,1,4,2,1,-4,Prand([2,1,-2,-3],1)],1));
	}).loop,
	\itrig2, Pseq([
		1,0,0,0, 1,0,1,0,
		0,0,1,0, 1,1,1,0,
		1,0,0,1, 0,0,1,0,
		0,1,1,0, 1,0,0,1,
	],inf),
	\dur, 1/4,
));
)

