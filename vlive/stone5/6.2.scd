
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	freq = 400;
	
	sig = SinOsc.ar(freq * (1 + 
		SinOsc.ar(
			freq * 
			(1+
				(
					[
						LFNoise1.kr(1/42),
						LFNoise1.kr(1/42),
						LFNoise1.kr(1/42),
						LFNoise1.kr(1/42),
					] * 0.01
				)
			)
			* (1+
				(
					[

						SinOsc.ar(210 * SinOsc.kr(1/14).range(0,1)) * SinOsc.kr(1/19).range(0,10),
						SinOsc.ar(71 * SinOsc.kr(1*~t).range(2,1)) * SinOsc.kr(1/19).range(0,10),
						SinOsc.ar(191 * SinOsc.kr(1/6*~t).range(4,1)) * SinOsc.kr(1/19).range(0,10),
						SinOsc.ar(710 * SinOsc.kr(1/14).range(0,1)) * SinOsc.kr(1/19).range(0,10),
					]
				)
			 )
		)

	));
	sig = EnvGen.ar(Env.adsr(0.1,0.1,1,0.4),Trig.kr(
		{arg x; Impulse.kr(1*~t +x)}!4,0.5
	),doneAction:0) * sig;
	//sig = RLPF.ar(sig, \lpf.kr(4100) * LFNoise1.kr([2,1/2,3,1/4]).range(2.0,0.2), \rq.kr(0.5));
	//sig = (sig*0.10 * LFNoise1.kr(1/2).range(0.0,7.0)).tanh;
	sig = sig / 1;
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});

