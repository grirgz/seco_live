
(
SynthDef(\shifty, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = LFSaw.ar([200,5000,4300] * XLine.kr(1,1.1,0.1));
	sig = RLPF.ar(sig, \lpfr.kr(3.1) * 5000, \rq.kr(0.5));
	sig = sig.sum/2;
	sig = sig * EnvGen.kr(\env.kr(Env([0,1,0.4,0],[0.01,0.4,0.1].normalizeSum)), gate);
	sig1 = WhiteNoise.ar;
	sig = sig1;
	sig1 = BPF.ar(sig, [20,70,73] * XLine.kr(4,0.1,0.01)).sum;
	sig = SinOsc.ar(XLine.ar(400,180,0.01)) * EnvGen.kr(Env([0,1,0],[0.001,0.08]), 1);
	sig = Ringz.ar(sig, [520,490,243],3.4) / 40;
	//sig = sig + sig1;
	//sig = sig1;
	sig = FreqShift.ar(sig, 210 * [1.1,1.6542,1.3]);
	sig = FreqShift.ar(sig, 220 * [1,1.2,0.7543]) + sig/2;
	sig = FreqShift.ar(sig, -350 * [1.123,1.2,1.3]);
	sig = AllpassC.ar(sig, 0.1,0.0001,0)+sig;
	sig = AllpassC.ar(sig, 0.1,0.0012,0)+sig;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4,1,-8),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\shifty, Pbind(
	\instrument, \shifty,
	\degree, Pseq([0],inf),
	\legato, 0.1,
	\dur, 1,
	\amp, 0.1,
)).play;
);


///////////////////


(
	~t = 185/4/60; TempoClock.default.tempo = ~t;
Pdef(\sdrums, 
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
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
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
		)),
		
	])
).play;
)


(
~buf = BufDef(\crepe, "field/crepe.flac");
Pdef(\racle, 
	Pbind(
		\instrument, \oscsampler3,
		\pos, 0.014 + Pseq([0,1,0,2],inf).stutter(8)/100,
		\pos, 0.110,
		\freq, Pseq([100,200,150,200]*4,inf) * Pseg(Pseq([0.25,2],inf),10),
		\freq, 10000,
		\range, 0.000001,
		\posenv, Pseq([
			//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
			//[ Env([0.00,0.0189,0.401].integrate.postln,[0.01,0.1]) ],
			//[ Env([0.00,0.0011,0.0012].integrate.postln,[0.01,0.1]) ],
			//[ Env([0.00,0.0001,0.0012].integrate.postln,[0.01,0.1]) ],
			[ Env([0.00,0.0001,0.0132].integrate.postln,[0.01,0.2]) ],
			[ Env([0.00,0.0001,0.0012].integrate.postln,[0.01,0.1]) ],
			//[ Env([0.00,0.0001,0.0012].integrate.postln,[0.01,0.1]) ],
		],inf),
		//\finepos, ~envNdefq.(~name+++\lfo1, Env([1,2]/100,1/t)),
		\legato, Pseq([3.8],inf) * Pseg(Pseq([0.5],inf),8),
		\dur, 1/8,
		\fshift, 0,
		\lpmix, Pseq([0,0,0.56,1, 0,1,0,1, 0.2,0.5,0.7,0.2],inf),
		\lpmix, 0,
		\isRest, false,
		\ffreq, Pseq([4000,8500],inf).stutter(1),
		\amp, 24.0 * Pkey(\amp),
		\isRest, Pseq([
			0,1,0,1, 0,1,0,1,
		],inf).coin.not,
		\amp, Pkey(\amp) * Pseq([
			0.5,0.2,1,0.2,
			0.7,0.4,1,0.2,
		],inf) + Pwhite(0.0,0.1),

	) <>
	
	Pbind(
		\pos, Pseq([0.0,0.01,0.02,0.03],inf),
		\pos, Pseg(Pseq([0,0.1],inf),32)+0.8,
		\pos, 0.172,
		\posenv, Pseq([
			//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
			[ Env([0.001,0.002,0.004].integrate.postln,[0.01,0.1]) ],
			[ Env([0.001,0.003,0.004].integrate.postln,[0.01,0.1]) ],
			[ Env([0.101,0.0013,0.004].integrate.postln,[0.01,0.1]) ],
		],inf),
		\fshift, 0,
		\fshift, -48,
		\fshift, Pseq([0,48,-40],inf),
		\lpmix, 0.79,
		\rq, 0.1,
		\posenv, Pseq([
			//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
			[ Env([0.001,0.0089,-0.3481].integrate.postln,[0.01,0.1]) ],
		],inf),
		//\pos, Ndef(~name+++\lfo1),
		//\pos, Pseq([0,0.1,0.5],inf) + Pwhite(0,0.01),
		//\finepos, Ndef(~name+++\lfo1),
		//\range, Pseg(Pseq([0.001,0.21],inf),8),
		//\range, Ndef(~name+++\lfo2),
		\range, 0.0001,
		\ffreq, Pseq([100,300,200,200],inf),
		\ffreq, Pseq([60,1000,3000,200,2000],inf),
		\ffreq, Pseq([60,70,100,120],inf),
		\ffreq, Pseq([3000,120],inf),
		\ffreq, Pseq([6000,4000,120,300],inf),
		\ffreq, Pwhite(50,10000).stutter(16),
		//\ffreq, 2000,
		\bufnum, ~buf,
		\freq, Pseq([
			Pser([50,55],16),
			Pser([40,45],16-4),
			100,1040,120,300,
		],inf),
		\ffreqtab, Pseq([[Array.series(8,0.5,0.1).postln]],inf),
		\ffreqtab, Pn(Plazy({
			[{ 1.rand } ! 8]
		})),
		\ffreqtab, Pseq([[Array.geom(8,1.8,1.2).postln]],inf),
		\ffreqtab, Pseq([
			[[2.3,3.2,0.1,0.1, 0.2,0.8,1.2,1.5]],
		],inf),
		\dur, 1/8,
		\pos, Pwhite(0.0,0.4).stutter(32),
		\pos, Pseq([0.1,0.1],inf).stutter(2),
		\adsr, Pseq([
			[ Env.adsr(0.01,0.3,0.5,0.01) ],
		],inf),
		\isRest, Pseq([1],inf).coin.not,
		\isRest, Pseq([
			Pser([1],1),
			Pser([0,0,0,0],4),
		],inf).coin.not,
		\legato, Pseq([1,0.4,1,0.3, Pn(1,4)],inf),
		\legato, Pseq([
			Pser([1,1,1,1],32-4),
			0.6,1.0,1.0,0.6
		],inf),
		\legato, Pseq([
			1,0.2,0.1,0.2,
			1,1,1,1,

			1,0.2,0.1,0.2,
			1,1,1,1,

			1,0.5,1,1,
			1,1,1,1,
		],inf),
		\legato, Pseq([
			Pser([
				1.0,1.3,0.9,0.8,
				1.0,0.3,0.9,0.3,
			], 64),
			Pser([1,1,1,1],32),
			Pser([1,0.31,1,1],32),
		],inf).collect({ arg x; if(x == 1) { 1 } { if(x.coin) { 1 } { x.rand + 0.1 } } }),
		\legato, Pseq([
			1,1,1,1,
			1,1,1,0.1,
		],inf).stutter(4),
		//\lag, Pseq([0.05, 0, 0.05, 0],inf) / t,
		\isRest, false,
	)
).play;
)
