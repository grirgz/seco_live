~t = 135/4/60; TempoClock.default.tempo = ~t;

ProtoDef(\simpleMixer).play
(
	~master.();
Pdef(\capdrums, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 1.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,1, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,0,

				0,0,0,0, 0,0,1,0,
				0,1,0,0, 1,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,0,

				0,0,0,1, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 1,
			\speed, 1.2,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

				0,0,1,0, 0,0,1,1,
				0,0,0,0, 1,0,1,1,
				0,1,1,1, 0,0,1,0,
				1,0,0,0, 1,1,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,1,0,
				0,0,0,1, 1,0,1,0,
				0,0,0,0, 0,0,1,0,
				1,0,1,1, 1,0,1,1,
					
				],inf),
				0,0,0,1, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,0,

				0,0,0,0, 0,0,1,0,
				0,1,0,0, 1,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,0,

				0,0,0,1, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/16,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.9,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\hat) <> Pbind(
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
		Pdef(\bass) <> Pmono(\distbass,
			\freq, 70 * Pseq([0,1].midiratio,inf).stutter(16),
			\fmrange, Pseq([0.5,1,1.5],inf),
			\fmfreq, Pseq([0.5,1,2,4],inf),
			\dur, 1/4,
			\igate, Pseq([
				1,0,0,0,
				0,0,0,0,
			],inf),
			\iadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4.1) ],
			],inf),
			\lpf, Pkey(\freq) * Pseq([2,1,4,8],inf).stutter(8),
			\hpf, Pkey(\freq) / 2,

			\amp, Pkey(\amp) * 2,
			\isRest, false,
		),
		
	])
).play;
)

(
SynthDef(\distbass, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	freq = SinOsc.ar(freq*\fmfreq.kr(1).lag(0.3)) * \fmrange.kr(0.5).lag(0.3) * LFNoise1.kr(1/7).range(0.9,1.1) + 1 * freq;
	sig = SinOsc.ar(freq.lag(0.1) * [1,8,2,4,1.002]);
	sig1 = LFPulse.ar(freq * [1,4,1.001,2 * LFNoise1.kr(1/10).range(0.999,1.001),1/2], mul:1.00);
	sig = sig + sig1;
	sig = sig.fold2(SinOsc.kr(1/13).range(0.9,1));
	sig = sig.wrap2(SinOsc.kr(1/14).range(0.9,1));
	sig = RLPF.ar(sig, \lpf.kr(500).lag(0.4) * LFNoise1.kr(1/9).range(0.9,1.1), \rq.kr(0.5));
	sig = HPF.ar(sig, \hpf.kr(40));
	sig = sig * EnvGen.ar(\iadsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),\igate.kr(1),doneAction:0);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);


(
SynthDef(\dischord, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	freq = [0,1,2,3,4,5].midiratio * freq;
	freq = SinOsc.ar(freq*\fmfreq.kr(1).lag(0.3)) * \fmrange.kr(0.5).lag(0.3) * LFNoise1.kr(1/7).range(0.9,1.1) + 1 * freq;
	sig = SinOsc.ar(freq.lag(0.1) * [1,8,2,4,1.002]);
	sig1 = LFPulse.ar(freq * [1,4,1.001,2 * LFNoise1.kr(1/10).range(0.999,1.001),1/2], mul:1.00);
	sig = sig + sig1;
	sig = sig.fold2(SinOsc.kr(1/13).range(0.9,1));
	sig = sig.wrap2(SinOsc.kr(1/14).range(0.9,1));
	sig = RLPF.ar(sig, \lpf.kr(500).lag(0.4) * LFNoise1.kr(1/9).range(0.9,1.1), \rq.kr(0.5));
	sig = HPF.ar(sig, \hpf.kr(40));
	sig = sig * EnvGen.ar(\iadsr.kr(Env.adsr(0.01,0.1,0.8,1.1)),Trig.kr(\itrig.tr(1), \tsustain.kr(0.1)),doneAction:0);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	//sig = Splay.ar(sig, spread, amp, pan);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\dischord, Pdef(\pad) <> PmonoArtic(\dischord,
	\degree, Pseq([0],inf),
	\freq, Pseq([
		200,4000,5000,
	],inf),
	\itrig, 1,
	\lpf, 15000,
	\fmrange, 100,
	\hpf, ~pmodenv.(Pseq([40,11002],inf), Pseq([8,0],inf)),
	\fmfreq, Pseq([1/4004,1],inf),
	\tsustain, 4/~t,
	\legato, 1,
	\dur, 1,
	\amp, 0.1,
)).play;
);

(
Pdef(\dischord, Pdef(\pad) <> PmonoArtic(\dischord,
	\degree, Pseq([0],inf),
	\freq, Pseq([
		200,400,500,
	],inf),
	\itrig, 1,
	\lpf, 15000,
	\fmrange, 1,
	\hpf, ~pmodenv.(Pseq([40,1002],inf), Pseq([8,0],inf)),
	\fmfreq, Pseq([1/10],inf),
	\tsustain, 4/~t,
	\legato, 1,
	\dur, 1,
	\amp, 0.1,
)).play;
);

Pdef(\dischord).stop
quant	

Pdef.defaultQuant = 4;
Ndef.defaultQuant = 4;


(
	~master.();
Pdef(\capdrums, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,1, 0,1,1,0,
				1,1,1,0, 1,0,1,1,
				0,0,1,0, 0,1,1,0,
				0,1,0,0, 1,0,1,0,
				1,0,1,1, 0,1,1,0,
				1,1,1,0, 1,0,1,1,
			],inf).coin.not,
			\pos, Pseq([
				Pseg(Pseq([0.04,0.04,1],inf),Pseq([1,3,0],inf)),
			],inf),
			\sustain, 0.1,
			\dur, 1/16,
			\amp, 0.1,
		)),
		Pdef(\bass) <> Pbind(
			\instrument, \distbass,
			\freq, 70 * Pseq([
				2,5/4,4/3,1,
				2,5/4,4/3,1,
				2,5/4,4/3,1,
				2,5/4,4/3, Pwhite(1,3.0,1),
				Pser([
					\r
				],16),
			]+0.5,inf),
			\lag, Pseq([0,Pwhite(0.0,0.2,3)],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
).play;
)

(
)

(
Ndef(\pic, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig1 = Dust.ar(10 * SinOsc.kr(1/8).range(10,1/2));
	sig1 = Ringz.ar(sig1, rrand(100,10000.0!8) * LFNoise0.kr(1/2).range(1/4,1), 1.1).mean/2;
	sig2 = Dust.ar(7);
	sig2 = Ringz.ar(sig2, rrand(100,10000.0!8), 1.1).mean/2;
	sig = sig1 + sig2;
	sig = sig * EnvGen.kr(Env([0,0,1,0],[2/~t,0.1,2.8]), Impulse.kr(1/4*~t));
	sig = Pan2.ar(sig, pan, amp);
}).play(BusDef(\mixer4).index, 2);
);

(
Pdef(\capdrums, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.4,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				1,0,1,1, 0,1,1,0,
				1,1,1,0, 1,0,1,1,
				0,0,1,0, 0,1,1,0,
				0,1,0,0, 1,0,1,0,
				1,0,1,1, 0,1,1,0,
				1,1,1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1/8,
			\speed, 1 * Pwhite(1/2,2.1),
			\dur, 1/16,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\hat) <> Pbind(
			\kitIndex, 9,
			\isRest, Pseq([
				0.51,1
			],inf).coin.not,
			\sustain, 0.1/8,
			\gain, 2,
			\speed, 1 * Pwhite(1/2,2.1),
			\dur, 1/16,
			\amp, 0.1,
		)),
		Pdef(\bass) <> Pbind(
			\instrument, \distbass,
			\freq, 70 * Pseq([
				2,5/4,4/3,1,
				2,5/4,4/3,1,
				2,5/4,4/3,1,
				2,5/4,4/3, Pwhite(1,3.0,1),
				Pser([
					\r
				],16),
			]+0.5,inf),
			\lag, Pseq([0,Pwhite(0.0,0.2,3)],inf),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
).play;
)
