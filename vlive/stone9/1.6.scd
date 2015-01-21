
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var env1;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	freq = [100, 200,300, 400,500,600,700,800,900,1000];
	freq = LinSelectX.kr(
		LFPulse.kr(1/7).range(0,1.00).lag(0.4),
		[
			[100,100.001,200.001,800],
			[100,100.002,201.001,800.001],
			//freq,
		]

	);
	freq = freq *.t Duty.kr(1/4/~t, 0, Dseq([
		Dseq([
			0,0,0,
			[1,7,3,7],
		],4),
		Dseq([
			0,0,0,
			[1,9,3,5],
		],4),
		Dseq([
			0,[0,2,0,8],0,
			[1,9,3,5],
			0,[0,3,0,7],0,
			[1,9,3,5],
		],4),
	],inf)).midiratio;
	//freq = freq *.t [0,3,7].midiratio;
	freq = freq.flat;
	
	env1 = 0.1;
	env1 = EnvGen.kr(Env([0,0.1,0.4,0.01,0.1],[4.1,4.8,4,4]), 1);
	env1 = EnvGen.kr(Env([0,0.1,1.4,0.01,0.1,10,0.01],[4.1,4.8,4,4,4,10]), 1);
	sig = SinOsc.ar(freq);
	sig1 = sig * SinOsc.kr((1..8)/8).range(0,1);
	sig = DelayL.ar(sig, 0.4, (1..8)/8*0.01 * SinOsc.kr((1..8)/8).range(0,env1))+sig;
	sig = DelayL.ar(sig, 0.6, (1..8)/8*0.021 * SinOsc.kr((1..8)/8).range(0,env1))+sig;
	sig1 = (sig*10).tanh;
	sig1 = LPF.ar(sig1,7000);
	sig2 = Limiter.ar(sig);
	sig3 = sig * (sig < 0.71 * SinOsc.kr(1/44).range(0,1));
	sig = SelectX.ar( 
		SelectX.kr(
			SinOsc.kr(1/39).range(0,1),
			[
				SinOsc.kr(1/29).range(0,2),
				SinOsc.kr(1/19 * (1..4)/4).range(0,2),
			]
		)
		, [sig1, sig2,sig3]
	);
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;
	sig;
})
