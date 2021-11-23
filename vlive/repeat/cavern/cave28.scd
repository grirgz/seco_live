~t = 1; TempoClock.default.tempo = ~t;

(
Ndef(\combchain, {
	var in = InFeedback.ar(\inbus.kr(BusDef(\sendbus1, \audio)), 2); 
	var oin = in;
	in = in + CombC.ar(in, 2, SinOsc.ar(0.015* [0.13, 0.17]).range(0.5, 1) * [0.13, 0.17], 7);
	in = in + CombC.ar(in, 2, SinOsc.ar(0.01* [0.1, 0.15]).range(0.5, 1) * [0.1, 0.15], 7);
	in = in + CombC.ar(in, 2, [1.5, 1.0], 7);
	//in = in + GVerb.ar(in, 1);
	in = in + FreeVerb2.ar(in[0], in[1], 0.5, 1);
	in = in / 3 / 3;
	in = Compander.ar(in, in, \cpt.kr(0.2), \cpbelow.kr(1.001), \cpabove.kr(0.1), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	in = SelectX.ar(\mix.kr(0.5), [oin, in]);
	in = in * \gain.kr(1);
	in;
}).play;
)

// intro
(
	Ndef(\combchain).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 \playersec,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\dur, 1/4,
			\loop, 1,
			\gain, 1,
			\gain , Pseq([
				Pseq([
					0
				],8*4*4/2),
				Pseq([
					1,0,0,
				],inf),
			],inf) * 0.4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[225].value,
			\isRest, Pseq([
				Pseq([
					0
				],8*8*3),
				Pseq([
					0,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[135].value,
			\isRest, Pseq([
				Pseq([
					0
				],8*8*4),
				Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \jmcpiano,
			\note, Pseq([
				0,3,2,1,
			],inf),
			\octave, Pseq([3,4,5],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,1.1,1.2,3.1) ],
			],inf),
			\legato, 0.1,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,5
			],inf).stutter(8),
			\octave, 3,
			\lpf, 1600,
			\rq, 0.9,
			\sustain, 0.1,
			\isRest, Pseq([
				Pseq([
					0
				],8*8*4),
				Pseq([
					1
				],inf),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\amp, 0.91,
		),
		
	])
)).play;
);

// part 1
(
	Ndef(\combchain).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 \playersec,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\dur, 1/4,
			\loop, 1,
			\gain, 1,
			\gain , Pseq([
				Pseq([
					1,0,0,
				],inf),
			],inf) * 0.4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[225].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[135].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \jmcpiano,
			\note, Pseq([
				0,3,2,1,
			],inf),
			\octave, Pseq([3,4,5],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,1.1,1.2,3.1) ],
			],inf),
			\legato, 0.1,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,5
			],inf).stutter(8),
			\octave, 3,
			\lpf, 1600 * Pseg(Pseq([1,1,4,1,1/2],inf),Pseq([1,1,1,1],inf)),
			\rq, Pseg(Pseq([1,1,0.1,1,0.4],inf),2),

			\pan, Pseq([
				0,-0.2,0,0.2,
			],inf),
			\sustain, 0.1,
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,0, 1,0,0,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,0, 1,1,0,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,0, 1,1,0,1,
					1,1,1,1, 1,1,1,1,
				],inf),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\amp, 0.091,
		),
		
	])
)).play;
);

// part 1b
(
	Ndef(\combchain).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 \playersec,
			\bufnum, BufDef.stereo('voices/curse.flac'),
			\dur, 1/4,
			\loop, 1,
			\gain, 1,
			\gain , Pseq([
				Pseq([
					1,0.1,0.1,
				],inf),
			],inf) * 0.4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[225].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[135].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \jmcpiano,
			\note, Pseq([
				0,3,2,1,
			],inf),
			\octave, Pseq([3,4,5],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,1.1,1.2,3.1) ],
			],inf),
			\legato, 0.1,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,5
			],inf).stutter(8),
			\octave, 3,
			\lpf, Pwhite(100,1000.0,inf) * Pseg(Pseq([1,10],1),8).loop,
			\rq, Pwhite(0.1,1,inf),
			\pan, Pseq([
				0,-0.2,0,0.2,
			],inf),
			\sustain, 0.1,
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					Pseq([
						0.8,
					],8),
				],inf),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\amp, 0.091,
		),
		
	])
)).play;
);

// part 1c
(
	Ndef(\combchain).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 \playersec,
			\bufnum, BufDef.stereo('voices/curse.flac'),
			\dur, 1/4,
			\loop, 1,
			\gain, 1,
			\gain , Pseq([
				Pseq([
					1,0.1,0.1,
				],inf),
			],inf) * 0.4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[225].value,
			\isRest, Pseq([
				Pseq([
					Pseq([
						0,0,0,0, 1,0,0,0,
					],6),
						0,0,0,0, 1,0,1,0,
						0,0,0,0, 0,0,0,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[135].value,
			\isRest, Pseq([
				Pseq([

					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,

					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,1,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,

					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,

					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					1,0,0,1, 0,1,1,1,
					1,0,0,0, 0,0,0,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \jmcpiano,
			\note, Pseq([
				0,3,2,1,
			],inf),
			\octave, Pseq([3,4,5],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,1.1,1.2,3.1) ],
			],inf),
			\legato, 0.1,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[600].value,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],8),
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					1,1,1,1, 1,1,1,1,
				],4),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[790].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					1,0,1,0, 1,0,1,0,
				],8),

			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,5,3,0,2,-4,1,-5,
			],inf).stutter(16),
			\octave, 3,
			\lpf, Pwhite(100,1000.0,inf) * Pseg(Pseq([1,10],1),8).loop,
			\rq, Pwhite(0.1,1,inf),
			\pan, Pseq([
				0,-0.2,0,0.2,
			],inf),
			\sustain, 0.1,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0.5,
					0.5,0,0,0.5, 0,0,0.5,0,
					0.5,0,0,0, 0.5,0,0,0,
					Pseq([
						0.8,
					],8),
				],inf),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\amp, 0.091,
		),
		
	])
)).play;
);


///////////////////////////////////////////////////

(
var duration = 60 * 5;
var freqDrift = { |freq| LFDNoise3.ar(0.2, 0.1, freq.cpsmidi).midicps };
var masterVolume = -2.dbamp;

play {
	var rootFreq = freqDrift.(26.midicps);
	var gate = EnvGen.ar(Env([0, 1, 1, 0], [0.1, duration, 0.25]), gate: 1, doneAction: 0);
	var leveler = LinLin.ar(LFTri.ar(duration.reciprocal, 1), -1, 1, -24, 0).dbamp;
	var sig = HPF.ar(
		({ |k|
			Pan2.ar(({ |i|
				Pulse.ar(
					i * k + 2 / (k + 1) * rootFreq * (i + 1) * 0.0625 * 16,
					LinLin.ar(LFTri.ar(rootFreq * (i + 1) / 1024), -1, 1, 0.5, 0.95)
				)} ! (k/2 + 1).asInteger).product
				* (k + 1).reciprocal
				* LinExp.ar(Blip.ar(
					(k + 5).nthPrime.reciprocal * rootFreq * 0.125, 3), -1, 1, -48.dbamp, 1).neg,
				LFTri.ar((k + 1).nthPrime * rootFreq / 256)
			)
		} ! 16).sum * -12.dbamp,
		40
	);
	var compsig = Compander.ar(
		sig, sig, -48.dbamp, 1, XLine.ar(1, 0.125, duration), mul: Line.ar(0, 36, duration).dbamp
	);
	var final = LeakDC.ar(SinOsc.ar(
		rootFreq * 2,
		GVerb.ar(
			compsig.sum,
			revtime: 2.5,
			drylevel: 0,
			earlyreflevel: 0,
			taillevel: -12.dbamp,
			mul: LinExp.ar(LFTri.ar(duration.reciprocal, 1), -1, 1, pi, pi * 0.25),
			add: compsig
		),
		mul: 0.5 * gate,
	), mul:  leveler);
	var verb = GVerb.ar(final.sum, 300, 4.5, drylevel: 0, earlyreflevel: -6.dbamp, taillevel: -12.dbamp, add: final);
	var env = DetectSilence.ar(gate + verb, doneAction: 2);
	verb * masterVolume
};

play {
	var rootFreq = freqDrift.(Lag.ar(26.midicps * 4 * LinLin.ar(LFTri.ar(duration.reciprocal * 5), -1, 1, 3, 13).floor / LinLin.ar(LFTri.ar(duration.reciprocal * 3), -1, 1, 13, 3).floor, 0.25));
	var gate = EnvGen.ar(Env([0, 1, 1, 0], [0.1, duration * 0.9, 0.25]), gate: 1, doneAction: 0);
	var leveler = LinLin.ar(LFTri.ar(duration.reciprocal * 15, 2), -1, 1, -72, 6).dbamp;
	var sig = HPF.ar(
		({ |k|
			Pan2.ar(({ |i|
				Pulse.ar(
					i * k + 2 / (k + 1) * rootFreq * (i + 1) * 0.0625 * 16,
					LinLin.ar(LFTri.ar(rootFreq * (i + 1) / 1024), -1, 1, 0.5, 0.95)
				)} ! (k/2 + 1).asInteger).product
				* LinExp.ar(Blip.ar(
					(k + 5).nthPrime.reciprocal * rootFreq * 0.125, 3), -1, 1, -48.dbamp, 1).neg,
				LFTri.ar((k + 1).nthPrime * rootFreq / 256)
			)
		} ! 16).sum * -12.dbamp,
		40
	);
	var compsig = Compander.ar(
		sig, sig, -48.dbamp, 1, XLine.ar(1, 0.125, duration), mul: Line.ar(0, 36, duration).dbamp
	);
	var final = LeakDC.ar(SinOsc.ar(
		rootFreq * 4,
		GVerb.ar(
			compsig.sum,
			revtime: 2.5,
			drylevel: 0,
			earlyreflevel: 0,
			taillevel: -12.dbamp,
			mul: Line.ar(pi * 2, pi, duration),
			add: compsig
		),
		mul: 0.5 * gate,
	), mul: leveler * AmpCompA.kr(root: rootFreq * 4));
	var verb = GVerb.ar(final.sum, 300, 4.5, drylevel: 0, earlyreflevel: 0.dbamp, taillevel: -24.dbamp, add: final);
	var env = DetectSilence.ar(gate + verb, doneAction: 2);
	verb * -18.dbamp * masterVolume
};

play {
	var rootFreq = 26.midicps;
	var depthMod = LFSaw.kr(0.05).exprange(0.05, 5.0);
	var gate = EnvGen.ar(Env([0, 1, 1, 0], [0.1, duration * 0.9, 0.25]), gate: 1, doneAction: 0);
	var leveler = LinLin.ar(LFTri.ar(duration.reciprocal, 3), -1, 1, -24, 6).dbamp;
	var sig = HPF.ar(
		({ |k|
			Pan2.ar(({ |i|
				SinOsc.ar(i * k + 2 / (k + 1) * rootFreq * (i + 1))} ! 4).product
				* (k+1).reciprocal
				* LFSaw.kr(
					(k + 5).nthPrime.reciprocal * rootFreq * 0.25, k/7 * 2
				).exprange(-24.dbamp, 1),
				LFTri.ar((k + 1).nthPrime * rootFreq)
			)
		} ! 16).sum * -18.dbamp,
		40
	);
	var siggap = Amplitude.ar(sig).reciprocal.min(0.0625);
	var verb = GVerb.ar(
		sig.sum,
		roomsize: [80, 135, 283],
		revtime: depthMod * 2,
		drylevel: 0,
		taillevel: 0.dbamp * siggap,
		earlyreflevel: -6.dbamp * siggap,
		add: sig
	).sum * leveler * gate;
	var env = DetectSilence.ar(verb, doneAction: 2);
	verb * masterVolume
}
)


////////////////////////////////


// https://recarteblog.wordpress.com/
//gongFM_SC

// 1. Añadir al servidor

(
SynthDef(\gongFM, {
	arg ratio1=0.9, ratio2=0.55, ratio3=1.03, index2=2, index3=4, amp=0.7, dur=7, pan=0;
	var sig, op1, op2, op3, env1, env2, env3;
	env3 = EnvGen.kr(Env.new([0, 1, 1, 0], [0.4, 0.3, dur]), doneAction:2);
	env2 = EnvGen.kr(Env.new([0, 1, 1, 0], [0, 0.3, dur]), doneAction:2);
	env1 = EnvGen.kr(Env.new([0, 1, 1, 0], [0.003, 0.3, dur - 0.5]), doneAction:2);
	op3 = SinOsc.ar(([67, 70, 74].midicps * ratio3), mul:[67, 70, 74].midicps * ratio3 * index3) * env3;
	op2 = SinOsc.ar((([67, 70, 74].midicps * ratio2) + op3), mul:[67, 70, 74].midicps * ratio2 * index2) * env2;
	op1 = SinOsc.ar(([67, 70, 74].midicps * ratio1) + op2);
	sig = op1 * env1 * amp;
	sig = Splay.ar(sig);
	sig = Balance2.ar(sig[0], sig[1], pan);
	Out.ar(0, sig);
}).add;
)


// 2. Ejecutar los Synths

Synth(\gongFM);

Synth(\gongFM, [\ratio1, 0.503, \ratio2, 0.50, \ratio3, 1.35, \index2, 1.53, \index3, 4.33]);

Synth(\gongFM, [\ratio1, 0.59, \ratio2, 0.17, \ratio3, 0.75, \index2, 1.54, \index3, 3.29]);

Synth(\gongFM, [\ratio1, 0.49, \ratio2, 0.17, \ratio3, 0.34, \index2, 1.33, \index3, 4.31]);

Synth(\gongFM, [\ratio1, 1.11, \ratio2, 0.2, \ratio3, 0.80, \index2, 1.97, \index3, 5.06]);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		Pseed(10212,
			Pbind(
				\instrument, \gongFM,
				\ratio1, Pwhite(0,1.11), \ratio2, Pwhite(0,0.2), \ratio3, Pwhite(0,0.80), \index2, Pwhite(0,1.97), \index3, Pwhite(0,5.06),
				\dur, Pn(2,4),
				\amp, 0.1,
			)
		).loop,
		
	])
)).play;
);

// https://recarteblog.wordpress.com/
//droneFM01

// 1. Añadir al servidor
(
SynthDef(\droneFM, {
	arg f1Freq=0.1, f2Freq=1.1, f3Freq=2.2, nFreq=440, m1Ratio=1, m2Ratio=2, m3Ratio=3,
	amp=0.1, dur=55, ampM=0.84 , pan=0;
	var sig, car1, mod1, car2, mod2, car3, mod3, env, index;
	index = LFNoise1.kr(0.2).range(2, 12);
	env = EnvGen.kr(Env.new([0, 0.70, 0.70, 0], [dur*0.333, dur*0.333, dur*0.333]), doneAction:2);
	mod1 = SinOsc.ar([nFreq * m1Ratio, nFreq+0.7 * m1Ratio], mul:nFreq * m1Ratio * index) * ampM;
	car1 = SinOsc.ar(f1Freq + mod1);
	mod2 = SinOsc.ar([nFreq * m2Ratio, nFreq+1.4 * m2Ratio], mul:nFreq * m2Ratio * index) * ampM;
	car2 = SinOsc.ar(f2Freq + mod2);
	mod3 = SinOsc.ar([nFreq * m3Ratio, nFreq+0.35 * m3Ratio], mul:nFreq * m3Ratio * index) * ampM;
	car3 = SinOsc.ar(f3Freq + mod3) * 0.4;
	sig = car1 + car2 + car3 * env * amp;
	sig = Pan2.ar(sig, pan);
	Out.ar(0, sig);
}).add;
)

// 2. Ejecutar los Synths
(
Synth(\droneFM, [\nFreq, 50.midicps]);
Synth(\droneFM, [\nFreq, 57.midicps]);
Synth(\droneFM, [\nFreq, 41.midicps]);
)

Ndef(\droneFM).source = \droneFM;
WindowDef(\NdefEditor).front(Ndef(\droneFM))

(
SynthDef(\mydronefm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var index = LFNoise1.kr(0.2).range(2,12);
	index = 130;
	sig = SinOsc.ar( ( SinOsc.ar([freq, freq]) * index * freq + 0.1 ));
	sig = SinOsc.ar( ( SinOsc.ar([freq, freq]) * index * freq + ( freq * 0.001 ) ));
	sig = SinOsc.ar(freq * ( SinOsc.ar([freq, freq+0.07]) * index + 1 ) + 100.01);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(14.7,0.1,0.8,1.7)), gate, doneAction:2);
	sig = sig * amp;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\mydronefm,
			\note, Pseq([
				-12,
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\droneFMbroken, {
	arg f1Freq=0.1, f2Freq=1.1, f3Freq=2.2, nFreq=440, m1Ratio=1, m2Ratio=2, m3Ratio=3,
	amp=0.1, dur=55, ampM=0.84 , pan=0;
	var sig, car1, mod1, car2, mod2, car3, mod3, env, index;
	index = LFNoise1.kr(0.2).range(2, 12);
	index = 2;
	env = EnvGen.kr(Env.new([0, 0.70, 0.70, 0], [dur*0.333, dur*0.333, dur*0.333]), doneAction:2);
	mod1 = SinOsc.ar([nFreq * m1Ratio, nFreq+0.7 * m1Ratio], mul:nFreq * m1Ratio * index) * ampM;
	car1 = SinOsc.ar(( f1Freq + mod1.poll ));
	mod2 = SinOsc.ar([nFreq * m2Ratio, nFreq+1.4 * m2Ratio], mul:nFreq * m2Ratio * index) * ampM;
	car2 = SinOsc.ar(f2Freq + mod2);
	mod3 = SinOsc.ar([nFreq * m3Ratio, nFreq+0.35 * m3Ratio], mul:nFreq * m3Ratio * index) * ampM;
	car3 = SinOsc.ar(f3Freq + mod3) * 0.4;
	sig = car1 * env * amp;
	//sig = car1 + car2 + car3 * env * amp;
	sig = Pan2.ar(sig, pan);
	sig.debug("sig");
	Out.ar(0, sig);
}).add;
)
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \droneFMbroken,
			\note, Pseq([
				-12,
			],inf),
			\nFreq, Pkey(\freq),
			\dur, 8,
			\amp, 0.1,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \droneFM,
			\note, Pseq([
				-12,
			],inf),
			\nFreq, Pkey(\freq),
			\dur, 8,
			\amp, 0.1,
		),
	])
)).play;
);

