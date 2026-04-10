
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
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pfindur(32,Pdef(\sec1)),
			Pfindur(16,Pdef(\break1)),
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
