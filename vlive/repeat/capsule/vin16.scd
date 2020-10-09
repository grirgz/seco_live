
~t = 185/4/60; TempoClock.default.tempo = ~t;


(
Ndef(\zed, { arg freq=440, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var seq1, seq2, seq3, seq4, seq5, seq6, seq7, seq8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	seq1 = Duty.kr(Drand([1/2,1/8],inf)/~t, 0, Dseq([
		1,0,1,1/2,
	],inf));
	seq2 = Dust.ar(seq1*10).poll;
	seq3 = Duty.kr(1/~t, 0, Dseq([
		[0,3,7],
		[0,3,7]+4,
	],inf)).midiratio;
	seq4 = Duty.kr(1/8/~t, 0, Dseq([
		1,0,0,4,
		1,0,0,4,
		1,0,0,4,
		1,1,2,4,
		1,0,0,4,
		1,0,0,4,
		1,0,0,4,
		1/2,1/9,1/12,4,
	],inf)).lag( ( SinOsc.kr(1.081) * 0.5 + 1 )) * ( SinOsc.kr(1.1) * 0.6 + 1 );
	env1 = EnvGen.kr(Env([1,1,2,1],[0,0.01,0.8]), seq2);
	sig1 = SinOsc.ar(freq * seq3 * env1 * ((0..7)/7 - 0.5 * \fspread.kr(0.001) + 1)).mean;
	sig2 = SinOsc.ar(freq * seq3 * (seq2 * 1 + 1)).mean; 
	sig3 = SinOsc.ar(freq * seq3).clip2( Pulse.ar(freq+[0.01,0.1,1.07]).mean  );
	sig3 = RLPF.ar(sig3, \lpfr.kr(2.8) * freq * seq3 * seq4 * ( SinOsc.ar(freq+[0.01,0.1,1.07]) * 1 + 1 ) , \rq.kr(0.5)).mean;
	sig3 = LeakDC.ar(sig3);
	sig3 = HPF.ar(sig3, 100);
	sig = sig1 + sig2 + sig3;
	//sig = sig3;
	//sig = sig * ( SinOsc.ar(seq1*freq) * 1 + 1 );
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.1]), Dust.kr(10));
	sig = SinOsc.ar(freq * env1);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
SynthDef(\sifle, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	//env1 = EnvGen.kr(Env([1,1,2,1],[0,0.1,0.1]), Dust.kr(10));
	env1 = EnvGen.kr(\env1.kr(Env([1,2,1,1],[0.1,0.1,0.1]*1)), Impulse.kr(\env1freq.kr(~t*8)) + Dust.kr(\env1dust.kr(4))).round(\env1round.kr(0)); // osc
	env2 = EnvGen.kr(\env2.kr(Env([1,2,4,1],[0.1,0.1,0.1]*2)), Impulse.kr(\env2freq.kr(~t*4)) + Dust.kr( \env2dust.kr(4))); // ff
	env3 = EnvGen.kr(\env3.kr(Env([1,1/2,4,1],[0.1,0.1,0.1]*2)), Impulse.kr(\env3freq.kr(~t*2)) + Dust.kr(\env3dust.kr(4))); // rq
	sig = LFSaw.ar(freq * [2,1+\fdelta.kr(0.001),1/2,1,2+\fdelta.kr] * env1) * [1,1, 1/8, 1,1];
	sig = RLPF.ar(sig, (\lpfr.kr(1.1) * env2 * freq).clip(20,19990), \rq.kr(0.5) * env3);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\siflehi, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	//env1 = EnvGen.kr(Env([1,1,2,1],[0,0.1,0.1]), Dust.kr(10));
	env1 = EnvGen.kr(\env1.kr(Env([1,2,1,1],[0.1,0.1,0.1]*1)), Impulse.kr(\env1freq.kr(~t*8)) + Dust.kr(\env1dust.kr(4))).round(\env1round.kr(0)); // osc
	env2 = EnvGen.kr(\env2.kr(Env([1,2,4,1],[0.1,0.1,0.1]*2)), Impulse.kr(\env2freq.kr(~t*4)) + Dust.kr( \env2dust.kr(4))); // ff
	env3 = EnvGen.kr(\env3.kr(Env([1,1/2,1.4,1/3],[0.1,0.1,0.1]*2)), Impulse.kr(\env3freq.kr(~t*2)) + Dust.kr(\env3dust.kr(4))); // rq
	sig = LFSaw.ar(freq * [2,1+\fdelta.kr(0.001),1/2,1,2+\fdelta.kr] * env1) * [1,1, 1/8, 1,1];
	sig = RHPF.ar(sig, ( \hpfr.kr(1.1) * env2 * freq ).clip(20,19990), \rq.kr(0.5) * env3);
	sig = LPF.ar(sig, \lpf.kr(18000));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1582].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
			\dur, 1/8,
			\pan, 1,
			\gain, 0.21,
		),
		Pmono(\sifle,
			\note, Pseq([
				1,3,1,0,
			],inf).stutter(1),
			\lpfr, 2.3,
			\octave, 3,
			\out, BusDef(\sendbus2, \audio),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1582].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
			\dur, 1/8,
			\pan, 1,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \sifle,
			\note, Pseq([
				1,3,1,0,
			],inf).stutter(1),
			\legato, Pseq([
				7,0,0,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0,
				7,0,0,0, 0,0,3,0,
				0,0,7,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpfr, 2.3,
			\octave, 3,
			\out, BusDef(\sendbus2, \audio),
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1582].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1581].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,1, 1,0,0,0,

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0, 0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,1,1,
			],inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
			\dur, 1/16,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("s")].value,
			\bufnum, ~buflib.clap[358].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
			\dur, 1/8,
			\pan, 1,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \sifle,
			\note, Pseq([
				1,1,1,0,
			],inf).stutter(2*8),
			\legato, Pseq([
				7,0,0,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0,
				7,0,0,0, 0,0,3,0,
				0,0,7,0, 0,0,0,0,
			],inf),
			\env1, Pseq([
				[ Env([1,1.2,1,1.2],[0.1,0.1,0.1]*2.4) ]
			],inf),
			\env1freq, 1,
			\env2, Pseq([
				[ Env([2,1,2,1]*2,[0.1,0.1,0.8]) ]
			],inf),
			\env3, Pseq([
				[ Env([2,1,2,1]/4,[0.1,0.1,0.8]*1) ]
			],inf),
			\fdelta, Pseg(Pseq([0.0001,0.1],inf),8*2),
			\env3freq, 1*~t,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpfr, Pseg(Pseq([1.2,0.3,2.3,4.3],inf),7),
			\octave, 3,
			\lag, 0.04,
			//\out, BusDef(\sendbus2, \audio),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \siflehi,
			\note, Pseq([
				[0,3,7]+1,
				[0,3,7]+1,
				[0,3,7]+1,
				[0,3,7]+0,
			],inf).stutter(2*8),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\legato, Pseq([
				7,0,0,0, 0,0,0,0,
				0,0,4,0, 0,0,2,0,
				7,0,0,0, 0,0,0,0,
				0,0,4,0, 0,0,0,1,
			],inf),
			\env1, Pseq([
				[ Env([1,1.2,1,1.2],[0.1,0.1,0.1]*1.4) ]
			],inf),
			\env1freq, 8,
			\env2, Pseq([
				[ Env([2,1,2,1]*2,[0.1,0.1,0.8]) ]
			],inf),
			\env3, Pseq([
				[ Env([2,1,2,1]/4,[0.1,0.1,0.8]*1) ]
			],inf),
			\fdelta, Pseg(Pseq([0.1001,0.01],inf),8*2),
			\env3freq, 1*~t,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\hpfr, Pseg(Pseq([0.3,5],inf),8),
			\lpf, 10000,
			\octave, 5,
			\lag, 0.04,
			//\out, BusDef(\sendbus2, \audio),
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1422].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,0,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,0,0, 1,1,1,0,

				1,1,1,0, 1,1,1,1,
				1,1,1,1, 1,0,1,1,
				1,1,1,1, 1,1,0,0,
				0,0,1,1, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\lag, 0.04,
			\gain, 0.1,
		),
		
	])
)).play;
);

Pdef(\part).clear;

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1582].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1581].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,1, 1,0,0,0,

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0, 0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,1,1,
			],inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
			\dur, 1/16,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("s")].value,
			\bufnum, ~buflib.clap[358].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
			\dur, 1/8,
			\pan, 1,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("s")].value,
			\bufnum, ~buflib.clap[353].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,1,
			],inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
			\dur, 1/8,
			\pan, 1,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \sifle,
			\note, Pseq([
				1,1,1,0,
			],inf).stutter(2*8),
			\legato, Pseq([
				1,1,1,0, 1,1,1,1,
				1,1,1,1, 1,0,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,0,0, 1,1,1,1,

				1,1,1,0, 1,1,1,1,
				1,1,1,1, 1,0,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,0, 1,1,1,0,

				1,1,1,0, 1,1,1,1,
				1,1,1,1, 1,0,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,0,0, 1,1,1,1,

				1,1,0,1, 1,1,1,1,
				1,1,1,1, 0,1,0,1,
				1,1,1,1, 1,1,1,1,
				1,1,0,0, 1,1,1,1,
			],inf)*0.5,
			\env1, Pseq([
				[ Env([1,1.2,1,1.2],[0.1,0.1,0.1]*0.4) ],
				[ Env([1,1.2,1,1.2],[0.1,0.1,0.1]*0.4) ],
				[ Env([2,1/2,4,1]*2,[0.1,0.1,0.1]*2.5) ],
				[ Env([1,1.2,1,1.2],[0.1,0.1,0.1]*2.4) ],
				[ Env([1,1.2,1,1.2],[0.1,0.1,0.1]*2.4) ],
				[ Env([2,1/2,4,1]*2,[0.1,0.1,0.1]*2.5) ],
				[ Env([1,1.2,1,1.2],[0.1,0.1,0.1]*2.4) ],
				[ Env([2,1/2,4,1]*2,[0.1,0.1,0.1]*2.5) ],
			],inf),
			\env1freq, 1,
			\env2, Pseq([
				[ Env([2,1/2,4,1]*2,[0.1,0.1,0.1]*0.5) ],
				[ Env([2,1/2,4,1]*2,[0.1,0.1,0.1]*2.5) ],
			],inf),
			\env2freq, 10,
			\env3, Pseq([
				[ Env([2,1,2,1]/4,[0.1,0.1,0.8]*1) ]
			],inf),
			\fdelta, Pseg(Pseq([0.0001,0.1],inf),8*2),
			\env3freq, 1*~t,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpfr, Pseg(Pseq([1,4],inf),2),
			\octave, 3,
			\lag, 0.04,
			//\out, BusDef(\sendbus2, \audio),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \siflehi,
			\note, Pseq([
				[0,3,7]+1,
				[0,3,7]+1,
				[0,3,7]+1,
				[0,3,7]+0,
			],inf).stutter(2*8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				1,0,1,0, 4,0,0,0,
			],inf),
			\env1, Pseq([
				[ Env([1,1.2,1,1.2],[0.1,0.1,0.1]*1.4) ]
			],inf),
			\env1freq, 8,
			\env2, Pseq([
				[ Env([2,1,2,1]*2,[0.1,0.1,0.8]) ]
			],inf),
			\env3, Pseq([
				[ Env([2,1,2,1]/4,[0.1,0.1,0.8]*1) ]
			],inf),
			\fdelta, Pseg(Pseq([0.1001,0.01],inf),8*2),
			\env3freq, 1*~t,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\hpfr, Pseg(Pseq([0.3,5],inf),1),
			\lpf, 10000,
			\octave, 5,
			\lag, 0.04,
			//\out, BusDef(\sendbus2, \audio),
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \hifm,
			\note, Pseq([
				Pseq([
					3,2,1,3,2,1,3,2,
				],6),
				Pseq([
					3,2,1,3,2,1,3,2,
				],2)-1,
			],inf)+7,
			\out, BusDef(\sendbus2, \audio),
			\pantab, Ptuple([
				Pseg(Pseq([-1,1],inf),8),
				Pseg(Pseq([1,0,-1],inf),5),
			]),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1422].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,0,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,0,0, 1,1,1,0,

				1,1,1,0, 1,1,1,1,
				1,1,1,1, 1,0,1,1,
				1,1,1,1, 1,1,0,0,
				0,0,1,1, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\lag, 0.04,
			\gain, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\hifm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq) * SinOsc.ar(freq * ( SinOsc.kr(0.1 * [1,1.01]) * 0.001 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan + \pantab.kr([-1,1]), amp).mean;
	Out.ar(out, sig);
}).add;
);




(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1582].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			//\out, BusDef(\fxbus1, \audio),
			\out, BusDef(\fxbus2, \audio),
			\dur, 1/16,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1581].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\out, BusDef(\fxbus1, \audio),
			\dur, 1/16,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("s")].value,
			\bufnum, ~buflib.clap[361].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\out, BusDef(\fxbus2, \audio),
			\legato,2,
			\dur, 1/8,
			\pan, 1,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("s")].value,
			\bufnum, ~buflib.clap[358].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\out, BusDef(\fxbus1, \audio),
			\legato,2,
			\dur, 1/8,
			\pan, 1,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("s")].value,
			\bufnum, ~buflib.clap[353].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\out, BusDef(\fxbus1, \audio),
			\legato,2,
			\dur, 1/8,
			\pan, 1,
			\gain, 0.21,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[518].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Prand([
					Pseq([
						1,0,1,0, 1,1,1,1, 
					],1),
					Pseq([
						1,0,1,0, 1,0,1,0, 
					],1),
					Pseq([
						1,1,1,1, 1,1,1,1,
					],1),
					Pseq([
						0,0,0,0,
					],1),
					Pseq([
						1,1,1,1,
					],1),
					Pseq([
						1,0,0,1,0,0,1,0,
					],1),
					Pseq([
						1,0,1,0,0,1,0,0,
					],1),
					Pseq([
						1,0,0,1,0,1,0,0,
					],1),
				],inf),
			],inf).coin.not,
			\sustain,2,
			\dur, 1/8,
			\out, BusDef(\fxbus2, \audio),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[518].value,
			\isRest, Pseq([
				Prand([
					Pseq([
						1,0,1,0,1,0,1,0,
					],1),
					Pseq([
						1,0,0,0,1,0,1,0,
					],1),
					Pseq([
						1,0,0,1,0,0,1,0,
					],1),
					Pseq([
						1,0,1,0,0,1,0,0,
					],1),
					Pseq([
						1,0,0,1,0,1,0,0,
					],1),
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\fxbus2, \audio),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \sifle,
			\note, Pseq([
				1,1,1,0,
			],inf).stutter(2*8),
			\legato, Pseq([
				16,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\env1, Pseq([
				[ Env([1,1.2,1,1.2],[0.1,0.1,0.1]*2.4) ],
			],inf),
			\env1freq, 1,
			\env2, Pseq([
				[ Env([1,2.2,4,1]*2,[0.8,0.1,0.1]*1) ],
			],inf),
			\env2freq, 2,
			\env3, Pseq([
				[ Env([2,1,2,1]/4,[0.1,0.1,0.8]*1) ]
			],inf),
			\fdelta, Pseg(Pseq([0.0001,0.1],inf),8*2),
			\env3freq, 1*~t,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpfr, ~pmodenv.(Pseq([1,2,1,4],inf), 1),
			\octave, 3,
			\lag, 0.04,
			//\out, BusDef(\sendbus2, \audio),
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pmono(\sifle,
			\freq, ~pmodenv.(Pexprand(60,1000,inf),Pwhite(0.04,17,inf)),
			\lpfr, ~pmodenv.(Pexprand(0.300,4,inf), Pwhite(4,7,inf)),
			\dur, 1,
			\amp, 0.1/2,
		),
		Pmono(\siflehi,
			\freq, ~pmodenv.(Pexprand(100,8000,inf),Pwhite(0.04,17,inf)),
			\hpfr, ~pmodenv.(Pexprand(0.300,4,inf), Pwhite(4,7,inf)),
			\dur, 1,
			\amp, 0.1/8,
		),
		Pmono(\siflehi,
			\freq, ~pmodenv.(Pexprand(100,8000,inf),Pwhite(4,7,inf)),
			\hpfr, ~pmodenv.(Pexprand(0.300,4,inf), Pwhite(4,7,inf)),
			\dur, 1,
			\amp, 0.1/8,
		),
		Pbind(
			\instrument, \hifm,
			\note, Pseq([
				Pseq([
					3,2,1,3,2,1,3,2,
				],6),
				Pseq([
					3,2,1,3,2,1,3,2,
				],2)-1,
			],inf)+Pswitch1(
				Prand([0,7],inf).stutter(Pwhite(4,8))!8,
				Pseq((0..7),inf),
			),
			\out, BusDef(\sendbus2, \audio),
			\pantab, Ptuple([
				Pseg(Pseq([-1,1],inf),8),
				Pseg(Pseq([1,0,-1],inf),5),
			]),
			\octave, Pswitch1(
				Prand([5,6],inf).stutter(Pwhite(4,8))!8,
				Pseq((0..7),inf),
			),
			\dur, 1/8,
			\amp, 0.1 * Pswitch1(
				Pseg(Pwhite(0,1/2,inf),Pwhite(4,8.0))!8,
				Pseq((0..7),inf),
			),
		),


		Pmono(\fx_echo,
			\addAction, \addToTail,
			//\lag, 0.0005,
			\decay, 2/~t ,
			\delay, Pseq([
				Pwhite(1,16,1)
			],inf)*1/16/~t,
			\inbus, BusDef(\fxbus1, \audio),
			\out, BusDef(\fxbus2, \audio),
			\dur, 1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1582].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			//\out, BusDef(\fxbus1, \audio),
			\out, BusDef(\fxbus2, \audio),
			\dur, 1/16,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1581].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\out, BusDef(\fxbus1, \audio),
			\dur, 1/16,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("s")].value,
			\bufnum, ~buflib.clap[361].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\out, BusDef(\fxbus2, \audio),
			\legato,2,
			\dur, 1/8,
			\pan, 1,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("s")].value,
			\bufnum, ~buflib.clap[358].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\out, BusDef(\fxbus1, \audio),
			\legato,2,
			\dur, 1/8,
			\pan, 1,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("s")].value,
			\bufnum, ~buflib.clap[353].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\out, BusDef(\fxbus1, \audio),
			\legato,2,
			\dur, 1/8,
			\pan, 1,
			\gain, 0.21,
		),
		Pmono(\fx_echo,
			\addAction, \addToTail,
			\lag, 0.0005,
			\decay, 1/~t ,
			\delay, Pseq([
				Pwhite(1,16,1)
			],inf)*1/16/~t,
			\inbus, BusDef(\fxbus1, \audio),
			\out, BusDef(\fxbus2, \audio),
			\dur, 1/2,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[518].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Prand([
					Pseq([
						1,0,1,0, 1,1,1,1, 
					],1),
					Pseq([
						1,0,1,0, 1,0,1,0, 
					],1),
					Pseq([
						1,1,1,1, 1,1,1,1,
					],1),
					Pseq([
						0,0,0,0,
					],1),
					Pseq([
						1,1,1,1,
					],1),
					Pseq([
						1,0,0,1,0,0,1,0,
					],1),
					Pseq([
						1,0,1,0,0,1,0,0,
					],1),
					Pseq([
						1,0,0,1,0,1,0,0,
					],1),
				],inf),
			],inf).coin.not,
			\sustain,2,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[518].value,
			\isRest, Pseq([
				Prand([
					Pseq([
						1,0,0,1,0,0,1,0,
					],1),
					Pseq([
						1,0,1,0,0,1,0,0,
					],1),
					Pseq([
						1,0,0,1,0,1,0,0,
					],1),
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \sifle,
			\note, Pseq([
				1,1,1,0,
			],inf).stutter(2*8),
			\legato, Pseq([
				16,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\env1, Pseq([
				[ Env([1,1.2,1,1.2],[0.1,0.1,0.1]*2.4) ],
			],inf),
			\env1freq, 1,
			\env2, Pseq([
				[ Env([1,2.2,4,1]*2,[0.8,0.1,0.1]*1) ],
			],inf),
			\env2freq, 2,
			\env3, Pseq([
				[ Env([2,1,2,1]/4,[0.1,0.1,0.8]*1) ]
			],inf),
			\fdelta, Pseg(Pseq([0.0001,0.1],inf),8*2),
			\env3freq, 1*~t,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpfr, ~pmodenv.(Pseq([1,2,1,4],inf), 1),
			\octave, 3,
			\lag, 0.04,
			//\out, BusDef(\sendbus2, \audio),
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \siflehi,
			\note, Pseq([
				1,1,1,0,
			],inf).stutter(2*8),
			\legato, Pseq([
				6,0,0,0, 0,0,4,0,
				0,0,6,0, 0,0,0,0,
			],inf),
			\env1, Pseq([
				[ Env([1,2,1,1.2],[1,1,1]/8/~t) ],
			],inf),
			\env1freq, 2/~t,
			\env2, Pseq([
				[ Env([1,2.2,4,1]*2,[0.8,0.1,0.1]*1) ],
			],inf),
			\env2freq, 2,
			\env3, Pseq([
				[ Env([2,1,2,1]/4,[0.1,0.1,0.8]*1) ]
			],inf),
			\fdelta, Pseg(Pseq([0.0001,0.1],inf),8*2),
			\env3freq, 1*~t,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\hpfr, ~pmodenv.(Pseq([1,2,1,4],inf), 1),
			\octave, 6,
			\lag, 0.04,
			//\out, BusDef(\sendbus2, \audio),
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \hifm,
			\note, Pseq([
				Pseq([
					3,2,1,3,2,1,3,2,
				],6),
				Pseq([
					3,2,1,3,2,1,3,2,
				],2)-1,
			],inf)+Pswitch1(
				Prand([0,7],inf).stutter(Pwhite(4,8))!8,
				Pseq((0..7),inf),
			),
			\out, BusDef(\sendbus2, \audio),
			\pantab, Ptuple([
				Pseg(Pseq([-1,1],inf),8),
				Pseg(Pseq([1,0,-1],inf),5),
			]),
			\octave, Pswitch1(
				Prand([5,6],inf).stutter(Pwhite(4,8))!8,
				Pseq((0..7),inf),
			),
			\dur, 1/8,
			\amp, 0.1 * Pswitch1(
				Pseg(Pwhite(0,1/2,inf),Pwhite(4,8.0))!8,
				Pseq((0..7),inf),
			),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1581].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\out, BusDef(\fxbus1, \audio),
			\out, BusDef(\sendbus1, \audio),
			\dur, 1/16,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1581].value,
			\isRest, Pseq([
				Prand([
					Pseq([
						0,1,0,
					],1),
					Pseq([
						1,0,0,0,0,0,
					],1),
					Pseq([
						1,1,0,
					],1),
				],1),
			],inf).coin.not,
			\out, BusDef(\fxbus1, \audio),
			\dur, 1/4,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("s")].value,
			\bufnum, ~buflib.clap[361].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
			\legato,2,
			\dur, 1/8,
			\pan, 1,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("s")].value,
			\bufnum, ~buflib.clap[358].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\out, BusDef(\fxbus1, \audio),
			\legato,2,
			\dur, 1/8,
			\pan, 1,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("s")].value,
			\bufnum, ~buflib.clap[353].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\out, BusDef(\fxbus1, \audio),
			\legato,2,
			\dur, 1/8,
			\pan, 1,
			\gain, 0.21,
		),
		Pmono(\fx_echo,
			\addAction, \addToTail,
			\lag, 0.0005,
			\decay, 1/~t ,
			\delay, Pseq([
				Pwhite(1,16,1)
			],inf)*1/16/~t,
			\inbus, BusDef(\fxbus1, \audio),
			//\out, BusDef(\sendbus1, \audio),
			\mix, 0.5,
			\dur, 1/2,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[518].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Prand([
					Pseq([
						1,0,1,0, 1,1,1,1, 
					],1),
					Pseq([
						1,0,1,0, 1,0,1,0, 
					],1),
					Pseq([
						1,1,1,1, 1,1,1,1,
					],1),
					Pseq([
						0,0,0,0,
					],1),
					Pseq([
						1,1,1,1,
					],1),
					Pseq([
						1,0,0,1,0,0,1,0,
					],1),
					Pseq([
						1,0,1,0,0,1,0,0,
					],1),
					Pseq([
						1,0,0,1,0,1,0,0,
					],1),
				],inf),
			],inf).coin.not,
			\sustain,2,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1362].value,
			\isRest, Pseq([
				Prand([
					Pseq([
						1,0,1,0,1,0,1,0,
					],1),
					Pseq([
						1,0,1,1,0,1,1,0,
					],1),
					Pseq([
						1,1,1,1, 1,1,1,1,
					],1),
					Pseq([
						1,0,0,1,0,1,0,0,
					],1),
				],inf),
			],inf).coin.not,
			\sustain, 1.2,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \hifm,
			\note, Pseq([
				Pseq([
					3,2,1,3,2,1,3,2,
				],6),
				Pseq([
					3,2,1,3,2,1,3,2,
				],2)-1,
			],inf)+Pswitch1(
				Prand([0,7],inf).stutter(Pwhite(4,8))!8,
				Pseq((0..7),inf),
			),
			\out, BusDef(\sendbus2, \audio),
			\pantab, Ptuple([
				Pseg(Pseq([-1,1],inf),8),
				Pseg(Pseq([1,0,-1],inf),5),
			]),
			\octave, Pswitch1(
				Prand([5,6],inf).stutter(Pwhite(4,8))!8,
				Pseq((0..7),inf),
			),
			\dur, 1/8,
			\amp, 0.1 * Pswitch1(
				Pseg(Pwhite(0,1/2,inf),Pwhite(4,8.0))!8,
				Pseq((0..7),inf),
			),
		),
		
	])
)).play;
);



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
SynthDef(\bouly2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env2 = EnvGen.ar(\env2.kr(Env([0,1,0],[1.001,1.08])), Impulse.ar(\imp2f.kr(1/4)));
	env1 = EnvGen.ar(\env1.kr(Env([0,1,0],[0.001,0.08])), Impulse.ar(\imp1f.kr(100) * env2));
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(\oscmix.kr(0.5)*2, [sig1, sig2, sig3] * env1);
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
SynthDef(\boulyharm2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var fratio;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env2 = EnvGen.ar(\env2.kr(Env([0,1,0],[1.001,1.08])), Impulse.ar(\imp2f.kr(1/4)));
	env1 = EnvGen.ar(\env1.kr(Env([0,1,0],[0.001,0.08])), Impulse.ar(\imp1f.kr(100) * env2));
	fratio = freq/2 * [1,2,3,4,5,6] * \harmtab.kr([1,1,1, 1,1,1]);
	sig = (SinOsc.ar(fratio) * LFNoise1.ar(Rand(0.3,4)!6).range(0,1) * 0.8).mean * env1;
	sig = RLPF.ar(sig, \lpfr.kr(5.1) * freq * (env2 * 0.5 +1), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, Pseq([\bouly,\boulyharm,\boulyharm2],inf),
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
			\imp1f, Ptuple(Pexprand(1,800.0,inf)!4),
			\dur, 2,
			\out, BusDef(\fxbus3, \audio),
			\amp, 0.1,
		),
		Pmono(\fx_rlpf,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\fxbus3, \audio),
			\out, BusDef(\fxbus4, \audio),
			\rq, 0.01,
			\lpf, ~pmodenv.(Pseq([110.1,1400],inf), 8, 1),
			\mix, 0.71,
			\gain, 1,
			\dur, 1,
		),
		Pmono(\fx_limiter,
			\addAction, \addToTail,
			\lag, 0.0006,
			\inbus, BusDef(\fxbus4, \audio),
			\level, 0.1,
			\limdur, 0.001,
			\dur, 1,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1581].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
			\out, BusDef(\fxbus1, \audio),
			\dur, 1/16,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1231].value,
			\isRest, Pseq([
				Prand([
					Pseq([
						0,1,0,
					],1),
					Pseq([
						1,0,0,0,0,0,
					],1),
					Pseq([
						1,1,0,
					],1),
				],1),
			],inf).coin.not,
			\out, BusDef(\fxbus1, \audio),
			\dur, 1/4,
			\gain, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("s")].value,
			\bufnum, ~buflib.clap[361].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
			\legato,2,
			\dur, 1/8,
			\pan, 1,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("s")].value,
			\bufnum, ~buflib.clap[358].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\out, BusDef(\fxbus1, \audio),
			\legato,2,
			\dur, 1/8,
			\pan, 1,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("s")].value,
			\bufnum, ~buflib.clap[353].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\out, BusDef(\fxbus1, \audio),
			\legato,2,
			\dur, 1/8,
			\pan, 1,
			\gain, 0.21,
		),
		Pmono(\fx_echo,
			\addAction, \addToTail,
			\lag, 0.0005,
			\decay, Pwhite(0.3,6)/~t ,
			\delay, Pseq([
				Pwhite(1,16,1)
			],inf)*1/16/~t,
			\inbus, BusDef(\fxbus1, \audio),
			//\out, BusDef(\sendbus1, \audio),
			\mix, 0.5,
			\dur, 1/2,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[518].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Prand([
					Pseq([
						1,0,1,0, 1,1,1,1, 
					],1),
					Pseq([
						1,0,1,0, 1,0,1,0, 
					],1),
					Pseq([
						1,1,1,1, 1,1,1,1,
					],1),
					Pseq([
						0,0,0,0,
					],1),
					Pseq([
						1,1,1,1,
					],1),
					Pseq([
						1,0,0,1,0,0,1,0,
					],1),
					Pseq([
						1,0,1,0,0,1,0,0,
					],1),
					Pseq([
						1,0,0,1,0,1,0,0,
					],1),
				],inf),
			],inf).coin.not,
			\sustain,2,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
			\gain, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, Pseq([\bouly],inf),
			\env1, Pseq([
				[ Env([0,1,0],[0.001,0.08]) ],
			],inf),
			\env2, Pseq([
				~pEnv.(Pwhite(0.0,1,inf)!3,Pwhite(0.001,2)),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(1.1,0.1,0.8,3.1) ],
			],inf),
			\note, Pseq([
				0,0,2,2,
			],inf).stutter(4) + Pbrown(-8,8, 1),
			\octave, 6,
			\lpfr, ~pmodenv.(Pwhite(0.61,1.4,inf), Pwhite(0.4,6.0)),
			\imp1f, Pexprand(10,20.0,inf),
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, Pseq([\boulyharm2,\boulyharm],inf),
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
			\imp1f, Ptuple(Pexprand(1,800.0,inf)!4),
			\dur, 2,
			\amp, 0.1,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1581].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
			\out, BusDef(\fxbus1, \audio),
			\dur, 1/16,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1231].value,
			\isRest, Pseq([
				Prand([
					Pseq([
						0,1,0,
					],1),
					Pseq([
						1,0,0,0,0,0,
					],1),
					Pseq([
						1,1,0,
					],1),
				],1),
			],inf).coin.not,
			\out, BusDef(\fxbus1, \audio),
			\dur, 1/4,
			\gain, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("s")].value,
			\bufnum, ~buflib.clap[361].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
			\legato,2,
			\dur, 1/8,
			\pan, 1,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("s")].value,
			\bufnum, ~buflib.clap[358].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\out, BusDef(\fxbus1, \audio),
			\legato,2,
			\dur, 1/8,
			\pan, 1,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("s")].value,
			\bufnum, ~buflib.clap[353].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\out, BusDef(\fxbus1, \audio),
			\legato,2,
			\dur, 1/8,
			\pan, 1,
			\gain, 0.21,
		),
		Pmono(\fx_echo,
			\addAction, \addToTail,
			\lag, 0.0005,
			\decay, Pwhite(0.3,6)/~t ,
			\delay, Pseq([
				Pwhite(1,16,1)
			],inf)*1/16/~t,
			\inbus, BusDef(\fxbus1, \audio),
			//\out, BusDef(\sendbus1, \audio),
			\mix, 0.5,
			\dur, 1/2,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[518].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Prand([
					Pseq([
						1,0,1,0, 1,1,1,1, 
					],1),
					Pseq([
						1,0,1,0, 1,0,1,0, 
					],1),
					Pseq([
						1,1,1,1, 1,1,1,1,
					],1),
					Pseq([
						0,0,0,0,
					],1),
					Pseq([
						1,1,1,1,
					],1),
					Pseq([
						1,0,0,1,0,0,1,0,
					],1),
					Pseq([
						1,0,1,0,0,1,0,0,
					],1),
					Pseq([
						1,0,0,1,0,1,0,0,
					],1),
				],inf),
			],inf).coin.not,
			\sustain,2,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
			\gain, 0.1,
		),
		
	])
)).play;
);

///////////////////////////////////

