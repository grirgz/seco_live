
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
	freq = 400  *.t [0,3,11].midiratio;
	freq = freq.flat;

	sig = freq.collect({ arg freq, x;
		var isig;
		var isig1;
		var time;
		time = 1/~t * (x+1)/4;
		sig1 = LFSaw.ar(freq);
		sig2 = LFPulse.ar(freq);
		sig3 = SinOsc.ar(freq);
		isig = SelectX.ar(
			Duty.kr(time, 0, Dseq([
				1,0.3,0.2,0,
			],inf)) * 2 + LFNoise1.kr(1/4 + x/10).range(0.0,1.0),
			[sig1, sig2, sig3]
		);
		//isig = isig * LFPulse.ar(1*(x+1)).range(0,1);
		isig = isig * Duty.kr(time, 0, Dseq([
			1,0,0,0,
		],inf)).lag(0.1);
		isig = isig * LFSaw.kr(2*x+1).range(0.1,1);
		isig1 = FreqShift.ar(isig, [1,2] * SinOsc.kr(x*2+1).range(0,1)).mean + isig;
		isig = SelectX.ar( SinOsc.kr(1/4+x/11).range(0,1), [isig, isig1]);
		isig;
	});
	sig = sig / 2;
	sig.debug("bsig");
	sig = Splay.ar(sig, 0.1 * Duty.kr(1/~t, 0, Dseq([
		1,0,
	],inf)), amp, pan);
	sig = sig * 12;
	
	
	amp = amp * \gain.kr(1);
	sig = sig * amp;
	sig;
});

Ndef(~name+++\fx).put(1, \set -> Pbind(
	\trig, Pseq([1,0,0,1, 0,0,1,0],inf),
	\dur, 1/4,
));
)
