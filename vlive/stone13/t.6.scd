
(
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var freq2;
	//var sig1, sig2;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var oldsig;

	freq = 100*4;
	freq = Duty.kr(1/~t, 0, Dseq([
		1,0,-1,0,
	],inf)).midiratio.lag(0.1) * freq;

	//freq = freq * [1,1.001];
	freq = freq * [0,3,7].midiratio;
	sig = SinOsc.ar(freq) ;
	oldsig = 1;
	8.do { arg x;
		sig = SinOsc.ar(freq+x) * (1+ ( sig * SinOsc.kr(1/( x+1 )).range(0,2) ) ) * 0.8;
	};
	//sig = sig.tanh;
	//sig = ( sig.abs > 0.4 ) * sig;
	sig = sig / 4;
	sig = Limiter.ar(sig);

	sig = sig + DelayL.ar(sig, 0.1, [0,0.1 * SinOsc.kr(1/12).range(0.8,1)]);
	sig = sig + DelayL.ar(sig, 0.1, 1/freq*1.1);
	sig = sig + DelayL.ar(sig, 0.1, 1/freq*0.9 * SinOsc.kr(1/4).range(0,1));
	sig = sig + DelayL.ar(sig, 0.1, 1/freq*0.9 * SinOsc.kr(1/4.541).range(1,2));
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

