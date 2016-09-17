
(
	s.waitForBoot({

~t = 80/60;
TempoClock.default.tempo = ~t;
Ndef.defaultQuant = 4;
Pdef.defaultQuant = 4;
FileSystemProject.load("radient1/lib.scd");

Ndef(\fx1).addSpec(\deltran1, ControlSpec(-1,5,\lin, 0,1));
Ndef(\fx1).addSpec(\deltran2, ControlSpec(-1,5,\lin,0,0));
Ndef(\fx1).addSpec(\deltran3, ControlSpec(-1,5,\lin,0,0));
Spec.add(\distamp, ControlSpec(0.01,30,\exp));
Spec.add(\deltran1, ControlSpec(0.01,30,\exp));
Spec.add(\deltran2, ControlSpec(0.01,30,\exp));
Spec.add(\deltran3, ControlSpec(0.01,30,\exp));

	});
)


(
	BufDef(\amen, "vipere/amenbreak.wav");
	Pdef(\drumkit, 
		Pbind(
			\instrument, \oscsampler4,
			//\degree, Pseq([0,3,5,4],inf).stutter(8) + [0,3,7],
			\octave, 4,
			\bufnum, BufDef(\amen),
			\hpfreq, 50,
			\ffreq, 4700,
			//\freq, Pseq([100,1000,10000,10],inf).stutter(8),
			\range, 0,
			\framerange, 33,
			\posenv, [ Env([0,0.01,0.1,0.0, 0.0], [0.01,0.1,3.6,3.6]) ],
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.5,0.06) ],
			],inf),
			\timeScale, 1,
			\levelScale, 0.45* Pseg(Pseq([0.01,0.1,1,10,100],inf),32),
			\levelScale, 0.51,
			//\out, BusDef(\fx1),
			\pos, Pseq([0.43,0.67,0.423,0.52].rotate(1),inf)+0.1,
			\pos, Pseq([0.43,0.67,0.423,0.52,0.8].rotate(1),inf)+0,
			\pos, 0.66,
			//\pos, 0.2,
			\hpmix, 0,
			\lpmix, 1,
			//\sustain, 1,
			//\legato, a[8].linlin(0,9,0.1,0.5),
			\legato, 1/2,
			\isRest, Pseq([
				1,0,0,0,
				1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.4
		)
	);

	Pdef(\drumseq1,
		Ppar([
			Pbind( 
				\pos, 0.66,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not
			) <> Pdef(\drumkit),
			Pbind( 
				\pos, 0.20,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.5,0.16) ],
				],inf),
				\isRest, Pseq([
					1,0, 1,0, 1,0, 1,0, 1,0,
					1,0, 1,0, 1,0, 1,0, 1,0,
					1,1, 1,0, 1,0, 1,0, 1,0,
				],inf).coin.not
			) <> Pdef(\drumkit),
			Pbind( 
				\pos, 0.19,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not
			) <> Pdef(\drumkit),

		].collect({ arg x; x
			//Pbind(\out,)
		}))

	);
	Pdef(\drumseq1).set(\out, BusDef(\fx1));

)

	(
	Pdef(\main, Ppar([
		Pdef(\drumseq1),
		Pdef(\drumseq2),
		Pdef(\drumseq3),
	])).play;
	Ndef(\fx1).play;
	Ndef(\fx2).play;
	Ndef(\fx3).play;
	)
	RandDelayNetwork(\multifb).make(\fx1, "4--", BusDef(\fx1, \audio));
	RandDelayNetwork(\default).make(\fx1, "4--", BusDef(\fx1, \audio));
	Ndef(\fx1).play;
	Ndef(\fx1).edit;
	RandDelayNetwork(\multifb).make(\fx2, "4--", BusDef(\fx2, \audio));
	Ndef(\fx2).play;
	Ndef(\fx2).edit;
	RandDelayNetwork(\multifb).make(\fx3, "4--", BusDef(\fx3, \audio));
	Ndef(\fx3).play;
	Ndef(\fx3).edit;

(
	Ndef(\fx1).put(100, \pset ->
		Pbind(
			\fb, Pseq([
				0,0,0,0.2,
			],inf)/3,
			\dur, 1,
		);
	
	);
	Ndef(\fx2).put(100, \pset ->
		Pbind(
			\delay, Pseq([
				Pseq([
					0.2,0.2,0.2,0.2,
					0.1,0.1,0,0,
				],3),

			],inf)/325.123456,
			\dur, 1,
		);
	
	)
)

(
	Pdef(\drumseq2,
		Ppar([
			Pbind( 
				\pos, 0.66,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not
			) <> Pdef(\drumkit),
			Pbind( 
				\pos, 0.20,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.5,0.16) ],
				],inf),
				\isRest, Pseq([
					1,0,0,0, 
				],inf).coin.not
			) <> Pdef(\drumkit),
			Pbind( 
				\pos, 0.19,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not
			) <> Pdef(\drumkit),
		])
	);
	Pdef(\drumseq2).set(\out, BusDef(\fx2));
)

(
	Pdef(\drumseq3,
		Ppar([
			Pbind( 
				\pos, 0.66,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not
			) <> Pdef(\drumkit),
		])
	);
	Pdef(\drumseq3).set(\out, BusDef(\fx3));
)


(
Ndef(\bass, { arg freq=50, pan=0, amp=0.1;
	var sig;
	var trig = Impulse.kr(1/4*~t);
	freq = EnvGen.kr(Env([231,231,52,41],[0,0.1,0.8]), trig);
	//sig = SinOsc.ar(freq * [1,1.01] * ( 1 + ( SinOsc.kr(101) * 1 )));
	sig = 0;
	sig = sig + SinOsc.ar(freq * ( 1 + ( SinOsc.kr(101) * 1 )));
	sig = sig * EnvGen.kr(\env.kr(Env([0,2,1,0],[0.01,0.8,0.1].normalizeSum)), trig, timeScale:2);
	sig = (sig * 100).tanh;
	sig = Pan2.ar(sig, SinOsc.ar(1/[14,15])*0.3*XLine.kr(0.001,1,2) , amp).mean;
}).play;
);

(
Ndef(\bass, { arg freq=50, pan=0, amp=0.1;
	var sig;
	var trig = Impulse.kr(1/4*~t);
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = EnvGen.kr(Env([731,731,32,41],[0,0.1,0.8]), trig);
	//sig = SinOsc.ar(freq * [1,1.01] * ( 1 + ( SinOsc.kr(101) * 1 )));
	//sig = LFSaw.ar(freq);
	sig = 0;
	sig = sig + SinOsc.ar(freq * ( 1 + ( SinOsc.kr(101) * 1 )));
	sig = sig * EnvGen.kr(\env.kr(Env([0,2,1,0],[0.01,0.8,0.1].normalizeSum)), trig, timeScale:2);
	//sig = (sig * 100).tanh;
	env1 = EnvGen.kr(Env([2,2,1],[0.01,0.8]), trig);
	sig = RLPF.ar(sig, \lpf.kr(7100) * env1, \rq.kr(0.5));
	sig = Pan2.ar(sig, SinOsc.ar(1/[14,15])*0.3*XLine.kr(0.001,1,2) , amp).mean;
}).play(BusDef(\fx2, \audio, 2).index);
);

	(
		Ndef(\bass).play;
	Pdef(\main, Ppar([
		//Pbind(\out, 0)<>Pdef(\dxseq1),
		Pbind(\out, BusDef(\fx1))<>Pdef(\dxseq1),
		Pbind(\out, 0)<>Pdef(\dxkick1),
		//Pdef(\drumseq2),
		//Pdef(\drumseq3),
	])).play;
	Ndef(\fx1).put(100, \pset ->
		Pseq([
			Pbind(
				\fb, Pseq([
					Pser([
						0,0,0,0.2,
						0,0.1,0,0.2,
						0.1,0.01,0,0.2,
					],16),
					Pser([
						0,0,0,0, 0,0,0,0,
						1,1,1,0, 0,0,0,0,
					],16)/10,
					Pser([
						0,0,0,0.2,
						0,0.1,0,0.2,
						0.1,0.01,0,0.2,
					],16),
					Pser([
						0.11,
					],16),
				],inf)/3,
				\dur, 1/4,
			);
		])
	
	);
	Ndef(\fx1).send;
	Ndef(\fx1).play;
	Ndef(\fx2).play;
	)

	RandDelayNetwork(\multifb).make(\fx1, "4--", BusDef(\fx1, \audio));
	Ndef(\fx1).play;
	Ndef(\fx1).edit;

	RandDelayNetwork(\multifb).make(\fx2, "4--", BusDef(\fx2, \audio));
	Ndef(\fx2).play;
(
	Pdef(\dxseq1,
		Ppar([
			Pbind( 
				\pos, 0.46,
				\timeScale, Pseq([1,2],inf).stutter(2),
				\isRest, Pseq([
					1,0
				],inf).coin.not
			) <> Pdef(\drumkit),
			Pbind( 
				\pos, 0.66,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not
			) <> Pdef(\drumkit),
		])
	);
	//Pdef(\drumseq3).set(\out, BusDef(\fx3));
)
Pdef(\dxkick1).play
(
	Pdef(\dxkick1,
		Pbind(
			\instrument, \zkick,
			\freq, 200,
			\timeScale, 0.6,
			\isRest, Pseq([
				Pseq([
					0,0.0,0.03,0.0, 1,0,0,0,
					0,0.0,0.03,0.0, 1,0,0,0,
				],3),
				Pseq([
					0,0.0,0.03,0.0, 1,0,0,0,
					1,0.0,0.03,0.0, 1,0,0,0,
				],1),
				Pseq([
					0,0.0,0.03,0.0, 1,0.51,0,0.51,
					1,0.0,0.03,0.0, 1,0,0,0,
				],3),
				Pseq([
					0,0.0,0.03,0.0, 1,0,0,0,
					1,0.0,0.03,0.0, 1,0,0,0,
				],1),
				//0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.4
		),
	);
	Pdef(\dxseq1,
		Ppar([
			//Pdef(\dxkick1),
			Pbind( 
				\pos, 0.50,
				\timeScale, Pseq([1,2],inf).stutter(2),
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not
			) <> Pdef(\drumkit),
			Pbind( 
				\pos, 0.56,
				\timeScale, Pseq([1,2],inf).stutter(2),
				\isRest, Pseq([
					0,0,0,0,
					1,0,1,0,
				],inf).coin.not
			) <> Pdef(\drumkit),
			Pbind( 
				\pos, 0.46,
				\timeScale, Pseq([1,2],inf).stutter(2),
				\isRest, Pseq([
					1,0,1,0,
					0,0,0,0,
				],inf).coin.not
			) <> Pdef(\drumkit),
			Pbind( 
				\pos, 0.66,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not
			) <> Pdef(\drumkit),
		])
	);
	//Pdef(\drumseq3).set(\out, BusDef(\fx3));
)

{ rrand(1,45) } ! 6


