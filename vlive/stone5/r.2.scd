
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var range;
	var bufnum;
	var pos;
	range = 10 * [10,10,10] * 1 * ( { arg x; SinOsc.kr(1/2 + x/8).range(1,10) }!4 );
	//freq = 150 * Array.series(8,1,0.01);
	freq = 150 * [0,4,8,12+4].midiratio;
	//bufnum = BufDef(\moeten);
	bufnum = BufDef(\ukraine, "bruit1/07_ukraine.flac");
	pos = 0.6 * (1+( [1,1.2,1.74] * 0.1 ));
	pos = pos + LFNoise2.kr(1/72).range(0.0,0.01) ;
	pos = pos + LFNoise2.kr(1/12).range(0.0,0.001) ;
	pos = pos + LFNoise2.kr(2).range(0.0,0.00001) ;

	sig  = BufRd.ar(2, bufnum, SinOsc.ar(freq).unipolar * range  + ( BufFrames.kr(bufnum)*pos ));
	sig = sig.flat.postln;

	sig = RLPF.ar(sig, \lpf.kr(7000) * LFNoise1.kr(1/4).range(0.1,1.5), \rq.kr(0.5));
	
	sig = sig * 8;
	amp = amp * \gain.kr(1);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/9).range(-1.0,1.0)} ! sig.size, amp).flop;
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});

