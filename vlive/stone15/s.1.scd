
// xTAGS: ndef, chord, calm
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
	var trig1;
	trig1 = Impulse.kr(1/8*~t);
	fspread = 0;
	f1 = EnvGen.kr(Env([10,1200,10],[1.1,4.8]), trig1);
	f2 = EnvGen.kr(Env([100,4200,10],[1.1,4.8]), trig1);
	f1 = 100 * 4 * EnvGen.kr(Env([1,1.2,1],[0.1,0.8]), trig1);
	f2 = 100 * 3.midiratio * EnvGen.kr(Env([1,4,1],[2.1,0.8]), trig1);
	
	freq = 60 * 4 * [-12,0,12].midiratio  * 2 * Duty.kr(4/~t, 0, Dseq([
		0,-0.24,
	].midiratio,inf));
	//freq = freq * ((0..7)/7 - 0.5 * fspread + 1);
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = LFCub.ar(freq);
	oscmix = EnvGen.kr(Env([0,1,0],[0.1,1.8]), Impulse.kr(1/2*~t));
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
	sig2 = TDuty.kr(1/16/~t, 0, Dseq([
		//1,0,0,1, 0,0,1,0,
		Dseq([
			1,0,1,0,
		],7),
		Dseq([
			0,0,0,0,
		],1),
		Dser([
			1,0,0,1,
			0,0,1,0,
			0,1,0,0,
			1,0,1,0,
			1,0,1,0,
			1,0,1,0,
			1,0,1,0,
		],7*4),
		Dseq([
			0,0,0,0,
		],1),
		Dser([
			1,1,0,0,
			1,0,1,0,
			1,1,0,1,
			1,0,1,1,
			1,0,1,0,
			1,0,1,0,
			1,0,1,0,
		],7*4),
		Dseq([
			0,0,0,0,
		],1),
	],inf));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,1,0.04 * SinOsc.kr(1/18).exprange(1,10)),Trig.kr(sig2,0.04),doneAction:0);
	sig;
})
