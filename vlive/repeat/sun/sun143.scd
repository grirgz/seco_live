
(
~t = 180/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[58].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[807].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 1,0,0,1,
				//0,1,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[166].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,1, 1,0,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,3,4,3,2,3,1
			],inf),
			\octave, 3,
			\lpf, Pseg(Pseq([200,300,450],1),16,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\amp, 0.071,
		),
		Pbind(
			\instrument, \sh101,
			\saw, 0,
			\note, Pseq([
				3,2,1,0,
			],inf).stutter(8),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\lpf, 400,
			\legato, Pseq([
				0.7,0.7,0.7,0.1, Pseq([0.1],4),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \mellowpad,
			\fspread, 0.0012000000569969,
			\fspread2, 0.0020000000949949,
			\lpf, 120.0,
			\kbamt, 0.0,
			\lpenvamt, Pseg(Pseq([0.4,2,4],1),16,\exp).loop,
			\rq, 0.30000001192093,
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.1, 0.10000000149012, 2.1000000238419 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\spread, 0.80000001192093,
			\saw, 0,
			\note, Pseq([
				9,8,7,6,
			],inf).stutter(1)+2,
			\isRest, Pseq([
				1,1,1,0, 0,0,0,0,
				1,1,1,0, 0,0,0,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\dur, Pseq([
				1.5,1/2,1,1,
				1.5,1/2,1,1,
				1.5,1/2,1.5,1/2,
				1.5,1/2,1.5,1/2,
			],inf),
			\amp, 0.1/2,
			\out, BusDef(\hic, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\hic, \audio),
			\delay, 1/4/~t,
			\diffmul, 1.5,
			\decay, 4/~t,
			\addAction, \addToTail,
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
			\bufnum, ~buflib.kick[58].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[807].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 1,0,0,1,
				//0,1,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[166].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,1, 1,0,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,3,4,3,2,3,1
			],inf),
			\octave, 3,
			\lpf, Pseg(Pseq([200,300,450],1),16,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\amp, 0.071,
		),
		Pbind(
			\instrument, \sh101,
			\saw, 0,
			\note, Pseq([
				3,2,1,0,
			],inf).stutter(8),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\lpf, 400,
			\legato, Pseq([
				0.7,0.7,0.7,0.1, Pseq([0.1],4),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\amp, 0.1,
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\hic, \audio),
			\delay, 1/4/~t,
			\diffmul, 1.5,
			\decay, 4/~t,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[7,12],[12,3],4,
				[7,11],[11,3],9,
			],inf),
			\octave, 6,
			\dur, Pseq([4,3,1],inf),
			\amp, 0.1,
			\out, BusDef(\pad, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\pad, \audio),
			\addAction, \addToTail,
			\room, 2,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);


(
SynthDef(\pulsedrone, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	lfo2 = XLine.kr(1,100,16/~t);
	lfo1 = SinOsc.ar(8*~t) * 0.4 + 1 * 100 * lfo2; 
	mod1 = SinOsc.ar(freq) * lfo1;
	sig = SinOsc.ar(freq + mod1);
	sig = sig * SinOsc.ar(8*~t).unipolar; 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
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
			\bufnum, ~buflib.kick[58].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
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



