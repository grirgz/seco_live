
(
	// basic
	RandDelayNetwork(\yap, {
		var block, algo;
		block = [
			\flanger!4,
			\delay!8,
			\delay2!8,
			\bpf!2, 
			\brf!2,
			\shift!4,
			\shift2!4,
			\dist!2,
		].flatten.choose;
		algo = [
			\par, \seq
		].wchoose([0.1,0.9].normalizeSum);
		if(algo == \par) {
			\par -> [2,4].choose.collect({
				\seq -> [ block, \end ]
			})
		} {
			\seq -> ([block] ++ (\end ! [1,2].choose))
		}
	},
	IdentityDictionary.newFrom([
		\delay, { arg si;
			DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		},
		\delay2, { arg si;
			DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		},
		\flanger, { arg si;
			DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		},
		\shift, { arg si;
			FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
		},
		\shift2, { arg si;
			FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
		},
		\bpf, { arg si;
			BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		},
		\brf, { arg si;
			BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		},
		\dist, { arg si;
			(si * 10.rand * \distamp.kr).tanh / 2;
		},
		\end, { arg si;
			si;
		}
	]));

)

//////////////////////////////////////////////////////////////////////////////////::

(
	// real!!!!!!
	RandDelayNetwork(\yap, {
		var block, algo;
		block = [
			//\delay!8,
			//\bpf,
			//\brf,
			\delay,
			//\delayrev,
			//\fm2,
			\fm3,
			//\add,
			//\comb,
		].flatten.choose;
		algo = [
			\par, \seq
		].wchoose([0.5,0.5].normalizeSum);
		if(algo == \par) {
			\par -> [2,4].choose.collect({
				\seq -> [ block, \end ]
			})
		} {
			\seq -> ([block] ++ (\end ! [1,2].choose))
		}
	},
	IdentityDictionary.newFrom([
		\fm, { arg si;
			var sig = SinOsc.ar(\freq.kr(100) * (1+ ( 1.0.rand * \shift.kr(1) )) * ( 1 + ( SinOsc.ar(si) * \distamp.kr(1 ))));
			sig = sig + sig;
			sig / 1.12;
		},
		\comb, { arg si;
			CombL.ar(si, 1, \delay.kr * exprand(0.001,1), \delay2.kr) + si / 1.00;
		
		},
		\fm2, { arg si;
			var sig = SinOsc.ar(exprand(100,17000) * \shift.kr(1) * ( 1 + ( SinOsc.ar(si) * \distamp.kr(1 ))));
			//sig = sig + sig;
			//sig / 1.12;
			sig;
		
		},
		\fm3, { arg si;
			var sig = LFSaw.ar(
				//exprand(100,17000) 
				\freq.kr
				* (1+ ( 1.0.rand * \shift.kr ) )
				* ( 1 + ( si * \distamp.kr))
			);
			//sig = sig + sig;
			//sig / 1.12;
			sig;
		
		},
		\add, { arg si;
			si + SinOsc.ar(exprand(100,17000) * \shift.kr(1))
		},
		\delay, { arg si;
			DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		},
		\delayrev, { arg si;
			var sig = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.11.rand] * \delay2.kr) + si;
			sig.reverse;
		},
		\delayt, { arg si;
			DelayL.ar(si, 2.8, { [1,2,3,4,5,6,7,8].choose }!2 / ~t * \delay.kr) + si;
		},
		\bpf, { arg si;
			BPF.ar(si, exprand(100,10000) * ( \delay.kr(1)+0.5 ), 0.5.rand + 0.01) + si / 2;
		},
		\brf, { arg si;
			BRF.ar(si, exprand(100,10000) * (\delay2.kr(1)+0.5), 0.5.rand + 0.01) + ( si / 4 );
		},
		\dist, { arg si;
			(si * 10.rand * \distamp.kr).tanh / 2;
		},
		\end, { arg si;
			si;
		}
	]));
	RandDelayNetwork(\yap).make(\fx1, "3--", BusDef(\fx1, \audio));

)
RandDelayNetwork(\yap).make(\fx1, "5--", BusDef(\fx1, \audio));
Ndef(\fx1).play
Ndef(\fx1).edit
Pdef(\perc_scar2).play
Pdef(\perc_scar2).stop

Ndef(\fx1).put(100, \pset -> Pbind(\degree, Pseq([0,2,4,2],inf), \dur, 2))

(
	// real!!!!!!
	Spec.add(\delrange, ControlSpec(0.00001,2,\exp));
	Spec.add(\delrange2, ControlSpec(0.00001,2,\exp));
	RandDelayNetwork(\yap, {
		var block, algo;
		block = [
			\delay,
			\delay2,
		].flatten.choose;
		algo = [
			\par, \seq
		].wchoose([0.5,0.5].normalizeSum);
		if(algo == \par) {
			\par -> [2,4].choose.collect({
				\seq -> [ block, \end ]
			})
		} {
			\seq -> ([block] ++ (\end ! [1,2].choose))
		}
	},
	IdentityDictionary.newFrom([
		\delay, { arg si;
			DelayL.ar(si, 0.8, rrand(0,1.0) * \delrange.kr + ( \delay.kr / ~t )) + si;
		},
		\delay2, { arg si;
			DelayL.ar(si, 0.8, rrand(0,1.0) * \delrange2.kr + ( \delay2.kr / ~t )) + si;
		},
		\end, { arg si;
			si;
		}
	]));
	RandDelayNetwork(\yap).make(\fx1, "5--", BusDef(\fx1, \audio));

)
RandDelayNetwork(\default).make(\fx1, "5--", BusDef(\fx1, \audio));
RandDelayNetwork(\yap).make(\fx2, "5--", BusDef(\fx2, \audio));
Ndef(\fx2).clear;
Ndef(\fx1).play
Ndef(\fx2).play
Ndef(\fx1).edit
Ndef(\fx2).edit
Pdef(\perc_scar2).play
Pdef(\perc_scar2).stop
Pdef(\hat).set(\out, BusDef(\fx2))

Ndef(\fx1).put(100, \pset -> Pbind(\degree, Pseq([0,2,4,2],inf), \dur, 2))


(
	// real!!!!!!
	Spec.add(\delrange, ControlSpec(0.00001,2,\exp));
	Spec.add(\delrange2, ControlSpec(0.00001,2,\exp));
	Spec.add(\delfmamp, ControlSpec(0.00001,8,\exp));
	Spec.add(\delfm, \widefreq);
	RandDelayNetwork(\flanger, {
		var block, algo;
		block = [
			\delay,
			\fold,
		].flatten.choose;
		algo = [
			\par, \seq
		].wchoose([0.5,0.5].normalizeSum);
		if(algo == \par) {
			\par -> [2,4].choose.collect({
				\seq -> [ block, \end ]
			})
		} {
			\seq -> ([block] ++ (\end ! [1,2].choose))
		}
	},
	IdentityDictionary.newFrom([
		\flanger, { arg si;
			DelayL.ar(si, 0.8, 
				rrand(0,1.0) * \delrange.kr + ( \delay.kr / ~t ) * ( 1 + ( SinOsc.ar(\delfm.kr * ~t) * \delfmamp.kr ))
			) + si;
		},
		\fold, { arg si;
			si.fold(rrand(0.5,4) * \fold.kr(1) * SinOsc.ar(\foldlfo.kr(1) * ~t).range(2,1));
		},
		\delay, { arg si;
			DelayL.ar(si, 0.8, rrand(0,1.0) * \delrange.kr + ( \delay.kr / ~t )) + si;
		},

		\delay2, { arg si;
			DelayL.ar(si, 0.8, rrand(0,1.0) * \delrange2.kr + ( \delay2.kr / ~t )) + si;
		},
		\end, { arg si;
			si;
		}
	]));
	RandDelayNetwork(\flanger).make(\fx1, "5--", BusDef(\fx1, \audio));

)
RandDelayNetwork(\default).make(\fx2, "5--", BusDef(\fx2, \audio));
RandDelayNetwork(\yap).make(\fx2, "5--", BusDef(\fx2, \audio));
Ndef(\fx2).clear;
Ndef(\fx1).play
Ndef(\fx2).play
Ndef(\fx1).edit
Ndef(\fx2).edit
Pdef(\perc_scar2).play
Pdef(\perc_scar2).stop
Pdef(\perc_scar2).set(\out, BusDef(\fx2));
Pdef(\main, Pset(\out, BusDef(\fx2), Pdef(\perc_scar2))).play
Pbindef(\perc_scar2, \out, BusDef(\fx2));
Pdef(\hat).set(\out, BusDef(\fx2))

Ndef(\fx1).put(100, \pset -> Pbind(\degree, Pseq([0,2,4,2],inf), \dur, 2))


////////////////////////////////////: perc
(
Pdef(\perc_scar2, (
	Ppar([

		// small kick
		Pbind(
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, Pkey(\amp) * 4/5,
			//\timeScale, 1/4,
			\dur, 1/4,
		)
		<>
		Pdef(\kick),

		// kick
		Pbind(
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0.2,0, 0.2,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0.9,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0.5,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0.5,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
		)
		<>
		Pdef(\kick),

		// snare 1
		Pbind(
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
		)
		<>
		Pdef(\basicsnare),

		// snarehat
		Pbind(
			\instrument, \basicsnare2,
			\sustain, 1,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, Pkey(\amp) * 1/2,
			\dur, 1/4,
		)
		<>
		Pdef(\basicsnare),

		// hat
		Pbind(
			\isRest, Pseq([
				Pseq([
					0,0,0.1,0, 0.4,0,0,0,
					0.2,0,0.1,0, 1,0,0,0,
				],6),
				Prand([
					Pseq([
						0,0,0,0, 0,0,0,0,
					],1),
					Pseq([
						1,0,0,1, 0,0,1,0,
					],1),
					Pseq([
						1,0,0,1, 0,0,1,0,
					],1),
					Pseq([
						1,0,1,0, 1,0,1,0,
					],1),
					Pseq([
						1,1,1,0, 1,0,1,0,
					],1),
				],2),
			],inf).coin.not,
			\rel, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,4,1,
				1,1,1,1, 1,1,1,1,
				Plazy({
					Prand([
						Pseq([1,1,1,1, 1,1,1,1/4].scramble),
						Pseq([1,1,1,1, 1,1,1,4].scramble)
					],1)
				}),
			],inf).stutter(1)/13 * Pseq([
				1.0,0.7,0.9,0.5,
			],inf).stutter(2),
			\dur, 1/4,
		)
		<>
		Pdef(\hat)
	])
));
)
RandDelayNetwork(\yap).make(\fx1, "5--", BusDef(\fx1, \audio));
Ndef(\fx1).play
Ndef(\fx1).edit
Pdef(\perc_scar2).play
Pdef(\perc_scar2).stop

(
Ndef(\pulseaudio, {
	SoundIn.ar([0,1]);
}).play(BusDef(\fx1, \audio).index, 2);
)

(
(
SynthDef(\gui, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1,1.001]);
	sig = RLPF.ar(sig, \lpf.kr(4700), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);
Ndef(\fx1).play;
Pdef(\gui, Pbind(
	\instrument, \gui,
	\root, Pseq([0,2,4,2],inf),
	\degree, [0,2,4],
	\scale, Scale.minor,
	\lpf, Ndef(\guilfo1, { SinOsc.kr(1/24).exprange(1050,10100)  }),
	\rq, Ndef(\guilfo2, { SinOsc.kr(1/34).exprange(0.01,1)  }),
	\dur, 8,
	\out, BusDef(\fx1),
	\amp, 0.1
)).play;
);
