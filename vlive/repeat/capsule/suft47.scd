~t = 185/4/60; TempoClock.default.tempo = ~t;
	(
	SynthDef(\cymbalsimple, { | out = 0, pan = 0.0, amp=0.1 |
		var sig, env;
		var env1, env2, env3, env4, env5, env6, env7, env8;
		env1 = EnvGen.kr(Env([1,0.02,1],[0.01,1.8]), 1);
		env = EnvGen.ar(Env.perc(0.001, 2, curve: -4), doneAction: 2);
		sig = HPF.ar(Ringz.ar(WhiteNoise.ar(0.1), {exprand(1000, 20000)}.dup(100), env1).mean, 4000);
		sig = BPF.ar(WhiteNoise.ar(1), 1900, 0.4) + sig;
		sig = sig * amp;
		Out.ar(out, Pan2.ar(sig * env, pan));
	}).add;
	)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 0.5,
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \cymbalsimple,
			\freq, 200,
			\dur, 1,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\amp, 0.2,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \oneone,
			\freq, 1200 * Pseq([
				1, 3/7,
			],inf).stutter(1),
			\dur, 2,
			\legato, 1,
			\amp, 0.1,
			\out, BusDef(\verbbus1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\verbbus1),
			\mix, 
			Pseq([
				~pmodenv.(Pseq([0,0.5],1), 1),
			],inf),
			\dur, 1,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.05714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
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
			\dur, 1,
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,0,0, 0,0,1,1,
			].rotate(0),inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\hibus1, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\verbbus1),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\stutbus, \audio, 2),
			\dur, 1,
		),
		Pmono(\feedmaster,
			\inbus, BusDef(\hibus1),
			\dur, 1,
			'wet10', 1.0,
			'mix', 1.0,
			'gain', 1.0052997797722/8,
			'fb', 0.00022170302067215,
			'delay', 0.000002297970969047,
			'delay2', 0.000013111339374216,
			'delay3', 0.0000074808264552251,
			'distamp', 0.3512751331888,
			'distamp2', 1.0195378685327,
			'distamp3', 11.2271768755705,
			'shift', 0.0,
			'shift2', 0.0,
			'shift3', -2.4789915966387,
			'shiftmix', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'ilpf', 19900,
			'ihpf', 7,
			\ipfmix, 1,
			'stereo', 0.0,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.18504562572587,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
			\out, BusDef(\stutbus, \audio),
			\addAction, \addToTail,
			\lag, 0.0004,
		),
		Pmono(\fx_stutter,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\stutbus, \audio),
			\rate, ~pmodenv.(Pseq([1,2,1,4],inf), 8),
			\time, 1/16/~t * Pseq([
				1,1/2,2,
			],inf).stutter(4),
			\mix, Pseq([
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
			],inf),
			\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
		),
	])
)).play;
)


(
SynthDef(\oneone, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var diff;
	env1 = EnvGen.kr(Env([0,1,0],[0.81,0.09]/~t*2), 1);
	env2 = EnvGen.kr(Env([0,0.0,1],[1,0.09]/~t), 1);
	diff= [1+env2,1-env2];
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq * 4/5 * diff) * env1 + 1 )) * SinOsc.ar(8*~t).range(0,1) ;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\oneone, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var diff;
	env1 = EnvGen.kr(Env([0,1,10],[0.81,0.09]/~t*2), 1);
	env2 = EnvGen.kr(Env([0,0.0,1],[1,0.09]/~t), 1);
	env3 = EnvGen.kr(Env([0.4,1.2,0.71],[1,0.99]/~t), 1);
	diff= [1+env2,1-env2];
	sig = LFSaw.ar(freq * ( SinOsc.ar(freq * 4/5 * diff) * env1 + 1 )) * SinOsc.ar(8*~t).range(0,1) ;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * env3 * freq, \rq.kr(0.1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);


Pdef(\part).clear;
(
Pdef(\part, Pdef(\kickstut, 
	Ppar([
		
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\hibus1, \audio),
		),
		Pmono(\feedmaster,
			\inbus, BusDef(\hibus1),
			\dur, 1,
			'wet10', 1.0,
			'mix', 1.0,
			'gain', 1.0052997797722/8/1.52,
			'fb', 0.00022170302067215,
			'delay', 0.000002297970969047,
			'delay2', 0.800013111339374216,
			'delay3', 0.0000074808264552251,
			'distamp', 0.3512751331888,
			'distamp2', 1.0195378685327,
			'distamp3', 1.2271768755705,
			'shift', 0.0,
			'shift2', 0.0,
			'shift3', -2.4789915966387,
			'shiftmix', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'ilpf', 19900,
			'ihpf', 7,
			\ipfmix, 1,
			'stereo', 0.0,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.18504562572587,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
			\out, BusDef(\stutbus, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\stutbus, \audio),
			\time, 1/8/~t,
			\mix, Pseq([
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
			],inf),
			\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
		),

	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 0.5,
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \cymbalsimple,
			\freq, 200,
			\dur, 1,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\amp, 0.2,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \oneone,
			\freq, 1200 * Pseq([
				1, 1/2,1,3/7,
			],inf).stutter(1),
			\dur, 2,
			\legato, 1,
			\amp, 0.1,
			\out, BusDef(\verbbus1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\verbbus1),
			\mix, 
			Pseq([
				~pmodenv.(Pseq([0,0.5],1), 1),
			],inf),
			\dur, 1,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.05714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
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
			\dur, 1,
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,0,0, 0,0,1,1,
			].rotate(0),inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\hibus1, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\verbbus1),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\stutbus, \audio, 2),
			\dur, 1,
		),
		Pmono(\feedmaster,
			\inbus, BusDef(\hibus1),
			\dur, 1,
			'wet10', 1.0,
			'mix', 1.0,
			'gain', 1.0052997797722/8,
			'fb', 0.00022170302067215,
			'delay', 0.000002297970969047,
			'delay2', 0.000013111339374216,
			'delay3', 0.0000074808264552251,
			'distamp', 0.3512751331888,
			'distamp2', 1.0195378685327,
			'distamp3', 11.2271768755705,
			'shift', 0.0,
			'shift2', 0.0,
			'shift3', -2.4789915966387,
			'shiftmix', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'ilpf', 19900,
			'ihpf', 7,
			\ipfmix, 1,
			'stereo', 0.0,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.18504562572587,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
			\out, BusDef(\stutbus, \audio),
			\addAction, \addToTail,
			\lag, 0.0004,
		),
		Pmono(\fx_stutter,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\stutbus, \audio),
			\rate, ~pmodenv.(Pseq([1,1,1/2,4],inf), 1),
			\time, 1/16/~t * Pseq([
				1,1/2,2,
			],inf).stutter(4),
			\mix, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
			],inf),
			\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([

		// bass
		
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\legato, 0.5,
			\amp, 0.1,
		),

		// kick

		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\lobus1, \audio),
		),

		// snare

		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\lobus1),
		)),

		// hat

		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,0,0, 0,0,1,1,
			].rotate(0),inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
			\amp, 0.01 * Pseq([1,0.7],inf),
		),

		// cymbal

		Pbind(
			\instrument, \cymbalsimple,
			\freq, 200,
			\dur, 1,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\amp, 0.2,
			\out, BusDef(\sendbus1, \audio),
		),

		// pitch
		Pbind(
			\instrument, \oneone,
			\freq, 1200 * Pseq([
				1, 1/2,1,3/7,
			],inf).stutter(1),
			\dur, 2,
			\legato, 1,
			\amp, 0.1,
			\out, BusDef(\verbbus1, \audio),
		),

		// mixer
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\verbbus1),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\stutbus, \audio, 2),
			\dur, 1,
		),

		// reverb
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\verbbus1),
			\mix, 
			Pseq([
				~pmodenv.(Pseq([0,0.5],inf), 1),
			],inf),
			\mix, 1,
			\dur, 1,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.05714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
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
			\dur, 1,
		),
		Pmono(\feedmaster,
			\inbus, BusDef(\hibus1),
			\dur, 1,
			'wet10', 1.0,
			'mix', 1.0,
			'gain', 1.0052997797722/8,
			'fb', 0.00022170302067215,
			'delay', 0.000002297970969047,
			'delay2', 0.000013111339374216,
			'delay3', 0.0000074808264552251,
			'distamp', 0.3512751331888,
			'distamp2', 1.0195378685327,
			'distamp3', 11.2271768755705,
			'shift', 0.0,
			'shift2', 0.0,
			'shift3', -2.4789915966387,
			'shiftmix', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'ilpf', 19900,
			'ihpf', 7,
			\ipfmix, 1,
			'stereo', 0.0,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.18504562572587,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
			\out, BusDef(\stutbus, \audio),
			\addAction, \addToTail,
			\lag, 0.0004,
		),
		Pmono(\fx_stutter,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\stutbus, \audio),
			\rate, ~pmodenv.(Pseq([1,1,1/2,4],inf), 1),
			\time, 1/16/~t * Pseq([
				1,1/2,2,
			],inf).stutter(4),
			\mix, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
			],inf),
			\mix, 1,
			\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
		),
		Pmono(\fx_stutter,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\stutbus, \audio),
			\rate, ~pmodenv.(Pseq([1,0.1,1/2,4],inf), Pwhite(1,2.09,inf)),
			\time, 1/16/~t * Prand([
				1,1/2,2,1.5,4,
			],inf).stutter(4),
			\mix, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
			],inf),
			\mix, 1,
			\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
		),
		Pmono(\feedmaster,
			\inbus, BusDef(\lobus1, \audio),
			\dur, 1,
			'wet10', 1.0,
			'mix', 1.0,
			'gain', 1.0052997797722/8,
			'fb', 0.00022170302067215,
			'delay', 0.000002297970969047,
			'delay2', 0.000013111339374216,
			'delay3', 0.0000074808264552251,
			//'delay3', ~pmodenv.(Pseq([0.000011,0.2],inf), 6),
			'distamp', 0.3512751331888,
			'distamp2', 0.0195378685327,
			'distamp3', 0.2271768755705,
			'shift', 0.0,
			'shift2', 0.0,
			'shift3', -2.4789915966387,
			'shiftmix', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'ilpf', 19900,
			'ihpf', 7,
			\ipfmix, 1,
			'stereo', 0.0,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.18504562572587,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
			\addAction, \addToTail,
			\lag, 0.0004,
			\out, BusDef(\stutbus2, \audio),
		),
		Pmono(\fx_stutter,
			\addAction, \addToTail,
			\lag, 0.0005,
			\lag, 0.04,
			\inbus, BusDef(\stutbus2, \audio),
			\rate, ~pmodenv.(Pseq([1,1,1/2,4,1,2,1,1,1/2]*0.4 + 1,inf), 1),
			\gain, 2,
			\time, 1/8/~t * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,2,2, 1,1,1,1,
			],inf).stutter(1),
			\mix, Pseq([
				1,0,0,0, 1,1,0,0,
				0,0,1,0, 1,1,1,0,
			],inf)/2,
			\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
			\isRest, true,
		),
		Pmono(\fx_echo,
			\addAction, \addToTail,
			\lag, 0.0005,
			\lag, 0.04,
			\inbus, BusDef(\stutbus2, \audio),
			\rate, ~pmodenv.(Pseq([1,1,1/2,4,1,2,1,1,1/2]*0.4 + 1,inf), 1),
			\gain, 2,
			\delay, 1/8/~t * Pseq([
				Pseq([
					1
				],inf),
				1.5,1,1,1, 1,1,1,1,
				1,1,2,2, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,2,2, 2,1,1,1,
			],inf).stutter(1),
			\mix, Pseq([
				1,1,0,0, 1,1,0,0,
				0,0,1,1, 0,0,1,0,
				1,0,0,0, 1,1,0,0,
				0,0,1,0, 0,0,1,0,
				1,0,0,0, 1,1,0,0,
				0,0,1,0, 1,0,1,0,
			],inf)/2,
			\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
		),
	])
)).play;
)


(
Pdef(\part, Pdef(\zed, 
	Ppar([

		// bass
		
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\legato, 0.5,
			\amp, 0.1,
		),

		// kick

		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\lobus1, \audio),
		),

		// snare

		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\mix1, \audio),
		)),

		// hat

		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,0,0, 0,0,1,1,
			].rotate(0),inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
			\amp, 0.01 * Pseq([1,0.7],inf),
		),

		// cymbal

		Pbind(
			\instrument, \cymbalsimple,
			\freq, 200,
			\dur, 1,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\amp, 0.2,
			\out, BusDef(\sendbus1, \audio),
		),

		// pitch
		Pbind(
			\instrument, \oneone,
			\freq, 1200 * Pseq([
				1, 1/2,1,3/7,
			],inf).stutter(1),
			\dur, 2,
			\legato, 1,
			\amp, 0.1,
			\out, BusDef(\mix1, \audio),
		),

		// mixer
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\mix1),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\stutbus, \audio, 2),
			\send1, 1,
			\sendbus1, BusDef(\verbbus1, \audio, 2),
			\dur, 1,
		),

		// reverb
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\verbbus1),
			//\mix, 
			//Pseq([
				//~pmodenv.(Pseq([0,0.5],inf), 1),
			//],inf),
			\mix, 1,
			\dur, 1,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.05714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
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
			\dur, 1,
		),
		Pmono(\feedmaster,
			\inbus, BusDef(\hibus1),
			\dur, 1,
			'wet10', 1.0,
			'mix', 1.0,
			'gain', 1.0052997797722/8,
			'fb', 0.00022170302067215,
			'delay', 0.000002297970969047,
			'delay2', 0.000013111339374216,
			'delay3', 0.0000074808264552251,
			'distamp', 0.3512751331888,
			'distamp2', 1.0195378685327,
			'distamp3', 1.2271768755705,
			'shift', 0.0,
			'shift2', 0.0,
			'shift3', -2.4789915966387,
			'shiftmix', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'ilpf', 19900,
			'iverbbus1hpf', 7,
			\ipfmix, 1,
			'stereo', 0.0,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.18504562572587,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
			//\out, BusDef(\stutbus, \audio),
			\addAction, \addToTail,
			\lag, 0.0004,
		),
		Pmono(\fx_stutter,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\stutbus, \audio),
			\rate, ~pmodenv.(Pseq([1,1,1/2,4],inf), 1),
			\time, 1/16/~t * Pseq([
				1,1/2,2,
			],inf).stutter(4),
			\mix, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
			],inf),
			\mix, 1,
			\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
		),
		Pmono(\fx_stutter,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\stutbus, \audio),
			\rate, ~pmodenv.(Pseq([1,0.1,1/2,4],inf), Pwhite(1,2.09,inf)),
			\time, 1/16/~t * Prand([
				1,1/2,2,1.5,4,
			],inf).stutter(4),
			\mix, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
			],inf),
			\mix, 1,
			\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
		),
		Pmono(\feedmaster,
			\inbus, BusDef(\lobus1, \audio),
			\dur, 1,
			'wet10', 1.0,
			'mix', 1.0,
			'gain', 1.0052997797722/8,
			'fb', 0.00022170302067215,
			'delay', 0.000002297970969047,
			'delay2', 0.000013111339374216,
			'delay3', 0.0000074808264552251,
			//'delay3', ~pmodenv.(Pseq([0.000011,0.2],inf), 6),
			'distamp', 0.3512751331888,
			'distamp2', 0.0195378685327,
			'distamp3', 0.2271768755705,
			'shift', 0.0,
			'shift2', 0.0,
			'shift3', -2.4789915966387,
			'shiftmix', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'ilpf', 19900,
			'ihpf', 7,
			\ipfmix, 1,
			'stereo', 0.0,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.18504562572587,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
			\addAction, \addToTail,
			\lag, 0.0004,
			\out, BusDef(\stutbus2, \audio),
		),
		Pmono(\fx_stutter,
			\addAction, \addToTail,
			\lag, 0.0005,
			\lag, 0.04,
			\inbus, BusDef(\stutbus2, \audio),
			\rate, ~pmodenv.(Pseq([1,1,1/2,4,1,2,1,1,1/2]*0.4 + 1,inf), 1),
			\gain, 2,
			\time, 1/8/~t * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,2,2, 1,1,1,1,
			],inf).stutter(1),
			\mix, Pseq([
				1,0,0,0, 1,1,0,0,
				0,0,1,0, 1,1,1,0,
			],inf)/2,
			\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
			\isRest, true,
		),
		Pmono(\fx_echo,
			\addAction, \addToTail,
			\lag, 0.0005,
			\lag, 0.04,
			\inbus, BusDef(\stutbus2, \audio),
			\rate, ~pmodenv.(Pseq([1,1,1/2,4,1,2,1,1,1/2]*0.4 + 1,inf), 1),
			\gain, 2,
			\delay, 1/8/~t * Pseq([
				Pseq([
					1
				],inf),
				1.5,1,1,1, 1,1,1,1,
				1,1,2,2, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,2,2, 2,1,1,1,
			],inf).stutter(1),
			\mix, Pseq([
				1,1,0,0, 1,1,0,0,
				0,0,1,1, 0,0,1,0,
				1,0,0,0, 1,1,0,0,
				0,0,1,0, 0,0,1,0,
				1,0,0,0, 1,1,0,0,
				0,0,1,0, 1,0,1,0,
			],inf)/2,
			\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
		),
	])
)).play;
)
