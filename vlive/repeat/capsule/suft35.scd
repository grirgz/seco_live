
~t = 180/4/60; TempoClock.default.tempo = ~t;

(
SynthDef(\cymbalsimple3, { | out = 0, pan = 0.0 |
	var sig, env;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var freqs;
	env = EnvGen.ar(\perc.kr(Env.perc(0.01, 2, curve: -4)), doneAction: 2);
	env1 = EnvGen.kr(Env([0,1,0],[0.01,0.08]), 1);
	freqs = \freqtab.kr({exprand(8030, 12000)}.dup(50) ++ {exprand(720, 7000)}.dup(50));
	sig = HPF.ar(Ringz.ar(WhiteNoise.ar(0.1), freqs, 4.1).mean, ( 1.1- env1 )*4000);
	sig = sig + EnvGen.ar(Env.perc(0.001,0.001,1), levelScale:1/2);
	sig = sig + LPF.ar(WhiteNoise.ar(0.1),EnvGen.ar(Env.perc(0.5,5,1))* 20000+10,mul:2);
	sig = sig / 3;
	Out.ar(out, Pan2.ar(sig * env, pan));
}).add;
SynthDef(\morechord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\freqenv.kr(Env([2,1,1.1],[0.01,4.8])), 1);
	freq = freq * [1/2,1,2] * env1;
	sig1 = SinOsc.ar(freq);
	sig2 = LFSaw.ar(freq);
	sig = SelectX.ar(\mix.kr(0.5), [sig1, sig2]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * ( SinOsc.ar(freq * \ffmr.kr(1)) * 1 + 1 ), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,8.1,0.2,2.1,1,-1)), gate, doneAction:2);
	pan = pan + LFNoise1.ar(1/2!sig.size); 
	sig = Pan2.ar(sig, pan, amp).mean;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\cymline, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var fspread = EnvGen.kr(Env([1,1.02,0.001],[0.1,2.8]), 1);
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([4701,7000,100],[0.1,2.8]), 1);
	freq = { freq * rrand(0.5,1.5) }.dup(8);
	sig = LFSaw.ar(freq * ( SinOsc.ar( freq * ((0..7)/7 - 0.5 * fspread + 1) ) * 1 + 1 ));
	sig = RHPF.ar(sig, env1, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	pan = pan + LFNoise1.kr(1/8!8, mul: XLine.kr(0.5,1,1));
	sig = Pan2.ar(sig, pan, amp).mean * 2;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bigkick, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.ar(Env([471,160,60],[0.006,0.1]), 1);
	env2 = EnvGen.ar(Env([771,60,50],[0.006,0.1]), 1);
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, [ env1, env2 ], \rq.kr(0.01)).sum;
	sig = sig / 4;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\bigkickbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.ar(Env([271,60,45],[0.003,0.2]), 1);
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, env1, \rq.kr(0.01));
	sig = sig;
	sig = sig * EnvGen.kr(Env([0,1,0.6,2.2,0],[0.001,0.1,0.1,0.5]), gate, doneAction:2);
	sig = ( sig*2 ).tanh/2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

(
SynthDef(\fuite, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \bigkick,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\legato, 0.1,
			\amp, 0.1,
			//\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \bigkickbass,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\amp, 0.1,
			//\out, BusDef(\kickbus, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\kickbus, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 8.361836201538,
			'prelpf', 19901,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 77,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 77,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				7,1,1,
			],inf),
			\isRest, Pseq([
				1,0,1, 
				1,0,0, 
				1,1,0, 
			],inf).coin.not,
			\octave, 6,
			\legato, Pseg(Pseq([0.1,1],inf),8),
			\lpfr, ~pmodenv.(Pseq([1,2,1,4],inf), 8),
			\fmr, ~pmodenv.(Pseq(1/[1,2,1,4],inf), 8),
			\diff, 0.0001,
			\dur, 1/12,
			\amp, 0.1/10,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([

				0,0, 1,0, 0,0, 1,0,
				0,0, 1,0, 0,0, 1,0,
				0,0, 1,0, 0,0, 1,0,
				0,0, 0,1, 1,0, 1,0,

				0,0, 1,0, 0,0, 1,0,
				0,0, 1,0, 0,0, 1,0,
				0,0.2, 1,0.2, 1,0.5, 1,0.2,
				0,1, 0,1, 1,0, 1,0,
			],inf).coin.not,
			\sustain, 0.051,
			\speed, 1.0,
			\gain, 0.2,
			\dur, 1/16 * (1 + (1/6 * Pseq([1,0,-1,0],inf))),
		)),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\isRest, Pseq([
				1,0,0,1, 1,0,1,0,
				1,1,0,1, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\speed, Pseq([
				1,1,0.8,0.8,
			],inf),
			\pos, ~pmodenv.(Pseq([0,0.2],inf), 17),
			\speed, ~pmodenv.(Pseq([1,1.02]/2,inf), 2),
			\dur, 1/8 * (1 + (1/6 * Pseq([1,-1],inf))),
			\dur, 1/16 * (1 + (1/6 * Pseq([1,0,-1,0],inf))),
			\gain, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\isRest, Pseq([
				1,0,0,1, 1,0,1,0,
				1,1,0,1, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
				1,0,1,0, 0,1,1,0,
			],inf).coin.not,
			\speed, Pseq([
				1,1,0.8,0.8,
			],inf),
			\lag, 1/32/~t,
			\pos, ~pmodenv.(Pseq([0,0.2]+1,inf), 17),
			\speed, ~pmodenv.(Pseq([1,1.02]/1.2,inf), 2),
			\dur, 1/8 * (1 + (1/6 * Pseq([1,-1],inf))),
			\dur, 1/16 * (1 + (1/6 * Pseq([1,0,-1,0],inf))),
			\gain, 1/4,
		),
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
		Pbind(
			\instrument, \cymline,
			\freq, 800,
			\dur, 2,
			\amp, 0.1/2,
		),
	])
)).play;
)



(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \bigkick,
			\dur, 1/16 * (1 + (1/6 * Pseq([1,-1],inf))),
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,1,
			],inf).coin.not,
			\legato, 0.1,
			\amp, 0.1,
			//\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \bigkickbass,
			\dur, 1/8,
			\legato, 0.1,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\amp, 0.1,
			//\out, BusDef(\kickbus, \audio),
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,1,1, 1,0,1,0, 
				1,1,1,0, 1,1,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.5,
			\dur, 1/16 * (1 + (1/6 * Pseq([1,-1],inf))),
			\out, BusDef(\fx1, \audio),
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\sustain, 0.3,
			\speed, 1.0 * Pseg(Pseq([1.2,1.1],inf),8),
			\gain, 0.5,
			\dur, 1/16 * (1 + (1/6 * Pseq([1,-1],inf))),
			//\out, BusDef(\fx2, \audio),
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				Pseq([
					1,0.2,1,0.2, 0,0.2,0.2,0.2,
				],inf),
			],inf).coin.not,
			\sustain, 0.3,
			\speed, 1.0 * Pseg(Pseq([1.1,1.095,0.98],inf),7),
			\gain, 0.5 * Plazy({ arg ev;
				var w = Pwhite(0,0.9,1);
				Pseq([
					1,w,1,w, w,w,w,w,
				],inf);
			}).loop,
			\dur, 1/16 * (1 + (1/6 * Pseq([1,-1],inf))),
			//\out, BusDef(\fx2, \audio),
		)),
		Pmono(\rdnroom,
			\inbus, BusDef(\fx1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.31,
			'gain', 1/22,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001 * Pseg(Pseq([0,100],inf),7),
			'delay3', 0.0000080 * Pseg(Pseq([0,100],inf),8),
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),

		Pbind(
			\instrument, \cymbalsimple3,
			\freq, 200,
			\freqtab, Pfunc({ arg ev;
				//thisThread.randSeed = 10;
				[ {exprand(8030, 12000)}.dup(50) ++ {exprand(720, 7000)}.dup(50) ]
			}),
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, 4,
			\perc, [ Env.perc(0.001,2.1,1, -4) ],
			\amp, 0.1,
			\out, BusDef(\cymbus, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\cymbus, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.3344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.800600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.800000543560101,
			\delay2, ~pmodenv.(Pseq([0.0011,0.000002],inf), 8),
			'distamp', 1.361836201538,
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

		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\hatbus, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\hatbus, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.55714285714286,
			'gain', 0.4344889782792,
			'fb', 0.0042099467303085,
			'delay', 0.000600001231 * Pseq([
				1,1000,1,2000,
				1000,1000,1000,1000,
				1,1000,1,2000,
				2000,2000,2000,2000,
				1,1000,1,2000,
				1000,1000,1000,1000,
				1,1000,1,2000,
				1000,1000,1000,1000,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
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
			\dur, 1/8,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \bigkick,
			\dur, 1/16 * (1 + (1/6 * Pseq([1,-1],inf))),
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,1,
			],inf).coin.not,
			\legato, 0.1,
			\amp, 0.1,
			\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \bigkick,
			\dur, 1/8,
			\legato, 0.1,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\kickbus, \audio),
			\isRest, true,
		),
		Pseq([
			Pfindur(8, Pmono(\rdnroom,
				\inbus, BusDef(\kickbus, \audio, 2),
				\dur, 1/8,
				'wet10', 1.0,
				'mix', 0.71,
				'gain', 1/12,
				'fb', 0.000100031,
				'delay', 0.00010001,
				'delay2', 0.00101001,
				'delay3', 0.0001180 * Pseq([1,1.2,1.4,1.6],inf),
				'distamp', 1.604 * Pseq([
					1,1,1,1,
					1,1,1,1,
					1,1,1,1,
					1,1,8,18,
				],inf),
				'distamp2', 0.23,
				'distamp3', 1.89,
				'shift', -5.0,
				'shiftmix', 0.0,
				'stereo', 1.0,
				'indelay', 0.04,
			)),
			Pfindur(8, Pmono(\rdnroom,
				\inbus, BusDef(\kickbus, \audio, 2),
				\dur, 1/8,
				'wet10', 1.0,
				'mix', 0.71,
				'gain', 1/12,
				'fb', 0.000100031,
				'delay', 0.00010001,
				'delay2', 0.00101001,
				'delay3', 0.0001180 * Pseq([1,1.2,1.4,1.6],inf),
				'distamp', 1.604 * Pseq([
					1,1,1,1,
					1,1,1,1,
					1,1,1,1,
					1,1,1,1,
					1,1,58,8,
					1,1,18,8,
					10,1,18,8,
					1,18,8,41,
				],inf),
				'distamp2', 0.23,
				'distamp3', 0.89,
				'shift', -5.0,
				'shiftmix', 0.0,
				'stereo', 1.0,
				'indelay', 0.04,
			)),
			Pfindur(8, Pmono(\rdnroom,
				\inbus, BusDef(\kickbus, \audio, 2),
				\dur, 1/8,
				'wet10', 1.0,
				'mix', 0.71,
				'gain', 1/12,
				'fb', 0.000100031,
				'delay', 0.00010001,
				'delay2', 0.00001001,
				'delay3', 0.0001180 * Pseq([1,1.2,1.4,1.6],inf),
				'distamp', 1.604 * Pseq([
					1,1,58,8,
					1,1,18,8,
					10,1,18,8,
					1,18,41,
				],inf),
				'distamp2', 0.23,
				'distamp3', 0.89,
				'shift', -5.0,
				'shiftmix', 0.0,
				'stereo', 1.0,
				'indelay', 0.04,
			)),
			Pfindur(8, Pmono(\rdnroom,
				\inbus, BusDef(\kickbus, \audio, 2),
				\dur, 1/8,
				'wet10', 1.0,
				'mix', 0.71,
				'gain', 1/16,
				'fb', 0.000100031,
				'delay', 0.00010001,
				'delay2', 0.0000001,
				'delay3', 0.0001180,
				'distamp', 0.604,
				'distamp2', 0.604,
				'distamp3', 1.004 * Pseq([
					Ppatlace([
						Pseq((1..8)).stutter(2),
						Pseq((1..8)).stutter(4),
						Pseq((1..8).reverse).stutter(2),
						Pseq((1..8)).stutter(4),
					],inf)
				],inf),
				'shift', -5.0,
				'shiftmix', 0.0,
				'stereo', 1.0,
				'indelay', 0.04,
			)),
			Pfindur(8, Pmono(\rdnroom,
				\inbus, BusDef(\kickbus, \audio, 2),
				\dur, 1/8,
				'wet10', 1.0,
				'mix', 0.71,
				'gain', 1/16,
				'fb', 0.000100031,
				'delay', 0.00000001,
				'delay2', 0.0000001,
				'delay3', 0.0000180,
				'distamp', 0.604,
				'distamp2', 0.604,
				'distamp3', 1.004 * Pseq([
					Ppatlace([
						Pseq((1..8)).stutter(4),
						Pseq((1..8).reverse).stutter(4),
					],inf)
				],inf),
				'shift', -5.0,
				'shiftmix', 0.0,
				'stereo', 1.0,
				'indelay', 0.04,
			)),
			Pfindur(8, Pmono(\rdnroom,
				\inbus, BusDef(\kickbus, \audio, 2),
				\dur, 1/8,
				'wet10', 1.0,
				'mix', 0.71,
				'gain', 1/16,
				'fb', 0.000100031,
				'delay', 0.00000001,
				'delay2', 0.0000001,
				'delay3', 0.0001180 * Pseq([1,1.2,1.4,1.6],inf),
				'distamp', 1.604 * Pseq([
					1,100, 1,100,
					1,100, 1,100,
					1,100, 1,100,
					1,10, 1,1,
				],inf),
				'distamp2', 0.23,
				'distamp3', 0.89,
				'shift', -5.0,
				'shiftmix', 0.0,
				'stereo', 1.0,
				'indelay', 0.04,
			)),
			Pfindur(8, Pmono(\rdnroom,
				\inbus, BusDef(\kickbus, \audio, 2),
				\dur, 1/8,
				'wet10', 1.0,
				'mix', 0.71,
				'gain', 1/16,
				'fb', 0.001100031,
				'delay', 0.00000001,
				'delay2', 0.0000001,
				'delay3', 0.0001180 * Pseq([1,1.2,1.4,1.6],inf),
				'distamp', 1.604 * Pseq([
					1,1,1,1,
					1,1,1,1,
					1,1,1,1,
					1,1,8,18,
				],inf),
				'distamp2', 0.23,
				'distamp3', 1.89,
				'shift', -5.0,
				'shiftmix', 0.0,
				'stereo', 1.0,
				'indelay', 0.04,
			)),
		],inf),


		/// hi drums

		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,1,1, 1,0,1,0, 
				1,1,1,0, 1,1,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.5,
			\dur, 1/16 * (1 + (1/6 * Pseq([1,-1],inf))),
			\out, BusDef(\fx1, \audio),
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\sustain, 0.3,
			\speed, 1.0 * Pseg(Pseq([1.2,1.1],inf),8),
			\gain, 0.5,
			\dur, 1/16 * (1 + (1/6 * Pseq([1,-1],inf))),
			//\out, BusDef(\fx2, \audio),
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				Pseq([
					1,0.2,1,0.2, 0,0.2,0.2,0.2,
				],inf),
			],inf).coin.not,
			\sustain, 0.3,
			\speed, 1.0 * Pseg(Pseq([1.1,1.095,0.98],inf),7),
			\gain, 0.5 * Plazy({ arg ev;
				var w = Pwhite(0,0.9,1);
				Pseq([
					1,w,1,w, w,w,w,w,
				],inf);
			}).loop,
			\dur, 1/16 * (1 + (1/6 * Pseq([1,-1],inf))),
			//\out, BusDef(\fx2, \audio),
		)),
		Pmono(\rdnroom,
			\inbus, BusDef(\fx1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.31,
			'gain', 1/22,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001 * Pseg(Pseq([0,100],inf),7),
			'delay3', 0.0000080 * Pseg(Pseq([0,100],inf),8),
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),

		Pbind(
			\instrument, \cymbalsimple3,
			\freq, 200,
			\freqtab, Pfunc({ arg ev;
				//thisThread.randSeed = 10;
				[ {exprand(8030, 12000)}.dup(50) ++ {exprand(720, 7000)}.dup(50) ]
			}),
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 4,
			\perc, [ Env.perc(1/~t,0.01,1, 4) ],
			\amp, 0.1/2,
			\out, BusDef(\cymbus, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\cymbus, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.3344889782792,
			'fb', 0.0012099467303085,
			'delay', 0.800600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.800000543560101,
			\delay2, ~pmodenv.(Pseq([0.0011,0.000002],inf), 8),
			'distamp', 1.361836201538,
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

		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\hatbus, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\hatbus, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.55714285714286,
			'gain', 0.4344889782792,
			'fb', 0.0042099467303085,
			'delay', 0.000600001231 * Pseq([
				1,1000,1,2000,
				1,1,1000,1000,
				1,1000,1,2000,
				2000,2000,2000,2000,
				1,1000,1,2000,
				1000,1000,1,1,
				1,1000,1,2000,
				1000,1,1,1000,
			].clump(4*3).stutter(2).flat,inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 11900,
			'posthpf', 1700,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1/8,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pstep(Pseq([
				0,0,0,1,
			],inf),1),
			\lpf, Pseg(Pseq([80,200],inf),8),
			\octave, 3,
			\legato, Pseq([
				1,1,
				1,1,
				1,1,
				1,1,
				1,1,
				1,1,
				1,1,
				1,0,
			],inf) * Pseg(Pseq([0.5,0.61],inf),8),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],
				[ Env.adsr(0.4,0.1,0.8,0.04,1,4) ],
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],

				[ Env.adsr(0.2,0.1,0.8,0.04,1,4) ],
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],
				[ Env.adsr(0.6,0.1,0.8,0.04,1,4) ],

			//	[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],
			//	[ Env.adsr(0.2,0.1,0.8,0.04,1,4) ],
			//	[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],
			//	[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],

			//	[ Env.adsr(0.2,0.1,0.8,0.04,1,4) ],
			],inf).stutter(2),
			\dur, 1/8,
			//\lag, 0.04,
			\amp, 0.02,
			\out, BusDef(\bassbus, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\bassbus, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.5,
			'gain', 1/10,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.0000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shift2', -1.13,
			'shift3', -2.478,
			'shiftmix', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'stereo', 1.0,
			'fbdistamp', 0.923,
			'fbdistmix', 0.911,
			'postlpf', 19000,
			'posthpf', 17,
			'wetamp', 0.18,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'brfrqfac', 0.37,
			'brffac', 0.60,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\bassbus, \audio, 2),
			\addAction, \addToTail,
			'mix', 1,
			'gain', 0.6344889782792 * Pseg(Pseq([1,2],inf),16),
			'fb', 0.002199467303085,
			'delay', 0.100600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.001000543560101 * Pseg(Pseq([1,0],inf),16),
			'distamp', 171.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 170,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 3700,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),

		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/16,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
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
		Pseq([
			Pfindur(8, Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,2,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
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
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
			)),
			Pfindur(8, Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.210000543560101,
				'distamp', 1.361836201538,
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
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
			)),
		],inf),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pstep(Pseq([
				0,0,0,1,
			],inf),1),
			\lpf, Pseg(Pseq([80,200],inf),8),
			\octave, 3,
			\legato, Pseq([
				1,1,
				1,1,
				1,1,
				1,1,
				1,1,
				1,1,
				1,1,
				1,0,
			],inf) * Pseg(Pseq([0.5,1],inf),8),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],
				[ Env.adsr(0.4,0.1,0.8,0.04,1,4) ],
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],

				[ Env.adsr(0.2,0.1,0.8,0.04,1,4) ],
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],
				[ Env.adsr(0.6,0.1,0.8,0.04,1,4) ],

				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],
				[ Env.adsr(0.2,0.1,0.8,0.04,1,4) ],
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],

				[ Env.adsr(0.2,0.1,0.8,0.04,1,4) ],
			],inf).stutter(2),
			\dur, 1/8,
			//\lag, 0.04,
			\amp, 0.02,
			\out, BusDef(\bassbus, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\bassbus, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.5,
			'gain', 1/12,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.0000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shift2', -1.13,
			'shift3', -2.478,
			'shiftmix', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'stereo', 1.0,
			'fbdistamp', 0.923,
			'fbdistmix', 0.911,
			'postlpf', 19000,
			'posthpf', 17,
			'wetamp', 0.18,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'brfrqfac', 0.37,
			'brffac', 0.60,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\bassbus, \audio, 2),
			\addAction, \addToTail,
			'mix', 1,
			'gain', 0.3344889782792,
			'fb', 0.002199467303085,
			'delay', 0.100600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.001000543560101,
			'distamp', 171.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 170,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19200,
			'posthpf', 3700,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
				\out, BusDef(\bassbus, \audio),
			),

		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/16,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
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
		Pseq([
			Pfindur(8, Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.6344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,2,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
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
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
			)),
			Pfindur(8, Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.210000543560101,
				'distamp', 1.361836201538,
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
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
			)),
		],inf),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pstep(Pseq([
				0,0,0,1,
			],inf),1),
			\lpf, Pseg(Pseq([80,200],inf),8),
			\octave, 3,
			\legato, Pseq([
				1,1, 1,1, 1,1, 1,1,
				1,1, 1,1, 1,1, 1,0,
			],inf) * Pseg(Pseq([0.5,1],inf),8),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],
				[ Env.adsr(0.4,0.1,0.8,0.04,1,4) ],
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],

				[ Env.adsr(0.2,0.1,0.8,0.04,1,4) ],
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],
				[ Env.adsr(0.6,0.1,0.8,0.04,1,4) ],

				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],
				[ Env.adsr(0.2,0.1,0.8,0.04,1,4) ],
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],

				[ Env.adsr(0.2,0.1,0.8,0.04,1,4) ],
			],inf).stutter(2),
			\dur, 1/8,
			//\lag, 0.04,
			\amp, 0.02,
			\out, BusDef(\bassbus, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\bassbus, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.5,
			'gain', 1/12,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.0000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shift2', -1.13,
			'shift3', -2.478,
			'shiftmix', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'stereo', 1.0,
			'fbdistamp', 0.923,
			'fbdistmix', 0.911,
			'postlpf', 19000,
			'posthpf', 17,
			'wetamp', 0.18,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'brfrqfac', 0.37,
			'brffac', 0.60,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\bassbus, \audio, 2),
			\addAction, \addToTail,
			'mix', 1,
			'gain', 0.3344889782792,
			'fb', 0.002199467303085,
			'delay', 0.100600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.001000543560101,
			'distamp', 171.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 170,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19200,
			'posthpf', 3700,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
				\out, BusDef(\bassbus, \audio),
			),

		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/16,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
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
		Pseq([
			Pfindur(8, Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.6344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,2,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
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
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
			)),
			Pfindur(8, Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.210000543560101,
				'distamp', 1.361836201538,
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
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
			)),
		],inf),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('loop/loop2_185bpm.flac'),
			\speed, 1.031,
			\pos, Pseq([
				0,1,2,2.4,
				0.1,1,2,2.4,
			],inf),
			\dur, Pn(1/2,inf),
			\gain, 1/2,
			\out, BusDef(\smpbus, \audio),
			\isRest, true,
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\smpbus),
			\time, 1/16/~t,
			\mix, Pseq([
				0,0,1,1,
				0,1,0,1,
			],inf),
			\dur, 1/8,
		),
		// smp3
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/loop2_185bpm.flac'),
			\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('fix4/snare1.flac'),
			\bufnum, BufDef(\ukraine, "bruit1/07_ukraine.flac"),
			\speed, 2.031 * Pseq([
				1,
			],inf),
			\pos, Pseq([
				4,2,5,1, 4,2,4,2,
				4,5,1,2, 4,1,5,2,
			],inf),
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\dur, Pn(1/2,inf),
			\gain, 1.4,
			\out, BusDef(\smpbus3, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\smpbus3),
			\time, 1/8/~t * Pseq([1,2],inf).stutter(4),
			\mix, Pseq([
				0,1,1,1,
				1,0,1,1,
			],inf),
			\dur, 1/8,
			\out, BusDef(\smpbus3b, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\smpbus3b),
			\hpf, 1000,
			\dur, 1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pstep(Pseq([
				0,0,0,1,
			],inf),1),
			\lpf, Pseg(Pseq([80,200],inf),8),
			\octave, 3,
			\legato, Pseq([
				1,1, 1,1, 1,1, 1,1,
				1,1, 1,1, 1,1, 1,0,
				Pseq([
					0.1,0, 0,0, 0,0, 0,0,
				],2),
				1,1, 1,1, 1,1, 1,1,
				1,1, 1,1, 1,1, 1,0,
				Pseq([
					0,0.1,
				],8),
			],inf) * Pseg(Pseq([0.5,1],inf),8),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],
				[ Env.adsr(0.4,0.1,0.8,0.04,1,4) ],
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],

				[ Env.adsr(0.2,0.1,0.8,0.04,1,4) ],
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],
				[ Env.adsr(0.6,0.1,0.8,0.04,1,4) ],

				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],
				[ Env.adsr(0.2,0.1,0.8,0.04,1,4) ],
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],
				[ Env.adsr(0.002,0.1,0.8,0.14,1,-4) ],

				[ Env.adsr(0.2,0.1,0.8,0.04,1,4) ],
			],inf).stutter(2),
			\dur, 1/8,
			//\lag, 0.04,
			\amp, 0.02,
			\out, BusDef(\bassbus, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\bassbus, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.5,
			'gain', 1/12,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.0000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shift2', -1.13,
			'shift3', -2.478,
			'shiftmix', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'stereo', 1.0,
			'fbdistamp', 0.923,
			'fbdistmix', 0.911,
			'postlpf', 19000,
			'posthpf', 17,
			'wetamp', 0.18,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'brfrqfac', 0.37,
			'brffac', 0.60,
			\out, BusDef(\bassbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\bassbus, \audio, 2),
			\addAction, \addToTail,
			'mix', 1,
			'gain', 0.3344889782792,
			'fb', 0.000199467303085,
			'delay', 0.000600001231 * Pseq([
				1000,10,2,3,
			],inf).stutter(8),
			'delay2', 0.001000543560101,
			'distamp', 171.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19200,
			'posthpf', 100,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
			\out, BusDef(\bassbus2, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\bassbus2),
			\sideinbus, BusDef(\sendbus1),
			\cpt, 0.05,
			\cpabove, 0.01,
			\cpclamp, 0.001,
			\cprelax, 0.04,
			\gain, 1,
			\dur, 1,
		),

		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/16,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
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
		Pseq([
			Pfindur(8, Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.6344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,2,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
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
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
			)),
			Pfindur(8, Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.210000543560101,
				'distamp', 1.361836201538,
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
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
			)),
		],inf),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('loop/loop2_185bpm.flac'),
			\speed, 1.031,
			\pos, Pseq([
				0,1,2,2.4,
				0.1,1,2,2.4,
			],inf),
			\dur, Pn(1/2,inf),
			\gain, 1/2,
			\out, BusDef(\smpbus, \audio),
			\isRest, true,
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\smpbus),
			\time, 1/16/~t,
			\mix, Pseq([
				0,0,1,1,
				0,1,0,1,
			],inf),
			\dur, 1/8,
		),
		// smp3
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/loop2_185bpm.flac'),
			\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('fix4/snare1.flac'),
			\bufnum, BufDef(\ukraine, "bruit1/07_ukraine.flac"),
			\speed, 1.031 * Pseq([
				1,
			],inf),
			\pos, Pseq([
				4,5,1,2, 4,1,5,2,
			],inf)/2+Pseq([
				5,0,6,3,
			],inf).stutter(8*4),
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\dur, Pn(1/2,inf),
			\gain, 1.4,
			\out, BusDef(\smpbus3, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\smpbus3),
			\time, 1/8/~t * Pseq([1,1,2],inf).stutter(4),
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,0,1,
				1,1,1,1, 1,1,1,1,
			],inf),
			\dur, 1/8,
			\out, BusDef(\smpbus3b, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\smpbus3b),
			\hpf, 1000,
			\dur, 1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/16,
			\gain, 1/2,
			\out, BusDef(\kickbus, \audio),
		)),
		Pseq([
			Pfindur(8, Pmono(\rdnroom,
				\inbus, BusDef(\kickbus, \audio, 2),
				\dur, 1/8,
				'wet10', 1.0,
				'mix', 0.01,
				'gain', 2,
				'fb', 0.000000031,
				'delay', 0.00000001,
				'delay2', 0.00001001,
				'delay3', 0.1100080,
				'distamp', 0.604,
				'distamp2', 0.23,
				'distamp3', 1.89,
				'shift', -5.0,
				'shiftmix', 0.0,
				'stereo', 1.0,
				'indelay', 0.04,
			)),
			Pfindur(8, Pmono(\rdnroom,
				\inbus, BusDef(\kickbus, \audio, 2),
				\dur, 1/8,
				'wet10', 1.0,
				'mix', 0.06,
				'gain', 0.9,
				'fb', 0.001000031,
				'delay', 0.00000001,
				'delay2', 0.00001001,
				'delay3', 0.0010080,
				'distamp', 0.604,
				'distamp2', 0.23,
				'distamp3', 7.89,
				'shift', -5.0,
				'shiftmix', 0.0,
				'stereo', 1.0,
				'indelay', 0.04,
			)),
		],1),
		Pbind(
			\instrument, \morechord,
			\degree, Pseq([0,0,2],inf),
			\octave, 5,
			\freqenv, [ Env([1,2,1],[0.1,2.8]) ],
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\dur, Pseq([
				3,3,2,
				3,3,2,
				3,2,3,
			],inf)/8,
			\amp, 0.1/5,
			\out, BusDef(\chordbus, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\chordbus, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			\delay2, ~pmodenv.(Pseq([0.0011,0.000002],inf), 8),
			'distamp', 0.361836201538,
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
		Pbind(
			\instrument, \morechord,
			\degree, Pseq([8],inf),
			\octave, Pseq([
				4,5,
			],inf).stutter(8),
			\freqenv, [ Env([1,5,1],[4.1,1.8]) ],
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\legato, 1,
			\dur, Pseq([
				3,1/2,1/2,
				2,1/2,1,1/2,
			],inf)*1,
			\amp, 0.1/5,
		),

		// hat

		Pbind(
			\instrument, \iron,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2) + [0,3,7],
			\octave, 9,
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1.1,
			\fmr, 1/4 * Pseq([1,0.1],inf).stutter(2),
			\lpfr,2,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.2) ],
				[ Env.adsr(0.051,0.01,0.8,0.1) ],
				[ Env.adsr(0.011,0.01,0.8,0.2) ],
				[ Env.adsr(0.051,0.01,0.8,0.2) ],
				[ Env.adsr(0.051,0.01,0.8,0.1) ],
				[ Env.adsr(0.011,0.01,0.8,0.2) ],
				[ Env.adsr(0.051,0.01,0.8,0.1) ],
				[ Env.adsr(0.011,0.01,0.8,0.2) ],
			],inf).stutter(2),
			\legato, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,1,0,1, 1,0,1,0, 

				1,0,1,0, 1,0,1,0, 
				1,0,1,1, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,1,0,1, 
			],inf)/10,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\panwidth, 0.2,
			\gain, 5,
			\lag, 0.04,
			\amp,0.05,
		),
		Pbind(
			\instrument, \morechord,
			\freqenv, [ Env([2,1,0.91],[0.1,8.8]) ],
			\lpenv, [ Env([2,1,3.91],[0.1,8.8]) ],
			\adsr, Pseq([
				[ Env.adsr(4/~t,0.08,0.8,0.1/~t,1,-2) ],
				[ Env.adsr(4/~t,0.08,0.8,4.1/~t,1,-2) ],
			],inf).stutter(4),
			\ffmr, 1/4,
			\ringfreqtab, Prout({ arg ev;
					var freqs;
				   	freqs = {exprand(300, 20000)}.dup(10);
					inf.do {
						freqs = freqs + {exprand(300, 20000)}.dup(10)/2;
						ev = freqs.yield;
					};
			}),
			\ringdecaytab, Prout({ arg ev;
					var freqs;
				   	freqs = {exprand(0.03, 1.8)}.dup(10);
					inf.do {
						freqs = freqs + {exprand(0.03, 1.8)}.dup(10)/2;
						ev = freqs.yield;
					};
			}),
			\legato, 0.91,
			\note, Pseq([
				[0,1,3,7],
			],inf),
			\legato, Pseq([
				0,0,0,1,
				0,0,0,4,
				0,0,0,0,
				0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 7,
			\dur, 2,
			\amp, 0.1/4,
		),
		
	])
)).play;
)


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/16,
			\gain, 1/2,
			\out, BusDef(\kickbus, \audio),
		)),
		Pseq([
			Pfindur(8, Pmono(\rdnroom,
				\inbus, BusDef(\kickbus, \audio, 2),
				\dur, 1/8,
				'wet10', 1.0,
				'mix', 0.01,
				'gain', 2,
				'fb', 0.000000031,
				'delay', 0.00000001,
				'delay2', 0.00001001,
				'delay3', 0.1100080,
				'distamp', 0.604,
				'distamp2', 0.23,
				'distamp3', 1.89,
				'shift', -5.0,
				'shiftmix', 0.0,
				'stereo', 1.0,
				'indelay', 0.04,
			)),
			Pfindur(8, Pmono(\rdnroom,
				\inbus, BusDef(\kickbus, \audio, 2),
				\dur, 1/8,
				'wet10', 1.0,
				'mix', 0.06,
				'gain', 0.9,
				'fb', 0.001000031,
				'delay', 0.00000001,
				'delay2', 0.00001001,
				'delay3', 0.0010080,
				'distamp', 0.604,
				'distamp2', 0.23,
				'distamp3', 7.89,
				'shift', -5.0,
				'shiftmix', 0.0,
				'stereo', 1.0,
				'indelay', 0.04,
			)),
		],1),
		Pbind(
			\instrument, \morechord,
			\degree, Pseq([0,0,2],inf),
			\octave, 5,
			\freqenv, [ Env([1,2,1],[0.1,2.8]) ],
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\dur, Pseq([
				3,3,2,
				3,3,2,
				3,2,3,
			],inf)/8,
			\amp, 0.1/5,
			\out, BusDef(\chordbus, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\chordbus, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			\delay2, ~pmodenv.(Pseq([0.0011,0.000002],inf), 8),
			'distamp', 0.361836201538,
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
		Pbind(
			\instrument, \morechord,
			\degree, Pseq([8],inf),
			\octave, Pseq([
				4,5,
			],inf).stutter(8),
			\freqenv, [ Env([1,5,1],[4.1,1.8]) ],
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\legato, 1,
			\dur, Pseq([
				3,1/2,1/2,
				2,1/2,1,1/2,
			],inf)*1,
			\amp, 0.1/5,
		),

		// hat

		Pbind(
			\instrument, \iron,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2) + [0,3,7],
			\octave, 9,
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1.1,
			\fmr, 1/4 * Pseq([1,0.1],inf).stutter(2),
			\lpfr,2,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.4) ],
				[ Env.adsr(0.051,0.01,0.8,0.1) ],
				[ Env.adsr(0.011,0.01,0.8,0.2) ],
				[ Env.adsr(0.051,0.01,0.8,0.2) ],
				[ Env.adsr(0.051,0.01,0.8,0.1) ],
				[ Env.adsr(0.011,0.01,0.8,0.2) ],
				[ Env.adsr(0.051,0.01,0.8,0.1) ],
				[ Env.adsr(0.011,0.01,0.8,0.2) ],
			],inf).stutter(2),
			\legato, Pseq([
				1,0,1,1, 1,1,1,0, 
				1,0,1,1, 1,1,0,1, 
				1,1,1,0, 1,1,0,1, 
			],inf)/10 * Pseq([1,0.7],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\panwidth, 0.2,
			\gain, 5,
			\lag, 0.04,
			\amp,0.05,
		),
		Pbind(
			\instrument, \morechord,
			\freqenv, [ Env([2,1,0.91],[0.1,8.8]) ],
			\lpenv, [ Env([2,1,3.91],[0.1,8.8]) ],
			\adsr, Pseq([
				[ Env.adsr(4/~t,0.08,0.8,0.1/~t,1,-2) ],
				[ Env.adsr(4/~t,0.08,0.8,4.1/~t,1,-2) ],
			],inf).stutter(4),
			\ffmr, 1/4,
			\ringfreqtab, Prout({ arg ev;
					var freqs;
				   	freqs = {exprand(300, 20000)}.dup(10);
					inf.do {
						freqs = freqs + {exprand(300, 20000)}.dup(10)/2;
						ev = freqs.yield;
					};
			}),
			\ringdecaytab, Prout({ arg ev;
					var freqs;
				   	freqs = {exprand(0.03, 1.8)}.dup(10);
					inf.do {
						freqs = freqs + {exprand(0.03, 1.8)}.dup(10)/2;
						ev = freqs.yield;
					};
			}),
			\legato, 0.91,
			\note, Pseq([
				[0,1,3,7],
			],inf),
			\legato, Pseq([
				0,0,0,1,
				0,0,0,4,
				0,0,0,0,
				0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 7,
			\dur, 2,
			\amp, 0.1/4,
		),
		
	])
)).play;
)
