
// trap bass
~t = 180/4/60; TempoClock.default.tempo = ~t;


(
SynthDef(\piercebass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\diffenv.kr(Env([0,1,1,0],[0.1,0.1,0.8])), \difftrig.tr(0));
	sig = Saw.ar(freq * [1,1+( \diff.kr(0.00001)*env1 )]).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\piercebass2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\diffenv.kr(Env([0,1,1,0],[0.1,0.1,0.8])), \difftrig.tr(0));
	env2 = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.2,0.0,0.1,-1.71)), gate, doneAction:0).poll;
	sig = Saw.ar(freq * [1,1+( \diff.kr(0.00001) )]).mean;
	sig2 = LFPulse.ar(freq / 1.midiratio * [1,1+( \diff.kr(0.00001) )]).mean;
	sig = LPF.ar(sig, ( \lpfr.kr(195.1) * ( env1 +1 ) * (env2 + 1) * freq ).clip(10,18998), \rq.kr(0.7));
	sig = sig + SinOsc.ar(freq * ( SinOsc.ar(freq * ( SinOsc.kr(1) * 0.1 + 1 )) * 1 + 1 )); 
	//sig = sig * (sig2 * env1 + 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\piercebass3, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\diffenv.kr(Env([0,1,1,0],[0.1,0.1,0.8])), \difftrig.tr(0));
	sig = Saw.ar(freq * [1,1+( \diff.kr(0.00001) )]).mean;
	sig2 = LFPulse.ar(freq / 1.midiratio * [1,1+( \diff.kr(0.00001) )]).mean;
	sig = sig * (sig2 * env1 + 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bloab, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpadsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * (env1 * \lpenvamt.kr(1) + 1), \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

ProtoDef(\piano).startControl(Pdef(\melo, Pbind(\instrument, \piercebass)))


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \piercebass,
			\octave, 3,
			\note, Pseq([
				-6,
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 \piercebass2,
			\octave, 3,
			\note, Pseq([
				Pser([
					-6,-6,-5,-6, -6,-6,-6,-6,
					-5,-5,-6,-6, -6,-6,-6,-6, 
					Pseq([
						0,
					],16),

					Pser([
						-10
					],8),
					Pser([
						-6,
					],4),
					Pseq([
						0,
					],4+16),
				],inf),
			],inf),
			\difftrig, Pseq([
				Pser([
					0
				],6),
				Pser([
					1
				],1),
				Pser([
					0
				],1),
			],inf),
			\diff, 0.00001,
			\diffenv, [ Env([0,1,2,0],[0.1,1,0.3].normalizeSum/2) ],
			\dur, 1/8,
			\amp, 0.2 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
		),
		Pbind(
			\instrument, \piercebass,
			\note, Pseq([
				Pseq([
					\rest
				],16),
				Pseq([
					Pser([
						9,\r,\r,\r, \r,\r,\r,\r,
					],8),
					4,\r,\r,\r, 3,\r,\r,\r,
				],1)+12,
				Pseq([
					\rest
				],8*4),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\legato, 0.7 * Pseq([
				8,0,0,0, 0,0,0,0,
				4,0,0,0, 4,0,0,0,
			],inf),
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1060].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1087].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2329].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \bloab,
			\lpfr, Pseq([
				~pmodenv.(Pseq([1/2,1,0.7,1],1).trace, 1/4/~t).loop,
			],1),
			\octave, 4,
			\note, Pseq([
				Pseq([\r], 8*6),
				1,\r, 4,\r, 6,\r, 1,4,
				\r,6,\r,7,  Pseq([\r],4)
			],inf),
			\dur, Pseq([1/8],inf),
			\amp, 0.1,
		),
		
	])
)).play;
);




(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bloab,
			\lpfr, Pseq([
				~pmodenv.(Pseq([1/2,1,0.7,1],1).trace, 1/4/~t).loop,
			],1),
			\octave, 4,
			\note, Pseq([
				1,\r, 4,\r, 6,\r, 1,4,
				\r,6,\r,7,  Pseq([\r],4)
			],inf),
			\dur, Pseq([1/8],inf),
			\amp, 0.1,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\note, Pseq([
				Plazy({ arg ev;
					Pseq(12.collect { arg idx;
						Pseq([
							0,idx,
						],inf) + Pseq((1..4),inf).stutter(2) - Pseq((1..6).mirror,1).stutter(8);
					})
				}).loop,
			],inf),
			\dur, 1/64,
			\amp, 0.1/2,
		),
		
	])
)).play;
);

///////////

(
SynthDef(\fakeRes, {
	arg  out = 0, freq = 200, peamount = 900,
	pitchAtt = 0.001, pitchDec = 0.13,
	ampAtt = 0.03, ampDec = 1.0, level = 0.5;

	var sig, sig1, sig2, ampenv, pitchenv, sig2Phase;

	pitchenv = EnvGen.ar(
		// Env([0, 1, 0], [pitchAtt, pitchDec], [0, 0]),  // original
		Env([0, 1, 0], [pitchAtt, pitchDec],  \squared),
		// Env([0, 1, 0], [pitchAtt, pitchDec],  \cubed),
		// doneAction:2      // removed
	);

	ampenv = EnvGen.ar(
		Env([0, 1, 0], [ampAtt, ampDec], [0, 0]),
		levelScale: level,
		doneAction:2,
	);

	sig1 = SinOsc.ar(
		freq,
		mul:-0.53,
		add:0.5
	);

	sig2Phase = Sweep.ar(sig1, (freq + (pitchenv * peamount)));

	sig2 = SinOsc.ar(
		freq + (pitchenv * peamount),
		phase: 2pi * sig2Phase
	);

	// sig = (sig1 * sig2)**2;  // orig
	// sig = (sig1 * sig2).pow(2);  // same sound as orig
	sig = (sig1 * sig2).squared;  // sounds different

	//sig = OnePole.ar(sig, -0.22); // added
	sig = WhiteNoise.ar;
	sig = OnePole.ar(sig, MouseX.kr(-1,1)); // added
	sig = sig * ampenv ! 2;
	Out.ar(0, sig);
}).add;
)

// play note
Synth(\fakeRes);  

// play pattern
(
~notePatt = Pbind(*[
	\instrument: \fakeRes,
	\degree, Pxrand([0, 2, 4, 8, 9, 10, 12, 16], 32),
	\scale, Scale.minor,
	\octave, 3,
	\peamount: Pwhite(200, 900, 32),
	\pitchAtt: 0.001,
	\pitchDec: Pwhite(0.3, 0.7, 32),
	\ampAtt: 0.001,
	\ampDec: Pwhite(0.5, 2, 32),
	\level: Pseq([0.9, 0.7, 0.6, 0.9, 0.5, 0.6, 0.9, 0.6, 0.8, 1, ], 2),
	\legato: 0.8,
	\dur: Prand([0.5, 0.75, 1], 32),
]).loop;
p = ~notePatt.play;
)

p.stop;


///////////

(
SynthDef(\resultat, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	sig = SinOsc.ar(freq * env1 * ( SinOsc.ar(freq * [1,1.01]) * 1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\instrument, \resultat,
			\freq, 
			Pseq([
				Pseries(70,120,64),
				Prand((70,70.1..120)*2,64),
			],inf),
			\legato, 1,
			\dur, 1/16,
			\amp, 0.1,
			\out, BusDef(\rev1, \audio),
		),
		Pbind(\instrument, \resultat,
			\freq, 
			Pseq([
				Prand((70,70.1..120)*2,64),
			],inf),
			\dur, 1/1,
			\legato, 1,
			\amp, 0.1,
			\out, BusDef(\rev1, \audio),
		),
		
		Pmono(\fx_freeverb2,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\rev1, \audio),
			\verbmix, 0.4,
			\room, 0.5,
			\damp, 0.7,
			\mix, ~pmodenv.(Pseq([0,0,1,1],1), 8).loop,
			\gain, 1,
			\dur, 2,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(1/2) * 1 + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
