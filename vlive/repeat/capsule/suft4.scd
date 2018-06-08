~t = 158/4/60; TempoClock.default.tempo = ~t; // sufferer 158
(
SynthDef(\clave, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = LFTri.ar(freq);
	sig1 = BPF.ar(sig1, \bpf.kr(1000), \rq.kr(1));

	sig2 = SinOsc.ar(\freq2.kr(300));
	sig2 = BPF.ar(sig2, \bpf2.kr(1000), \rq2.kr(1));

	sig = SelectX.ar(\sigmix.kr(0.5), [sig1, sig2]);
	sig = Decay.ar(sig, Trig.ar(1), \decay.kr(0.4));
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.1) ),gate,doneAction:2);
	sig = HPF.ar(sig, \hpf.kr(70));
	//sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\star, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var env1;
	var fspread;
	env1 = EnvGen.kr(Env([1,2,1],[1.7,0.8]), 1);
	fspread = 0.0007 + Rand(0,0.007);
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread + 1));
	sig = sig * ( sig/(sig+1.1)*50 * env1 ).clip(0.5);
	sig1 = sig * (sig.abs > Rand(0.1,0.7));
	sig = SelectX.ar( EnvGen.kr(Env([0,1,0],[0.1+Rand(0,2.0),0.1+Rand(0,2.0)]), 1), [sig, sig1]);
	sig = sig * 2;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	sig = sig /10;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\starlet, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var env1;
	var fspread;
	env1 = EnvGen.kr(Env([1,20,1],[1.7,0.8]), 1);
	fspread = 0.0007 + Rand(0,0.007)* env1;
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread + 1) );
	sig1 = sig * ( sig/(sig+1.1)*50 * env1 ).clip(0.5);
	sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);
	sig = sig * 2;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	sig = sig /10;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
	~master.();
Pdef(\part, Pdef(\bleu_intro, 
	Ppar([
		//Pbind(\out, BusDef(\fx2, \audio)) <>
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,0, 1,0,1, 
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\fac1, Pseq([
					1.1,
				],inf),
				\dur, 1/12,
				\out, BusDef(\fx2, \audio),
				\pan, 0,
				\amp, ~pmodenv.(Pseq([0,0,0,0,0,0,0.01,0.041],inf), 1),
			),
		Pbind(
			\instrument, Pseq([\starlet,\star, Prand([\starlet,\star],2)],inf).stutter(1),
			\note, Pseq([
				3,2,1,0,


			],inf),
			\scale, Scale.minor,
			\octave, 4,
			\dur, 6/3,
			\lag, Pseq([
				Pseq([0,0],8) / ~t,
				Pseq([0,1/4 + Pwhite(0,0.01,1)],4) / ~t,
				Pseq([0,0],4) / ~t,
				Pseq([0,1/2 + Pwhite(0,0.01,1)],4) / ~t,
				Pseq([0,0],4) / ~t,
				Pseq([0,1/8 + Pwhite(0,0.01,1)],4) / ~t,
				Pseq([0,0],Pwhite(4,8,1)) / ~t,
				Pseq([0,1/8 + Pwhite(0,0.05,1)],Pwhite(4,8,1)) / ~t,
			],inf),
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,2.0) ],
					[ Env.adsr(0.005,0.1,1.8,1.0) ],
					[ Env.adsr(0.005,0.1,1.8,0.5) ],
				],1),
			],inf),
			\legato, 0.2,
			\isRest, Pseq([
				1,0,0,0,
				1,0,1,1,
			],inf).coin.not,
			\isRest, false,
			\out, BusDef(\fx2, \audio),
		),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx2, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.04454369503751,
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1/12,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.000000394574653723 * Pseq([
							1,100000,1,1,
						],inf).stutter(8),
						'delay2', 0.4000100828221925227 * Pseg(Pseq([1],inf),8),
						'delay3', 0.00001001 * Pseq([
							1,
						],inf).stutter(8*2),
						'distamp', 0.62682721311638,
						'distamp2', 1.1,
						'distamp3', 0.9904517086311,
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.1,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx2, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.04454369503751,
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1*1,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.000000394574653723,
						'delay2', 0.0002110828221925227 * Pseg(Pseq([1],inf),8),
						'delay3', 0.00000001 * Pseq([1,1,1,1*1000],inf).stutter(8),
						'distamp', 2.62682721311638,
						'distamp2', 1.1,
						'distamp3', 1.9904517086311,
						\delay, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
	]),
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\bleu_draft1, 
	Ppar([
		//Pbind(\out, BusDef(\fx2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,1,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
				],inf).coin.not,
				//\dur, 1/8 * Pseq([4/3,2/3],inf),
				\dur, 1/12/2,
				\amp, 0.2,
				\out, BusDef(\fx2),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.121,
				\speed, 0.97,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,1,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 1,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,1, 0,0,1, 1,0,1,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.071,
				\speed, 0.97,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,0, 1,0,1, 
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\fac1, Pseq([
					0.1, 0.1, 0.1,
				],inf),
				\dur, 1/12,
				\out, BusDef(\fx1, \audio),
				\pan, 0,
				\amp, 0.02,
			),
		
		
			/////////////////
		
		]),
		Pbind(
			\instrument, Pseq([\starlet,\star, Prand([\starlet,\star],2)],inf).stutter(1),
			\note, Pseq([
				3,2,1,


			],inf),
			\scale, Scale.minor,
			\octave, 4,
			\dur, 1/3,
			\lag, Pseq([
				Pseq([0,0],8) / ~t,
				Pseq([0,1/4 + Pwhite(0,0.01,1)],4) / ~t,
				Pseq([0,0],4) / ~t,
				Pseq([0,1/2 + Pwhite(0,0.01,1)],4) / ~t,
				Pseq([0,0],4) / ~t,
				Pseq([0,1/8 + Pwhite(0,0.01,1)],4) / ~t,
				Pseq([0,0],Pwhite(4,8,1)) / ~t,
				Pseq([0,1/8 + Pwhite(0,0.05,1)],Pwhite(4,8,1)) / ~t,
			],inf),
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,2.0) ],
					[ Env.adsr(0.005,0.1,1.8,1.0) ],
					[ Env.adsr(0.005,0.1,1.8,0.5) ],
				],1),
			],inf),
			\legato, 0.2,
			\isRest, Pseq([
				1,0,0,0,
				1,0,1,1,
			],inf).coin.not,
			\isRest, false,
			\out, BusDef(\fx2, \audio),
		),
			Pbind(
				\instrument, \fmbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,0,1,
				],inf).stutter(8),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 5,
				\modamp, 0.4,
				\legato, Pseq([
						4,0,0, 0,0,1,
						4,0,0, 0,0,1,
						2,0,1, 2,0,1,
						4,0,0, 0,0,0,
				],inf)*0.8,
				\legato, Pseq([
						2,0,0, 0,0,1,
						2,0,0, 0,0,1,
						1,0,1, 2,0,1,
						2,0,0, 0,0,0,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \fmz1,
				\chaos, 1.93500,
				\note, Pseq([
					0,0,1,
					7,7,1,
				],inf).stutter(8)+[0,7]+ Pseq([
					0,0,1, 0,0,0, 0,-1,0, 0,
				],inf),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 5,
				\modamp, 0.4,
				\legato, Pseq([
					4,0,0, 0,0,0, 4,0,0, 0,0,1,
					4,0,0, 0,0,1, 3,0,0, 2,0,1,
					4,0,0, 0,0,0, 4,0,0, 0,0,1,
					3,0,0, 1,0,1, 3,0,1, 2,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \toto,
				\note, Pseq([
					4,0,0, 0,0,0,
					4,0,0, 4,0,0,
				],inf).stutter(1) + [0,3,0+11],
				//\detune, -10,
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\legato, Pseq([
					1,0,1, 1,0,1,
					1,0,0, 1,0,0,
				],inf)*0.8,
				\octave, 5,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\amp, 0.1,
				\isRest, true,
			),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx1, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.04454369503751,
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1/12,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.000000394574653723 * Pseq([
							1,100000,1,1,
						],inf).stutter(8),
						'delay2', 0.4000100828221925227 * Pseg(Pseq([1],inf),8),
						'delay3', 0.00001001 * Pseq([
							1,
						],inf).stutter(8*2),
						'distamp', 0.62682721311638,
						'distamp2', 1.1,
						'distamp3', 0.9904517086311,
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.1,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx2, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.04454369503751,
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1*1,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.000000394574653723,
						'delay2', 0.0100110828221925227 * Pseg(Pseq([1],inf),8),
						'delay3', 0.00000001 * Pseq([1,1,1,1*1000],inf).stutter(8),
						'distamp', 2.62682721311638,
						'distamp2', 1.1,
						'distamp3', 1.9904517086311,
						\delay, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
	]),
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\bleu_end, 
	Ppar([
		//Pbind(\out, BusDef(\fx2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					//1,0,0, 1,0,0,  0,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,0,0,
					//0,0,0, 0,0,0,  0,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,0,0,
					//0,0,0, 0,0,0,  0,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,0,0,
					//0,0,0, 0,0,0,  0,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,0,0,

					1,0,0, 1,0,0,  0,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,     1,0,1, 1,0,0,  0,0,0, 0,0,0,
				],inf).coin.not,
				//\dur, 1/8 * Pseq([4/3,2/3],inf),
				\dur, 1/12,
				\amp, 0.2,
				\out, BusDef(\fx1),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.121,
				\speed, 0.97,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
				\isRest, true,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					//0,0,1, 1,0,0,  1,0,0, 0,0,0,
					//0,0,0, 0,0,0,  0,0,0, 0,0,0,
					//0,0,0, 0,0,0,  0,0,0, 0,0,0,
					//0,0,0, 0,0,0, 0,0,0, 0,0,1,
					//0,0,0, 0,0,0,  0,0,0, 0,0,0,
					//0,0,0, 0,0,0,  0,0,0, 0,0,0,
					//0,0,0, 1,0,0,  0,0,0, 0,0,0,
					//0,0,0, 0,0,1, 0,0,1, 1,0,1,

					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,1,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 1,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.071,
				\speed, 0.97,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,0, 1,0,1, 
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\fac1, Pseq([
					0.1, 0.1, 0.1,
				],inf),
				\dur, 1/12,
				\out, BusDef(\fx1, \audio),
				\pan, 0,
				\amp, 0.02 * Pseg(Pseq([1,0],1),8),
			),
		
		
			/////////////////
		
		]),
		Pbind(
			\instrument, Pseq([\starlet,\star, Prand([\starlet,\star],2)],inf).stutter(1),
			\note, Pseq([
				3,2,1,


			],inf),
			\scale, Scale.minor,
			\octave, 4,
			\dur, 1/3,
			\lag, Pseq([
				Pseq([0,0],8) / ~t,
				Pseq([0,1/4 + Pwhite(0,0.01,1)],4) / ~t,
				Pseq([0,0],4) / ~t,
				Pseq([0,1/2 + Pwhite(0,0.01,1)],4) / ~t,
				Pseq([0,0],4) / ~t,
				Pseq([0,1/8 + Pwhite(0,0.01,1)],4) / ~t,
				Pseq([0,0],Pwhite(4,8,1)) / ~t,
				Pseq([0,1/8 + Pwhite(0,0.05,1)],Pwhite(4,8,1)) / ~t,
			],inf),
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,2.0) ],
					[ Env.adsr(0.005,0.1,1.8,1.0) ],
					[ Env.adsr(0.005,0.1,1.8,0.5) ],
				],1),
			],inf),
			\legato, 0.2,
			\isRest, Pseq([
				1,0,0,0,
				1,0,1,1,
			],inf).coin.not,
			\isRest, false,
			\out, BusDef(\fx1, \audio),
		),
			Pbind(
				\instrument, \fmbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,0,1,
				],inf).stutter(8),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 5,
				\modamp, 0.4,
				\legato, Pseq([
						4,0,0, 0,0,1,
						4,0,0, 0,0,1,
						2,0,1, 2,0,1,
						4,0,0, 0,0,0,
				],inf)*0.8,
				\legato, Pseq([
						2,0,0, 0,0,1,
						2,0,0, 0,0,1,
						1,0,1, 2,0,1,
						2,0,0, 0,0,0,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \fmz1,
				\chaos, 1.93500,
				\note, Pseq([
					0,0,1,
					7,7,1,
				],inf).stutter(8)+[0,7]+ Pseq([
					0,0,1, 0,0,0, 0,-1,0, 0,
				],inf),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 5,
				\modamp, 0.4,
				\legato, Pseq([
					4,0,0, 0,0,0, 4,0,0, 0,0,1,
					4,0,0, 0,0,1, 3,0,0, 2,0,1,
					4,0,0, 0,0,0, 4,0,0, 0,0,1,
					3,0,0, 1,0,1, 3,0,1, 2,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \toto,
				\note, Pseq([
					4,0,0, 0,0,0,
					4,0,0, 4,0,0,
				],inf).stutter(1) + [0,3,0+11],
				//\detune, -10,
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\legato, Pseq([
					1,0,1, 1,0,1,
					1,0,0, 1,0,0,
				],inf)*0.8,
				\octave, 5,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\amp, 0.1,
				\isRest, true,
			),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx1, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751 * Pseg(Pseq([1,1],1),8),
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1/12,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.800000394574653723 * Pseq([
							1,1,1,1,
						],inf).stutter(8),
						'delay2', 0.4000100828221925227 * Pseg(Pseq([1],inf),8),
						'delay3', 0.80001001 * Pseq([
							1,
						],inf).stutter(8*2),
						\delay3, ~pmodsynth.({ LFNoise1.kr(1).range(0.00001,0.1) }),
						'distamp', 0.62682721311638,
						'distamp2', 1.1,
						'distamp3', 0.9904517086311,
						\distamp3, ~pmodsynth.({ LFNoise1.kr(1).range(0.1,5.1) }),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.1,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						\elpf, ~pmodenv.(Pseq([19000,2000,1000,200,20],inf), 4),
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
	]),
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\bleu_draft2, 
	Ppar([
		//Pbind(\out, BusDef(\fx2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,1,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
				],inf).coin.not,
				//\dur, 1/8 * Pseq([4/3,2/3],inf),
				\dur, 1/12/2,
				\amp, 0.2,
				\out, BusDef(\fx2),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.121,
				\speed, 0.97,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,1,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.071,
				\speed, 0.97,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,0, 1,0,1, 
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\fac1, Pseq([
					0.1, 0.1, 0.1,
				],inf),
				\dur, 1/12,
				\out, BusDef(\fx1, \audio),
				\pan, 0,
				\amp, 0.02,
			),
		
		
			/////////////////
		
		
	// play

		
		
		
		]),
		Pbind(
			\instrument, Pseq([\starlet,\star, Prand([\starlet,\star],2)],inf).stutter(1),
			\note, Pseq([
				3,2,1,
			],inf),
			\scale, Scale.minor,
			\octave, 4,
			\dur, 1/3,
			\lag, Pseq([
				Pseq([0,0],8) / ~t,
				Pseq([0,1/4 + Pwhite(0,0.01,1)],4) / ~t,
				Pseq([0,0],4) / ~t,
				Pseq([0,1/2 + Pwhite(0,0.01,1)],4) / ~t,
				Pseq([0,0],4) / ~t,
				Pseq([0,1/8 + Pwhite(0,0.01,1)],4) / ~t,
				Pseq([0,0],Pwhite(4,8,1)) / ~t,
				Pseq([0,1/8 + Pwhite(0,0.05,1)],Pwhite(4,8,1)) / ~t,
			],inf),
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,2.0) ],
					[ Env.adsr(0.005,0.1,1.8,1.0) ],
					[ Env.adsr(0.005,0.1,1.8,0.5) ],
				],1),
			],inf),
			\legato, 0.2,
			\isRest, Pseq([
				1,0,0,0,
				1,0,1,1,
			],inf).coin.not,
			\isRest, false,
			\out, BusDef(\fx1, \audio),
		),
			Pbind(
				\instrument, \fmbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,0,1,
				],inf).stutter(8),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 5,
				\modamp, 0.4,
				\legato, Pseq([
						4,0,0, 0,0,1,
						4,0,0, 0,0,1,
						2,0,1, 2,0,1,
						4,0,0, 0,0,0,
				],inf)*0.8,
				\legato, Pseq([
						2,0,0, 0,0,1,
						2,0,0, 0,0,1,
						1,0,1, 2,0,1,
						2,0,0, 0,0,0,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \fmz1,
				\chaos, 1.93500,
				\note, Pseq([
					0,
				],inf).stutter(8)+ Pseq([
					[0,8],
					[0,9],
				],inf)+ Pseq([
					0,0,0.1, 0.2,0.4,0, 0,-1,0, 0,
				],inf),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 6,
				\modamp, 0.4,
				//\adsr, Pseq([
						//Prout({ arg ev;
							//Pseq((1..100)/20,1).asStream.collect({ arg val;
								//val.debug("va");
								//Env.adsr(0.1,0.1,0.8,val).yield;
							//});
							//ev
						//}),
				//],1).trace,
				\rel, Pseq([
					Pseg(Pseq([0,2],inf),8),
				],1),
				\adsr, Pseq([
					Pfunc({ arg ev;
						[ Env.adsr(0.1,0.1,0.8,ev[\rel]) ]
					}),
				],inf),
				\legato, Pseq([
					1,0,0,
					0,0,0,
					1,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx2, \audio),
				\dur, 1/12,
				\amp, 0.1 * Pseg(Pseq([1,0.1],inf),8),
				\isRest, true,
			),
			Pbind(
				\instrument, \toto,
				\note, Pseq([
					4,0,0, 0,0,0,
					4,0,0, 4,0,0,
				],inf).stutter(1) + [0,3,0+11],
				//\detune, -10,
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\legato, Pseq([
					1,0,1, 1,0,1,
					1,0,0, 1,0,0,
				],inf)*0.8,
				\octave, 5,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\amp, 0.1,
				\isRest, true,
			),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx1, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751,
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1/12,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.000000394574653723 * Pseq([
							1,100000,1,1,
						],inf).stutter(8),
						'delay2', 0.4000100828221925227 * Pseg(Pseq([1],inf),8),
						'delay3', 0.00001001 * Pseq([
							1,
						],inf).stutter(8*2),
						'distamp', 0.62682721311638,
						'distamp2', 1.1,
						'distamp3', 0.9904517086311,
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.1,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx2, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751,
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1/13,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.000000394574653723,
						'delay2', 0.0000110828221925227 * Pseg(Pseq([1],inf),8),
						'delay3', 0.10000001 * Pseq([1,1,1,1/10],inf),
						'distamp', 12.62682721311638,
						'distamp2', 11.1,
						'distamp3', 1.9904517086311,
						\delay, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
	]),
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\bleu_draft3, 
	Ppar([
		//Pbind(\out, BusDef(\fx2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,1,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
				],inf).coin.not,
				//\dur, 1/8 * Pseq([4/3,2/3],inf),
				\dur, 1/12/2,
				\amp, 0.2,
				\out, BusDef(\fx2),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.121,
				\speed, 0.97,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,1,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,1, 1,0,1,
					0,0,0, 0,0,1, 0,0,0, 0,0,1,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,1, 1,0,1,
					0,0,1, 0,0,1, 1,0,0, 0,0,1,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.071,
				\speed, 0.97,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,0, 1,0,1, 
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\fac1, Pseq([
					0.1, 0.1, 0.1,
				],inf),
				\dur, 1/12,
				\out, BusDef(\fx1, \audio),
				\pan, 0,
				\amp, 0.02,
			),
		
		
			/////////////////
		
		
	// play

		
		
		
		]),
		Pbind(
			\instrument, Pseq([\starlet,\star, Prand([\starlet,\star],2)],inf).stutter(1),
			\note, Pseq([
				3,2,1,
			],inf),
			\scale, Scale.minor,
			\octave, 4,
			\dur, 1/3,
			\lag, Pseq([
				Pseq([0,0],8) / ~t,
				Pseq([0,1/4 + Pwhite(0,0.01,1)],4) / ~t,
				Pseq([0,0],4) / ~t,
				Pseq([0,1/2 + Pwhite(0,0.01,1)],4) / ~t,
				Pseq([0,0],4) / ~t,
				Pseq([0,1/8 + Pwhite(0,0.01,1)],4) / ~t,
				Pseq([0,0],Pwhite(4,8,1)) / ~t,
				Pseq([0,1/8 + Pwhite(0,0.05,1)],Pwhite(4,8,1)) / ~t,
			],inf),
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,2.0) ],
					[ Env.adsr(0.005,0.1,1.8,1.0) ],
					[ Env.adsr(0.005,0.1,1.8,0.5) ],
				],1),
			],inf),
			\legato, 0.2,
			\isRest, Pseq([
				1,0,0,0,
				1,0,1,1,
			],inf).coin.not,
			\isRest, false,
			\out, BusDef(\fx1, \audio),
		),
			Pbind(
				\instrument, \fmbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,0,1,
				],inf).stutter(8),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 5,
				\modamp, 0.4,
				\legato, Pseq([
						4,0,0, 0,0,1,
						4,0,0, 0,0,1,
						2,0,1, 2,0,1,
						4,0,0, 0,0,0,
				],inf)*0.8,
				\legato, Pseq([
						2,0,0, 0,0,1,
						2,0,0, 0,0,1,
						1,0,1, 2,0,1,
						2,0,0, 0,0,0,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \fmz1,
				\chaos, 1.93500,
				\note, Pseq([
					Pser([
						0,7,-6,
					],12),
				],inf).stutter(8)+ Pseq([
					[0,8],
					[0,9],
				],inf)+ Pseq([
					0,0,0.1, 0.2,0.4,
				],inf),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, Pseq([
					Pser([
						6
					],12 * 6),
					Pser([
						7,
					],12 * 2),
				],inf).stutter(8),
				\modamp, 0.4,
				\rel, Pseq([
					Pseg(Pseq([0,0.72],inf),8),
				],1),
				\adsr, Pseq([
					Pfunc({ arg ev;
						[ Env.adsr(0.1,0.1,0.8,ev[\rel]) ]
					}),
				],inf),
				\legato, Pseq([
					Pser([
						1,0,0,
						0,0,0,
						1,0,1,
					],12*6),
					Pser([
						9*10,0,0,
						0,0,0,
						0,0,0,
					],12*2),
				],inf)*0.1,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx2, \audio),
				\dur, 1/12,
				\amp, 0.1 * Pseg(Pseq([1,0.1],inf),8),
			),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx1, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751,
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1/12,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.000000394574653723 * Pseq([
							1,100000,1,1,
						],inf).stutter(8),
						'delay2', 0.4000100828221925227 * Pseg(Pseq([1],inf),8),
						'delay3', 0.00001001 * Pseq([
							1,
						],inf).stutter(8*2),
						'distamp', 0.62682721311638,
						'distamp2', 1.1,
						'distamp3', 0.9904517086311,
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.1,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx2, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751,
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1/13,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.000000394574653723,
						'delay2', 0.0000110828221925227 * Pseg(Pseq([1],inf),8),
						'delay3', 0.10000001 * Pseq([1,1,1,1/10],inf),
						'distamp', 12.62682721311638,
						'distamp2', 11.1,
						'distamp3', 1.9904517086311 * Pstep(Pseq([1,1,1,1/4],inf),2),
						\delay, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
	]),
)).play;
);

(
	// flat
	~master.();
Pdef(\part, Pdef(\bleu_draft4, 
	Ppar([
		//Pbind(\out, BusDef(\fx2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,1,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
				],inf).coin.not,
				//\dur, 1/8 * Pseq([4/3,2/3],inf),
				\dur, 1/12/2,
				\amp, 0.2,
				\out, BusDef(\fx2),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.121,
				\speed, 0.97,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,1,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.071,
				\speed, 0.97,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,0, 1,0,1, 
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\fac1, Pseq([
					0.1, 0.1, 0.1,
				],inf),
				\dur, 1/12,
				\out, BusDef(\fx1, \audio),
				\pan, 0,
				\amp, 0.02,
			),
		
		
			/////////////////
		
		
	// play

		
		
		
		]),
		Pbind(
			\instrument, Pseq([\starlet,\star, Prand([\starlet,\star],2)],inf).stutter(1),
			\note, Pseq([
				[9,4,3],
				[0,13],
				[1,-12],
				3,2,1,
			],inf),
			\octave, 5,
			\dur, 1/3,
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,2.0) ],
					[ Env.adsr(0.005,0.1,1.8,1.0) ],
					[ Env.adsr(0.005,0.1,1.8,0.5) ],
				],1),
			],inf),
			\legato, 0.2,
			\legato, Pseq([
					3,0,0, 1,1,0,
			],inf) * 0.2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			//\out, BusDef(\fx2, \audio),
		),
			Pbind(
				\instrument, \fmbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,0,1,
				],inf).stutter(8),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 5,
				\modamp, 0.4,
				\legato, Pseq([
						4,0,0, 0,0,1,
						4,0,0, 0,0,1,
						2,0,1, 2,0,1,
						4,0,0, 0,0,0,
				],inf)*0.8,
				\legato, Pseq([
						2,0,0, 0,0,1,
						2,0,0, 0,0,1,
						1,0,1, 2,0,1,
						2,0,0, 0,0,0,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \fmz1,
				\chaos, 1.93500,
				\note, Pseq([
					0,0,1,
					7,7,1,
				],inf).stutter(8)+[0,7]+ Pseq([
					0,0,1, 0,0,0, 0,-1,0, 0,
				],inf),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 5,
				\modamp, 0.4,
				\legato, Pseq([
					4,0,0, 0,0,0, 4,0,0, 0,0,1,
					4,0,0, 0,0,1, 3,0,0, 2,0,1,
					4,0,0, 0,0,0, 4,0,0, 0,0,1,
					3,0,0, 1,0,1, 3,0,1, 2,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \toto,
				\note, Pseq([
					4,0,0, 0,0,0,
					4,0,0, 4,0,0,
				],inf).stutter(1) + [0,3,0+11],
				//\detune, -10,
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\legato, Pseq([
					1,0,1, 1,0,1,
					1,0,0, 1,0,0,
				],inf)*0.8,
				\octave, 5,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\amp, 0.1,
				\isRest, true,
			),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx1, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751,
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1/12,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.000000394574653723 * Pseq([
							1,100000,1,1,
						],inf).stutter(8),
						'delay2', 0.4000100828221925227 * Pseg(Pseq([1],inf),8),
						'delay3', 0.00001001 * Pseq([
							1,
						],inf).stutter(8*2),
						'distamp', 0.62682721311638,
						'distamp2', 1.1,
						'distamp3', 0.9904517086311,
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.1,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx2, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751,
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1*13,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.000000394574653723,
						'delay2', 0.0010110828221925227 * Pseg(Pseq([1],inf),8),
						'delay3', 0.00000001 * Pseq([1,1,1,1/10],inf),
						'distamp', 1.62682721311638,
						'distamp2', 2.1,
						'distamp3', 1.9904517086311,
						//\delay3, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
	]),
)).play;
);

(
	// verse1
	~master.();
Pdef(\part, Pdef(\bleu_draft5, 
	Ppar([
		//Pbind(\out, BusDef(\fx2, \audio)) <>
		Ppar([
			Pbind(
				\time, Ptime().round.trace,
				\dur, 8,
				\isRest, true,
			),
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,1,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,1,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,1,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  0.5,0,0, 0,1,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,1,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
				],inf).coin.not,
				//\dur, 1/8 * Pseq([4/3,2/3],inf),
				\dur, 1/12/2,
				\amp, 0.2,
				\out, BusDef(\fx2),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.121,
				\speed, 0.97,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 1,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					1,0,1, 1,0,0,  0,0,1, 1,0,1,
					//0,0,0, 0,0,0,  0,0,0, 0,0,0,
					//0,0,0, 0,0,0, 0,0,0, 0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.071,
				\speed, 0.97,
				\gain, 0.2,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,0, 1,0,1, 
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\fac1, Pseq([
					0.1, 0.1, 0.1,
				],inf),
				\dur, 1/12,
				\out, BusDef(\fx1, \audio),
				\pan, 0,
				\amp, 0.02,
			),
		
		
			/////////////////
		
		
	// play

		
		
		
		]),
		Pbind(
			\instrument, Pseq([\starlet,\star, Prand([\starlet,\star],2)],inf).stutter(1),
			\note, Pseq([
				[9,4,3],
				[0,13],
				[1,-12],
				3,2,1,
			],inf),
			\octave, 5,
			\dur, 1/3,
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,2.0) ],
					[ Env.adsr(0.005,0.1,1.8,1.0) ],
					[ Env.adsr(0.005,0.1,1.8,0.5) ],
				],1),
			],inf),
			\legato, 0.2,
			\legato, Pseq([
					3,0,0, 1,1,0,
			],inf) * 0.2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\fx3, \audio),
		),
			Pbind(
				\instrument, \fmbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,0,1,
				],inf).stutter(8),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 5,
				\modamp, 0.4,
				\legato, Pseq([
						4,0,0, 0,0,1,
						4,0,0, 0,0,1,
						2,0,1, 2,0,1,
						4,0,0, 0,0,0,
				],inf)*0.8,
				\legato, Pseq([
						2,0,0, 0,0,1,
						2,0,0, 0,0,1,
						1,0,1, 2,0,1,
						2,0,0, 0,0,0,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \fmz1,
				\chaos, 1.93500,
				\note, Pseq([
					0,0,1,
					7,7,1,
				],inf).stutter(8)+[0,7]+ Pseq([
					0,0,1, 0,0,0, 0,-1,0, 0,
				],inf),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 5,
				\modamp, 0.4,
				\legato, Pseq([
					4,0,0, 0,0,0, 4,0,0, 0,0,1,
					4,0,0, 0,0,1, 3,0,0, 2,0,1,
					4,0,0, 0,0,0, 4,0,0, 0,0,1,
					3,0,0, 1,0,1, 3,0,1, 2,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \toto,
				\note, Pseq([
					4,0,0, 0,0,0,
					4,0,0, 4,0,0,
				],inf).stutter(1) + [0,3,0+11],
				//\detune, -10,
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\legato, Pseq([
					1,0,1, 1,0,1,
					1,0,0, 1,0,0,
				],inf)*0.8,
				\octave, 5,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\amp, 0.1,
				\isRest, true,
			),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx1, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751,
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1/12,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.000000394574653723 * Pseq([
							1,100000,1,1,
						],inf).stutter(8),
						'delay2', 0.4000100828221925227 * Pseg(Pseq([1],inf),8),
						'delay3', 0.00001001 * Pseq([
							1,
						],inf).stutter(8*2),
						'distamp', 0.62682721311638,
						'distamp2', 1.1,
						'distamp3', 0.9904517086311,
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.1,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
					Pmono(\chorusdistlim,
						\inbus, BusDef(\fx1, \audio, 2),
						\freq, 200,
						\distamp, 20,
						\distpostamp, 1/1,
						\fb, 0.404,
						\distmix, 1,
						\delay, 0.00011,
						\modfreq, 0.004*~t,
						\modamp, 0.0001,
						\hpf, 500,
						\gain, 0.1/2,
						\mix, 1.0,
						\dur, 1,
						\amp, 0.1,
					),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx2, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751,
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1*13,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.000000394574653723,
						'delay2', 0.0000110828221925227 * Pstep(Pseq([
							100,1,
							200, 50,
						],inf),8),
						'delay3', 0.02000001 * Pseq([
							1,1,1,1/10,
							Pseq([
								1,1,1,1/10,
							],1)/100,
						],inf),
						'distamp', 1.62682721311638,
						'distamp2', 2.1,
						'distamp3', 1.9904517086311,
						//\delay3, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx3, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751 * Pseq([
							0,1,1,1,
							1,1,1,1,
						],inf).stutter(8*8),
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							13,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*8),
						'delay', 0.000000394574653723,
						'delay2', 0.0000110828221925227 * Pstep(Pseq([
							100,1,
							200, 50,
						],inf),8),
						'delay3', 0.02000001 * Pseq([
							1,1,1,1/10,
							Pseq([
								1,1,1,1/10,
							],1)/100,
						],inf),
						'distamp', 1.62682721311638,
						'distamp2', 2.1,
						'distamp3', 1.9904517086311,
						//\delay3, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 10030,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
	]),
)).play;
);

(
	// verse1 fucked up, should last 32+8
	~master.();
Pdef(\part, Pdef(\bleu_draft6, 
	Ppar([
		//Pbind(\out, BusDef(\fx2, \audio)) <>
		Ppar([
			Pbind(
				\time, Ptime().round.trace,
				\dur, 8,
				\isRest, true,
			),
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,1,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,1,0, 1,0,0, 0,0,0, 0,0,0, 1,0,0, 0,0,0, 0,1,0, 
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,1,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0, 1,0,0, 0,1,0, 0,0,0, 0,0,0, 0,0,0, 0,1,0, 
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,1,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,1,0, 1,0,0, 0,0,0, 0,0,0, 1,0,0, 0,0,0, 0,1,0, 
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,1,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,1,0, 0,0,1, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,1,0, 
				],inf).coin.not,
				//\dur, 1/8 * Pseq([4/3,2/3],inf),
				\dur, 1/12/2,
				\amp, 0.2,
				\out, BusDef(\fx2),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.121,
				\speed, 0.97,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 1,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 1,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						1,0,1, 1,0,0,  0,0,1, 1,0,1,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 1,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 1,0,0,  0,0,0, 0,0,0,
						
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 1,0,1,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
						1,0,0, 1,0,1,  0,0,1, 1,0,1,
					],1),
					Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,1,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 1,0,0,  0,0,1, 1,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,1,0,  0,0,0, 0,0,0,
						0,0,0, 1,0,0,  0,0,1, 1,0,0,
						1,0,0, 0,0,0,  0,0,1, 0,1,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,1,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 1,0,0,  0,0,1, 1,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,1,  0,0,0, 0,0,0,
						0,0,0, 0,0,1,  0,0,0, 1,1,0,
						0,0,1, 0,0,0,  0,0,0, 1,0,1,

					],1),
					//0,0,0, 0,0,0,  0,0,0, 0,0,0,
					//0,0,0, 0,0,0, 0,0,0, 0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.071,
				\speed, 0.97,
				\gain, 0.2,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,0, 1,0,1, 1,0,0, 1,0,1, 1,0,0, 1,0,1, 1,0,0, 1,0,1, 
					1,0,1, 1,0,1, 1,0,0, 1,0,1, 1,0,0, 1,0,1, 1,0,0, 1,0,1, 
					1,0,0, 1,0,0, 1,0,1, 1,0,1, 1,0,0, 1,0,1, 1,0,0, 1,0,1, 
					1,0,1, 1,0,1, 0,0,0, 1,1,1, 1,0,0, 1,0,1, 1,0,0, 1,0,1, 
					1,0,0, 1,0,1, 1,0,0, 1,0,1, 1,0,1, 1,0,0, 1,1,1, 1,0,0, 
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\fac1, Pseq([
					0.1, 0.1, 0.1,
				],inf),
				\dur, 1/12,
				\out, BusDef(\fx1, \audio),
				\pan, 0,
				\amp, 0.02,
			),
		
		
			/////////////////
		
		
	// play

		
		
		
		]),
		Pbind(
			\instrument, Pseq([\starlet,\star, Prand([\starlet,\star],2)],inf).stutter(1),
			\note, Pseq([
				[9,4,3],
				[0,13],
				[1,-12],
				3,2,1,
			],inf),
			\octave, 5,
			\dur, 1/3,
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,2.0) ],
					[ Env.adsr(0.005,0.1,1.8,1.0) ],
					[ Env.adsr(0.005,0.1,1.8,0.5) ],
				],1),
			],inf),
			\legato, 0.2,
			\legato, Pseq([
					3,0,0, 1,1,0,
			],inf) * 0.2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\fx3, \audio),
		),
			Pbind(
				\instrument, \fmbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,0,1,
				],inf).stutter(8),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 5,
				\modamp, 0.4,
				\legato, Pseq([
						4,0,0, 0,0,1,
						4,0,0, 0,0,1,
						2,0,1, 2,0,1,
						4,0,0, 0,0,0,
				],inf)*0.8,
				\legato, Pseq([
						2,0,0, 0,0,1,
						2,0,0, 0,0,1,
						1,0,1, 2,0,1,
						2,0,0, 0,0,0,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \fmz1,
				\chaos, 1.93500,
				\note, Pseq([
					3,2,1
				],inf).stutter(8)+0+ Pseq([
					0,0,0,0,-4,12,-12
				],inf),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 6,
				\modamp, 0.4,
				\legato, Pseq([
					Pser([
						0
					],12*8),
					Pser([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,1, 1,0,1,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,1,0, 0,0,1,
						0,0,0, 0,0,0, 1,0,0, 1,0,1,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,1, 1,0,1,
					],inf),
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx3, \audio),
				\dur, 1/12,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \toto,
				\note, Pseq([
					4,0,0, 0,0,0,
					4,0,0, 4,0,0,
				],inf).stutter(1) + [0,3,0+11],
				//\detune, -10,
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\legato, Pseq([
					1,0,1, 1,0,1,
					1,0,0, 1,0,0,
				],inf)*0.8,
				\octave, 5,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\amp, 0.1,
				\isRest, true,
			),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx1, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751,
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1/12,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.000000394574653723 * Pseq([
							1,100000,1,1,
						],inf).stutter(8),
						'delay2', 0.4000100828221925227 * Pseg(Pseq([1],inf),8),
						'delay3', 0.00001001 * Pseq([
							1,
						],inf).stutter(8*2),
						'distamp', 0.62682721311638,
						'distamp2', 1.1,
						'distamp3', 0.9904517086311,
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.1,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
					Pmono(\chorusdistlim,
						\inbus, BusDef(\fx1, \audio, 2),
						\freq, 200,
						\distamp, 20,
						\distpostamp, 1/1,
						\fb, 0.404,
						\distmix, 1,
						\delay, 0.00011,
						\modfreq, 0.004*~t,
						\modamp, 0.0001,
						\hpf, 500,
						\gain, 0.1/2,
						\mix, 1.0,
						\dur, 1,
						\amp, 0.1,
					),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx2, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751,
						'gain', 1.44454369503751 * Pseq([
							1, 1, 1, 1,
							1, 1, 1, 1,
							1, 1, 1, 1,
							0, 0, 0, 0,
						],inf).stutter(4*4),
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							5,8,5,5,
							1*13,1,4,20,
							6,5,8,2,
							1*13,1,4,20,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(1*2),
						'delay', 0.000000394574653723,
						'delay2', 0.0000110828221925227 * Pstep(Pseq([
							Pseq([
								2000, 2050, 2000, 2050,
							],inf)/10,
							200, 20050, 20000, 20050,
						],inf),8),
						'delay3', 0.02000001 * Pseq([
							1/2000
						],inf),
						'distamp', 1.62682721311638,
						'distamp2', 2.1,
						'distamp3', 1.9904517086311,
						//\delay3, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
						\out, BusDef(\stutbus, \audio),
					),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx3, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751 * Pseq([
							0,0,0,0, 0,0,0,0,
							0,1,0,0, 1,0,0,0,
							1,1,1,1, 1,1,1,1,
							1,0,1,1, 1,0,1,1,

							Pser([
								1,1,1,1, 1,1,1,1,
								1,1,0,1, 1,1,0,1,
								1,1,1,1, 1,1,1,1,
								1,1,0,1, 1,1,0,1,
								
								1,1,0,1, 1,0,1,1,
								0,0,1,0, 0,0,1,0,
								1,1,1,1, 1,1,1,1,
								1,0,1,1, 1,0,1,1,
							],3*8),
							0,0,0,0, 0,0,0,0,
							0,1,0,0, 1,0,0,0,
							1,0,1,0, 0,0,1,1,
							1,0,0,0, 0,0,0,0,
						],inf).stutter(2*1),
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							13,10,8,15,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*8),
						'delay', 0.000000394574653723,
						'delay', 0.00010828221925227 * Pstep(Pseq([
							1,10,
						],inf),1),
						\delay2, 0.0001 * Pseq([
							1,1,1,1,
						],inf).stutter(8),
						'delay3', 0.0002000001 * Pseq([
							1,2,1/10,100,
						],inf).stutter(8*4),
						'distamp', 1.62682721311638,
						'distamp2', 2.1,
						'distamp3', 1.9904517086311,
						//\delay3, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 10030,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
					Pmono(\fx_stutter,
						\inbus, BusDef(\stutbus, \audio),
						\time, 1/~t * Pseq([
							Pseq([
								1/12,1/16,1/8,1/6,1/9,
							],8*8),
						],inf),
						\mix, Pseq([
							Pseq([
								0,0,0,0, 0,0,1,0,
								0,0,1,1, 0,1,0,1,
								0,1,0,0, 1,0,0,0,
								0,0,1,1, 0,1,0,1,
							],1),
							Pseq([
								0,0,0,0, 0,0,0,0,
								0,1,1,0, 1,0,0,1,
							],1),
							Pseq([
								1,1,0,0, 0,0,1,1,
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,
							],1),
						],inf),
						\dur, 1/8,
					),
	]),
)).play;
);

(
	// verse2
	~master.();
Pdef(\part, Pdef(\bleu_draft7, 
	Ppar([
		//Pbind(\out, BusDef(\fx2, \audio)) <>
		Ppar([
			Pbind(
				\time, Ptime().round.trace,
				\dur, 8,
				\isRest, true,
			),
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,1,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,1,0, 1,0,0, 0,0,0, 0,0,0, 1,0,0, 0,0,0, 0,1,0, 
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,1,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0, 1,0,0, 0,1,0, 0,0,0, 0,0,0, 0,0,0, 0,1,0, 
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,1,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,1,0, 1,0,0, 0,0,0, 0,0,0, 1,0,0, 0,0,0, 0,1,0, 
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,1,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,1,0, 0,0,1, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,1,0, 
				],inf).coin.not,
				//\dur, 1/8 * Pseq([4/3,2/3],inf),
				\dur, 1/12/2,
				\amp, 0.2,
				\out, BusDef(\fx2),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.121,
				\speed, 0.97,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 1,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 1,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						1,0,1, 1,0,0,  0,0,1, 1,0,1,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 1,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 1,0,0,  0,0,0, 0,0,0,
						
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 1,0,1,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
						1,0,0, 1,0,1,  0,0,1, 1,0,1,
					],1),
					Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,1,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 1,0,0,  0,0,1, 1,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,1,0,  0,0,0, 0,0,0,
						0,0,0, 1,0,0,  0,0,1, 1,0,0,
						1,0,0, 0,0,0,  0,0,1, 0,1,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,1,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 1,0,0,  0,0,1, 1,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,1,  0,0,0, 0,0,0,
						0,0,0, 0,0,1,  0,0,0, 1,1,0,
						0,0,1, 0,0,0,  0,0,0, 1,0,1,

					],1),
					//0,0,0, 0,0,0,  0,0,0, 0,0,0,
					//0,0,0, 0,0,0, 0,0,0, 0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.071,
				\speed, 0.97,
				\gain, 0.2,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,0, 1,0,1, 1,0,0, 1,0,1, 1,0,0, 1,0,1, 1,0,0, 1,0,1, 
					1,0,1, 1,0,1, 1,0,0, 1,0,1, 1,0,0, 1,0,1, 1,0,0, 1,0,1, 
					1,0,0, 1,0,0, 1,0,1, 1,0,1, 1,0,0, 1,0,1, 1,0,0, 1,0,1, 
					1,0,1, 1,0,1, 0,0,0, 1,1,1, 1,0,0, 1,0,1, 1,0,0, 1,0,1, 
					1,0,0, 1,0,1, 1,0,0, 1,0,1, 1,0,1, 1,0,0, 1,1,1, 1,0,0, 
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\fac1, Pseq([
					0.1, 0.1, 0.1,
				],inf),
				\dur, 1/12,
				\out, BusDef(\fx1, \audio),
				\pan, 0,
				\amp, 0.02,
			),
		
		
			/////////////////
		
		
		]),
		Pbind(
			\instrument, Pseq([\starlet,\star, Prand([\starlet,\star],2)],inf).stutter(1),
			\note, Pseq([
				[9,4,3],
				[0,13],
				[1,-12],
				3,2,1,
			],inf),
			\octave, 5,
			\dur, 1/3,
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,2.0) ],
					[ Env.adsr(0.005,0.1,1.8,1.0) ],
					[ Env.adsr(0.005,0.1,1.8,0.5) ],
				],1),
			],inf),
			\legato, 0.2,
			\legato, Pseq([
					3,0,0, 1,1,0,
			],inf) * 0.2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\fx3, \audio),
		),
			Pbind(
				\instrument, \fmbass,
				\chaos, 1.93500,
				\note, Pseq([
					9,7,1,
				],inf).stutter(4) + Prand([12,0,-12],inf),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 7,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.7) ],
				],inf),
				\modamp, 0.4,
				\legato, Pseq([
						0,0,0, 1,0,0,
						0,0,0, 0,0,0,
						0,0,1, 1,0,0,
						1,0,0, 0,0,0,
						1,0,0, 1,0,1,
				],inf)*0.1,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx3, \audio),
				\dur, 1/12,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \fmz1,
				\chaos, 1.93500,
				\note, Pseq([
					9,13,-12,
				3,2,1,
				],inf).stutter(1)+ Pseq([
					0,0,
				],inf),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 8,
				\modamp, 0.4,
				\legato, Pseq([
					1,0,0, 0,0,0, 0,0,0, 0,0,0,
					1,0,0, 0,0,0, 0,0,1, 2,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx3, \audio),
				\dur, 1/3,
				\amp, 0.1/2,
			),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx1, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751,
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1/12,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.000000394574653723 * Pseq([
							1,100000,1,1,
						],inf).stutter(8),
						'delay2', 0.4000100828221925227 * Pseg(Pseq([1],inf),8),
						'delay3', 0.00001001 * Pseq([
							1,
						],inf).stutter(8*2),
						'distamp', 0.62682721311638,
						'distamp2', 1.1,
						'distamp3', 0.9904517086311,
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.1,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
					Pmono(\chorusdistlim,
						\inbus, BusDef(\fx1, \audio, 2),
						\freq, 200,
						\distamp, 20,
						\distpostamp, 1/1,
						\fb, 0.404,
						\distmix, 1,
						\delay, 0.00011,
						\modfreq, 0.004*~t,
						\modamp, 0.0001,
						\hpf, 500,
						\gain, 0.1/2,
						\mix, 1.0,
						\dur, 1,
						\amp, 0.1,
					),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx2, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751 * Pseq([
							1, 1, 1, 1,
							1, 1, 1, 1,
							1, 1, 1, 1,
							0, 0, 1, 1,
						],inf).stutter(4*4),
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							5,5,5,5,
							5,5,5,5,
							5,5,5,5,
							1*13,1,4,20,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(1*2),
						'delay', 0.000000394574653723,
						'delay2', 0.0000110828221925227 * Pstep(Pseq([
							Pseq([
								2000, 2050, 2000, 2050,
							],inf)/10,
							200, 20050, 20000, 20050,
						],inf),8),
						'delay3', 0.02000001 * Pseq([
							1/2000
						],inf),
						'distamp', 1.62682721311638,
						'distamp2', 2.1,
						'distamp3', 1.9904517086311,
						//\delay3, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx3, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751 * Pseq([
							1,1,0,0,
							1,1,1,1,
						],inf).stutter(8*8),
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							20,1,1,13,1,20,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*8),
						'delay', 0.001000394574653723,
						'delay2', 0.0000110828221925227 * Pstep(Pseq([
							100, 200, 50,
						],inf),8),
						'delay3', 0.02000001 * Pseq([
							1,1,1,1/10,
							Pseq([
								1,1,1,1/10,
							],1)/100,
						],inf),
						'distamp', 1.62682721311638,
						'distamp2', 2.1,
						'distamp3', 1.9904517086311 * Pseq([
							Pseq([
								1,1,1,1, 1,1,1,1,
							],4),
							Pseq([
								10,1, 10,1, 10,1, 10,1,
							],3),
							Pser([1/2],8),
						],inf),
						//\delay3, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 10030,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
					Pseq([
						Pfindur(6,
							Pmono(\rdnroom,
								\inbus, BusDef(\fx3, \audio, 2),
								\dur, 1/8,
								'wet10', 1.0,
								'mix', 1,
								'gain', 1/12,
								'fb', 0.0002000031,
								'delay', 0.00000001,
								'delay2', 0.00101001,
								'delay3', 0.0000080,
								'distamp', 0.604,
								'distamp2', 0.23,
								'distamp3', 40.89,
								'shift', -5.0,
								'shiftmix', 0.0,
								'stereo', 1.0,
								'indelay', 0.04,
							),
						),
						Pfindur(2,
							Pmono(\rdnroom,
								\inbus, BusDef(\fx3, \audio, 2),
								\dur, 1/8,
								'wet10', 1.0,
								'mix', 1,
								'gain', 1/12,
								'fb', 0.00002000031,
								'delay', 0.00000001,
								'delay2', 0.02001001,
								'delay3', 0.0000080,
								'distamp', 0.604,
								'distamp2', 0.23,
								'distamp3', 20.89,
								'shift', -5.0,
								'shiftmix', 0.0,
								'stereo', 1.0,
								'indelay', 0.04,
							),
						),
					],inf),
	]),
)).play;
);


(
	// longer than 32 beats
	~master.();
Pdef(\part, Pdef(\bleu_draft5trans, 
	Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,0, 0,0,0,  0,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  1,0,0, 0,0,0,
				],inf).coin.not,
				//\dur, 1/8 * Pseq([4/3,2/3],inf),
				\dur, 1/12/2,
				\amp, 0.2,
			),
		Pbind(
			\instrument, Pseq([\starlet,\star, Prand([\starlet,\star],2)],inf).stutter(1),
			\note, Pseq([
				[9,4,3],
				[0,13],
				[1,-12],
				3,2,1,
			],inf).stutter(8),
			\octave, 5,
			\dur, 2,
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,2.0) ],
					[ Env.adsr(0.005,0.1,1.8,1.0) ],
					[ Env.adsr(0.005,0.1,1.8,0.5) ],
				],1),
			],inf),
			\legato, 0.2,
			\legato, Pseq([
					3,0,0, 1,1,0,
			],inf) * 0.2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\fx3, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\starbus),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0,
			\sendbus0, BusDef(\fx3, \audio, 2),
			\sendbus0, BusDef(\fx2, \audio, 2),
			\sendbus0, BusDef(\fx1, \audio, 2),
			\dur, 1,
		),
			Pbind(
				\instrument, \fmbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,0,1,
				],inf).stutter(8),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 5,
				\modamp, 0.4,
				\legato, Pseq([
						4,0,0, 0,0,1,
						4,0,0, 0,0,1,
						2,0,1, 2,0,1,
						4,0,0, 0,0,0,
				],inf)*0.8,
				\legato, Pseq([
						2,0,0, 0,0,1,
						2,0,0, 0,0,1,
						1,0,1, 2,0,1,
						2,0,0, 0,0,0,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \fmz1,
				\chaos, 1.93500,
				\note, Pseq([
					0,0,1,
					7,7,1,
				],inf).stutter(8)+[0,7]+ Pseq([
					0,0,1, 0,0,0, 0,-1,0, 0,
				],inf),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 5,
				\modamp, 0.4,
				\legato, Pseq([
					4,0,0, 0,0,0, 4,0,0, 0,0,1,
					4,0,0, 0,0,1, 3,0,0, 2,0,1,
					4,0,0, 0,0,0, 4,0,0, 0,0,1,
					3,0,0, 1,0,1, 3,0,1, 2,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \toto,
				\note, Pseq([
					4,0,0, 0,0,0,
					4,0,0, 4,0,0,
				],inf).stutter(1) + [0,3,0+11],
				//\detune, -10,
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\legato, Pseq([
					1,0,1, 1,0,1,
					1,0,0, 1,0,0,
				],inf)*0.8,
				\octave, 5,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\amp, 0.1,
				\isRest, true,
			),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx1, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751,
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1/12,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.000000394574653723 * Pseq([
							1,100000,1,1,
						],inf).stutter(8),
						'delay2', 0.4000100828221925227 * Pseg(Pseq([1],inf),8),
						'delay3', 0.00001001 * Pseq([
							1,
						],inf).stutter(8*2),
						'distamp', 0.62682721311638,
						'distamp2', 1.1,
						'distamp3', 0.9904517086311,
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.1,
						'prelpf', 19900,
						'prehpf', 17,
						'lpf', 17000,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 19900,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 19300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
					Pmono(\chorusdistlim,
						\inbus, BusDef(\fx1, \audio, 2),
						\freq, 200,
						\distamp, 20,
						\distpostamp, 1/1,
						\fb, 0.404,
						\distmix, 1,
						\delay, 0.00011,
						\modfreq, 0.004*~t,
						\modamp, 0.0001,
						\hpf, 500,
						\gain, 0.1/2,
						\mix, 1.0,
						\dur, 1,
						\amp, 0.1,
					),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx2, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751,
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1*13,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.000000394574653723,
						'delay2', 0.0000110828221925227 * Pstep(Pseq([
							100,1,
							200, 50,
						],inf),8),
						'delay3', 0.02000001 * Pseq([
							1,1,1,1/10,
							Pseq([
								1,1,1,1/10,
							],1)/100,
						],inf),
						'distamp', 1.62682721311638,
						'distamp2', 2.1,
						'distamp3', 1.9904517086311,
						//\delay3, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
						\isRest, true,
					),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx3, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751 * Pseq([
							1,1,1,1,
							1,1,1,1,
						],inf).stutter(8*8),
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							13,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*8),
						'delay', 0.000000394574653723,
						'delay2', 0.0000110828221925227 * Pstep(Pseq([
							100,1,
							200, 50,
						],inf),8),
						\delay2, ~pmodenv.(Pseq([0.0001,0.2],inf), 8),
						'delay3', 0.02000001 * Pseq([
							1,1,1,1/10,
							Pseq([
								1,1,1,1/10,
							],1)/100,
						],inf),
						'distamp', 1.62682721311638,
						'distamp2', 2.1,
						'distamp3', 1.9904517086311,
						//\delay3, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 10030,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),

					// other
			Ppar([
				Pbind(
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 0,0,1,
						1,0,1, 0,1,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 0,0,1,
					],inf).coin.not,
					\freq, 800,
					\bpf, 400,
					\freq2, 750,
					\bpf2, 1500,
				),
				Pbind(
					\isRest, Pseq([
						1,0,0, 1,0,0,  1,0,0, 1,0,0,
					],inf).coin.not,
					\freq, 400,
					\bpf, 700,
					\hpf, 200,
				),
				
			])<>
			Pbind(
				\instrument, \clave,
				\hpf, 50,
				\decay, 0.02,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.01,0.008,0.01) ],
				],inf),
				\freq, 700,
				\bpf, 400,
				\rq, 0.1,
				\freq2, 150,
				\bpf2, 11500,
				\rq2, 0.01,
				\amp, 37,
				\dur, 1/12*2,
				\out, BusDef(\fx2, \audio),
			),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx2, \audio),
						'wet10', 1.0,
						'mix', 0.92100840336134,
						'gain', 0.84454369503751 * Pseq([
							1,1,1,1,
							1,1,1,1,
						],inf).stutter(8*8),
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1*42,
							1,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(1*1),
						'delay', 0.000000394574653723,
						'delay2', Pstep(Pseq([
							0.1,
							1/1200000,
							0.01,
							1/1200000,
						],inf),1)/4,
						'delay3', 0.40000001 * Pseq([
							1
						],inf),
						'distamp', 1.62682721311638,
						'distamp2', 0.7,
						'distamp3', 0.9904517086311,
						//\delay3, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 10030,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
	]),
)).play;
);

(
	// longer than 32 beats
	//~master.();
Pdef(\part, Pdef(\bleu_draft7trans, 
	Ppar([
		//Pbind(\out, BusDef(\fx2, \audio)) <>
		Ppar([
			Pbind(
				\time, Ptime().round.trace,
				\dur, 8,
				\isRest, true,
			),
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,0, 0,0,0,  0,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,0,0,
				],inf).coin.not,
				//\dur, 1/8 * Pseq([4/3,2/3],inf),
				\dur, 1/12/2,
				\amp, 0.2,
				\out, BusDef(\fx2),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 1,0,0,
					0,0,0, 0,0,0, 0,0,0, 1,0,1,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.121,
				\speed, 0.97,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 1,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 1,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						1,0,1, 1,0,0,  0,0,1, 1,0,1,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 1,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 1,0,0,  0,0,0, 0,0,0,
						
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 1,0,1,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
						1,0,0, 1,0,1,  0,0,1, 1,0,1,
					],1),
					Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,1,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 1,0,0,  0,0,1, 1,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,1,0,  0,0,0, 0,0,0,
						0,0,0, 1,0,0,  0,0,1, 1,0,0,
						1,0,0, 0,0,0,  0,0,1, 0,1,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,1,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 1,0,0,  0,0,1, 1,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,1,  0,0,0, 0,0,0,
						0,0,0, 0,0,1,  0,0,0, 1,1,0,
						0,0,1, 0,0,0,  0,0,0, 1,0,1,

					],1),
					//0,0,0, 0,0,0,  0,0,0, 0,0,0,
					//0,0,0, 0,0,0, 0,0,0, 0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.071,
				\speed, 0.97,
				\gain, 0.2,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
				\isRest, true,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,0, 1,0,1, 1,0,0, 1,0,1, 1,0,0, 1,0,1, 1,0,0, 1,0,1, 
					1,0,1, 1,0,1, 1,0,0, 1,0,1, 1,0,0, 1,0,1, 1,0,0, 1,0,1, 
					1,0,0, 1,0,0, 1,0,1, 1,0,1, 1,0,0, 1,0,1, 1,0,0, 1,0,1, 
					1,0,1, 1,0,1, 0,0,0, 1,1,1, 1,0,0, 1,0,1, 1,0,0, 1,0,1, 
					1,0,0, 1,0,1, 1,0,0, 1,0,1, 1,0,1, 1,0,0, 1,1,1, 1,0,0, 
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\fac1, Pseq([
					0.1, 0.1, 0.1,
				],inf),
				\dur, 1/12,
				\out, BusDef(\fx1, \audio),
				\pan, 0,
				\amp, 0.02,
			),
		
		
			/////////////////
		
		
		]),
		Pbind(
			\instrument, Pseq([\starlet,\star, Prand([\starlet,\star],2)],inf).stutter(1),
			\note, Pseq([
				3,2,1,


			],inf),
			\scale, Scale.minor,
			\octave, 4,
			\dur, 1/3,
			\lag, Pseq([
				Pseq([0,0],8) / ~t,
				Pseq([0,1/4 + Pwhite(0,0.01,1)],4) / ~t,
				Pseq([0,0],4) / ~t,
				Pseq([0,1/2 + Pwhite(0,0.01,1)],4) / ~t,
				Pseq([0,0],4) / ~t,
				Pseq([0,1/8 + Pwhite(0,0.01,1)],4) / ~t,
				Pseq([0,0],Pwhite(4,8,1)) / ~t,
				Pseq([0,1/8 + Pwhite(0,0.05,1)],Pwhite(4,8,1)) / ~t,
			],inf),
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,2.0) ],
					[ Env.adsr(0.005,0.1,1.8,1.0) ],
					[ Env.adsr(0.005,0.1,1.8,0.5) ],
				],1),
			],inf),
			\legato, 0.2,
			\isRest, Pseq([
				1,0,0,0,
				1,0,1,1,
			],inf).coin.not,
			\isRest, false,
			\out, BusDef(\fx1, \audio),
		),
		Pbind(
			\instrument, Pseq([\starlet,\star, Prand([\starlet,\star],2)],inf).stutter(1),
			\note, Pseq([
				[9,4,3],
				[0,13],
				[1,-12],
				3,2,1,
			],inf),
			\octave, 5,
			\dur, 1/3,
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,2.0) ],
					[ Env.adsr(0.005,0.1,1.8,1.0) ],
					[ Env.adsr(0.005,0.1,1.8,0.5) ],
				],1),
			],inf),
			\legato, 0.2,
			\legato, Pseq([
					3,0,0, 1,1,0,
			],inf) * 0.2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\fx3, \audio),
		),
			Pbind(
				\instrument, \fmbass,
				\chaos, 1.93500,
				\note, Pseq([
					9,
				],inf).stutter(4) + Prand([12,0,-12],inf),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 7,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.7) ],
				],inf),
				\modamp, 0.4,
				\legato, Pseq([
						0,0,0, 1,0,0,
						0,0,0, 0,0,0,
						0,0,1, 1,0,0,
						1,0,0, 0,0,0,
						1,0,0, 1,0,1,
				],inf)*0.1,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx3, \audio),
				\dur, 1/12,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \fmz1,
				\chaos, 1.93500,
				\note, Pseq([
					9,13,-12,
				3,2,1,
				],inf).stutter(1)+ Pseq([
					0,0,
				],inf),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 8,
				\modamp, 0.4,
				\legato, Pseq([
					1,0,0, 0,0,0, 0,0,0, 0,0,0,
					1,0,0, 0,0,0, 0,0,1, 2,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx3, \audio),
				\dur, 1/3,
				\amp, 0.1/2,
			),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx1, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751,
						'gain', 1.44454369503751 * Pseq([
							1, 0,
						],inf).stutter(8*4),
						'wetgain', 0.2504562572587,
						'fb', 0.000301 * Pseq([
							1/12,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.100000394574653723 * Pseq([
							1,1,1,1,
						],inf).stutter(8),
						'delay2', 0.0000100828221925227 * Pseg(Pseq([1],inf),8),
						'delay3', 0.20001001 * Pseq([
							1,
						],inf).stutter(8*2),
						'distamp', 0.62682721311638,
						'distamp2', 1.1,
						'distamp3', 0.9904517086311,
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.1,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 19300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
					Pmono(\chorusdistlim,
						\inbus, BusDef(\fx1, \audio, 2),
						\freq, 200,
						\distamp, 20,
						\distpostamp, 1/1,
						\fb, 0.404,
						\distmix, 1,
						\delay, 0.00011,
						\modfreq, 0.004*~t,
						\modamp, 0.0001,
						\hpf, 500,
						\gain, 0.1/2,
						\mix, 1.0,
						\dur, 1,
						\amp, 0.1,
					),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx2, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751 * Pseq([
							1, 0,
						],inf).stutter(8*7),
						'wetgain', 0.2504562572587,
						'fb', 0.00000301 * Pseq([
							1,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(1*2),
						'delay', 0.000000394574653723,
						'delay2', 0.000000110828221925227 * Pstep(Pseq([
							1
						],inf),8),
						'delay3', 0.00000001 * Pseq([
							1
						],inf),
						'distamp', 0.62682721311638,
						'distamp2', 0.1,
						'distamp3', 0.0904517086311,
						//\delay3, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 19700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 19300,
						\ehpf, 20,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx3, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751 * Pseq([
							1,0,
						],inf).stutter(8*5),
						'wetgain', 0.2504562572587,
						'fb', 0.000301 * Pseq([
							1,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*8),
						'delay', 0.001000394574653723,
						'delay2', 0.0000110828221925227 * Pstep(Pseq([
							100, 200, 50,
						],inf),8),
						'delay3', 0.02000001 * Pseq([
							1,1,1,1/10,
							Pseq([
								1,1,1,1/10,
							],1)/100,
						],inf),
						'distamp', 1.62682721311638,
						'distamp2', 2.1,
						'distamp3', 1.9904517086311 * Pseq([
							Pseq([
								1,1,1,1, 1,1,1,1,
							],4),
							Pseq([
								10,1, 10,1, 10,1, 10,1,
							],3),
							Pser([1/2],8),
						],inf),
						//\delay3, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 10030,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
					Pmono(\chorusdistlim,
						\inbus, BusDef(\fx3, \audio, 2),
						\freq, 200,
						\distamp, 20,
						\distpostamp, 1/1,
						\fb, 0.904,
						\distmix, 1,
						\delay, 0.41,
						\modfreq, 0.4*~t,
						\modamp, 0.0001,
						\hpf, 500,
						\gain, 0.1,
						\mix, 1.0,
						\dur, 1,
						\amp, 0.1,
					),
					Pseq([
						Event.silent(7),
						Pfindur(1,
							Pmono(\rdnroom,
								\inbus, BusDef(\fx3, \audio, 2),
								\dur, 1/8,
								'wet10', 1.0,
								'mix', 1,
								'gain', 1/12,
								'fb', 0.00002000031,
								'delay', 0.00000001,
								'delay2', 0.02001001,
								'delay3', 0.0000080,
								'distamp', 0.604,
								'distamp2', 0.23,
								'distamp3', 20.89,
								'shift', -5.0,
								'shiftmix', 0.0,
								'stereo', 1.0,
								'indelay', 0.04,
							),
						),
					],inf),
	]),
)).play;
);

//////////////////

/// MAIN


(
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(8, Pdef(\bleu_intro)),
		Pfindur(8, Pdef(\bleu_draft1)),
		Pfindur(32, Pdef(\bleu_draft5)),
		Pfindur(8, Pdef(\bleu_draft5trans)),
		Pfindur(32, Pdef(\bleu_draft7)),
		Pfindur(8, Pdef(\bleu_draft7trans)),
		Pfindur(32+8, Pdef(\bleu_draft6)),
		Pfindur(8, Pdef(\bleu_end)),
	])
)).play;
)


(
Pdef(\part, Pdef(\main_old, 
	Pseq([
		Pfindur(6, Pdef(\bleu_draft1)),
		Pfindur(2, Pdef(\bleu_draft2)),
		Pfindur(8, Pdef(\bleu_draft4)),
		Pfindur(15, Pdef(\bleu_draft5)),
		Pfindur(1, Pdef(\bleu_draftc1)),
		Pfindur(4, Pdef(\bleu_draftb1)),
		Pfindur(4, Pdef(\bleu_draftb3)),
		Pfindur(2, Pdef(\bleu_draftb2)),
		Pfindur(2, Pdef(\bleu_draft2)),
		Pfindur(8, Pdef(\bleu_draft3)),
		Pfindur(14, Pdef(\bleu_draft6)),
		Pfindur(2, Pdef(\bleu_draft2)),
		Pfindur(14, Pdef(\bleu_draft7)),
		Pfindur(4, Pdef(\bleu_draftb1)),
	])
)).play;
)

(
Pdef(\part, Pdef(\main_old2, 
	Pseq([
		Pfindur(32, Pdef(\bleu_draft5)),
		Pfindur(32, Pdef(\bleu_draft7)),
	])
)).play;
)


//////////////////////

(
	// play

Pdef(\murmure,
	Pbind(
	\instrument, Pseq([\starlet,\star, Prand([\starlet,\star],2)],inf).stutter(1),
	\note, Pseq([
		3,2,1,

		
	],inf),
	\scale, Scale.minor,
	\octave, 4,
	\dur, 1/3,
	\lag, Pseq([
		Pseq([0,0],8) / ~t,
		Pseq([0,1/4 + Pwhite(0,0.01,1)],4) / ~t,
		Pseq([0,0],4) / ~t,
		Pseq([0,1/2 + Pwhite(0,0.01,1)],4) / ~t,
		Pseq([0,0],4) / ~t,
		Pseq([0,1/8 + Pwhite(0,0.01,1)],4) / ~t,
		Pseq([0,0],Pwhite(4,8,1)) / ~t,
		Pseq([0,1/8 + Pwhite(0,0.05,1)],Pwhite(4,8,1)) / ~t,
	],inf),
	\lag, 0,
	\adsr, Pseq([
		Prand([
			[ Env.adsr(0.005,0.1,1.0,1.8) ],
			[ Env.adsr(0.005,0.1,1.0,1.8) ],
			[ Env.adsr(0.005,0.1,1.0,1.8) ],
			[ Env.adsr(0.005,0.1,1.0,2.0) ],
			[ Env.adsr(0.005,0.1,1.8,1.0) ],
			[ Env.adsr(0.005,0.1,1.8,0.5) ],
		],1),
	],inf),
	\legato, 0.2,
	\isRest, Pseq([
		1,0,0,0,
		1,0,1,1,
	],inf).coin.not,
	\isRest, false,
).trace
).play;
)

Pdef(\murmure).stop
Pdef(\murmure).clear

////////////////////



(
Pdef(\part, Pdef(\bleu_draftc1, 
	Ppar([
		Pdef(\clave, 
			Pbind(
				\instrument, \clave,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
			),
		),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			))
	])
)).play;
)

WindowDef(\PdefEditor).front(Pdef(\clave))



(
Pdef(\part, Pdef(\bleu_draftb1, 
	Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,0, 0,0,0,  0,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  1,0,0, 0,0,0,
				],inf).coin.not,
				//\dur, 1/8 * Pseq([4/3,2/3],inf),
				\dur, 1/12/2,
				\amp, 0.2,
			),
			Ppar([
				Pbind(
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 0,0,1,
						1,0,1, 0,1,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 0,0,1,
					],inf).coin.not,
					\freq, 800,
					\bpf, 400,
					\freq2, 750,
					\bpf2, 1500,
				),
				Pbind(
					\isRest, Pseq([
						1,0,0, 1,0,0,  1,0,0, 1,0,0,
					],inf).coin.not,
					\freq, 400,
					\bpf, 700,
					\hpf, 200,
				),
				
			])<>
			Pbind(
				\instrument, \clave,
				\hpf, 50,
				\decay, 0.02,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.01,0.008,0.01) ],
				],inf),
				\freq, 700,
				\bpf, 400,
				\rq, 0.1,
				\freq2, 150,
				\bpf2, 11500,
				\rq2, 0.01,
				\amp, 37,
				\dur, 1/12*2,
				\out, BusDef(\fx1, \audio),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx1, \audio),
						'wet10', 1.0,
						'mix', 0.92100840336134,
						'gain', 0.84454369503751 * Pseq([
							1,1,1,1,
							1,1,1,1,
						],inf).stutter(8*8),
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1*41,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*8),
						'delay', 0.000000394574653723,
						'delay2', 0.0000000110828221925227 * Pstep(Pseq([
							1200000,
							200000,
							100000,
							1,
						],inf),2),
						'delay3', 0.40000001 * Pseq([
							1
						],inf),
						'distamp', 0.62682721311638,
						'distamp2', 0.7,
						'distamp3', 0.9904517086311,
						//\delay3, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 10030,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
	])
)).play;
)


(
Pdef(\part, Pdef(\bleu_draftb2, 
	Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,0, 0,0,0,  0,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  1,0,0, 0,0,0,
				],inf).coin.not,
				//\dur, 1/8 * Pseq([4/3,2/3],inf),
				\dur, 1/12/2,
				\amp, 0.2,
			),
			Ppar([
				Pbind(
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 0,0,1,
						1,0,1, 0,1,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 0,0,1,
					],inf).coin.not,
					\freq, 800,
					\bpf, 400,
					\freq2, 750,
					\bpf2, 1500,
				),
				Pbind(
					\isRest, Pseq([
						1,0,0, 1,0,0,  1,0,0, 1,0,0,
					],inf).coin.not,
					\freq, 400,
					\bpf, 700,
					\hpf, 200,
				),
				
			])<>
			Pbind(
				\instrument, \clave,
				\hpf, 50,
				\decay, 0.02,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.01,0.008,0.01) ],
				],inf),
				\freq, 700,
				\bpf, 400,
				\rq, 0.1,
				\freq2, 150,
				\bpf2, 11500,
				\rq2, 0.01,
				\amp, 37,
				\dur, 1/12*2,
				\out, BusDef(\fx2, \audio),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\fx1, \audio),
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					1,0,0, 1,0,0, 1,0,0, 1,0,1,
					1,0,0, 1,0,0, 1,0,0, 1,0,1,
					1,0,0, 1,0,0, 1,0,0, 1,0,1,
					1,0,0, 1,0,0, 1,0,1, 1,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2 * Pseq([
					1,0.5,0.5,
					1,0.5,0.5,
					1,0.5,0.5,
					1,0.5,0.5,

					1,0.5,0.5,
					1,0.5,0.5,
					1,0.5,0.5,
					1,0.3,0.3,
				],inf).stutter(2),
				\dur, 1/12,
				\amp, 0.1,
			)),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx1, \audio),
						'wet10', 1.0,
						'mix', 0.12100840336134,
						'gain', 1.84454369503751 * Pseq([
							1,1,1,1,
							1,1,1,1,
						],inf).stutter(8*8),
						'wetgain', 0.8504562572587,
						'fb', 0.00301 * Pseq([
							1*21,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*8),
						'delay', 0.000000394574653723,
						'delay2', Pstep(Pseq([
							0.1,
							1/1200000,
							0.01,
							1/1200000,
						],inf),1),
						'delay3', 0.40000001 * Pseq([
							1
						],inf),
						'distamp', 0.62682721311638,
						'distamp2', 0.7,
						'distamp3', 0.9904517086311,
						//\delay3, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 10030,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx2, \audio),
						'wet10', 1.0,
						'mix', 0.92100840336134,
						'gain', 0.64454369503751 * Pseq([
							1,1,1,1,
							1,1,1,1,
						],inf).stutter(8*8),
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							Plazy({ arg ev;
								Pser([
									1*42,
									1,
									1,
								],[4,8,16].choose).repeat(4);
							}),
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(1*1),
						'delay', 0.000000394574653723,
						'delay2', Pstep(Pseq([
							0.1,
							1/1200000,
							0.01,
							1/1200000,
						],inf),1)/4,
						'delay3', 0.40000001 * Pseq([
							1
						],inf),
						'distamp', 1.62682721311638,
						'distamp2', 0.7,
						'distamp3', 0.9904517086311,
						//\delay3, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 10030,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
	])
)).play;
)


(
Pdef(\part, Pdef(\bleu_draftb3, 
	Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,0, 0,0,0,  0,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  1,0,0, 0,0,0,
				],inf).coin.not,
				//\dur, 1/8 * Pseq([4/3,2/3],inf),
				\dur, 1/12/2,
				\amp, 0.2,
			),
			Ppar([
				Pbind(
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 0,0,1,
						1,0,1, 0,1,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 0,0,1,
					],inf).coin.not,
					\freq, 800,
					\bpf, 400,
					\freq2, 750,
					\bpf2, 1500,
				),
				Pbind(
					\isRest, Pseq([
						1,0,0, 1,0,0,  1,0,0, 1,0,0,
					],inf).coin.not,
					\freq, 400,
					\bpf, 700,
					\hpf, 200,
				),
				
			])<>
			Pbind(
				\instrument, \clave,
				\hpf, 50,
				\decay, 0.02,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.01,0.008,0.01) ],
				],inf),
				\freq, 700,
				\bpf, 400,
				\rq, 0.1,
				\freq2, 150,
				\bpf2, 11500,
				\rq2, 0.01,
				\amp, 37,
				\dur, 1/12*2,
				\out, BusDef(\fx2, \audio),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\fx1, \audio),
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					1,0,0, 1,0,0, 1,0,0, 1,0,1,
					1,0,0, 1,0,0, 1,0,0, 1,0,1,
					1,0,0, 1,0,0, 1,0,0, 1,0,1,
					1,0,0, 1,0,0, 1,0,1, 1,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2 * Pseq([
					1,0.5,0.5,
					1,0.5,0.5,
					1,0.5,0.5,
					1,0.5,0.5,

					1,0.5,0.5,
					1,0.5,0.5,
					1,0.5,0.5,
					1,0.3,0.3,
				],inf).stutter(2),
				\dur, 1/12,
				\amp, 0.1,
			)),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx1, \audio),
						'wet10', 1.0,
						'mix', 0.12100840336134,
						'gain', 1.84454369503751 * Pseq([
							1,1,1,1,
							1,1,1,1,
						],inf).stutter(8*8),
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1*21,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*8),
						'delay', 0.000000394574653723,
						'delay2', Pstep(Pseq([
							0.1,
							1/1200000,
							0.01,
							1/1200000,
						],inf),1),
						'delay3', 0.40000001 * Pseq([
							1
						],inf),
						'distamp', 0.62682721311638,
						'distamp2', 0.7,
						'distamp3', 0.9904517086311,
						//\delay3, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 10030,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx2, \audio),
						'wet10', 1.0,
						'mix', 0.92100840336134,
						'gain', 0.84454369503751 * Pseq([
							1,1,1,1,
							1,1,1,1,
						],inf).stutter(8*8),
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1*42,
							1,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(1*1),
						'delay', 0.000000394574653723,
						'delay2', Pstep(Pseq([
							0.1,
							1/1200000,
							0.01,
							1/1200000,
						],inf),1)/4,
						'delay3', 0.40000001 * Pseq([
							1
						],inf),
						'distamp', 1.62682721311638,
						'distamp2', 0.7,
						'distamp3', 0.9904517086311,
						//\delay3, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 10030,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
	])
)).play;
)


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
	])
)).play;
)
