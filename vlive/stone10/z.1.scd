
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var env1;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var fspread;

	fspread = 0.0001 * Duty.kr(1/~t, 0, Dseq([
		1,2,0.1,100,
	],inf));
	freq = 200 * 4.midiratio * ((0..7)/7 - 0.5 * fspread + 1);
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		Dseq([
			[0,0,0,0]
		],8),
		Dseq([
			[1,2,3,4],
			[0,2,0,0],
			[0,3,7,11],
			[0,2,0,0],
		],inf),
	],inf)).midiratio;
	sig1 = SinOsc.ar(1000 * [1,1/2,1/3]) * SinOsc.ar(11 * (1..5)/45).range(0,110);
	sig = SinOsc.ar(freq, sig1);

	//sig = sig * Duty.kr(1/~t * Dseq([0.8,0.2],inf) * [1,1.01,1.001], 0, Dseq([
	//	1,0,0,0,0,0,0,
	//],inf));
	sig1 = SinOsc.kr(1/4 * (1..sig.size)).range(0,1);
	sig = sig * sig1 * (sig1.abs > 0.8).lag(0.1);
	sig = sig /4;

	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;
	sig;
})
