
(
	Ndef(~name+++\fx).set(\bufnum, BufDef(\bomb));
	Ndef(~name+++\fx, { arg in, pan=0, bufnum=0, amp=1;
		var s1;
		var pos;
		bufnum.debug("kjk");
		//in = BufRd.ar(2, bufnum, SinOsc.ar(100).unipolar * 0.1 + 0.1 * BufFrames.kr(bufnum));
		pos = Latch.ar(SinOsc.kr(1).range(1,2)*0.3+[0.05,0.3,0.2] * BufFrames.kr(bufnum), Impulse.ar(10));
		in = PlayBuf.ar(2, bufnum, 1/8 * [1,2], Impulse.ar(44 * [1,1.001] * SinOsc.ar(1/[1,2,4]).range(0.51,4.1)), pos);
		in = Pan2.ar(in, pan + LFNoise1.kr(10)/2, amp).mean.sum;
		in = in * 0.4;
		in.debug("hihi");


	});
)


