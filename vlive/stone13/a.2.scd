
(
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var freq2;

	freq = 100*4;
	freq = Duty.kr(1/~t, 0, Dseq([
		1,0,4,0,
	],inf)).midiratio * freq;
	freq2 = (-200!8).rand;
	sig = SinOsc.ar(freq + ( freq2 / 8));
	sig = sig * ( 1 + ( FreqShift.ar(sig, freq2 * SinOsc.kr(41/4).range(0,1)) * SinOsc.kr(1/4).range(0,1) ) );
	sig = (sig*23* SinOsc.kr(1/8 * (1..8)).range(0,1)).tanh;
	sig = HPF.ar(sig,150);
	sig = LPF.ar(sig,4450);
	sig = sig / 2;
	
	amp = amp * \gain.kr(1);
	sig = sig * EnvGen.kr(\iadsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), Trig.kr(\itrig.tr(1),\isustain.kr(1)), doneAction:0);

	sig = sig + CombL.ar(sig, 1, 1/8/8 * (1..8) * LFNoise1.kr(1/8 * (1..8)/8).range(0.8,2.0), 1);
	sig = sig + CombL.ar(sig, 1, 1/8/8 * (1..8) * LFNoise1.kr(1/8 * (1..8)/8).range(0.8,2.0), 1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
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

