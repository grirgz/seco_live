
~t = 185/4/60; TempoClock.default.tempo = ~t;
(
~master = {
	Ndef(\rdn).play;
	Ndef(\rdn2).play;
	Ndef(\rdn3).play;
}
)

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\lag, 0.04) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/12,
				\isRest, Pseq([
					1,0,0, 0,0,0, 0,0,0, 0,0,0,
					0,0,1, 1,0,0, 0,0,0, 0,0,0,
					1,0,0, 0,0,0, 0,0,0, 0,0,0,
					0,0,0, 1,0,0, 0,0,0, 0,0,0,
			
					1,0,0, 0,0,0, 0,0,0, 0,0,0,
					0,0,1, 1,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 12,
				\isRest, Pseq([
					0,0,0, 0,0,1, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,0,
				],inf).coin.not,
				\velamp, 1/9,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\sustain, 0.1/2,
				\dur, 1/12,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 16,
				\isRest, Pseq([
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
			
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
				],inf).coin.not,
				\velamp, 1/3,
				\sustain, 0.1,
				\dur, 1/12,
			)),
		]),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \basicbass,
			\freq, Pseq([
				70,70,70,72,
				70,~pmodenv.(Pseq([80,14],1), 1),70,70,
			],inf).stutter(12),
			\amp, 0.1,
			\legato, Pseq([
				Pseq([
					8,0,0, 0,0,0, 0,0,0, 0,0,0,
					0,0,0, 4,0,0, 0,0,0, 0,0,0,
				],3),
				//15,0,0, 0,0,0, 0,0,0, 0,0,0,
				//0,0,0, 9,0,0, 0,0,0, 0,0,0,

				//15,0,0, 0,0,0, 0,0,0, 0,0,0,
				//0,0,0, 9,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf),
			\dur, 1/12,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \kalimba,
			\note, Pseq([
				0,-1
			],inf),
			\isRest, Pseq([
				1,0,0,1, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.2,
			//\out, BusDef(\sendbus1, \audio),
			\out, BusDef(\sendbus2, \audio),
		),

		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 20,
			\speed, Pseq([
				Pseg( Pseq([ 1,1.02 ],4), 1/2),
				Pseg( Pseq([ 1/2,1.02 ],4), 1/2),
			],inf),
			\isRest, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 0.7,
			\sustain, 0.2,
			\dur, 1/12 * (1 + (0.16 * Pseq([-1,0,1],inf))),
			\out, BusDef(\sendbus2, \audio),
		)),
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			//\lag, 0.04,
			\out, BusDef(\sendbus3, \audio),
		) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/12,
				\isRest, Pseq([
					1,0,0, 0,0,0, 0,0,0, 0,0,0,
					0,0,1, 1,0,0, 0,0,0, 0,0,0,
					1,0,0, 0,0,0, 0,0,0, 0,0,0,
					0,0,0, 1,0,0, 0,0,0, 0,0,0,
			
					1,0,0, 0,0,0, 0,0,0, 0,0,0,
					0,0,1, 1,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 12,
				\isRest, Pseq([
					0,0,0, 0,0,1, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,0,
				],inf).coin.not,
				\velamp, 1/9,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\sustain, 0.1/2,
				\dur, 1/12,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 16,
				\isRest, Pseq([
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
			
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
				],inf).coin.not,
				\velamp, 1/3,
				\sustain, 0.1,
				\dur, 1/12,
			)),
		]),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,1,0,  0,0,1, 0,0,0,
				0,0,0, 1,0,0,  0,0,0, 0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \basicbass,
			\freq, Pseq([
				70,70,70,72,
				70,~pmodenv.(Pseq([80,14],1), 1),70,70,
			],inf).stutter(12),
			\amp, 0.1,
			\legato, Pseq([
				Pseq([
					8,0,0, 0,0,0, 0,0,0, 0,0,0,
					0,0,0, 1,0,0, 1,0,1, 0,1,0,
				],3),
				//Pseq([
					//8,0,0, 0,0,0, 0,0,0, 0,0,0,
					//0,0,0, 4,0,0, 0,0,0, 0,0,0,
				//],3),
				//15,0,0, 0,0,0, 0,0,0, 0,0,0,
				//0,0,0, 9,0,0, 0,0,0, 0,0,0,

				//15,0,0, 0,0,0, 0,0,0, 0,0,0,
				//0,0,0, 9,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf),
			\dur, 1/12,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \kalimba,
			\note, Pseq([
				0,-1
			],inf) + Pseq([
				[0,4+12,9],
				[0,3+12,11],
			],inf).stutter(8),
			\isRest, Pseq([
				1,0,0,1, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.2,
			//\out, BusDef(\sendbus1, \audio),
			\out, BusDef(\sendbus2, \audio),
		),

		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 20,
			\speed, Pseq([
				Pseg( Pseq([ 1,1.02 ],4), 1/2),
				Pseg( Pseq([ 1/2,1.02 ],4), 1/2),
			],inf),
			\isRest, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 0.7,
			\sustain, 0.2,
			\dur, 1/12 * (1 + (0.16 * Pseq([-1,0,1],inf))),
			\out, BusDef(\sendbus2, \audio),
		)),
		Pmono(\fx_stutter,
			\inbus, BusDef(\stutter, \audio),
			//\out, BusDef(\xxx, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				//0,0,0,0, 0,0,1,0,
				//0,1,0,0, 0,0,0,0,
				0,0,0, 0,0,0, 0,0,0,1,1,1,
				0,0,0, 1,1,1, 0,0,0,0,0,0,
			],inf),
			\rate, 1,
			\time, Pstep(Pseq([1/4,1/8,1/4],inf),1/4)/~t,
			\time, 1/12/~t * Pseq([1,1/2],inf),
			\dur, Pser([1/12],inf),
			\amp, 0.1,
		),
		
	])
)).play;
);


rdntostring	
~rdn_to_fbstring.()
ProtoDef(\rdn).fxdef
~rdn_to_fbstring.(RandDelayNetwork(ProtoDef(\rdn).fxdef)).editorInsert // with outer synthdef and preset pbind
(

		SynthDef(\rdnring, { arg out=0, gate=1;
			var sig;
			var sig2;
			var si, env = ();
			var si2;
			var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 

			thisThread.randSeed = 481835;

			sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
			si = sig;
			sig = { arg si, env;
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = (si * 10.rand * \distamp.kr).tanh / 2;
si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
}.value(si, env);

			//sig2 = HPF.ar(sig, \hpf.kr(14), \hprq.kr(0.1));
			//sig2 = LPF.ar(sig2, \lpf.kr(19900), \lprq.kr(1));
			//sig = SelectX.ar(\pfmix.kr(0.0), [sig, sig2]);
			sig = Limiter.ar(sig);
			LocalOut.ar(sig);

			//sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(0));
			//sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(0));
			//sig2 = HPF.ar(sig, \posthpf.kr(14), \posthprq.kr(0.1));
			//sig2 = LPF.ar(sig2, \postlpf.kr(19900), \postlprq.kr(1));
			//sig = SelectX.ar(\postpfmix.kr(0.0), [sig, sig2]);
			sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
			sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
			sig = sig * \gain.kr(1);
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
			Out.ar(out, sig);

		}).add;

		
Pbind(
	'wet10', 1.0,
	'mix', 0.77791010151461,
	'gain', 3.8141670022365,
	'fb', 0.0001,
	'delay', 0.00011674193588235,
	'delay2', 0.70589400866187,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 14.304154254852,
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
)

		
);

(
	Pdef(\part, Pdef(\zed, 
		Ppar([
			Pbind(\out, BusDef(\sendbus2, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
					\dur, 1/8,
					\isRest, Pseq([
						1,0,0,1, 1,0,0,0,
						1,0,0,0, 1,0,0,0,
						1,0,0,1, 0,0,1,0,
						1,0,0,0, 1,0,0,0,
						1,0,0,0, 1,0,0,1,
					],inf).coin.not,
					\amp, 0.1,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,1,0, 0,1,0,0,
					],inf).coin.not,
					\sustain, 0.071,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.01) ],
					],inf),
					\gain, 0.2,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 0,0,1,0,
						0,0,0,0, 0,0,1,1,
						1,0,1,1, 0,1,0,1,
					],inf).coin.not,
					\sustain, 0.041,
					\speed, Pseq([
						Pseq([
							1
						],8*3),
						Pseq((1..8).reverse/4)
					],inf),
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.01) ],
					],inf),
					\gain, 0.1,
					\dur, 1/16,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,0,1, 1,0,1,1,
						0,0,0,0, 0,0,0,0,
						1,1,1,0, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.041,
					\speed, Pseq([
						Pseq([
							1
						],8*3),
						Pseq((1..8).reverse/4)
					],inf),
					\speed, 4,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.01) ],
					],inf),
					\gain, 0.1,
					\dur, 1/16,
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 8,
					\isRest, Pseq({[
						1,1,1,1, 1,1,1,1,
						1,0,1,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0,
						0,0,1,0, 0,0,1,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\sustain, 0.1,
					\gain, 0.2 * Pseq([
						1,0.5,0.1,
					],inf),
					\dur, 1/16,
				)),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,1,
					],inf).coin.not,
					\sustain, 0.05,
					\fac1,0.1,
					\dur, 1/8,
					\amp, 0.01 * Pseq([1,0,0.7],inf),
				),
			]),
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/12,
				\isRest, Pseq([
					1,0,0, 0,1,0,  0,0,1, 0,0,0,
					0,0,0, 1,0,0,  0,0,0, 0,0,0,
				],inf).coin.not,
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
			),
			Pbind(
				\instrument, \basicbass,
				\freq, Pseq([
					70,70,70,72,
					70,~pmodenv.(Pseq([80,14],1), 1),70,70,
				],inf).stutter(12),
				\amp, 0.1,
				\legato, Pseq([
					Pseq([
						8,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 1,0,0, 1,0,1, 0,1,0,
					],3),
					//Pseq([
					//8,0,0, 0,0,0, 0,0,0, 0,0,0,
					//0,0,0, 4,0,0, 0,0,0, 0,0,0,
					//],3),
					//15,0,0, 0,0,0, 0,0,0, 0,0,0,
					//0,0,0, 9,0,0, 0,0,0, 0,0,0,

					//15,0,0, 0,0,0, 0,0,0, 0,0,0,
					//0,0,0, 9,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,0,
				],inf),
				\dur, 1/12,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\sendbus1, \audio),
			),
			Pmono(\rdnring,
				\inbus, BusDef(\sendbus1, \audio),
				\dur, 1,
			) <>
			Pbind(
				'wet10', 1.0,
				'mix', 0.77791010151461,
				'gain', 0.8141670022365,
				'fb', 0.0001,
				'delay', 0.70011674193588235,
				'delay2', 0.90589400866187,
				'shift', 0.1,
				'shift2', 0.1,
				'distamp', 44.304154254852,
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
			),
			Pmono(\rdnring,
				\inbus, BusDef(\sendbus2, \audio),
				\dur, 1/8,
			) <>
			Pbind(
				'wet10', 1.0,
				'mix', 0.57791010151461,
				'gain', 1.8141670022365,
				'fb', 0.0001,
				'delay', 0.80011674193588235,
				'delay2', 0.000589400866187 * Pseq([
					1,1000,10,1,10,1,
				],inf),
				'shift', 0,
				'shift2', 0,
				'distamp', 1.304154254852,
				'pitchlag', 1.0,
				'pitchmix', 0.0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 1700,
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
			),

		])
	)).play;
);

(
	Pdef(\part, Pdef(\zed, 
		Ppar([
			Pbind(\out, BusDef(\sendbus2, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
					\dur, 1/8,
					\isRest, Pseq([
						1,0,0,0, 0,0,1,0,
						0,1,0,0, 0,0,0,0,
					],inf).coin.not,
					\amp, 0.1,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,1,0, 0,1,0,0,
						0,0,1,0, 1,0,0,1,
					],inf).coin.not,
					\sustain, 0.071,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.01) ],
					],inf),
					\gain, 0.2,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,1, 0,0,1,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,1,
					],inf).coin.not,
					\sustain, 0.041,
					\speed, Pseq([
						Pseq([
							1
						],8*3),
						Pseq((1..8).reverse/4)
					],inf),
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.01) ],
					],inf),
					\gain, 0.1,
					\dur, 1/16,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,0,1, 1,0,1,1,
						0,0,0,0, 0,0,0,0,
						1,1,1,0, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.041,
					\speed, Pseq([
						Pseq([
							1
						],8*3),
						Pseq((1..8).reverse/4)
					],inf),
					\speed, 4,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.01) ],
					],inf),
					\gain, 0.1,
					\dur, 1/16,
					\isRest, true,
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 8,
					\isRest, Pseq([
						1,0,1,1, 1,0,1,0,
					],inf).coin.not,
					\sustain, 0.1,
					\gain, 0.2 * Pseq([
						1,0.5,0.1,
					],inf),
					\dur, 1/16,
				)),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,1,
					],inf).coin.not,
					\sustain, 0.05,
					\fac1,0.1,
					\dur, 1/8,
					\amp, 0.01 * Pseq([1,0,0.7],inf),
				),
			]),
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/12,
				\isRest, Pseq([
					1,0,0, 0,1,0,  0,0,1, 0,0,0,
					0,0,0, 1,0,0,  0,0,0, 0,0,0,
				],inf).coin.not,
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
			),
			Pbind(
				\instrument, \basicbass,
				\freq, Pseq([
					70,70,70,72,
					70,~pmodenv.(Pseq([80,14],1), 1),70,70,
				],inf).stutter(12),
				\amp, 0.1,
				\legato, Pseq([
					Pseq([
						8,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 1,0,0, 1,0,1, 0,1,0,
					],3),
					//Pseq([
					//8,0,0, 0,0,0, 0,0,0, 0,0,0,
					//0,0,0, 4,0,0, 0,0,0, 0,0,0,
					//],3),
					//15,0,0, 0,0,0, 0,0,0, 0,0,0,
					//0,0,0, 9,0,0, 0,0,0, 0,0,0,

					//15,0,0, 0,0,0, 0,0,0, 0,0,0,
					//0,0,0, 9,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,0,
				],inf),
				\dur, 1/12,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\sendbus1, \audio),
			),
			Pmono(\rdnring,
				\inbus, BusDef(\sendbus1, \audio),
				\dur, 1,
			) <>
			Pbind(
				'wet10', 1.0,
				'mix', 0.77791010151461,
				'gain', 0.8141670022365,
				'fb', 0.0001,
				'delay', 0.70011674193588235,
				'delay2', 0.90589400866187,
				'shift', 0.1,
				'shift2', 0.1,
				'distamp', 44.304154254852,
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
			),
			Pmono(\rdnring,
				\inbus, BusDef(\sendbus2, \audio),
				\dur, 1/8,
			) <>
			Pbind(
				'wet10', 1.0,
				'mix', 0.47791010151461,
				'gain', 1.5141670022365,
				'fb', 0.0001,
				'delay', 0.00011674193588235,
				'delay2', 0.000589400866187 * Pseq([
					1,1000,10,1,10,1,
				],inf),
				'shift', 0,
				'shift2', 0,
				'distamp', 4.304154254852,
				'pitchlag', 1.0,
				'pitchmix', 0.0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 1700,
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
			),

		])
	)).play;
);

(
	Pdef(\part, Pdef(\zed, 
		Ppar([
			Pbind(\out, BusDef(\sendbus2, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
					\dur, 1/8,
					\isRest, Pseq([
						1,0,1,0, 0,0,1,0,
						0,0,0,0, 0,0,0,1,
					],inf).coin.not,
					\amp, 0.1,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,0,1,0,
					],inf).coin.not,
					\sustain, 0.071,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.01) ],
					],inf),
					\gain, 0.2,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,1, 0,0,1,0,
						0,0,0,0, 0,0,0,0,
						0,1,1,0, 0,0,0,0,
						0,0,0,0, 0,0,1,1,
					],inf).coin.not,
					\sustain, 0.041,
					\speed, Pseq([
						Pseq([
							1
						],8*3),
						Pseq((1..8).reverse/4)
					],inf),
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.01) ],
					],inf),
					\gain, 0.1,
					\dur, 1/16,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,0,1, 1,0,1,1,
						0,0,0,0, 0,0,0,0,
						1,1,1,0, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.041,
					\speed, Pseq([
						Pseq([
							1
						],8*3),
						Pseq((1..8).reverse/4)
					],inf),
					\speed, 4,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.01) ],
					],inf),
					\gain, 0.1,
					\dur, 1/16,
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
			]),
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/12,
				\isRest, Pseq([
					1,0,0, 0,1,0,  0,0,1, 0,0,0,
					0,0,0, 1,0,0,  0,0,0, 0,0,0,
				],inf).coin.not,
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
			),
			Pbind(
				\instrument, \basicbass,
				\freq, Pseq([
					70,70,70,72,
					70,~pmodenv.(Pseq([80,14],1), 1),70,70,
				],inf).stutter(12),
				\amp, 0.1,
				\legato, Pseq([
					Pseq([
						8,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 1,0,0, 1,0,1, 0,1,0,
					],3),
					//Pseq([
					//8,0,0, 0,0,0, 0,0,0, 0,0,0,
					//0,0,0, 4,0,0, 0,0,0, 0,0,0,
					//],3),
					//15,0,0, 0,0,0, 0,0,0, 0,0,0,
					//0,0,0, 9,0,0, 0,0,0, 0,0,0,

					//15,0,0, 0,0,0, 0,0,0, 0,0,0,
					//0,0,0, 9,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,0,
				],inf),
				\dur, 1/12,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\sendbus1, \audio),
			),
			Pmono(\rdnring,
				\inbus, BusDef(\sendbus1, \audio),
				\dur, 1,
			) <>
			Pbind(
				'wet10', 1.0,
				'mix', 0.77791010151461,
				'gain', 0.8141670022365,
				'fb', 0.0001,
				'delay', 0.70011674193588235,
				'delay2', 0.90589400866187,
				'shift', 0.1,
				'shift2', 0.1,
				'distamp', 44.304154254852,
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
			),
			Pmono(\rdnring,
				\inbus, BusDef(\sendbus2, \audio),
				\dur, 1/8,
			) <>
			Pbind(
				'wet10', 1.0,
				'mix', 0.57791010151461,
				'gain', 1.5141670022365,
				'fb', 0.0001,
				'delay', 0.80011674193588235,
				'delay2', 0.000589400866187 * Pseq([
					1,1000,10,1,10,1,
				],inf),
				'shift', 0,
				'shift2', 0,
				'distamp', 1.304154254852,
				'pitchlag', 1.0,
				'pitchmix', 0.0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 1700,
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
			),

		])
	)).play;
);

(
	Pdef(\part, Pdef(\zed, 
		Ppar([
			Pbind(\out, BusDef(\sendbus2, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
					\dur, 1/8,
					\isRest, Pseq([
						1,0,1,0, 0,0,1,0,
						0,0,0,0, 0,0,0,1,
					],inf).coin.not,
					\amp, 0.1,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,0,1,0,
					],inf).coin.not,
					\sustain, 0.071,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.01) ],
					],inf),
					\gain, 0.2,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,1, 0,0,1,0,
						0,0,0,0, 0,0,0,0,
						0,1,1,0, 0,0,0,0,
						0,0,0,0, 0,0,1,1,
					],inf).coin.not,
					\sustain, 0.041,
					\speed, Pseq([
						Pseq([
							1
						],8*3),
						Pseq((1..8).reverse/4)
					],inf),
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.01) ],
					],inf),
					\gain, 0.1,
					\dur, 1/16,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,0,1, 1,0,1,1,
						0,0,0,0, 0,0,0,0,
						1,1,1,0, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.041,
					\speed, Pseq([
						Pseq([
							1
						],8*3),
						Pseq((1..8).reverse/4)
					],inf),
					\speed, 4,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.01) ],
					],inf),
					\gain, 0.1,
					\dur, 1/16,
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
			]),
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/12,
				\isRest, Pseq([
					1,0,0, 0,1,0,  0,0,1, 0,0,0,
					0,0,0, 1,0,0,  0,0,0, 0,0,0,
				],inf).coin.not,
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
			),
			Pbind(
				\instrument, \basicbass,
				\freq, Pseq([
					70,70,70,72,
					70,~pmodenv.(Pseq([80,14],1), 1),70,70,
				],inf).stutter(12),
				\amp, 0.1,
				\legato, Pseq([
					Pseq([
						8,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 1,0,0, 1,0,1, 0,1,0,
					],3),
					//Pseq([
					//8,0,0, 0,0,0, 0,0,0, 0,0,0,
					//0,0,0, 4,0,0, 0,0,0, 0,0,0,
					//],3),
					//15,0,0, 0,0,0, 0,0,0, 0,0,0,
					//0,0,0, 9,0,0, 0,0,0, 0,0,0,

					//15,0,0, 0,0,0, 0,0,0, 0,0,0,
					//0,0,0, 9,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,0,
				],inf),
				\dur, 1/12,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\sendbus1, \audio),
			),
			Pmono(\rdnring,
				\inbus, BusDef(\sendbus1, \audio),
				\dur, 1,
			) <>
			Pbind(
				'wet10', 1.0,
				'mix', 0.77791010151461,
				'gain', 0.8141670022365,
				'fb', 0.0001,
				'delay', 0.70011674193588235,
				'delay2', 0.90589400866187,
				'shift', 0.1,
				'shift2', 0.1,
				'distamp', 44.304154254852,
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
			),
			Pmono(\rdnring,
				\inbus, BusDef(\sendbus2, \audio),
				\dur, 1/8,
			) <>
			Pbind(
				'wet10', 1.0,
				'mix', 0.57791010151461,
				'gain', 01.8141670022365,
				'fb', 0.0001,
				'delay', 0.80011674193588235,
				'delay2', 0.000589400866187 * Pseq([
					1,1000,10,1,10,1,
				],inf),
				'shift', 0,
				'shift2', 0,
				'distamp', 1.304154254852,
				'pitchlag', 1.0,
				'pitchmix', 0.0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 1700,
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
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.75714285714286,
				'gain', 0.5344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000100001231 * Pseq([
					1,2,
				],inf).stutter(1),
				'delay2', 0.000100543560101,
				'distamp', 1.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 170,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 170,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 1,
			),

		])
	)).play;
);

////

(
	Pdef(\part, Pdef(\zed, 
		Ppar([
			Pbind(\out, BusDef(\sendbus2, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
					\dur, 1/8,
					\isRest, Pseq([
						1,0,1,0, 0,0,0,0,
						1,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\amp, 0.1,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						Pseq([
							0,0,0,0, 1,0,0,1,
							0,0,1,0, 0,0.51,0,0.51,
						],3),
						Pseq([
							0,0,0,0, 1,0,0,1,
							0,1,1,0, 0,0,0,0,
						],1),
					],inf).coin.not,
					\sustain, 0.071 * Pseq([
						1,1,2,
						1,1,4,
					],inf),
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.01) ],
					],inf),
					\gain, 0.2,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 9,
					\isRest, Pseq([
						Pser([
							0,0,0.5,0, 0.5,0.5,0,0.5,
							0,1,1,1, 1,0,0,1,
							0,0.61,0.51,0, 0,0,0.51,0,
						],16*3*2),
						Pser([
							0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,1,0, 1,1,1,1, 0,0,0,0,
						],16*1*2),
					],inf).coin.not,
					\speed, Pseq([
						Pseq([
							1,1,1,
						],8),
						~pmodenv.(Pseq([1,2],1), 1/4),
					],inf),
					\sustain, 0.071 * Pseq([
						1/2
					],inf),
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.01) ],
					],inf),
					\gain, 0.2,
					\dur, 1/16,
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
			]),
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/12,
				\isRest, Pseq([
					1,0,0, 0,1,0,  0,0,1, 0,0,0,
					0,0,0, 1,0,0,  0,0,0, 0,0,0,
				],inf).coin.not,
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
			),
			Pbind(
				\instrument, \basicbass,
				\freq, Pseq([
					70,70,70,72,
					70,~pmodenv.(Pseq([80,14],1), 1),70,70,
				],inf).stutter(12),
				\amp, 0.1,
				\legato, Pseq([
					Pseq([
						8,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 1,0,0, 1,0,1, 0,1,0,
					],3),
					//Pseq([
					//8,0,0, 0,0,0, 0,0,0, 0,0,0,
					//0,0,0, 4,0,0, 0,0,0, 0,0,0,
					//],3),
					//15,0,0, 0,0,0, 0,0,0, 0,0,0,
					//0,0,0, 9,0,0, 0,0,0, 0,0,0,

					//15,0,0, 0,0,0, 0,0,0, 0,0,0,
					//0,0,0, 9,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,0,
				],inf),
				\dur, 1/12,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\sendbus1, \audio),
			),
			Pmono(\rdnring,
				\inbus, BusDef(\sendbus1, \audio),
				\dur, 1,
			) <>
			Pbind(
				'wet10', 1.0,
				'mix', 0.77791010151461,
				'gain', 0.8141670022365,
				'fb', 0.0001,
				'delay', 0.70011674193588235,
				'delay2', 0.90589400866187,
				'shift', 0.1,
				'shift2', 0.1,
				'distamp', 4.304154254852,
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
			),
			Pmono(\rdnring,
				\inbus, BusDef(\sendbus2, \audio),
				\dur, 1/8,
			) <>
			Pbind(
				'wet10', 1.0,
				'mix', 0.57791010151461,
				'gain', 01.8141670022365,
				'fb', 0.0001,
				'delay', 0.80011674193588235,
				'delay2', 0.000589400866187 * Pseq([
					1,1000,10,1,10,1,
				],inf),
				'shift', 0,
				'shift2', 0,
				'distamp', 1.304154254852,
				'pitchlag', 1.0,
				'pitchmix', 0.0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 1700,
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
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.75714285714286,
				'gain', 0.5344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000100001231 * Pseq([
					1,2,
				],inf).stutter(1),
				'delay2', 0.000100543560101,
				'distamp', 1.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 170,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 170,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 1,
			),

		])
	)).play;
);

(
	Pdef(\part, Pdef(\zed, 
		Ppar([
			Pbind(\out, BusDef(\sendbus2, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
					\dur, 1/8,
					\isRest, Pseq([
						1,0,1,0, 0,0,0,0,
						1,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\amp, 0.1,
				),
				PatKitDef(\bat).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,1,0,1, 0,0,1,0,

						0,0,0,0, 1,0,0,0,
						0,1,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 0,1,0,1,
					],inf).coin.not,
					\sustain, 0.1,
					\velamp, 1/3,
					\dur, 1/8,
				)),
				PatKitDef(\bat).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						0,0,1,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,1,0,1, 0,0,1,0,
						0,0,0,0, 0,0,1,1,
						1,0,1,1, 1,0,1,1,
					],inf).coin.not,
					\sustain, 0.071,
					\speed, Pseq([1,0.9],inf),
					\velamp, 1/18,
					\dur, 1/16,
				)),
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('voices/feynman.flac'),
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,1,1, 1,1,1,1,
						0,0,0,0, 0,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,0,1,0, 1,0,1,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\pos, 0.3* Pseg(Pseq([2,1],inf),8),
					\speed, ~pmodenv.(Pseq([1,1.2,1,1.04],inf), 1/3),
					\sustain, 0.01,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.01) ],
					],inf),

					\dur, 1/16,
					\gain, 1/4,
				),
				PatKitDef(\rim).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						Pseq([
							0,0,0,0, 1,0,1,0,
							0,0,0,0, 1,0,1,0,
							0,1,0,0, 1,0,0,1,
						],3),
						Pseq([
							0,0,0,0, 1,0,0,1,
							0,1,1,0, 0,0,0,0,
						],1),
					],inf).coin.not,
					\sustain, 0.071 * Pseq([
						1,1,2,
						1,1,4,
					],inf),
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.01) ],
					],inf),
					\gain, 0.2,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 9,
					\isRest, Pseq([
						Pser([
							0,0,0,0, 0,0,0,0,
							1,0,0,0, 1,0,0,1,
							0,0,0,0, 0,0,0,0,
							1,1,1,1, 1,0,0,1,
						],16*3*2),
						Pser([
							0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,1,0, 1,1,1,1, 0,0,0,0,
						],16*1*2),
					],inf).coin.not,
					\speed, Pseq([
						Pseq([
							1,1,1,
						],8),
						~pmodenv.(Pseq([1,2],1), 1/4),
					],inf),
					\sustain, 0.071 * Pseq([
						1/2
					],inf),
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.01) ],
					],inf),
					\gain, 0.2,
					\dur, 1/16,
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
			]),
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/12,
				\isRest, Pseq([
					1,0,0, 0,1,0,  0,0,1, 0,0,0,
					0,0,0, 1,0,0,  0,0,0, 0,0,0,
				],inf).coin.not,
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
			),
			Pbind(
				\instrument, \basicbass,
				\freq, Pseq([
					70,70,70,72,
					70,~pmodenv.(Pseq([80,14],1), 1),70,70,
				],inf).stutter(12),
				\amp, 0.1,
				\legato, Pseq([
					Pseq([
						8,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 1,0,0, 1,0,1, 0,1,0,
					],3),
					//Pseq([
					//8,0,0, 0,0,0, 0,0,0, 0,0,0,
					//0,0,0, 4,0,0, 0,0,0, 0,0,0,
					//],3),
					//15,0,0, 0,0,0, 0,0,0, 0,0,0,
					//0,0,0, 9,0,0, 0,0,0, 0,0,0,

					//15,0,0, 0,0,0, 0,0,0, 0,0,0,
					//0,0,0, 9,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,0,
				],inf),
				\dur, 1/12,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\sendbus1, \audio),
			),
			Pmono(\rdnring,
				\inbus, BusDef(\sendbus1, \audio),
				\dur, 1,
			) <>
			Pbind(
				'wet10', 1.0,
				'mix', 0.77791010151461,
				'gain', 0.8141670022365,
				'fb', 0.0001,
				'delay', 0.70011674193588235,
				'delay2', 0.90589400866187,
				'shift', 0.1,
				'shift2', 0.1,
				'distamp', 4.304154254852,
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
			),
			Pmono(\rdnring,
				\inbus, BusDef(\sendbus2, \audio),
				\dur, 1/8,
			) <>
			Pbind(
				'wet10', 1.0,
				'mix', 0.57791010151461,
				'gain', 01.8141670022365,
				'fb', 0.0001,
				'delay', 0.80011674193588235,
				'delay2', 0.000589400866187 * Pseq([
					1,1000,10,1,10,1,
				],inf),
				'shift', 0,
				'shift2', 0,
				'distamp', 1.304154254852,
				'pitchlag', 1.0,
				'pitchmix', 0.0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 1700,
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
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.75714285714286,
				'gain', 0.5344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000100001231 * Pseq([
					1,2,
				],inf).stutter(1),
				'delay2', 0.000100543560101,
				'distamp', 1.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 170,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 170,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 1,
			),

		])
	)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
					\dur, 1/8,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\amp, 0.1,
				),
				PatKitDef(\bat).asPattern(Pbind(
					\kitIndex, 5,
					\speed, 0.97,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\sustain, 0.2,
					\velamp, 1/3,
					\dur, 1/8,
				)),
				PatKitDef(\bat).asPattern(Pbind(
					\kitIndex, 5,
					\speed, 0.97 * Pseq([
						1,
					],inf),
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,1,1, 0,0,1,0,
						0,1,0,0, 0,0,0,0,
						0,0,1,0, 0,1,0,1,
						1,1,0,1, 1,1,0,1,
					],inf).coin.not,
					\sustain, 0.071 * Pseq([
						1,0.8,
					],inf),
					\velamp, 1/13* Pseq([
						1,0.8,
					],inf),
					\dur, 1/16,
				)),
				PatKitDef(\bat).asPattern(Pbind(
					\kitIndex, 8,
					\isRest, Pseq([
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 0,0,1,0,
						1,0,1,0, 1,0,0,1,
					],inf).coin.not,
					\sustain, 0.1,
					\velamp, 1/7,
					\dur, 1/8,
				)),
				PatKitDef(\bat).asPattern(Pbind(
					\kitIndex, 8,
					\isRest, Pseq([
						1,1,1,0, 0,0,1,0,
						0,1,0,0, 1,0,0,0,
						1,0,1,0,
					],inf).coin.not,
					\sustain, 0.1,
					\velamp, 1/15,
					\dur, 1/16,
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
		
	])
)).play;
);

//////////////


(
Ndef(\zed).put(0, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var phase;
	var bufnum = BufDef(\amen, "vipere/amenbreak.wav");
	phase = Phasor.ar(1, 1,0,BufFrames.kr(bufnum));
	phase = SinOsc.ar(freq, mul:\pmul.kr(100)) * LFNoise1.ar(\noisefreq.kr(1/20)!30).range(0.0,\noiserange.kr(1.0));
	sig = BufRd.ar(2, bufnum, phase+\ppos.kr(10000));
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * LFNoise1.kr(1/2!30).range(1.0,2.0), \rq.kr(0.5));
	sig = sig.mean;
	sig.debug("sig");
	//sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed).put(1, \pset -> 
		Pbind(
			\freq, Pseq([
				83,83,273,
				80,80,253,
				83,83,273,
				80,380,153,
			],inf),
			\dur, Pseq( rrand(0.2,0.4!3).normalizeSum ,inf)*1,
		)
).play;
);


Ndef(\zed2).sources = Ndef(\zed).sources
Ndef(\zed).clear
Ndef(\zed).edit
Ndef(\zed2).edit
Ndef(\zed2).play
(
Ndef(\zed2).put(1, \pset -> 
		Pbind(
			\freq, Pseq([
				1530,1530,1017,1221
			],inf).stutter(3),
			\lpfr, 0.1 * Pseq([1,1,10],inf),
			\dur, Pseq( rrand(0.2,0.4!3).normalizeSum ,inf)*1/2,
		)
).play;
);

Ndef(\zed).clear
Ndef(\zed).edit
