
(
SynthDef(\amdel, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, xfreq=100;
	var sig;
	freq = freq.lag(0.1);

	sig = SinOsc.ar(xfreq); 
	sig = Select.ar(sig+1*2, [ Saw.ar(freq), Pulse.ar(freq), SinOsc.ar(freq) ]);
	sig = LeakDC.ar(sig);
	sig = RLPF.ar(sig, \lpfr.kr(4.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, PmonoArtic(\amdel,
	\degree, Pseq([
		0,0,0,-1,
	],inf),
	\lpfr, 7,
	\xfreq, ~pmodenv.(Pseq([100,80],inf), 4),
	\scale, Scale.minor,
	\trigx, 1,
	\legato, Pseq([1,1,1,0.8,0.1,1,1,0.9],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	//\legato, 0.7,
	\octave, 3,
	\dur, 1/2,
	\amp, 0.1
)).play;
);
