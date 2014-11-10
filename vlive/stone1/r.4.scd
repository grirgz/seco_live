
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
	fund = Duty.kr(4/~t, 0, Dseq([
		41,40,42,40,
	],inf)).lag(4.1/~t);
	timeScale = EnvGen.kr(Env([1,9,1],[10.1,10.8,10.3]).circle, 1);
	timeScale = EnvGen.kr(Env([1,9,1,0.3],[1.1,1.8,14]).circle, 1);
	fund = EnvGen.ar(Env([50,42,41]+40,[0.01]).circle, 1, timeScale: timeScale);
	fund = fund * EnvGen.kr(Env([1,2,1],[4.1,4.8,4.3]).circle, 1);
	fund = fund * Duty.kr(1/2/~t, 0, Dseq([
		1,2,1/2,1,
		1,2,1,1/2,
		4,8,4,2,
		2,2,2,4,
	],inf));
	f1 = Duty.kr(4/~t, 0, Dseq([
		100,440,
	],inf)).lag(0.4/~t);
	f2 = Duty.kr(1/2/~t, 0, Dseq([
		700,140, 200,110,
		200,200, 200,310,
		700,140, 200,110,
		200,200, 200,310,

		200,200, 200,310,
		200,200, 200,310,
		200,200, 200,310,
		200,200, 200,310,
	],inf)).lag(0.1/~t)* Duty.kr(1/4/~t, 0, Dseq([
		1,2,1/2,1
	],inf));
	source = LFPulse.ar(fund * [1,1.001,1.0002]);
	source = source + LFSaw.ar(fund);
	source = source + SinOsc.ar(fund);
	freq = fund;
	fspread = SinOsc.kr(1/9).range(0,1);
	freq = freq * ((0..7)/7 - 0.5 * fspread + 1);
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	oscmix = SinOsc.kr(1/7).range(0,1);
	sig = SelectX.ar(oscmix*2, [sig1, sig2, sig3]);
	vowel = 
		Normalizer.ar(BPF.ar(sig, f1, \rq1.kr(0.1)))
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
