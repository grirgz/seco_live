
//////////////////////////

--- Pbind default arguments
legato/sustain
dur/stretch/delta
freq/detune/degree/note/midinote
octave/root/mtranspose
common bugs : reuse sustain, Ndef in freq, 

multichannel

Pkey

Pseq
Pseg
Ndef modulation
Ndef gui editing
common bugs : reuse sustain, Ndef in freq, 

array param
env param

Pindex

<> Pchain
Ppar

Pfunc
Prout
Plazy

.loop
isRest
.coin.not

Ndef as fx

granular


(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, ffreq=2000, rq=0.2;
	var sig;
	sig = LFSaw.ar(freq * [1,0.9,2,0.7]);
	sig = RLPF.ar(sig, ffreq, rq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\a, Pbind(
	\instrument, \plop,
	\degree, Pseq([0,2,4,2],inf),
	\root, [-8,7],
	\ffreq, Pseq([4100,3000],inf).stutter(8),
	\ffreq, Pseg(Pseq([100,3000],inf),1),
	\ffreq, [
		Ndef(\plop, { SinOsc.kr(1).range(100,4100) }),
		Ndef(\plop2, { LFSaw.kr(1/2).range(4100,8100) }),
		Ndef(\plop3, { arg val=2000; val }),
	],
	\legato, [1,0.3],
	\isRest, Pseq([
		1,0,1,0,
		1,0,0,0,
	],inf).coin.not,
	\dur, 1/8,

))
)


(
	~make_ctl = { arg name;
		var window, button, slider;
		window = Window.new;
		button = Button.new;
		slider = Slider.new;
		Button.states = [


		]

	}
)

Pdef(\a).play
Ndef(\plop3).edit


1200
Scale.major.ratios
(
Pdef(\a, Pbind(
	\instrument, \granu,
	\mbufnum, ~buf,
	\degree, Pseq([0,2,4,2],inf),
	\time_stretch, 0,
	\pitch_stretch, 1/2 + Pwhite(0.0,0.1),
	\pitch_stretch, 1 * Pindex(Scale.major.ratios,Pseq([0,2,4,2],inf)),
	\release, 0.05,
	\grainrate, 100,
	\graindur, 0.05,
	\pos, 0.2,
	\amp, 1.8,
	\legato, 1,
	\dur, 1/4,

))
)

(
Pdef(\a, Pbind(
	\instrument, \granu,
	\mbufnum, ~buf,
	\time_stretch, Pseg(Pseq([0,1],inf),2),
	\pitch_stretch, Pseq([1/2,1,2,3],inf),
	\release, 0.05,
	\grainrate, 100,
	\graindur, 1,
	\pos, Pseq([0.1,0.3],inf) + Pwhite(0.0,0.4).stutter(8),
	\amp, 1.8,
	\legato, 1,
	\dur, 1/4,

))
)
Pdef(\a).play

	\instrument, Pseq([\granu,\granu2],inf).stutter(2),
