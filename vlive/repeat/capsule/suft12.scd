// taken from suft5
~t = 153/4/60; TempoClock.default.tempo = ~t;

(
SynthDef(\fxringer, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = RHPF.ar(sig, \lpf.kr(1000), \rq.kr(0.5));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\clochete, { arg out=0, gate=1, freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig1 = Dust.ar(10 * SinOsc.kr(1/8).range(10,1/2));
	sig1 = Ringz.ar(sig1, rrand(100,10000.0!8) * LFNoise0.kr(1/2).range(1/4,1), 1.1).mean/2;
	sig2 = Dust.ar(7);
	sig2 = Ringz.ar(sig2, rrand(100,10000.0!8), 1.1).mean/2;
	sig = sig1 + sig2;
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\blitz, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var fspread;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var ofreq = freq;
	sig1 = LFSaw.ar(freq * Latch.kr( WhiteNoise.ar(4),Impulse.kr( SinOsc.ar(1/4).range(1,8) )));
	//sig1 = LPF.ar(sig1, SinOsc.ar(10).range(10,1000) );
	sig1 = sig1 * LFPulse.ar(freq);
	fspread = SinOsc.ar(freq) * 0.01;
	sig2 = Duty.ar(fspread * 10, 0, Dseq([
		1000,340,5400,2390,
	],inf));
	freq = freq * [1,3/2,2,1/2];
	freq = LFSaw.ar(ofreq*2) * LFPulse.ar(sig2) * 0.07 + 1 * freq;
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread + 1) * ( sig1 * 1 + 1 ));
	sig = Saw.ar(freq* ( sig1 * 1 + 1 )) + sig;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	pan = pan + SinOsc.ar((1..sig.size),(1..sig.size));
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * 2;
	Out.ar(out, sig);
}).add;
);


Pdef(\part, Pdef(\blitz, 
	Ppar([
		Pmono(\blitz,
			\note, Pseq([
				0,00,0,-1,
			],inf),
			\dur, 1,
			\amp, 0.1,
		);
		
	])
)).play;

(
);

///////////////////////////////////////////
(
	// intro
	Pdef(\part, Pdef(\teko_intro, 
		Pseq([
			Pfindur(4+inf, Ppar([
				// perc

				Pbind(
					\instrument, \phyhat4,
					\isRest, Pseq([
						1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,1,0,
						1,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0, 1,0,0,1, 1,0,1,0,
						1,0,0,0, 1,0,0,0, 1,0,0,0, 1,1,0,1,

					],inf).coin.not,
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([
						0.4, 0.1, 0.2, 0.1,
					],inf),
					\dur, 1/16,
					\out, BusDef(\fx_fil2, \audio),
					//\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
					\pan, 0,
					\amp, 0.02,
				),
					Pbind(
						\instrument, \snapkickx,
						\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
						\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
						\isRest, Pseq([
							Pseq([
								0,0,0,0,
							],4),
							Pseq([
								1,0,0,0,
							],inf),
						],inf).coin.not,
						//\dur, 1/8 * Pseq([4/3,2/3],inf),
						\dur, 1/16,
					\out, BusDef(\fx_fil, \audio),
						\amp, 0.1,
					),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,1,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\out, BusDef(\fx_fil, \audio),
					\sustain, 0.1,
					\gain, 0.4,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						0,0,1,0, 0,0,1,1, 0,1,1,0, 0,0,1,0,
						0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
						0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
						0,0,1,0, 1,0,0,0, 0,0,1,0, 0,0,1,0,
						0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
						0,0,1,0, 0,0,1,0, 0,1,0,1, 0,0,1,0,
					],inf).coin.not,
					\out, BusDef(\fx_fil2, \audio),
					\sustain, 0.1/2,
					\gain, 0.2,
					\dur, 1/16,
				)),
				Pmono(\fx_rhpf,
					\inbus, BusDef(\fx_fil, \audio),
					\hpf, ~pmodenv.(Pseq([17000,200,10],inf), 8),
					\dur, 1,
				),
				Pmono(\fx_rlpf,
					\inbus, BusDef(\fx_fil2, \audio),
					\lpf, ~pmodenv.(Pseq([17,20,20000],inf), 8),
					\dur, 1,
				),


				// treb

				Pbind(
					\instrument, \fmz1,
					\note, Pseq([
						-1,0,
					],inf).stutter(2),
					\legato, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf)*0.2,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,1,0.05) ],
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\hpfr, ~pmodenv.(Pseq([1,2,1/2,1/4],inf), 8),
					\octave, 6,
					\dur, 1/16,
					\out, Pseq([
						BusDef(\fx1, \audio),
					],inf).stutter(16*8),
					\amp, 0.1,
					\isRest, true,
				),
				Pmono(\fx_chorus,
					\inbus, BusDef(\fx3, \audio),
					\fb, 2.9,
					\delay, 0.01,
					\modamp, 0.010,
					\modfreq, Pseq([
						0.1,
					],inf).stutter(8),
					\mix, 0.2,
					\dur, 1/4,
					\out, BusDef(\fx1, \audio),
					\isRest, true,
				),

				// fx

				Pmono(\ronordn,
					\inbus, BusDef(\fx1, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.0001201 * Pseq([
						Pser([
							1,2,	
						],32*2),
						Pser([
							0.01,2
						],32*2),
					],inf),
					'delay', 0.000010394574653723,
					'delay2', 0.0000828221925227 * Pseq([
						1,1,1,50,
						1,1,1,100,
						1,1,1,200,
						1,1,1,300,
						1,1,1,1/100,
					],inf).stutter(8),
					'delay3', 0.00001,
					'distamp', 1.22682721311638 * Pseq([
						1,1.8,
					],inf),
					'distamp2', 001.0,
					'distamp3', 0.9904517086311,
					'shift', -0.0,
					'shift2', -0.1344537815126,
					'shift3', -0.4789915966387,
					'shiftmix', 0.1,
					'pitchlag', 1.0,
					'pitchmix', 0.0,
					'prelpf', 17000,
					'prehpf', 17,
					'lpf', 17000,
					'hpf', 17,
					'stereo', 0.0,
					'brffac', 0.60195390291997,
					'brfrqfac', 0.37940593233798,
					'fbdistamp', 0.47619047619048,
					'fbdistmix', 0.91176470588235,
					'postlpf', 17000,
					'posthpf', 17,
					'wetamp', 0.18504562572587,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,

					\eqmid1b, Pseq([300,2000,4000],inf).stutter(8*4),
					\eqrq1b, 0.6,
					\eqdb1b, 4.6,

					\dur, 1/8 * Pseq([1],inf),
				),
				Pmono(\ronordn,
					\inbus, BusDef(\fx2, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.000101,
					'delay', 0.000000394574653723 * Pseq([100],inf),
					'delay2', 0.00010828221925227,
					'delay3', 0.400001,
					'distamp', 1.12682721311638 * Pseq([1,2,1,4],inf),
					'distamp2', 0.1,
					'distamp3', 1.0904517086311,
					'shift', -5.0,
					'shift2', -1.1344537815126,
					'shift3', -2.4789915966387,
					'shiftmix', 0,
					'pitchlag', 1.0,
					'pitchmix', 0.0,
					'prelpf', 17000,
					'prehpf', 17,
					'lpf', 17000,
					'hpf', 17,
					'stereo', 0.0,
					'brffac', 0.60195390291997,
					'brfrqfac', 0.37940593233798,
					'fbdistamp', 32.47619047619048,
					'fbdistmix', 0.91176470588235,
					'postlpf', 17000,
					'posthpf', 117,
					'wetamp', 0.18504562572587,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,

					\eqmid1b, 6000,
					\eqrq1b, 0.6,
					\eqdb1b, 1.6,

					\freq, 200,
					\dur, 1 * Pseq([1/4],inf),
					\out, BusDef(\fxstut, \audio),
				),
				Pmono(\fx_stutter,
					\freq, 200,
					\inbus, BusDef(\fxstut, \audio),
					\mix, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,1,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,1,1,1,
					],inf)/2,
					\time, Pstep(Pseq([
						1/16, 1/4,
						1/4, 1/4,
						1/8, 1/4,
						1/8, 1/4,
					],inf),1/4)/~t,
					\lag, Pwhite(0.01,0.1),
					\fb, 0.1,
					\dur, Pser([1/16],inf),
					\amp, 0.1,
				),
			])),
		])
	)).play;
)

(
	// simple
	Pdef(\part, Pdef(\teko_simple, 
		Pseq([
			Pfindur(4+inf, Ppar([
				// perc

				Pbind(
					\instrument, \phyhat4,
					\isRest, Pseq([
						1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,1,0,
						1,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0, 1,0,0,1, 1,0,1,0,
						1,0,0,0, 1,0,0,0, 1,0,0,0, 1,1,0,1,

					],inf).coin.not,
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([
						0.4, 0.1, 0.2, 0.1,
					],inf),
					\dur, 1/16,
					//\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
					\pan, 0,
					\amp, 0.02,
				),
				Pbind(\out, BusDef(\fx1))<>
				Ppar([
					Pbind(
						\instrument, \snapkickx,
						\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
						\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
						\isRest, Pseq([
							1,0,0,0,
						],inf).coin.not,
						//\dur, 1/8 * Pseq([4/3,2/3],inf),
						\dur, 1/16,
						\amp, 0.1,
					),
				]),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,1,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\out, BusDef(\fx2, \audio),
					\sustain, 0.1,
					\gain, 0.4,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						0,0,1,0, 0,0,1,1, 0,1,1,0, 0,0,1,0,
						0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
						0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
						0,0,1,0, 1,0,0,0, 0,0,1,0, 0,0,1,0,
						0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
						0,0,1,0, 0,0,1,0, 0,1,0,1, 0,0,1,0,
					],inf).coin.not,
					\out, BusDef(\fx_fil, \audio),
					\sustain, 0.1/2,
					\gain, 0.2,
					\dur, 1/16,
				)),
				Pmono(\fx_rhpf,
					\inbus, BusDef(\fx_fil, \audio),
					\hpf, ~pmodenv.(Pseq([17000,200,10],inf), 8),
					\dur, 1,
				),


				// treb

				Pbind(
					\instrument, \fmz1,
					\note, Pseq([
						-1,0,
					],inf).stutter(2),
					\legato, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf)*0.2,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,1,0.05) ],
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\hpfr, ~pmodenv.(Pseq([1,2,1/2,1/4],inf), 8),
					\octave, 6,
					\dur, 1/16,
					\out, Pseq([
						BusDef(\fx1, \audio),
					],inf).stutter(16*8),
					\amp, 0.1,
				),
				Pmono(\fx_chorus,
					\inbus, BusDef(\fx3, \audio),
					\fb, 2.9,
					\delay, 0.01,
					\modamp, 0.010,
					\modfreq, Pseq([
						0.1,
					],inf).stutter(8),
					\mix, 0.2,
					\dur, 1/4,
					\out, BusDef(\fx1, \audio),
				),
		Pmono( \clochete,
			\freq, 200,
			\dur, 1,
			\amp, 0.051,
			\amp, Pkey(\amp) * Pseq([
				0,0,0,0, 0,0,0,0, 
				Pseq([
					1,1,1,1, 1,1,1,0,
				],inf),
			],inf),
			\out, BusDef(\fx2, \audio),
		),

				// fx

				Pmono(\ronordn,
					\inbus, BusDef(\fx1, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.01201 * Pseq([
						Pser([
							1,2,	
						],32*2),
						Pser([
							0.01,2
						],32*2),
					],inf),
					'delay', 0.000010394574653723,
					'delay2', 0.0000828221925227 * Pseq([
						1,1,1,50,
						1,1,1,100,
						1,1,1,200,
						1,1,1,300,
						1,1,1,1/100,
					],inf).stutter(8),
					'delay3', 0.00001,
					'distamp', 1.22682721311638 * Pseq([
						1,1.8,
					],inf),
					'distamp2', 001.0,
					'distamp3', 0.9904517086311,
					'shift', -0.0,
					'shift2', -0.1344537815126,
					'shift3', -0.4789915966387,
					'shiftmix', 0.1,
					'pitchlag', 1.0,
					'pitchmix', 0.0,
					'prelpf', 17000,
					'prehpf', 17,
					'lpf', 17000,
					'hpf', 17,
					'stereo', 0.0,
					'brffac', 0.60195390291997,
					'brfrqfac', 0.37940593233798,
					'fbdistamp', 0.47619047619048,
					'fbdistmix', 0.91176470588235,
					'postlpf', 17000,
					'posthpf', 17,
					'wetamp', 0.18504562572587,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,

					\eqmid1b, Pseq([300,2000,4000],inf).stutter(8*4),
					\eqrq1b, 0.6,
					\eqdb1b, 4.6,

					\dur, 1/8 * Pseq([1],inf),
				),
				Pmono(\ronordn,
					\inbus, BusDef(\fx2, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.00101,
					'delay', 0.000000394574653723 * Pseq([100],inf),
					'delay2', 0.00010828221925227,
					'delay3', 0.400001,
					'distamp', 1.12682721311638 * Pseq([1,2,1,4],inf),
					'distamp2', 4.1,
					'distamp3', 1.0904517086311,
					'shift', -5.0,
					'shift2', -1.1344537815126,
					'shift3', -2.4789915966387,
					'shiftmix', 0,
					'pitchlag', 1.0,
					'pitchmix', 0.0,
					'prelpf', 17000,
					'prehpf', 17,
					'lpf', 17000,
					'hpf', 17,
					'stereo', 0.0,
					'brffac', 0.60195390291997,
					'brfrqfac', 0.37940593233798,
					'fbdistamp', 32.47619047619048,
					'fbdistmix', 0.91176470588235,
					'postlpf', 17000,
					'posthpf', 117,
					'wetamp', 0.18504562572587,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,

					\eqmid1b, 6000,
					\eqrq1b, 0.6,
					\eqdb1b, 1.6,

					\freq, 200,
					\dur, 1 * Pseq([1/4],inf),
					\out, BusDef(\fxstut, \audio),
				),
				Pmono(\fx_stutter,
					\freq, 200,
					\inbus, BusDef(\fxstut, \audio),
					\mix, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,1,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,1,1,1,
					],inf)/2,
					\time, Pstep(Pseq([
						1/16, 1/4,
						1/4, 1/4,
						1/8, 1/4,
						1/8, 1/4,
					],inf),1/4)/~t,
					\lag, Pwhite(0.01,0.1),
					\fb, 0.1,
					\dur, Pser([1/16],inf),
					\amp, 0.1,
				),
			])),
		])
	)).play;
)


(
	// with angry violin
	Pdef(\part, Pdef(\plop, 
		Pseq([
			Pfindur(4+inf, Ppar([
				// perc

				Pbind(
					\instrument, \phyhat4,
					\isRest, Pseq([
						1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,1,0,
						1,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0, 1,0,0,1, 1,0,1,0,
						1,0,0,0, 1,0,0,0, 1,0,0,0, 1,1,0,1,

					],inf).coin.not,
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([
						0.4, 0.1, 0.2, 0.1,
					],inf),
					\dur, 1/16,
					//\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
					\pan, 0,
					\amp, 0.02,
				),
				Pbind(\out, BusDef(\fx1))<>
				Ppar([
					Pbind(
						\instrument, \snapkickx,
						\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
						\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
						\isRest, Pseq([
							1,0,0,0,
						],inf).coin.not,
						//\dur, 1/8 * Pseq([4/3,2/3],inf),
						\dur, 1/16,
						\amp, 0.1,
					),
				]),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,1,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\out, BusDef(\fx2, \audio),
					\sustain, 0.1,
					\gain, 0.4,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						0,0,1,0, 0,0,1,1, 0,1,1,0, 0,0,1,0,
						0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
						0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
						0,0,1,0, 1,0,0,0, 0,0,1,0, 0,0,1,0,
						0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
						0,0,1,0, 0,0,1,0, 0,1,0,1, 0,0,1,0,
					],inf).coin.not,
					\out, BusDef(\fx_fil, \audio),
					\sustain, 0.1/2,
					\gain, 0.2,
					\dur, 1/16,
				)),
				Pmono(\fx_rhpf,
					\inbus, BusDef(\fx_fil, \audio),
					\hpf, ~pmodenv.(Pseq([17000,200,10],inf), 8),
					\dur, 1,
				),


				// treb

				Pbind(
					\instrument, \fmz1,
					\note, Pseq([
						-1,0,
					],inf).stutter(2),
					\legato, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf)*0.2,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,1,0.05) ],
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\hpfr, ~pmodenv.(Pseq([1,2,1/2,1/4],inf), 8),
					\octave, 6,
					\dur, 1/16,
					\out, Pseq([
						BusDef(\fx1, \audio),
					],inf).stutter(16*8),
					\amp, 0.1,
				),
				Pmono(\fx_chorus,
					\inbus, BusDef(\fx3, \audio),
					\fb, 2.9,
					\delay, 0.01,
					\modamp, 0.010,
					\modfreq, Pseq([
						0.1,
					],inf).stutter(8),
					\mix, 0.2,
					\dur, 1/4,
					\out, BusDef(\fx1, \audio),
				),
		Pmono(\blitz,
			\note, Pstep(Pseq([
				0,00,0,-1,
			],inf),1),
			\octave, Pseq([
				Pser([
					8,7,4,
				],2*8),
				Pseq([
					8,8,7,8,
					7,6,7,4,
				],2),
				Pseq([
					8,8,8,8,
					4,4,4,4,
				],2),
			],inf).stutter(1),
			\dur, PdurStutter(Pseq([1,4,2,8],inf), Pseq([
				1,2,1,1/2,1/2
				
			],inf)),
			\amp, 0.071,
			\out, BusDef(\bus0, \audio),
		),
		Pmono(\fxringer,
			\inbus, BusDef(\bus0, \audio),
			\rq, 0.1,
			\lpf, Pseq([
				200,400,
				200,800,
			],inf),
			\dur, 1,
			\amp, 0.1,
		),

				// fx

				Pmono(\ronordn,
					\inbus, BusDef(\fx1, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.01201 * Pseq([
						Pser([
							1,2,	
						],32*2),
						Pser([
							0.01,2
						],32*2),
					],inf),
					'delay', 0.000010394574653723,
					'delay2', 0.0000828221925227 * Pseq([
						1,1,1,50,
						1,1,1,100,
						1,1,1,200,
						1,1,1,300,
						1,1,1,1/100,
					],inf).stutter(8),
					'delay3', 0.00001,
					'distamp', 1.22682721311638 * Pseq([
						1,1.8,
					],inf),
					'distamp2', 001.0,
					'distamp3', 0.9904517086311,
					'shift', -0.0,
					'shift2', -0.1344537815126,
					'shift3', -0.4789915966387,
					'shiftmix', 0.1,
					'pitchlag', 1.0,
					'pitchmix', 0.0,
					'prelpf', 17000,
					'prehpf', 17,
					'lpf', 17000,
					'hpf', 17,
					'stereo', 0.0,
					'brffac', 0.60195390291997,
					'brfrqfac', 0.37940593233798,
					'fbdistamp', 0.47619047619048,
					'fbdistmix', 0.91176470588235,
					'postlpf', 17000,
					'posthpf', 17,
					'wetamp', 0.18504562572587,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,

					\eqmid1b, Pseq([300,2000,4000],inf).stutter(8*4),
					\eqrq1b, 0.6,
					\eqdb1b, 4.6,

					\dur, 1/8 * Pseq([1],inf),
				),
				Pmono(\ronordn,
					\inbus, BusDef(\fx2, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.00101,
					'delay', 0.000000394574653723 * Pseq([100],inf),
					'delay2', 0.00010828221925227,
					'delay3', 0.400001,
					'distamp', 1.12682721311638 * Pseq([1,2,1,4],inf),
					'distamp2', 4.1,
					'distamp3', 1.0904517086311,
					'shift', -5.0,
					'shift2', -1.1344537815126,
					'shift3', -2.4789915966387,
					'shiftmix', 0,
					'pitchlag', 1.0,
					'pitchmix', 0.0,
					'prelpf', 17000,
					'prehpf', 17,
					'lpf', 17000,
					'hpf', 17,
					'stereo', 0.0,
					'brffac', 0.60195390291997,
					'brfrqfac', 0.37940593233798,
					'fbdistamp', 32.47619047619048,
					'fbdistmix', 0.91176470588235,
					'postlpf', 17000,
					'posthpf', 117,
					'wetamp', 0.18504562572587,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,

					\eqmid1b, 6000,
					\eqrq1b, 0.6,
					\eqdb1b, 1.6,

					\freq, 200,
					\dur, 1 * Pseq([1/4],inf),
					\out, BusDef(\fxstut, \audio),
				),
				Pmono(\fx_stutter,
					\freq, 200,
					\inbus, BusDef(\fxstut, \audio),
					\mix, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,1,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,1,1,1,
					],inf)/2,
					\time, Pstep(Pseq([
						1/16, 1/4,
						1/4, 1/4,
						1/8, 1/4,
						1/8, 1/4,
					],inf),1/4)/~t,
					\lag, Pwhite(0.01,0.1),
					\fb, 0.1,
					\dur, Pser([1/16],inf),
					\amp, 0.1,
				),
			])),
		])
	)).play;
)


(
	// angry violin on fx
	Pdef(\part, Pdef(\plop, 
		Pseq([
			Pfindur(4+inf, Ppar([
				// perc

				Pbind(
					\instrument, \phyhat4,
					\isRest, Pseq([
						1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,1,0,
						1,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0, 1,0,0,1, 1,0,1,0,
						1,0,0,0, 1,0,0,0, 1,0,0,0, 1,1,0,1,

					],inf).coin.not,
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([
						0.4, 0.1, 0.2, 0.1,
					],inf),
					\dur, 1/16,
					//\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
					\pan, 0,
					\amp, 0.02,
				),
				Pbind(\out, BusDef(\fx1))<>
				Ppar([
					Pbind(
						\instrument, \snapkickx,
						\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
						\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
						\isRest, Pseq([
							1,0,0,0,
						],inf).coin.not,
						//\dur, 1/8 * Pseq([4/3,2/3],inf),
						\dur, 1/16,
						\amp, 0.1,
					),
				]),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,1,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\out, BusDef(\fx2, \audio),
					\sustain, 0.1,
					\gain, 0.4,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						0,0,1,0, 0,0,1,1, 0,1,1,0, 0,0,1,0,
						0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
						0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
						0,0,1,0, 1,0,0,0, 0,0,1,0, 0,0,1,0,
						0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
						0,0,1,0, 0,0,1,0, 0,1,0,1, 0,0,1,0,
					],inf).coin.not,
					\out, BusDef(\fx_fil, \audio),
					\sustain, 0.1/2,
					\gain, 0.2,
					\dur, 1/16,
				)),
				Pmono(\fx_rhpf,
					\inbus, BusDef(\fx_fil, \audio),
					\hpf, ~pmodenv.(Pseq([17000,200,10],inf), 8),
					\dur, 1,
				),


				// treb

				Pbind(
					\instrument, \fmz1,
					\note, Pseq([
						-1,0,
					],inf).stutter(2),
					\legato, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf)*0.2,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,1,0.05) ],
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\hpfr, ~pmodenv.(Pseq([1,2,1/2,1/4],inf), 8),
					\octave, 6,
					\dur, 1/16,
					\out, Pseq([
						BusDef(\fx1, \audio),
					],inf).stutter(16*8),
					\amp, 0.1,
				),
				Pmono(\fx_chorus,
					\inbus, BusDef(\fx3, \audio),
					\fb, 2.9,
					\delay, 0.01,
					\modamp, 0.010,
					\modfreq, Pseq([
						0.1,
					],inf).stutter(8),
					\mix, 0.2,
					\dur, 1/4,
					\out, BusDef(\fx1, \audio),
				),
		Pmono(\blitz,
			\note, Pstep(Pseq([
				0,00,0,-1,
			],inf),1),
			\octave, Pseq([
				Pser([
					8,7,4,
				],2*8),
				Pseq([
					8,8,7,8,
					7,6,7,4,
				],2),
				Pseq([
					8,8,8,8,
					4,4,4,4,
				],2),
			],inf).stutter(1),
			\dur, PdurStutter(Pseq([1,4,2,8],inf), Pseq([
				1,2,1,1/2,1/2
				
			],inf)),
			\amp, 0.071,
			\out, BusDef(\bus0, \audio),
		),
		Pmono(\fxringer,
			\inbus, BusDef(\bus0, \audio),
			\rq, 0.1,
			\lpf, Pseq([
				200,400,
				200,800,
			],inf)*2,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fx2, \audio),
		),

				// fx

				Pmono(\ronordn,
					\inbus, BusDef(\fx1, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.01201 * Pseq([
						Pser([
							1,2,	
						],32*2),
						Pser([
							0.01,2
						],32*2),
					],inf),
					'delay', 0.000010394574653723,
					'delay2', 0.0000828221925227 * Pseq([
						1,1,1,50,
						1,1,1,100,
						1,1,1,200,
						1,1,1,300,
						1,1,1,1/100,
					],inf).stutter(8),
					'delay3', 0.00001,
					'distamp', 1.22682721311638 * Pseq([
						1,1.8,
					],inf),
					'distamp2', 001.0,
					'distamp3', 0.9904517086311,
					'shift', -0.0,
					'shift2', -0.1344537815126,
					'shift3', -0.4789915966387,
					'shiftmix', 0.1,
					'pitchlag', 1.0,
					'pitchmix', 0.0,
					'prelpf', 17000,
					'prehpf', 17,
					'lpf', 17000,
					'hpf', 17,
					'stereo', 0.0,
					'brffac', 0.60195390291997,
					'brfrqfac', 0.37940593233798,
					'fbdistamp', 0.47619047619048,
					'fbdistmix', 0.91176470588235,
					'postlpf', 17000,
					'posthpf', 17,
					'wetamp', 0.18504562572587,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,

					\eqmid1b, Pseq([300,2000,4000],inf).stutter(8*4),
					\eqrq1b, 0.6,
					\eqdb1b, 4.6,

					\dur, 1/8 * Pseq([1],inf),
				),
				Pmono(\ronordn,
					\inbus, BusDef(\fx2, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.14454369503751,
					'fb', 0.000101,
					'delay', 0.000000394574653723 * Pseq([10000],inf),
					'delay2', 0.00010828221925227,
					'delay3', 0.000001,
					'distamp', 1.12682721311638 * Pseq([
						Pseq([
							1,2,4,1, 4,4,4,4,
						],1),
						Pseq([
							1,2,1,4
						],2).stutter(4),
						Pseq([
							0,0,0,0,
							0,0,4,0,
							4,4,1,4,
							1,4,1,4,
						],1).stutter(1),
					],inf).stutter(2),
					'distamp2', 8.1,
					'distamp3', 1.0904517086311,
					'shift', -5.0,
					'shift2', -1.1344537815126,
					'shift3', -2.4789915966387,
					'shiftmix', 0,
					'pitchlag', 1.0,
					'pitchmix', 0.0,
					'prelpf', 17000,
					'prehpf', 17,
					'lpf', 17000,
					'hpf', 17,
					'stereo', 0.0,
					'brffac', 0.60195390291997,
					'brfrqfac', 0.37940593233798,
					'fbdistamp', 32.47619047619048,
					'fbdistmix', 0.91176470588235,
					'postlpf', 17000,
					'posthpf', 117,
					'wetamp', 0.18504562572587,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,

					\eqmid1b, 6000,
					\eqrq1b, 0.6,
					\eqdb1b, 1.6,

					\freq, 200,
					\dur, 1 * Pseq([1/4],inf),
					\out, BusDef(\fxstut, \audio),
				),
				Pmono(\fx_stutter,
					\freq, 200,
					\inbus, BusDef(\fxstut, \audio),
					\mix, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,1,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,1,1,1,
					],inf)/2,
					\time, Pstep(Pseq([
						1/16, 1/4,
						1/4, 1/4,
						1/8, 1/4,
						1/8, 1/4,
					],inf),1/4)/~t,
					\lag, Pwhite(0.01,0.1),
					\fb, 0.1,
					\dur, Pser([1/16],inf),
					\amp, 0.1,
				),
			])),
		])
	)).play;
)


(
	// with voice
	Pdef(\part, Pdef(\plop, 
		Pseq([
			Pfindur(4+inf, Ppar([
				// perc

				Pbind(
					\instrument, \phyhat4,
					\isRest, Pseq([
						1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,1,0,
						1,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0, 1,0,0,1, 1,0,1,0,
						1,0,0,0, 1,0,0,0, 1,0,0,0, 1,1,0,1,

					],inf).coin.not,
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([
						0.4, 0.1, 0.2, 0.1,
					],inf),
					\dur, 1/16,
					//\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
					\pan, 0,
					\amp, 0.02,
				),
				Pbind(\out, BusDef(\fx1))<>
				Ppar([
					Pbind(
						\instrument, \snapkickx,
						\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
						\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
						\isRest, Pseq([
							1,0,0,0,
						],inf).coin.not,
						//\dur, 1/8 * Pseq([4/3,2/3],inf),
						\dur, 1/16,
						\amp, 0.1,
					),
				]),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,1,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\out, BusDef(\fx2, \audio),
					\sustain, 0.1,
					\gain, 0.4,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						0,0,1,0, 0,0,1,1, 0,1,1,0, 0,0,1,0,
						0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
						0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
						0,0,1,0, 1,0,0,0, 0,0,1,0, 0,0,1,0,
						0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
						0,0,1,0, 0,0,1,0, 0,1,0,1, 0,0,1,0,
					],inf).coin.not,
					\out, BusDef(\fx_fil, \audio),
					\sustain, 0.1/2,
					\gain, 0.2,
					\dur, 1/16,
				)),
				Pmono(\fx_rhpf,
					\inbus, BusDef(\fx_fil, \audio),
					\hpf, ~pmodenv.(Pseq([17000,200,10],inf), 8),
					\dur, 1,
				),


				// treb

				Pbind(
					\instrument, \fmz1,
					\note, Pseq([
						-1,0,
					],inf).stutter(2),
					\legato, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf)*0.2,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,1,0.05) ],
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\hpfr, ~pmodenv.(Pseq([1,2,1/2,1/4],inf), 8),
					\octave, 6,
					\dur, 1/16,
					\out, Pseq([
						BusDef(\fx1, \audio),
					],inf).stutter(16*8),
					\amp, 0.1,
				),
				Pmono(\fx_chorus,
					\inbus, BusDef(\fx3, \audio),
					\fb, 2.9,
					\delay, 0.01,
					\modamp, 0.010,
					\modfreq, Pseq([
						0.1,
					],inf).stutter(8),
					\mix, 0.2,
					\dur, 1/4,
					\out, BusDef(\fx1, \audio),
				),
		Pmono(\blitz,
			\note, Pstep(Pseq([
				0,00,0,-1,
			],inf),1),
			\octave, Pseq([
				7,5,5,
			],inf).stutter(1),
			\dur, PdurStutter(Pseq([4],inf), Pseq([
				1,1/2,
			],inf)),
			\amp, 0.071 * Pseq([
				Pseq([
					1,0,1,0,
				],4),
				1,0, 1,1,
				1,0,0,0,
				1,1,0,1,
			],inf),
			\out, BusDef(\bus0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/kaspi.flac'),
			\out, BusDef(\fx2, \audio),
			\pos, Pseq([
				0,1,
				0,1.01,
			],inf)+ Pstep(Pseq([3,0.5,3,0.5,1,2],inf),2*1),
			\speed, Pseq([
				Pstep(Pseq([1,1],1),2),
				1,1.2,1.4,
			],inf),
			\dur, Pstep(Pseq([1,1/2,1/4],inf),8),
			\amp, 0.1,
		),
		Pmono(\fxringer,
			\inbus, BusDef(\bus0, \audio),
			\rq, 0.1,
			\lpf, Pseq([
				200,400,
				200,800,
			],inf)*2,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fx2, \audio),
		),

				// fx

				Pmono(\ronordn,
					\inbus, BusDef(\fx1, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.01201 * Pseq([
						Pser([
							1,2,	
						],32*2),
						Pser([
							0.01,2
						],32*2),
					],inf),
					'delay', 0.000010394574653723,
					'delay2', 0.0000828221925227 * Pseq([
						1,1,1,50,
						1,1,1,100,
						1,1,1,200,
						1,1,1,300,
						1,1,1,1/100,
					],inf).stutter(8),
					'delay3', 0.00001,
					'distamp', 1.22682721311638 * Pseq([
						1,1.8,
					],inf),
					'distamp2', 001.0,
					'distamp3', 0.9904517086311,
					'shift', -0.0,
					'shift2', -0.1344537815126,
					'shift3', -0.4789915966387,
					'shiftmix', 0.1,
					'pitchlag', 1.0,
					'pitchmix', 0.0,
					'prelpf', 17000,
					'prehpf', 17,
					'lpf', 17000,
					'hpf', 17,
					'stereo', 0.0,
					'brffac', 0.60195390291997,
					'brfrqfac', 0.37940593233798,
					'fbdistamp', 0.47619047619048,
					'fbdistmix', 0.91176470588235,
					'postlpf', 17000,
					'posthpf', 17,
					'wetamp', 0.18504562572587,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,

					\eqmid1b, Pseq([300,2000,4000],inf).stutter(8*4),
					\eqrq1b, 0.6,
					\eqdb1b, 4.6,

					\dur, 1/8 * Pseq([1],inf),
				),
				Pmono(\ronordn,
					\inbus, BusDef(\fx2, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.14454369503751,
					'fb', 0.000101,
					'delay', 0.000000394574653723 * Pseq([10000],inf),
					'delay2', 0.00010828221925227,
					'delay3', 0.000001,
					'distamp', 1.12682721311638 * Pseq([
						Pseq([
							1,2,4,1, 4,4,4,4,
						],1),
						Pseq([
							1,2,1,4
						],2).stutter(4),
						Pseq([
							0,0,0,0,
							0,0,4,0,
							4,4,1,4,
							1,4,1,4,
						],1).stutter(1),
					],inf).stutter(2),
					'distamp2', 8.1,
					'distamp3', 1.0904517086311,
					'shift', -5.0,
					'shift2', -1.1344537815126,
					'shift3', -2.4789915966387,
					'shiftmix', 0,
					'pitchlag', 1.0,
					'pitchmix', 0.0,
					'prelpf', 17000,
					'prehpf', 17,
					'lpf', 17000,
					'hpf', 17,
					'stereo', 0.0,
					'brffac', 0.60195390291997,
					'brfrqfac', 0.37940593233798,
					'fbdistamp', 32.47619047619048,
					'fbdistmix', 0.91176470588235,
					'postlpf', 17000,
					'posthpf', 117,
					'wetamp', 0.18504562572587,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,

					\eqmid1b, 6000,
					\eqrq1b, 0.6,
					\eqdb1b, 1.6,

					\freq, 200,
					\dur, 1 * Pseq([1/4],inf),
					\out, BusDef(\fxstut, \audio),
				),
				Pmono(\fx_stutter,
					\freq, 200,
					\inbus, BusDef(\fxstut, \audio),
					\mix, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,1,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,1,1,1,
					],inf)/2,
					\time, Pstep(Pseq([
						1/16, 1/4,
						1/4, 1/4,
						1/8, 1/4,
						1/8, 1/4,
					],inf),1/4)/~t,
					\lag, Pwhite(0.01,0.1),
					\fb, 0.1,
					\dur, Pser([1/16],inf),
					\amp, 0.1,
				),
			])),
		])
	)).play;
)


(
	// cut perc
	Pdef(\part, Pdef(\teko_cutperc, 
		Ppar([
			Pseq([
				Pfindur(14, Ppar([
					// perc
				
					Pbind(
						\instrument, \phyhat4,
						\isRest, Pseq([
							1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,1,0,
							1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,1,0,
							1,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,1,0,
							1,0,0,0, 1,0,0,0, 1,0,0,1, 1,0,1,0,
							1,0,0,0, 1,0,0,0, 1,0,0,0, 1,1,0,1,
				
						],inf).coin.not,
						\sustain, Pseq([0.08,0.02],inf),
						\fac1, Pseq([
							0.4, 0.1, 0.2, 0.1,
						],inf),
						\dur, 1/16,
						//\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
						\pan, 0,
						\amp, 0.02,
					),
					Pbind(\out, BusDef(\fx1))<>
					Ppar([
						Pbind(
							\instrument, \snapkickx,
							\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
							\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
							\isRest, Pseq([
								1,0,0,0,
							],inf).coin.not,
							//\dur, 1/8 * Pseq([4/3,2/3],inf),
							\dur, 1/16,
							\amp, 0.1,
						),
					]),
					PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 5,
						\isRest, Pseq([
							0,0,0,0, 1,0,0,0,
							0,0,0,0, 1,0,0,0,
							0,0,0,0, 1,0,0,0,
							0,0,0,0, 1,0,0,0,
							0,1,0,0, 1,0,0,0,
							0,0,0,0, 1,0,0,0,
						],inf).coin.not,
						\out, BusDef(\fx2, \audio),
						\sustain, 0.1,
						\gain, 0.4,
						\dur, 1/8,
					)),
					PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 4,
						\isRest, Pseq([
							0,0,1,0, 0,0,1,1, 0,1,1,0, 0,0,1,0,
							0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
							0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
							0,0,1,0, 1,0,0,0, 0,0,1,0, 0,0,1,0,
							0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
							0,0,1,0, 0,0,1,0, 0,1,0,1, 0,0,1,0,
						],inf).coin.not,
						\out, BusDef(\fx_fil, \audio),
						\sustain, 0.1/2,
						\gain, 0.2,
						\dur, 1/16,
					)),
					Pmono(\fx_rhpf,
						\inbus, BusDef(\fx_fil, \audio),
						\hpf, ~pmodenv.(Pseq([17000,200,10],inf), 8),
						\dur, 1,
					),
				
				
				])),
				Event.silent(2),
			],inf),
				// treb

				Pbind(
					\instrument, \fmz1,
					\note, Pseq([
						-1,0,
					],inf).stutter(2),
					\legato, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf)*0.2,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,1,0.05) ],
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\hpfr, ~pmodenv.(Pseq([1,2,1/2,1/4],inf), 8),
					\octave, 6,
					\dur, 1/16,
					\out, Pseq([
						BusDef(\fx1, \audio),
					],inf).stutter(16*8),
					\amp, 0.1,
				),
				Pmono(\fx_chorus,
					\inbus, BusDef(\fx3, \audio),
					\fb, 2.9,
					\delay, 0.01,
					\modamp, 0.010,
					\modfreq, Pseq([
						0.1,
					],inf).stutter(8),
					\mix, 0.2,
					\dur, 1/4,
					\out, BusDef(\fx1, \audio),
				),
		Pmono(\blitz,
			\note, Pstep(Pseq([
				0,00,0,-1,
			],inf),1),
			\octave, Pseq([
				7,5,5,
			],inf).stutter(1),
			\dur, PdurStutter(Pseq([4],inf), Pseq([
				1,1/2,
			],inf)),
			\amp, 0.071 * Pseq([
				Pseq([
					1,1,1,1,
				],16+8),
				Pseq([
					1,0,1,0,
				],4),
				1,0, 1,1,
				1,0,0,0,
				1,1,0,1,
				0,0,0,0,
			],inf),
			\out, BusDef(\bus0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/kaspi.flac'),
			\bufnum, BufDef('voices/02_moeten.flac'),
			\out, BusDef(\bus0, \audio),
			\pos, Pseq([
				0,1,
				0,1.01,
			],inf)+ Pstep(Pseq([3,0.5,3,0.5,1,2],inf),2*1),
			\legato, Pseq([
				0.1,0.8
			],inf).stutter(32),
			\speed, Pseq([
				Pstep(Pseq([2,2],1),2),
				1,1.2,1.4,
			],inf),
			\dur, Pstep(Pseq([1,1/2,1/4],inf),8),
			\amp, 0.1,
		),
		Pmono(\fxringer,
			\inbus, BusDef(\bus0, \audio),
			\rq, 0.1,
			\lpf, Pseq([
				200,400,
				200,800,
			],inf)*2,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fx2, \audio),
		),

				// fx

				Pmono(\ronordn,
					\inbus, BusDef(\fx1, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.01201 * Pseq([
						Pser([
							1,2,	
						],32*2),
						Pser([
							0.01,2
						],32*2),
					],inf),
					'delay', 0.000010394574653723,
					'delay2', 0.0000828221925227 * Pseq([
						1,1,1,50,
						1,1,1,100,
						1,1,1,200,
						1,1,1,300,
						1,1,1,1/100,
					],inf).stutter(8),
					'delay3', 0.00001,
					'distamp', 1.22682721311638 * Pseq([
						1,1.8,
					],inf),
					'distamp2', 001.0,
					'distamp3', 0.9904517086311,
					'shift', -0.0,
					'shift2', -0.1344537815126,
					'shift3', -0.4789915966387,
					'shiftmix', 0.1,
					'pitchlag', 1.0,
					'pitchmix', 0.0,
					'prelpf', 17000,
					'prehpf', 17,
					'lpf', 17000,
					'hpf', 17,
					'stereo', 0.0,
					'brffac', 0.60195390291997,
					'brfrqfac', 0.37940593233798,
					'fbdistamp', 0.47619047619048,
					'fbdistmix', 0.91176470588235,
					'postlpf', 17000,
					'posthpf', 17,
					'wetamp', 0.18504562572587,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,

					\eqmid1b, Pseq([300,2000,4000],inf).stutter(8*4),
					\eqrq1b, 0.6,
					\eqdb1b, 4.6,

					\dur, 1/8 * Pseq([1],inf),
				),
				Pmono(\ronordn,
					\inbus, BusDef(\fx2, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.14454369503751,
					'fb', 0.000101,
					'delay', 0.000000394574653723 * Pseq([10000],inf),
					'delay2', 0.00010828221925227,
					'delay3', 0.000001,
					'distamp', 1.12682721311638 * Pseq([
						Pseq([
							1,2,4,1, 4,4,4,4,
						],1),
						Pseq([
							1,2,1,4
						],2).stutter(4),
						Pseq([
							0,0,0,0,
							0,0,4,0,
							4,4,1,4,
							1,4,1,4,
						],1).stutter(1),
					],inf).stutter(2),
					'distamp2', 8.1,
					'distamp3', 1.0904517086311,
					'shift', -5.0,
					'shift2', -1.1344537815126,
					'shift3', -2.4789915966387,
					'shiftmix', 0,
					'pitchlag', 1.0,
					'pitchmix', 0.0,
					'prelpf', 17000,
					'prehpf', 17,
					'lpf', 17000,
					'hpf', 17,
					'stereo', 0.0,
					'brffac', 0.60195390291997,
					'brfrqfac', 0.37940593233798,
					'fbdistamp', 32.47619047619048,
					'fbdistmix', 0.91176470588235,
					'postlpf', 17000,
					'posthpf', 117,
					'wetamp', 0.18504562572587,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,

					\eqmid1b, 6000,
					\eqrq1b, 0.6,
					\eqdb1b, 1.6,

					\freq, 200,
					\dur, 1 * Pseq([1/4],inf),
					\out, BusDef(\fxstut, \audio),
				),
				Pmono(\fx_stutter,
					\freq, 200,
					\inbus, BusDef(\fxstut, \audio),
					\mix, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,1,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,1,1,1,
					],inf)/2,
					\time, Pstep(Pseq([
						1/16, 1/4,
						1/4, 1/4,
						1/8, 1/4,
						1/8, 1/4,
					],inf),1/4)/~t,
					\lag, Pwhite(0.01,0.1),
					\fb, 0.1,
					\dur, Pser([1/16],inf),
					\amp, 0.1,
				),
		])
	)).play;
)

(
	// hiphop
	Pdef(\part, Pdef(\teko_hip, 
		Ppar([
			Pseq([
				Pfindur(14, Ppar([
					// perc
				
					Pbind(
						\instrument, \phyhat4,
						\isRest, Pseq([
							1,0,0,0, 1,0,0,0, 
				
						],inf).coin.not,
						\sustain, Pseq([0.08,0.02],inf),
						\fac1, Pseq([
							0.4, 0.1, 0.2, 0.1,
						],inf),
						\dur, 1/16,
						//\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
						\pan, 0,
						\amp, 0.02,
					),
					Pbind(\out, BusDef(\fx1))<>
					Ppar([
						Pbind(
							\instrument, \snapkickx,
							\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
							\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
							\isRest, Pseq([
								1,0,1,0, 0,0,0,0,
								1,0,1,0, 0,0,0,0,
								1,0,0,1, 0,0,1,0,
								1,0,0,0, 0,0,1,0,
							],inf).coin.not,
							//\dur, 1/8 * Pseq([4/3,2/3],inf),
							\dur, 1/16,
							\amp, 0.1,
						),
					]),
					PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 5,
						\isRest, Pseq([
							0,0,0,0, 1,0,0,0,
							0,0,0,0, 1,0,0,0,
							0,0,0,0, 1,0,0,0,
							0,0,0,0, 1,0,0,0,
							0,1,0,0, 1,0,0,0,
							0,0,0,0, 1,0,0,0,
						],inf).coin.not,
						\out, BusDef(\fx2, \audio),
						\sustain, 0.1,
						\gain, 0.4,
						\dur, 1/8,
					)),
					PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 4,
						\isRest, Pseq([
							0,0,1,0, 0,0,1,1, 0,1,1,0, 0,0,1,0,
							0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
							0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
							0,0,1,0, 1,0,0,0, 0,0,1,0, 0,0,1,0,
							0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
							0,0,1,0, 0,0,1,0, 0,1,0,1, 0,0,1,0,
						],inf).coin.not,
						\out, BusDef(\fx_fil, \audio),
						\sustain, 0.1/2,
						\gain, 0.2,
						\dur, 1/16,
					)),
					Pmono(\fx_rhpf,
						\inbus, BusDef(\fx_fil, \audio),
						\hpf, ~pmodenv.(Pseq([17000,200,10],inf), 8),
						\dur, 1,
					),
				
				
				])),
				Event.silent(2),
			],inf),
				// treb

				Pbind(
					\instrument, \fmz1,
					\note, Pseq([
						-1,0,
					],inf).stutter(2),
					\legato, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf)*0.2,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,1,0.05) ],
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\hpfr, ~pmodenv.(Pseq([1,2,1/2,1/4],inf), 8),
					\octave, 6,
					\dur, 1/16,
					\out, Pseq([
						BusDef(\fx1, \audio),
					],inf).stutter(16*8),
					\amp, 0.1,
				),
				Pmono(\fx_chorus,
					\inbus, BusDef(\fx3, \audio),
					\fb, 2.9,
					\delay, 0.01,
					\modamp, 0.010,
					\modfreq, Pseq([
						0.1,
					],inf).stutter(8),
					\mix, 0.2,
					\dur, 1/4,
					\out, BusDef(\fx1, \audio),
				),
		Pmono(\blitz,
			\note, Pstep(Pseq([
				0,00,0,-1,
			],inf),1),
			\octave, Pseq([
				7,5,5,
			],inf).stutter(1),
			\dur, PdurStutter(Pseq([4],inf), Pseq([
				1/2,1/8
			],inf)),
			\amp, 0.071 * Pseq([
				Pseq([
					1,0,1,0,
				],4),
				1,0, 1,1,
				1,0,0,0,
				1,1,0,1,
				0,0,0,0,
			],inf),
			\out, BusDef(\bus0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/02_moeten.flac'),
			\bufnum, BufDef('voices/kaspi.flac'),
			\out, BusDef(\bus0, \audio),
			\pos, Pseq([
				0,1,
				0,1.01,
			],inf)+ Pstep(Pseq([3,0.5,3,0.5,1,2],inf),2*1),
			\legato, Pseq([
				0.9
			],inf).stutter(32),
			\speed, Pseq([
				Pstep(Pseq([2,2]/2,1),2),
				1,1.2,1.4,
			],inf),
			\isRest, Pseq([
				1,1,0,0, 0,0,1,0,
				1,1,0,0, 1,1,0,1,
			],inf).coin.not,
			\dur, Pstep(Pseq([1/2,1/8,1/4],inf),8),
			\amp, 0.1,
		),
		Pmono(\fxringer,
			\inbus, BusDef(\bus0, \audio),
			\rq, 0.1,
			\lpf, Pseq([
				200,400,
				200,800,
			],inf)*2,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fx2, \audio),
		),

				// fx

				Pmono(\ronordn,
					\inbus, BusDef(\fx1, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.01201 * Pseq([
						Pser([
							0.01,2,
							1,2,	
						],32*2),
						Pser([
							0.01,2
						],32*2),
					],inf),
					'delay', 0.000010394574653723,
					'delay2', 0.0000828221925227 * Pseq([
						1,1,1,50,
						1,1,1,100,
						1,1,1,200,
						1,1,1,300,
						1,1,1,1/100,
					],inf).stutter(8),
					'delay3', 0.00001,
					'distamp', 1.22682721311638 * Pseq([
						1,1.8,
					],inf),
					'distamp2', 001.0,
					'distamp3', 0.9904517086311,
					'shift', -0.0,
					'shift2', -0.1344537815126,
					'shift3', -0.4789915966387,
					'shiftmix', 0.1,
					'pitchlag', 1.0,
					'pitchmix', 0.0,
					'prelpf', 17000,
					'prehpf', 17,
					'lpf', 17000,
					'hpf', 17,
					'stereo', 0.0,
					'brffac', 0.60195390291997,
					'brfrqfac', 0.37940593233798,
					'fbdistamp', 0.47619047619048,
					'fbdistmix', 0.91176470588235,
					'postlpf', 17000,
					'posthpf', 17,
					'wetamp', 0.18504562572587,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,

					\eqmid1b, Pseq([300,2000,4000],inf).stutter(8*4),
					\eqrq1b, 0.6,
					\eqdb1b, 4.6,

					\dur, 1/8 * Pseq([1],inf),
				),
				Pmono(\ronordn,
					\inbus, BusDef(\fx2, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.14454369503751,
					'fb', 0.000101,
					'delay', 0.000000394574653723 * Pseq([1000],inf),
					'delay2', Pseq([
						~pmodenv.(Pseq([0.00001,0.00002,1],inf), Pseq([12,4],1)),
					],inf),
					'delay3', 0.00001,
					'distamp', 1.12682721311638 * Pseq([
						Pseq([
							1,2,4,1, 4,4,4,4,
						],1),
						Pseq([
							1,2,1,4
						],2).stutter(4),
						Pseq([
							0,0,0,0,
							0,0,4,0,
							4,4,1,4,
							1,4,1,4,
						],1).stutter(1),
					],inf).stutter(2) * Pstep(Pseq([ 1,0 ],inf), Pseq([15+( 3/4 ),1/4],inf)).trace,
					'distamp2', 8.1,
					'distamp3', 1.0904517086311,
					'shift', -5.0,
					'shift2', -1.1344537815126,
					'shift3', -2.4789915966387,
					'shiftmix', 0,
					'pitchlag', 1.0,
					'pitchmix', 0.0,
					'prelpf', 17000,
					'prehpf', 17,
					'lpf', 17000,
					'hpf', 17,
					'stereo', 0.0,
					'brffac', 0.60195390291997,
					'brfrqfac', 0.37940593233798,
					'fbdistmix', 0.91176470588235,
					'postlpf', 17000,
					'posthpf', 117,
					'wetamp', 0.18504562572587,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,

					\eqmid1b, 6000,
					\eqrq1b, 0.6,
					\eqdb1b, 1.6,

					\freq, 200,
					\dur, 1 * Pseq([1/4],inf),
					\out, BusDef(\fxstut, \audio),
				),
				Pmono(\fx_stutter,
					\freq, 200,
					\inbus, BusDef(\fxstut, \audio),
					\mix, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,1,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,1,1,1,
					],inf)/2,
					\time, Pstep(Pseq([
						1/16, 1/4,
						1/4, 1/4,
						1/8, 1/4,
						1/8, 1/4,
					],inf),1/4)/~t,
					\lag, Pwhite(0.01,0.1),
					\fb, 0.1,
					\dur, Pser([1/16],inf),
					\amp, 0.1,
				),
		])
	)).play;
)

(
	// acid
	Pdef(\part, Pdef(\plop, 
		Pseq([
			Pfindur(4+inf, Ppar([
				// perc

				Pbind(
					\instrument, \phyhat4,
					\isRest, Pseq([
						1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,1,0,
						1,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0, 1,0,0,1, 1,0,1,0,
						1,0,0,0, 1,0,0,0, 1,0,0,0, 1,1,0,1,

					],inf).coin.not,
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([
						0.4, 0.1, 0.2, 0.1,
					],inf),
					\dur, 1/16,
					//\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
					\pan, 0,
					\amp, 0.02,
				),
				Pbind(\out, BusDef(\fx1))<>
				Ppar([
					Pbind(
						\instrument, \snapkickx,
						\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
						\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
						\isRest, Pseq([
							1,0,0,0,
						],inf).coin.not,
						//\dur, 1/8 * Pseq([4/3,2/3],inf),
						\dur, 1/16,
						\amp, 0.1,
					),
				]),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,1,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\out, BusDef(\fx2, \audio),
					\sustain, 0.1,
					\gain, 0.4,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						0,0,1,0, 0,0,1,1, 0,1,1,0, 0,0,1,0,
						0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
						0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
						0,0,1,0, 1,0,0,0, 0,0,1,0, 0,0,1,0,
						0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
						0,0,1,0, 0,0,1,0, 0,1,0,1, 0,0,1,0,
					],inf).coin.not,
					\out, BusDef(\fx_fil, \audio),
					\sustain, 0.1/2,
					\gain, 0.2,
					\dur, 1/16,
				)),
				Pmono(\fx_rhpf,
					\inbus, BusDef(\fx_fil, \audio),
					\hpf, ~pmodenv.(Pseq([17000,200,10],inf), 8),
					\dur, 1,
				),


				// treb

				Pbind(
					\instrument, \fmz1,
					\note, Pseq([
						-1,0,
					],inf).stutter(2),
					\legato, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf)*0.2,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,1,0.05) ],
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\hpfr, ~pmodenv.(Pseq([1,2,1/2,1/4],inf), 8),
					\octave, 6,
					\dur, 1/16,
					\out, Pseq([
						BusDef(\fx1, \audio),
					],inf).stutter(16*8),
					\amp, 0.1,
				),
				Pmono(\fx_chorus,
					\inbus, BusDef(\fx3, \audio),
					\fb, 2.9,
					\delay, 0.01,
					\modamp, 0.010,
					\modfreq, Pseq([
						0.1,
					],inf).stutter(8),
					\mix, 0.2,
					\dur, 1/4,
					\out, BusDef(\fx2, \audio),
				),
				Pbind(
					\instrument, \acidman,
					\note, Pseq([
						-2,0,0,1,
						0,12,1,1,
					],inf),
					\lpffac, ~pmodenv.(Pseq([62,42,71,100],inf), 4),
					\rq, ~pmodenv.(Pseq([0.2,0.8,0.4,0.05,0.1],inf), 5),
					\att, ~pmodenv.(Pseq([0.002,0.18,0.04],inf), 5),
					\out, BusDef(\fx3, \audio),
					\dur, 1/8,
					\amp, 0.1/2,
				),

				// fx

				Pmono(\ronordn,
					\inbus, BusDef(\fx1, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.01201 * Pseq([
						Pser([
							1,2,	
						],32*2),
						Pser([
							0.01,2
						],32*2),
					],inf),
					'delay', 0.000010394574653723,
					'delay2', 0.0000828221925227 * Pseq([
						1,1,1,50,
						1,1,1,100,
						1,1,1,200,
						1,1,1,300,
						1,1,1,1/100,
					],inf).stutter(8),
					'delay3', 0.00001,
					'distamp', 1.22682721311638 * Pseq([
						1,1.8,
					],inf),
					'distamp2', 001.0,
					'distamp3', 0.9904517086311,
					'shift', -0.0,
					'shift2', -0.1344537815126,
					'shift3', -0.4789915966387,
					'shiftmix', 0.1,
					'pitchlag', 1.0,
					'pitchmix', 0.0,
					'prelpf', 17000,
					'prehpf', 17,
					'lpf', 17000,
					'hpf', 17,
					'stereo', 0.0,
					'brffac', 0.60195390291997,
					'brfrqfac', 0.37940593233798,
					'fbdistamp', 0.47619047619048,
					'fbdistmix', 0.91176470588235,
					'postlpf', 17000,
					'posthpf', 17,
					'wetamp', 0.18504562572587,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,

					\eqmid1b, Pseq([300,2000,4000],inf).stutter(8*4),
					\eqrq1b, 0.6,
					\eqdb1b, 4.6,

					\dur, 1/8 * Pseq([1],inf),
				),
				Pmono(\ronordn,
					\inbus, BusDef(\fx2, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.000101,
					'delay', 0.0101000394574653723 * Pseq([1],inf),
					'delay2', 0.00010828221925227,
					'delay3', 0.00300001,
					'distamp', 33.72682721311638,
					'distamp2', 1.1,
					'distamp3', 0.0904517086311,
					'shift', -5.0,
					'shift2', -1.1344537815126,
					'shift3', -2.4789915966387,
					'shiftmix', 0,
					'pitchlag', 1.0,
					'pitchmix', 0.0,
					'prelpf', 17000,
					'prehpf', 17,
					'lpf', 17000,
					'hpf', 17,
					'stereo', 0.0,
					'brffac', 0.60195390291997,
					'brfrqfac', 0.37940593233798,
					'fbdistamp', 32.47619047619048,
					'fbdistmix', 0.91176470588235,
					'postlpf', 17000,
					'posthpf', 117,
					'wetamp', 0.18504562572587,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,

					\eqmid1b, 6000,
					\eqrq1b, 0.6,
					\eqdb1b, 1.6,

					\freq, 200,
					\dur, 1 * Pseq([1/4],inf),
					\out, BusDef(\fxstut, \audio),
				),
				Pmono(\fx_stutter,
					\freq, 200,
					\inbus, BusDef(\fxstut, \audio),
					\mix, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,1,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,1,1,1,
					],inf)/2,
					\time, Pstep(Pseq([
						1/16, 1/4,
						1/4, 1/4,
						1/8, 1/4,
						1/8, 1/4,
					],inf),1/4)/~t,
					\lag, Pwhite(0.01,0.1),
					\fb, 0.1,
					\dur, Pser([1/16],inf),
					\amp, 0.1,
				),
			])),
		])
	)).play;
)

(
	// filter
	Pdef(\part, Pdef(\teko_filter, 
		Ppar([
			Pseq([
				Pfindur(14, Ppar([
					// perc
				
					Pbind(
						\instrument, \phyhat4,
						\isRest, Pseq([
							1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,1,0,
							1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,1,0,
							1,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,1,0,
							1,0,0,0, 1,0,0,0, 1,0,0,1, 1,0,1,0,
							1,0,0,0, 1,0,0,0, 1,0,0,0, 1,1,0,1,
				
						],inf).coin.not,
						\sustain, Pseq([0.08,0.02],inf),
						\fac1, Pseq([
							0.4, 0.1, 0.2, 0.1,
						],inf),
						\dur, 1/16,
						//\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
						\pan, 0,
						\amp, 0.02,
					),
					Pbind(\out, BusDef(\fx1))<>
					Ppar([
						Pbind(
							\instrument, \snapkickx,
							\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
							\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
							\isRest, Pseq([
								1,0,0,0,
							],inf).coin.not,
							//\dur, 1/8 * Pseq([4/3,2/3],inf),
							\dur, 1/16,
							\amp, 0.1,
						),
					]),
					PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 5,
						\isRest, Pseq([
							0,0,0,0, 1,0,0,0,
							0,0,0,0, 1,0,0,0,
							0,0,0,0, 1,0,0,0,
							0,0,0,0, 1,0,0,0,
							0,1,0,0, 1,0,0,0,
							0,0,0,0, 1,0,0,0,
						],inf).coin.not,
						\out, BusDef(\fx2, \audio),
						\sustain, 0.1,
						\gain, 0.4,
						\dur, 1/8,
					)),
					PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 4,
						\isRest, Pseq([
							0,0,1,0, 0,0,1,1, 0,1,1,0, 0,0,1,0,
							0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
							0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
							0,0,1,0, 1,0,0,0, 0,0,1,0, 0,0,1,0,
							0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
							0,0,1,0, 0,0,1,0, 0,1,0,1, 0,0,1,0,
						],inf).coin.not,
						\out, BusDef(\fx_fil, \audio),
						\sustain, 0.1/2,
						\gain, 0.2,
						\dur, 1/16,
					)),
					Pmono(\fx_rhpf,
						\inbus, BusDef(\fx_fil, \audio),
						\hpf, ~pmodenv.(Pseq([17000,200,10],inf), 8),
						\dur, 1,
					),
				
				
				])),
				Event.silent(2),
			],inf),
				// treb

				Pbind(
					\instrument, \fmz1,
					\note, Pseq([
						-1,0,
					],inf).stutter(2),
					\legato, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf)*0.2,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,1,0.05) ],
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\hpfr, ~pmodenv.(Pseq([1,2,1/2,1/4],inf), 8),
					\octave, 6,
					\dur, 1/16,
					\out, Pseq([
						BusDef(\fx1, \audio),
					],inf).stutter(16*8),
					\amp, 0.1,
				),
				Pmono(\fx_chorus,
					\inbus, BusDef(\fx3, \audio),
					\fb, 2.9,
					\delay, 0.01,
					\modamp, 0.010,
					\modfreq, Pseq([
						0.1,
					],inf).stutter(8),
					\mix, 0.2,
					\dur, 1/4,
					\out, BusDef(\fx1, \audio),
				),
		Pmono(\blitz,
			\note, Pstep(Pseq([
				0,00,0,-1,
			],inf),1),
			\octave, Pseq([
				7,5,5,
			],inf).stutter(1),
			\dur, PdurStutter(Pseq([4],inf), Pseq([
				1,1/2,
			],inf)),
			\amp, 0.071 * Pseq([
				Pseq([
					1,1,1,1,
				],16+8),
				Pseq([
					1,0,1,0,
				],4),
				1,0, 1,1,
				1,0,0,0,
				1,1,0,1,
				0,0,0,0,
			],inf),
			\out, BusDef(\bus0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/kaspi.flac'),
			\bufnum, BufDef('voices/02_moeten.flac'),
			\out, BusDef(\bus0, \audio),
			\pos, Pseq([
				0,1,
				0,1.01,
			],inf)+ Pstep(Pseq([3,0.5,3,0.5,1,2],inf),2*1),
			\legato, Pseq([
				0.1,0.8
			],inf).stutter(32),
			\speed, Pseq([
				Pstep(Pseq([2,2],1),2),
				1,1.2,1.4,
			],inf),
			\dur, Pstep(Pseq([1,1/2,1/4],inf),8),
			\amp, 0.1,
		),
		Pmono(\fxringer,
			\inbus, BusDef(\bus0, \audio),
			\rq, 0.1,
			\lpf, Pseq([
				200,400,
				200,800,
			],inf)*2,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fx2, \audio),
		),

				// fx

				Pmono(\ronordn,
					\inbus, BusDef(\fx1, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.01201 * Pseq([
						Pser([
							1,2,	
						],32*2),
						Pser([
							0.01,2
						],32*2),
					],inf),
					'delay', 0.000010394574653723,
					'delay2', 0.0000828221925227 * Pseq([
						1,1,1,50,
						1,1,1,100,
						1,1,1,200,
						1,1,1,300,
						1,1,1,1/100,
					],inf).stutter(8),
					'delay3', 0.00001,
					'distamp', 1.22682721311638 * Pseq([
						1,1.8,
					],inf),
					'distamp2', 001.0,
					'distamp3', 0.9904517086311,
					'shift', -0.0,
					'shift2', -0.1344537815126,
					'shift3', -0.4789915966387,
					'shiftmix', 0.1,
					'pitchlag', 1.0,
					'pitchmix', 0.0,
					'prelpf', 17000,
					'prehpf', 17,
					'lpf', 17000,
					'hpf', 17,
					'stereo', 0.0,
					'brffac', 0.60195390291997,
					'brfrqfac', 0.37940593233798,
					'fbdistamp', 0.47619047619048,
					'fbdistmix', 0.91176470588235,
					'postlpf', 17000,
					'wetamp', 0.18504562572587,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,

					\eqmid1b, Pseq([300,2000,4000],inf).stutter(8*4),
					\eqrq1b, 0.6,
					\eqdb1b, 4.6,

					\dur, 1/8 * Pseq([1],inf),
					\out, BusDef(\filter, \audio),
				),
				Pmono(\fx_rhpf,
					\inbus, BusDef(\filter, \audio),
					\hpf, Pseq([
						~pmodenv.(Pseq([1,4,10,10,1000],1), 8)
					],inf),
					\dur, 1,
					\amp, 0.1,
				),
				Pmono(\ronordn,
					\inbus, BusDef(\fx2, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.14454369503751,
					'fb', 0.000101,
					'delay', 0.000000394574653723 * Pseq([10000],inf),
					'delay2', 0.00010828221925227,
					'delay3', 0.000001,
					'distamp', 1.12682721311638 * Pseq([
						Pseq([
							1,2,4,1, 4,4,4,4,
						],1),
						Pseq([
							1,2,1,4
						],2).stutter(4),
						Pseq([
							0,0,0,0,
							0,0,4,0,
							4,4,1,4,
							1,4,1,4,
						],1).stutter(1),
					],inf).stutter(2),
					'distamp2', 8.1,
					'distamp3', 1.0904517086311,
					'shift', -5.0,
					'shift2', -1.1344537815126,
					'shift3', -2.4789915966387,
					'shiftmix', 0,
					'pitchlag', 1.0,
					'pitchmix', 0.0,
					'prelpf', 17000,
					'prehpf', 17,
					'lpf', 17000,
					'hpf', 17,
					'stereo', 0.0,
					'brffac', 0.60195390291997,
					'brfrqfac', 0.37940593233798,
					'fbdistamp', 32.47619047619048,
					'fbdistmix', 0.91176470588235,
					'postlpf', 17000,
					'posthpf', 117,
					'wetamp', 0.18504562572587,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,

					\eqmid1b, 6000,
					\eqrq1b, 0.6,
					\eqdb1b, 1.6,

					\freq, 200,
					\dur, 1 * Pseq([1/4],inf),
					\out, BusDef(\fxstut, \audio),
				),
				Pmono(\fx_stutter,
					\freq, 200,
					\inbus, BusDef(\fxstut, \audio),
					\mix, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,1,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,1,1,1,
					],inf)/2,
					\time, Pstep(Pseq([
						1/16, 1/4,
						1/4, 1/4,
						1/8, 1/4,
						1/8, 1/4,
					],inf),1/4)/~t,
					\lag, Pwhite(0.01,0.1),
					\fb, 0.1,
					\dur, Pser([1/8],inf),
					\amp, 0.1,
					\out, BusDef(\filter2, \audio),
				),
				Pmono(\fx_rlpf,
					\inbus, BusDef(\filter2, \audio),
					\lpf, Pseq([
						~pmodenv.(Pseq([20000,20000,20000,12070,20],1), 8)
					],inf),
					\dur, 1,
					\amp, 0.1,
				),
		])
	)).play;
)

////////////////////////////// MAIN

(
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(8, Pdef(\teko_intro)),
		Pfindur(16, Pdef(\teko_simple)),
		Pfindur(32, Pdef(\teko_filter)),
		Pfindur(16, Pdef(\teko_hip)),
		Pfindur(16, Pdef(\teko_cutperc)),
	])
)).play;
)

/////////////////////////
(
SynthDef(\acidmanfail, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.2]), \xtrig.tr(1));
	freq = freq.lag(0.1);
	sig = LFSaw.ar(freq * [1,1.01, 2,1/2]);
	sig = RLPF.ar(sig, \lpfr.kr(3.8) * freq * env1, \rq.kr(0.001));
	sig = sig.tanh;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\acidpart, Pdef(\ploiiip, 
	Ppar([
		Pmono(\acidman,
			\note, Pseq([
				0,12,3,2,
				1,1,1,1,
			],inf),
			\octave, 3,
			\lpfr, ~pmodenv.(Pseq([1.5,8.0,4,1],inf), 8),
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
)
(
Pdef(\plop, 
	Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1,
)).play;
);
);

	

(
SynthDef(\acidman, {	
	arg out=0, gate=1,freq=250, amp=0.1;
	var env1, env2, pitch;
	var sig;

	pitch = freq.cpsmidi;
	pitch = Lag.kr(pitch, 0.12 * (1-Trig.kr(gate, 0.001)) * gate);
	env1 = EnvGen.ar(Env.new([0, 1.0, 0, 0], [0.001, 2.0, 0.04], [0, -4, -4], 2), gate, amp, doneAction:2);
	env2 = EnvGen.ar(Env.adsr(\att.kr(0.101), 0.8, 0, 0.8, \lpffac.kr(2), -4), gate);
	sig = LFPulse.ar(pitch.midicps * [1,1.001], 0.0, 0.51 * [1,1.02], 2, -1);

	sig = RLPF.ar(sig, ( (pitch + env2).midicps ).clip(20,20000), \rq.kr(0.3));
	sig = sig * env1;
	sig = sig /2;

	Out.ar(out, sig);
}).add; 
Pdef(\acidpart, Pdef(\ploiiip, 
	Ppar([
		//PmonoArtic(\acidman,
			//\note, Pseq([
				//0,12,3,2,
				//1,1,1,1,
			//],inf),
			//\legato, Pseq([
				//1,1,0.91,1,
				//1,1,1,0.56,
			//],inf),
			//\octave, 5,
			//\dur, 1/8,
			//\amp, 0.1,
		//),
		Pbind(
			\instrument, \acidman,
			\note, Pseq([
				-2,0,0,1,
				0,12,1,1,
			],inf),
			\lpffac, ~pmodenv.(Pseq([22,42,71,100],inf), 8),
			\rq, ~pmodenv.(Pseq([0.2,0.8,0.4,0.05],inf), 5),
			\att, ~pmodenv.(Pseq([0.002,0.8,0.04],inf), 5),
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
)

Pdef(\acidpart).clear
Pdef(\part).clear


/////////////////////////////


(
	// techno house!
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,1,0,
				1,1,1,0,
			],inf).coin.not,
			\dur, 1/8 * (1 + (0.33 * Pseq([-1,1],inf))),
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \chordb,
			\freq, Pdict(
				(
					up: ~pmodenv.(Pseq([0,1]*200+270,1), 1/8),
					down: ~pmodenv.(Pseq([1,0]*200+280,1), 1/8),
					down2: ~pmodenv.(Pseq([1,0]*1400+200,1), 1/8),
				),
				Pseq([
					\up, \up, \up, \down,
					\up, \up, \up, \down2,
				],inf)
			),
			\legato, 0.3,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.4,0.4) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1/2,
			\out, BusDef(\filter, \audio),
		),
		Pmono(\fx_rhpf,
			\inbus, BusDef(\filter, \audio),
			\freq, 200,
			\hpf, ~pmodenv.(Pseq([1,2000,10000,17004],inf), 2),
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fxdist, \audio),
		),
		Pmono(\fx_dist,
			\inbus, BusDef(\fxdist, \audio),
			\freq, 200,
			\mix, 1,
			\distamp, 100,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)


(
SynthDef(\fx_dist, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
)



(
SynthDef(\gritz, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = Duty.ar(0.001, 0, Dseq([
		1,0.3,10,20,
		1,1,1/100,
	],inf))*100;
	freq = Duty.ar( SinOsc.kr(1/3).range(0.01,0.1), 0, Dseq([
		freq, 100,1000,
freq,freq,freq,freq,
Drand([100,1000,1234],1),
freq,freq,freq,freq,
freq*1/2,freq*2/3,
Dseq([0.1,0.2,0.4,1,2]*freq,5),
	],inf));
	sig = Pulse.ar(freq * ( SinOsc.ar(sig1) * CuspN.ar(2.1) + 1 ));
	sig = sig + SinOsc.ar(freq * ( sig * 0.1 + 1 ),sig1/171.2 / [1,2,3,4]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono(\gritz,
			\freq, 200,
			\freq, ~pmodenv.(Pseq([100,2000,10000,84],inf), 8),
			\dur, 1,
			\amp, 0.1,
		);
	])
)).play;
);
Pdef(\part).clear


(
Ndef(\drone1, { arg freq=2000, pan=0, amp=0.1;
	var sig;
	var fspread;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig4 = Duty.kr(1/~t, 0, Dseq([
		1,0.1,0.01,0.001,
	],inf));
	sig4 = Duty.kr(sig4, 0, Dseq([
		1,0.1,0.01,0.001,
	],inf));
	sig1 = Duty.kr(sig4, 0, Dseq([
		1,30,2,4,0,
	],inf)).lag(1);
	sig2 = Duty.kr(sig4, 0, Dseq([
		1,30,2,4,0,
	],inf));
	sig3 = EnvGen.kr(Env([1,2,0.01],[4.1,5.8]).circle, 1);
	freq = Duty.kr(sig4, 0, Dseq([
		Dseq([
			90
		],16),
		90,1000,430,200,500,8700,
	],inf)).lag(sig3);
	fspread = SinOsc.ar([sig2,1,1/2]) * sig1; 
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * fspread + 1));
	sig = BPF.ar(sig, freq+100);
	sig = SinOsc.ar(freq*3/2 * ( SinOsc.ar(sig2*10) * sig3 + 1 ))*0.7 + sig; 
	sig = CombL.ar(sig, 0.1,1/(freq+100),0.1) + sig;
	sig = FreqShift.ar(sig, -100.01) + sig;
	sig = ( sig*\distamp.kr(100) ).tanh * \distpostamp.kr(1/2);
	sig = RLPF.ar(sig, \lpf.kr(1000) * sig3, \rq.kr(0.5));
	sig = LeakDC.ar(sig);
	sig = HPF.ar(sig,30);
	sig = sig * 4;
	//pan = pan + SinOsc.ar(1/4 * sig3, (1..sig.size)/100+1.9 * sig3, mul:sig3/3); 
	pan = pan + SinOsc.ar((1..sig.size)/100+0.1); 
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);



(
SynthDef(\drone1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env2 = EnvGen.kr(Env([1,2,1],[4.1,0.8]), 1);
	env1 = SinOsc.ar(freq) * 1 + 1 * env2 * 300;
	sig = SinOsc.ar(freq * ( SinOsc.ar( env1 ) * 1 + 1 ));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\drone2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env2 = EnvGen.kr(Env([1,0.2,1],[4.1,0.8]), 1);
	env1 = SinOsc.ar(freq) * 1 + 1 * env2 * 300;
	sig = LFSaw.ar(freq * ( SinOsc.ar( env1 ) * 1 + 1 ));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part, Pdef(\plop, 
	Ptpar([
		230, Ptpar([
		   	0,Pfindur(3, Pmono(\drone1,
		   		\freq, 200,
		   		\dur, 1,
		   		\amp, 0.1,
		   	)),
		   	2,Pfindur(3, Pmono(\drone2,
		   		\freq, 200,
		   		\dur, 1,
		   		\amp, 0.1,
		   	)),
		   	4,Pfindur(3, Pmono(\drone2,
		   		\freq, 3200,
		   		\dur, 1,
		   		\amp, 0.1,
		   	)),
		   	6,Pfindur(3, Pmono(\drone1,
		   		\freq, 3200,
		   		\dur, 1,
		   		\amp, 0.1,
		   	)),
		   ],1),
		0, Ptpar([
		   	0,Pfindur(1, Pmono(\drone1,
		   		\freq, 200,
		   		\dur, 1,
		   		\amp, 0.1,
		   	)),
		   	2,Pfindur(1, Pmono(\drone2,
		   		\freq, 200,
		   		\dur, 1,
		   		\amp, 0.1,
		   	)),
		   	4,Pfindur(1, Pmono(\drone2,
		   		\freq, 3200,
		   		\dur, 1,
		   		\amp, 0.1,
		   	)),
		   	6,Pfindur(1, Pmono(\drone1,
		   		\freq, 3200,
		   		\dur, 1,
		   		\amp, 0.1,
		   	)),
		   ],inf),
		0, Ppar([
			Pbind(
				\instrument, \drone1,
				\freq, Pwhite(100.0,2000),
				\sustain, 0.1,
				\dur, Pseq([2/3,1/5],inf),
				\amp, 0.1,
			),
			Pbind(
				\instrument, \drone2,
				\freq, Pwhite(100.0,2000),
				\sustain, 0.1,
				\dur, Pseq([4/5,3/4],inf),
				\amp, 0.1,
			),
		]),
	])
)).play;
);

Pdef(\part).clear
