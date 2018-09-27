(
SynthDef(\dubdrone3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar;
	sig = Klank.ar(Ref([ exprand(20.0,10100!48!2), 0.001!8 ]), sig);
	//sig = sig * SinOsc.kr(4*~t).range(0,1);
	sig = sig * EnvGen.kr(\env.kr(Env([0,2,1,0],[0.01,0.8,0.01].normalizeSum)), Impulse.kr(4*1.5*~t), timeScale:1/8);
	//sig = sig  / 4;
	sig = sig * 15*2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,1.1,0.2,0.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig.debug("sig");
	Out.ar(out, sig);
}).add;

SynthDef(\dubdrone4, { arg out=0, gate=1, amp=0.5, pan=0, freq=200, mbufnum,
						gdur=12, trate=100, time_stretch=1, pos=0, pitch_stretch = 1, 
						randframes=0.01, randrate=1, doneAction=2, finepos=0,
						release=0.2;
						 
	var ou;
	var ou1, ou2;
	var dur, clk;
	var bufnum = mbufnum;
	var randclk;
	var pitch;
	var sr, phasor;

	bufnum = BufDef.mono(\rocksteady, "vipere/rocksteady.flac");
	pitch_stretch = Duty.kr(1/8/~t, 0, Dseq([
		[0,4,7,12],
		[0,4,7,10],
		[0,7,10,-12],
		[0,3,7,10],
	].midiratio,inf));
	time_stretch = 0;
	trate = 100;
	pos = SinOsc.kr(1/16*~t,pi).range(0,1) * 0.0004 * [1,1.1] + 0.3;
	//pos = EnvGen.ar(Env([0,0.4,0.2],[0.4,0.2]),LFPulse.kr(1/1*~t),doneAction:0);
	//pos = pos + EnvGen.ar(Env([0,0.2,0.4],[0.4,0.1]),LFPulse.kr(1*~t).poll,doneAction:0).poll;
	clk = Impulse.kr(trate);
	randclk = Impulse.kr(randrate * trate);
	dur = 0.1;
	pan = (WhiteNoise.kr(0.6) + pan).clip(-1,1);
	sr = SampleRate.ir;
	phasor = Phasor.ar(0, time_stretch.abs / sr / BufDur.kr(bufnum), 0, 1);
	phasor = Select.ar(time_stretch.sign + 1 /2, [
		pos - phasor,
		phasor + pos,
	]);

	pos = phasor * BufDur.kr(bufnum) + finepos ;
	ou = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);
	ou = Pan2.ar(ou, SinOsc.kr(1/48,[0,pi]).unipolar).flop;
	ou = [
		[300,350] * SinOsc.kr(1/8*~t).range(1,1.2),
		[1300,1350],
		[7300,7350],
	].collect { arg x, idx;
		ou1 = RHPF.ar(ou, x[0],0.3);
		ou2 = RLPF.ar(ou1, x[1],0.3);
		ou2 = ou2 * SinOsc.kr(1/(1+x)).unipolar;
		ou2;
	};
	ou = ou /8;
	ou = Splay.ar(ou, 1, amp);
	ou = ou * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, ou);
}).add;

SynthDef(\dubdrone4x, { arg out=0, gate=1, amp=0.5, pan=0, freq=200, mbufnum,
						gdur=12, trate=100, time_stretch=1, pos=0, pitch_stretch = 1, 
						randframes=0.01, randrate=1, doneAction=2, finepos=0,
						release=0.2;
						 
	var ou;
	var ou1, ou2;
	var dur, clk;
	var bufnum = mbufnum;
	var randclk;
	var pitch;
	var sr, phasor;

	bufnum = BufDef.mono(\rocksteady, "vipere/rocksteady.flac");
	pitch_stretch = Duty.kr(1/8/~t, 0, Dseq([
		[0,4,7,12],
		[0,4,7,10],
		[0,7,10,-12],
		[0,3,7,10],
	].midiratio,inf)) * pitch_stretch;
	//time_stretch = 0;
	//trate = 100;
	pos = SinOsc.kr(1/16*~t,pi).range(0,1) * 0.0004 * [1,1.1] + pos;
	//pos = EnvGen.ar(Env([0,0.4,0.2],[0.4,0.2]),LFPulse.kr(1/1*~t),doneAction:0);
	//pos = pos + EnvGen.ar(Env([0,0.2,0.4],[0.4,0.1]),LFPulse.kr(1*~t).poll,doneAction:0).poll;
	clk = Impulse.kr(trate);
	randclk = Impulse.kr(randrate * trate);
	dur = 0.1;
	pan = (WhiteNoise.kr(0.6) + pan).clip(-1,1);
	sr = SampleRate.ir;
	phasor = Phasor.ar(0, time_stretch.abs / sr / BufDur.kr(bufnum), 0, 1);
	phasor = Select.ar(time_stretch.sign + 1 /2, [
		pos - phasor,
		phasor + pos,
	]);

	pos = phasor * BufDur.kr(bufnum) + finepos ;
	ou = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);
	ou = Pan2.ar(ou, SinOsc.kr(1/48,[0,pi]).unipolar).flop;
	ou = [
		[300,350] * SinOsc.kr(1/8*~t).range(1,1.2),
		[1300,1350],
		[7300,7350],
	].collect { arg x, idx;
		ou1 = RHPF.ar(ou, x[0],0.3);
		ou2 = RLPF.ar(ou1, x[1],0.3);
		ou2 = ou2 * SinOsc.kr(1/(1+x)).unipolar;
		ou2;
	};
	ou = ou /8;
	ou = Splay.ar(ou, 1, amp);
	ou = ou * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, ou);
}).add;

SynthDef(\bassgrise, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[2.1,0.8]), 1);
	sig = SinOsc.ar(freq * [1,1 + ( env1 * \det.kr(0.1) )] * ( SinOsc.ar(freq * 1 + \fmdet.kr(0.01)) * 0.1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
)
~t = 135/4/60; TempoClock.default.tempo = ~t;

// from suft52.scd
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \bassgrise,
			\note, Pseq([
				Pser([
					7,0,0, 
					0,0,0, 
					0,0,0, 
					0,0,0, 
				],12*2),
			],inf),
			\lpf, 302,
			\det, Pwhite(0.1,0.001),
			\legato, Pseq([

					Pseq([
						1,0,0, 1,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0.51, 0.51,0,0.51,
						8,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0.51, 0.51,0,0.51,
						2,0,0, 0,0,0,  2,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0.51, 0.51,0,0.51,
						
					],3),

			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/12,
			\amp, 0.1,
			\lag, 0.04,
			\out, BusDef(\sendbus1, \audio),
		),
			Pmono(\rdnroom,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\dur, 1/8,
				'wet10', 1.0,
				'mix', 0.4,
				'gain', 1/9,
				'fb', 0.001000031,
				'delay', 0.00000001,
				'delay2', 0.00001001,
				'delay3', 0.0000080,
				'distamp', 0.604,
				'distamp2', 0.23,
				'distamp3', 0.89,
				'shift', -5.0,
				'shiftmix', 0.0,
				'stereo', 1.0,
				'indelay', 0.04,
			),
			Pbind(
				\instrument, \dubdrone4x,
				\note, Pseq([
					0,
				],inf),
				\pitch_stretch, Pseg(Pseq([0,2],inf),8),
				\octave, 7,
				\legato, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					8,0,0, 0,0,0,  0,0,0, 0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,3.1) ],
				],inf),
				//\lag, 0.04,
				\dur, 1/12,
				\amp, 0.1,
				\out, BusDef(\sendbus2, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.15714285714286,
				'gain', 3.7344889782792,
				'fb', 0.001099467303085,
				'delay', 0.000600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.000000543560100,
				'distamp', 2.361836201538,
				'prelpf', 19900,
				'prehpf', 1700,
				'lpf', 19900,
				'hpf', 200,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 570,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 1,
			),
			Pbind(
				\instrument, \dubdrone4x,
				\note, Pseq([
					4,
				],inf),
				\pitch_stretch, 4,
				\time_stretch, Pseg(Pseq([0,2],inf),8),
				\pos, 0.3,
				\trate, 100,
				\octave, 7,
				\legato, Pseq([
					0,0,0, 0,0,0,
				  	0,0,0, 6,0,0,
					0,0,0, 0,0,0,
					0,0,0, 0,0,0,

					0,0,0, 0,0,1,
				  	2,0,0, 2,0,0,
					0,0,0, 0,0,0,
					0,0,0, 0,0,0,

					0,0,0, 0,0,0,
					Prand([
						Pseq([
							1,0,1, 2,0,0,
						],1),
						Pseq([
							0,0,1, 1,1,0,
						],1),
					],1),
					0,0,0, 0,0,0,
					0,0,0, 0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\lag, 0.04,
				\dur, 1/12,
				\amp, 0.2,
			),
			Pbind(
				\instrument, \dubdrone4,
				\note, Pseq([
					4,
				],inf),
				\octave, 7,
				\legato, Pseq([
					0,0,0, 0,0,0, 0,0,4, 0,0,0,
					0,0,0, 0,0,0, 0,0,1/4, 2,0,0,
					0,0,0, 0,0,0, 0,3,0, 0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\lag, 0.04,
				\dur, 1/12,
				\amp, 0.1,
				\isRest, true,
			),



			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
				\out, BusDef(\sendbus3, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus3, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.15714285714286,
				'gain', 0.9344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 7.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\dur, 1/8,
				\gain, 0.4 * Pseq([
					1,0.8,1,1,0.9,
				],inf),
				//\lag, 0.04,
				\out, BusDef(\sendbus3, \audio),
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,1,0,
					0,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\adsr, Pseq([
					[ Env.adsr(0.05,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/12,
				\gain, 0.4 * Pseq([
					1,0.8,1,1,0.9,
				],inf),
				//\lag, 0.04,
				\out, BusDef(\sendbus3, \audio),
			)),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 6,
				\isRest, Pseq([
					0,0,1, 1,0,1,  0,0,0, 0,0,0,
					0,0,0, 1,0,0,  0,0,1, 1,0,1,
					0,0,1, 1,0,0,  0,0,1, 0,0,0,
					0,0,1, 0,0,1,  0,0,1, 0,0,1,
				],inf).coin.not,
				\sustain, 0.1/4,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\dur, 1/12,
				\gain, 0.4 * Pseq([
					1,0.8,1,1,0.9,
				],inf),
				//\lag, 0.04,
				\out, BusDef(\sendbus3, \audio),
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					1,1,1,1,
				],inf).coin.not,
				\lag, 0.04,
				\sustain, 0.1,
				\dur, 1/8,
				\gain, 0.2 * Pseq([
					1,0.7,
				],inf) * Pseq([
					1,Pwhite(0.01,0.5,1),
				],inf),
				\amp, 0.1,
				\lag, 0.04,
				//\out, BusDef(\fx1, \audio),
			)),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \bassgrise,
			\note, Pseq([
				Pser([
					7,0,0, 
					0,0,0, 
					0,0,0, 
					0,0,0, 
				],12*2),
			],inf),
			\lpf, 302,
			\det, Pwhite(0.1,0.001),
			\legato, Pseq([
				Pseq([
					0,0,0, 0,0,0,  6,0,0, 0,0,0,
				],4),
				Pseq([
					0,0,0, 0,0,0,  6,0,0, 0,0,0,
					1,0,0, 0,0,0,  6,0,0, 0,0,0,
					1,0,0, 0,0,0,  4,0,0, 1,0,1,
					0,0,1, 1,0,0,  6,0,0, 0,0,0,
				],8),
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/12,
			\amp, 0.1,
			\lag, 0.04,
			\out, BusDef(\sendbus1, \audio),
		),
			Pmono(\rdnroom,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\dur, 1/8,
				'wet10', 1.0,
				'mix', 0.4,
				'gain', 1/9,
				'fb', 0.000000031 * Pseq([
					1000000,1,
					1000000,10000,
					100000,10000,
					10000,100000,
				],inf),
				'delay', 0.00000001,
				'delay2', 0.00001001,
				'delay3', 0.0000080,
				'distamp', 0.604,
				'distamp2', 0.23,
				'distamp3', 0.89,
				'shift', -5.0,
				'shiftmix', 0.0,
				'stereo', 1.0,
				'indelay', 0.04,
			),
			Pbind(
				\instrument, \dubdrone4x,
				\note, Pseq([
					0,
				],inf),
				\pitch_stretch, Pseg(Pseq([0,2],inf),8),
				\octave, 7,
				\legato, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					8,0,0, 0,0,0,  0,0,0, 0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,3.1) ],
				],inf),
				//\lag, 0.04,
				\dur, 1/12,
				\amp, 0.1,
				\out, BusDef(\sendbus2, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.15714285714286,
				'gain', 3.7344889782792,
				'fb', 0.001099467303085,
				'delay', 0.000600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.000000543560100,
				'distamp', 2.361836201538,
				'prelpf', 19900,
				'prehpf', 1700,
				'lpf', 19900,
				'hpf', 200,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 570,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 1,
			),
			Pbind(
				\instrument, \dubdrone4x,
				\note, Pseq([
					4,
				],inf),
				\pitch_stretch, 4,
				\time_stretch, Pseg(Pseq([0,2],inf),8),
				\pos, 0.3,
				\trate, 100,
				\octave, 7,
				\legato, Pseq([
					0,0,0, 0,0,0,
				  	0,0,0, 6,0,0,
					0,0,0, 0,0,0,
					0,0,0, 0,0,0,

					0,0,0, 0,0,1,
				  	2,0,0, 2,0,0,
					0,0,0, 0,0,0,
					0,0,0, 0,0,0,

					0,0,0, 0,0,0,
					Prand([
						Pseq([
							1,0,1, 2,0,0,
						],1),
						Pseq([
							0,0,1, 1,1,0,
						],1),
					],1),
					0,0,0, 0,0,0,
					0,0,0, 0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\lag, 0.04,
				\dur, 1/12,
				\amp, 0.2,
			),
			Pbind(
				\instrument, \dubdrone4,
				\note, Pseq([
					4,
				],inf),
				\octave, 7,
				\legato, Pseq([
					0,0,0, 0,0,0, 0,0,4, 0,0,0,
					0,0,0, 0,0,0, 0,0,1/4, 2,0,0,
					0,0,0, 0,0,0, 0,3,0, 0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\lag, 0.04,
				\dur, 1/12,
				\amp, 0.1,
				\isRest, true,
			),



			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
				\out, BusDef(\sendbus3, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus3, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.15714285714286,
				'gain', 0.9344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 7.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 1,
				\isRest, true,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\dur, 1/8,
				\gain, 0.4 * Pseq([
					1,0.8,1,1,0.9,
				],inf),
				//\lag, 0.04,
				\out, BusDef(\sendbus3, \audio),
			)),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\dur, 1/8,
				\gain, 0.4 * Pseq([
					1,0.8,1,1,0.9,
				],inf),
				//\lag, 0.04,
				\out, BusDef(\sendbus3, \audio),
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,1,0,
					0,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\adsr, Pseq([
					[ Env.adsr(0.05,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/12,
				\gain, 0.4 * Pseq([
					1,0.8,1,1,0.9,
				],inf),
				//\lag, 0.04,
				\out, BusDef(\sendbus3, \audio),
			)),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 6,
				\isRest, Pseq([
					0,0,1, 1,0,1,  0,0,0, 0,0,0,
					0,0,0, 1,0,0,  0,0,1, 1,0,1,
					0,0,1, 1,0,0,  0,0,1, 0,0,0,
					0,0,1, 0,0,1,  0,0,1, 0,0,1,
				],inf).coin.not,
				\sustain, 0.1/4,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\dur, 1/12,
				\gain, 0.4 * Pseq([
					1,0.8,1,1,0.9,
				],inf),
				//\lag, 0.04,
				\out, BusDef(\sendbus3, \audio),
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					1,1,1,1,
				],inf).coin.not,
				\lag, 0.04,
				\sustain, 0.1,
				\dur, 1/8,
				\gain, 0.2 * Pseq([
					1,0.7,
				],inf) * Pseq([
					1,Pwhite(0.01,0.5,1),
				],inf),
				\amp, 0.1,
				\lag, 0.04,
				//\out, BusDef(\fx1, \audio),
			)),
		
	])
)).play;
)
