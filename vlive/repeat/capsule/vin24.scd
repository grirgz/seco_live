
~t = 124/4/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1067].value,
			\bufnum, ~buflib.kick[62].value, // sec
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[62].value, // sec
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1067].value,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[578].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1616].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[14].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.21 * Pseq([0.7,1],inf),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[15].value,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11 * Pseq([0.7,1],inf),
		),
		
	])
)).play;
);


// TODO: composer un Ndef qui a la forme d'une musique
// attack sustain suspend (avec quelques sons en suspens) puis drop! puis deconstruction..


~t = 124/4/60; TempoClock.default.tempo = ~t;
(
Ndef(\arrange, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;

	freq = freq * Duty.kr(1/~t, 0, Dseq([
		0,3,3,2,
	],inf)).midiratio;

	env2 = EnvGen.kr(Env([0,1,0],[LFNoise1.kr(1!4).range(0.1,0.4),0.8]), Dust.kr(1/8!4));
	env3 = EnvGen.kr(Env([0,0,1,1],[2,1.1,1000.8]), 1);
	sig2 = LFSaw.ar(freq * [9,3,5,7].midiratio) * env2;
	sig2 = RLPF.ar(sig2, \lpfr.kr(4.1) * freq, \rq.kr(0.5));
	sig2 = sig2.sum * env3;

	env1 = EnvGen.kr(Env([0,1,1],[2,1000.8]), 1);
	sig1 = SinOsc.ar(freq * ( SinOsc.ar(freq * ( 5 - 24 ).midiratio * (sig2 * 10 + 1)) * env1 + 1 ));

	sig3 = SinOsc.ar(SinOsc.ar(1 * [1,2,3,4] * ~t) + 1 * freq * (9 + 12).midiratio) * EnvGen.kr(Env([0,1,0],[0.001,0.01]), Impulse.kr(4 * [1,2,3,4] * ~t)) * LFPulse.ar([1,2,3,4]/3 * ~t).range(0,1);
	sig3 = sig3.sum;
	lfo1 = SinOsc.ar(1/4) * 1.9 + 1; 
	sig3 = RLPF.ar(sig3, (\lpfr3.kr(2.1) * lfo1  * freq).clip(20, 20000), \rq.kr(0.5));
	sig3 = CombL.ar(sig3, 4/~t, 1/8/~t * (Amplitude.kr(sig1) * 0.003 + 1),1/~t) * 0.2 + sig3;
	sig3 = sig3 * env1;

	env4 = EnvGen.kr(Env([1,1,0,0,1,1],[6,0.01,4-0.02,0.01,1000]/~t), 1);

	sig = [sig1 * env4,sig2 * env4, sig3].sum;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\arrange, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;

	freq = 48.midicps;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		0,3,3,2,
	],inf)).midiratio;

	env5 = EnvGen.kr(Env([0,0,1,0,0],[6,4,0.5,1000.8]/~t), 1);
	env2 = EnvGen.kr(Env([0,1,0],[LFNoise1.kr(1!4).range(0.1,0.4),0.8]), Dust.kr(1/8!4));
	env2 = SelectX.kr(env5, [env2, 0.71]);
	env3 = EnvGen.kr(Env([0,0,1,1],[2,1.1,1000.8]), 1);
	sig2 = LFSaw.ar(freq*2 * [9,3,5,7].midiratio * ( SinOsc.ar(freq * env3) * env3 * 0.5 + 1 )) * env2;
	sig2 = RLPF.ar(sig2, \lpfr.kr(4.1) * freq, \rq.kr(0.5));
	sig2 = sig2.sum * env3;
	sig2 = sig2 * LFPulse.kr(8*~t).range(0,1);

	env1 = EnvGen.kr(Env([0,1,1],[2,1000.8]), 1);
	sig1 = SinOsc.ar(freq * ( SinOsc.ar(freq * ( 5 - 24 ).midiratio * (sig2 * 10 + 1)) * env1 + 1 ));
	sig1 = sig1 + (sig1.fold( SinOsc.ar(0.01 * [1,1.2123,12.1]).sum) * SinOsc.ar(0.1 * [1,1.2123]).range(0,0.2).sum);

	sig3 = SinOsc.ar(SinOsc.ar(1 * [1,2,3,4] * ~t) + 1 * freq * (9 + 12).midiratio) * EnvGen.kr(Env([0,1,0],[0.001,0.01]), Impulse.kr(4 * [1,2,3,4] * ~t)) * LFPulse.ar([1,2,3,4]/3 * ~t).range(0,1);
	sig3 = sig3.sum;
	lfo1 = SinOsc.ar(1/4) * 1.9 + 1; 
	sig3 = RLPF.ar(sig3, (\lpfr3.kr(2.1) * lfo1  * freq).clip(20, 20000), \rq.kr(0.5));
	sig3 = CombL.ar(sig3, 4/~t, 1/8/~t * (Amplitude.kr(sig1) * 0.003 + 1),1/~t) * 0.2 + sig3;
	sig3 = sig3 * env1;

	//env5 = EnvGen.kr(Env([0,0,1,0,0],[0,4,0.5,1000.8]/~t), 1);
	sig4 = WhiteNoise.ar * env5 * 0.5;
	sig4 = FreqShift.ar(sig4, ( SinOsc.kr(1*~t * ( env5 * 4.9 + 1 )) * env5 + 1 ) * 100) + sig4;
	sig4 = BPF.ar(sig4, freq * ( SinOsc.kr(1.1 *~t) * 0.81 * env5 + 4 ), 1)*2;

	env4 = EnvGen.kr(Env([1,1,0,0,1,1],[6,0.01,4-0.02,0.01,1000]/~t), 1);

	sig = [sig1 * env4,sig2, sig3, sig4].sum;
	//sig = sig4;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


(
Ndef(\arrange2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(
		ExpRand(100,7000!16)
		* ( SinOsc.ar(ExpRand(0.0100,0.07000!16)/10).round(0.01) * SinOsc.ar(Rand(0.100,0.7!16)).range(0,0.3) + 1 )
		* ( SinOsc.ar(ExpRand(100,7000!16)) * SinOsc.ar(Rand(0.100,0.7!16)).range(0,0.3) + 1 ) 
	).mean;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
SynthDef(\fmrander, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(
		( freq * ( ExpRand(0.100,0.7000!16) * 0.007 + 1 ) )
		* ( SinOsc.ar(ExpRand(0.0100,0.07000!16)/1).round(0.01) * SinOsc.ar(Rand(0.100,0.7!16)/10).range(0,0.9) + 1 )
		* ( SinOsc.ar(ExpRand(100,7000!16)) * SinOsc.ar(Rand(0.100,0.7!16)).range(0,0.03) + 1 ) 
	);
	sig = RLPF.ar(sig, \lpfr.kr(5.1) * freq, \rq.kr(0.5));
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \fmrander,
			\note, Pseq([
				0,4,12,
			],inf),
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\ssss, 
	Ppar([
		Pmono( \arrange,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, Pseq([
				Pseq([
					\organ_tonewheel1,
				],6),
				Pseq([
					\organ_tonewheel0,
				],2),
			],inf),
			\blockFlute, 0,
			\larigot, 0,
			\nazard, 0.3,
			\fundamental, 1,
			\sifflute, 0,
			\bass, 0.61,
			\quint, 0.3,
			\oct, 0.71,
			\tierce, 0.3,
			\vdepth, 0.008,
			\octave, Ptuple(Prand([4,5,6],inf)!3),
			\note, Pseq([
				[0,3,7]+0,
				[0,3,7]-1,
			],inf),
			\sus, 0.01 * Pseg(Pseq([1,98],inf),16),
			\rel, 0.11 * Pseg(Pseq([1,2],inf),3.7),
			\strum, Pseg(Pseq([0,0.04],inf),8),
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(0.1,0.1,0.8,3.1) ],
				],6),
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
					[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\legato, Pseq([
				Pseq([
					0.8,
				],6),
				0.1,0.8,
			],inf),
			\lag, Pseq([
				Pseq([
					0
				],6),
				5/12,
				0,
			],inf),
			\dur, 1/8,
			\amp, 0.02 * Pseg(Pseq([0,Pn(1,inf)],inf),10),
		),
		Psched(6+4,
			Pdef(\ploux2part)
		),
		Psched(24,Pbind(
			\instrument, \fmrander,
			\note, Pseq([
				4,12,
			],inf),
			\dur, 8,
			\amp, 0.071,
		)).loop,
	])
)).play;
);

(
Pdef(\part, Pdef(\revpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[663].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			\out, BusDef(\verb, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2435].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
			\out, BusDef(\verb, \audio),
		),
		Pmono(\fx_freeverb2,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\verb, \audio),
			\verbmix, 0.4,
			\room, 2.5,
			\damp, 0.7,
			\mix, 1,
			\gain, 0.51,
			\dur, 2,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\revpart2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_mainTimeline_t0_200506_224210').buffer,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, 1,
			\speed, -1,
			\pos, 0.2,
			\dur, 1/8,
			\gain, 0.71,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_mainTimeline_t0_200506_224210').buffer,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,1,0, 0,0,1,0, 0,1,1,0,
				0,0,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,1, 1,0,1,0, 0,0,1,0, 0,1,0,1,
				0,0,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 1,
			\speed, 1,
			\pos, 0.2,
			\dur, 1/16,
			\gain, 0.71,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[690].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,1,

				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			\out, BusDef(\verb, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2435].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
			\out, BusDef(\verb, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//	\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1093].value,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.05 * Pseq([0.7,1],inf),
		),
		Pmono(\fx_freeverb2,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\verb, \audio),
			\verbmix, 0.4,
			\room, 0.5,
			\damp, 0.7,
			\mix, 1/4,
			\gain, 0.41,
			\dur, 2,
		),
		Pbind(
			\instrument, \padbroke,
			\note, Pseq([
				[0,12, 12+7],
				[0,12, 12+7],
				[0,12, 12+7],
				[0,3, 12+3],

				[0+12,3, 12+3],
				[0,3, 12+3],
				[0,3, 12+3],
				[3, 12+3,11+24],
			],inf)-12,
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(1.1,0.1,0.8,2.1) ],
				],8),
				Pseq([
					[ Env.adsr(1.1,0.1,0.8,0.5) ],
				],inf),
			],inf),
			\octave, 6,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\legato, 0.1,
			\ctranspose, Pseq([
				0,3,3,2,
			],inf),
			\dur, 1,
			\amp, 0.1/1,
			\out, BusDef(\fxchorus, \audio),
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fxchorus, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 0.5,
			\fb, 0.9,
			\delay, 0.1,
			\diff, 0.001,
			\modfreq, 0.1,
			\modamp, 1/6,
			\gain,2,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fxverb,\audio),
		),
		Pmono(\fx_freeverb2,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\fxverb, \audio),
			\verbmix, 0.6,
			\room, 1.9,
			\damp, 0.7,
			\mix, 1,
			\gain, 1/2,
			\dur, 2,
		),
		
	])
)).play;
);

(
SynthDef(\anguille, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = XLine.kr(0.5,8,4/~t);
	env2 = XLine.kr(0.01,40,4/~t);
	sig1 = LFSaw.ar(freq * [1,1.01,2,3,3.01,4]);
	sig2 = SinOsc.ar(freq * [1,1.01,2,3,3.01,4]);
	sig1 = sig1.collect({ arg isig, idx;
		var cut;
		var isig1;
		isig1 = isig.clip( SinOsc.kr(0.01 + Rand(0.01,0.2)));
		isig = SelectX.ar( SinOsc.kr(0.01 + Rand(0.01,0.2)).unipolar, [isig, isig1]);
		isig = isig * SinOsc.kr(0.01 + Rand(0.01,0.2)).range(0.2,1);
		isig = isig * LFPulse.kr(1.01 * env2 + Rand(0.01,1.2)).range(0,1);
		cut = \lpfr.kr(4.1) * freq * SinOsc.kr(0.01 + Rand(0.01,0.02)).range(1/2,2) * env1;
		isig = RLPF.ar(isig, cut.clip(20,20000), \rq.kr(0.5) * SinOsc.kr(0.01 + Rand(0.01,0.02)).range(1/2,2));
		//isig1 = isig1 * 0.1;
		//isig = SelectX.ar( SinOsc.kr(0.01 + Rand(0.01,0.2)).unipolar, [sig2[idx], isig1]);
		isig;

	});
	sig2 = sig2.collect({ arg isig, idx;
		var cut;
		var isig1;
		isig1 = isig.clip( SinOsc.kr(0.01 + Rand(0.01,0.2)));
		isig = SelectX.ar( SinOsc.kr(0.01 + Rand(0.01,0.2)).unipolar, [isig, isig1]);
		isig = isig * SinOsc.kr(0.01 + Rand(0.01,0.2)).range(0.2,1);
		isig = isig * LFPulse.kr(1.01 * env2 + Rand(0.01,1.2)).range(0,1);
		isig;

	});
	sig = SelectX.ar(SinOsc.kr(0.01 + Rand(0.01,0.2!sig1.size)).unipolar, [sig1, sig2].flop);
	//sig = ( sig*10 ).distort;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan + SinOsc.ar(SinOsc.kr(0.01 + Rand(0.01!sig.size,0.2))); 
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
		Pdef(\part2,Pmono(\arrange2,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		)).play;
Pdef(\part, Pdef(\revpart2b, 
	Ppar([
		Psched([4,8],
			Pmono(\anguille,
				\dur, 1,
				\amp, 0.122,
				\rq, 0.3,
				\octave, 5,
				\ctranspose, Pseq([
					0,3,3,2,
				],inf),
			),
		).loop,
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_mainTimeline_t0_200506_224210').buffer,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, 1,
			\speed, -1,
			\pos, 0.2,
			\dur, 1/8,
			\gain, 0.71,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_mainTimeline_t0_200506_224210').buffer,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,1,0, 0,0,1,0, 0,1,1,0,
				0,0,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,1, 1,0,1,0, 0,0,1,0, 0,1,0,1,
				0,0,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 1,
			\speed, 1,
			\pos, 0.2,
			\dur, 1/16,
			\gain, 0.71,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[690].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,1,

				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			\out, BusDef(\verb, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2435].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
			\out, BusDef(\verb, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//	\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1093].value,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.05 * Pseq([0.7,1],inf),
		),
		Pmono(\fx_freeverb2,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\verb, \audio),
			\verbmix, 0.4,
			\room, 0.5,
			\damp, 0.7,
			\mix, 1/4,
			\gain, 0.41,
			\dur, 2,
		),
		Pbind(
			\instrument, \padbroke,
			\note, Pseq([
				[0,12, 12+7],
				[0,12, 12+7],
				[0,12, 12+7],
				[0,3, 12+3],

				[0+12,3, 12+3],
				[0,3, 12+3],
				[0,3, 12+3],
				[3, 12+3,11+24],
			],inf)-12,
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(1.1,0.1,0.8,2.1) ],
				],8),
				Pseq([
					[ Env.adsr(1.1,0.1,0.8,0.5) ],
				],inf),
			],inf),
			\octave, 6,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\legato, 0.1,
			\ctranspose, Pseq([
				0,3,3,2,
			],inf),
			\dur, 1,
			\amp, 0.1/1,
			\out, BusDef(\fxchorus, \audio),
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fxchorus, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 0.5,
			\fb, 0.9,
			\delay, 0.1,
			\diff, 0.001,
			\modfreq, 0.1,
			\modamp, 1/6,
			\gain,2,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fxverb,\audio),
		),
		Pmono(\fx_freeverb2,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\fxverb, \audio),
			\verbmix, 0.6,
			\room, 1.9,
			\damp, 0.7,
			\mix, 1,
			\gain, 1/2,
			\dur, 2,
		),
		
	])
)).play;
);


(
// part 1 main
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pseq([
			Psched([0,32],Pdef(\ssss)),
			Ppar([
				Psched([0,16],Pmono(\arrange2,
					\dur, 1,
					\amp, 0.1,
				)),
				Pseq([
					Psched([0,8],Pdef(\revpart)),
					Psched([0,8],Pdef(\revpart2b)),
				],1),
			]),
			Psched([0,16],Pdef(\revpart3)),
			Psched([0,16],Pdef(\sec2)),
		],1),
		
	])
)).play;
);

(
// WIP 1 main
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pseq([
			//Psched([0,32],Pdef(\ssss)),
			//Ppar([
				//Psched([0,16],Pmono(\arrange2,
					//\dur, 1,
					//\amp, 0.1,
				//)),
				//Pseq([
					//Psched([0,8],Pdef(\revpart)),
					//Psched([0,8],Pdef(\revpart2)),
				//],1),
			//]),
			Psched([0,8],Ppar([
				Pmono(\arrange2,
					\dur, 1,
					\amp, 0.1,
				),
				Psched([0,8],Pdef(\revpart2b)),
			])),
			Psched([0,16],Pdef(\revpart3)),
			Psched([0,16],Pdef(\sec2)),
		],1),
		
	])
)).play;
);

(
Ndef(\arrange2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;

	freq = 48.midicps;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		0,3,3,2,
	],inf)).midiratio;

	lfo2 = Duty.kr(1/3/~t, 0, Dseq([
		1,3,1.2,1.4,10
	],inf)).lag(0.1);
	lfo3 = ( SinOsc.kr(0.041) * 1 + 1 );
	lfo1 = SinOsc.ar(0.1 * lfo2).range(lfo3,0.6);
	sig1 = Pulse.ar(freq, lfo1);
	lfo5 = ( SinOsc.kr([0.04,0.23]).sum * 0.31 + 1 );
	sig1 = RLPF.ar(sig1, \lpfr.kr(4.1) * freq * lfo5, \rq.kr(0.5)) + ( sig1 * 0.3 );
	sig1 = Pan2.ar(sig1, pan, amp);

	lfo4 = Duty.kr(1/4/~t, 0, Dseq([
		1,0,4,3,
	].midiratio,inf));
	sig2 = SinOsc.ar(freq * 2 * lfo4 * ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1));
	sig2 = Splay.ar(sig2, \spread.kr(0.8), amp, pan);

	sig3 = LFSaw.ar(freq * ( SinOsc.ar(freq/3) * 1 + 1 ));
	lfo6 = ( SinOsc.kr(0.13) * 0.81 + 1 );
	sig3 = RLPF.ar(sig3, \lpfr3.kr(3.1) * lfo6 * freq, \rq.kr(0.5));
	sig3 = Pan2.ar(sig3, pan, amp);

	sig = [sig1,sig2,sig3].sum * 0.7;
	sig;
}).play;
);

(
SynthDef(\arrange, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;

	freq = 48.midicps;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		0,3,3,2,
	],inf)).midiratio;

	env5 = EnvGen.kr(Env([0,0,1,0,0],[6,4,0.5,1000.8]/~t), 1);
	env2 = EnvGen.kr(Env([0,1,0],[LFNoise1.kr(1!4).range(0.1,0.4),0.8]), Dust.kr(1/8!4));
	env2 = SelectX.kr(env5, [env2, 0.71]);
	env3 = EnvGen.kr(Env([0,0,1,1],[2,1.1,1000.8]), 1);
	sig2 = LFSaw.ar(freq*2 * [9,3,5,7].midiratio * ( SinOsc.ar(freq * env3) * env3 * 0.5 + 1 )) * env2;
	sig2 = RLPF.ar(sig2, \lpfr.kr(4.1) * freq, \rq.kr(0.5));
	sig2 = sig2.sum * env3;
	sig2 = sig2 * LFPulse.kr(8*~t).range(0,1);

	env1 = EnvGen.kr(Env([0,1,1],[2,1000.8]), 1);
	sig1 = SinOsc.ar(freq * ( SinOsc.ar(freq * ( 5 - 24 ).midiratio * (sig2 * 10 + 1)) * env1 + 1 ));
	sig1 = sig1 + (sig1.fold( SinOsc.ar(0.01 * [1,1.2123,12.1]).sum) * SinOsc.ar(0.1 * [1,1.2123]).range(0,0.2).sum);

	sig3 = SinOsc.ar(SinOsc.ar(1 * [1,2,3,4] * ~t) + 1 * freq * (9 + 12).midiratio) * EnvGen.kr(Env([0,1,0],[0.001,0.01]), Impulse.kr(4 * [1,2,3,4] * ~t)) * LFPulse.ar([1,2,3,4]/3 * ~t).range(0,1);
	sig3 = sig3.sum;
	lfo1 = SinOsc.ar(1/4) * 1.9 + 1; 
	sig3 = RLPF.ar(sig3, (\lpfr3.kr(2.1) * lfo1  * freq).clip(20, 20000), \rq.kr(0.5));
	sig3 = CombL.ar(sig3, 4/~t, 1/8/~t * (Amplitude.kr(sig1) * 0.003 + 1),1/~t) * 0.2 + sig3;
	sig3 = sig3 * env1;

	//env5 = EnvGen.kr(Env([0,0,1,0,0],[0,4,0.5,1000.8]/~t), 1);
	sig4 = WhiteNoise.ar * env5 * 0.5;
	sig4 = FreqShift.ar(sig4, ( SinOsc.kr(1*~t * ( env5 * 4.9 + 1 )) * env5 + 1 ) * 100) + sig4;
	sig4 = BPF.ar(sig4, freq * ( SinOsc.kr(1.1 *~t) * 0.81 * env5 + 4 ), 1)*2;

	env4 = EnvGen.kr(Env([1,1,0,0,1,1],[6,0.01,4-0.02,0.01,1000]/~t), 1);

	sig = [sig1 * env4,sig2, sig3, sig4].sum;
	//sig = sig4;

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\arrange2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;

	freq = 48.midicps;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		0,3,3,2,
	],inf)).midiratio;

	lfo2 = Duty.kr(1/3/~t, 0, Dseq([
		1,3,1.2,1.4,10
	],inf)).lag(0.1);
	lfo3 = ( SinOsc.kr(0.041) * 1 + 1 );
	lfo1 = SinOsc.ar(0.1 * lfo2).range(lfo3,0.6);
	sig1 = Pulse.ar(freq, lfo1);
	lfo5 = ( SinOsc.kr([0.04,0.23]).sum * 0.31 + 1 );
	sig1 = RLPF.ar(sig1, \lpfr.kr(4.1) * freq * lfo5, \rq.kr(0.5)) + ( sig1 * 0.3 );
	sig1 = Pan2.ar(sig1, pan, amp);

	lfo4 = Duty.kr(1/4/~t, 0, Dseq([
		1,0,4,3,
	].midiratio,inf));
	sig2 = SinOsc.ar(freq * 2 * lfo4 * ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1));
	sig2 = Splay.ar(sig2, \spread.kr(0.8), amp, pan);

	sig3 = LFSaw.ar(freq * ( SinOsc.ar(freq/3) * 1 + 1 ));
	lfo6 = ( SinOsc.kr(0.13) * 0.81 + 1 );
	sig3 = RLPF.ar(sig3, \lpfr3.kr(3.1) * lfo6 * freq, \rq.kr(0.5));
	sig3 = Pan2.ar(sig3, pan, amp);

	sig = [sig1,sig2,sig3].sum * 2.7;

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\arrange3, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;


	lfo2 = Duty.kr(1/3/~t, 0, Dseq([
		1,3,1.2,1.4,10
	],inf)).lag(0.1);
	lfo3 = ( SinOsc.kr(0.041) * 1 + 1 );
	lfo1 = SinOsc.ar(0.1 * lfo2).range(lfo3,0.6);
	sig1 = Pulse.ar(freq, lfo1);
	lfo5 = ( SinOsc.kr([0.04,0.23]).sum * 0.31 + 1 );
	sig1 = RLPF.ar(sig1, \lpfr.kr(4.1) * freq * lfo5, \rq.kr(0.5)) + ( sig1 * 0.3 );
	sig1 = Pan2.ar(sig1, pan, amp) * EnvGen.kr(\adsr1.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:0);

	lfo4 = Duty.kr(Dwhite(0.1,1.7)/8/~t, 0, Dseq([
		Dseq([
			1,0,4,3,
		],1),
	].midiratio,inf));
	sig2 = LFSaw.ar(freq * 1/2 * lfo4 * ((0..7)/7 - 0.5 * \fspread.kr(0.01) + 1));
	sig2 = RLPF.ar(sig2, \lpfr2.kr(4.1) * freq, \rq.kr(0.5));
	sig2 = Splay.ar(sig2, \spread.kr(0.8), amp, pan) * EnvGen.kr(\adsr2.kr(Env.adsr(0.4,0.1,0.8,2.1)), gate, doneAction:2) * \amp2.kr(0);

	sig3 = LFSaw.ar(freq * ( SinOsc.ar(freq/3) * 1 + 1 ));
	lfo6 = ( SinOsc.kr(0.13) * 0.81 + 1 );
	sig3 = RLPF.ar(sig3, \lpfr3.kr(3.1) * lfo6 * freq, \rq.kr(0.5));
	sig3 = Pan2.ar(sig3, pan, amp);

	sig = [sig1,sig2,sig3].sum * 2.7;

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,1.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\arrange2, 
	Ppar([
		Pmono(\arrange2,
			\note, 0,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\ploux2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr(Env([1,2,1,0.1],[0.1,0.8,1])), 1);
	env2 = EnvGen.kr(\env2.kr(Env([1,2,1,0.1],[0.1,0.8,1])), 1);
	sig = SinOsc.ar(freq * env1.round(\roundfreq.kr(0.3)));
	sig = sig + SinOsc.ar(freq * env1);
	sig = sig.fold(\fold.kr(1) * env2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\ploux2part, 
	Ppar([
		Pbind(
			\instrument, \ploux2,
			\freq, Pseg(Pseq([1,3],inf),8)*40*Pseq([1,1,1.2],inf),
			\at, Pseg(Pseq([0,1],inf),8),
			\dec, Pseg(Pseq([3,0.1],inf),3),
			\roundfreq, Pseg(Pseq([0,0.01,1,0.4],inf),9),
			\env1, Pfunc({ arg ev;
				[Env([ev[\at],ev[\dec],1,2.1],[0.1,0.2,1])]
			}),
			\env2, Pfunc({ arg ev;
				[Env([ev[\dec],ev[\at],0.61,0.01],[0.4,0.1,1])]
			}),
			\dur, Pseg(Pseq([0.1,0.05,1,0.31,0.07],inf),7),
			\sustain, 2,
			\amp, 0.051,
			\out, BusDef(\comp, \audio),
		),
		Pbind(
			\instrument, \ploux2,
			\freq, Pseg(Pseq([1,1.13,0.98],inf),1.1)*321.4,
			\at, Pseg(Pseq([0,1],inf),8),
			\dec, Pseg(Pseq([3,0.1],inf),3),
			\roundfreq, Pseg(Pseq([0,0.01,1,0.4],inf),9),
			\env1, Pfunc({ arg ev;
				[Env([ev[\at],ev[\dec],1,0.1]/100+1,[0.1,0.1,1])]
			}),
			\env2, Pfunc({ arg ev;
				[Env([ev[\dec],ev[\at],0.61,0.01],[0.4,0.1,1])]
			}),
			\dur, Pseg(Pseq([0.1,0.05,1,1],inf),8),
			\sustain, 1,
			\amp, 0.051,
			\out, BusDef(\comp, \audio),
		),
		Pmono(\simplecomp,
			\inbus, BusDef(\comp, \audio),
			\cpt, 0.1,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		
	])
)).play;
);

(
SynthDef(\bassyet, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	sig1 = LFSaw.ar(freq);
	sig2 = SinOsc.ar(freq+\oscder.kr(10));
	sig = SelectX.ar( sig2, [sig1, sig2]);
	sig = sig * EnvGen.kr(\oscadsr.kr(Env.adsr(0.1,0.4,0.3,2.1)), gate, doneAction:0);

	lfo1 = Duty.kr(1/8/~t, 0, Dseq([
		Drand([
			1,0,-2,4,
			1+12,12,-2+12,4+12,
		],1),
	],inf)).midiratio * 2;
	sig3 = SinOsc.ar(freq * lfo1 * (sig*0.3 +1)) * LFPulse.kr([4,7,14]*~t).unipolar.sum/4 * LFPulse.kr([4,7,14]+1*~t).unipolar.sum;
	sig = sig + sig3;

	env1 = EnvGen.kr(\lpenv.kr(Env([0,1,0.5,1,0],[0.01,0.01,0.01,1])), 1);
	sig = RLPF.ar(sig, \lpfr.kr(5.1) * freq * (env1 * \lpenvamt.kr(3.2) + 1), \rq.kr(0.5));


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,4.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\bassyetmono_trail, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var trig;
	trig = \trigger.tr(1);

	sig1 = LFSaw.ar(freq);
	sig2 = SinOsc.ar(freq+\oscder.kr(10));
	sig = SelectX.ar( sig2, [sig1, sig2]);
	env2 = EnvGen.kr(\oscadsr.kr(Env.adsr(0.01,0.4,0.3,2.1)), Trig.kr(\trigger.tr(1),0.1), doneAction:0);
	sig4 = sig;
	sig = sig * env2;

	env5 = Dust.kr(1) * Trig.kr(trig,2) + trig;
	lfo1 = ( SinOsc.kr(0.04,1.7) * 1 + 1 * 0.21 );
	lfo2 = ( SinOsc.kr(0.0223,0.3) * 1 + 1 * 0.21 );
	env3 = EnvGen.kr(Env([0,1,0],[0.01, lfo1]), env5);
	env4 = EnvGen.kr(Env([3,1,1,1/4],[0.01,0.1,lfo2]), env5);
	sig3 = SinOsc.ar(freq * env4 ) * ( SinOsc.ar(freq * 2 * ( SinOsc.kr(0.1) * 0.1 + 1 )) * 0.1 + 1 ) + ( sig4*0.2 ) * env3 * 4;
	sig = sig + sig3;
	//sig = sig3;

	env1 = EnvGen.kr(\lpenv.kr(Env([0,1,0.5,1,0],[0.01,0.01,0.01,1])), 1);
	sig = RLPF.ar(sig, \lpfr.kr(5.1) * freq * (env1 * \lpenvamt.kr(0.2) + 1), \rq.kr(0.5));


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp) * 3;
	Out.ar(out, sig);
}).add;
SynthDef(\bassyetmono, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig1 = LFSaw.ar(freq);
	sig2 = SinOsc.ar(freq+\oscder.kr(10));
	sig = SelectX.ar( sig2, [sig1, sig2]);

	env1 = EnvGen.kr(\lpenv.kr(Env([0,1,0.02,2,0],[0.1,1.01,1.01,1])), \trigger.tr(1));
	sig = RLPF.ar(sig, \lpfr.kr(5.1) * freq * (env1 * \lpenvamt.kr(3.2) + 1), \rq.kr(0.5));

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\bassyetmono2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig1 = LFSaw.ar(freq * [1,1+\det.kr(0.01)]);
	sig2 = SinOsc.ar(freq+\oscder.kr(10) * [1,1+\det.kr]);
	sig = SelectX.ar( sig2, [sig1, sig2]);

	env1 = EnvGen.kr(\lpenv.kr(Env([0,1,0.02,2,0],[0.1,1.01,1.01,1])), \trigger.tr(1));
	sig = RLPF.ar(sig, \lpfr.kr(5.1) * freq * (env1 * \lpenvamt.kr(3.2) + 1), \rq.kr(0.5));

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [-1,1]*env1+pan, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\padbroke, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	env1 = EnvGen.kr(\lpenv.kr(Env([1,2,1],[4.1,4.8])), 1);
	env2 = EnvGen.kr(\fmenv.kr(Env([0,2,1],[4.1,4.8])), 1);
	sig1 = SinOsc.ar(freq * [1,1+\det.kr(0.00001)] * ( SinOsc.ar(freq*[2,1/2,1+\det.kr]).sum * env2 + 1 ));
	sig2 = LFSaw.ar(freq * [1,1+\det.kr]);
	sig2 = sig2 * EnvGen.kr(\sawenv.kr(Env([0,1,0],[1.1,1.8])), 1);
	sig2 = LPF.ar(sig2, \lpf.kr(4000) * env1);
	sig2 = sig2 * 1;

	sig3 = SinOsc.ar(freq * [1,1+\det.kr(0.00001)]/2 * ( SinOsc.ar(freq*[2,1/2,1+\det.kr]).sum * env2 + 1 ));
	sig3 = sig3 + SinOsc.ar(freq * [1,1+\det.kr(0.00001)]/4 * ( SinOsc.ar(freq*[2,1/2,1+\det.kr]).sum * env2 + 1 ));

	lfo1 = SinOsc.ar(0.1 * ( LFNoise1.kr(0.1 * env2).unipolar * 10 + 1 )).unipolar;
	sig = SelectX.ar(\oscmix.kr(0.9) * lfo1 , [sig1, sig2]);
	sig = sig + (sig3 * LFNoise1.kr(1).unipolar);

	sig5 = sig.fold2(0.1)*4;
	sig = SelectX.ar(\foldmix.kr(0.3) * lfo1, [sig, sig5]);

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [1,-1], amp).mean;
	Out.ar(out, sig);
}).add;
)

(
// test bass
Pdef(\part, Pdef(\zed, 
	Ppar([
		
		Pbind(
			\instrument, \bassyet,
			\octave, 3,
			\oscder, ~pmodenv.(Pseq([0,0.1,1],inf), 8),
			\note, Pseq([
				0,3,3,2,
			],inf),
			\legato, 0.3,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\sec2, 
	Ppar([
		Pbind(
			\instrument, \bassyet,
			\octave, 3,
			\oscder, ~pmodenv.(Pseq([0,0.1,1],inf), 8),
			\note, Pseq([
				0,3,3,2,
			],inf),
			\legato, 0.3,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\bassyetmono,
			\note, Pstep(Pseq([
				0,3,3,2,
			],inf),1),
			\octave, Prand([4,5,6],inf),
			\oscder, ~pmodenv.(Pseq([10,0,5.1,1,20,0],inf), 8),
			\trigger, Pstep(Pseq([1,0],inf),1),
			\dur, PdurStutter(Prand([1,1,1,4,2,8],inf), 1),
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \iron,
			\note, Pbrown(0,12,1),
			\mtranspose, Pstep(Pseq([
				0,3,3,2,
			],inf),1),
			\isRest, Pseq([
				1,0.5
			],inf).coin.not,
			\dur, PdurStutter(Pseq([1,4,2,8],inf), 1/2),
			\amp, 0.1/4,
			\out, BusDef(\fxchorus2, \audio),
		),
		Pmono(\fx_flanger,
			\inbus, BusDef(\fxchorus2, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 0.1,
			\fb, 0.9,
			\lfomul, 0.0001,
			\delay, 0.01,
			\gain,1,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\tmix1, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\tmix1),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0.1,
			\sendbus0, BusDef(\fxchorus, \audio, 2),
			\dur, 1,
		),
		Pbind(
			\instrument, \padbroke,
			\note, Pseq([
				[0,12, 12+7],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(1.1,0.1,0.8,2.1) ],
			],inf),
			\octave, 6,
			\legato, 1,
			\ctranspose, Pseq([
				0,3,3,2,
			],inf),
			\dur, 1,
			\amp, 0.1/3,
			\out, BusDef(\fxchorus, \audio),
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fxchorus, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 0.5,
			\fb, 0.9,
			\delay, 0.1,
			\diff, 0.001,
			\modfreq, 0.1,
			\modamp, 1/6,
			\gain,2,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fxverb,\audio),
		),
		Pmono(\fx_freeverb2,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\fxverb, \audio),
			\verbmix, 0.6,
			\room, 1.9,
			\damp, 0.7,
			\mix, 1,
			\gain, 1/2,
			\dur, 2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_mainTimeline_t0_200506_224210').buffer,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\legato, 1,
			\speed, -1,
			\pos, 0.2,
			\dur, 1/8,
			\gain, 0.71,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_mainTimeline_t0_200506_224210').buffer,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,1,0, 0,0,1,0, 0,1,1,0,
				0,0,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 1,
			\speed, 1,
			\pos, 0.2,
			\dur, 1/16,
			\gain, 0.71,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[690].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			\out, BusDef(\verb, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2435].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
			\out, BusDef(\verb, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//	\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1093].value,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.05 * Pseq([0.7,1],inf),
		),
		Pmono(\fx_freeverb2,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\verb, \audio),
			\verbmix, 0.4,
			\room, 0.5,
			\damp, 0.7,
			\mix, 1/4,
			\gain, 0.41,
			\dur, 2,
		),
		
	])
)).play;
);

(
// prog
Pdef(\part, Pdef(\sec2, 
	Ppar([
		Psched( [0,100], Pmono(\bassyetmono_trail,
			\note, Pstep(Pseq([
				0,3,3,2,
			],inf),1),
			\octave, 3,
			\lpfr, 5,
			\oscder, 10,
			\trigger, Pstep(Pseq([1,0],inf),1/2),
			\dur, 1,
			\amp, 0.1/4,
			//\out, BusDef(\rev1, \audio),
		),),
		Pmono(\bassyetmono2,
			\note, Pstep(Pseq([
				0,3,3,2,
			],inf),1),
			\octave, 5,
			\lpfr, ~pmodenv.(Pseq([1/4,4],inf), 8),
			\oscder, 10,
			\trigger, Pstep(Pseq([1,0],inf),1),
			\dur, 1,
			\amp, 0.1/4,
			//\out, BusDef(\rev1, \audio),
		),
		Pbind(
			\instrument, \padbroke,
			\note, Pseq([
				[0,12, 12+7],
				[0,12, 12+7],
				[0,12, 12+7],
				[0,3, 12+3],

				[0+12,3, 12+3],
				[0,3, 12+3],
				[0,3, 12+3],
				[3, 12+3,11+24],
			],inf)-12,
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(1.1,0.1,0.8,2.1) ],
				],8),
				Pseq([
					[ Env.adsr(1.1,0.1,0.8,0.5) ],
				],inf),
			],inf),
			\octave, 6,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\legato, 0.1,
			\ctranspose, Pseq([
				0,3,3,2,
			],inf),
			\dur, 1,
			\amp, 0.1/1,
			\out, BusDef(\fxchorus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_mainTimeline_t0_200506_224210').buffer,
			\legato, Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				1/2,0,1/3,1,

				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\speed, -1,
			\pos, 1/~t/4,
			\dur, 1/4,
			\gain, 0.71,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_mainTimeline_t0_200506_224210').buffer,
			\legato, Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,

				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\speed, -1,
			\pos, 1/~t,
			\dur, 1/4,
			\gain, 0.71,
		),
		Psched(8,
			Ppar([
				Pbind(
					\instrument, \iron,
					\note, Pbrown(0,12,1),
					\mtranspose, Pstep(Pseq([
						0,3,3,2,
					],inf),1),
					\isRest, Pseq([
						1,0.5
					],inf).coin.not,
					\dur, PdurStutter(Pseq([1,4,2,8],inf), 1/2),
					\amp, 0.1/4,
					\out, BusDef(\fxchorus2, \audio),
				),
				Pmono(\fx_flanger,
					\inbus, BusDef(\fxchorus2, \audio),
					\addAction, \addToTail,
					\lag, 0.0006,
					\mix, 0.1,
					\fb, 0.9,
					\lfomul, 0.0001,
					\delay, 0.01,
					\gain,1,
					\dur, 1,
					\amp, 0.1,
					\out, BusDef(\tmix1, \audio),
				),
				Pmono(\simpletrackmixer,
					\inbus, BusDef(\tmix1),
					\pregain, 1,
					\postgain, 1,
					\delay, 0,
					\send0, 0.1,
					\sendbus0, BusDef(\fxchorus, \audio, 2),
					\dur, 1,
				),
				Pbind(
					\instrument, \padbroke,
					\note, Pseq([
						[0,12, 12+7],
					],inf),
					\adsr, Pseq([
						[ Env.adsr(1.1,0.1,0.8,2.1) ],
					],inf),
					\octave, 6,
					\legato, 1,
					\ctranspose, Pseq([
						0,3,3,2,
					],inf),
					\dur, 1,
					\amp, 0.1/3,
					\out, BusDef(\fxchorus, \audio),
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, SampleTimeline('rec_mainTimeline_t0_200506_224210').buffer,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,1, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
					],inf).coin.not,
					\legato, 1,
					\speed, -1,
					\pos, 0.2,
					\dur, 1/8,
					\gain, 0.71,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, SampleTimeline('rec_mainTimeline_t0_200506_224210').buffer,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,1,1, 0,0,1,0, 0,0,1,0, 0,1,1,0,
						0,0,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\legato, 1,
					\speed, 1,
					\pos, 0.2,
					\dur, 1/16,
					\gain, 0.71,
				),

				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.kick[690].value,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,1,
						0,0,1,0, 0,0,0,1,
						1,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,1,1,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.3,
					\out, BusDef(\verb, \audio),
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.snare[2435].value,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.61,
					\out, BusDef(\verb, \audio),
				),
				Pbind(
					\instrument, \playersec,
					//	\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\bufnum, ~buflib.hat[1093].value,
					\isRest, Pseq([
						1,1,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.05 * Pseq([0.7,1],inf),
				),
				Pmono(\fx_freeverb2,
					\addAction, \addToTail,
					\lag, 0.0005,
					\inbus, BusDef(\verb, \audio),
					\verbmix, 0.4,
					\room, 0.5,
					\damp, 0.7,
					\mix, 1/4,
					\gain, 0.41,
					\dur, 2,
				),
			]),
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fxchorus, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 0.5,
			\fb, 0.9,
			\delay, 0.1,
			\diff, 0.001,
			\modfreq, 0.1,
			\modamp, 1/6,
			\gain,2,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fxverb,\audio),
		),
		Pmono(\fx_freeverb2,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\fxverb, \audio),
			\verbmix, 0.6,
			\room, 1.9,
			\damp, 0.7,
			\mix, 1,
			\gain, 1/2,
			\dur, 2,
		),

	])
)).play;
);

(
// prog + new bass
Pdef(\part, Pdef(\sec2, 
	Ppar([
		Psched( [100,8], Pmono(\bassyetmono_trail,
			\note, Pstep(Pseq([
				0,3,3,2,
			],inf),1),
			\octave, 3,
			\lpfr, 5,
			\oscder, 10,
			\trigger, Pstep(Pseq([1,0],inf),1/2),
			\dur, 1,
			\amp, 0.1/4,
			//\out, BusDef(\rev1, \audio),
		),),
		Pmono(\bassyetmono2,
			\note, Pstep(Pseq([
				0,3,3,2,
			],inf),1),
			\octave, 5,
			\lpfr, ~pmodenv.(Pseq([1/4,4],inf), 8),
			\oscder, 10,
			\trigger, Pstep(Pseq([1,0],inf),1),
			\dur, 1,
			\amp, 0.1/4,
			//\out, BusDef(\rev1, \audio),
		),
		Pbind(
			\instrument, \padbroke,
			\note, Pseq([
				[0,12, 12+7],
				[0,12, 12+7],
				[0,12, 12+7],
				[0,3, 12+3],

				[0+12,3, 12+3],
				[0,3, 12+3],
				[0,3, 12+3],
				[3, 12+3,11+24],
			],inf)-12,
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(1.1,0.1,0.8,2.1) ],
				],8),
				Pseq([
					[ Env.adsr(1.1,0.1,0.8,0.5) ],
				],inf),
			],inf),
			\octave, 6,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\legato, 0.1,
			\ctranspose, Pseq([
				0,3,3,2,
			],inf),
			\dur, 1,
			\amp, 0.1/1,
			\out, BusDef(\fxchorus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_mainTimeline_t0_200506_224210').buffer,
			\legato, Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				1/2,0,1/3,1,

				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\speed, -1,
			\pos, 1/~t/4,
			\dur, 1/4,
			\gain, 0.71,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_mainTimeline_t0_200506_224210').buffer,
			\legato, Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,

				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\speed, -1,
			\pos, 1/~t,
			\dur, 1/4,
			\gain, 0.71,
		),
		Psched(0,
			Ppar([
				Pbind(
					\instrument, \arrange3,
					\note, 0,
					\dur, 1,
					\amp, 0.2,
					\legato, 0.1,
					\note, Pstep(Pseq([
						0,3,3,2,
					],inf),1),
					\octave, 3,
				),
				Pbind(
					\instrument, \iron,
					\note, Pbrown(0,12,1),
					\mtranspose, Pstep(Pseq([
						0,3,3,2,
					],inf),1),
					\isRest, Pseq([
						1,0.5
					],inf).coin.not,
					\dur, PdurStutter(Pseq([1,4,2,8],inf), 1/2),
					\amp, 0.1/4,
					\out, BusDef(\fxchorus2, \audio),
				),
				Pmono(\fx_flanger,
					\inbus, BusDef(\fxchorus2, \audio),
					\addAction, \addToTail,
					\lag, 0.0006,
					\mix, 0.1,
					\fb, 0.9,
					\lfomul, 0.0001,
					\delay, 0.01,
					\gain,1,
					\dur, 1,
					\amp, 0.1,
					\out, BusDef(\tmix1, \audio),
				),
				Pmono(\simpletrackmixer,
					\inbus, BusDef(\tmix1),
					\pregain, 1,
					\postgain, 1,
					\delay, 0,
					\send0, 0.1,
					\sendbus0, BusDef(\fxchorus, \audio, 2),
					\dur, 1,
				),
				Pbind(
					\instrument, \padbroke,
					\note, Pseq([
						[0,12, 12+7],
					],inf),
					\adsr, Pseq([
						[ Env.adsr(1.1,0.1,0.8,2.1) ],
					],inf),
					\octave, 6,
					\legato, 1,
					\ctranspose, Pseq([
						0,3,3,2,
					],inf),
					\dur, 1,
					\amp, 0.1/3,
					\out, BusDef(\fxchorus, \audio),
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, SampleTimeline('rec_mainTimeline_t0_200506_224210').buffer,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,1, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
					],inf).coin.not,
					\legato, 1,
					\speed, -1,
					\pos, 0.2,
					\dur, 1/8,
					\gain, 0.71,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, SampleTimeline('rec_mainTimeline_t0_200506_224210').buffer,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,1,1, 0,0,1,0, 0,0,1,0, 0,1,1,0,
						0,0,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\legato, 1,
					\speed, 1,
					\pos, 0.2,
					\dur, 1/16,
					\gain, 0.71,
				),

				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.kick[690].value,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,1,
						0,0,1,0, 0,0,0,1,
						1,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,1,1,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.3,
					\out, BusDef(\verb, \audio),
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.snare[2435].value,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.61,
					\out, BusDef(\verb, \audio),
				),
				Pbind(
					\instrument, \playersec,
					//	\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\bufnum, ~buflib.hat[1093].value,
					\isRest, Pseq([
						1,1,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.05 * Pseq([0.7,1],inf),
				),
				Pmono(\fx_freeverb2,
					\addAction, \addToTail,
					\lag, 0.0005,
					\inbus, BusDef(\verb, \audio),
					\verbmix, 0.4,
					\room, 0.5,
					\damp, 0.7,
					\mix, 1/4,
					\gain, 0.41,
					\dur, 2,
				),
			]),
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fxchorus, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 0.5,
			\fb, 0.9,
			\delay, 0.1,
			\diff, 0.001,
			\modfreq, 0.1,
			\modamp, 1/6,
			\gain,2,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fxverb,\audio),
		),
		Pmono(\fx_freeverb2,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\fxverb, \audio),
			\verbmix, 0.6,
			\room, 1.9,
			\damp, 0.7,
			\mix, 1,
			\gain, 1/2,
			\dur, 2,
		),

	])
)).play;
);


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
Pdef(\demo, 
	Pmono(\distbass,
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
)
).play;
)

(
Pdef(\part, Pdef(\revpart3, 
	Ppar([
		Pmono(\distbass,
			\note, Pstep(Pseq([
				0,3,3,2,
			],inf),1),
			\octave, 3,
			\fmrange, Pseq([0.5,1,1.5],inf),
			\fmfreq, Pseq([0.5,1,2,4],inf),
			\dur, 1/16,
			\igate, Pseq([
				1,0,
			],inf),
			\iadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpf, Pkey(\freq) * Pseq([2,1,4,8],inf).stutter(8),
			\hpf, Pkey(\freq) / 2,

			\amp, 0.3 * Pseq([
				1,Pwhite(0.1,0.7),
			],inf),
			\isRest, false,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_mainTimeline_t0_200506_224210').buffer,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\legato, 1,
			\speed, -1,
			\pos, 0.2,
			\dur, 1/8,
			\gain, 0.71,
		),
		Pbind(
			\instrument, \padbroke,
			\note, Pseq([
				[0,12, 12+7],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(1.1,0.1,0.8,2.1) ],
			],inf),
			\octave, 6,
			\legato, 1,
			\ctranspose, Pseq([
				0,3,3,2,
			],inf),
			\dur, 1,
			\amp, 0.1/3,
			\out, BusDef(\fxchorus, \audio),
		),
		Pbind(
			\instrument, \padbroke,
			\note, Pseq([
				[0,12, 12+7],
				[0,12, 12+7],
				[0,12, 12+7],
				[0,3, 12+3],

				[0+12,3, 12+3],
				[0,3, 12+3],
				[0,3, 12+3],
				[3, 12+3,11+24],
			],inf)-12,
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(1.1,0.1,0.8,2.1) ],
				],8),
				Pseq([
					[ Env.adsr(1.1,0.1,0.8,0.5) ],
				],inf),
			],inf),
			\octave, 6,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\legato, 0.1,
			\ctranspose, Pseq([
				0,3,3,2,
			],inf),
			\dur, 1,
			\amp, 0.1/1,
			\out, BusDef(\fxchorus, \audio),
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fxchorus, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 0.5,
			\fb, 0.9,
			\delay, 0.1,
			\diff, 0.001,
			\modfreq, 0.1,
			\modamp, 1/6,
			\gain,2,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fxverb,\audio),
		),
		Pmono(\fx_freeverb2,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\fxverb, \audio),
			\verbmix, 0.6,
			\room, 1.9,
			\damp, 0.7,
			\mix, 1,
			\gain, 1/2,
			\dur, 2,
			\out, BusDef(\hpf, \audio),
		),
		Pmono(\fx_rhpf,
			\inbus, BusDef(\hpf, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\hpf, ~pmodenv.(Pseq([100,2000],inf), 8),
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_mainTimeline_t0_200506_224210').buffer,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,1,0, 0,0,1,0, 0,1,1,0,
				0,0,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 1,
			\speed, 1,
			\pos, 0.2,
			\dur, 1/16,
			\gain, 0.71,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[690].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			\out, BusDef(\verb, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2435].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
			\out, BusDef(\verb, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//	\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1093].value,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.05 * Pseq([0.7,1],inf),
		),
		Pmono(\fx_freeverb2,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\verb, \audio),
			\verbmix, 0.4,
			\room, 0.5,
			\damp, 0.7,
			\mix, 1/4,
			\gain, 0.41,
			\dur, 2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_mainTimeline_t0_200506_224210').buffer,
			\legato, Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,

				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\speed, -1,
			\pos, 1/~t,
			\dur, 1/4,
			\gain, 0.71,
		),

	])
)).play;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[690].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			\out, BusDef(\verb, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2435].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
			\out, BusDef(\verb, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[245].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, 2,
			\dur, 1/8,
			\gain, 0.31,
			\out, BusDef(\verb, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[89].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0, 1,0,1,1, 1,0,0,1,
				0,0,1,0, 0,1,1,0, 1,0,0,0, 0,0,1,1,
				1,0,0,0, 1,1,1,0, 0,0,0,1, 1,0,0,1,
				0,0,1,1, 0,1,1,0, 1,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[241].value,
			\isRest, Pseq([
				0,1,0,1, 0,0,1,1,
				0,0,1,0, 0,0,1,1,
				0,0,1,1, 0,0,1,1,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				Pseg(Pseq([0.1,1],inf),1/7),
				1,1/4
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.3,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.31,
			\out, BusDef(\verb, \audio),
		),
		Pmono(\fx_freeverb2,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\verb, \audio),
			\verbmix, 0.4,
			\room, 0.5,
			\damp, 0.7,
			\mix, 1/4,
			\gain, 0.41,
			\dur, 2,
		),
		
	])
)).play;
);
