


(
~t = 185/4/60; TempoClock.default.tempo = ~t;
SynthDef(\blik, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * XLine.kr(1,4,8) * ( 1 + ( SinOsc.kr(1/21 * (1..8)) * SinOsc.kr(2*~t).range(0,0.1) )));
	sig = RLPF.ar(sig, \lpf.kr(5400) * SinOsc.kr((1..8)/8*0.1 * ( 1 + ( SinOsc.kr(1/9 * (1..8)/8) * 1 ))).range(4,1), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	pan = pan + SinOsc.ar((1..8) * ( 1 + ( SinOsc.kr(1/3) * 1 )), mul:0.3);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\blik2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * ( 1 + ( SinOsc.kr(1/21 * (1..8)) * SinOsc.kr(\fmampfmf.kr(1)).range(0,\fmampmax.kr(1)) * XLine.kr(0.001,1,\clean.kr(1)) )));
	sig = RLPF.ar(sig, \lpf.kr(5400) * SinOsc.kr((1..8)/8*0.1 * ( 1 + ( SinOsc.kr(1/9 * (1..8)/8) * 1 ))).range(4,1), \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,3.1)),gate,doneAction:2);
	pan = pan + SinOsc.ar((1..8) * ( 1 + ( SinOsc.kr(1/3) * 1 )), mul:0.3);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\blik, Pbind(
	\instrument, \blik,
	\octave, 3,
	\degree, 0,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\legato, 8.59,
	\dur, 1,
	\amp, 0.1/2,
));
Pdef(\blikp1,
		Pbind(
			\instrument, \blik2,
			\clean, Pexprand(0.2,2),
			\octave, Prand([3,4,5],inf),
			\degree, Pseq([
				[0,2,4], [0,2,4],
				[5,7,9], [5,7,9],
			],inf),
			\isRest, Pseq({[
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,1,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\lpf, Pexprand(100,1000),
			\fmampmax, Pwhite(0.01,0.8),
			\fmampfmf, Pwhite(0.01,100),
			\legato, Pwhite(1,9),
			\dur, 1/4,
			\amp, 0.1/2,
		)
);

Pdef(\blikp2,
	Pbind(
		\dur, 1/2,
	)
	<> Pdef(\blikp1)
);

Pdef(\blikmain, 
	Pseq([
		Pfindur(8,Pdef(\blik)),
		Pfindur(32,Ppar([
			Pdef(\blikp1),
			Pdef(\blikp2),
		].collect({ arg p; Pbind(\dur, 1, \clean, 8) <> p }))),
		Pfindur(32,Ppar([
			Pdef(\blikp1),
			Pdef(\blikp2),
		].collect({ arg p; Pbind() <> p }))),
		Pfindur(16,Ppar([
			Pdef(\blikp1),
			Pdef(\blikp2),
		].collect({ arg p; Pbind(\dur, 1/8, \legato, 00.1) <> p }))),
		Pfindur(16,Ppar([
			Pdef(\blikp1),
			Pdef(\blikp2),
		].collect({ arg p; Pbind(
			\octave, 4,
			\adsr, [ Env.adsr(0.01,0.1,0.8,0.1) ],
			\sustain, Pseq([
				Pseq((1..64).reverse/128,1),
				Pn(1/2,inf)
			],inf),
			\dur, 1/8, \isRest, Pseq([1,1,0,1],inf), \clean, 8, \legato, 00.1) <> p }))),
		Pfindur(16,Ppar([
			Pdef(\blikp1),
			Pdef(\blikp2),
		].collect({ arg p; Pbind(
			\octave, 4,
			\note, Pseq((1..32),inf).stutter(4),
			\adsr, [ Env.adsr(0.01,0.1,0.8,0.1) ],
			\sustain, Pseq([
				Pseq((1..64).mirror/62,1),
				Pn(1/2,inf)
			],inf),
			\dur, 1/8, \isRest, Pseq([1,1,0,1],inf), \clean, Pseq((1..12)/10,inf), \legato, 00.1) <> p }))),
		
	],2)
).play;
);
