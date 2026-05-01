
// try some funk idea
(
~t = 205/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				5,\r,\r,\r, 5,2,0,5,
				\r,5,2,0, 5,2,0,\r,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);


/////////////////
// now do anything

(
SynthDef(\bassbla, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	// sin into delay with lfo, xfade harms
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var lpenv;
	var delay;
	var lfoharms = [1,1/2,2,3,4];
	var delayharms = [1,2,1/2,1/3,1/4];
	//var lfoharms = [1,1,1];
	//var delayharms = [1,1,1];
	var voices;
	sig = SinOsc.ar(freq);

	voices = lfoharms.collect { arg lfoharm, idx;
		delayharms.collect { arg delayharm;
			var isig;
			delay = 1/freq * delayharm * \delayfac.kr(1);
			lfo1 = LFSaw.ar(1/delay);
			isig = DelayL.ar(sig, \maxdelay.kr(0.1), lfo1 * delay * SinOsc.ar(freq * lfoharm * \lfofac.kr(1), mul:\lfoa.kr(0.1), add:1)) + sig;
			isig;
		}
	};
	sig = SelectX.ar(\delayselect.kr(0) * ( lfoharms.size - 1 ), SelectX.ar(\lfoselect.kr(0) * ( delayharms.size - 1 ), voices));
	lpenv = EnvGen.kr(\lpenv.kr(Env([1,2,1],[0.04,0.2])), 1) * \lpenva.kr(2.7) + 1;
	sig = RLPF.ar(sig, ( \lpf.kr(400) * lpenv ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * 0.5;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\funfm1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[0.01,0.01]), 1);
	env2 = EnvGen.kr(Env([0,1,0],[0.1,0.8]), 1);
	mod3 = LFTri.ar(freq * [1,1.01]) * freq * 7.9;
	mod2 = SinOsc.ar(freq * [1.001,1]) * freq * 0.4 * env1;
	mod1 = SinOsc.ar(freq + mod2) * 1000;
	sig = SinOsc.ar(freq + mod1);
	sig = RLPF.ar(sig, \lpf.kr(1100), \rq.kr(0.5));
	sig = sig + SinOsc.ar(freq + mod3,mul:env2 * 0.3);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\fmpad1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var num=7;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0.7],[Rand(0.02!num,1.7),0.8]), 1);
	mod1 = SinOsc.ar(freq * [1.999,1/4,1,1/2,1,1/4,2.001] * LFNoise1.kr(0.2!num,mul:0.01,add:1)) * Rand(100!num,1700)* LFNoise1.kr(0.2!7,mul:0.7,add:1) * env1;
	sig = SinOsc.ar(freq * [2,1/4,1,1/2,1,1/4,2]* LFNoise1.kr(0.2!num,mul:0.01,add:1)+ mod1);
	sig = RLPF.ar(sig, ( \lpf.kr(2100) * LFNoise1.kr(1!num, mul:0.5,add:1) ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\part1, 
	Ppar([
		Pbind(
			\instrument, \bassbla,
			\note, Pstep(Pseq([
				0,5,-2,7,
			],inf),2),
			\lpf, PmodEnv(Pseq([100,400,4000,14000],1), 16, \exp).loop,
			\lfoselect, Pstep(Pseq([0,1],inf),16),
			\delayselect, 0.51,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				5,0,2,0, 5,2,0,5,
				0,5,2,0, 5,2,0,5,
				//5,\r,\r,\r, 5,2,0,5,
				//\r,5,2,0, 5,2,0,\r,
				//5,\r,2,0, 5,2,0,5,
				//\r,5,2,0, 5,2,0,\r,
			],inf),
			\isRest, Pseq([
				1,0.3,0.3,0.71, 0.9,0.9,0.9,0.9,
				0.3,0.9,0.9,0.9, 0.5,0.7,0.5,0.6,
			],inf).coin.not,
			\lpf, Pseg(Pseq([800,300,5000],inf),8,\exp),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\mel, \audio),
		),
		Pbind(
			\instrument, \funfm1,
			\note, Pseq([
				Pseq([
					0,-2,0,
				],8),
				-7,-5,
				Pseq([
					0,-2,0,
				],8),
				7,5,12,
			],inf).stutter(7),
			\dur, 1/8,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Plazy({ arg ev;
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,0,0,0, 0,1,0,0,
						1,0,0,0, 1,1,1,0,
					].scramble,4)
				}).loop,
			],inf).coin.not,
			\lpf, PmodEnv(Pseq([500,1000,4000,5000],1), 8,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.05,0.5,0.3) ],
			],inf),
			\sustain, 0.1/2,
			\amp, 0.1,
			\out, BusDef(\melb, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\melb, \audio),
			\delay, 1/2/~t,
			//\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
		),
		Pmono(\fx_delay,
			\inbus, BusDef(\mel, \audio),
			//\delay, 1/8/~t,
			\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,7],
				[0,5],
				[-2,5],
				[-2,7],
			],inf).stutter(2),
			\octave, 6,
			\dur, 1,
			\amp, 0.2,
			\out, BusDef(\pad, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\pad, \audio),
			\addAction, \addToTail,
			\hpf, 500,
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
			\instrument, \bassbla,
			\note, Pstep(Pseq([
				0,5,-2,7,
			],inf),2),
			\lpf, PmodEnv(Pseq([100,400,4000,14000],1), 16, \exp).loop,
			\lfoselect, Pstep(Pseq([0,1],inf),16),
			\delayselect, 0.51,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				5,0,2,0, 5,2,0,5,
				0,5,2,0, 5,2,0,5,
				//5,\r,\r,\r, 5,2,0,5,
				//\r,5,2,0, 5,2,0,\r,
				//5,\r,2,0, 5,2,0,5,
				//\r,5,2,0, 5,2,0,\r,
			],inf),
			\isRest, Pseq([
				1,0.3,0.3,0.71, 0.9,0.9,0.9,0.9,
				0.3,0.9,0.9,0.9, 0.5,0.7,0.5,0.6,
			],inf).coin.not,
			\lpf, Pseg(Pseq([800,300,5000],inf),8,\exp),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\mel, \audio),
		),
		Pbind(
			\instrument, \funfm1,
			\note, Pseq([
				Pseq([
					0,-2,0,
				],8),
				-7,-5,
				Pseq([
					0,-2,0,
				],8),
				7,5,12,
			],inf).stutter(7),
			\dur, 1/8,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Plazy({ arg ev;
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,0,0,0, 0,1,0,0,
						1,0,0,0, 1,1,1,0,
					].scramble,4)
				}).loop,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.05,0.5,0.3) ],
			],inf),
			\sustain, 0.1/2,
			\amp, 0.1,
			\out, BusDef(\melb, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\melb, \audio),
			\delay, 1/2/~t,
			//\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
		),
		Pmono(\fx_delay,
			\inbus, BusDef(\mel, \audio),
			//\delay, 1/8/~t,
			\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
		),
		Pbind(
			\instrument, \fmpad1,
			\note, Pseq([
				//[0,7],
				//[0,5],
				//[-2,5],
				//[-2,7],
				[0,3+12,7],
				[0,5,9],
				[-2,2,5],
				[-2,2,7],
			],inf).stutter(1),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\octave, 6,
			\dur, 2,
			\amp, 0.2,
			\out, BusDef(\pad, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\pad, \audio),
			\addAction, \addToTail,
			\hpf, 500,
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
			\instrument, \fmpad1,
			\note, Pseq([
				[0,3,7],
				[0,5,9],
				[-2,2,5],
				[-2,2,7],
			],inf).stutter(1),
			\octave, 5,
			\dur, 2,
			\amp, 0.2,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[161].value,
			\bufnum, ~buflib.kick[65].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[865].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
					0,1,0,1, 0,0,1,1,
				],inf),
				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
				0,0,1,0, 0,1,0,1,
				0,1,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
				0,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07 * Pseq([
				0.6,1,0.6,1,
			],inf),
			\out, BusDef(\hat, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[210].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.12 * Pseg(Pwhite(0.6,2,inf),7),
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\hat, \audio),
			\mix, 0.3,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\hat2, \audio),
		),
		Pmono(\fx_rlpfrhpf,
			\inbus, BusDef(\hat2, \audio),
			\addAction, \addToTail,
			\hpf, Pseg(Pseq([0.1,1,0.4],inf),8)*2000,
			\lpf, Pseg(Pseq([0.5,0.3,1],inf),8)*8000,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[720].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \bassbla,
			\note, Pstep(Pseq([
				0,5,-2,7,
			],inf),2),
			\lpf, PmodEnv(Pseq([200,400,4000,14000],1), 16, \exp).loop,
			\lfoselect, Pstep(Pseq([0,1],inf),16),
			\delayselect, 0.51,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.15 * Pseq([
				1,0,0,1, 0,0,1,0,
				1,1,0,1, 1,0,1,1,
			],inf).linlin(0,1,0.7,1),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,1,0,1, 1,0,1,1,
				1,1,1,0, 1,0,1,1,
			],inf).coin.not,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				5,0,2,0, 5,2,0,5,
				0,5,2,0, 5,2,0,5,
				//5,\r,\r,\r, 5,2,0,5,
				//\r,5,2,0, 5,2,0,\r,
				//5,\r,2,0, 5,2,0,5,
				//\r,5,2,0, 5,2,0,\r,
			],inf),
			\isRest, Pseq([
				1,0.3,0.3,0.71, 0.9,0.9,0.9,0.9,
				0.3,0.9,0.9,0.9, 0.5,0.7,0.5,0.6,
			],inf).coin.not,
			\lpf, Pseg(Pseq([800,300,5000],inf),8,\exp),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\mel, \audio),
		),
		Pbind(
			\instrument, \funfm1,
			\note, Pseq([
				Pseq([
					0,-2,0,
				],8),
				-7,-5,
				Pseq([
					0,-2,0,
				],8),
				7,5,12,
			],inf).stutter(7),
			\dur, 1/8,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Plazy({ arg ev;
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,0,0,0, 0,1,0,0,
						1,0,0,0, 1,1,1,0,
					].scramble,4)
				}).loop,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.05,0.5,0.3) ],
			],inf),
			\sustain, 0.1/2,
			\amp, 0.1,
			\out, BusDef(\melb, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\melb, \audio),
			\delay, 1/2/~t,
			//\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
		),
		Pmono(\fx_delay,
			\inbus, BusDef(\mel, \audio),
			//\delay, 1/8/~t,
			\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
		),
		Pbind(
			\instrument, \fmpad1,
			\note, Pseq([
				//[0,7],
				//[0,5],
				//[-2,5],
				//[-2,7],
				[0,3+12,7],
				[0,5,9],
				[-2,2,5],
				[-2,2,7],
			],inf).stutter(1),
			\octave, 6,
			\dur, 2,
			\amp, 0.2,
			\out, BusDef(\pad, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\pad, \audio),
			\addAction, \addToTail,
			\hpf, 500,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

///////
(
SynthDef(\randmixer16, { arg out=0, gate=1;
	var sig;
	var num=16;
	var env;
	env = EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	num.do { arg idx;
		var in;
		var isig;
		in = InFeedback.ar(( \inbus+++idx ).kr(BusDef(\zero, \audio)), 2); 
		isig = in;
		//isig = isig * LFNoise1.ar(0.2).exprange(0.001,1);
		isig = isig * LFNoise1.ar(0.2).range(0.001,1);
		isig = isig * env;
		isig = isig * \gain.kr(1);
		Out.ar(out, isig);
	};
}).add;
Pdef(\part).reset;
);
(
// rand amp
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[161].value,
			\bufnum, ~buflib.kick[65].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\mout1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[865].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
					0,1,0,1, 0,0,1,1,
				],inf),
				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
				0,0,1,0, 0,1,0,1,
				0,1,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
				0,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07 * Pseq([
				0.6,1,0.6,1,
			],inf),
			\out, BusDef(\hat, \audio),
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\hat, \audio),
			\mix, 0.3,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\hat2, \audio),
		),
		Pmono(\fx_rlpfrhpf,
			\inbus, BusDef(\hat2, \audio),
			\addAction, \addToTail,
			\hpf, Pseg(Pseq([0.1,1,0.4],inf),8)*2000,
			\lpf, Pseg(Pseq([0.5,0.3,1],inf),8)*8000,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\mout2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[210].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.12 * Pseg(Pwhite(0.6,2,inf),7),
			\out, BusDef(\mout3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[720].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\mout4, \audio),
		),


		Pbind( // bass
			\instrument, \bassbla,
			\note, Pstep(Pseq([
				0,5,-2,7,
			],inf),2),
			\lpf, PmodEnv(Pseq([200,400,4000,14000],1), 16, \exp).loop,
			\lfoselect, Pstep(Pseq([0,1],inf),16),
			\delayselect, 0.51,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.15 * Pseq([
				1,0,0,1, 0,0,1,0,
				1,1,0,1, 1,0,1,1,
			],inf).linlin(0,1,0.7,1),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,1,0,1, 1,0,1,1,
				1,1,1,0, 1,0,1,1,
			],inf).coin.not,
			\out, BusDef(\mout5, \audio),
		),

		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				5,0,2,0, 5,2,0,5,
				0,5,2,0, 5,2,0,5,
				//5,\r,\r,\r, 5,2,0,5,
				//\r,5,2,0, 5,2,0,\r,
				//5,\r,2,0, 5,2,0,5,
				//\r,5,2,0, 5,2,0,\r,
			],inf),
			\isRest, Pseq([
				1,0.3,0.3,0.71, 0.9,0.9,0.9,0.9,
				0.3,0.9,0.9,0.9, 0.5,0.7,0.5,0.6,
			],inf).coin.not,
			\lpf, Pseg(Pseq([800,300,5000],inf),8,\exp),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\mel, \audio),
		),
		Pmono(\fx_delay,
			\inbus, BusDef(\mel, \audio),
			//\delay, 1/8/~t,
			\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
			\out, BusDef(\mout6, \audio),
		),

		Pbind(
			\instrument, \funfm1,
			\note, Pseq([
				Pseq([
					0,-2,0,
				],8),
				-7,-5,
				Pseq([
					0,-2,0,
				],8),
				7,5,12,
			],inf).stutter(7),
			\dur, 1/8,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Plazy({ arg ev;
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,0,0,0, 0,1,0,0,
						1,0,0,0, 1,1,1,0,
					].scramble,4)
				}).loop,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.05,0.5,0.3) ],
			],inf),
			\sustain, 0.1/2,
			\amp, 0.1,
			\out, BusDef(\melb, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\melb, \audio),
			\delay, 1/2/~t,
			//\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
			\out, BusDef(\mout7, \audio),
		),

		Pbind(
			\instrument, \fmpad1,
			\note, Pseq([
				//[0,7],
				//[0,5],
				//[-2,5],
				//[-2,7],
				[0,3+12,7],
				[0,5,9],
				[-2,2,5],
				[-2,2,7],
			],inf).stutter(1),
			\octave, 6,
			\dur, 2,
			\amp, 0.2,
			\out, BusDef(\pad, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\pad, \audio),
			\addAction, \addToTail,
			\hpf, 500,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\mout8, \audio),
		),
		Pmono(\randmixer16,
			\inbus, BusDef(\sendbus1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\inbus0, BusDef(\mout1, \audio),
			\inbus1, BusDef(\mout2, \audio),
			\inbus2, BusDef(\mout3, \audio),
			\inbus3, BusDef(\mout4, \audio),
			\inbus4, BusDef(\mout5, \audio),
			\inbus5, BusDef(\mout6, \audio),
			\inbus6, BusDef(\mout7, \audio),
			\inbus7, BusDef(\mout8, \audio),
			\dur, 1,
		),
		
	])
)).play;
);


//////////////////

(
Pdef(\part, Pdef(\intro, 
	Ppar([
		
		Ptpar([
			0, Pbind(
				\instrument, \sh101,
				\note, Pseq([
					5,\r,\r,\r, 5,2,0,5,
					\r,5,2,0, 5,2,0,\r,
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.4,0.1) ],
				],inf),
				\envamt, Pseg(Pseq([1,8],1), 8*2).loop,
				\lpf, PmodEnv(Pseq([80,100,200],1),Pseq([4,12],inf),\exp).loop,
				\dur, 1/8,
				\amp, 0.1,
			),
			8, Ppar([
				   	Pbind(
						\instrument, \bassbla,
						\note, Pstep(Pseq([
							0,5,-2,7,
						],inf),2),
						\lpf, PmodEnv(Pseq([80,400],1), 16, \exp).loop,
						\lfoselect, Pstep(Pseq([0,1],inf),16),
						\delayselect, 0.51,
						\adsr, Pseq([
							[ Env.adsr(0.01,0.1,0.8,0.1) ],
						],inf),
						\octave, 3,
						\dur, 1/8,
						\amp, 0.1,
						\out, BusDef(\bass, \audio),
					),
					Pmono(\fx_hpf,
						\inbus, BusDef(\bass, \audio),
						\addAction, \addToTail,
						\hpf, PmodEnv(Pseq([10,10,5000],1), Pseq([4,4]),\exp).loop,
						\lag, 0.0009,
						\dur, 1,
					),
			]),
			16, Ppar([
				Pbind(
					\instrument, \snappad,
					\note, Pseq([
						[0,7],
						[0,5],
						[-2,5],
						[-2,7],
					],inf).stutter(2),
					\octave, Ptuple(Prand([5,6,6,6,6,6],inf)!2),
					\dur, 1,
					\amp, 0.2,
					\out, BusDef(\pad, \audio),
				),
				Pmono(\fx_hpf,
					\inbus, BusDef(\pad, \audio),
					\addAction, \addToTail,
					\hpf, 500,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
		]),
	])
)).play;
);


(
// raising energy
Pdef(\part, Pdef(\part1, 
	Ppar([
		Pbind(
			\instrument, \bassbla,
			\note, Pstep(Pseq([
				0,5,-2,7,
			],inf),2),
			\lpf, PmodEnv(Pseq([100,400,4000],1), 16, \exp).loop,
			\lfoselect, Pstep(Pseq([0,1],inf),16),
			\delayselect, 0.51,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				5,0,2,0, 5,2,0,5,
				0,5,2,0, 5,2,0,5,
				//5,\r,\r,\r, 5,2,0,5,
				//\r,5,2,0, 5,2,0,\r,
				//5,\r,2,0, 5,2,0,5,
				//\r,5,2,0, 5,2,0,\r,
			],inf),
			\isRest, ( Pseq([
				1,0.3,0.3,0.71, 0.9,0.9,0.9,0.9,
				0.3,0.9,0.9,0.9, 0.5,0.7,0.5,0.6,
			],inf) * Pseg([0.8,1.1], 32).loop ).coin.not,
			\lpf, Pseg(Pseq([300,800,5000],inf),16,\exp),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\mel, \audio),
		),
		Pbind(
			\instrument, \funfm1,
			\note, Pseq([
				Pseq([
					0,-2,0,
				],8),
				-7,-5,
				Pseq([
					0,-2,0,
				],8),
				7,5,12,
			],inf).stutter(7),
			\dur, 1/8,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Plazy({ arg ev;
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,0,0,0, 0,1,0,0,
						1,0,0,0, 1,1,1,0,
					].scramble,4)
				}).loop,
			],inf).coin.not,
			\lpf, PmodEnv(Pseq([500,1000,4000,5000],1), 8,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.05,0.5,0.3) ],
			],inf),
			\sustain, 0.1/2,
			\amp, 0.1,
			\out, BusDef(\melb, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\melb, \audio),
			\delay, 1/2/~t,
			//\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
		),
		Pmono(\fx_delay,
			\inbus, BusDef(\mel, \audio),
			//\delay, 1/8/~t,
			\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,7],
				[0,5],
				[-2,5],
				[-2,7],
			],inf).stutter(2),
			\octave, 6,
			\dur, 1,
			\amp, 0.2,
			\out, BusDef(\pad, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\pad, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([2000,124],1), 32,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[210].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.12 * Pseg(Pseq([0,0.1,0.5,1,1.1],1),8),
		),
		
	])
)).play;
);


(
// introduce drums
Pdef(\part, Pdef(\part2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[161].value,
			\bufnum, ~buflib.kick[65].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,1,0,1, 0,0,1,0,
			],1).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseg(Pseq([0,1],inf),4),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[161].value,
			\bufnum, ~buflib.kick[65].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,1,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Ptpar([
			16, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[720].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			20, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[349].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,1,0,1, 0,1,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11 * Pseg(Pseq([0.5,1],inf),32),
			),
		]),
		
		Pbind(
			\instrument, \bassbla,
			\note, Pstep(Pseq([
				0,5,-2,7,
			],inf),2),
			\lpf, PmodEnv(Pseq([100,400,4000],1), 16, \exp).loop,
			\lfoselect, Pstep(Pseq([0,1],inf),16),
			\delayselect, 0.51,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				5,0,2,0, 5,2,0,5,
				0,5,2,0, 5,2,0,5,
				//5,\r,\r,\r, 5,2,0,5,
				//\r,5,2,0, 5,2,0,\r,
				//5,\r,2,0, 5,2,0,5,
				//\r,5,2,0, 5,2,0,\r,
			],inf),
			\isRest, ( Pseq([
				1,0.3,0.3,0.71, 0.9,0.9,0.9,0.9,
				0.3,0.9,0.9,0.9, 0.5,0.7,0.5,0.6,
			],inf) * Pseg([0.8,1.1], 32).loop ).coin.not,
			\lpf, Pseg(Pseq([300,800,5000],inf),16,\exp),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\mel, \audio),
		),
		Pbind(
			\instrument, \funfm1,
			\note, Pseq([
				Pseq([
					0,-2,0,
				],8),
				-7,-5,
				Pseq([
					0,-2,0,
				],8),
				7,5,12,
			],inf).stutter(7),
			\dur, 1/8,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Plazy({ arg ev;
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,0,0,0, 0,1,0,0,
						1,0,0,0, 1,1,1,0,
					].scramble,4)
				}).loop,
			],inf).coin.not,
			\lpf, PmodEnv(Pseq([500,1000,4000,5000],1), 8,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.05,0.5,0.3) ],
			],inf),
			\sustain, 0.1/2,
			\amp, 0.1,
			\out, BusDef(\melb, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\melb, \audio),
			\delay, 1/2/~t,
			//\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
		),
		Pmono(\fx_delay,
			\inbus, BusDef(\mel, \audio),
			//\delay, 1/8/~t,
			\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,7],
				[0,5],
				[-2,5],
				[-2,7],
			],inf).stutter(2),
			\octave, 6,
			\dur, 1,
			\amp, 0.2,
			\out, BusDef(\pad, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\pad, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([2000,124],1), 32,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[210].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.12 * Pseg(Pseq([0,1,1,1,1.1],1),8),
		),
	])
)).play;
);
(
// call answer
Pdef(\part, Pdef(\part3, 
	Ppar([

		Pbind(
			\instrument, \bigcrash,
			\dur, Pn(4,1),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \bassbla,
			\note, Pstep(Pseq([
				0,5,-2,7,
			],inf),2),
			\lpf, PmodEnv(Pseq([100,400,4000],1), 16, \exp).loop,
			\lfoselect, Pstep(Pseq([0,1],inf),16),
			\delayselect, 0.51,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,1,1,0, 1,0,1,0,
				1,0,0,1, 0,0,1,0,
				1,1,1,0, 1,1,0,1,
			],inf).coin.not,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				5,0,2,0, 5,2,0,5,
				0,5,2,0, 5,2,0,5,
				//5,\r,\r,\r, 5,2,0,5,
				//\r,5,2,0, 5,2,0,\r,
				//5,\r,2,0, 5,2,0,5,
				//\r,5,2,0, 5,2,0,\r,
			],inf),
			\isRest, ( Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 1,1,0,1,
				1,1,1,0, 1,1,1,1,
			],inf) ).coin.not,
			\lpf, Pseg(Pseq([300,800,5000],inf),16,\exp),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\mel, \audio),
		),
		Pbind(
			\instrument, \funfm1,
			\note, Pseq([
				Pseq([
					0,-2,0,
				],8),
				-7,-5,
				Pseq([
					0,-2,0,
				],8),
				7,5,12,
			],inf).stutter(7),
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,1, 0,1,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,1,1,0,
				0,0,0,0, 0,0,1,0,
				0,0,1,1, 0,1,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,1,1,0,
				0,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\lpf, PmodEnv(Pseq([500,1000,4000,5000],1), 8,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.05,0.5,0.3) ],
			],inf),
			\sustain, 0.1/2,
			\amp, 0.1,
			\out, BusDef(\melb, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\melb, \audio),
			\delay, 1/2/~t,
			//\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
		),
		Pmono(\fx_delay,
			\inbus, BusDef(\mel, \audio),
			//\delay, 1/8/~t,
			\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,7],
				[0,5],
				[-2,5],
				[-2,7],
			],inf).stutter(2),
			\octave, 6,
			\dur, 1,
			\amp, 0.2,
			\out, BusDef(\pad, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\pad, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([2000,124],1), 32,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[210].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.12 * Pseg(Pseq([0,0.1,0.5,1,1.1],1),8),
		),
		
	])
)).play;
);
(
// other pad
Pdef(\part, Pdef(\part4, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[161].value,
			\bufnum, ~buflib.kick[65].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[865].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
					0,1,0,1, 0,0,1,1,
				],inf),
				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
				0,0,1,0, 0,1,0,1,
				0,1,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
				0,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07 * Pseq([
				0.6,1,0.6,1,
			],inf),
			\out, BusDef(\hat, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[210].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.12 * Pseg(Pwhite(0.6,2,inf),7),
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\hat, \audio),
			\mix, 0.3,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\hat2, \audio),
		),
		Pmono(\fx_rlpfrhpf,
			\inbus, BusDef(\hat2, \audio),
			\addAction, \addToTail,
			\hpf, Pseg(Pseq([0.1,1,0.4],inf),8)*2000,
			\lpf, Pseg(Pseq([0.5,0.3,1],inf),8)*8000,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[720].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \bassbla,
			\note, Pstep(Pseq([
				0,5,-2,7,
			],inf),2),
			\lpf, PmodEnv(Pseq([200,400,4000,14000],1), 16, \exp).loop,
			\lfoselect, Pstep(Pseq([0,1],inf),16),
			\delayselect, 0.51,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.15 * Pseq([
				1,0,0,1, 0,0,1,0,
				1,1,0,1, 1,0,1,1,
			],inf).linlin(0,1,0.7,1),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,1,0,1, 1,0,1,1,
				1,1,1,0, 1,0,1,1,
			],inf).coin.not,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				5,0,2,0, 5,2,0,5,
				0,5,2,0, 5,2,0,5,
				//5,\r,\r,\r, 5,2,0,5,
				//\r,5,2,0, 5,2,0,\r,
				//5,\r,2,0, 5,2,0,5,
				//\r,5,2,0, 5,2,0,\r,
			],inf),
			\isRest, Pseq([
				1,0.3,0.3,0.71, 0.9,0.9,0.9,0.9,
				0.3,0.9,0.9,0.9, 0.5,0.7,0.5,0.6,
			],inf).coin.not,
			\lpf, Pseg(Pseq([800,300,5000],inf),8,\exp),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\mel, \audio),
		),
		Pbind(
			\instrument, \funfm1,
			\note, Pseq([
				Pseq([
					0,-2,0,
				],8),
				-7,-5,
				Pseq([
					0,-2,0,
				],8),
				7,5,12,
			],inf).stutter(7),
			\dur, 1/8,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Plazy({ arg ev;
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,0,0,0, 0,1,0,0,
						1,0,0,0, 1,1,1,0,
					].scramble,4)
				}).loop,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.05,0.5,0.3) ],
			],inf),
			\sustain, 0.1/2,
			\amp, 0.1,
			\out, BusDef(\melb, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\melb, \audio),
			\delay, 1/2/~t,
			//\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
		),
		Pmono(\fx_delay,
			\inbus, BusDef(\mel, \audio),
			//\delay, 1/8/~t,
			\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
		),
		Pbind(
			\instrument, \fmpad1,
			\note, Pseq([
				//[0,7],
				//[0,5],
				//[-2,5],
				//[-2,7],
				[0,3+12,7],
				[0,5,9],
				[-2,2,5],
				[-2,2,7],
			],inf).stutter(1),
			\octave, 6,
			\dur, 2,
			\amp, 0.2,
			\out, BusDef(\pad, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\pad, \audio),
			\addAction, \addToTail,
			\hpf, 500,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);
(
//////////// main
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(16,Pdef(\intro)),
		Pfindur(32,Pdef(\part1)),
		Pfindur(32,Pdef(\part2)),
		Pfindur(32,Pdef(\bintro)),
		Pfindur(32,Pdef(\part4)),
		Pfindur(32,Pdef(\part3)),
	])
)).play;
);

/////////



////

(
Pdef(\part, Pdef(\bintro, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[161].value,
			\bufnum, ~buflib.kick[65].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,1,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\kicktrack, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([1000,300,20,20,20],1), 8,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		
		Pbind(
			\instrument, \bassbla,
			\note, Pstep(Pseq([
				0,5,-2,7,
			],inf),2),
			\lpf, PmodEnv(Pseq([100,400,4000],1), 16, \exp).loop,
			\lfoselect, Pstep(Pseq([0,1],inf),16),
			\delayselect, 0.51,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\bass, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\bass, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([1000,200,10,10,10],1), 8,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\bass2, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\bass2, \audio),
			\addAction, \addToTail,
			\room, 1,
			\mix, PmodEnv(Pseq([1,0.1,0,0,0],1), 8).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				//5,0,2,0, 5,2,0,5,
				//0,5,2,0, 5,2,0,5,
				5,\r,\r,\r, 5,2,0,5,
				\r,5,2,0, 5,2,0,\r,
				//5,\r,2,0, 5,2,0,5,
				//\r,5,2,0, 5,2,0,\r,
			],inf),
			\lpf, Pseg(Pseq([300,800,5000],inf),16,\exp),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\mel, \audio),
		),
		Pmono(\fx_delay,
			\inbus, BusDef(\mel, \audio),
			//\delay, 1/8/~t,
			\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
			\out, BusDef(\mel2, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\mel2, \audio),
			\addAction, \addToTail,
			\room, 1,
			\damp, 1,
			\mix, PmodEnv(Pseq([0.2,0.1,0,0,0],1), 8).loop,
			\lag, 0.0009,
			\dur, 1,
		),

		Pbind(
			\instrument, \funfm1,
			\note, Pseq([
				Pseq([
					0,-2,0,
				],8),
				-7,-5,
				Pseq([
					0,-2,0,
				],8),
				7,5,12,
			],inf).stutter(7),
			\dur, 1/8,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Plazy({ arg ev;
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,0,0,0, 0,1,0,0,
						1,0,0,0, 1,1,1,0,
					].scramble,4)
				}).loop,
			],inf).coin.not,
			\lpf, PmodEnv(Pseq([500,1000,4000,5000],1), 8,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.05,0.5,0.3) ],
			],inf),
			\sustain, 0.1/2,
			\amp, 0.1,
			\out, BusDef(\melb, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\melb, \audio),
			\delay, 1/2/~t,
			//\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
			\out, BusDef(\melb2, \audio),
		),
		Pmono(\fx_lpf,
			\inbus, BusDef(\melb2, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([2000,200,20],1), 8,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\melb3, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\melb3, \audio),
			\addAction, \addToTail,
			\room, 1,
			\damp, 1,
			\mix, PmodEnv(Pseq([1,0.1,0,0,0],1), 8).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,7],
				[0,5],
				[-2,5],
				[-2,7],
			],inf).stutter(2),
			\octave, 6,
			\dur, 1,
			\amp, 0.2,
			\out, BusDef(\pad, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\pad, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([2000,124],1), 32,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\bintro, 
	Ppar([
		Pbind(
			\instrument, \bigcrash,
			\dur, Pn(4,1),
			\amp, 0.1,
			//\out, BusDef(\crashverb, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[161].value,
			\bufnum, ~buflib.kick[65].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					Pseq([
						Pseq([
							1,0,0,0, 1,0,0,0,
						],7),
						1,0,0,0, 1,0,0,1,
					],3),
						Pseq([
							1,0,0,0, 1,0,0,0,
						],6),
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,1,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\kicktrack, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([1000,300,20,20,20],1), 8,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		
		Pbind(
			\instrument, \bassbla,
			\note, Pstep(Pseq([
				7,
			],inf),2),
			\lpf, PmodEnv(Pseq([100,400,4000],1), 16, \exp).loop,
			\lfoselect, Pstep(Pseq([0,1],inf),16),
			\delayselect, 0.51,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\bass, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\bass, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([1000,200,10,10,10],1), 8,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\bass2, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\bass2, \audio),
			\addAction, \addToTail,
			\room, 1,
			\mix, PmodEnv(Pseq([1,0.1,0,0,0],1), 8).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				//5,0,2,0, 5,2,0,5,
				//0,5,2,0, 5,2,0,5,
				5,\r,\r,\r, 5,2,0,5,
				\r,5,2,0, 5,2,0,\r,
				//5,\r,2,0, 5,2,0,5,
				//\r,5,2,0, 5,2,0,\r,
			],inf),
			\lpf, Pseg(Pseq([300,800,5000],inf),16,\exp),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\mel, \audio),
		),
		Pmono(\fx_delay,
			\inbus, BusDef(\mel, \audio),
			//\delay, 1/8/~t,
			\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
			\out, BusDef(\mel2, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\mel2, \audio),
			\addAction, \addToTail,
			\room, 1,
			\damp, 1,
			\mix, PmodEnv(Pseq([0.2,0.1,0,0,0],1), 8).loop,
			\lag, 0.0009,
			\dur, 1,
		),

		Pbind(
			\instrument, \funfm1,
			\note, Pseq([
				Pseq([
					0,-2,0,
				],8),
				-7,-5,
				Pseq([
					0,-2,0,
				],8),
				7,5,12,
			],inf).stutter(7),
			\dur, 1/8,
			\isRest, Pseq([
				//Pseq([
					//0,0,0,0, 0,0,0,0,
				//],4),
				Plazy({ arg ev;
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,0,0,0, 0,1,0,0,
						1,0,0,0, 1,1,1,0,
					].scramble,4)
				}).loop,
			],inf).coin.not,
			\lpf, PmodEnv(Pseq([500,1000,4000,5000],1), 8,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.05,0.5,0.3) ],
			],inf),
			\sustain, 0.1/2,
			\amp, 0.1,
			\out, BusDef(\melb, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\melb, \audio),
			\delay, 1/2/~t,
			//\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
			\out, BusDef(\melb2, \audio),
		),
		Pmono(\fx_lpf,
			\inbus, BusDef(\melb2, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([2000,200,20],1), 8,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\melb3, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\melb3, \audio),
			\addAction, \addToTail,
			\room, 1,
			\damp, 1,
			\mix, PmodEnv(Pseq([1,0.1,0,0,0],1), 8).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,7],
			],inf).stutter(2),
			\octave, 6,
			\dur, 1,
			\amp, 0.2,
			\out, BusDef(\pad, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\pad, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([2000,124],1), 32,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pfindur(31,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[211].value,
			\bufnum, ~buflib.hat[1013].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],16),
				Pseq([
					1,1,1,1, 1,1,1,1,
				],16),
			],inf).coin.not,
			\legato, Pseq([0.8,0.3],inf),
			\speed, Pseq([1,1 * 4.midiratio],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.05 * Pseg(Pseq([0,0.1,0.5,1,1.3],1),8) * Pseq([1,0.6],inf),
			//\gain, 0.07 * Pseq([1,0.3],inf),
			//\gain, 0.12,

		)),
	])
)).play;
);

(
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([15000,10,1],[0.005,0.8]), 1);
	env2 = EnvGen.kr(Env([10000,10,1],[0.006,0.8]), 1);
	mod1 = SinOsc.ar(8000) * 10000; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
// big crash
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bigcrash,
			\dur, 4,
			\amp, 0.1,
			//\out, BusDef(\crashverb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\crashverb, \audio),
			\addAction, \addToTail,
			\room, 2,
			\damp, 1,
			\mix, 0.91,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);


(
// raising energy, break at end
Pdef(\part, Pdef(\part1br, 
	Ppar([
		Pbind(
			\instrument, \bassbla,
			\note, Pstep(Pseq([
				0,5,-2,7,
			],inf),2),
			\lpf, PmodEnv(Pseq([100,400,4000],1), 16, \exp).loop,
			\lfoselect, Pstep(Pseq([0,1],inf),16),
			\delayselect, 0.51,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\bass, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\bass, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([10,10,5000],1), Pseq([24,8])).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				5,0,2,0, 5,2,0,5,
				0,5,2,0, 5,2,0,5,
				//5,\r,\r,\r, 5,2,0,5,
				//\r,5,2,0, 5,2,0,\r,
				//5,\r,2,0, 5,2,0,5,
				//\r,5,2,0, 5,2,0,\r,
			],inf),
			\isRest, ( Pseq([
				1,0.3,0.3,0.71, 0.9,0.9,0.9,0.9,
				0.3,0.9,0.9,0.9, 0.5,0.7,0.5,0.6,
			],inf) * Pseg([0.8,1.1], 32).loop ).coin.not,
			\lpf, Pseg(Pseq([300,800,5000,100],inf),Pseq([16,8,8]),\exp),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\mel, \audio),
		),
		Pmono(\fx_delay,
			\inbus, BusDef(\mel, \audio),
			//\delay, 1/8/~t,
			\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
		),
		Pbind(
			\instrument, \funfm1,
			\note, Pseq([
				Pseq([
					0,-2,0,
				],8),
				-7,-5,
				Pseq([
					0,-2,0,
				],8),
				7,5,12,
			],inf).stutter(7),
			\dur, 1/8,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Plazy({ arg ev;
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,0,0,0, 0,1,0,0,
						1,0,0,0, 1,1,1,0,
					].scramble,4)
				}).loop,
			],inf).coin.not,
			\lpf, PmodEnv(Pseq([500,1000,4000,50],1), 8,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.05,0.5,0.3) ],
			],inf),
			\sustain, 0.1/2,
			\amp, 0.1,
			\out, BusDef(\melb, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\melb, \audio),
			\delay, 1/2/~t,
			//\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,7],
				[0,5],
				[-2,5],
				[-2,7],
			],inf).stutter(2),
			\octave, 6,
			\dur, 1,
			\amp, 0.2,
			\out, BusDef(\pad, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\pad, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([2000,124,2000],1), Pseq([24,8]),\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[210].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.12 * Pseg(Pseq([0,0.1,0.5,1,1.1],1),8),
		),
		
	])
)).play;
);



(
// call answer + drums
Pdef(\part, Pdef(\part3, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[161].value,
			\bufnum, ~buflib.kick[65].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),

		Pbind(
			\instrument, \bigcrash,
			\dur, Pn(4,1),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \bassbla,
			\note, Pstep(Pseq([
				0,5,-2,7,
			],inf),2),
			\lpf, PmodEnv(Pseq([100,400,4000],1), 16, \exp).loop,
			\lfoselect, Pstep(Pseq([0,1],inf),16),
			\delayselect, 0.51,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,1,1,0, 1,0,1,0,
				1,0,0,1, 0,0,1,0,
				1,1,1,0, 1,1,0,1,
			],inf).coin.not,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				5,0,2,0, 5,2,0,5,
				0,5,2,0, 5,2,0,5,
				//5,\r,\r,\r, 5,2,0,5,
				//\r,5,2,0, 5,2,0,\r,
				//5,\r,2,0, 5,2,0,5,
				//\r,5,2,0, 5,2,0,\r,
			],inf),
			\isRest, ( Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 1,1,0,1,
				1,1,1,0, 1,1,1,1,
			],inf) ).coin.not,
			\lpf, Pseg(Pseq([300,800,5000],inf),16,\exp),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\mel, \audio),
		),
		Pbind(
			\instrument, \funfm1,
			\note, Pseq([
				Pseq([
					0,-2,0,
				],8),
				-7,-5,
				Pseq([
					0,-2,0,
				],8),
				7,5,12,
			],inf).stutter(7),
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,1, 0,1,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,1,1,0,
				0,0,0,0, 0,0,1,0,
				0,0,1,1, 0,1,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,1,1,0,
				0,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\lpf, PmodEnv(Pseq([500,1000,4000,5000],1), 8,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.05,0.5,0.3) ],
			],inf),
			\sustain, 0.1/2,
			\amp, 0.1,
			\out, BusDef(\melb, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\melb, \audio),
			\delay, 1/2/~t,
			//\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
		),
		Pmono(\fx_delay,
			\inbus, BusDef(\mel, \audio),
			//\delay, 1/8/~t,
			\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,7],
				[0,5],
				[-2,5],
				[-2,7],
			],inf).stutter(2),
			\octave, 6,
			\dur, 1,
			\amp, 0.2,
			\out, BusDef(\pad, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\pad, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([2000,124],1), 32,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[210].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.12 * Pseg(Pseq([0,0.1,0.5,1,1.1],1),8),
		),
		
	])
)).play;
);

(
// introduce drums immediatly
Pdef(\part, Pdef(\part2dir, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[161].value,
			\bufnum, ~buflib.kick[65].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
						Pseq([
							1,0,0,0, 1,0,0,0,
						],7),
						1,0,0,0, 1,0,0,1,
						Pseq([
							1,0,0,0, 1,0,0,0,
						],7),
						0,0,0,0, 0,0,0,0,

						Pseq([
							1,0,0,0, 1,0,0,0,
						],7),
						1,0,0,0, 1,0,0,1,
						Pseq([
							1,0,0,0, 1,0,0,0,
						],6),
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Ptpar([
			0, Pfindur(28,Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[720].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pseq([
						0,0,1,0, 0,0,1,0,
					],7),
					0,0,1,1, 0,0,1,0,
					Pseq([
						0,0,1,0, 0,0,1,0,
					],7),
					1,1,0,1, 0,0,1,0,
				],inf).coin.not,
				\legato, Pseq([0.8,1],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11,
			)),
			4, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[349].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,1,0,1, 0,1,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.09 * Pseg(Pseq([0,1,1],1),Pseq([4,22])),
			),
		]),
		Pbind(
			\instrument, \bigcrash,
			\dur, Pn(4,1),
			\amp, 0.1,
		),
		
		Pseq([

			Pfindur(16,Pbind(
				\instrument, \bassbla,
				\note, Pstep(Pseq([
					0,5,-2,7,
				],inf),2),
				\lpf, 
				Pseq([
					PmodEnv(Pseq([500,800,2000],1), 8, \exp),
				],inf),
				\lfoselect, Pseg(Pseq([0.4,0.6],1),16).loop,
				\lfofac, PmodEnv(Pseq([1,4,0.4],1), 16).loop,
				\delayselect, 0.8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\octave, 3,
				\dur, 1/8,
				\amp, 0.1,
			)),
			Pfindur(16,Pbind(
				\instrument, \bassbla,
				\note, Pstep(Pseq([
					0,5,-2,7,
				],inf),2),
				\lpf, 
				Pseq([
					PmodEnv(Pseq([500,800,4000],1), 8, \exp),
					PmodEnv(Pseq([200,300,4000],1), 8, \exp),
				],inf),
				\lfoselect, Pseg(Pseq([0.4,0.6],1),16).loop,
				\lfofac, PmodEnv(Pseq([1,4,0.4],1), 16).loop,
				\delayselect, 0.51,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\isRest, Pseq([
					Pstep([ 1,0 ],Pseq([14,2])),
				],inf).coin.not,
				\octave, 3,
				\dur, 1/8,
				\amp, 0.1,
			)),
		],1),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				5,0,2,0, 5,2,0,5,
				0,5,2,0, 5,2,0,5,
				//5,\r,\r,\r, 5,2,0,5,
				//\r,5,2,0, 5,2,0,\r,
				//5,\r,2,0, 5,2,0,5,
				//\r,5,2,0, 5,2,0,\r,
			],inf),
			\isRest, ( Pseq([
				1,0.3,0.3,0.71, 0.9,0.9,0.9,0.9,
				0.3,0.9,0.9,0.9, 0.5,0.7,0.5,0.6,
			],inf) * Pseg([0.8,1.1], 32).loop ).coin.not,
			\lpf, Pseg(Pseq([300,800,5000],inf),16,\exp),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\mel, \audio),
		),
		Pbind(
			\instrument, \funfm1,
			\note, Pseq([
				Pseq([
					0,-2,0,
				],8),
				-7,-5,
				Pseq([
					0,-2,0,
				],8),
				7,5,12,
			],inf).stutter(7),
			\dur, 1/8,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Plazy({ arg ev;
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,0,0,0, 0,1,0,0,
						1,0,0,0, 1,1,1,0,
					].scramble,4)
				}).loop,
			],inf).coin.not,
			\lpf, PmodEnv(Pseq([500,1000,4000,5000],1), 8,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.05,0.5,0.3) ],
			],inf),
			\sustain, 0.1/2,
			\amp, 0.1,
			\out, BusDef(\melb, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\melb, \audio),
			\delay, 1/2/~t,
			//\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
		),
		Pmono(\fx_delay,
			\inbus, BusDef(\mel, \audio),
			//\delay, 1/8/~t,
			\delay, 0.04,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
			\gain, 1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,7],
				[0,5],
				[-2,5],
				[-2,7],
			],inf).stutter(2),
			\octave, 6,
			\dur, 1,
			\amp, 0.2,
			\out, BusDef(\pad, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\pad, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([2000,124],1), 32,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[210].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.12 * Pseg(Pseq([0,1,1,1,1.1],1),8),
		),
	])
)).play;
);

(
//////////// main 2
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(16,Pdef(\intro)),
		Pfindur(32,Pdef(\part1br)),
		Pfindur(32,Pdef(\part2dir)),
		Pfindur(31.5,Pdef(\bintro)),
		Pfindur(0.5, Pbind(\isRest, true)),
		Pfindur(32,Pdef(\part4)),
		Pfindur(32,Pdef(\part3)),
	])
)).play;
);
