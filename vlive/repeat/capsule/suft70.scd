
~t = 128/4/60; TempoClock.default.tempo = ~t;
(
SynthDef(\sino, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1.02,4/5],[0.5,0.8]), 1);
	sig = SinOsc.ar(freq * env1 * ( SinOsc.ar(freq*3/4) * 0.1 / env1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.4,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\violinx, { | out=0, freq=200, gate=1, amp=0.8 |
	var env = EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	var sig = VarSaw.ar(freq, width:LFNoise2.kr(1).range(0.2, 0.8)*SinOsc.kr(5, Rand(0.0, 1.0)).range(0.7,0.8))*0.25;
	sig = sig * env * amp;
	Out.ar(out, sig!2);
//It is also used for simulating Farfisa organ and flutes
//by nicolaariutti
//http://sccode.org/1-5as
}).add;
SynthDef(\chis, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, timeScale=1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([10,10420,182],[0.04,5.1]/~t,[1,1]),1, timeScale:timeScale);
	env2 = EnvGen.kr(Env([10,10100,152],[0.04,4.1]/~t,[1,1]), 1, timeScale:timeScale);
	env3 = EnvGen.kr(Env([10,710,1000],[4,0.1]/~t,[1,1]), 1, timeScale:timeScale);
	env4 = EnvGen.kr(Env([0.1,2,0.1],[4.0,0.08]/~t), 1, timeScale:timeScale);
	sig = WhiteNoise.ar;
	sig = Ringz.ar(sig, rrand(70.0!8,1000),0.01).mean;
	sig = sig * ( SinOsc.ar(7700) * env4 + 1 );
	//sig = RLPF.ar(sig, env2, \rq2.kr(0.8));
	sig = RHPF.ar(sig,  [env3, env2, env1 ], \rq.kr(0.5));
	sig = LPF.ar(sig,  15000, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,2.4)),gate,doneAction:2);
	sig = Pan2.ar(sig, [-1,0,1]*0.1, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\distantbleep, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = Blip.ar(freq,\numharm.kr(8));
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfr.kr(7.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \distantbleep,
			\freq, 90,
			\legato, 0.5,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\sendbus2),
			//\lpf, 16000,
			//\lpmix, 0.5,
			\room, 0.4,
			\damp, 10,
			\mix, 1,
			\gain, 1,
			\dur, 1,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\out, BusDef(\sendbus2, \audio),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			\delay2, ~pmodenv.(Pseq([0.0000001,0.0002,0.2],inf), 7.8),
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 170,
			\hpf, ~pmodenv.(Pseq([100,52,81],inf), 4.18),
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
			\instrument, \playersec_hlpf,
			\hpfmix, 1,
			\hpf, 14000,
			\speed, 0.9,
			\bufnum, BufDef('bruit1/07_ukraine.flac'),
			\bufnum, BufDef('vipere/crush.flac'),
			\pos, 31,
			\dur, 4,
			\legato, 1,
			\gain, 4,
			\out, BusDef(\sendbus3, \audio),
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\sendbus3),
			\lpf, 19000,
			\lpmix, 0.5,
			\decay, 3,
			\delayfac, 1,
			\mix, 1,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\tapeslow,\audio),
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\out, BusDef(\rev3, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sino,
			\freq, 400,
			\isRest, Pseq([
				0,0,0,0,
				0,0,0,1,
			],inf).coin.not,
			\dur, 1/2,
			\lag, 0.1,
			\legato, 0.8,
			\amp, 0.1,
			\out, BusDef(\rev3, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\rev3),
			//\lpf, 16000,
			//\lpmix, 0.5,
			\room, 0.4,
			\damp, 10,
			\mix, 0.51,
			\gain, 1,
			\dur, 1,
		),
		Pmono(\fx_tapeslow,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\tapeslow,\audio),
			\mix, Pseq([
				0,0,1,1, 0,0,0,0,
				0,0,0,0, 0,0,1,1,
				0,0,0,0, 0,1,1,0,
				0,1,0,0, 0,0,0,0,
			],inf),
			\env, Pseq([
				[ Env([1, 1,0.48,1.3,1], [0, 1,1,1]/2) ],
				[ Env([1, 1,0.8,0.3,1], [0, 1/2,1,1]/2) ],
			],inf).stutter(8),
			\time, 2,
			\dur, 1/4,
		),
		Pbind(
			\instrument, \chis,
			\timeScale, 1/3,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				11,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pn(1/8,inf),
			\adsr, Pseq([
				[ Env.adsr(1.9,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \harpsichord_simple,
			\note, Pseq([
				[0,3,9,3-12],
				[0,3,8,3-12],
				[0,3,7,3-12],
				[0,3,6,6+12],
			],inf).stutter(2),
			\octave, 5,
			\legato, Pseq([
				0,0,0,0, 4,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 2,0,1,1,
				1,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/4,
			\out, BusDef(\rev4, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			\bufnum, BufDef(\ukraine, "bruit1/07_ukraine.flac"),
			\speed, 1.2 * Pseg(Pseq([1.10,1],inf),1) * Pseq([1,1,0.86],inf),
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.151) ],
			],inf),
			\pos, Pwhite(0,0.01,inf)+0.15,
			\isRest, Pseq([
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				Pseq([
					1,
				],17),
			],inf).coin.not,
			\dur, 1/32,
			\gain, 1/1,
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,1,
				1,1,1,1, 0,1,1,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,1.7],inf),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\rev4, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.81,
			'gain', 1/9,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001 * Pseq([
				1,1000,
			],inf).stutter(3),
			'delay3', 0.2000080,
			'distamp', 0.604,
			'distamp2', 4.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
	])
)).play;
)

(
);

(
	// record here
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.3, 0.3) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.2,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 44, 21], [0.045, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.1, 0.03) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.172,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/4,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pmono(\fx_reverb,
			\addAction, \addToTail,
			\lag, 0.0004,
			\inbus, BusDef(\sendbus1),
			\lpf, 11000,
			\lpmix, 0.5,
			\decay, 3,
			\delayfac, 1,
			\mix, 0.2,
			\gain, 1.1,
			\dur, 1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\sendbus2, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				//0,0,0,0, 0,0,1,0,
				//0,1,0,0, 0,0,0,0,
				0
			],inf),
			\rate, 1,
			\time, Pstep(Pseq([1/4,1/8,1/4],inf),1/4)/~t,
			\time, 1/16/~t,
			\dur, Pser([1/8],inf),
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,0,1,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/8,
			\dur, 1/8,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,1, 1,1,0,1,

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,1,0,1, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\velamp, 1/12,
			\dur, 1/16,
		)),

		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\speed, 0.8,
			\lag, 0.03 * Pseq([1,1,2,1.5,1],inf).stutter(4),
			\sustain, 0.1,
			\velamp, 1/8,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,0,0,-1,
			],inf).stutter(4),
			\octave, 3,
			\dur, 1/8,
			//\lpf, 200 * Pseq([
				//1,1/2,1/3
			//],inf),
			\legato, Pseq([
				4,0,0,0, 0,0,0,0,
				0,0,2,0, 0,0,0,1,
				1,0,0,0, 0,3,0,0,
				0,0,0,1, 2,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
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
			'delay3', 0.2000080 * Pseq([
				1,1/1000
			],inf),
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
		Pbind(
			\instrument, \sino,
			\freq, 400,
			\isRest, Pseq([
				0,0,
				0,0,
				0,0,
				0,1,
			],inf).coin.not,
			\dur, 1/2,
			\lag, 0.1,
			\legato, 0.8,
			\amp, 0.1,
			\out, BusDef(\rev3, \audio),
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\rev3),
			\lpf, 16000,
			\lpmix, 0.5,
			\decay, 3,
			\delayfac, 1,
			\mix, 1,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \recorder,
			\addAction, \addToTail,
			\lag, 0.0009,
			\inbus, BusDef(\recorder, \audio),
			\inbus, 0,
			\bufnum, BufDef(\loop_bap1, s.sampleRate * 8/~t, 2),
			\dur, Pn(8,1),
			\out, BusDef(\null, \audio),
			\amp, 0.1,
			\isRest, true,
		),
		
	])
)).play;
)


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop_bap1'),
			\pos, Pseq([
				2,
			],inf)/2/~t,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.05,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\dur, 1/8,
			\gain, 1,
		),
		Pswitch([
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop_bap1'),
				\pos, Pseq([1.2,0.3,2.2],inf),
				\dur, Pn(1,1),
				\gain, 1,
			),
			Psync( Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop_bap1'),
				\pos, Pseq([
					2.5,
				],inf)/2/~t,
				\isRest, Pseq([
					1,1, 1,
				],inf).coin.not,
				\sustain, 0.05,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\dur, Pseg(Pseq([0.05,1/4],1),1),
				\gain, 1,
			), 1, 1),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop_bap1'),
				\pos, Pseq([1.23,0.3],inf),
				\dur, Pn(1/2,2),
				\gain, 1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop_bap1'),
				\pos, Pseq([1.3],inf),
				\dur, Pn(1,1),
				\gain, 1,
			),
		],Pseq([0,1,2,1,3,1],inf)),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop_bap1'),
			\pos, Pseq([
				3,
			],inf)/2/~t,
			\sustain, 0.05,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.8) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop_bap1'),
			\pos, Pseq([
				3.6,3.4,
			],inf)/2/~t,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\dur, 1/8,
			\gain, 1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.3, 0.3) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 44, 21], [0.045, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.1, 0.03) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/4,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop_bap1'),
			\pos, Pseq([
				3,
			],inf)/2/~t,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\speed, 0.9 * Pseq((5..1)/5,inf),
			\lag, 0.009 * Pseq((5..1)/50,inf),
			\sustain, Pseq((5..1)/50,inf),
			\isRest, Pseq([
				0,0,0, 0,0,0,  0,1,1, 1,1,1,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,1,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf).coin.not,
			\dur, 1/12,
			\gain, 0.9,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\hpf, 1000,
			\hpmix, 1,
			\bufnum, BufDef('loop_bap1'),
			\pos, Pseq([
				1.3,
			],inf)/2/~t,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			//\sustain, Pseq((5..1)/50,inf),
			\legato, Pseq([
				8,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\gain, 0.9,
		),
		Pmono(\fx_reverb,
			\addAction, \addToTail,
			\lag, 0.0004,
			\inbus, BusDef(\sendbus1),
			\lpf, 11000,
			\lpmix, 0.5,
			\decay, 3,
			\delayfac, 1,
			\mix, 0.2,
			\gain, 1.1,
			\dur, 1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\sendbus2, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				//0,0,0,0, 0,0,1,0,
				//0,1,0,0, 0,0,0,0,
				0
			],inf),
			\rate, 1,
			\time, Pstep(Pseq([1/4,1/8,1/4],inf),1/4)/~t,
			\time, 1/16/~t,
			\dur, Pser([1/8],inf),
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,0,1,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/8,
			\dur, 1/8,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,1, 1,1,0,1,

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,1,0,1, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\velamp, 1/12,
			\dur, 1/16,
		)),

		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\speed, 0.8,
			\lag, 0.03 * Pseq([1,1,2,1.5,1],inf).stutter(4),
			\sustain, 0.1,
			\velamp, 1/8,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,0,0,-1,
			],inf).stutter(4),
			\octave, 3,
			\dur, 1/8,
			\lpf, 200 * Pseq([
				1,1/2,1/3
			],inf),
			\legato, Pseq([
				4,0,0,0, 0,0,0,0,
				0,0,2,0, 0,0,0,1,
				1,0,0,0, 0,3,0,0,
				4,0,0,0, 2,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
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
			'delay3', 0.2000080 * Pseq([
				1,1/1000
			],inf),
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
		Pbind(
			\instrument, \sino,
			\freq, 400,
			\isRest, Pseq([
				0,0,
				0,0,
				0,0,
				0,1,
			],inf).coin.not,
			\dur, 1/2,
			\lag, 0.1,
			\legato, 0.8,
			\amp, 0.1,
			\out, BusDef(\rev3, \audio),
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\rev3),
			\lpf, 16000,
			\lpmix, 0.5,
			\decay, 3,
			\delayfac, 1,
			\mix, 1,
			\gain, 1,
			\dur, 1,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.1, 0.3) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
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
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/2,
			\dur, 1/8,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				1,0,0, 1,0,0,  1,0,0, 0,0,0,
				0,0,1, 0,1,0,  0,0,0, 1,0,0,
				1,0,1, 0,1,1,  0,0,1, 0,0,1,
				0,0,1, 1,1,1,  0,0,0, 0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
				[ Env.adsr(0.01,0.1,0.8,0.11) ],
			],inf).stutter(12),
			\sustain, 0.1/2,
			\speed, Pseg(Pseq([1,1.1,0.6],inf),1),
			\velamp, 1/8,
			\dur, 1/3 * PdurStutter(Pseq([1,4,2,8],inf), 1),
		)),
		Pmono(\playersec_hlpf,
			\hpf, 1000,
			\hpmix, 1,
			\bufnum, BufDef('loop_bap1'),
			\speed, Pseq([1,2,2,2,4,4,1,2],inf).stutter(3),
			\trigger, 1,
			\pos, Pseq([
				2,1,0,
			],inf).stutter(3)/2/~t,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			//\sustain, Pseq((5..1)/50,inf),
			\legato, Pseq([
				12,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\gain, 0.9,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.1, 0.3) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
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
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/2,
			\dur, 1/8,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				1,0,0, 1,0,0,  1,0,0, 0,0,0,
				0,0,1, 0,1,0,  0,0,0, 1,0,0,
				1,0,1, 0,1,1,  0,0,1, 0,0,1,
				0,0,1, 1,1,1,  0,0,0, 0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
				[ Env.adsr(0.01,0.1,0.8,0.11) ],
			],inf).stutter(12),
			\sustain, 0.1/2,
			\speed, Pseg(Pseq([1,1.1,0.6],inf),1),
			\velamp, 1/8,
			\dur, 1/3 * PdurStutter(Pseq([1,4,2,8],inf), 1),
		)),
		Pmono(\playersec_hlpf,
			\hpf, 1000,
			\hpmix, 1,
			\bufnum, BufDef('loop_bap1'),
			\speed, Pseq([1,2,2,2,4,4,1,2],inf).stutter(3),
			\trigger, 1,
			\pos, Pseq([
				2,1,0,
			],inf).stutter(3)/2/~t,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			//\sustain, Pseq((5..1)/50,inf),
			\legato, Pseq([
				12,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\gain, 0.9,
		),
		
	])
)).play;
)

//////////////////////


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),

	])
)).play;
)


(
Pdef(\demo, 
	Pbind(
		\instrument, \chis,
		\timeScale, 1/2,
		\freq, 200,
		\legato, 1,
		\dur, Pn(4,1),
		\adsr, Pseq([
			[ Env.adsr(0.1,0.1,0.8,0.1) ],
		],inf),
		\amp, 0.1/2,
	),
).play;
)


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
		Pbind(
			\instrument, \chis,
			\timeScale, 1/3,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				16,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pn(1/8,inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1/2,
		),
	])
)).play;
)




(
SynthDef(\graine, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, pitch_stretch=1, pos=0, gdur=0.1, mbufnum=0;
	var sig;
	var clk = Impulse.ar(\gfreq.kr(1));
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \graine,
			\mbufnum, BufDef.mono(\loop_bap1),
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)
