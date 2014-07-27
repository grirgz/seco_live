
(
	Ndef(~name+++\fx, { arg in, pan=0, amp=1;
		var sig1, sig2;
		in = LFPulse.ar(280 * [1,1.00001,1/2,2,1/3,3].mirror2.clump(2)).mean;
		sig1 = BPF.ar(in, 100 * (1..8) * 2,1 * LFNoise1.kr(1.1).range(0.1,1));
		sig2 = RLPF.ar(in, 100 * (1..8) * 2,1 * LFNoise1.kr(0.7).range(0.1,1));
		in = SelectX.ar(LFNoise1.kr(1.2).unipolar * 2, [sig1, sig2, in]);
		in = in.fold2(0.9 * SinOsc.kr(1/(1..8)/~t).unipolar);
		in.postln;
		in = Pan2.ar(in, pan + LFNoise1.kr(1)/3, amp);
		in = in.mean;
		in = in * 1.8;
		in.debug("hihi");


	});
)


