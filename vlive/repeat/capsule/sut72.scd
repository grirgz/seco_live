~t = 145/4/60; TempoClock.default.tempo = ~t;
(
SynthDef(\oneone2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, timeScale=(1/~t);
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var diff;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	env1 = EnvGen.kr(Env([0,1,0],[0.81,0.9]*2), 1, timeScale:timeScale);
	env2 = EnvGen.kr(Env([0,0.0,1],[1,0.09]), 1, timeScale:timeScale);
	lfo1 = SinOsc.ar(freq).range(0.40,1);
	env4 = EnvGen.kr(Env([0,1,0],[0.5,2.8]), 1);
	diff= [1+env2,1-env2];
	sig1 = ( SinOsc.ar(freq * 1/2 * diff).mean * env1  + 1 );
	sig2 = ( LFSaw.ar(freq * 2 * diff).mean * env1  + 1 );
	sig3 = SelectX.ar( env4, [sig1, sig2]);
	lfo2 = SinOsc.ar(\lfo.kr(8*~t)).range(0,1);
	sig = SinOsc.ar(freq * [1,1.0001].flop * [1/8,1,1/2,2] * sig3).mean * lfo2 ;
	sig4 = LFSaw.ar(freq/2* [1,1.0001] * sig3 * ( SinOsc.kr(12 * env4) * 1 + 1 )) * lfo2;
	sig4 = LPF.ar(sig4, \lpfr.kr(2.1) * freq * ( lfo2+( 1/2 ) ), \rq.kr(0.5));
	sig4 = HPF.ar(sig4, \hpfr.kr(1.1/2) * freq * ( lfo2+( 1/2 ) ).lag(0.1), \rq.kr(0.5));
	sig = sig + sig4;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [1,-1], amp).mean;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.1, 0.3) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\amp, 0.2,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/16,
			//\lag, -0.04,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			//\out, BusDef(\sendbus1, \audio),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,1,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,1,0,
			],inf).stutter(1).coin.not,
			\sustain, 0.1/4,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
				[ Env.adsr(0.001,0.1,0.8,0.4) ],
			],inf),
			//\speed, ~pmodenv.(Pseq([2,Pseq([2,1,1,4],inf)]/8+0.61,inf), 1/4),
			\velamp, 1/4.8,
			\dur, 1/16,
			\isRest, true,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.2) ],
				[ Env.adsr(0.001,0.1,0.8,0.01) ],
			],inf),
			\sustain, 0.1/2,
			\velamp, 1/9,
			\velamp, Pkey(\velamp) * Pseq([
				4,1,2,1, 1,0,1,1,
				0,3,1,0, 4,1,2,1,
				1,1,4,1, 1,4,1,1,
				0,1,1,4, 1,4,4,1,
			]/2,inf).stutter(1),
			\isRest, Pfunc({ arg ev;
				ev[\velamp] <= 0
			}),
			\dur, 1/8,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			//\out, BusDef(\sendbus1, \audio),
			\velamp, 1/23.8,
			\velamp, Pkey(\velamp) * Pseq([
				0,0,1,0, 1,0,0,1,
				0,0,3,1, 0,1,0,4,
				0,0,1,0, 0,1,5,0,
				0,0,0,1, 1,5,0,1,
				0,0,1,0, 1,0,0,1,
				0,0,1,1, 0,1,0,1,
				0,0,1,0, 0,1,0,0,
				0,0,0,1, 1,1,0,1,
			],inf).stutter(1),
			\isRest, Pfunc({ arg ev;
				ev[\velamp] <= 0
			}),
			\sustain, 0.1/4,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
				[ Env.adsr(0.001,0.1,0.8,0.4) ],
			],inf),
			//\speed, ~pmodenv.(Pseq([2,Pseq([2,1,1,4],inf)]/8+0.61,inf), 1/4),
			\dur, 1/16,
		)),
		Pmono(\fx_reverb,
			\inbus, BusDef(\sendbus1),
			\lpf, 16000,
			\lpmix, 0.5,
			\decay, 0.3,
			\delayfac, 1/2,
			\mix, 0.3,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \oneone2,
			\note, Pseq([
				2,8-12,
				5,4-12,
				9,1-12,
				9,1-12,
			],inf),
			\octave, 6,
			\legato, Pseq([
				1/2,0,2,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/2,
			\amp, 0.1,
			\timeScale, 1/~t/1.2,
			\out, BusDef(\oneone, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\oneone, \audio),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, Pseq([
				1,0,0,0,
			],inf) * 0.8,
			\sendbus0, BusDef(\sendbus2, \audio, 2),
			\dur, 1/4,
		),
	])
)).play;
);

Pdef(\part).clear;




