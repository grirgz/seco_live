
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var ffreq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var igate, dur, sustain, legato;
	var freqlim, clipmix;
	freq = Duty.kr(2/~t, 0, Dseq([
		1,0,4,3,
	],inf)).midiratio;
	freq = 50 * freq;

	sig = SinOsc.ar(freq);
	
	freqlim = 100;
	clipmix = Duty.kr(1/~t * Dseq([1,2,1,1,1/2,1/2],inf), 0, Dseq([
		1,1,0.91,1,
	],inf))/4;
	sig1 = LPF.ar(sig, freqlim);
	sig2 = HPF.ar(sig, freqlim);
	sig3 = SelectX.ar(clipmix, [sig1, sig2]);
	sig4 = SelectX.ar(1-clipmix, [sig1, sig2]);

	sig3 = (sig3 * 10 * (1..8) * Duty.kr(1/4/~t, 0, Dseq([
		1,
	],inf)).lag(0.2)).tanh;
	sig = sig3 + sig4;
	sig1 = LPF.ar(sig, 100);
	sig2 = LPF.ar(sig, 5000) * 1/4 * SinOsc.kr(1/12).range(1/4,2);
	sig3 = HPF.ar(sig, 500) * 1/4 * SinOsc.kr(1/7).range(1/4,2);
	sig = [sig1 , sig2 , sig3].sum;
	sig = LPF.ar(sig, 100);

	
	
	dur = 1/4;
	legato = 0.5;
	sustain = legato * dur;
	
	igate = TDuty.kr(dur/~t, 0, Dseq([
		1,0,0,1, 0,0,1,0,
		Drand([
			Dseq([
				1,1,0,0, 0,0,1,0,
			],1),
			Dseq([
				1,0,0,0, 1,0,0,0,
			],1),
			Dseq([
				1,0,0,1, 0,0,1,0,
			],1),
		],1),
	],inf))*sustain/~t;
	
	sig = sig * EnvGen.ar(Env.adsr(0.05,0.1,1,0.7),Trig.kr(igate,igate),doneAction:0);
	sig = sig * 4;

	//sig = RLPF.ar(sig, 400 * Duty.kr(1/~t, 0, Dseq([
	//	1,4,2,1/2,
	//],inf)), 0.1);
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size * 0.3, amp).mean;
	sig;
})
