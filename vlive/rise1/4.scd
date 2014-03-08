~name = \4;



(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, levelScale=1, timeScale=1,
			ffreq=1000, rq=0.3, fspread=0.2,
			levelScale2=1, timeScale2=1;
	var sig, sig1, sig2, sig3;
	var env, env2;
	var impfreq;
	//env = EnvGen.ar(Env.adsr(0.1,0.1,1,1.1),gate,doneAction:2);
	env = EnvGen.ar(Env([0,0.1,0.9],[1,1],[5,4]),gate,levelScale:levelScale, timeScale:timeScale, doneAction:0);
	env2 = EnvGen.ar(Env([0,0.1,0.9],[1,1],[-5,-4]),gate,levelScale:levelScale2, timeScale:timeScale2, doneAction:0);
	freq = freq * env + (freq * 0.5);
	freq = freq * (1+([0.1,-0.2,0.3,-0.01]*fspread));
	//impfreq = 1450 * EnvGen.ar(Env([0.7,4.1,0.9],[1,1],[5,-4]),gate,levelScale:levelScale2, timeScale:timeScale2, doneAction:0);
	//sig = LFPulse.ar([freq, impfreq, freq+1]) * 0.001;
	sig = LFPulse.ar([freq, freq+1]) ;
	sig = sig.flatten;
	sig.postln;
	//sig = Impulse.ar(impfreq);
	//sig = sig + Dust.ar(impfreq);
	//sig = Ringz.ar(sig, freq, 5.01);
	ffreq = ffreq * env2 + (ffreq * 0.5);
	sig = RLPF.ar(sig, ffreq*4, rq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,4.01)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

Veco(~name).make_mixer;

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\fspread, 0.01,
	\fspread, Ndef(~name+++\lfo1, { SinOsc.ar(0.1).range(0,1) }),
	\timeScale, 0.01,
	\timeScale, 1,
	\isRest, Pseq([
		1,1,1,1,
	],inf),
	\freq, Pwhite(10,14900.0),
	\freq, Pwhite(40,111.0) + Pseg(Pseq([0.1,0.1,10000,1000],inf), 4),
	\freq, Pseq([100,70],inf) + Pseg(Pseq([0.1,0.1,2000],inf), 8),
	\freq, Pseq([100,70],inf) * Pseg(Pseq([1,1,18],inf), 8),
	\levelScale, Pwhite(-0.5,1),
	\levelScale, 1,
	\ffreq, Pwhite(100,1000.0),
	\ffreq, Pseq([1000,2000]*2,inf),
	\rq, Pwhite(0.051,0.4),
	\dur, 1/1,
	\sustain, Pseq([Pwhite(0.9,4,1),Pwhite(0.9,4,1)],inf),
	\dur, Pseq([Pwhite(0.1,0.24,1),Pwhite(0.02,0.4,1)],inf),
	\sustain, 0.1,
	\dur, 0.1,
	\dur, Pwhite(0.01,0.4),
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);

// END



// cuisine !!!!
(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, levelScale=1, timeScale=1,
			ffreq=1000, rq=0.3, fspread=0.2,
			levelScale2=1, timeScale2=1;
	var sig, sig1, sig2, sig3;
	var env, env2;
	var impfreq;
	//env = EnvGen.ar(Env.adsr(0.1,0.1,1,1.1),gate,doneAction:2);
	env = EnvGen.ar(Env([0,0.1,0.9],[1,1],[5,4]),gate,levelScale:levelScale, timeScale:timeScale, doneAction:0);
	env2 = EnvGen.ar(Env([0,0.1,0.9],[1,1],[-5,-4]),gate,levelScale:levelScale2, timeScale:timeScale2, doneAction:0);
	freq = freq * env + (freq * 0.5);
	freq = freq * (1+([0.1,-0.2,0.3,-0.01]*fspread));
	impfreq = 10 * EnvGen.ar(Env([0,0.1,0.9],[1,1],[-5,-4]),gate,levelScale:levelScale2, timeScale:timeScale2, doneAction:0);
	sig = Impulse.ar(impfreq);
	sig = Dust.ar(impfreq);
	sig = Ringz.ar(sig, freq, 0.01);
	ffreq = ffreq * env2 + (ffreq * 0.5);
	sig = RLPF.ar(sig, ffreq*4, rq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.71,0.1,0.8,4.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\fspread, 0.01,
	\fspread, Ndef(~name+++\lfo1, { SinOsc.ar(0.1).range(0,1) }),
	\timeScale, 0.01,
	\timeScale, 1,
	\isRest, Pseq([
		1,1,1,1,
	],inf),
	\freq, Pwhite(10,14900.0),
	\freq, Pwhite(40,111.0) + Pseg(Pseq([0.1,0.1,10000,1000],inf), 4),
	\levelScale, Pwhite(-0.5,1),
	\ffreq, Pwhite(100,1000.0),
	\rq, Pwhite(0.051,0.4),
	\dur, 1/1,
	\dur, Pwhite(0.1,0.4),
	\sustain, Pseq([Pwhite(0.9,4,1),Pwhite(0.9,4,1)],inf),
	\dur, Pseq([Pwhite(0.1,0.24,1),Pwhite(0.02,0.4,1)],inf),
	\sustain, 0.4,
	\dur, 0.1,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);

// sature un peu

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, levelScale=1, timeScale=1,
			ffreq=1000, rq=0.3, fspread=0.2,
			levelScale2=1, timeScale2=1;
	var sig, sig1, sig2, sig3;
	var env, env2;
	var impfreq;
	//env = EnvGen.ar(Env.adsr(0.1,0.1,1,1.1),gate,doneAction:2);
	env = EnvGen.ar(Env([0,0.1,0.9],[1,1],[5,4]),gate,levelScale:levelScale, timeScale:timeScale, doneAction:0);
	env2 = EnvGen.ar(Env([0,0.1,0.9],[1,1],[-5,-4]),gate,levelScale:levelScale2, timeScale:timeScale2, doneAction:0);
	//freq = freq * env + (freq * 0.5);
	freq = freq * (1+([0.1,-0.2,0.3,-0.01]*fspread));
	impfreq = 1450 * EnvGen.ar(Env([0.7,4.1,0.9],[1,1],[5,-4]),gate,levelScale:levelScale2, timeScale:timeScale2, doneAction:0);
	sig = LFPulse.ar([freq, impfreq, freq+1]) * 0.001;
	sig = sig.flatten;
	sig.postln;
	//sig = Impulse.ar(impfreq);
	//sig = sig + Dust.ar(impfreq);
	sig = Ringz.ar(sig, freq, 5.01);
	ffreq = ffreq * env2 + (ffreq * 0.5);
	sig = RLPF.ar(sig, ffreq*4, rq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.71,0.1,0.8,4.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\fspread, 0.01,
	\fspread, Ndef(~name+++\lfo1, { SinOsc.ar(0.1).range(0,1) }),
	\timeScale, 0.01,
	\timeScale, 1,
	\isRest, Pseq([
		1,1,1,1,
	],inf),
	\freq, Pwhite(10,14900.0),
	\freq, Pwhite(40,111.0) + Pseg(Pseq([0.1,0.1,10000,1000],inf), 4),
	\freq, Pseq([1000,2000]/10,inf),
	\levelScale, Pwhite(-0.5,1),
	\levelScale, 1,
	\ffreq, Pwhite(100,1000.0),
	\ffreq, Pseq([1000,2000]*2,inf),
	\rq, Pwhite(0.051,0.4),
	\dur, 1/1,
	\dur, Pwhite(0.1,0.4),
	\sustain, Pseq([Pwhite(0.9,4,1),Pwhite(0.9,4,1)],inf),
	\dur, Pseq([Pwhite(0.1,0.24,1),Pwhite(0.02,0.4,1)],inf),
	\sustain, 0.4,
	\dur, 0.4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);

