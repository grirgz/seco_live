
Ndef(~name+++\fx).put(0, { arg pan=0, f1=200, f2=300, fund = 70, amp = 0.25, doneAction=2 ;
	var sig;
	var source;
	var vowel;
	var timeScale;
	var oscmix;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq;
	var spread;
	var fspread;
	freq = fund;


	fspread = SinOsc.kr(1/49*[1,1.12,4]).exprange(0.0000001,0.001).sum;
	fspread = EnvGen.kr(Env([0.0000001,0.2,0.001],[0.8,0.1,0.03].normalizeSum*1/~t).circle, 1);
	freq = freq * ((0..7)/7 - 0.5 * fspread + 1);
	//freq = freq * 1;

	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	oscmix = SinOsc.kr(1/77).range(0,1);
	sig = SelectX.ar(oscmix*2, [sig1, sig2, sig3]);

	f1 = SinOsc.kr([1/5,4]).range(400,100).sum;
	f2 = SinOsc.kr([1/5.01,4.01]).range(400,100).sum;
	f1 = Duty.kr(1/~t, 0, Dseq([
		1000,2000,
		500 * Dseq([
			0,4,7,0
		].midiratio,1),
		400 * Dseq([
			1,2,4,2,
		],1),
	],inf)).lag(0.1);
	f2 = 400 * Duty.kr(1/2/~t, 0, Dseq([
		Dseq([
			0,4,7,0
		].midiratio,1),
		Dseq([
			1,2,4,2,
		],1),
	],inf));

	vowel = 
		Normalizer.ar(BPF.ar(sig, f1, \rq1.kr(0.1) * SinOsc.kr(1/12).range(0.1,4)))
		+
		Normalizer.ar(BPF.ar(sig, f2, \rq2.kr(0.1)))
		;
	amp = amp * \gain.kr(1);
	sig = vowel;
	sig.postln;
	pan = SinOsc.kr(1/45).range(-1,1) * 0.1;
	spread = SinOsc.kr(1/25).range(0,1);
	sig = Splay.ar(sig, spread, amp, pan);
	sig;
})
