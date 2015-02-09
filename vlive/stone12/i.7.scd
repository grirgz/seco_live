
(
BufDef.mono(\moeten, "voices/02_moeten.flac");
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var bufnum, pos, loop, trigger;
	var speed;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var pitch_stretch, dur, pan, clk;

	bufnum = BufDef.mono(\moeten);
	bufnum = BufDef.mono(\robinet, "field/robinet.wav");
	bufnum = BufDef.mono(\my, "field/couvercle.wav");
	pos = 15  + [0,0.01,0.001];
	pitch_stretch = 1 * LFNoise1.kr(1/2 * (1..8)).range( SinOsc.kr(1/18).exprange(0.0001,18),0.1);

	clk = Impulse.ar(40);
	dur = 1;
	pan = 0;
	sig = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);
	//sig = sig.collect( { arg isig, x;
	//	isig = LPF.ar(isig, 700 * (1+ x ));
	//});
	sig = HPF.ar(sig, 120);
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
