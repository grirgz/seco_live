(
SynthDef(\simplebass, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1,1.0001,1.001]);
	sig = sig + LFPulse.ar(freq * [1,1.0001,1.001]);
	sig = sig / 2;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);

	sig = RLPF.ar(sig, \lpf.kr(100), \rq.kr(0.5));
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\snapkickx, { |out = 0, pan = 0, amp = 0.3|
	var body, bodyFreq, bodyAmp;
	var pop, popFreq, popAmp;
	var click, clickAmp;
	var snd;

	// body starts midrange, quickly drops down to low freqs, and trails off
	bodyFreq = EnvGen.ar(\bodyfreqenv.kr(Env([261, 60, 51], [0.035, 0.08], curve: \exp)));
	bodyAmp = EnvGen.ar(\bodyenv.kr(Env.linen(0.005, 0.1, 0.3)), doneAction: 2);
	body = SinOsc.ar(bodyFreq) * bodyAmp;
	// pop sweeps over the midrange
	popFreq = XLine.kr(750, 261, 0.02);
	popAmp = EnvGen.ar(\popenv.kr(Env.linen(0.001, 0.02, 0.001))) * 0.15;
	pop = SinOsc.ar(popFreq) * popAmp;
	// click is spectrally rich, covering the high-freq range
	// you can use Formant, FM, noise, whatever
	clickAmp = EnvGen.ar(Env.perc(\clickat.kr(0.001), \clickrel.kr(0.01))) * 0.15;
	click = LPF.ar(Formant.ar(910, 4760, 2110), 3140) * clickAmp;

	snd = body + pop + click;
	snd = snd.tanh;

	Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;
SynthDef(\fm_grain_test, {arg out=0, gate = 1, amp = 1, freq=200, fratio=2, pan=0;
	var sig = FMGrain.ar(
		Impulse.ar(200), 0.14, freq, freq*fratio,
		LFNoise1.ar(500!2).range(1, 10),
	);
	sig = sig * EnvGen.kr(
		Env([0, 1, 0], [1, 1], \sin, 1),
		gate,
		timeScale:\timeScale.kr(1),
		doneAction: 2
	);
	sig = Pan2.ar(sig, pan, amp).sum;
    Out.ar(out, sig);
}).add;
)


(
SynthDef(\rono, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var lfo = { 
		SinOsc.kr(rrand(0.01,(1..8)))
	};
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr(lfo.().range(1,100)) * lfo.() )));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\rono, 
	Pseq([
		Pmono(\rono,
			\freq, Pseq([
				200,1000,
			],inf),
			\dur, 1,
			\out, BusDef(\mixer3, \audio),
			\amp, 0.1,
		);
	])
).play;
);

(
SynthDef(\rono, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var lfo = { 
		SinOsc.kr(rrand(0.01,(1..8))) * LFPulse.kr(2*~t).range(2,1);
	};
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr(lfo.().range(1,100)) * lfo.() )));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\rono, 
	Pseq([
		Pmono(\rono,
			\freq, Pseq([
				200,1000,
			],inf),
			\dur, 1,
			\amp, 0.1,
		);
	])
).play;
);

(
	~master.();
SynthDef(\rono2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var lfo = { 
		SinOsc.kr(rrand(0.01,(1..8))/100)
	};
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(lfo.().range(1,100)) * lfo.() )));
	sig = sig * ( 1 + ( SinOsc.ar(lfo.()) * 1 ));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	//sig = CombL.ar(sig, 1/~t,1/~t,10/~t) + sig;

	sig = sig + Fb { arg fb;
		var isig;
		isig = ( fb * \fb.kr(2) ) + sig;
	
		isig = Limiter.ar(isig);
		isig;
	};

	sig = Pan2.ar(sig, pan, amp).mean;
	sig = HPF.ar(sig, 800);
	Out.ar(out, sig);
}).add;
Pdef(\rono, 
	Pseq([
		Pmono(\rono2,
			\freq, Pseq([
				Pseq([
					4200,1000,
				],6),
				10000,5000,
				500,600,
			],inf),
			\out, BusDef(\mixer3, \audio),
			\dur, PdurStutter(Pseq([1,4,2,8],inf), 2),
			\amp, 0.1,
		);
	])
).play;
);

Pdef(\rono).stop

WindowDef(\main).front;




(
	~master.();
Pdef(\part, Pdef(\ronopart1,
	Ppar([

		Pbind(\out, BusDef(\mixer6))<>Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					1,1,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
					],8*14),
						0,0,0,0, 1,0,0,0,
						0,1,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.28,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,1,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],8*14),
						0,0,0,0, 0,0,0,0,
						1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,1,1,0,
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,0,1,1, 1,0,1,0, 1,0,1,0,
					1,1,0,1, 1,0,1,0, 1,0,1,0, 1,0,1,1,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),
		
				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.08 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\isRest, Pseq([
				Pseq([
		
					0,0,0,0, 1,0,0,0, 1,1,1,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 1,1,1,1, 0,1,0,0,
					0,0,0,0, 1,1,0,0, 1,1,1,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					0.1,
				],8*2)*1,
			],inf),
			\gain, 0.6,
			\dur, 1/16,
			\amp, 0.1,
		),
		]),
		Pbind(\out, BusDef(\mixer6))<>Pseq([
			Pfindur(3, Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, Plazy({ arg ev;
					Pseq([
						[ Env([261, rrand(60,84), 41], [rrand(0.02,0.035), 0.08], curve: \exp) ],
					],1);
				}).loop,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, 1/8 * Pseg(Pseq([1/2,1/4,1,2,1/2,4,1/8],inf),1/2,4),
				\amp, 0.1,
			)),
			Event.silent(1),
		],inf),
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\ronopart1,
	Ppar([

		Pbind(\out, BusDef(\mixer6))<>Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					1,1,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
					],8*14),
						0,0,0,0, 1,0,0,0,
						0,1,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.28,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,1,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],8*14),
						0,0,0,0, 0,0,0,0,
						1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\isRest, Pstep(Pseq([0,1,1,1],inf),1/2).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\dur, Pseg(Pseq([1/2,1/16,1/2,1/8],inf),1/2,4),
				\amp, 0.2,
			),
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\isRest, Pseq([
				Pseq([
					1,0,1,0,
				],4),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					0.1,0.2,
				],8*2)*2,
			],inf),
			\gain, 0.6,
			\dur, 1/16,
			\amp, 0.1,
		),
		]),
		Pmono(\ronordn,
		'wet10', 1.0,
		'mix', 0.52100840336134,
		'gain', 0.24454369503751,
		'fb', 0.0201,
		'delay', 0.000010394574653723,
		'delay2', 0.000828221925227,
		'delay3', 0.0001,
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
			\inbus, BusDef(\sendbus2, \audio),
			\dur, 1,
		),
	])
)).play;
);

Pdef(\part).clear;
(
	~master.();
Pdef(\part, Pdef(\ronopart1,
	Ppar([

		Pbind(\out, BusDef(\mixer6))<>Ppar([
		Pmono(\rono,
			\freq, Pseq([
				1000,
				7200,
			],inf),
			\dur, 1,
			\amp, 0.06,
		),
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					1,1,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
					],8*14),
						0,0,0,0, 1,0,0,0,
						0,1,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.28,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,1,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],8*14),
						0,0,0,0, 0,0,0,0,
						1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\isRest, Pstep(Pseq([
					Pseq([
						0,0,0,0
					],1),
					Pseq([
						0,1,1,1
					],1),
					Pseq([
						0,0,0,0
					],1),
				],inf),1/2).coin,
				\sustain, Pseq([0.08,0.02],inf),
				\dur, Pseg(Pseq([1/2,1/16,1/2,1/8],inf),1/2,4),
				\amp, 0.2,
			),
			Pseq([
				Pfindur(3, Pbind(
					\instrument, \snapkickx,
					\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
					\bodyfreqenv, Plazy({ arg ev;
						Pseq([
							[ Env([261, rrand(60,84), 41], [rrand(0.02,0.035), 0.08], curve: \exp) ],
						],1);
					}).loop,
					\isRest, Pseq([
						1,1,
					],inf).coin.not,
					\dur, 1/8,
					\dur, 1/8 * Pseg(Pseq([1/2,1/4,1,2,1/2,4,1/8],inf),1/2,4),
					\amp, 0.1,
				)),
				Event.silent(9),
			],inf),
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\isRest, Pseq([
				Pseq([
					1,0,1,0,
				],4),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					0.1,0.2,
				],8*2)*2,
			],inf),
			\gain, 0.6,
			\dur, 1/16,
			\amp, 0.1,
		),
		]),
		Pmono(\ronordn,
		'wet10', 1.0,
		'mix', 0.52100840336134,
		'gain', 0.24454369503751,
		'fb', 0.0201,
		'delay', 0.000010394574653723,
		'delay2', 0.000828221925227,
		'delay3', 0.0001,
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
			\inbus, BusDef(\sendbus2, \audio),
			\dur, 1,
		),
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\ronopart1,
	Ppar([

		Pbind(\out, BusDef(\mixer6))<>Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					1,1,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
					],8*14),
						0,0,0,0, 1,0,0,0,
						0,1,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.28,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,1,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],8*14),
						0,0,0,0, 0,0,0,0,
						1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
		]),
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\isRest, Pseq([
				Pseq([
					1,0,1,0,
				],4),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					0.1,
					0.1,
					0.1,
					0.2,
				],8*2)*2,
			],inf).stutter(2),
			\gain, 0.6,
			\dur, 1/16,
			\amp, 0.1,
		),
			Pbind(
				\instrument, \fm_grain_test,
				\fratio, 1/2,
				\fratio, Pseq([1],inf),
				\degree, Pseq([
					[0,2,4],
					[0,2-12,4],
					[0,2,4],
					[3,5-12,7],
				],inf),
				\out, BusDef(\mixer4, \audio),
				\octave, Pseq([4,5],inf).stutter(2),
				\legato, [
					0.7,0.7,1,
				],
				\dur, 2,
				\amp, 0.1/6,
			),
		Pmono(\ronordn,
		'wet10', 1.0,
		'mix', 1.52100840336134,
		'gain', 0.24454369503751,
		'fb', 0.0101,
		'fb', ~pmodenv.(Pseq([0.001,0.011,0.01,0.03],inf), 1),
		'delay', 0.000010394574653723,
		'delay2', 0.000828221925227,
		'delay3', 0.0001,
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
			\inbus, BusDef(\sendbus2, \audio),
			\dur, 1,
		),
	])
)).play;
);

(
	// fx for treb
	~master.();
Pdef(\part, Pdef(\ronopart1,
	Ppar([

		Pbind(\out, BusDef(\mixer6))<>Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					1,1,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
					],8*14),
						0,0,0,0, 1,0,0,0,
						0,1,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.28,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,1,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],8*14),
						0,0,0,0, 0,0,0,0,
						1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.3,1,-1) ],
					[ Env.adsr(0.01,0.1,0.8,0.1,1,-1) ],
				],inf).stutter(1),
				\dur, 1/8,
				\amp, 0.04 * Pseq([1,0.2],inf),
			),
		]),
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
					1,0,0,1, 1,0,0,0,
					0,0,0,0, 1,0,1,0,
				],4),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					0.1,
					0.1,
					0.1,
				],8*2)*2,
			],inf).stutter(2),
			\gain, 0.6,
			\dur, 1/16,
			\amp, 0.1,
		),
			Pbind(
				\instrument, \fm_grain_test,
				\fratio, 1/2,
				\fratio, Pseq([1],inf),
				\note, Pseq([
					[1,7],
					[2,4],
					[2,4],
					[9,4],
				],inf).stutter(2),
				\out, BusDef(\mixer4, \audio),
				\octave, Pseq([5,5,4,6,3,5],inf).stutter(2),
				\legato, Pseq([
						6,0,0,0, 0,0,2,0,
						6,0,0,0, 0,0,0,1,
						3,0,0,3, 0,0,2,0,
						2,0,1,1, 0,0,2,0,

						3,0,0,3, 0,0,2,0,
						1,0,2,0, 2,0,2,0,
						4,0,0,0, 2,0,2,0,
						2,0,5,0, 0,0,0,1,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\timeScale, 0.1,
				\legato, Pkey(\legato) * [
					0.9,0.71,
				],
				\dur, 1/4,
				\amp, 0.1/16,
			),
		Pmono(\ronordn,
		'wet10', 1.0,
		'mix', 1.52100840336134,
		'gain', 0.24454369503751,
		'fb', ~pmodenv.(Pseq([0.001,0.011,0.01,0.03],inf), 1),
		'fb', 0.08,
		'delay', 0.00000010394574653723,
		'delay2', 0.00000828221925227,
		'delay3', 0.0000001,
		'distamp', 0.42682721311638,
		'distamp2', 000.5,
		'distamp3', 0.5904517086311,
		'shift', -5.0,
		'shift2', -1.1344537815126,
		'shift3', -0.4789915966387,
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
			\inbus, BusDef(\sendbus2, \audio),
			\dur, 1,
		),
	])
)).play;
);

////////////////



(
	~master.();
Pdef(\part, Pdef(\ronopart1,
	Ppar([

		Pbind(\out, BusDef(\mixer6))<>Ppar([
			Pfindur(1,
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 74, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, 1/8 * Pseg(Pseq([1/2,1/8],inf),1,-4),
				\amp, 0.1,
			)).loop,
		]),
	])
)).play;
);

(

	SynthDef(\ronordn, { arg out=0, gate=1;
		var sig;
		var si, env = ();
		var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 

		thisThread.randSeed = 740492;

		sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
		si = sig;
		sig = { arg si, env;
			si = (si * 10.rand * \distamp.kr).tanh / 2;
			si = SelectX.ar(\shiftmix.kr, [
				si,
				FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2,
			]);
			si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
			BRF.ar(si, exprand(100,10000)* \brffac.kr(1), ( 0.5.rand * \brfrqfac.kr(1) ) + 0.01) + ( si / 4 );
			BRF.ar(si, exprand(100,10000)* \brffac.kr(1), ( 0.5.rand * \brfrqfac.kr(1) ) + 0.01) + ( si / 4 );
			si = (si * 10.rand * \distamp3.kr).tanh / 2;
			si = [
				{ arg si, env;
					si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
					si = (si * 10.rand * \distamp.kr).tanh / 2;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
					si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
				}.value(si, env);

			].mean;
			si = SelectX.ar(\shiftmix.kr, [
				si,
				FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift3.kr) + si / 1.2,
			]);
			si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
			si = (si * 10.rand * \distamp.kr).tanh / 2;
		}.value(si, env);

		sig = Limiter.ar(sig);
		LocalOut.ar(sig);

		sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(0));
		//sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(0));
		//sig = HPF.ar(sig, \ehpf.kr(140), \ehprq.kr(1));
		//sig = LPF.ar(sig, \elpf.kr(10000), \elprq.kr(1));
		sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
		sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
		sig = sig * \gain.kr(1);
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
		Out.ar(out, sig);

	}).add;


	Pbind(
		'wet10', 1.0,
		'mix', 0.52100840336134,
		'gain', 2.4454369503751,
		'fb', 0.0001,
		'delay', 0.00010394574653723,
		'delay2', 0.080828221925227,
		'delay3', 0.0001,
		'distamp', 0.42682721311638,
		'distamp2', 100.0,
		'distamp3', 8.9904517086311,
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
	)


);

///////////////////////////////


(
SynthDef(\brou, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


Pkey

(
(Pbind(
		\dur,0.15,
		\degree, Pseries(0,1)%8,
		\degree, Pwrand([0,Pkey(\degree).keep(1)],[0.9,0.1],inf)
).play)
)

Pattern

(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0,2,34]),
	\dur, 1,
	\amp, 0.1,
)).play;
);

(
Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 1,
	\amp, 0.1,
);
)

