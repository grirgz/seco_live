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
SynthDef(\cloche, { arg out=0, gate=1, freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig1 = Dust.ar(10 * SinOsc.kr(1/8).range(10,1/2));
	sig1 = Ringz.ar(sig1, Rand(100,10000.0!8) * LFNoise0.kr(1/2).range(1/4,1), 1.1).mean/2;
	sig2 = Dust.ar(7);
	sig2 = Ringz.ar(sig2, Rand(100,10000.0!8), 1.1).mean/2;
	sig = sig1 + sig2;
	sig = sig * EnvGen.kr(Env([0,1,0],[0.1,2.8]), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

(
	~master.();
Pdef(\track1_idea, 
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
				],4),
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

				],1),
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
		Pdef(\pad) <> PmonoArtic( \cloche,
			\legato, Pseq([
				Pser([
					1,
				],7), 0.8,
			],inf),
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
			\isRest, true,
		),
		Pdef(\pad) <> Pbind(
			//\freq, 100,
			\instrument, \chordb,
			\amp, 0.1/2,
			\degree, Pseq([
				Prand([0,1,-2,0]),
				Prand([0,1,-2,0])+8,
			],inf) + Ptuple([0,Pseq([2,4],inf)]),
			\freq, 70 * Pseq([0,1].midiratio,inf).stutter(16) * 8 * Ptuple([0,Pseq([2b,4],inf)]).midiratio,
			\lpffac, Ndef(\lfo1, { CuspN.ar(1/7).range(0.50,4)  }),
			\adsr, Prand([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.001,0.1,0.8,1.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.001) ],
				[ Env.adsr(1.1,0.1,0.8,0.1) ],
			],inf).stutter(4),
			\scale, Scale.minor,
			\octave, 5,
			\dur, 1/4,
			\legato, Pseq([
				Pser([
					4,2,1,1,
				],4*8*4),
				Pser([
					1,2,1,1,
				],4*8*4)/4,
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,1,0, 1,1,0,0,
				Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,0,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,0,1,1,
				],3),
			],inf).coin.not,
),
		
	])
).play;
)

(
SynthDef(\chordb, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = {arg x; 
		var isig;
		var ffac = 8;
		isig = LFSaw.ar( freq/2 * x + ExpRand(freq/64,2*freq/64));
		isig = isig + LFPulse.ar( freq/ffac * x + ExpRand(freq/64/ffac,2*freq/64/ffac));

		isig = RLPF.ar(isig, freq/2 * x + ExpRand(freq/64,2*freq/64)* LFNoise1.kr(1/4).range(1.1,1) * \lpffac.kr(2) , \rq.kr(0.5));
	}!5;
	sig = sig.scramble;
	sig = TScramble.ar(sig, Impulse.kr(4),1);
	//sig = FreqShift.ar(sig, 4 * SinOsc.kr(1/45).range(0,1)) + sig;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan) / 7;
	Out.ar(out, sig);
}).add;

~master.();
Pdef(\chordb, Pdef(\pad) <> Pbind(
	//\freq, 100,
	\instrument, \chordb,
	\amp, 0.1,
	\degree, Pseq([
		Prand([0,1,-2,0]),
		Prand([0,1,-2,0])+8,
	],inf) + Ptuple([0,Pseq([2,4],inf)]),
	\freq, 70 * Pseq([0,1].midiratio,inf).stutter(16) * 8 * Ptuple([0,Pseq([2b,4],inf)]).midiratio,
	\lpffac, Ndef(\lfo1, { CuspN.ar(1/7).range(0.50,4)  }),
	\adsr, Prand([
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
		[ Env.adsr(0.001,0.1,0.8,1.1) ],
		[ Env.adsr(0.1,0.1,0.8,0.001) ],
		[ Env.adsr(1.1,0.1,0.8,0.1) ],
	],inf).stutter(4),
	\scale, Scale.minor,
	\octave, 5,
	\dur, 1/4,
	\legato, Pseq([
		4,2,1,1,
	],inf),
	\isRest, false,
)).play;
)


ProtoDef(\rdn).presetCompileString.editorInsert
(
RandDelayNetwork('del3').make('rdn', "4-JIHM-RN78");
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 1,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'delay3', 0.0001,
	'distamp', 1.5846456692913,
	'distamp2', 3.9466141732283,
	'distamp3', 3.9466141732283,
	'shift', -5.0,
	'shift2', -1.1344537815126,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'brffac', 0.60195390291997,
	'brfrqfac', 0.37940593233798,
	'stereo', 0.0,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

(
	~master.();
Pdef(\track1_idea, 
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
		Pbind(
			\instrument, Pseq([\playersec_fx, \playersec],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				4,
				2,
			],inf).stutter(8),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\speed, 2.2,
			\legato, Pseq([
				Pser([
					8.2,
				],8*2)*3,
			],inf),
			\gain, 0.6,
			\dur, 1/8,
			\amp, 0.1,
		),
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
				],4),
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

				],1),
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
			\freq, 70 * Pstep(Pseq([0,1].midiratio,inf),4),
			\fmrange, Pseq([0.5,1,1.5],inf).stutter(8),
			\fmfreq, Pseq([0.5,1,2,4],inf).stutter(8),
			\dur, 1/16,
			\igate, Pseq([
				1,1,1,1, 0,0,1,0,
				1,0,0,1, 0,0,1,0,
				1,1,0,1, 0,0,1,1,
				0,0,0,0, 1,0,1,0,

				1,0,1,0, 1,1,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,0, 1,1,1,0,
				1,0,1,0, 1,1,1,0,

				1,1,1,1, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,1,0,0,

				1,1,1,0, 1,1,1,0,
				1,1,1,1, 0,0,1,1,
				1,0,1,0, 1,1,1,0,
				1,0,1,1, 1,0,0,1,
			],inf),
			\iadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\lpf, Pkey(\freq) * Pseq([8,6,7,5],inf).stutter(4),
			\hpf, Pkey(\freq) / 2,

			\amp, Pkey(\amp) * 2,
			\isRest, false,
		),
		Pdef(\pad) <> PmonoArtic( \cloche,
			\legato, Pseq([
				Pser([
					1,
				],7), 0.8,
			],inf),
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
			\isRest, true,
		),
		Pdef(\pad) <> Pbind(
			//\freq, 100,
			\instrument, \chordb,
			\amp, 0.1/2,
			\degree, Pseq([
				Prand([0,1,-2,0]),
				Prand([0,1,-2,0])+8,
			],inf) + Ptuple([0,Pseq([2,4],inf)]),
			\freq, 70 * Pseq([0,1].midiratio,inf).stutter(16) * 8 * Ptuple([0,Pseq([2b,4],inf)]).midiratio,
			\lpffac, Ndef(\lfo1, { CuspN.ar(1/7).range(0.50,4)  }),
			\adsr, Prand([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.001,0.1,0.8,1.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.001) ],
				[ Env.adsr(1.1,0.1,0.8,0.1) ],
			],inf).stutter(4),
			\scale, Scale.minor,
			\octave, 5,
			\dur, 1/4,
			\legato, Pseq([
				Pser([
					4,2,1,1,
				],4*8*4),
				Pser([
					1,2,1,1,
				],4*8*4)/4,
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,1,0, 1,1,0,0,
				Pseq([
					0,1,1,1, 0,1,1,1,
					0,1,0,1, 0,1,1,1,
					0,1,1,1, 0,1,1,1,
					0,1,1,1, 0,0,1,1,
				],3),
			],inf).coin.not,
),
		
	])
).play;
)
