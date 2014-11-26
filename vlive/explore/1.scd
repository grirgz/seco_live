

Ndef(\a).fadeTime_(15).play;fork{loop{Ndef(\a,{Klank.ar(`[9.collect{[5000.0.rand,5000.0.rand]},nil,1!4],PinkNoise.ar(7e-3))/3});9.wait}}


(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var fspread;
	var fac;
	fspread = SinOsc.ar(1/7).range(0,1);
	freq = freq * ((0..7)/7 - 0.5 *.t fspread + 1);
	sig = SinOsc.ar(freq);
	fac = SinOsc.kr(1/5).range(1,5);
	sig =  (sig*fac-sig.sqrt).pow(2).fold2(sig*2);
	sig = sig / 3;
	//sig = sig.flop.mean;
	sig.postln;
	sig = Pan2.ar(sig, pan + {LFNoise1.kr(1/2).range(-1.0,1.0)}!sig.size, amp).flop;
}).play;
);

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var fspread;
	var fac;
	var fac2;
	fspread = SinOsc.ar(1/7).range(0,1);
	//freq = freq * ((0..7)/7 - 0.5 *.t fspread + 1);
	freq = Duty.kr(1/8, 0, Dseq([
		100,120,200,1550,
	],inf));
	freq = freq * [1,1];
	sig = SinOsc.ar(freq);
	//fac = SinOsc.kr(1/5 * [1,1.1,1.01,2.001]).range(1,5);
	//fac = SinOsc.kr(1/5 ).range(1,[1,3,5,7,10]);
	fac = SinOsc.kr(1/5 ).range(1,5);
	fac = Duty.kr(1/4, 0, Dseq([
		1,4,2,3,
	],inf)).lag(0.1);
	//sig =  (sig*fac-sig.sqrt).pow(2).fold2(sig*2);
	//sig =  (sig*fac-sig.sqrt).pow(sig);
	//sig = (sig*fac).pow(sig);
	//sig = sig.fold2(0.5);
	//sig = (sig*fac).clip2(1) % (sig/fac).clip2(0.1);
	fac2 = 3;
	fac2 = Duty.kr(1, 0, Dseq([
		4,8,3,2,3,
	],inf)).lag(1.1);
	sig = (sig*fac%LFSaw.ar(freq/fac2*fac))/(1+sin(sig)).pow(fac2);
	sig = Limiter.ar(sig);
	//sig = sig.flop.mean;
	sig.postln;
	//sig = Pan2.ar(sig, pan + {LFNoise1.kr(1/2).range(-1.0,1.0)}!sig.size, amp).flop;
	sig/3;
}).play;
);

Ndef(\plop).stop
