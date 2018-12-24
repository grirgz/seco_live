~t = 185/4/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\port3, 
	Ppar([
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 24, 51], [0.035, 0.08], curve: \exp) ],
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
					1,0,0,0, 0,0,1,0,
					0,1,0,1, 0,0,1,0,
					1,1,0,0, 0,0,1,0,
					0,1,0,1, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
		]),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\lag, 0.04,
			\out, BusDef(\sendbus1, \audio),
			)),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.5714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085 * Pseq([
				1,12
			],inf),
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000100543560101,
			'distamp', 4.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 1990,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1/2,
		),
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				-5,-2,1,4,
			],inf) + Pseq([
				0,-1,2,-3,
			],inf).stutter(4),
			\hpfmix, 1,
			\hpf, 500,
			\lpfr, 2.3,
			\octave, 5,
			\dur, 1/1 * Pseq([4,1,3,4, 4,1,5,2].normalizeSum*4,inf),
			\amp, 0.1/5,
			\out, BusDef(\sendbus1, \audio),
			\lag, 0.04,
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\sendbus1),
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\sendbus1),
			\delay,1/36/~t * Pseg(Pseq([1,10],inf),8),
			\decay, 2,
			\dur, 1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\port2, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 44, 31], [0.015, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.001, 0.2, 0.1) ],
		
			\popfstart, 750,
			\popfend, 161,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 210,
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
				0,0,0,1, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.2,
			\lag, 0.04,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.2) ],
			],inf),
			\gain, 0.2,
			\dur, 1/8,
			\lag, 0.04,
		)),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,1.4) ],
				[ Env.adsr(0.001,0.1,0.8,0.4) ],
				[ Env.adsr(0.001,0.1,0.8,0.4) ],
				[ Env.adsr(0.001,0.1,0.8,1.4) ],
			],inf),
			\octave, 3,
			\legato, 1/4,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \ronordn,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.5714285714286,
			'gain', 0.1344889782792,
			'fb', 0.002099467303085,
			'delay2', 0.000000543560101,
			'distamp', 22.361836201538,
					'fb', 0.00201,
					'delay', 0.000010394574653723,
					'delay2', 0.00100828221925227,
			'delay2', 0.00000600001231 * Pseq([
				1,2000,200,
			],inf).stutter(1),
					'delay3', 0.01001,
					'distamp', 3.92682721311638,
					'distamp2', 001.0,
					'distamp3', 1.9904517086311,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 1990,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, 
				Plazy({ arg ev;
			Pseq([
					Pseq([
						1,1,
					],[4,8,12].choose),
					Pseq([
						1,0,
					],[4,8,12].choose),
			],inf).coin.not
				}).loop,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\lag, 0.04,
		),
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				-5,-2,1,4,
			],inf) + Pseq([
				0,-1,2,-3,
			],inf).stutter(4),
			\hpfmix, 1,
			\hpf, 500,
			\lpfr, 2.3,
			\octave, 5,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1/5,
			\out, BusDef(\sendbus3, \audio),
			\lag, 0.04,
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\sendbus3),
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\sendbus3),
			\delay,1/36/~t * Pseg(Pseq([1,10],inf),8),
			\decay, 2,
			\dur, 1,
		),
		Pbind(
			\instrument, \nidi,
			\note, Pseq([
				0,2,7,9,
			],inf),
			\dur, 1/8,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 16,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\distamp, 20,
			\mix, 0.5,
			\amp, 0.1/4,
		),
		
	])
)).play;
);

(
SynthDef(\nidi, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0.1,10,40,1],[4,4.1,0.8]), 1);
	sig = SinOsc.ar([234,234.43] * ( SinOsc.ar(freq) * env1 + 1 )).mean;
	sig1 = ( sig*\distamp.kr(1)*env1 ).tanh * \distpostamp.kr(1/2);
	sig = SelectX.ar(\mix.kr(1), [sig, sig1]);
	sig = sig * EnvGen.ar(Env.adsr(2.01,0.1,0.8,0.01),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\port1, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 44, 31], [0.015, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.001, 0.2, 0.1) ],
		
			\popfstart, 750,
			\popfend, 161,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 210,
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
				0,0,0,1, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.2,
			\lag, 0.04,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\speed, 0.951,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.4) ],
			],inf),
			\gain, 0.2,
			\dur, 1/8,
			\lag, 0.04,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\speed, 0.7,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,1, 0,0,0,1,
				0,1,0,1, 0,0,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,1,0,0, 0,1,0,0,
				0,0,0,1, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.005,0.1,0.8,0.2) ],
			],inf),
			\gain, 0.15,
			\dur, 1/8,
			\lag, 0.04,
		)),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,1.4) ],
				[ Env.adsr(0.001,0.1,0.8,0.4) ],
				[ Env.adsr(0.001,0.1,0.8,0.4) ],
				[ Env.adsr(0.001,0.1,0.8,1.4) ],
			],inf),
			\octave, 3,
			\legato, 1/4,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,0,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \ronordn,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.5714285714286,
			'gain', 0.1344889782792,
			'fb', 0.002099467303085,
			'delay2', 0.000000543560101,
			'distamp', 22.361836201538,
					'fb', 0.00201,
					'delay', 0.0000010394574653723,
					'delay2', 0.00100828221925227,
			'delay2', 0.00000600001231 * Pseq([
				1,1,1,2000,
				10,200,1/10,
			],inf).stutter(1),
					'delay3', 0.00001,
					'distamp', 3.02682721311638,
					'distamp2', 001.0,
					'distamp3', 1.9904517086311,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 1990,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 10900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, 
				Plazy({ arg ev;
			Pseq([
					Pseq([
						1,1,
					],[4,8,12].choose),
					Pseq([
						1,0,
					],[4,8,12].choose),
			],inf).coin.not;
				}).loop,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\lag, 0.04,
		),
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				-5,-2,1,4,
			],inf) + Pseq([
				0,-1,2,-3,
			],inf).stutter(4) + 
			Pseq([
				[0,6],
				[0,5],
			],inf),
			\strum, Pseg(Pseq([0,0.21],inf),8),
			\hpfmix, 1,
			\hpf, 500,
			\lpfr, 2.3,
			\octave, 5,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1/5,
			\out, BusDef(\sendbus3, \audio),
			\lag, 0.04,
		),
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				-5,-2,1,4,
			],inf) + Pseq([
				0,-1,2,-3,
			],inf).stutter(4) + 
			Pseq([
				19
			],inf),
			\hpfmix, 1,
			\hpf, 500,
			\lpfr, 2.3,
			\octave, 5,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/4 + (1/8),
			\amp, 0.1/10,
			\out, BusDef(\sendbus3, \audio),
			\lag, 0.04,
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\sendbus3),
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\sendbus3),
			\delay,1/36/~t * Pseg(Pseq([1,10],inf),8),
			\decay, 2,
			\dur, 1,
		),
		Pbind(
			\instrument, \nidi,
			\note, Pseq([
				0,2,7,9,
			],inf),
			\dur, 1/8,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 16,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\distamp, 20,
			\mix, 0.5,
			\amp, 0.1/4,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(7,
			Pdef(\port1_calm3),
		),
		Pfindur(6,
			Ppar([
				Pbind(
					\muter, Pstep(Pseq([
						Rest(1),
						Rest(1),
						Rest(1),
						0,
					],inf),1/2),
				)<>
				Pdef(\port1),
				Pdef(\port1_calm2),
			]),
		),
		Pfindur(6+8,
			Pdef(\port1),
		),
		Pfindur(2,
			Pdef(\port1_calm),
		),
		Pfindur(6+8,
			Pdef(\port1_calm),
		),
		Pfindur(1,
			Pdef(\port3),
		),
		Pfindur(10,
			Pdef(\port2),
		),
		Pfindur(2,
			Pdef(\port1_calm),
		),
		Pfindur(11,
			Pdef(\port3),
		),
		Pfindur(1,
			Pdef(\port2),
		),
		Pfindur(14,
			Pdef(\port1_calm4),
		),
		
	],inf)
)).play;
);

(
	// calm
Pdef(\part, Pdef(\port1_calm, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 44, 51], [0.015, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.001, 0.2, 1.1) ],
		
			\popfstart, 750,
			\popfend, 161,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 210,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,1,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.2,
			\lag, 0.04,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\speed, 0.7 * 1/Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1.1,0.8,1.3,
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(0.005,0.1,0.8,0.2) ],
				],12),
				Pseq([
					[ Env.adsr(0.005,0.1,0.8,0.2) ],
					[ Env.adsr(0.005,0.1,0.8,0.4) ],
					[ Env.adsr(0.005,0.1,0.8,0.6) ],
					[ Env.adsr(0.005,0.1,0.8,0.8) ],
				],4),
			],inf),
			\gain, 0.15,
			\dur, 1/8,
			\lag, 0.04,
		)),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,1.4) ],
				[ Env.adsr(0.001,0.1,0.8,0.4) ],
				[ Env.adsr(0.001,0.1,0.8,0.4) ],
				[ Env.adsr(0.001,0.1,0.8,1.4) ],
			],inf),
			\octave, 3,
			\legato, 1/4,
			\dur, 1,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,0,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \ronordn,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.5714285714286,
			'gain', 0.1344889782792,
			'fb', 0.002099467303085,
			'delay2', 0.000000543560101,
			'distamp', 22.361836201538,
					'fb', 0.00201,
					'delay', 0.0000010394574653723,
					'delay2', 0.00100828221925227,
			'delay2', 0.00000600001231 * Pseq([
				2000,
			],inf).stutter(1),
					'delay3', 0.00001,
					'distamp', 3.02682721311638,
					'distamp2', 001.0,
					'distamp3', 1.9904517086311,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 1990,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 10900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				-5,-2,1,4,
			],inf) + Pseq([
				0,-1,2,-3,
			],inf).stutter(4) + 
			Pseq([
				[0,6],
				[0,5],
			],inf),
			\strum, Pseg(Pseq([0,0.21],inf),8),
			\hpfmix, 1,
			\hpf, 500,
			\lpfr, 2.3,
			\octave, 5,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1,
			\amp, 0.1/15,
			\out, BusDef(\sendbus3, \audio),
			\lag, 0.04,
		),
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				-5,-2,1,4,
			],inf) + Pseq([
				0,-1,2,-3,
			],inf).stutter(4) + 
			Pseq([
				19
			],inf),
			\hpfmix, 1,
			\hpf, 500,
			\lpfr, 2.3,
			\octave, 5,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1 + (1/8),
			\amp, 0.1/20,
			\out, BusDef(\sendbus3, \audio),
			\lag, 0.04,
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\sendbus3),
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\sendbus3),
			\delay,1/36/~t * Pseg(Pseq([1,10],inf),8),
			\decay, 2,
			\dur, 1,
		),
		Pbind(
			\instrument, \nidi,
			\note, Pseq([
				0,2,7,9,
			],inf),
			\dur, 1/8,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 16,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\distamp, 20,
			\mix, 0.5,
			\amp, 0.1/4,
		),
		
	])
)).play;
);

(
	// calm
Pdef(\part, Pdef(\port1_calm2, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 44, 45], [0.015, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.001, 0.2, 0.1) ],
		
			\popfstart, 750,
			\popfend, 161,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 210,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 2,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\lag, 0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\speed, 0.7 * 1/Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1.1,0.8,1.3,
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(0.005,0.1,0.8,0.2) ],
				],12),
				Pseq([
					[ Env.adsr(0.005,0.1,0.8,0.2) ],
					[ Env.adsr(0.005,0.1,0.8,0.4) ],
					[ Env.adsr(0.005,0.1,0.8,0.6) ],
					[ Env.adsr(0.005,0.1,0.8,0.8) ],
				],4),
			],inf),
			\gain, 0.15,
			\dur, 1/8,
			\lag, 0.04,
		)),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.4) ],
			],inf),
			\octave, 3,
			\legato, 1/4,
			\dur, 1,
			\isRest, Pseq([
				0,0,0,0, 0,1,1,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \ronordn,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.5714285714286,
			'gain', 0.1344889782792,
			'fb', 0.002099467303085,
			'delay2', 0.000000543560101,
					'fb', 0.00201,
					'delay', 0.1000010394574653723,
					'delay2', 0.00100828221925227,
			'delay2', 0.00000600001231 * Pseq([
				20,
			],inf).stutter(1),
					'delay3', 0.00001,
					'distamp', 0.42682721311638,
					'distamp2', 001.0,
					'distamp3', 1.9904517086311,
					\shift, 0.10,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 1990,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 10900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				-5,-2,1,4,
			],inf) + Pseq([
				0,-1,2,-3,
			],inf).stutter(4) + 
			Pseq([
				[0,6],
				[0,5],
			],inf),
			\strum, Pseg(Pseq([0,0.21],inf),8),
			\hpfmix, 1,
			\hpf, 500,
			\lpfr, 2.3,
			\octave, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/15,
			\out, BusDef(\sendbus3, \audio),
			\lag, 0.04,
		),
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				-5,-2,1,4,
			],inf).stutter(4) + Pseq([
				0,-1,2,-3,
			],inf).stutter(4) + 
			Pseq([
				19
			],inf),
			\hpfmix, 1,
			\hpf, 500,
			\lpfr, 2.3,
			\octave, 5,
			\isRest, Pseq([
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8 + (1/8),
			\amp, 0.1/20,
			\out, BusDef(\sendbus3, \audio),
			\lag, 0.04,
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\sendbus3),
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\sendbus3),
			\delay,1/36/~t * Pseg(Pseq([1,10],inf),8),
			\decay, 2,
			\dur, 1,
		),
		Pbind(
			\instrument, \nidi,
			\note, Pseq([
				0,2,7,9,
			],inf),
			\dur, 1/8,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,0,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\distamp, 20,
			\mix, 0.5,
			\amp, 0.1/4,
		),
		
	])
)).play;
);

(
	// calm
Pdef(\part, Pdef(\port1_calm3, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 44, 45], [0.015, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.001, 0.2, 0.1) ],
		
			\popfstart, 750,
			\popfend, 161,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 210,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 2,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\lag, 0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\speed, 0.7 * 1/Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1.1,0.8,1.3,
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(0.005,0.1,0.8,0.2) ],
				],12),
				Pseq([
					[ Env.adsr(0.005,0.1,0.8,0.2) ],
					[ Env.adsr(0.005,0.1,0.8,0.4) ],
					[ Env.adsr(0.005,0.1,0.8,0.6) ],
					[ Env.adsr(0.005,0.1,0.8,0.8) ],
				],4),
			],inf),
			\gain, 0.15,
			\dur, 1/8,
			//\lag, 0.04,
			\out, BusDef(\sendbus2, \audio),
		)),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.4) ],
			],inf),
			\octave, 3,
			\legato, 1/4,
			\dur, 1,
			\isRest, Pseq([
				0,0,0,0, 0,1,1,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085 * Pseq([
				1,100,
			],inf),
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 4.361836201538,
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
		Pmono( \ronordn,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.5714285714286,
			'gain', 0.1344889782792,
			'fb', 0.002099467303085,
			'delay2', 0.000000543560101,
					'fb', 0.00201,
					'delay', 0.1000010394574653723,
					'delay2', 0.00100828221925227,
			'delay2', 0.00000600001231 * Pseq([
				20,
			],inf).stutter(1),
					'delay3', 0.00001,
					'distamp', 0.42682721311638,
					'distamp2', 001.0,
					'distamp3', 1.9904517086311,
					\shift, 0.10,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 1990,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 10900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				-5,-4,-4,-4,
			],inf) + Pseq([
				0,
			],inf).stutter(4) + 
			Pseq([
				[0,6],
				[0,5],
			],inf),
			\strum, Pseg(Pseq([0,0.21],inf),8),
			\hpfmix, 1,
			\hpf, 500,
			\lpfr, 2.3,
			\octave, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/15,
			\out, BusDef(\sendbus2, \audio),
			\lag, 0.04,
		),
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				-5,-4,-4,-4,
			],inf) + Pseq([
				0,
			],inf).stutter(4) + 
			Pseq([
				12
			],inf),
			\hpfmix, 1,
			\hpf, 500,
			\lpfr, 2.3,
			\octave, 5,
			\isRest, Pseq([
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8 + (1/8),
			\amp, 0.1/20,
			\out, BusDef(\sendbus3, \audio),
			\lag, 0.04,
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\sendbus3),
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\sendbus3),
			\delay,1/36/~t * Pseg(Pseq([1,10],inf),8),
			\decay, 2,
			\dur, 1,
		),
		Pbind(
			\instrument, \nidi,
			\note, Pseq([
				0,2,7,9,
			],inf),
			\dur, 1/8,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,0,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\distamp, 20,
			\mix, 0.5,
			\amp, 0.1/4,
		),
		
	])
)).play;
);

(
	// calm
Pdef(\part, Pdef(\port1_calm4, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 41, 30], [0.015, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.001, 0.1, 0.1) ],
		
			\popfstart, 750,
			\popfend, 061,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 160,
			\formbw, 8110,
			\lpf, 8140,
			\clickat, 0.001,
			\clickrel, 0.11,
			\clickamp, 0.25,
		
			\distpreamp, 2,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,1,1,0, 0,0,0,1,
				1,0,1,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\lag, 0.04,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\speed, 0.7 * 1/Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1.1,0.8,1.3,
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(0.005,0.1,0.8,0.2) ],
				],12),
				Pseq([
					[ Env.adsr(0.005,0.1,0.8,0.2) ],
					[ Env.adsr(0.005,0.1,0.8,0.4) ],
					[ Env.adsr(0.005,0.1,0.8,0.6) ],
					[ Env.adsr(0.005,0.1,0.8,0.8) ],
				],4),
			],inf),
			\gain, 0.15,
			\dur, 1/8,
			//\lag, 0.04,
			\out, BusDef(\sendbus3, \audio),
		)),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.4) ],
			],inf),
			\octave, 3,
			\legato, 1/4,
			\dur, 1,
			\isRest, Pseq([
				0,0,0,0, 0,1,1,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085 * Pseq([
				1,100,
			],inf),
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
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
		Pmono( \ronordn,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.5714285714286,
			'gain', 0.1344889782792,
			'fb', 0.002099467303085,
			'delay2', 0.000000543560101,
					'fb', 0.00201,
					'delay', 0.1000010394574653723,
					'delay2', 0.00100828221925227,
			'delay2', 0.00000600001231 * Pseq([
				1,20,
			],inf).stutter(1),
					'delay3', 0.00001,
					'distamp', 0.42682721311638,
					'distamp2', 001.0,
					'distamp3', 1.9904517086311,
					\shift, 0.10,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 1990,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 10900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				-5,-4,-4,-4,
			],inf).stutter(4) + Pseq([
				0,
			],inf).stutter(4) + 
			Pseq([
				[0,6],
				[0,5],
			],inf),
			\strum, Pseg(Pseq([0,0.21],inf),8),
			\hpfmix, 1,
			\hpf, 500,
			\lpfr, 2.3,
			\octave, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				1,1,0,0, 1,0,1,0,
				1,1,0,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/15,
			\out, BusDef(\sendbus2, \audio),
			//\lag, 0.04,
		),
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				-5,-4,-4,-4,
			],inf).stutter(4) + Pseq([
				0,
			],inf).stutter(4) + 
			Pseq([
				12
			],inf),
			\hpfmix, 1,
			\hpf, 500,
			\lpfr, 2.3,
			\octave, 5,
			\isRest, Pseq([
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8 + (1/8),
			\amp, 0.1/20,
			\out, BusDef(\sendbus3, \audio),
			\lag, 0.04,
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\sendbus3),
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\sendbus3),
			\delay,1/36/~t * Pseg(Pseq([1,10],inf),8),
			\decay, 2,
			\dur, 1,
		),
		Pbind(
			\instrument, \nidi,
			\note, Pseq([
				0,2,7,9,
			],inf),
			\dur, 1/8,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,0,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\distamp, 20,
			\mix, 0.5,
			\amp, 0.1/4,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pseq([
			//Event.silent(5),
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([561, 54, 31], [0.015, 0.08], curve: \exp) ],
				\bodyenv, 
				Pseq([
					[ Env.linen(0.001, 0.1, 0.4) ],
					[ Env.linen(0.001, 0.1, 0.1) ],
					[ Env.linen(0.001, 0.1, 0.1) ],
					[ Env.linen(0.001, 0.1, 0.1) ],
				],inf),
		
				\popfstart, 750,
				\popfend, 161,
				\popfdur, 0.02,
				\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
				\popamp, 0.15,
		
				\formfund, 210,
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
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,1,0,1,
				],1).coin.not,
				\dur, 1/8,
				\amp, 0.2,
				\lag, 0.04,
			),
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyfreqenv, [ Env([561, 54, 31], [0.015, 0.08], curve: \exp) ],
					\bodyenv, 
					Pseq([
						[ Env.linen(0.001, 0.1, 0.4) ],
						[ Env.linen(0.001, 0.1, 0.1) ],
						[ Env.linen(0.001, 0.1, 0.1) ],
						[ Env.linen(0.001, 0.1, 0.1) ],
					],inf),
			
					\popfstart, 750,
					\popfend, 161,
					\popfdur, 0.02,
					\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
					\popamp, 0.15,
			
					\formfund, 210,
					\formfreq, 4760,
					\formbw, 2110,
					\lpf, 3140,
					\clickat, 0.001,
					\clickrel, 0.01,
					\clickamp, 0.15,
			
					\distpreamp, 1,
					\distpostamp, 1,
			
					\isRest, Pseq([
						1,0,1,0, 0,0,0,1,
						1,0,1,0, 0,0,0,1,
						1,0,1,0, 0,0,0,1,
						1,0,1,0, 0,0,0,1,
						1,0,1,0, 0,0,0,1,
						1,0,1,0, 0,1,0,1,
						1,0,1,0, 0,0,1,1,
						1,0,0,0, 0,0,0,1,

						1,0,1,0, 0,0,0,1,
						1,0,1,0, 0,0,1,0,
						1,0,1,0, 0,0,0,1,
						1,0,1,0, 0,0,1,0,
						1,0,1,0, 0,0,0,1,
						1,0,1,0, 0,0,1,0,
						1,1,0,0, 0,1,1,0,
						1,0,0,0, 0,0,0,1,

						1,0,1,0, 0,0,0,1,
						1,0,1,0, 0,0,1,0,
						1,0,1,0, 0,0,0,1,
						1,0,1,0, 0,0,1,0,
						1,0,1,0, 0,0,0,1,
						1,0,1,0, 0,0,1,0,
						1,1,0,1, 0,0,1,0,
						0,0,1,0, 0,0,0,1,
					],inf).coin.not,
					\dur, 1/8,
					\amp, 0.2,
					\lag, 0.04,
				),
				PatKitDef(\bat).asPattern(Pbind(
					\kitIndex, 4,
					\speed, 0.951,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\sustain, 0.1,
					\adsr, Pseq([
						[ Env.adsr(0.001,0.1,0.8,0.4) ],
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\lag, 0.04,
				)),
				PatKitDef(\bat).asPattern(Pbind(
					\kitIndex, 4,
					\speed, 0.7,
					\isRest, Pseq([

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,1,1, 0,0,1,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,1,1,


						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,1,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,1,0,
						0,0,1,0, 0,0,0,0,
						0,0,1,0, 0,0,1,0,
						0,0,1,1, 0,0,1,0,


						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,1,1, 0,0,1,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,1,1,


						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,1,

						0,0,0,0, 0,0,1,0,
						1,0,0,1, 0,0,0,0,
						1,0,1,0, 0,0,1,0,
						0,0,1,1, 0,0,1,0,
					],inf).coin.not,
					\sustain, 0.1/2,
					\adsr, Pseq([
						[ Env.adsr(0.005,0.1,0.8,0.2) ],
					],inf),
					\gain, 0.15,
					\dur, 1/16,
					\lag, 0.04,
				)),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0, 1,0,
						1,0, 1,1,
						1,0, 1,0,
						1,1, 1,0,

						1,1, 0,1,
						1,0, 1,1,
						0,1, 1,0,
						1,1, 0,1,

						1,0, 1,0,
						1,0, 1,1,
						1,0, 1,0,
						1,1, 1,0,
						1,0, 1,0,
						1,1,1,1,
						1,1,1,1,
						1,0, 1,0,
						1,0, 1,0,
						0,1, 1,0,
						1,1, 0,1,
						1,1, 1,0,
						1,0, 0,0,
						1,1,1,1,
						1,1,1,1,
						1,1,1,1,
					],inf).coin.not,
					\sustain, 0.05,
					\fac1,0.1 * Pseq([
						1,1,3,1,
						1,1,1,3,
						1,1,1,1,
						1,1,1,1,
					],inf),
					\dur, 1/8,
					\lag, 0.04,
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
			]),
		]),
		Pmono(\crackledec,
			\chaos, 0.93500,
			\note, Pseq([
				1,3,12,4,
			],inf),
			\octave, 5,
			\format, Pseq([
				1,2,3,4,5
			],inf)/4,
			\formdec, 0.03,
			\xtrig, 1,
			\dur, 1,
			\amp, 0.2,
			\out, BusDef(\sendbus3, \audio),
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\sendbus3),
			\addAction, \addToTail,
			\lag, 0.0005,
			\dur, 1,
			\room, 0.1,
			\amp, 0.1,
			\out, BusDef(\filter, \audio),
		),
		Pmono(\fx_lpf,
			\inbus, BusDef(\filter),
			\addAction, \addToTail,
			\lag, 0.0006,
			\lpf, ~pmodenv.(Pseq([10,12000],inf), 8),
			\gain, 3,
			\dur, 1,
			\out, BusDef(\stutter, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\stutter),
			\addAction, \addToTail,
			\time, 1/8/~t * Pseq([
				1,1/2,0.758,
			],inf),
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,1,0,0, 1,0,0,1,

				Pser([
					1,0,1,0, 0,1,0,1,
					0,0,1,1, 0,0,0,0,
					0,1,0,0, 1,1,0,1,
					0,1,0,0, 1,0,0,
				],8*4*2),
			],inf),
			\lag, 0.0007,
			\dur, 1/4,
		),

		Pbind(
			\instrument, \iron,
			\note, Pseq([
				-5,-4,-4,-4,
			],inf).stutter(4) + Pseq([
				0,
			],inf).stutter(4) + 
			Pseq([
				[0,6],
				[0,5],
			],inf),
			\strum, Pseg(Pseq([0,0.21],inf),8),
			\hpfmix, 1,
			\hpf, 500,
			\lpfr, 2.3,
			\octave, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				1,1,0,0, 1,0,1,0,
				1,1,0,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/15,
			\out, BusDef(\sendbus3, \audio),
			//\lag, 0.04,
		),
		
	])
)).play;
);

SynthDef(\crackledec, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,0.1],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([0,1,0],[0.01,0.1]), \xtrig.tr(1));
	sig = Crackle.ar(\chaos.kr(1));
	sig = LFSaw.ar(freq * ( sig* 10.1 * env1 + 1 )); 
	sig = sig * env2;
	//sig = Formlet.ar(sig, freq,\format.kr(0.21),\formdec.kr(0.1));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = HPF.ar(sig, 50);
	sig = Limiter.ar(sig);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;



(
BufDef.mono(\moeten, "voices/02_moeten.flac");
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var clk = Impulse.ar(30);
	var bufnum = BufDef.mono('voices/kaspi.flac');
	var pitch_stretch = [1,0.8,1.2];
	var pos = 2.2 + LFNoise1.ar(11,mul:0.01) + Line.kr(0.01,0.15,10);
	var gdur = 0.4;
	sig = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), gdur, pan, 1);
	sig = sig + TGrains.ar(2, Impulse.kr(11), bufnum, pitch_stretch, pos+0.01 % BufDur.kr(bufnum), gdur, pan, 1);
	sig = sig.mean;
	sig = FreeVerb2.ar(sig[0],sig[1]);
	sig.debug("sig");
	sig = Splay.ar(sig, 1, amp, pan);
}).play;
);


(
BufDef.mono(\moeten, "voices/02_moeten.flac");
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var clk = Impulse.ar(20)+Dust.ar(20);
	//var bufnum = BufDef.mono('vipere/canabis.wav');
	var bufnum = BufDef.mono('vipere/booba.flac');
	var pitch_stretch = LFNoise1.kr(1/10!3)*0.01+1*[1,0.978,1.7142];
	
	var pos = Demand.ar(clk, 0,Dseq([
		Dseq([
			0.1,0.02,0.03,
		],19)+4,
		Dseq([
			0.1,0.02,0.03,
		],19)+3,
		Dseq([
			1,2,3,
		],9),
		Dseq([
			1,3,
		],9),
	],inf));
	var gdur = 0.2;
	sig = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), gdur, pan, 1);
	sig = sig + TGrains.ar(2, Impulse.kr(11), bufnum, pitch_stretch, pos+0.01 % BufDur.kr(bufnum), gdur, pan, 1);
	sig.debug("sig");
	sig = sig.flat;
	sig.debug("sig2");
	pan = LFNoise1.kr(0.1!sig.size);
	sig.debug("sig3");
	sig = Pan2.ar(sig, pan, amp).mean;
	sig.debug("sig4");
	sig = FreeVerb2.ar(sig[0],sig[1]);
	sig = sig * 2;
}).play;
);


(
SynthDef(\granchord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var clk = Impulse.ar(20)+Dust.ar(20);
	//var bufnum = BufDef.mono('vipere/canabis.wav');
	var bufnum = BufDef.mono('vipere/booba.flac');
	var pitch_stretch = LFNoise1.kr(1/10!3)*0.01+1*[1,0.978,1.7142];
	
	var pos = Demand.ar(clk, 0,Dseq([
		Dseq(\postab.kr([
			0.1,0.02,0.03,
		]),19),
	],inf));
	var gdur = 0.2;
	sig = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), gdur, pan, 1);
	sig = sig + TGrains.ar(2, Impulse.kr(11), bufnum, pitch_stretch, pos+0.01 % BufDur.kr(bufnum), gdur, pan, 1);
	sig.debug("sig");
	sig = sig.flat;
	sig.debug("sig2");
	pan = LFNoise1.kr(0.1!sig.size);
	sig.debug("sig3");
	sig = Pan2.ar(sig, pan, amp).mean;
	sig.debug("sig4");
//	sig = FreeVerb2.ar(sig[0],sig[1]);
sig = sig + Fb ({ arg fb;
	var isig;
	isig = ( fb * \fb.kr(0.7) ) + sig;

	isig = DelayL.ar(isig, 0.5, [0.0123,0.123,0.113,0.43]) + isig;
	//isig = DelayL.ar(isig, 1.5, [0.4134,0.426,1.114,0.13]+0.2* SinOsc.kr(4*~t).range(2,0.1)) + isig;
	isig = DelayL.ar(isig, 1.5, [0.4134,0.426,1.114,0.13]+0.4*0.00023* SinOsc.kr(3*~t).range(2,0.1)) + isig;
	isig = isig.tanh;
	//isig = DelayL.ar(isig, 1.5, [0.4134,0.426,1.114,0.13]) + isig;
	isig = Limiter.ar(isig);
	isig;
}).mean;
	sig = sig * 1/18;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\granchord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, pitch_stretch=1, gdur = 0.2;
	var sig;
	var clk = Impulse.ar(20)+Dust.ar(20);
	//var bufnum = BufDef.mono('vipere/canabis.wav');
	var bufnum = BufDef.mono('vipere/booba.flac');
	
	var pos = Demand.ar(clk, 0,Dseq([
		Dseq(\postab.kr([
			0.1,0.02,0.03,
		]),19),
	],inf));
	pitch_stretch = LFNoise1.kr(1/10!3)*0.01+1*[1,0.978,1.7142] * pitch_stretch;
	sig = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), gdur, pan, 1);
	sig = sig + TGrains.ar(2, Impulse.kr(11), bufnum, pitch_stretch, pos+0.01 % BufDur.kr(bufnum), gdur, pan, 1);
	sig.debug("sig");
	sig = sig.flat;
	sig.debug("sig2");
	pan = LFNoise1.kr(0.1!sig.size);
	sig.debug("sig3");
	sig = Pan2.ar(sig, pan, amp).mean;
	sig.debug("sig4");
//	sig = FreeVerb2.ar(sig[0],sig[1]);
	sig = sig * 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.1, 0.3,2) ],
		
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
		
			\distpreamp, 4,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,1, 1,0, 1,0,
				1,1, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\lag, 0.15,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \granchord,
			\postab, Pseq([
				[ [1,2,3,4]/10+5 ],
				[ [1,2,3,4]/10+5 ],
				[ [1,2,3,4]/10+5 ],
				[ [1,2,3,4]/10+5 ],
				[ [1,2,3,4]/10+7 ],
				[ [1,2,3,4]/10+5 ],
				[ [1,2,3,4]/10+5 ],
				[ [1,2,3,4]/10+5 ],
				[ [1,2,3,4]/10+9 ],
			],inf) + Pseg(Pseq([0,-5],inf),18),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\gdur, 0.5,
			\pitch_stretch, 2.1,
			\legato, Pseq([
				1/4,2,0,1/4,
				1/4,2,0,1/4,
				1/4,2,0,1/4,
				1/4,2,0,1/4,
				1/4,1.2,1/8,1/4,
			].rotate(2),inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \iron,
			\freq, ~pmodenv.(Pseq([1,1.2,1,0.8]*223 * 3/2,inf), 7),
			\legato, 0.1,
			\hpmix, 1,
			\diff, 0.2,
			\env1, Pseq([
				[ Env([1,2,0.1]/4,[0.4,0.8]) ]
			],inf),
			\fmr, 2,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\hpf, 1000,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,0,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.4,
		),
		Pbind(
			\instrument, \iron,
			\freq, ~pmodenv.(Pseq([1,2,1,4]*223,inf), 18),
			\legato, 0.1,
			\hpmix, 1,
			\diff, 0.2,
			\env1, Pseq([
				[ Env([1,2,0.1]/4,[0.4,0.8]) ]
			],inf),
			\fmr, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\hpf, 1000,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,0,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\amp, 0.4,
		),
		
	])
)).play;
);
