
(
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var freq2;
	//var sig1, sig2;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;

	freq = 100*4;
	freq = Duty.kr(1/~t, 0, Dseq([
		1,0,-1,0,
	],inf)).midiratio.lag(0.1) * freq;
	freq2 = (-200!8).rand;
	freq = freq * ( 1+ (0.03* SinOsc.ar(8 / (1..8)).range(0,1) ) );
	//lfo1 = SinOsc.ar(100) * SinOsc.kr(1/8).range(0,20);
	lfo1 = SinOsc.ar(800* [0,3,7].midiratio) * MouseX.kr(0,20);
	sig = LFSaw.ar(freq * ( 1 + lfo1));
	sig = CombL.ar(sig, 1/44, 1/DelayL.kr(freq,0.1,0.1 * SinOsc.ar(448).range(2,0.4)) * [1/2,2],1)/8;
	sig = CombL.ar(sig, 1/44, 1/freq * 2 * (LFNoise1.kr((1..8)*0.01)*0.21+1), 1);
	sig = sig / 2;
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

