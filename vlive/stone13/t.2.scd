
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

	//freq = freq * [1,1.001];
	freq = freq * [1,4,2,1/2,1.0001];
	sig = SinOsc.ar(freq) ;
	19.do { arg x;
		sig1 = SinOsc.ar(freq * ( sig * LFNoise1.kr(1/8 / (1..4) * (x+1)).range(0.0,1.0) + 1 )) ;
		sig = SelectX.ar( SinOsc.kr(1/4 / (1+x) * (1..4)).range(0,1), [sig, sig1]);
	};

	sig = DelayL.ar(sig, 0.1, [0,0.1 * SinOsc.kr(1/12).range(0.8,1)]);
	//sig = sig ! 2;
	sig = sig * 1/4;
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size * 0.3, amp).mean;
	//sig = Pan2.ar(sig, 0, amp);
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

