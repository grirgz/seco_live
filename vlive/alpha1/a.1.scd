
(
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var freq2;
	var pan;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	freq = 100*2 * [1,1/2,1/4];
	freq = Duty.kr(4/~t, 0, Dseq([
		1,0,-1,-2,
	],inf)).midiratio * freq;
	freq = LFSaw.kr(1/2/~t).range(100,50);
	freq = 120 * Duty.kr(1/8/~t, 0, Dseq([
		0,0,0,0,
		Drand([12,-12,1],1),0,0,0,
		Drand([12,-12,1,6],1)*2,0,0,0,
		1,0,0,6,
		0,0,0,0,
		-5,1,1,1,
		0,0,0,-12,
		1,0,12,6,
	],inf)).midiratio.lag(
		Duty.kr(1/4/~t, 0, Dseq([
			1,0,15,0,
			0,0,
			2,2,2,0,
			0,0,
			0,10,0,0,
		],inf))/20

	);
	freq2 = (-20!8).rand;
	sig = SinOsc.ar(freq + ( freq2 / 8));
	sig = sig * ( 1 + ( FreqShift.ar(sig, freq2 * SinOsc.kr(4*~t).range(0,1)) * SinOsc.kr( Duty.kr(1/~t, 0, Dseq([
		4,8,2,16,
		1/8,1/8,1/8,1/8,
	],inf))*~t).range(0,1) ) );
	freq = freq ! 2;
	sig = LFSaw.ar(freq) * Duty.kr(1/4/~t, 0, Dseq([
		1,1,4,4,
		4,1,1,1,
	],inf))/4;
	sig = LFPulse.ar(freq) * Duty.kr(1/4/~t, 0, Dseq([
		1,0,1,1,
		4,0,4,4,
		0,0,0,0,
	],inf))/2 + sig;
	//sig = SelectX.ar( LFPulse.kr(1/4*~t).range(0,1), [sig, sig1]);
	sig = sig / 2;
	
	amp = amp * \gain.kr(1);
	sig = sig * EnvGen.kr(\iadsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), Trig.kr(\itrig.tr(1),\isustain.kr(1)), doneAction:0);

	sig = sig * 6;

	pan = 0;
	pan = Duty.kr(1/~t, 0, Dseq([
		Drand([
			Dseq([
				1,0,-1,0,
			],1) * Drand([1,0.3,0.5],inf),
			Dseq([
				1,0.3,
			],1),
			Dseq([
				1,0.9,
			],1),
			Dseq([
				0.1,0.2,
			],1),
			Dseq([
				-1,-0.3,
			],1),
		],1),
	],inf)).lag( Duty.kr(3/2/~t, 0, Dseq([
		0.1,0,0.4,0,
	],inf)));
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
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
		1,1,1,1,
	],inf),
	\dur, 1/8,
));
)

