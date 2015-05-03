
(
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var freq2;
	var pan;
	var fspread = 0.00001;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	pan = 0;

	fspread = Duty.kr(1/8/~t, 0, Dseq([
		0,1,
	],inf))/100;
	fspread = Duty.kr(1/8/~t, 0, Dseq([
		0,0,0,0,
		0,0,0,0,
		0,0,0,0,
		0,0,0,0,

		0,0,0,0,
		0,0,0,0,
		0,0,0,0,
		0,0,0,1,
	],inf))/100;
	freq = 60 / 2;
	freq = ((0..7)/7 - 0.5 * fspread + 1) * freq;
	sig = LFPulse.ar(freq);
	sig = sig + LFSaw.ar(freq);
	sig = sig + SinOsc.ar(freq * ( 1 + ( SinOsc.kr(freq) * LFPulse.kr(1/4*~t).range(0,2) )));
	sig = FreqShift.ar(sig, freq * Duty.kr(3/2/~t, 0, Dseq([
		-1,0,1,0,
		1/2,0,-2/3,0,
	],inf))) + sig;
	sig = ( sig*10 * Duty.kr(1/3/~t, 0, Dseq([
		1,50,
	],inf)) ).tanh;
	sig1 = sig;
	sig1 = CombL.ar(sig, 1/10, 1/( 60 * ( 1 + ( SinOsc.kr(1/2 * (1..8)/8) * 10 )) ),0) + sig;
	sig1 = CombL.ar(sig, 1/10, 1/( 60 ),0) + sig;
	sig = SelectX.ar( SinOsc.kr(1/3).range(0,1), [sig, sig1]);
	sig = LPF.ar(sig, 4000);
	sig = sig / 2;

	//sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size * pan, amp).mean;
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size  * 0.1 + pan, amp).mean;
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

