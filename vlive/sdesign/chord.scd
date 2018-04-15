
(
SynthDef(\sinchord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq * [1/2,1,2];
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,8.1,0.2,2.1,1,-1)), gate, doneAction:2);
	pan = pan + LFNoise1.ar(1/2!sig.size); 
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, Pdef(\demomo, 
	Ppar([
		Pbind(
			\instrument, \sinchord,
			\legato, 0.91,
			\note, Pseq([
				[0,1,3,7],
			],inf),
			\dur, 8,
			\amp, 0.1,
			\out, BusDef(\fx1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\fx1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.1714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101 * Pexprand(40.0,0.00001),
			'distamp', 0.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 170,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 77,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 4,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\fx1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.1714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0052099467303085,
			'delay', 0.000000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.500000543560101 * Pexprand(40.0,0.00001),
			'distamp', 7.361836201538,
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
			\dur, 4,
		),
	])
)).play;
)

///////////:

(
SynthDef(\morechord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\freqenv.kr(Env([2,1,1.1],[0.01,4.8])), 1);
	freq = freq * [1/2,1,2] * env1;
	sig1 = SinOsc.ar(freq);
	sig2 = LFSaw.ar(freq);
	sig = SelectX.ar(\mix.kr(0.5), [sig1, sig2]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * ( SinOsc.ar(freq * \ffmr.kr(1)) * 1 + 1 ), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,8.1,0.2,2.1,1,-1)), gate, doneAction:2);
	pan = pan + LFNoise1.ar(1/2!sig.size); 
	sig = Pan2.ar(sig, pan, amp).mean;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, Pdef(\demomo, 
	Ppar([
		Pbind(
			\instrument, \morechord,
			\legato, 0.91,
			\note, Pseq([
				[0,1,3,7],
			],inf),
			\dur, 8,
			\amp, 0.1,
		),
	])
)).play;
)

(
Pdef(\demo, 
	Pbind(
		\instrument, \morechord,
		\degree, Pseq([0],inf),
		\octave, 8,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\demo, 
	Pbind(
		\instrument, \morechord,
		\degree, Pseq([0],inf),
		\freqenv, [ Env([1,2,1],[0.1,0.8]) ],
		\adsr, Pseq([
			[ Env.adsr(0.1,0.1,0.8,0.1) ],
		],inf),
		\octave, 8,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
SynthDef(\morechord2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var freqs, decays;
	env1 = EnvGen.kr(\freqenv.kr(Env([2,1,1.1],[0.01,4.8])), 1);
	env2 = EnvGen.kr(\lpenv.kr(Env([2,1,1.1],[0.01,4.8])), 1);
	freq = freq * [1/2,1,2] * env1;
	sig1 = SinOsc.ar(freq);
	sig2 = LFSaw.ar(freq);
	sig = SelectX.ar( LFNoise1.kr(1).range(0,1), [sig1, sig2]);
	freqs  = \ringfreqtab.kr({exprand(300, 20000)}.dup(10));
	decays  = \ringdecaytab.kr({exprand(0.03, 1)}.dup(10));
	sig = Ringz.ar([ sig], freqs, decays).mean/10;
	pan = pan + LFNoise1.ar(1/2!sig.size); 
	sig = RLPF.ar(sig, env2 * \lpfr.kr(1.1) * freq * ( SinOsc.ar(freq * \ffmr.kr(1)) * 1 + 1 ), \rq.kr(0.5));
	sig = sig /2;
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,8.1,0.2,2.1,1,-1)), gate, doneAction:2);
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, Pdef(\demomo, 
	Ppar([
		Pbind(
			\instrument, \morechord2,
			\freqenv, [ Env([2,1,0.91],[0.1,8.8]) ],
			\lpenv, [ Env([2,1,3.91],[0.1,8.8]) ],
			\adsr, Pseq([
				[ Env.adsr(0.01,0.08,0.8,8.1/~t) ],
			],inf),
			\ffmr, 1/4,
			\ringfreqtab, Prout({ arg ev;
					var freqs;
				   	freqs = {exprand(300, 20000)}.dup(10);
					inf.do {
						freqs = freqs + {exprand(300, 20000)}.dup(10)/2;
						ev = freqs.yield;
					};
			}),
			\ringdecaytab, Prout({ arg ev;
					var freqs;
				   	freqs = {exprand(0.03, 1.8)}.dup(10);
					inf.do {
						freqs = freqs + {exprand(0.03, 1.8)}.dup(10)/2;
						ev = freqs.yield;
					};
			}),
			\sustain, 1,
			\legato, 0.91,
			\note, Pseq([
				[0,1,3,7],
			],inf),
			\octave, 6,
			\dur, 8,
			\amp, 0.1,
		),
	])
)).play;
)

///////////:
// filter fm
// le baba des des chords c'est plusieurs vois detunés et a l'octave
// fm sur le filter rend le son sale
// strum to easily make it more spaced
// big attack to make it more cloudy

(
SynthDef(\filterfm, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var xfreq = freq * [1,1.01,1.001,2,1/2];
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env2 = EnvGen.kr(\fmampenv.kr(Env([1,0.2,4],[0.1,2.8])), 1);
	xfreq = xfreq * ( SinOsc.ar(freq * \fmr.kr(1)) * \fmamp.kr(1) * env2 + 1 );
	env1 = EnvGen.kr(\rqenv.kr(Env([1,0.2,1],[0.1,2.8])), 1);
	sig1 = LFSaw.ar(xfreq);
	sig2 = LFPulse.ar(xfreq);
	sig3 = SinOsc.ar(xfreq);
	sig = SelectX.ar( LFNoise1.kr(1!8).range(0,2), [sig1, sig2, sig3]);
	//sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * ( SinOsc.ar(freq * \lpfmr.kr(1)) * \lpfmamp.kr(1) + 1 ), \rq.kr(0.5) * env1);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq , \rq.kr(0.5) * env1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan + LFNoise1.kr(1/8!8);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, 
	Pbind(
		\instrument, \filterfm,
		\note, Pseq([
			[0,3,7],
			[-1,3,7],
			[-1,4,8],
			[-1,3,8],
		],inf) + Ptuple(Prand([12,0,-12],inf)!3),
		\adsr, Pseq([
			[ Env.adsr(2.1,0.1,0.8,1.1) ],
		],inf),
		\fmamp, 2.1,
		\fmr, 1.002,
		\octave, 5,
		\strum, Pwhite(0,0.1),
		\lpfmamp, Pwhite(0.0,0.32),
		\rq, 0.5,
		\lpfr, 2,
		\lpfmr, 1,
		\dur, 1,
		\amp, 0.1,
	),
).play;
)


/////////////////////////////////

(
SynthDef(\filterfm, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var xfreq = freq * [1,1.01,1.001,2,1/2];
	var xfreq1, xfreq2;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env2 = EnvGen.kr(\fmampenv.kr(Env([0,1.02,0,4],[0.1,1,2.8])), 1);
	env3 = EnvGen.kr(\fmmixenv.kr(Env([1,0,1],[0.1,2.8])), 1);
	env4 = EnvGen.kr(\xfreqenv.kr(Env([4,4,0.1],[0.1,4.8])), 1);
	xfreq1 = xfreq * ( SinOsc.ar(freq * \fmr.kr(1)) * \fmamp.kr(1) * env2 + 1 );
	xfreq2 = xfreq * ( SinOsc.ar(freq * \fmr2.kr(1.0123)) * \fmamp.kr(1) * env2 + 1 );
	xfreq = [xfreq1, xfreq2];
	//xfreq = xfreq1;
	env1 = EnvGen.kr(\rqenv.kr(Env([1,0.2,1],[0.1,2.8])), 1);
	sig1 = LFSaw.ar(xfreq);
	sig2 = LFPulse.ar(xfreq);
	sig3 = SinOsc.ar(xfreq);
	sig4 = [sig1, sig2, sig3].collect({ arg isig;
		isig.debug("isig");
		isig = SelectX.ar( env3, isig );
		isig = isig.fold2(env4)/env4*1.72;
		isig/2;
	});
	sig = SelectX.ar( LFNoise1.kr(1!8).range(0,2), sig4);
	sig.debug("sig").shape.debug("shape");
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq , \rq.kr(0.5) * env1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan + LFNoise1.kr(1/8!8, mul: XLine.kr(0.5,1,1));
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, 
	Pbind(
		\instrument, \filterfm,
		\note, Pseq([
			[0,4,7],
			[0,4,8],
			[0,4,7]+5,
			[0,3,7]+5,
		],inf).stutter(4) + Ptuple(Prand([12,0,-12],inf)!3),
		\adsr, Pseq([
			[ Env.adsr(2.1,0.1,0.8,2.1) ],
		],inf),
		\fmamp, 2.1,
		\fmr, 1,
		\octave, 5,
		\strum, Pwhite(0,1.1),
		\lpfmamp, Pwhite(0.0,0.32),
		\rq, 0.5,
		\lpfr, 2,
		\lpfmr, 1,
		\legato, 1.1,
		\dur, 1,
		\amp, 0.1/3,
	),
).play;
)

(
Pdef(\demo, 
	Pbind(
		\instrument, \filterfm,
		\note, Pseq([
			[0,4,7],
			[0,4,8],
			[0,4,7]+5,
			[0,3,7]+5,
		],inf).stutter(1) + Ptuple(Prand([12,0,-12],inf)!3),
		\adsr, Pseq([
			[ Env.adsr(2.1,0.1,0.8,1.1) ],
		],inf),
		\fmamp, 2.1,
		\fmr, 1,
		\octave, 5,
		\strum, Pwhite(0,0.2),
		\lpfmamp, Pwhite(0.0,0.32),
		\rq, 0.5,
		\lpfr, 2,
		\lpfmr, 1,
		\legato, 1.1,
		\dur, 1,
		\amp, 0.1/3,
	),
).play;
)

(
Pdef(\demo, 
	Pbind(
		\instrument, \filterfm,
		\note, Pseq([
			[0,1,2],
			[0,1,2]+2,
			[0,-1,2]+2,
		],inf).stutter(1) + Ptuple(Prand([12,0,-12],inf)!3),
		\adsr, Pseq([
			[ Env.adsr(2.1,0.1,0.8,1.1) ],
		],inf),
		\fmamp, 2.1,
		\fmr, 1,
		\octave, 5,
		\strum, Pwhite(0,0.2),
		\lpfmamp, Pwhite(0.0,0.32),
		\rq, 0.5,
		\lpfr, 2,
		\lpfmr, 1,
		\legato, 1.1,
		\dur, 1,
		\amp, 0.1/3,
	),
).play;
)


////////////////////////::
