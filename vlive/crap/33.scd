
(
Ndef(\plop).put(0, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(\oscmix.kr(0.5)/2, [sig1, sig2, sig3]);
	sig = RLPF	
	sig = Pan2.ar(sig, pan, amp);
}).play;


Ndef(\plop).put(1, \set -> Pbind(
	\oscmix, Pseq([1,0,0.5],inf),
	\dur, 1/4,
));

);


(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * [1/2,1,2,1/2];
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(\oscmix.kr(0.5)/2, [sig1, sig2, sig3]);
	//sig[2] = (sig[2]*10).tanh;
	sig = sig * [LFPulse.kr(1/7).range(0,1),1,1,SinOsc.kr(1/42).range(0,1)];

	sig = RLPF.ar(sig, \lpf.kr(100).lag(0.1),0.5);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.31),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

TempoClock.default.tempo = 155/60;

(
Pdef(\plop, Pbind(
	\instrument, \plop,
	\degree, Pseq([
		0,\r,2,\r,
		4,\r,\r,\r,
		0,\r,\r,\r,
		\r,\r,3,\r,

		3,\r,5,\r,
		7,\r,\r,\r,
		4,\r,\r,\r,
		\r,\r,\r,\r,
	],inf),
	\lpf, Pseq([
		100,200,300,400,500,
	],inf),
	\lpf, Ndef(\lfo1, { SinOsc.kr(SinOsc.kr(1/25).range(0.2,1.4)).range(50,700)  }),
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
		[ Env.adsr(0.3,0.1,0.8,0.1) ],
		[ Env.adsr(0.1,0.1,0.8,0.3) ],
		[ Env.adsr(0.1,0.1,0.8,0.033) ],
		[ Env.adsr(0.2,0.1,0.8,0.033) ],
	],inf),
	\legato, Pseq([
		1,1,1,1,
		2,1,2,1,
		4,1,1,1,
		1,1,2,1,
		1,


	],inf) * 0.8,
	\oscmix, Pseq([
		0,0.3,1,0.5,0.8
	],inf).stutter(4),
	//\mtranspose, Pseq([0,])
	\octave, 3,
	//\isRest, Pseq([
	//	1,0,1,0, 1,0,0,0,
	//	1,0,0,0, 1,0,1,0,
	//	1,0,0,0, 0,0,0,0,
	//	1,0,0,0, 1,0,1,0,
	//],inf).coin.not,
	\dur, 1/4,
	\amp, 0.1
)).play;
);



Veco.gui

(
SynthDef(\lead, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * [2,1,1,2];
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(\oscmix.kr(0.5)/2, [sig1, sig2, sig3]);
	sig[2] = (sig[2]*10).tanh;
	sig = sig * [LFPulse.kr(1/7).range(0,1),1,1,SinOsc.kr(1/42).range(0,1)];

	sig = RLPF.ar(sig, \lpf.kr(100).lag(0.1),0.5);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.31),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

TempoClock.default.tempo = 155/60;

(
Pdef(\lead, Pbind(
	\instrument, \lead,
	\degree, Pseq([
		\r,0,2,2,
		4,4,\r,\r,
		0,\r,\r,\r,
		3,3,3,3,

		\r,3,\r,5,
		\r,\r,7,\r,
		4,\r,4,\r,
		4,4,0,0,
	],inf),
	\lpf, Pseq([
		100,200,300,400,500,
	],inf),
	\lpf, Ndef(\lfo1, { SinOsc.kr(SinOsc.kr(1/45).range(0.2,1.7)).range(1150,4700)  }),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.1) ],
	],inf),
	\legato, Pseq([
		1,1,1,1,
		4,1,1,1,
		1,1,2,1,
		2,1,2,1,
		1,


	],inf) * 0.2,
	\oscmix, Pseq([
		0,0.3,1,0.5,0.8
	],inf).stutter(4),
	//\mtranspose, Pseq([0,])
	\octave, 5,
	//\isRest, Pseq([
	//	1,0,1,0, 1,0,0,0,
	//	1,0,0,0, 1,0,1,0,
	//	1,0,0,0, 0,0,0,0,
	//	1,0,0,0, 1,0,1,0,
	//],inf).coin.not,
	\dur, 1/4,
	\amp, 0.1 / 2,
)).play;
);
