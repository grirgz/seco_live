
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
	bufnum = BufDef.mono(\my, "field/siffle.wav");
	pos = 17  + [0,0.21,0.101] + LFNoise1.kr(8).range(0,0.03) + LFNoise1.kr(1/8).range(0,7.03);
	pitch_stretch = 1 * LFNoise1.kr(1/2 ).range(1.0,0.9);

	clk = Impulse.ar(10);
	dur = 1/1;
	pan = 0;
	sig = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);
	//sig = sig.collect( { arg isig, x;
	//	isig = LPF.ar(isig, 700 * (1+ x ));
	//});
	sig = sig + DelayL.ar(sig, 1/8,1/8*(1..8)+0.01/18);
	sig = HPF.ar(sig, 720 * [1,2]);
	//sig = LPF.ar(sig, 12420);
	[1000,2300,5021,13000,17000].do { arg x, y;
		sig = BRF.ar(sig, x * SinOsc.kr(1/(1+y+5)).range(1.1,1));
	};
	sig = sig * 12;
	sig = sig * 8;
	
	amp = amp * \gain.kr(1);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
	sig;
})
)

// END

Ndef(~name+++\fx).clear
	BufDef.mono(\robinet, "field/robinet.wav");

s.quit
Server.supernova
s.boot
