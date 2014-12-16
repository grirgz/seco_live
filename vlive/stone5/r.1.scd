
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var range;
	var bufnum;
	var pos;
	range = 10 * [10,10,10];
	freq = 150 * Array.series(8,1,0.01);
	//bufnum = BufDef(\moeten);
	bufnum = BufDef(\ukraine, "bruit1/07_ukraine.flac");
	pos = 0.7 + SinOsc.kr(1/48).range(0,0.01) * (1+( [1,1.2,1.74] * 0.00001 ));

	sig  = BufRd.ar(2, bufnum, SinOsc.ar(freq).unipolar * range  + ( BufFrames.kr(bufnum)*pos ));
	sig = sig.flat.postln;
	
	sig = sig * 4;
	amp = amp * \gain.kr(1);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/9).range(-1.0,1.0)} ! sig.size, amp).flop;
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});

