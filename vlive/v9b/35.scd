~name = \35;

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, frange=0.9;
	var sig, sig1, sig2, sig3;
	freq = freq.lag(0.1);
	frange = frange.lag(0.3);
	sig = SinOsc.ar(LFNoise1.kr(1).range(5,freq));
	sig = LFSaw.ar(frange*freq*sig+freq*0.9);
	//g=LFNoise2.ar(3,11,12);
	//sig = LFSaw.ar(frange*freq*g+freq*1.1);
	//f=LFNoise0.ar(sig.range(0.1,4),4,6).octcps.lag(0)/100;
	//sig = LFSaw.ar(frange*freq*f+freq);
	//sig = LFSaw.ar(frange*freq*sig+freq);
	//x=Resonz.ar(LFNoise0.ar(f),f/6,(g**2.3)/f).clip;
	f=SinOsc.ar(1*Array.geom(8,0.1,1.1).postln).range(100,600);
	//f=LFSaw.ar(f/100*Array.series(8,0.1,0.1).postln).range(50,600+LFNoise1.kr(1,200));
	//x=Resonz.ar(WhiteNoise.ar(1),f,Array.series(8,0.01,0.05).postln);
	x=Resonz.ar(sig,f,Array.series(8,0.01,0.05).postln);
	//sig = sig;
	//sig = AllpassC.ar(x,1,Array.series(8,0.01,0.05).mirror.postln,99) - x;
	sig = CombC.ar(x,1,Array.series(8,0.01,0.05).mirror.postln,1.09) - x;
	//sig = x;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	//\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.2 * Pkey(\amp)
) <> Veco(~name).mixer)
);

// END

{g=LFNoise2.ar(3,11,12);f=LFNoise0.ar(g,4,6).octcps;x=Resonz.ar(LFNoise0.ar(f),f/6,(g**2.3)/f).clip;AllpassC.ar([x,0-x],1,g/23,99)}.play

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, frange=0.9;
	var sig, sig1, sig2, sig3;
	freq = freq.lag(0.1);
	frange = frange.lag(0.3);
	sig = SinOsc.ar(LFNoise1.kr(1).range(5,100));
	sig = LFSaw.ar(frange*freq*sig+freq*0.9);
	g=LFNoise2.ar(3,11,12);
	sig = LFSaw.ar(frange*freq*g+freq*1.1);
	f=LFNoise0.ar(sig.range(0.1,4),4,6).octcps.lag(0)/100;
	sig = LFSaw.ar(frange*freq*f+freq);
	sig = LFSaw.ar(frange*freq*sig+freq);
	//x=Resonz.ar(LFNoise0.ar(f),f/6,(g**2.3)/f).clip;
	f=SinOsc.ar(1*Array.geom(8,0.1,1.1).postln).range(100,600);
	f=LFSaw.ar(f/100*Array.series(8,0.1,0.1).postln).range(50,600+LFNoise1.kr(1,200));
	//x=Resonz.ar(WhiteNoise.ar(1),f,Array.series(8,0.01,0.05).postln);
	x=Resonz.ar(sig,f,Array.series(8,0.01,0.05).postln);
	//sig = sig;
	//sig = AllpassC.ar(x,1,Array.series(8,0.01,0.05).mirror.postln,99) - x;
	sig = CombC.ar(x,1,Array.series(8,0.01,0.05).mirror.postln,2.99) - x;
	//sig = x;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, frange=0.9;
	var sig, sig1, sig2, sig3;
	freq = freq.lag(0.1);
	frange = frange.lag(0.3);
	sig = SinOsc.ar(LFNoise1.kr(1).range(5,freq));
	sig = LFSaw.ar(frange*freq*sig+freq*0.9);
	//g=LFNoise2.ar(3,11,12);
	//sig = LFSaw.ar(frange*freq*g+freq*1.1);
	//f=LFNoise0.ar(sig.range(0.1,4),4,6).octcps.lag(0)/100;
	//sig = LFSaw.ar(frange*freq*f+freq);
	//sig = LFSaw.ar(frange*freq*sig+freq);
	//x=Resonz.ar(LFNoise0.ar(f),f/6,(g**2.3)/f).clip;
	f=SinOsc.ar(1*Array.geom(8,0.1,1.1).postln).range(100,600);
	//f=LFSaw.ar(f/100*Array.series(8,0.1,0.1).postln).range(50,600+LFNoise1.kr(1,200));
	//x=Resonz.ar(WhiteNoise.ar(1),f,Array.series(8,0.01,0.05).postln);
	x=Resonz.ar(sig,f,Array.series(8,0.01,0.05).postln);
	//sig = sig;
	//sig = AllpassC.ar(x,1,Array.series(8,0.01,0.05).mirror.postln,99) - x;
	sig = CombC.ar(x,1,Array.series(8,0.01,0.05).mirror.postln,1.09) - x;
	//sig = x;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);
