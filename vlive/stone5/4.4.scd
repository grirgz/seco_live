
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	freq = 400;
	
	sig = LFSaw.ar(freq * (1 + 
		SinOsc.ar(
			freq * Duty.kr(2/~t, 0, Dseq([
				[0,5,7,12],
				[0,4,7,12],
				[0,4,7,9],
			],inf)).midiratio
			* (1+
				(
					SinOsc.ar(freq*
						Duty.kr(1/8/~t, 0, Dseq([
							0,4,0,7,
							0,3,4,2,
						],inf)).midiratio
					)
					* Duty.kr(1/4/~t, 0, Dseq([
						1,2,40,4,
					],inf))
				)
			 )
		)

	));
	sig = RLPF.ar(sig, \lpf.kr(4100) * LFNoise1.kr([2,1/2,3,1/4]).range(2.0,0.2), \rq.kr(0.5));
	sig = (sig*10 * LFNoise1.kr(1/2).range(0.0,1.0)).tanh;
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});

