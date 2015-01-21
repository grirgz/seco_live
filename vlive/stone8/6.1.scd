
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
	var fspread = 0.001;

	freq = 430 * Duty.kr(1/~t, 0, Dseq([
		[0,3,7],
	],inf)).midiratio;
	freq = freq *.t ((0..7)/7 - 0.5 * fspread + 1);
	freq = freq.flat;
	
	sig = LFSaw.ar(freq);
	sig = LPF.ar(sig, XLine.kr(0.50,15000,12));
	
	amp = amp * \gain.kr(1);
	sig = sig * amp;

	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;
	sig;
});

Ndef(~name+++\fx).put(1, \set -> Pbind(
	\trig, Pseq([1,0,0,1, 0,0,1,0],inf),
	\dur, 1/4,
));
)
