
// these: each track should use the 3 waveforms, sin saw and pulse, the make at least 3 synthdef

(
// sin with fm
SynthDef(\doublefm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,2400],[0.1,0.8]), 1);
	mod2 = SinOsc.ar(freq) * 10 * env1;
	mod1 = SinOsc.ar(freq + mod2) * 100;
	sig = SinOsc.ar(freq + mod1);
	sig = sig + SinOsc.ar(freq+1 + mod2)/2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\pulse, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = LFPulse.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.02) + 1)).bipolar;
	env1 = EnvGen.kr(\lpenv.kr(Env([0,1,0],[0.1,0.8])), 1);
	sig = RLPF.ar(sig, \lpf.kr(1000) * (env1 * \lpenvamt.kr(3.2) + 1), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[237].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.08,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1337].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[197].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				Pser([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],8*7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[198].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				Pser([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,1,0,0,
				],8*7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \doublefm,
			\note, Pseq([
				0,0,3,-7,
				0,0,-1,5,
			],inf),
			\adsr, Pseq([
				PpatEnv.adsr(0.1,0.1,0.8, Pseg(Pseq([0.1,1],inf),32)),
			],inf),
			\legato, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],7),
				8,0,0,0, 0,0,0,0,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,5
			],inf).stutter(32*2),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \pulse,
			\note, Pseq([
				[0,5],
				[7,5],
			],inf).stutter(32*2),
			\octave, 6,
			\adsr, Pseq([
				Pser([
					[ Env.adsr(0.1,0.1,0.8,0.3) ],
				],32),
				Pser([
					[ Env.adsr(0.1,0.1,0.8,0.3) ],
					[ Env.adsr(0.1,0.1,0.8,0.03) ],
					[ Env.adsr(0.1,0.1,0.8,0.73) ],
				],32),
			],inf),
			\lpenvamt, Pseg(Pseq([1,11],1),32).loop,
			\dur, 1/8,
			\amp, 0.1/4,
			\out, BusDef(\pul, \audio),
		),
		Pmono(\fx_flanger,
			\inbus, BusDef(\pul, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\pul2, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\pul2, \audio),
			\addAction, \addToTail,
			\lpf, 20000,
			\hpf, 2000,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[237].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.08,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1337].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[197].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				Pser([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],8*7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[198].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				Pser([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,1,0,0,
				],8*7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \doublefm,
			\note, Pseq([
				0,0,3,-7,
				0,0,-1,5,
			],inf),
			\adsr, Pseq([
				PpatEnv.adsr(0.1,0.1,0.8, Pseg(Pseq([0.1,1],inf),32)),
			],inf),
			\legato, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],7),
				8,0,0,0, 0,0,0,0,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,5
			],inf).stutter(32*2),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \pulse,
			\note, Pstep(Pseq([
				[0,3,7],
				[2,5,10],
				//[7,5],
			],inf),4*2),
			\octave, 6,
			\adsr, Pseq([
				Pser([
					[ Env.adsr(0.1,0.1,0.8,0.3) ],
				],32),
				Pser([
					[ Env.adsr(0.1,0.1,0.8,0.3) ],
					[ Env.adsr(0.1,0.1,0.8,0.03) ],
					[ Env.adsr(0.1,0.1,0.8,0.73) ],
				],32),
			],inf),
			\lpenvamt, Pseg(Pseq([1,11],1),32).loop,
			\dur, 2,
			\amp, 0.1/4,
			\out, BusDef(\pul, \audio),
		),
		Pmono(\fx_flanger,
			\inbus, BusDef(\pul, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

(
SynthDef(\pulsepad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = SinOsc.ar(freq/2) * \mod1a.kr(40);
	sig1 = LFPulse.ar(freq + mod1 * ((0..7)/7 - 0.5 * \fspread.kr(0.02) + 1)).bipolar;
	sig2 = LFPulse.ar(freq/2 + mod1 * ((0..7)/7 - 0.5 * \fspread.kr(0.02) + 1)).bipolar;
	sig3 = LFPulse.ar(freq + mod1) * EnvGen.kr(Env([0,1,0],[0.01,0.08]), Impulse.kr((freq % 4 )));
	sig = sig1 + ( sig2 * 0.3) + sig3  /2;
	env1 = EnvGen.kr(\lpenv.kr(Env([0,1,0],[0.4,1.8])), 1);
	sig = RLPF.ar(sig, \lpf.kr(1000) * (env1 * \lpenvamt.kr(3.2) + 1), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \pulsepad,
			\note, Pstep(Pseq([
				[0,3,7],
				[2,5,10],
				//[7,5],
			],inf),4*2),
			\octave, 6,
			\fspread, 0.00123,
			\adsr, Pseq([
				[ Env.adsr(1.1,0.1,0.8,2.3) ],
			],inf),
			\lpenvamt, Pseg(Pseq([1,11],1),32).loop,
			\dur, 2,
			\amp, 0.1/4,
			//\out, BusDef(\pul, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \pulsepad,
			\note, Pseq([
				Pser([0,3,7],16*4),
				Pser([2,5,10],16*4),
			],inf),
			\octave, 6,
			\fspread, Pseg(Pseq([0.001,0.05],1),4).loop,
			\adsr, Pseq([
				[ Env.adsr(1.1,0.1,0.8,4/~t) ],
			],inf),
			\lpenvamt, Pseg(Pseq([1,11],1),32).loop,
			\mod1a, Pseg(Pseq([1,10,300],inf),32,\exp),
			\dur, 1/8,
			\amp, 0.1/4,
			\out, BusDef(\pul, \audio),
		),
		Pbind(
			\instrument, \sawe,
			\note, Pseq([
				Prand([0,3,7,9,3+12,-12]),
			],inf),
			\octave, 7,
			\dur, Prand(1/(1..8),inf),
			\amp, 0.1/8,
			\lpf, Pseg(Pseq([1000,5001],1),32,\exp).loop,
			\sustain, 0.1,
			\out, BusDef(\pul, \audio),
		),
		Pmono(\fx_freeverb2fil,
			\inbus, BusDef(\pul, \audio),
			\addAction, \addToTail,
			\room, 2,
			\lpf, 20000,
			\hpf, PmodEnv(Pseq([1,100,2000],1), Pseq([24,8]), \exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

(
SynthDef(\sawe, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = LFSaw.ar(freq);
	env1 = EnvGen.kr(\lpenv.kr(Env([0,1,0],[0.1,0.8])), 1);
	sig = RLPF.ar(sig, \lpf.kr(1000) * (env1 * \lpenvamt.kr(3.2) + 1), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sawe,
			\note, Pseq([
				Prand([0,3,7,9]),
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/2,
		),
	])
)).play;
);


(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = Impulse.ar(50);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
SynthDef(\impfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,4,2,1/2],[0.1,0.1,0.8]), 1);
	mod1 = Impulse.ar(freq/2 * env1) * 4140 * env1;
	sig = SinOsc.ar(freq + mod1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \impfm,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \impfm,
			\note, Pseq([
				[0,3,7],
				[0,3,7]+5,
			],inf),
			\octave, 5,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind
	])
)).play;
);
