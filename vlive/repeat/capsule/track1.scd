(
SynthDef(\chordb, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = {arg x; 
		var isig;
		var ffac = 8;
		isig = LFSaw.ar( freq/2 * x + ExpRand(freq/64,2*freq/64));
		isig = isig + LFPulse.ar( freq/ffac * x + ExpRand(freq/64/ffac,2*freq/64/ffac));

		isig = RLPF.ar(isig, freq/2 * x + ExpRand(freq/64,2*freq/64)* LFNoise1.kr(1/4).range(1.1,1) * \lpffac.kr(2) , \rq.kr(0.5));
	}!5;
	sig = sig.scramble;
	sig = TScramble.ar(sig, Impulse.kr(4),1);
	//sig = FreqShift.ar(sig, 4 * SinOsc.kr(1/45).range(0,1)) + sig;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan) / 7;
	Out.ar(out, sig);
}).add;
SynthDef(\distbass, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	freq = SinOsc.ar(freq*\fmfreq.kr(1).lag(0.3)) * \fmrange.kr(0.5).lag(0.3) * LFNoise1.kr(1/7).range(0.9,1.1) + 1 * freq;
	sig = SinOsc.ar(freq.lag(0.1) * [1,8,2,4,1.002]);
	sig1 = LFPulse.ar(freq * [1,4,1.001,2 * LFNoise1.kr(1/10).range(0.999,1.001),1/2], mul:1.00);
	sig = sig + sig1;
	sig = sig.fold2(SinOsc.kr(1/13).range(0.9,1));
	sig = sig.wrap2(SinOsc.kr(1/14).range(0.9,1));
	sig = RLPF.ar(sig, \lpf.kr(500).lag(0.4) * LFNoise1.kr(1/9).range(0.9,1.1), \rq.kr(0.5));
	sig = HPF.ar(sig, \hpf.kr(40));
	sig = sig * EnvGen.ar(\iadsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),\igate.kr(1),doneAction:0);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\dischord, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	freq = [0,1,2,3,4,5].midiratio * freq;
	freq = SinOsc.ar(freq*\fmfreq.kr(1).lag(0.3)) * \fmrange.kr(0.5).lag(0.3) * LFNoise1.kr(1/7).range(0.9,1.1) + 1 * freq;
	sig = SinOsc.ar(freq.lag(0.1) * [1,8,2,4,1.002]);
	sig1 = LFPulse.ar(freq * [1,4,1.001,2 * LFNoise1.kr(1/10).range(0.999,1.001),1/2], mul:1.00);
	sig = sig + sig1;
	sig = sig.fold2(SinOsc.kr(1/13).range(0.9,1));
	sig = sig.wrap2(SinOsc.kr(1/14).range(0.9,1));
	sig = RLPF.ar(sig, \lpf.kr(500).lag(0.4) * LFNoise1.kr(1/9).range(0.9,1.1), \rq.kr(0.5));
	sig = HPF.ar(sig, \hpf.kr(40));
	sig = sig * EnvGen.ar(\iadsr.kr(Env.adsr(0.01,0.1,0.8,1.1)),Trig.kr(\itrig.tr(1), \tsustain.kr(0.1)),doneAction:0);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	//sig = Splay.ar(sig, spread, amp, pan);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
SynthDef(\cloche, { arg out=0, gate=1, freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig1 = Dust.ar(10 * SinOsc.kr(1/8).range(10,1/2));
	sig1 = Ringz.ar(sig1, Rand(100,10000.0!8) * LFNoise0.kr(1/2).range(1/4,1), 1.1).mean/2;
	sig2 = Dust.ar(7);
	sig2 = Ringz.ar(sig2, Rand(100,10000.0!8), 1.1).mean/2;
	sig = sig1 + sig2;
	sig = sig * EnvGen.kr(Env([0,1,0],[0.1,2.8]), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)


(

		Pdef(\t1kick, Pdef(\kick) <> Pbind(
			\instrument, \snapkick,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,1,0,

				1,1,0,1, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		));
		Pdef(\t1kick2,Pdef(\kick) <> Pbind(
			\instrument, \snapkick2,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		));
		Pdef(\t1snare, Pdef(\snare) <> Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/8,
			\amp, 0.1/1,
		));
		Pdef(\t1snare2, Pdef(\snare) <> Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1,
				0,1,0,0, 0,0,0,1,
				0,0,0,0, 1,0,0,1,
				0,1,0,0, 0,0,0,1,

				0,0,0,0, 1,0,0,1,
				0,1,0,0, 0,0,0,1,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\sustain, 0.011,
			\dur, 1/8,
			\amp, 0.04,
		));
		Pdef(\t1hat, Pdef(\hat) <> Pbind(
			\instrument, \phyhat,
			\isRest, Pseq([
				1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,1,1,0,
				1,0,1,0, 1,0,1,0,

				1,0,1,1, 1,0,1,0,
				1,1,1,0, 1,0,1,1,
				1,1,1,0, 1,1,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\sustain, Pseq([0.08,0.02],inf),
			\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
			\pan, Pseq([0.2,0.1,0,-0.1],inf),
			\fac1, Pseq([
				0.5,Pser([
					0.04,
				],15),
				0.05,Pser([
					0.4,0.04,
				],15),
				
			],inf),
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
			\pan, 0,
			\amp, 0.05,
		));
		Pdef(\t1cym, Pdef(\hat) <> Pbind(
			\instrument, \phycymbal,
			\freq, 200,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\fac1, 8,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.1,0.9,0.3,1,-4) ]
			],inf),
			\sustain, 0.2,
			\dur, 1,
			\amp, 0.05,
		));
		Pdef(\t1bass, Pdef(\bass)<>Pbind(
			\instrument, \simplebass,
			\freq, Pseq([
				85,86,87,70,
			],inf),
			\lpf, 200,
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
		));
		Pdef(\t1piano, Pdef(\piano) <> Pbind(
			\instrument, \rix,
			\freq, Pstep(Pseq([2200,2220,2240,1345],inf),1),
			\legato, Pstep(Pseq([
				1,0.4,
			],inf),1),
			\fspread, 4.0001,
			\dur, Pseq([1,1,1,1/2,1/2],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 0,1,1,1,
			],inf).coin.not,
			\dur, PdurStutter(Pseq([
				1,1,1,1,
				1,1,1,2,
				1,1,1,1,
				1,1,1,4,
				1,1,1,1,
				1,1,1,2,
				1,1,16,16,
				4,1,1,2,
			],inf), 1),
			\amp, 0.1,
		));
		Pdef(\t1cling, Pdef(\pad) <> Pbind(\instrument, \cling,
			\degree, Pseq([0],inf),
			\legato, Pseq([
				0.1, 0.1, 0.7,0.1,
			],inf)/2,
			\dur, 2,
			\amp, 0.1,
		));
		Pdef(\t1voice, Pdef(\pad) <> Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
				2,
			],inf).stutter(8),
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					8.2,
				],8*2)*1,
			],inf),
			\gain, 0.6,
			\dur, 1/8,
			\amp, 0.1,
		));
)

Pdef(\part).clear
(
	~master.();
Pdef(\part, Pdef(\t1_intro, 
	Ptpar([
		4, Pbind(
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
			],inf).coin.not,
		) <> Pdef(\t1hat),
		0, Pbind(
			\dur,1,
		) <> Pdef(\t1piano),
		4, Pbind(
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur,1/8,
		) <> Pdef(\t1snare2),
		8, Pbind(
			\compmix, 0,
			\lpf, 3000,
			\isRest, Pseq([
				1,0,0,1,
			],inf).coin.not,
			\dur,1,
		) <> Pdef(\t1bass),
	])
)).play;
)

Pdef(\part).clear
(
	~master.();
Pdef(\part, Pdef(\t1_outro, 
	Ppar([
		Pfindur(2,Pdef(\t1kick)),
		Pfindur(4,Pdef(\t1kick2)),
		Pfindur(2,Pdef(\t1snare)),
		Pfindur(4,Pdef(\t1snare2)),
		Pfindur(12,Pdef(\t1hat)),
		Pfindur(8,Pdef(\t1bass)),
		Pfindur(16,Pdef(\t1piano)),
	])
)).play;
)

(
	~master.();
Pdef(\part,Pdef(\t1_verse1, 
	Ppar([
		Pdef(\t1kick),
		Pdef(\t1kick2),
		Pdef(\t1snare),
		Pdef(\t1snare2),
		Pdef(\t1hat),
		Pdef(\t1bass),
		Pdef(\t1piano),
	])
)).play;
)

(
Pdef(\part,Pdef(\t1_verse2, 
	Ppar([
		Pdef(\t1kick),
		Pdef(\t1kick2),
		Pdef(\t1snare),
		Pdef(\t1snare2),
		Pdef(\t1hat),
		Pdef(\t1bass),
		Pdef(\t1piano),
	])
)).play;
)

(
Pdef(\part,Pdef(\t1_break, 
	Ppar([
		Pdef(\t1kick),
		Pdef(\t1snare),
		Pdef(\t1hat),
		Pdef(\t1bass),
	])
)).play;
)

(
Pdef(\part,Pdef(\t1_chorus, 
	Ppar([
		Pdef(\t1kick),
		Pdef(\t1kick2),
		Pdef(\t1snare),
		Pdef(\t1snare2),
		Pdef(\t1hat),
		Pdef(\t1bass),
		Pdef(\t1piano),
		Pdef(\t1cling),
	])
)).play;
)

(
	~master.();
Pdef(\part,Pdef(\t1_bridgeprep, 
	Ppar([
		Pdef(\t1kick),
		Pdef(\t1kick2),
		Pbind(
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
		) <> Pdef(\t1snare2),
		//Pdef(\t1snare2),
		Pbind(
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					1,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
		) <> Pdef(\t1hat),
		Pseq([
			Rest(4),
			Pbind(
				\sustain, 12/~t, 
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					Pseq([
						0
					],inf),
				],1).coin.not,
			) <> Pdef(\t1voice),
		],1),
	])
)).play;
)

(
	~master.();
Pdef(\part,Pdef(\t1_bridge, 
	Ppar([
		Pdef(\t1kick),
		Pdef(\t1snare),
		Pdef(\t1snare2),
		Pbind(
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
		) <> Pdef(\t1snare2),
		//Pdef(\t1snare2),
		Pbind(
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
		) <> Pdef(\t1hat),
		Pseq([
			Pbind(
				\pos, Pseq([0.1,0.7],inf).stutter(Pseq([1,2,4],inf).stutter(2)),
				\legato, Pseq([
					4,0,0,0, 0,1,0,0,
					1,0,1,0, 0,0,0,1,
					4,0,0,0, 0,1,0,0,
					1,0,1,0, 0,0,0,1,

					2,0,0,0, 0,1,0,0,
					1,0,2,0, 1/2,1/2,0,1,
					1,0,1,1, 1,0,1,1,
					2,0,2,0, 1,1,1,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/16,
			) <> Pdef(\t1voice),
		],1),
	])
)).play;
)

(
	~master.();
Pdef(\main,Pdef(\track1, 
	Pseq([
		Pfindur(16,Pdef(\t1_intro)),
		Pfindur(16,Pdef(\t1_verse1)),
		Pfindur(16,Pdef(\t1_break)),
		Pfindur(16,Pdef(\t1_chorus)),
		Pfindur(16,Pdef(\t1_bridgeprep)),
		Pfindur(16,Pdef(\t1_bridge)),
		Pfindur(16,Pdef(\t1_verse2)),
		Pfindur(16,Pdef(\t1_outro)),
	])
)).play;
);

8*16 / (135/4/60) / 60
