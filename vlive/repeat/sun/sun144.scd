
// some sound design

~t = 180/2/60; TempoClock.default.tempo = ~t;

(
SynthDef(\padno, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 5;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr(Env.adsr(8.1,0.1,0.8,3.1)), gate, doneAction:0);
	mod1 = SinOsc.ar(freq * LFNoise1.kr(0.1!num,mul:\fjit.kr(0.01),add:1)) * env1 * 2;
	mod2 = SinOsc.ar(freq * 2 * LFNoise1.kr(0.1!num,mul:\fjit.kr(0.01),add:1)) * env1 * 2 * LFNoise1.kr(0.1!num).unipolar;
	mod3 = SinOsc.ar(freq / 2 * LFNoise1.kr(0.1!num,mul:\fjit.kr(0.01),add:1)) * env1 * 2 * LFNoise1.kr(0.1!num).unipolar;
	sig = SinOsc.ar(freq * LFNoise1.kr(0.1!num,mul:\fjit.kr,add:1) + mod1 + mod2 + mod3);
	sig1 = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = SelectX.ar(\distmix.kr(0.5), [sig, sig1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1.1,0.1,0.8,3.4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\leadno, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var moddet=\moddet.kr(5);
	mod1 = SinOsc.ar(\modf1.kr(1*~t), add:-0.5, mul:\modm.kr(2)).clip(0,1) * ( moddet.midiratio-1 ) + 1;
	mod2 = SinOsc.ar(\modf2.kr(4*~t),pi/2).clip(0,1) * ( moddet.midiratio-1 ) + 1;
	mod3 = LFSaw.ar(freq) * 740 * mod2;
	sig1 = LFPulse.ar(freq * mod1 + mod2) * 1;
	sig2 = SinOsc.ar(freq + mod3);
	sig = [sig1,sig2].mean;
	sig = RLPF.ar(sig, \lpf.kr(4100), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bassno, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod2 = SinOsc.ar(freq*4) * \moda2.kr(480) * SinOsc.ar(1*~t);
	mod1 = SinOsc.ar(freq + mod2) * \moda.kr(180) * SinOsc.ar(2*~t);
	sig = SinOsc.ar(freq + mod1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\wuw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var isig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[2.1,0.8]), 1);
	sig = [1/2,1,2].collect { arg ffac;
		mod1 = SinOsc.ar(freq * LFNoise1.ar(0.1!5,mul:0.1,add:1)) * 1000 * env1;
		mod2 = SinOsc.ar(freq + mod1) * 17; 
		isig = SinOsc.ar(freq * ffac + mod2) * [0.1,1,0.1];
	};
	sig = sig * [0.2,1,0.2];
	sig = sig.sum;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

///////////////////////////////


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \padno,
			\note, Pseq([
				[-4, -1, 3],
				[-4, -1, 4],
				[-5, -1, 4],
				[-6, -1, 3],
			],inf),
			\dur, 4,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \leadno,
			\note, Pseq([
				3,-1,-1,3,2,
			],inf),
			\modm, 1.1,
			\moddet, 2,
			\modf1, 2*~t * Pseq([1,1,1,1,3],inf),
			\legato, 1,
			\octave, 6,
			\dur, 1/8,
			\dur, 4,
			\dur, Pseq([4,4,4,3,1],inf),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \leadno,
			\note, Pseq([
				-4,4,-1,-6,-5,
			],inf),
			\legato, 1,
			\octave, 5,
			\dur, 1/8,
			\dur, 4,
			\dur, Pseq([4,4,4,3,1],inf),
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1078].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[151].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[843].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \bassno,
			\note, Pseq([
				3,-1,-1,3,2,
			],inf),
			\modm, 1.1,
			\moddet, 2,
			\modf1, 2*~t * Pseq([1,1,1,1,3],inf),
			\legato, 1,
			\moda, PmodEnv(Pseq([81,200,400],1), 8,\exp).loop,
			\moda2, PmodEnv(Pseq([81,200,400],1), 32,\exp).loop,
			\octave, 3,
			\dur, 1/8,
			\dur, 4,
			\dur, Pseq([4,4,4,3,1],inf),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \padno,
			\note, Pseq([
				[-4, -1, 3],
				[-4, -1, 4],
				[-5, -1, 4],
				[-6, -1, 3],
			],inf),
			\dur, 4,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \leadno,
			\note, Pseq([
				3,-1,-1,3,2,
			],inf),
			\modm, 1.1,
			\moddet, 2,
			\modf1, 2*~t * Pseq([1,1,1,1,3],inf),
			\legato, 1,
			\octave, 6,
			\dur, 1/8,
			\dur, 4,
			\dur, Pseq([4,4,4,3,1],inf),
			\amp, 0.1/1.5,
		),
		Pbind(
			\instrument, \leadno,
			\note, Pseq([
				-4,4,-1,-6,-5,
			],inf),
			\legato, 1,
			\octave, 5,
			\dur, 1/8,
			\dur, 4,
			\dur, Pseq([4,4,4,3,1],inf),
			\amp, 0.1/1.5,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \wuw,
			\note, Pseq([
				-4,4,-1,-6,-5,
			],inf),
			\legato, 0.1,
			\octave, 6,
			\dur, 1/8,
			\dur, 4,
			\dur, Pseq([4,4,4,3,1],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,2.1) ],
			],inf),
			\amp, 0.1/1.5,
			\out, BusDef(\fil, \audio),
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\fil, \audio),
			\addAction, \addToTail,
			\lpf, ~pmodsynth.({ SinOsc.ar(2*~t) * 0.9 + 1 * 2800 }),
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
			\instrument, \padno,
			\note, Pseq([
				[-4, -1, 3],
				[-4, -1, 4],
				[-5, -1, 4],
				[-6, -1, 3],
			],inf),
			\dur, 4,
			\amp, 0.1/4,
			\out, BusDef(\fil, \audio),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4/~t) ],
			],inf),
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\fil, \audio),
			\addAction, \addToTail,
			\lpf, ~pmodsynth.({ SinOsc.ar(1*~t) * 0.7 + 1 * 2800 }),
			\rq, 0.8,
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
			\instrument, \padno,
			\note, Pseq([
				[-4, -1, 3],
				[-4, -1, 4],
				[-5, -1, 4],
				[-6, -1, 3],
			],inf),
			\dur, 4,
			\amp, 0.1/4,
			\out, BusDef(\cfil, \audio),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4/~t) ],
			],inf),
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\cfil, \audio),
			\addAction, \addToTail,
			\lpf, ~pmodsynth.({ SinOsc.ar(1*~t) * 0.7 + 1 * 2800 }),
			\rq, 0.8,
			\lag, 0.0009,
			\dur, 1,
		),

		Pbind(
			\instrument, \wuw,
			\note, Pseq([
				-4,4,-1,-6,-5,
			],inf),
			\legato, 0.1,
			\octave, 6,
			\dur, 1/8,
			\dur, 4,
			\dur, Pseq([4,4,4,3,1],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,2.1) ],
			],inf),
			\amp, 0.1/1.5,
			\out, BusDef(\fil, \audio),
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\fil, \audio),
			\addAction, \addToTail,
			\lpf, ~pmodsynth.({ SinOsc.ar(2*~t) * 0.9 + 1 * 2800 }),
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
			\instrument, \padno,
			\note, Pseq([
				[-4, -1, 3],
				[-4, -1, 4],
				[-5, -1, 4],
				[-6, -1, 3],
			],inf),
			\dur, 4,
			\amp, 0.1/4,
			\out, BusDef(\cfil, \audio),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4/~t) ],
			],inf),
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\cfil, \audio),
			\addAction, \addToTail,
			\lpf, ~pmodsynth.({ SinOsc.ar(1*~t) * 0.7 + 1 * 2800 }),
			\rq, 0.8,
			\lag, 0.0009,
			\dur, 1,
		),

		Pbind(
			\instrument, \wuw,
			\note, Pseq([
				-6,-1,3,4, -1,-1,-6,-5,
				-6,-1,4,3, -1,-1,-6,-5,
			],inf),
			\legato, 0.1,
			\octave, 6,
			\dur, 1/8,
			\dur, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,2.1) ],
			],inf),
			\isRest, Pseq([
				0,1, 0,1, 0,1, 0,1,
				1,1, 0,1, 0,1, 0,1,
			],inf).coin.not,
			\amp, 0.1/1.5,
		),
		Pbind(
			\instrument, \leadno,
			\note, Pseq([
				3,2,1,-1,-3,
			],inf),
			\modm, 1.1,
			\moddet, 2,
			\modf1, 2*~t * Pseq([1,1,1,1,3],inf),
			\legato, 1,
			\octave, 6,
			\lpf, PmodEnv(Pseq([100,2000],1), 32,\exp).loop,
			\dur, 1/8,
			\dur, 4,
			\dur, Pseq([4,4,4,3,1]/2,inf),
			\amp, 0.1/1.5,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \padno,
			\note, Pseq([
				[-4, -1, 3],
				[-4, -1, 4],
				[-5, -1, 4],
				[-6, -1, 3],
			],inf),
			\dur, 4,
			\amp, 0.1/4,
			\out, BusDef(\cfil, \audio),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4/~t) ],
			],inf),
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\cfil, \audio),
			\addAction, \addToTail,
			\lpf, ~pmodsynth.({ SinOsc.ar(2*~t) * 0.7 + 1 * 2800 }),
			\rq, 0.8,
			\lag, 0.0009,
			\dur, 1,
		),

		Pbind(
			\instrument, \wuw,
			\note, Pseq([
				-6,-1,3,4, -1,-1,-6,-5,
				-6,-1,4,3, -1,-1,-6,-5,
			],inf),
			\legato, 0.1,
			\octave, 6,
			\dur, 1/8,
			\dur, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,2.1) ],
			],inf),
			\isRest, Pseq([
				0,1, 0,1, 0,1, 0,1,
				1,1, 0,1, 0,1, 0,1,
			],inf).coin.not,
			\amp, 0.1/1.5,
		),
		Pbind(
			\instrument, \leadno,
			\note, Pseq([
				3,2,1,-1,-3,
			],inf),
			\modm, 1.1,
			\moddet, 2,
			\modf1, 2*~t * Pseq([1,1,1,1,3],inf),
			\legato, 1,
			\octave, 6,
			\lpf, PmodEnv(Pseq([100,2000],1), 32,\exp).loop,
			\dur, 1/8,
			\dur, 4,
			\dur, Pseq([4,4,4,3,1]/2,inf),
			\amp, 0.1/1.5,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1078].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[151].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[159].value,
			\bufnum, ~buflib.hat[1806].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[843].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1311].value,
			\bufnum, ~buflib.hat[1882].value,
			\bufnum, ~buflib.hat[1053].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,1,0,0, 0,1,0,0,
				],6),
				Pseq([
					1,1,1,1, 1,1,1,1,
				],2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1053].value,
			\bufnum, ~buflib.hat[1882].value,
			\bufnum, ~buflib.hat[1311].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,1, 0,0,0,1,
				],7),
				Pseq([
					1,1,1,1, 1,1,1,1,
				],1),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \bassno,
			\note, Pseq([
				3,-1,-1,3,2,
			],inf),
			\modm, 1.1,
			\moddet, 2,
			\modf1, 2*~t * Pseq([1,1,1,1,3],inf),
			\legato, 1,
			\moda, PmodEnv(Pseq([81,200,400],1), 8,\exp).loop,
			\moda2, PmodEnv(Pseq([81,200,400],1), 32,\exp).loop,
			\octave, 3,
			\dur, 1/8,
			\dur, 4,
			\dur, Pseq([4,4,4,3,1],inf),
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \padno,
			\note, Pseq([
				[-4, -1, 3],
				[-4, -1, 4],
				[-5, -1, 4],
				[-6, -1, 3],
			],inf),
			\dur, 4,
			\amp, 0.1/4,
			\out, BusDef(\cfil, \audio),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4/~t) ],
			],inf),
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\cfil, \audio),
			\addAction, \addToTail,
			\lpf, ~pmodsynth.({ SinOsc.ar(2*~t) * 0.7 + 1 * 2800 }),
			\rq, 0.8,
			\lag, 0.0009,
			\dur, 1,
		),

		Pbind(
			\instrument, \wuw,
			\note, Pseq([
				-6,-1,3,4, -1,-1,-6,-5,
				-6,-1,4,3, -1,-1,-6,-5,
			],inf),
			\legato, 0.1,
			\octave, 6,
			\dur, 1/8,
			\dur, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,2.1) ],
			],inf),
			\isRest, Pseq([
				0,1, 0,1, 0,1, 0,1,
				1,1, 0,1, 0,1, 0,1,
			],inf).coin.not,
			\amp, 0.1/1.5,
		),
		Pbind(
			\instrument, \leadno,
			\note, Pseq([
				3,2,1,-1,-3,
			],inf),
			\modm, 1.1,
			\moddet, 2,
			\modf1, 2*~t * Pseq([1,1,1,1,3],inf),
			\legato, 1,
			\octave, 6,
			\lpf, PmodEnv(Pseq([100,2000],1), 32,\exp).loop,
			\dur, 1/8,
			\dur, 4,
			\dur, Pseq([4,4,4,3,1]/2,inf),
			\amp, 0.1/1.5,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1078].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[151].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Ptpar([
			16, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[159].value,
				\bufnum, ~buflib.hat[1806].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[843].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11/2,
			),
			32, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1311].value,
				\bufnum, ~buflib.hat[1053].value,
				\bufnum, ~buflib.hat[1882].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pseq([
						0,1,0,0, 0,1,0,0,
					],6),
					Pseq([
						1,1,1,1, 1,1,1,1,
					],2),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			24, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1053].value,
				\bufnum, ~buflib.hat[1882].value,
				\bufnum, ~buflib.hat[1311].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pseq([
						0,0,0,1, 0,0,0,1,
					],7),
					Pseq([
						1,1,1,1, 1,1,1,1,
					],1),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),

		]),
		Pbind(
			\instrument, \bassno,
			\note, Pseq([
				3,-1,-1,3,2,
			],inf),
			\modm, 1.1,
			\moddet, 2,
			\modf1, 4*~t * Pseq([1,1,1,1,3],inf),
			\modf2, 2*~t * Pseq([1,1,1,1,3],inf),
			\legato, 1,
			//\moda, PmodEnv(Pseq([400],1), 8,\exp).loop,
			//\moda2, PmodEnv(Pseq([401],1), 32,\exp).loop,
			\moda, 400,
			\moda2, PmodEnv(Pseq([400,800,2000,4000],1), 16,\exp).loop,
			\octave, 3,
			\dur, 1/8,
			\dur, 4,
			\dur, Pseq([4,4,4,3,1],inf),
			\amp, 0.1,
		),
	])
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1078].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[151].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
		Pbind(
			\instrument, \padno,
			\note, Pseq([
				[-4, -1, 3],
				[-4, -1, 4],
				[-5, -1, 4],
				[-6, -1, 3],
			],inf),
			\dur, 4,
			\amp, 0.1/4,
			\out, BusDef(\cfil, \audio),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4/~t) ],
			],inf),
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\cfil, \audio),
			\addAction, \addToTail,
			\lpf, ~pmodsynth.({ SinOsc.ar(1*~t) * 0.7 + 1 * 2800 }),
			\rq, 0.8,
			\lag, 0.0009,
			\dur, 1,
		),

		Pbind(
			\instrument, \wuw,
			\note, Pseq([
				-4,4,-1,-6,-5,
			],inf),
			\legato, 0.1,
			\octave, 6,
			\dur, 1/8,
			\dur, 4,
			\dur, Pseq([4,4,4,3,1],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,2.1) ],
			],inf),
			\amp, 0.1/1.5,
			\out, BusDef(\fil, \audio),
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\fil, \audio),
			\addAction, \addToTail,
			\lpf, ~pmodsynth.({ SinOsc.ar(2*~t) * 0.9 + 1 * 2800 }),
			\lag, 0.0009,
			\dur, 1,
		),

		Pbind(
			\instrument, \bassnono,
			\note, Pseq([
				Pseq([ -4,-1, ],4),
				Pseq([ -4,4, ],4),
				Pseq([ -5,4, ],4),
				//Pseq([ -6,3, ],4),
				-6,3,-6,2,1,-1,-6,3,
			],inf).stutter(Pseq([6,2],inf)),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				PpatEnv.adsr(0.01,0.1,0.8, Pseg(Pseq([0.1,0.2,0.01],inf),8))
			],inf),
			\legato, 0.4,
			\moda, PmodEnv(Pseq([10,200],1), 32).loop,
			\dur, 1/8,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\amp, 0.2,
		),
	])
)).play;
);

(
SynthDef(\bassnono, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = SinOsc.ar(freq)  *\moda.kr(110);
	sig = LFPulse.ar(freq + mod1);
	sig = RLPF.ar(sig, \lpf.kr(700), \rq.kr(0.5));
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
			\bufnum, ~buflib.kick[1078].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[151].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
		Pbind(
			\instrument, \padno,
			\note, Pseq([
				[-4, -1, 3],
				[-4, -1, 4],
				[-5, -1, 4],
				[-6, -1, 3],
			],inf),
			\dur, 4,
			\amp, 0.1/4,
			\out, BusDef(\cfil, \audio),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4/~t) ],
			],inf),
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\cfil, \audio),
			\addAction, \addToTail,
			\lpf, ~pmodsynth.({ SinOsc.ar(1*~t) * 0.7 + 1 * 2800 }),
			\rq, 0.8,
			\lag, 0.0009,
			\dur, 1,
		),

		Pbind(
			\instrument, \wuw,
			\note, Pseq([
				-4,4,-1,-6,-5,
			],inf),
			\legato, 0.1,
			\octave, 6,
			\dur, 1/8,
			\dur, 4,
			\dur, Pseq([4,4,4,3,1],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,2.1) ],
			],inf),
			\amp, 0.1/1.5,
			\out, BusDef(\fil, \audio),
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\fil, \audio),
			\addAction, \addToTail,
			\lpf, ~pmodsynth.({ SinOsc.ar(2*~t) * 0.9 + 1 * 2800 }),
			\lag, 0.0009,
			\dur, 1,
		),

		Pbind(
			\instrument, \bassnono,
			\note, Pseq([
				Pseq([ -4,-1, ],4),
				Pseq([ -4,4, ],4),
				Pseq([ -5,4, ],4),
				//Pseq([ -6,3, ],4),
				-6,3,-6,2,1,-1,-6,3,
			],inf).stutter(Pseq([6,2],inf)),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				PpatEnv.adsr(0.01,0.1,0.8, Pseg(Pseq([0.1,0.2,0.01],inf),8))
			],inf),
			\legato, 0.4,
			\moda, PmodEnv(Pseq([10,200],1), 32).loop,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,1,0, 1,1,0,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
				0,1,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\amp, 0.2,
		),
	])
)).play;
);

(
SynthDef(\sonarno, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([0.7,1,1],[0.012,0.8]), 1);
	env2 = EnvGen.kr(Env([0.5,1,0.1],[0.01,3.8]), 1);
	mod1 = SinOsc.ar(freq) * env2 * \moda.kr(100) * SinOsc.ar(2*~t,mul:0.8,add:1) ;
	sig = LFPulse.ar(freq * env1 + mod1);
	sig = RLPF.ar(sig, \lpf.kr(800) * env1, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,3.01)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1078].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[151].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
		Pbind(
			\instrument, \padno,
			\note, Pseq([
				[-4, -1, 3],
				[-4, -1, 4],
				[-5, -1, 4],
				[-6, -1, 3],
			],inf),
			\dur, 4,
			\amp, 0.1/4,
			\out, BusDef(\cfil, \audio),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4/~t) ],
			],inf),
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\cfil, \audio),
			\addAction, \addToTail,
			\lpf, ~pmodsynth.({ SinOsc.ar(1*~t) * 0.7 + 1 * 2800 }),
			\rq, 0.8,
			\lag, 0.0009,
			\dur, 1,
		),

		Pbind(
			\instrument, \wuw,
			\note, Pseq([
				-4,4,-1,-6,-5,
			],inf),
			\legato, 0.1,
			\octave, 6,
			\dur, 1/8,
			\dur, 4,
			\dur, Pseq([4,4,4,3,1],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,2.1) ],
			],inf),
			\amp, 0.1/1.5,
			\out, BusDef(\fil, \audio),
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\fil, \audio),
			\addAction, \addToTail,
			\lpf, ~pmodsynth.({ SinOsc.ar(2*~t) * 0.9 + 1 * 2800 }),
			\lag, 0.0009,
			\dur, 1,
		),

		Pbind(
			\instrument, \bassnono,
			\note, Pseq([
				Pseq([ -4,-1, ],4),
				Pseq([ -4,4, ],4),
				Pseq([ -5,4, ],4),
				//Pseq([ -6,3, ],4),
				-6,3,-6,2,1,-1,-6,3,
			],inf).stutter(Pseq([6,2],inf)),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				PpatEnv.adsr(0.01,0.1,0.8, Pseg(Pseq([0.1,0.2,0.01],inf),8))
			],inf),
			\legato, 0.4,
			\moda, PmodEnv(Pseq([10,200],1), 32).loop,
			\dur, 1/8,
			\isRest, Pseq([
				//1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,

			],inf).coin.not,
			\gamp, Pseg(Pseq([0.1,0.9,0.1,0.5],inf),8),
			\gamp2, Pseg(Pseq([0.1,0.9],inf),32),
			\amp, 0.2 * Pseq([
				Plazy({ arg ev;
					var gh = ev[\gamp];
					var gh2 = ev[\gamp2];
					Pseq([
						1,gh,0.8,gh2, 0.6,gh,1,gh2,
					],1)
				}).loop,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[195].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			//\speed, 0.7,
			\dur, 1/8,
			\sustain, Pseq([
				1,
				1,
				1,
				0.5,
			],inf)/10,
			\gain, 0.01 * Pseq([
				1,
				1,
				1,
				0.9,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.foley1[256].value,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\speed, Pseq([
				1,1.2,1,1, 1,1.2,1,1,
				1,1.2,1,1, 1,1.2,1,2,
			],inf).stutter(16),
			\dur, 1/8,
			\gain, 0.15,
			\out, BusDef(\verb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\verb, \audio),
			\addAction, \addToTail,
			\room, 4,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sonarno,
			\note, Pseq([
				-4,-1,-6
			],inf),
			\octave, 6,
			\dur, 1/8,
			\moda, Pseg(Pseq([1,100,200],inf),32),
			\lpf, Pseg(Pseq([200,8001],1),32,\exp).loop,
			\legato, 0.1,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				PpatEnv.adsr(0.1,0.1,0.8, Pseg(Pseq([0.1,3],inf),42))
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1 * Pseg(Pseq([1,1/3],1),32).loop,
			\out, BusDef(\verb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\verb, \audio),
			\addAction, \addToTail,
			\room, 4,
			\damp, 0.9,
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
			\instrument, \sonarno,
			\note, Pseq([
				-5,
			],inf),
			\octave, 6,
			\dur, 1/8,
			\moda, Pseg(Pseq([1,100],inf),32),
			\lpf, Pseg(Pseq([200,12001],1),32,\exp).loop,
			\legato, 0.1,
			\legato, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\out, BusDef(\verb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\verb, \audio),
			\addAction, \addToTail,
			\room, 4,
			\damp, 0.9,
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
			\bufnum, ~buflib.kick[1078].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[151].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \wuw,
			\note, Pseq([
				-4,4,-1,-6,-5,
			],inf),
			\legato, 0.1,
			\octave, 6,
			\dur, 1/8,
			\dur, 4,
			\dur, Pseq([4,4,4,3,1],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1/1.5,
			\out, BusDef(\fil, \audio),
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\fil, \audio),
			\addAction, \addToTail,
			\lpf, ~pmodsynth.({ SinOsc.ar(2*~t) * 0.9 + 1 * 2800 }),
			\lag, 0.0009,
			\dur, 1,
		),

		Pbind(
			\instrument, \bassnono,
			\note, Pseq([
				Pseq([ -4,-1, ],4),
				Pseq([ -4,4, ],4),
				Pseq([ -5,4, ],4),
				//Pseq([ -6,3, ],4),
				-6,3,-6,2,1,-1,-6,3,
			],inf).stutter(Pseq([6,2],inf)),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.51 * Pseq([
				1/2,1,1,1/2, 1/2,1,1,1/2,
			],inf),
			\moda, PmodEnv(Pseq([10,200],1), 32).loop,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,1,1, 1,0,1,1,
				//1,0,1,0, 1,0,1,0,

			],inf).coin.not,
			\gamp, Pseg(Pseq([0.1,0.9,0.1,0.5],inf),8),
			\gamp2, Pseg(Pseq([0.1,0.9],inf),32),
			\gamp3, Pseg(Pseq([0.1,0.7],inf),16),
			\amp, 0.2 * Pseq([
				Plazy({ arg ev;
					var gh = ev[\gamp];
					var gh2 = ev[\gamp2];
					var gh3 = ev[\gamp3];
					Pseq([
						gh3,gh,0.8,gh2, gh3,gh,1,gh2,
					],1)
				}).loop,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[195].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			//\speed, 0.7,
			\dur, 1/8,
			\sustain, Pseq([
				1,
				1,
				1,
				0.5,
			],inf)/10,
			\gain, 0.01 * Pseq([
				1,
				1,
				1,
				0.9,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.foley1[256].value,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\speed, Pseq([
				1,1.2,1,1, 1,1.2,1,1,
				1,1.2,1,1, 1,1.2,1,2,
			],inf).stutter(16),
			\dur, 1/8,
			\gain, 0.15,
			\out, BusDef(\verb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\verb, \audio),
			\addAction, \addToTail,
			\room, 4,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sonarno,
			\note, Pseq([
				-4,-1,-6
			],inf),
			\octave, 6,
			\dur, 1/8,
			\moda, Pseg(Pseq([1,100,200],inf),32),
			\lpf, Pseg(Pseq([200,8001],1),32,\exp).loop,
			\legato, 0.1,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\adsr, Pseq([
				PpatEnv.adsr(0.1,0.1,0.8, Pseg(Pseq([0.1,0.5],inf),42))
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1 * Pseg(Pseq([1,1/3],1),32).loop,
			\out, BusDef(\verb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\verb, \audio),
			\addAction, \addToTail,
			\room, 1,
			\damp, 0.9,
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
			\bufnum, ~buflib.kick[1078].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[151].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \wuw,
			\note, Pseq([
				-4,4,-1,-6,-5,
			],inf),
			\legato, 0.1,
			\octave, 6,
			\dur, 1/8,
			\dur, 4,
			\dur, Pseq([4,4,4,3,1],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1/1.5,
			\out, BusDef(\fil, \audio),
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\fil, \audio),
			\addAction, \addToTail,
			\lpf, ~pmodsynth.({ SinOsc.ar(2*~t) * 0.9 + 1 * 2800 }),
			\lag, 0.0009,
			\dur, 1,
		),

		Pbind(
			\instrument, \bassnono,
			\note, Pseq([
				Pseq([ -4,-1, ],4),
				Pseq([ -4,4, ],4),
				Pseq([ -5,4, ],4),
				//Pseq([ -6,3, ],4),
				-6,3,-6,2,1,-1,-6,3,
			],inf).stutter(Pseq([6,2],inf)),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.51 * Pseq([
				1/2,1,1,1/2, 1/2,1,1,1/2,
			],inf),
			\moda, PmodEnv(Pseq([10,200],1), 32).loop,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,1,1, 1,0,1,1,
				//1,0,1,0, 1,0,1,0,

			],inf).coin.not,
			\gamp, Pseg(Pseq([0.1,0.9,0.1,0.5],inf),8),
			\gamp2, Pseg(Pseq([0.1,0.9],inf),32),
			\gamp3, Pseg(Pseq([0.1,0.7],inf),16),
			\amp, 0.2 * Pseq([
				Plazy({ arg ev;
					var gh = ev[\gamp];
					var gh2 = ev[\gamp2];
					var gh3 = ev[\gamp3];
					Pseq([
						gh3,gh,0.8,gh2, gh3,gh,1,gh2,
					],1)
				}).loop,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[195].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			//\speed, 0.7,
			\dur, 1/8,
			\sustain, Pseq([
				1,
				1,
				1,
				0.5,
			],inf)/10,
			\gain, 0.01 * Pseq([
				1,
				1,
				1,
				0.9,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.foley1[256].value,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\speed, Pseq([
				1,1.2,1,1, 1,1.2,1,1,
				1,1.2,1,1, 1,1.2,1,2,
			],inf).stutter(16),
			\dur, 1/8,
			\gain, 0.15,
			\out, BusDef(\verb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\verb, \audio),
			\addAction, \addToTail,
			\room, 4,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sonarno,
			\note, Pseq([
				-4,-1,-6
			],inf),
			\octave, 6,
			\dur, 1/8,
			\moda, Pseg(Pseq([1,100,200],inf),32),
			\lpf, Pseg(Pseq([200,8001],1),32,\exp).loop,
			\legato, 0.1,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\adsr, Pseq([
				PpatEnv.adsr(0.1,0.1,0.8, Pseg(Pseq([0.1,0.5],inf),42))
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1 * Pseg(Pseq([1,1/3],1),32).loop,
			\out, BusDef(\verb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\verb, \audio),
			\addAction, \addToTail,
			\room, 1,
			\damp, 0.9,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, 0,
			\legato, 1,
			\dur, 4,
			\gain, 1,
			\out, BusDef(\vfil, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\vfil, \audio),
			\out, BusDef(\vfil1, \audio),
			\delay, PmodEnv(Pseq([1,2,1.1]/20,1), 2).loop,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_rlpfrhpf,
			\inbus, BusDef(\vfil1, \audio),
			\out, BusDef(\vfil2, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([5000,2000,4000],1), 2).loop,
			\lpf, PmodEnv(Pseq([500,2000,4000],4), 2.1).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\vfil2, \audio),
			\adsr, Pseq([
				[ Env.adsr(0.03,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4 * Prand([1,1/2],inf).stutter(8),
			\gain, 1 * Pseq([
				Ppatlace([
					1,1,
					Pseg(Pseq([0.5,1,0.3],inf),8),
					Pseg(Pwhite(0.3,1,inf),8),
				])
				
			],inf),
		),

	])
)).play;
);

(
SynthDef(\pulsedrone, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	lfo4 = EnvGen.kr(Env([1,1,12,1],[8,4.1,4.8]), 1);
	lfo3 = XLine.kr(1,10,16/~t);
	lfo2 = XLine.kr(1,100,16/~t);
	lfo1 = SinOsc.ar(8*~t) * 0.9 + 1 * 100 * lfo2; 
	mod1 = SinOsc.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.02) * lfo3 + 1)) * lfo1;
	sig = SinOsc.ar(freq + mod1);
	sig = Resonz.ar(sig, 300 * lfo4,0.5);
	sig = sig * LFPulse.ar(8*~t).unipolar.lag(0.01); 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1078].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[151].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \wuw,
			\note, Pseq([
				-4,4,-1,-6,-5,
			],inf),
			\legato, 0.1,
			\octave, 6,
			\dur, 1/8,
			\dur, 4,
			\dur, Pseq([4,4,4,3,1],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1/1.5,
			\out, BusDef(\fil, \audio),
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\fil, \audio),
			\addAction, \addToTail,
			\lpf, ~pmodsynth.({ SinOsc.ar(2*~t) * 0.9 + 1 * 2800 }),
			\lag, 0.0009,
			\dur, 1,
		),

		Pbind(
			\instrument, \bassnono,
			\note, Pseq([
				Pseq([ -4,-1, ],4),
				Pseq([ -4,4, ],4),
				Pseq([ -5,4, ],4),
				//Pseq([ -6,3, ],4),
				-6,3,-6,2,1,-1,-6,3,
			],inf).stutter(Pseq([6,2],inf)),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.51 * Pseq([
				1/2,1,1,1/2, 1/2,1,1,1/2,
			],inf),
			\moda, PmodEnv(Pseq([10,200],1), 32).loop,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,1,1, 1,0,1,1,
				//1,0,1,0, 1,0,1,0,

			],inf).coin.not,
			\gamp, Pseg(Pseq([0.1,0.9,0.1,0.5],inf),8),
			\gamp2, Pseg(Pseq([0.1,0.9],inf),32),
			\gamp3, Pseg(Pseq([0.1,0.7],inf),16),
			\amp, 0.2 * Pseq([
				Plazy({ arg ev;
					var gh = ev[\gamp];
					var gh2 = ev[\gamp2];
					var gh3 = ev[\gamp3];
					Pseq([
						gh3,gh,0.8,gh2, gh3,gh,1,gh2,
					],1)
				}).loop,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[195].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			//\speed, 0.7,
			\dur, 1/8,
			\sustain, Pseq([
				1,
				1,
				1,
				0.5,
			],inf)/10,
			\gain, 0.01 * Pseq([
				1,
				1,
				1,
				0.9,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.foley1[256].value,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\speed, Pseq([
				1,1.2,1,1, 1,1.2,1,1,
				1,1.2,1,1, 1,1.2,1,2,
			],inf).stutter(16),
			\dur, 1/8,
			\gain, 0.15,
			\out, BusDef(\verb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\verb, \audio),
			\addAction, \addToTail,
			\room, 4,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sonarno,
			\note, Pseq([
				-4,-1,-6
			],inf),
			\octave, 6,
			\dur, 1/8,
			\moda, Pseg(Pseq([1,100,200],inf),32),
			\lpf, Pseg(Pseq([200,8001],1),32,\exp).loop,
			\legato, 0.1,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\adsr, Pseq([
				PpatEnv.adsr(0.1,0.1,0.8, Pseg(Pseq([0.1,0.5],inf),42))
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1 * Pseg(Pseq([1,1/3],1),32).loop,
			\out, BusDef(\verb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\verb, \audio),
			\addAction, \addToTail,
			\room, 1,
			\damp, 0.9,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, 0,
			\legato, 1,
			\dur, 4,
			\gain, 1,
			\out, BusDef(\vfil, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\vfil, \audio),
			\out, BusDef(\vfil1, \audio),
			\delay, PmodEnv(Pseq([1,2,1.1]/20,1), 2).loop,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_rlpfrhpf,
			\inbus, BusDef(\vfil1, \audio),
			\out, BusDef(\vfil2, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([5000,2000,4000,400,4500],8), 2).loop,
			\lpf, PmodEnv(Pseq([500,2000,4000],4), 2.1).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\vfil2, \audio),
			\adsr, Pseq([
				[ Env.adsr(0.03,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4 * Prand([1,1/2],inf).stutter(8),
			\gain, 1 * Pseq([
				Ppatlace([
					1,1,
					Pseg(Pseq([0.5,1,0.3],inf),8),
					Pseg(Pwhite(0.3,1,inf),8),
				])
				
			],inf),
		),
		Pmono(\pulsedrone,
			\note, Pseq([
				0,
			],inf),
			\octave, 4,
			\dur, 1,
			\amp, 0.1,
		),

	])
)).play;
);
