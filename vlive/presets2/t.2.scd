
(
	Ndef(~name+++\fx).set(\bufnum, BufDef(\ukraine));
	Ndef(~name+++\fx, { arg in, pan=0, bufnum=0, amp=1;
		var s1;
		var pos;
		bufnum.debug("kjk");
		//in = BufRd.ar(2, bufnum, SinOsc.ar(100).unipolar * 0.1 + 0.1 * BufFrames.kr(bufnum));
		pos = 0.1  + LFNoise0.kr(20).unipolar(0.014) * BufFrames.kr(bufnum);
		in = PlayBuf.ar(2, bufnum, 1/8 * [1,2,4,3], Impulse.ar(78 * [1,1/2,1/4]), pos);
		in = Pan2.ar(in, pan + LFNoise1.kr(10)/2, amp).mean.sum;
		in = in * 4.8;
		in.debug("hihi");


	});
)


