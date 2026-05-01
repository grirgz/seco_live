SynthDef(~name, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	freq = freq * \freqfac.kr(1);
	sig = VarSaw.ar(freq * [1,1.001], width: SinOsc.ar(1/2,pi/2) );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;

~currentTrack.initPdef(
	Pbind(
		\instrument, ~name,
		\note, Pseq([
			0,
		],inf),
		\freqfac, PmodEnv(Pseq([1,1,1,1,-1.midiratio],1), 2).loop,
		\octave, 3,
		\dur, 1/4,
		\amp, 0.1,
		\out, BusDef(\basstrack, \audio),
	)
);
