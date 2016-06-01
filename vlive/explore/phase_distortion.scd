
~buffer = Buffer.alloc(s, 1024);
~buffer.sine1([1], asWavetable:false); // put a sine wave in the buffer
~t = 1;
(
SynthDef(\phasedist, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum;
	var sig;
	var phase;
	var midpoint;
	freq = Duty.kr(1/~t, 0, Dseq([
		0,2,0,4,
	],inf)).midiratio * freq;
	midpoint = MouseX.kr(0,1);
	//phase = EnvGen.ar(Env([0,0,0.5,MouseX.kr(0,1)], [0,0.5,0.5]), Impulse.ar(freq), timeScale:1/freq);
	phase = EnvGen.ar(Env([0,0,0.5,1], [0,midpoint,1-midpoint]), Impulse.ar(freq), timeScale:1/freq);
	phase = phase * BufFrames.kr(bufnum);

	sig = BufRd.ar(1, bufnum, phase);
	//sig = SinOsc.ar(0, phase);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);

	//sig = (phase/BufFrames.kr(bufnum) - 0.5)!2 / 10; // see the phase signal, comment to hear the end signal
	Out.ar(out, sig);
}).add;

Pdef(\plop, Pbind(
	\instrument, \phasedist,
	//\degree, Pseq([0,2,4],inf),
	\freq, 200,
	\degree, Pseq([0],inf),
	\bufnum, ~buffer,
	\legato, 0.95,
	\dur, 8/2,
	\amp, 0.1
)).play;
);
//Synth(\phasedist, [\bufnum, ~buffer, \freq, 200]).plot(1)

~buffer.plot
s.plot

{ EnvGen.kr(Env([0,0,0.5,1], [0,0.5,0.5]), Impulse.kr(4), timeScale:1/4); }.plot(2)

