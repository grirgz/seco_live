
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 500;
	freq = freq * Duty.kr(1/4/~t, 0, Dseq([
		Dseq([
			1,0,1,2,
			3,0,1,2,
		].midiratio,1),
	],inf));
	freq = freq * ( 1 + ( LFSaw.ar(\fmfreq.kr(80) * LFPulse.kr([1/12,1/16]*~t).range(1,1.5)).wrap2( SinOsc.kr(2).range(0.5,1) ) * 1 )) ;
	sig = LFSaw.ar(freq * SinOsc.kr(1/16*~t).range(1.02,1)) ;
	sig = sig.fold2( SinOsc.kr([1/2,4]).range(0.5,1) );
	sig = sig * SelectX.kr(
		Duty.kr(8/~t, 0, Dseq([
			Drand([0,1,2,3,4,5])
		],inf)).lag(7/~t),
		[
			LFPulse.kr([4,1/4]*~t,[0,0.7],[0.7,0.9]),
			LFPulse.kr([4,1/4]*~t,0,[0.7,0.9]),
			LFPulse.kr(4*~t,0,[0.7,0.9]),
			LFPulse.kr(4*~t,0,0.7),
			LFPulse.kr([1,2]*~t,0,0.7),
		]
	);
	sig = RLPF.ar(sig, \lpf.kr(5000) * 
		SelectX.kr(
			SinOsc.kr([1/7,1/2]*~t).range(0,2).mean,
			[
				[1/2,1],
				[1/2,1].reverse,
				[1/8,2],
			]
		),
		\lrq.kr(0.1),
	) + BPF.ar(sig,7000 * [1,SinOsc.kr(1/16).range(1,1.1)],0.1,mul:0.1);
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})

