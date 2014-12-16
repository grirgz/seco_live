
Ndef(~name+++\fx).put(0, { 
	arg pan=0, f1=200, f2=300, f3=200, fund = 70, amp = 0.25, doneAction=2 ;

	var sig;
	var source;
	var vowel;
	var timeScale;
	var oscmix;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq;
	var spread;
	var fspread;
	var trig1;
	timeScale=1.01;
	trig1 = Impulse.kr(1/8*~t);
	fspread = SinOsc.kr(1/8*~t) *0.1 * Duty.kr(1/~t, 0, Dseq([
		1,1,0,0,
		0,0,0,0,
		0,0,1,1,
		0,0,0,0,
		0,0,0,0,
	],inf));
	f1 = EnvGen.kr(Env([10,1200,10],[1.1,4.8]), trig1, timeScale:timeScale);
	f2 = EnvGen.kr(Env([100,4200,10],[1.1,4.8]), trig1, timeScale:timeScale);
	f1 = 400 * 7.midiratio * EnvGen.kr(Env([1,1.2,1],[0.1,0.8]), trig1, timeScale:timeScale);
	f2 = 400 * 3.midiratio * EnvGen.kr(Env([1,4,1],[2.1,0.8]), trig1, timeScale:timeScale);
	f3 = 100 * 0.midiratio * EnvGen.kr(Env([1,4,1,7, 2,0.3],[1.1,1.8,1,1, 1,1]/3), trig1, timeScale:timeScale);
	
	freq = 100 * Duty.kr(4/~t, 0, Dseq([
		[0,4,7],
	],inf)).midiratio  * 4 * Duty.kr(4/~t, 0, Dseq([
		0,0,0,
	].midiratio,inf));
	freq = freq * ((0..7)/7 - 0.5 * fspread + 1);
	freq = freq * ( 1 
		+ SelectX.ar( SinOsc.kr(1/4*~t).range(0,1), [SinOsc.ar(freq/2)*47, SinOsc.ar(freq/1.122)*47])
		
		+ LFSaw.ar(freq*2)*0.01 );
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = LFCub.ar(freq);
	oscmix = SinOsc.kr(1/7).range(0,1);
	sig = SelectX.ar(oscmix*2, [sig1, sig2, sig3]);
	vowel = 
		Normalizer.ar(BPF.ar(sig, f1, \rq1.kr(0.1)))
		+
		Normalizer.ar(BPF.ar(sig, f2, \rq2.kr(0.1)))
		+
		Normalizer.ar(BPF.ar(sig, f3, \rq3.kr(0.1)))
		;
	amp = amp * \gain.kr(1);
	sig = vowel;
	sig.postln;
	pan = SinOsc.kr(1/45).range(-1,1) * 0.1;
	spread = SinOsc.kr(1/25).range(0,1);
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig * Duty.kr(1/8/~t, 0, Dseq([
		1,1,1,1,
		1,1,1,1,
	],inf)).lag(0.5);
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,1,0.4),Trig.kr(Impulse.kr(1/2*~t),4),doneAction:0);
	sig;
})
