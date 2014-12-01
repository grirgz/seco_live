(
	~name = \plop;
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = SinOsc.ar(freq);
	sig = sig | LFSaw.ar(1/10,mul:10);
	sig = sig | LFSaw.ar(4*1/7,mul:50);
	sig = sig | LFSaw.ar(\kfreq3.kr(1).lag(0.1),mul:50);
	sig = RLPF.ar(sig, \lpf.kr(1000).lag(0.1),0.5);
	sig = RHPF.ar(sig, \hpf.kr(100).lag(0.1),0.5);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;

Pdef(~name, Pmono(~name,
	\degree, Pseq([0,1,7,3],inf),
	\octave, 5,
	\isRest, false,
	//\lpf, Pseq([400,5000,2000,100],inf),
	//\hpf, Pseq([400,5000,2000,100,4000,250],inf) /4,
	\kfreq3, Pseq([0.1,1/8,20,100],inf).stutter(2),
	\dur, 1/4,
	\amp, 0.1
)).play;
);
{ SinOsc.ar(500)!2 }.play

(
	~name = \plop;
	~t = 1;
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = SinOsc.ar(freq);
	sig = sig | LFSaw.ar(1/10,mul:10);
	sig = sig | LFSaw.ar(4*1/7,mul:50);
	sig = sig | LFSaw.ar(\kfreq3.kr(1).lag(0.1),mul:50);
	sig = RLPF.ar(sig, \lpf.kr(1000).lag(0.1),0.5);
	sig = RHPF.ar(sig, \hpf.kr(100).lag(0.1) * SinOsc.kr(2/~t).range(0.1,1),0.5);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;

Pdef(~name, Pmono(~name,
	\degree, Pseq([0,1,7,3],inf),
	\octave, 5,
	\isRest, false,
	\lpf, Pseq([
		Pser([1000],4*4),
		Pser([400,1000,2000,100,1000],4*4),
	],inf),
	\hpf, Pseq([400,5000,2000,100,4000,250,700],inf) /4,
	\kfreq3, Pseq([
		Pseq([10],4*4).stutter(2),
		Pseq([0.1,1/8,20,100],4*4).stutter(2),
	],inf),
	\dur, 1/4,
	\amp, 0.1
)).play;
);

(
	~name = \plop;
	~t = 1;
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var osig, sig, sig1, sig2, sig3;
	sig = SinOsc.ar(freq);
	osig = sig;
	sig = sig | LFSaw.ar(70/64,mul:4);
	sig = sig | LFSaw.ar(70*2,mul:5);
	sig = sig | LFSaw.ar(1,mul:5);
	//sig = sig | LFSaw.ar(70*2,mul:5);
	//sig = sig + (osig | LFSaw.ar(\kfreq3.kr(1).lag(0.1),mul:5));
	sig = RLPF.ar(sig, \lpf.kr(1000).lag(0.1),0.5);
	//sig = RHPF.ar(sig, \hpf.kr(100).lag(0.1) * SinOsc.kr(4/~t).range(0.1,1),0.7);
	sig = RHPF.ar(sig, \hpf.kr(100).lag(0.1) ,0.7);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;

Pdef(~name, Pmono(~name,
	\degree, Pseq([0,1,7,3],inf),
	\octave, 5,
	\isRest, false,
	\lpf, Pseq([
		Pser([7000],4*4),
	],inf),
	\hpf, Pseq([50],inf) ,
	\kfreq3, Pseq([
		Pseq([50],4*4).stutter(2),
	],inf),
	\dur, 1/4,
	\amp, 0.1
)).play;
);

(
	~name = \plop;
	~t = 1;
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var osig, sig, sig1, sig2, sig3;
	sig = SinOsc.ar(freq);
	osig = sig;
	sig = sig | LFSaw.ar(70/64,mul:4);
	sig = sig | LFSaw.ar(70*2,mul:5);
	sig = sig | LFSaw.ar(70/64,mul:5);
	sig = sig | LFSaw.ar(70/128,mul:20);
	sig = sig & LFSaw.ar(70/256,mul:20);
	//sig = sig | LFSaw.ar(70*2,mul:5);
	//sig = sig + (osig | LFSaw.ar(\kfreq3.kr(1).lag(0.1),mul:5));
	sig = RLPF.ar(sig, \lpf.kr(1000).lag(1.1),0.5);
	//sig = RHPF.ar(sig, \hpf.kr(100).lag(0.1) * SinOsc.kr(4/~t).range(0.1,1),0.7);
	sig = RHPF.ar(sig, \hpf.kr(100).lag(0.1) ,0.7);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;

Pdef(~name, Pmono(~name,
	\degree, Pseq([0,1],inf),
	\octave, 5,
	\isRest, false,
	\lpf, Pseq([
		Pser([7000]),
		Pser([5700]),
	],inf)/4,
	\hpf, Pseq([50],inf) ,
	\kfreq3, Pseq([
		Pseq([50],4*4).stutter(2),
	],inf),
	\dur, 1/2,
	\amp, 0.1
)).play;
);
