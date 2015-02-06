
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var igate, dur, sustain, legato;
	var modf;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var rel;
	freq = 60.midicps * 8;
	modf = Duty.kr(1/~t * (1..8)/8, 0, Dseq([
		1,2,1/4,1,
	],inf));
	sig = SinOsc.ar(freq*(1..8)/8 * modf);
	sig1 = sig;
	sig1 = sig1 + DelayL.ar(sig1, 1, 0.1 * (1..8)/8);
	sig1 = sig1 + DelayL.ar(sig1, 2, 0.1 * (1..8)/8*16);
	sig1 = DelayL.ar(sig1, 2, 0.00001 * (0..7)/7 * SinOsc.kr(1/7).range(1,1.04));
	sig = SelectX.ar( SinOsc.kr(1/8).range(0,1), [sig, sig1]);
	dur = 1/4;
	legato = 0.1;
	sustain = legato * dur;
	igate = TDuty.kr(dur/~t, 0, Dseq([
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,0,0,0,
	],inf))*sustain/~t;
	rel = Duty.kr(1/4/~t, 0, Dseq([
		Dser([
			0.4
		],8*8),
		Dser([
			1,0.1,0.1,0.6,
			0.1,0.2,0.2,0.6,
		],8*8),
		Dser([
			1,2.1,3.1,1.6,
			2,1.1,2.1,1.6,
		],8*8),
	],inf));
	sig = sig * EnvGen.ar(Env.adsr(0.001,0.1,1,rel),Trig.kr(igate,igate),doneAction:0);
	amp = amp * \gain.kr(1);
	sig = sig /4;
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;
	sig;
})
