
// floxytek raw
(
~t = 190/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
);

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

SynthDef(\sdkick, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1|
	var env0, env1, env1m;
	var sig;

	//freqpan = [-1,0,1] * freqpan;
	env0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.005, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([210, 62, 59], [0.045, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	
	sig = LFPulse.ar(env1 * freqpan, 0, 0.5, 1, -0.5);
	sig = sig + WhiteNoise.ar(1);
	sig = LPF.ar(sig, env1*fratio);
	sig = sig + SinOsc.ar(env1, 0.5);
	sig = LPF.ar(sig, \lpf.kr(2000));
	
	//sig = sig * 1.2;
	//sig = sig.clip2(1);

	sig = sig * env0;
	sig = Pan2.ar(sig, pan, amp);
	
	OffsetOut.ar(out, sig);
}, metadata:(specs:(
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
	env0: ParamEnvSpec(\amp),
	env1: ParamEnvSpec(\freq),
))).add;

SynthDef(\dispers, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv, lpfreq;
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.02) + 1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.2)), gate, doneAction:0) * \lpadsramt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	sig = RLPF.ar(sig, ( \lpf.kr(330) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\simplesin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\simplewhitenoise, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar(1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
// dissonant plok
// i should try a pluck sound
SynthDef(\displok, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 3;
	sig = Klang.ar(Ref([ [800, 1000, 1200] ++ exprand(800.0,4000!3), [0.3, 0.3, 0.3] ++ exprand(0.01,0.1!3), [pi, pi, pi]]), \freqscale.kr(1), 0);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\wnpluck, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, coef=0, decay=10;
	var sig;
	var ex;
	ex = WhiteNoise.ar(1);
	//ex = LFSaw.ar(freq);
    sig = Pluck.ar(ex, Impulse.ar(0), freq.reciprocal, [1,1.001] * freq.reciprocal, decay, coef:coef);
	//sig = RLPF.ar(sig, \lpfr.kr(4)*freq, \rq.kr(0.05)) * 1 + ( sig/4 );
	sig = HPF.ar(sig, 5000);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,1.4),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
SynthDef(\rpluck, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, coef=0, decay=10;
	var sig;
	var ex;
	ex = WhiteNoise.ar(1);
	//ex = LFSaw.ar(freq);
    sig = Pluck.ar(ex, Impulse.ar(0), freq.reciprocal, [1,1.001] * freq.reciprocal, decay, coef:coef);
	//sig = RLPF.ar(sig, \lpfr.kr(4)*freq, \rq.kr(0.05)) * 1 + ( sig/4 );
	sig = HPF.ar(sig, \hpf.kr(500));
	sig = LPF.ar(sig, \lpf.kr(2500));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,1.4),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;

SynthDef(\multilift, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1,1.12,1.43,1.54]);
	sig = sig.mean;
	sig = RLPF.ar(sig, \lpf.kr(1800), \rq.kr(0.5));
	sig = HPF.ar(sig, 400);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

////////////
// structure:
// intro: 32 kicks until start of next section
// 1 beat = 2 kicks



(
// try with a bass synth instead of long kick
// length: 16 beats = 32 kick
Pdef(\part, Pdef(\fintro, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[495].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,1, 1,0,0,0,
				Pser([
					1,0,0,0, 1,0,0,0,
				],14*8),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kick, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kick),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, PmodEnv(Pseq([1,Pn(0,8)],1), 2).loop,
			\sendbus0, BusDef(\kickverb, \audio, 2),
			\send1, 1,
			\sendbus1, BusDef(\kicktrack, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.011,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \bassbla,
			\note, Pseq([
				8,
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1
				],1*2),
				Pser([
					1
				],15*2),
			],inf).coin.not,
			\rq, 0.7,
			\delayfac, 1,
			\lfofac, 1/2,
			\lfoa, 1,
			\lpf, 158,
			\lpenva, 0,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\kickverb, \audio),
			\addAction, \addToTail,
			\room, 2,
			\damp, 1,
			\lag, 0.0009,
			\mix, 1,
			\dur, 1,
			\out, BusDef(\kickverb1, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\kickverb1, \audio),
			\addAction, \addToTail,
			\hpf, 500,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,4,7,11],
			],inf),
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\pad, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\pad, \audio),
			\addAction, \addToTail,
			\hpf, 300,
			\lag, 0.0009,
			\dur, 1,
			\gain, PmodEnv(Pseq([0.01,1],1), 16,\exp).loop,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\fpart1, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\env0, [ Env([0,1,1.4,0],[0.002,0.02,0.1]) ],
			\env1, [ Env([2100,50,72],[0.017,0.4],[-4]) ],
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,0,0, // kick cut after sidechain
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2299].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.04,
			\out, BusDef(\main, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1133].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			//\isRest, true,
			\out, BusDef(\main, \audio),
		),
		Pbind(
			\instrument, \bassbla,
			\note, Pseq([
				8,
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1
				],1*2),
				Pser([
					1
				],15*2),
			],inf).coin.not,
			\rq, 0.7,
			\delayfac, 2,
			\lfofac, 8,
			\lpf, 258*8*4,
			\lpenva, 0,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, Pstep(Pseq([1,0],1),Pseq([7,1])).loop,
			\cpt, 0.021,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\main, \audio),
			\sideout, BusDef(\main, \audio),
		),
		Pmono(\tracksummer,
			\inbus, BusDef(\main, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \dispers,
			\fspread, 0.1,
			\lpadsr, [ Env([ 0.0, 1.0, 0.0 ], [ 1.6000000238419, 0.40000000596046 ], [ 4.0, 4.0 ]) ],
			\itrig, 1.0,
			\lpenvamt, 4.0,
			\lpf, 5400.0,
			\rq, 0.5,
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\spread, 0.80000001192093,
			\note, Pseq([
				0,
			],inf),
			\octave, 5,
			\note, Pseq([
				7,
			],inf),
			\freq, PmodEnv(Pseq([75,Pn(67,4)],1).midicps, 4).loop,
			\legato, 0.2,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1/4,
			\out, BusDef(\hiverb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\hiverb, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),

		
	])
)).play;
);

(
// 4 part of 8 beats = 32 beats, separated by synth at 16th beat
// part a
Pdef(\part, Pdef(\fpart2a, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\env0, [ Env([0,1,1.4,0],[0.002,0.02,0.1]) ],
			\env1, [ Env([2100,50,72],[0.017,0.4],[-4]) ],
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,0,0, // kick cut after sidechain
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2299].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.04,
			\out, BusDef(\main, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1133].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			//\isRest, true,
			\out, BusDef(\main, \audio),
		),
		Pbind(
			\instrument, \bassbla,
			\note, Pseq([
				8,
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1
				],1*2),
				Pser([
					1
				],15*2),
			],inf).coin.not,
			\rq, 0.7,
			\delayfac, 2,
			\lfofac, 8,
			\lpf, 258*8*4,
			\lpenva, 0,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, Pstep(Pseq([1,0],1),Pseq([6,2])).loop,
			\cpt, 0.021,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\main, \audio),
			\sideout, BusDef(\main, \audio),
		),
		Pmono(\tracksummer,
			\inbus, BusDef(\main, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pseq([
			Pfindur(14, Pbind()),
			Pfindur(2, Pbind(
				\legato, 0.2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),

			)),
		],inf) <>
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				1,8,7,6,5,5,5,5,
			],inf).stutter(2),
			\octave, 4,
			\lpf, 5600,
			\dur, 1/4,
			\amp, 0.1/2,
			\out, BusDef(\hpf, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\hpf, \audio),
			\addAction, \addToTail,
			\hpf, 1900,
			\lag, 0.0009,
			\dur, 1,
		),

		Ptpar([
			14, Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/feynman.flac'),
				\pos, 0,
				\speed, 0.3,
				\legato, 1,
				\dur, Pn(2,1),
				\gain, 1/2,
			)
		]),
		
	])
)).play;
);

(
// 4 part of 8 beats = 32 beats, separated by synth at 16th beat
// part b
Pdef(\part, Pdef(\fpart2b, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\env0, [ Env([0,1,1.4,0],[0.002,0.02,0.1]) ],
			\env1, [ Env([2100,50,72],[0.017,0.4],[-4]) ],
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,0,0, // kick cut after sidechain
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2299].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.04,
			\out, BusDef(\main, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1133].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			//\isRest, true,
			\out, BusDef(\main, \audio),
		),
		Pbind(
			\instrument, \bassbla,
			\note, Pseq([
				8,
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1
				],1*2),
				Pser([
					1
				],15*2),
			],inf).coin.not,
			\rq, 0.7,
			\delayfac, 2,
			\lfofac, 8,
			\lpf, 258*8*4,
			\lpenva, 0,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, Pstep(Pseq([1,0],1),Pseq([6,2])).loop,
			\cpt, 0.021,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\main, \audio),
			\sideout, BusDef(\main, \audio),
		),
		Pmono(\tracksummer,
			\inbus, BusDef(\main, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				1,8,7,6,5,5,5,5,
			],inf).stutter(2),
			\octave, 4,
			\lpf, 5600,
			\legato, Pstep(Pseq([0.8,0.3],inf),Pseq([2.5,1.5],inf)),
			\adsr, Pseq([
				Pstep( 
					Pseq([
						[ Env.adsr(0.1,0.1,0.8,1.1) ],
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					2
				),
			],inf),
			\dur, 1/4,
			\isRest, Pseq([
				1,1,1,1,
				1,1,1,1,
			],inf).coin.not,
			\amp, 0.1/2,
			\out, BusDef(\hpf, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\hpf, \audio),
			\addAction, \addToTail,
			\hpf, 1900,
			\lag, 0.0009,
			\dur, 1,
		),

		
	])
)).play;
);

(
Pdef(\part, Pdef(\fpart3breaka, 
	Ppar([
		Pbind(
			\instrument, \simplesin,
			\freq, PmodEnv(Pseq([100,50],1), 4,-4).loop,
			\octave, 5,
			\dur, 2,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],1).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \simplewhitenoise,
			\dur, 8,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,8/~t) ],
			],1),
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \dispers,
			\fspread, 0.1,
			\lpadsr, [ Env([ 0.0, 1.0, 0.0 ], [ 1.6000000238419, 0.40000000596046 ], [ 4.0, 4.0 ]) ],
			\itrig, 1.0,
			\lpenvamt, 4.0,
			\lpf, 5400.0,
			\rq, 0.5,
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\spread, 0.80000001192093,
			\note, Pseq([
				0,
			],inf),
			\octave, 5,
			\note, Pseq([
				7,
			],inf),
			\freq, PmodEnv(Pseq([75,Pn(67,4)],1).midicps, 4).loop,
			\legato, 0.2,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1/4,
			\out, BusDef(\hiverb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\hiverb, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \displok,
			\note, Pseq([
				0,
			],inf),
			\freqscale, Pseg(Pseq([2,1],1),8),
			\legato, 0.1,
			\octave, 5,
			\dur, Pwhite(1/2,1,inf),
			\amp, 0.05,
		),
		Ptpar([
			12, Pbind(
				\instrument, \simplewhitenoise,
				\dur, 4,
				\legato, 1,
				\adsr, Pseq([
					[ Env.adsr(4/~t,0.1,0.8,0.01,1,4) ],
				],1),
				\amp, 0.1/4,
			),
			15, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.snare[2299].value,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\isRest, Pseq([
						1,0,0,0, 1,0,1,1,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.04,
					\out, BusDef(\snareverb, \audio),
				),
				Pmono(\fx_freeverb2,
					\inbus, BusDef(\snareverb, \audio),
					\addAction, \addToTail,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
		]),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\fpart3breakb, 
	Ppar([
		Pbind(
			\instrument, \simplesin,
			\freq, PmodEnv(Pseq([100,50],1), 4,-4).loop,
			\octave, 5,
			\dur, 2,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],1).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \simplewhitenoise,
			\dur, 8,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,8/~t) ],
			],1),
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \displok,
			\note, Pseq([
				0,
			],inf),
			\freqscale, Pseg(Pseq([2,1],1),8),
			\legato, 0.1,
			\octave, 5,
			\dur, Pwhite(1/4,1,inf)/2,
			\amp, 0.05,
		),
		Ptpar([
			4, Pfindur(12,Pmono(
				\multilift,
				\freq, PmodEnv(Pseq([200,604],1), 12).loop,
				\adsr, Pseq([
					[ Env.adsr(8.1/~t,0.1,0.8,0.1,1,4) ],
				],inf),
				\legato, 1,
				\dur, 1,
				\amp, 0.1/2,
			)),
			12, Pbind(
				\instrument, \simplewhitenoise,
				\dur, 4,
				\legato, 1,
				\adsr, Pseq([
					[ Env.adsr(4/~t,0.1,0.8,0.01,1,4) ],
				],1),
				\amp, 0.1/4,
			),
			15, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.snare[2299].value,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\isRest, Pseq([
						1,0,0,0, 1,0,1,1,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.04,
					\out, BusDef(\snareverb, \audio),
				),
				Pmono(\fx_freeverb2,
					\inbus, BusDef(\snareverb, \audio),
					\addAction, \addToTail,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
		]),
		
	])
)).play;
);

(
// first pluck is 8 beats
// end of third pluck at 24 beats
Pdef(\part, Pdef(\fpart3breakc, 
	Ppar([
		Pbind(
			\instrument, \rpluck,
			\note, Pseq([
				8,10,11,13,
			],3).stutter(8),
			\octave, 3,
			\coef, 0.3,
			\dur, 1/4,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \rpluck,
			\note, Pseq([
				Pser([
					\r
				],2*8),
				Pseq([
					11,8,8,8,
					13,10,10,10,
					15,11,11,11,
					17,13,13,13,
				],2),
			],1).stutter(1),
			\octave, 4,
			\coef, 0.3,
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \rpluck,
			\note, Pseq([
				Pser([
					\r
				],2*16),
				8,15,11,10,
				6,13,10,8,
				3,8,6,5,
				5,11,8,6,
			],1).stutter(1),
			\octave, 5,
			\coef, 0.3,
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \simplewhitenoise,
			\dur, 8,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(8.1/~t,0.1,0.8,8/~t) ],
			],1),
			\amp, 0.1/4,
		),
		Ptpar([
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[2299].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
				],16).coin.not,
				\dur, 1/8,
				\gain, 0.04,
			),
			24, Ppar([
				
				Pbind(
					\instrument, \simplesin,
					\freq, PmodEnv(Pseq([100,50],1), 4,-4).loop,
					\octave, 5,
					\dur, 2,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
					],1).coin.not,
					\amp, 0.1,
				),
				Pbind(
					\instrument, \simplewhitenoise,
					\dur, 8,
					\legato, 0.1,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,0.8,8/~t) ],
					],1),
					\amp, 0.1/4,
				),
				Pbind(
					\instrument, \dispers,
					\fspread, 0.1,
					\lpadsr, [ Env([ 0.0, 1.0, 0.0 ], [ 1.6000000238419, 0.40000000596046 ], [ 4.0, 4.0 ]) ],
					\itrig, 1.0,
					\lpenvamt, 4.0,
					\lpf, 5400.0,
					\rq, 0.5,
					\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
					\spread, 0.80000001192093,
					\note, Pseq([
						0,
					],inf),
					\octave, 5,
					\note, Pseq([
						7,
					],inf),
					\freq, PmodEnv(Pseq([75,Pn(67,4)],1).midicps, 4).loop,
					\legato, 0.2,
					\isRest, Pseq([
						1,1,
					],inf).coin.not,
					\dur, 1/4,
					\amp, 0.1/4,
					\out, BusDef(\hiverb, \audio),
				),
				Pmono(\fx_freeverb2,
					\inbus, BusDef(\hiverb, \audio),
					\addAction, \addToTail,
					\lag, 0.0009,
					\dur, 1,
				),
				Pbind(
					\instrument, \displok,
					\note, Pseq([
						0,
					],inf),
					\freqscale, Pseg(Pseq([2,1],1),8),
					\legato, 0.1,
					\octave, 5,
					\dur, Pwhite(1/2,1,inf),
					\amp, 0.05,
				),
			]),
			30, Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/feynman.flac'),
				\pos, 0,
				\speed, 0.3,
				\legato, 1,
				\dur, Pn(2,1),
				\gain, 1/2,
			)
		]),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\fpart4a, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\env0, [ Env([0,1,1.4,0],[0.002,0.02,0.1]) ],
			\env1, [ Env([2100,50,72],[0.017,0.4],[-4]) ],
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,0,0, // kick cut after sidechain
				Pseq([
					1,0,0,0, 1,0,0,0,
				],6),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],1).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2299].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,1, 1,0,0,1,
				Pseq([
					0,0,0,0, 1,0,0,0,
				],6),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],1).coin.not,
			\dur, 1/8,
			\gain, 0.04,
			\out, BusDef(\main, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1133].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],14),
			],1).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			//\isRest, true,
			\out, BusDef(\main, \audio),
		),
		Pbind(
			\instrument, \bassbla,
			\note, Pseq([
				8,
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1
				],7*2),
				Pser([
					0
				],1*2),
				Pser([
					1
				],6*2),
				Pser([
					0
				],2*2),
			],inf).coin.not,
			\rq, 0.7,
			\delayfac, 2,
			\lfofac, 8,
			\lpf, 258*8*4,
			\lpenva, 0,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, Pstep(Pseq([1,0],1),Pseq([7,1])).loop,
			\cpt, 0.021,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\main, \audio),
			\sideout, BusDef(\main, \audio),
		),
		Pmono(\tracksummer,
			\inbus, BusDef(\main, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Ptpar([
			7, Pbind( // snare crash
				\instrument, \playersec,
				\bufnum, ~buflib.snare[574].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],1).coin.not,
				\legato, 4,
				\dur, 1/8,
				\gain, 0.11,
			),
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[834].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.05,
			),
			8+6, Ppar([
				Pbind( // sifle
					\instrument, \sh101,
					\note, Pseq([
						15,11,13,10,
					],1),
					\octave, 7,
					\dur, 1/2,
					\legato, 0.3,
					\lpf, 1000,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.2,0.1) ],
					],inf),
					\amp, 0.1/2,
					\out, BusDef(\sifleverb, \audio),
				),
				Pmono(\fx_freeverb2,
					\inbus, BusDef(\sifleverb, \audio),
					\addAction, \addToTail,
					\mix, 0.7,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
		]),

		
	])
)).play;
);

(
Pdef(\part, Pdef(\fpart4b, 
	Pfindur(16,Ppar([
		Pbind(
			\instrument, \sdkick,
			\env0, [ Env([0,1,1.4,0],[0.002,0.02,0.1]) ],
			\env1, [ Env([2100,50,72],[0.017,0.4],[-4]) ],
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0, // kick cut after sidechain
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2299].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,1, 1,0,0,1,
				Pseq([
					0,0,0,0, 1,0,0,0,
				],6),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],1).coin.not,
			\dur, 1/8,
			\gain, 0.04,
			\out, BusDef(\main, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1133].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],14),
			],1).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			//\isRest, true,
			\out, BusDef(\main, \audio),
		),
		Pbind(
			\instrument, \bassbla,
			\note, Pseq([
				8,
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1
				],7*2),
				Pser([
					0
				],1*2),
				Pser([
					1
				],6*2),
				Pser([
					0
				],2*2),
			],inf).coin.not,
			\rq, 0.7,
			\delayfac, 2,
			\lfofac, 8,
			\lpf, 258*8*4,
			\lpenva, 0,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, Pstep(Pseq([1,0],2),Pseq([7,1,6,2])).loop,
			\cpt, 0.021,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\main, \audio),
			\sideout, BusDef(\main, \audio),
		),
		Pmono(\tracksummer,
			\inbus, BusDef(\main, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Ppar([
			Pseq([
				Pfindur(8,Pbind( // sifle
					\instrument, \sh101,
					\note, Pseq([
						8,11,\r,10,
						\r, 8,13,11,
						11,11,11, 11,
						10,10,\r,\r,
					],1),
					\octave, 7,
					\dur, 1/2,
					\legato, 0.3,
					\lpf, 1000,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.2,0.1) ],
					],inf),
					\amp, 0.1/2,
					\out, BusDef(\sifleverb, \audio),
				)),
				Pfindur(8,Pbind( // sifle
					\instrument, \sh101,
					\note, Pseq([
						8,11,\r,10,
						\r,13,\r,11,
						11,11,11, 8,
						8,\r,\r,\r,
					],1),
					\octave, 7,
					\dur, 1/2,
					\legato, 0.3,
					\lpf, 1000,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.2,0.1) ],
					],inf),
					\amp, 0.1/2,
					\out, BusDef(\sifleverb, \audio),
				)),
			],1),
			Pmono(\fx_freeverb2,
				\inbus, BusDef(\sifleverb, \audio),
				\addAction, \addToTail,
				\mix, 0.7,
				\lag, 0.0009,
				\dur, 1,
			),
		]),
		Ptpar([
			7, Pbind( // snare crash
				\instrument, \playersec,
				\bufnum, ~buflib.snare[574].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					1,0,0,1, 1,0,0,1,
				],1).coin.not,
				\legato, 4,
				\dur, 1/8,
				\gain, 0.11,
			),
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[834].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.05,
			),
		]),

		
	]))
)).play;
);

(
Pdef(\part, Pdef(\fpart4c, 
	Pfindur(16,Ppar([
		Pbind(
			\instrument, \sdkick,
			\env0, [ Env([0,1,1.4,0],[0.002,0.02,0.1]) ],
			\env1, [ Env([2100,50,72],[0.017,0.4],[-4]) ],
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0, // kick cut after sidechain
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2299].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,1, 1,0,0,1,
				Pseq([
					0,0,0,0, 1,0,0,0,
				],6),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],1).coin.not,
			\dur, 1/8,
			\gain, 0.04,
			\out, BusDef(\main, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1133].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],14),
			],1).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			//\isRest, true,
			\out, BusDef(\main, \audio),
		),
		Pbind(
			\instrument, \bassbla,
			\note, Pseq([
				8,
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1
				],7*2),
				Pser([
					0
				],1*2),
				Pser([
					1
				],6*2),
				Pser([
					0
				],2*2),
			],inf).coin.not,
			\rq, 0.7,
			\delayfac, 2,
			\lfofac, 8,
			\lpf, 258*8*4,
			\lpenva, 0,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, Pstep(Pseq([1,0],2),Pseq([7,1,6,2])).loop,
			\cpt, 0.021,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\main, \audio),
			\sideout, BusDef(\main, \audio),
		),
		Pmono(\tracksummer,
			\inbus, BusDef(\main, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Ppar([
			Pseq([
				Pfindur(8,Pbind( // sifle
					\instrument, \sh101,
					\note, Pseq([
						8,11,\r,10,
						\r, 8,13,11,
						11,11,11, 11,
						10,10,\r,\r,
					],1),
					\octave, 7,
					\dur, 1/2,
					\legato, 0.3,
					\lpf, 1000,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.2,0.1) ],
					],inf),
					\amp, 0.1/2,
					\out, BusDef(\sifleverb, \audio),
				)),
				Pfindur(8,Pbind( // sifle
					\instrument, \sh101,
					\note, Pseq([
						8,11,\r,10,
						\r,13,\r,11,
						11,11,11, 8,
						8,\r,\r,\r,
					],1),
					\octave, 7,
					\dur, 1/2,
					\legato, 0.3,
					\lpf, 1000,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.2,0.1) ],
					],inf),
					\amp, 0.1/2,
					\out, BusDef(\sifleverb, \audio),
				)),
			],1),
			Pmono(\fx_freeverb2,
				\inbus, BusDef(\sifleverb, \audio),
				\addAction, \addToTail,
				\mix, 0.7,
				\lag, 0.0009,
				\dur, 1,
			),
		]),
		Ptpar([
			7, Pbind( // snare crash
				\instrument, \playersec,
				\bufnum, ~buflib.snare[574].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					1,0,0,1, 1,0,0,1,
				],1).coin.not,
				\legato, 4,
				\dur, 1/8,
				\gain, 0.11,
			),
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[834].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.05,
			),
		]),

		
	]))
)).play;
);

(
Pdef(\part, Pdef(\fpart4d, 
	Pfindur(16,Ppar([
		Pbind(
			\instrument, \sdkick,
			\env0, [ Env([0,1,1.4,0],[0.002,0.02,0.1]) ],
			\env1, [ Env([2100,50,72],[0.017,0.4],[-4]) ],
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0, // kick cut after sidechain
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2299].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,1, 1,0,0,1,
				Pseq([
					0,0,0,0, 1,0,0,0,
				],6),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],1).coin.not,
			\dur, 1/8,
			\gain, 0.04,
			\out, BusDef(\main, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1133].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],14),
			],1).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			//\isRest, true,
			\out, BusDef(\main, \audio),
		),
		Pbind(
			\instrument, \bassbla,
			\note, Pseq([
				8,
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1
				],7*2),
				Pser([
					0
				],1*2),
				Pser([
					1
				],6*2),
				Pser([
					0
				],2*2),
			],inf).coin.not,
			\rq, 0.7,
			\delayfac, 2,
			\lfofac, 8,
			\lpf, 258*8*4,
			\lpenva, 0,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, Pstep(Pseq([1,0],2),Pseq([7,1,6,2])).loop,
			\cpt, 0.021,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\main, \audio),
			\sideout, BusDef(\main, \audio),
		),
		Pmono(\tracksummer,
			\inbus, BusDef(\main, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Ppar([
			Pseq([
				Pfindur(16,Pbind( // sifle
					\instrument, \sh101,
					\note, Pseq([
						11,8,10,7,
					],2).stutter(4),
					\octave, 7,
					\dur, 1/2,
					\legato, 0.3,
					\lpf, 1000,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.2,0.1) ],
					],inf),
					\amp, 0.1/2,
					\out, BusDef(\sifleverb, \audio),
				)),
			],1),
			Pmono(\fx_freeverb2,
				\inbus, BusDef(\sifleverb, \audio),
				\addAction, \addToTail,
				\mix, 0.7,
				\lag, 0.0009,
				\dur, 1,
			),
		]),
		Ptpar([
			7, Pbind( // snare crash
				\instrument, \playersec,
				\bufnum, ~buflib.snare[574].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					1,0,0,1, 1,0,0,1,
				],1).coin.not,
				\legato, 4,
				\dur, 1/8,
				\gain, 0.11,
			),
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[834].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.05,
			),
		]),

		
	]))
)).play;
);

(
Pdef(\part, Pdef(\fpart5breaka, 
	Ppar([
		
		Ppar([
			Pbind( // pad
				\instrument, \snappad,
				\note, Pseq([
					[3,8,11,15]
				],inf),
				\octave, 5,
				\dur, 4,
				\amp, 0.051,
			),
			Pbind( 
				\instrument, \snappad,
				\note, Pseq([
					12,8,11,11,
					8,8,11,11,
				],inf),
				\octave, 6,
				\dur, 2,
				\amp, 0.1,
			),

		]),
		Ptpar([
			8, Pbind(
			   	\instrument, \simplewhitenoise,
			   	\dur, 8,
			   	\legato, 1,
			   	\adsr, Pseq([
			   		[ Env.adsr(8/~t,0.1,0.8,0.01,1,4) ],
			   	],1),
			   	\amp, 0.1/4,
			   ),
		]),
	])
)).play;
);

(
Pdef(\part, Pdef(\fpart5breakb, 
	Ppar([
		
		Ppar([
			Pbind( // pad
				\instrument, \snappad,
				\note, Pseq([
					[3,8,11,15]
				],inf),
				\octave, 5,
				\dur, 4,
				\amp, 0.051,
			),
			Pbind( 
				\instrument, \snappad,
				\note, Pseq([
					12,8,11,11,
					8,8,11,11,
				],inf),
				\octave, 6,
				\dur, 2,
				\amp, 0.1,
			),

		]),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				8,10,11,13,
			],inf).stutter(8),
			\octave, 4,
			\dur, 1/4,
			\amp, 0.1/2,
		),
		Ptpar([
			8, Pbind(
			   	\instrument, \simplewhitenoise,
			   	\dur, 8,
			   	\legato, 1,
			   	\adsr, Pseq([
			   		[ Env.adsr(8/~t,0.1,0.8,0.01,1,4) ],
			   	],1),
			   	\amp, 0.1/4,
			   ),
		]),
	])
)).play;
);

(
Pdef(\part, Pdef(\fpart5breakc, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2299].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],16).coin.not,
			\dur, 1/8,
			\gain, 0.04,
		),
		Ppar([
			Pbind( // pad
				\instrument, \snappad,
				\note, Pseq([
					[3,8,11,15]
				],inf),
				\octave, 5,
				\dur, 4,
				\amp, 0.051,
			),
			//Pbind( 
				//\instrument, \snappad,
				//\note, Pseq([
					//12,8,11,11,
					//8,8,11,11,
				//],inf),
				//\octave, 6,
				//\dur, 2,
				//\amp, 0.1,
			//),

		]),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				8,10,11,13,
				11,15,8,8,
			],inf).stutter(8),
			\octave, 4,
			\dur, 1/4,
			\amp, 0.1/2,
		),
		Ptpar([
			8, Pbind(
			   	\instrument, \simplewhitenoise,
			   	\dur, 8,
			   	\legato, 1,
			   	\adsr, Pseq([
			   		[ Env.adsr(8/~t,0.1,0.8,0.01,1,4) ],
			   	],1),
			   	\amp, 0.1/4,
			   ),
		]),
	])
)).play;
);

(
Pdef(\part, Pdef(\fpart5breakd, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2299].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],14).coin.not,
			\dur, 1/8,
			\gain, 0.04,
		),
		Ppar([
			Pbind( // pad
				\instrument, \snappad,
				\note, Pseq([
					[3,8,11,15]
				],inf),
				\octave, 5,
				\dur, 4,
				\amp, 0.051,
			),
			//Pbind( 
				//\instrument, \snappad,
				//\note, Pseq([
					//12,8,11,11,
					//8,8,11,11,
				//],inf),
				//\octave, 6,
				//\dur, 2,
				//\amp, 0.1,
			//),

		]),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				8,10,11,13,
				11,15,8,8,
			],inf).stutter(8),
			\octave, 4,
			\dur, 1/4,
			\amp, 0.1/2,
			\isRest, true,
		),
		Pfindur(14,Pbind(
			\instrument, \sh101,
			\note, Pseq([
				//8,8,\r,8,
				//8,10,\r,10,
				//13,6,\r,6,
				// TODO
				Pseq([ 8,10,6,15 ],1).stutter(8),
			],inf).stutter(1),
			\isRest, Pseq([
				1,1,0,1,
				0,1,0,1,
			],inf).coin.not,
			\octave, 6,
			\dur, 1/4,
			\amp, 0.1/2,
		)),
		Ptpar([
			8, Pbind(
				\instrument, \simplewhitenoise,
				\dur, 8,
				\legato, 1,
				\adsr, Pseq([
					[ Env.adsr(8/~t,0.1,0.8,0.01,1,4) ],
				],1),
				\amp, 0.1/4,
			),
			14, Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/feynman.flac'),
				\pos, 0,
				\speed, 0.5,
				\legato, 1,
				\dur, Pn(2,1),
				\gain, 1/2,
			)
		]),
	])
)).play;
);

(
Pdef(\part, Pdef(\fpart5breake, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2299].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],8),
				Pseq([
					1,0,1,0, 1,0,1,0,
				],4),
				Pseq([
					1,1,1,1, 1,1,1,1,
				],2),
			],1).coin.not,
			\dur, 1/8,
			\gain, 0.04,
		),
		Pfindur(14,Ppar([
			Pbind( // pad
				\instrument, \snappad,
				\note, Pseq([
					[3,8,11,15]
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\rel, Pseq([3,3,3,0.1],1),
				\octave, 5,
				\dur, Pseq([4,4,4,2],1),
				\amp, 0.051,
			),
			//Pbind( 
			//\instrument, \snappad,
			//\note, Pseq([
			//12,8,11,11,
			//8,8,11,11,
			//],inf),
			//\octave, 6,
			//\dur, 2,
			//\amp, 0.1,
			//),

			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					8+12,
				],inf),
				\freq, Pseq([
					Pseg(Pseq([68,72,78].midicps,inf),8,\exp),
				],inf),
				\octave, 3,
				\dur, 1/4,
				\amp, 0.1/2,
			),
		])),
		Pfindur(14,Pbind(
			\instrument, \sh101,
			\note, Pseq([
				//8,8,\r,8,
				//8,10,\r,10,
				//13,6,\r,6,
				// TODO
				3,8,3,10,
			],inf).stutter(1),
			\isRest, Pseq([
				1
			],inf).coin.not,
			\octave, 5,
			\dur, 1/4,
			\amp, 0.1/2 * Pseg(Pseq([0,1,1],1),8),
		)),
		Ptpar([
			8, Pbind(
				\instrument, \simplewhitenoise,
				\dur, 6,
				\legato, 1,
				\adsr, Pseq([
					[ Env.adsr(6/~t,0.1,0.8,0.01,1,4) ],
				],1),
				\amp, 0.1/4,
			),
			14, Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/feynman.flac'),
				\pos, 0,
				\speed, 0.5,
				\legato, 1,
				\dur, Pn(2,1),
				\gain, 1/2,
			)
		]),
	])
)).play;
);

(
Pdef(\part, Pdef(\fpart6, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\env0, [ Env([0,1,1.4,0],[0.002,0.02,0.1]) ],
			\env1, [ Env([2100,50,72],[0.017,0.4],[-4]) ],
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,0,0, // kick cut after sidechain
				Pseq([
					1,0,0,0, 1,0,0,0,
				],6),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],1).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2299].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,1, 1,0,0,1,
				Pseq([
					0,0,0,0, 1,0,0,0,
				],6),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],1).coin.not,
			\dur, 1/8,
			\gain, 0.04,
			\out, BusDef(\main, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1133].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],14),
			],1).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			//\isRest, true,
			\out, BusDef(\main, \audio),
		),
		Pbind(
			\instrument, \bassbla,
			\note, Pseq([
				8,
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1
				],7*2),
				Pser([
					0
				],1*2),
				Pser([
					1
				],6*2),
				Pser([
					0
				],2*2),
			],inf).coin.not,
			\rq, 0.7,
			\delayfac, 2,
			\lfofac, 8,
			\lpf, 258*8*4,
			\lpenva, 0,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, Pstep(Pseq([1,0],1),Pseq([7,1])).loop,
			\cpt, 0.021,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\main, \audio),
			\sideout, BusDef(\main, \audio),
		),
		Pmono(\tracksummer,
			\inbus, BusDef(\main, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Ptpar([
			7, Pbind( // snare crash
				\instrument, \playersec,
				\bufnum, ~buflib.snare[574].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],1).coin.not,
				\legato, 4,
				\dur, 1/8,
				\gain, 0.11,
			),
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[834].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.05,
			),
			8+6, Ppar([
				Pbind( // sifle
					\instrument, \sh101,
					\note, Pseq([
						15,11,13,10,
					],1),
					\octave, 7,
					\dur, 1/2,
					\legato, 0.3,
					\lpf, 1000,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.2,0.1) ],
					],inf),
					\amp, 0.1/2,
					\out, BusDef(\sifleverb, \audio),
				),
				Pmono(\fx_freeverb2,
					\inbus, BusDef(\sifleverb, \audio),
					\addAction, \addToTail,
					\mix, 0.7,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
		]),

		
	])
)).play;
);

////// seq

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pfindur(16, Pdef(\fintro)),
			Pfindur(16, Pdef(\fpart1)),
			Pfindur(16, Pdef(\fpart2a)),
			Pfindur(16, Pdef(\fpart2b)),
			Pfindur(16, Pdef(\fpart3breaka)),
			Pfindur(16, Pdef(\fpart3breakb)),
			Pfindur(32, Pdef(\fpart3breakc)),
			Pfindur(16, Pdef(\fpart4a)),
			Pfindur(16, Pdef(\fpart4b)),
			Pfindur(16, Pdef(\fpart4c)),
			Pfindur(16, Pdef(\fpart4d)),
			Pfindur(16, Pdef(\fpart5breaka)),
			Pfindur(16, Pdef(\fpart5breakb)),
			Pfindur(16, Pdef(\fpart5breakc)),
			Pfindur(16, Pdef(\fpart5breakd)),
			Pfindur(16, Pdef(\fpart5breake)),
			Pfindur(16, Pdef(\fpart6)),
		],1),
		
	])
)).play;
);

/////////// draft

//////////

Pdef(\sdkick, Pbind(\instrument, \sdkick)).edit

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\env0, [ Env([0,1,1.4,0],[0.002,0.2,0.1]) ],
			\env1, [ Env([2100,50,72],[0.017,0.4],[-4]) ],
			\isRest, Pseq([
				1,0,0,1, 1,0,0,0,
				Pseq([
					1,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
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
			\instrument, \sdkick,
			\env0, [ Env([0,1,1.4,0],[0.002,0.02,0.1]) ],
			\env1, [ Env([2100,50,72],[0.017,0.4],[-4]) ],
			\isRest, Pseq([
				1,0,0,1, 1,0,0,0,
				Pseq([
					1,0,0,0, 1,0,0,0,
				],15),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2299].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.04,
			\out, BusDef(\main, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1133].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			//\isRest, true,
			\out, BusDef(\main, \audio),
		),
		Pbind(
			\instrument, \bassbla,
			\note, Pseq([
				8,
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pseq([
				Pser([
					0
				],1*2),
				Pser([
					1
				],15*2),
			],inf).coin.not,
			\rq, 0.7,
			\delayfac, 2,
			\lfofac, 8,
			\lpf, 258*8*4,
			\lpenva, 0,
			\dur, 1/2,
			\amp, 0.1,
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
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\main, \audio),
			\sideout, BusDef(\main, \audio),
		),
		Pmono(\tracksummer,
			\inbus, BusDef(\main, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\comp, \audio),
		),
		Pmono(\fx_simplecompander, // can't make it right, abort
			\inbus, BusDef(\comp, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\pregain, 1.0,
			\cpt, 0.05000596046,
			\cpbelow, 8.00100004673,
			\cpabove, 0.000099,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.80000000149012,
			\mix, Prand([0,1],inf).stutter(4).trace,
			\wetgain, 6.0*3,
			\wetgain, 1.0*2,
			\dur, 1,
		),

		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \sdkick,
			\env0, [ Env([0,1,1.4,0],[0.002,0.2,0.1]) ],
			\env1, [ Env([2100,58,65],[0.017,0.6],[-4]) ],
			\isRest, Pseq([
				1,0,0,1, 1,0,0,0,
				Pseq([
					1,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\kick, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kick),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, PmodEnv(Pseq([1,Pn(0,8)],1), 2).loop,
			\sendbus0, BusDef(\kickverb, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\kickverb, \audio),
			\addAction, \addToTail,
			\room, 2,
			\damp, 1,
			\lag, 0.0009,
			\mix, 1,
			\dur, 1,
			\out, BusDef(\kickverb1, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\kickverb1, \audio),
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
			\instrument, \snappad,
			\note, Pseq([
				[0,4,7,11],
			],inf),
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\pad, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\pad, \audio),
			\addAction, \addToTail,
			\hpf, 300,
			\lag, 0.0009,
			\dur, 1,
			\gain, PmodEnv(Pseq([0.01,1],1), 8,\exp).loop,
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
				1,8,7,6,5,5,5,5,
			],inf).stutter(2),
			\octave, 5,
			\lpf, 5600,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\hpf, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\hpf, \audio),
			\addAction, \addToTail,
			\hpf, 1900,
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
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, 0,
			\speed, 0.3,
			\legato, 1,
			\dur, 1,
			\gain, 1/2,
		)
	])
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \displok,
			\note, Pseq([
				0,
			],inf),
			\freqscale, Pseg(Pseq([2,1],1),8),
			\legato, 0.1,
			\octave, 5,
			\dur, Pwhite(1/2,1,inf),
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
			\bufnum, ~buflib.snare[2299].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.04,
			\out, BusDef(\snareverb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\snareverb, \audio),
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
			\instrument, \simplewhitenoise,
			\dur, 2,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(2/~t,0.1,0.8,0.01,1,4) ],
			],1),
			\amp, 0.1/4,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pfindur(8,Pmono(
			 \multilift,
			\freq, PmodEnv(Pseq([200,604],1), 8).loop,
			\legato, 1,
			\dur, 1,
			\amp, 0.1,
		)),
		
	])
)).play;
);





(
Pdef(\pluck, Pbind(
	\instrument, \wnpluck,
	\degree, Pseq([
		[ 0,2,4 ] + 0,
		[ 0,2,4 ] + 1,
	],inf),
	\octave, 5,
	\decay, 100,
	\coef, Pseg(Pseq((1..10)/10,inf),1),
	//\coef, 0.01,
	\dur, 4,
	\amp, 0.1
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \rpluck,
			\note, Pseq([
				8,10,11,13,
			],inf).stutter(8),
			\octave, 3,
			\coef, 0.3,
			\dur, 1/4,
			\amp, 0.1/2,
		),
		
	])
)).play;
);


(

Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind( // snare crash
			\instrument, \playersec,
			\bufnum, ~buflib.snare[574].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 4,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind( // sifle
			\instrument, \sh101,
			\note, Pseq([
				15,11,13,10,
			],inf),
			\octave, 7,
			\dur, 1/2,
			\legato, 0.3,
			\lpf, 1000,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.2,0.1) ],
			],inf),
			\amp, 0.1/2,
			\out, BusDef(\sifleverb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\sifleverb, \audio),
			\addAction, \addToTail,
			\mix, 0.7,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind( // pad
			\instrument, \snappad,
			\note, Pseq([
				[3,8,11,15]
			],inf),
			\octave, 5,
			\dur, 4,
			\amp, 0.051,
		),
		Pbind( 
			\instrument, \snappad,
			\note, Pseq([
				12,8,11,11,
				8,8,11,11,
			],inf),
			\octave, 6,
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
			Pfindur(4,Pbind( // pad
				\instrument, \snappad,
				\note, Pseq([
					[3,8,11,15]
				],inf),
				\rel, 0.1,
				\octave, 5,
				\dur, 4,
				\amp, 0.051,
			)),
	])
)).play;
);
