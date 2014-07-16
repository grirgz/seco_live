
(
	Ndef(~name+++\fx, { arg in, pan=0, amp=1;
		in = LFSaw.ar(80 * [1,1.00001].mirror2.clump(2)).mean;
		in = in.fold2(0.9 * SinOsc.kr(1).unipolar);
		in.postln;
		in = in * 0.8;
		Pan2.ar(in, pan, amp);


	});
)


// END

Ndef(~name+++\fx)
