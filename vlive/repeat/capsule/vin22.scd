
(
~master = {
	ProtoDef(\simpleMixer).play;
	ProtoDef(\rdn).play;
	ProtoDef(\rdn2).play;
	ProtoDef(\rdn3).play;
};
~master.();
)

~t = 206/4/60; TempoClock.default.tempo = ~t;

(
SynthDef(\sidebass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(Env([0,1,0],[0.01,0.1]), 1);
	sig1 = Pulse.ar(freq * [1,2,3,4] , ( SinOsc.kr(0.1* [1,1.001]) * 0.1 + 1 ));
	sig2 = SinOsc.ar(freq); 
	sig = [sig1,sig2].sum;
	sig = RLPF.ar(sig, \lpf.kr(1000) * (env1 * 40.5 + 1), \rq.kr(0.5));
	sig5 = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = SelectX.ar(\distmix.kr(0.5), [sig, sig5]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\bizbiz, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	env1 = EnvGen.kr(\fmamtenv.kr(Env([0,0.451,0],[0.01,1.8])), 1) * \fmamt.kr(1);
	lfo1 = Duty.kr(\lfo1dur.kr(1/4)/~t, 0, Dseq([
		Dseq([0,2,6,4,2].midiratio,inf)
	],inf));
	sig = SinOsc.ar(freq * [1,lfo1, 2, 2*lfo1] * ( SinOsc.ar(freq *[1,2] * lfo1  +1) * env1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\bizbiz2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	env1 = EnvGen.kr(\pitchenv.kr(Env([0,1,1,0.1],[0.1,0.8,0.1])), 1);
	env2 = EnvGen.kr(Env([0,1,0],[0.1,1.8]), 1);
	lfo1 = Duty.kr(\lfo1dur.kr(1/4)/~t, 0, Dseq([
		Dseq([0,2,6,4,2].midiratio,inf)
	],inf));
	sig = Pulse.ar(freq * [1,lfo1, 2,3,4,5,6,1/2].collect({ arg x; LFNoise1.kr(0.2) * 0.001 + 1 * x }).scramble * (env1 * 0.1 + 1));
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * [lfo1*\lplfoamt.kr(2),1] * (env2 * \lpenvamt.kr(0.2) +1), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\bizbiz3, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	env1 = EnvGen.kr(\pitchenv.kr(Env([0,1,1,0.1],[0.1,0.8,0.1])), 1);
	env2 = EnvGen.kr(Env([0,1,0],[0.1,1.8]), 1);
	lfo1 = Duty.kr(\lfo1dur.kr(1/4)/~t, 0, Dseq([
		Dseq([0,2,6,4,2].midiratio,inf)
	],inf));
	sig = Pulse.ar(freq * [1,lfo1, 2,3,4,5,6,1/2].collect({ arg x; LFNoise1.kr(0.2) * 0.001 + 1 * x }).scramble * (env1 * 0.1 + 1));
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * [lfo1*\lplfoamt.kr(2),1] * (env2 * \lpenvamt.kr(0.2) +1), \rq.kr(0.5));
	lfo2 = TDuty.kr(1/16/~t, 0, Dseq([
		Drand([
			Dseq([
				1,0,1,1, 0,1,0,1,
			],1),
			Dseq([
				1,1,1,1, 1,0,1,0,
			],1),
			Dseq([
				1,0,1,0, 0,0,0,0,
			],1),
			Dseq([
				1,0,0,0, 1,0,0,0,
			],1),
		],1),
	],inf));
	sig = sig * EnvGen.kr(Env([0,1,0],[0.01,\ienvrel.kr(0.1)]), lfo2) * 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1486].value,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \sidebass,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\isRest, Pseq([
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[545].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[948].value,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1486].value,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \sidebass,
			\note, Pseq([
				1,
			],inf),
			\octave, 3,
			\isRest, Pseq([
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(\lag, 0.04) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1986].value,
				\isRest, Pseq([
					0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.04,0.1,0.8,0.5) ],
				],inf),
				\dur, 1/8,
				\gain, 0.51,
				\out, BusDef(\mixer1, \audio),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[948].value,
				\isRest, Pseq([
					1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
				\out, BusDef(\mixer2, \audio),
			),
			Pbind(
				\instrument, \bizbiz,
				\note, Pseq([
					1,
				],inf),
				\envmod, Pseg(Pseq([0,1],inf),8*4),
				\adsr, Pseq([
					Pfunc({ arg ev;
						[ Env.adsr(0.01,0.1,0.8,1.1).blend(
							Env.adsr(0.41,0.1,0.8,0.01),
							ev[\envmod],
						) ];
					}),
				],inf),
				\fmamtenv, Pseq([
					Pfunc({ arg ev;
						[ Env([0,1,0],[0.01,0.8]).blend(
							Env([0,1,0],[0.8,0.01]),
							ev[\envmod],
						) ]
					}),
					Pfunc({ arg ev;
						[ Env([0,1,0],[0.1,0.8]).blend(
							Env([1,0,1],[0.1,0.8]),
							ev[\envmod],
						) ]
					}),
				],inf),
				\lfo1dur, Pseq([
					1/4, 1/4, 1/4, 1/4, 1/4, 1/4, 1/4, 1,
					1/4, 1/4, 1/4, 1/4, 1/4, 1/4, 1/4, 1/2,
				],inf)/~t * Pseq(1/[1,2,3,4],inf).stutter(4),
				\dur, 1/2,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \bizbiz2,
				\note, Pseq([
					Pseq([
						[0,5,8, 11],
					],7),
					[0,5,8],
				],inf).stutter(2),
				\envmod, Pseg(Pseq([0,1],inf),8*4),
				\pitchenv, Pseq([
					Pfunc({ arg ev;
						[ Env([1.1,1/2,1,4/5],[0.1,0.8,0.1]).blend(
							Env([0,1,1,0.1],[0.1,0.8,0.1]),
							ev[\envmod],
						) ];
					}),
				],inf),
				\lplfoamt, 1/2 * Pseg(Pseq([0,4],inf),8*4),
				\octave, 6,
				\lfo1dur, 1/32/~t,
				\lfo1dur, Pseq([
					1/4, 1/4, 1/16, 1/16, 1/4, 1/4, 4, 1/8,
				],inf),
				\lpenvamt, ~pmodenv.(Pseq([1/2,2,1,4],inf), 8),
				\legato, Pseq([
					2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1,
				\amp, 0.1/3,
			),
		]),
		
	])
)).play;
);


(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1486].value,
			\isRest, Pseq([
				1,0, 0,0, 0,0, 0,0,
				1,0, 0,0, 0,0, 0,1,
				1,0, 0,1, 0,0, 0,0,
				1,0, 1,0, 0,0, 1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \sidebass,
			\note, Pseq([
				0,0,0,-1
			],inf).stutter(8),
			\octave, 3,
			\isRest, Pseq([
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,1,0,1,
				1,1,0,1, 0,1,0,1,
				0,1,0,1, 0,0,0,0,

				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,1,1,1,
				0,1,0,1, 0,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1/4,1,1,
				1,1,1,1, 1,1,1,1,
				1,1/2,0,1/2, 1,1,1,1,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(\lag, 0.04) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1608].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.21,
				\out, BusDef(\mixer3, \audio),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1986].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
					0,0,1,0.2, 0,1,0.1,0.04,
					0,0,1,0, 0,0,1,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.04,0.1,0.8,0.5) ],
				],inf),
				\dur, 1/8,
				\gain, 0.51,
				\out, BusDef(\mixer1, \audio),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[948].value,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,0,0,
					0,1,0,1, 0,1,0,1,
					1,1,1,1, 1,1,1,1,

					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,0,0,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\sustain, Pseq([0.1,0.2],inf), 
				\gain, 0.11,
				\out, BusDef(\mixer2, \audio),
			),
			Pbind(
				\instrument, \bizbiz,
				\note, Pseq([
					0,0,0,-1,
				],inf).stutter(2),
				\envmod, Pseg(Pseq([0,1],inf),8*4),
				\adsr, Pseq([
					Pfunc({ arg ev;
						[ Env.adsr(0.01,0.1,0.8,1.1).blend(
							Env.adsr(0.41,0.1,0.8,0.01),
							ev[\envmod],
						) ];
					}),
				],inf),
				\fmamtenv, Pseq([
					Pfunc({ arg ev;
						[ Env([0,1,0],[0.01,0.8]).blend(
							Env([0,1,0],[0.8,0.01]),
							ev[\envmod],
						) ]
					}),
					Pfunc({ arg ev;
						[ Env([0,1,0],[0.1,0.8]).blend(
							Env([1,0,1],[0.1,0.8]),
							ev[\envmod],
						) ]
					}),
				],inf),
				\lfo1dur, Pseq([
					1/4, 1/4, 1/4, 1/4, 1/4, 1/4, 1/4, 1,
					1/4, 1/4, 1/4, 1/4, 1/4, 1/4, 1/4, 1/2,
				],inf)/~t * Pseq(1/[1,2,3,4],inf).stutter(4),
				\dur, 1/2,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \bizbiz2,
				\note, Pseq([
					Pseq([
						[0,5,8, 11],
					],7),
					[0,5,8],
				],inf).stutter(2),
				\envmod, Pseg(Pseq([0,1],inf),8*4),
				\pitchenv, Pseq([
					Pfunc({ arg ev;
						[ Env([1.1,1/2,1,4/5],[0.1,0.8,0.1]).blend(
							Env([0,1,1,0.1],[0.1,0.8,0.1]),
							ev[\envmod],
						) ];
					}),
				],inf),
				\lplfoamt, 1/2 * Pseg(Pseq([0,4],inf),8*4),
				\octave, 6,
				\lfo1dur, 1/32/~t,
				\lfo1dur, Pseq([
					1/4, 1/4, 1/16, 1/16, 1/4, 1/4, 4, 1/8,
				],inf),
				\lpenvamt, ~pmodenv.(Pseq([1/2,2,1,4],inf), 8),
				\legato, Pseq([
					2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1,
				\amp, 0.1/3,
			),
		]),
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1486].value,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \sidebass,
			\note, Pseq([
				1,
			],inf),
			\octave, 3,
			\isRest, Pseq([
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(\lag, 0.04) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1986].value,
				\isRest, Pseq([
					0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.04,0.1,0.8,0.5) ],
				],inf),
				\dur, 1/8,
				\gain, 0.51,
				\out, BusDef(\mixer1, \audio),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[948].value,
				\isRest, Pseq([
					1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
				\out, BusDef(\mixer2, \audio),
			),
			Pbind(
				\instrument, \bizbiz,
				\fmamt, Pseg(Pseq([0,1],inf),8),
				\freq, Pseg(Pseq([800,2000],inf),7.34*4),
				\lfo1dur, Pseg(Pseq([1/4,0.01],inf),6.234*4),
				\adsr, Pseq([
					[ Env.adsr(0.4,0.1,0.8,0.4) ],
				],inf),
				\legato, Pseg(Pseq([0.1,1],inf),7.1*8),
				\dur, 1/4,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \bizbiz,
				\fmamt, Pseg(Pseq([0,1],inf),8),
				\freq, Pseg(Pseq([1800,1000,2000],inf),3.1*4)* ( 3-12 ).midiratio,
				\lfo1dur, Pseg(Pseq([1/4,0.01],inf),4.43*4),
				\adsr, Pseq([
					[ Env.adsr(0.4,0.1,0.8,0.4) ],
				],inf),
				\legato, Pseg(Pseq([0.1,0.2,1],inf),5.3*4),
				\dur, 1/4,
				\amp, 0.1,
			),
			Pbind(
				\isRest, true,
				\instrument, \bizbiz,
				\note, Pseq([
					1,
				],inf),
				\envmod, Pseg(Pseq([0,1],inf),8*4),
				\adsr, Pseq([
					Pfunc({ arg ev;
						[ Env.adsr(0.01,0.1,0.8,1.1).blend(
							Env.adsr(0.41,0.1,0.8,0.01),
							ev[\envmod],
						) ];
					}),
				],inf),
				\fmamtenv, Pseq([
					Pfunc({ arg ev;
						[ Env([0,1,0],[0.01,0.8]).blend(
							Env([0,1,0],[0.8,0.01]),
							ev[\envmod],
						) ]
					}),
					Pfunc({ arg ev;
						[ Env([0,1,0],[0.1,0.8]).blend(
							Env([1,0,1],[0.1,0.8]),
							ev[\envmod],
						) ]
					}),
				],inf),
				\lfo1dur, Pseq([
					1/4, 1/4, 1/4, 1/4, 1/4, 1/4, 1/4, 1,
					1/4, 1/4, 1/4, 1/4, 1/4, 1/4, 1/4, 1/2,
				],inf)/~t * Pseq(1/[1,2,3,4],inf).stutter(4),
				\dur, 1/2,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \bizbiz3,
				\note, Pseq([
					Pseq([
						[0,5,8, 11],
					],7),
					[0,5,8],
				],inf).stutter(2),
				\envmod, Pseg(Pseq([0,1],inf),8*4),
				\ienvrel, Pseg(Pseq([0.1,0.01,0.3,1,0.05],inf),2.1*4),
				\pitchenv, Pseq([
					Pfunc({ arg ev;
						[ Env([1.1,1/2,1,4/5],[0.1,0.8,0.1]).blend(
							Env([0,1,1,0.1],[0.1,0.8,0.1]),
							ev[\envmod],
						) ];
					}),
				],inf),
				\lplfoamt, 1/2 * Pseg(Pseq([0,4],inf),8*4),
				\octave, 6,
				\lfo1dur, 1/32/~t,
				\lfo1dur, Pseq([
					1/4, 1/4, 1/16, 1/16, 1/4, 1/4, 4, 1/8,
				],inf),
				\lpenvamt, ~pmodenv.(Pseq([1/2,2,1,4],inf), 8),
				\legato, Pseq([
					2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1,
				\amp, 0.1/3,
			),
		]),
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1486].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0, 

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0, 

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1, 

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0, 

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,1,0,1, 1,0,0,0, 
			],inf).coin.not,
			\legato, Pseg(Pseq([0.1,1],inf),8),
			\legato, 0.1,
			\dur, 1/16,
			\gain, 0.3,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \sidebass,
			\note, Pseq([
				1,
			],inf),
			\octave, 3,
			\isRest, Pseq([
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/2,
			\legato, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(\lag, Pkeyd(\lag, 0) + 0.04) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('smp/buffyvoice.flac'),
				\pos, 4.4 + Pseq([
					0,0,0,0,
					0,1,1,3,
				]/3,inf),
				\dur, 1/4,
				\legato, 1,
				\speed, ~pmodenv.(
					Pseq([
						Pseq([1,1.12,0.781,1.14]*2,inf) * Pseq([
							1,1.2,1,0.9
						],inf).stutter(16),
					],1)
					, 1/4),
				\gain, 1/4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('smp/buffyvoice.flac'),
				\pos, 3.9 + Pseq([
					0,0,0,0,
					0,0,0,2,
					0,0,0,0,
					0,0,0,1,
				]/3,inf).stutter(2) + Pseg(Pseq([0,0.11],inf),8),
				\dur, 1/8,
				\isRest, Pseq([
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					1,1,0,1, 1,1,0,1,
				],inf).coin.not,
				\legato, 1,
				\speed, ~pmodenv.(
					Pseq([
						Pseq([1,1.12,0.781,1.14]*2,inf) * Pseq([
							1/3
						],inf).stutter(16),
					],1)
					, 8.4),
				\gain, 1/4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('smp/buffyvoice.flac'),
				\pos, 7.4 + Pseq([
					0,0,0,0,
					0,0,0,1,
					0,0,1,0,
					0,1,1,3,
				]/3,inf),
				\dur, 1/4,
				\legato, Pseg(Pseq([0.1,0.3,1],inf),8),
				//\lag, 1/8/~t,
				\speed, ~pmodenv.(
					Pseq([
						Pseq([1,1.12,0.781,1.14],inf) 
						* Pseg(Pseq([1,1.2,0.7],inf),8),
					],1)
					, 1/4),
				\gain, 1/4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1986].value,
				\isRest, Pseq([
					0,0,1,0,
					0,0,1,0,
					0,0,1,0,
					0,0,1,0,
					0,0,1,0,
					0,0,1,0,
					0,0,1,0,
					0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.04,0.1,0.8,0.5) ],
				],inf),
				\dur, 1/8,
				\gain, 0.51,
				\out, BusDef(\mixer1, \audio),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[948].value,
				\isRest, Pseq([
					1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
				\out, BusDef(\mixer2, \audio),
			),
		]),
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1486].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0, 

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0, 

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1, 

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0, 

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,1,0,1, 1,0,0,0, 
			],inf).coin.not,
			\legato, Pseg(Pseq([0.1,1],inf),8),
			\legato, 0.1,
			\dur, 1/16,
			\gain, 0.3,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \sidebass,
			\note, Pseq([
				1,
			],inf),
			\octave, 3,
			\isRest, Pseq([
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/2,
			\legato, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(\lag, Pkeyd(\lag, 0) + 0.04) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('smp/buffyvoice.flac'),
				\pos, 4.4 + Pseq([
					0,0,0,0,
					0,1,1,3,
				]/9,inf),
				\dur, 1/4,
				\legato, 1,
				\speed, ~pmodenv.(
					Pseq([
						Pseq([1,1.12,0.781,1.14]*2,inf) * Pseq([
							1,1.2,1,0.9
						],inf).stutter(16),
					],1)
					, 17.1),
				\gain, 1/4,
			),
			Pbind(
				\instrument, \default,
				\note, Pseq([
					[-4,8],
					[0,-4,-7,5,12],
					[-4,8],
					[0,-4,-7,5,12],
					[-4,8],
					[-1,-4,-8,4,11],
					[-4,8],
					[-1,-4,-8,4,11],
				],inf),
				\dur, 1/4,
				\amp, 0.1/3,
			),
			Pbind(
				\instrument, \sidebass,
				\note, Pseq([
					Pser([-4,8],8*2),
					Pser([-4,8,0,-7,12],8),
					Pser([-4,8,-1,-8,11],8),

					Pser([-4,8],8),
					Pser([-4,8,-1,-8,11],8),
					Pser([-4,8],8),
					Pser([8,11,4,8,4,11,8],8),
					Pseq([
						Pseq([0,5],4),
						Pseq([-1,4],4),
					],2),
				],inf),
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,0,1,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,0,0,
				],inf).coin.not,
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('smp/buffyvoice.flac'),
				\pos, 3.9 + Pseq([
					0,0,0,0,
					0,0,0,2,
					0,0,0,0,
					0,0,0,1,
				]/3,inf).stutter(2) + Pseg(Pseq([0,0.11],inf),8),
				\dur, 1/8,
				\isRest, Pseq([
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					1,1,0,1, 1,1,0,1,
				],inf).coin.not,
				\legato, 1,
				\speed, ~pmodenv.(
					Pseq([
						Pseq([1,1.12,0.781,1.14]*2,inf) * Pseq([
							1/3
						],inf).stutter(16),
					],1)
					, 8.4),
				\gain, 1/4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('smp/buffyvoice.flac'),
				\pos, 7.4 + Pseq([
					0,0,0,0,
					0,0,0,1,
					0,0,1,0,
					0,1,1,3,
				]/3,inf),
				\dur, 1/4,
				\legato, Pseg(Pseq([0.1,0.3,1],inf),8),
				//\lag, 1/8/~t,
				\speed, ~pmodenv.(
					Pseq([
						Pseq([1,1.12,0.781,1.14],inf) 
						* Pseg(Pseq([1,1.2,0.7],inf),8),
					],1)
					, 1/4),
				\gain, 1/4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1986].value,
				\isRest, Pseq([
					0,0,1,0,
					0,0,1,0,
					0,0,1,0,
					0,0,1,0,
					0,0,1,0,
					0,0,1,0,
					0,0,1,0,
					0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.04,0.1,0.8,0.5) ],
				],inf),
				\dur, 1/8,
				\gain, 0.51,
				\out, BusDef(\mixer1, \audio),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[948].value,
				\isRest, Pseq([
					1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
				\out, BusDef(\mixer2, \audio),
			),
		]),
		
	])
)).play;
);

Window
ProtoDef(\piano).startControl(Pdef(\melo))
ProtoDef(\piano).edit
SynthDesc(\default).conrols
PdefParam.instrument(Pdef(\melo))
BaseParam.getInstrumentFromPbind(Pdef(\melo).source)

Pdef(\melo).getHalo(\instrument)
Pdef(\melo).addHalo(\instrument, \default)
Pdef(\melo).source.patternpairs.clump(2).detect { arg pair;
					pair[0] == \instrument
				}[0].class;
(
Pdef(\melo, 
	Pbind(
		\instrument, \default,
	)
);
);
WindowDef(\pianokeyboard).front(Pdef(\melo))
WindowDef(\PdefEditor).front(Pdef(\melo))
(
WindowDef(\bla, {

	//VLayout (
		//ParamGroupLayout.two_panes(Pdef(\melo).asParamGroup.keep(3).debug("x"))
	//)
	Pdef(\melo).asParamGroup[2].debug("x").asPopUpMenu
}).front;
)

Spec.specs[\out]
Spec.add(\out, TagSpecDef(\BusDef_object))
TagSpecDef(\BusDef_object).list
~p = Param(Pdef('melo'), 'out')
~win = Window.new
~pop = PopUpMenu.new;
~pop.mapParam(~p)

(
Pdef(\truecastle, 
	Pbind(
		\instrument, \default,
		\note, Pseq([
			Pser([ -6, -2, 1, ],12),
			Pser([ -8, -2, 1, ],12),
			Pser([ -7, -2, 1, ],12),
			Pser([ -7, -2, 0, ],12),

			Pser([ -6, -2, 0, ],12),
			Pser([ -8, -2, 0, ],12),
			Pser([ -7, -2, 0, ],12),
			Pser([ -7, -3, 0, ],12),
		],inf),
		\dur, 1/12,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\truecastle, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				8,8,8,\r, 6,\r,\r,6,
				8,8,8,\r, 1,0,\r,1,
				8,8,8,\r, 5,\r,\r,5,
				8,8,8,\r, 5,\r,\r,5,
				//0,\r,1,\r, \r,1,\r,0,
				//0,1,\r,\r, 0,1,\r,0,
				//0,\r,1,\r, \r,1,\r,0,
				//0,1,\r,\r, 0,1,\r,0,
			],inf),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				Pswitch1(
					[
						Pseq([ 6,10,-6, ],inf),
						Pseq([ 10,1, ],inf),
						Pseq([ 1,13, ],inf),
						Pseq([ 7,-2, 0,4 ],inf),
						Pseq([ 10,6,-6, ],inf),
						Pseq([ 10,1, ],inf),
						Pseq([ 8,1,13, ],inf),
						Pseq([ 7,-3, 0,4 ],inf),
					].collect({ arg pat;
						pat.stutter(Prand([1,2,3,4],inf))
					}), 
					Pstep(Pseq((0..7),inf),1),
				),
			],inf),
			\legato, 0.1,
			\octave, 6,
			\dur, Pconst(1, Prand([Pwhite(0.1,0.3),1/2, 1/4, 0.2], inf)).loop,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				Pswitch1(
					[
						Pseq([ 0,1, ],inf),
						Pseq([ 0,1, ],inf),
						Pseq([ 0,1, ],inf),
						Pseq([ 0,-2, ],inf),

						Pseq([ 0,1, ],inf),
						Pseq([ 0,1, ],inf),
						Pseq([ 0,1, ],inf),
						Pseq([ 0,-3, ],inf),
					].collect({ arg pat;
						pat.stutter(Prand([1,2,3,4],inf))
					}), 
					Pstep(Pseq((0..7),inf),1),
				),
			],inf),
			\legato, 0.1,
			\octave, 6,
			\dur, Pconst(1, Prand([Pwhite(0.1,0.3),1/2, 1/4, 0.2], inf)).loop,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				Pser([ -6, -2, 1, 6],16),
				Pser([ -8, -2, 1, 4],16),
				Pser([ -7, -2, 1, 5],16),
				Pser([ -7, -2, 0, 5],16),
		
				Pser([ -6, -2, 0, 6],16),
				Pser([ -8, -2, 0, 4],16),
				Pser([ -7, -2, 0, 5],16),
				Pser([ -7, -3, 0, 5],16),

				Pser([ -6, -2, 1, 6],16),
				Pser([ -8, -2, 1, 4],16),
				Pser([ -7, -2, 1, 5],16),
				Pser([ -7, -2, 0, 5],16),
		
				Pser([ -6, -2, 0, 6],16),
				Pser([ -8, -2, 0, 4],16),
				Pser([ -7, -2, 0, 5],16),
				Pser([ -7, -3, 0, 5],16),
			],inf),
			\dur, 1/16,
			\amp, 0.1,
		)
	]),
).play;
);


(
// spray electronique de l'espace
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = LFNoise1.ar(1);
	sig1 = WhiteNoise.ar * Duty.kr(1/8/~t, 0, Dseq([
		Drand([
			1,0,0,0,1,1,1,0,
		],inf),
	],inf)).lag(0.1);
	sig1 = BPF.ar(sig1, LFNoise1.kr(1).range(100,15000));
	sig2 = 8.collect({ arg idx;
		SinOsc.ar(freq * (idx * lfo1 +1)) / ((idx+1/4)) * EnvGen.kr(Env([0,1,0],[0.1,0.8]), Dust.kr(1));
	}).mean;
	sig3 = Pulse.ar(freq * (sig2 * LFNoise1.kr(0.7) +1)); 
	sig3 = RLPF.ar(sig3, \lpf.kr(3100), \rq.kr(0.5))*0.3;
	sig = [sig1, sig2, sig3].sum;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
// r2d2 birds
Ndef(\zed, { arg freq=800, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = LFNoise1.ar(1);
	lfo2 = LFNoise1.ar(1);
	lfo3 = Select.ar(LFNoise1.ar(1), DC.ar(2**((0..11)/12)));
	lfo4 = Select.ar(LFNoise1.ar(1), DC.ar(2**((0..11)/12)));
	sig2 = 8.collect({ arg idx;
		SinOsc.ar(freq * (idx * lfo3 +1)) / ((idx+1/4)) * EnvGen.kr(Env([0,1,0],[0.01,0.8 * lfo1]), Dust.kr(1));
	}).mean;
	sig3 = 8.collect({ arg idx;
		var isig;
		isig = Pulse.ar(freq * (idx * lfo4 +1)) / ((idx+1/4)) * EnvGen.kr(Env([0,1,0],[0.01,0.8 * lfo2]), Dust.kr(1));
		isig = RLPF.ar(isig, 700, \rq.kr(0.5));
		isig;
	}).mean;
	//sig = [sig1, sig2, sig3].sum;
	sig = [sig3,sig2].sum;
	sig = DelayL.ar(sig, 1/10, SinOsc.ar(0.1 * [1,1.1,1.12]).range(1/11,1/2000) )+sig;
	sig = DelayL.ar(sig, 1/10, SinOsc.ar(0.1123 * [1,1.1243,1.312]).range(1/11,1/2000) )+sig;
	pan = pan + LFNoise1.kr(0.1!sig.size);
	sig = Pan2.ar(sig, pan, amp).mean * 4;
}).play;
);
Ndef(\zed).play(BusDef(\sendbus1).index, 2)


Ndef(\zed).stop
(
// clochette musette chords
Ndef(\rdn).play;
Ndef(\fx1).play;
Ndef(\zed, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var lfogen1, lfogen2, lfogen3;
	lfo1 = LFNoise1.ar(1);
	lfo2 = LFNoise1.ar(1);
	lfo3 = Duty.ar(4/~t, 0, Dseq([
		Dseq([
			([0,4,7,10,12,16,19]+5).midiratio,
			([0,4,7,10,12,16,19]).midiratio,
		],inf),

		//[0,4,7,12,16,19].midiratio,
		//[0,3,7,12,15,19].midiratio,
		//([0,4,7,12,16-12,19-12]+7).midiratio,
	],inf));
	lfogen1 = {Select.ar(LFNoise1.ar(1).range(0,lfo3.size-1), lfo3)};
	sig2 = 8.collect({ arg idx;
		var lfo = LFNoise1.kr(1).range(0.1,2);
		var ifreq = freq * [0,4,5,3,-12].midiratio;
		var isig;
		isig = SinOsc.ar(ifreq * lfogen1.value, mul: [1,0.3,0.3,0.1]).mean * EnvGen.kr(Env([0,1,0],[0.01,0.8 * lfo]), Dust.kr(1));

		isig = isig * LFNoise1.kr(0.1).range(0.1,1) * 2;
	});
	sig3 = 8.collect({ arg idx;
		var isig;
		var lfo = LFNoise1.kr(1).range(0.1,2);
		var ilfo2 = LFNoise1.kr(1).range(0.1,1);
		isig = Pulse.ar(freq * lfogen1.value) * EnvGen.kr(Env([0,1,0],[0.01,0.8 * lfo]), Dust.kr(1));
		isig = RLPF.ar(isig, 700 * (ilfo2 * 3.1 +1), \rq.kr(0.7));
		isig = isig * LFNoise1.kr(0.1).range(0.1,1);
		isig;
	});
	sig4 = 8.collect({ arg idx;
		var isig;
		var lfo = LFNoise1.kr(1).range(0.1,2);
		var ilfo2 = LFNoise1.kr(1).range(0.1,1);
		var ifreq = freq * [0,4,5,3,-12].midiratio;
		isig = LFSaw.ar(ifreq * lfogen1.value, mul: [1,0.3,0.3,0.1]).mean * EnvGen.kr(Env([0,1,0],[0.01,0.8 * lfo]), Dust.kr(1));
		isig = RLPF.ar(isig, 700 * (ilfo2 * 3.1 +1), \rq.kr(0.7)) * 2;
		isig = isig * LFNoise1.kr(0.1).range(0.1,1);
		isig;
	});
	//sig = [sig1, sig2, sig3].sum;
	sig = [sig3,sig2,sig4].flatten;
	//sig = DelayL.ar(sig, 1/10, SinOsc.ar(0.1 * [1,1.1,1.12]).range(1/11,1/2000) )+sig;
	//sig = DelayL.ar(sig, 1/10, SinOsc.ar(0.1123 * [1,1.1243,1.312]).range(1/11,1/2000) )+sig;
	sig4.debug("sig");
	pan = pan + LFNoise1.kr(0.1!sig.size);
	sig = Pan2.ar(sig, pan, amp).mean * 4;
}).play;
);
Ndef(\zed).quant = 8
