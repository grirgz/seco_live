
(
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var freq2;
	var pan;
	var fspread = 0.00001;
	pan = 0;

	freq = 40;
	freq = ((0..7)/7 - 0.5 * fspread + 1) * freq;
	sig = LFPulse.ar(freq);
	sig = sig + LFSaw.ar(freq * Duty.kr(1/8/~t, 0, Dseq([
		1,1,1,2,
		1,4,1,1,
		1,1,1/2,1,

		1,1,1,2,
		1,1,4,1,
		1,1,1,1/2,

		1,1,1/4,1,
		1,3,1,1,
		1,1,1.3,1,

		1,1,1,1.2,
		1,1,1.4,1,
		1,1,1,1/2,
	],inf)));

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

