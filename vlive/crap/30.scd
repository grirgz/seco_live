
~name = "bla";
~t = 1
(

SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=1, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var seq1, seq2, seq3, seq4;
	var osig;
	seq1 = Duty.kr(1/~t, 0, Dseq([
		1,2,1.3,9,
		1.2,2,1.7,9,
		4,5,2,1,
		1/4,5,2,1,
	],inf)).lag(0.1);
	seq1 = Duty.kr(1/4/~t, 0, Dseq([
		2,4,2,5/4,
	],inf)).lag(0.1);
	seq2 = Duty.kr(1/2/~t, 0, Dseq([
		1,2,1.3,2,
		1,2,1.3,2,
		1,2.5,1.3,2.5,
		1,2.5,1.3,2.5,
	],inf)).lag(0.1);
	//seq1 = SinOsc.kr(1).range(0.1,5);
	sig = Formant.ar(freq * [1,1.001,1/4,1/2,1/8, 1 * (seq1/10)] *.t [seq2 , seq1], 200 * seq1, [100,200,700] * seq2);
	seq3 = Duty.kr(1/4/~t, 0, Dseq([
		1,10,5,1,
		1,50,5,1,
	],inf)).lag(0.1);
	osig = sig;
	sig = HPF.ar(sig, 7000 * LFNoise1.kr(1/14).range(1/7,1.1));
	sig = (sig*seq3).tanh;
	sig3 = (sig*seq3).distort + (sig.sqrt + sig);

	sig = SelectX.ar(SinOsc.kr(1/7*~t).range(0,1),[sig, sig3]);
	sig = Normalizer.ar(sig);
	sig1 = sig;

	sig = LPF.ar(osig, 1000);
	sig2 = sig;
	sig = sig2 + sig1;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = sig.flop.sum;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;

Pdef(~name, Pmono(~name,
	\degree, Pseq([0],inf),
	\spread, 1,
	//\pan, 1,
	\octave, 4,
	\isRest, Pseq([1],inf).coin.not,
	\dur, 1/4,
	\amp, 0.1
)).play

)

{ SinOsc.ar(100) }.play

(

SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=1, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var seq1, seq2, seq3, seq4;
	var osig;
	seq1 = Duty.kr(1/4/~t, 0, Dseq([
		Dseq([
			2,4,2,5/4,
		],4),
		Dseq([
			4,4,4,4,
		],4),
		Dseq([
			1/2,1,1/2,1,
		],4),
		Dseq([
			5,5,1,1,
		],4),
	],inf)).lag(0.1);
	seq2 = Duty.kr(1/2/~t, 0, Dseq([
		Dseq([
			1,1,4,4,
			5,4,3,2,
		],inf) + Dseq([
			Dstutter(8, Dseq([0,0])),
			Dstutter(8, Dseq([0,2,4,2])),
			Dstutter(8, Dseq([3,3,4,2])),
			Dstutter(1, Dseq([3,3,4,2],4)),
		],inf)
	],inf)).lag(0.1);
	//seq1 = SinOsc.kr(1).range(0.1,5);
	sig = Formant.ar(freq * [1,1.001,1/4,1/2,1/8, 1 * (seq1/10)] *.t [seq2 , seq1], 200 * seq1, [100,200,700] * seq2);
	seq3 = Duty.kr(1/4/~t, 0, Dseq([
		1,10,5,1,
		1,50,5,1,
		7,7,7,7,
		17,1/7,17,1/7,
	],inf)).lag(0.1);
	osig = sig;
	sig = HPF.ar(sig, 7000 * LFNoise1.kr(1/14).range(1/7,1.1));
	sig = (sig*seq3).tanh;
	sig3 = (sig*seq3).distort + (sig.sqrt + sig);

	sig = SelectX.ar(SinOsc.kr(1/7*~t).range(0,1),[sig, sig3]);
	sig = Normalizer.ar(sig);
	sig1 = sig;

	sig = LPF.ar(osig, 1000);
	sig2 = sig;
	sig = sig2 + sig1;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = sig.flop.sum;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;

Pdef(~name, Pmono(~name,
	\degree, Pseq([0],inf),
	\spread, 1,
	//\pan, 1,
	\octave, 4,
	\isRest, Pseq([1],inf).coin.not,
	\dur, 1/4,
	\amp, 0.1
)).play

)

(

SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, spread=1, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var seq1, seq2, seq3, seq4;
	var osig;
	seq1 = Duty.kr(1/4/~t, 0, Dseq([
		Dseq([
			2,4,2,5/4,
		],4),
		Dseq([
			4,4,4,4,
		],4),
		Dseq([
			1/2,1,1/2,1,
		],4),
		Dseq([
			5,5,1,1,
		],4),
	],inf)).lag(0.1);
	seq1 = \seq1.kr(1);
	seq2 = Duty.kr(1/2/~t, 0, Dseq([
		Dseq([
			1,1,4,4,
			5,4,3,2,
		],inf) + Dseq([
			Dstutter(8, Dseq([0,0])),
			Dstutter(8, Dseq([0,2,4,2])),
			Dstutter(8, Dseq([3,3,4,2])),
			Dstutter(1, Dseq([3,3,4,2],4)),
		],inf)
	],inf)).lag(0.1);
	seq2 = \seq2.kr(1);
	//seq1 = SinOsc.kr(1).range(0.1,5);
	sig = Formant.ar(freq * [1,1.001,1/4,1/2,1/8, 1 * (seq1/10)] *.t [seq2 , seq1], 200 * seq1, [100,200,700] * seq2);
	seq3 = Duty.kr(1/4/~t, 0, Dseq([
		Dseq([
			1,10,5,1,
			1,50,5,1,
		],4),
		Dseq([
			7,7,7,7,
		],4),
		Dseq([
			17,1/7,17,1/7,
		],12),
	],inf)).lag(0.1);
	seq3 = \seq3.kr(1);
	osig = sig;
	sig = HPF.ar(sig, 7000 * LFNoise1.kr(1/14).range(1/7,1.1));
	sig = (sig*seq3).tanh;
	sig3 = (sig*seq3).distort + (sig.sqrt + sig);

	sig = SelectX.ar(SinOsc.kr(1/7*~t).range(0,1),[sig, sig3]);
	sig1 = sig;

	sig = LPF.ar(osig, 1000);
	sig2 = sig;
	sig = sig2 + sig1;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = sig.flop.sum;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;

Pdef(\plop, Pmono(\plop,
	\degree, Pseq([0,1,-2,-2,4,4,0,1],inf).stutter(16),
	\spread, 1,
	\seq1, Pseq([
		Pseq([
			1,4,
		],16),
		Pseq([
			1,4 + 4/5
		],16),
	],inf),
	\seq1, Pseq([
		Pseq([
			1,4 + 5/4,
		],16),
		Pseq([
			1,4 + 4/5
		],16),
	],inf).stutter(2),
	\seq1, Pseq([
		Pseq([
			1/4,2,
		],16),
	],inf).stutter(2),
	\seq2, Pseq([
		Pseq([
			1,2,
		],16),
	],inf).stutter(2),
	\seq3, Pseq([
		Pseq([
			7,2,1,10,1,
			7,2,1,10,1,
			7,2,1,10,1,
			7,
		],16),
	],inf).stutter(1),
	//\pan, 1,
	\octave, 4,
	\isRest, Pseq([1],inf).coin.not,
	\dur, 1/8,
	\amp, 0.1
)).play

)

(
Pdef(\plop, Pmono(\plop,
	\degree, Pseq([0,4],inf).stutter(16),
	\spread, 1,
	\seq1, Pseq([
		Pseq([
			1/4,2,1/4,1,
		],16),
	],inf).stutter(1),
	\seq1, Pseq([
		Pseq([
			1/4,1/4,4,4,
		],4),
		Pseq([
			4,4,4,4,
			1/4,1/4,1/4,1/4,
		],4),
	],inf).stutter(1),
	\seq2, Pseq([
		Pseq([
			7,2,1/4,2,
		],16),
	],inf).stutter(4),
	\seq3, Pseq([
		Pseq([
			7,2,1,10,
		],16),
	],inf).stutter(1),
	//\pan, 1,
	\octave, 4,
	\isRest, Pseq([1],inf).coin.not,
	\dur, 1/8,
	\amp, 0.1
)).play
)

// END

Pdef(~name).clear
~t
