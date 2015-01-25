
// TAGS: ndef, wobble, bass, vowel
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
	freq = Duty.kr(1/~t, 0, Dseq([
		70,70,70,90,
		70,70,70,85,
	],inf));
	f1 = SinOsc.kr( Duty.kr(1/~t, 0, Dseq([
		4,2,6,8,16,
	],inf))/2*~t).range(80,4200);
	f2 = SinOsc.kr( Duty.kr(2/~t, 0, Dseq([
		4,1,1,2,8,
	],inf))/2*~t).range(80,400);
	fspread = SinOsc.kr(1/9*[1,1.12]).range(0,0.0001).sum;
	fspread = Duty.kr(1/4/~t, 0, Dseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 1,0,0,0,
	],inf))/1000+0.00001;
	freq = freq * ((0..7)/7 - 0.5 * fspread + 1);
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	oscmix = SinOsc.kr(1/7).range(0,1);
	sig = SelectX.ar(oscmix*2, [sig1, sig2, sig3]);
	vowel = 
		Normalizer.ar(BPF.ar(sig, f1, [1,0.5,0.3]))
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
