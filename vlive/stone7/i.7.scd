BufDef(\march, "vipere/march.flac");
(
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,0.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,1.9)).range(0,0.02) + 0.15  });
~buf = BufDef(\march);
~buf = BufDef(\moeten);
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;
//Ndef(~name+++\lfo1, { Phasor.kr(0, (1/SampleRate.ir).poll *1, 0, 0.81) + 0.1 + LFPulse.kr(8).range(0,0.0001).lag(0.1)});
Ndef(~name+++\lfo1, { arg freq=1; SinOsc.kr(freq * t).range(6050,7500).lag(0.051)});
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([4,2,6,8],inf),
	\dur, 1/1,
));
Ndef(~name+++\lfo3, { arg freq=20; freq.lag(4.401)});
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\freq, Pseq([
		0,0.001, 0, 0.002,
	],inf),
	\dur, 1,
));
//Ndef(~name+++\lfo1, { 0.1 + LFPulse.kr(1).range(0,0.0008).lag(0.4)});
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,1.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(1.18).range(0,1.02) + 10.45  });
//Ndef(~name+++\lfo2, { LFSaw.kr(SinOsc.kr(1.12).range(0.01,4.9)).range(0.0001,0.0012)  });
Ndef(~name+++\lfo2, { SinOsc.kr(1/2*~t).range(0.50,17 * SinOsc.kr([1/1,1/7]/42*~t).mean.exprange(0.01,1))  });

Ndef(~name+++\lfo4).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo4, { SinOsc.kr(1/1*~t).range(0.0,1 * SinOsc.kr([1/1,1/7]/40*~t).mean.exprange(0.01,1))  });

Ndef(~name+++\lfo5).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo5, { SinOsc.kr(1/1*~t).range(1.0,0.99 * SinOsc.kr([1/1,1/7]/41*~t).mean.exprange(1.00,1))  });
Pdef(~name +++ \pre, 
	Pbind(
		\instrument, ~name+++\c,
		\phase, 0 + Pseg(Pseq([0,0.1],inf),8),
		\fmamp1, Ndef(~name+++\lfo2),
		\mix, Ndef(~name+++\lfo4),
		\mixf, Ndef(~name+++\lfo5),
		\freq, 400 * 1 * Pseq([
			Pseq([1],16) + [0,8,5+12],
			Pseq([1],16) + [0,8,4+12],
			Pseq([1],16) + [0,7,5+12],
			Pseq([1],16) + [0,7,4+12],
		],inf).midiratio.stutter(2) * Ptuple(
			{Prout({ arg ev;
				var randseq;
				var randseq2;
				1000.do {
					randseq = { [1/2,1].choose } ! 4;
					randseq2 = { [1/2,1].choose } ! 4;
					ev = Pseq([
						Pseq([
							Pseq(randseq),
							Pseq(randseq2*2),
							Pseq(randseq*2),
							Pseq(randseq2),
						],2),
						Pseq([
							Pseq(randseq),
							Pseq(randseq2),
						],4),
						Pseq([
							Pseq(randseq,2),
							Pseq(randseq2,2),
						],2),
					],1).embedInStream;
				};
			})}!3
		),
		\lpf, 1000,
		\lpftab, [[1,1.01,1.001]],
		\hpftab, [[1,1.01,1.001]],
		\hpf, 710,
		\mixhpf, 1,

	\isRest, Pseq([
		Prand([
			Pseq([
				1,
			],1),
		],1),
	],inf).coin.not,
	\amp, Pkey(\amp) * Pseq([
		1,1,1,1, 1,1,0.31,1,
	],inf),
	\dur, 1/8,
	\legato, Pseq([
		Prand([
			3,4,5,
		],1),
		Prand([
			4,4.5,
		],1),
		
	],inf)/2 * Ptuple({Pwhite(1,1.01)}!3),
	
	)
)
);

// END

Sdef(~name, \mypreset).rebuild
Sdef(~namex, \mypreset).edit
Sdef(~namex, \mypreset).rebuild(true)
a = IdentityDictionary.new; a.putPairs( Sdef(~namex, \mypreset).specs ); a[\fshift]
Sdef(~namex, \mypreset).get(0,0)
Sdef(~name, \mypreset).active_subindex
Sdef(~name, \mypreset).all[0][0] = nil
~score_storage.all['1'][\mypreset] = nil

Pdef.all.do { arg x; x.postln; }

Pdef('1.0.mypreset').source.asCompileString
Pdef('1.0.mypreset').play
