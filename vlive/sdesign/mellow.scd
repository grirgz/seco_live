// https://www.youtube.com/watch?v=R-7O4vwCS6E
// octave + vibrato

(
SynthDef(\mellow, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * [ [1,1.01] ] * [2,1], mul:[0.45,0.76]).sum;
	sig.debug("sig");
	sig = sig * SinOsc.ar(8.4).range(1,0.7);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp).sum;
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\mellow, 
	Ppar([
		Pbind(
			\instrument, \mellow,
			\note, Pseq([
				[0,7],
				[0+12,4]+3,
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)


///////////////////////

(
SynthDef(\mellow, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0.9,1,1.01],[0.1,2.8]), 1);
	sig = SinOsc.ar(freq *env1* [ [1 / env1,1.0001 * env1] ] * [2,1], mul:[0.25,0.76]).sum;
	sig.debug("sig");
	sig = sig * SinOsc.ar(8.4).range(1,0.7);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,1,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp).sum;
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\mellow, 
	Ppar([
		Pbind(
			\instrument, \mellow,
			\note, Pseq([
				[0,7],
				[0+12,4]+3-12,
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)

////////////////////////
// add pulse and mix
(
SynthDef(\mellow, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(Env([0.9,1,1.01],[0.4,2.8],[-4]), 1);
	env2 = EnvGen.kr(Env([0,1,0],[8.1,4.8],[-2]), 1);

	sig1 = SinOsc.ar(freq *env1* [ [1 / env1,1.0001 * env1] ] * [2,1], mul:[0.25,0.76]).sum;
	
	sig2 = Pulse.ar(freq * 2 *env1* [ [1 / env1,1.0001 * env1] ] * [2,1], mul:[0.25,0.76]).sum;
	sig2 = RLPF.ar(sig2, \lpfr.kr(3.1) * freq, \rq.kr(0.5));

	sig = SelectX.ar(env2 + SinOsc.kr([1,2.1,3]*4.3).range(0,env2/2).sum, [sig1, sig2]);

	sig.debug("sig");
	sig = sig * SinOsc.ar(8.4).range(1,0.7);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,1,0.7)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp).sum;
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\mellow, 
	Ppar([
		Pbind(
			\instrument, \mellow,
			\note, Pseq([
				[0,7],
				[0+12,4]+3-12,
			],inf),
			\dur, 2,
			\amp, 0.1,
		),
	])
)).play;
)


/////////////////////


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \mellow,
			\note, Pseq([
				[0,7],
				[0+12,4]+3-12,
			],inf),
			\dur, 2,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.2714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.210000543560101,
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
		
	])
)).play;
)

//////////////

(
SynthDef(\fakerdn, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = sig = sig + Fb { arg fb;
		var isig;
		isig = ( fb * \fb.kr(1) ) + sig;

		isig = DelayL.ar(isig, 0.1,0.06323 * \delay.kr(1))+isig;
		isig = DelayL.ar(isig, 0.1,0.05322 * \delay.kr(1) * ( SinOsc.ar(\phaserfreq.kr(700)) * \phaseramp.kr(41) + 1 ))+isig;
		isig = DelayL.ar(isig, 0.1,0.04523 * \delay.kr(1))+isig;
	
		isig = Limiter.ar(isig);
		isig;
	};
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;

);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \mellow,
			\note, Pseq([
				[0,7],
				[0+12,4]+3-12,
			],inf),
			\dur, 2,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \mellow,
			\note, Pseq([
				4,3,
			],inf),
			\dur, 2,
			\octave, 6,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \fakerdn,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 1.0714285714286,
			'gain', 0.144889782792,
			'fb', 0.0002099467303085,
			\phaserfreq, Pseq([0,4*~t],inf),
			\phaseramp, Pseq([0,10],inf),
			'delay', 0.000600001231 * Pseq([
				1,10,2,
			],inf).stutter(1),
			'delay2', 0.210000543560101,
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
		
	])
)).play;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \mellowslide,
			\note, Pseq([
				4,3,
			],inf),
			\freq2, (Pkey(\note) + Pseq([-1,1],inf) + 60).midicps,
			\dur, 2,
			\octave, 6,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\mellowslide, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(Env([0.9,1,1.01],[0.4,2.8],[-4]), 1);
	env2 = EnvGen.kr(Env([0,1,0],[8.1,4.8],[-2]), 1);

	freq = SelectX.kr(Duty.kr(1/8/~t, 0, Dseq([
		0,0,0,0, 0,0,0,0,
		0,1,1,1,1,0,0,
	],inf)), [freq, \freq2.kr(0).poll]).lag2ud(0.01,0.1);

	sig1 = SinOsc.ar(freq *env1* [ [1 / env1,1.0001 * env1] ] * [2,1], mul:[0.25,0.76]).sum;
	
	sig2 = Pulse.ar(freq * 2 *env1* [ [1 / env1,1.0001 * env1] ] * [2,1], mul:[0.25,0.76]).sum;
	sig2 = RLPF.ar(sig2, \lpfr.kr(3.1) * freq, \rq.kr(0.5));

	sig = SelectX.ar(env2 + SinOsc.kr([1,2.1,3]*4.3).range(0,env2/2).sum, [sig1, sig2]);

	sig.debug("sig");
	sig = sig * SinOsc.ar(8.4).range(1,0.7);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,1,0.7)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp).sum;
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);
