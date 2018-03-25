
~t = 135/4/60; TempoClock.default.tempo = ~t;

(
SynthDef(\bruit, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = 15.collect({ arg idx;
		var ffac = \fdiff.kr(1) * rrand(0,1) + 1;
		var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
		sig1 = LFSaw.ar(freq * ffac);
		sig2 = SinOsc.ar(freq * ffac); 
		sig = SelectX.ar( SinOsc.kr(rrand(1/18,1)).range(0,1), [sig1, sig2]);
		sig = sig * LFPulse.ar(rrand(1/18,1)).range(0,1);
		sig = BPF.ar(sig, freq * ( \bpfdiff.kr(1) * rrand(0.0,1) + 1),\rq.kr(0.5));
		sig = sig * ( \mutetab.kr(3) > idx );
	}).mean;
	sig = sig * 4;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\drumbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,1, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					0,0,0,0, 0,1,0,1,
					0,1,0,1, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
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

		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\drumbus1, \audio, 2),
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
		),


		/// btuiyt
		Pmono(\bruit,
			\note, Pseq([
				0,2,7,
			],inf),
			\mutetab, ~pmodenv.(Pseq([0,5,10,14],inf), 8),
			\fdiff, ~pmodenv.(Pseq([0,0.2,1,4],inf), 3),
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.01,
			'gain', 2,
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
		),
		
	])
)).play;
)



