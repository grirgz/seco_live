
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
	f1 = SinOsc.kr(5/3/8*~t).range(1940,4100);
	f2 = SinOsc.kr(4/3/8*~t).range(740* SinOsc.kr(1/13).range(1/2,3),100);

	freq = fund;
	freq = 100*[1,2,4];
	fspread = SinOsc.kr(1/1*[1,2/3]*~t).range(0,0.0001).sum;
	freq = freq * ((0..7)/7 - 0.5 * fspread + 1);
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = LFCub.ar(freq);
	oscmix = SinOsc.kr(1/8*~t).range(0,1);
	sig = SelectX.ar(oscmix*2, [sig1, sig2, sig3]);
	sig = SelectX.ar( Duty.kr(1/2/~t, 0, Dseq([
		1,2,0,0,
		1,1.2,1.5,2,
		1,2,0,0,
		0,0,0,0.3,
	],inf)).lag(1/2/~t), sig);
	vowel = 
		Normalizer.ar(BPF.ar(sig, f1, \rq1.kr(0.1)))
		+
		Normalizer.ar(BPF.ar(sig, f2, \rq2.kr(0.1)))
		;
	amp = amp * \gain.kr(1);
	sig = sig / 2;
	sig = vowel;
	sig.postln;
	pan = SinOsc.kr(1/45).range(-1,1) * 0.1;
	spread = SinOsc.kr(1/25).range(0,1);
	sig = Splay.ar(sig, spread, amp, pan);
	sig;
})
