
(
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var freq2;
	//var sig1, sig2;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var ifreq;

	freq = 100*4;
	ifreq = freq;
	freq = Duty.kr(8/~t, 0, Dseq([
		Dseq([
			[0,3+12,12],
			[0,3+12,12]+3,
		],1),
	],inf)).midiratio.lag( Duty.kr(1/~t, 0, Dseq([
		1,0,2,0,
		1,4,0,1,
	],inf)/4)) * freq;
	freq =  [ 2 * ifreq * Duty.kr(1/~t, 0, Dseq([
		0,12,4,4+12,
	],inf)).midiratio ] ++ freq;
	freq.debug("freq");
	freq2 = (-200!8).rand;
	freq = freq * ( 1+ (0.03* LFNoise1.ar(1 / (1..8)).range(0,1) ) );
	//lfo1 = SinOsc.ar(100) * SinOsc.kr(1/8).range(0,20);
	lfo1 = SinOsc.ar(100 ) * MouseX.kr(0,30);
	sig = LFSaw.ar(freq * ( 1 + lfo1));
	sig = CombL.ar(sig, 1/44, 1/DelayL.kr(freq,0.1,0.1 * SinOsc.ar(448).range(2,0.4)) * [1/2,2],1)/8;
	sig = CombL.ar(sig, 1/44, 1/freq * 2 * (LFNoise1.kr((1..8)*0.01)*0.21+1), 1);
	//sig = sig * MouseX.kr(1,4);
	sig = Limiter.ar(sig, 0.8);
	sig = sig * 4;
	//sig = sig * XLine.kr(0.001,1,8);
	//sig = RLPF.ar(sig, MouseY.kr(50,18000, \exponential).lag(1), 0.10);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
	sig;
});

Ndef(~name+++\fx).put(1, \set -> Pbind(
	\itrig, Pseq([1,1],inf),
	\isustain, 0.01,
	\iadsr, Plazy({ arg ev;
		Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.53) ],
		],1);
	}).loop,
	\dur, 1/4,
));
)

