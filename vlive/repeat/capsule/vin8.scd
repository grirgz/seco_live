

	(
		~t = 71/2/60; TempoClock.default.tempo = ~t;
ProtoDef(\rdn, ProtoTemplateDef(\rdn));
ProtoDef(\rdn2, ProtoTemplateDef(\rdn));
ProtoDef(\rdn3, ProtoTemplateDef(\rdn));
ProtoDef(\rdn4, ProtoTemplateDef(\rdn));
	~master = {
		ProtoDef(\simpleMixer).play;
	ProtoDef(\rdn).play;
	ProtoDef(\rdn2).play;
	ProtoDef(\rdn3).play;
	};
	~master.();
	)

(
SynthDef(\serenity, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * \ratio.kr([0,4,7]) * [1/2,1,2];
	sig1 = SinOsc.kr((1..9)/10).range(0,1);
	sig2 = SinOsc.kr((1..9)/20).range(0,1);
	sig = SinOsc.ar(freq) * SinOsc.ar(freq+sig2, SinOsc.ar(freq+2+sig1), 1, SinOsc.ar(freq+2+sig2) );
	pan = LFNoise1.kr((1..9)/75).range(-1,1);
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
)

	(
		~master.();
	Pdef(\part, Pdef(\zed, 
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 104, 41], [0.035, 0.08], curve: \exp) ],
				\bodyenv, [ Env.linen(0.005, 0.1, 0.3) ],
			
				\popfstart, 750,
				\popfend, 261,
				\popfdur, 0.02,
				\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
				\popamp, 0.15,
			
				\formfund, 910,
				\formfreq, 4760,
				\formbw, 2110,
				\lpf, 3140,
				\clickat, 0.001,
				\clickrel, 0.01,
				\clickamp, 0.15,
			
				\distpreamp, 1,
				\distpostamp, 1,
			
				\isRest, Pseq([

					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,1,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,1,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 1,0,0,1,
					1,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
			),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\out, BusDef(\sendbus2, \audio),
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,1,1,1, 1,1,1,1,
					0,1,0,0, 1,0,0,1,
				],inf).coin.not,
				\out, BusDef(\sendbus2, \audio),
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 0,1,1,1,
				],inf).coin.not,
				\out, BusDef(\sendbus2, \audio),
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\out, BusDef(\sendbus3, \audio),
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.2,
				\dur, 1/8,
				\out, BusDef(\sendbus3, \audio),
			)),
			
		])
	)).play;
	);

	(
		~master.();
	Pdef(\part, Pdef(\zed, 
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 104, 41], [0.035, 0.08], curve: \exp) ],
				\bodyenv, [ Env.linen(0.005, 0.1, 0.3) ],
			
				\popfstart, 750,
				\popfend, 261,
				\popfdur, 0.02,
				\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
				\popamp, 0.15,
			
				\formfund, 910,
				\formfreq, 4760,
				\formbw, 2110,
				\lpf, 3140,
				\clickat, 0.001,
				\clickrel, 0.01,
				\clickamp, 0.15,
			
				\distpreamp, 1,
				\distpostamp, 1,
			
				\isRest, Pseq([

					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,1,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,1,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 1,0,0,1,
					1,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
			),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\out, BusDef(\sendbus2, \audio),
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\out, BusDef(\sendbus3, \audio),
				\amp, 0.01 * Pseq([
					Pseq([
						1,0.7, 1,0.2, 1,0.7, 0,0.7,
						1,0.7, 1,0.7, 1,0.7, 0,0.7,
						0.1,0.7, 0.1,0.7, 1,0.7, 1,0.7,
					],6),
					1,0.3,
				],inf),
			),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,1,1,1, 1,1,1,1,
					0,1,0,0, 1,0,0,1,
					0,1,0,0, 1,0,0,1,
					0,1,0,0, 1,0,0,1,
				],inf).coin.not,
				\out, BusDef(\sendbus2, \audio),
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 0,1,1,1,
					0,0,0,0, 0,0,1,0,
					0,1,1,1, 0,1,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 0,1,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\out, BusDef(\sendbus2, \audio),
				//\sustain, 0.1,
				\pos, 0.1,
				\speed, 0.7,
				\gain, 0.2,
				\dur, 1/8,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\out, BusDef(\sendbus3, \audio),
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.2,
				\dur, 1/8,
				\out, BusDef(\sendbus3, \audio),
			)),
			
		])
	)).play;
	);

	(
		~master.();
	Pdef(\part, Pdef(\zed, 
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 104, 41], [0.035, 0.08], curve: \exp) ],
				\bodyenv, [ Env.linen(0.005, 0.1, 0.3) ],
			
				\popfstart, 750,
				\popfend, 261,
				\popfdur, 0.02,
				\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
				\popamp, 0.15,
			
				\formfund, 910,
				\formfreq, 4760,
				\formbw, 2110,
				\lpf, 3140,
				\clickat, 0.001,
				\clickrel, 0.01,
				\clickamp, 0.15,
			
				\distpreamp, 1,
				\distpostamp, 1,
			
				\isRest, Pseq([

					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,1,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,1,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 1,0,0,1,
					1,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
			),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\out, BusDef(\sendbus2, \audio),
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
			Pseq([
				Plazy({
					var lib = {
						Pfindur(2,Ppar([
							PatKitDef(\bat).asPattern(Pbind(
								\kitIndex, 8,
								\isRest, Pseq([
									0,Pn(1,inf)
								],inf).coin.not,
								\out, BusDef(\sendbus2, \audio),
								\speed, rrand(1/2,4.0),
								//\sustain, 0.1,
								\gain, 0.2,
								\dur, 2/rrand(1,16),
							)),
							Pbind(
								\instrument, \playersec_looper,
								\trigfreq, rrand(1.0,100),
								\out, BusDef(\sendbus2, \audio),
								\bufnum, BufDef('voices/feynman.flac'),
								\dur, 1,
								\gain, 1,
								\isRest, Pseq([
									0,Pn(1,inf)
								],inf).coin.not,
								\speed, rrand(1/2,4.0),
								\pos, rrand(0,10.0),
								//\sustain, 0.1,
								\gain, 0.2,
								\dur, 2/exprand(1,16),
							),
							PatKitDef(\bat).asPattern(Pbind(
								\kitIndex, 0,
								\isRest, Pseq([
									0,Pn(1,inf)
								],inf).coin.not,
								\out, BusDef(\sendbus2, \audio),
								\speed, rrand(1/2,4.0),
								//\sustain, 0.1,
								\gain, 0.2,
								\dur, 1/8,
								\dur, 2/rrand(1,16),
								\isRest, true,
							)),
						]));
					}.dup(8);
					Pseq([
						lib[0],
						lib[1],
						lib[0],
					],1);
				}),
				Psched( [0,1],
					Plazy({
						Ppar([
							PatKitDef(\bat).asPattern(Pbind(
								\kitIndex, 8,
								\isRest, Pseq([
									0,0,0,0,Pn(1,inf)
								],inf).coin.not,
								\out, BusDef(\sendbus2, \audio),
								\speed, rrand(1/2,4.0),
								//\sustain, 0.1,
								\gain, 0.2,
								\dur, 2/rrand(1,16),
							)),
							Pbind(
								\instrument, \playersec_looper,
								\trigfreq, rrand(1.0,100),
								\out, BusDef(\sendbus2, \audio),
								\bufnum, BufDef('voices/feynman.flac'),
								\dur, 1,
								\gain, 1,
								\isRest, Pseq([
									0,0,0,0,Pn(1,inf)
								],inf).coin.not,
								\speed, rrand(1/2,4.0),
								\pos, rrand(0,10.0),
								//\sustain, 0.1,
								\gain, 0.2,
								\dur, 2/exprand(1,16),
							),
							PatKitDef(\bat).asPattern(Pbind(
								\kitIndex, 0,
								\isRest, Pseq([
									0,0,0,0,Pn(1,inf)
								],inf).coin.not,
								\out, BusDef(\sendbus2, \audio),
								\speed, rrand(1/2,4.0),
								//\sustain, 0.1,
								\gain, 0.2,
								\dur, 1/8,
								\dur, 2/rrand(1,16),
								\isRest, true,
							)),
						]);
				
					})
				),
			],inf),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 0,1,1,1,
				],inf).coin.not,
				\out, BusDef(\sendbus2, \audio),
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\isRest, true,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\out, BusDef(\sendbus3, \audio),
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.2,
				\dur, 1/8,
				\out, BusDef(\sendbus3, \audio),
			)),
			
		])
	)).play;
	);

(
Ndef(\ampread, { 
	var sig = InFeedback.ar(ProtoDef(\rdn3).inbus);
	sig = Amplitude.kr(sig) * \scale.kr(1) + \bias.kr(0);
	sig = LagUD.kr(sig, 0, \lagdown.kr(1));
	//sig.poll;
	sig;
});
)
Ndef(\ampread).edit
(
ProtoDef(\rdn2).proxy[150] = \filter -> { arg in;
	var sig;
	var inkick = InFeedback.ar(ProtoDef(\rdn).inbus);
	var insnare = InFeedback.ar(ProtoDef(\rdn3).inbus);
	sig = Compander.ar(in, inkick + insnare, \cpt.kr(0.04), \cpbelow.kr(0.901), \cpabove.kr(0.001), \cpclamp.kr(0.01), \cprelax.kr(2.1));
	sig;

	
}
)

ProtoDef(\rdn2).proxy.quant = 2
(
ProtoDef(\rdn2).proxy[150] = \filter -> { arg in;
	var sig;
	var gate;
	gate = Duty.kr(1/8/~t, 0, Dseq([
		Dseq([
			0,1,1,1, 1,1,1,1,
		],inf),
		0,1,1,1, 1,1,1,1,
		0,1,1,0, 1,1,1,1,

		0,1,1,1, 1,1,1,1,
		0,1,1,1, 1,1,0,1,

		0,1,1,0, 1,1,0,1,
		0,0,1,1, 1,1,1,1,

		0,1,1,1, 1,1,1,1,
		0,1,1,1, 0,1,1,0,
		//0,0,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
		//0,0,1,1, 1,1,0,0, 1,1,1,1, 1,1,1,1,

		//0,0,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
		//0,0,1,1, 1,1,1,1, 1,1,1,1, 0,0,1,1,
	],inf));
	sig = in;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.4,0.1,0.8,0.01)), gate, doneAction:0);
	sig;

	
}
)

	ProtoDef(\rdn3).proxy.map(\fb, Ndef(\ampread))
	ProtoDef(\rdn2).reload
	ProtoDef(\rdn2).proxy.clear
	ProtoDef(\rdn2).proxy.objects
	ProtoDef(\rdn2).reload


(
SynthDef(\factis, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, spread=0.8;
	var sig;
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1));
	sig = sig.fold(\fold.kr(1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\factisaw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, spread=0.8;
	var sig;
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1));
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig.fold(\fold.kr(1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pspawner({ arg sp;
			9.do { arg idx;
				sp.par(
					Plazy({ arg ev;
						Ppar([
							Pbind(
								\instrument, \factis,
								\freq, exprand(60,8000),
								\fspread, ~pmodenv.(Pseq([0.001,Pseq([1,0.410]/100,2)],2), 1).loop,
								\fold, Pseq([
									~pmodenv.(Pseq([1,2,1,0.4],1), 1),
								],inf),
								\dur, Pn(2**rrand(1,4),8)/8,
								\amp, 0.1/7,
							),
						]);
					}).loop,
				);
				sp.wait(1.0.rand);
			}
	   
		})
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pspawner({ arg sp;
			9.do { arg idx;
				sp.par(
					Plazy({ arg ev;
						Ppar([
							Pbind(
								\instrument, \factis,
								\freq, exprand(60,8000),
								\fspread, ~pmodenv.(Pseq([0.001,Pseq([1,0.410]/100,2)],2), 1).loop,
								\fold, Pseq([
									~pmodenv.(Pseq([1,2,1,0.4],1), 1),
								],inf),
								\dur, Pn(2**rrand(1,4),16*2)/8 * Pseg(Pseq([1,0.1,0.1,0.1],inf),4,\exponential),
								\amp, 0.1/7,
							),
						]);
					}).loop,
				);
				sp.wait(1.0.rand);
			}
	   
		})
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\zed2, 
	Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyfreqenv, [ Env([261, 104, 41], [0.035, 0.08], curve: \exp) ],
					\bodyenv, [ Env.linen(0.005, 0.1, 0.3) ],
		
					\popfstart, 750,
					\popfend, 261,
					\popfdur, 0.02,
					\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
					\popamp, 0.15,
		
					\formfund, 910,
					\formfreq, 4760,
					\formbw, 2110,
					\lpf, 3140,
					\clickat, 0.001,
					\clickrel, 0.01,
					\clickamp, 0.15,
		
					\distpreamp, 1,
					\distpostamp, 1,
		
					\isRest, Pseq([
		
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,1,
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
		
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,1,
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,1,0,
						0,0,0,0, 1,0,0,1,
						1,0,0,0, 0,0,0,0,
						0,0,0,1, 1,0,0,1,
					],inf).coin.not,
					\dur, 1/8,
					\amp, 0.1,
					\out, BusDef(\sendbus1, \audio),
				),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,1,
					],inf).coin.not,
					\out, BusDef(\sendbus3, \audio),
					\sustain, 0.05,
					\fac1,0.1,
					\dur, 1/8,
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 0,1,1,1,
				],inf).coin.not,
				\out, BusDef(\sendbus2, \audio),
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\isRest, true,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\out, BusDef(\sendbus3, \audio),
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.2,
				\dur, 1/8,
				\out, BusDef(\sendbus3, \audio),
			)),
		Pbind(
			\out, BusDef(\sendbus2, \audio),
		)<>
		Pseq([
			Pfindur(16,Pspawner({ arg sp;
				"one".debug;
				9.do { arg idx;
					sp.par(
						Plazy({ arg ev;
							Ppar([
								Pbind(
									\instrument, \factisaw,
									\freq, exprand(60,8000),
									\fspread, ~pmodenv.(Pseq([0.001,Pseq([1,0.410]/100,2)],2), 1).loop,
									\fold, Pseq([
										~pmodenv.(Pseq([1,2,1,0.4],1), 1),
									],inf),
									\dur, Pn(2**rrand(1,4),8)/8,
									\amp, 0.1/7,
								),
							]);
						}).loop,
					);
					sp.wait(1.0.rand);
				}
		
			})),
			Pfindur(16,Pspawner({ arg sp;
				"two".debug;
				9.do { arg idx;
					sp.par(
						Plazy({ arg ev;
							Ppar([
								Pbind(
									\instrument, \factisaw,
									\freq, exprand(60,8000),
									\fspread, ~pmodenv.(Pseq([0.001,Pseq([1,0.410]/100,2)],2), 1).loop,
									\fold, Pseq([
										~pmodenv.(Pseq([1,2,1,0.4],1), 1),
									],inf),
									\dur, Pn(2**rrand(1,4),16*2)/8 * Pseg(Pseq([1,0.1,0.1,0.1],inf),4,\exponential),
									\amp, 0.1/7,
								),
							]);
						}).loop,
					);
					sp.wait(1.0.rand);
				}
		
			}))
		],inf)
	]),
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\zed2, 
	Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyfreqenv, [ Env([261, 104, 41], [0.035, 0.08], curve: \exp) ],
					\bodyenv, [ Env.linen(0.005, 0.1, 0.3) ],
		
					\popfstart, 750,
					\popfend, 261,
					\popfdur, 0.02,
					\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
					\popamp, 0.15,
		
					\formfund, 910,
					\formfreq, 4760,
					\formbw, 2110,
					\lpf, 3140,
					\clickat, 0.001,
					\clickrel, 0.01,
					\clickamp, 0.15,
		
					\distpreamp, 1,
					\distpostamp, 1,
		
					\isRest, Pseq([
		
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,1,
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
		
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,1,
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,1,0,
						0,0,0,0, 1,0,0,1,
						1,0,0,0, 0,0,0,0,
						0,0,0,1, 1,0,0,1,
					],inf).coin.not,
					\dur, 1/8,
					\amp, 0.1,
					\out, BusDef(\sendbus1, \audio),
				),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,1,
					],inf).coin.not,
					\out, BusDef(\sendbus3, \audio),
					\sustain, 0.05,
					\fac1,0.1,
					\dur, 1/8,
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 0,1,1,1,
				],inf).coin.not,
				\out, BusDef(\sendbus2, \audio),
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\isRest, true,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\out, BusDef(\sendbus3, \audio),
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.2,
				\dur, 1/8,
				\out, BusDef(\sendbus3, \audio),
			)),
		Pbind(
			\out, BusDef(\sendbus2, \audio),
		)<>
		Pseq([
			Pfindur(16,Pspawner({ arg sp;
				var transp;
				"one".debug;
				sp.par(
					Pbind(
						\transp, Pseq([
							3,0,4,1, 5,2,6,3,
						].reverse,inf),
						\play, {
							transp = ~transp;
						}, 
						\dur, 4,
					),
				);
				9.do { arg idx;
					sp.par(
						Plazy({ arg ev;
							Ppar([
								Pbind(
									\lag, 0.0005,
									\instrument, \factisaw,
									//\freq, exprand(60,8000),
									//\degree, rrand(0,7*5),
									\note, [0,3,7,10,13].choose + ([0,1,2,3,4]*12).choose,
									\ctranspose, Pfunc({ transp }),
									\lpfr, rrand(1.1,2),
									\rq, rrand(0.1,0.9),
									\legato, rrand(0.1,1),
									\adsr, Pseq([
										Prand([
											[ Env.adsr(0.1,0.1,0.8,0.1) ],
											[ Env.adsr(0.01,0.1,0.8,0.1) ],
											[ Env.adsr(0.01,0.1,0.8,0.01) ],
											[ Env.adsr(0.1,0.1,0.8,0.01) ],
											[ Env.adsr(0.2,0.1,0.8,0.01) ],
											[ Env.adsr(0.2,0.1,0.8,0.2) ],
										],1),
									],inf),
									\octave, 3,
									\scale, Scale.dorian,
									\fspread, ~pmodenv.(Pseq([0.001,Pseq([1,0.410]/100,2)],2), 1).loop,
									\fold, Pseq([
										~pmodenv.(Pseq([1,2,1,0.4],1), 1),
									],inf),
									\dur, Pn(2**rrand(1,4),8*2)/16,
									\amp, 0.1/7,
								),
							]);
						}).loop,
					);
					sp.wait(1.0.rand);
				}
		
			})),
		],inf)
	]),
)).play;
);

(
[\rdn, \rdn2, \rdn3, \rdn4].collect({ arg key;
	ProtoDef(key).presetCompileString;
}).join("\n\n").editorInsert
)
(
ProtoDef('rdn').make('deldefault', 'rdn', "4-GTU4-EC0L", BusDef(\sendbus1));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.42038826827877,
	'gain', 0.8781512605042,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 1.0,
	'shift', -0.21008403361345,
	'shift2', -0.3781512605042,
	'distamp', 0.69909760632006,
	'pitchlag', 1.0,
	'pitchmix', 0.68487394957983,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 3.9466141732283,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.0001,
	'distamp2', 3.9466141732283,
).keep(1));


ProtoDef('rdn2').make('deldefault', 'rdn2', "4-3JEU-7T3F", BusDef(\sendbus2));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.15865695594442,
	'gain', 0.93697478991597,
	'fb', 0.00010795156148588,
	'delay', 0.0001,
	'delay2', 0.53838436220335,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 19.684194472866,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 5.3996444583459,
	'fbdistmix', 1,
	'postlpf', 17000,
	'posthpf', 20.0,
	'wetamp', 0.21582339958846,
	'indelay', 0,
	'wet20', 1.0,
	'mamp', 2,
	'wet150', 1.0,
	'adsr', Env([ 0, 1, 0.8, 0 ], [ 0.4, 0.1, 0.359741 ], [ -4, -4, 4 ], 2),
).keep(1));


ProtoDef('rdn3').make('deldefault', 'rdn3', "4-O5JS-DEK5", BusDef(\sendbus3));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.5,
	'gain', 0.55042016806723,
	'fb', 0.001,
	'delay', 0.33838551534282,
	'delay2', 0.47937156455582,
	'shift', 0,
	'shift2', 0,
	'distamp', 1,
	'pitchlag', 0.125,
	'pitchmix', 0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.5,
	'fbdistmix', 1,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 1,
	'indelay', 0.02,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));


ProtoDef('rdn4').make('default', 'rdn4', nil, BusDef(\zero));
Ndef('rdn4').put(100, \pset -> Pbind(
	
).keep(1));

);


/////////////////////////////////////////////////////////////

(
SynthDef(\doublebell, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var tabsize = 30;
	sig = WhiteNoise.ar;
	sig = LFSaw.ar(freq);
	sig = sig * EnvGen.ar(Env.perc(0.001,0.01),gate);
	sig1 = Ringz.ar(sig, \freqtab.kr({exprand(100,10000) }.dup(tabsize)) * \freqr.kr(1), \res.kr(3.dup(tabsize))).mean;
	sig2 = Ringz.ar(sig, \freqtab2.kr({exprand(100,10000) }.dup(tabsize)) * \freqr2.kr(1), \res2.kr(0.1.dup(tabsize))).mean;
	sig = SelectX.ar(Line.kr(0,0.5,1/2), [sig1 , sig2]);
	sig = LPF.ar(sig, EnvGen.kr(Env([1000,200,1000]+1000,[0.4,0.8]), 1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,1.5,1,1)), gate, doneAction:2) * 0.4;
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
				\instrument, \doublebell,
				\freqtab, Pseq([
					[{exprand(40,10000) }.dup(30)  ]
				],inf),
				\freqtab2, Pseq([
					[{exprand(40,10000) }.dup(30)  ]
				],inf),
				\res, Pseq([
					[{rrand(0.01,3) }.dup(30)  ]
				],inf),
				\res2, Pseq([
					[{rrand(0.01,4) }.dup(30)  ]
				],inf),
				\sustain, 0.1,
				\dur, Pseq(
					(1-2.pow((0..10).neg/4).reverse/4)
					* rrand(0.5,2)),
				\freqr, Pkey(\dur),
				\freqr, Pseg(Pseq([1,7/9],inf),2),
				\amp, 0.3,
			);
		}).loop,
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Plazy({ arg ev;
			Pbind(
				\degree, Pseq([
					1,2,3,4,5,
				],inf),
				\instrument, \doublebell,
				\freqtab, Pseq([
					[{exprand(40,10000) }.dup(30)  ]
				],inf),
				\freqtab2, Pseq([
					[{exprand(40,10000) }.dup(30)  ]
				],inf),
				\res, Pseq([
					[{rrand(0.01,3) }.dup(30)  ]
				],inf),
				\res2, Pseq([
					[{rrand(0.01,4) }.dup(30)  ]
				],inf),
				\sustain, 0.1,
				\dur, Pseq(
					(1-2.pow((0..10).neg/4).reverse/4)
					* rrand(0.5,2)),
					\dur, 1,
				\freqr, Pkey(\dur),
				\freqr, Pseg(Pseq([1,7/9],inf),2),
				\amp, 0.3,
				\out, BusDef(\sendbus1, \audio),
			);
		}).loop,
		
	])
)).play;
);

Pdef(\part).clear;
(1-2.pow((0..10).neg/4).reverse/4).plot
<
Plotter
(
WindowDef(\plot, {
	Plotter("pplo").value_((1-2.pow((0..10).neg/4).reverse/4)).view;
}).front;
)


(
SynthDef(\doublebell, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var tabsize = 30;
	sig = WhiteNoise.ar;
	sig = LFSaw.ar(freq * [0,3,7].midiratio * ( SinOsc.ar(freq+10) * 1 + 1 )).mean + sig;
	sig = sig * EnvGen.ar(Env.perc(0.01,0.061),gate);
	//sig = sig + ( BPF.ar(WhiteNoise.ar * EnvGen.kr(Env([1,1/2,0],[0.1,0.8],-1), 1), freq,0.4)  );
	sig = Ringz.ar(sig, \freqtab.kr({ exprand(0.99,1) }.dup(tabsize)), \res.kr(3.dup(tabsize))).mean;
	sig = sig + (Ringz.ar(sig, \freqtab2.kr({exprand(0.99,1.02)  }.dup(tabsize)) * freq, \res2.kr(0.1.dup(tabsize))).mean*0.01);
	sig3 = LFSaw.ar(freq * [0,3,7].midiratio).mean;
	sig3 = RLPF.ar(sig3, \lpfr.kr(1.8) * freq, \rq.kr(0.5));
	sig = sig/2 + ( sig3*2 ) * 2;
	//sig = SelectX.ar(Line.kr(0.61,0.5,1/2), [sig1 , sig2]);
	//sig = HPF.ar(sig, EnvGen.kr(Env([1000,200,1000]+1000,[0.4,0.8]), 1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,1.5,1,-1)), gate, doneAction:2) * 0.1;
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
				\octave, 4,
				\instrument, \doublebell,
				\freqtab, Pseq([
					[
						( (0..29)+rrand(40,70) ).midicps 
					]
				],inf),
				\freqtab2, Pseq([
					[{exprand(140,10000) }.dup(30)  ]
				],inf),
				\res, Pseq([
					[{rrand(0.01,5.3) }.dup(30)  ]
				],inf),
				\res2, Pseq([
					[{rrand(0.01,3.04) }.dup(30)  ]
				],inf),
				\sustain, 0.2,
				\dur, Pseq(
					(1-2.pow((0..10).neg/4).reverse/4)
					* rrand(0.5,2)),
				\freqr, 1,
				\amp, 0.1,
			);
		}).loop,
		
	])
)).play;
);

(
SynthDef(\doublebell2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var tabsize = 30;
	sig = WhiteNoise.ar;
	sig = sig * EnvGen.ar(Env.perc(0.001,0.001),gate);
	sig = DelayL.ar(Impulse.ar(0), (0..5)/100).mean;
	sig = Dust.ar(10);
	sig = LPF.ar(sig, 1000);
	//sig = sig + ( BPF.ar(WhiteNoise.ar * EnvGen.kr(Env([1,1/2,0],[0.1,0.8],-1), 1), freq,0.4)  );
	sig = Ringz.ar(sig, \freqtab.kr({ exprand(0.99,1) }.dup(tabsize)), \res.kr(3.dup(tabsize))).mean;
	sig = sig + (Ringz.ar(sig, \freqtab2.kr({exprand(0.99,1.02)  }.dup(tabsize)) * freq, \res2.kr(0.1.dup(tabsize))).mean*0.01);
	//sig = sig/2 + ( sig3*2 ) * 2;
	//sig = SelectX.ar(Line.kr(0.61,0.5,1/2), [sig1 , sig2]);
	//sig = HPF.ar(sig, EnvGen.kr(Env([1000,200,1000]+1000,[0.4,0.8]), 1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,1.5,1,-1)), gate, doneAction:2) * 3.7;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Plazy({ arg ev;
			Pbind(
				\out, BusDef(\sendbus1, \audio),
				\degree, Pseq([
					1,2,3,4,5,
				],inf),
				\octave, 4,
				\freq, 64,
				\instrument, \doublebell2,
				\freqtab, Pseq([
					[
						{exprand(60,1000)}.dup(30)
					]
				],inf),
				\freqtab2, Pseq([
					[{exprand(140,1000) }.dup(30)  ]
				],inf),
				\res, Pseq([
					[{rrand(0.01,2.3) }.dup(30)  ]
				],inf),
				\res2, Pseq([
					[{rrand(0.01,1.04) }.dup(30)  ]
				],inf),
				\sustain, 0.2,
				\dur, Pseq(
					(1-2.pow((0..10).neg/4).reverse/4)
					* rrand(0.5,2)),
				\freqr, 1,
				\amp, 0.1,
			);
		}).loop,
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 74, 51], [0.035, 0.18], curve: \exp) ],
			\out, BusDef(\sendbus1, \audio),
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\amp, 0.3,
		),
		Pdef(\alarm),
		
	])
)).play;
);


(
SynthDef(\windman, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var tabsize = 30;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([1,2,1],[2.1,2.8]), 1);
	sig = Ringz.ar(sig, { exprand(100,9000) * ( SinOsc.kr(exprand(0.01,0.1)) * 0.1 + 1 ) }.dup(tabsize), { exprand(0.01000,2.6000) * ( SinOsc.kr(exprand(0.01,10)) * 0.1 + 1 )}.dup(tabsize)) * 0.01;
	sig = sig * { ( SinOsc.kr(exprand(0.01,1)) * 0.91 + 1 ) }.dup(tabsize);
	//sig = HPF.ar(sig, EnvGen.kr(Env([10,200,13000],[1.1,1.8]), 1));
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


(
Pdef(\part, Pdef(\alarm, 
	Ppar([
		Pmono(\windman,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);



(
SynthDef(\ringme, { arg out=0, gate=1;
	var sig;
	var tabsize = 30;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = Ringz.ar(sig, { exprand(70,12000) }.dup(tabsize).sort + Rand(0,100.0!tabsize), { exprand(0.35000,1.6000) }.dup(tabsize).sort.reverse.rotate(4) + Rand(0,0.4!tabsize)) * 0.01;
	sig = Splay.ar(sig, \spread.kr(0.8), 1, 0);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/8,
			\out, BusDef(\ring, \audio),
		)),
		Pmono(\ringme,
			\inbus, BusDef(\ring, \audio),
			\out, BusDef(\sendbus1, \audio),
			\dur, 1,
		),
	])
)).play;
);

ClipTimeline(\vin8rec).edit
ClipTimeline(\vin8brec).edit

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\out, BusDef(\sendbus1, \audio),
			\instrument, \phyhat3,
			\isRest, Pseq([
				0,0, 0,0,1,0, 0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8 * (1 + (0.36 * Pseq([1,-1],inf))),
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/8,
			\out, BusDef(\ring, \audio),
		)),
		Pmono(\ringme,
			\inbus, BusDef(\ring, \audio),
			\out, BusDef(\sendbus2, \audio),
			\dur, 1,
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);

ClipTimeline(\vin8rec).edit

//ProtoDef(\rdn).clear;
//////////////:


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \default,
			\degree, Pseq([
				[0,3,7]
			],inf),
			\octave, 4,
			\octave, Ptuple(Pwhite(3,6,inf)!3),
			\legato, 1,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),

	])
)).play;
);


///////////////////////////////

SampleTimeline('rec_vin8rec_t0_191028_183535').postProxy.asParamGroup.collect(_.property)

(
SampleTimeline('rec_vin8rec_t0_191028_183535').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 4.0, \label: 'start', \playDur: 4.0, \relDur: 4.0, \sustain: 0, \type: 'start', ),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_vin8rec_t0_191028_183535').buffer = BufDef('/tmp/rec_vin8rec_t0_191028_183535.wav');
)



//////////

(
SynthDef(\monte, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(\fmfreq.kr(1) * ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1)) * \fmamp.kr(1) + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pmono(
			 \monte,
			\fspread, ~pmodenv.(Pseq([0,0.01,0.1,4],inf), 1),
			\fmfreq, ~pmodenv.(Pseq([1,200,1000],inf), 8),
			\freq, ~pmodenv.(Pseq([200,4001],inf), 8),
			\out, BusDef(\mixer3, \audio),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);
Pdef(\part).clear;

(
SynthDef(\montelp, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( LFSaw.ar(\fmfreq.kr(1) * ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1)) * \fmamp.kr(1) + 1 ));
	sig = LPF.ar(sig, \lpf.kr(100));
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
	~master.();
Pdef(\part, Pdef(\zed, 
	Pbind(
		\lpf, ~pmodenv.(Pseq([100,200,300,1000,4000,18000],1), 1),
		\hpf, 200,
	)<>
	Ppar([
		Pmono(
			 \montelp,
			\fspread, ~pmodenv.(Pseq([0,0.01,0.1,4],inf), 1.3),
			\fmfreq, ~pmodenv.(Pseq([1,200,1000],inf), 8.3),
			\freq, ~pmodenv.(Pseq([200,4001],inf), 8.3),
			\out, BusDef(\mixer3, \audio),
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(
			 \montelp,
			\fspread, ~pmodenv.(Pseq([0,0.01,0.1,4],inf), 1/2),
			\fmfreq, ~pmodenv.(Pseq([1,200,1000,10000],inf), 8/2),
			\freq, ~pmodenv.(Pseq([200,4001],inf), 8/2),
			\out, BusDef(\mixer3, \audio),
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(
			 \montelp,
			\fspread, ~pmodenv.(Pseq([0,0.01,0.1,4],inf), 1),
			\fmfreq, ~pmodenv.(Pseq([1,200,1000],inf), 8),
			\freq, ~pmodenv.(Pseq([200,4001],inf), 8),
			\out, BusDef(\mixer3, \audio),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);


SampleTimeline('rec_vin8rec_t0_191028_191424').postProxy.set(\legato, 1)



(
	~swing = 0.4;
Pdef(\part, Pdef(\zed, 
	Pbind(
		\out, BusDef(\sendbus1, \audio),
	)<>
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\isRest, Pseq([
				1,0,0,1, 0,0,0,0,
				0,1,1,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,1,1,0, 0,0,0,0,

				1,0,0,1, 0,0,0,0,
				0,1,1,0, 0,0,0,1,
				1,0,0,1, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 0,0,0,0,
			   	0,0,0,0, 1,1,1,1,
			   	1,0,1,0, 1,1,0,0,
			   	1,0,1,0, 1,0,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(16).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([0,1,0,-1],inf))),
		)),

		
	])
)).play;
);




(
	~swing = 0.4;
Pdef(\part, Pdef(\zed, 
	Pbind(
//		\out, BusDef(\sendbus1, \audio),
	)<>
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,0,1, 0,0,0,0,
					0,1,1,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
					0,1,1,0, 0,0,0,0,
			
					1,0,0,1, 0,0,0,0,
					0,1,1,0, 0,0,0,1,
					1,0,0,1, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\amp, 0.1,
			),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
			
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 1,0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/3,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq({[
					1,1,1,1, 0,0,0,0,
				   	0,0,0,0, 1,1,1,1,
				   	1,0,1,0, 1,1,0,0,
				   	1,0,1,0, 1,0,1,1,
					1,1,1,1, 1,1,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,1,0,
				].clump(8).choose}.dup(16).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([0,1,0,-1],inf))),
			)),
		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_vin8rec_t0_191028_231139').buffer,
			\pos, 1/~t + Pseg(Pseq([0,1]/~t,inf),4), 
			\pos, 24 + Pseq([
				Pseq((0..7)/8),
			],inf)/~t + Pseq((0..7),inf).stutter(8),
			\legato, Pseq([
				4,0,0,0, 0,0,0,0,
				2,0,0,0, 3,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			//\lag, 0.04,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([0,1,0,-1],inf))),
			\gain, 1/2,
		)

		
	])
)).play;
);
