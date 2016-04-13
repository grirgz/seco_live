
BufDef.mono(\ukraine, "bruit1/07_ukraine.flac");
BufDef.mono(\metal, "vipere/metal.flac");
BufDef.mono(\bomb, "vipere/bomb.flac");
BufDef.mono(\moeten, "voices/02_moeten.flac")

(
Ndef(\grain, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var clk = Impulse.ar(10);
	var bufnum = BufDef.mono(\moeten);
	var pos = 0.0 + LFNoise1.ar(100).range(0.02,0.01) + Sweep.kr(1, 1/10) + [0,0.01,0.02];
	var dur = 0.01 * LFNoise1.ar(40 * SinOsc.kr(1/14).range(1/8,1)).exprange(5.1,0.01);
	var pitch_stretch = 1 * [12,4,7+12].midiratio;
	dur = 0.051;
	clk = Impulse.kr(Duty.kr(1, 0, Dseq([
		40,20,60,80
	],inf)).lag(1));
	sig = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);
