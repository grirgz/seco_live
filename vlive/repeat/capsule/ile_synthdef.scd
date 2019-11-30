
(
SynthDef(\sereno, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = freq * \ratio.kr([0,4,7].midiratio) * [1/2,1,2];
	sig1 = SinOsc.kr((1..9)/10).range(0,1);
	sig2 = SinOsc.kr((1..9)/20).range(0,1);
	sig = LFSaw.ar(freq) * SinOsc.ar(freq+sig2, SinOsc.ar(freq+2+sig1), 1, SinOsc.ar(freq+2+sig2) );
	pan = LFNoise1.kr((1..9)/75).range(-1,1);

	lfo1 = Duty.kr(1/8/~t * LFNoise1.kr(1/3).range(0.001,4), 0, Dseq([
		1,0,1.5,0.5,0,2,
	],inf)).lag(0.251);
	lfo2 = Duty.kr(1/7/~t * LFNoise1.kr(1/3).range(0.001,4), 0, Dseq([
		1,0,1.5,0.5,0,2,
	],inf)).lag(0.251);
	lfo3 = TDuty.kr(1/~t, 0, Dseq([
		1,0,0,0,
	],inf));
	env1 = EnvGen.kr(Env([1,2,0.71],[Rand(0.1,0.7),Rand(0.4,1.7)]), lfo3);
	env2 = EnvGen.kr(Env([1,2,0.71],[Rand(0.1,0.7),Rand(0.4,1.7)]), 1);
	sig1 = LFSaw.ar(freq * (lfo1 * 0.03 + 1) * [1/2,1,2]) * LFNoise1.kr(1/7!3).range(0,1);
	sig1 = sig1 + LFSaw.ar(freq * (lfo2 * 0.03 + 1) * \ratio.kr) * LFNoise1.kr(1/7!3).range(0,1);
	sig1 = sig1.mean;
	sig = SelectX.ar(\fiomix.kr(0.5), [sig, sig1]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * env1 * freq, \rq.kr(0.5));

	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
)
