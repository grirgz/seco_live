
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var env1;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	freq = 70;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		[0,3,7,11,19]
	],inf)).midiratio *.t [1,2,4];
	freq = freq.flat;
	sig1 = SinOsc.ar(100 * ((0..7)/7 - 0.5 * SinOsc.kr(1/22).range(0,0.001) + 1)) * SinOsc.kr(1/15 * (1..freq.size)/10).range(0,10);
	sig = SinOsc.ar(freq * LFSaw.kr(1/1 * (1..freq.size).normalizeSum + 0.01).lag(0.1).range(1,1.12), sig1);
	sig1 = sig * sig.round(0.7 * SinOsc.kr(1/19).range(0,1));
	sig = SelectX.ar(LFSaw.kr(1/1 * (1..freq.size).normalizeSum + 0.02).lag(0.1).range(0,1) , [sig, sig1]);
	sig = LPF.ar(sig, 200 * SinOsc.kr(1/18 * [1,2,3]).range(1,4));
	sig = FreqShift.ar(sig, 200 * [0,3,7,0+12].midiratio);
	sig = BRF.ar(sig, 200 * SinOsc.kr(1/7 * [1,2,3]).range(0.8,1.2));
	sig.debug("sig");
	sig = sig;
	sig = sig / 4;

	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;
	sig;
})
