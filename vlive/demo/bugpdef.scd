// from suft68
// if the inner pdef have same name, the first notes from the previous pattern are played
// or even sometime when the name is different
~t = 172/4/60; TempoClock.default.tempo = ~t;
(
SynthDef(\fzion, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,1.2]), 1);
	env2 = EnvGen.kr(Env([1,1.5,3/4],[0.1,1.2]), 1);
	freq = freq * [1,2,2.001];
	sig = LFPulse.ar(freq  * ( SinOsc.ar(freq * env2) * 0.9 + 1 ));
	sig = RHPF.ar(sig, 4000 ,0.3);
	sig = RLPF.ar(sig, 2400* env1,0.3);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan + SinOsc.ar((1..sig.size)/10, mul:0.1);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\fzion2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1.9,2,1],[0.1,1.4]), 1);
	env2 = EnvGen.kr(Env([1.2,1.1,3/4],[0.1,1.4]), 1);
	freq = freq * [1,1.01];
	sig1 = LFCub.ar(freq*2 * env2 * ( SinOsc.ar(freq * \fmr.kr(1)) * \fmamp.kr(4.5) + 1 ));
	//sig = sig.fold2(env2 * 0.5)+( sig * 0.1 );
	sig1 = CombL.ar(sig1, 0.2,1/2100 / env2,0.1)+sig1;
	sig1 = sig1/4;
	sig1 = RHPF.ar(sig1, 800 * env1 ,0.7);
	sig1 = RLPF.ar(sig1, 1440,0.8);
	sig2 = LFCub.ar(freq * env2);
	sig2 = RHPF.ar(sig2, 300 ,0.9);
	sig2 = sig2.tanh;
	sig = [sig1, sig2].sum;
	//sig = sig1;
	sig = sig /1;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan + SinOsc.ar((1..sig.size)/10, mul:0.3);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,1, 1,0,0, 0,0,0, 0,0,0,
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 1,0,0, 0,0,0, 0,0,0,
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,1, 1,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,1,
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 12,
			\isRest, Pseq([
				0,0,0, 0,0,1, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/9,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\dur, 1/12,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 16,
			\isRest, Pseq([
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,

				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/3,
			\sustain, 0.1,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \fzion2,
			\freq, 110,
			\legato, Pseq([
				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,
				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,

				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 20,
			\speed, Pseq([
				Pseg( Pseq([ 1,1.02 ],1), 1/2),
				Pseg( Pseq([ 2,1 ],1), 1),
				Pseg( Pseq([ 1/2,2 ],1), 1/2),

				Pseg( Pseq([ 0.71,0.71 ]*2,1), 1),
				Pseg( Pseq([ 1/2,1.2 ]*2,1), 1/2),
				Pseg( Pseq([ 1.11,1.21 ],1), 1/2),
			],inf),
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 1,0,1,
				0,1,0, 1,0,1,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 1,0,0,
				1,1,0, 1,0,1,  1,0,0, 1,0,1,
				0,0,0, 0,0,0,  1,0,0, 1,0,1,
				0,1,0, 1,0,1,  0,0,0, 0,0,0,
				0,0,1, 0,0,1,  1,0,1, 1,0,0,
				0,0,0, 0,0,0,  0,0,1, 1,0,0,
			],inf).coin.not,
			\velamp, 0.7,
			\sustain, 0.2,
			\dur, 1/12 * (1 + (0.16 * Pseq([-1,0,1],inf))),
		)),
		Pbind(
			\instrument, \playersec_hlpf,
			\hpf, 1000 * Pseq([
				1,2,
			],inf),
			\hpmix, 1,
			\speed, Pseq([
				1,1.1,0.7,0.8,
			],inf),
			\bufnum, BufDef(\splah),
			\legato, Pseq([
				12,0,0, 0,0,0,  0,0,0, 12,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				12,0,0, 0,0,0,  0,0,0, 1,0,12,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\hpf, 1000 * Pseq([
				1,2,
			],inf),
			\hpmix, 1,
			\speed, Pseq([
				2,
			],inf),
			\bufnum, BufDef(\splah),
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 1,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\gain, 1,
		),
		Pbind(
			\instrument, \fzion3,
			\freq, 1210,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \fzion4,
			\note, Pseq([
				7,
			],inf).stutter(1)+[0,2],
			\freq, 1210,
			\octave, 7,
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 1,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,1, 1,0,0,
			],inf)/10,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.45) ],
			],inf),
			\dur, 1/12,
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
			'delay', 0.00010001,
			'delay2', 0.00001001,
			'delay3', 0.0000080,
			'distamp', 4.604,
			'distamp2', 2.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
		Pbind(
			\instrument, \hech,
			\legato, 1/4,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)

(
	// trap
Pdef(\part, Pdef(\zed2, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,1, 1,0,0, 0,0,0, 0,0,0,
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 1,0,0, 0,0,0, 0,0,0,

				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,1, 1,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 12,
			\isRest, Pseq([
				0,0,0, 0,0,1, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/9,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\dur, 1/12,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 16,
			\isRest, Pseq([
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,

				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/3,
			\sustain, 0.1,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \fzion,
			\freq, 400,
			\legato, Pseq([
				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,
				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,

				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \fzion4,
			\note, Pseq([
				17,0,19
			],inf).stutter(1)+[0,2],
			\octave, 6,
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 1,0,0,  0,0,1, 1,0,1,
				1,0,1, 1,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				1,0,1, 1,1,1,  1,0,1, 1,0,1,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf)/8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.05) ],
			],inf),
			\dur, 1/12,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,1,
				1,0,0, 1,0,0,  1,0,1, 1,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,1,
				1,0,0, 1,0,1,  1,0,0, 1,0,1,
				0,0,0, 0,0,0,  0,0,0, 0,0,1,
				1,0,1, 0,1,1,  1,0,0, 1,0,1,
				0,0,0, 0,0,0,  0,0,1, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.01 * Pseq([1,0.5,0.7],inf),
		),
		
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\dur, 1/8,
			'mix', 0.002,
			'gain', 1.5,
			'fb', 0.000000031,
			'delay', 0.00010001,
			'delay2', 0.40001001,
			'delay3', 0.0000080,
			'distamp', 4.604,
			'distamp2', 4.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\hpf, 1000 * Pseq([
				1,2,
			],inf),
			\hpmix, 1,
			\speed, Pseq([
				1,1.1,0.7,0.8,
			],inf),
			\bufnum, BufDef(\splah),
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 12,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 1,0,12,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\hpf, 1000 * Pseq([
				1,2,
			],inf),
			\hpmix, 1,
			\speed, Pseq([
				2,
			],inf),
			\bufnum, BufDef(\splah),
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 1,0,0,  0,0,0, 1,0,1,
				0,0,0, 0,0,1,  0,0,1, 1,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\gain, 1,
		),
		Pbind(
			\instrument, \hech,
			\legato, 1/4,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)

////////: try to dissect

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \fzion2,
			\freq, 110,
			\legato, Pseq([

				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
		),
	])
)).play;
)

(
	// trap
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \fzion,
			\freq, 400,
			\legato, Pseq([

				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
		),
		
	])
)).play;
)

Pdef(\part).clear
Pdef(\zed).clear

/////// dissect from reverse

// no bug
(
Pdef(\bla, Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 2,
	\amp, 0.1,
)).play;
)

(
Pdef(\bla, Pbind(
	\instrument, \default,
	\freq, 900,
	\dur, 2,
	\amp, 0.1,
)).play;
)

////////: try to dissect
// without the inner pdef: still bug
// with simplified score: still bug

(
Pdef(\part, 
	Ppar([
		Pbind(
			\instrument, \fzion2,
			\freq, 110,
			\legato, Pseq([
				12,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
		),
	])
).play;
)

(
	// trap
Pdef(\part, 
	Ppar([
		Pbind(
			\instrument, \fzion,
			\freq, 400,
			\legato, Pseq([

				12,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
		),
		
	])
).play;
)

////////: try to dissect
// without isRest: no bug

(
Pdef(\part, 
	Ppar([
		Pbind(
			\instrument, \fzion2,
			\freq, 110,
			\legato, 1,
			\dur, 1,
			\amp, 0.1,
		),
	])
).play;
)

(
	// trap
Pdef(\part, 
	Ppar([
		Pbind(
			\instrument, \fzion,
			\freq, 400,
			\legato, 1,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
).play;
)

////////: try to dissect
// with isRest but no legato rest: no bug

(
Pdef(\part, 
	Ppar([
		Pbind(
			\instrument, \fzion2,
			\freq, 110,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\legato, 4,
			\dur, 1/4,
			\amp, 0.1,
		),
	])
).play;
)

(
	// trap
Pdef(\part, 
	Ppar([
		Pbind(
			\instrument, \fzion,
			\freq, 400,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\legato, 4,
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
).play;
)

////////: try to dissect
// legatorest with shorter score: no bug
(
Pdef(\part, 
	Ppar([
		Pbind(
			\instrument, \fzion2,
			\freq, 110,
			\legato, Pseq([
				2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/2,
			\amp, 0.1,
		),
	])
).play;
)

(
	// trap
Pdef(\part, 
	Ppar([
		Pbind(
			\instrument, \fzion,
			\freq, 400,
			\legato, Pseq([
				2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
).play;
)

////////: try to dissect

(
Pdef(\part, 
	Ppar([
		Pbind(
			\instrument, \fzion2,
			\freq, 110,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/2,
			\amp, 0.1,
		),
	])
).play;
)

(
	// trap
Pdef(\part, 
	Ppar([
		Pbind(
			\instrument, \fzion,
			\freq, 400,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
).play;
)


Pdef.defaultQuant = 2

////////: try to dissect
// half score: no bug

(
Pdef(\part, 
	Ppar([
		Pbind(
			\instrument, \fzion2,
			\freq, 110,
			\legato, Pseq([
				6,0,0, 0,0,0, 
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/6,
			\amp, 0.1,
		),
	])
).play;
)

(
	// trap
Pdef(\part, 
	Ppar([
		Pbind(
			\instrument, \fzion,
			\freq, 400,
			\legato, Pseq([

				6,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/6,
			\amp, 0.1,
		),
		
	])
).play;
)

////////: try to dissect
// half tempo: still bug
~t = 172/4/2/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, 
	Ppar([
		Pbind(
			\instrument, \fzion2,
			\freq, 110,
			\legato, Pseq([
				12,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
		),
	])
).play;
)

(
	// trap
Pdef(\part, 
	Ppar([
		Pbind(
			\instrument, \fzion,
			\freq, 400,
			\legato, Pseq([

				12,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
		),
		
	])
).play;
)

////////: try to dissect
~t = 172/4/60; TempoClock.default.tempo = ~t; // normal tempo
// at 10 there is no bug
(
Pdef(\part, 
	Ppar([
		Pbind(
			\instrument, \fzion2,
			\freq, 110,
			\legato, Pseq([
				10,0,0, 0,0,0, 0,0,0, 0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/10,
			\amp, 0.1,
		),
	])
).play;
)

(
	// trap
Pdef(\part, 
	Ppar([
		Pbind(
			\instrument, \fzion,
			\freq, 400,
			\legato, Pseq([

				10,0,0, 0,0,0, 0,0,0, 0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/10,
			\amp, 0.1,
		),
		
	])
).play;
)

////////: try to dissect
~t = 172/4/60; TempoClock.default.tempo = ~t; // normal tempo
// at 11 there is bug

(
Pdef(\part, 
	Ppar([
		Pbind(
			\instrument, \fzion2,
			\freq, 110,
			\legato, Pseq([
				11,0,0, 0,0,0, 0,0,0, 0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/11,
			\amp, 0.1,
		),
	])
).play;
)

(
	// trap
Pdef(\part, 
	Ppar([
		Pbind(
			\instrument, \fzion,
			\freq, 400,
			\legato, Pseq([

				11,0,0, 0,0,0, 0,0,0, 0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/11,
			\amp, 0.1,
		),
		
	])
).play;
)


////////: try to dissect
Pdef.defaultQuant = 2
Pdef(\part).quant = 2
Pdef(\part).quant = nil

(
Pdef(\part, 
	Ppar([
		Pbind(
			\instrument, \fzion2,
			\freq, 110,
			\legato, Pseq([
				12,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
		),
	])
).play;
)

(
	// trap
Pdef(\part, 
	Ppar([
		Pbind(
			\instrument, \fzion,
			\freq, 400,
			\legato, Pseq([

				12,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
		),
		
	])
).play;
)


//////////////////// a better way to test: run run the same Pdef
Pdef(\part).quant = 2
Pdef(\part).quant = nil

(
Pdef(\part, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, 0,
			\legato, Pseq([
				11,0,0, 0,0,0, 0,0,0, 0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/11,
			\amp, 0.1,
		),
	])
).play;
)

///////////////// conclusion
// this is the worst bug ever existing
// defaultQuant seems to play a role, length of legato seems to play a role, \isRest seems to play a role, but sometime there is bug, sometime not
