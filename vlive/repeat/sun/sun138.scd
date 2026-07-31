

// follow dnb tuto

(
~t = 170/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("sndlib/synthbasic.scd");
)

///////// draft

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[401].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1800].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Nervous 2.wav'),
			\bufnum, BufDef.stereo('vbreaks/Bernard Purdie - Funky Donkey (part3).wav'),
			\legato, 1,
			\st, 177/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0,1),4).loop + Pseq([
				Pser([ 
					0,0,0,0, 0,0,0,0, 
					0,0,-6*2,0, -4,0,0,0, 
					0,0,0,0, 0,0,0,0, 
					0,0,-6*2,0, -10,0,0,1, 
					0,0,0,0, 0,0,0,0, 
					0,0,-6*2,0, 0,0,0,0, 
					0,0,0,0, 0,0,0,0, 
					0,0,-6*2,0, 4,0,0,1, 
				],8*8),
				//Pseq([ 0,0,0,0, 0,0,0,0, ],4),
			]/16,inf) / Pkey(\st),
			\legato, Pseq([
				1,0,1,0, 1,0,1,1,
				0,0,1,0, 1,1,0,1,
				1,0,1,0, 0,1,1,1,
				1,0,1,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\dur, 1/8,
			\gain, 1/8* Pseq([
				1,1,1,1, 4,1,1,1,
				1,1,4,1, 1,1,1,1,
				1,1,1,1, 4,1,1,1,
				1,1,4,1, 4,1,1,1,
			]/4,inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Michael Viner\'s Incredible Bongo Band - Sing Sing (part2).wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/8 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				0, 1,
			]+0,1),8).loop * Pkey(\bufdur),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\loopa, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\loopa, \audio),
			\addAction, \addToTail,
			\hpf, 1000,
			\lpf, 7000,
			\hpf, PmodEnv(Pseq([1000,4000,200],1), 8,\exp).loop,
			\lpf, PmodEnv(Pseq([7000,12000],1), 8,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[139].value,
			\bufnum, ~buflib.hat[1718].value,
			\bufnum, ~buflib.hat[1501].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\legato, Pseq([
				1,0,1,0, 1,1,0,1,
				2,0,1,0, 1,0,1,0,
				1,0,1,0, 8,0,0,0,
				1,0,2,0, 1,0,1,0,
			],inf)*0.5,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Melvin Bliss - Synthetic Substitution.wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/8 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				0, 1,
			]+0,1),4).loop * Pkey(\bufdur),
			\dur, 1/4,
			\gain, 1/8,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Melvin Bliss - Synthetic Substitution.wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/8 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				0, 1,
			]+0,1),4).loop * Pkey(\bufdur),
			\dur, 1/8,
			\gain, 1/8,
		),
	])
)).play;
);

(
// with bass
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[401].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1800].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Nervous 2.wav'),
			\bufnum, BufDef.stereo('vbreaks/Bernard Purdie - Funky Donkey (part3).wav'),
			\legato, 1,
			\st, 177/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0,1),4).loop + Pseq([
				Pser([ 
					0,0,0,0, 0,0,0,0, 
					0,0,-6*2,0, -4,0,0,0, 
					0,0,0,0, 0,0,0,0, 
					0,0,-6*2,0, -10,0,0,1, 
					0,0,0,0, 0,0,0,0, 
					0,0,-6*2,0, 0,0,0,0, 
					0,0,0,0, 0,0,0,0, 
					0,0,-6*2,0, 4,0,0,1, 
				],8*8),
				//Pseq([ 0,0,0,0, 0,0,0,0, ],4),
			]/16,inf) / Pkey(\st),
			\legato, Pseq([
				1,0,1,0, 1,0,1,1,
				0,0,1,0, 1,1,0,1,
				1,0,1,0, 0,1,1,1,
				1,0,1,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\dur, 1/8,
			\gain, 1/8* Pseq([
				1,1,1,1, 4,1,1,1,
				1,1,4,1, 1,1,1,1,
				1,1,1,1, 4,1,1,1,
				1,1,4,1, 4,1,1,1,
			]/4,inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Michael Viner\'s Incredible Bongo Band - Sing Sing (part2).wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/8 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				0, 1,
			]+0,1),8).loop * Pkey(\bufdur),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\loopa, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\loopa, \audio),
			\addAction, \addToTail,
			\hpf, 1000,
			\lpf, 7000,
			\hpf, PmodEnv(Pseq([1000,4000,200],1), 8,\exp).loop,
			\lpf, PmodEnv(Pseq([7000,12000],1), 8,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[139].value,
			\bufnum, ~buflib.hat[1718].value,
			\bufnum, ~buflib.hat[1501].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\legato, Pseq([
				1,0,1,0, 1,1,0,1,
				2,0,1,0, 1,0,1,0,
				1,0,1,0, 8,0,0,0,
				1,0,2,0, 1,0,1,0,
			],inf)*0.5,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \foghorn,
			\note, Pseq([
				5,5,4,4,
			],inf).stutter(8),
			\legato, Pseq([
				0,0,0,0, 6,0,0,0,
				0,0,6,0, 0,0,0,0,
				16,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				Pser([
					0
				],32),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \downbass,
			\note, Pseq([
				3,
			],inf),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 28,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\ffac, Plazy({ arg ev;
				if(ev[\legato] > 0) {
					PnoteEnv([7,0,0].midiratio,[2,4]/~t).keep(1)
				} {
					1
				};
			}).loop,
			//\ffac, 1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);


////////////// other ideas


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.hat[1847].value,
			\lpf, Pseq([2e4,5500],inf),
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,0,1,0,
				1,0,1,0, 1,1,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Melvin Bliss - Synthetic Substitution.wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/16/2 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				0, 1,
			]+0,1),8).loop * Pkey(\bufdur),
			\dur, 1/8,
			\gain, 1/8,
		),
	])
)).play;
);

//////////// foghorn

(
SynthDef(\foghorn, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig1 = SinOsc.ar(freq);
	env2 = EnvGen.kr(Env([0,1,0],[1,1]), 1, timeScale:0.5);
	sig2 = SinOsc.ar(freq*31.midiratio) * env2;
	sig = [sig1, sig2].mean;
	sig = ( sig*\distamp.kr(5) ).tanh * \distpostamp.kr(1/2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \foghorn,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\dur, 2,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\foghorn, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig1 = SinOsc.ar(freq);
	env2 = EnvGen.kr(Env([0,1,0],[0.1,0.5]), 1, timeScale:1);
	sig2 = SinOsc.ar(freq*31.midiratio) * env2;
	sig = [sig1, sig2].mean;
	sig = ( sig*\distamp.kr(15) ).tanh * \distpostamp.kr(1/2);
	sig = sig + ( SinOsc.ar(freq) * 1.4 );
	sig = sig /2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \foghorn,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\dur, 2,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\foghorn, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = SinOsc.ar(freq) * EnvGen.kr(Env([0.1,2000,1],[0.4,0.8]), 1);
	sig1 = SinOsc.ar(freq+mod1);
	env2 = EnvGen.kr(Env([0,1,0],[1,1]), 1, timeScale:0.5);
	sig2 = SinOsc.ar(freq*31.midiratio) * env2;
	sig = [sig1, sig2].mean;
	sig = ( sig*\distamp.kr(5) ).tanh * \distpostamp.kr(1/2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\foghorn, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = SinOsc.ar(freq) * EnvGen.kr(Env([0.1,2000,1],[0.4,0.8]), 1);
	mod1 = mod1 + ( SinOsc.ar(freq*1.01) * EnvGen.kr(Env([0.1,2000,1],[3.4,0.8]), 1) );
	sig1 = SinOsc.ar(freq+mod1);
	env2 = EnvGen.kr(Env([0,1,0],[1,1]), 1, timeScale:0.5);
	sig2 = SinOsc.ar(freq*31.midiratio) * env2;
	sig = [sig1, sig2].mean;
	sig = ( sig*\distamp.kr(5) ).tanh * \distpostamp.kr(1/2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\foghorn, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = SinOsc.ar(freq) * EnvGen.kr(Env([0.1,200,1],[0.4,0.8]), 1);
	mod1 = mod1 + ( SinOsc.ar(freq*1.0005) * EnvGen.kr(Env([0.1,2000,1],[4.4,0.8]), 1) );
	sig1 = SinOsc.ar(freq/2+mod1);
	env2 = EnvGen.kr(Env([0,1,0],[1,1]), 1, timeScale:0.5);
	sig2 = SinOsc.ar(freq*31.midiratio) * env2;
	sig = [sig1, sig2].mean;
	sig = ( sig*\distamp.kr(5) ).tanh * \distpostamp.kr(1/2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\foghorn, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = SinOsc.ar(freq) * EnvGen.kr(Env([0.1,200,1],[0.4,0.8]), 1);
	mod1 = mod1 + ( SinOsc.ar(freq*Rand(1,1.05)) * EnvGen.kr(Env([0.1,2000,1],[4.4,0.8]), 1) );
	sig1 = SinOsc.ar(freq/2+mod1);
	env2 = EnvGen.kr(Env([0,1,0],[1,1]), 1, timeScale:0.5);
	sig2 = SinOsc.ar(freq*31.midiratio) * env2;
	sig = [sig1, sig2].mean;
	sig = ( sig*\distamp.kr(5) ).tanh * \distpostamp.kr(1/2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

/////// down bass
(
SynthDef(\downbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = freq * \ffac.kr(1);
	sig = LFSaw.ar(freq);
	env1 = EnvGen.kr(\lpenv.kr(Env([0,1,0],[0.1,0.8])), 1);
	sig = RLPF.ar(sig, \lpf.kr(1000) * (env1 * \lpenvamt.kr(3.2) + 1), \rq.kr(0.5));	
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \downbass,
			\note, Pseq([
				3,
			],inf),
			\ffac, PnoteEnv([0,-12].midiratio,[2/~t]),
			\octave, 3,
			\dur, 2,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\downbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	freq = freq * \ffac.kr(1);
	mod1 = SinOsc.ar(freq/2)  * EnvGen.kr(Env([10,10000,0],[30.1,0.8],2), 1);
	sig = LFSaw.ar(freq*[1,2]+mod1).mean;
	env1 = EnvGen.kr(\lpenv.kr(Env([0,1,0],[0.1,0.8])), 1);
	sig = RLPF.ar(sig, \lpf.kr(1000) * (env1 * \lpenvamt.kr(3.2) + 1), \rq.kr(0.5));	
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\downbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	freq = freq * \ffac.kr(1);
	mod1 = SinOsc.ar(freq/2)  * EnvGen.kr(Env([10,10000,0],[30.1,0.8],2), 1);
	sig = LFSaw.ar(freq*[1,1 * Rand(1,1.01)]+mod1).mean;
	env1 = EnvGen.kr(\lpenv.kr(Env([0,1,0],[0.1,0.8])), 1);
	sig = RLPF.ar(sig, \lpf.kr(1000) * (env1 * \lpenvamt.kr(3.2) + 1), \rq.kr(0.5));	
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
//////////

