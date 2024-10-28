~t = 175/4/60; TempoClock.default.tempo = ~t;
// contrainte: composer avec juste le drone, les percussions, et des effets
// on s'en fout si c'est nul, et si on a d'autres idées on les ajoutera quand ce premier morceau sera terminé

(
SynthDef(\sinduty, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar( Duty.kr(1/2/~t, 0, Dseq([ 100,200,300, ],inf) * \freqfac.kr(1)));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pspawner({ arg sp;
			loop {
				sp.par(
					Pmono( \sinduty,
						\dur, 1,
						\amp, 0.1,
						\out, BusDef(\sendbus1, \audio),
					),
				
				);
				( 2 + rrand(0.1,2) /~t ).wait
			}
		}),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Big City Lights.wav'),
			\legato, 1,
			\st, 102/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				\r,\r,\r,\r, \r,\r,\r,\r,
				\r,\r,\r,\r, \r,\r,\r,\r,
				\r,\r,0,0, \r,\r,\r,\r,
				\r,\r,\r,\r, \r,\r,\r,\r,

				\r,\r,\r,\r, \r,\r,\r,\r,
				0,\r,\r,\r, \r,\r,8,0,
				\r,\r,\r,\r, \r,\r,\r,\r,
				\r,0,8,\r, \r,\r,\r,\r,
				//0,3,3,0, 8,3,6,0,
				//4,3,3,0, 8,3,0,\r,
			],inf)/16 / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Big City Lights.wav'),
			\legato, 1,
			\st, 102/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				12,12,12,12, 11,10,10,0,
				4,9,9,9, 8,10,10,0,
				//0,3,3,0, 8,3,6,0,
				//4,3,3,0, 8,3,0,\r,
			],inf)/16 / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
		
	])
)).play;
);

ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-P3DL-SG93", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.47478991596639,
	'gain', 0.28319327731092,
	'fb', 0.0001,
	'delay', 0.51794746792312,
	'delay2', 0.11015819387359,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.1416643274669,
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
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-S8VB-QUNK", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.77791010151461,
	'gain', 0.31260504201681,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.45233707447721,
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
Pdef(\part, Pdef(\intro, 
	Ppar([
		
	])
)).play;
);


(
Pdef(\drone1, 
	Pspawner({ arg sp;
		ProtoDef(\rdn).play;
		ProtoDef(\rdn).rebuild;
		ProtoDef(\rdn).proxy.set(\delay, 0.65, \delay2, 0.66);
		ProtoDef(\rdn).proxy.set(\mix, Ndef(\lfo1, { Line.kr(0,0.6,8) }));
		10.do {
			sp.par(
				Pmono( \sinduty,
					\dur, 1,
					\amp, 0.1,
					\out, BusDef(\sendbus1, \audio),
				),

			);
			( 2 + rrand(0.1,2) /~t ).wait
		}
	}),
).play;
);

(
Pdef(\drone1, 
	Pspawner({ arg sp;
		ProtoDef(\rdn).play;
		ProtoDef(\rdn).rebuild;
		ProtoDef(\rdn).proxy.set(\mix, 0.5);
		ProtoDef(\rdn).proxy.set(\delay, Ndef(\lfo1, { Line.kr(0,0.651,8) }));
		ProtoDef(\rdn).proxy.set(\delay2, Ndef(\lfo2, { Line.kr(0,0.651,8) }));
		10.do {
			sp.par(
				Pmono( \sinduty,
					\dur, 1,
					\amp, 0.1,
					\out, BusDef(\sendbus1, \audio),
				),

			);
			( 2 + rrand(0.1,2) /~t ).wait
		}
	}),
).play;
);

(
Pdef(\drone1b, 
	Pspawner({ arg sp;
		ProtoDef(\rdn).play;
		ProtoDef(\rdn).rebuild;
		ProtoDef(\rdn).proxy.set(\mix, 0.5);
		ProtoDef(\rdn).proxy.set(\delay, Ndef(\lfo1, { Line.kr(0,0.651,8) }));
		ProtoDef(\rdn).proxy.set(\delay2, Ndef(\lfo2, { Line.kr(0,0.651,8) }));
		10.do {
			sp.par(
				Pmono( \sinduty,
					\dur, 1,
					\amp, 0.1,
					\freqfac, 4.midiratio,
					\out, BusDef(\sendbus1, \audio),
				),

			);
			( 2 + rrand(0.1,2) /~t ).wait
		}
	}),
).play;
);


Pdef(\drone1).clear;

(
	ProtoDef(\rdn2).play;
	ProtoDef(\rdn2).proxy.set(\mix, 0.1);
	//ProtoDef(\rdn2).proxy.set(\mix, Ndef(\rmix2, { Line.kr(0.1,0.5) }));
Pdef(\drums1, 
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Big City Lights.wav'),
			\legato, 1,
			\st, 102/2/60,
			\hpmix, 1,
			\hpf, ~pmodenv.(Pseq([20000,10,10],1), 16).loop,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([0,1,2]+12,inf),8),
				//12,12,12,12, 11,13,13,13,
				//0,3,3,0, 8,3,6,0,
				//4,3,3,0, 8,3,0,\r,
			],inf)/16 / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
).play;
);
(
	ProtoDef(\rdn2).play;
	ProtoDef(\rdn2).proxy.set(\mix, 0.1);
	//ProtoDef(\rdn2).proxy.set(\mix, Ndef(\rmix2, { Line.kr(0.1,0.5) }));
Pdef(\drums2, 
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Big City Lights.wav'),
			\legato, 1,
			\st, 102/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				12,12,12,12, 11,10,10,0,
				4,9,9,9, 8,10,10,0,
				12,12,12,12, 11,10,10,0,
				4,9,9,9, 8,10,10,0,
				12,12,12,12, 11,10,10,0,
				4,9,9,9, 8,10,10,0,
				12,12,12,12, 11,10,10,0,
				12,13,13,13, 10,11,11,0,
				//11,8,11,10, 12,13,10,0,
				//0,3,3,0, 8,3,6,0,
				//4,3,3,0, 8,3,0,\r,
			],inf)/16 / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
).play;
);

(
	ProtoDef(\rdn2).play;
	ProtoDef(\rdn2).proxy.set(\mix, 0.1);
	//ProtoDef(\rdn2).proxy.set(\mix, Ndef(\rmix2, { Line.kr(0.1,0.5) }));
Pdef(\drums2, 
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Big City Lights.wav'),
			\legato, 1,
			\st, 102/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				Pseq([
					12,12,12,12, 11,10,10,0,
					12,13,13,13, 10,11,11,0,
				],3),
				Pseq([
					12,12,12,12, 11,10,10,0,
					12,12,13,13, 10,10,11,11,
				],1),
				//Pseq([
					//12,12,12,12, 11,10,10,0,
					//12,13,9,13, 8,10,10,0,
				//],1),
				//Pseq([
					//12,12,12,12, 11,10,10,0,
					//4,9,9,9, 8,10,10,0,
				//],1),
				//11,8,11,10, 12,13,10,0,
				//0,3,3,0, 8,3,6,0,
				//4,3,3,0, 8,3,0,\r,
			],inf)/16 / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
).play;
);

(
	ProtoDef(\rdn2).play;
	ProtoDef(\rdn2).proxy.set(\mix, 0.1);
	//ProtoDef(\rdn2).proxy.set(\mix, Ndef(\rmix2, { Line.kr(0.1,0.5) }));
Pdef(\drums3, 
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Big City Lights.wav'),
			\legato, 1,
			\st, 102/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				Pseq([
					12,12,12,12, 11,10,10,0,
					12,13,13,13, 10,11,11,0,
				],3),
				Pseq([
					12,12,12,12, 11,10,10,0,
					12,12,13,13, 10,10,11,11,
				],1),
				//Pseq([
					//12,12,12,12, 11,10,10,0,
					//12,13,9,13, 8,10,10,0,
				//],1),
				//Pseq([
					//12,12,12,12, 11,10,10,0,
					//4,9,9,9, 8,10,10,0,
				//],1),
				//11,8,11,10, 12,13,10,0,
				//0,3,3,0, 8,3,6,0,
				//4,3,3,0, 8,3,0,\r,
			],inf)/16 / Pkey(\st),
			\dur, 2,
			\sustain, 0.1,
			\gain, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
).play;
);
(
	ProtoDef(\rdn2).play;
	ProtoDef(\rdn2).proxy.set(\mix, 0.1);
	//ProtoDef(\rdn2).proxy.set(\mix, Ndef(\rmix2, { Line.kr(0.1,0.5) }));
Pdef(\drums4, 
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Big City Lights.wav'),
			\legato, 1,
			\st, 102/2/60,
			\hpmix, 1,
			\hpf, ~pmodenv.(Pseq([20000,10,10],1), 16).loop,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([0,1,2]+12,inf),8),
				//12,12,12,12, 11,13,13,13,
				//0,3,3,0, 8,3,6,0,
				//4,3,3,0, 8,3,0,\r,
			],inf)/16 / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
).play;
);

Pdef(\part, Pdef(\main, 
	Pseq([
		P
		
	])
)).play;

(
Tdef(\main, {
	Pdef(\drone1).stop;
	Pdef(\drums1).stop;
	ProtoDef(\rdn).stop;
	ProtoDef(\rdn).play;
	ProtoDef(\rdn2).play;


	Pdef(\drone1).play;
	Pdef(\drumseq1, Pseq([
		Pfindur(32,Pdef(\drums1)),
		Pfindur(32,Pdef(\drums2)),
	],1)).play;
}).play;
)

(
Tdef(\main, {
	Pdef(\drone1).stop;
	Pdef(\drums1).stop;
	ProtoDef(\rdn).stop;
	ProtoDef(\rdn2).stop;
	ProtoDef(\rdn).play;
	ProtoDef(\rdn2).play;


	Pdef(\drone1).play;
	5.wait;
	Pdef(\drums3).play;
	Pdef(\drums4).play;
	25.wait;
	Pdef(\drone1).stop;
	Pdef(\drone1b).play;

}).play;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drone1b)
		
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				7,2,7+12
			],inf),
			\freq, Pseq([
				100,200,300,
			],inf),
			\freq, 100 * Pseq([
				Pseq([
					0,12,12 + 7,
				],inf)+4,
			],inf).midiratio,
			\octave, 3,
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);
