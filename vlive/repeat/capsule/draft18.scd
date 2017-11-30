PatKitDef(\ksh2b).edit
PatKitDef(\ksh2b).presetCompileString.editorInsert
(
PatKitDef('ksh2b').targets = [
	StepEvent.newFrom((pos: 0.53160997732426, instrument: 'playersec', gain: 0.43224671703362, bufnum: BufDef('loop/kicksnarehat2.flac'), sustain: 1)),
	StepEvent.newFrom((pos: 4.5360997732426, instrument: 'playersec', gain: 0.43574427961076, bufnum: BufDef('loop/kicksnarehat2.flac'), sustain: 1)),
	StepEvent.newFrom((instrument: 'playersec')),
	nil,
	StepEvent.newFrom((pos: 0.69823129251701, instrument: 'playersec', gain: 0.43574427961076, bufnum: BufDef('loop/kicksnarehat2.flac'), sustain: 1)),
	StepEvent.newFrom((pos: 17.598752834467, instrument: 'playersec', gain: 0.43574427961076, bufnum: BufDef('loop/kicksnarehat2.flac'), sustain: 1)),
	nil,
	nil,
	StepEvent.newFrom((pos: 4.7151700680272, instrument: 'playersec', gain: 0.43574427961076, bufnum: BufDef('loop/kicksnarehat2.flac'), sustain: 1)),
	StepEvent.newFrom((pos: 9.6393197278912, instrument: 'playersec', gain: 0.43574427961076, bufnum: BufDef('loop/kicksnarehat2.flac'), sustain: 1)),
	StepEvent.newFrom((pos: 14.168911564626, instrument: 'playersec', gain: 0.43574427961076, bufnum: BufDef('loop/kicksnarehat2.flac'), sustain: 1)),
	StepEvent.newFrom((pos: 14.174648526077, instrument: 'playersec', gain: 0.43574427961076, bufnum: BufDef('loop/kicksnarehat2.flac'), sustain: 1)),
	nil,
	nil,
	nil,
	nil,
	StepEvent.newFrom((pos: 1.5487301587302, instrument: 'playersec', gain: 0.43574427961076, bufnum: BufDef('voices/kaspi.flac'), sustain: 1)),
	StepEvent.newFrom((pos: 8.9065079365079, instrument: 'playersec', gain: 0.43574427961076, bufnum: BufDef('voices/kaspi.flac'), sustain: 1)),
	StepEvent.newFrom((pos: 12.742176870748, instrument: 'playersec', gain: 0.43574427961076, bufnum: BufDef('voices/kaspi.flac'), sustain: 1)),
];
);
(
SynthDef(\trebi, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = Saw.ar(freq * ( 1 + ( SinOsc.ar(freq*\fmr.kr(1)*[1,1.01]) * 1 )));
	sig = RLPF.ar(sig, \lpf.kr(1100), \rq.kr(0.5)) * 2;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\gegefx, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sigx;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = LocalIn.ar(2) * \fb.kr(0.9);
	sig = sig + in;
	//sig = FreqShift.ar(sig, \shift.kr(100)) + sig;
	//sig = sig * ( 1 + ( SinOsc.ar(freq) * 1 ));

	sig = DelayC.ar(sig, 1, \delays1.kr(rrand(0.0001,0.4)) * SinOsc.kr(3.7).range(1,1.001) * \delay1.kr(1)) + sig;
	sigx = sig;
	sig = DelayC.ar(sig, 1, \delays2.kr(rrand(0.0001,0.4))* \delay2.kr(1));
	sig = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = sig + sigx;
	sig = DelayC.ar(sig, 1, \delays3.kr(rrand(0.0001,0.4)) * SinOsc.kr(3.2).range(1,1.001)* \delay3.kr(1)) + sig;

	sig1 = Compander.ar(sig, in, \cpt.kr(0.04), \cpbelow.kr(1.701), \cpabove.kr(1), \cpclamp.kr(0.01), \cprelax.kr(2.1));
	sig = SelectX.ar(\compmix.kr(1), [sig, sig1]);

	sig1 = ( sig*\mdistamp.kr(10) ).tanh * \mdistpostamp.kr(1/2);
	sig = SelectX.ar(\mdistmix.kr(0), [sig, sig1]);

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);

	sig = Limiter.ar(sig);
	LocalOut.ar(sig);

	sig = sig /2;
	sig = RLPF.ar(sig, \lpf.kr(15000,0.6));
	sig = HPF.ar(sig, \hpf.kr(150));
	//sig = Limiter.ar(sig * \limit.kr(1.2)) / \limit.kr;
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\clik, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * LFNoise0.kr(4).range(1,2));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\monoclik, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(3.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\drono, { arg out=0, freq=200, pan=0, amp=0.1, gate=1;
	var sig;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr(freq*1.123) * 1 ))) * LFSaw.ar(freq*4/3 * SinOsc.kr(1/12).range(1.1,1)) ;
	sig = RLPF.ar(sig, \lpf.kr(3000) * LFNoise1.ar(1/13!4).range(1/4,4), \rq.kr(0.5) * LFNoise1.ar(1/13!4).range(1/4,2)).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\sendtoarbus, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0,1,0.01),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
);


(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\fx))<>
		Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,1,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,1,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\speed, 0.98,
				\sustain, 0.12,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,1,
					0,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.09,
				\speed, 0.98,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,1,0,1,
					1,0,1,1, 0,1,1,0, 1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\sustain, 0.011,
				\adsr, Pseq([
					[ Env.adsr(0.07,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.1,
				\gain, Pkey(\gain) * Pseq([
					0.3,0.7,
				],inf),
				\dur, 1/16,
				\amp, 0.1,
			)),
		]),
		Pbind(
			\out, BusDef(\fx, \audio),
			\out, BusDef(\mixer3, \audio),
			\instrument, \trebi,
			\note, Pstep(Pseq([
				5,1,
			],inf),2),
			\octave, 3,
			\dur, 1/8,
			\lpf, ~pmodenv.(Pseq([1,2,1,4]*400,inf), 8),
			\amp, ~pmodenv.(Pseq([0,1,1,1]*0.1*0.1,inf), 2),
		),
		Pmono(\medelfx2,
			\inbus, BusDef(\fx, \audio),
			\mix, Pseq([
				0.6,
			],inf),
			\compmix, 1,
			\fb, Pseg(Pseq([0,1],inf),8),
			\fb, Pseq([
				Pser([
					0.0005,
				],12),
				Pser([
					0.0071,
				],4),
				//0,
			],inf),
			\delays1, Pseq([
				[ [ 0.00001,0.000005,0.00001,0.00001 ].rand ],
			],inf),
			\delays2, Pseq([
				//[ [ 0.00001,0.0005,0.00001,0.00001 ].rand ],
				[ [ 0.00001,0.70005,0.70001,0.70001 ].rand ],
			],inf),
			\delays3, Pseq([
				[ [ 0.00001,0.00005,0.00001,0.00001 ].rand ],
				[ [ 0.00001,0.00005,0.00001,0.00001 ].rand ],
				[ [ 0.00001,0.00005,0.00001,0.00001 ].rand ],
				[ [ 0.31001,0.70005,0.60001,0.70001 ].rand ],
			].debug("sd"),inf).stutter(1),
			\hpf, 40,
			\limit, 5,
			\distamp, 80,
			\gain, 0.25,
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 500,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
)



Pdef(\part).clear

(
Pdef(\part, Pdef(\plop, 
	Ppar([

		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0, 0,0,0,1, 0,0,0,0,
				0,1,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,1,
				0,0,1,0, 0,0,0,0, 0,0,0,0, 0,1,1,0,
			],inf).coin.not,
			\sustain, 0.051,
			\dur, 1/16,
			\gain, 0.2,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 9,
			\isRest,
				Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,1,0,0,

					1,0,1,0, 1,0,1,0,
					1,1,1,0, 1,0,1,1,

					1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,1,0,0,

					1,0,1,0, 1,0,1,0,
					1,1,1,0, 1,0,1,1,
				],inf).coin.not,
			\sustain, 0.021,
			\gain, 0.2,
			\dur, 1/16,
			\amp, 0.1,
		)),
		
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\out, BusDef(\fx, \audio),
				\speed, 0.98,
				\sustain, 0.12,
				\gain, 0.01,
				\dur, 1/8,
				\amp, 0.1,
			)),
		Pbind(
			\instrument, \default,
			\note, Pdefn(\chords,Pseq([
				Pser([
					-1,-1,
				],8*3),
				Pser([
					3,4,
				],8),
				Pser([
					0,0,
				],8*3),
				Pser([
					3,4,
				],8),
			],inf)),
			\isRest, Pseq([
				1,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\octave, Pseq([
				4,3,
			],inf).stutter(8),
			\sustain, 0.1,
			\dur, 1/8,
			\out, BusDef(\fx, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\note, Pdefn(\chords),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,1,0,1, 1,0,0,0,
				0,0,1,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\octave, Pseq([
				5,6,
			],inf).stutter(8),
			\sustain, 0.1,
			\dur, 1/8,
			\out, BusDef(\fx, \audio),
			\amp, 0.1,
		),
		Pmono(\gegefx,
			\inbus, BusDef(\fx, \audio),
			\fb, 0.01,
			\compmix,0,
			\delays1, Pseq([
				[{ 0.7.rand }!4],
				[{ 0.000007.rand }!4],
			],inf),
			\delays2, Pseq([
				[{ 0.000007.rand }!4]
			],inf),
			\delays3, Pseq([
				[{ 0.7.rand }!4]
			],inf),
			\gain, 0.5,
			\distamp,80,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		);
		
	])
)).play;
)

(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([

		Pbind(\out, BusDef(\mixer5))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0, 0,0,0,1, 0,0,0,0,
					0,1,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,1,
					0,0,1,0, 0,0,0,0, 0,0,0,0, 0,1,1,0,
				],inf).coin.not,
				\sustain, 0.051,
				\dur, 1/16,
				\gain, 0.2,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest,
					Pseq([
						1,0,0,0, 1,0,0,0,
						1,0,0,0, 1,1,0,0,
			
						1,0,1,0, 1,0,1,0,
						1,1,1,0, 1,0,1,1,
			
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 1,1,0,0,
			
						1,0,1,0, 1,0,1,0,
						1,1,1,0, 1,0,1,1,
					],inf).coin.not,
				\sustain, 0.021,
				\gain, 0.2,
				\dur, 1/16,
				\amp, 0.1,
			)),
		]),
		
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\out, BusDef(\fx, \audio),
				\speed, 0.98,
				\sustain, 0.12,
				\gain, 0.01,
				\dur, 1/8,
				\amp, 0.1,
			)),
		Pbind(
			\instrument, \clik,
			\freq, Pwhite(300,1000.0),
			\sustain, 0.1,
			\dur, 1/8,
			\out, BusDef(\fx, \audio),
			\amp, 0.01,
		),
		Pmono(\gegefx,
			\inbus, BusDef(\fx, \audio),
			\fb, ~pmodenv.(Pseq([0.001,0.002],inf), 8),
			\compmix,0.5,
			\delays1, Pseq([
				[{ 0.000007.rand }!4],
			],inf),
			\delays2, Pseq([
				[{ 0.000007.rand }!4]
			],inf),
			\delays3, Pseq([
				[{ 0.7.rand }!4]
			],inf),
			\delay3, ~pmodenv.(Pseq(1/[1,24],inf), 8),
			\gain, 0.5,
			\distamp, ~pmodenv.(Pseq([1,200],inf), 8),
			\hpf, 140,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		);
		
	])
)).play;
)


(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([

		Pbind(\out, BusDef(\mixer5))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,1,1, 1,0,1,  0,0,0, 0,0,0,
					1,1,0, 1,1,1,  0,0,0, 0,0,1,
					1,0,0, 1,0,0,  0,0,0, 1,0,0,
					1,1,0, 1,0,0,  0,0,0, 0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/12,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\pos, 2.45,
				\pos, 2.15,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.05,
				\dur, 1/16,
				\gain, 0.7,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\pos, 2.45,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,
					0,0,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\dur, 1/16,
				\gain, 0.7,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,1, 
					0,0,0,1, 0,0,0,0, 
					0,0,0,0, 0,0,0,1, 
					0,0,0,0, 0,0,0,0, 
					0,0,0,0, 0,0,0,1, 
					0,1,0,0, 0,0,0,0, 
				],inf).coin.not,
				\sustain, 0.051,
				\dur, 1/8,
				\gain, 0.2,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest,
					Pseq([
						1,0,0,0, 1,0,0,0,
					],inf).coin.not,
				\sustain, 0.021,
				\gain, 0.2,
				\dur, 1/16,
				\amp, 0.1,
			)),
		]),
		
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,1,1,1,
				],inf).coin.not,
				\out, BusDef(\fx, \audio),
				\speed, 0.98,
				\sustain, 0.04,
				\gain, 0.01,
				\dur, 1/8,
				\amp, 0.1,
			)),
		Pbind(
			\instrument, \clik,
			\freq, Pwhite(300,1000.0),
			\isRest, Pseq([
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\out, BusDef(\fx, \audio),
			\amp, 0.03,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				1,0,0,0,
			],inf).stutter(4),
			\octave, 3,
			\isRest, Pseq([
				Pseq([
					1,0,1,0,
				],1*12),
				Pseq([
					0,0,0,0,
				],1*4),
			],inf).coin.not,
			\sustain, 0.2,
			\dur, 1/8,
			\out, BusDef(\fx, \audio),
			\amp, 0.2,
		),
		Pmono(\gegefx,
			\inbus, BusDef(\fx, \audio),
			\fb, ~pmodenv.(Pseq([0.01,0.008],inf), 8),
			\fb, Pseq([
				0.01,
				0,
			],inf),
			\compmix,0.5,
			\delays1, Pseq([
				[{ 0.700007.rand }!4],
			],inf),
			\delays2, Pseq([
				[{ 0.000007.rand }!4]
			],inf),
			\delays3, Pseq([
				[{ 0.7.rand }!4]
			],inf),
			\delay3, ~pmodenv.(Pseq(1/[1,1.2],inf), 8),
			\gain, Pseq([
				0.5,0.5, 0.5,0.5,
				0.0,0.5, 0.5,0.5,
			],inf),
			\distamp, ~pmodenv.(Pseq([81,10,50,200],inf), 2),
			\hpf, 140,
			\freq, 200,
			\dur, 1/4,
			\amp, 0.1,
		);
		
	])
)).play;
)


(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([

		Pbind(\out, BusDef(\mixer5))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,1,1, 1,0,1,  0,0,0, 0,0,0,
					1,1,0, 1,1,1,  0,0,0, 0,0,1,
					1,0,0, 1,0,0,  0,0,0, 1,0,0,
					1,1,0, 1,0,0,  0,0,0, 0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/12,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\pos, 2.45,
				\pos, 2.15,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.05,
				\dur, 1/16,
				\gain, 0.7,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\pos, 2.45,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,
					0,0,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\dur, 1/16,
				\gain, 0.7,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,1, 
					0,0,0,1, 0,0,0,0, 
					0,0,0,0, 0,0,0,1, 
					0,0,0,0, 0,0,0,0, 
					0,0,0,0, 0,0,0,1, 
					0,1,0,0, 0,0,0,0, 
				],inf).coin.not,
				\sustain, 0.051,
				\dur, 1/8,
				\gain, 0.2,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest,
					Pseq([
						1,0,0,0, 1,0,0,0,
					],inf).coin.not,
				\sustain, 0.021,
				\gain, 0.2,
				\dur, 1/16,
				\amp, 0.1,
			)),
		]),
		
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx, \audio),
				\speed, 0.98,
				\sustain, 0.04,
				\gain, 0.01,
				\dur, 1/8,
				\amp, 0.1,
			)),
		PmonoArtic(\monoclik,
			\freq, 65,
			\out, BusDef(\fx, \audio),
			\legato, Pseq([
					1,1,1,1, 1,0.81,0,0.4,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, ~pmodenv.(Pseq([1,2,1/2,4]*0.051,inf), 2),
		),
		Pmono(\gegefx,
			\inbus, BusDef(\fx, \audio),
			\fb, ~pmodenv.(Pseq([0.01,0.008],inf), 8),
			\fb, Pseq([
				0.1,
			],inf),
			\compmix,0.5,
			\delays1, Pseq([
				[{ 0.000007.rand }!4],
			],inf),
			\delays2, Pseq([
				[{ 0.000107.rand }!4]
			],inf),
			\delays3, Pseq([
				[{ 0.000107.rand }!4]
			],inf),
			\delay3, ~pmodenv.(Pseq(1/[1,1.2],inf), 8),
			\gain, Pseq([
				0.5,0.2, 
			],inf),
			\distamp, 4,
			\hpf, 40,
			\lpf, 400,
			\freq, 200,
			\dur, 1/4,
			\amp, 0.1,
		);
		
	])
)).play;
)


(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\mixer5))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\pos, 2.45,
				\pos, 2.15,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.05,
				\dur, 1/16,
				\gain, 0.7,
				\amp, 0.1,
				\isRest, true,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\pos, 2.45,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,
					0,0,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\dur, 1/16,
				\gain, 0.7,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,1, 
					0,0,0,1, 0,0,0,0, 
					0,0,0,0, 0,0,0,1, 
					0,0,0,0, 0,0,0,0, 
					0,0,0,0, 0,0,0,1, 
					0,1,0,0, 0,0,0,0, 
				],inf).coin.not,
				\sustain, 0.051,
				\dur, 1/8,
				\gain, 0.2,
				\amp, 0.1,
				\isRest, true,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest,
					Pseq([
						1,0,0,0, 1,0,0,0,
					],inf).coin.not,
				\sustain, 0.021,
				\gain, 0.2,
				\dur, 1/16,
				\amp, 0.1,
			)),
		]),
		Pmono(\drono,
			\freq, 200,
			\dur, 1/8,
			\legato, Pseq([
					1,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\fx, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\dur, 1/8,
			\isRest, Pseq([
				1,1,1,1, 1,0,1,1,
			],inf).coin.not,
			\out, BusDef(\fx2, \audio),
			\freq, Pseq([
				~pmodenv.(Pseq([200,200,200,200,1004],1), Pseq([1,1,1,1],inf)),
			],inf),
			\amp, 0.1,
		),
		PmonoArtic(\drono,
			\freq, 400,
			\dur, 1/8,
			\legato, Pseq([
					1,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\fx, \audio),
			\amp, 0.1,
		),
		Pmono(\gegefx,
			\inbus, BusDef(\fx2, \audio),
			\fb, 0.001,
			\compmix,0,
			\delay1, ~pmodenv.(Pseq([400900,0],inf), 2),
			\delays1, Pseq([
				[{ 0.000007.rand }!4],
			],inf),
			\delays2, Pseq([
				[{ 0.000007.rand }!4]
			],inf),
			\delays3, Pseq([
				[{ 0.0007.rand }!4]
			],inf),
			\gain, Pseq([
				//1,0,0,0, 1,0,0,1,
				1,1,1,1, 1,1,1,1,
			],inf)*0.4,
			\distamp,18,
			\freq, 200,
			\dur, 1/8,
			\amp, 0.1,
		),
		
		Pmono(\gegefx,
			\inbus, BusDef(\fx, \audio),
			\fb, 0.001,
			\compmix,0,
			\delay1, ~pmodenv.(Pseq([400900,0],inf), 2),
			\delays1, Pseq([
				[{ 0.000007.rand }!4],
			],inf),
			\delays2, Pseq([
				[{ 0.000007.rand }!4]
			],inf),
			\delays3, Pseq([
				[{ 0.0007.rand }!4]
			],inf),
			\gain, Pseq([
				//1,0,0,0, 1,0,0,1,
				0,0,0,0, 1,1,1,1,
			],inf)*0.4,
			\distamp,18,
			\freq, 200,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
)

(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\mixer5))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\pos, 2.45,
				\pos, 2.15,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\dur, 1/16,
				\gain, 0.7,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\pos, 2.45,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,
					0,0,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\dur, 1/16,
				\gain, 0.7,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,1, 
					0,0,0,1, 0,0,0,0, 
					0,0,0,0, 0,0,0,1, 
					0,0,0,0, 0,0,0,0, 
					0,0,0,0, 0,0,0,1, 
					0,1,0,0, 0,0,0,0, 
				],inf).coin.not,
				\sustain, 0.051,
				\dur, 1/8,
				\gain, 0.2,
				\amp, 0.1,
				\isRest, true,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest,
					Pseq([
						1,0,0,0, 1,0,0,0,
					],inf).coin.not,
				\sustain, 0.021,
				\gain, 0.2,
				\dur, 1/16,
				\amp, 0.1,
			)),
		]),
		Pmono(\drono,
			\freq, 200,
			\dur, 1/8,
			\legato, Pseq([
					1,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\fx, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\dur, 1/16,
			\isRest, Pseq([
				1,0,0,0, 1,0,1,1,
			],inf).coin.not,
			\out, BusDef(\fx2, \audio),
			\sustain, 0.01,
			\freq, Pwalk([
				(1..8) * 93 + 234
			].flat,Pseq([
				Prand([
					1,0,-1,
				],1).stutter(Pwhite(1,8)),

			],inf)),
			\amp, 0.1,
		),
		PmonoArtic(\drono,
			\freq, 400,
			\dur, 1/8,
			\legato, Pseq([
					1,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\fx, \audio),
			\amp, 0.1,
		),
		Pmono(\gegefx,
			\inbus, BusDef(\fx2, \audio),
			\fb, 0.001,
			\compmix,0,
			\delay2, ~pmodenv.(Pseq([40000,100,100,100],inf), 4),
			\delays1, Pseq([
				[{ 0.000007.rand }!4],
			],inf),
			\delays2, Pseq([
				[{ 0.000007.rand }!4]
			],inf),
			\delays3, Pseq([
				[{ 0.0007.rand }!4]
			],inf),
			\gain, Pseq([
				//1,0,0,0, 1,0,0,1,
				1,1,1,1, 1,1,1,1,
			],inf)*0.4,
			\distamp,48,
			\freq, 200,
			\dur, 1/8,
			\amp, 0.1,
		),
		
		Pmono(\gegefx,
			\inbus, BusDef(\fx, \audio),
			\fb, 0.001,
			\compmix,0,
			\delay1, ~pmodenv.(Pseq([40000,0],inf), 2),
			\delays1, Pseq([
				[{ 0.000007.rand }!4],
			],inf),
			\delays2, Pseq([
				[{ 0.000007.rand }!4]
			],inf),
			\delays3, Pseq([
				[{ 0.0007.rand }!4]
			],inf),
			\gain, Pseq([
				//1,0,0,0, 1,0,0,1,
				0,0,0,0, 1,1,1,1,
			],inf)*0.4,
			\distamp,18,
			\freq, 200,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
)



(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\mixer5))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\pos, 2.45,
				\pos, 2.15,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\dur, 1/16,
				\gain, 0.7,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\pos, 2.45,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,
					0,0,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\dur, 1/16,
				\gain, 0.7,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,1, 
					0,0,0,1, 0,0,0,0, 
					0,0,0,0, 0,0,0,1, 
					0,0,0,0, 0,0,0,0, 
					0,0,0,0, 0,0,0,1, 
					0,1,0,0, 0,0,0,0, 
				],inf).coin.not,
				\sustain, 0.051,
				\dur, 1/8,
				\gain, 0.2,
				\amp, 0.1,
				\isRest, true,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest,
					Pseq([
						1,0,0,0, 1,0,0,0,
						1,0,0,0, 0,0,0,0,
					],inf).coin.not,
				\sustain, 0.021,
				\gain, 0.2,
				\dur, 1/16,
				\amp, 0.1,
			)),
		]),
		Pmono(\drono,
			\freq, 200,
			\dur, 1/8,
			\legato, Pseq([
					1,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\fx, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\dur, 1/16,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\out, BusDef(\fx2, \audio),
			\sustain, 0.01,
			\freq, Pwalk([
				(1..8) * 93 + 234
			].flat,Pseq([
				Prand([
					1,0,-1,
				],1).stutter(Pwhite(1,8)),

			],inf)),
			\amp, 0.1,
		),
		PmonoArtic(\drono,
			\freq, 400,
			\dur, 1/8,
			\legato, Pseq([
					1,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\fx, \audio),
			\amp, 0.1,
		),
		Pmono(\gegefx,
			\inbus, BusDef(\fx2, \audio),
			\fb, 0.001,
			\compmix,0,
			\delay2, ~pmodenv.(Pseq([40000,100,100,100],inf), 4),
			\delays1, Pseq([
				[{ 0.000007.rand }!4],
			],inf),
			\delays2, Pseq([
				[{ 0.000007.rand }!4]
			],inf),
			\delays3, Pseq([
				[{ 0.0007.rand }!4]
			],inf),
			\gain, Pseq([
				//1,0,0,0, 1,0,0,1,
				1,1,1,1, 1,1,1,1,
			],inf)*0.4,
			\distamp,48,
			\freq, 200,
			\dur, 1/8,
			\amp, 0.1,
		),
		
		Pmono(\gegefx,
			\inbus, BusDef(\fx, \audio),
			\fb, 0.001,
			\compmix,0,
			\delay1, ~pmodenv.(Pseq([40000,0],inf), 2),
			\delays1, Pseq([
				[{ 0.000007.rand }!4],
			],inf),
			\delays2, Pseq([
				[{ 0.000007.rand }!4]
			],inf),
			\delays3, Pseq([
				[{ 0.0007.rand }!4]
			],inf),
			\gain, Pseq([
				//1,0,0,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,0,0,
			],inf)*0.4,
			\distamp,18,
			\freq, 200,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
)


////////////////////////////


(
~algofm = { arg freq=3200, pan=0, amp=0.1, gate=1;
	var sig;
	var op;
	var randfreq;
	var freqfac1 = \freqfac1.kr(1);
	var freqfac2 = \freqfac2.kr(1);
	var freqfacstr = Pseq([
		freqfac1, freqfac2
	],inf).asStream;

	op = { arg freq;
		[
			LFSaw.ar(freq),
			LFPulse.ar(freq),
			LFCub.ar(freq),
			SinOsc.ar(freq),
			WhiteNoise.ar,
		].choose;
	};

	randfreq = {
		exprand(1/20,14000)* freqfacstr.next;
	};

	sig = op.(exprand(200, 14000) );

	15.do { arg idx;
		var algos = [
			{ op.(sig * exprand(0.01,2) + 1 * randfreq.value); }, // fm
			{ op.(sig * exprand(0.01,2) + 1 * randfreq.value) + sig; }, // fm + sig
			{ sig * exprand(0.01,2) + 1 * op.(randfreq.value); }, // am
			{ sig * op.(randfreq.value); }, // ring
			{ sig + op.(randfreq.value); }, // sum
		];
		sig = algos.choose.value;
	};

	sig = LPF.ar(sig, \lpf.kr(14000));
	sig = HPF.ar(sig, \hpf.kr(140));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
};
SynthDef(\algofm_t1, { arg out=0; 
	var sig;
	thisThread.randSeed = 26142;
	sig = SynthDef.wrap(~algofm);
	Out.ar(out, sig);
}).add;
SynthDef(\algofm_t2, { arg out=0; 
	var sig;
	thisThread.randSeed = 26742;
	sig = SynthDef.wrap(~algofm);
	Out.ar(out, sig);
}).add;
SynthDef(\algofm_t3, { arg out=0; 
	var sig;
	thisThread.randSeed = 20742;
	sig = SynthDef.wrap(~algofm);
	Out.ar(out, sig);
}).add;
50.do { arg idx;
	SynthDef(\algofm_g+++idx, { arg out=0; 
		var sig;
		thisThread.randSeed = 19742+idx;
		sig = SynthDef.wrap(~algofm);
		Out.ar(out, sig);
	}).add;
}
);

SynthDesc(\algofm).def.func
SynthDef

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono(\algofm_t1,
			\freqfac1, 1/7,
			\freqfac2, 1/17,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\algofm_t2,
			\freqfac1, Pseq([
				[0,4,7],
			],inf).midiratio * 1/8,
			\freqfac2, Pseq([
				10/1
			],inf),
			\freqfac2, ~pmodenv.(Pseq([101,1/122],inf), 8),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \algofm_t3,
			\freqfac1, 1/18,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		);
		
	])
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar(
		8.collect {
			Pmono(\algofm_g+++(0..49).choose,
				\dur, 1,
				\amp, ~pmodenv.(Pseq([0,1].scramble*0.1,inf), 18.0.rand),
				\freqfac1, ~pmodenv.(Pseq([1/10,10].scramble,inf), 48.0.rand),
				\freqfac2, ~pmodenv.(Pseq([1/10,10].scramble,inf), 48.0.rand),
			);

		}
	)
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar(
		4.collect {
			Pmono(\algofm_g+++(0..49).choose,
				\dur, 1,
				\amp, ~pmodenv.(Pseq([0,1,1,1]*0.1,inf), 4),
				\freqfac1, ~pmodenv.(Pseq([1/10,10,10,10],inf), 4),
				\freqfac2, ~pmodenv.(Pseq([1/10,10,10,10],inf), 4),
			);

		}
	)
)).play;
)

(
	~master.();
Pdef(\part, Pdef(\plop, 
	Pbind(\out, BusDef(\mixer5))<>
	Ppar([
		Pbind(
			\instrument, \snapkick,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snaretuned,
			\freq, 200,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				2,
			],inf),
			\sustain, 0.01,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				[0,5,9],
			],inf),
			\sustain, 0.01,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				[12,7,9],
			],inf),
			\octave, 5,
			\sustain, 0.01,
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \whitenoise,
			\freq, ~pmodenv.(Pseq([800,9000],inf), 1,1,4),
			\legato, 1,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)

(
SynthDef(\whitenoise, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\mixer5))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\pos, 2.45,
				\pos, 2.15,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\dur, 1/16,
				\gain, 0.7,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\pos, 2.45,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,
					0,0,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\dur, 1/16,
				\gain, 0.7,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,1, 
					0,0,0,1, 0,0,0,0, 
					0,0,0,0, 0,0,0,1, 
					0,0,0,0, 0,0,0,0, 
					0,0,0,0, 0,0,0,1, 
					0,1,0,0, 0,0,0,0, 
				],inf).coin.not,
				\sustain, 0.051,
				\dur, 1/8,
				\gain, 0.2,
				\amp, 0.1,
				\isRest, true,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest,
					Pseq([
						1,0,0,0, 1,0,0,0,
						1,0,0,0, 0,0,0,0,
					],inf).coin.not,
				\sustain, 0.021,
				\gain, 0.2,
				\dur, 1/16,
				\amp, 0.1,
			)),
		]),
		Pmono(\drono,
			\freq, 200,
			\dur, 1/8,
			\legato, Pseq([
					1,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\fx, \audio),
			\amp, 0.1,
		),
		PmonoArtic(\drono,
			\freq, 400,
			\dur, 1/8,
			\legato, Pseq([
					1,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\fx, \audio),
			\amp, 0.1,
		),
		Pbind(\out, BusDef(\fx2))<>
		Ppar([
			Pbind(
				\instrument, \default,
				\note, Pseq([
					2,
				],inf),
				\sustain, 0.01,
				\isRest, Pseq([
					0,1,
				],inf).coin.not,
				\dur, 1,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \default,
				\note, Pseq([
					[0,5,9],
				],inf),
				\sustain, 0.01,
				\dur, 1/4,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \default,
				\note, Pseq([
					[12,7,9],
				],inf),
				\octave, 5,
				\sustain, 0.01,
				\dur, 1/2,
				\amp, 0.1,
			),
		]),
		Pmono(\gegefx,
			\inbus, BusDef(\fx2, \audio),
			\fb, 0.01,
			\compmix,0,
			\delay2, ~pmodenv.(Pseq([40000,100,100,100],inf), 4),
			\delays1, Pseq([
				[{ 0.000007.rand }!4],
			],inf),
			\delays2, Pseq([
				[{ 0.000007.rand }!4]
			],inf),
			\delays3, Pseq([
				[{ 0.0007.rand }!4]
			],inf),
			\gain, Pseq([
				//1,0,0,0, 1,0,0,1,
				1,1,1,1, 1,1,1,1,
			],inf)*0.2,
			\distamp,48,
			\freq, 200,
			\dur, 1/8,
			\amp, 0.1,
		),
		
		Pmono(\gegefx,
			\inbus, BusDef(\fx, \audio),
			\fb, 0.001,
			\compmix,0,
			\delay1, ~pmodenv.(Pseq([40000,0],inf), 2),
			\delays1, Pseq([
				[{ 0.000007.rand }!4],
			],inf),
			\delays2, Pseq([
				[{ 0.000007.rand }!4]
			],inf),
			\delays3, Pseq([
				[{ 0.0007.rand }!4]
			],inf),
			\gain, Pseq([
				//1,0,0,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf)*0.4,
			\distamp,18,
			\freq, 200,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \whitenoise,
			\freq, ~pmodenv.(Pseq([800,9000],inf).stutter(2), 1,1,4),
			\legato, 1,
			\isRest, Pseq([
				0,0,
				0,1,
			],inf).coin.not,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)

(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\mixer5))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,1,0,0,
					0,1,1,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					1,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,

					0,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					1,1,0,1, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
		]),
			Pmono(\sendtoarbus,
				\freq, 200,
				\inbus, BusDef(\fx, \audio),
				\dur, 1,
				\amp, 0.1,
			),
		Pbind(
			\instrument, \basscomb,
			\freq, 70,
			\fmamp, ~pmodenv.(Pseq([1,2,4,10],inf), 8),
			\fmfreq, ~pmodenv.(Pseq([200,1000],inf), 8),
			\legato, 0.9,
			\combdecay, ~pmodenv.(Pseq([0,2,1,4],inf), 8),
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\lpfr, ~pmodenv.(Pseq([1,2,1,4],inf), 8),
			\adsr2, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ]
			],inf),
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \basscomb,
			\freq, Pseq([
				450,450,450,200,
				741,312,312,741,
			],inf).stutter(8),
			\fmamp, ~pmodenv.(Pseq([1,2,4,10],inf), 8),
			\fmfreq, ~pmodenv.(Pseq([200,1000],inf), 8),
			//\legato, 0.9,
			\combdecay, ~pmodenv.(Pseq([0,2,1,4],inf), 8),
			\isRest, Pseq([
				0,0,0,1,
			],inf).coin.not,
			\lpfr, ~pmodenv.(Pseq([1,2,1,4],inf), 8),
			\adsr2, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ]
			],inf),
			\lag, Pwhite(0.01,0.4),
			\sustain, 1/4/~t - Pkey(\lag),
			\dur, 1/4,
			\amp, 0.1,
		),
		Pmono(\face,
			\fspread, ~pmodenv.(Pseq([1,2,1,4]*0.01,inf), 8),
			\panrange,1,
			\fold, ~pmodenv.(Pseq([1,2,1,4]/2,inf), 8),
			\freq, [200,300,750,1234]+900,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
SynthDef(\basscomb, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(Env([1,5,1],[1.1,0.8]), 1);
	sig = Saw.ar(freq + [0,0.001]).mean;
	sig = sig + SinOsc.ar(freq * ( 1 + ( SinOsc.ar(\fmfreq.kr(100)) * \fmamp.kr(1) )));
	sig = ( sig*env1*3 ).tanh;
	sig = sig + InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = CombL.ar(sig, 0.1,1/freq/1.01,\combdecay.kr(0))+sig;
	sig = ( sig*env1*1/2 ).tanh;
	sig = sig /1;
	sig1 = sig;
	sig1 = FreqShift.ar(sig1, 1000.01);
	sig1 = Pan2.ar(sig, SinOsc.kr(1/2*~t)*0.1, amp);
	sig1 = sig1 * EnvGen.ar(\adsr2.kr(Env.adsr(0.01,0.1,0.8,3.7)),gate,doneAction:2);
	sig = RLPF.ar(sig, \lpfr.kr(7.1) * freq, \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:0);
	sig = sig+sig1;
	sig = sig / 3;
	sig = LeakDC.ar(sig);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\face, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(1) + 1));
	sig = sig.fold(\fold.kr(1));
	pan = SinOsc.kr( ((0..7)/7 - 0.5 * \panspread.kr(1) + 1) * 0.1 ) * \panrange.kr(0.1);
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = LeakDC.ar(sig);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.1) ),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
);

(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\mixer5))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\pos, 2.45,
				\pos, 2.15,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\dur, 1/16,
				\gain, 0.7,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\pos, 2.45,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,
					0,0,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\dur, 1/16,
				\gain, 0.7,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,1, 
					0,0,0,1, 0,0,0,0, 
					0,0,0,0, 0,0,0,1, 
					0,0,0,0, 0,0,0,0, 
					0,0,0,0, 0,0,0,1, 
					0,1,0,0, 0,0,0,0, 
				],inf).coin.not,
				\sustain, 0.051,
				\dur, 1/8,
				\gain, 0.2,
				\amp, 0.1,
				\isRest, true,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest,
					Pseq([
						1,0,0,0, 1,0,0,0,
						1,0,0,0, 0,0,0,0,
					],inf).coin.not,
				\sustain, 0.021,
				\gain, 0.2,
				\dur, 1/16,
				\amp, 0.1,
			)),
		]),
		Pbind(
			\instrument, \face,
			\out, BusDef(\fx),
			\fspread, 0.0001,
			\freq, 100 * Pseq([
				1,2
			],inf).midiratio,
			\legato, Pseq([
					0.1,0,0,0, 0.1,0,0,0.1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.4) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \face,
			\fspread, 0.001,
			\out, BusDef(\fx),
			\fold, 0.3,
			\freq, [200,300,750,1234]+200 * Pseq([
				1,2
			],inf).midiratio,
			\legato, Pseq([
					1,1,2,0,
					4,0,0,0,
					1,1,2,0,
					3,0,0,1,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.1,
		),
		Pmono(\gegefx,
			\inbus, BusDef(\fx, \audio),
			\fb, 0.0000001,
			\compmix,0,
			\delays1, Pseq([
				[{ 0.00000017.rand }!4],
			],inf),
			\delays2, Pseq([
				[{ 0.000007.rand }!4]
			],inf),
			\delays3, Pseq([
				[{ 0.0000001.rand }!4]
			],inf),
			\delay1, ~pmodsynth.({ SinOsc.ar(5.2).range(1,1.01)  }),
			\delay2, ~pmodsynth.({ SinOsc.ar(4.2).range(1,1.01)  }),
			\gain, 0.5,
			\lpf, 5000,
			\distamp,80,
			\mdistmix, 0.99,
			\mdistamp, 80.91,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		);
	])
)).play;
)

(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\mixer5))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\pos, 2.45,
				\pos, 2.15,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,1, 0,0,0,1, 0,0,0,0,
					0,1,0,0, 0,0,0,1, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,1,0, 0,0,0,0, 0,1,0,0,
					0,1,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.05,
				\dur, 1/16,
				\gain, 0.7,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\pos, 2.45,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,
					0,0,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,
					0,0,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,
					1,0,0,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,
					1,0,0,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\dur, 1/16,
				\gain, 0.7,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,1, 
					0,0,0,1, 0,0,0,0, 
					0,0,0,0, 0,0,0,1, 
					0,0,0,0, 0,0,0,0, 
					0,0,0,0, 0,0,0,1, 
					0,1,0,0, 0,0,0,0, 
				],inf).coin.not,
				\sustain, 0.051,
				\dur, 1/8,
				\gain, 0.2,
				\amp, 0.1,
				\isRest, true,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest,
					Pseq([
						1,0,0,0, 1,0,0,0,
						1,0,0,0, 0,0,0,0,
					],inf).coin.not,
				\sustain, 0.021,
				\gain, 0.2,
				\dur, 1/16,
				\amp, 0.1,
			)),
		]),
		Pbind(
			\instrument, \face,
			\out, BusDef(\fx),
			\fspread, 0.0001,
			\freq, 100 * Pseq([
				1,2
			],inf).midiratio,
			\legato, Pseq([
					0.1,0,0,0, 0.1,0,0,0.1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.4) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \face,
			\fspread, 0.001,
			\out, BusDef(\fx),
			\fold, 0.3,
			\freq, Pseq([
				[200,1234],
				[330,1734],
			],inf).stutter(16)+200 * Pseq([
				1,2
			],inf).midiratio,
			\legato, Pseq([
					8,0,0,0,
					0,0,0,0,
					6,0,0,0,
					0,0,2,0,

					7,0,0,0,
					0,0,0,1,
					4,0,0,0,
					4,0,0,0,

					7,0,0,0,
					0,0,0,1,
					2,0,2,0,
					3,0,0,1,

					8,0,0,0,
					0,0,0,0,
					1,7,0,0,
					0,0,0,0,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.1,
		),
		Pmono(\gegefx,
			\inbus, BusDef(\fx, \audio),
			\fb, 0.0001,
			\compmix,0,
			\delays1, Pseq([
				[{ 0.00000017.rand }!4],
			],inf),
			\delays2, Pseq([
				[{ 0.000007.rand }!4]
			],inf),
			\delays3, Pseq([
				[{ 0.0000001.rand }!4]
			],inf),
			\delay1, ~pmodsynth.({ SinOsc.ar(0.2).range(1,1.01)  }),
			\delay2, ~pmodsynth.({ LFSaw.ar(1/8*~t * [2,16]).range(1,2.01).mean  }),
			\gain, 0.5,
			\lpf, 8000,
			\distamp,8,
			\mdistmix, 0.99,
			\mdistamp, 10.91,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		);
	])
)).play;
)

//////////////////
