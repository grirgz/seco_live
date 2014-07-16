
(
	Ndef(~name+++\fx, { arg in, pan=0, amp=1;
		in = SinOsc.ar(80 * [1,1.00001].mirror2.clump(2)).mean;
		in = in.fold2(0.9 * SinOsc.kr(1/(1..8)/~t).unipolar);
		in.postln;
		in = Pan2.ar(in, pan + LFNoise1.kr(1), amp);
		in = in.mean;
		in = in * 1.8;
		in.debug("hihi");


	});
)


