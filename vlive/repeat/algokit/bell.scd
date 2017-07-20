
(
SynthDef(\bell, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, timeScale=1;
	var sig;
	var size = 50;
	sig = SinOsc.ar({gauss(2,1).linexp(0,4,100,15000)}.dup(size));
	sig = LFSaw.ar({ExpRand(19000.0,500) * XLine.kr(rrand(0.1,2),rrand(0.1,2),exprand(4.81,44.4))}.dup(size/2), mul:1.0);
	sig = sig ++ LFSaw.ar({freq*ExpRand(0.9,1.1) * XLine.kr(rrand(0.991,1.02),rrand(0.991,1.02),exprand(4.81,44.4))}.dup(size/2));
	//sig = sig * LFSaw.ar(freq,mul:1.0); 
	//sig = SinOsc.ar(\freqs.kr(100!size));
	
	//sig = RLPF.ar(sig, \lpf.kr(5100), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.dadsr({ ExpRand(0.0001,0.051) } ! size,0.01,0.1,0.8,{Rand(0.01,0.8)} ! size),gate,timeScale:timeScale,doneAction:0);
	sig = sig.mean;
	sig = BPF.ar(sig, freq, 0.1)+( sig/48 );
	//sig = BPF.ar(sig, freq, 0.01)+( sig/4 );
	//sig = BPF.ar(sig, freq, 0.01)+( sig/4 );
	//sig = BPF.ar(sig, freq, 0.01)+( sig/4 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.9),gate,timeScale:timeScale,doneAction:2);
	sig = sig * 45 * 2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

Pdef(\bell,
	Pbind(
		\instrument, \bell,
		//\freq, 200,
		\degree, Pseq([
			0,0,0,0,
			1,0,2,0,
		],inf),
		\octave, 6,
		\timeScale, 0.8,
		//\sustain, 0.1,
		\legato, 0.8,
		\dur, 1,
		\amp, 0.1
	)
).play;
);

(
(
SynthDef(\disso, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * ((1..8)/8 * XLine.kr(0.001,0.01,2) +1) ).mean;
	sig = RLPF.ar(sig, \lpfr.kr(2) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
~psize = 3;
Pdef(\disso, Pbind(
	\instrument, \disso,
	\note, Pseq([{rrand(1,24)}!~psize],inf),
	//\detune, {rrand(241,24)}!~psize,
	//\detune, 100,
	\dur, 2,
	\amp, 0.1
)).play;
);
