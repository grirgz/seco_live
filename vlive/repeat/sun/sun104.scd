
// venjent dnb study

~t = 174/2/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1336].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[1621].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1110].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.03,
		),
		Pbind(
			\instrument, \bigbass,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\legato, 1,
			\dur, Pseq([6,Rest(2)],inf),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('projrec/sun103/velo.flac'),
			\pos, 0,
			\legato, 1,
			\dur, Pseq([6,Rest(2)],inf),
			\gain, 1,
		),
		Pbind(
			\instrument, \bigbass2,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\dur, Pseq([Rest(6),2],inf),
			\amp, 0.1,
		),

	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1336].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,0,
				1,0,0,1, 1,0,0,0, 0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[1621].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,0, 0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1110].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.03,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('projrec/sun103/velo.flac'),
			\pos, 0,
			\legato, 1,
			\dur, Pseq([6,Rest(2)],inf),
			\gain, 1,
		),
		Pbind(
			\instrument, \bigbass,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\legato, 1,
			\dur, Pseq([6,Rest(2)],inf),
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \bigbass2,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\legato, 1,
			\dur, Pseq([Rest(5),2,Rest(1)],inf),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \formbass_o,
			\note, Pseq([
				4,
			],inf),
			\legato, 1,
			\octave, 3,
			\bwfreq, 900,
			\dur, Pseq([Rest(7),1],inf),
			\amp, 0.1,
		),

	])
)).play;
);


(
SynthDef(\bigbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 5;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1.52,1,1.1],[1.1,0.8,3]), 1);
	env1 = Duty.kr(1/4/~t, 0, Dseq([
		0,0,2,0,0,0,0,12,4,
		0,2,0,2,0,0,
	].midiratio,inf)).lag(1/4/~t);
	sig = LFSaw.ar(freq * env1 * ( LFSaw.ar(freq/2.01) * 1 + 1 ) * ( LFNoise1.kr(0.1!num) * 0.01 + 1 ));
	sig = sig + SinOsc.ar(freq * env1 * ( LFSaw.ar(freq*1.01) * 0.41 + 1 )); 
	sig = RLPF.ar(sig, \lpf.kr(5000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bigbass2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 5;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1.2,1],[0.1,0.8]), 1);
	sig = LFSaw.ar(freq * env1 * ( LFSaw.ar(freq*2.01) * 1 + 1 ) * ( LFNoise1.kr(0.1!num) * 0.01 + 1 ));
	sig = sig + SinOsc.ar(freq * env1 * ( LFSaw.ar(freq*1.01) * 0.41 + 1 )); 
	sig = RLPF.ar(sig, \lpf.kr(7000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\formbass_o, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = Formant.ar(freq/2, 70, 1000);
	sig = sig + Formant.ar(freq, 500, \bwfreq.kr(220));
	sig = sig + Formant.ar(freq, 1000, \bwfreq.kr);
	sig = sig + LFCub.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.02) + 1)).mean;
	sig = LPF.ar(sig, 1000);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\formbass_u, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = Formant.ar(freq, 320, \bwfreq.kr(220));
	sig = sig + Formant.ar(freq, 800, \bwfreq.kr);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\formbass_i, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = Formant.ar(freq, 1400/2, \bwfreq.kr(220));
	sig = sig + Formant.ar(freq, 1000/2, \bwfreq.kr);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\formbass_a, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = Formant.ar(freq, Vowel.formLib.at(\a,\bass,\freq)).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
Pdef(\formbass).edit
Vowel.formLib.at(\a,\bass,\freq)
Vowel.formLib.at(\a,\bass)
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \formbass_a,
			\note, Pseq([
				0,4,
			],inf),
			\octave, 2,
			\
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\formbass, 
			Pbind(
				\instrument, \formbass_i,
				\note, Pseq([
					0,4,
				],inf),
				\octave, 3,
				\dur, 4,
				\amp, 0.1,
			),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\formbass, 
			Pbind(
				\instrument, \formbass_u,
				\note, Pseq([
					0,4,
				],inf),
				\octave, 3,
				\dur, 4,
				\amp, 0.1,
			),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \formbass_o,
			\note, Pseq([
				0,4,
			],inf),
			\octave, 2,
			\bwfreq, 900,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);

v = Vowel()

		v.addFormants([3000,4000], -6, [200, 200])

		

		{Formants.ar(100, v) * 0.01 ! 2 }.play

		{Formants.ar(100, Vowel(\i, \tenor)) * 0.1}.play

				

		{[Formants.ar(100, Vowel()) * 0.1, Formants.ar(100, v) * 0.1 ]}.play

		

		v.removeFormants([5,6])

////////////////////

(
SynthDef(\velobass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num = 5;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\freqenv.kr(Env([1,1,1],[0.1,0.8]), 1));
	sig = SinOsc.ar(freq * env1 * \freqmod.kr(1) * ( LFSaw.ar(freq/2) * 1 + 1 ) * ( LFNoise1.kr(0.1!num) * 0.001 + 1 ));
	sig1 = LFSaw.ar(freq * env1 * \freqmod.kr(1) * ( LFSaw.ar(freq/2) * 1 + 1 ) * ( LFNoise1.kr(0.1!num) * 0.001 + 1 ));
	sig = SelectX.ar(\sawmix.kr(0.5), [sig, sig1]);
	sig = sig + SinOsc.ar(freq * env1 * ( LFSaw.ar(freq*1) * 0.41 + 1 )); 
	sig = RLPF.ar(sig, \lpf.kr(7000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pfindur(8,Pbind(
			\instrument, \velobass,
			\note, Pseq([
				3,6,3
			],inf),
			\freqmod, Pseq([
				PmodEnv(Pseq([1,1,0.5],1), 1.99),
				1,
				1,
				1,
			],1),
			\octave, 3,
			\legato, 1,
			\dur, Pseq([4.5,1/2,1/2,Rest(3/2)],inf),
			\amp, 0.1,
		)).loop,
	])
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \formbass_o,
			\note, Pseq([ 6,8-12 ]),
			\octave, 3,
			\legato, 1,
			\bwfreq, Pseq([
				220,600,
			],1),
			\dur, Pn(1,2),
			\gain, 1/9,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1336].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[1621].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1110].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.03,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\sec1, 
	Ppar([
		Pmono(
			\playersec,
			\bufnum, BufDef('projrec/sun103/velo.flac'),
			\pos, 0,
			\legato, 1,
			\dur, Pseq([8],1),
			\gain, 0.1,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\sec2, 
	Ppar([

		Pfindur(16,Pdef(\drums_rise)),
		Pmono(
			\playersec,
			\bufnum, BufDef('projrec/sun103/velo.flac'),
			\pos, 0,
			\legato, 1,
			\dur, Pseq([8],1),
			\gain, 0.1,
		),
		Ptpar([
			6.4, Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('projrec/sun103/break.flac'),
				\pos, 0,
				\legato, 1,
				\dur, Pn(1,1),
				\gain, 1/9,
			)
		]),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\sec3, 
	Ppar([
		Pfindur(16,Pdef(\drums1)),
		Pmono(
			\playersec,
			\bufnum, BufDef('projrec/sun103/velo.flac'),
			\pos, 0,
			\legato, 1,
			\dur, Pseq([8],1),
			\gain, 0.1,
		),
		Pfindur(8,Pbind(
			\instrument, \velobass,
			\note, Pseq([
				3,1
			],inf),
			\freqenv, Pseq([
				[ Env([1,1,0.9],[3.1,3.8]) ],
				[ Env([1,3.midiratio,1],[0.2,0.5]) ],
			],inf),
			\octave, 3,
			\legato, 1,
			\dur, Pseq([4,2.5,Rest(3/2)],inf),
			\amp, 0.1/2,
		)),
		Ptpar([
			6.5, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('projrec/sun103/break.flac'),
					\pos, 0,
					\legato, 1,
					\dur, Pn(1.5,1),
					\gain, 1/9,
					\out, BusDef(\ifx1, \audio),
				),
				Pbind(
					\instrument, \formbass_o,
					\note, 6,
					\octave, 3,
					\legato, 1,
					\dur, Pn(1.5,1),
					\gain, 1/9,
				),
				Pmono(\fx_echo,
					\inbus, BusDef(\ifx1, \audio),
					\addAction, \addToTail,
					\delay, 1/2/~t,
					\decay, 5,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,0.8,5.1) ],
					],inf),
					\mix, Pseq([0,Pn(1,inf)],inf),
					\lag, 0.0009,
					\dur, 1,
				),
			]),
		]),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\sec4, 
	Ppar([
		Pfindur(16,Pdef(\drums1)),
		Pmono(
			\playersec,
			\bufnum, BufDef('projrec/sun103/velo.flac'),
			\pos, 0,
			\legato, 1,
			\dur, Pseq([8],1),
			\gain, 0.1,
		),
		Pfindur(8,Pbind(
			\instrument, \velobass,
			\note, Pseq([
				3,1
			],inf),
			\freqenv, Pseq([
				[ Env([1,1,0.9],[3.1,3.8]) ],
				[ Env([1,3.midiratio,1],[0.2,0.5]) ],
			],inf),
			\octave, 3,
			\legato, 1,
			\dur, Pseq([3,1.7,Rest(3/2)],1),
			\amp, 0.1/2,
		)),
		Ptpar([
			4.75, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('projrec/sun103/break.flac'),
					\pos, Pseq([
						1,0,2,
					],1)/4,
					\legato, 1,
					\dur, Pn(0.5,3),
					\gain, 1/9,
				),
				Pbind(
					\instrument, \formbass_o,
					\note, 6,
					\octave, 3,
					\legato, 1,
					\dur, Pn(1.75,1),
					\gain, 1/9,
				),
				Pmono(\fx_echo,
					\inbus, BusDef(\ifx1, \audio),
					\addAction, \addToTail,
					\delay, 1/2/~t,
					\decay, 5,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,0.8,5.1) ],
					],inf),
					\mix, Pseq([0,Pn(1,inf)],inf),
					\lag, 0.0009,
					\dur, 1,
				),
			]),
			6.5, Ppar([
				
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('projrec/sun103/break.flac'),
					\pos, 0,
					\legato, 1,
					\dur, Pn(1.5,1),
					\gain, 1/9,
					//\out, BusDef(\ifx1, \audio),
				),
				Pbind(
					\instrument, \formbass_o,
					\note, 8-12,
					\bwfreq, Pseq([
						600,
					],1),
					\octave, 3,
					\legato, 0.91,
					\dur, Pn(1.5,1),
					\gain, 1/1,
				),
			]),
		]),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pfindur(8,Pdef(\sec1)),
			Pfindur(8,Pdef(\sec2)),
			Pfindur(8,Pdef(\sec3)),
			Pfindur(8,Pdef(\sec4)),
			Pfindur(8,Pdef(\sec3)),
			//Pfindur(8,Pdef(\sec4)),
			//Pfindur(8,Pdef(\sec4)),
			//Pfindur(8,Pdef(\sec4)),
			//Pfindur(8,Pdef(\sec3)),
		],1),
	])
)).play;
);

(
Pdef(\part, Pdef(\drums_rise, 
	Ppar([


		Pbind(\out, BusDef(\drumlpf, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1336].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0, 1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0, 1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0, 1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('projrec/sun103/velo.flac'),
				\pos, 4.67,
				\legato, 1,
				\sustain, 0.2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 1/4,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[1719].value,
				\bufnum, ~buflib.snare[1621].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1110].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,0, 1,0,1,0, 1,0,1,0,
					0,0,1,0, 0,0,0,0, 1,0,1,0, 1,0,1,0,
					0,0,1,0, 0,0,0,0, 1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\speed, 1,
				\dur, 1/8,
				\gain, 0.09,
			),
		]),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\drumlpf, \audio),
			\addAction, \addToTail,
			\lpf, PmodEnv(Pseq([100,4000],1), 8).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\drums_rise, 
	Ppar([


		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('projrec/sun103/velo.flac'),
			\pos, 4.68,
			\legato, 1,
			\sustain, 0.5,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/4,
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lpf, PmodEnv(Pseq([100,14000],1), 8).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);


////////////// drums study


~t = 174/4/60; TempoClock.default.tempo = ~t;
(
Pdef(\part, Pdef(\drumsec1, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1336].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[1621].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1, 0,1,1,0, 0,1,0,1,
				0,0,0,0, 1,0,0,1, 0,1,1,0, 0,1,0,1,
				0,0,0,0, 1,0,0,1, 0,1,1,0, 0,1,0,1,
				1,0,0,1, 1,0,0,1, 0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1110].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0, 1,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,1,0, 1,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,1,0, 1,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.03,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\drumsec2, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1336].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[1621].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1, 0,1,1,0, 0,1,0,1,
				0,0,0,0, 1,0,0,1, 0,1,1,0, 0,1,0,1,
				0,0,0,0, 1,0,0,1, 0,1,1,0, 0,1,0,1,
				1,0,0,1, 1,0,0,1, 1,0,1,1, 0,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1110].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0, 1,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,1,0, 1,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,1,0, 1,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
	])
)).play;
);
Pdef(\drums1).play
(
Pdef(\part, Pdef(\drumsec3, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1336].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[1621].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1, 0,1,1,0, 0,1,0,1,
				0,0,0,0, 1,0,0,1, 0,1,1,0, 0,1,0,1,
				0,0,0,0, 1,0,0,1, 0,1,1,0, 0,1,0,1,
				1,0,0,1, 1,1,0,1, 1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1110].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0, 1,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,1,0, 1,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,1,0, 1,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\drumsec4, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1336].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[1621].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1, 0,1,1,0, 0,1,0,1,
				0,0,0,0, 1,0,0,1, 0,1,1,0, 0,1,0,1,
				0,0,0,0, 1,0,0,1, 0,1,1,0, 0,1,0,1,
				1,0,0,1, 1,1,0,1, 1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1110].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0, 1,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,1,0, 1,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,1,0, 1,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
	])
)).play;
);
