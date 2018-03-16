

(
SynthDef(\wallgrain, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, pitch_stretch=1, gdur=0.1, mbufnum=0;
	var sig;
	var gtrig = Impulse.ar(\gfreq.kr(40));
	var pos = TRand.ar(0, BufDur.kr(mbufnum), Impulse.ar(\randtrig.kr(10)));
	sig = TGrains.ar(2, gtrig, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono(\wallgrain,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\gfreq, 70,
			\randfreq, 100,
			\gdur, 0.01,
			\pitch_stretch, 4,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0001099467303085,
			'delay', 0.000000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.210000543560101,
			'distamp', 21.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 1700,
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
			\out, BusDef(\sendbus1b, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1b, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.001600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.0000543560101,
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

Pdef(\part).clear;
{ SinOsc.ar(200) ! 2 * 0.1}.play;


(
SynthDef(\layergrain, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, pitch_stretch=1, gdur=0.1, mbufnum=0;
	var sig;
	var gtrig = Impulse.ar(\gfreq.kr(40));
	var pos = TRand.ar(0!8, 1.5, Impulse.ar(\randtrig.kr(10))).lag(1.5);
	pos = pos + Rand(0.0,BufDur.kr(mbufnum));
	pos = pos + SinOsc.kr((1..8)/18).range(1,1.051);
	sig = TGrains.ar(2, gtrig, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	//sig = sig * SinOsc.kr((1..8)/8).range(0,1);
	//sig = sig * [1,0,0,0, 0,0,0,0];
	sig = sig.mean;
	sig.debug("sig");
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono(\layergrain,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
			\note, Pseq([
				0,4,7,
			],inf),
			\gfreq, Pkey(\freq),
			\randtrig, 0.200,
			\gdur, 0.05,
			\pitch_stretch, 1,
			\dur, 1,
			\amp, 0.1,
			//\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0001099467303085,
			'delay', 0.000000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.210000543560101,
			'distamp', 21.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 1700,
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
			\out, BusDef(\sendbus1b, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1b, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.001600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.0000543560101,
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


(
SynthDef(\envgrain, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, pitch_stretch=1, gdur=0.1, mbufnum=0, pos=0;
	var sig;
	var gtrig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1.02,1],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,1,1.1],[0.1,0.8]), 1);
	env3 = EnvGen.kr(Env([0,0.07,0],[2.1,2.8]), 1);
	env4 = EnvGen.kr(Env([1,2.72,1],[0.1,0.8]), 1);
	gtrig = Impulse.ar(\gfreq.kr(40) * env1);
	pos = pos + LFNoise1.ar(1/10, mul:0.001);
	sig = TGrains.ar(2, gtrig, mbufnum, pitch_stretch * env2, pos + env3 % BufDur.kr(mbufnum), gdur * env4, pan, 1);
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \envgrain,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\octave, 6,
			\pos, 2.4 + Pseq([
				0,0.001,
			],inf),
			\gfreq, Pkey(\freq),
			\randtrig, 0.200,
			\gdur, 0.01,
			\legato, 0.1,
			\pitch_stretch, 1,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \envgrain,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\legato, Pseq([
				3,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 4,
			\pos, 2.0 + Pseq([
				0,0.001,
			],inf),
			\gfreq, Pkey(\freq),
			\randtrig, 0.200,
			\gdur, 0.01,
			\pitch_stretch, 1,
			\lag, 0,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0001099467303085,
			'delay', 0.000000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.0000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
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
			\out, BusDef(\sendbus1b, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1b, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.0000543560101,
			'distamp', 1.361836201538,
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
		),
	])
)).play;
)



(
SynthDef(\envgrain2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, pitch_stretch=1, gdur=0.1, mbufnum=0, pos=0;
	var sig;
	var gtrig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1.02,1],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,1,1.1],[0.1,0.8]), 1);
	env3 = EnvGen.kr(Env([0,0.1,0],[2.1,2.8]), 1);
	env4 = EnvGen.kr(Env([1,0.72,1],[0.1,0.8]), 1);
	gtrig = Impulse.ar(\gfreq.kr(40) * env1);
	pos = pos + LFNoise1.ar(1/10, mul:0.001);
	sig = TGrains.ar(2, gtrig, mbufnum, pitch_stretch * env2, pos + env3 % BufDur.kr(mbufnum), gdur * env4, pan, 1);
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \envgrain2,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 6,
			\pos, 2.1 + Pseq([
				0,0.001,
			],inf),
			\gfreq, Pkey(\freq),
			\randtrig, 0.200,
			\gdur, 0.01,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.8) ],
			],inf),
			\legato, 0.5,
			\pitch_stretch, 1,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \envgrain,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\legato, Pseq([
				3,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 4,
			\pos, 2.0 + Pseq([
				0,0.001,
			],inf),
			\gfreq, Pkey(\freq),
			\randtrig, 0.200,
			\gdur, 0.01,
			\pitch_stretch, 1,
			\lag, 0,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0001099467303085,
			'delay', 0.000000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.0000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
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
			\out, BusDef(\sendbus1b, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1b, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.0000543560101,
			'distamp', 1.361836201538,
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
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \envgrain,
			\mbufnum, BufDef.mono('loop/loop3b_185bpm.flac'),
			\pos, 2,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 4,
			\gfreq, Pkey(\freq),
			\randtrig, 0.200,
			\gdur, 0.01,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.8) ],
			],inf),
			\legato, 0.5,
			\pitch_stretch, 1,
			\freq, 20,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
)


(
// parametrized
SynthDef(\envgrain, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, pitch_stretch=1, gdur=0.1, mbufnum=0, pos=0;
	var sig;
	var gtrig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\gfreqenv.kr(Env([1,1.02,1],[0.1,0.8])), 1);
	env2 = EnvGen.kr( \pitchenv.kr(Env([1,1,1.1],[0.1,0.8])), 1);
	env3 = EnvGen.kr( \posenv.kr(Env([0,0.1,0],[2.1,2.8])), 1);
	env4 = EnvGen.kr( \gdurenv.kr(Env([1,0.72,1],[0.1,0.8])), 1);
	gtrig = Impulse.ar(\gfreq.kr(40) * env1);
	pos = pos + LFNoise1.ar( \posrandfreq.kr(1/10), mul:\posrandamp.kr(0.001));
	sig = TGrains.ar(2, gtrig, mbufnum, pitch_stretch * env2, pos + env3 % BufDur.kr(mbufnum), gdur * env4, pan, 1);
	sig.debug("sig");
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \envgrain,
			\mbufnum, BufDef.mono('loop/loop3b_185bpm.flac'),
			\pos, 2,
			\posenv, Pseq([
				[ Env([0,0.12,0],[1.1,2.8]) ]
			],inf),
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 4,
			\freq, 100,
			\gfreq, Pkey(\freq),
			\gdur, 0.05,
			\posrandamp, 0.02,
			\posrandfreq, 100,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.8) ],
			],inf),
			\legato, 0.5,
			\pitch_stretch, 1,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.4,
			\out, BusDef(\csendbus1, \audio),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\speed, 0.6,
			\sustain, 0.3,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\csendbus1, \audio),
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,1.9) ],
			],inf),
			\dur, 1/8,
			\gain, 0.8,
			\out, BusDef(\csendbus1, \audio),
		)),
		Pbind(
			\instrument, \envgrain,
			\mbufnum, BufDef.mono('loop/loop3b_185bpm.flac'),
			\pos, 3,
			\posenv, Pseq([
				[ Env([0,0.12,0],[1.1,2.8]) ]
			],inf),
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 4,
			\freq, 100,
			\gfreq, Pkey(\freq),
			\gdur, 0.05,
			\posrandamp, 0.02,
			\posrandfreq, 100,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.48,
			\pitch_stretch, 1,
			\dur, 4,
			\gain, 4,
			\amp, 0.1,
			\out, BusDef(\bsendbus1, \audio),
		),
		Pmono(\fx_compander,
			\inbus, BusDef(\bsendbus1),
			\mix, 1,
			\sidemode, 0,
			\cpabove, 0.02,
			\cpclamp, 0,
			\pregain, 2,
			\gain, 2,
			\cpt, 0.1,
			\dur, 1,
			\out, BusDef(\csendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\csendbus1, \audio, 2),
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
		Pbind(
			\instrument, \envgrain,
			\mbufnum, BufDef.mono('loop/loop3b_185bpm.flac'),
			\pos, 0.4,
			\posenv, Pseq([
				[ Env([0,0.12,0.4],[1.1,2.8]) ]
			],inf),
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 4,
			\freq, 400,
			\gfreq, Pkey(\freq),
			\gdur, 0.05,
			\posrandamp, 0.02,
			\posrandfreq, 100,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.8) ],
			],inf),
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\legato, 0.9,
			\pitch_stretch, 1,
			\dur, 2,
			\gain, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\fx_hishelf,
			\inbus, BusDef(\sendbus1),
			\mix,1,
			\freq, 700,
			\rq, 1,
			\db, 8,
			\dur, 1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono(\chorus,
			\inbus, BusDef(\sendbus2),
			\mix,0.71,
			\modamp, 0.08,
			\fb, 1.8,
			\lpf, 19900,
			\modfreq, 0.0700,
			\diff, 0.1,
			\dur, 1,
			\out, BusDef(\csendbus1, \audio),
		),
	])
)).play;
)
