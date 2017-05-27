
BufDef.mono(\moeten, "voices/02_moeten.flac")
BufDef.loadDialog(\loop1)
(
Ndef(\grain).set(\bufnum, BufDef.mono(\moeten));
Ndef(\grain, { arg freq=200, pan=0, amp=0.1, bufnum, pitch_stretch=1, pos=0, density=1, gfreq=10;
	var sig;
	var clk;
	clk = Impulse.ar(gfreq);
	sig = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), 1/gfreq*density , pan, 1);
	sig = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), 0.3, pan, 1);
	sig;

}).play;
);
Ndef(\grain).clear
Ndef(\grain).edit
BufDef(\loop1).play
BufDef(\loop1).bufnum
BufDef(\loop1).numChannels

(
Ndef(\grain, { arg freq=200, pan=0, amp=0.1, bufnum, pitch_stretch=1, pos=0, density=1, gfreq=10;
	var sig;
	var clk;
	clk = Impulse.ar(gfreq);
	sig = TGrains.ar(2, clk, bufnum, pitch_stretch, pos * LFNoise2.ar(15,mul:0.003,add:1)  % BufDur.kr(bufnum), 1/gfreq*density * LFNoise1.ar(41,mul:0.03,add:1) , pan, 1);
	sig;

}).play;
);


(
Ndef(\grain, { arg freq=200, pan=0, amp=0.1, bufnum, pitch_stretch=1, pos=0, density=1, gfreq=10;
	var sig;
	var clk;
	clk = Impulse.ar(gfreq * LFNoise1.kr(7).range(1.01,1.0));
	sig = TGrains.ar(2, clk, bufnum, pitch_stretch * [1,1/2,2], pos *.x [1,1.01,1.02] * LFNoise2.ar(15,mul:0.003,add:1)  % BufDur.kr(bufnum), 1/gfreq*density * LFNoise1.ar(41,mul:0.03,add:1) , pan, 1);
	sig = sig *3;
	sig.mean.postln;
}).play;
);

[1,1/2,2] *.x [1,1.01,1.02]
