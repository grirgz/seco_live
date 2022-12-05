
~t = 145/4/60; TempoClock.default.tempo = ~t;
(
SynthDef(\multidelay, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = DelayL.ar(sig, \maxdelay.kr(0.2), [ \deltab.kr((1..8)/8/8/~t) ]);
	sig = sig * [ \delamptab.kr(1!8) ];
	sig = sig.flop.sum;
	sig = sig * \wetgain.kr(1);
	sig.debug("sig");
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
)
(1..8)/8/8/~t
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[282].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\cfx1, \audio),
		),
		Pmono(\multidelay,
			\inbus, BusDef(\cfx1, \audio),
			\deltab, [ ( (1..8)/8/2/~t ) ], 
			\maxdelay, 1,
			\addAction, \addToTail,
			\lag, 0.0009,
			\gain, 0.4,
			\mix, 0.5,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[282].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\cfx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1885].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\cfx1, \audio),
		),
		Pmono(\multidelay,
			\inbus, BusDef(\cfx1, \audio),
			\deltab, Plazy({ arg ev;
				Pseq([
					[ 512.partition(8)/16/4 ],
				],[2,3,4].choose)
			}).loop,
			\addAction, \addToTail,
			\maxdelay, 1.0,
			\lag, 0.0009,
			\gain, 0.3,
			\dur, 1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus2, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[282].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\cfx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1885].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\cfx2, \audio),
		),
		Pmono(\multidelay,
			\inbus, BusDef(\cfx1, \audio),
			\deltab, Plazy({ arg ev;
				Pseq([
					[ 512.partition(8)/16/[2,4,8].choose ],
				],[2,3,4].choose*2)
			}).loop,
			\delamptab, Pseq([
				[ [ 1,0,0,0, 0,0,0,0, ] ],
				[ [ 1,1,1,1, 0,0,0,0, ] ],
				[ [ 1,0,0,0, 0,0,0,0, ] ],
				[ [ 1,0,1,0, 1,0,1,0, ] ],
				[ [ 0,0,0,0, 1,1,1,1, ] ],
				[ [ 1,0,0,0, 0,0,0,0, ] ],
				[ [ 1,1,1,1, 1,1,1,1, ] ],
			],inf),
			\addAction, \addToTail,
			\maxdelay, 1.0,
			\lag, 0.0009,
			\gain, 0.3,
			\dur, 1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\multidelay,
			\inbus, BusDef(\cfx2, \audio),
			\deltab, Plazy({ arg ev;
				Pseq([
					[ 512.partition(8)/16/[2,4,8].choose ],
				],[2,3,4].choose*2)
			}).loop,
			\delamptab, [ [ 1,0,0,0, 0,0,0,0, ] ],
			\delamptab, Prand([
				[ [ 1,0,0,0, 0,0,0,0, ] ],
				[ [ 1,1,1,1, 0,0,0,0, ] ],
				[ [ 1,0,0,0, 0,0,0,0, ] ],
				[ [ 1,0,1,0, 1,0,1,0, ] ],
				[ [ 0,0,0,0, 1,1,1,1, ] ],
				[ [ 1,0,0,0, 0,0,0,0, ] ],
				[ [ 1,1,1,1, 1,1,1,1, ] ],
			],inf),
			\addAction, \addToTail,
			\maxdelay, 1.0,
			\lag, 0.0009,
			\gain, 0.3,
			\dur, 1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1336].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 0,0,0,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1,1, 1,1,4,0.4,
				1,1,1,1, 1,1,1,1,
				1,1,4,0.1, 1,1,1,1
			]*0.8,inf),
			\dur, 1/16,
			\gain, 0.05,
			\out, BusDef(\sendbus2, \audio),
		),
		
	])
)).play;
);

ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "4-K2I5-M6BT", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.23109243697479,
	'gain', 0.98739495798319,
	'fb', 0.001976642902517,
	'delay', 0.00026312860738959,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 6.7256008986351,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

(
ProtoDef('rdn').make('deldefault', 'rdn', "4-N17M-4BQJ", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.5,
	'gain', 1.0,
	'fb', 0.010640563987112,
	'delay', 0.00038746751204561,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 6.3463059962866,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

ProtoDef(\rdn2).presetCompileString.editorInsert
(
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-APLP-9PL2", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.80672268907563,
	'gain', 0.27310924369748,
	'fb', 0.0004118463107867,
	'delay', 0.38004229563659,
	'delay2', 0.0021268217472962,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 5.8170913293744,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 20000.0,
	'prehpf', 17,
	'lpf', 20000.0,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 20000.0,
	'posthpf', 20.0,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[282].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\cfx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1885].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\cfx2, \audio),
		),
		Pmono(\multidelay,
			\inbus, BusDef(\cfx1, \audio),
			\deltab, Plazy({ arg ev;
				Pseq([
					[ 512.partition(8)/16/[2,4,8].choose ],
				],[2,3,4].choose*2)
			}).loop,
			\delamptab, Pseq([
				[ [ 1,0,0,0, 0,0,0,0, ] ],
				[ [ 1,1,1,1, 0,0,0,0, ] ],
				[ [ 1,0,0,0, 0,0,0,0, ] ],
				[ [ 1,0,1,0, 1,0,1,0, ] ],
				[ [ 0,0,0,0, 1,1,1,1, ] ],
				[ [ 1,0,0,0, 0,0,0,0, ] ],
				[ [ 1,1,1,1, 1,1,1,1, ] ],
			],inf),
			\addAction, \addToTail,
			\wetgain, 0.4,
			\maxdelay, 1.0,
			\lag, 0.0009,
			\gain, 0.3,
			\dur, 1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\multidelay,
			\inbus, BusDef(\cfx2, \audio),
			\deltab, Plazy({ arg ev;
				Pseq([
					[ 512.partition(8)/16/[2,4,8].choose ],
				],[2,3,4].choose*2)
			}).loop,
			\delamptab, [ [ 1,0,0,0, 0,0,0,0, ] ],
			\wetgain, 0.4,
			\delamptab, Pseq([
				[ [ 0,0,0,0, 0,0,0,0, ] ],
				[ [ 1,0,0,0, 0,0,0,0, ] ],
				[ [ 1,1,1,1, 0,0,0,0, ] ],
				[ [ 1,0,0,0, 0,0,0,0, ] ],
				[ [ 1,0,1,0, 1,0,1,0, ] ],
				[ [ 0,0,0,0, 1,1,1,1, ] ],
				[ [ 1,0,0,0, 0,0,0,0, ] ],
				[ [ 1,1,1,1, 1,1,1,1, ] ],
			],inf),
			\addAction, \addToTail,
			\maxdelay, 1.0,
			\lag, 0.0009,
			\gain, 0.3,
			\dur, 1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1336].value,
			\isRest, Prand([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 0,0,0,0,
				1,0,1,1, 1,0,1,0,
			].clump(8).collect({ arg x; Pseq(x,1) }),inf).coin.not,
			\legato, Pseq([
				1,1,1,1, 1,1,4,0.4,
				1,1,1,1, 1,1,1,1,
				1,1,4,0.1, 1,1,1,1
			]*0.8,inf),
			\dur, 1/16,
			\gain, 0.05,
			\out, BusDef(\sendbus2, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[282].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\cfx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1885].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\cfx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\cfx2, \audio),
		),
		Pmono(\multidelay,
			\inbus, BusDef(\cfx1, \audio),
			\deltab, [ ( (1..8)/8/2/~t ) ], 
			\delamptab, [ [ 1,1,1,1, 0,0,0,0, ].scramble ],
			\maxdelay, 1,
			\addAction, \addToTail,
			\wetgain, 0.4,
			\lag, 0.0009,
			\gain, 0.4,
			\mix, 0.5,
			\dur, 1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\multidelay,
			\inbus, BusDef(\cfx2, \audio),
			\deltab, [ ( (1..8)/8/2/~t ) ], 
			\delamptab, [ [ 1,1,1,1, 0,0,0,0, ].scramble ],
			\maxdelay, 1,
			\addAction, \addToTail,
			\wetgain, 0.4,
			\lag, 0.0009,
			\gain, 0.4,
			\mix, 0.5,
			\dur, 1,
			\out, BusDef(\sendbus2, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[282].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\cfx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1885].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\cfx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Prand([
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,1,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			].clump(8).collect(Pseq(_)),inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\cfx2, \audio),
		),
		Pmono(\multidelay,
			\inbus, BusDef(\cfx1, \audio),
			\deltab, [ ( (1..8)/8/2/~t ) ], 
			\delamptab, Plazy({ arg ev;
				Pseq([
					Pseq([
						Pseq([
							[ [ 1,1,1,1, 0,0,0,0, ].scramble ],
						],3),
						[ [ 1,1,1,1, 0,0,0,0, ].scramble ],
					],3),
					Pseq([
						[ [ 1,1,1,1, 0,0,0,0, ].scramble ],
					],3),
					[ [ 1,1,1,1, 0,0,0,0, ].scramble ],
				],1);
			}).loop,
			\maxdelay, 1,
			\addAction, \addToTail,
			\wetgain, 0.4,
			\lag, 0.0009,
			\gain, 0.4,
			\mix, 0.5,
			\dur, 1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\multidelay,
			\inbus, BusDef(\cfx2, \audio),
			\deltab, [ ( (1..8)/8/4/~t ) ], 
			\delamptab, Plazy({ arg ev;
				Pseq([
					Pseq([
						Pseq([
							[ [ 1,1,1,1, 0,0,0,0, ].scramble ],
						],3),
						[ [ 1,1,1,1, 0,0,0,0, ].scramble ],
					],3),
					Pseq([
						[ [ 1,1,1,1, 0,0,0,0, ].scramble ],
					],3),
					[ [ 1,1,1,1, 0,0,0,0, ].scramble ],
				],1);
			}).loop,
			\maxdelay, 1,
			\addAction, \addToTail,
			\wetgain, 0.4,
			\lag, 0.0009,
			\gain, 0.4,
			\mix, 0.5,
			\dur, 1,
			\out, BusDef(\sendbus2, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[282].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1885].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\fx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus2, \audio),
		),
	])
)).play;
);
