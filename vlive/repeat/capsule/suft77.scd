~t = 119/4/60; TempoClock.default.tempo = ~t;

(
SynthDef(\kbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1.02,1.05],[0.1,0.8]), 1);
	sig1 = LFSaw.ar(freq * [16/11,19/7,1]).mean;
	sig2 = LFSaw.ar(freq * ( SinOsc.ar(freq/2) * 1 + 1 ));
	sig = [sig1,sig2].mean;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.051,0.1,7.8,0.1,0.08)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.055, 0.01], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.05, 0.02) ],
		
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
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\lag, 0.04,
		),
		Pbind(
			\instrument, \kbass,
			\freq, 
			Pseq([
				Pseq([ 80, ],8*2),
				Pser([ 70,80,80, ],8),
			],inf),
			\dur, 1/8,
			\legato, Pseq([
				4,0,0,0, 0,0,3,0,
				0,0,2,0, 0,2,0,0,
			],inf),
			\lag, 0.04,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.3,
			\out, BusDef(\t1, \audio),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.071,
			\gain, 0.1,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 6,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\pos, 0.01,
			//\speed, 0.8,
			//\lag, 0.11,
			//\lag, 0.04,
			\gain, 0.1/2,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,1,1,
				1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,1,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\pos, 0.01,
			//\speed, 0.8,
			//\lag, 0.11,
			//\lag, 0.04,
			\gain, 0.1/2,
			\dur, 1/16,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\t1, \audio),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0.1,
			\sendbus0, BusDef(\sendbus1, \audio, 2),
			\dur, 1,
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.003,
			'gain', 2,
			'fb', 0.000005031,
			'delay', 0.10000001 * Pseq([
				1,1,1/1010,3,
			],inf).stutter(4),
			'delay2', 0.40001001,
			'delay3', 0.0010080 * Pseq([
				1,1/10,
			],inf).stutter(2),
			'distamp', 1.604,
			'distamp2', 1.23,
			'distamp3', 1.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
			\lag, 0.04,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\sustain, Pseq([
				0.2,0.01,0.01,
				0.2,0.01,
				0.2,0.01,0.01,
				0.2,0.01,0.01,
				0.2,0.01,0.01,
				0.2,0.01,
			],inf).stutter(2),
			\speed, 0.6,
			\lag, 0.04,
			\dur, 1/8,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 1,1,
				1,0, 0,0, 1,1, 1,1,
				1,0, 1,0, 1,0, 1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\velamp, 1/19,
			\lag, 0.04,
			\dur, 1/8,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0, 0,0,0,
				0,0,0, 0,0,0,
				0,0, 1, 1,0, 1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\speed, Pseq([
				1,1.05,0.99,
				1.1,1.05,0.99,
				0.91,1.05,0.99,
			],inf),
			\velamp, 1/19,
			\lag, 0.04,
			\dur, 1/16,
		)),
		Pbind(
			\instrument, \oneone2,
			\timeScale, 1/~t/2.2,
			\dur, 1/4,
			\amp, 0.1/2,
			\note, Pseq([
				Pser([
					0,0,0,-2, -2,0,-3,1,
					0,0,0,-3, -3,0,-3,1,
				],16),
			],inf) + [0,12],
			\octave, 6,
			\legato, Pseq([
				2,0,0,2, 0,0,1/2,1/2,
				2,0,0,2, 0,0,0,1/2,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\verb, \audio),
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\verb, \audio),
			\lpf, 16000,
			\lpmix, 0.5,
			\decay, 3,
			\delayfac, 1,
			\mix, 0.2,
			\gain, 1,
			\dur, 1,
		),
		

		
	])
)).play;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1, 1,0,1,  1,0,1, 1,0,0,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.02 * Pseq([1,0.5,0.7],inf),
		),
		Pbind(
			\instrument, \oneone2,
			\timeScale, 1/~t/1.2,
			\dur, 1/3,
			\amp, 0.1,
			\note, Pseq([
				2,
				5,
				9,
				9,
			],inf).stutter(3),
			\octave, 6,
			\legato, Pseq([
				1/2,0,0, 2,0,0, 4,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\verb, \audio),
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\verb, \audio),
			\lpf, 16000,
			\lpmix, 0.5,
			\decay, 3,
			\delayfac, 1,
			\mix, 0.2,
			\gain, 1,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8 * (1 + (0.29 * Pseq([1,-1],inf))),
			\amp, 0.02 * Pseq([1,0.5],inf),
		),
		Pbind(
			\instrument, \oneone2,
			\timeScale, 1/~t/1.2,
			\dur, 1/2,
			\amp, 0.1,
			\note, Pseq([
				2,
				5,
				9,
				9,
			],inf).stutter(2),
			\octave, 6,
			\legato, Pseq([
				1/2,0, 2,0, 4,0, 0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\verb, \audio),
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\verb, \audio),
			\lpf, 16000,
			\lpmix, 0.5,
			\decay, 3,
			\delayfac, 1,
			\mix, 0.2,
			\gain, 1,
			\dur, 1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.055, 0.01], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.05, 0.02) ],
		
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
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\lag, 0.04,
		),
		Pbind(
			\instrument, \kbass,
			\freq, 
			Pseq([
				Pseq([ 80, ],8*2),
				Pser([ 70,80,80, ],8),
			],inf),
			\dur, 1/8,
			\legato, Pseq([
				4,0,0,0, 0,0,3,0,
				0,0,2,0, 0,2,0,0,
			],inf),
			\lag, 0.04,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.3,
			\out, BusDef(\t1, \audio),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.071,
			\gain, 0.1,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 6,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\pos, 0.01,
			//\speed, 0.8,
			//\lag, 0.11,
			//\lag, 0.04,
			\gain, 0.1/2,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,1,1,
				1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,1,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\pos, 0.01,
			//\speed, 0.8,
			//\lag, 0.11,
			//\lag, 0.04,
			\gain, 0.1/2,
			\dur, 1/16,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\t1, \audio),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0.1,
			\sendbus0, BusDef(\sendbus1, \audio, 2),
			\dur, 1,
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.003,
			'gain', 2,
			'fb', 0.000005031,
			'delay', 0.10000001 * Pseq([
				1,1,1/1010,3,
			],inf).stutter(4),
			'delay2', 0.40001001,
			'delay3', 0.0010080 * Pseq([
				1,1/10,
			],inf).stutter(2),
			'distamp', 1.604,
			'distamp2', 1.23,
			'distamp3', 1.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
			\lag, 0.04,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\sustain, Pseq([
				0.2,0.01,0.01,
				0.2,0.01,
				0.2,0.01,0.01,
				0.2,0.01,0.01,
				0.2,0.01,0.01,
				0.2,0.01,
			],inf).stutter(2),
			\speed, 0.6,
			\lag, 0.04,
			\dur, 1/8,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,0, 1,1,
				1,0, 0,0, 1,1, 1,1,
				1,0, 1,0, 1,0, 1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\velamp, 1/19,
			\lag, 0.04,
			\dur, 1/8,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0, 0,0,0,
				0,0,0, 0,0,0,
				0,0, 1, 1,0, 1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\speed, Pseq([
				1,1.05,0.99,
				1.1,1.05,0.99,
				0.91,1.05,0.99,
			],inf),
			\velamp, 1/19,
			\lag, 0.04,
			\dur, 1/16,
		)),
		Ppar(
			( [0,3,7,9] + [[0,-12,12]] ).flat.collect{ arg note, idx;
				Pbind(
					\instrument, \oneone,
					\timeScale, 1/~t/2.2,
					\dur, 1/4,
					\amp, 0.1/2,
					\note, Pseq([
						Pser([
							0,0,0,-2, -2,0,-3,1,
							0,0,0,-3, -3,0,-3,1,
						],16),
					],inf) + [0,12],
					\note, Pseq([
						note
					],inf) + Pstep(Pseq([0,0,0,2],inf),2),
					\octave, 5,
					\legato, Pseq([
						8, 0,0,0,0, 0,0,0,
					],inf),
					\amp, Pseq([
						~pmodenv.(Pseq([0,0.1,0.1/2],inf), 1.1+idx),
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\out, BusDef(\verb, \audio),
				)
			
			}
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\verb, \audio),
			\lpf, 19000,
			\lpmix, 0.5,
			\decay, 3,
			\delayfac, 1,
			\mix, 0.1,
			\gain, 1/2,
			\dur, 1,
		),
		

		
	])
)).play;
);
