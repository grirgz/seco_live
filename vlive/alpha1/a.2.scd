
(
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var freq2;
	var pan = 1;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;


	freq = 120;
	freq = freq ! 2;
	freq = freq * Duty.kr(1/4/~t, 0, Dseq([
		0,0,12,0,
	],inf)).midiratio.lag(
		Duty.kr(1/4/~t, 0, Dseq([
			0,0,
			1,0,0,0,
			1/2,0,
			0,0,0,0,
		],inf))
	);
	sig = LFSaw.ar(freq);
	sig = sig.fold2(0.8) * Duty.kr(1/~t, 0, Dseq([
		1,0,0,0,
	],inf)) + sig;
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size * pan, amp).mean;
	sig;
});

Ndef(~name+++\fx).put(1, \set -> Pbind(
	\itrig, Pseq([1,1],inf),
	\isustain, 0.11,
	\iadsr, Plazy({ arg ev;
		Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.03) ],
			//[ Env.adsr(0.01,0.1,0.8,0.23) ],
			//[ Env.adsr(0.01,0.1,0.8,0.53) ],
		],1).stutter(Prand([1,2,3,4,10],inf));
	}).loop,
	\dur, 1/8,
));
Ndef(~name+++\fx).put(2, \set -> Pbind(
	\isustain2, Pseq([0.01,0.08,0.04],inf),
	\iadsr2, Plazy({ arg ev;
		Pwalk([
			[ Env.adsr(0.01,0.1,0.8,2.53) ],
			[ Env.adsr(0.08,0.1,0.8,2.53) ],
			[ Env.adsr(0.08,0.1,0.8,7.53) ],
			[ Env.adsr(0.01,0.1,0.8,0.53) ],
			[ Env.adsr(0.01,0.1,0.8,0.53) ],
			[ Env.adsr(0.01,0.1,0.8,0.13) ],
			[ Env.adsr(0.01,0.1,0.8,0.13) ],
			[ Env.adsr(0.01,0.1,0.8,0.03) ],
			[ Env.adsr(0.01,0.1,0.8,0.03) ],
			[ Env.adsr(0.01,0.1,0.8,2.53) ],
			[ Env.adsr(0.01,0.1,0.8,1.53) ],
		],Pseq([1,1,1,1,4,2,1,-4,Prand([2,1,-2,-3],1)],1));
	}).loop,
	\itrig2, Pseq([
		0,0,0,0,
		1,1,1,1,
	],inf),
	\dur, 1/8,
));
)

