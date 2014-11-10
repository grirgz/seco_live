
Ndef(~name+++\fx).put(0, { arg pan=0, f1=200, f2=300, fund = 70, amp = 0.25, doneAction=2 ;
	var sig;
	var source;
	var vowel;
	fund = Duty.kr(4/~t, 0, Dseq([
		41,40,42,40,
	],inf)).lag(4.1/~t);
	//f1 = Duty.kr(4/~t, 0, Dseq([
	//	100,440,
	//],inf)).lag(4.1/~t);
	//f2 = Duty.kr(1/2/~t, 0, Dseq([
	//	700,140, 200,110,
	//],inf)).lag(4.1/~t);
	fund = EnvGen.kr(Env([50,42,41],[1.1,4.8,7.3]).circle, 1);
	f2 = EnvGen.kr(Env([100,200,121],[7.1,1.8,0.3]).circle, 1);
	f1 = EnvGen.kr(Env([700,250,321],[2.4,7.2,1.3]).circle, 1);
	source = LFPulse.ar(fund * [1,1.001,1.0002]);
	source = source + LFSaw.ar(fund);
	source = source + SinOsc.ar(fund);
	vowel = 
		Normalizer.ar(BPF.ar(source, f1, \rq1.kr(0.1)))
		+
		Normalizer.ar(BPF.ar(source, f2, \rq2.kr(0.1)))
		;
	amp = amp * \gain.kr(1);
	sig = vowel;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig;
})
