
(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var gate;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * ( 1 + ( SinOsc.kr(74 * SinOsc.kr(1/8).range(0,1)) * 1 ));
	sig = SinOsc.ar(freq);
	sig = LFSaw.ar(freq);
	gate = Impulse.kr(1);
	sig = LPF.ar(sig, LFPulse.kr(1/4).range(100,14000));
	sig = sig * EnvGen.kr(\env.kr(Env([1,2,1,0],[0.1,0.8,0.1].normalizeSum)), gate, timeScale:1);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


(
SynthDef(\ratrace, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq + {LFNoise1.ar(Rand(1,118)).range(0.0,100.0)}!8;
	freq.debug("freq");
	freq = freq * {LFNoise1.ar(Rand(1,118)).range(0.0,2.0)}!8;
	freq.debug("freqaa");
	(freq * ((0..7)/7 - 0.5 * \fspread.kr(1) + 1)).debug("freq2");
	//sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(1) + 1));
	[freq].debug("freqx");
	sig = LFSaw.ar(freq ).flat.mean;
	sig.debug("sig0");
	sig = sig * 100;
	sig = sig.abs < 5 * sig;
	sig = sig * 100;
	sig = sig.tanh;
	sig = BPF.ar(sig, freq);
	//sig = sig * 0.01;
	sig = Normalizer.ar(sig);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = Pan2.ar(sig.mean, pan, amp).mean;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);

(
Pdef(\ratrace, Pbind(
	\instrument, \ratrace,
	\degree, Pseq([0,2,4,7],inf),
	\fspread, Pseq([1,0.34],inf),
	\octave, 6,
	\isRest, Pseq([
		0,0,0,0, 0,0,0,1,
		1,1,1,1, 0,0,0,0,
	],inf).coin.not,
	\isRest, Pseq([
		1,0
	],inf).coin.not.stutter(8),
	\dur, 1/4,
	\amp, 0.1
)).play;
);

(
Pdef(\krat, Pbind(
	\instrument, \ratrace,
	\degree, Pseq([0],inf),
	\fspread, Pseq([0.00001],inf),
	\octave, 7,
	\legato, 1/8,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.08) ],
	],inf),
	\isRest, Pseq([
		1,0,1,0, 0,1,1,1,
		1,0.4,0,0.1, 0.4,0.5,1,0.31,
	],inf).coin.not,
	\dur, 1/4,
	\amp, 0.1/6,
)).play;
);

(
Pdef(\krat, Pbind(
	\instrument, \ratrace,
	\degree, Pseq([0],inf),
	\fspread, Pseq([0.00001],inf),
	\octave, 7,
	\legato, Prand([
		Pser([1/8, 1/4],16),
		Pser([1/8, 1/8],16),
		Pser([1/8, 1/8, 1/4],16),
		Pser([1/8, 1/2],16),
	],inf).stutter(Prand([1,2,4],inf).stutter(16)),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.08) ],
	],inf),
	\isRest, Pseq([
		Pser([1],8),
		Pser([1,0],8),
		Pser([1],8),
		Pser([0],8),
		Prand([
			Pser([1,0,1,1],8),
			Pser([1,1,0],8),
			Pser([1,0],8),
			Pser([1],8),
		],1),
		Pser([1,0,0],8),
	],inf).coin.not,
	\dur, 1/8,
	\amp, 0.1/2,
)).play;
);

(
Pdef(\ratrace, Pbind(
	\instrument, \ratrace,
	\degree, Pseq([0,2,4,7],inf),
	\fspread, Pseq([1,0.34],inf),
	\octave, 6,
	\legato, 1,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.4) ],
	],inf),
	\isRest, Pseq([
		0,0,0,0, 1,0,0,0,
	],inf).coin.not,
	\dur, 1/4,
	\amp, 0.1/2,
)).play;
);

Pdef.defaultQuant = 4
Ndef.defaultQuant = 4
Ndef(\plop).quant = 4
Ndef(\vide).quant = 4
~t = 1;

(
Ndef(\vide, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var gate;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var seq1, seq2, seq3;
	var msig, sidein = InFeedback.ar(BusDef(\b1),2);
	freq = 50;
	seq1 = Duty.kr(1/4/~t, 0, Dseq([
		1,1,1,1,
		1,1,1,21,
		1,1,1,1,
		0.1,1,1,1,
	],inf));
	seq1 = Duty.kr(1/4/~t, 0, Dseq([
		0,1,0,1,
		6,6,46,6,
		0,1,0,1,
		6,6,46,6,
		0,1,0,1,
		6,6,46,6,
		1,1,4,1,
		86,6,6,6,
	],inf));
	freq = freq * ( 1 + ( SinOsc.ar(freq * seq1) * 1 ));
	sig = SinOsc.ar(freq);
	sig = sig + LFSaw.ar(freq);
	seq2 = Duty.kr(1/4/~t, 0, Dseq([
		1,1,4,1,
		1,0,0,0,
	],inf));
	gate = Impulse.kr(1 * seq2);
	//sig = LPF.ar(sig, LFPulse.kr(1/4).range(100,14000));
	seq3 = Duty.kr(1/~t, 0, Dseq([
		0.2,0.1,0.1,0.1,
	],inf))*04;
	sig = BPF.ar(sig, freq, seq3);
	//sig = BPF.ar(sig, freq/4, 1);
	sig = sig * EnvGen.kr(\env.kr(Env([1,2,1,0],[0.1,0.8,0.1].normalizeSum)), gate, timeScale:1);
	sig = ( sig/1 ).clip2(1);
	sig = sig * 2;
	sig = Pan2.ar(sig, pan, amp).flop.flat;
	msig = Compander.ar(sig, sidein * 2, \cpt.kr(0.01), \cpbelow.kr(1.0), \cpabove.kr(0.5), \cpclamp.kr(0.01), \cprelax.kr(0.09));
	msig = msig + sidein;
	msig;
}).play;
)
Ndef(\vide).clear;
(
Ndef(\vide, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var gate;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var seq1, seq2, seq3;
	var msig, sidein = InFeedback.ar(BusDef(\b1),2);
	freq = 50;
	seq1 = Duty.kr(1/4/~t, 0, Dseq([
		2,2,0,0, 1,0,0,0.1,
		2,1,2,1, 1,0,0.2,0.1,
	],inf));
	freq = freq * ( 1 + ( SinOsc.ar(freq * seq1) * 1 ));
	sig = SinOsc.ar(freq);
	sig = sig + LFSaw.ar(freq);
	seq2 = Duty.kr(1/4/~t, 0, Dseq([
		1,1,4,1,
		1,0,0,0,
	],inf));
	gate = Impulse.kr(1 * seq2);
	//sig = LPF.ar(sig, LFPulse.kr(1/4).range(100,14000));
	seq3 = Duty.kr(1/~t, 0, Dseq([
		0.2,0.1,0.1,0.1,
	],inf))*04;
	sig = BPF.ar(sig, freq, seq3);
	sig = sig * EnvGen.kr(\env.kr(Env([1,2,1,0],[0.1,0.8,0.1].normalizeSum)), gate, timeScale:1);
	sig = ( sig/1 ).clip2(1);
	sig = BPF.ar(sig, freq, seq3 * 2) + sig;
	sig = sig * 1/2;
	sig = Pan2.ar(sig, pan, amp).flop.flat;
	msig = Compander.ar(sig, sidein * 2, \cpt.kr(0.01), \cpbelow.kr(1.0), \cpabove.kr(0.5), \cpclamp.kr(0.01), \cprelax.kr(0.09));
	msig = msig + sidein;
	msig;
}).play;
)


(
SynthDef(\ratkick, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1|
	var env0, env1, env1m, son;

	//freqpan = [-1,0,1] * freqpan;
	env0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.015, 0.10, 00.1], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([90, 32, 29], [0.015, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	env1m = env1.midicps;
	
	son = LFPulse.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, env1m*fratio);
	son = son + SinOsc.ar(env1m, 0.5);
	son = LPF.ar(son, \lpf.kr(2000));
	
	//son = son * 1.2;
	//son = son.clip2(1);

	son = son * amp;
	son = son * env0 * 8;
	son = Pan2.ar(son, pan, amp);
	
	OffsetOut.ar(out, son);
}, metadata:(specs:(
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).store;
)

(
Pdef(\ratkick, Pbind(
	\env0, [ Env.new([0, 1, 0.5, 0], [0.045, 0.10, 00.1], [-4, -2, -4]) ],
	\env1, [ Env.new([90, 37, 31], [0.025, 0.29], [-4, -5]) ],
	\instrument, \ratkick,
	\degree, Pseq([0],inf),
	\isRest, Pseq([
		1,0,0,0, 1,0,0,0,
		0,0,0,0, 0,0,0,0,
		1,0,1,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		1,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,1,0,
		1,0,0,1, 0,0,1,0,
		0,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\out, BusDef(\b1),
	\dur, 1/8,
	\amp, 0.2
)).play;
);

(
Ndef(\vide, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var gate;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var seq1, seq2, seq3;
	var ss1, ss2;
	var msig;
	var sidein = InFeedback.ar(BusDef(\b1),2);
	freq = Duty.kr(16/~t, 0, Dseq([
		Dwhite(40,90,4),
	],inf));
	seq1 = Duty.kr(2/~t, 0, Dseq([
		20.21,3.411,
		1,0.54,0.1,0.6,
	],inf));
	ss1 = Duty.kr(1/~t, 0, Dseq([
		1,0,0.4,0.1,
	],inf));
	freq = freq * ( 1 + ( SinOsc.ar(freq * seq1) * ss1 ));
	sig = SinOsc.ar(freq);
	sig = sig + LFSaw.ar(freq);
	seq2 = Duty.kr(1/8/~t, 0, Dseq([
		1,1,0,1, 0,1,0,1,
		1,0,1,1, 0,1,0,1,
		1,1,0,1, 0,1,0,1,
		0,0,0,1, 0,1,0,1,
	],inf));
	gate = Impulse.kr(1 * seq2);
	//sig = LPF.ar(sig, LFPulse.kr(1/4).range(100,14000));
	seq3 = Duty.kr(1/~t, 0, Dseq([
		0.2,0.1,0.1,0.1,
	],inf))*02;
	sig = BPF.ar(sig, freq, seq3);
	sig = sig * EnvGen.kr(\env.kr(Env([0,2,1,0],[0.1,0.1,0.1].normalizeSum)), gate, timeScale:1);
	sig = BPF.ar(sig, freq, seq3 * 1/2) + sig;
	sig = ( sig/1 ).clip2(1);
	sig = sig * 1/2;
	sig = Normalizer.ar(sig) * 1.1;
	sig = Pan2.ar(sig, pan, amp).flop.flat;
	msig = Compander.ar(sig, sidein, \cpt.kr(0.01), \cpbelow.kr(1.0), \cpabove.kr(0), \cpclamp.kr(0.01), \cprelax.kr(0.09));
	msig = msig + sidein;
	msig;
}).play;
)

(
Pdef(\snare, Pbind(
	\instrument, \zsnare,
	\degree, Pseq([0],inf),
	\isRest, Pseq([
		Prand([
			Pseq([
				0,0,0,0, 1,0,0,0,
			],1),
			Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],1),
			Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],1),
		],1),
		Prand([
			Pseq([
				0,0,0,0, 1,0,1,0,
			],1),
			Pseq([
				0,0,0,0, 1,0,0,1,
			],1),
			Pseq([
				0,1,0,0, 1,0,0,0,
			],1),
			Pseq([
				0,0,0,0, 1,0,0,0,
			],1),
			Pseq([
				0,0,1,0, 1,0,0,0,
			],1),
		],1),
	],inf).coin.not,
	\dur, 1/4,
	\out, BusDef(\b1),
	\amp, 0.1
)).play;
);

BusDef(\b1, \audio, 2)

(
Ndef(\vide, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var gate;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var seq1, seq2, seq3;
	var ss1, ss2;
	var msig;
	var sidein = InFeedback.ar(BusDef(\b1),2);
	freq = Duty.kr(2/~t, 0, Dseq([
		//Dwhite(40,80,4),
		80,160,70,
	],inf));
	seq1 = Duty.kr(1/2/~t, 0, Dseq([
		20.21,3.411,
		1,0.54,0.1,0.6,
	],inf));
	seq1 = SinOsc.kr(1).range(0,1);
	seq1 = Env([0,10,10,0.00100],[1/3,5+( 2/3 ),2]/2).circle.ar;
	//seq1.poll;
	ss1 = Duty.kr(1/~t, 0, Dseq([
		1,0.1,
	],inf));
	freq = freq * ( 1 + ( SinOsc.ar(freq * seq1) * ss1 ));
	sig = SinOsc.ar(freq);
	sig = sig + LFSaw.ar(freq);
	seq2 = Duty.kr(1/8/~t, 0, Dseq([
		1,1,0,1, 0,1,0,1,
		1,0,1,1, 0,1,0,1,
		1,1,0,1, 0,1,0,1,
		0,0,0,1, 0,1,0,1,
	],inf));
	gate = Impulse.kr(1 * seq2);
	//sig = LPF.ar(sig, LFPulse.kr(1/4).range(100,14000));
	seq3 = Duty.kr(1/~t, 0, Dseq([
		0.2,0.1,0.1,0.1,
	],inf))*02;
	sig = BPF.ar(sig, freq, seq3);
	sig = sig * EnvGen.kr(\env.kr(Env([0,2,1,0],[0.1,0.1,0.1].normalizeSum)), gate, timeScale:1);
	sig = BPF.ar(sig, freq, seq3 * 1/2) + sig;
	sig = ( sig/1 ).clip2(1);
	sig = sig * 1/2;
	sig = Normalizer.ar(sig) * 1.1;
	sig = Pan2.ar(sig, pan, amp).flop.flat;
	msig = Compander.ar(sig, sidein, \cpt.kr(0.01), \cpbelow.kr(1.0), \cpabove.kr(0), \cpclamp.kr(0.01), \cprelax.kr(0.09));
	msig = msig + sidein;
	msig;
}).play;
)

(
Ndef(\flux, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * [0,4,7].midiratio;
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(
		SinOsc.kr(1.1 + [1,2,3] / 43).range(0,2),
		[sig1, sig2, sig3]
	);
	sig.debug("siga");
	sig = sig.fold2( SinOsc.kr(1/14 * [1,1.01,1.02]).range(0.8,1) );
	sig = sig.collect({ arg isig, i; 
		SelectX.ar(
			SinOsc.kr(1+( i/10.1 ) / 24).range(0,3),
			[
				sig.wrapAt(i+1) * isig,
				sig.wrapAt(i-1) * isig,
				isig.clip2(sig.wrapAt(i+i).abs),
				isig,
			]
		)
	});
	sig.debug("sig0");
	sig = RLPF.ar(sig, freq * SinOsc.kr((1..sig.size)/10).range(4,1));
	sig = Pan2.ar(sig, SinOsc.kr((1..sig.size)/11.3) * 0.1, amp).mean;
	sig.debug("sigend");
}).play;
);
