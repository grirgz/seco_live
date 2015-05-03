
(
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var freq2;
	var pan;
	var fspread = 0.00001;
	pan = 0;

	freq = 70 * 6 * Duty.kr(1/~t, 0, Dseq([
		[0,3,7],
		[-12,3+12,7],

	],inf)).midiratio;
	sig = LFPulse.ar(freq);
	sig = sig + LFSaw.ar(freq);
	sig = sig + SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq) * LFPulse.kr(1/4*~t * [1,1/2]).range(0,2) )));
	
	sig = sig * EnvGen.kr(\iadsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), Trig.kr(\itrig.tr(1),\isustain.kr(1)), doneAction:0);

	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size * pan, amp).mean;
	sig;
});

Ndef(~name+++\fx).put(1, \set -> Pbind(
	\itrig, Pseq([
		0,0,0,0,
		0,0,0,0,
		0,0,0,0,
		0,0,1,0,
	],inf),
	\iadsr, Plazy({ arg ev;
		Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.03) ],
			[ Env.adsr(0.01,0.1,0.8,0.43) ],
		],1).stutter(Prand([1,2,3,4,10],inf));
	}).loop,
	\dur, 1/8,
	\isustain, 1.00 * Pkey(\dur) / ~t,
));
)

