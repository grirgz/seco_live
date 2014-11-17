
(
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	
	var freq;
	freq = \freq.kr(800) * [0,3,7].midiratio;
	sig1 = SinOsc.ar(freq * SinOsc.kr(1/7).range(0.99,1) *.t [1,1.24563,1.29456,1.545147]);
	sig = SinOsc.ar(70 * SinOsc.kr(1/17).range(1,1.01) * [1.32,1.4523], sig1 * LFNoise1.ar(1/14 * LFNoise1.ar(1/8).exprange(1.0,119)).range(0.5,4));
	sig2 = LFSaw.ar(freq * 1.12541);
	sig2 = RLPF.ar(sig2, LFNoise1.kr(1/14.3).range(100,17000), LFNoise1.kr(1/12).range(0.01,1.0));
	sig = SelectX.ar( LFNoise1.kr(1/4.25).range(0.0,1.0), [sig, sig * sig2]).flop;
	sig = SelectX.ar( LFNoise1.kr(1/2).range(0.0,1.0) * (sig.size-1), sig.flop);
	sig = sig * ({LFNoise1.kr(1/2).range(0.0,1.0)} ! sig.size);
	sig = LPF.ar(sig,  LFNoise1.kr(1/22).range(200,17000));
	sig = HPF.ar(sig, 400 * LFNoise1.kr(1/12).range(0.05,2.0));
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	amp = amp * EnvGen.kr(\adsr.kr(Env.adsr(0.0001,0.1,0.5,2.1)), Trig.kr(Impulse.kr(1/8*~t),1), doneAction:0);
	sig = CombL.ar(sig, 4/~t, 2/~t,8/~t) + sig;
	sig.postln;
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1,1.0)}!sig.size, amp);
	sig;
});

Ndef(~name+++\fx).put(1, \set -> Pbind(
	\freq, 400 * Pseq([0,3,7],inf).midiratio,
	\dur, 2,
));
)
