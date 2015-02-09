
(
// xTAGS: violon, ndef, granular, drone
BufDef.mono(\moeten, "voices/02_moeten.flac");
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var bufnum, pos, loop, trigger;
	var speed;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var pitch_stretch, dur, pan, clk;

	bufnum = BufDef.mono(\moeten);
	bufnum = BufDef.mono(\robinet, "field/robinet.wav");
	bufnum = BufDef.mono(\my, "field/drone_pr.wav");
	pos = Duty.kr(8/~t, 0, Dseq([
		1,10,5,20,
	],inf)).lag(4)  + [0,0.01,0.001] + LFNoise1.ar(1 * (1..3)/1).range(0,1.43);
	pitch_stretch = 1 * LFNoise1.kr(1/2 * (1..3)).range(1.0,0.9);

	clk = Impulse.ar(47);
	dur = 1/8;
	pan = 0;
	sig = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);
	sig1 = LPF.ar(sig, 1000);
	sig2 = HPF.ar(sig, 8000 * SinOsc.kr(1/7).range(1/4,1));
	sig3 = BPF.ar(sig, 4000 * SinOsc.kr(1/9).range(1/4,1));
	sig = [sig1, sig2, sig3].sum;
	//sig = RLPF.ar(sig, 100 * (1..3), 0.2);
	//sig = sig.collect( { arg isig, x;
	//	isig = LPF.ar(isig, 700 * (1+ x ));
	//});
	//sig = HPF.ar(sig, 120);
	sig = sig * 12;
	sig = sig * 4;
	
	amp = amp * \gain.kr(1);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
	sig;
})
)

// END

Ndef(~name+++\fx).clear
	BufDef.mono(\robinet, "field/robinet.wav");
