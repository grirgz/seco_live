
(
	Ndef(~name+++\fx).put(0, { arg in, pan=0, amp=0.2;
		var sig1, sig2;
		var freq;
		var tfreq;
		var oscmix;
		freq = 40 * 16;
		freq = Duty.ar(4/~t,0,Dseq([
			[52,52*2/7],
			[52,52*3/7],
		],inf));
		sig1 = LFPulse.ar(freq * 8 * [2,1,1.010,2].clump(2)).mean;
		sig2 = LFSaw.ar(freq * 4 * [2,1,1.010,2].clump(2)).mean;
		oscmix = Duty.kr(1/4/~t, 0, Dseq([
			1,0,0,0,
			1,0,1,0,
		],inf));
		in = SelectX.ar(oscmix, [sig1, sig2]);
		sig1 = BPF.ar(in, freq * (1..8)/6 * 2,1 * LFNoise1.kr(1.1).range(0.1,1));
		sig2 = RLPF.ar(in, freq * (1..8) * 4,1 * LFNoise1.kr(0.7).range(0.1,1));
		in = SelectX.ar(LFNoise1.kr(1.2).unipolar, [sig1, sig2]);
		in = in.fold2(0.9 * SinOsc.kr(1/(1..8)/~t).unipolar);
		in.postln;
		in = Pan2.ar(in, pan + LFNoise1.kr(1)/3, amp);
		in = in.mean;
		in = in * 2.8;
		in.debug("hihi");


	});
);

// END

Ndef(~name+++\fx).put(1, nil)

(
	Ndef(~name+++\fx).put(1, \set -> Pbind(
		\freq, Pseq([100,200,300],inf),
		\freq, 180,
		\freqtab, Pseq([
			(2**([ 0, 4, 7 ]/12)) *.t [1,1.00001],
			(2**([ -1, 3, 7 ]+6/12)) *.t [1,1.00001],
		],inf),
		\amp, 0.5,
		\dur, 2,

	)

)
);


2**((0..12)/12)
2**(4/12)
1, 4/3
