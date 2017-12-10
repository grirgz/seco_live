(
SynthDef(\delbass2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = LFSaw.ar(freq);
	sig1 = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig2 = RLPF.ar(sig, \lpfr2.kr(1.1) * freq, \rq2.kr(0.5));
	sig = SelectX.ar(\lpmix.kr(1.5), [sig, sig1, sig2]);
	sig = sig * EnvGen.ar(\iadsr.kr( Env.adsr(0.01,0.1,0.1,0.1) ),gate,doneAction:0);
	sig = sig * \igain.kr(1);

	thisThread.randSeed = 123133;
	
	sig1 = sig + Fb { arg fb;
		var isig;
		isig = ( fb * \fb.kr(0.3) * 100 ) + sig;
		isig = [

			{ arg isig;
				4.do {
					isig = DelayC.ar(isig, 1,rrand(0.1,0.01) * \delay1.kr) + sig;
				};
				isig;
				isig = ( isig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
			}.value(isig),
			{ arg isig;
				4.do {
					isig = DelayC.ar(isig, 1,rrand(0.1,0.01)*\delay2.kr) + sig;
				};
				isig;
				isig = ( isig*\distamp2.kr(10) ).tanh * \distpostamp2.kr(1/2);
			}.value(isig),
		].mean;
		isig = [

			{ arg isig;
				4.do {
					isig = DelayC.ar(isig, 1,rrand(0.1,0.01)*\delay3.kr) + sig;
				};
				isig;
			}.value(isig),
			{ arg isig;
				4.do {
					isig = DelayC.ar(isig, 1,rrand(0.1,0.01)*\delay4.kr) + sig;
				};
				isig;
			}.value(isig),
		].mean;
	
		isig = Limiter.ar(isig);
		isig;
	};
	sig = SelectX.ar(\delmix.kr(0.5), [sig, sig1]);

	sig = sig * \gain.kr(1);

	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.7,0.1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \delbass2,
			\delay1, 0.0000001,
			\delay2, 0.1000001,
			\delay3, 1.0000001,
			\delay4, 0.0000001,
			\lpfr2, 2,
			\lpmix, 1.7,
			\fb, 0.401,
			\iadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\distamp, 0.1,
			\distamp2, 1,
			\note, Pseq([
				0,2,5,-2,
			],inf),
			\octave, 3,
			\dur, 1,
			\igain, 1,
			\amp, 0.1,
		);
	])
)).play;
)
(
SynthDef(\delbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = LFSaw.ar(freq);
	sig1 = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig2 = RLPF.ar(sig, \lpfr2.kr(1.1) * freq, \rq2.kr(0.5));
	sig = SelectX.ar(\lpmix.kr(0.5), [sig, sig1, sig2]);

	thisThread.randSeed = 123133;
	
	sig1 = sig + Fb { arg fb;
		var isig;
		isig = ( fb * \fb.kr(0.7) * 100 ) + sig;
		isig = [

			{ arg isig;
				4.do {
					isig = DelayC.ar(isig, 1,rrand(0.1,0.01) * \delay1.kr) + sig;
				};
				isig;
				isig = ( isig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
			}.value(isig),
			{ arg isig;
				4.do {
					isig = DelayC.ar(isig, 1,rrand(0.1,0.01)*\delay2.kr) + sig;
				};
				isig;
				isig = ( isig*\distamp2.kr(10) ).tanh * \distpostamp2.kr(1/2);
			}.value(isig),
		].mean;
		isig = [

			{ arg isig;
				4.do {
					isig = DelayC.ar(isig, 1,rrand(0.1,0.01)*\delay3.kr) + sig;
				};
				isig;
			}.value(isig),
			{ arg isig;
				4.do {
					isig = DelayC.ar(isig, 1,rrand(0.1,0.01)*\delay4.kr) + sig;
				};
				isig;
			}.value(isig),
		].mean;
	
		isig = Limiter.ar(isig);
		isig;
	};
	sig = SelectX.ar(\delmix.kr(0.5), [sig, sig1]);

	sig = sig * \gain.kr(1);

	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.1) ),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\phyhat4, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([8210,1100,2051],[0.1,0.8]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([18210,4200,7451],[0.1,0.8],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.1,0.9));
	sig = HPF.ar(sig, 20000-env2);
	sig1 = sig;
	//sig = RLPF.ar(sig, env2, \rq.kr(0.5));
	sig = WhiteNoise.ar;
	env3 = EnvGen.kr(Env([1,0.9,1]*Rand(0.91,1.1),[0.01+Rand(0,0.1),0.8]), 1);
	sig = sig + Ringz.ar(sig, [900,1030,1410,8000.14,5000] * env3, 0.001).mean/10;
	env1 = EnvGen.kr(Env([881,7810,251],[0.01,0.8]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([18000,14800,1001],[0.01,0.8*\fac1.kr(1)],[1,-1]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = HPF.ar(sig, env1);
	sig = LPF.ar(sig, env2);
	sig2 = sig*1.3;

	sig = sig1+sig2;

	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.4,1,-4) ),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\plop, 
	Pseq([
		Pfindur(2, Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.01,
			
				],inf),
				\dur, 1/16,
				//\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
				\pan, 0,
				\amp, 0.02,
			),
			Pbind(
				\instrument, \phyhat4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 1,0,0,1,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 1,0,0,1,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 1,0,0,1,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.4, 0.1, 0.2, 0.1,
				],inf),
				\dur, 1/16,
				//\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
				\pan, 0,
				\amp, 0.02,
			),
		])),
		Pfindur(4+inf, Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.01,
			
				],inf),
				\dur, 1/16,
				//\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
				\pan, 0,
				\amp, 0.02,
			),
			Pbind(
				\instrument, \phyhat4,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,1,0, 1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
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
								1,0,0,0, 0,0,0,1,
								1,0,0,0, 0,0,0,0,
								1,0,0,1, 0,0,1,0,
								1,0,1,0, 0,0,0,0,
							],inf).coin.not,
							\dur, 1/8 * Pseq([4/3,2/3],inf),
							\amp, 0.1,
						),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\out, BusDef(\fx1, \audio),
					\sustain, 0.1,
					\gain, 0.4,
					\dur, 1/8,
				)),
			]),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\out, BusDef(\fx2, \audio),
					\sustain, 0.1,
					\gain, 0.4,
					\dur, 1/8,
				)),
				Pmono(\ronordn,
					\inbus, BusDef(\fx1, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.01201 * Pseq([
						1,1/20
					],inf),
					'delay', 0.000010394574653723,
					'delay2', 0.0000828221925227,
					'delay3', 0.00001,
					'distamp', 0.92682721311638,
					'distamp2', 001.0,
					'distamp3', 1.9904517086311,
					'shift', -5.0,
					'shift2', -1.1344537815126,
					'shift3', -2.4789915966387,
					'shiftmix', 0.15966386554622,
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

					\eqmid1b, 6000,
					\eqrq1b, 0.6,
					\eqdb1b, 1.6,

					\freq, 200,
					\dur, 1/2 * Pseq([1],inf),
				),
				Pmono(\ronordn,
					\inbus, BusDef(\fx2, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.00101,
					'delay', 0.000000394574653723,
					'delay2', 0.00010828221925227,
					'delay3', 0.000001,
					'distamp', 1.12682721311638,
					'distamp2', 1.1,
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
					'fbdistamp', 0.47619047619048,
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
					\dur, 1 * Pseq([1],inf),
				),
		])),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Pseq([
		Pfindur(4+inf, Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.01,
			
				],inf),
				\dur, 1/16,
				//\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
				\pan, 0,
				\amp, 0.02,
				\isRest, true,
			),
			Pbind(
				\instrument, \phyhat4,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.4, 0.1, 0.2, 0.1,
				],inf),
				\dur, 1/16,
				//\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
				\pan, 0,
				\amp, 0.02,
			),
		Pbind(
			\instrument, \fmz1,
			\note, Pseq([
				3,4,3,4,
				3,4,0,0,
			],inf),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,1,0.05) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\hpfr, ~pmodenv.(Pseq([1,2,1/2,1/4],inf), 8),
			\octave, 6,
			\dur, 1/8,
			\out, BusDef(\fx3, \audio),
			\amp, 0.1,
		),
		Pmono(\memefx,
			\inbus, BusDef(\fx3, \audio),
			\fb, 0.4,
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, Pseq([
				50,4000,
				50,2000,
			],inf),
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\mix, 0.5,
			\dur, 1/4,
			\amp, 0.1,
		),
			Pbind(\out, BusDef(\fx1))<>
			Ppar([
						Pbind(
							\instrument, \snapkickx,
							\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
							\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
							\isRest, Pseq([
								1,0,0,0, 1,0,0,0,
								1,0,0,0, 1,0,0,0,
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,
								1,0,0,1, 0,0,1,0,
								1,0,1,1, 0,1,1,1,
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,
							],inf).coin.not,
							//\dur, 1/8 * Pseq([4/3,2/3],inf),
							\dur, 1/16,
							\amp, 0.1,
						),
			]),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,1, 0,1,0,0,
					],inf).coin.not,
					\out, BusDef(\fx2, \audio),
					\sustain, 0.1,
					\gain, 0.4,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
					],inf).coin.not,
					\out, BusDef(\fx2, \audio),
					\sustain, 0.1/2,
					\gain, 0.4,
					\dur, 1/16,
				)),
				Pmono(\ronordn,
					\inbus, BusDef(\fx1, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.01201 * Pseq([
						1,1/20
					],inf),
					'delay', 0.000010394574653723,
					'delay2', 0.0000828221925227,
					'delay3', 0.00001,
					'distamp', 0.92682721311638,
					'distamp2', 001.0,
					'distamp3', 1.9904517086311,
					'shift', -5.0,
					'shift2', -1.1344537815126,
					'shift3', -2.4789915966387,
					'shiftmix', 0.15966386554622,
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

					\eqmid1b, 6000,
					\eqrq1b, 0.6,
					\eqdb1b, 1.6,

					\freq, 200,
					\dur, 1 * Pseq([1],inf),
				),
				Pmono(\ronordn,
					\inbus, BusDef(\fx2, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.00101,
					'delay', 0.000000394574653723,
					'delay2', 0.00010828221925227,
					'delay3', 0.000001,
					'distamp', 1.12682721311638,
					'distamp2', 1.1,
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
					'fbdistamp', 0.47619047619048,
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
					\dur, 1 * Pseq([1],inf),
				),
		])),
	])
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Pseq([
		Pfindur(4+inf, Ppar([
			// perc

			Pbind(
				\instrument, \phyhat4,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
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
								1,0,0,0, 1,0,0,0,
								1,0,0,0, 1,0,0,0,
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,
								1,0,0,1, 0,0,1,0,
								1,0,1,0, 0,1,0,0,
								0,0,0,0, 0,0,0,0,
								0,0,0,1, 0,0,1,0,
							],inf).coin.not,
							//\dur, 1/8 * Pseq([4/3,2/3],inf),
							\dur, 1/16,
							\amp, 0.1,
						),
			]),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\out, BusDef(\fx2, \audio),
					\sustain, 0.1,
					\gain, 0.4,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
					],inf).coin.not,
					\out, BusDef(\fx2, \audio),
					\sustain, 0.1/2,
					\gain, 0.4,
					\dur, 1/16,
				)),

			// treb

		Pbind(
			\instrument, \fmz1,
			\note, Pseq([
				3,4,3,4,
				3,4,0,0,
			],inf),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,1,0.05) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\hpfr, ~pmodenv.(Pseq([1,2,1/2,1/4],inf), 8),
			\octave, 6,
			\dur, 1/8,
			\out, BusDef(\fx3, \audio),
			\amp, 0.1,
		),
		Pmono(\memefx,
			\inbus, BusDef(\fx3, \audio),
			\out, BusDef(\fx3s, \audio),
			\fb, 0.4,
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, Pseq([
				50,4000,
				50,2000,
			],inf),
			\freq, Pseq([
				~pmodenv.(Pseq([10,2000],1), 2),
				~pmodenv.(Pseq([12000,120],1), 2),
			],inf),
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\shift, Pseq([
				100,100,-100,
			],inf),
			\mix, 0.5,
			\dur, 1/4,
			\amp, 0.1,
		),
			Pmono(\fx_stutter,
				\freq, 200,
				\inbus, BusDef(\fx3s, \audio),
				\mix, 0,
				\time, Pstep(Pseq([1/16,1/4,1/8,1/4],inf),1/4)/~t,
				\fb, 0.1,
				\dur, Pser([1/4],inf),
				\amp, 0.1,
			),

			// fx

				Pmono(\ronordn,
					\inbus, BusDef(\fx1, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.01201 * Pseq([
						1,1/20
					],inf),
					'delay', 0.000010394574653723,
					'delay2', 0.0000828221925227,
					'delay3', 0.00001,
					'distamp', 0.92682721311638,
					'distamp2', 001.0,
					'distamp3', 1.9904517086311,
					'shift', -5.0,
					'shift2', -1.1344537815126,
					'shift3', -2.4789915966387,
					'shiftmix', 0.15966386554622,
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

					\eqmid1b, 6000,
					\eqrq1b, 0.6,
					\eqdb1b, 1.6,

					\freq, 200,
					\dur, 1 * Pseq([1],inf),
				),
				Pmono(\ronordn,
					\inbus, BusDef(\fx2, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.00101,
					'delay', 0.000000394574653723,
					'delay2', 0.00010828221925227,
					'delay3', 0.000001,
					'distamp', 1.12682721311638,
					'distamp2', 1.1,
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
					'fbdistamp', 0.47619047619048,
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
					\dur, 1 * Pseq([1],inf),
				),
		])),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Pseq([
		Pfindur(4+inf, Ppar([
			// perc

			Pbind(
				\instrument, \phyhat4,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
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
								1,0,0,1, 1,0,0,1,
								1,0,0,1, 1,0,0,1,
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,
								1,0,0,0, 0,0,0,0,
								0,0,0,1, 1,1,1,1,
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,
							],inf).coin.not,
							//\dur, 1/8 * Pseq([4/3,2/3],inf),
							\dur, 1/16,
							\amp, 0.1,
						),
			]),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],inf).coin.not,
				\out, BusDef(\fx2, \audio),
					\sustain, 0.1,
					\gain, 0.4,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
					],inf).coin.not,
					\out, BusDef(\fx2, \audio),
					\sustain, 0.1/2,
					\gain, 0.4,
					\dur, 1/16,
				)),
				

			// treb

		Pbind(
			\instrument, \fmz1,
			\note, Pseq([
				3,4,3,4,
				3,4,0,0,
			],inf),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,1,0.05) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\hpfr, ~pmodenv.(Pseq([1,2,1/2,1/4],inf), 8),
			\octave, 6,
			\dur, 1/8,
			\out, BusDef(\fx3, \audio),
			\amp, 0.1,
		),
		Pmono(\memefx,
			\inbus, BusDef(\fx3, \audio),
			\out, BusDef(\fx3s, \audio),
			\fb, 0.4,
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, Pseq([
				50,4000,
				50,2000,
			],inf),
			\freq, Pseq([
				~pmodenv.(Pseq([10,2000],1), 2),
				~pmodenv.(Pseq([12000,120],1), 2),
			],inf),
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\shift, Pseq([
				100,100,-100,
			],inf),
			\mix, 0.5,
			\dur, 1/4,
			\amp, 0.1,
		),
			Pmono(\fx_stutter,
				\freq, 200,
				\inbus, BusDef(\fx3s, \audio),
				\out, BusDef(\fx2, \audio),
				\mix, Pseq([
					0,0,0,0,
					0,0,0,1,
					1,1,1,1,
					0,0,0,0,
				],inf),
				\time, Pstep(Pseq([
					1/16, 1/16, 1/16, 1/16,
					1/16, 1/16, 1/16, 1/16,
					1/6, 1/10, 1/13, 1/6,
					1/16, 1/16, 1/16, 1/16,
				],inf),1/4)/~t,
				\fb, 0.1,
				\dur, Pser([1/4],inf),
				\amp, 0.1,
			),

			// fx

				Pmono(\ronordn,
					\inbus, BusDef(\fx1, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.01201 * Pseq([
						1,1/20
					],inf),
					'delay', 0.000010394574653723,
					'delay2', 0.0000828221925227,
					'delay3', 0.00001,
					'distamp', 0.92682721311638,
					'distamp2', 001.0,
					'distamp3', 1.9904517086311,
					'shift', -5.0,
					'shift2', -1.1344537815126,
					'shift3', -2.4789915966387,
					'shiftmix', 0.15966386554622,
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

					\eqmid1b, 6000,
					\eqrq1b, 0.6,
					\eqdb1b, 1.6,

					\freq, 200,
					\dur, 1 * Pseq([1],inf),
				),
				Pmono(\ronordn,
					\inbus, BusDef(\fx2, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.00101,
					'delay', 0.000000394574653723,
					'delay2', 0.00010828221925227,
					'delay3', 0.000001,
					'distamp', 1.12682721311638,
					'distamp2', 1.1,
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
					'fbdistamp', 0.47619047619048,
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
					\dur, 1 * Pseq([1],inf),
					\out, BusDef(\fxrev, \audio),
				),
			Pmono(\fx_reverb,
				\inbus, BusDef(\fxrev, \audio),
				\freq, 200,
				\mix, 0.3,
				\gain, 1.2,
				\fb, 0.1,
				\dur, Pser([1],inf),
				\amp, 0.1,
			),
		])),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Pseq([
		Pfindur(4+inf, Ppar([
			// perc

			Pbind(
				\instrument, \phyhat4,
				\isRest, Pseq([
					1,0,1,0, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
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
								1,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,1,
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,
							],inf).coin.not,
							//\dur, 1/8 * Pseq([4/3,2/3],inf),
							\dur, 1/16,
							\amp, 0.1,
						),
			]),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],inf).coin.not,
				\out, BusDef(\fx2, \audio),
					\sustain, 0.1,
					\gain, 0.4,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
					],inf).coin.not,
					\out, BusDef(\fx2, \audio),
					\sustain, 0.1/2,
					\gain, 0.4,
					\dur, 1/16,
				)),
				

			// treb

		Pbind(
			\instrument, \fmz1,
			\note, Pseq([
				[0,1],
				[0,1]-8,
			],inf).stutter(8),
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,1,0.05) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\hpfr, ~pmodenv.(Pseq([1,2,1/2,1/4],inf), 8),
			\octave, 6,
			\dur, 1/8,
			\out, BusDef(\fx3, \audio),
			\amp, 0.1,
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fx3, \audio),
			//\out, BusDef(\fx2),
			\fb, 0.1,
			\delay, 0.001,
			\modamp, 0.10,
			\modfreq, 30.01,
			\mix, 0.2,
			\dur, 1/4,
		),

			// fx

				Pmono(\ronordn,
					\inbus, BusDef(\fx1, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.01201 * Pseq([
						1,1/20
					],inf),
					'delay', 0.000010394574653723,
					'delay2', 0.0000828221925227,
					'delay3', 0.00001,
					'distamp', 0.92682721311638,
					'distamp2', 001.0,
					'distamp3', 1.9904517086311,
					'shift', -5.0,
					'shift2', -1.1344537815126,
					'shift3', -2.4789915966387,
					'shiftmix', 0.15966386554622,
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

					\eqmid1b, 6000,
					\eqrq1b, 0.6,
					\eqdb1b, 1.6,

					\freq, 200,
					\dur, 1 * Pseq([1],inf),
				),
				Pmono(\ronordn,
					\inbus, BusDef(\fx2, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.00101,
					'delay', 0.000000394574653723,
					'delay2', 0.00010828221925227,
					'delay3', 0.000001,
					'distamp', 1.12682721311638,
					'distamp2', 1.1,
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
					'fbdistamp', 0.47619047619048,
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
					\dur, 1 * Pseq([1],inf),
					\out, BusDef(\fxstut, \audio),
				),
			Pmono(\fx_stutter,
				\freq, 200,
				\inbus, BusDef(\fxstut, \audio),
				\mix, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,0,
				],inf)/2,
				\time, Pstep(Pseq([
					1/16, 1/8, 1/16,
					1/16, 1/16, 1/32,
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
Pdef(\part, Pdef(\plop, 
	Pseq([
		Pfindur(4+inf, Ppar([
			// perc

			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,1,0, 1,0,0,0,
					1,0,1,0, 1,1,1,1,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.4, 0.1, 0.2, 0.1,
				],inf)/3,
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
								0,0,0,1, 0,0,1,0,
								0,1,0,0, 0,1,0,1,
								0,0,0,0, 0,0,0,0,
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
					],inf).coin.not,
				\out, BusDef(\fx2, \audio),
					\sustain, 0.1,
					\gain, 0.4,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
					],inf).coin.not,
					\out, BusDef(\fx2, \audio),
					\sustain, 0.1/2,
					\gain, 0.4,
					\dur, 1/16,
				)),
				

			// treb

		Pbind(
			\instrument, \fmz1,
			\note, Pseq([
				[0,1],
				[0,2],
			],inf).stutter(8),
			\legato, Pseq([
				0.1,
			],inf) * Pseg(Pseq([1,10],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,1,0.05) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\hpfr, ~pmodenv.(Pseq([1,2,1/2,1/4],inf), 8),
			\hpfr, Pseg(Pseq([7,7],inf),8),
			\octave, 6,
			\dur, 1/8,
			\out, BusDef(\fx3, \audio),
			\amp, 0.1,
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fx3, \audio),
			\out, BusDef(\fx_rlpf,\audio),
			\fb, 0.1,
			\delay, 0.001,
			\modamp, 0.10,
			\modfreq, 30.01,
			\mix, 0.2,
			\dur, 1/4,
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\fx_rlpf, \audio),
			\lpf, ~pmodenv.(Pseq([319,1200,4000,13940],inf), 2),
			\dur, 1,
			\rq, 0.1,
			//\timingOffset, 0.1,
			//\addAction, \addToTail,
			\amp, 0.1,
		),

			// fx

				Pmono(\ronordn,
					\inbus, BusDef(\fx1, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.01201 * Pseq([
						1,1/20
					],inf),
					'delay', 0.000010394574653723,
					'delay2', 0.0000828221925227,
					'delay3', 0.00001,
					'distamp', 0.92682721311638,
					'distamp2', 001.0,
					'distamp3', 1.9904517086311,
					'shift', -5.0,
					'shift2', -1.1344537815126,
					'shift3', -2.4789915966387,
					'shiftmix', 0.15966386554622,
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

					\eqmid1b, 6000,
					\eqrq1b, 0.6,
					\eqdb1b, 1.6,

					\freq, 200,
					\dur, 1 * Pseq([1],inf),
					\out, BusDef(\fx_rhpf,\audio),
				),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\fx_rhpf, \audio),
			\mix, Pseq([
				0,1,1,1,
			],inf),
			\lpf, ~pmodenv.(Pseq([12130,212,4000,1343],inf), 2),
			\dur, 1,
			\rq, 0.1,
			//\timingOffset, 0.1,
			//\addAction, \addToTail,
			\out, BusDef(\fxstut, \audio),
			\amp, 0.1,
		),
			Pmono(\fx_stutter,
				\freq, 200,
				\inbus, BusDef(\fxstut, \audio),
				\mix, Pseq([
					0,0,1,1, 0,1,1,1,
				],inf),
				\time, Pstep(Pseq([
					1/16, 1/8, 1/16,
					1/16, 1/16, 1/32,
				],inf),1/4)/~t,
				\fb, 0.1,
				\dur, Pser([1/16],inf),
				\amp, 0.1,
			),
				Pmono(\ronordn,
					\inbus, BusDef(\fx2, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.00101,
					'delay', 0.000000394574653723,
					'delay2', 0.00010828221925227,
					'delay3', 0.000001,
					'distamp', 1.12682721311638,
					'distamp2', 1.1,
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
					'fbdistamp', 0.47619047619048,
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
					\dur, 1 * Pseq([1],inf),
				),
		])),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Pseq([
		Pfindur(4+inf, Ppar([
			// perc

			Pbind(
				\instrument, \phyhat4,
				\isRest, Pseq([
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					Pseq([
						0,0,0,1, 0,0,1,1,
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf),
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
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
								0,0,0,1, 0,0,1,0,
								0,1,0,0, 0,1,0,1,
								0,0,0,0, 0,0,0,0,
							],inf).coin.not,
							//\dur, 1/8 * Pseq([4/3,2/3],inf),
							\dur, 1/16,
							\amp, 0.1,
							\isRest, true,
						),
			]),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
				\out, BusDef(\fx2, \audio),
					\sustain, 0.1,
					\gain, 0.4,
					\dur, 1/8,
					\isRest, true,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
					],inf).coin.not,
					\out, BusDef(\fx2, \audio),
					\sustain, 0.1/2,
					\gain, 0.4,
					\dur, 1/16,
				)),
				
				// bass
		PmonoArtic(\delbass2,
			\note, Pseq([
				0,1,1,1,
			],inf),
			\legato, Pseq([
				0,0,0,0, 1,1,1,0.4,
				1,1,1,0.41, 1,1,1,0.41,
				1,1,1,0, 1,1,1,0.4,
				1,1,1,1, 1,1,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1,
			\amp, 0.1,

			'lpfr', 2.77601093560068,
			'rq', 0.069397810604479,
			'lpfr2', 2.0548273159042 * Pseq([1,1/2],inf),
			'rq2', 0.047652800371952,
			'lpmix', 0.25921569567667,
			'fb', 0.0009756305902278,
			'delay1', 0.7000003147810941,
			'distamp', 100.0688547724285,
			'distpostamp', 0.6597787422967,
			'delay2', 0.00009532098181673,
			'distamp2', 100.01762092256774,
			'distpostamp2', 0.9754399721,
			'delay3', 0.40053317803124595,
			'delay4', 0.400030830941282943,
			'delmix', 1.0710510771126,
			'gain', 1.02039742573121,
			'adsr', [ Env([ 0.0, 0.97959184646606, 1.0, 0.0 ], [ 0.10999999940395, 0.25059666607289, 0.20262526598068 ], [ -4.0, -4.0, -4.0 ], 2.0)],
			//\delay2, ~pmodenv.(Pseq(1/[1,20000,1,100000004]*1,inf), 4),
		),

			// treb

		Pbind(
			\instrument, \fmz1,
			\note, Pseq([
				[0,1],
				[0,2],
			],inf).stutter(8),
			\legato, Pseq([
				0.1,
			],inf) * Pseg(Pseq([1,10],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,1,0.05) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\hpfr, ~pmodenv.(Pseq([1,2,1/2,1/4],inf), 8),
			\hpfr, Pseg(Pseq([7,7],inf),8),
			\octave, 6,
			\dur, 1/8,
			\out, BusDef(\fx3, \audio),
			\amp, 0.1,
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fx3, \audio),
			\out, BusDef(\fx_rlpf,\audio),
			\fb, 0.1,
			\delay, 0.001,
			\modamp, 0.10,
			\modfreq, 30.01,
			\mix, 0.2,
			\dur, 1/4,
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\fx_rlpf, \audio),
			\lpf, ~pmodenv.(Pseq([319,1200,4000,13940],inf), 2),
			\dur, 1,
			\rq, 0.1,
			//\timingOffset, 0.1,
			//\addAction, \addToTail,
			\amp, 0.1,
		),

			// fx

				Pmono(\ronordn,
					\inbus, BusDef(\fx1, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.01201 * Pseq([
						1,1/20
					],inf),
					'delay', 0.000010394574653723,
					'delay2', 0.0000828221925227,
					'delay3', 0.00001,
					'distamp', 0.92682721311638,
					'distamp2', 001.0,
					'distamp3', 1.9904517086311,
					'shift', -5.0,
					'shift2', -1.1344537815126,
					'shift3', -2.4789915966387,
					'shiftmix', 0.15966386554622,
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

					\eqmid1b, 6000,
					\eqrq1b, 0.6,
					\eqdb1b, 1.6,

					\freq, 200,
					\dur, 1 * Pseq([1],inf),
					\out, BusDef(\fx_rhpf,\audio),
					\isRest, true,
				),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\fx_rhpf, \audio),
			\mix, Pseq([
				0,1,1,1,
			],inf),
			\lpf, ~pmodenv.(Pseq([12130,212,4000,1343],inf), 2),
			\dur, 1,
			\rq, 0.1,
			//\timingOffset, 0.1,
			//\addAction, \addToTail,
			\out, BusDef(\fxstut, \audio),
			\amp, 0.1,
		),
			Pmono(\fx_stutter,
				\freq, 200,
				\inbus, BusDef(\fxstut, \audio),
				\mix, Pseq([
					0,0,1,1, 0,1,1,1,
				],inf),
				\time, Pstep(Pseq([
					1/16, 1/8, 1/16,
					1/16, 1/16, 1/32,
				],inf),1/4)/~t,
				\fb, 0.1,
				\dur, Pser([1/16],inf),
				\amp, 0.1,
			),
				Pmono(\ronordn,
					\inbus, BusDef(\fx2, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.00101,
					'delay', 0.000000394574653723,
					'delay2', 0.00010828221925227,
					'delay3', 0.000001,
					'distamp', 1.12682721311638,
					'distamp2', 1.1,
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
					'fbdistamp', 0.47619047619048,
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
					\dur, 1 * Pseq([1],inf),
				),
		])),
	])
)).play;
)


/////////////////////


(
SynthDef(\distverb, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = in;
	sig = LocalIn.ar(2) * \fb.kr(0.1);
	sig1 = LPF.ar(sig, \lpf.kr(16000));
	sig = SelectX.ar(\lpmix.kr(0.5), [sig, sig1]);
	sig = sig + in;
	15.do {
		sig = AllpassL.ar(sig, 0.06, Rand(0.001,0.06) * \delayfac.kr(1), \decay.kr(3));
	};
	sig1 = ( sig*\distamp.kr(4)+\distbias.kr(4) ).ceil(in)-\distbias.kr*\distpostamp.kr(1/80);
	sig = SelectX.ar(\distmix.kr(1), [sig, sig1]);
	sig = Limiter.ar(sig);
	LocalOut.ar(sig);
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\plop, 
	Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					Pseq([
						1,0,1,0, 1,0,1,0,
						1,0,1,0, 1,0,1,0,
						1,0,1,0, 1,0,1,0,
						1,1,0,1, 1,0,1,0,
					],inf),
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.4, 0.1, 0.2, 0.1,
				],inf),
				\dur, 1/16,
				//\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
				\pan, 0,
				\amp, 0.02,
			),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,0,0,-1,
			],inf).stutter(4),
			\lpf, Pseq([
				Pseq([
					200, 200, 200, 200, 200, 200, 400, 200,
				],4),
				Pseq([
					~pmodenv.(Pseq([100,401,200,100,1904],1), 1/8,1,-4),
				],4),
			],inf),
							\legato, Pseq([
								2,0,2,0, 0,0,1,0,
								3,0,0,1, 0,0,1,0,
								0,1,0,0, 0,1,0,1,
								0,0,0,0, 4,0,0,0,
							],inf),
							\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\out, Pseq([
				0,
				0,
				0,
				BusDef(\fx1, \audio),
			],inf).stutter(8*4),
			\dur, 1/8,
			\amp, 0.1,
		),
			Pbind(\out, BusDef(\fx3))<>
			Ppar([
						Pbind(
							\instrument, \snapkickx,
							\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
							\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
							\isRest, Pseq([
								1,0,1,0, 0,0,0,0,
								0,0,0,1, 0,0,1,0,
								0,1,0,0, 0,1,0,1,
								0,0,0,0, 0,0,0,0,
							],inf).coin.not,
							//\dur, 1/8 * Pseq([4/3,2/3],inf),
							\dur, 1/8,
							\amp, 0.1,
						),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
				//\out, BusDef(\fx2, \audio),
					\sustain, 0.1,
					\gain, 0.4,
					\dur, 1/8,
				)),
			]),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,1,
						0,1,0,1, 0,1,1,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
				//\out, BusDef(\fx2, \audio),
					\sustain, 0.1/2,
					\gain, 0.3,
					\dur, 1/16,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
					],inf).coin.not,
				//	\out, BusDef(\fx2, \audio),
					\sustain, 0.1/2,
					\gain, 0.4,
					\dur, 1/16,
				)),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,

				0,12,0,-12,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,

				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,

				12,30,20-24,10,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
			],inf),
			\legato, Pseq([
					1,1,1,1, 1,0,0,0,
					1,0,0,0, 0,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\fx1, \audio),
			\amp, 0.1,
		),
		Pmono(\distverb,
			\inbus, BusDef(\fx1, \audio),
			\out, BusDef(\fx2, \audio),
			\fb, 0.00001,
			\decay,0.1,
			\distpostamp, 1/20,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\fx_rhpf,
			\inbus, BusDef(\fx2, \audio),
			\mix, Pseq([
				1,1,1,1,
			],inf),
			\hpf, Pseq([
				~pmodenv.(Pseq([10,10,200,412,4000],1), 2),
			],inf),	
			\dur, 1,
			\rq, 0.4,
			//\timingOffset, 0.1,
			//\addAction, \addToTail,
			//\out, BusDef(\fxstut, \audio),
			\amp, 0.1,
		),
		
				Pmono(\ronordn,
					\inbus, BusDef(\fx3, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.01101,
					'delay', 0.000000394574653723,
					'delay2', 0.00000828221925227,
					'delay3', 0.000001,

					'delay2', 0.20010828221925227 * Pseq([
						0.0000001,0.00000001,
						1.0000001,0.00000001,
					],inf),

					'distamp', 1.12682721311638,
					'distamp2', 1.1,
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
					'fbdistamp', 0.47619047619048,
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
					\dur, 1/4 * Pseq([1],inf),
				),
	])
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \delbass2,
			\delay1, 0.0000001,
			\delay2, 0.1000001,
			\delay3, 1.0000001,
			\delay4, 0.0000001,
			\lpfr2, 2,
			\lpmix, 1.7,
			\fb, 0.401,
			\iadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\distamp, 0.1,
			\distamp2, 1,
			\note, Pseq([
				0,2,5,-2,
			],inf),
			\octave, 3,
			\dur, 1,
			\igain, 1,
			\amp, 0.142,
		),
		
		Pbind(
			\instrument, \twik,
			\freq, Pwhite(50.0,10000),
			\dur, Pwhite(0.1,2),
			\sustain, 0.041,
			\out, BusDef(\fx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\dur, 1,
			\pos, Pseq([
				0.3,1,2,3,
			],inf),
			\amp, 0.1,
			\sustain, 0.2,
			\gain, 0.7,
			\out, BusDef(\fx1, \audio),
		),
		Pmono(\distverb,
			\inbus, BusDef(\fx1, \audio),
			\out, BusDef(\fxhpf, \audio),
			\distmix, 0.5,
			\fb, 0.01001,
			\decay,3,
			\distbias, 0,
			\distamp, 0.4,
			\distpostamp, 1/120,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\fx_rhpf,
			\inbus, BusDef(\fxhpf, \audio),
			\hpf, 400,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),

			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					Pseq([
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,0,0,0, 1,0,1,0,
						1,0,1,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0,
						1,1,0,1, 1,0,1,0,
					],inf),
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.4, 0.1, 0.2, 0.1,
				],inf),
				\dur, 1/16,
				//\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
				\pan, 0,
				\amp, 0.0071,
			),
			Pbind(\out, BusDef(\fxperc))<>
			Ppar([
						Pbind(
							\instrument, \snapkickx,
							\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
							\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
							\isRest, Pseq([
								1,0,1,0, 0,0,0,0,
								0,0,0,1, 0,0,1,0,
								0,1,0,0, 0,1,0,1,
								0,0,0,0, 0,0,0,0,
							],inf).coin.not,
							//\dur, 1/8 * Pseq([4/3,2/3],inf),
							\dur, 1/8,
							\amp, 0.1,
						),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
				//\out, BusDef(\fx2, \audio),
					\sustain, 0.1,
					\gain, 0.4,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,1,
						0,1,0,1, 0,1,1,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
				//\out, BusDef(\fx2, \audio),
					\sustain, 0.1/2,
					\gain, 0.3,
					\dur, 1/16,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
					],inf).coin.not,
				//	\out, BusDef(\fx2, \audio),
					\sustain, 0.1/2,
					\gain, 0.4,
					\dur, 1/16,
				)),
			]),
		Pmono(\distverb,
			\inbus, BusDef(\fxperc, \audio),
			\distmix, 0.5,
			\fb, 0.00001,
			\decay,0.03,
			\mix, 0.7,
			\distbias, 0,
			\distamp, 0.04,
			\distpostamp, 1/72,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \delbass2,
			\delay1, 0.0000001,
			\delay2, 0.1000001,
			\delay3, 1.0000001,
			\delay4, 0.0000001,
			\lpfr2, 2,
			\lpmix, 1.7,
			\fb, 0.401,
			\iadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\distamp, 0.1,
			\distamp2, 1,
			\note, Pseq([
				0,2,5,-2,
			],inf),
			\octave, 3,
			\dur, 1,
			\igain, 1,
			\amp, 0.142,
		),
		
		Pbind(
			\instrument, \twik,
			\freq, Pwhite(50.0,10000),
			\dur, Pwhite(0.1,2),
			\sustain, 0.041,
			\out, BusDef(\fx1, \audio),
		),
		Pbind(
			\instrument, \twik,
			\note, Pseq([
				5,
				0,
				2,
				0,
			],inf)+24,
			\dur, 1/4,
			\legato, Pseq([
				Pser([
					0
				],32),
				Pser([
					0, 0, 0, 0, 0,
					0, 0, 0, 1, 0,
					1, 0, 0, 0, 0,
					0, 0, 0, 0, 0,
					1, 0, 0, 0, 0,
					0, 0, 0, 0, 0,

				],32),
				Pser([
					2,0,1,1, 1,0,1,1,
					1,0.4,0,1, 0.4,1,1,0,
					0.4,
				],64),
			],inf) * 0.1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			//\sustain, 0.081,
			\out, BusDef(\fx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\dur, 1,
			\pos, Pseq([
				0.3,1,2,3,
			],inf),
			\amp, 0.1,
			\sustain, 0.2,
			\gain, 0.7,
			\out, BusDef(\fx1, \audio),
		),
		Pmono(\distverb,
			\inbus, BusDef(\fx1, \audio),
			\out, BusDef(\fxhpf, \audio),
			\distmix, 0.5,
			\fb, 0.01001,
			\decay,3,
			\distbias, 0,
			\distamp, 0.4,
			\distpostamp, 1/120,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\fx_rhpf,
			\inbus, BusDef(\fxhpf, \audio),
			\hpf, 400,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),

			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					Pseq([
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,0,0,0, 1,0,1,0,
						1,0,1,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0,
						1,1,0,1, 1,0,1,0,
					],inf),
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.4, 0.1, 0.2, 0.1,
				],inf),
				\dur, 1/16,
				//\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
				\pan, 0,
				\amp, 0.0071,
			),
			Pbind(\out, BusDef(\fxperc))<>
			Ppar([
						Pbind(
							\instrument, \snapkickx,
							\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
							\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
							\isRest, Pseq([
								1,0,1,0, 0,0,0,0,
								0,0,0,1, 0,0,1,0,
								0,1,0,0, 0,1,0,1,
								0,0,0,0, 0,0,0,0,
							],inf).coin.not,
							//\dur, 1/8 * Pseq([4/3,2/3],inf),
							\dur, 1/8,
							\amp, 0.1,
						),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
				//\out, BusDef(\fx2, \audio),
					\sustain, 0.1,
					\gain, 0.4,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,1,
						0,1,0,1, 0,1,1,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
				//\out, BusDef(\fx2, \audio),
					\sustain, 0.1/2,
					\gain, 0.3,
					\dur, 1/16,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
					],inf).coin.not,
				//	\out, BusDef(\fx2, \audio),
					\sustain, 0.1/2,
					\gain, 0.4,
					\dur, 1/16,
				)),
			]),
			Pseq([
				Pmono(\distverb,
					\inbus, BusDef(\fxperc, \audio),
					\distmix, 0.5,
					\fb, 0.41001,
					\decay,0.3,
					\delayfac, 0.01,
					\mix, 0.7,
					\distbias, 0,
					\distamp, 0.04,
					\distpostamp, 1/112,
					\freq, 200,
					\gain, 1.5,
					\dur, 1 * Pseq([1],4),
					\amp, 0.1,
				),
		Pmono(\distverb,
			\inbus, BusDef(\fxperc, \audio),
			\distmix, 0.5,
			\fb, 0.00001,
			\decay,0.03,
			\mix, 0.7,
			\distbias, 0,
			\distamp, 0.04,
			\distpostamp, 1/72,
			\freq, 200,
					\gain, 1.5,
			\dur, 1 * Pseq([1],4),
			\amp, 0.1,
		),
				Pmono(\distverb,
					\inbus, BusDef(\fxperc, \audio),
					\distmix, 0.5,
					\fb, 0.01001,
					\decay,0.03,
					\delayfac, 0.01,
					\mix, 0.7,
					\distbias, 0,
					\distamp, 0.04,
					\distpostamp, 1/12,
					\freq, 200,
					\dur, 1 * Pseq([1],4),
					\amp, 0.1,
				),
				Pmono(\distverb,
					\inbus, BusDef(\fxperc, \audio),
					\distmix, 0.5,
					\fb, 0.01001,
					\decay,0.03,
					\delayfac, 2.4001,
					\mix, 0.7,
					\distbias, 4,
					\distamp, 0.04,
					\distpostamp, 1/12,
					\freq, 200,
					\dur, 1 * Pseq([1],4),
					\amp, 0.1,
				),
				Pmono(\distverb,
					\inbus, BusDef(\fxperc, \audio),
					\distmix, 0.5,
					\fb, 0.00101,
					\decay,0.3,
					\delayfac, 0.1001,
					\mix, 0.7,
					\distbias, 4,
					\distamp, 3.4,
					\distpostamp, 1/12,
					\freq, 200,
					\dur, 1 * Pseq([1],4),
					\amp, 0.1,
				),
				
			],inf),
	])
)).play;
)




(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \delbass2,
			\delay1, 0.0000001,
			\delay2, 0.1000001,
			\delay3, 1.0000001,
			\delay4, 0.0000001,
			\lpfr2, 2,
			\lpmix, 1.7,
			\fb, 0.401,
			\iadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\distamp, 0.1,
			\distamp2, 1,
			\note, Pseq([
				0,2,5,-2,
			],inf),
			\octave, 3,
			\dur, 1,
			\igain, 1,
			\amp, 0.142,
		),
		
		Pbind(
			\instrument, \twik,
			\freq, Pwhite(50.0,10000),
			\dur, Pwhite(0.1,2),
			\sustain, 0.041,
			\out, BusDef(\fx1, \audio),
		),
		Pbind(
			\instrument, \twik,
			\note, Pseq([
				5,
				0,
				2,
				0,
			],inf)+24,
			\dur, 1/4,
			\legato, Pseq([
				Pser([
					0
				],32),
				Pser([
					0, 0, 0, 0, 0,
					0, 0, 0, 1, 0,
					1, 0, 0, 0, 0,
					0, 0, 0, 0, 0,
					1, 0, 0, 0, 0,
					0, 0, 0, 0, 0,

				],32),
				Pser([
					2,0,1,1, 1,0,1,1,
					1,0.4,0,1, 0.4,1,1,0,
					0.4,
				],64),
			],inf) * 0.1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			//\sustain, 0.081,
			\out, BusDef(\fx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\dur, 1/8,
			\pos, Pseq([
				0.3,1,2,3,
			],inf).stutter(8),
			\isRest, Pseq([
				1,1,0,0, 0,0,0,0,
				1,1,0,0, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
			\sustain, 0.08,
			\gain, 0.7,
			\out, BusDef(\fx1, \audio),
		),
		Pmono(\distverb,
			\inbus, BusDef(\fx1, \audio),
			\out, BusDef(\fxhpf, \audio),
			\distmix, 0.5,
			\fb, 0.01001,
			\decay,0.3,
			\distbias, 0,
			\distamp, 1.4,
			\distpostamp, 1/70,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\fx_rhpf,
			\inbus, BusDef(\fxhpf, \audio),
			\hpf, 400,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),

			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					Pseq([
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,0,0,0, 1,0,1,0,
						1,0,1,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0,
						1,1,0,1, 1,0,1,0,
					],inf),
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.4, 0.1, 0.2, 0.1,
				],inf),
				\dur, 1/16,
				//\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
				\pan, 0,
				\amp, 0.0071,
			),
			Pbind(\out, BusDef(\fxperc))<>
			Ppar([
						Pbind(
							\instrument, \snapkickx,
							\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
							\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
							\isRest, Pseq([
								1,0,1,0, 0,0,0,0,
								0,0,0,1, 0,0,1,0,
								0,1,0,0, 0,1,0,1,
								0,0,0,0, 0,0,0,0,
							],inf).coin.not,
							//\dur, 1/8 * Pseq([4/3,2/3],inf),
							\dur, 1/8,
							\amp, 0.1,
						),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
				//\out, BusDef(\fx2, \audio),
					\sustain, 0.1,
					\gain, 0.4,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,1,
						0,1,0,1, 0,1,1,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
				//\out, BusDef(\fx2, \audio),
					\sustain, 0.1/2,
					\gain, 0.3,
					\dur, 1/16,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
					],inf).coin.not,
				//	\out, BusDef(\fx2, \audio),
					\sustain, 0.1/2,
					\gain, 0.4,
					\dur, 1/16,
				)),
			]),
			Pseq([
				Pmono(\distverb,
					\inbus, BusDef(\fxperc, \audio),
					\distmix, 0.5,
					\fb, 0.41001,
					\decay,0.3,
					\delayfac, 0.01,
					\mix, 0.7,
					\distbias, 0,
					\distamp, 0.04,
					\distpostamp, 1/112,
					\freq, 200,
					\gain, 1.5,
					\dur, 1 * Pseq([1],4),
					\amp, 0.1,
				),
		Pmono(\distverb,
			\inbus, BusDef(\fxperc, \audio),
			\distmix, 0.5,
			\fb, 0.00001,
			\decay,0.03,
			\mix, 0.7,
			\distbias, 0,
			\distamp, 0.04,
			\distpostamp, 1/72,
			\freq, 200,
					\gain, 1.5,
			\dur, 1 * Pseq([1],4),
			\amp, 0.1,
		),
				Pmono(\distverb,
					\inbus, BusDef(\fxperc, \audio),
					\distmix, 0.5,
					\fb, 0.01001,
					\decay,0.03,
					\delayfac, 0.01,
					\mix, 0.7,
					\distbias, 0,
					\distamp, 0.04,
					\distpostamp, 1/12,
					\freq, 200,
					\dur, 1 * Pseq([1],4),
					\amp, 0.1,
				),
				Pmono(\distverb,
					\inbus, BusDef(\fxperc, \audio),
					\distmix, 0.5,
					\fb, 0.01001,
					\decay,0.03,
					\delayfac, 2.4001,
					\mix, 0.7,
					\distbias, 4,
					\distamp, 0.04,
					\distpostamp, 1/12,
					\freq, 200,
					\dur, 1 * Pseq([1],4),
					\amp, 0.1,
				),
				Pmono(\distverb,
					\inbus, BusDef(\fxperc, \audio),
					\distmix, 0.5,
					\fb, 0.00101,
					\decay,0.3,
					\delayfac, 0.1001,
					\mix, 0.7,
					\distbias, 4,
					\distamp, 3.4,
					\distpostamp, 1/12,
					\freq, 200,
					\dur, 1 * Pseq([1],4),
					\amp, 0.1,
				),
				
			],inf),
	])
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					Pseq([
						1,0,1,0, 1,0,1,0,
						1,0,1,0, 1,0,1,0,
						1,0,1,0, 1,0,1,0,
						1,1,0,1, 1,0,1,0,
					],inf),
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.4, 0.1, 0.2, 0.1,
				],inf),
				\dur, 1/16,
				//\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
				\pan, 0,
				\amp, 0.02,
			),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,0,0,-1,
			],inf).stutter(4),
			\note, Pseq([
				0,2,5,-2,
				0,0,0,-1,
				0,0,0,-1,
				0,0,0,-1,
			],inf).stutter(8),
			\lpf, Pseq([
				Pseq([
					200, 200, 200, 200, 200, 200, 400, 200,
				],4),
				Pseq([
					~pmodenv.(Pseq([100,401,200,100,1904],1), 1/8,1,-4),
				],4),
			],inf),
							\legato, Pseq([
								2,0,2,0, 0,0,1,0,
								3,0,0,1, 0,0,1,0,
								0,1,0,0, 0,1,0,1,
								0,0,0,0, 4,0,0,0,
							],inf),
							\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\out, Pseq([
				0,
				0,
				0,
				BusDef(\fx1, \audio),
			],inf).stutter(8*4),
			\dur, 1/8,
			\amp, 0.1,
		),
			Pbind(\out, BusDef(\fx3))<>
			Ppar([
						Pbind(
							\instrument, \snapkickx,
							\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
							\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
							\isRest, Pseq([
								1,0,1,0, 0,0,0,0,
								0,0,0,1, 0,0,1,0,
								0,1,0,0, 0,1,0,1,
								0,0,0,0, 0,0,0,0,
							],inf).coin.not,
							//\dur, 1/8 * Pseq([4/3,2/3],inf),
							\dur, 1/8,
							\amp, 0.1,
						),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
				//\out, BusDef(\fx2, \audio),
					\sustain, 0.1,
					\gain, 0.4,
					\dur, 1/8,
				)),
			]),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,1,
						0,1,0,1, 0,1,1,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
				//\out, BusDef(\fx2, \audio),
					\sustain, 0.1/2,
					\gain, 0.3,
					\dur, 1/16,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
					],inf).coin.not,
				//	\out, BusDef(\fx2, \audio),
					\sustain, 0.1/2,
					\gain, 0.4,
					\dur, 1/16,
				)),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,

				0,12,0,-12,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,

				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,

				12,30,20-24,10,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
			],inf),
			\note, Pseq([
				Pseq([
					5, 0, 2, 12,
				],1),
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,

				0,12,0,-12,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,

				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,

				12,30,20-24,10,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
			],inf).stutter(2),
			\legato, Pseq([
					1,1,1,1, 1,0,0,0,
					1,0,0,0, 0,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\fx1, \audio),
			\amp, 0.1,
		),
		Pmono(\distverb,
			\inbus, BusDef(\fx1, \audio),
			\out, BusDef(\fx2, \audio),
			\fb, 0.00001,
			\decay,0.1,
			\distpostamp, 1/20,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\fx_rhpf,
			\inbus, BusDef(\fx2, \audio),
			\mix, Pseq([
				1,1,1,1,
			],inf),
			\hpf, Pseq([
				~pmodenv.(Pseq([10,10,200,412,4000],1), 2),
			],inf),	
			\dur, 1,
			\rq, 0.4,
			//\timingOffset, 0.1,
			//\addAction, \addToTail,
			//\out, BusDef(\fxstut, \audio),
			\amp, 0.1,
		),
		
				Pmono(\ronordn,
					\inbus, BusDef(\fx3, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.01101,
					'delay', 0.000000394574653723,
					'delay2', 0.00000828221925227,
					'delay3', 0.000001,

					'delay2', 0.20010828221925227 * Pseq([
						0.0000001,0.00000001,
						1.0000001,0.00000001,
					],inf),

					'distamp', 1.12682721311638,
					'distamp2', 1.1,
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
					'fbdistamp', 0.47619047619048,
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
					\dur, 1/4 * Pseq([1],inf),
				),
	])
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \delbass2,
			\delay1, 0.0000001,
			\delay2, 0.1000001,
			\delay3, 1.0000001,
			\delay4, 0.0000001,
			\lpfr2, 2,
			\lpmix, 1.7,
			\fb, 0.401,
			\iadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\distamp, 0.1,
			\distamp2, 1,
			\note, Pseq([
				0,2,5,-2,
			],inf),
			\octave, 3,
			\dur, 1,
			\igain, 1,
			\amp, 0.142,
			\isRest, true,
		),
		
		Pbind(
			\instrument, \twik,
			\freq, Pwhite(50.0,10000),
			\dur, Pwhite(0.1,2),
			\sustain, 0.041,
			\out, BusDef(\fx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\dur, 1,
			\pos, Pseq([
				0.3,1,2,3,
			],inf),
			\amp, 0.1,
			\sustain, 1.2,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\gain, 0.7,
			\out, BusDef(\fx1, \audio),
		),
		Pmono(\distverb,
			\inbus, BusDef(\fx1, \audio),
			\out, BusDef(\fxhpf, \audio),
			\distmix, 0.5,
			\fb, 0.01001,
			\decay,3,
			\distbias, 0,
			\distamp, 0.4,
			\distpostamp, 1/120,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\fx_rhpf,
			\inbus, BusDef(\fxhpf, \audio),
			\hpf, 400,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),

			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					Pseq([
						1,0,0,0, 1,0,0,0,
					],inf),
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.4, 0.1, 0.2, 0.1,
				],inf),
				\dur, 1/16,
				//\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
				\pan, 0,
				\amp, 0.0071,
			),
			Pbind(\out, BusDef(\fxperc))<>
			Ppar([
						Pbind(
							\instrument, \snapkickx,
							\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
							\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
							\isRest, Pseq([
								1,0,1,0, 0,0,0,0,
								0,0,0,1, 0,0,1,0,
								0,1,0,0, 0,1,0,1,
								0,0,0,0, 0,0,0,0,
							],inf).coin.not,
							//\dur, 1/8 * Pseq([4/3,2/3],inf),
							\dur, 1/8,
							\amp, 0.1,
						),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
				//\out, BusDef(\fx2, \audio),
					\sustain, 0.1,
					\gain, 0.4,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,1,
						0,1,0,1, 0,1,1,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
				//\out, BusDef(\fx2, \audio),
					\sustain, 0.1/2,
					\gain, 0.3,
					\dur, 1/16,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
					],inf).coin.not,
				//	\out, BusDef(\fx2, \audio),
					\sustain, 0.1/2,
					\gain, 0.4,
					\dur, 1/16,
				)),
			]),
		Pmono(\distverb,
			\inbus, BusDef(\fxperc, \audio),
			\distmix, 0.5,
			\fb, 0.00001,
			\decay,0.03,
			\mix, 0.7,
			\distbias, 0,
			\distamp, 0.04,
			\distpostamp, 1/72,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
			\isRest, true,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \delbass2,
			\delay1, 0.0000001,
			\delay2, 0.1000001,
			\delay3, 1.0000001,
			\delay4, 0.0000001,
			\lpfr2, 2,
			\lpmix, 1.7,
			\fb, 0.401,
			\iadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\distamp, 0.1,
			\distamp2, 1,
			\note, Pseq([
				0,2,5,-2,
			],inf),
			\octave, 3,
			\dur, 1,
			\igain, 1,
			\amp, 0.142,
		),
		
		Pbind(
			\instrument, \twik,
			\freq, Pwhite(50.0,10000),
			\dur, Pwhite(0.1,2),
			\sustain, 0.041,
			\out, BusDef(\fx1, \audio),
		),
		Pmono( \siren,
			\freq, 500,
			\fm, Pseq([
				1/7,1/11,
			],inf).stutter(2),
			\isRest, Pseq([
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\fmamp, 0.9,
			\legato,2,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\dur, 1,
			\pos, Pseq([
				0.3,1,2,3,
			],inf),
			\amp, 0.1,
			\sustain, 1.2,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\gain, 0.7,
			\out, BusDef(\fx1, \audio),
		),
		Pmono(\distverb,
			\inbus, BusDef(\fx1, \audio),
			\out, BusDef(\fxhpf, \audio),
			\distmix, 0.5,
			\fb, 0.01001,
			\decay,3,
			\distbias, 0,
			\distamp, 0.4,
			\distpostamp, 1/120,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\fx_rhpf,
			\inbus, BusDef(\fxhpf, \audio),
			\hpf, 400,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),

			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					Pseq([
						1,0,0,0, 1,0,0,0,
					],inf),
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.4, 0.1, 0.2, 0.1,
				],inf),
				\dur, 1/16,
				//\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
				\pan, 0,
				\amp, 0.0071,
			),
			Pbind(\out, BusDef(\fxperc))<>
			Ppar([
						Pbind(
							\instrument, \snapkickx,
							\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
							\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
							\isRest, Pseq([
								1,0,1,0, 0,0,0,0,
								0,0,0,1, 0,0,1,0,
								0,1,0,0, 0,1,0,1,
								0,0,0,0, 0,0,0,0,
							],inf).coin.not,
							//\dur, 1/8 * Pseq([4/3,2/3],inf),
							\dur, 1/8,
							\amp, 0.1,
						),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
				//\out, BusDef(\fx2, \audio),
					\sustain, 0.1,
					\gain, 0.4,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,1,
						0,1,0,1, 0,1,1,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
				//\out, BusDef(\fx2, \audio),
					\sustain, 0.1/2,
					\gain, 0.3,
					\dur, 1/16,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
					],inf).coin.not,
				//	\out, BusDef(\fx2, \audio),
					\sustain, 0.1/2,
					\gain, 0.4,
					\dur, 1/16,
				)),
			]),
			Pseq([
		Pmono(\distverb,
			\inbus, BusDef(\fxperc, \audio),
			\dur, 1 * Pseq([1],8),
			\isRest, true,
		),
		Pmono(\distverb,
			\inbus, BusDef(\fxperc, \audio),
			\distmix, 0.5,
			\fb, 0.20001 * Pseq([
				1,0,
			],inf),
			\mix, 0.9,
			\distbias, 0,
			\distamp, 0.04,
			\distpostamp, 1/42 * Pseq([2,1/2,1,1, 1,1/10],inf),
			\freq, 200,
			\dur, 1 * Pseq([1/2],8*2),
			\amp, 0.1,
		),
		Pmono(\distverb,
			\inbus, BusDef(\fxperc, \audio),
			\distmix, 0.5,
			\fb, 0.00001,
			\decay,3.03,
			\delayfac, 0.1,
			\mix, 0.7,
			\distbias, 0,
			\distamp, 10.04,
			\distpostamp, 1/12,
			\freq, 200,
			\dur, 1 * Pseq([1],4),
			\gain, 0.5,
			\dur, 1,
			\amp, 0.1,
		),
				
			],inf),
	])
)).play;
)

{ SinOsc.ar(200 * ( SinOsc.kr(1/9) * 1 + 1 )) ! 2 * 0.1}.play;
(
SynthDef(\siren, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(400 * [1,1.1001] * ( SinOsc.ar(\fm.kr(1/11)) * \fmamp.kr(1) + 1 ));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono( \siren,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)
Pdef.defaultQuant= 1;
Pdef.defaultQuant= 4;

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \delbass2,
			\delay1, 0.0000001,
			\delay2, 0.1000001,
			\delay3, 1.0000001,
			\delay4, 0.0000001,
			\lpfr2, 2,
			\lpmix, 1.7,
			\fb, 0.401,
			\iadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\distamp, 0.1,
			\distamp2, 1,
			\note, Pstep(Pseq([
				0,2,5,-2,
			],inf),1),
			\legato, Pseq([
					4,0,0,0, 1,0,0,0,
					2,0,2,0, 0,0,1,0,
					4,0,0,0, 2,0,1,1,
					0,0,2,0, 1,3,0,0,
					2,0,1,0, 2,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
			\igain, 1,
			\amp, 0.142,
		),
		
		Pbind(
			\instrument, \twik,
			\freq, Pwhite(50.0,10000),
			\dur, Pwhite(0.1,2),
			\sustain, 0.041,
			\out, BusDef(\fx1, \audio),
		),
		Pbind(
			\instrument, \twik,
			\note, Pseq([
				5,
				0,
				2,
				0,
			],inf)+24,
			\dur, 1/4,
			\legato, Pseq([
				Pser([
					0
				],32),
				Pser([
					0, 0, 0, 0, 0,
					0, 0, 0, 1, 0,
					1, 0, 0, 0, 0,
					0, 0, 0, 0, 0,
					1, 0, 0, 0, 0,
					0, 0, 0, 0, 0,

				],32),
				Pser([
					2,0,1,1, 1,0,1,1,
					1,0.4,0,1, 0.4,1,1,0,
					0.4,
				],64),
			],inf) * 0.1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			//\sustain, 0.081,
			\out, BusDef(\fx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\dur, 1/8,
			\pos, Pseq([
				0.3,1,2,3,
			],inf).stutter(8),
			\isRest, Pseq([
				1,1,0,0, 0,0,0,0,
				1,0,1,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\sustain, 0.08,
			\gain, 0.7,
			\out, BusDef(\fx1, \audio),
		),
		Pmono(\distverb,
			\inbus, BusDef(\fx1, \audio),
			\out, BusDef(\fxhpf, \audio),
			\distmix, 0.5,
			\fb, 0.40001,
			\decay,3.3,
			\distbias, 0,
			\distamp, 1.4,
			\distpostamp, 1/30,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\fx_rhpf,
			\inbus, BusDef(\fxhpf, \audio),
			\hpf, 400,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),

			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					Pseq([
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,0,0,0, 1,0,1,0,
						1,0,1,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0,
						1,1,0,1, 1,0,1,0,
					],inf),
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.4, 0.1, 0.2, 0.1,
				],inf),
				\dur, 1/16,
				//\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
				\pan, 0,
				\amp, 0.0071,
			),
			Pbind(\out, BusDef(\fxperc))<>
			Ppar([
						Pbind(
							\instrument, \snapkickx,
							\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
							\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
							\isRest, Pseq([
								1,0,1,0, 0,0,0,0,
								0,0,0,1, 0,0,1,0,
								0,1,0,0, 0,1,0,1,
								0,0,0,0, 0,0,0,0,
							],inf).coin.not,
							//\dur, 1/8 * Pseq([4/3,2/3],inf),
							\dur, 1/8,
							\amp, 0.1,
						),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
				//\out, BusDef(\fx2, \audio),
					\sustain, 0.1,
					\gain, 0.4,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,1,
						0,1,0,1, 0,1,1,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
				//\out, BusDef(\fx2, \audio),
					\sustain, 0.1/2,
					\gain, 0.3,
					\dur, 1/16,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
					],inf).coin.not,
				//	\out, BusDef(\fx2, \audio),
					\sustain, 0.1/2,
					\gain, 0.4,
					\dur, 1/16,
				)),
			]),
			Pseq([
				Pmono(\distverb,
					\inbus, BusDef(\fxperc, \audio),
					\distmix, 0.5,
					\fb, 0.41001,
					\decay,0.3,
					\delayfac, 0.01,
					\mix, 0.7,
					\distbias, 0,
					\distamp, 0.04,
					\distpostamp, 1/112,
					\freq, 200,
					\gain, 1.5,
					\dur, 1 * Pseq([1],4),
					\amp, 0.1,
				),
		Pmono(\distverb,
			\inbus, BusDef(\fxperc, \audio),
			\distmix, 0.5,
			\fb, 0.00001,
			\decay,0.03,
			\mix, 0.7,
			\distbias, 0,
			\distamp, 0.04,
			\distpostamp, 1/72,
			\freq, 200,
					\gain, 1.5,
			\dur, 1 * Pseq([1],4),
			\amp, 0.1,
		),
				Pmono(\distverb,
					\inbus, BusDef(\fxperc, \audio),
					\distmix, 0.5,
					\fb, 0.01001,
					\decay,0.03,
					\delayfac, 0.01,
					\mix, 0.7,
					\distbias, 0,
					\distamp, 0.04,
					\distpostamp, 1/12,
					\freq, 200,
					\dur, 1 * Pseq([1],4),
					\amp, 0.1,
				),
				Pmono(\distverb,
					\inbus, BusDef(\fxperc, \audio),
					\distmix, 0.5,
					\fb, 0.01001,
					\decay,0.03,
					\delayfac, 2.4001,
					\mix, 0.7,
					\distbias, 4,
					\distamp, 0.04,
					\distpostamp, 1/12,
					\freq, 200,
					\dur, 1 * Pseq([1],4),
					\amp, 0.1,
				),
				Pmono(\distverb,
					\inbus, BusDef(\fxperc, \audio),
					\distmix, 0.5,
					\fb, 0.00101,
					\decay,0.3,
					\delayfac, 0.1001,
					\mix, 0.7,
					\distbias, 4,
					\distamp, 3.4,
					\distpostamp, 1/12,
					\freq, 200,
					\dur, 1 * Pseq([1],4),
					\amp, 0.1,
				),
				
			],inf),
	])
)).play;
)
