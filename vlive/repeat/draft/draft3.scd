
////////////////////////////////////////////////////////////
// transitions!!!
// TODO


(
Pdef(\plop, Pbind(
	\instrument, \,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);

(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);

Pdef(\main, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
			\amp, Pkey(\amp) * Pseq([
				0.3,0.5,1,0.5,
			],inf),
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\speed, -1,
			\pos, 0.2,
			\sustain, 0.1,
			\amp, 0.1,
			\amp, Pkey(\amp) * Pseq([
				0.3,0.5,1,0.5,
			],inf),
			\dur, 1/8,
		))
	])
).play;



/////////////////////////////////////////////////////////////////// prodigy
/// chords

~t = 74/2/60; TempoClock.default.tempo = ~t;

(
SynthDef(\pchord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0.401,0.002,2],[1.1,2.8]), 1);
	env2 = EnvGen.kr(Env([0.001,2.002,2],[2.1,2.8]), 1);
	sig = LFSaw.ar(freq * ( LFNoise1.kr((1..16)/( 100*env2 ))/( 300*env1 ) +[[1,1.0001]] )).mean;
	sig = RHPF.ar(sig, 800);

	sig = sig + SinOsc.ar(freq * ( LFNoise1.kr((1..16)/( 100*env2 ))/( 300*env1 ) +[[1,1.0001]] ) ).mean;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,1.7),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * amp / 2;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\plead, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\plead, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfr.kr(4)*freq, \rq.kr(0.1))/18;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\chords, Pbind(
	\instrument, \pchord,
	\degree, Pseq([ 
		[-2,0,3],
		[-2,1,3s],
		[-1,2,4s],
		[0,3,5],
		[1,4,6],
	],inf),
	\dur, PdurStutter(Pseq([1,1,1,2],inf),2),
	\amp, 0.1/3,
)).play;
);



(
Pdef(\lead, Pbind(
	\instrument, \plead,
	\legato, Pseq([
		Pser([0.71],14),
		Pser([2],2),
	],inf),
	\degree, Pseq([
		2b,2,
		2b,2,
		2b,2,
		5b,5,

		5b,5,
		5b,5,
		5b,2,
		2,\rest,

	],inf),
	\dur, 1/8,
	\amp, 0.1
)).play;
);


BufDef.loadDialog(\scrat)
BufDef.loadDialog(\scrat2)
(
SynthDef(\scrat, { arg out=0, freq=200, pan=0, amp=0.1, bufnum=0, gate=1;
	var sig;
	var phase;
	//phase = Phasor.ar(Impulse.kr(\trigrate.kr(1/2*~t)), \rate.kr(1),\start.kr(0),\end.kr(1)*BufFrames.kr(bufnum)).lag(\phaselag.kr(0.4));
	//phase = EnvGen.kr(Env([0,1,0]*,[0.1,0.8]), 1);
	phase = LFTri.ar(\pfreq.kr(1)*1/2, -1).range(\start.kr(0),\start.kr +(  1/\pfreq.kr/BufDur.kr(bufnum) )) * BufFrames.kr(bufnum); 
	sig = BufRd.ar(2, bufnum, phase*\sign.kr(1));
	//sig = RLPF.ar(sig, \lpfr.kr(1) * \trigrate.kr * SinOsc.ar(1 * [ [1,1/2,1/4,1/14] ]).range(1/2,4) , \rq.kr(0.5)).flop.mean;
	sig.debug("sig");
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.kr(\asr.kr(Env.asr(0.01,1,0.01)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\scrat, Pbind(
	\instrument, \scrat,
	\degree, Pseq([0],inf),
	\trigrate, 1/1,
	\pfreq,4/1*~t,
	\start, 0.04+0.01,
	//\sustain, 0.1,
	\bufnum, BufDef(\scrat2),
	\dur, 1,
	\amp, 0.1,
)).play;
);
BufDef(\scrat).play
BufDef(\scrat2).play

WindowDef(\PdefEditor).front(Pdef(\scrat))
Param(Pdef(\scrat), \bufnum).type

{ LFTri.ar(200, -1 ) ! 2 * 0.1}.plot;


///////////////////////////////////////////////////////
