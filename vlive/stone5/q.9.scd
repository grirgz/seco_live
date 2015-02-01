
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var igate;
	var env1, env2, env3;
	freq = 400;
	
	freq = 750 / 2 ;
	freq = freq * Duty.kr(2/~t, 0, Dseq([
		[0,5,9,14],
		[0,5,10,13],
		[0,4,10,14],
		[0,4,10,13],
	],inf)).midiratio;

	env1 = XLine.kr(1,100,16/~t);
	env2 = \morph.kr(0).linlin(0,1,-1,1);
	env1 = env2.range(1,100);
	sig = LFSaw.ar(freq * (1 + 
		(
			SinOsc.ar(
				freq * Duty.kr(1/2/~t, 0, Dseq([
					[1,2,4],
					[1,8,1/4],
				],inf)) * env2.range(1,\fend1.kr(10.001)).poll
				* (1+
					(
						SinOsc.ar(freq * env2.range(1,\fend2.kr(100))*
							Duty.kr(1/6/~t, 0, Dseq([
								0,4,0,7,
								0,3,4,2,
							],inf)).midiratio
						)
						* Duty.kr(1/8/~t, 0, Dseq([
							1,2,0,4,
							0,2,0,4,
							1,4,0,0,
						],inf))/8
						* env2.range(1, \fend3.kr(1))
					)
				 )
			) * env2.range(1,\fend4.kr(10))
		)

	));
	sig = RLPF.ar(sig, \lpf.kr(11100) * SinOsc.kr(
		Duty.kr(1/~t, 0, Dseq([
			1,1/4,0,0,
			2,1,0,0,
			1/8,1/8,0,0,
			1,0,0,0,
			8,0,0,0,
		],inf))
		* ~t).range(0.1,1) , \rq.kr(0.5));
	//sig = (sig*10 * LFNoise1.kr(1/2).range(0.0,1.0)).tanh;


	igate = TDuty.kr(1/4/~t, 0, Dseq([
		1,0,0,1,
		0,0,1,0,
		1,0,0,0,
		0,1,0,0,
	],inf))/8;
	sig = sig * EnvGen.kr(Env.adsr(0.01,0.7,1.5,\release.kr(7.4)), Trig.kr(igate > 0,igate), doneAction:0) * 2;
	sig = sig * Duty.kr(1/16/~t, 0, Dseq([
		1,1,1,1,
		1,1,1,1,
		1,1,1,1,
		1,1,1,1,
		1,1,1,0,
		1,0,1,1,
		1,1,1,0,
		0,0,1,1,

		1,1,1,1,
		1,1,1,1,
		1,1,1,1,
		1,1,1,1,
		1,1,1,1,
		1,1,1,1,
		1,1,1,0,
		1,0,1,1,
	],inf));

	sig = sig + CombL.ar(sig, 1/~t, (\delay.kr(1).round(1)/8)**2/~t,\cdecay.kr(4));

	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});

// END

~set_macro.(\k1, Ndef(~name+++\fx), \morph, \unipolar);
~set_macro.(\k2, Ndef(~name+++\fx), \fend1, \lofreq);
~set_macro.(\k3, Ndef(~name+++\fx), \fend2, \lofreq);
~set_macro.(\k4, Ndef(~name+++\fx), \fend3, \lofreq);
~set_macro.(\k5, Ndef(~name+++\fx), \fend4, \lofreq);
~set_macro.(\k6, Ndef(~name+++\fx), \release, \release);
~set_macro.(\k7, Ndef(~name+++\fx), \delay, \release);
~set_macro.(\k8, Ndef(~name+++\fx), \cdecay, \release);
