
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;

	var igate, dur, sustain, legato;
	var freq;

	freq = Ndef.ar(~roger+++\freq) * [1,2];




	sig = SinOsc.ar(freq);

	dur = 1/8;
	legato = 0.3;
	sustain = legato * dur;

	igate = TDuty.kr(dur/~t, 0, Dseq([
		1,1,1,1,
		Dseq([
			0.3,1.1,0.8,0.5
		],1),
	],inf))*sustain/~t;

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,1,0.1),Trig.kr(igate,igate),doneAction:0);
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
