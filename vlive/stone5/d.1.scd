
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var range;
	var bufnum;
	var pos;
	var pitch_stretch;
	var gpan = 0;
	var dur = 0.1;
	var clk;
	range = 10 * [10,10,10] * 1 * ( { arg x; SinOsc.kr(1/2 + x/8).range(1,10) }!4 );
	//freq = 150 * Array.series(8,1,0.01);
	freq = 750 * [0,4,8,12+4].midiratio;
	//bufnum = BufDef(\moeten);
	bufnum = BufDef.mono(\ukraine, "bruit1/07_ukraine.flac");
	pos = 0.6 * (1+( [1,1.2,1.74] * 0.1 ));
	pos = pos + LFNoise2.kr(1/72).range(0.0,0.01) ;
	pos = pos + LFNoise2.kr(1/12).range(0.0,0.101) ;
	pos = pos + LFNoise2.kr(2).range(0.0,0.00001) ;
	clk = Impulse.ar(8*~t);
	//clk = clk + [DelayL.ar(clk, 1/3/~t,1/7/~t),0,DelayL.ar(clk, 1/3/~t,1/9/~t)];

	//pos = pos + TRand.ar(0,0.4, clk);
	pos = pos + Demand.ar(clk, 0, Dseq([
		0, 0.2, 0.36, 0.4,
		Drand([
			Dseq([
				0.1, 0.1, 0.4, 0.1,
			],1),
			Dseq([
				0.3,0.32,0.31,0.305,
			],1),
		],1),
	],inf)).poll;
	pitch_stretch = [1,2,1.5];
	sig = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, gpan, 1);
	sig = sig.flat.postln;

	//sig = RLPF.ar(sig, \lpf.kr(700) * LFNoise1.kr(1/4).range(1.1,1.5), \rq.kr(0.5));
	
	sig = sig * 8;
	amp = amp * \gain.kr(1);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/9).range(-1.0,1.0)} ! sig.size, amp).flop;
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});

