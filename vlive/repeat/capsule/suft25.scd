(
~t = 155/4/60; TempoClock.default.tempo = ~t;
~swing = 1/6;
)

(
SynthDef(\mouais, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var spread = ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1);
	sig2 = SinOsc.ar(freq *[1,2]* ( SinOsc.ar(freq * ( 3/2 )) * 1 + 1 )).sum;
	sig1 = LFPulse.ar(freq*[1,2]).sum;
	sig3 = LFSaw.ar(freq *1* ( SinOsc.ar(freq * ( 6/4 )) * 1 + 1 ));
	sig = LocalIn.ar(8) * \fb.kr(0.7);
	sig = SelectX.ar(sig.range(0,2) * \selectffac.kr(1) * spread, [sig1, sig2, sig3]) + sig /2;
	LocalOut.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	pan = pan + LFNoise1.kr((1..8)/45);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\fxmud, { arg out=0, mix=0.5, gain=1, gate=1;
	var in, sig;
	var modfreq;
	var imix;
	modfreq = XLine.kr(1,10000,20);
	imix = Duty.ar(
		Dseq([
			Dseq([
				1/4,
			],8),
			Dseq([
				1/8,
			],8),
			Dseq([
				1/32,
			],8),
		],inf)/~t, 0, Dseq([
		1,0,2,0,
		2,1,2,0,
	],inf));
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2);
	sig = in;
	sig = CombL.ar([ sig ], 1.1,0.1 * ((0..7)/7 - 0.5 * \delspread.kr(0.1) + 1),\decay.kr(0.1));
	sig = sig.collect({ arg isig;
		var osig = isig;
		isig = ( isig * 1 ).abs < 0.2 * isig;
		isig = SelectX.ar( imix, [isig, osig, in ] );
		isig = isig * \distpostamp.kr(1/2);
		isig;
       	});
	sig.debug("sig1");
	sig = sig.mean;
	sig.debug("sig2");
	sig = SelectX.ar(mix, [in, sig]);
	sig = sig * EnvGen.ar(\asr.kr(Env.asr(0.01,1,0.01)),gate,doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pmono(\mouais,
				\note, Pstep(Pseq([
					0,3,2,1,
				],inf),1/1),
				\octave, 3,
				\dur, 1/12 * (1 + (~swing * Pseq([1,-1],inf))),
				\fb, Pseq([
					0.7, 0.7, 0.7, 0.9,
					0.7, 1.1, 0.7, 1.1,
					1.1, 0.1, 0.1, 0.1,
				],inf),
				\selectffac, Pseq([
					0,2,2, 2,2,2, 0,2,2, 2,8,8,
					0,2,2, 2,2,2, 0,2,0, 0,0,0,
				],inf),
				\fspread, Pseq([
					1/11112,
					1/21112,
				],inf),
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/12 * (1 + (~swing * Pseq([1,-1],inf))),
				\isRest, Pseq([
					1,0, 0,0, 0,0,  0,0, 0,0, 0,0,
					1,0, 0,0, 1,0,  0,0, 0,0, 0,0,
				],inf).coin.not,
				\amp, 0.1 * Pseq([
					1,1/2, 1/2,1/2, 1/2,1/2,
				],inf),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0, 0,0, 0,0,  1,0, 0,0, 0,0,
					0,0, 0,0, 0,0,  1,0, 0,0, 0,0,
					0,0, 0,0, 0,0,  1,0, 0,0, 0,0,
					0,0, 0,0, 0,0,  1,0, 0,0, 0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2 * Pseq([
					1,1/2, 1/2,1/2, 1/2,1/2,
				],inf),
				\dur, 1/12 * (1 + (~swing * Pseq([1,-1],inf))),
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,
					1,0,
					1,0,
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/12 * (1 + (~swing * Pseq([1,-1],inf))),
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000000001231 * Pseq([
				1,
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
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000001001231 * Pseq([
				1,100,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 8.361836201538,
			'prelpf', 19900,
			'prehpf', 407,
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


			Pmono(\mouais,
				\note, Pstep(Pseq([
					0,3,2,1,
				],inf),1/1) + Pseq([
					0,1,-1,-2,0,-3,
				],inf),
				\octave, Prand([6,7,8],inf),
				\dur, 1/12 * (1 + (~swing * Pseq([1,-1],inf))),
				\fb, Pseq([
					0.7, 0.7, 0.7, 0.9,
					0.7, 1.1, 0.7, 1.1,
					1.1, 0.1, 0.1, 0.1,
				],inf),
				\selectffac, Pseq([
					100.0001,
				],inf),
				\fspread, Pseq([
					1/11112,
				],inf),
				\amp, 0.1 * Pseq([
					1,1, 1,1, 1,0,
					1,0, 1,0, 0,1,
					1,1, 1,1, 1,0,
					1,1, 1,0, 1,1,
					1,1, 1,1, 1,0,
					1,1, 0,1, 1,0,
				],inf),
				\out, BusDef(\sendbus2, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 11.361836201538,
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

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pmono(\mouais,
				\note, Pstep(Pseq([
					0,3,2,1,
				],inf),1/1),
				\octave, 3,
				\dur, 1/12 * (1 + (~swing * Pseq([1,-1],inf))),
				\fb, Pseq([
					0.7, 0.7, 0.7, 0.9,
					0.7, 1.1, 0.7, 1.1,
					1.1, 0.1, 0.1, 0.1,
				],inf),
				\selectffac, Pseq([
					0,2,2, 2,2,2, 0,2,2, 2,8,8,
					0,2,2, 2,2,2, 0,2,0, 0,0,0,
				],inf),
				\fspread, Pseq([
					1/11112,
					1/21112,
				],inf),
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/12 * (1 + (~swing * Pseq([1,-1],inf))),
				\isRest, Pseq([
					1,0, 0,0, 0,0,  0,0, 0,0, 0,0,
					1,0, 0,0, 1,0,  0,0, 0,0, 0,0,
				],inf).coin.not,
				\amp, 0.1 * Pseq([
					1,1/2, 1/2,1/2, 1/2,1/2,
				],inf),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0, 0,0, 0,0,  1,0, 0,0, 0,0,
					0,0, 0,0, 0,0,  1,0, 0,0, 0,0,
					0,0, 0,0, 0,0,  1,0, 0,0, 0,0,
					0,0, 0,0, 0,0,  1,0, 0,0, 0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2 * Pseq([
					1,1/2, 1/2,1/2, 1/2,1/2,
				],inf),
				\dur, 1/12 * (1 + (~swing * Pseq([1,-1],inf))),
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,
					1,0,
					1,0,
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/12 * (1 + (~swing * Pseq([1,-1],inf))),
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
			'prelpf', 1900,
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
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000001001231 * Pseq([
				1,100,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 4407,
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
				\out, BusDef(\sendbus3, \audio),
		),


			Pmono(\mouais,
				\note, Pstep(Pseq([
					0,3,2,1,
				],inf),1/1) + Pseq([
					0,1,-1,-2,0,-3,
				],inf),
				\octave, Prand([4,5,6,7,8],inf),
				\dur, 1/12 * (1 + (~swing * Pseq([1,-1],inf))),
				\fb, Pseq([
					0.7, 0.7, 0.7, 0.9,
					0.7, 1.1, 0.7, 1.1,
					1.1, 0.1, 0.1, 0.1,
				],inf),
				\selectffac, Pseq([
					100.0001,
				],inf),
				\fspread, Pseq([
					1/11112,
				],inf),
				\amp, 0.1 * Pseq([
					1,1, 1,1, 1,0,
					1,0, 1,0, 0,1,
					1,1, 1,1, 1,0,
					1,1, 1,0, 1,1,
					1,1, 1,1, 1,0,
					1,1, 0,1, 1,0,
				],inf),
				\out, BusDef(\sendbus2, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.200600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.700000543560101,
				'distamp', 11.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 44.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
				\out, BusDef(\sendbus3, \audio),
				\isRest, true,
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.4344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 11.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 44.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
				\out, BusDef(\sendbus3, \audio),
			),
			Pmono(\fxmud,
				\inbus, BusDef(\sendbus3),
				\delspread, ~pmodenv.(Pseq(1/[1,2,1,334],inf), 2),
				\decay, ~pmodenv.(Pseq([10,0.1,0,1,9],inf), 3.2),
				\mix, 1,
				\gain, 2,
				\dur, 1,
			),
		
	])
)).play;
)






(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\basssendbus1, \audio)) <>
		Ppar([
			Pmono(\mouais,
				\fb, Pseq([
					0.1,
				],inf),
				\selectffac, Pseq([
					0.2, 
				],inf),
				\fspread, Pseq([
					1/11112,
					1/11212,
				],inf),
				\note, Pseq([
					0,
				],inf).stutter(12),
				\octave, 3,
				\dur, 1/12,
				\amp, 0.1 * Pseq([
					1,1,1, 1,1,1,  1,1,0, 0,0,0,
					1,1,1, 1,1,1,  1,1,0, 0,0,0,
					1,1,1, 1,1,1,  1,1,0, 0,0,0,
					1,1,0, 0,0,1,  1,0,0, 0,0,0,
				],inf),
			),
			Pbind(
				\instrument, \mouais,
				\fb, Pseq([
					0.1,
				],inf),
				\selectffac, Pseq([
					0.2, 
				],inf),
				\fspread, Pseq([
					1/11112,
					1/11212,
				],inf),
				\legato, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,5,0, 0,0,0,  1,0,0, 0,0,0,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\note, Pseq([
						-5,
				],inf).stutter(12),
				\octave, 3,
				\dur, 1/12,
				\amp, 0.1,
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\basssendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.25714285714286,
			'gain', 1.0344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.010600001231 * Pseq([
				Pseg(Pseq([0,1],inf),10.1),
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 7.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 1900,
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
			

			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/12,
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 1,0,0,
					],inf).coin.not,
					\lag, Pwhite(0,0.2),
					\amp, 0.1,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,1,0, 0,0,0,
						0,0,0, 0,0,0,  0,1,0, 0,0,0,
						0,0,0, 1,0,0,  0,1,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1,
					\lag, Pwhite(0,0.1),
					\gain, 0.2,
					\dur, 1/12,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
					],inf).coin.not,
					\sustain, 0.1,
					\lag, Pwhite(0,0.1),
					\gain, 0.2,
					\dur, 1/12,
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 8,
					\isRest, Pseq([
						0,0,0, 1,1,1,  1,1,0, 0,0,0,
						0,0,1, 1,1,1,  1,1,0, 0,0,0,
						0,0,1, 1,1,0,  1,1,0, 0,1,1,
						0,1,1, 1,1,1,  0,0,0, 0,0,0,
						1,1,0, 1,1,0,  1,1,0, 1,1,0,
					],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/12,
					\amp, 0.1,
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
					\isRest, true,
				),
			]),
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
				\out, BusDef(\sendbus2, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.75714285714286,
				'gain', 0.4344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,
					Pseg(Pseq([0,1],inf),18),
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
			),

			// sifle


			Pbind(
				\instrument, \sawpad,
				\note, Pseq([
					Pseq((1..8))
				],inf),
				\octave, Prand([6],inf),
				\legato, 1,
				\isRest, Pseq([
					0,0,0,1,
				],inf).coin.not,
				\dur, 2,
				\lag, 0.5,
				\amp, 0.1,
				\out, BusDef(\bsendbus1, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\bsendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 71.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 54.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 700,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
			),
		
			// computer

			Pmono(\mouais,
				\note, Pstep(Pseq([
					0,3,2,1,
				],inf),1/1) + Pseq([
					0,1,-1,-2,0,-3,
				],inf),
				\octave, Prand([4,5,6,7,8],inf),
				\dur, 1/12 * (1 + (~swing * Pseq([1,-1],inf))),
				\fb, Pseq([
					0.7, 0.7, 0.7, 0.9,
					0.7, 1.1, 0.7, 1.1,
					1.1, 0.1, 0.1, 0.1,
				],inf),
				\selectffac, Pseq([
					100.0001,
				],inf),
				\fspread, Pseq([
					1/11112,
				],inf),
				\amp, 0.1 * Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,1, 1,1, 1,0,
					1,0, 1,0, 0,1,
					1,1, 1,1, 1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,1, 1,0, 1,1,
					1,1, 1,1, 1,0,
					1,1, 0,1, 1,0,
				],inf),
				\out, BusDef(\mudsendbus2, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\mudsendbus2, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.200600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.700000543560101,
				'distamp', 11.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 44.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 170,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
				\out, BusDef(\sendbus3, \audio),
				\isRest, true,
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\mudsendbus2, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.4344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 11.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 44.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 170,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
				\out, BusDef(\mudsendbus3, \audio),
			),
			Pmono(\fxmud,
				\inbus, BusDef(\mudsendbus3),
				\delspread, ~pmodenv.(Pseq(1/[1,2,1,334],inf), 2),
				\decay, ~pmodenv.(Pseq([10,0.1,0,1,9],inf), 3.2),
				\mix, 1,
				\gain, 4,
				\dur, 1,
			),

			// smp

			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop/loop2_185bpm.flac'),
				\pos, 1.1,
				\isRest, Pseq([
					1,0,
				],inf).coin.not,
				\lag,0.2,
				\dur, 1,
				\gain, 0.7,
				\out, BusDef(\smpsendbus1, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\smpsendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.200000001231 * Pseq([
					1,
					Pseg(Pseq([0,1],inf),1.9)
				],inf).stutter(1),
				'delay2', 0.00000543560101,
				'distamp', 19.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 470 * Pseg(Pseq([0,1],inf),1.8),
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

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\basssendbus1, \audio)) <>
		Ppar([
			Pmono(\mouais,
				\fb, Pseq([
					0.1,
				],inf),
				\selectffac, Pseq([
					0.2, 
				],inf),
				\fspread, Pseq([
					1/11112,
					1/11212,
				],inf),
				\note, Pseq([
					0,
				],inf).stutter(12),
				\octave, 3,
				\dur, 1/12,
				\amp, 0.1 * Pseq([
					1,1,1, 1,1,1,  1,1,0, 0,0,0,
					1,1,1, 1,1,1,  1,1,0, 0,0,0,
					1,1,1, 1,1,1,  1,1,0, 0,0,0,
					1,1,0, 0,0,1,  1,0,0, 0,0,0,
				],inf),
			),
			Pbind(
				\instrument, \mouais,
				\fb, Pseq([
					0.1,
				],inf),
				\selectffac, Pseq([
					0.2, 
				],inf),
				\fspread, Pseq([
					1/11112,
					1/11212,
				],inf),
				\legato, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,5,0, 0,0,0,  1,0,0, 0,0,0,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\note, Pseq([
						-5,
				],inf).stutter(12),
				\octave, 3,
				\dur, 1/12,
				\amp, 0.1,
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\basssendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.25714285714286,
			'gain', 1.0344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.010600001231 * Pseq([
				Pseg(Pseq([0,1],inf),10.1),
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 7.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 1900,
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
			

			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/12,
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 1,0,0,
					],inf).coin.not,
					\lag, Pwhite(0,0.2),
					\amp, 0.1,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,1,0, 0,0,0,
						0,0,0, 0,0,0,  0,1,0, 0,0,0,
						0,0,0, 1,0,0,  0,1,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1,
					\lag, Pwhite(0,0.1),
					\gain, 0.2,
					\dur, 1/12,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
					],inf).coin.not,
					\sustain, 0.1,
					\lag, Pwhite(0,0.1),
					\gain, 0.2,
					\dur, 1/12,
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 8,
					\isRest, Pseq([
						0,0,1, 1,0,0,  1,1,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/12,
					\amp, 0.1,
				)),
			]),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000000001231 * Pseq([
					1,
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
				\out, BusDef(\sendbus2, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.75714285714286,
				'gain', 0.4344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000000001231 * Pseq([
					1,
					Pseg(Pseq([0.1,100],inf),18),
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
			),


			// smp

			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop/loop2_185bpm.flac'),
				\pos, 1.1,
				\isRest, Pseq([
					1,0,
				],inf).coin.not,
				\lag,0.2,
				\dur, 1,
				\gain, 0.7,
				\out, BusDef(\smpsendbus1, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\smpsendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.200000001231 * Pseq([
					1,
					Pseg(Pseq([0,1],inf),1.9)
				],inf).stutter(1),
				'delay2', 0.00000543560101,
				'distamp', 19.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 470 * Pseg(Pseq([0,1],inf),1.8),
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

(
SynthDef(\sawpad, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1/2,1,2,3,4] * ( SinOsc.ar( freq * (1..8).midiratio * SinOsc.kr(1/3).range(0,1) ) * 1 + 1 ));
	sig = SinOsc.ar(freq * XLine.kr(2,1.9,1) * ( sig * 0.1 + 1 )) + sig;
	//sig = RLPF.ar(sig, ( \lpfr.kr(7.1) * freq ).clip(20,19900), \rq.kr(0.5));

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

Pdef(\plop, 
	Ppar([
		
			Pbind(
				\instrument, \sawpad,
				\note, Pseq([
					Pseq((1..8))
				],inf),
				\legato, 1/2,
				\dur, 2,
				\amp, 0.1,
			),
	])
).play;



(
SynthDef(\longway, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fspread=0.01;
	var sig;
	var spread =1;
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread + 1) * ( SinOsc.ar(freq*1.2) * 1 + 1 )) * ( SinOsc.ar(freq * 0.2) * 1 + 1 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,2.1),gate,doneAction:2);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\longway, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \longway,
				\note, Pseq([
					18,0,7,8
				],inf),
				\fspread, 1/Pkey(\freq) * 8,
				\dur, 1,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \playersec_looper,
				\bufnum, BufDef('voices/feynman.flac'),
				\trigfreq, 8*~t,
				\legato, 1,
				\pos, ~pmodenv.(Pseq([0,2,1,4],inf), 8),
				\dur, 1,
				\gain, 1/2,
			//	\out, BusDef(\smpsendbus1, \audio),
			),
		]),
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

		Pbind(\out, BusDef(\drums1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 
					1,0,1,0, 
					1,0,1,0, 
					1,0,1,0, 
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 0,0,0,0,

					0,0,0,0, 1,0,0,1,
					0,1,0,0, 0,1,0,1,
					0,0,0,0, 0,1,0,0,
					0,1,0,0, 1,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 1,0,0,0,

					0,0,0,0, 1,0,1,0,
					0,1,1,0, 1,0,1,1,
					0,1,0,1, 1,0,1,0,
					0,1,0,0, 1,0,1,0,
				],inf).coin.not,
				\gain, 0.2,
				\gain, Pkey(\gain) * Pseq([
					//Pseq([
						//1,1/3,1/2,1/3,
					//],2*4),
					Pseq([
						1,2/3,1/2,2/3,
					],2*4),
				],inf),
				\speed, Pwhite(1,1.01),
				\sustain, 0.1 * Pseq([
					1,3/5,4/5,3/5,
					2,3/5,4/5,3/5,
				],inf),
				\dur, 1/8 * (1 + (1/6 * Pseq([1,-1],inf))),
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,0,1, 1,0,1,0, 1,0,0,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.2,
				\dur, 1/16 * (1 + (1/6 * Pseq([1,0,-1,0],inf))),
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),

		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\drums1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.55714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.0000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.0000543560101,
			'distamp', 1.361836201538,
			'prelpf', 8900,
			'prehpf', 17,
			'lpf', 9900,
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
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\drums1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.25714285714286,
			'gain', 0.9344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000200001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.0000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 917,
			'lpf', 19900,
			'hpf', 117,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 170,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\drums1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.25714285714286,
			'gain', 0.9344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000200001231 * Pseq([
				1,1.3,1/2,
			],inf).stutter(1),
			'delay2', 0.1000543560101,
			'distamp', 2.361836201538,
			'prelpf', 19900,
			'prehpf', 13917,
			'lpf', 19900,
			'hpf', 117,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 170,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
		),
	])
)).play;
)


(
Pdef(\part, Pdef(\longway, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \longway,
				\note, Pseq([
					18,0,7,8
				],inf),
				\fspread, 1/Pkey(\freq) * 8,
				\dur, 1,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \playersec_looper,
				\bufnum, BufDef('voices/feynman.flac'),
				\trigfreq, 400*~t,
				\legato, 1,
				\pos, ~pmodenv.(Pseq([0,2,1,4],inf), 8),
				\dur, 1,
				\gain, 1/2,
			//	\out, BusDef(\smpsendbus1, \audio),
			),
		]),
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

		Pbind(\out, BusDef(\drums1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 
					1,0,1,0, 
					1,0,1,0, 
					1,0,1,0, 
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 0,0,0,0,

					0,0,0,0, 1,0,0,1,
					0,1,0,0, 0,1,0,1,
					0,0,0,0, 0,1,0,0,
					0,1,0,0, 1,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 1,0,0,0,

					0,0,0,0, 1,0,1,0,
					0,1,1,0, 1,0,1,1,
					0,1,0,1, 1,0,1,0,
					0,1,0,0, 1,0,1,0,
				],inf).coin.not,
				\gain, 0.2,
				\gain, Pkey(\gain) * Pseq([
					//Pseq([
						//1,1/3,1/2,1/3,
					//],2*4),
					Pseq([
						1,2/3,1/2,2/3,
					],2*4),
				],inf),
				\speed, Pwhite(1,1.01),
				\sustain, 0.1 * Pseq([
					1,3/5,4/5,3/5,
					2,3/5,4/5,3/5,
				],inf),
				\dur, 1/8 * (1 + (1/6 * Pseq([1,-1],inf))),
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,0,1, 1,0,1,0, 1,0,0,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.2,
				\dur, 1/16 * (1 + (1/6 * Pseq([1,0,-1,0],inf))),
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),

	])
)).play;
)
(
SynthDef(\simplegran, { arg out=0, mix=0.5, gain=1, gate=1, mbufnum=0, pitch_stretch=1, pos=0, gdur=0.1, pan;
	var sig;
	var clk;
	var phase;
	clk = Impulse.ar(\gfreq.kr(40));
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = pos;
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, phase % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * 0.5;
	sig = sig * EnvGen.ar(\asr.kr(Env.asr(0.01,1,0.01)),gate,doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
SynthDef(\doublegran, { arg out=0, mix=0.5, gain=1, gate=1, mbufnum=0, pitch_stretch=1, pos=0, gdur=0.1, pan;
	var sig;
	var clk;
	var phase;
	clk = Impulse.ar(\gfreq.kr(40));
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = pos;
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, phase + [0,\dephase.kr(0)] % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig.mean * 0.6;
	sig.debug("sig");
	sig = sig * EnvGen.ar(\asr.kr(Env.asr(0.01,1,0.01)),gate,doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pseq([
			Pbind(
				\instrument, \mouais,
				\note, Pseq([
					Pser([
						4,4,
					],8*3),
				],1),
				\octave, 3,
				\selectffac, Pseq([0.7,1],inf),
				\fb, Pseq([
					0.01,0.1,1,0.5,
				],inf).stutter(4),
				\legato, Pseq([
					Ppatlace([
						Pseg(Pseq([0.1,1],inf),1),
						Pseg(Pseq([0.2,1],inf),1.1),
						Pseg(Pseq([0.3,1],inf),1.2),
						Pseg(Pseq([0.4,1],inf),0.3),
					],inf),
				],inf),
				\dur, 1/4,
				\amp, 0.1,
				\out, BusDef(\sendbus2, \audio),
			),
			Pbind(
				\instrument, \mouais,
				\note, Pseq([
					Pser([
						3,2,
					],8*1 * 2),
				],1),
				\octave, 3,
				\selectffac, Pseq([0.7,1],inf),
				\fb, Pseq([
					0.01,0.1,1,0.5,
				],inf).stutter(4),
				\isRest, Pseq([
					1,1,0,0, 1,0,1,0,
					1,0,1,1, 1,0,1,0,
					1,0,1,1, 1,0,1,1,
					1,0,1,0, 1,1,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\sendbus2, \audio),
			),
		],inf),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.55714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 1900 * Pseq([
					1,10,
				],inf).stutter(2),
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
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/12 * (1 + (~swing * Pseq([1,-1],inf))),
				\isRest, Pseq([
					1,0, 0,0, 0,0,  0,0, 0,0, 0,0,
					1,0, 0,0, 1,0,  0,0, 0,0, 0,0,
					1,0, 0,0, 0,0,  0,0, 0,0, 0,0,
					1,0, 0,0, 1,0,  0,0, 0,0, 0,0,

					1,0, 0,0, 0,0,  0,0, 0,0, 0,0,
					1,0, 0,0, 1,0,  0,0, 0,0, 0,0,
					1,0, 0,1, 1,0,  0,0, 1,0, 0,0,
					0,0, 0,0, 0,0,  0,0, 0,0, 0,0,
				],inf).coin.not,
				\amp, 0.1 * Pseq([
					1,1/2, 1/2,1/2, 1/2,1/2,
				],inf),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0, 0,0, 0,0,  1,0, 0,0, 0,0,
					0,0, 0,0, 0,0,  1,0, 0,0, 0,0,
					0,0, 0,0, 0,0,  1,0, 0,0, 0,0,
					0,0, 0,0, 0,0,  1,0, 0,0, 0,1,

					0,0, 0,0, 0,0,  1,0, 0,0, 0,0,
					0,0, 0,0, 0,0,  1,0, 0,0, 0,0,
					0,0, 0,0, 0,0,  1,0, 0,1, 1,0,
					0,0, 0,1, 1,0,  1,0, 0,1, 1,1,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2 * Pseq([
					1,1/2, 1/2,1/2, 1/2,1/2,
				],inf),
				\dur, 1/12 * (1 + (~swing * Pseq([1,-1],inf))),
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,
					1,0,
					1,0,
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/12 * (1 + (~swing * Pseq([1,-1],inf))),
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000000001231 * Pseq([
				1,
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
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.45714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 0.361836201538,
			'prelpf', 19900,
			'prehpf', 407,
			'lpf', 19900,
			'hpf', 117,
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
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.75714285714286,
				'gain', 0.6344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000100001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.210000543560101,
				'distamp', 0.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 170,
				'fbdistamp', 1.5388371966577,
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
		Pmono(\simplegran,
			\freq, 200,
			\mbufnum, BufDef.mono('loop/loop3b_185bpm.flac'),
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, Pseq([
				~pmodenv.(Pseq([1,1.4]+0.4,1), 1/2),
				~pmodenv.(Pseq([1.4,1]+0.4,1), 1/2),
				~pmodenv.(Pseq([1.0,0.51]+0.4,1), 1),
				~pmodenv.(Pseq([1,1.4]+0,1), 1/2),
				~pmodenv.(Pseq([1.4,1]+0,1), 1/2),
				~pmodenv.(Pseq([1.0,0.51]+0,1), 1),
			],inf),
			\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
			\gdur, ~pmodenv.(Pseq([0.1,0.02],inf), 4),
			\pitch_stretch, 2,
			\dur, 1/ Pseq([
				4,5,6,7,8,
			],inf).stutter(8),
			\gain, Pseq([
				1,0,0,
			],inf),
		),
		Pmono(\simplegran,
			\freq, 200,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono('loop/loop3b_185bpm.flac'),
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\pos, Pseq([
				~pmodenv.(Pseq([1,4.0]+0.4,1), 2),
			],inf),
			\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
			\gdur, ~pmodenv.(Pseq([0.01,0.2],inf), 4),
			\pitch_stretch, 4,
			\dur, 1/4,
			\gain, Pseq([
				1,0,
			],inf),
			\amp, 0.1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pseq([
			Pbind(
				\instrument, \mouais,
				\note, Pseq([
					Pser([
						4,4,
					],8*3),
				],1),
				\octave, 3,
				\selectffac, Pseq([0.7,1],inf),
				\fb, Pseq([
					0.01,0.1,1,0.5,
				],inf).stutter(4),
				\legato, Pseq([
					Ppatlace([
						Pseg(Pseq([0.1,1],inf),1),
						Pseg(Pseq([0.2,1],inf),1.1),
						Pseg(Pseq([0.3,1],inf),1.2),
						Pseg(Pseq([0.4,1],inf),0.3),
					],inf),
				],inf),
				\dur, 1/4,
				\amp, 0.1,
				\out, BusDef(\sendbus2, \audio),
			),
			Pbind(
				\instrument, \mouais,
				\note, Pseq([
					Pser([
						3,2,
					],8*1 * 2),
				],1),
				\octave, 3,
				\selectffac, Pseq([0.7,1],inf),
				\fb, Pseq([
					0.01,0.1,1,0.5,
				],inf).stutter(4),
				\isRest, Pseq([
					1,1,0,0, 1,0,1,0,
					1,0,1,1, 1,0,1,0,
					1,0,1,1, 1,0,1,1,
					1,0,1,0, 1,1,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\sendbus2, \audio),
			),
		],inf),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.55714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 1900 * Pseq([
					1,10,
				],inf).stutter(2),
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
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/12 * (1 + (~swing * Pseq([1,-1],inf))),
				\isRest, Pseq([
					1,0, 0,0, 0,0,  0,0, 0,0, 0,0,
					1,0, 0,0, 1,0,  0,0, 0,0, 0,0,
					1,0, 0,0, 0,0,  0,0, 0,0, 0,0,
					1,0, 0,0, 1,0,  0,0, 0,0, 0,0,

					1,0, 0,0, 0,0,  0,0, 0,0, 0,0,
					1,0, 0,0, 1,0,  0,0, 0,0, 0,0,
					1,0, 0,1, 1,0,  0,0, 1,0, 0,0,
					0,0, 0,0, 0,0,  0,0, 0,0, 0,0,
				],inf).coin.not,
				\amp, 0.1 * Pseq([
					1,1/2, 1/2,1/2, 1/2,1/2,
				],inf),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0, 0,0, 0,0,  1,0, 0,0, 0,0,
					0,0, 0,0, 0,0,  1,0, 0,0, 0,0,
					0,0, 0,0, 0,0,  1,0, 0,0, 0,0,
					0,0, 0,0, 0,0,  1,0, 0,0, 0,1,

					0,0, 0,0, 0,0,  1,0, 0,0, 0,0,
					0,0, 0,0, 0,0,  1,0, 0,0, 0,0,
					0,0, 0,0, 0,0,  1,0, 0,1, 1,0,
					0,0, 0,1, 1,0,  1,0, 0,1, 1,1,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2 * Pseq([
					1,1/2, 1/2,1/2, 1/2,1/2,
				],inf),
				\dur, 1/12 * (1 + (~swing * Pseq([1,-1],inf))),
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,
					1,0,
					1,0,
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/12 * (1 + (~swing * Pseq([1,-1],inf))),
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000000001231 * Pseq([
				1,
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
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.45714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 0.361836201538,
			'prelpf', 19900,
			'prehpf', 407,
			'lpf', 19900,
			'hpf', 117,
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
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.75714285714286,
				'gain', 0.6344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000100001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.210000543560101,
				'distamp', 0.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 170,
				'fbdistamp', 1.5388371966577,
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
		Pmono(\simplegran,
			\freq, 200,
			\mbufnum, BufDef.mono('loop/loop3b_185bpm.flac'),
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, Pseq([
				~pmodenv.(Pseq([1,1.04,1.2]+0.4,1), 1/8),
				~pmodenv.(Pseq([1.4,1]+0.4,1), 1/8),
				~pmodenv.(Pseq([1,1.04,1.2]+0.4,1), 1/8),
				~pmodenv.(Pseq([1.4,1]+0.4,1), 1/8),
				~pmodenv.(Pseq([1,1.2]+0.4,1), 1/8),
				~pmodenv.(Pseq([1.4,1]+0.4,1), 1/8),
			],inf),
			\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
			\gdur, ~pmodenv.(Pseq([0.1,0.02],inf), 4),
			\pitch_stretch, 2,
			\dur, 1/8,
			\gain, Pseq([
				0,0,1,1,
				1,0,1,0,
				0,0,1,0,
				0,0,1,0,0,
			],inf),
		),
		Pbind(
			\instrument, \simplegran,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono('loop/loop3b_185bpm.flac'),
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\pos, Pseq([
				~pmodenv.(Pseq([1,4.0]+0.4,1), 2),
			],inf),
			\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
			\gdur, ~pmodenv.(Pseq([0.01,0.2],inf), 4),
			\pitch_stretch, 4,
			\dur, 1/4,
			\dur, 1/8,
			\gain, Pseq([
				1,0,1,0,
				1,0,1,0,
				1,0,1,0,
				1,1,1,1,
				1,0,1,0,
				1,1,0,1,
				1,0,1,0,
			],inf),
			\amp, 0.1,
		),
	])
)).play;
)

