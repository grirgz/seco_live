
(
BufDef.mono(\moeten, "voices/02_moeten.flac");
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var bufnum, pos, loop, trigger;
	var speed;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var pitch_stretch, dur, pan, clk;

	bufnum = BufDef.mono(\moeten);
	pos = 0.3  + [0,0.01,0.001] + LFNoise1.ar(1 * (1..3)).range(0,0.3);
	pitch_stretch = 1/4 * LFNoise1.kr(1/2 * (1..8)).range(1.0,0.9);

	clk = Impulse.ar(10);
	dur = 1/1;
	pan = 0;
	sig = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);
	sig = sig.collect( { arg isig, x;
		isig = LPF.ar(isig, 100 * (1+ x ));
	});
	sig = sig * 12;
	sig = sig * 1;
	
	amp = amp * \gain.kr(1);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
	sig;
})
)
