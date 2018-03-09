
(
SynthDef(\simplepad, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = Formant.ar(freq* ( LFNoise1.kr(1/9!8) * 0.2 + LFNoise0.kr(1/9!8).range(0.5,1.5) ), 700 , 1000);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\fx_gverb, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = GVerb.ar(sig, roomsize:1, revtime:3);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,1.01),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \simplepad,
			\note, Pseq([
				0,2,3,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1/~t) ],
			],inf),
			\legato, 1/2,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\sendbus1),
		),
		Pmono(\fx_gverb,
			\inbus, BusDef(\sendbus1),
			\dur, 1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.400600001231 * Pseq([
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

///////////////////////////
(
SynthDef(\simplepad, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0.1,1,4]/8,[1.1,0.8]), 1);
	sig = Formant.ar(freq* ( LFNoise1.kr(1/9!8) * env1 + LFNoise0.kr(1/9!8).range(0.5,1.5) ), 700 , 1000);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\fx_gverb, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = GVerb.ar(sig, roomsize:1, revtime:3);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,1.01),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \simplepad,
			\note, Pseq([
				0,2,3,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1/~t) ],
			],inf),
			\legato, 1/2,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\sendbus1),
		),
		Pbind(
			\instrument, \simplepad,
			\note, Pseq([
				0,2,3,
			],inf),
			\octave, 6,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1/~t) ],
			],inf),
			\legato, 1/2,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\sendbus1),
		),

		Pmono(\fx_gverb,
			\inbus, BusDef(\sendbus1),
			\dur, 1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.400600001231 * Pseq([
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


