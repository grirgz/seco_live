

(
TempoClock.default.tempo = 110/60;
Pdef.defaultQuant = 4;
Ndef.defaultQuant = 4;
~t = TempoClock.default.tempo;
SynthDef(\hat, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar;
	sig = RLPF.ar(sig, \lpf.kr(11100), \rq.kr(0.5));
	sig = RHPF.ar(sig, \hpf.kr(3100), \rq.kr(0.5));
	//sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.2,1,-4),gate,doneAction:2);
	sig = sig * EnvGen.ar(Env.perc(0.01,\rel.kr(0.1),-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\hat2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar;
	sig = RLPF.ar(sig, \lpf.kr(15100), \rq.kr(0.5));
	sig = RHPF.ar(sig, \hpf.kr(6100), \rq.kr(0.5));
	//sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.2,1,-4),gate,doneAction:2);
	sig = sig * EnvGen.ar(Env.perc(0.01,\rel.kr(0.1),-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\snare, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([4000,4400,1700],[0.04,0.7],-4), 1) * \env1scale.kr(1);
	sig1 = RLPF.ar(sig, env1 , \rq.kr(0.5) * [1,0.5]) * [1,0.7];
	env2 = EnvGen.kr(Env([1000,4400,1700],[0.01,0.7],-4), 1) * \env2scale.kr(1);
	sig2 = RLPF.ar(sig, env2 , \rq.kr(0.5) * [1,0.5]) * [1,0.7];
	sig = [sig1, sig2];
	//sig = [FreqShift.ar(sig, -220) , sig];
	sig = DelayL.ar(sig, 0.1, [ 1/8000, 1/7000 ]) + sig;
	sig = DelayL.ar(sig, 0.1, [ 1/8000, 1/7000 ] * 4.11) + sig;
	sig = 4.collect { arg x;
		var isig = DelayL.ar(sig, 0.1,0.01 * ( x/40 )) + sig;
		isig = DelayL.ar(isig, 0.1, [ 1/8000, 1/7000 ] * 0.98 * ( x/10 )) + sig;
	};
	sig = sig.mean;
	sig.debug("sig");
	sig = sig * EnvGen.ar(\env.kr(Env.perc(0.01,0.2,1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\snare2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var fmf;
	sig1 = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([freq,freq*2,4541],[0.01,0.08]), 1);
	sig1 = BPF.ar(sig1, env1);
	sig2 = WhiteNoise.ar;
	env2 = EnvGen.kr(Env([freq,freq*2,8541],[0.04,0.08]), 1);
	sig2 = BPF.ar(sig2, env2);

	fmf = freq * [1,1/4];
	env3 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	sig3 = SinOsc.ar(fmf * ( 1 + ( SinOsc.ar(fmf * 8/10) * env3 )));
	sig = [sig1, sig2];
	sig = sig * EnvGen.kr(Env.perc(0.0001,0.02), gate);
	sig = sig + sig3;
	//sig = [sig1, sig2] * 2;
	sig = DelayL.ar(sig, 0.1, [ 1/8000, 1/7000 ] * 1744.11) + sig;
	sig = sig * EnvGen.kr(Env.perc(0.0001,0.2), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\kick, Pbind(
	\instrument, \dr_kick,
	\env1, Pseq([
		[ Env.new([80, 32, 29], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\timeScale, 2,
	\fratio, 1,
	\degree, Pseq([0],inf),
	\dur, 4,
	\amp, 0.8
)).play;
);

(
Pdef(\hat, Pbind(
	\instrument, \hat,
	\degree, Pseq([0],inf),
	\sustain, 0.05,
	\isRest, Pseq([
		1,0,1,0,
	],inf).coin.not,
	\rel, Pseq([ 
		Pseq([ 0.01, ],3), 0.1,
		Pseq([ 0.01, ],3), 0.1 + Pwhite(0.1,0.4,1),
	],inf).stutter(2),
	\dur, 1/4,
	//\dur, (1 + (0.09 * Pseq([-1,1],inf))).stutter(2) / 4,
	\amp, 0.03
)).play;
);

Pdef(\hat).stop

(
);

(
Pdef(\hat2, Pbind(
	\instrument, \hat,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\sustain, 0.05,
	\isRest, Pseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,1,1,0,
		0,0,1,1, 0,1,0,1,
		0,0,0,0, 0,0,0,0,

		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,1,1,1,
		0,0,0,0, 0,0,0,0,

		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		1,0,0,1, 0,0,1,0,
		0,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\rel, Pseq([ 
		0.1,
	],inf).stutter(2),
	\amp, 0.03
)).play;
);


(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([10,1,1,1],inf),
	\sustain, 0.01,
	\dur, 1/2,
	\amp, 0.1
)).stop;
);

(
Pdef(\kick, Pbind(
	\instrument, \dr_kick,
	\env1, Pseq([
		[ Env.new([80, 32, 29], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\timeScale, 2,
	\fratio, 1,
	\degree, Pseq([0],inf),
	\dur, 4,
	\amp, 0.8
)).play;
);

(
Pdef(\kick2, Pbind(
	\instrument, \dr_kick,
	\env1, Pseq([
		[ Env.new([80, 32, 29], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.1,0], [0.055, 0.09,0.1], [-4, -5]) ],
	],inf),
	\timeScale, 1,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
		1,0,1,0, 0,1,0,0,
		1,0,0,0, 0,0,0,0,
		1,0,1,0, 0,0,1,0,
	],inf).coin.not,
	\fratio, 1,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\amp, 0.8
)).play;
);

(
);

(
Pdef(\snare, 

	Pbind(
		\instrument, \snare,
		\degree, Pseq([0],inf),
		\dur, 1/4,
		\isRest, Pseq([
			0,0,0,0, 1,0,0,0,
		],inf).coin.not,
		\amp, 0.2
	)
	<>
	Pbind(
		\env, Pseq([
			[ Env.perc(0.01,0.2) ],
			[
				[ Env.perc(0.01,0.4) ],
				[ Env.perc(0.02,0.4) ]
			]
		],inf),
		\env1scale, Pseq([1,1.0],inf),
		\env2scale, Pseq([1,[0.4,0.8]],inf),
		\lag, Pseq([0, Ptuple([0,Pwhite(0.01,0.071,1)])],inf),
	).stutter(8)

).play;
);


(
);

(
Pdef(\snare2, Pbind(
	\instrument, \snare2,
	\freq, Pseq([100,200,170,120],inf),
	\isRest, Pseq([
		0,0,1,0, 0,0,1,0.71,
		0,0.9,0.1,1, 0,0,1,0.3,
	],inf).coin.not,
	\dur, 1/8,
	\amp, 0.9
)).play;
);

(
Pdef(\snare2, Pbind(
	\instrument, \snare2,
	\freq, Pseq([100,200,170,120],inf).stutter(6),
	\isRest, Pseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,1,1, 1,1,1,1,
	],inf).coin.not,
	\dur, 1/8,
	\amp, 0.9
)).play;
);

(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);


(
SynthDef(\bassko, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1/8,1],[0.1,0.8]), 1);
	//freq = freq * (1 + SinOsc.ar(0,[ \phase1.kr(0),\phase2.kr(0) ],mul:0.01) );
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(\oscmix.kr(0.5)*2, [sig1, sig2, sig3]);
	sig = SinOsc.ar(freq) + sig; 
	//sig = ( sig*100 ).tanh;
	sig = sig.wrap2(0.9) + sig;
	sig = RLPF.ar(sig, \lpf.kr(1700) + [ \phase1.kr(0),\phase2.kr(0) ], \rq.kr(0.5));
	sig = sig + RLPF.ar(sig, \lpf2.kr(470) * ( env1*0.1+1 ) , \rq2.kr(0.1), mul:1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig / 2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\bassko, Pbind(
	\instrument, \bassko,
	\phase1, Ndef(\lfo1_phase1, { SinOsc.kr(1/14).range(0,2pi)  }),
	\lpf, Ndef(\lfo1_lpf, { SinOsc.kr(1/34).range(1770,2401)  }),
	\lpf2, Ndef(\lfo1_lpf2, { SinOsc.kr(1/14).range(70,401)  }),
	\rq2, Ndef(\lfo1_rq2, { SinOsc.kr(1/24).range(0.01,1)  }),
	\degree, Pseq([0,0,0,-1],inf).stutter(4),
	\octave, 3,
	\legato, Pseq([
		Pseq([
			3,3,3,1,
		],3),
		Pseq([
			1,2,1,3,
		],1),
	],inf).stutter(4),
	\isRest, Pseq([
		1,0,0,0, 1,0,0,0,
		1,0,0,0, 1,1,1,0,
		1,0,0,0, 1,0,0,0,
		1,0,0,0, 1,0,1,1,

		1,0,0,0, 1,0,0,0,
		1,0,0,0, 1,1,1,0,
		1,0,1,1, 1,0,0,0,
		1,0,1,0, 1,0,1,1,
	],inf).coin.not,
	\dur, 1/8,
	\amp, 0.1
)).play;
);

(
Pdef(\bassko, Pbind(
	\instrument, \bassko,
	\phase1, Ndef(\lfo1_phase1, { SinOsc.kr(1/14).range(0,2pi)  }),
	\lpf, Ndef(\lfo1_lpf, { SinOsc.kr(1/34).range(1770,2401)  }),
	\lpf2, Ndef(\lfo1_lpf2, { SinOsc.kr(1/14).range(70,401)  }),
	\rq2, Ndef(\lfo1_rq2, { SinOsc.kr(1/24).range(0.01,1)  }),
	\degree, Pseq([0,0,0,-1],inf).stutter(4),
	\octave, 3,
	\legato, Pseq([
		2
	],inf).stutter(4),
	\isRest, Pseq([
		1,0,0,0, 0,0,1,0,
		0,0,0,0, 0,0,0,0,
		1,0,0,0, 0,0,1,0,
		0,0,0,0, 0,0,0,0,

		1,0,0,0, 0,0,1,0,
		0,0,0,0, 0,0,0,0,
		1,0,0,0, 0,0,0,0,
		0,0,1,0, 1,0,0,0,
	],inf).coin.not,
	\dur, 1/8,
	\amp, 0.1
)).play;
);



////////////////////////////////////////
(
Pdef(\kick).play;
Pdef(\kick2).play;
Pdef(\snare).play;
Pdef(\hat).play;
Pdef(\hat2).play;
Pdef(\bassko).play;
Ndef(\gato).play;
)

(
Pdef(\kick2, Pbind(
	\instrument, \dr_kick,
	\env1, Pseq([
		[ Env.new([80, 32, 29], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.6,0], [0.055, 0.09,0.1], [-4, -5]) ],
	],inf),
	\timeScale, 1,
	\isRest, Pseq([
		1,1,0,0, 0,0,0,0,
		1,0,0,0, 0,0,1,0,
		1,0,1,0, 0,0,0,0,
		1,0,0,1, 0,0,1,0,

		1,1,0,0, 0,0,0,0,
		1,0,0,0, 0,0,1,0,
		1,0,0,0, 0,0,0,1,
		1,0,1,0, 0,1,1,0,
	],inf).coin.not,
	\fratio, 1,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\amp, 0.8
)).play;
);

(
Pdef(\snare, 

	Pbind(
		\instrument, \snare,
		\degree, Pseq([0],inf),
		\dur, 1/4,
		\isRest, Pseq([
			0,0,0,0, 1,0,0,0,
		],inf).coin.not,
		\amp, 0.2
	)
	<>
	Pbind(
		\env, Pseq([
			[ Env.perc(0.01,0.2) ],
			[ Env.perc(0.01,0.2) ],
			[ Env.perc(0.01,0.2) ],
			[
				[ Env.perc(0.01,0.3) ],
				[ Env.perc(0.02,0.2) ]
			],
			[ Env.perc(0.01,0.2) ],
			[ Env.perc(0.01,0.2) ],
			[ Env.perc(0.01,0.2) ],
			[
				[ Env.perc(0.01,0.4) ],
				[ Env.perc(0.02,0.4) ]
			],
		],inf),
		\env1scale, Pseq([1,1.0],inf),
		\env2scale, Pseq([1,[0.4,0.8]],inf),
		\lag, Pseq([0, Ptuple([0,Pwhite(0.01,0.071,1)])],inf)/2,
	).stutter(8)

).play;
);

(
Pdef(\hat, Pbind(
	\instrument, \hat,
	\degree, Pseq([0],inf),
	\sustain, 0.05,
	\isRest, Pseq([
		1,0,1,0,
	],inf).coin.not,
	\rel, Pseq([ 
		Pseq([ 0.01, ],3), 0.1,
		Pseq([ 0.01, ],3), 0.1 + Pwhite(0.1,0.4,1),
	],inf).stutter(2),
	\dur, 1/4,
	//\dur, (1 + (0.09 * Pseq([-1,1],inf))).stutter(2) / 4,
	\amp, 0.03
)).play;
);

Pdef(\hat).stop

(
);

(
Pdef(\hat2, Pbind(
	\instrument, \hat,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\sustain, 0.05,
	\isRest, Pseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,1,1,0,
		0,0,1,1, 0,1,0,1,
		0,0,0,0, 0,0,0,0,

		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,1,1,1,
		0,0,0,0, 0,0,0,0,

		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		1,0,0,1, 0,0,1,0,
		0,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\rel, Pseq([ 
		0.1,
	],inf).stutter(2),
	\amp, 0.03
)).play;
);

(
Pdef(\snare2, Pbind(
	\instrument, \snare2,
	\freq, Pseq([100,200,170,120],inf).stutter(1)*1.9 ,
	\isRest, Pseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		1,0,1,0, 1,0,0,0,

	],inf).coin.not,
	\dur, 1/4,
	\amp, 0.9
)).play;
);


(
SynthDef(\fool, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\fool, Pbind(
	\instrument, \fool,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);

(
Ndef(\gato, { arg freq=220, pan=0, amp=0.1;
	var sig;
	var fspread;
	//freq = freq * ( 1 + ( SinOsc.ar( 100 * ( 1 + ( SinOsc.kr( 4 * ( 1 + ( SinOsc.kr(1/4) * 1 ))) * 1 )) ) * 11 ));
	freq = freq * Duty.kr(1/4/~t, 0, Dseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, -1,0,-1,0,
	],inf)).midiratio;
	fspread = 0.001 * SinOsc.kr(1/4 * ~t).range(0,10);
	fspread = 0.001 * Duty.kr(1/~t, 0, Dseq([
		1,0,10,0,
	],inf));
	freq = freq * ((0..7)/7 - 0.5 * fspread + 1);
	freq = freq.collect({ arg f, x; if(x.odd) { f / 2 } { f } });

	sig = LFSaw.ar(freq);
	sig = LPF.ar(sig, 9000);
	sig = sig * Duty.kr(1/4/~t, 0, Dseq([
		0,0,0,0, 1,0,1,0,
		0,0,0,0, 1,1,0,0,
		0,0,0,0, 0,1,1,0,
		0,0,1,1, 0,0,1,0,

		1,0,1,1, 0,0,0,0,
		1,0,0,0, 0,1,1,0,
		0,0,1,1, 1,0,1,1,
		1,0,0,0, 1,0,1,0,
	],inf));
	pan = sig.collect { arg ss, x;
		Duty.kr(1/4/~t, 0, Dseq([
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, -1,1,0,0,
			0,0,0,0, 1,1,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, -1,1,0,0,
			0,0,0,0, 1,-1,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, -1,1,0,0,
		],inf,x))/4
	};
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);

(
Ndef(\gato, { arg freq=440, pan=0, amp=0.1;
	var sig;
	var fspread;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	//freq = freq * ( 1 + ( SinOsc.ar( 100 * ( 1 + ( SinOsc.kr( 4 * ( 1 + ( SinOsc.kr(1/4) * 1 ))) * 1 )) ) * 11 ));
	freq = freq * Duty.kr(1/4/~t, 0, Dseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, -1,0,-1,0,
	],inf)).midiratio;
	fspread = 0.001 * SinOsc.kr(1/4 * ~t).range(0,10);
	fspread = 0.001 * Duty.kr(1/~t, 0, Dseq([
		1,0,10,0,
	],inf));
	freq = freq * ((0..7)/7 - 0.5 * fspread + 1);
	freq = freq.collect({ arg f, x; if(x.odd) { f / 4 } { f } });

	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar( SinOsc.kr(1/9).range(0,1)*2, [sig1, sig2, sig3]);
	sig1 = sig;
	sig1 = sig1.wrap2( SinOsc.kr(1/7).range(0.5,1));
	sig1 = (sig1 * 100).fold2( SinOsc.kr(1/4).range(0.5,1));
	sig = SelectX.ar( SinOsc.kr(1/17).range(0,1), [sig, sig1]);
	sig = sig1;
	sig = LPF.ar(sig, 9000);
	sig = sig * Duty.kr(1/4/~t, 0, Dseq([
		0,0,0,0, 0,0,1,0,
		1,1,1,1, 1,1,1,1,
		0,0,0,0, 1,0,1,0,
		1,1,1,1, 1,1,1,1,
		0,0,0,0, 1,1,1,0,
		1,1,1,1, 0,1,1,1,
	],inf));
	pan = sig.collect { arg ss, x;
		Duty.kr(1/4/~t, 0, Dseq([
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, -1,1,0,0,
			0,0,0,0, 1,1,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, -1,1,0,0,
			0,0,0,0, 1,-1,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, -1,1,0,0,
		],inf,x))/4
	};
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);



(
Ndef(\brik, { arg freq=400, pan=0, amp=0.1;
	var sig;
	freq = freq * [1,1/2, Duty.kr(1/4/~t, 0, Dseq([
		1,4,4,4,
	],inf))/4];
	sig = SinOsc.ar(freq);
	sig = sig.wrap2( SinOsc.kr(1/( (1..8)/8 ) * ~t).range(0.6,1) );
	sig = sig * EnvGen.kr(Env([0,1,1,0],[0.1,0.8,0.1].normalizeSum / ~t * 4), Impulse.kr(~t/4));
	sig = RLPF.ar(sig, \lpf.kr(10000), \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);

(
Ndef(\brik, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = freq * [1,1/2, Duty.kr(1/4/~t, 0, Dseq([
		1,4,4,4,
	],inf))/4];
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar( Duty.kr(1/2/~t, 0, Dseq([
		2,2,2,2,
		2,2,2,2,
		2,2,2,2,
		1,0,2,0,

		0,0,0,0,
		0,0,0,0,
		0,0,0,0,
		1,0,2,0,

		2,2,2,2,
		2,2,2,2,
		2,2,2,2,
		1,0,2,0,

		1,1,1,1,
		1,1,1,1,
		1,1,1,1,
		1,0,2,0,
	],inf)), [sig1, sig2, sig3]);
	sig = sig.fold2( SinOsc.kr(1/( (1..8)/8 ) * ~t).range(0.6,1) );
	env2 = Duty.kr(1/~t, 0, Dseq([
		1,1/2,1/4,0,
		0,0,0,0,
	],inf));
	sig = sig * EnvGen.kr(Env([0,1,1,0],[0.01,0.8,0.01].normalizeSum / ~t * 4), Impulse.kr(~t/4));
	sig = RLPF.ar(sig, \lpf.kr(10000) * env2, \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);


(
BufDef(\rocksteady, "vipere/rocksteady.flac");
Pdef(\razy, Pbind(
	\instrument, \dr_oscsampler,
	\bufnum, BufDef(\rocksteady),
	\degree, Pseq([0],inf),
	\posenv, Pseq([
		[ Env([0,1,0],[8.84,0.8]) ]
	],inf),
	\pos, 0,
	\sustain, 0.8,
	\dur, 4,
	\amp, 0.1
)).play;
);

(
BufDef(\rocksteady, "vipere/rocksteady.flac");
Pdef(\vla, Pbind(
	\instrument, \dr_oscsampler,
	\bufnum, BufDef(\rocksteady),
	\degree, Pseq([0],inf),
	\posenv, Pseq([
		[ Env([0,1,0],[8.84,0.8]) ]
	],inf),
	\pos, 0.6,
	\sustain, 0.4,
	\isRest, Pseq([
		0,0,0,1,
		1,1,0,1,
	],inf).coin.not,
	\dur, 1/2,
	\amp, 0.1
)).play;
);

(
BufDef(\rocksteady, "vipere/rocksteady.flac");
Pdef(\frik, Pbind(
	\instrument, \dr_oscsampler,
	\bufnum, BufDef(\rocksteady),
	\degree, Pseq([0],inf),
	\posenv, Pseq([
		[ Env([0,0.009,0.111,0.1],[0.04,0.8,4.3]) ]
	],inf),
	\freq, 48,
	\pos, 0.2,
	\framerange, 17,
	\fshift, -100,
	\lpmix, 1,
	\ffreq, 10000,
	//\sustain, 4 / ~t,
	\legato, 1,
	\isRest, Pseq([
		1
	],inf).coin.not,
	\dur, 4,
	\amp, 0.4
)).play;
);

(
BufDef(\rocksteady, "vipere/rocksteady.flac");
Pdef(\frik, 
	
	Ppar([
			Pbind(
			\instrument, \dr_oscsampler,
			\bufnum, BufDef(\rocksteady),
			\degree, Pseq([0],inf),
			\posenv, Pseq([
				[ Env([0,0.009,0.111,0.1],[0.04,0.8,4.3]) ]
			],inf),
			\freq, 48,
			\pos, 0.2,
			\framerange, 17,
			\fshift, -100,
			\lpmix, 1,
			\ffreq, 10000,
			//\sustain, 4 / ~t,
			\legato, 1,
			\isRest, Pseq([
				1
			],inf).coin.not,
			\dur, 4,
			\amp, 0.4
		)
	]),


).play;
);

(
Ndef(\cymbal,{
	var env = EnvGen.ar(Env.perc);
	var sig = WhiteNoise.ar;
	var freqs = {exprand(2000,20000)}.dup(100);
	sig = Ringz.ar(sig,freqs*1.12,0.05).mean * 0.5;
	sig = sig + Ringz.ar(sig,freqs,0.5).mean*0.5*env;
	sig ! 2;
}).play;
)
Ndef(\cymbal).clear


Ndef(\cymbal, {
	
})

(
SynthDef(\cymbal, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var env = EnvGen.ar(Env.perc(\at.kr(0.01)), gate, doneAction:2);
	var sig = WhiteNoise.ar;
	var freqs = {exprand(2000,20000)}.dup(100);
	sig = Ringz.ar(sig,freqs*1.12,0.05).mean * 0.5;
	sig = sig + Ringz.ar(sig,freqs,0.5).mean*0.5*env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\plop, Pbind(
	\instrument, \cymbal,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);
