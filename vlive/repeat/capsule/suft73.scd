~t = 165/4/60; TempoClock.default.tempo = ~t; // death beast

FileSystemProject.load("holis/synthdef.scd")

(
SynthDef(\nidi2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0.1,1,40,1],[4,4.1,0.8]), 1);
	sig = SinOsc.ar([234,234.43] * ( SinOsc.ar(freq) * env1 + 1 )).mean;
	sig1 = ( sig*\distamp.kr(1)*env1 ).tanh * \distpostamp.kr(1/2);
	sig = SelectX.ar(\mix.kr(1), [sig, sig1]);
	sig = sig * EnvGen.ar(Env.adsr(2.01,0.1,0.8,0.01),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\subass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([2,1,1],[0.01,0.8]), 1);
	env2 = EnvGen.kr(\freqenv.kr(Env([1,1.1,1.02,1,0.991],[1/2,1/4, 1/4,1/2]/~t)), 1);
	sig = SinOsc.ar(freq * [1,1.002, env2]).sum;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.02,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\crackledec, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, timeScale=1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,1/2],[0.11,1.1]), \xtrig2.tr(1), timeScale:timeScale);
	env2 = EnvGen.kr(Env([0,1,0],[0.01,1.1]), \xtrig.tr(1), timeScale:timeScale);
	sig = Crackle.ar(\chaos.kr(1)*[1,1]);
	sig = LFSaw.ar(freq * ( sig* 1.1 * env1 + 1 )).mean; 
	sig = sig * env2;
	//sig = Formlet.ar(sig, freq,\format.kr(0.21),\formdec.kr(0.1));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = HPF.ar(sig, 50);
	sig = Limiter.ar(sig);
	sig=  sig  / 1;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.015, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,0, 1,0,0,  0,0,0, 0,0,0,
				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,1, 1,0,0,  0,0,0, 0,0,0,

				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,0, 1,0,0,  0,0,0, 1,0,1,
				1,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,1, 1,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\dur, 1/12,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,

				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,1,
			],inf).coin.not,
			\speed, 1.01,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\velamp, 1/3,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,

				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 0,0,1,  0,0,0, 0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\speed, 0.9,
			\velamp, 1/6,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.01 * Pseq([1,0.6,0.2],inf),
		),
		Pbind(
			\instrument, \subass,
			\freqenv, Pseq([
				[Env([1,1.1,1.02,1,0.991],[1/2,1/4, 1/4,1/2]/~t)],
				[Env([1,1.1,1.02,1,0.991],[1/2,1/4, 1/4,1/2]/~t)],
				[Env([1,1.1,1.02,1,0.991],[1/4,1/2, 1/2,1/4]/~t)],
				[Env([1,1.1,1.02,1,0.991],[1/4,1/2, 1/2,1/4]/~t)],
				[Env([1,1.1,1.02,1,0.991],[1/8,1/2, 1/2,1/4]/~t)],
			],inf).stutter(1),
			\note, Pseq([
				0,1,
			],inf)-2,
			\octave, 3,
			\lpf, 40,
			\dur, 1,
			\amp, 0.2,
		),
		Pmono(\crackledec,
			\chaos, 0.93500,
			\note, Pseq([
				0,-1, 9, 0,-1, 9, 0,3, 1, 0,3, 1,
				-1, 9, 0,-1, 9, 0, 3, 3, 0,  3,1,0,
			],inf).stutter(1),
			\octave, Pseq([
				7,6,5,4,
				7,6,5,4,
				7,6,5,4,
				7,4,7,4,
			].stutter(2),inf),
			\format, Pseq([
				1,2,3,4,5
			],inf)/4,
			\legato, Pseq([
				5,0,0, 0,0,6,  0,0,0, 0,0,0,
				1,0,1, 0,0,0,  3,0,0, 0,0,1,
				5,0,0, 0,0,6,  0,0,0, 0,0,0,
				1,0,1, 0,0,0,  1,0,1, 1,0,1,

				5,0,0, 0,0,3,  0,0,0, 0,0,0,
				1,0,1, 0,0,0,  3,0,0, 0,0,1,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 1,0,1,
			],inf),
			\timeScale, Pkey(\legato)/4,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\formdec, 0.03,
			\xtrig, 1,
			\xtrig2, Pseq([
				0,0,0,1,
				0,0,1,0,
				0,0,0,0,
			],inf),
			\dur, 1/12,
			\amp, 0.1/4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\sendbus1),
			\lpf, 16000,
			\lpmix, 0.1,
			\decay, 0.3,
			\delayfac, 0.1,
			\mix, 1/2,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\dur, 1/12,
			'wet10', 1.0,
			'mix', 0.5,
			'gain', 1/48,
			'fb', 0.0000031 * Pseq([
				1,2,1000,
			],inf).stutter(4),
			'delay', 0.0000080,
			'delay2', 0.00001001,
			'delay3', 0.0000080,
			'delay3', 0.00001001 * Pseq([
				1,12,1/12, 1,12,1/12, 3,100,1000, 3,100,1/1000,
			],inf),
			'distamp', 2.604,
			'distamp2', 22.23,
			'distamp3', 2.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
			\out, BusDef(\sendbus3, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\sendbus3, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				//0,0,0,0, 0,0,1,0,
				//0,1,0,0, 0,0,0,0,
				0,0,0, 0,1,1,
				0,0,0, 0,1,0,
				1,0,0, 0,0,0,
				0,1,1, 0,0,0,
			],inf),
			\rate, 1,
			\time, Pstep(Pseq([1/4,1/8,1/4],inf),1/4)/~t,
			\time, 1/12/2/~t,
			\dur, Pser([1/12],inf),
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
		Pbind(
			\instrument, \subass,
			\note, Pseq([
				0,1,
			],inf),
			\octave, 3,
			\lpf, 40,
			\dur, 1,
			\amp, 0.2,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.015, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,0, 1,0,0,  0,0,0, 0,0,0,
				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,1, 1,0,0,  0,0,0, 0,0,0,

				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,0, 1,0,0,  0,0,0, 1,0,1,
				1,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,1, 1,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\dur, 1/12,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,

				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,1,
			],inf).coin.not,
			\speed, 1.01,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\velamp, 1/3,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,

				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 0,0,1,  0,0,0, 0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\speed, 0.9,
			\velamp, 1/6,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.01 * Pseq([1,0.6,0.2],inf),
		),
		Pbind(
			\instrument, \subass,
			\freqenv, Pseq([
				[Env([1,1.1,1.02,1,0.991],[1/2,1/4, 1/4,1/2]/~t)],
				[Env([1,1.1,1.02,1,0.991],[1/2,1/4, 1/4,1/2]/~t)],
				[Env([1,1.1,1.02,1,0.991],[1/4,1/2, 1/2,1/4]/~t)],
				[Env([1,1.1,1.02,1,0.991],[1/4,1/2, 1/2,1/4]/~t)],
				[Env([1,1.1,1.02,1,0.991],[1/8,1/2, 1/2,1/4]/~t)],
			],inf).stutter(1),
			\note, Pseq([
				0,1,
			],inf)-2,
			\octave, 3,
			\lpf, 40,
			\dur, 1,
			\amp, 0.2,
		),
		Pmono(\crackledec,
			\chaos, 0.93500,
			\note, Pseq([
				0,
			],inf).stutter(1),
			\octave, Pseq([
				Pseq([
					Pseq([ 6 ],12), Pseq([ 6 ],10), 7,4,
				],3),
				Pseq([
					Pseq([ -16 ],12), Pseq([ -16 ],10), 7,4,
				],1),
			].stutter(2),inf),
			\format, Pseq([
				1,2,3,4,5
			],inf)/4,
			\legato, Pseq([
				12,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 9,0,0,  0,0,0, 0,0,0,
				12,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 9,0,0,  0,0,0, 1,0,0,
				12,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 2,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 1,0,0,
			],inf),
			\timeScale, Pkey(\legato)/4,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\formdec, 0.03,
			\xtrig, 1,
			\xtrig2, Pseq([
				0,0,0,1,
				0,0,1,0,
				0,0,0,0,
			],inf),
			\dur, 1/12,
			\amp, 0.1/4 * Pseq([
				Pseq([
					1
				],12*6),
				Pseq([
					0
				],12*2),
			],inf),
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\sendbus1),
			\lpf, 16000,
			\lpmix, 0.1,
			\decay, 0.3,
			\delayfac, 0.1,
			\mix, 1/2,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\dur, 1/12,
			'wet10', 1.0,
			'mix', 0.5,
			'gain', 1/48,
			'fb', 0.0000031 * 
			Pseq([
				Pseq([
					1,2,1000,
				],6).stutter(4),
				Pseq([
					1/10,1,1,
				],2).stutter(4),
			],inf),
			'delay', 0.0000080,
			'delay2', 0.00001001,
			'delay3', 0.0000080,
			'delay3', 0.00001001 * Pseq([
				1,12,1/12, 1,12,1/12, 3,100,1000, 3,100,1/1000,
			],inf),
			'distamp', 2.604,
			'distamp2', 22.23,
			'distamp3', 2.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
			\out, BusDef(\sendbus3, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\sendbus3, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				//0,0,0,0, 0,0,1,0,
				//0,1,0,0, 0,0,0,0,
				0,0,0, 0,1,1,
				0,0,0, 0,1,0,
				1,0,0, 0,0,0,
				0,1,1, 0,0,0,
			],inf),
			\rate, 1,
			\time, Pstep(Pseq([1/4,1/8,1/4],inf),1/4)/~t,
			\time, 1/12/2/~t,
			\dur, Pser([1/12],inf),
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.015, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,0, 1,0,0,  0,0,0, 0,0,0,
				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,1, 1,0,0,  0,0,0, 0,0,0,

				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,0, 1,0,0,  0,0,0, 1,0,1,
				1,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,1, 1,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\dur, 1/12,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,

				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,1,
			],inf).coin.not,
			\speed, 1.01,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\velamp, 1/3,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,

				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 0,0,1,  0,0,0, 0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\speed, 0.9,
			\velamp, 1/6,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.01 * Pseq([1,0.6,0.2],inf),
		),
		Pbind(
			\instrument, \subass,
			\freqenv, Pseq([
				[Env([1,1.1,1.02,1,0.991],[1/2,1/4, 1/4,1/2]/~t)],
				[Env([1,1.1,1.02,1,0.991],[1/2,1/4, 1/4,1/2]/~t)],
				[Env([1,1.1,1.02,1,0.991],[1/4,1/2, 1/2,1/4]/~t)],
				[Env([1,1.1,1.02,1,0.991],[1/4,1/2, 1/2,1/4]/~t)],
				[Env([1,1.1,1.02,1,0.991],[1/8,1/2, 1/2,1/4]/~t)],
			],inf).stutter(1),
			\note, Pseq([
				0,1,
			],inf)-2,
			\octave, 3,
			\lpf, 40,
			\dur, 1,
			\amp, 0.2,
		),
		Pmono(\crackledec,
			\chaos, 0.93500,
			\note, Pseq([
				0,
			],inf).stutter(1),
			\octave, Pseq([
				4,
			].stutter(2),inf),
			\format, Pseq([
				1,2,3,4,5
			],inf)/4,
			\legato, Pseq([
				12,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 9,0,0,  0,0,0, 0,0,0,
				12,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 9,0,0,  0,0,0, 1,0,0,
				12,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 2,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 1,0,0,
			],inf),
			\timeScale, Pkey(\legato)/4,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\formdec, 0.03,
			\xtrig2, Pseq([
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 1,0,0, 0,0,0, 0,0,0,
			],inf),
			\xtrig, Pkey(\xtrig2),
			\dur, 1/12,
			\amp, 0.1/4 * Pseq([
				Pseq([
					1
				],12*6),
				Pseq([
					0
				],12*2),
			],inf),
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\sendbus1),
			\lpf, 16000,
			\lpmix, 0.1,
			\decay, 0.3,
			\delayfac, 0.1,
			\mix, 1/2,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\dur, 1/12,
			'wet10', 1.0,
			'mix', 0.5,
			'gain', 1/48,
			'fb', 0.0000031 * 
			Pseq([
				Pseq([
					1,2,1,1000,
					1000,2,1,1,
				],3).stutter(3),
				Pseq([
					1/10,1,1,
				],2).stutter(4),
			],inf),
			'delay', 0.0000080,
			'delay2', 0.00001001,
			'delay3', 0.0000080,
			'delay3', 0.00001001 * Pseq([
				1,12,1/12, 1,12,1/12, 3,100,1000, 3,100,1/1000,
				3,100,1/1000, 1,12,1/12, 1,12,1/12, 3,100,1000,
			],inf),
			'distamp', 2.604,
			'distamp2', 22.23,
			'distamp3', 2.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
			\out, BusDef(\sendbus3, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\sendbus3, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				//0,0,0,0, 0,0,1,0,
				//0,1,0,0, 0,0,0,0,
				0,0,0, 0,1,1,
				0,0,0, 0,1,0,
				1,0,0, 0,0,0,
				0,1,1, 0,0,0,
			],inf),
			\rate, 1,
			\time, Pstep(Pseq([1/4,1/8,1/4],inf),1/4)/~t,
			\time, 1/12/2/~t,
			\dur, Pser([1/12],inf),
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.015, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,0, 1,0,0,  0,0,0, 0,0,0,
				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,1, 1,0,0,  0,0,0, 0,0,0,

				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,0, 1,0,0,  0,0,0, 1,0,1,
				1,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,1, 1,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\dur, 1/12,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,

				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,1,
			],inf).coin.not,
			\speed, 1.01,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\velamp, 1/3,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,

				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 0,0,1,  0,0,0, 0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\speed, 0.9,
			\velamp, 1/6,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.01 * Pseq([1,0.6,0.2],inf),
		),
		Pbind(
			\instrument, \subass,
			\freqenv, Pseq([
				[Env([1,1.1,1.02,1,0.991],[1/2,1/4, 1/4,1/2]/~t)],
				[Env([1,1.1,1.02,1,0.991],[1/2,1/4, 1/4,1/2]/~t)],
				[Env([1,1.1,1.02,1,0.991],[1/4,1/2, 1/2,1/4]/~t)],
				[Env([1,1.1,1.02,1,0.991],[1/4,1/2, 1/2,1/4]/~t)],
				[Env([1,1.1,1.02,1,0.991],[1/8,1/2, 1/2,1/4]/~t)],
			],inf).stutter(1),
			\note, Pseq([
				Pstep(Pseq([0,1],inf),1),
			],inf)-2,
			\octave, 3,
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,0, 1,0,0,  0,0,0, 0,0,0,
				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,1, 1,0,0,  0,0,0, 0,0,0,

				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,0, 1,0,0,  0,0,0, 1,0,1,
				1,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,1, 1,0,0,
			],inf).coin.not,
			\lpf, 40,
			\amp, 0.1/1.2,
		),
		Pmono(\crackledec,
			\chaos, 0.93500,
			\note, Pseq([
				0,
			],inf).stutter(1)-2,
			\octave, Pseq([
				3,
			].stutter(2),inf),
			\format, Pseq([
				1,2,3,4,5
			],inf)/4,
			\legato, Pseq([
				Pser([
					8,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 3,0,0,
					8,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 3,0,0,  0,0,0, 1,0,0,
				],3*12*2),
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 1,0,0,
			],inf),
			\timeScale, Pkey(\legato)/4,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\formdec, 0.03,
			\xtrig2, Pseq([
				1,0,0, 0,0,0, 0,0,0, 1,0,0,
				0,0,0, 1,0,0, 0,0,0, 1,0,0,
			],inf),
			\xtrig, Pkey(\xtrig2),
			\dur, 1/12,
			\amp, 0.1 * Pseq([
				Pseq([
					1
				],12*6),
				Pseq([
					0
				],12*2),
			],inf),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.015, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,0, 1,0,0,  0,0,0, 0,0,0,
				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,1, 1,0,0,  0,0,0, 0,0,0,

				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,0, 1,0,0,  0,0,0, 1,0,1,
				1,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,1, 1,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\dur, 1/12,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,

				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,1,
			],inf).coin.not,
			\speed, 1.01,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\velamp, 1/3,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,

				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 0,0,1,  0,0,0, 0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\speed, 0.9,
			\velamp, 1/6,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.01 * Pseq([1,0.6,0.2],inf),
		),
		Pbind(
			\instrument, \subass,
			\freqenv, Pseq([
				[Env([1,1.1,1.02,1,0.991],[1/2,1/4, 1/4,1/2]/~t)],
				[Env([1,1.1,1.02,1,0.991],[1/2,1/4, 1/4,1/2]/~t)],
				[Env([1,1.1,1.02,1,0.991],[1/4,1/2, 1/2,1/4]/~t)],
				[Env([1,1.1,1.02,1,0.991],[1/4,1/2, 1/2,1/4]/~t)],
				[Env([1,1.1,1.02,1,0.991],[1/8,1/2, 1/2,1/4]/~t)],
			],inf).stutter(1),
			\note, Pseq([
				1,0,
			],inf)-2,
			\octave, 3,
			\lpf, 40,
			\dur, 1,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \chovar,
			//\det, Ptuple (
				//Pwhite(0.01,0.00001,inf)!3
			//),
			\adsr, Pseq([
				Pfuncn({ arg ev;
					[ Env.adsr(0.1,0.1,0.8,rrand(0.1,1.2)) ]
				}),
				//Pfuncn({ arg ev;
					//[ Env.adsr(0.4,0.1,0.8,rrand(0.01,0.2)) ]
				//}),
			],inf),
			//\lpfr, Ptuple (
				//Pwhite(0.41,2.50001,inf)!3
			//),
			\note, Pseq([
				Pseq([
					1,1,1, 1,1,1,  1,1,1, 1,1,1,
					1,1,1, 0,1,1,  1,1,1, 0,1,1,
				],inf)-2,
			],inf) + 
			Pseq([
				Pseq([
					[3+12,3,7-12],
					[0,7,7-12],
				],12),
				Pseq([
					[3+12,3,7-12],
					[0,9,7-12],
				],12),
			],inf),
			\isRest, Pseq([
				1,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 1,0,0,  0,0,0, 0,0,0,
			],inf).coin.not,
			\dur, 1/12,
			\octave, 6,
			\amp, 0.1/3 * Ptuple(
				Pwhite(0.1,1,inf)!3,
			),
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\sendbus1),
			\lpf, 16000,
			\lpmix, 0.1,
			\decay, 0.3,
			\delayfac, 0.1,
			\mix, 0.1,
			\room, 0.1,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\sendbus2, \audio),
			\isRest, true,
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\dur, 1/12,
			'wet10', 1.0,
			'mix', 0.5,
			'gain', 1/10,
			'fb', 0.0000031 * 
			Pseq([
				Pseq([
					1,2,1,1000,
					1000,2,1,1,
				],3).stutter(3),
				Pseq([
					1/10,1,1,
				],2).stutter(4),
			],inf),
			'delay', 0.0000080,
			'delay2', 0.00001001,
			'delay3', 0.0000080,
			'delay3', 0.00100001 * Pseq([
				1
			],inf),
			'distamp', 2.604,
			'distamp2', 2.23,
			'distamp3', 2.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
			\out, BusDef(\sendbus3, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\sendbus3, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				//0,0,0,0, 0,0,1,0,
				//0,1,0,0, 0,0,0,0,
				0,0,0, 0,1,1,
				0,0,0, 0,1,0,
				1,0,0, 0,0,0,
				0,1,1, 0,0,0,
			],inf),
			\rate, 1,
			\time, Pstep(Pseq([1/4,1/8,1/4],inf),1/4)/~t,
			\time, 1/12/2/~t,
			\dur, Pser([1/12],inf),
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.015, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,0, 1,0,0,  0,0,0, 0,0,0,
				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,1, 1,0,0,  0,0,0, 0,0,0,

				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,0, 1,0,0,  0,0,0, 1,0,1,
				1,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,1, 1,0,0,

				1,0,0, 0,0,1,  0,0,0, 1,0,1,
				0,0,0, 1,0,0,  0,0,0, 0,0,0,
				0,0,1, 0,0,1,  0,0,0, 0,0,1,
				0,0,1, 1,0,0,  0,0,1, 1,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\dur, 1/12,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,

				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,1,
			],inf).coin.not,
			\speed, 1.01,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\velamp, 1/3,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,0, 1,0,0,  0,0,0, 1,0,1,
				1,0,1, 0,1,0,  0,0,1, 0,0,1,
				1,0,0, 1,0,0,  0,0,1, 0,0,0,
				0,1,0, 1,0,0,  0,0,0, 1,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1 * Pseq([
				1,1,1/8, 1/2,1,1,  1,1,1/4, 1,1,1/2,
			],inf),
			\speed, 0.9,
			\velamp, 1/6,
			\dur, 1/12,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,

				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 0,0,1,  0,0,0, 0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\speed, 0.9,
			\velamp, 1/6,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.01 * Pseq([1,0.6,0.2],inf),
		),
		Pbind(
			\instrument, \subass,
			\freqenv, Pseq([
				[Env([1,1.1,1.02,1,0.991],[1/2,1/4, 1/4,1/2]*2/~t)],
			],inf).stutter(1),
			\note, Pseq([
				1,0,
			],inf)-2,
			\legato, Pseq([
				3,0,0, 0,0,0,  0,0,0, 0,0,1,
				0,0,0, 3,0,0,  0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\lpf, 40,
			\dur, 1/12,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \organ_tonewheel1,
			\note, Pseq([
				0,3,7,
			],inf),
			\octave, 6,
			\dur, 1/12,
			\pan, ~pmodenv.(Pseq([-1,1],inf), 1),
			\amp, Pseq([
				~pmodenv.(Pseq([0.1,0],1), 3,1,-4),
				~pmodenv.(Pseq([0,0],1), 1/3,1,-2),
				~pmodenv.(Pseq([0,0],1), 1/3,1,-2),
				~pmodenv.(Pseq([0,0],1), 1/3,1,-2),
				~pmodenv.(Pseq([0.1,0],1), 3,1,-4),
				//~pmodenv.(Pseq([1,1,1, 1,1/2,1/2, 0,0,0, 0,0,0, 0],1), 1/12,1,-2)
			],inf),
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\sendbus1),
			\lpf, 16000,
			\lpmix, 0.5,
			\decay, 8,
			\delayfac, ~pmodenv.(Pseq([1,2,1,4]/10,inf), 8),
			\decay, ~pmodenv.(Pseq([1,2,1,4],inf), 5),
			\mix, 1,
			\gain, 1,
			\dur, 1/12,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.015, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,0, 1,0,0,  0,0,0, 0,0,0,
				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,1, 1,0,0,  0,0,0, 0,0,0,

				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,0, 1,0,0,  0,0,0, 1,0,1,
				1,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,1, 1,0,0,

				1,0,0, 0,0,1,  0,0,0, 1,0,1,
				0,0,0, 1,0,0,  0,0,0, 0,0,0,
				0,0,1, 0,0,1,  0,0,0, 0,0,1,
				0,0,1, 1,0,0,  0,0,1, 1,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\dur, 1/12,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,

				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,1,
			],inf).coin.not,
			\speed, 1.01,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\velamp, 1/3,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,0, 1,0,0,  0,0,0, 1,0,1,
				1,0,1, 0,1,0,  0,0,1, 0,0,1,
				1,0,0, 1,0,0,  0,0,1, 0,0,0,
				0,1,0, 1,0,0,  0,0,0, 1,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1 * Pseq([
				1,1,1/8, 1/2,1,1,  1,1,1/4, 1,1,1/2,
			],inf),
			\speed, 0.9,
			\velamp, 1/6,
			\dur, 1/12,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,

				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 0,0,1,  0,0,0, 0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\speed, 0.9,
			\velamp, 1/6,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.01 * Pseq([1,0.6,0.2],inf),
		),
		Pbind(
			\instrument, \subass,
			\freqenv, Pseq([
				[Env([1,1.1,1.02,1,0.991],[1/2,1/4, 1/4,1/2]*2/~t)],
			],inf).stutter(1),
			\note, Pseq([
				1,0,
			],inf)-2,
			\legato, Pseq([
				3,0,0, 0,0,0,  0,0,0, 0,0,1,
				0,0,0, 3,0,0,  0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\lpf, 40,
			\dur, 1/12,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \organ_tonewheel1,
			\note, Pseq([
				Pseq([
					0,3,7,
				],5),
				Pseq([
					0,3,7-12,
				],3),
				//Pseq([
					//0,3,7,
				//].reverse,4),
			],inf),
			\octave, 4,
			\dur, 1/12,
			\isRest, Pseq([
				1,1,0,1,
				1,1,0,0,
				1,1,0,1,
				1,0,0,1,
			],inf).stutter(3).coin.not,
			\pan, ~pmodenv.(Pseq([-1,1],inf), 1),
			\amp, 0.1/2,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\sendbus1),
			\addAction, \addToTail,
			\lag, 0.0005,
			\lpf, ~pmodenv.(Pseq([5000,40],inf), 3),
			\dur, 1,
		),
		Pbind(
			\instrument, \vlip,
			\note, Pseq([
				0,
			],inf),
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  6,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
		),

	])
)).play;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.015, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,0, 1,0,0,  0,0,0, 0,0,0,
				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,1, 1,0,0,  0,0,0, 0,0,0,

				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,0, 1,0,0,  0,0,0, 1,0,1,
				1,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,1, 1,0,0,

				1,0,0, 0,0,1,  0,0,0, 1,0,1,
				0,0,0, 1,0,0,  0,0,0, 0,0,0,
				0,0,1, 0,0,1,  0,0,0, 0,0,1,
				0,0,1, 1,0,0,  0,0,1, 1,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\dur, 1/12,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,

				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,1,
			],inf).coin.not,
			\speed, 1.01,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\velamp, 1/3,
		)),
		Pbind(
			\instrument, \wavechord,
			\note, Pseq([
					0,
			],inf),
			\legato, 0.4,
			\legato, Pseq([
				4,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf)/2,
			\lpfr, ~pmodenv.(Pseq([1/2,2],inf), 8),
			\rq, 0.5,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
				[ Env.adsr(0.01,0.1,0.8,0.21) ],
			],inf),
			\octave, 5,
			\dur, 1/12,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\velamp, 1/6,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \wavechord,
			\note, Pseq([
				-3,1,
			],inf),
			\legato, 0.4,
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,1,
				0,0,0, 0,0,0,  0,0,0, 3,0,0,
				0,0,0, 0,0,0,  0,0,0, 1,0,1,
			],inf)/2,
			\lpfr, ~pmodenv.(Pseq([2,1/2],inf), 8),
			\rq, 0.5,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
				[ Env.adsr(0.01,0.1,0.8,0.21) ],
			],inf),
			\octave, 6,
			\dur, 1/12,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \wavechord,
			\note, Pseq([
				[0+12,-3,1],
			],inf),
			\octave, 6,
			\legato, Pseq([
				9,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \kalimba,
			\note, Pseq([
				0,-1
			],inf).stutter(6),
			\octave, 6,
			\relMin, 0.1,
			\relMax, 1,
			\isRest, Pseq([
				0,0,0, 0,0,0,  0,0,1, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 1,0,0,
				0,0,0, 0,0,0,  0,0,0, 1,1,0,
				0,0,0, 0,0,0,  0,0,1, 0,0,1,
			],inf).coin.not,
			\dur, 1/12,
			\amp, 0.1,
			//\out, BusDef(\sendbus1, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \nidi2,
			\note, Pseq([
				0,2,7,9,
			],inf),
			\octave, 6,
			\dur, 1/12,
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				1,0,0, 1,0,0,  16,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\distamp, 20,
			\mix, 0.5,
			\amp, 0.1/2,
		),
		
	])
)).play;
);


(
ProtoDef(\rdn).play;
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.015, 0.08], curve: \exp) ],
				\dur, 1/12,
				\isRest, Pseq([
					1,0,0, 0,0,1,  0,0,0, 0,0,1,
					1,0,0, 1,0,0,  0,0,0, 0,0,1,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 4,
				\dur, 1/12,
				\isRest, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
				],inf).coin.not,
				\speed, 1.01,
				\sustain, 0.1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\velamp, 1/3,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 4,
				\dur, 1/12,
				\isRest, Pseq([
					0,0,0, 0,0,0,  1,0,0, 0,0,0,
				],inf).coin.not,
				\speed, 1.01,
				\sustain, 0.1/2,
				\adsr, Pseq([
					[ Env.adsr(0.02,0.1,0.8,0.13) ],
				],inf),
				\velamp, 1/6,
			)),
		]),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					1,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.1) ],
				],inf),
				\sustain, 0.1/2,
				\velamp, 1/6,
				\dur, 1/12,
				\out, BusDef(\sendbus31, \audio),
			)),
			Pbind(
				\instrument, \wavechord,
				\note, Pseq([
						0,
				],inf),
				\legato, 0.4,
				\legato, Pseq([
					4,0,0, 0,0,0, 0,0,0, 0,0,0,
				],inf)/2,
				\lpfr, ~pmodenv.(Pseq([1/2,2],inf), 8),
				\rq, 0.5,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
					[ Env.adsr(0.01,0.1,0.8,0.21) ],
				],inf),
				\octave, 5,
				\dur, 1/12,
				\amp, 0.1,
			),
		
		Pbind(
			\instrument, \wavechord,
			\note, Pseq([
				-3,1,
			],inf),
			\legato, 0.4,
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,1,
				0,0,0, 0,0,0,  0,0,0, 3,0,0,
				0,0,0, 0,0,0,  0,0,0, 1,0,1,
			],inf)/2,
			\lpfr, ~pmodenv.(Pseq([2,1/2],inf), 8),
			\rq, 0.5,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
				[ Env.adsr(0.01,0.1,0.8,0.21) ],
			],inf),
			\octave, 6,
			\dur, 1/12,
			\amp, 0.1,
			\lag, 0.004,
			\out, BusDef(\rev, \audio),
		),
		Pbind(
			\instrument, \wavechord,
			\note, Pseq([
				[0+12,-3,1],
			],inf),
			\octave, 6,
			\legato, Pseq([
				9,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1/4,
			\lag, 0.004,
			\out, BusDef(\rev, \audio),
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\rev),
			\lpf, 16000,
			\lpmix, 0.5,
			\decay, 3,
			\delayfac, 1,
			\mix, 1,
			\gain, 1,
			\dur, 1,
		),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,0, 1,0,0,  1,0,0, 1,0,0,
						1,0,1, 1,0,0,  1,0,0, 1,0,0,
						1,0,0, 1,0,0,  1,0,0, 1,0,1,
					],inf).coin.not,
					\sustain, 0.05,
					\fac1,0.1,
					\lag, 0.04,
					\dur, 1/12,
					\amp, 0.01 * Pseq([1,0.21,0.4],inf),
				),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 1,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.2,
					\fac1,0.9,
					\lag, 0.04,
					\dur, 1/12,
					\amp, 0.01 * Pseq([1,0.21,0.4],inf),
				),
	])
)).play;
);



(
ProtoDef(\rdn).play;
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pdict(
			(
				bass: Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('loop/suft73_165bpm.flac'),
					\dur, Pn(1/12,6),
					\legato, 1,
					\pos, 0.04 + Pseg(Pseq([0,1/2],1),1),
					\gain, 1,
				),
				bassshort: Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('loop/suft73_165bpm.flac'),
					\dur, Pn(1/12,6),
					\isRest, Pseq([
						1,1,1, 0,0,0, 0,0,0, 0,0,0,
					],inf).coin.not,
					\legato, 1,
					\pos, 0.04 + Pseg(Pseq([0,1/2],1),1),
					\gain, 1,
				),
				snare: Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('loop/suft73_165bpm.flac'),
					\dur, Pn(1/12,6),
					\legato, 1,
					\pos, 0.04 + Pseg(Pseq([2,5/2]/~t,1),1),
					\gain, 1,
				),
				snareshort: Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('loop/suft73_165bpm.flac'),
					\dur, Pn(1/12,6),
					\isRest, Pseq([
						1,1,1, 0,0,0,  0,0,0, 0,0,0,
					],inf).coin.not,
					\legato, 1,
					\pos, 0.04 + Pseg(Pseq([1/2,5/2]/~t,1),1),
					\gain, 1,
				),
				rest: Event.silent(1),
			),
			Pseq([
					\bassshort, \snareshort, 
					\bassshort, \snare, 
			],inf),
		),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.015, 0.08], curve: \exp) ],
				\dur, 1/12,
				\isRest, Pseq([
					1,0,0, 0,0,1,  0,0,0, 0,0,1,
					1,0,0, 1,0,0,  0,0,0, 0,0,1,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 4,
				\dur, 1/12,
				\isRest, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
				],inf).coin.not,
				\speed, 1.01,
				\sustain, 0.1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\velamp, 1/3,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 4,
				\dur, 1/12,
				\isRest, Pseq([
					0,0,0, 0,0,0,  1,0,0, 0,0,0,
				],inf).coin.not,
				\speed, 1.01,
				\sustain, 0.1/2,
				\adsr, Pseq([
					[ Env.adsr(0.02,0.1,0.8,0.13) ],
				],inf),
				\velamp, 1/6,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 1,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,1, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,1,0,
					0,0,1, 0,0,0,  0,0,0, 0,0,0,
				],inf).coin.not,
				\sustain, 0.1/2,
				\velamp, 1/6,
				\dur, 1/12,
			
			)),
				PatKitDef(\bat).asPattern(Pbind(
					\kitIndex, 8,
					\isRest, Pseq([
						1,0,1, 0,0,0, 0,0,0, 1,0,0,
						1,0,0, 0,0,1, 0,0,0, 0,0,1,
						1,0,0, 1,0,0, 0,0,0, 0,0,1,
						0,0,0, 1,0,0, 0,0,0, 0,0,1,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.001,0.1,0.8,0.1) ],
					],inf),
					\sustain, 0.1/2,
					\velamp, 1/6 * Pseq([
						1,0.2,0.5,
					],inf),
					\dur, 1/12,
				)),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,0, 1,0,0,  1,0,0, 1,0,0,
					],inf).coin.not,
					\sustain, 0.05,
					\fac1,0.1,
					\dur, 1/12,
					\amp, 0.01 * Pseq([1,0.21,0.1],inf),
				),
		]),
	])
)).play;
);
