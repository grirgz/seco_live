
(
	Ndef(~name+++\fx).set(\bufnum, BufDef(\moeten));
	Ndef(~name+++\fx, { arg in, pan=0, bufnum=0, amp=1;
		var s1;
		var pos;
		var rate;
		bufnum.debug("kjk");
		//in = BufRd.ar(2, bufnum, SinOsc.ar(0.5).unipolar * 0.1 + 0.1 * BufFrames.kr(bufnum));
		//pos = MouseX.kr(0,1) * BufFrames.kr(bufnum);
		pos = 0;
		rate = MouseX.kr(-1,1) * 3;
		//in = BufRd.ar(2, bufnum, K2A.ar(pos));
		//pos = 0.1  + LFNoise0.kr(20).unipolar(0.014) * BufFrames.kr(bufnum);
		in = PlayBuf.ar(2, bufnum, rate, 1, pos);
		in = Pan2.ar(in, pan + LFNoise1.kr(10)/2, amp).mean;
		in = in * 1.8;
		in.debug("hihi");


	});
)


