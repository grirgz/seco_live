
(
	Ndef(~name+++\fx, { arg in, pan=0, amp=1;
		var s1;
		s1 = SinOsc.ar(700*1/(1..7)) * LFNoise1.kr((1..8)).unipolar;
		in = SinOsc.ar(80 * [1,1.00001].mirror2.clump(2), s1).mean;
		in = in.fold2(0.9 * SinOsc.kr(1/(1..8)/~t).unipolar);
		in.postln;
		in = Pan2.ar(in, pan + LFNoise1.kr(10)/2, amp);
		in = in.mean;
		in = in * 0.8;
		in.debug("hihi");


	});
)


