
(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var lfo1, lfo2;
	lfo1 = SinOsc.ar(freq/8) * XLine.ar(0.001,4.001,8);
	sig = SinOsc.ar(lfo1 + 1 * freq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;

SynthDef(~name+++\b, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var lfo1, lfo2;
	var lfopan;
	var time = 8;
	lfopan = XLine.ar(0.001,1,time);
	lfo1 = SinOsc.ar(freq / ((1..8)/80 + 8)) * XLine.ar(0.001,4.001,time);
	sig = SinOsc.ar(lfo1 + 1 * freq * [1,1/2]+ Rand(0,0.001));
	sig1 = LFPulse.ar(lfo1 + 1 * freq + Rand(0,0.001),mul:0.2);
	sig1 = RLPF.ar(sig1, SinOsc.kr(1/7).range(100,4001));
	sig = sig + sig1; 
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	//sig = Splay.ar(sig, spread, amp, pan);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size * lfopan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(~name+++\c, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var lfo1, lfo2;
	var lfopan;
	var time = 4;
	lfopan = 1;
	freq = [1,2,1/4,1.001] * freq;
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar( Line.kr(0,2,time), [sig1, sig2, sig3]);
	sig = RLPF.ar(sig, LFPulse.kr(1/1 / (1..4)).range(140,4001).lag(0.1));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	//sig = Splay.ar(sig, spread, amp, pan);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size * lfopan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(~name+++\d, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var lfo1, lfo2;
	var lfopan;
	var time = 4;
	lfopan = 1;
	freq = [1,2,1/4,1.001] * freq;
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar( Line.kr(0,2,time), [sig1, sig2, sig3]);
	sig = RLPF.ar(sig, LFPulse.kr(1/1 * (1..4) * Line.ar(0,1,time)).range(140,4001).lag(0.1));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	//sig = Splay.ar(sig, spread, amp, pan);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size * lfopan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(~name+++\e, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var lfo1, lfo2;
	var lfopan;
	var time = 4;
	lfopan = 1;
	lfo1 = LFPulse.kr(1/1 / (1..4) * Line.ar(0,1,time));
	lfo2 = SinOsc.kr(1/1 / (1..4) / 2 * Line.ar(0,1,time)).round(0.3);
	freq = [1,2,1/4,1.001] * freq;
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar( lfo2.range(0,2), [sig1, sig2, sig3]);
	sig = RLPF.ar(sig, lfo1.range(140,4001).lag(0.1));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	//sig = Splay.ar(sig, spread, amp, pan);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size * lfopan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);

// END

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	//sig = {arg x; SinOsc.ar(freq * ExpRand(x/64+x,0-x/64+x))}!64;
	sig = {arg x; var y=ExpRand(0.0001,266); x=freq; SinOsc.ar( ExpRand(x/y+x,0-x/y+x))}!64;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan * LFNoise1.ar(1/8)/3, amp);
	//sig = sig.mean * 4;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	//sig = {arg x; SinOsc.ar(freq * ExpRand(x/64+x,0-x/64+x))}!64;
	sig = {arg x; SinOsc.ar( freq/2 * x + ExpRand(freq/64,2*freq/64).poll)}!5;
	sig = sig.scramble;
	sig = TScramble.ar(sig, Impulse.kr(4),1);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan * LFNoise1.ar(1/8)/3, amp);
	//sig = sig.mean * 4;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);




// http://twitter.com/#!/alln4tural/status/99846300173991936
// http://soundcloud.com/tengototen/esoteric-tweet


fork{loop{h=[5,7,8].choose*(2**(2..8).choose);play{Splay.ar({SinOsc.ar(exprand(h,h+(h/64)),0,0.1)}!64)*LFGauss.ar(9,1/4,0,0,2)};2.wait}};

// really i wanted to do this:
fork{loop{h=([33,38,40].choose.midicps)*(2**((0 .. 5).choose));play{Splay.ar({SinOsc.ar(exprand(h-(h/256),h+(h/256)),0,0.1)}!64)*LFGauss.ar(19,1/4,0,0,2)};4.wait}};
// or more like a constant drone:
fork{loop{h=([33,38,40].choose.midicps)*(2**((0 .. 4).choose));h.postln;play{Splay.ar({SinOsc.ar(exprand(h-(h/64),h+(h/64)),0,0.1)}!8)*LFGauss.ar(19,1/4,0,0,2)};0.25.wait}};
// primes
fork{loop{h=(4 .. 100).choose.nthPrime*(2**(0..3).choose);play{Splay.ar({SinOsc.ar(exprand(h-(h/256),h+(h/256)),0,0.1)}!64)*LFGauss.ar(19,1/4,0,0,2)};2.wait}}; 
// Fibonacci
fork{loop{h=(List.

play{Splay.ar({SinOsc.ar(exprand(h-(h/64),h+(h/64)),0,0.1)}!8)*LFGauss.ar(19,1/4,0,0,2)};
h=([33,38,40].choose.midicps)*(2**((0 .. 5)))
h=(100)*(2**((0 .. 5)))
exprand(h-(h/64),h+(h/64))
