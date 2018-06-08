
~t = 185/4/60; TempoClock.default.tempo = ~t;
(
SynthDef(\fxnimp, { arg out=0, gate=1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	env1 = EnvGen.kr(Env([1,2,1/2],[0.1,8.8]), \trig1.tr(0));
	env2 = EnvGen.kr(Env([0,1/2,2],[0.1,3.8],3), \trig2.tr(0));
	env3 = EnvGen.kr(Env([0,1/2,2],[0.1,3.8],3), \trig3.tr(0));
	env4 = EnvGen.kr(Env([0,1/2,2],[0.1,8.8],3), \trig4.tr(0));
	sig = in;
	sig = sig * SinOsc.ar(300 * env1);
	sig = sig + FreqShift.ar(sig, [-123,1233,432]*env4, mul:env2).mean;
	sig = CombL.ar(sig, 0.2 * SinOsc.ar(100 * env4).range(0,1),2)*env3.poll+sig;
	sig = Splay.ar(sig, 1, 1, SinOsc.kr((1..8)/7)).mean.debug("x");
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\tere, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * ( LFNoise1.ar({ 0.1.rand }!10 * LFNoise1.ar({ 10.0.rand }!10)) * 1 + 1 ));
	sig = sig + SinOsc.ar(freq * ( LFNoise1.ar({ 0.1.rand }!10 * LFNoise1.ar({ 10.0.rand }!10)) * 1 + 1 ));
	sig = RLPF.ar(sig, \lpfr.kr(2) * freq * ( LFNoise1.ar(0.1.rand!10) * 1 + 1 ), \rq.kr(0.5));
	sig = sig * 4;
	pan = pan + LFNoise1.ar(1!10);
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\noisybass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(0.4);
	env1 = EnvGen.kr(Env([0,0,7000,0],[0.01,0.4,0.8]), \trigx.tr(1));
	env2 = EnvGen.kr(Env([0,0,1,0],[0.01,0.2,1.4]), \trigx.tr(1));
	env3 = EnvGen.kr(Env([1,1,0,0],[0.01,0.4,1.8]), \trigx.tr(1));
	sig = Pulse.ar(freq * [1,1.0001]);
	//sig = sig * ( SinOsc.ar(freq) + 1  );
	sig1 = ( SinOsc.ar(freq) + 1  );
	sig1 = SelectX.ar(env2, [DC.ar(1), sig1]);
	sig = sig * sig1;
	sig = LPF.ar(sig, \lpfr.kr(8.1) * freq);

	sig1 = SinOsc.ar(2*~t).exprange(0.1,1);
	sig1 = SelectX.ar(env2, [DC.ar(1), sig1]);
	sig = sig/4 + LPF.ar(sig.fold2( sig1 ), 10000);

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \tere,
			\note, Pstep(Pseq([
				1,2,7,6,
				0,3,7,6,
			],inf),1/4),
			\legato, Pseq([
				1,1,141,
			],1)/4,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 7,
			\dur, 1/4 * (1 + (0.06 * Pseq([1,-1],inf))),
			\dur, 1/9,
			\dur, Pseq([
				1/2,
			],inf),
			\amp, 0.1/2,
			\out, BusDef(\mix1, \audio),
		),
		Pmono(\fxnimp,
			\inbus, BusDef(\mix1),
			\trig1, Pseq([
				0,0,0,0, 1, Pn(0,inf),
			],inf),
			\trig2, Pseq([
				0,0,0, 1,Pn(0,inf),
			],inf),
			\trig3, Pseq([
				0,0,0,0,0, 1,Pn(0,inf),
			],inf),
			\trig4, Pseq([
				0,0,0,0,0,0, 1,Pn(0,inf),
			],inf),
			\dur, 1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				1,0,
			],inf),
			\legato, 0.2,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \tere,
			\note, Pstep(Pseq([
				1,2,7,6,
				0,3,7,6,
			],inf),1/4),
			\legato, Pseq([
				1,1,1,1, 8,0,1,0,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,1,
				0,1,1,1, 0,1,1,1,
			],inf)/4,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 7,
			\dur, 1/4 * (1 + (0.06 * Pseq([1,-1],inf))),
			\dur, 1/9,
			\dur, Pseq([
				1/2,
			],inf),
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \default,
			\note, Pstep(Pseq([
				1,2,7,6,
				0,3,7,6,
			],inf),1/4),
			\legato, Pseq([
				1,1,1,1, 8,0,1,0,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,1,
				0,1,1,1, 0,1,1,1,
			],inf)/4,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/4 * (1 + (0.06 * Pseq([1,-1],inf))),
			\dur, 1/9,
			\dur, Pseq([
				1/4,
				1/4,
				1/4,
				1/4,
				1/4,
				1/3,
				1/3,
				1/6,
				1/5,
			],inf),
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \noisybass,
			\note, Pstep(Pseq([
				1,2,7,6,
				0,3,7,6,
			],inf),1/4),
			\legato, Pseq([
				1,1,1,1, 8,0,1,0,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,1,
				0,1,1,1, 0,1,1,1,
			],inf)/4,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/4 * (1 + (0.06 * Pseq([1,-1],inf))),
			\dur, 1/9,
			\dur, Pseq([
				1/4,1/7,
			],inf),
			\amp, 0.1,
		),
	])
)).play;
)

(
SynthDef(\petitnoise, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq= EnvGen.kr(\freqenv.kr(Env([8000,2000,10000],[0.1,0.8])), 1);
	sig = LFNoise1.ar(freq) + WhiteNoise.ar;
	sig = SinOsc.ar(freq * ( sig + 1 )) * sig; 
	sig = HPF.ar(sig, freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \petitnoise,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1/2,
	)
).play;
);

Pdef(\part).clear;

(
Pdef(\part, Pdef(\part_note, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				1,0,
			],inf),
			\legato, 0.2,
			\dur, Pn(1,3),
			\amp, 0.1,
		),
	Pbind(
		\instrument, \petitnoise,
		\freqenv, [Env([8000,2000,10000],[0.1,4.8])],
		\adsr, Pseq([
			[ Env.adsr(1.1,0.1,0.8,0.01) ],
		],inf),
		\dur, Pseq([Rest(12), 4],inf),
		\legato, 1,
		\amp, 0.1,
	),
		Pbind(
			\instrument, \tere,
			\note, Pstep(Pseq([
				1,2,7,6,
				0,3,7,6,
			],inf),1/4),
			\legato, Pseq([
				1/4,1/4,15*2,
			],1),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 7,
			\dur, 1/4 * (1 + (0.06 * Pseq([1,-1],inf))),
			\dur, 1/9,
			\dur, Pseq([
				1/2,
			],inf),
			\amp, 0.1/2,
			\out, BusDef(\mix1, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\mix1),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send1, ~pmodenv.(Pseq([0,0,0.2,1],inf), 4),
			\sendbus1, BusDef(\sendbus1, \audio, 2),
			\dur, 1,
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.01,
			'gain', 2,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay2', ~pmodenv.(Pseq([0.0001,0.2,1,0.004],inf), 4),
			'delay3', 0.2000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 2.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
		Pmono(\fxnimp,
			\inbus, BusDef(\sendbus1),
			\trig1, Pseq([
				0,0,0,0, 1, Pn(0,inf),
			],inf),
			\trig2, Pseq([
				0,0,0, 1,Pn(0,inf),
			],inf),
			\trig3, Pseq([
				0,0,0,0,0, 1,Pn(0,inf),
			],inf),
			\trig4, Pseq([
				0,0,0,0,0,0, 1,Pn(0,inf),
			],inf),
			\dur, 1,
		),
		Pbind(
			\instrument, \default,
			\note, Pstep(Pseq([
				1,2,7,6,
				0,3,7,6,
			],inf),1/4),
			\legato, Pseq([
				1,1,1,1, 8,0,1,0,
				1,0,0,0, 0,0,0,0,
				36,0,0,0, 0,0,0,0,
			],1)/4,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/4 * (1 + (0.06 * Pseq([1,-1],inf))),
			\dur, 1/9,
			\dur, Pseq([
				1/4,
				1/4,
				1/4,
				1/4,
				1/4,
				1/3,
				1/3,
				1/6,
				1/5,
			],inf),
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \noisybass,
			\note, Pstep(Pseq([
				1,2,7,6,
				0,3,7,6,
			],inf),1/4),
			\legato, Pseq([
				1,1,1,1, 8,0,0,0,
				0,0,0,0, 0,0,0,0,
			],1)/4,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/4 * (1 + (0.06 * Pseq([1,-1],inf))),
			\dur, 1/9,
			\dur, Pseq([
				1/4,1/7,
			],inf),
			\amp, 0.1,
		),
	])
)).play;
)


(
Pdef(\part, Pdef(\part_boom, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],1).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],1).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
		]),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\sendbus1),
			\out, BusDef(\sendbus2, \audio),
			\addAction, \addToTail,
			\lag, 0.0004,
			\room, 1,
			\dur, 1,
		),
		Pmono(\rdnroom,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\dur, 1/2,
			'wet10', 1.0,
			'mix', 0.41,
			'mix', ~pmodenv.(Pseq([0,0.2,1,4],inf), Pseq([0.01,8,8])),
			'gain', 1/4,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', Pseq([
				Pn(0.1,1),
				Pn(0.00001001,inf)
			],inf),
			\delay2, ~pmodenv.(Pseq([0.1,0.0002,0.00021,0.00001],inf), Pseq([0.04,8,8])),
			'delay3', 0.0000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 2.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.1714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.003600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(16+( 1/2 ), Pdef(\part_note)),
		Pfindur(16, Pdef(\part_boom)),
		Pfindur(32, Pdef(\part_boom2)),
		Pfindur(32, Pdef(\part_boom3)),
	])
)).play;
)

(
Pdef(\part, Pdef(\part_boom2, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],1).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],1).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \noisybass,
				\freq, ~pmodsynth.({ 77+Duty.kr(Dwhite(0.1,2), 0, Dseq([
					1,-1,Dwhite(-13,19.0,1),0,0,0.1,0,
				],inf)) }),
				\dur, Pseq([Rest(8),8,Rest(1),8]),
				\amp, 0.1/44,
			),
		]),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\sendbus1),
			\out, BusDef(\sendbus2, \audio),
			\addAction, \addToTail,
			\lag, 0.0004,
			\room, 1,
			\dur, 1,
		),
		Pmono(\rdnroom,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\dur, 1/2,
			'wet10', 1.0,
			'mix', 0.41,
			'mix', ~pmodenv.(Pseq([0,0.2,1,4],inf), Pseq([0.01,8,8,8],inf)),
			'gain', 1/4,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', Pseq([
				Pn(0.1,1),
				Pn(0.00001001,inf)
			],inf),
			\delay2, ~pmodenv.(Pseq([0.1,0.0002,0.00021,0.00001],inf), Pseq([0.04,8,8,8],inf)),
			'delay3', 0.0000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 2.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.1714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.003600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\part_boom3, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					0,0,0,0, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
				],1).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,1,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],1).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/feynman.flac'),
				\dur, 1/Pwhite(8,18),
				\pos, Pseq([
					Prand([0,0, 0,0,0,Pwhite(0.01,0.02,1),],1)
				],inf),
				\isRest, Pseq([
					Pseq([
						0
					],16),
					1,1,1,1, 1,1,
				],inf).coin.not,
				\gain, 1,
			),
		]),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\sendbus1),
			\out, BusDef(\sendbus2, \audio),
			\addAction, \addToTail,
			\lag, 0.0004,
			\room, 1,
			\dur, 1,
		),
		Pmono(\rdnroom,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\dur, 1/2,
			'wet10', 1.0,
			'mix', 0.41,
			'mix', ~pmodenv.(Pseq([0,0.2,1,0.4,1,0.5],inf), Pseq([0.01,8,8,8],inf)),
			'gain', 1/4,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', Pseq([
				Pn(0.1,1),
				Pn(0.00001001,inf)
			],inf),
			\delay2, ~pmodenv.(Pseq([0.1,0.0002,0.00021,0.00001,0.002,0.000002],inf), Pseq([0.04,8,8,8],inf)),
			'delay3', 0.0000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 2.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.1714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.003600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
		
	])
)).play;
)


/////////////////:

(
SynthDef(\sino, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = SinOsc.ar(freq * [1,2,1/2,4,1.01,2.01]).mean;
	sig = LFSaw.ar(freq * [1,2,1/2,4,1.01,2.01]).mean;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig + sig1;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\part_alarm, 
	Ppar([
		Pbind(
			\instrument, \sino,
			\freq, 800 * Pseq([1,1,1/2,1/4,1/8],inf),
			\isRest, Pseq([
				1,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 0.1,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \sino,
			\freq, 800 * [0,-4,8,11,14].midiratio,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,8.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1,
			\amp, 0.1/4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \sino,
			\freq, 100 * [0,-4,8,11,14].midiratio,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,8.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1,
			\amp, 0.1/4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, Pseq([
				Rest(8),
				Rest(1),
				Pseq([
					1/8
				],8),
			],inf),
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus1, \audio),
		),
		Pseq([
			Pmono(\fx_gain,
				\inbus, BusDef(\sendbus1),
				\gain, 1.5,
				\dur, Pn(1,1),
			),
			Ppar([
				Pmono(\rdnroom,
					\inbus, BusDef(\sendbus1, \audio, 2),
					\dur, 1/8,
					'wet10', 1.0,
					'mix', 0.1,
					'gain', 1/2,
					'fb', 0.000100031,
					\fb, ~pmodenv.(Pseq([0.0001,0.002,0.000001,0.004],inf), Prand([0.1,0.01,1],inf)),
					'delay', 0.00000001,
					'delay2', 0.00001001,
					'delay3', 0.0000080,
					'delay', ~pmodenv.(Pseq([0.00001,Pn(0.0007,1),0.001],inf), Pseq([8,1/2],inf)),
					'delay3', ~pmodenv.(Pseq([0.00001,Pn(0.7,inf)],inf), 1/2),
					'distamp', 0.604,
					'distamp2', 0.23,
					'distamp3', 0.89,
					'shift', -0.01,
					'shiftmix', 0.1,
					'stereo', 1.0,
					'indelay', 0.04,
				),
				Pmono(\ronoreal,
					\inbus, BusDef(\sendbus1, \audio, 2),
					\dur, 1/8,
					'wet10', 1.0,
					'mix', 0.1,
					'gain', 1/2,
					'fb', 0.000100031,
					'delay', 0.00000001,
					'delay2', 0.20001001,
					'delay3', 0.2000080,
					'delay', ~pmodenv.(Pseq([0.00001,Pn(0.0001,1),0.001],inf), Pseq([8,1/2],inf)),
					'delay3', ~pmodenv.(Pseq([0.00001,Pn(0.1,inf)],inf), 1/2),
					'distamp', 0.604,
					'distamp2', 0.23,
					'distamp3', 0.89,
					'shift', -0.01,
					'shiftmix', 0.1,
					'stereo', 1.0,
					'indelay', 0.04,
				),
			]),
		],1),


		// drums

		Pbind(\out, BusDef(\drumbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,1,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
					],8+4),
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,1,
					0,0,0,0, 1,0,0,0,
					0,0,0,1, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,0,
					0,0,0,1, 1,0,0,0,
					0,0,0,1, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.05,
				\gain, 0.051 * Pseg(Pseq([1,1.5,0.8,1.8,1],inf),1.41),
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,1,1,1,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\gain, 0.051 * Pseg(Pseq([1,1.5,0.8,1.8,1],inf),1.41),
				\dur, 1/8,
			)),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\drumbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
			\isRest, true,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\drumbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.002099467303085,
			'delay', 0.200600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.300000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 7000,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 7700,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\drumbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.01,
			'gain', 4,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.40001001,
			'delay3', 0.0000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 3.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),

		// bass

		Pbind(
			\instrument, \noisybass,
			\freq, 100 * ( Pseq([
				0,0,1,
			],inf)-12 ).midiratio,
			\legato, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				7,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				5,0,0,0, 0,3,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\bassbus1, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\bassbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.1,
			'gain', 1,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00081001,
			'delay3', 0.0008080,
			'delay3', ~pmodenv.(Pseq([0.0008,0.002,0.1,0.0004],inf), Prand([1,2,3],inf)),
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),


		/////////

		Pmono(\rdnroom,
			\inbus, BusDef(\smpsendbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.01,
			'gain', 2,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.2000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
	Pbind(
		\instrument, \oscsampler3,
		\pos, 1.208,
		\freq, 187,
		\range, 0.0000001,
		\posenv, Pseq([
			[ Env([0.00,0.01001,0].integrate.postln,[0.41,8.1]) ],
		],inf),
		\finepos, 1/400,
		\legato, Pseq([

			0,0,0,0, 0,0,0,0,
			0,0,0,0, 1,1,0,1,

			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,1,1,

			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,1,0, 1,1,1,1,

			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,1,0,
			0,0,1,0, 0,1,0,1,

			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			1,0,1,0, 1,0,1,1,
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\dur, 1/8,
		\fshift, 400,
		\lpmix, 1,
		\rq, 0.4,
		\hpmix, 0,
		\hpfreq, 100,
		\ffreq, Pseq([
			Pn(1020,3),5240,
			Pn(4020,3),2240,
			Pn(3020,3),1240,
		],inf).stutter(2),
		\amp, 0.1,
			\bufnum, BufDef('voices/feynman.flac'),

	) 

	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\bodyfreqenv, [ Env([461, 54, 21], [0.035, 0.08], curve: \exp) ],
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\amp, 0.2,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,0,1,0,
			   	1,0,1,0, 1,1,0,1,
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,1,0,1, 1,0,1,0, 
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.071 + Pwhite(0.01,0.07,inf).stutter(Prand([1,2,3],inf)),
			\gain, 0.071 + Pwhite(0.01,0.07,inf).stutter(Prand([1,2,3],inf)),
			\dur, 1/16 * (1 + (0.06 * Pseq([1,-1],inf))),
		)),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 9,
			\isRest, Pseq([
				1,1, 1,1, 1,0, 1,0,
				1,0, 1,1, 1,0, 1,1,
				1,1, 0,0, 1,1, 1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.1,
			\dur, 1/8,
		)),
		
	Pbind(
		\instrument, \oscsampler3,
		\freq, 187,
		\range, 0.0000001,
		\posenv, Pseq([
			[ Env([0.00,0.01001,0].integrate.postln,[0.41,8.1]) ],
		],inf),
		\pos, 2.208,
		\finepos, 18/400,
		\legato, Pseq([
			4,0,0,0, 1,0,0,1,
		   	0,0,2,0, 1,0,1,1,
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\dur, 1/8,
		\fshift, 40,
		\lpmix, 1,
		\rq, 0.4,
		\hpmix, 0,
		\hpfreq, 100,
		\ffreq, Pseq([
			1020,5240,450,700,
		],inf) * Pseq([1,2,1/2],inf).stutter(4),
		\ffreq, ~pmodenv.(Prand([10000,2000,7231,70],inf), 8),
		\amp, 0.1,
			\bufnum, BufDef('voices/feynman.flac'),

	),
	Pbind(
		\instrument, \oscsampler3,
		\freq, 187,
		\range, 0.0000001,
		\posenv, Pseq([
			[ Env([0.00,0.01201,0].integrate.postln,[0.41,8.1]) ],
		],inf),
		\pos, 1.008,
		\finepos, 1/400,
		\legato, Pseq([
			1,0,0,1, 0,0,1,0,
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\dur, 1/8,
		\fshift, 40,
		\lpmix, 1,
		\rq, 0.4,
		\hpmix, 0,
		\hpfreq, 100,
		\ffreq, Pseq([
			1020,5240,450,700,
		],inf).stutter(2) * Pseq([1,2,1/2],inf).stutter(5),
		\ffreq, ~pmodenv.(Prand([10000,2000,60,7231],inf), 8),
		\amp, 0.1,
			\bufnum, BufDef('voices/kaspi.flac'),

	),
	Pbind(
		\instrument, \oscsampler3,
		\freq, 187,
		\range, 0.0000101,
		\posenv, Pseq([
			[ Env([0.00,0.00201,0].integrate.postln,[0.41,8.1]) ],
		],inf),
		\pos, 1.008,
		\finepos, 19/400 + Pseg(Pseq([0,10]/15440,inf),8),
		\legato, Pseq([
			1,0,1,0, 1,0,1,0,
		],inf)/8,
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.8) ],
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\dur, 1/8,
		\fshift, 400,
		\lpmix, 1,
		\rq, 0.4,
		\hpmix, 0,
		\hpfreq, 100,
		\ffreq, Pseq([
			10020,8000, 7020,8000,
			7020,9000, 8020,5000,
		],inf).stutter(2),
		\ffreq, ~pmodenv.(Pseq([10000,2000,7231],inf), 8),
		\amp, 0.1,
			\bufnum, BufDef('voices/nanterre.flac'),

	) ,
	])
)).play;
)


////////////////////:


(
Pdef(\part, Pdef(\part_xxx, 
	Ppar([
		Pbind(
			\instrument, \sino,
			\freq, 800 * Pseq([1,1,1/2,1/4,1/8],inf),
			\isRest, Pseq([
				1,1,0,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.1,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \sino,
			\freq, 800 * [0,-4,8,11,14].midiratio,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\legato, Pseq([
				1,0,1,0, 0,1,0,1,
				2,0,1,0, 1,0,1,1,
				1,0,1,2, 0,1,0,1,
				0,1,1,1, 0,1,0,1,
				0,1,3,0, 0,1,0,1,
			],inf)/4,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.1/4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \sino,
			\freq, 100 * [0,-4,8,11,14].midiratio,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,8.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1,
			\amp, 0.1/4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, Pseq([
				Rest(8),
				Rest(1),
				Pseq([
					1/8
				],8),
			],inf),
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus1, \audio),
		),
		Pseq([
			//Pmono(\fx_gain,
				//\inbus, BusDef(\sendbus1),
				//\gain, 1.5,
				//\dur, Pn(1,1),
			//),
			Ppar([
				Pmono(\rdnroom,
					\inbus, BusDef(\sendbus1, \audio, 2),
					\dur, 1/8,
					'wet10', 1.0,
					'mix', 0.1,
					'gain', 1/2,
					\fb, ~pmodenv.(Pseq([0.0001,0.002,0.000001,0.004],inf), Prand([0.1,0.01,1],inf)),
					'fb', 0.000100031,
					'delay', 0.00000001,
					'delay2', 0.00001001,
					'delay3', 0.0000080,
					'distamp', 0.604,
					'distamp2', 0.23,
					'distamp3', 0.89,
					'shift', -0.01,
					'shiftmix', 0.1,
					'stereo', 1.0,
					'indelay', 0.04,
				),
				Pmono(\ronoreal,
					\inbus, BusDef(\sendbus1, \audio, 2),
					\dur, 1/8,
					'wet10', 1.0,
					'mix', 0.1,
					'gain', 1/2,
					'fb', 0.000100031,
					'delay', 0.00000001,
					'delay2', 0.20001001,
					'delay3', 0.2000080,
					'distamp', 0.604,
					'distamp2', 0.23,
					'distamp3', 0.89,
					'shift', -0.01,
					'shiftmix', 0.1,
					'stereo', 1.0,
					'indelay', 0.04,
				),
			]),
		],1),


		// drums

		Pbind(\out, BusDef(\drumbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([

					Pseq([
						1,0,0,0, 0,0,1,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,1,0,
						0,0,0,0, 0,1,0,0,
					],3),
					Pseq([
						1,0,1,0, 0,0,0,0,
						1,0,0,1, 0,1,0,1,
						1,0,1,0, 0,0,1,0,
						1,0,0,1, 0,1,0,0,
					],2),
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([

					0,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 1,0,0,1,
					Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,1,0, 0,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,1,0, 0,0,1,0,	
					],2),
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
					],8+4),
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,1,
					0,0,0,0, 1,0,0,0,
					0,0,0,1, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,0,
					0,0,0,1, 1,0,0,0,
					0,0,0,1, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.05,
				\gain, 0.051 * Pseg(Pseq([1,1.5,0.8,1.8,1],inf),1.41),
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,1,1,1,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\gain, 0.051 * Pseg(Pseq([1,1.5,0.8,1.8,1],inf),1.41),
				\dur, 1/8,
			)),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\drumbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
			\isRest, true,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\drumbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.002099467303085,
			'delay', 0.200600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.300000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 7000,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 7700,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\drumbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.01,
			'gain', 4,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.40001001,
			'delay3', 0.0000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 3.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),

		// bass

		Pbind(
			\instrument, \noisybass,
			\freq, 100 * ( Pseq([
				0,0,1,
			],inf)-12 ).midiratio,
			\legato, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				7,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				5,0,0,0, 0,3,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\bassbus1, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\bassbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.1,
			'gain', 1,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00081001,
			'delay3', 0.0008080,
			'delay3', ~pmodenv.(Pseq([0.0008,0.002,0.1,0.0004],inf), Prand([1,2,3],inf)),
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),


		/////////

		Pmono(\rdnroom,
			\inbus, BusDef(\smpsendbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.01,
			'gain', 2,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.2000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
	Pbind(
		\instrument, \oscsampler3,
		\pos, 1.208,
		\freq, 187,
		\range, 0.0000001,
		\posenv, Pseq([
			[ Env([0.00,0.01001,0].integrate.postln,[0.41,8.1]) ],
		],inf),
		\finepos, 1/400,
		\legato, Pseq([

			0,0,0,0, 0,0,0,0,
			0,0,0,0, 1,1,0,1,

			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,1,1,

			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,1,0, 1,1,1,1,

			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,1,0,
			0,0,1,0, 0,1,0,1,

			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			1,0,1,0, 1,0,1,1,
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\dur, 1/8,
		\fshift, 400,
		\lpmix, 1,
		\rq, 0.4,
		\hpmix, 0,
		\hpfreq, 100,
		\ffreq, Pseq([
			Pn(1020,3),5240,
			Pn(4020,3),2240,
			Pn(3020,3),1240,
		],inf).stutter(2),
		\amp, 0.1,
			\bufnum, BufDef('voices/feynman.flac'),

	) 

	])
)).play;
)
