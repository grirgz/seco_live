(
SynthDef("piou", {
	arg out=0, amp=1, sustain=0.5;
	var ou;
	ou = SinOsc.ar(
		XLine.kr(500, 50, sustain)*SinOsc.kr(9)+1,
		XLine.kr(000, 10, sustain)
	) * EnvGen.kr(Env.linen(0.1,0.5,0.1), timeScale:sustain, doneAction:2);
	Out.ar(out, ou * amp)
}).store;
 
SynthDef("fm1", {
	arg out=0, amp=1, sustain=0.5, freq=440, modf=9;
	var ou;
	ou = SinOsc.ar( SinOsc.kr(modf)+1*freq)
	* EnvGen.kr(Env.linen(0.1,0.5,0.1), timeScale:sustain, doneAction:2);
	Out.ar(out, ou * amp)
}).store;
 
SynthDef("fm2", {
	var out=0, amp=1, sustain=0.5, freq=500, modf=200, modbpf=900;
	var ou;
	ou = SinOsc.ar( SinOsc.kr(modf)+1*freq)
	* EnvGen.kr(Env.linen(0.1,0.5,0.1), timeScale:sustain, doneAction:2);
	ou = BPF.ar(ou, SinOsc.kr(SinOsc.kr(1)+1*900)+1*freq);
}).store;
 
SynthDef("shh", {
	arg out=0, amp=1, sustain=0.5, freq=440, modf=9, noise=0.5;
	var ou;
	ou = WhiteNoise.ar(noise);
	ou = LPF.ar(ou, SinOsc.kr(modf)+1*freq)
	* EnvGen.kr(Env.perc(0.001,sustain), doneAction:2);
	Out.ar(out, ou * amp)
}).store;
SynthDef("kickTrig1", { arg levK=1, t_trig=0, sustain=0.125, f1=36.7, f2=73.4, amp=1, out=0;
	var kEnv, ou;
	var kickEnv;
	kickEnv = Env.linen(0.001, 1.9, 0.099, 1);
	kEnv=EnvGen.ar(kickEnv,1, doneAction:2, timeScale: sustain, levelScale: levK);
	ou =Pan2.ar(Decay2.kr(t_trig, 0.005, 0.45, 
	FSinOsc.ar(f1, 0.4)+FSinOsc.ar(f2, 0.2)),0);
 
	Out.ar(out, ou * kEnv * amp);
}).store;
SynthDef("snTrig1", { arg levSn=1, t_trig=0, sustain=0.125, panPos=0, amp=1,
	out=0;
	var snEnv, ou;
	var snareEnv;
	snareEnv = Env.linen(0.001, 1.9, 0.099, 1);
	snEnv=EnvGen.ar(snareEnv,1, doneAction:2, timeScale: sustain, levelScale: levSn);
	ou =Pan2.ar(Decay2.kr(t_trig, 0.005, 0.25, FSinOsc.ar(38.midicps, 0.3)+ 		BrownNoise.ar(0.4)),panPos);
 
	Out.ar(out, ou*snEnv * amp);
}).store;
)
 

(
TempoClock.default.tempo = 2;

~piou2 = Pbind(
	//\freq, Pseq([600*Pseg(Pseq([0.2,1.0],inf),Pseq([9.5],inf))],inf),
	\freq, Pstutter(4,Pseq([1,2,4,6,2,8],inf))*0200,
	\modf, Pstutter(4*2,Pseq([1,2,3,4,5,6],inf)),
 
	\amp, Pseq([
		Pn(0,8),
		Pseq([
			Pn(Pseq([1,0]),3),
			Pn(1,6),
			Pseq([1,0,1,1,0]),
		],inf)
	],inf)*0.4,
	//\dur, Ptrace(PdurStutter(Pseq([7,2],inf),Pseq([4,0.5],inf))),
	\dur, Pseq([Pn(4,8)],inf),
	//\legato, Pseq([Pseg(Pseq([0.2,1.0],inf),Pseq([9.5],inf))],inf),
	\sustain, Pseq([Pn(1.5,16),Pn(0.75,8),Pn(3.8,4)],inf),
	\instrument, "fm1"
);
~bass1 = Pbind(
	\octave, Pseq([4],inf),
	\degree, Pseq([
		Pseq([0,1],4*(16+8)),
		Pseq([0,1,5,9],2*16),
	],inf),
	\modf, Pstutter(4*4,Pseq([4,5,6]+2,inf))*10,
	\scale, [0,3,5,6,7,10],
 
	\amp, Pseq([
		Pseq([0,0,0,0,0,0,0,0],4),
		Pseq([1,0,0,0,1,0,0,0],6),
		Pseq([
			Pseq([1,1,1,1,1,1,1,1],6),
			Pseq([1,0,0,1,1,0,0,1],2),
			Pseq([1,0,1,0,1,0,1,0],2),
			Pseq([0,0,0,0,0,0,0,0],1),
		],inf)
	],inf)*0.6,
	\dur, Pseq([Pn(0.5,8)],inf),
	\sustain, Pseq([Pn(0.5,16+8),Pn(0.28,32)],inf),
	\instrument, "fm1"
);
~hihat = Pbind(
	\noise, 5,
	\freq, Pseq([100,210,300],inf)+100,
	\modf, Pstutter(4*4,Pseq([0.1,7,2,3,4,5,6],inf)),
	\amp, Pseq([
		Pseq([0,0,0,0,0,0,0,0],1),
		Pseq([0,0,1,0,0,0,1,0],1),
		Pseq([1,0,1,0,1,0,1,0],1),
	],inf)*0.8,
	\dur, Pseq([Pn(0.5/2,8)],inf),
	\sustain, Pseq([Pn(0.1,8*8),Pn(0.6,8),Pn(0.1,8*8),Pn(0.8,8)],inf),
	\instrument, "shh"
);
~kick = Pbind(
	\dur, 0.5/2,
	\levK, 5,
	\amp, Pseq([
		Pseq([
			Pseq([1,0,1,0,1,0,1,0],1),
			Pseq([1,0,0,0,0,0,0,0],1),
		],2),
		Pseq([
			Pseq([1,0,1,0,1,0,1,0],8),
			Pseq([1,1,1,1,0,0,0,0],1),
			Pseq([1,0,1,0,1,0,1,0],8),
			Pseq([1,0,0,0,0,0,0,0],1),
		],inf)
	],inf)*0.8,
	\instrument, "kickTrig1"
);
~snare = Pbind(
	\dur, 0.5/2,
	\levSn, 5,
	\amp, Pseq([
		Pseq([0,0,0,0,1,0,0,0],8),
		Pseq([0,0,0,0,1,0,1,0],1),
	],inf)*0.8,
	\instrument, "snTrig1"
);

Ppar([ ~bass1, ~kick, ~snare, ~hihat, ~piou2 ]).play;

)
