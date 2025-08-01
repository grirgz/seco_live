(
SynthDef(\bilin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * [1,2,1/2] * (\bilintab.kr({ 1.0.bilinrand }!100) * \fspread.kr(0.01) + 1);
	sig = sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(\oscmix.kr(0.5)*2, [sig1, sig2, sig3]);
	//sig = LFSaw.ar(freq * [1,2,1/2] * ({ 1.0.bilinrand }!100 * 0.01 + 1)).clump(2).mean;
	sig = sig.clump(2).mean;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}, metadata:(specs:(
	oscmix: \unipolar,
	fspread: ControlSpec(0.001,0.2,\exp),
))).add;
);


(
Pdef(\demo, Pdef(\demox, 
	Ppar([
		Pbind(
			\instrument, \bilin,
			\note, Pseq([
				[0,3,7],
				[0,3,7]+4,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

///////////////////////

(
SynthDef(\chordb, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffac=8;
	var sig, sig1, sig2, sig3;
	sig = {arg x; 
		var isig;
		//var ffac = 8;
		isig = LFSaw.ar( freq/2 * x + ExpRand(freq/64,2*freq/64));
		isig = isig + LFPulse.ar( freq/ffac * x + ExpRand(freq/64/ffac,2*freq/64/ffac));

		isig = RLPF.ar(isig, freq/2 * x + ExpRand(freq/64,2*freq/64)* LFNoise1.kr(1/4).range(1.1,1) * \lpffac.kr(2) , \rq.kr(0.5));
	}!5;
	sig = sig.scramble;
	sig = TScramble.ar(sig, Impulse.kr(4),1);
	//sig = FreqShift.ar(sig, 4 * SinOsc.kr(1/45).range(0,1)) + sig;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan) / 5;
	Out.ar(out, sig);
}).add;
);

Pdef(\chordb, Pbind(
	//\freq, 100,
	\instrument, \chordb,
	\degree, Pseq([
		Prand([0,1,4,0]),
		Prand([0,1,4,0])+8,
	],inf) + Ptuple([0,Pseq([3,5],inf)]),
	\freq, (60 * Pseq([
		Prand([
			0,3,[0,4,7]
		],4) + Pseq([
			0,12
		]).stutter(4),
		Prand([
			7,10,[7,10]
		],4) + Pseq([
			0,12
		]).stutter(4),
		Prand([
			5,9,7
		],4) + Pseq([
			0,12
		]).stutter(4),
	],inf).midiratio * 16) * Prand([1,1/2,1/4,1],inf).stutter(1),
	//\lag, Ptuple([0,
	//	Prand([
	//		1/~t,
	//		1/2/~t,
	//		1/4/~t,
	//		0,
	//	])
	//],inf),
	//\scale, [1,2.5,7.3,5,7],
	\scale, Scale.minor,
	\octave, 4,
	\dur, 2,
	\legato, 3.5,
	\isRest, false,
)).play;

//////////////////////////////////////////////



~t = 60/60; TempoClock.default.tempo = ~t;
(
~buf = BufDef(\moeten, "voices/02_moeten.flac");
Ndef(\lfo1).quant = Pdef.defaultQuant;

Ndef(\lfo1, { arg freq=1; SinOsc.kr(freq * ~t).range(50,7500).lag(0.051)});
Ndef(\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([1,1,16,1,1,8,1,1],inf),
	\dur, 1/1,
));

Pdef(\chord, 
	Pmono(\oscsampler3,
		\finepos, Pseq([0,0,0.0004,0.01004],inf) + Pseq([0,0.1,0.20,0.25],inf).stutter(8),
		\fineposlag, 0.4,
		\pos, 0.2,
		\freq, 60 * Pseq([
			[0,3,8],
			[0,3,7],
		],inf).midiratio.stutter(4) * 4,
		\ffreq, Ndef(\lfo1),
		\isRest, false,
		\bufnum, ~buf,
		\ffreqtab, Pseq([[Array.geom(8,1.0,1.01).postln]],inf),
		\range, 0.0001,
		\posenv, Pseq([
			[ Env([0.00,0.014,0.0].integrate.postln,[0.42,8.4]) ],
		],inf),
		\dur, 1,
	) 
).play
);


(
~t = 60/60; TempoClock.default.tempo = ~t;
~buf = BufDef(\moeten, "voices/02_moeten.flac");
Ndef(\lfo1).quant = Pdef.defaultQuant;

Ndef(\lfo1, { XLine.kr(1,1140,16/~t) });


Pdef(\chord, 
	Pmono(\oscsampler3,

		\finepos, Pseq([0,0,0.0004,0.01004],inf) + Pseq([0,0.1,0.20,0.25],inf).stutter(8),
		\finepos, Pseq([0],inf),
		\fineposlag, 0.4,
		\pos, 0.2,
		//\freq, Ndef(~name+++\lfo3).bus.asMap,
		\freq, 60 * Pseq([
			[0,3,8],
			[0,3,7],
		],inf).midiratio.stutter(4) * 4,
		\isRest, false,
	\bufnum, ~buf,
	\ffreqtab, Pseq([[Array.geom(8,1.0,1.01).postln]],inf),
	\range, 0.0001,
	\posenv, Pseq([
		[ Env([0.00,0.014,0.0].integrate.postln,[1.42,0.4]) ],
	],inf),
	\dur, 1,

		\ffreq, Ndef(\lfo1),
	) 
).play
);

/////////////////
// laminated chord

(
	// problem: more than stereo
Ndef(\chord, { arg freq=800, pan=0, amp=0.1;
	var sig;
	freq = freq * [0,8,15].midiratio;
	freq = freq *.x [1,1/2,2];
	sig = SinOsc.ar(freq);
	sig = sig.fold2( SinOsc.kr(1/7 * [1,2,3]).range(0,1) );
	sig = sig.wrap2( SinOsc.kr(1/6 * [1,2,3]).range(0,1) );
	sig = Resonz.ar(sig, SinOsc.kr(1/9 * [1,2,3]).range(100,7000), 0.5);
	sig.debug("sig");
	sig = Pan2.ar(sig, pan, amp).flop;
	sig.debug("sig");
}).play;
);

(
Ndef(\chord, { arg freq=800, pan=0, amp=0.1;
	var sig;
	freq = freq * [0,4,7].midiratio;
	freq = freq *.x [1,1/2,2];
	sig = SinOsc.ar(freq);
	sig = sig.fold2( SinOsc.kr(1/7 * [1,2,3]).range(0,1) );
	sig = sig.wrap2( SinOsc.kr(1/6 * [1,2,3]).range(0,1) );
	sig = Resonz.ar(sig, SinOsc.kr(1/9 * [1,2,3]).range(100,7000), 0.5);
	sig.debug("sig");
	sig = Splay.ar(sig, 1, amp, pan);
	sig.debug("sig");
}).play;
);

(
Ndef(\chord, { arg freq=800, pan=0, amp=0.1;
	var sig;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		1,0,4,3,
	],inf)).midiratio;
	freq = freq * [0,4,7].midiratio;
	freq = freq *.x [1,1/2,2];
	sig = SinOsc.ar(freq);
	sig.debug("sig");
	sig = sig.fold2( SinOsc.kr(1/7 * [1,2,3]).range(0,1) );
	sig = sig.wrap2( SinOsc.kr(1/6 * [1,2,3]).range(0,1) );
	sig = sig + DelayL.ar(sig, 0.5, SinOsc.kr((1..9)/170,(1..9)).range(0.001,0.5) );
	sig = Resonz.ar(sig, SinOsc.kr(1/9 * [1,2,3]).range(100,7000), 0.5);
	sig.debug("sig");
	sig = Splay.ar(sig, 1, amp, pan);
	sig.debug("sig");
}).play;
);

///////////////////
(
SynthDef(\tredrone, { arg lagf=0, freq=200, pan=0, amp=0.1, out=0, gate=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(lagf);
	freq = freq * [1, 5/3];
	sig = LFPulse.ar(freq * ( 1 + ( CuspL.ar(\cusfreq.kr(10) + [1,2,3],\cus2.kr(1.1),\cus3.kr(1)).lag(0.1) * ( CuspL.ar(0.1)/3 + 0.1+[ [0,0.01] ] ) * \fma.kr(1) ))).mean;
	sig.debug("kjkj");
	sig = sig /13;
	sig1 = sig;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq.lag(1) * SinOsc.kr(1*~t * [1,3/5]).range(0,1), \rq.kr(0.5));
	sig = sig + BPF.ar(sig1, freq.lag(1) * 8);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
(
Pdef(\demo, PmonoArtic(\tredrone,
	\legato, 1,
	\cus3, { rrand(0.01,10) }.dup(3),
	\fma, 0.01,
	\cus2, [1,2,3]*10,
	\cusfreq, [1,2,3]/3,
	\lpfr, 2,
	\lagf, Pseq([1,0,0,1]/2,inf).stutter(8),
	\octave, 6,
	\degree, Pseq([
		[0,2,4],
		[0,2,4]+2,
		[0,2,4],
		[0,2,4]+2-12,
		[0,2,4],
		[0,2,4]+2,
		[0,2,4],
		[-20,-20,-20],
	],inf).stutter(8),
	\dur, 1,
	\amp, 0.4
)).play;
);
);

////////////////////////////////////
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
				[0,1,3,7]+4,
			],inf),
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
)


////////////////////////////

// sum of a list of oscillators with special tricks on each (fm, filter, shaping, ..)


SynthDef(\chordo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.2,1],[0.1,0.8]), 1);
	env2 = SinOsc.ar(8/1.5*~t * ( SinOsc.kr(1*~t,Rand(0,2)) * 1 + 1 )).range(0.1,1);
	sig1 = SinOsc.ar(freq* [1,1.0001,1/2,1/4] * [0,4,7].midiratio/4)* EnvGen.kr(Env([0,0.41,0],[0.01,0.2]), 1);
	sig2 = SinOsc.ar(freq/2 * [1,2,1/2] * 4.midiratio).fold(env1) * 0.4;
	sig3 = LFSaw.ar(freq * [1,1.01,1.006,1/2,1/4] * 7.midiratio) * EnvGen.kr(Env([0,0.51,0],[1.1,2.8], 4), 1);
	sig3 = RLPF.ar(sig3, \lpfr.kr(2.1) * EnvGen.kr(Env([1,1/2,2,1],[2,2.1,2.8]), 1) * freq, \rq.kr(0.5));
	sig4 = SinOsc.ar(freq * [3/4,5/4]) * EnvGen.kr(Env([0,0.41,0],[0.01,0.2]), 1);
	sig5 = SinOsc.ar(freq+0.1 * [0+12,4,7,7-12,4-24].midiratio/2 * ( LFSaw.ar(freq/2) * 0.4 + 1 )) * EnvGen.kr(Env([0,0.41,0],[0.1,1.5]), 1);
	sig6 = SinOsc.ar(freq*1.001 * [1,1/2,2,1/8]  * ( SinOsc.ar(freq* [0+12,4,7,7-12].midiratio/2) * 1.4 + 1 )) * EnvGen.kr(Env([0,0,0.41,0],[0.3,0.8,6.5]), 1);
	sig6 = HPF.ar(sig6, 1000 * EnvGen.kr(Env([1,2,1],[4.1,0.8]), 1)) + BPF.ar(sig6, 70);
	sig = sig1 + sig2 + sig3 + sig4 + sig5 + sig6;
	sig = RLPF.ar(sig, env2 * \lpf.kr(1000), 0.5 / (1+ env2 ));
	sig = AllpassL.ar(sig, 0.4,0.01 * [1,0.6,0.7,1.1],4.5) + ( sig * 2 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,5.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

(
Pdef(\demo, Pdef(\xdemo, 
	Ppar([
		Pbind(
			\instrument, \chordo,
			\note, Pseq([
				[0,4,7],
				[0,4,7]+4,
			],inf),
			\octave, 7,
			\lpf, 7000,
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
)


////////////////////
// basic pad : sin + (saw with delayed filter env)
// widening by detune

(
SynthDef(\basicpad, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env([1,2,1],[4.1,0.8])), 1);
	sig1 = SinOsc.ar(freq * [1,1+\det.kr(0.00001)]);
	sig2 = LFSaw.ar(freq * [1,1+\det.kr]);
	sig2 = sig2 * EnvGen.kr(\sawenv.kr(Env([0,1,0],[1.1,1.8])), 1);
	sig2 = LPF.ar(sig2, \lpf.kr(8000) * env1);
	sig = [sig1, sig2].sum / 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [1,-1], amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, Pdef(\xdemo, 
	Ppar([
		Pbind(
			\instrument, \basicpad,
			\note, Pseq([
				[0,4,7],
				[0,4,7]+4,
			],inf),
			\lpf, 1000,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)


////////

(
SynthDef(\basicpadfm, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env([1,2,1],[4.1,4.8])), 1);
	env2 = EnvGen.kr(\fmenv.kr(Env([0,2,1],[4.1,4.8])), 1);
	sig1 = SinOsc.ar(freq * [1,1+\det.kr(0.00001)] * ( SinOsc.ar(freq*[2,1/2,1+\det.kr]).sum * env2 + 1 ));
	sig2 = LFSaw.ar(freq * [1,1+\det.kr]);
	sig2 = sig2 * EnvGen.kr(\sawenv.kr(Env([0,1,0],[1.1,1.8])), 1);
	sig2 = LPF.ar(sig2, \lpf.kr(8000) * env1);
	sig2 = sig2 * 1;
	sig = SelectX.ar(\oscmix.kr(0.5), [sig1, sig2]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [1,-1], amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, Pdef(\xdemo, 
	Ppar([
		Pbind(
			\instrument, \basicpadfm,
			\det, ~pmodenv.(Pseq([0.00001,0.02,0.0001,0.04],inf), 8),
			\note, Pseq([
				[0,4,7],
				[0,4,7]+4,
			],inf),
			\oscmix, ~pmodenv.(Pseq([0,1,0.51,0.74],inf), 8),
			\lpf, 1000,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)

////////////

(
SynthDef(\stepchord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = Duty.kr(1/4/~t, 0, Dseq([
		1,2,4,3/2,
	],inf));
	lfo2 = Duty.kr(1/3/~t, 0, Dseq([
		1,2,4,3/2,
	],inf));
	freq = freq * [1/2,1,lfo2, lfo1];
	sig1 = SinOsc.ar(freq);
	sig2 = LFSaw.ar(freq);
	sig2 = BPF.ar(sig2, freq * SinOsc.kr(1/2).range(0.5,2), 0.5 * SinOsc.kr(1/13).range(1.4,1/4));
	sig3 = SinOsc.ar(freq * ( SinOsc.ar(freq) * 1 + 1 ));
	sig3 = BPF.ar(sig3, freq * SinOsc.kr(1/3).range(0.5,2), 0.5 * SinOsc.kr(1/7).range(1.4,1/4));

	sig = [sig1,sig2, sig3].mean;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,8.1,0.2,2.1,1,-1)), gate, doneAction:2);
	pan = pan + LFNoise1.ar(1/2!sig.size); 
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part1, Pdef(\demomo, 
	Ppar([
		Pbind(
			\instrument, \stepchord,
			\legato, 0.91,
			\note, Pseq([
				[0,1,3,7],
				[4,7,9,12],
			],inf),
			\dur, 2,
			\amp, 0.1,
		),
	])
)).play;
)

////////////////

(
SynthDef(\wavechord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	lfo1 = Duty.kr(1/~t * LFNoise1.kr(1/3).range(0.001,4), 0, Dseq([
		1,0,1.5,0.5,0,2,
	],inf)).lag(0.051);
	lfo2 = Duty.kr(1/~t * LFNoise1.kr(1/3).range(0.001,4), 0, Dseq([
		1,0,1.5,0.5,0,2,
	],inf)).lag(0.051);
	env1 = EnvGen.kr(Env([1,2,0.71],[Rand(0.1,0.7),Rand(0.4,1.7)]), 1);
	env2 = EnvGen.kr(Env([1,2,0.71],[Rand(0.1,0.7),Rand(0.4,1.7)]), 1);
	sig1 = SinOsc.ar(freq * [1/2,1,2]) * LFNoise1.kr(1/7!3).range(0,1);
	sig1 = sig1.mean;
	sig2 = LFSaw.ar(freq * [1/2,1,2]) * LFNoise1.kr(1/8!3).range(0,1);
	sig2 = sig2.mean;
	sig2 = RLPF.ar(sig2, \lpfr.kr(1.1) * env1 * freq, \rq.kr(0.5));
	sig3 = LFPulse.ar(freq * [1/2,1,2]) * LFNoise1.kr(1/9!3).range(0,1);
	sig3 = sig3.mean;
	sig3 = RLPF.ar(sig3, \lpfr.kr(1.1) * env2 * freq, \rq.kr(0.5));
	sig = SelectX.ar( lfo1, [sig1, sig2, sig3] ) * 1;
	sig = [sig, SelectX.ar( lfo2, [sig1, sig2, sig3] ) * 1];
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.4)), gate, doneAction:2);
	sig = sig * amp * 1.31;

	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\wavechord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	lfo1 = Duty.kr(1/8/~t * LFNoise1.kr(1/3).range(0.001,4), 0, Dseq([
		1,0,1.5,0.5,0,2,
	],inf)).lag(0.251);
	lfo2 = Duty.kr(1/8/~t * LFNoise1.kr(1/3).range(0.001,4), 0, Dseq([
		1,0,1.5,0.5,0,2,
	],inf)).lag(0.251);
	env1 = EnvGen.kr(Env([1,2,0.71],[Rand(0.1,0.7),Rand(0.4,1.7)]), 1);
	env2 = EnvGen.kr(Env([1,2,0.71],[Rand(0.1,0.7),Rand(0.4,1.7)]), 1);
	sig1 = SinOsc.ar(freq * [1/2,1,2]) * LFNoise1.kr(1/7!3).range(0,1);
	sig1 = sig1.mean;
	sig2 = LFSaw.ar(freq * [1/2,1,2]) * LFNoise1.kr(1/8!3).range(0,1);
	sig2 = sig2.mean;
	sig2 = RLPF.ar(sig2, \lpfr.kr(1.1) * env1 * freq, \rq.kr(0.5));
	sig3 = LFPulse.ar(freq * [1/2,1,2]) * LFNoise1.kr(1/9!3).range(0,1);
	sig3 = sig3.mean;
	sig3 = RLPF.ar(sig3, \lpfr.kr(1.1) * env2 * freq, \rq.kr(0.5));
	sig = SelectX.ar( lfo1, [sig1, sig2, sig3] ) * 1;
	sig = [sig, SelectX.ar( lfo2, [sig1, sig2, sig3] ) * 1];
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.4)), gate, doneAction:2);
	sig = sig * amp ;

	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \wavechord,
			\note, Pseq([
				[0,4,7,12],
				[0,4,7,11]+3,
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \wavechord,
			\note, Pseq([
				[0,4,7,12],
				[0,4,7,11]+3,
			],inf),
			\dur, 4,
			\strum, 0.2,
			\amp, 0.1,
		),
	])
)).play;
)
//////////////
(
SynthDef(\accordeon, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	env1 = EnvGen.kr(Env([0,1,2],[0.01,0.8]), 1);
	lfo1 = Duty.kr(1/8/~t * LFNoise1.kr(1/2).range(0.1,2.0), 0, Dseq([
		0,7-12,3,7,
	],inf)).midiratio;
	sig = SinOsc.ar(freq * lfo1);
	sig = CombL.ar(sig, 1/freq, 1/freq * 1) + sig;
	sig = (sig * 1).tanh;
	sig = sig * 0.9;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \accordeon,
			\note, Pseq([
				[0,3,7],
				[11,3,7]-4,
			],inf) ,
			\dur, 1,
			\amp, 0.1/4,
		),
	])
)).play;
);

///////////////////////

(
SynthDef(\serenity, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * \ratio.kr([0,4,7].midiratio) * [1/2,1,2];
	sig1 = SinOsc.kr((1..9)/10).range(0,1);
	sig2 = SinOsc.kr((1..9)/20).range(0,1);
	sig = SinOsc.ar(freq) * SinOsc.ar(freq+sig2, SinOsc.ar(freq+2+sig1), 1, SinOsc.ar(freq+2+sig2) );
	pan = LFNoise1.kr((1..9)/75).range(-1,1);
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \serenity,
		\degree, Pseq([0,3,2,1],inf),
		\ratio, Pseq([
			[[0,4,7]],
			[[0,3,7]],
		],inf).midiratio,
		\adsr, Pseq([
			[ Env.adsr(0.1,0.1,0.8,1.8) ],
		],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);


////////////////////////


(
SynthDef(\bouly, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env2 = EnvGen.ar(\env2.kr(Env([0,1,0],[1.001,1.08])), Impulse.ar(\imp2f.kr(1/4)));
	env1 = EnvGen.ar(\env1.kr(Env([0,1,0],[0.001,0.08])), Impulse.ar(\imp1f.kr(100) * env2));
	sig = SinOsc.ar(freq) * env1;
	sig = RLPF.ar(sig, \lpfr.kr(5.1) * freq * (env2 * 0.5 +1), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\boulyharm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var fratio;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env2 = EnvGen.ar(\env2.kr(Env([0,1,0],[1.001,1.08])), Impulse.ar(\imp2f.kr(1/4)));
	env1 = EnvGen.ar(\env1.kr(Env([0,1,0],[0.001,0.08])), Impulse.ar(\imp1f.kr(100) * env2));
	fratio = freq/2 * [1,2,3,4,5,6];
	sig = (SinOsc.ar(fratio) * [0.51,1,0.2, 0.61,0.1,0.3] * 0.8).mean * env1;
	sig = RLPF.ar(sig, \lpfr.kr(5.1) * freq * (env2 * 0.5 +1), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
FileSystemProject.loadOnce("libdef/macros.scd");
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, Prand([\bouly, \boulyharm],inf),
			\env1, Pseq([
				[ Env([0,1,0],[0.001,0.08]) ],
			],inf),
			\env2, Pseq([
				Ptuple(~pEnv.(Pwhite(0.0,1,inf)!3,Pwhite(0.001,2))!4),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(1.1,0.1,0.8,3.1) ],
			],inf),
			\note, Pseq([
				[0,7,3+12,11],
				[0,3,9,11],
				[0,3,9,11]+2,
				[0+12,7,9,11]+2,
			],inf),
			\lpfr, ~pmodenv.(Pwhite(0.61,4,inf), Pwhite(0.4,6.0)),
			\imp1f, Ptuple(Pwhite(1,100.0,inf)!4),
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);

Pdef(\part).clear;


/////////////////////////////////////



(
SynthDef(\plucky, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:0);
	//sig = Decay.ar(WhiteNoise.ar, 0.1);
	sig = Pluck.ar(WhiteNoise.ar, 1, 100.reciprocal, freq.reciprocal, \decay.kr(1));
	sig = sig + (sig.tanh * \distamp.kr(1));
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * (env1 * \envfamt.kr(1) + 1), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\pluckym, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var xfreq = freq * ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1);
	env1 = EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:0);
	//sig = Decay.ar(WhiteNoise.ar, 0.1);
	sig = Pluck.ar(WhiteNoise.ar, 1, 100.reciprocal, xfreq.reciprocal, \decay.kr(1));
	sig = sig + (sig.tanh * \distamp.kr(1));
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * (env1 * \envfamt.kr(1) + 1) ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, Pdef(\demozed, 
	Ppar([
		Pbind(
			\instrument, \plucky,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,1,
			],inf).coin.not,
			\legato, 2,
			\envfamt, 5,
			\env1, Pseq([
				[ Env.adsr(0.1,0.351,0.3,0.4) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.051,0.8,0.4) ],
			],inf),
			\decay, 4,
			\note, Pseq([
				Pseq([
					[0,7,12,15],
				],8+6),
				[0,7,12,14],
				[0,7,12,14],

				[3,7,10,14],
				Pseq([
					[3,7,10,15],
				],8+6),
				[3,7,10,14],

				Pseq([
					[-4, 3,8,10],
					Pseq([
						[-4, 3,8,10, 12],
					],8+6),
					[-4, 3,8,10],
				],2),
			],inf),
			\dur, 1/16,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\demo, Pdef(\demozed, 
	Ppar([
		Pbind(
			\instrument, \pluckym,
			\fspread, 0.001 * Pseg(Pseq([1,10],inf),8),
			\legato, 0.2,
			\legato, Pseq([
				Pswitch1(
					[
						Pseg(Pseq([0.01,1],inf),9),
						Pseg(Pseq([0.01,0.2],inf),7),
						Pseg(Pseq([1,0.01],inf),10),
						Pseg(Pseq([0.01,1],inf),11),
						Pseg(Pseq([0,0.2],inf),12),
						Pseg(Pseq([1,0.01],inf),13),
					], 
					Pseq([0,1,2,3,4,5],inf)
				),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0.05 }),
			\envfamt, Pswitch1(
					[
						Pseg(Pseq([0.01,1],inf),8.3),
						Pseg(Pseq([0,0.2],inf),6.1),
						Pseg(Pseq([1,0.01],inf),9.2),
						Pseg(Pseq([0.01,1],inf),9.1),
						Pseg(Pseq([0,0.2],inf),8.1),
						Pseg(Pseq([1,0.01],inf),10.1),
					]* 5 , 
					Pseq([0,1,2,3,4,5],inf)
			),
			\lpfr, ~pmodenv.(Pseq([1/4,2,1,1.4],inf), 8),
			\env1, Pseq([
				[ Env.adsr(0.1,0.351,0.3,0.4) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.081,0.051,0.8,0.4) ],
			],inf),
			\decay, Pswitch1(
				[
					Pseg(Pseq([1/4,4],inf),6),
					Pseg(Pseq([1/4,2],inf),7),
					Pseg(Pseq([2,1/4],inf),9),
					Pseg(Pseq([1/8,4],inf),10),
					Pseg(Pseq([1/8,2],inf),11),
					Pseg(Pseq([2,1/8],inf),12),
				], 
				Pseq([0,1,2,3,4,5],inf)
			),
			\note, Pseq([
				Pseq([
					[0,7,12,15],
				],12+9),
				[0,7,12,14],
				[0,7,12,14],
				[0,7,12,14],

				[3,7,10,14],
				[3,7,10,14],
				[3,7,10,14],
				Pseq([
					[3,7,10,15],
				],12+6),
				[3,7,10,14],
				[3,7,10,14],
				[3,7,10,14],

				Pseq([
					[-4, 3,8,10],
					[-4, 3,8,10],
					[-4, 3,8,10],
					Pseq([
						[-4, 3,8,10, 12],
					],12+6),
					[-4, 3,8,10],
					[-4, 3,8,10],
					[-4, 3,8,10],
				],2),
			],inf),
			\dur, 1/12,
			\amp, 0.1,
		),
		
	])
)).play;
);


////////

// Use latch to generate lfo patterns that are cyclic-like but with natural variation

(
SynthDef(\latchsaw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, noisefreq=0.1, noiseamp=0.01;
	var sig;
	sig = LFSaw.ar(freq * [1* LFNoise1.ar(noisefreq,mul:noiseamp,add:1),1/2 * LFNoise1.ar(noisefreq,mul:noiseamp,add:1),LFNoise1.ar(noisefreq,mul:noiseamp,add:1) ]).mean;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * ( 
		Latch.ar( SinOsc.ar(\fmf.kr(1000.2)).unipolar, Impulse.ar(\latchfreq.kr(10))).lag(\latchlag.kr(0.01)) * \latchamt.kr(0.1) + 1 
	), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

ProtoDef(\piano).startControl

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pmono(
			 \latchsaw,
			 \latchamt, Pseg(Pseq([0,3.71],inf),8),
			 \latchlag, Pseg(Pseq([0,0.01,1],inf),9),
			 \fmf, Pseq([
			 	[1000.2,1000.1,2000,1002]
			 ],inf),
			 \lpfr, 0.8,
			 \latchfreq, 16*~t,
			\note, Pseq([
				[0,7,12,15],
				[1,6,13,15],
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

/////////////////


(
SynthDef(\nappy, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var cfreq = freq * \chord.kr(1!4);
	var num = 4 * 2 * 5;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var amps;
	//freq.poll(label:"freq");
	lfo1 = SinOsc.kr(0.1) * 0.001 * \lfo1range.kr(1);
	lfo3 = LFNoise1.kr(0.1!num).range(0.3,3); 
	lfo5 = LFNoise1.kr(0.1!num).range(0.3,0.7); 
	lfo2 = EnvGen.kr(Env([1,1.2,1],[0.1,1.8]), 1, timeScale: lfo3, levelScale: lfo5);
	lfo4 = EnvGen.kr(Env([1,2,1],[0.7,0.8]), 1, timeScale: lfo3);
	cfreq = cfreq *.x [1 - lfo1,1 + lfo1] * [ [1/2,1,2,7,9] ];
	amps = [0.6,1,0.6,0.1,0.1];
	cfreq.debug("cfreq");
	sig = SelectX.ar( LFNoise1.kr(1/2!num).range(0.0,1.0) ,[
		SinOsc.ar(cfreq) * amps,
		LFSaw.ar(cfreq) * amps,
	].collect(_.flatten)) * 5;
	sig.debug("sig");
	//sig = sig * ( SinOsc.ar(freq/2 * ( SinOsc.ar(freq/4 + Rand(0.0,1!sig.size)) * 0.71 + 1 )) * 0.7 + 1 );
	sig = sig * sig.fold( ( SinOsc.kr(0.11) * 0.1 + 1 ).neg, ( SinOsc.kr(0.3) * 1 + 1 ) );
	//sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * lfo2 ).poll, \rq.kr(0.5) * lfo4);
	sig = RLPF.ar(sig, ( \lpf.kr(10001.1) * lfo2 ).clip(10,20000), \rq.kr(0.5) * lfo4);
	sig = HPF.ar(sig,\hpf.kr(30));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan + LFNoise1.kr(0.1!sig.size);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \nappy,
			\note, Pseq([
				0,
				-1,
			],inf),
			\octave,5,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
			\lpf, ~pmodenv.(Pseq([300,1200]+18,1), 8).loop,
			\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\chord, Pseq([
				[ [0,3,7,9].midiratio ],
				[ [0,3,7,10].midiratio ],
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

///////////////////


(
Ndef(\zed, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var factors = (0..12).midiratio;
	factors = [0,3,7,9,12, 15,19].midiratio;
	freq = Duty.kr(4/~t, 0, Dseq([
		1,3,Dwhite(0,12,2),
	],inf)).midiratio * freq;
	sig = SinOsc.ar(freq * factors, mul: Pulse.kr(factors.scramble).range(0.0,1.0)).mean;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var factors = (0..12).midiratio;
	factors = [0,3,7,9,12, 15,19].midiratio;
	freq = Duty.kr(4/~t, 0, Dseq([
		1,3,Dwhite(0,12,2),
	],inf)).midiratio * freq;
	sig = LFSaw.ar(freq * factors * ( SinOsc.ar(freq) * LFNoise1.kr(factors.scramble/2).exprange(0.001,0.3) + 1 ), mul: LFPulse.kr(factors.scramble/2).range(0,1.0));
	sig = RLPF.ar(sig, \lpfr.kr(2.1) * freq * ( SinOsc.ar(factors.scramble/8) * 0.6 + 1 ), \rq.kr(0.5));
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
}).play;
);


(
Ndef(\zed)[1] = \filter	-> { arg in;
	var sig;
	sig = in;

	sig.debug("sig");
	AllpassL.ar(sig, 4/~t, LFNoise1.kr([ 0.1 !10]).range(1.0,10.1) * 0.01,1.1).flop.mean.postln + sig * 4;
	
};
)


//////////////

(
SynthDef(\gregrain_norm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mbufnum, pitch_stretch=1, pos=0, gdur=0.1;
	var sig, clk;
	clk = Impulse.ar(freq);
	pan = Dseq(\panseq.kr([1,0.4,-1,0.1,-0.9]),inf);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = HPF.ar(sig, \hpf.kr(180));
	sig = LPF.ar(sig, \lpf.kr(18000));
	sig = Normalizer.ar(sig);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, 
	Pmono(
		\gregrain_norm,
		\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
		\mbufnum, BufDef.mono('voices/feynman.flac'),
		\pos, ~pmodenv.(Pseq([0,5,10]/48,1) + Pwhite(0,1.02,inf).stutter(8) + 1.1, 8).loop,
		\gdur, 0.01,
		//\freq, 100,
		\pitch_stretch, 1/2,
		\note, Pseq([
			[0,4,7,10],
			[0,4,7,11],
		],inf).stutter(8),
		//\freq, ~pmodenv.(Pseq([0,0.1].midiratio * 70.midicps,1), 1).loop,
		//\freq, ~pmodenv.(Pseq([0,2,1,4].midiratio * 100,1), 1).loop,
		\lpf, 14000,
		\hpf, 100,
		\octave, 6,
		\legato, 0.71,
		\adsr, Pseq([
			[ Env.adsr(2.1,2.1,0.4,0.1) ],
		],inf),
		\dur, Pn(1/2,inf),
		\gain, 1/8,
	),
).play;
);

(
Pdef(\part, 
	Pmono(
		\gregrain_norm,
		\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
		\mbufnum, BufDef.mono('voices/feynman.flac'),
		\pos, ~pmodenv.(Pseq([0,5,10]/48,1) + Pwhite(0,1.02,inf).stutter(8) + 1.1, 8).loop,
		\gdur, 0.01,
		\panseq, Pseq([
			Ptuple(
				5.collect { arg idx;
					Pseg(Pseq([0,-1,1],inf),2+idx)
				}
			)
		],inf).collect({ arg x; [x] }),
		//\freq, 100,
		\pitch_stretch, 1/2,
		\note, Pseq([
			[0,4,7,10],
			[0,4,7,11],
		],inf).stutter(8),
		//\freq, ~pmodenv.(Pseq([0,0.1].midiratio * 70.midicps,1), 1).loop,
		//\freq, ~pmodenv.(Pseq([0,2,1,4].midiratio * 100,1), 1).loop,
		\lpf, 14000,
		\hpf, 100,
		\octave, 6,
		\legato, 0.71,
		\adsr, Pseq([
			[ Env.adsr(2.1,2.1,0.4,0.1) ],
		],inf),
		\dur, Pn(1/2,inf),
		\gain, 1/8,
	),
).play;
);

///////////////

(
SynthDef(\largechord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env([0.1,0.32,2.1],[0.7,1.8])), 1);
	freq = freq * [1/4,1/2,1,2,3,4,5,6,7];
	sig = LFSaw.ar(freq *.x [1,1+\diff.kr(0.00001)]);
	sig = sig + SinOsc.ar(freq,mul:\sinamp.kr(0.2));
	sig = RLPF.ar(sig, ( \lpfr.kr(8.1) * env1 * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,8.1,0.2,2.1,1,-1)), gate, doneAction:2);
	pan = pan + LFNoise1.ar(1/2!sig.size); 
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \largechord,
			\legato, 0.91,
			\note, Pseq([
				[0,3,7],
				[0,3,7]+4,
				[0,3,7,11-12],
				[0,3,7,10-12]+4,
			],inf),
			\octave, 5,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);


////////////////

(
SynthDef(\formant, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\fenv.kr(Env([0,1,0],[0.1,0.8])), 1) * \fenvamt.kr(1) + 1;
	env2 = EnvGen.kr(\bwenv.kr(Env([0,1,0],[0.1,0.8])), 1) * \bwenvamt.kr(1) + 1;
	sig = Formant.ar(freq, \formfreq.kr(120) * env1, \bwfreq.kr(195) * env2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \formant,
			\note, Pseq([
				[0,4,7,0+12],
				[0,4,7-12,0+12]+5,
				[1,4,7-12,1+12]+5,
				[0,4,7-12,0+12]+7,
			],inf).stutter(8*2),
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\legato, Pseq([
				4,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\formfreq, PmodEnv(Pseq([100,200],1), 8*2).loop,
			\bwfreq, PmodEnv(Pseq([100,800],1), 8*2).loop,
			\fenvamt, 1.1,
			\fenv, [
				Env([0,0,1],[0.1,7.08])
			],
			\bwenv, [
				Env([0,0,1],[0.1,7.08])
			],
			//\formfreq, PmodEnv(Pseq([140,780],1), 8).loop,
			//\fspread, PmodEnv(Pseq([0.0051,0.04],1), 8).loop,
			//\bwfreq, PmodEnv(Pseq([1400,152],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.5) ],
			],inf),
			\octave, 4,
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
);

/////////////
// fspread controlled by env
// some simple fm
// env on filter

(
SynthDef(\convergechord, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var num = 7;
	env1 = EnvGen.kr(\fspreadenv.kr(Env([1,0.05,0.001]/4,[0.1,3.0])), 1, levelScale:\fspread.kr(1), timeScale:\fspreadts.kr(1));
	env2 = EnvGen.kr(\lpadsr.kr(Env.adsr(1.1,0.1,0.8,2.1)), gate);
	sig = SinOsc.ar(freq * ((0..num)/num - 0.5 * env1 + 1) * ( SinOsc.ar(freq*\fmfr.kr(1/2)) * \fma.kr(4) + 1 ));
	sig = RLPF.ar(sig, \lpf.kr(200) * ( env2 * \envamt.kr(4) + 1 ), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \convergechord,
			\envamt, PmodEnv(Pseq([0,4],1), 8).loop,
			\fspread, PmodEnv(Pseq([0,1],1), 32).loop,
			\fmfr, Pseq([1,2,1/2],inf),
			\fma, PmodEnv(Pseq([0,4],1), 16).loop,
			\note, Pseq([
				[0,4,7],
				[-1,4,7],
			],inf),
			\dur, 2,
			\amp, 0.1/3,
		),
		
	])
)).play;
);

///////////////

(
SynthDef(\beechord, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num= 10;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = EnvGen.kr(Env([0.01,1/2,1],[10.1,10.8]), 1);
	lfo2 = EnvGen.kr(Env([0.4,0.01,1/2,1],[4,10.1,10.8]), 1);
	lfo3 = EnvGen.kr(Env([0.001,0.01,1/2,1],[0.4,4.1,30.8]), 1);
	sig = Blip.ar(
		freq 
			* Select.kr( LFNoise1.kr(1/1!num).exprange(0.1,1), [  exprand(0.98,1!num),1]) 
			,
		SinOsc.ar( SinOsc.ar(exprand(1/19,10!num)).range(1/3,10)/10  ).range(1, SinOsc.ar(exprand(1/30,10!num)).exprange(1,200) )
	);
	sig1 = sig;
	sig1 = LPF.ar(sig1, 800);
	sig1 = HPF.ar(sig1, 400);

	sig2 = sig;
	sig2 = RLPF.ar(sig2, 1200 * ( SinOsc.kr([ 1/2,1/3,1/5 ]) * 0.1 + 1 ), 0.1);
	sig2 = HPF.ar(sig2, 900);
	sig = ( sig1 * lfo2 ) + ( sig * lfo3 ) + ( sig2 * lfo1 );
	sig = sig.debug("sig") * 5;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.1,1!num)), amp).mean;
	Out.ar(out, sig);
}).add;
);

Pdef(\part).clear;
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \beechord,
			\note, Pseq([
				[0,3,7],
				[0,3,7]-1,
			],inf),
			\octave, 5,
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);
