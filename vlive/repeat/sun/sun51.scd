
~t = 132/2/60; TempoClock.default.tempo = ~t;


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[480].value,
			\bufnum, ~buflib.kick[1059].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1631].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pdef(\acidtrem, Pbind(\instrument, \acidtrem)) <>
		Pmono(\acidtrem,
			\note, Pseq([
				5,0,2,4,
			],inf),
			\dur, Pseq([
				1,1,2-(1/16),1/16
			],inf)*2,
			\octave, 3,
			\amp, 0.1,
			\tremfreq, 8*~t,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_flanger,
			\flangefreq, 1.5*~t,
			\fb, 0.10000000149012,
			\maxdelay, 0.019999999552965,
			\lfomul, 0.0019999997764826,
			\delay, 0.0001999998882413,
			\mix, 0.5,
			\gain, 1.0,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

ProtoDef(\piano).startControl()
Pdef(\acidtrem).edit
Pdef(\acidtrem).presetCompileString.editorInsert
(
Pdef('acidtrem').setVal('ffscale', 6.4876406187238);
Pdef('acidtrem').setVal('tremfac', 2.5491518880364);
Pdef('acidtrem').setVal('trembias', 12.093374395794);
Pdef('acidtrem').setVal('wave', 0.88432621454712);
Pdef('acidtrem').setVal('oct', 0.36980050469245);
Pdef('acidtrem').setVal('lpfr', 1.5489134175503);

);

~t

(
SynthDef(\acidtrem, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var ffenv = EnvGen.kr(Env([0,1,0],[\ffat.kr(0.05),\ffrel.kr(0.1)], 1, 1,1), gate, levelScale:\ffscale.kr(700));
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(\tremfreq.kr(8 * ~t)) * \tremfac.kr(0.7) + \trembias.kr(2);
	freq = freq * [1/2,1,2,];
	sig = SelectX.ar(\wave.kr(0.9),[ Saw.ar(freq),Pulse.ar(freq) ]);
	sig = SelectX.ar(\oct.kr(0.1)*2, sig);
	sig = RLPF.ar(sig, \lpfr.kr(2.6) * freq * lfo1 + ffenv, \rq.kr(0.1), mul:\distgain.kr(0.5)).distort;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.4,1,-1)), gate, doneAction:2);
	pan = [-0.1,0.1];
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pmono(\acidtrem,
			\ffat, 0.050000000745058,
			\ffrel, 0.10000000149012,
			\ffscale, 700.0,
			\tremfreq, 8.8000001907349,
			\tremfac, 1.99999998807907,
			\trembias, 2.0,
			\wave, 0.89999997615814,
			\oct, ~pmodenv.(Pseq([0,1,0.5],4), 1/2).loop,
			\lpfr, 1.5999999046326,
			\rq, 0.20000000149012,
			\distgain, 0.5,
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.0099999997764826, 0.10000000149012, 0.40000000596046 ], [ -1.0, -1.0, -1.0 ], 2.0) ],
			\note, Pseq([
				5,0,2,4,
			],inf),
			\dur, Pseq([
				1,1,2-(1/16),1/16
			],inf)*2,
			\octave, 4,
			\amp, 0.1,
			\tremfreq, 8*~t,
		),
	])
)).play;
);



/////////////////////////////

FileSystemProject.load("holis/synthdef.scd");

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,0,
				12,12,
				-7,12,
				0,12+5,
			],inf),
			\ctranspose, Pstep(Pseq([
				0,0,0,0, 
				0,0, 7,5,
			],inf),1),
			\lpf, 1000,
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1/4,
		),
		Pdef(\acidtrem, Pbind(\instrument, \acidtrem)) <>
		Pbind(
			\instrument, \acidtrem,
			\note, Pseq([
				0,0,12,7,
			],inf).stutter(2),
			\ctranspose, Pstep(Pseq([
				0,0,0,0, 
				0,0, 7,5,
			],inf),1),
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \acidtry2,
			\note, Pseq([
				-7,\r,\r,-7,
			   	14,17,14,0,
				0,12,\r,\r,
			   	14,17,14,0,
			],inf).stutter(1),
			\ctranspose, Pstep(Pseq([
				0,0,0,0, 
				0,0, 7,5,
			],inf),1),
			\ffat, ~pmodenv.(Prand([0.41,0.2,0.1,0.4]/13,inf), 8),
			\ffrel, ~pmodenv.(Pseq([0.41,0.2,0.1,0.4],inf), 8),
			\ffscale, ~pmodenv.(Pseq([700,2000,100],inf), 3),
			\lpfr, ~pmodenv.(Pseq([1,1/2,2,1/4],inf), 7),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\oct, Pseq([
				1/2,1/4,3/5,7/9,4/7,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1131].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,1,0,1,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,1,0,1,
				1,0,1,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[480].value,
			\bufnum, ~buflib.kick[1059].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1631].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\acidtry2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var ffenv = EnvGen.kr(Env([0,1,0],[\ffat.kr(0.05),\ffrel.kr(0.1)], 1, 1,1), gate, levelScale:\ffscale.kr(700));
	freq = freq * [1/2,1,2,];
	sig = SelectX.ar(\wave.kr(0.9),[ Saw.ar(freq),Pulse.ar(freq) ]);
	sig = SelectX.ar(\oct.kr(0.1)*2, sig);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq + ffenv, \rq.kr(0.1), mul:\distgain.kr(0.5)).distort;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.4,1,-1)), gate, doneAction:2);
	pan = [-0.1,0.1];
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\degree, Pseq([
				0,0,
				7,7,
				-4,7,
				0,7+3,
			],inf),
			\ctranspose, Pstep(Pseq([
				0,0,0,0, 
				0,0, 7,5,
			],inf),1),
			\lpf, 1000,
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1/4,
		),
		Pdef(\acidtrem, Pbind(\instrument, \acidtrem)) <>
		Pbind(
			\instrument, \acidtrem,
			\note, Pseq([
				0,0,12,7,
			],inf).stutter(2),
			\ctranspose, Pstep(Pseq([
				0,0,0,0, 
				0,0, 7,5,
			],inf),1),
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \acidtry2,
			\note, Pseq([
				-7,\r,\r,-7,
			   	14,17,14,0,
				0,12,\r,\r,
			   	14,17,14,0,
			],inf).stutter(1),
			\ctranspose, Pstep(Pseq([
				0,0,0,0, 
				0,0, 7,5,
			],inf),1),
			\ffat, ~pmodenv.(Prand([0.41,0.2,0.1,0.4]/13,inf), 8),
			\ffrel, ~pmodenv.(Pseq([0.41,0.2,0.1,0.4],inf), 8),
			\ffscale, ~pmodenv.(Pseq([700,2000,100],inf), 3),
			\lpfr, ~pmodenv.(Pseq([1,1/2,2,1/4],inf), 7),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\oct, Pseq([
				1/2,1/4,3/5,7/9,4/7,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1131].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,1,0,1,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,1,0,1,
				1,0,1,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[480].value,
			\bufnum, ~buflib.kick[1059].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1631].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		
	])
)).play;
);


/////// test degree


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \basicbass,
			\degree, Pseq([
				0,7,
				-3,7,
			],inf),
			\ctranspose, Pstep(Pseq([
				0,0,0,0, 
				0,0, 7,5,
			],inf),1),
			\lpf, 1000,
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \basicbass,
			\degree, Pseq([
				0,4,2b+7,2
			],inf),
			\ctranspose, Pstep(Pseq([
				0,0,0,0, 
				0,0, 7,5,
			],inf),1),
			\lpf, 1000,
			\octave, 5,
			\dur, 1/4,
			\amp, 0.1/4,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \basicbass,
			\degree, Pseq([
				0,7,
				-3,7,
			],inf),
			\mtranspose, Pstep(Pseq([
				0,0,0,0, 
				0,0, 4,3,
			],inf),1),
			\lpf, 1000,
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \basicbass,
			\degree, Pseq([
				0,4,2b+7,2
			],inf),
			\mtranspose, Pstep(Pseq([
				0,0,0,0, 
				0,0, 4,3,
			],inf),1),
			\lpf, 1000,
			\octave, 5,
			\dur, 1/4,
			\amp, 0.1/4,
		),
	])
)).play;
);


///////////////////////// punk drums
~t = 250/2/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[480].value,
			\bufnum, ~buflib.kick[1059].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,1,0,
				1,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				Pwhite(0.9,1,1),
				Phprand(0.5,1,1),
				Phprand(0.4,1,1),
				Pexprand(0.2,0.7,1),
			],inf).stutter(2),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1631].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1131].value,
			\bufnum, ~buflib.hat[119].value,
			\bufnum, [
				~buflib.hat[253].value,
				~buflib.hat[119].value,
			],
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\velo, Pseg(Pseq([0,0,1],1),4).loop,
			\legato, Pkey(\velo).linlin(0,1,0.1,2),
			\gain, 0.11 * Pkey(\velo).linlin(0,1,0.3,1/2),
		),
	])
)).play;
);

~t = 200/2/60; TempoClock.default.tempo = ~t;
(
	~swing = 0.32;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[480].value,
			\bufnum, ~buflib.kick[1059].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0.91,0, 0,0,0.51,0,
				1,0,0.51,0, 0,0,0.21,0,
			],inf).coin.not,
			\gain, 0.1 * Pseq([
				Phprand(0.9,1,1),
				Phprand(0.2,0.5,1),
				Phprand(0.4,1,1),
				Pexprand(0.1,0.5,1),
				Phprand(0.4,1,1),
				Phprand(0.2,0.5,1),
				Phprand(0.4,1,1),
				Pexprand(0.1,0.5,1),
			],inf).stutter(2),
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,0,-1,0],inf))),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1631].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1131].value,
			\bufnum, ~buflib.hat[119].value,
			\bufnum, [
				~buflib.hat[253].value,
				~buflib.hat[119].value,
			],
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,0,-1,0],inf))),
			\velo, Pseg(Pseq([0,0,1],1),4).loop,
			\legato, Pkey(\velo).linlin(0,1,0.1,2),
			\gain, 0.11 * Pkey(\velo).linlin(0,1,0.3,1/2),
		),
	])
)).play;
);

(
	~swing = 0.32;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[480].value,
			\bufnum, ~buflib.kick[1059].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0.91,0, 0,0,0.51,0,
				1,0,0.51,0, 0,0,0.21,0,
			],inf).coin.not,
			\gain, 0.1 * Pseq([
				Phprand(0.9,1,1),
				Phprand(0.2,0.5,1),
				Phprand(0.4,1,1),
				Pexprand(0.1,0.5,1),
				Phprand(0.4,1,1),
				Phprand(0.2,0.5,1),
				Phprand(0.4,1,1),
				Pexprand(0.1,0.5,1),
			],inf).stutter(2),
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,0,-1,0],inf))),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1631].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1564].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing/2 * Pseq([1,0,-1,0],inf))),
			\velo, Pseg(Pseq([0,1],1),4).loop,
			\velo, Pseg(Pseq([0,0,1],1),4).loop,
			\legato, Pkey(\velo).linlin(0,1,0.1,2),
			\gain, 0.15 * Pkey(\velo).linlin(0,1,0.3,1/2),
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \acidtry2,
			\degree, Pseq([
				0,2,4,0,
			],inf),
			\mtranspose, -2
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\degree, Prout({ arg ev;
				var li = List.new;
				20.do { arg item, idx;
					li.add(idx);
					ev = li.yield
				};
			}).stutter(8),
			\isRest, Pseq([
				1,0,0,0, 1,0,0,1,
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1631].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.15,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \acidtry2,
			\degree, Prout({ arg ev;
				var li = List.new;
				var ref = (0..20);
				20.do { arg item, idx;
					li.add(ref.removeAt(ref.size.rand));
					ev = li.yield
				};
			}).stutter(16),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 5,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,1,
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1631].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.25,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[480].value,
			\bufnum, ~buflib.kick[1059].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 0,1,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,1, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \acidtry2,
			\degree, Pstep(Pseq([
				[0,2b+7,4],
				[0,2b+7,4],
				[0,2b+7,4],
				[0,2+7,4],
			],inf),1),
			\ctranspose, Pstep(Pseq([
				0,0,2,1,
			],inf),1),
			\strum, 0.01,
			\oct, ~pmodenv.(Pseq([1,2,1,4]/4,1), 1/8).loop,
			\lpfr, ~pmodenv.(Pseq([1,6,4,8],1), 8).loop,
			\ffat, 0.15,
			\ffrel, 0.05,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 5,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,1,
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \acidtry2,
			\degree, Pseq([
				0,2b+7,4,6,
			],inf).stutter(1),
			\degree, Pindex(
				Pstep(Pseq([
					[0,2b+7,4],
					[0,2b+7,4],
					[0,2b+7,4],
					[0,2+7,4],
				],inf),1),
				Pseq([
					0,0,1,2,0,2,0,2
				],inf),
			),
			\ctranspose, Pstep(Pseq([
				0,0,2,1,
			],inf),1),
			\strum, 0.01,
			\oct, ~pmodenv.(Pseq([1,2,0,4]/4,1), 1/8).loop,
			\lpfr, ~pmodenv.(Pseq([1,6,4,8],1), 8).loop,
			\ffat, 0.005,
			\ffrel, 0.5,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 4,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1631].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.25,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[480].value,
			\bufnum, ~buflib.kick[1059].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 0,1,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,1, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \acidtry2,
			\degree, Pstep(Pseq([
				Pseq([
					[0,2b+7,4,14],
				],3),
				[0,2+7,4,2+14],
			],inf),1),
			\ctranspose, Pstep(Pseq([
				0,0,2,1,
			],inf),1),
			\strum, 0.01,
			\oct, ~pmodenv.(Pseq([1,2,1,4]/4,1), 18).loop,
			\lpfr, ~pmodenv.(Pseq([1,6,4,8]/4,1), 8).loop,
			\rq, 0.1,
			\ffat, 0.45,
			\ffrel, 0.5,
			\ffscale, 4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.5) ],
			],inf),
			\octave, 5,
			\legato, Pseq([
				16,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				6,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \acidtry2,
			\degree, Pseq([
				0,2b+7,4,6,
			],inf).stutter(1),
			\degree, Pindex(
				Pstep(Pseq([
					[0,2b+7,4],
					[0,2b+7,4],
					[0,2b+7,4],
					[0,2+7,4],
				],inf),1),
				Pseq([
					0,0,1,2,0,2,0,2
				],inf),
			),
			\ctranspose, Pstep(Pseq([
				0,0,2,1,
			],inf),1),
			\strum, 0.01,
			\oct, ~pmodenv.(Pseq([1,2,0,4]/4,1), 1/8).loop,
			\lpfr, ~pmodenv.(Pseq([1,6,4,8],1), 8).loop,
			\ffat, 0.005,
			\ffrel, 0.5,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 4,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1631].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.25,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[480].value,
			\bufnum, ~buflib.kick[1059].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 0,1,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,1, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		
	])
)).play;
);


(
SynthDef(\sinoct, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var ifreq;
	ifreq = freq;
	freq = freq * [1/2,1,2];
	mod1 = ( SinOsc.ar(freq * \fmr.kr(1)) * \fmamp.kr(0.5) + 1 );
	mod1 = SelectX.ar((\oct2.kr(0.5)*2 ).fold(0,2), mod1);
	sig = SinOsc.ar(freq * mod1);
	sig = SelectX.ar(( \oct.kr(0.5)*2).fold(0,2), sig);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = SelectX.ar(( \oct3.kr(0.5)*2).fold(0,2), sig);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sinoct,
			\note, Pseq([
				0,2,4,5,
			],inf),
			//\oct, ~pmodenv.(Pseq([0,1],1), 8).loop,
			//\oct2, ~pmodenv.(Pseq([0,1],1), 4).loop,
			\fmamp, 0.1,
			\rq, 0.1,
			\lpfr, 3,
			\fmr, 4,
			\oct2, Pseq([
				0
			],inf),
			\oct, ~pmodenv.(Pseq([0,1],1), 4).loop,
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\sinoct, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var ifreq;
	ifreq = freq;
	freq = freq * [1/2,1,2];
	env1 = EnvGen.kr(Env([0,2,0],[0.5,0.8]), 1);
	sig = SinOsc.ar(freq);
	sig = sig.tanh;
	sig = SelectX.ar(( \oct.kr(0.5)*2+ env1).fold(0,1.99) , sig);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

//////////////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, Pswitch1(
				[
					~buflib.kick[1059].value,
					~buflib.snare[1631].value,
					~buflib.hat[1564].value,
				], 
				Pseq([
					Pseq([
						0,
						Prand([0,1,2],1),
						1,
						Prand([0,1,2],1),
					],inf),
					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0,

					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,1,
				],inf)
			),
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				1
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.25,
		),
		
	])
)).play;
);
