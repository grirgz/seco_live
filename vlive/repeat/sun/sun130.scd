
(
FileSystemProject.loadOnce("sun/main.scd");
~t = 135/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
)

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
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1094].value,
			\bufnum, ~buflib.kick[753].value,
			\bufnum, ~buflib.kick[202].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.071,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1674].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.06,
		),
		Pbind(
			\instrument, \bassbla,
			\note, Pseq([
				0,\r,0,\r,
				0,\r,0,\r,
				0,\r,0,\r,
				0,0,\r,0,

				0,\r,0,\r,
				0,\r,0,\r,
				0,\r,0,\r,
				0,\r,\r,0,

				0,\r,0,\r,
				0,\r,0,\r,
				0,\r,0,\r,
				0,0,\r,0,

				0,\r,0,\r,
				0,\r,0,\r,
				0,\r,0,\r,
				0,0,\r,\r,
			],inf),
			\ctranspose, Pstep(Pseq([7,9,7,5],inf),2),
			\delayselect, 0.31,
			\lpf, PmodEnv(Pseq([100,400],1), 8,\exp).loop,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[1,4,7],
				[2,5,9],
				[1,4,7],
				[2,5,9-12],
			],inf),
			\octave, 6,
			\dur, 2,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				10,10,10,9,
				10,10,10,9,
				7,7,7,4,
				2,2,2,13,
			],inf).stutter(4),
			\isRest, Pseq([
				1,1,1,1, 1,1,0,1,
				1,1,1,1, 1,1,0,1,
				1,0,1,1, 1,1,1,1,
				1,1,1,1, 1,1,0,1,
			],inf).coin.not,
			\lpf, PmodEnv(Pseq([230,400],1), 32, \exp).loop,
			\legato, 0.5 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			\adsr, Pseq([
				Pswitch1(
					[
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
						[ Env.adsr(0.21,0.1,0.8,1.1) ],
						[ Env.adsr(0.01,0.01,0.3,0.01) ],
					], 
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,2,1,2, 2,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,2,2,2, 0,0,0,0,
					],inf)
				),
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
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1094].value,
			\bufnum, ~buflib.kick[753].value,
			\bufnum, ~buflib.kick[202].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.071,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1674].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.06,
		),
		Pbind(
			\instrument, \bassbla,
			\note, Pseq([
				0,\r,0,\r,
				0,\r,0,\r,
				0,\r,0,\r,
				0,0,\r,0,

				0,\r,0,\r,
				0,\r,0,\r,
				0,\r,0,\r,
				0,\r,\r,0,

				0,\r,0,\r,
				0,\r,0,\r,
				0,\r,0,\r,
				0,0,\r,0,

				0,\r,0,\r,
				0,\r,0,\r,
				0,\r,0,\r,
				0,0,\r,\r,
			],inf),
			\ctranspose, Pstep(Pseq([7,9,7,5],inf),2),
			\delayselect, 0.31,
			\lpf, PmodEnv(Pseq([100,400],1), 8,\exp).loop,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[1,4,7],
				[2,5,9],
				[1,4,7],
				[2,5,9-12],
			],inf),
			\octave, 6,
			\dur, 2,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				1,1,2,2,
			],inf),
			\dur, 1,
			\amp, 0.1,
			\isRest, true,
		),
		
	])
)).play;
);

///////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1167].value,
			\bufnum, ~buflib.snare[1708].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/8,
			\out, BusDef(\fill, \audio),
		),
		Pmono(\fx_flanger,
			\flangefreq, 1/8/4/~t,
			\fb, 0.10000000149012,
			\maxdelay, 0.19999999552965,
			\lfomul, 0.0199999997764826,
			\delay, 0.1049999998882413,
			\mix, 0.5,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\inbus, BusDef(\fill, \audio),
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
			\instrument, \sh101,
			\note, Pseq([
				[0,4,7,12],
				[4,7,11,4+12],
			],inf).stutter(4),
			\strum, 0.25,
			\octave, 5,
			\envamt, PmodEnv(Pseq([9,2,8],1), 8).loop,
			\lpadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.04,0.3,1.1) ],
			],inf),
			\lpf, 300,
			\legato, 0.4,
			\dur, 1,
			\amp, 0.1/4,
			\out, BusDef(\fill, \audio),
		),
		Pmono(\fx_flanger,
			\flangefreq, 1/8/4/~t,
			\fb, 0.30000000149012,
			\maxdelay, 0.19999999552965,
			\lfomul, 0.00099999997764826,
			\delay, 0.00049999998882413,
			\mix, 0.3,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\inbus, BusDef(\fill, \audio),
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
			\instrument, \sh101,
			\note, Pseq([
				[0,4,7,12],
				[4,7,11,4+12],
			],inf).stutter(4),
			\strum, 0.25,
			\octave, 5,
			\envamt, PmodEnv(Pseq([9,2,8],1), 8).loop,
			\lpadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.04,0.3,1.1) ],
			],inf),
			\lpf, 300,
			\legato, 0.4,
			\dur, 1,
			\amp, 0.1/4,
			\out, BusDef(\fill, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\fill),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0.51,
			\sendbus0, BusDef(\flanger, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_flanger,
			\inbus, BusDef(\flanger, \audio),
			\flangefreq, 1/8/4/~t,
			\fb, 0.80000000149012,
			\maxdelay, 0.19999999552965,
			\lfomul, 0.00099999997764826,
			\delay, 0.00049999998882413,
			\mix, 1,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\flanger2, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\flanger2, \audio),
			\addAction, \addToTail,
			\hpf, 2700,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

/////////


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				[0,4,7,12],
				[4,7,11,4+12],
				[0,4,7,12],
				[4,7,11,4+12],
				[2,5,9,0+12],
				[2,7,11,2+12],
				//[5,9,12,5+12],
			],inf).stutter(4),
			\strum, 0.25,
			\octave, 5,
			\envamt, PmodEnv(Pseq([9,2,8],1), 8).loop,
			\lpadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.04,0.3,1.1) ],
			],inf),
			\lpf, PmodEnv(Pseq([100,1000],1), 32,\exp).loop,
			\legato, 0.4,
			\dur, 1,
			\amp, 0.1/4,
			\out, BusDef(\fill, \audio),
		),
		Pmono(\fx_flanger,
			\flangefreq, 1/8/4/~t,
			\fb, 0.60000000149012,
			\maxdelay, 0.19999999552965,
			\lfomul, 0.10099999997764826,
			\delay, 0.01049999998882413,
			\mix, 0.3,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\inbus, BusDef(\fill, \audio),
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
			\bufnum, ~buflib.kick[409].value,
			\bufnum, ~buflib.kick[1488].value,
			//\bufnum, ~buflib.kick[36].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1102].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[961].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.08 * Pseq([
				0.5,0.7,0.4,1,
			],inf),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				[0,4,7,12],
				[4,7,11,4+12],
				[0,4,7,12],
				[4,7,11,4+12],
				[2,5,9,0+12],
				[2,7,11,2+12],
				//[5,9,12,5+12],
			],inf).stutter(4),
			\strum, 0.25,
			\octave, 5,
			\envamt, PmodEnv(Pseq([9,2,8],1), 8).loop,
			\lpadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.04,0.3,1.1) ],
			],inf),
			\lpf, PmodEnv(Pseq([100,1000],1), 32,\exp).loop,
			\legato, 0.4,
			\dur, 1,
			\amp, 0.1/4,
			\out, BusDef(\fill, \audio),
		),
		Pmono(\fx_flanger,
			\flangefreq, 1/8/4/~t,
			\fb, 0.60000000149012,
			\maxdelay, 0.19999999552965,
			\lfomul, 0.10099999997764826,
			\delay, 0.01049999998882413,
			\mix, 0.3,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\inbus, BusDef(\fill, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0, 4, 0, 4, 2, 7,
			],inf).stutter(8*4),
			\octave, 3,
			\lpf, 200,
			\legato, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,1,0,1, 1,0,1,1,
			],inf)*0.7,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.071,
		),
		Pbind(
			\instrument, \fmline2,
			\note, Pseq([
				0, 4, 0, 4, 2, 7,
			],inf).stutter(1),
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);


(
SynthDef(\fmline2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(Env([1,2,2400],[0.1,0.8],\exp), 1);
	mod2 = SinOsc.ar(freq) * 10 * env1;
	mod1 = SinOsc.ar(freq*2 + mod2) * 100;
	sig1 = SinOsc.ar(freq + mod1);

	env1 = EnvGen.kr(Env([14000,200,40],[0.1,0.8],\exp), 1);
	env2 = EnvGen.kr(Env([14,2,1],[0.1,1.8],\exp), 1);
	mod2 = LFCub.ar(freq + ( sig1 * env2 )) * 80 * env1;
	mod1 = SinOsc.ar(freq*2 + mod2) * freq * 2;
	sig2 = LFCub.ar(freq*3/2 + mod1, 0.2);

	sig = [sig1, sig2].mean;
	//sig = sig2;

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1.1,0.1,0.8,1.1,1,1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[409].value,
			\bufnum, ~buflib.kick[1488].value,
			//\bufnum, ~buflib.kick[36].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1102].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[961].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.08 * Pseq([
				0.5,0.7,0.4,1,
			],inf),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				[0,4,7,12],
				[4,7,11,4+12],
				[0,4,7,12],
				[4,7,11,4+12],
				[2,5,9,0+12],
				[2,7,11,2+12],
				[2,5,9,0+12],
				[2,7,11,2+12],
				//[5,9,12,5+12],
			],inf).stutter(4),
			\strum, 0.25,
			\octave, 5,
			\envamt, PmodEnv(Pseq([9,2,8],1), 8).loop,
			\lpadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.04,0.3,1.1) ],
			],inf),
			\lpf, PmodEnv(Pseq([100,1000],1), 32,\exp).loop,
			\legato, 0.4,
			\dur, 1,
			\amp, 0.1/4,
			\out, BusDef(\fill, \audio),
		),
		Pmono(\fx_flanger,
			\flangefreq, 1/8/4/~t,
			\fb, 0.60000000149012,
			\maxdelay, 0.19999999552965,
			\lfomul, 0.10099999997764826,
			\delay, 0.01049999998882413,
			\mix, 0.3,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\inbus, BusDef(\fill, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0, 4, 0, 4, 2, -1, 2,7,
			],inf).stutter(8*4),
			\octave, 3,
			\lpf, 200,
			\legato, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,1,0,1, 1,0,1,1,
			],inf)*0.7,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.071,
		),
		Pbind(
			\instrument, \fmline2,
			\note, Pseq([
				0, 4, 0, 4, 2, -1, 2,7,
			],inf).stutter(1),
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);
