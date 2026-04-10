(
FileSystemProject.load("sun/main.scd");
~t = 120/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("sndlib/mysynthdefault.scd");
FileSystemProject.load("sndlib/synthbasic.scd");
FileSystemProject.load("holis/synthdef.scd");
FileSystemProject.load("sndlib/buflib.scd");
)

(
// minimal house
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \sdkick,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],3),
				1,0,1,0, 1,0,1,1,
				Pseq([
					1,0,1,0, 1,0,1,0,
				],3),
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
		),
		Pbind(
			\instrument, \sdsnare,
			\dur, 1/8/2,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0, 
				],6),
					0,0,0,0, 1,0,0,1, 
					0,0,0,0, 1,0,0,0, 
				Pseq([
					0,0,0,0, 1,0,0,0, 
				],6),
					0,0,0,0, 1,0,0,0, 
					0,0,0,0, 0,0,0,1, 
			],inf).coin.not,
			\legato, 1,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\hpf, 100,
			\hpmix, 1,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, 2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),1).loop / Pkey(\st),
			\pos, Pseq([
				Pseq([
					4,5,6,7,
					4,1,2,6,
					4,5,6,3,
					4,1,2,6,
					
				],1)/8+ Pseq([
					Plazy({ arg ev;
						Pseq(
							8.collect { arg item, idx;

								[0,1].choose
							};
							,8
						);
					}).loop,
					
				],1),
				
			],inf) / Pkey(\st),
			\dur, 1/8/2,
			\isRest, Pseq([
				0,1,1,1,
			],inf).coin.not,
			\legato, 1,
			\gain, 1/8 * Pseq([
				Ppatlace(
					16.collect { arg item, idx;
						Pseg(Pseq([1.0.rand,1.0.rand],inf),8.0.rand)
					}
				)
				
			],inf),
		),
	])
)).play;
);

(
// minimal house
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \sdkick,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],3),
				1,0,1,0, 1,0,1,1,
				Pseq([
					1,0,1,0, 1,0,1,0,
				],3),
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
		),
		Pbind(
			\instrument, \sdsnare,
			\dur, 1/8/2,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0, 
				],6),
					0,0,0,0, 1,0,0,1, 
					0,0,0,0, 1,0,0,0, 
				Pseq([
					0,0,0,0, 1,0,0,0, 
				],6),
					0,0,0,0, 1,0,0,0, 
					0,0,0,0, 0,0,0,1, 
			],inf).coin.not,
			\legato, 1,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\hpf, 100,
			\hpmix, 1,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, 2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),1).loop / Pkey(\st),
			\pos, Pseq([
				Pseq([
					4,5,6,7,
					4,1,2,6,
					4,5,6,3,
					4,1,2,6,
					
				],1)/8+ Pseq([
					Plazy({ arg ev;
						Pseq(
							8.collect { arg item, idx;

								[0,1].choose
							};
							,8
						);
					}).loop,
					
				],1),
				
			],inf) / Pkey(\st),
			\dur, 1/8/2,
			\isRest, Pseq([
				0,1,1,1,
			],inf).coin.not,
			\legato, 1,
			\gain, 1/8 * Pseq([
				Ppatlace(
					16.collect { arg item, idx;
						Pseg(Pseq([1.0.rand,1.0.rand],inf),8.0.rand)
					}
				)
				
			],inf),
		),
		Pbind(
			\instrument, \sh101,
			\octave, 3,
			\note, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0,
				0,0,0,3,
			],inf),
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\amp, 0.1,
			\legato, 0.4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.2,0.2) ],
			],inf),
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\basstrack, \audio),
			\delay, 1/ Pseq([
				Pn(1,4),
				Pn(6,4),
				Pn(8,4),
				
			],inf)/1/~t,
			\diffmul, 0.9,
			\decay, 2/~t,
			\mix, 0.2,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);


~protordn_to_fbstring.(ProtoDef(\rdn)).editorInsert
(

SynthDef(\rdn_longverb, { arg out=0, gate=1;
	// code: 4-QFRH-8Q5F
	var si, env = ();
	var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
	var code, rdnkey;

	var sig;
	var sigin;
	var del, shi;
	var del2, shi2;
	var distamp;
	var hasFreq, afreq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var pitchlag;
	var pitchmix;
	var fb, fb1, fb2;
	var gain;
	var mix;
	var indelay;
	//"default_make_graph".debug("!!!");
	rdnkey = rdnkey ? \default;
	code = code ? "4--";
	sig = in;
	mix = \mix.kr(0.5);
	gain = \gain.kr(1);
	fb = \fb.kr(0.001);
	del = \delay.kr(0.001,0.1);
	del2 = \delay2.kr(0.001,0.1);
	shi = \shift.kr(0);
	shi2 = \shift2.kr(0);
	distamp = \distamp.kr(1);
	pitchlag = \pitchlag.kr(1/8) / TempoClock.default.tempo;
	pitchmix = \pitchmix.kr(0);

	sig = LPF.ar(sig, \prelpf.kr(17000));
	sig = HPF.ar(sig, \prehpf.kr(17));

	sig = sig + (LocalIn.ar(2) * fb);

	sig = LPF.ar(sig, \lpf.kr(17000));
	sig = HPF.ar(sig, \hpf.kr(17));
	thisThread.randSeed = 288943.0;
	si = sig;
	sig = { arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
	}.value(si, env);


	sig1 = sig.tanh * \fbdistamp.kr(1/2);
	sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

	sig = Limiter.ar(sig);

	sig1 = sig;
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	sig = SelectX.ar(pitchmix, [sig, sig1]);

	LocalOut.ar(sig);
	sig = LPF.ar(sig, \postlpf.kr(17000));
	sig = HPF.ar(sig, \posthpf.kr(17));
	sig = Limiter.ar(sig);
	sig = sig * \wetamp.kr(1);

	indelay = \indelay.kr(0);
	sigin = DelayL.ar(in, 0.2, indelay);
	sig = SelectX.ar(mix, [sigin, sig]);
	sig = sig * gain;
	//sig.debug("end sig");
	sig;


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0,1,0.001)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

		
Pbind(
	'wet10', 1.0,
	'mix', 0.7436974789916,
	'gain', 2,
	'fb', 0.0001,
	'delay', 1.0,
	'delay2', 0.47937156455582,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.4868559926042,
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
)

		
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1808].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\out, BusDef(\noise, \audio),
			\gain, 0.11,
		),
		Pmono(\rdn_longverb,
			\inbus, BusDef(\noise, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,

			'wet10', 1.0,
			'mix', 0.7436974789916,
			'gain', 2,
			'fb', 0.0001,
			'delay', 1.0,
			'delay2', 0.47937156455582,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.4868559926042,
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
		),
	])
)).play;
);

(
// more fx
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \sdkick,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],3),
				1,0,1,0, 1,0,1,1,
				Pseq([
					1,0,1,0, 1,0,1,0,
				],3),
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \sdsnare,
			\dur, 1/8/2,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0, 
				],6),
					0,0,0,0, 1,0,0,1, 
					0,0,0,0, 1,0,0,0, 
				Pseq([
					0,0,0,0, 1,0,0,0, 
				],6),
					0,0,0,0, 1,0,0,0, 
					0,0,0,0, 0,0,0,1, 
			],inf).coin.not,
			\legato, 1,
			\amp, 0.1/2,
			\out, BusDef(\mainhpf, \audio),
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\hpf, 100,
			\hpmix, 1,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, 2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),1).loop / Pkey(\st),
			\pos, Pseq([
				Pseq([
					4,5,6,7,
					4,1,2,6,
					4,5,6,3,
					4,1,2,6,
					
				],1)/8+ Pseq([
					Plazy({ arg ev;
						Pseq(
							8.collect { arg item, idx;

								[0,1].choose
							};
							,8
						);
					}).loop,
					
				],1),
				
			],inf) / Pkey(\st),
			\dur, 1/8/2,
			\isRest, Pseq([
				0,1,1,1,
			],inf).coin.not,
			\legato, 1,
			\gain, 1/8 * Pseq([
				Ppatlace(
					16.collect { arg item, idx;
						Pseg(Pseq([1.0.rand,1.0.rand],inf),8.0.rand)
					}
				)
				
			],inf),
			\out, BusDef(\mainhpf, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1381].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0,
				],7),
				0,0,1,1,
				Pseq([
					0,0,1,0,
				],7),
				0,1,1,0,
				Pseq([
					0,0,1,0,
				],7),
				0,1,0,1,
				Pseq([
					0,0,1,0,
				],4),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				Prand([0.2,0.7,0.5],4),
				0.4,0.4, 0.4,0.4,
				Prand([0.2,0.7,0.5,2],4),
				0.4,0.2, 0.4,0.4,
			],inf),
			\dur, 1/8/2,
			\gain, 0.14 * Pseq([
				Pwhite(0.5,1,2),
				Pwhite(0.9,1,1),
				Pwhite(0.5,1,1),
			],inf),
			\out, BusDef(\hat, \audio),
		),


		Pbind( // bass
			\instrument, \sh101,
			\octave, 3,
			\note, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0,
				0,0,0,3,
			],inf),
			\dur, 1/8/2,
			\isRest, Pseq([
				Pser([
					1,0,0,1, 0,0,1,0,
					0,1,0,0, 1,0,0,1,
				],15*4),
				0,0,0,0,
				Pseq([
					0,0.3,1,0.71,
				],15),
				0,0,0,0,
			],inf).coin.not,
			\amp, 0.15,
			\envamt, Pseq([
				PmodEnv(Pseq([0.1,0.2,4],1), Pseq([7,1],inf),\exp),
				PmodEnv(Pseq([0.1,0.2,4],1), Pseq([7,1],inf),\exp),
			],inf),
			\lpf, PmodEnv(Pseq([1000,200,8000],4), 5,\exp).loop,
			\legato, 0.4 * Pseg(Pseq([1,2],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.2,0.2) ],
			],inf),
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\basstrack, \audio),
			\delay, 1/ Pseq([
				Pn(1,4),
				Pn(6,4),
				Pn(8,4),
				Pseq([
					Pn(8,4),
				],inf),
			],inf)/1/~t,
			//\delay, 1/8/~t,
			//\diffmul, 0.9,
			\lpf, 1000,
			//\diffadd, PmodEnv(Pseq([0.01,0.01,0.02,0.1],1), Pseq([8,4,4]),\exp).loop,
			\diffadd, 0.005,
			\decay, 2/~t,
			\mix, PmodEnv(Pseq([0,0.2,0.4,0.5, 0.4,0.5,1],1).trace, Pseq([1,6,1],inf)).loop,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\basstrack1, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack1, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\cpt, 0.021,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.01,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\mainhpf, \audio),
			\sideout, BusDef(\mainhpf, \audio),
		),

		Pmono(\fx_hpf,
			\inbus, BusDef(\mainhpf, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([1,1,500,500],1), Pseq([14,1,1])).loop,
			\mix, 1,
			\lag, 0.00091,
			\dur, 1,
		),


		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1808].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],6),
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\out, BusDef(\noise, \audio),
			\gain, 0.11,
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\hat,\audio),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\noise, \audio, 2),
			\dur, 1,
			\out, BusDef(\mainhpf, \audio),
		),
		Pmono(\rdn_longverb,
			\inbus, BusDef(\noise, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,

			'wet10', 1.0,
			'mix', 1,
			'gain', 1,
			'fb', 0.0001,
			'delay', 0.70123,
			'delay2', 0.007937156455582,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 0.4868559926042,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 15000,
			'posthpf', PmodEnv(Pseq([19000,10000,700,15000,330],1), Pseq([7,1],inf)).loop,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
	])
)).play;
);

///////////
// metalic rythm

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[443].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\ifx1, \audio),
			\delay, 1/12/~t,
			//\delay, ~pmodsynth.({ SinOsc.ar(1.1).range(1,1.004) * 1/6/~t }),
			\decay, 1/2/~t,
			\hpf, 300,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\ifx2, \audio),
		),
		Pmono(\fx_freqshift,
			\inbus, BusDef(\ifx2, \audio),
			\shift, Pwhite(-100,200,inf),
			\shift, Pseq(rrand(-5,4!8),inf),
			\mix, Pseq([
				0,1,1,1,1,1,
			],1),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1/6,
		).loop,
		
	])
)).play;
);



(
SynthDef(\metaldrum, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var fmf = Rand(100,5000.0);
	freq = EnvGen.kr(Env([4800,252,251],[0.01,0.8]), 1);
	sig = SinOsc.ar(freq * ( LFSaw.ar(fmf) * 10 + 1 ));
	(freq/fmf).poll;
	sig = BPF.ar(sig, 1000,0.3);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \metaldrum,
			\sustain, 1/8,
			\note, Pseq([
				0,
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\fmshot, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var fmf = \fmfac.kr(1);
	var fma;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = EnvGen.kr(Env([200,freq,freq],[0.08,0.8]), 1);
	fma = EnvGen.kr(Env([1,12,1],[0.1,0.8]), 1);
	env3 = EnvGen.kr(Env([0,12,1],[0.1,0.8]), 1);
	sig = SinOsc.ar(freq * ( LFSaw.ar(freq * fmf) * fma + 1 ));
	sig = sig + SinOsc.ar(freq * ( SinOsc.ar(freq * 2) * env3 + 1 ));
	//sig = sig + LFCub.ar(freq * ( SinOsc.ar(freq / 2) * env3 + 1 ));
	//sig = sig /4;
	(freq/fmf).poll;
	//sig = BPF.ar(sig, 1000,0.3);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \fmshot,
			\sustain, 1/8,
			\fmfac, 0.0616925*8,
			\note, Pseq([
				0,3,2,1,
			],inf),
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
);
