
Pdef(\recorder).quant = 4
Pdef(\src).quant = 4

~recmodel.edit
Ndef(\fx2).objects.indices
(
Spec.add(\verbmix, \unipolar);
Ndef(\fx2).put(5, \filter -> { arg in;
	var sig = in;
	FreeVerb2.ar(sig[0], sig[1], \verbmix.kr(0.5), \room.kr(1), \damp.kr(0.4));

});
)
Ndef(\fx2).play

(
Pdef(\plop, Pbind(
	\instrument, \snapkick,
	\degree, Pseq([0],inf),
	\dur, 2,
	\amp, 0.1
)).play;
);



(
BufDef(\kick, s.sampleRate * 4);
BufDef(\kick2, s.sampleRate * 4);
BufDef(\kick3, s.sampleRate * 4);
BufDef(\tmp4, s.sampleRate * 4);
BufDef(\snare, s.sampleRate * 4);
BufDef(\snare2, s.sampleRate * 4);
BufDef(\snare3, s.sampleRate * 4);
BufDef(\hat, s.sampleRate * 4);
BufDef(\tmp16, s.sampleRate * 16);
BufDef(\bass, s.sampleRate * 4);
BufDef(\melo, s.sampleRate * 4);
BufDef(\melo2, s.sampleRate * 4);
)

[1,2].normalizeSum

~kitlist = [\kick, \kick2, \kick3, \snare, \snare2, \snare3, \hat];
~kitlist.do { arg key; BufDef.all[key] = nil }
~savebufs.([\kick, \kick2, \kick3, \snare, \snare2, \snare3, \hat], "fix1")
~loadbufs.([\kick, \kick2, \kick3, \snare, \snare2, \snare3, \hat], "fix1")


(
SynthDef(\imp, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig2;
	sig = Impulse.ar(1);
	sig2 = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

~recmodel.instrs.add(\imp)

BufDef(\snare2).saveDialog
BufDef(\snare2).play

Pdef(\src)
Pdef(\bla).addHalo(\instrument, \snapkick)
Param(Pdef(\src), \bodyfreqamp).spec
Param(Pdef(\bla), \bodyfreqenv).spec
XEnvSpec(\freq)


(
	~name = \smpdrum1;
	Pdef(~name, Ppar([
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\kick),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\pos, 0.04,
			\sustain, Pseq([0.2,0.7,0.3,0.6,0.5,0.4],inf).stutter(10),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\kick3),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\pos, 0.04,
			\sustain, Pseq([0.2,0.7,0.3,0.6,0.5,0.4],inf).stutter(10),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 2,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, Pseq([
				BufDef(\kick2),
				BufDef(\kick3),
				BufDef(\kick),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,1,0,

				0,0,1,0, 1,0,0,1,
				0,0,0,0, 0,0,1,0,

				0,0,1,0, 0,1,0,1,
				0,0,0,0, 0,1,0,0,

				0,0,1,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\pos, 0.04 + 0,
			\sustain, 0.2,
			\dur, 1/4,
			\gain, 1.5,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\snare2),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\pos, 0.04,
			\sustain, 0.8,
			\dur, 1/4,
			//\out, BusDef(\fx1),
			\gain, 1,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\snare),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\pos, 0.04 + 0.2,
			\sustain, 0.8,
			\dur, 1/4,
			//\out, BusDef(\fx1),
			\gain, 1,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\snare2),
			\isRest, Pseq([
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,1,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,1,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,1, 0,1,0,
			],inf).coin.not,
			\pos, 0.04 + 0.4,
			\sustain, 0.2,
			\sustain, Pseq([0.1,0.2,Prand([0.1,0.12,0.3],1)],inf),
			\dur, 1/4,
			//\out, BusDef(\fx1),
			\gain, 1,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\snare),
			\isRest, Pseq([
				0,0,0,0, 0,1,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,1,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,1, 0,1,0,
			],inf).coin.not,
			\pos, 0.04 + 0.4,
			\sustain, Pseq([0.1,0.2,Prand([0.1,0.12,0.3],1)],inf),
			\speed, -0.9,
			\dur, 1/4,
			//\out, BusDef(\fx1),
			\gain, 1,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\hat),
			\isRest, Pseq([
				1,1,
				1,0.5,
				1,0,
				1,0,0,0,
			],inf).coin.not,
			\pos, Pseq([0.07, 0.12],inf).stutter(2) + 0.04,
			\speed, 1,
			\sustain, 0.06 + Pseq([0,0.1,0,0, 0,0,0.2,0, 0,0,-0.02],inf),
			\dur, 1/8,
			\gain, 1/8,
			\gain, Pkey(\gain) * Pseq([
				1,0.5,
				0.3,0.5,
			],inf),
		),

	].collect({ arg pat;
		Pbind(\out, BusDef(\fx1)) <> pat
		
	})));
	//Pdef(~name).set(\out, BusDef(\fx1));
	Pdef(~name).set(\out, 0);
	Pdef(\main, Pdef(~name)).play;
	Ndef(\fx2).play;
)
		Pseq([
			Pfindur(32*2,Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\zouk, "vipere/zouk.flac"),
				\isRest, Pseq([
					1,1,1,0.81, 1,0,0.2,0.2,
					1,0,0,0, 0,0,1,0,
					1,0,1,1, 1,0,0.4,0,
					1,0,0.4,1, 0,0,1,0,
				],inf).coin.not,
				\pos, Pseq([
					Pser([0.1,0.2],8),
					Pser([0.1],8),
					Pser([2.7],8),
					Pser([4.1],8),
				],inf).stutter(1),
				\sustain, Pseq([
					Pser([
						0.3,0.1,
					],8),
					Pser([
						0.1,
					],8),
					1/4,1/4
				],inf).stutter(8),
				\dur, 1/4,
				//\out, BusDef(\fx1),
				\gain, 1,
			)),

			Event.silent(16),
			Pfindur(16,Pbind(
				\instrument, \playerbeat,
				\bufnum, BufDef(\zouk, "vipere/zouk.flac"),
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\pos, Pseq([
					0,0, 0,0, 8,0, 0,0,
					4,0, 0,0, 0,0, 0,0,
				],inf).stutter(1),
				\sustain, Pseq([1/2,1/2],inf).stutter(8),
				\dur, 1/4,
				//\out, BusDef(\fx1),
				\gain, 1,
			)),
		],inf)

(
SynthDef(\lead, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig, env;
	sig = LFSaw.ar(freq * ( 1 + ( SinOsc.ar((1..12)*2*112) * 0.7 )));
	env = EnvGen.kr(\env.kr(Env([1,0.8,2,2],[0.1,0.8,0.1].normalizeSum)), gate);
	sig = RLPF.ar(sig, 1200 * env, 0.1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\lead, Pbind(
	\instrument, \lead,
	\degree, Pseq([
		[0,2,7],
		[0,4,6],
	],inf).stutter(8*4),
	\scale, Scale.minor,
	\isRest, Pseq([
		1,0,0,0, 0,0,0.3,0,
		1,0,0.4,0, 1,0,0,0,
	],inf).coin.not,
	\dur, 1/8,
	\legato, Pseq([
		4 + Ptuple(Pwhite(0.1,0.2,1)!3),
		4 + Ptuple(Pwhite(0.1,0.2,1)!3),
		4 + Ptuple(Pwhite(0.1,0.2,1)!3),
		2 + Ptuple(Pwhite(0.1,0.2,1)!3),
		3 + Ptuple(Pwhite(0.1,0.2,1)!3),
	],inf),
	\amp, 0.1/3,
)).play;
);


(
	~name = \smpdrum2;
	Pdef(~name, Ppar([
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\kick),
			\isRest, Pseq([
				1,0,1,1, 0,1,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\pos, 0.04,
			\sustain, Pseq([0.2,0.7,0.3,0.6,0.5,0.4],inf).stutter(10),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1,
		),
		//Pbind(
		//	\instrument, \playerbeat,
		//	\bufnum, BufDef(\melo),
		//	\out, BusDef(\fx1),
		//	\isRest, Pseq([
		//		0,0,0,0, 0,0,0,0,
		//		1,0,1,0, 1,0,1,0,
		//	],inf).coin.not,
		//	\pos, 0.04,
		//	\sustain, 1/2,
		//	\adsr, Pseq([
		//		[ Env.adsr(0.001,0.1,0.8,0.1) ],
		//	],inf),
		//	\dur, 1/4,
		//	\gain, 1,
		//),
		//Pbind(
		//	\instrument, \playerbeat,
		//	\bufnum, BufDef(\melo2),
		//	\out, BusDef(\fx1),
		//	\isRest, Pseq([
		//		1,0,1,0, 1,0,1,0,
		//		0,0,0,0, 0,0,0,0,
		//	],inf).coin.not,
		//	\pos, 0.04 + Pseq([0,0.2],inf).stutter(2),
		//	\sustain, 1/2,
		//	\adsr, Pseq([
		//		[ Env.adsr(0.001,0.1,0.8,0.1) ],
		//	],inf),
		//	\dur, 1/4,
		//	\gain, 1,
		//),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\snare3),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\pos, 0.04,
			\sustain, Pseq([0.2,0.7,0.3,0.6,0.5,0.4],inf).stutter(10),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\hat),
			\isRest, Pseq([
				1,1,
				1,0.5,
				1,0,
				1,0,0,0,
			],inf).coin.not,
			\pos, Pseq([0.07, 0.12],inf).stutter(2) + 0.04,
			\speed, 1,
			\sustain, 0.06 + Pseq([0,0.1,0,0, 0,0,0.2,0, 0,0,-0.02],inf),
			\dur, 1/4,
			\gain, 4/1,
			\gain, Pkey(\gain) * Pseq([
				1,0.5,
				0.3,0.5,
			],inf),
		),

	].collect({ arg pat;
		//Pbind(\out, BusDef(\fx1)) <> pat
		Pbind(\gain, Pkey(\gain) * 2, \dur, Pkey(\dur) /2) <> pat
		
	})));
	//Pdef(~name).set(\out, BusDef(\fx1));
	Pdef(~name).set(\out, 0);
	Pdef(\main, Pdef(~name)).play;
	Ndef(\fx2).play;
)

(
Ndef(\niak, { arg amp=0.5, pan=0, freq=200, mbufnum,
						gdur=12, trate=100, time_stretch=1, pos=0, pitch_stretch = 1, 
						randframes=0.01, randrate=1, doneAction=2, finepos=0,
						release=0.2;
	var ou;
	var ou1, ou2;
	var dur, clk;
	var bufnum = mbufnum;
	var randclk;
	var pitch;
	var sr, phasor;

	bufnum = BufDef.mono(\rocksteady, "vipere/rocksteady.flac");
	pitch_stretch = 1;
	time_stretch = Duty.kr(1/2/~t,0,Dseq([
		0.1,0.3,0.8,2,
		0.4,0.3,0.2,2,
	],inf)).lag(0.1);
	pitch_stretch = Duty.kr(1/4/~t,0,Dseq([
		1,0.7,1,1,
	],inf)).lag(0.01);
	pos = 0.41;
	trate = 100;
	//pos = SinOsc.kr(1/64*~t).range(0,0.01) + pos;
	clk = Impulse.kr(trate);
	randclk = Impulse.kr(randrate * trate);
	dur = 0.1;
	pan = (WhiteNoise.kr(0.6) + pan).clip(-1,1);
	sr = SampleRate.ir;
	phasor = Phasor.ar(TDuty.kr(4/~t), time_stretch.abs / sr / BufDur.kr(bufnum), 0, 1);
	phasor = Select.ar(time_stretch.sign + 1 /2, [
		pos - phasor,
		phasor + pos,
	]);

	pos = phasor * BufDur.kr(bufnum) + finepos ;
	ou = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);
	ou1 = HPF.ar(ou, 200 * SinOsc.kr(1/52*~t).range(0.5,3.1));
	//ou1 = ou;
	//ou1 = LPF.ar(ou1, 1200);
	ou1 = LPF.ar(ou1, 3200 * SinOsc.kr(1/32*~t).range(0.5,3.1));
	ou = ou1;
	ou = Splay.ar(ou, 1, amp);
	ou = ou * LFPulse.kr(1/4 * ~t * 17/16,0,0.6).range(0,1).lag(0.1);
}).play;
);



(
Ndef(\bassy, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var seq1, seq2, seq3, seq4;
	freq = Duty.kr(4/~t, 0, Dseq([
		0,2,3,-1,
	],inf)) + Duty.kr(1/8/~t, 0, Dseq([
		0,3,
	],inf));
	freq = freq.midiratio * 400 / [4,2] * 2;
	sig = SinOsc.ar(freq);
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(sig) * SinOsc.kr(1/4*~t).range(0,4) )));
	sig = sig + LFSaw.ar(freq);
	seq1 = Duty.kr(1/2/~t, 0, Dseq([
		2,2, 8,16,
		2,2, 4,8,
		1/2,1/2, 1/2,1/2,
		2,2, 4,8,
	],inf));
	seq2 = Duty.kr(1/~t, 0, Dseq([
		1,0.4,0.1,0.01,
	],inf));
	seq3 = Duty.kr(1/~t, 0, Dseq([
		1,3,0.3,0.2,
	],inf));
	sig = ( sig * 5 ).tanh + sig;

	sig = RLPF.ar(sig, ( freq  * ( SinOsc.kr(seq1*~t)+1/2 * seq3 + 0.1 ) ), seq2);
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);


Ndef.defaultQuant

(
Pdef(\bassy, Pbind(
	\instrument, \bassy,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);

(
	~name = \smpdrum3;
	Pdef(~name, Ppar([
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\kick),
			\isRest, Pseq([
				1,0,1,1, 0,1,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\pos, 0.04,
			\sustain, Pseq([0.2,0.7,0.3,0.6,0.5,0.4],inf).stutter(10),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1,
		),
		//Pbind(
		//	\instrument, \playerbeat,
		//	\bufnum, BufDef(\melo),
		//	\out, BusDef(\fx1),
		//	\isRest, Pseq([
		//		0,0,0,0, 0,0,0,0,
		//		1,0,1,0, 1,0,1,0,
		//	],inf).coin.not,
		//	\pos, 0.04,
		//	\sustain, 1/2,
		//	\adsr, Pseq([
		//		[ Env.adsr(0.001,0.1,0.8,0.1) ],
		//	],inf),
		//	\dur, 1/4,
		//	\gain, 1,
		//),
		//Pbind(
		//	\instrument, \playerbeat,
		//	\bufnum, BufDef(\melo2),
		//	\out, BusDef(\fx1),
		//	\isRest, Pseq([
		//		1,0,1,0, 1,0,1,0,
		//		0,0,0,0, 0,0,0,0,
		//	],inf).coin.not,
		//	\pos, 0.04 + Pseq([0,0.2],inf).stutter(2),
		//	\sustain, 1/2,
		//	\adsr, Pseq([
		//		[ Env.adsr(0.001,0.1,0.8,0.1) ],
		//	],inf),
		//	\dur, 1/4,
		//	\gain, 1,
		//),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\snare),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\pos, 0.04,
			\sustain, Pseq([0.2,0.7,0.3,0.6,0.5,0.4],inf).stutter(10),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\snare),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,0,1,0, 0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\pos, 0.18,
			\sustain, Pseq([0.1],inf),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 1,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\snare2),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\pos, 0.18,
			\sustain, Pseq([0.8],inf),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 1,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\hat),
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
			],inf).coin.not,
			\pos, Pseq([0.01, 0.02],inf).stutter(2) + 0.04,
			\speed, 1,
			\sustain, Pseq([
				Pser([0.1,0]/2,8),
				0.1,0,0.1,0, 0.4,0,0,0,
				0.1,0,0.1,0, 0.2,0,0.1,0,
				0.1,0.1,0.1,0, 0.4,0,0,0,
			],inf),
			\isRest, Pkey(\sustain) <= 0,
			\dur, 1/8,
			\gain, 2/1,
			\gain, Pkey(\gain) * Pseq([
				1,0.5,
				0.3,0.5,
			],inf),
		),

	].collect({ arg pat;
		//Pbind(\out, BusDef(\fx1)) <> pat
		Pbind(\gain, Pkey(\gain) * 2, \dur, Pkey(\dur) /1) <> pat
		
	})));
	//Pdef(~name).set(\out, BusDef(\fx1));
	Pdef(~name).set(\out, 0);
	Pdef(\main, Pdef(~name)).play;
	//Ndef(\fx2).play;
)
