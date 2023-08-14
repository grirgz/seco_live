~t = 300/4/60; TempoClock.default.tempo = ~t;
// steal from sun2

FileSystemProject.load("sun/sun27.scd");
FileSystemProject.load("sun/sun27b.scd");

(
SynthDef(\sunfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(\fmf.kr(40)) * \fma.kr(1) + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\sunfm2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 4;
	sig = SinOsc.ar(freq * ( SinOsc.ar(\fmf.kr(40)) * \fma.kr(1) + 1 ));
	num.do { arg x;
		sig = sig + ( SinOsc.ar(freq * (1/(x+1)) * ( SinOsc.ar(\fmf.kr * ( x+1 )) * \fma.kr + 1 )) * (1/(x+1)) );
	} / num;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


//////////////////////////////////
//////////////////////////////////
//////////////////////////////////
//////////////////////////////////

(
Pdef(\part, Pdef(\coolbass, 
	Ppar([
		Pbind(
			//\out, BusDef(\sendbus1),
			\amp, 0.162,
		) <>
		Pseq([
//( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  //'amp': 0.1, 'freq': 124, 'fmf': 104 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 49, 'fmf': 98 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 113, 'fmf': 41 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 112, 'fmf': 61 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 55, 'fmf': 122 ),

		],inf),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\coolbass2, 
	Ppar([
		Pbind(
			//\out, BusDef(\sendbus1),
			\amp, 0.162,
			\instrument, \sunfm2,
			\amp, 0.091,
		) <>
		Pseq([
//( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  //'amp': 0.1, 'freq': 124, 'fmf': 104 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 49, 'fmf': 98 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 113, 'fmf': 41 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 112, 'fmf': 61 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 55, 'fmf': 122 ),

		],inf),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\coolbass),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vbreaks/Funk Brothers - Home Cookin.wav'),
			\legato, 1,
			\st, 110/2/60,
			\speed, 1/Pstep(Pseq([
				1
			],inf),1/8) * ~t / Pkey(\st),
			\pos, Pseq([

				Pseg(Pseq([
					0, 2,
				],1),2),
				Pseg(Pseq([
					0, 2,
				]+4,1),2),
				Pseg(Pseq([
					0, 2,
				],1),2),
				Pseg(Pseq([
					0, 2,
				]+8,1),2),
			],inf) / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, PdurStutter(Pseq([
				Pser([
					8,
				],8*4),
			],inf), 1),
			\isRest, Pstep(Pseq([
				//1,0.2,0.2,0.2,
				1,
			],inf),1/8).coin.not,
			\gain, 1/8,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_rlpfrhpf,
			\lpf, 7301.0,
			\lrq, 1.0,
			\hpf, 2301.0,
			\hrq, 1.0,
			\mix, 1.0,
			\gain, 1.0,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),

	])
)).play;
);

(
Pdef(\part, Pdef(\suncbase1, 
	Ppar([
		
		Pdef(\coolbass),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vbreaks/Funk Brothers - Home Cookin.wav'),
			\legato, 1,
			\st, 110/2/60,
			\speed, 1/Pstep(Pseq([
				1
			],inf),1/8) * ~t / Pkey(\st),
			\pos, Pseq([

					Pseg(Pseq([
						0, 2,
					],1),2),
					Pseg(Pseq([
						0, 2,
					]+4,1),2),
					Pseg(Pseq([
						0, 2,
					],1),2),
					Pseg(Pseq([
						0, 2,
					]+8,1),2),

					Pseg(Pseq([
						0, 2,
					],1),2),
					Pseg(Pseq([
						0, 2,
					]+8,1),2),

					Pseg(Pseq([
						0, 2,
					]+2,1),2),
					Pseg(Pseq([
						0, 2,
					]+4,1),2),

					Pseg(Pseq([
						0, 2,
					],1),2),
					Pseg(Pseq([
						0, 2,
					],1),2),

					Pseg(Pseq([
						0, 2,
					],1),2),
					Pseg(Pseq([
						0, 2,
					]+8,1),2),

			],inf) / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, PdurStutter(Pseq([
				Pser([
					8,
				],8*4),
			],inf), 1),
			\isRest, Pstep(Pseq([
				//1,0.2,0.2,0.2,
				1,
			],inf),1/8).coin.not,
			\gain, 1/8,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_rlpfrhpf,
			\lpf, 7301.0,
			\lpf, ~pmodenv.(Pseq([10000,7000,5000],8), 8).loop,
			\lrq, 1.0,
			\hpf, 4301.0,
			\hpf, ~pmodenv.(Pseq([4101,2002,100],8), 14).loop,
			\hrq, ~pmodenv.(Pseq([0.5,0.1,0.2,1],8), 8).loop,
			\mix, 1.0,
			\gain, 1.0,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),

	])
)).play;
);


(
Pdef(\part, Pdef(\suncdrums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[190].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[190].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,1,1,0, 0,1,0,1,
				0,0,0,1, 0,0,1,0,
				0,1,0,1, 0,1,1,0,
				0,0,0,0, 0,0,0,0,
		
				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,1,0,1,
				0,0,0,1, 0,1,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 0.2,
			\gain, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1931].value,
			\bufnum, ~buflib.snare[1846].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\legato, Pseq([
				0.81,1.5
			],inf).stutter(16),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1931].value,
			\bufnum, ~buflib.snare[1846].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\legato, Pseq([
				0.4,0.4,Prand([0.2,0.4,2],1),0.4,
			],inf).stutter(16),
			\isRest, Pseq([
				0,0,1,0, 0,1,0,1,
				0,1,0,0, 1,0,0,1,
				0,0,1,0, 1,0,0,1,
				0,0,1,1, 0,0,1,1,
		
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[733].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1/2,1,1/2,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 4,1,1/2,1,
			],inf) * 0.8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 1,1,0,0,
				1,1,0,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
		
				1,0,0,1, 0,1,1,0,
				1,0,0,0, 1,1,0,0,
				1,0,0,1, 1,0,1,1,
				0,1,1,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1128].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,0,1, 1,1,0,1,
				0,0,0,1, 1,1,1,1,
				1,1,0,1, 0,1,1,1,
				0,1,0,1, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2 * Pseq([
				1,1,1,1, 1,1,1/2,1/2,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1555].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
				1,0,0,1, 1,0,1,0,
				1,0,0,0, 1,1,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,1,1,
				1,0,0,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11 * Pseq([
				1,1/2, 
			],inf).stutter(2),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\suncdrums2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[190].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[190].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,1,1,0, 0,1,0,1,
				0,0,0,1, 0,0,1,0,
				0,1,0,1, 0,1,1,0,
				0,0,0,0, 0,0,0,0,
		
				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,1,0,1,
				0,0,0,1, 0,1,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 0.2,
			\gain, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1931].value,
			\bufnum, ~buflib.snare[1846].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\legato, Pseq([
				0.81,1.5
			],inf).stutter(16),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1931].value,
			\bufnum, ~buflib.snare[1846].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\legato, Pseq([
				0.4,0.4,Prand([0.2,0.4,2],1),0.4,
			],inf).stutter(16),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				Pseq([
					0,0,1,0, 0,1,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 1,0,0,1,
					0,0,0,0, 0,0,0,0,
				],inf),

				0,0,1,0, 0,1,0,1,
				0,1,0,0, 1,0,0,1,
				0,0,1,0, 1,0,0,1,
				0,0,1,1, 0,0,1,1,
		
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[733].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1/2,1,1/2,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 4,1,1/2,1,
			],inf) * 0.8,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],4),

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				1,0,0,0, 1,1,0,0,
				1,1,0,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
		
				1,0,0,1, 0,1,1,0,
				1,0,0,0, 1,1,0,0,
				1,0,0,1, 1,0,1,1,
				0,1,1,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1128].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					1,0,1,0, 1,0,1,0,
					0,0,0.2,0, 0.71,0,1,0,
				],4),

				1,1,0,1, 1,1,0,1,
				0,0,0,1, 1,1,1,1,
				1,1,0,1, 0,1,1,1,
				0,1,0,1, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2 * Pseq([
				1,1,1,1, 1,1,1/2,1/2,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1555].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
				1,0,0,1, 1,0,1,0,
				1,0,0,0, 1,1,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,1,1,
				1,0,0,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11 * Pseq([
				1,1/2, 
			],inf).stutter(2),
		),
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\suncblock1, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('loop/pigs.flac'),
			//\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			//\st, 272/8/60,
			\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\st, 272/2/60,
			\gain, 0.1,
			\speed, 2/Pstep(Pseq([
				1,0.7,1.2,1.2, 1,1,1,1,
			],inf),1/2) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseq([
					0,2,2,0, 9,9,0,9,
					12,14,15,4, 13,9,4,2,
					0,2,2,0, 9,9,0,9,
					4,13,12,4, 10,9,4,2,

					0,2,2,0, 9,9,0,9,
					12,14,15,4, 13,9,4,2,
					0,2,2,0, 9,9,0,9,
					12,13,14,4, 10,9,4,2,
					//8,9,10,11,
					//(0..7),
					//(0..3), (0..3),
					//(0..3)+4, (0..3)+4,
					//4,12,12,4,2,2,4,2,
				].flat/4,inf),
			],inf) / Pkey(\st),
			\dur, PdurStutter(Pseq([1,4, 4,4, 4,2,4,1, ],inf), 1/2),
			\dur, 1/8,
			\gain, 0.1* Pstep(Pseq([
				1,1,1,1, 1,1,1,1,
				//1,0.91,1,0.91, 1,0.91,0.91,1,
			],inf),1/8),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0.91,1,0.91, 1,0.91,0.91,1,
			],inf).coin.not,
			//\legato, Pseq([1,0.5,0.7,1],inf),
			//\dur, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[733].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1/2,1,1/2,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 4,1,1/2,1,
			],inf) * 0.8,
			\speed, ~pmodenv.(Pseq([1,1.32],1), 31).loop,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],6),
				Pseq([
					1,0.2,1,0.2, 1,0.2,1,0.2,
				],2),

			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseg(Pseq([0.01,1,1,1,1],inf),8),
		),
		Pbind(
			\instrument, \sawvlip,
			//\degree, Pseq([
			//0+7,2,4-7,9,
			//0,12,2,14,	
			//],inf).stutter(8),
			\freq, Pseq([
				14, 17,
			],inf).stutter(1) * 112 + [0,123] *.x [1/2,1,2] * Pseq([1,2],inf).stutter(8*8*2),
			\fmamp, 0.4,

			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0.1,0,0.1,
				8,0,0,0, 0,0,0,0,
			],inf),
			\rlpf, ~pmodenv.(Pseq([1001,7000,100],1).stutter(2) + Pseq([0,1300]), 8).loop,
			\rq, 0.1,
			\adsr, Pseq([
				Pfunc({ arg ev;
					[ Env.adsr(0.1,0.7,0.4,ev) ]
				}) <> Pseq([
					0.1,1,6,12,3.3,
				],inf),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1 * Pseg(Pseq([0.7,1,0.3,0.9,1],inf),9),
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_fatecho,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \oscsampler3,
			\pos, 1.208,
			\pos, 1.808,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.03101,0].integrate.postln,[0.41,8.1]) ],
			],inf),
			\finepos, 1/400 * Pseq([1,4,2,2],inf),
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
			],inf),
			\levelScale, Pseq([
				1,1,1,1, 1,2,0.73,1/2,
			],inf).stutter(2),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\fshift, 40,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 0,
			\hpfreq, 100,
			\amp, 0.1/3,
			\bufnum, BufDef.stereo('voices/feynman.flac'),

		),
	])
)).play;
);


(
SynthDef(\sawvlip, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,0.002,0.3],[0.1,0.8]), 1);
	sig = LFSaw.ar(freq * SinOsc.ar((1..8)/10 * \fmfr.kr(1), mul:\fmamp.kr(2.001) * env1, add:1));
	sig = RLPF.ar(sig, ( \lpf.kr(1000.1) ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part2, Pdef(\suncblock2, 
	Ppar([

		Pbind(
			\instrument, \sawvlip,
			//\degree, Pseq([
			//0+7,2,4-7,9,
			//0,12,2,14,	
			//],inf).stutter(8),
			\freq, Pseq([
				14, 17,
			],inf).stutter(1) * 112 + [0,123] *.x [1/2,1,2] * Pseq([1,2],inf).stutter(8*8*2),
			\fmamp, 0.4,

			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0.1,0,0.1,
				8,0,0,0, 0,0,0,0,
			],inf),
			\rlpf, ~pmodenv.(Pseq([1001,7000,100],1).stutter(2) + Pseq([0,1300]), 8).loop,
			\rq, 0.1,
			\adsr, Pseq([
				Pfunc({ arg ev;
					[ Env.adsr(0.1,0.7,0.4,ev) ]
				}) <> Pseq([
					0.1,1,6,12,3.3,
				],inf),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1 * Pseg(Pseq([0.7,1,0.3,0.9,1],inf),9),
			\out, BusDef(\bfx1, \audio),
		),
		Pmono(\fx_fatecho,
			\inbus, BusDef(\bfx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \oscsampler3,
			\pos, 1.208,
			\pos, 1.808,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.03101,0].integrate.postln,[0.41,8.1]) ],
			],inf),
			\finepos, 1/400 * Pseq([1,4,2,2],inf),
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
			],inf),
			\levelScale, Pseq([
				1,1,1,1, 1,2,0.73,1/2,
			],inf).stutter(2),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\fshift, 40,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 0,
			\hpfreq, 100,
			\amp, 0.1/3 * Pseg(Pseq([0.01,0.1,1,0.5,0.2,0.7],inf),8),
			\bufnum, BufDef.stereo('voices/feynman.flac'),

		),
	])
)).play;
);

(
Pdef(\part3, Pdef(\suncblock2b, 
	Ptpar([
		
		8,Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('loop/pigs.flac'),
			//\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			//\st, 272/8/60,
			\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\st, 272/2/60,
			\gain, 0.1,
			\speed, 2/Pstep(Pseq([
				1,0.7,1.2,1.2, 1,1,1,1,
			],inf),1/2) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseq([
					0,2,2,0, 9,9,0,9,
					12,14,15,4, 13,9,4,2,
					0,2,2,0, 9,9,0,9,
					4,13,12,4, 10,9,4,2,

					0,2,2,0, 9,9,0,9,
					12,14,15,4, 13,9,4,2,
					0,2,2,0, 9,9,0,9,
					12,13,14,4, 10,9,4,2,
					//8,9,10,11,
					//(0..7),
					//(0..3), (0..3),
					//(0..3)+4, (0..3)+4,
					//4,12,12,4,2,2,4,2,
				].flat/4,inf),
			],inf) / Pkey(\st),
			\dur, PdurStutter(Pseq([1,4, 4,4, 4,2,4,1, ],inf), 1/2),
			\dur, 1/8,
			\gain, 0.071* Pstep(Pseq([
				1,1,1,1, 1,1,1,1,
				//1,0.91,1,0.91, 1,0.91,0.91,1,
			],inf),1/8),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0.91,1,0.91, 1,0.91,0.91,1,
			],inf).coin.not,
			//\legato, Pseq([1,0.5,0.7,1],inf),
			//\dur, 1/8,
		),
		0,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[733].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1/2,1,1/2,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 4,1,1/2,1,
			],inf) * 0.8,
			\speed, ~pmodenv.(Pseq([1,1.32],1), 31).loop,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],6),
				Pseq([
					1,0.2,1,0.2, 1,0.2,1,0.2,
				],2),

			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseg(Pseq([0.01,1,1,1,1],inf),8),
		),
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Pbind(
			\instrument, \oscsampler3,
			\pos, 1.208,
			\pos, 0.808 + Pseq([0,40],inf).stutter(8*2),
			\freq, 7,
			\range, 0.0000001,
			\posenv, Pseq([
				Pseq([
					[ Env([0.00,0.03101,0].integrate.postln,[0.41,8.1]) ],
				],7),
				[ Env([0.00,0.03101/8,-0.03].integrate.postln,[0.411/8,0.4]) ],
			],inf).stutter(8*2),
			\finepos, 1/400 * Pseq([1,4,2,2],inf),
			\legato, Pseq([
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				8,0,0,0, 0,0,0,0,
			].clump(16).scramble.collect({ arg x; Pseq(x,[2,3,4,5].choose) }),inf),
			\timeScale, 4,
			\levelScale, Pseq([
				1,1,1,1, 1,2,0.73,1/2,
			],inf).stutter(2),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.3,0.3,0.4,0.1) ],
			],inf),
			\dur, 1/8,
			\fshift, 40,
			\lpmix, 1,
			\ffreq, ~pmodenv.(Pseq([1000,700,101,8200,50],1), 13).loop,
			\rq, 0.2,
			\hpmix, 0,
			\hpfreq, 100,
			\amp, 0.1/3,
			\bufnum, BufDef.stereo('voices/feynman.flac'),

		),
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\suncbli1, 
	Ppar([
		Pbind(
			\instrument, \oscsampler3,
			\pos, 1.208,
			\pos, 0.808,
			\freq, 487,
			\range, 0.000001 * Pseq([
				50,1000,1,100,0.1,10,
			],inf).stutter(8*8*4),
			\posenv, Pseq([
				[ Env([0.00,0.07101,0].integrate.postln,[0.41,8.1]) ],
				[ Env([0.00,0.03101,0].integrate.postln,[0.41,8.1]) ],
				[ Env([0.00,0.00101,0].integrate.postln,[0.41,8.1]) ],
				[ Env([0.00,0.03101,0].integrate.postln,[0.41,8.1]) ],
			],inf),
			\finepos, 1/400 * Pseq([1,4,2,2],inf),
			\legato, Pseq([
				1,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
			],inf),
			\timeScale, 2,
			\levelScale, Pseq([
				1,1,1,1, 1,2,0.73,1/2,
			],inf).stutter(2),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.4,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\fshift, 40,
			\ffreq, ~pmodenv.(Pseq([1000,7000,101],1), 12).loop,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 0,
			\hpfreq, 100,
			\amp, 0.1/3,
			\bufnum, BufDef.stereo('voices/feynman.flac'),

		),
		
	])
)).play;
);


//////////////////////////////////

/// main seq

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pfindur(16,Pdef(\coolbass)),
			Pfindur(64*2-4, Ppar([
				Pdef(\suncbase1),
				Pseq([
					Event.silent(8),
					Pfindur(16,Pdef(\suncdrums2)),
					Pfindur(16,Pdef(\suncdrums1)),
					Event.silent(8),
					Ptpar([
						0, Pfindur(32+16,Pdef(\suncblock2)),
						16, Pfindur(32+16,Pdef(\suncblock2b)),
					])
				],1),
			])),
			Pfindur(16,Pdef(\suncbreak1)),
			Pfindur(64,Ppar([
				Pdef(\suncbase1),
				Pdef(\suncblock1),
			])),
			Pfindur(16,Pdef(\coolbass)),
			
		],1),
		
	])
)).play;
);


//////////////


(
Pdef(\part, Pdef(\suncbreak1, 
	Ppar([
		Pbind(
			\instrument, \oscsampler3,
			\pos, 1.208,
			\pos, 1.808,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.03101,1.7].integrate.postln,[0.41,8.1]) ],
			],inf),
			\finepos, 1/400 * Pseq([1,4,2,2],inf),
			\legato, Pseq([
				6,0,0,0, 6,0,0,0,
			],inf),
			\timeScale, ~pmodenv.(Pseq([1,1.2,2],1), 12).loop,
			\levelScale, Pseq([
				1,1,1,1, 
			],inf).stutter(2),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\fshift, 40,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 0,
			\hpfreq, 100,
			\amp, 0.1/3,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\out, BusDef(\ifx2, \audio),
		),
		Pmono(\fx_fatecho,
			\inbus, BusDef(\ifx2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vbreaks/Funk Brothers - Home Cookin.wav'),
			\legato, 1,
			\st, 110/2/60,
			\speed, 1/Pstep(Pseq([
				1
			],inf),1/8) * ~t / Pkey(\st),
			\pos, Pseq([

					Pseg(Pseq([
						0, 2,
					],1),2),
					Pseg(Pseq([
						0, 2,
					]+4,1),2),
					Pseg(Pseq([
						0, 2,
					],1),2),
					Pseg(Pseq([
						0, 2,
					]+8,1),2),

					Pseg(Pseq([
						0, 2,
					],1),2),
					Pseg(Pseq([
						0, 2,
					]+8,1),2),

					Pseg(Pseq([
						0, 2,
					]+2,1),2),
					Pseg(Pseq([
						0, 2,
					]+4,1),2),

					Pseg(Pseq([
						0, 2,
					],1),2),
					Pseg(Pseq([
						0, 2,
					],1),2),

					Pseg(Pseq([
						0, 2,
					],1),2),
					Pseg(Pseq([
						0, 2,
					]+8,1),2),

			],inf) / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, PdurStutter(Pseq([
				Pser([
					8,
				],8*4),
			],inf), 1),
			\isRest, Pstep(Pseq([
				//1,0.2,0.2,0.2,
				1,1,1,1, 1,1,1,0.91,
				1,1,0.91,1, 1,1,1,1,
				1,1,1,0.9, 1,0.91,1,1,
				1,1,1,1, 1,0,0,0,
			],inf),1/8).coin.not,
			\gain, 1/8,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_rlpfrhpf,
			\lpf, 7301.0,
			\lpf, ~pmodenv.(Pseq([10000,7000,5000],8), 8).loop,
			\lrq, 1.0,
			\hpf, 4301.0,
			\hpf, ~pmodenv.(Pseq([4101,2002,100],8), 14).loop,
			\hrq, ~pmodenv.(Pseq([0.5,0.1,0.2,1],8), 8).loop,
			\mix, 1.0,
			\gain, 1.0,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);



(
	ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\amp, 0.162,
			\instrument, \sunfm,
			\amp, 0.091,
			\out, BusDef(\sendbus1, \audio),
		) <>
		Pseq([
			//( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
			  //'amp': 0.1, 'freq': 124, 'fmf': 104 ),
			( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
			  'amp': 0.1, 'freq': 49, 'fmf': 98 ),
			( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
			  'amp': 0.1, 'freq': 113, 'fmf': 41 ),
			( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
			  'amp': 0.1, 'freq': 112, 'fmf': 61 ),
			( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
			  'amp': 0.1, 'freq': 55, 'fmf': 122 ),

		],inf),
			
		Prout({ arg ev;
			4.do { arg item, idx;
					"bla-1".debug;
				SystemClock.sched(s.latency, {
					"bla".debug;
					ProtoDef(\rdn).proxy.set(\delay, Ndef(\rdn_lfo1, { XLine.kr(0.04,1,16/~t).poll }).asMap);
					//nil;
				});
					"bla2".debug;
				16.wait;
					"bla3".debug;
			};
			nil;
		}),
	])
)).play;
);

(
Ndef(\rdn).put(100, \pset -> Pbind(
	\delay, ~pmodenv.(Pseq([0.041,1],1), 16).loop,
));
)
Ndef(\rdn).put(100, nil)
ProtoDef(\rdn).proxy.set(\delay, Ndef(\lfo1, { XLine.kr(0.04,1,16/~t).poll }).asMap)
ProtoDef(\rdn).proxy.set(\delay, Ndef(\lfo1, { XLine.kr(0.04,1,16/~t).poll }))


(
Tempo.bpm_(120*2);
d = Routine({
	"wait for the downbeat...".postln;
	OSCSched.global.tdeltaTillNext(4.0).wait;

	  32.do({ arg i;
		   [i,BeatSched.beat, BeatSched.time].postln;
		   Tempo.beats2secs(1.0).wait;
	  });
 });
SystemClock.play(d);
)

BeatSched.tempo
