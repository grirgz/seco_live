
// inspir de sun88
~t = 154/2/60; TempoClock.default.tempo = ~t;

(
SynthDef(\formantbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.01,4.8]), 1);
	env2 = EnvGen.kr(Env([1,3,1],[0.01,4.8]), 1);
	env3 = EnvGen.kr(Env([0,1.0,0],[0.01,1.8]), 1);
	//sig = LFSaw.ar(freq);
	//sig = Formant.ar(freq, freq/4*env1, freq * ( SinOsc.ar(freq/2) * env3 + 1 ) );
	sig = Formant.ar(freq , \formfreq.kr(10) * env2* ((0..7)/7 - 0.5 * \fspread.kr(1.1102) + 1), \bwfreq.kr(100) * env1 );
	//sig = sig * ( Pulse.ar(freq/4) * 0.5 + 1 );
	//sig = RLPF.ar(sig, [ \lpf.kr(800), \lpf2.kr(1400) ], \rq.kr(0.5)).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\formantbass2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[1.1,4.8]), 1);
	env2 = EnvGen.kr(Env([1,3,1],[0.4,4.8]), 1);
	env3 = EnvGen.kr(Env([0,1.0,0],[0.4,1.8]), 1);
	//sig = LFSaw.ar(freq);
	//sig = Formant.ar(freq, freq/4*env1, freq * ( SinOsc.ar(freq/2) * env3 + 1 ) );
	sig = Formant.ar(freq , \formfreq.kr(10) * env2* ((0..7)/7 - 0.5 * \fspread.kr(1.1102) + 1), \bwfreq.kr(100) * env1 );
	//sig = sig * ( Pulse.ar(freq/4) * 0.5 + 1 );
	//sig = RLPF.ar(sig, [ \lpf.kr(800), \lpf2.kr(1400) ], \rq.kr(0.5)).mean;
	sig = HPF.ar(sig, \hpf.kr(40));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\funfmbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[0.01,0.8], -2), 1);
	mod2 = SinOsc.ar(freq) * 2 * env1;
	mod1 = SinOsc.ar(freq * [1,1.01], mod2) * 4;
	sig = SinOsc.ar(freq, mod1);
	sig = LPF.ar(sig, \lpf.kr(1000));
	sig = sig + SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.2), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\funfm1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var modEnv3 = EnvGen.kr(Env([1,0.3,0.1,0],[0.4,0.5,0.8], 2), 1);
	var modEnv2 = EnvGen.kr(Env([1,0.3,1,0],[0.1,3.1,0.8], -2), 1);
	var modEnv1 = EnvGen.kr(Env([0,0.3,1,0],[1.1,2.1,0.8], 2), 1);
	var mod3 = LFCub.ar(freq * [1,1.01] * \mratio3.kr( 4 )) * freq * \index3.kr(0.5) * ( modEnv3+0 );
	var mod2 = LFCub.ar(freq * \mratio2.kr( 1/2 ) + mod3) * freq * \index2.kr(2) * modEnv2;
	var mod = SinOsc.ar(freq * \mratio.kr( 1/2 ) + mod3) * freq * \index.kr(1) * modEnv1;
	sig = SinOsc.ar(freq * [1.01,1]* \cratio.kr(1) + mod + mod2);
	sig = sig + LFCub.ar(freq * \cratio2.kr(1/2) + mod3,mul:0.5);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\funfmpiano, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = Pulse.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.05) + 1)) * 1000; 
	//mod1 = mod1.tanh;
	mod1 = LPF.ar(mod1, \lpf.kr(1300));
	sig = SinOsc.ar(freq + mod1);
	sig = sig * SinOsc.ar(freq * 1/2,mul:0.3,add:1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.2)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\glass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * [1,2,1.01]).mean;
	sig = sig + SinOsc.ar(freq/2, mul: XLine.kr(1,0.001,0.05));
	sig = sig * \distamp.kr(1);
	sig = sig.tanh;
	sig = Resonz.ar(sig, \cutoff.kr(300));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1224].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1733].value,
			\bufnum, ~buflib.snare[20].value,
			\bufnum, ~buflib.snare[1872].value,
			//\bufnum, ~buflib.snare[723].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\sec1, 
	Ppar([
		Pbind(
			\instrument, \funfmbass,
			\note, Pseq([
				4,4,11-12,10-12,
			],inf).stutter(8),
			\octave, 3,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.01) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1224].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],30),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1733].value,
			\bufnum, ~buflib.snare[20].value,
			\bufnum, ~buflib.snare[1872].value,
			//\bufnum, ~buflib.snare[723].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],30),
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \glass,
			\note, Pstep(Pseq([
				4,7,6,7,
				4,7,11,10,
			],inf),1),
			\dur, 1/8,
			\cutoff, Pseg(Pseq([100,3001],inf),8*4,\exp),
			\distamp, Pseq([
				40,20,1,5,
			],inf),
			\isRest, Pseq([
				0,0,1,1, 0,0,1,1,
				1,0,1,1, 0,0,1,1,
				1,0,1,1, 1,0,1,1,
				1,1,0,1, 1,0,1,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		Ptpar([
			16, Pbind(
				\instrument, \funfmpiano,
				\note, Pseq([
					7,6,
					7,6,
					7,6,
					7,-2,
				],inf),
				\octave, 6,
				\dur, 1,
				\pan, Pwhite(-1,1,inf) * 0.4,
				\amp, 0.071,
			),
		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[23].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\sec2, 
	Ppar([
		Pbind(
			\instrument, \funfmbass,
			\note, Pseq([
				4,7,
				0,4,
				11-12,
				11,
				10-12,
				10,
			],inf).stutter(4),
			\octave, 3,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.01) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1224].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1243].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1733].value,
			\bufnum, ~buflib.snare[20].value,
			\bufnum, ~buflib.snare[1872].value,
			//\bufnum, ~buflib.snare[723].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,1,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[23].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					4,\r,7,
				],29),
				\r,6,\r,
			],inf),
			\envamt, Pseg(Pseq([1,4,11],inf),8),
			\lpf, 100 * Pseg(Pseq([1,3],inf),8*4),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1 * Pseq([
				Pfin(29,Ppatlace([
					0,0,1,
				],inf)),
				0,1,0,
				Pfin(29,Ppatlace([
					Pseg(Pseq([0,1],inf),8),0,1,
				],inf)),
				0,1,0,
				Pfin(29,Ppatlace([
					1,0,1,
				],inf)),
				0,1,0,
			],inf),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\break1, 
	Ppar([
		
		Pbind(
			\instrument, \fmnap,
			\note, [4,7,11,4+12],
			\dur, Pn(4,1),
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1224].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1733].value,
			\bufnum, ~buflib.snare[20].value,
			\bufnum, ~buflib.snare[1872].value,
			//\bufnum, ~buflib.snare[723].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Ptpar([
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.clap[41].value,
				//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
					],6),
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11 * Pseq([
					Pseg(Pseq([0,0,0,0,1]+0.01,1),2,\exp).loop,
				],inf),
			),
			4,Pbind(
				\instrument, \funfm1,
				\note, Pseq([
					Pser([
						4
					],7*4),
					Pser([
						-2,
					],4),
				],inf),
				\octave, 4,
				\dur, 1/8,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			8,Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1187].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
					1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11 * Pseq([
					0.5,0.1,1,0.2,
				],inf),
			),
		]),

	])
)).play;
);

(
Pdef(\part, Pdef(\sec3, 
	Ppar([
		
		Pbind(
			\instrument, \fmnap,
			\note, [4,7,11,4+12],
			\dur, Pn(4,1),
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1224].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1733].value,
			\bufnum, ~buflib.snare[20].value,
			\bufnum, ~buflib.snare[1872].value,
			//\bufnum, ~buflib.snare[723].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Ptpar([
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.clap[41].value,
				//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
					],14),
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11 * Pseq([
					Pseg(Pseq([0,0,0,0,1]+0.01,1),2,\exp).loop,
				],inf),
			),
			0,Pbind(
				\instrument, \funfm1,
				\note, Pseq([
					Pser([
						4
					],7*4),
					Pser([
						-2,
					],4),
				],inf),
				\octave, 4,
				\dur, 1/8,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			0,Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1187].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
					1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11 * Pseq([
					0.5,0.1,1,0.2,
				],inf),
			),
		]),

	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			//Pfindur(32,Pdef(\sec1)),
			Pfindur(16,Pdef(\break1)),
			Pfindur(16,Pdef(\sec3)),
			Pfindur(32,Pdef(\sec1)),
			Pfindur(32,Pdef(\sec2)),
		],1),
	])
)).play;
);

(
SynthDef(\fmnap, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = SinOsc.ar(freq * [1,1.2,1.4,1.5]* LFNoise1.kr(0.1!4,mul:0.1,add:1)) * LFNoise1.kr(0.1!4,mul:1.8,add:1) * EnvGen.kr(Env([0,1,0],[0.1,0.8]), 1);
	mod1 = SinOsc.ar(freq * [1,1.02,1.04,1.05]* LFNoise1.kr(0.1!4,mul:0.1,add:1)) * LFNoise1.kr(0.1!4,mul:1.8,add:1) * EnvGen.kr(Env([0,1,0],[1.1,5]), 1);
	sig = SinOsc.ar(freq, mod1 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
SynthDescLib.at(\fmnap).controlDict

Synth(\default)

/////
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \formantbass2,
			\degree, Pseq([0],inf),
			\note, Pseq([
				4,4,11-12,10-12,
			],inf).stutter(8),
			//\bwfreq, PmodEnv(Pseq([10,100],1), 8,\exp).loop,
			\bwfreq, Pseq([100,120,150,200],inf),
			\formfreq, PmodEnv(Pseq([10,100,800],1), 8,\exp).loop,
			\formfreq, Pseq([30,35,50],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.42,0.5,0.1,1) ],
			],inf),
			//\lag, ( 1/4 ) * ( 3/4 )/~t,
			\isRest, Pseq([
				1,0,0,1,0,0,1,0,
			],inf).coin.not,
			\isRest, Pseq([
				1,1,0,1,0,0,1,0,
				1,0,0,1,1,0,1,0,
				1,0,1,1,0,0,1,0,
				1,0,0,1,0,0,1,1,
			],inf).coin.not,
			\legato, 1.2,
			\dur, 1/8,
			\amp, 0.1,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1224].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1733].value,
			\bufnum, ~buflib.snare[20].value,
			\bufnum, ~buflib.snare[1872].value,
			//\bufnum, ~buflib.snare[723].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1189].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				1,0,1,0, 0,0,1,0,
				0,1,1,0, 0,0,1,0,
				0,0,1,1, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.08 * Pseq([
				0.5,0.5,1,0.5,
			],inf),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					4,7,11,12,
					11,7,4,7,
				],1),
				4,7,10,12,
				10,7,4,7,
			],inf),
			\dur, 1/4,
			\amp, 0.1/2 * Pseq([
				Ppatlace(  [
					Pseg([ 0.3,0.9 ],8*2),Pseg([1,1,1,0.3],9).loop,
				] )
			],inf),
			\saw, Pseg(Pseq([0,0.1,1],inf),10),
			\lpf, Pseg(Pseq([300,3001],inf),8,\exp),
			\adsr, Pseq([
				PpatEnv.adsr(Pseg([0.1,0.01],8).loop,0.1,0.8,Pseg([0.1,1.01,0.01],8).loop),
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,0,1,1,
				1,1,1,1, 1,1,1,0,
				1,1,1,0, 1,1,1,1,
				1,1,1,1, 1,1,1,0,
			],inf).coin.not,
			//\isRest, true,
			\out, BusDef(\mel, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\mel, \audio),
			\delay, 1/8/~t,
			\diffadd, 0.01 * Pseg(Pseq([0,1,8],inf),8),
			//\diffmul, 1.5,
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0.3,
			\gain, 0.7,
			\dur, 1,
		),
	])
)).play;
);

////////// from sun45


(
	ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			{ arg gate=1, amp=0.1, pan=0, freq=200;
				var sig;
				var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
				sig = 3.collect { arg idx;
					var ifreq = freq + ( idx/1000 );
					var oscmix = SinOsc.kr(1/2*~t + ( idx/1000 )).unipolar;
					//oscmix = 0;
					sig1 = LFSaw.ar(ifreq);
					sig2 = LFPulse.ar(ifreq+1);
					sig3 = SinOsc.ar(ifreq+2);
					SelectX.ar(oscmix*2, [sig1, sig2, sig3]);
				};
				sig = HPF.ar(sig, 20) * 2;
				sig = sig.mean;
				sig = LPF.ar(sig, freq*2);
				sig = LeakDC.ar(sig);
				sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.3)), gate, doneAction:2);
				sig = Pan2.ar(sig, pan, amp);
			}.asDefName,
			\note, Pstep(Pseq([
				0,-1,
			],inf),4)+4,
			\octave, 3,
			\dur, Pn(1,inf),
			\amp, 0.1,
		),

		Pmono(
			{ arg gate=1, amp=0.1, pan=0, freq=200;
				var sig;
				var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
				sig = 13.collect { arg idx;
					var ifreq = freq + ( idx/1000 );
					var oscmix = SinOsc.kr(1/2*~t + ( idx/1000 )).unipolar;
					//oscmix = 0;
					sig1 = LFSaw.ar(ifreq);
					sig2 = LFPulse.ar(ifreq+1);
					sig3 = SinOsc.ar(ifreq+2);
					SelectX.ar(oscmix*2, [sig1, sig2, sig3]);
				};
				//sig = sig.mean;
				sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
				sig = LPF.ar(sig, freq*5);
				sig = HPF.ar(sig, 20) * 1/3;
				sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
				sig = LeakDC.ar(sig);
				//sig = Pan2.ar(sig, pan, amp);
			}.asDefName,
			\note, Pstep(Pseq([
				[0,4,7,12+7],
				[-1,4,7,12+7],
			],inf),4)+16,
			\octave, 3,
			\dur, 1,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/3,
			//\isRest, true,
		),
		Ptpar([
			16,Pbind(
				\instrument, \default,
				\note, Pstep(Pseq([
					[-1,4] +.x [-12,0,12],
					[-1,3] +.x [-12,0,12],
				],inf),4),
				\octave, 6,
				\legato, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,1.1) ],
				],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1/2,
				\lag, -0.04,
				//\out, BusDef(\sendbus2, \audio),
			),
		]),

	])
)).play;
);

(
SynthDef(\monobass1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(1/4*~t); 
	lfo2 = SinOsc.ar(1/8*~t); 
	lfo3 = SinOsc.ar(1*~t); 
	lfo4 = SinOsc.ar(2/12*~t); 
	lfo5 = SinOsc.ar(1/16*~t); 
	mod1 = SelectX.ar( SinOsc.kr(1/2*~t).range(0,1), SinOsc.ar(freq*[1/4,4])) *134 *lfo3 * lfo4;
	mod2 = SinOsc.ar(freq) * 100 * lfo2;
	mod3 = LPF.ar(Pulse.ar(freq * [1,1.01] + mod2).bipolar, 300* ( lfo5 *0.7 + 1 ));
	mod4 = SelectX.ar( SinOsc.kr(1/2*~t).range(0,1), SinOsc.ar(freq*[1/2,2], mod1)) *44;
	sig = SinOsc.ar(freq + mod4 , mod3).bipolar;
	sig = RLPF.ar(sig, \lpf.kr(1100) * ( lfo2 *0.2 + 1 ), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = HPF.ar(sig, \hpf.kr(200));
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\monobass1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(1/4*~t); 
	lfo2 = SinOsc.ar(1/8*~t); 
	lfo3 = SinOsc.ar(1*~t); 
	lfo4 = SinOsc.ar(2/12*~t); 
	lfo5 = SinOsc.ar(1/16*~t); 
	mod1 = SelectX.ar( SinOsc.kr(1/2*~t).range(0,1), SinOsc.ar(freq*[1/4,4])) *34 *lfo3 * lfo4;
	mod2 = SinOsc.ar(freq*2) * 10 * lfo2;
	mod3 = LPF.ar(Pulse.ar(freq * [1,1.01] + mod2).bipolar, 300* ( lfo5 *0.7 + 1 ));
	mod4 = SelectX.ar( SinOsc.kr(1/2*~t).range(0,1), SinOsc.ar(freq*[1/2,2], mod1)) *44;
	sig = SinOsc.ar(freq + mod2 + mod3).bipolar;
	sig = sig + LFCub.ar(freq*2+ mod1 , mod4);
	sig = RLPF.ar(sig, \lpf.kr(410) * ( lfo2 *0.2 + 1 ), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = HPF.ar(sig, \hpf.kr(200));
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\monobass2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(1/4*~t, pi/2) * 0.2; 
	mod2 = SinOsc.ar(freq * [0.9999,1,1.001]) * 4 * ( lfo1 + 1 );
	mod1 = SinOsc.ar(freq/2 * [0.9999,1,1.001], mod2) * 2;
	sig = SinOsc.ar(freq * mod1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.2), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1224].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1733].value,
			\bufnum, ~buflib.snare[20].value,
			\bufnum, ~buflib.snare[1872].value,
			//\bufnum, ~buflib.snare[723].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1189].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				1,0,1,0, 0,0,1,0,
				0,1,1,0, 0,0,1,0,
				0,0,1,1, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.5,1,0.5,
			],inf),
		),
		
		Pmono(
			\monobass2,
			\note, Pstep(Pseq([
				0,-1,
			],inf),4)+4,
			\octave, 3,
			\dur, Pn(2,inf),
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\monobass1,
			\note, Pstep(Pseq([
				[0,4,7,12+7],
				[-1,4,7,12+7],
			],inf),4)+16,
			\octave, 3,
			\dur, 2,
			\lpf, PmodEnv(Pseq([400,240,100],1), 8*2,\exp).loop,
			\amp, 0.1/2,
			//\isRest, true,
			\out, BusDef(\basstrack, \audio),
		),

		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.021,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.2,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\monobass, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\monobass, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([100,2140],1), 8,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),

		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					0,4,7,0,
					0,4,7,0,
					0,4,4,0,
					0,7,4,0,
				],8*4),
				Pser([
					-1,4,7,-1,
					-1,4,-1,4,
					-1,4,7,-1,
					-1,7,4,-1,
				],8*4),
			],inf),
			\root, 4,
			\octave, 5,
			\isRest, Pseq([
				1
				//0,0,1,0, 0,0,1,0,
				//0,0,1,0, 0,0,1,1,
				//0,0,1,0, 0,0,1,0,
				//1,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\lpf, 200,
			\envamt, 4,
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				0.3,
				1,
			],inf),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				7,9,7,11, 0,4,11,7,
			],inf),
			\root, 4,
			\octave, 5,
			\isRest, Pseq([
				0,0,1,0, 1,1,0,1,
				1,1,0,0, 0,0,1,0,
				//0,0,1,0, 0,0,1,1,
				//0,0,1,0, 0,0,1,0,
				//1,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\lpf, 200,
			\envamt, 4,
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				0.7,
				0.7,
				1,
			],inf),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1224].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1733].value,
			\bufnum, ~buflib.snare[20].value,
			\bufnum, ~buflib.snare[1872].value,
			//\bufnum, ~buflib.snare[723].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1189].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				1,0,1,0, 0,0,1,0,
				0,1,1,0, 0,0,1,0,
				0,0,1,1, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.5,1,0.5,
			],inf),
		),
		
		Pmono(
			\monobass2,
			\note, Pstep(Pseq([
				0,-1,
			],inf),4)+4,
			\octave, 3,
			\dur, Pn(2,inf),
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\monobass1,
			\note, Pstep(Pseq([
				[0,4,7,12+7],
				[-1,4,7,12+7],
			],inf),4)+16,
			\octave, 3,
			\dur, 2,
			\lpf, PmodEnv(Pseq([400,240,100],1), 8*2,\exp).loop,
			\amp, 0.1/2,
			//\isRest, true,
			\out, BusDef(\basstrack, \audio),
		),

		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.021,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.2,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\monobass, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\monobass, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([100,2140],1), 8,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),

		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					0,4,7,0,
					0,4,7,0,
					0,4,4,0,
					0,7,4,0,
				],8*4),
				Pser([
					-1,4,7,-1,
					-1,4,-1,4,
					-1,4,7,-1,
					-1,7,4,-1,
				],8*4),
			],inf),
			\root, 4,
			\octave, 5,
			\isRest, Pseq([
				1
				//0,0,1,0, 0,0,1,0,
				//0,0,1,0, 0,0,1,1,
				//0,0,1,0, 0,0,1,0,
				//1,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\lpf, 200 * Pseg(Pseq([4,2,1],inf),8*2,\exp),
			\envamt, 4,
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				0.3,
				1,
			],inf),
			\out, BusDef(\mel, \audio),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				7,9,7,12, 0,4,12,7,
				7,9,7,11, 0,4,11,7,
			],inf),
			\root, 4,
			\octave, 6,
			\isRest, Pseq([
				0,0,1,0, 1,1,0,1,
				1,1,0,0, 0,0,1,0,
				//0,0,1,0, 0,0,1,1,
				//0,0,1,0, 0,0,1,0,
				//1,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\lpf, 200 * Pseg(Pseq([1,4],inf),8*2,\exp),
			\envamt, 4,
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				0.7,
				0.7,
				1,
			],inf),
			\out, BusDef(\mel, \audio),
		),
		Pmono(\fx_echodiff,
			\delay, 1/7/~t,
			\decay, 2/~t,
			\inbus, BusDef(\mel, \audio),
			\mix, 0.2,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\mel1, \audio),
			\isRest, true,
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\mel, \audio),
			\out, BusDef(\mel1, \audio),
			\mix, 0.3,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\mel1, \audio),
			\addAction, \addToTail,
			\lpf, PmodEnv(Pseq([1,2,1,4]*2000,1), 8).loop,
			\hpf, PmodEnv(Pseq([1,2,1,4]*1000,1), 8).loop,
			\lag, 0.0009,
			\gain, 0.5,
			\dur, 1,
		),
		Pmono(\monopiano,
			\note, Pseq([
				Pser([0,4,7,12+7], 8*2), Pser([0,4,7,12+7,0], 8*2),
				Pser([-1,4,-1,7, -1,4,7,-1], 8*2),
				Pser([-1,7,-1, -1,4,7,-1], 8*2),
				//Pseq([0,4,7,12+7], 8),
				//Pseq([-1+12,4,-1,12+7]),
			],inf)+16,
			\octave, 5,
			\dur, 1/8,
			\hpf, PmodEnv(Pseq([4240,400,10100],1), 8*2,\exp).loop,
			\amp, 0.1/2,
			\out, BusDef(\arp, \audio),
			//\isRest, true,
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\arp, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0.3,
			\grain, 0.5,
			\dur, 1,
		),
	])
)).play;
);


(
SynthDef(\monopiano, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = SinOsc.ar(1/8.1*~t) * 1000; 
	env2 = SinOsc.ar(1/9.1*~t) * 100; 
	//env1 = 1000;
	//freq = freq.lag(0.01);
	mod1 = LFSaw.ar(freq * [1,1.01]) * env1;
	mod1 = BPF.ar(mod1, SinOsc.ar(1/8 * ~t).exprange(10,8000),0.1 );
	mod2 = SinOsc.ar(freq) * env2;
	sig = SinOsc.ar(freq + mod1);
	sig = sig + SinOsc.ar(freq/2 + mod2);
	sig = SelectX.ar(0.5, [sig, sig.fold2(0.5)]);
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
