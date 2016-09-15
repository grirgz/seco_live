
(
BufDef(\radient, "~/Musique/sc/bounce/radient_t4_e1.flac".standardizePath);
//BufDef(\radient).play;
Ndef(\comp, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in;
	var bufnum = BufDef(\radient);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * 1, 1, startPos: (0*BufFrames.kr(bufnum)), doneAction:0, loop: 0);
	sig.debug("sig");
	sig = sig * \preamp.kr(1);
	//sig = SoundIn.ar([0,1]);
	in = sig;
	sig = Compander.ar(sig, in, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.9), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * \postamp.kr(1);
}).play;
);
Ndef(\comp).edit
