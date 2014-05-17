(
Ndef(~name+++\fx, { arg freq=500, pan=0, amp=0.1, spread=0.8;
	var sig;
	sig = LFSaw.ar(freq * SinOsc.kr([1,2,4]) + freq);
	sig = RLPF.ar(sig,  SinOsc.kr([1,2,4]*10.3) + 1 * freq * 1.4);
	sig = Impulse.ar(CuspN.ar(1) + 1 * 50);
	freq = LFNoise0.ar(1).range(0.2,9);
	sig = Impulse.ar([10,40,20]*freq);
	sig = Ringz.ar(sig,  CuspN.ar(40) * 0.1 + 1 * 100, SinOsc.kr(1).range(0.3,1)/1);
	sig = Ringz.ar(sig,  CuspN.ar(4) * 0.1 + 1 * 100, SinOsc.kr(1).range(0.3,1)/1);
	//sig = sig.clip2(0.8);
	sig = DelayC.ar(sig, 0.1,0.1*Array.series(8,0.1,SinOsc.kr(1).range(0.01,0.2)));
	sig = sig.distort;
	sig = sig * 0.9;
	sig = Splay.ar(sig, spread, amp, pan);
});
Ndef(~name+++\fx).fadeTime = 0.1;
);
