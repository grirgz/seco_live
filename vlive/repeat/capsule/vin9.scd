		~t = 71/2/60; TempoClock.default.tempo = ~t;

(
SynthDef(\doublebell, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var tabsize = 30;
	sig = WhiteNoise.ar;
	sig = LFPulse.ar(freq) + sig;
	sig = sig * EnvGen.ar(Env.perc(0.001,0.01),gate);
	sig = sig + ( BPF.ar(WhiteNoise.ar * EnvGen.kr(Env([1,1/2,0],[0.1,0.8],-1), 1), freq,0.4)  );
	sig1 = Ringz.ar(sig, \freqtab.kr({exprand(0.99,1) }.dup(tabsize)) * freq, \res.kr(3.dup(tabsize))).mean;
	sig2 = Ringz.ar(sig, \freqtab2.kr({exprand(0.99,1.02)  }.dup(tabsize)) * freq, \res2.kr(0.1.dup(tabsize))).mean;
	sig = SelectX.ar(Line.kr(0.61,0.5,1/2), [sig1 , sig2]);
	//sig = HPF.ar(sig, EnvGen.kr(Env([1000,200,1000]+1000,[0.4,0.8]), 1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,1.5,1,1)), gate, doneAction:2) * 0.1;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\doublebell_damp, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var tabsize = 30;
	sig = WhiteNoise.ar;
	sig = LFPulse.ar(freq) + sig;
	sig = sig * EnvGen.ar(Env.perc(0.001,0.01),gate);
	sig = sig + ( BPF.ar(WhiteNoise.ar * EnvGen.kr(Env([1,1/2,0],[0.1,0.8],-1), 1), freq*2,0.1)  );
	sig1 = Ringz.ar(sig, \freqtab.kr({exprand(100,10000) }.dup(tabsize)) * \freqr.kr(1), \res.kr(3.dup(tabsize))).mean;
	sig2 = Ringz.ar(sig, \freqtab2.kr({exprand(100,10000) }.dup(tabsize)) * \freqr2.kr(1), \res2.kr(0.1.dup(tabsize))).mean;
	sig = SelectX.ar(Line.kr(0,0.5,1/2), [sig1 , sig2]);
	sig = LPF.ar(sig, EnvGen.kr(Env([1000,200,1000]+1000,[0.4,0.8]), 1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,1.5,1,1)), gate, doneAction:2) * 0.1;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Plazy({ arg ev;
			Pbind(
				\degree, Pseq([
					1,2,3,4,5,
				],inf),
				\octave, 5,
				\instrument, \doublebell,
				\freqtab, Pseq([
					[{exprand(140,10000) }.dup(30)  ]
				],inf),
				\freqtab2, Pseq([
					[{exprand(140,10000) }.dup(30)  ]
				],inf),
				\res, Pseq([
					[{rrand(0.01,1.3) }.dup(30)  ]
				],inf),
				\res2, Pseq([
					[{rrand(0.01,1.4) }.dup(30)  ]
				],inf),
				\sustain, 0.1,
				\dur, Pseq(
					(1-2.pow((0..10).neg/4).reverse/4)
					* rrand(0.5,2)),
				\freqr, 1,
				\amp, 0.3,
			);
		}).loop,
		
	])
)).play;
);

(
	Pdef(\part, Pdef(\zed, 
		Ppar([
			//Pbind(\dur, Pkey(\dur) * 4 * Pseg(Pwhite(1/4,4),8)) <>
			Ppar([
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
					\bufnum, ~buflib.kick[1166].value,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 1,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,1,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
					],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/20,
							\dur, 1/20 * Pkey(\tfac),
					\gain, 0.3,
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
					\bufnum, ~buflib.snare[1606].value,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/20,
							\dur, 1/20 * Pkey(\tfac),
					\gain, 0.3,
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\bufnum, ~buflib.hat[167].value,
					\isRest, Pseq([
						1,0,1,0, 1,0,1,0,
					],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/20,
							\dur, 1/20 * Pkey(\tfac),
					\gain, 1,
				),
			]),
			Plazy({ arg ev;
				var numvoices = 8;
				Ppar(
					{ arg idx;
						var score = 0!numvoices;
						score[idx] = 1;
						Pbind(
							\instrument, \doublebell_damp,
							\freq, Pseg(Pbrown(300,8000.0,200,inf),7.1),
							\freqtab, Pseq([
								[{exprand(140,10000) }.dup(30)  ]
							],inf) * Pseg(Pwhite(1/2,2),8),
							\freqtab2, Pseq([
								[{exprand(140,10000) }.dup(30)  ]
							],inf) * Pseg(Pwhite(1/2,2),8),
							\res, Pseq([
								[{rrand(0.01,1.3) }.dup(30)  ]
							],inf) * Pseg(Pwhite(1/2,2),8),
							\res2, Pseq([
								[{rrand(0.01,1.4) }.dup(30)  ]
							],inf) * Pseg(Pwhite(1/2,2),8),
							\adsr, Pseq([
								[ Env.adsr(0.001,0.1,0.8,0.1) ],
							],inf),
							\isRest, Pseq([
								Pseq(score)
							],inf).coin.not,
							\dur, 1/20 * Pkey(\tfac),
							\lag, 0.051 *Pseg(Pwhite(1/18,1.2),8),
							\sustain, 0.051 *Pseg(Pwhite(1/2,1.2),8),
							\amp, 0.3 * Pseg(Pwhite(1/2,2.2),8),
						)
					}.dup(numvoices)
				)
			}).loop,

		])
			<> Pbind(\tfac, Pseg(Pwhite(1/2,2,inf)/3 + Pwhite(1/2,2,inf).stutter(4),8))
	)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Pbind(\dur, Pkey(\dur) * Pseg(Pwhite(2,1/2),8)) <>
	Ppar([
			Pbind(
				\instrument, \doublebell,
				\freq, Pseg(Pbrown(1300,4000.0,200,inf),7.1),
				\freqtab, Pseq([
					[{exprand(140,10000) }.dup(30)  ]
				],inf) * Pseg(Pwhite(1/2,2),8),
				\freqtab2, Pseq([
					[{exprand(140,10000) }.dup(30)  ]
				],inf) * Pseg(Pwhite(1/2,2),8),
				\res, Pseq([
					[{rrand(0.01,1.3) }.dup(30)  ]
				],inf) * Pseg(Pwhite(1/2,2),8),
				\res2, Pseq([
					[{rrand(0.01,1.4) }.dup(30)  ]
				],inf) * Pseg(Pwhite(1/2,2),8),
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.1) ],
				],inf),
				\isRest, Pseq([
					1,0,0,
				],inf).coin.not,
				\dur, 1/20,
				\sustain, 0.051 *Pseg(Pwhite(1/2,1.2),8),
				\amp, 0.3 * Pseg(Pwhite(1/2,1.2),8),
			),
			Pbind(
				\instrument, \doublebell,
				\freq, Pbrown(1300,4000.0,200,inf),
				\freq, Pseg(Pbrown(300,8000.0,200,inf),7.1),
				\freqtab, Pseq([
					[{exprand(140,10000) }.dup(30)  ]
				],inf) * Pseg(Pwhite(1/2,2),8),
				\freqtab2, Pseq([
					[{exprand(140,10000) }.dup(30)  ]
				],inf) * Pseg(Pwhite(1/2,2),8),
				\res, Pseq([
					[{rrand(0.01,1.3) }.dup(30)  ]
				],inf) * Pseg(Pwhite(1/2,2),8),
				\res2, Pseq([
					[{rrand(0.01,1.4) }.dup(30)  ]
				],inf) * Pseg(Pwhite(1/2,2),8),
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.1) ],
				],inf),
				\lag, Pwhite(0.0,0.01),
				\isRest, Pseq([
					0,1,0,
				],inf).coin.not,
				\dur, 1/20,
				\sustain, 0.05 *Pseg(Pwhite(1/2,1.2),8),
				\amp, 0.3 * Pseg(Pwhite(1/2,1.2),8),
			),
			Pbind(
				\instrument, \doublebell,
				\freq, Pbrown(1300,4000.0,200,inf),
				\freq, Pseg(Pbrown(300,8000.0,200,inf),7.1),
				\freqtab, Pseq([
					[{exprand(140,10000) }.dup(30)  ]
				],inf) * Pseg(Pwhite(1/2,2),8),
				\freqtab2, Pseq([
					[{exprand(140,10000) }.dup(30)  ]
				],inf) * Pseg(Pwhite(1/2,2),8),
				\res, Pseq([
					[{rrand(0.01,1.3) }.dup(30)  ]
				],inf) * Pseg(Pwhite(1/2,2),8),
				\res2, Pseq([
					[{rrand(0.01,1.4) }.dup(30)  ]
				],inf) * Pseg(Pwhite(1/2,2),8),
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.1) ],
				],inf),
				\lag, Pwhite(0.0,0.01),
				\isRest, Pseq([
					0,0,1,
				],inf).coin.not,
				\dur, 1/20,
				\sustain, 0.05 *Pseg(Pwhite(1/2,1.2),8),
				\amp, 0.3 * Pseg(Pwhite(1/2,1.2),8),
			),
		
	])
)).play;
);
(
Pdef(\part, Pdef(\zed, 
	Pbind(\dur, Pkey(\dur) * Pseg(Pwhite(2,1/2),8)) <>
	Ppar([
			Pbind(
				\instrument, \doublebell,
				\freq, Pseg(Pbrown(1300,4000.0,200,inf),7.1),
				\freqtab, Pseq([
					[{exprand(140,10000) }.dup(30)  ]
				],inf) * Pseg(Pwhite(1/2,2),8),
				\freqtab2, Pseq([
					[{exprand(140,10000) }.dup(30)  ]
				],inf) * Pseg(Pwhite(1/2,2),8),
				\res, Pseq([
					[{rrand(0.01,1.3) }.dup(30)  ]
				],inf) * Pseg(Pwhite(1/2,2),8),
				\res2, Pseq([
					[{rrand(0.01,1.4) }.dup(30)  ]
				],inf) * Pseg(Pwhite(1/2,2),8),
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.1) ],
				],inf),
				\isRest, Pseq([
					1,0,
				],inf).coin.not,
				\dur, 1/20,
				\sustain, 0.051 *Pseg(Pwhite(1/2,1.2),8),
				\amp, 0.3 * Pseg(Pwhite(1/2,1.2),8),
			),
			Pbind(
				\instrument, \doublebell,
				\freq, Pbrown(1300,4000.0,200,inf),
				\freq, Pseg(Pbrown(300,8000.0,200,inf),7.1),
				\freqtab, Pseq([
					[{exprand(140,10000) }.dup(30)  ]
				],inf) * Pseg(Pwhite(1/2,2),8),
				\freqtab2, Pseq([
					[{exprand(140,10000) }.dup(30)  ]
				],inf) * Pseg(Pwhite(1/2,2),8),
				\res, Pseq([
					[{rrand(0.01,1.3) }.dup(30)  ]
				],inf) * Pseg(Pwhite(1/2,2),8),
				\res2, Pseq([
					[{rrand(0.01,1.4) }.dup(30)  ]
				],inf) * Pseg(Pwhite(1/2,2),8),
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.1) ],
				],inf),
				\lag, Pwhite(0.0,0.01),
				\isRest, Pseq([
					0,1,
				],inf).coin.not,
				\dur, 1/20,
				\sustain, 0.05 *Pseg(Pwhite(1/2,1.2),8),
				\amp, 0.3 * Pseg(Pwhite(1/2,1.2),8),
			),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
			Pbind(
				\instrument, \doublebell,
				\freq, ~pmodenv.(Pbrown(1300,8000.0,200,inf), 1.1),
				\freqtab, Pseq([
					[{exprand(140,10000) }.dup(30)  ]
				],inf),
				\freqtab2, Pseq([
					[{exprand(140,10000) }.dup(30)  ]
				],inf),
				\res, Pseq([
					[{rrand(0.01,1.3) }.dup(30)  ]
				],inf),
				\res2, Pseq([
					[{rrand(0.01,1.4) }.dup(30)  ]
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\isRest, Pseq([
					1,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \doublebell,
				\freq, ~pmodenv.(Pbrown(1300,8000.0,200,inf), 1.1),
				\freqtab, Pseq([
					[{exprand(140,10000) }.dup(30)  ]
				],inf),
				\freqtab2, Pseq([
					[{exprand(140,10000) }.dup(30)  ]
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\isRest, Pseq([
					0,1,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
		
	])
)).play;
);
