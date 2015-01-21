
(
Ndef(~name+++\fx).put(0, { arg amp=0.1, pan=0, release=0.26, fratio=1.5, freqpan=0.01, spread=0.8, timeScale=1;
	var env0, env1, env1m, son;
	var son1, son2, son3, son4;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sig;
	var env2, env3, env4;
	var distlim = 1;
	var trig;
	var lfo1, lfo2, lfo3;
	var freq;
	freq = 700;
	freq = freq * [1,1.01,1.002] *.t Duty.kr(1/~t, 0, Dseq([
		[1,4/3],
		[1,5/4],
		[1,5/4,9/8],
		[1,5/4,7/8],
	],inf));

	lfo1 = SinOsc.ar(freq/4 *
		Duty.kr(1/~t * [1.0001,1,1.001], 0, Dseq([
			1,1/4,2,1/2,
		],inf))
	
	) * Duty.kr(1/~t * [1,1.01,1.002], 0, Dseq([
		1,4,2,0,
	],inf)) * Line.kr(0,10,10);
	sig = SinOsc.ar(lfo1 + 1 * freq);

	sig = Splay.ar(sig, 0.1, amp, pan);
	sig = sig * 2;
	
	
	amp = amp * \gain.kr(1);
	sig = sig * amp;
	sig;
});

Ndef(~name+++\fx).put(1, \set -> Pbind(
	\trig, Pseq([1,0,0,1, 0,0,1,0],inf),
	\dur, 1/4,
));
)
