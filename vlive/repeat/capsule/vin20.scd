~t = 138/4/60; TempoClock.default.tempo = ~t;

// psy trance


(
SynthDef(\trbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env([0,1,0],[0.1,0.8])), 1);
	env2 = EnvGen.kr(\lpenv2.kr(Env([0,1,0],[0.1,0.8])), 1);
	env3 = EnvGen.kr(Env([0,1,0],[0.01,0.01]), 1);
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, ( \lpfr.kr(4.1) 
		* (
			( env1 * \lpenvamt.kr(1)  ) 
			+ ( env2 * \lpenv2amt.kr(1) ) 
			+ 1
		)
		* freq ).clip(20,20000), \rq.kr(0.5));
	sig2 = SinOsc.ar(EnvGen.kr(Env([7000,130,1132],[0.01,0.08]), 1)) * env3; 
	sig2 = HPF.ar(sig2, 100) * 2; 
	sig = [sig, sig2].sum;
	//sig = sig2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\trbasspitch, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env([0,1,0],[0.1,0.8])), 1);
	env2 = EnvGen.kr(\lpenv2.kr(Env([0,1,0],[0.1,0.8])), 1);
	env3 = EnvGen.kr(\pitchenv.kr(Env([1,1/2,1/2],[0.1,0.8])), 1);
	freq = freq * env3;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, ( \lpfr.kr(4.1) 
		* (
			( env1 * \lpenvamt.kr(1)  ) 
			+ ( env2 * \lpenv2amt.kr(1) ) 
			+ 1
		)
		* freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\enver, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = sig * EnvGen.kr(\env.kr(Env([0,1,1,0],[0.4,0.8,0.1])), \trigger.tr(1));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\pitcher, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1.4,1,0.4] * ( 1/freq ),[0.1,0.8,2], [-1,1]), 1);
	env2 = EnvGen.kr(Env([1/2,2,1/11,1] * ( 1/freq ),[0.2,0.8,2], [-1,1]), 1);
	env3 = EnvGen.kr(Env([1,1.12,0.91],[0.1,0.8]), 1);
	freq = freq * env3;
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.0007) + 1));
	sig = DelayL.ar(sig, 0.1, env1)+sig;
	sig = DelayL.ar(sig, 0.1, env1)+sig;
	sig = DelayL.ar(sig, 0.1, env2)+sig;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan + LFNoise1.kr(1/2!sig.size,mul:0.1).range(-1.0,1.0);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\plucky, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:0);
	//sig = Decay.ar(WhiteNoise.ar, 0.1);
	sig = Pluck.ar(WhiteNoise.ar, 1, 100.reciprocal, freq.reciprocal, \decay.kr(1));
	sig = sig + (sig.tanh * \distamp.kr(1));
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * (env1 * \envfamt.kr(1) + 1), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\pluckym, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var xfreq = freq * ((0..7)/7 - 0.5 * \fspread.kr(0.001) + 1);
	env1 = EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:0);
	//sig = Decay.ar(WhiteNoise.ar, 0.1);
	sig = Pluck.ar(WhiteNoise.ar, 1, 100.reciprocal, xfreq.reciprocal, \decay.kr(1));
	sig = sig + (( sig*\distpreamp.kr(1) ).tanh * \distamp.kr(1));
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * (env1 * \envfamt.kr(1) + 1), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\psytrance1, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([691, 104, 51], [0.01, 0.18], curve: \exp) ],
			\bodyenv, [ Env.linen(0.002, 0.11, 0.03) ],
		
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
				1,1,1,1, 1,1,1,0,
				1,1,1,1, 1,1,0,0,
				1,1,1,1, 1,1,1,0,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1729].value,
			\bufnum, ~buflib.hat[1008].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/4,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (0.2 * Pseq([1,-1],inf))),
			\gain, 0.07,
			\out, BusDef(\fxbus2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1820].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.253,0.4,0.02) ],
			],inf),
			\sustain, 0.06,	
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pmono(\enver,
			\env, Pseq([
				[Env([0,1,1,0],[0.1,0.84,0.051]/4/~t,[3,3,-3,-3])],
			],inf),
			\trigger, 1,
			\inbus, BusDef(\fxbus2, \audio),
			\mix, 0.61,
			\dur, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2343].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,0.2) ],
			],inf),
			\sustain, 0.1,
			\gain, 0.11,
		),
		//bass
		Pbind(
			\instrument, \trbass,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpenvamt, ~pmodenv.(Pseq([4,1/2,5,1,4],inf), 3.3),
			\lpenv2amt, ~pmodenv.(Pseq([1/2,2,1,4],inf), 8),
			\rq, ~pmodenv.(Pseq([0.71,0.2,0.1,0.4],inf), 5.8),
			\lpfr, ~pmodenv.(Pseq([2,1/2,1,4]*1.7,inf), 10.9),
			\lpenv, Pseq([
				[ Env([0,1,0],[0.01,0.18]) ]
			],inf),
			\lpenv2, Pseq([
				[ Env([0,1,0],[0.004,0.18], [1,1]) ]
			],inf),
			\isRest, Pseq([
				1,0,1,0,1,0, 1,0,1,1,0,1, 1,0,0,0,1,0, 1,0,1,0,1,0, 
				1,0,1,0,1,0, 1,0,1,0,1,1, 1,0,0,0,1,0, 0,0,1,0,1,1, 
				1,0,1,0,1,0, 1,0,1,0,1,0, 1,0,0,0,1,0, 1,0,1,0,1,0, 
				1,0,1,0,1,0, 1,0,1,0,1,1, 1,0,0,0,1,0, 0,0,1,0,1,0, 

				Pseq([
					1,0,1,0,1,0, 1,0,1,1,0,1, 1,0,0,0,1,0, 1,0,1,0,1,0, 
					1,0,1,0,1,0, 1,0,1,0,1,1, 1,0,0,0,1,0, 0,0,1,0,1,1, 
					1,0,1,0,1,0, 1,0,1,0,1,0, 1,0,0,0,1,0, 1,0,1,0,1,0, 
					1,0,1,0,1,0, 1,0,1,0,1,1, 1,0,0,0,1,0, 0,0,1,0,1,0, 
				]+0.1,1),
			],inf).coin.not,
			\dur, 1/24,
			\amp, 0.1/1.2,
			\out, BusDef(\fxbus1, \audio),
		),
		Pmono(\enver,
			\env, Pseq([
				[Env([0,1,1,0],[0.1,0.7,0.1]/4/~t,[3,3,-3,-3])],
			],inf),
			\trigger, 1,
			\inbus, BusDef(\fxbus1, \audio),
			\mix, 1,
			\dur, 1/4,
		),
		Pbind(
			\instrument, \trbasspitch,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\pitchenv, Pseq([
				[ Env([1,1/2,1/2],[0.4,0.8]) ],
				[ Env([1/2,2,2],[0.4,0.8]) ],
			],inf).stutter(8),
			\lpenv, Pseq([
				[ Env([0,1,0],[0.01,0.18]) ]
			],inf),
			\lpenv2, Pseq([
				[ Env([0,1,0],[0.004,0.18], [1,1]) ]
			],inf),
			\legato, Pseq([
				0,0,0,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.1/2,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \trbasspitch,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpenvamt, ~pmodenv.(Pseq([4,1/2,5,1,4],inf), 3.3),
			\lpenv2amt, ~pmodenv.(Pseq([1/2,2,1,4],inf), 8),
			\pitchenv, Pseq([
				[ Env([1,1/2,1/2],[0.4,0.8]) ]
			],inf),
			\rq, ~pmodenv.(Pseq([0.71,0.2,0.1,0.4],inf), 5.8),
			\lpfr, ~pmodenv.(Pseq([2,1/2,1,4],inf), 10.9),
			\lpenv, Pseq([
				[ Env([0,1,0],[0.01,0.18]) ]
			],inf),
			\lpenv2, Pseq([
				[ Env([0,1,0],[0.004,0.18], [1,1]) ]
			],inf),
			\legato, Pseq([
				0,0,0,0, 0,0,2,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/2,
		),
		
	])
)).play;
);

(
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[250].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
			\out, BusDef(\rev1, \audio),
		),
		Pmono(\fx_freeverb2,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\rev1, \audio),
			\verbmix, 0.5,
			\room, 0.8,
			\damp, 0.7,
			\mix, 1,
			\gain, 1,
			\dur, 2,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \pitcher,
			\note, Pseq([
				0,
			],inf),
			\octave, [4,5,6],
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\dur, 2,
			\amp, 0.1,
			\out, BusDef(\rev1, \audio),
		),
		
	])
)).play;
);

WindowDef(\BufferEditor).front(BufDef(\basicrecorder_buffer8))

BufDef(\pitcher1, "ramp/pitcher1.wav");

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Psched([0,2],Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\pitcher1),
			\legato, 1,
			\dur, 2,
			\gain, 0.3,
		)),
		Psched(2, Ppar([
			Pdef(\psytrance1),
			Psched(0,Pbind(
				\instrument, \playersec,
				\bufnum, BufDef(\pitcher1),
				\legato, 1,
				\isRest, Pseq([
					0,0,0,1,
				],inf).coin.not,
				\dur, 2,
				\gain, 0.2,
			)),
		]))
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec_looper,
			\bufnum, BufDef(\pitcher1),
			\trigfreq, Pseq([
				1,8,16,4,
				1,8,16,4,
				4,1,16,1,
				1,1,1,1,
			],inf)*~t,
			\legato, 1,
			\speed, -1 * Pseq([
				1,1/2,1/4,
				Pn(1/4,16-3)
			],inf).linlin(1/4,1,0.7,1),
			\loop,1,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,0,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 0.4,
			\out, BusDef(\filbus1, \audio),
		),
		Pmono(\fx_rhpf,
			\inbus, BusDef(\filbus1, \audio),
			\hpf, 4100 * Pseq([
				1/3,1/2,1, 1,1,1,
				1,1,1, 1,1/2,1/3,
			],inf),
			\dur, 1/6,
		),
			Psched(0,Pbind(
				\instrument, \playersec,
				\bufnum, BufDef(\pitcher1),
				\legato, 1,
				\isRest, Pseq([
					0,0,0,1,
				],inf).coin.not,
				\dur, 2,
				\gain, 0.2,
			)),
			Pdef(\psytrance1),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec_looper,
			\bufnum, BufDef(\pitcher1),
			\trigfreq, Pseq([
				1,1,1,1,
				1,2,8,4,
				8,8,32,16,
				1,2,8,4,
			],inf)*4*~t,
			\legato, 1,
			\speed, -1 * Pseq([
				1,1/2,1/4,
				Pn(1/4,16-3)
			],inf).linlin(1/4,1,0.7,1),
			\loop,1,
			\legato, Pseq([
				1,1,2,0, 0,0,0,0,
				0,3,0,0, 0,0,0,1,
				2,0,2,0, 0,0,0,0,
				0,0,0,0, 0,1,0,1,
				1,1,2,0, 0,1,2,0,
				3,0,0,1, 1,2,0,1,
				4,0,0,0, 1,1,1,0,
				0,2,0,0, 2,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 0.4,
			\out, BusDef(\filbus1, \audio),
		),
		Pmono(\fx_rhpf,
			\inbus, BusDef(\filbus1, \audio),
			\hpf, 4100 * Pseq([
				1/3,1/2,1, 1,1,1,
				1,1,1, 1,1/2,1/3,
			],inf),
			\dur, 1/6,
		),
			Psched(0,Pbind(
				\instrument, \playersec,
				\bufnum, BufDef(\pitcher1),
				\legato, 1,
				\isRest, Pseq([
					0,0,0,1,
				],inf).coin.not,
				\dur, 2,
				\gain, 0.2,
			)),
			Pdef(\psytrance1),
		
	])
)).play;
);

SynthDef(\playersec_looper_rlpf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, velamp=1;
	// pos in seconds
	var sig;
	var trigger = Impulse.ar(\trigfreq.kr(0));
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(\lpenv.kr(Env.adsr(0.1,0.4,0.8,2.1)), gate, doneAction:0);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig5 = RLPF.ar(sig, \lpf.kr(800.1) * (env1 * \lpenvamt.kr(0.8) + 1), \rq.kr(0.2));
	sig = SelectX.ar(\mix.kr(1), [sig, sig5]);
	sig = Compander.ar(sig, sig, \cpt.kr(0.1), \cpbelow.kr(1.001), \cpabove.kr(0.1), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec_looper,
			\bufnum, BufDef(\pitcher1),
			\trigfreq, Pseq([
				Pseq([
					1,1,1,8, 1,16,1,1,
				],inf),
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,12,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,12,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,8,
			],inf)*~t,
			\pos, -0.1,
			\lpf, ~pmodenv.(Pseq([800,4000],inf), 8),
			\legato, 1,
			\speed, -1 * Pseq([
				1,1/2,1/4,
				Pn(1/4,16-3)
			],inf).linlin(1/4,1,0.7,1),
			\speed, Pseg(Pseq([1,0.8,1/2],inf),8) * -1,
			\speed, [-1,-1.2],
			\loop,1,
			\legato, Pseq([
				1,1,1,1, 1,1/2,1,0,
				1,1,1,1, 1,1,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\gain, 0.8,
			\out, BusDef(\filbus1, \audio),
		),
		Pmono(\fx_rlpfrhpf,
			\inbus, BusDef(\filbus1, \audio),
			\hpf, 4100 * Pseq([
				1/3,1/2,1, 1,1,1,
				1,1,1, 1,1/2,1/3,
			],inf)/2,
			\lpf, ~pmodenv.(Pseq([1000,10000],inf), 8),
			\lprq, 0.2,
			\dur, 1/6,
		),
			Psched(0,Pbind(
				\instrument, \playersec,
				\bufnum, BufDef(\pitcher1),
				\legato, 1,
				\isRest, Pseq([
					0,0,0,1,
				],inf).coin.not,
				\dur, 2,
				\gain, 0.2,
			)),
			Pdef(\psytrance1),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec_looper,
			\bufnum, BufDef(\pitcher1),
			\pos, Pseg(Pseq([0,0.21],inf),16*4),
			\pos, 0,
			\trigfreq, Pseq([
				Pseq([
					1,2,8,4, 1,2,4,4,
				],6),
				Pseq([
					1,2,16,4, 1,2,16,4,
					6,2,8,4, 16,2,8,4,
				],1),
			],inf)*4*~t,
			\legato, 1,
			\speed, -1 * Pseq([
				1,1/2,1/4,
				Pn(1/4,16-3)
			],inf).linlin(1/4,1,0.7,1) * Pseq([
				Pseg(Pseq([1,1.52],1),8),
			],inf),
			\loop,1,
			\legato, Pseq([

				Pseq([
					1,0,1,0, 1,0,1,0,
				],6)* Pseg(Pseq([1/4,2],inf),2),
					3,0,0,1, 0,1,2,0,
					4,0,0,0, 1,2,0,0,

				Pseq([
					1,0,1,0, 1,0,1,0,
				],6),
					3,0,0,1, 0,1,2,0,
					4,0,0,0, 1,2,0,0,

				Pseq([
					1,0,1,0, 1,0,1,0,
				]*2,6),
					3,0,0,1, 0,1,2,0,
					4,0,0,0, 1,2,0,0,

				Pseq([
					1,1,1,1, 1,1,1,1,
				],6)* Pswitch1(
					[
						Pseg(Pseq([1/4,2],inf),8),
						Pseg(Pseq([2,1/4],inf),8),
					], 
					Pseq([0,1],inf)
				),
					3,0,0,1, 0,1,2,0,
					4,0,0,0, 1,2,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 0.4,
			\out, BusDef(\filbus1, \audio),
		),
		Pmono(\fx_rhpf,
			\inbus, BusDef(\filbus1, \audio),
			\hpf, 4100 * Pseq([
				1/3,1/2,1, 1,1,1,
				1,1,1, 1,1/2,1/3,
			],inf),
			\dur, 1/6,
		),
			Psched(0,Pbind(
				\instrument, \playersec,
				\bufnum, BufDef(\pitcher1),
				\legato, 1,
				\isRest, Pseq([
					0,0,0,1,
				],inf).coin.not,
				\dur, 2,
				\gain, 0.2,
			)),
			Pdef(\psytrance1),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\psytrance1, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([691, 104, 61], [0.01, 0.18], curve: \exp) ],
			\bodyenv, [ Env.linen(0.001, 0.2, 0.07) ],
		
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
				1,1,1,1, 1,1,1,0,
				1,1,1,1, 1,1,0,0,
				1,1,1,1, 1,1,1,0,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1729].value,
			\bufnum, ~buflib.hat[1008].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/4,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (0.2 * Pseq([1,-1],inf))),
			\gain, 0.07,
			\out, BusDef(\fxbus2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1820].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.253,0.4,0.02) ],
			],inf),
			\sustain, 0.06,	
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pmono(\enver,
			\env, Pseq([
				[Env([0,1,1,0],[0.1,0.84,0.051]/4/~t,[3,3,-3,-3])],
			],inf),
			\trigger, 1,
			\inbus, BusDef(\fxbus2, \audio),
			\mix, 0.61,
			\dur, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2343].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,0.2) ],
			],inf),
			\sustain, 0.1,
			\gain, 0.11,
		),
		//bass
		Pbind(
			\instrument, \trbass,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpenvamt, ~pmodenv.(Pseq([4,1/2,5,1,4],inf), 3.3),
			\lpenv2amt, ~pmodenv.(Pseq([1/2,2,1,4],inf), 8),
			\rq, ~pmodenv.(Pseq([0.71,0.2,0.1,0.4],inf), 5.8),
			\lpfr, ~pmodenv.(Pseq([2,1/2,1,4]*1.7,inf), 10.9),
			\lpenv, Pseq([
				[ Env([0,1,0],[0.01,0.18]) ]
			],inf),
			\lpenv2, Pseq([
				[ Env([0,1,0],[0.004,0.18], [1,1]) ]
			],inf),
			\isRest, Pseq([
				1,0,1,1,0,1, 1,1,1,0,1,1, 1,0,0,0,1,0, 1,0,1,0,1,0, 
				1,0,1,0,1,0, 1,0,1,1,0,1, 1,0,0,0,1,0, 1,0,1,0,1,0, 
				1,0,1,0,1,0, 1,0,1,0,1,1, 1,0,0,0,1,0, 0,0,1,0,1,1, 
				1,0,1,0,1,0, 1,0,1,0,1,0, 1,0,0,0,1,0, 1,0,1,0,1,0, 
				1,0,1,0,1,0, 1,0,1,0,1,1, 1,0,0,0,1,0, 0,0,1,0,1,0, 
			]+0.1,inf).coin.not,
			\dur, 1/24,
			\amp, 0.1/1.2,
			\out, BusDef(\fxbus1, \audio),
		),
		Pmono(\enver,
			\env, Pseq([
				[Env([0,1,1,0],[0.1,0.7,0.1]/4/~t,[3,3,-3,-3])],
			],inf),
			\trigger, 1,
			\inbus, BusDef(\fxbus1, \audio),
			\mix, 1,
			\dur, 1/4,
		),
		Pbind(
			\instrument, \trbasspitch,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\pitchenv, Pseq([
				[ Env([1,1/2,1/2],[0.4,0.8]) ],
				[ Env([1/2,2,2],[0.4,0.8]) ],
			],inf).stutter(8),
			\lpenv, Pseq([
				[ Env([0,1,0],[0.01,0.18]) ]
			],inf),
			\lpenv2, Pseq([
				[ Env([0,1,0],[0.004,0.18], [1,1]) ]
			],inf),
			\legato, Pseq([
				0,0,0,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.1/2,
		),
		
	])
)).play;
);

(
SynthDef(\ampoule, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * \harm.kr([1,2,3, 4,5,6]/2)) * \harmamp.kr([0.2,1,0.2,0.2,0.2,0.2]);
	//sig = sig.sum;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * 2;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\psytrance2, 
	Ppar([
		Pbind(
			\instrument, \ampoule,
			\harm, Pseq([
				Plazy({ arg ev;
					Pseq([
						[[ 1,2,3, 4,5,6 ].scramble/2],
						[rrand(0.99,1.01!6)],
						[[ 1,2,3, 4,5,6 ].scramble/4],
					],inf);
				}).stutter(8).loop,
			],inf),
			\degree, Pseq([
				0,7,7-12,3,
				0,3,0,0,
				3,7,3,11,
				3,7,3,0,
			],inf).stutter(2),
			\mtranspose, Pseq([0,2,1b,-1],inf).stutter(8*4),
			\isRest, Pseq([
				1,0,0,0,
				1,0,0,0,
				1,0,1,0,
				1,0,1,0,
				1,0,1,0,
				1,0,1,0,
				1,0,1,0,
				0,0,1,0,

				1,0,0,0,
				1,0,0,0,
				1,0,1,0,
				0,0,1,0,
				1,0,0,1,
				1,0,1,0,
				1,0,1,1,
				1,1,0,1,
			],inf).coin.not,
			\legato, Pseg(Pseq([0.051,1],inf),8*2),
			\dur, 1/16,
			\amp, 0.1,
			\out, BusDef(\fxbus3, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\fxbus3, \audio),
			\out, BusDef(\fxbus4, \audio),
			\delay, 1/12/~t,
			\mix, Pseg(Pseq([0,0.51],inf),8*4),
			\decay, 1.1,
			\dur, 1,
		),
		Pmono(\chorus,
			\inbus, BusDef(\fxbus4, \audio),
			\mix, Pseg(Pseq([0,1],inf),8*4),
			\out, BusDef(\fxbus5, \audio),
			\delay, 0.01,
			\modamp, 2,
			\gain, 2,
			\dur, 1,
		),
		Pmono(\fx_bpf,
			\inbus, BusDef(\fxbus5, \audio),
			\bpf, ~pmodenv.(Pseq([100,2000,10000,40],inf), 3.4),
			\rq, 0.04,
			\mix, 0.8,
			\gain, 2,
			\dur, 1,
			\amp, 0.1,
		),


		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([691, 114, 41], [0.01, 0.18], curve: \exp) ],
			\bodyenv, [ Env.linen(0.001, 0.1, 0.07) ],
		
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
				1,1,1,1, 1,1,1,0,
				1,1,1,1, 1,1,0,0,
				1,1,1,1, 1,1,1,0,
				1,1,1,1, 0,0,0,0,
			],inf).stutter(2).coin.not,
			\dur, 1/4,
			\amp, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1729].value,
			\bufnum, ~buflib.hat[1008].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/4,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (0.2 * Pseq([1,-1],inf))),
			\gain, 0.07,
			\out, BusDef(\fxbus2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1820].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.253,0.4,0.02) ],
			],inf),
			\sustain, 0.06,	
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pmono(\enver,
			\env, Pseq([
				[Env([0,1,1,0],[0.1,0.84,0.051]/4/~t,[3,3,-3,-3])],
			],inf),
			\trigger, 1,
			\inbus, BusDef(\fxbus2, \audio),
			\mix, 0.61,
			\dur, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2343].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,0.2) ],
			],inf),
			\sustain, 0.1,
			\gain, 0.11,
		),
		//bass
		Pbind(
			\instrument, \trbass,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpenvamt, ~pmodenv.(Pseq([4,1/2,5,1,4],inf), 3.3),
			\lpenv2amt, ~pmodenv.(Pseq([1/2,2,1,4],inf), 8),
			\rq, ~pmodenv.(Pseq([0.71,0.2,0.1,0.4],inf), 5.8),
			\lpfr, ~pmodenv.(Pseq([2,1/2,1,4]*1.7,inf), 10.9),
			\lpenv, Pseq([
				[ Env([0,1,0],[0.01,0.18]) ]
			],inf),
			\lpenv2, Pseq([
				[ Env([0,1,0],[0.004,0.18], [1,1]) ]
			],inf),
			\isRest, Pseq([
				1,0,1,1,0,1, 1,1,1,0,1,1, 1,0,0,0,1,0, 1,0,1,0,1,0, 
				1,0,1,0,1,0, 1,0,1,1,0,1, 1,0,0,0,1,0, 1,0,1,0,1,0, 
				1,0,1,0,1,0, 1,0,1,0,1,1, 1,0,0,0,1,0, 0,0,1,0,1,1, 
				1,0,1,0,1,0, 1,0,1,0,1,0, 1,0,0,0,1,0, 1,0,1,0,1,0, 
				1,0,1,0,1,0, 1,0,1,0,1,1, 1,0,0,0,1,0, 0,0,1,0,1,0, 
			]+0.1,inf).coin.not,
			\dur, 1/24,
			\amp, 0.1/1.2,
			\out, BusDef(\fxbus1, \audio),
		),
		Pmono(\enver,
			\env, Pseq([
				[Env([0,1,1,0],[0.1,0.7,0.1]/4/~t,[3,3,-3,-3])],
			],inf),
			\trigger, 1,
			\inbus, BusDef(\fxbus1, \audio),
			\mix, 1,
			\dur, 1/4,
		),
		Pbind(
			\instrument, \trbasspitch,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\pitchenv, Pseq([
				[ Env([1,1/2,1/2],[0.4,0.8]) ],
				[ Env([1/2,2,2],[0.4,0.8]) ],
			],inf).stutter(8),
			\lpenv, Pseq([
				[ Env([0,1,0],[0.01,0.18]) ]
			],inf),
			\lpenv2, Pseq([
				[ Env([0,1,0],[0.004,0.18], [1,1]) ]
			],inf),
			\legato, Pseq([
				0,0,0,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.1/2,
		),
		
	])
)).play;
);


(
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \plucky,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,1,
			],inf).coin.not,
			\legato, 2,
			\envfamt, 5,
			\env1, Pseq([
				[ Env.adsr(0.1,0.351,0.3,0.4) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.051,0.8,0.4) ],
			],inf),
			\decay, 4,
			\note, Pseq([
				Pseq([
					[0,7,12,15],
				],8+6),
				[0,7,12,14],
				[0,7,12,14],

				[3,7,10,14],
				Pseq([
					[3,7,10,15],
				],8+6),
				[3,7,10,14],

				Pseq([
					[-4, 3,8,10],
					Pseq([
						[-4, 3,8,10, 12],
					],8+6),
					[-4, 3,8,10],
				],2),
			],inf),
			\dur, 1/16,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([691, 104, 51], [0.01, 0.18], curve: \exp) ],
			\bodyenv, [ Env.linen(0.002, 0.11, 0.03) ],
		
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
				1,1,1,1, 1,1,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,0,0,
				1,1,1,1, 1,1,1,1,

				1,1,1,1, 1,1,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,1,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.15,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(\lag, 0.04) <>
		Ppar([
			Pbind(
				\instrument, \trbass,
				\note, Pseq([
					0,
				],inf),
				\octave, 3,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\lpenvamt, 1/2,
				\lpenv2amt, ~pmodenv.(Pseq([1/2,2],inf), 1),
				\rq, ~pmodenv.(Pseq([0.71,0.2,0.1,0.4],inf), 5.8),
				\lpfr, ~pmodenv.(Pseq([2,1/2,1,4]*1.7,inf), 10.9),
				\lpenv, Pseq([
					[ Env([0,1,0],[0.01,0.18]) ]
				],inf),
				\lpenv2, Pseq([
					[ Env([0,1,0],[0.004,0.18], [1,1]) ]
				],inf),
				\isRest, Pseq([
					1,0,1,0,1,0, 1,0,1,0,1,0, 1,0,1,0,1,0, 1,0,0,0,0,0, 
					1,0,1,0,1,0, 1,0,1,0,1,0, 1,0,1,0,1,0, 1,0,1,0,1,0, 
				],inf).coin.not,
				\dur, 1/24,
				\amp, 0.1/1.2,
				\out, BusDef(\fxbus1, \audio),
			),
			Pmono(\enver,
				\env, Pseq([
					[Env([0,1,1,0],[0.1,0.7,0.1]/4/~t,[3,3,-3,-3])],
				],inf),
				\trigger, 1,
				\inbus, BusDef(\fxbus1, \audio),
				\mix, 1,
				\dur, 1/4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2343].value,
				\isRest, Pseq([
					0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.3,0.2) ],
				],inf),
				\sustain, 0.1,
				\gain, 0.11,
			),
		]),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \pluckym,
			\fspread, 0.001 * Pseg(Pseq([1,10],inf),8),
			\legato, 0.2,
			\legato, Pseq([
				Pswitch1(
					[
						Pseg(Pseq([0.01,1],inf),9),
						Pseg(Pseq([0.01,0.2],inf),7),
						Pseg(Pseq([1,0.01],inf),10),
						Pseg(Pseq([0.01,1],inf),11),
						Pseg(Pseq([0,0.2],inf),12),
						Pseg(Pseq([1,0.01],inf),13),
					], 
					Pseq([0,1,2,3,4,5],inf)
				),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0.05 }),
			\envfamt, Pswitch1(
					[
						Pseg(Pseq([0.01,1],inf),8.3),
						Pseg(Pseq([0,0.2],inf),6.1),
						Pseg(Pseq([1,0.01],inf),9.2),
						Pseg(Pseq([0.01,1],inf),9.1),
						Pseg(Pseq([0,0.2],inf),8.1),
						Pseg(Pseq([1,0.01],inf),10.1),
					]*5, 
					Pseq([0,1,2,3,4,5],inf)
			),
			\lpfr, ~pmodenv.(Pseq([1/4,2,1,1.4],inf), 8),
			\env1, Pseq([
				[ Env.adsr(0.1,0.351,0.3,0.4) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.051,0.8,0.4) ],
			],inf),
			\decay, Pswitch1(
				[
					Pseg(Pseq([1/4,4],inf),6),
					Pseg(Pseq([1/4,2],inf),7),
					Pseg(Pseq([2,1/4],inf),9),
					Pseg(Pseq([1/8,4],inf),10),
					Pseg(Pseq([1/8,2],inf),11),
					Pseg(Pseq([2,1/8],inf),12),
				], 
				Pseq([0,1,2,3,4,5],inf)
			),
			\note, Pseq([
				Pseq([
					[0,7,12,15],
				],12+10),
				[0,7,12,14],
				[0,7,12,14],

				[3,7,10,14],
				Pseq([
					[3,7,10,15],
				],12+10),
				[3,7,10,14],

				Pseq([
					[-4, 3,8,10],
					Pseq([
						[-4, 3,8,10, 12],
					],12+10),
					[-4, 3,8,10],
				],2),
			],inf),
			\dur, 1/12,
			\amp, 0.1/2,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([691, 104, 51], [0.01, 0.18], curve: \exp) ],
			\bodyenv, [ Env.linen(0.002, 0.11, 0.03) ],
		
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
				1,1,1,1, 1,1,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,0,0,
				1,1,1,1, 1,1,1,1,

				1,1,1,1, 1,1,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,1,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.15,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(\lag, 0.04) <>
		Ppar([
			Pbind(
				\instrument, \trbass,
				\note, Pseq([
					0,
				],inf),
				\octave, 3,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\lpenvamt, 1/2,
				\lpenv2amt, ~pmodenv.(Pseq([1/2,2],inf), 1),
				\rq, ~pmodenv.(Pseq([0.71,0.2,0.1,0.4],inf), 5.8),
				\lpfr, ~pmodenv.(Pseq([2,1/2,1,4]*1.7,inf), 10.9),
				\lpenv, Pseq([
					[ Env([0,1,0],[0.01,0.18]) ]
				],inf),
				\lpenv2, Pseq([
					[ Env([0,1,0],[0.004,0.18], [1,1]) ]
				],inf),
				\isRest, Pseq([
					1,0,1,0,1,0, 1,0,1,0,1,0, 1,0,1,0,1,0, 1,0,0,0,0,0, 
					1,0,1,0,1,0, 1,0,1,0,1,0, 1,0,1,0,1,0, 1,0,1,0,1,0, 
				],inf).coin.not,
				\dur, 1/24,
				\amp, 0.1/1.2,
				\out, BusDef(\fxbus1, \audio),
			),
			Pmono(\enver,
				\env, Pseq([
					[Env([0,1,1,0],[0.1,0.7,0.1]/4/~t,[3,3,-3,-3])],
				],inf),
				\trigger, 1,
				\inbus, BusDef(\fxbus1, \audio),
				\mix, 1,
				\dur, 1/4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2343].value,
				\isRest, Pseq([
					0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.3,0.2) ],
				],inf),
				\sustain, 0.1,
				\gain, 0.11,
			),
		]),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \pluckym,
			\env1, Pseq([
				[ Env.adsr(0.4,0.1,0.8,0.1) ],
			],inf),
			\envfamt, 8,
			\lpfr,1/4,
			\distpreamp,43,
			\distamp,0.05,
			\rq, 0.1,
			\decay, 4,
			\fspread, 0.001 * Pseg(Pseq([1,10],inf),9),
			\note, Pseq([
				[5,8,12, 16],
				[4,9,12, 17],
			],inf).stutter(2),
			\strum,0.1/8 * Pseg(Pseq([1,8],inf),8),	
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\pluckbus1, \audio),
		),
		Pbind(
			\instrument, \pluckym,
			\env1, Pseq([
				[ Env.adsr(0.1/5,0.1/4,0.1,0.1) ],
			],inf),
			\envfamt, 3,
			\fspread, 0.001 * Pseg(Pseq([4,1,10],inf),7),
			\lpfr,1/2,
			\distpreamp,43,
			\distamp,0.05,
			\rq, 0.4,
			\decay, 4,
			\note, Pseq([
				Plazy({ arg ev;
					Pseq([
						5,7,12,7, 5,7,12,7,
					].scramble,1);
				}),
				Plazy({ arg ev;
					Pseq([
						4,7,12+4,12+7, 4,7,12+4,12+7,
					].scramble,1);
				}),
			],inf).stutter(2),
			\isRest, Pseq([
				1,0.5,
			],inf).coin.not,
			\strum,0.1/2,	
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\pluckbus1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\pluckbus1, \audio),
			\out, BusDef(\pluckbus2, \audio),
				\freq, 0.2,
				\mix, 1/2,
				\delay, 1/4/~t,
				\decay,4,
			\dur, 1,
		),
		Pmono(\fx_flanger,
			\inbus, BusDef(\pluckbus2, \audio),
				\freq, 1/8/~t,
				\mix, 0.2,
				\lfomul, 0.025,
				\delay, 0.05,
				\maxdelay, 0.05,
				\fb, 0.7,
			\dur, 1,
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([691, 104, 51], [0.01, 0.18], curve: \exp) ],
			\bodyenv, [ Env.linen(0.002, 0.11, 0.03) ],
		
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
				1,1,1,1, 1,1,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,0,0,
				1,1,1,1, 1,1,1,1,

				1,1,1,1, 1,1,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,1,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.15,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(\lag, 0.04) <>
		Ppar([
			Pbind(
				\instrument, \trbass,
				\note, Pseq([
					0,
				],inf),
				\octave, 3,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\lpenvamt, 1/2,
				\lpenv2amt, ~pmodenv.(Pseq([1/2,2],inf), 1),
				\rq, ~pmodenv.(Pseq([0.71,0.2,0.1,0.4],inf), 5.8),
				\lpfr, ~pmodenv.(Pseq([2,1/2,1,4]*1.7,inf), 10.9),
				\lpenv, Pseq([
					[ Env([0,1,0],[0.01,0.18]) ]
				],inf),
				\lpenv2, Pseq([
					[ Env([0,1,0],[0.004,0.18], [1,1]) ]
				],inf),
				\isRest, Pseq([
					1,0,0,0,1,0, 1,0,1,0,1,0, 1,0,0,0,1,0, 1,0,1,0,1,0,
					1,0,1,0,1,0, 1,0,1,0,1,0, 1,0,0,0,1,0, 1,0,0,0,0,0,
				],inf).coin.not,
				\dur, 1/24,
				\amp, 0.1/1.2,
				\out, BusDef(\fxbus1, \audio),
			),
			Pmono(\enver,
				\env, Pseq([
					[Env([0,1,1,0],[0.1,0.7,0.1]/4/~t,[3,3,-3,-3])],
				],inf),
				\trigger, 1,
				\inbus, BusDef(\fxbus1, \audio),
				\mix, 1,
				\dur, 1/4,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2343].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.3,0.2) ],
				],inf),
				\sustain, 0.1,
				\gain, 0.11,
			),
			Psched([7,8],
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\bufnum, ~buflib.snare[2366].value,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0, 1,0,1,0, 0,1,0,1,
					],inf).coin.not,
					\dur, 1/16,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.3,0.2) ],
					],inf),
					\sustain, 0.1,
					\gain, 0.0511,
				),
			).loop
		]),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \pluckym,
			\env1, Pseq([
				[ Env.adsr(0.4,0.1,0.8,0.1) ],
			],inf),
			\envfamt, 8,
			\lpfr,1/4,
			\distpreamp,43,
			\distamp,0.05,
			\rq, 0.1,
			\decay, 4,
			\fspread, 0.001 * Pseg(Pseq([1,10],inf),9),
			\note, Pseq([
				[5,8,12, 16],
				[4,9,12, 17],
			],inf).stutter(2),
			\strum,0.1/8 * Pseg(Pseq([1,8],inf),8),	
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\pluckbus1, \audio),
		),
		Pbind(
			\instrument, \pluckym,
			\env1, Pseq([
				[ Env.adsr(0.1/5,0.1/4,0.1,0.1) ],
			],inf),
			\envfamt, 3,
			\fspread, 0.001 * Pseg(Pseq([4,1,10],inf),7),
			\lpfr,1/2,
			\distpreamp,43,
			\distamp,0.05,
			\rq, 0.4,
			\decay, 4,
			\note, Pseq([
				Plazy({ arg ev;
					Pseq([
						5,7,12,7, 5,7,12,7,
					].scramble,1);
				}),
				Plazy({ arg ev;
					Pseq([
						4,7,12+4,12+7, 4,7,12+4,12+7,
					].scramble,1);
				}),
			],inf).stutter(2),
			\isRest, Pseq([
				1,0.5,
			],inf).coin.not,
			\strum,0.1/2,	
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\pluckbus1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\pluckbus1, \audio),
			\out, BusDef(\pluckbus2, \audio),
				\freq, 0.2,
				\mix, 1/2,
				\delay, 1/4/~t,
				\decay,4,
			\dur, 1,
		),
		Pmono(\fx_flanger,
			\inbus, BusDef(\pluckbus2, \audio),
				\freq, 1/8/~t,
				\mix, 0.2,
				\lfomul, 0.025,
				\delay, 0.05,
				\maxdelay, 0.05,
				\fb, 0.7,
			\dur, 1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([691, 104, 51], [0.01, 0.18], curve: \exp) ],
			\bodyenv, [ Env.linen(0.002, 0.11, 0.03) ],
		
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
				1,1,1,1, 1,1,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,0,0,
				1,1,1,1, 1,1,1,1,

				1,1,1,1, 1,1,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,1,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.15,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(\lag, 0.04) <>
		Ppar([
			Pbind(
				\instrument, \trbass,
				\note, Pseq([
					0,
				],inf),
				\octave, 3,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\lpenvamt, 1/2,
				\lpenv2amt, ~pmodenv.(Pseq([1/2,2],inf), 1),
				\rq, ~pmodenv.(Pseq([0.71,0.2,0.1,0.4],inf), 5.8),
				\lpfr, ~pmodenv.(Pseq([2,1/2,1,4]*1.7,inf), 10.9),
				\lpenv, Pseq([
					[ Env([0,1,0],[0.01,0.18]) ]
				],inf),
				\lpenv2, Pseq([
					[ Env([0,1,0],[0.004,0.18], [1,1]) ]
				],inf),
				\isRest, Pseq([
					1,0,0,0,1,0, 1,0,1,0,1,0, 1,0,0,0,1,0, 1,0,1,0,1,0,
					1,0,1,0,1,0, 1,0,1,0,1,0, 1,0,0,0,1,0, 1,0,0,0,0,0,
				],inf).coin.not,
				\dur, 1/24,
				\amp, 0.1/1.2,
				\out, BusDef(\fxbus1, \audio),
			),
			Pmono(\enver,
				\env, Pseq([
					[Env([0,1,1,0],[0.1,0.7,0.1]/4/~t,[3,3,-3,-3])],
				],inf),
				\trigger, 1,
				\inbus, BusDef(\fxbus1, \audio),
				\mix, 1,
				\dur, 1/4,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2343].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.3,0.2) ],
				],inf),
				\sustain, 0.1,
				\gain, 0.11,
			),
			Psched([7,8],
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\bufnum, ~buflib.snare[2366].value,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0, 1,0,1,0, 0,1,0,1,
					],inf).coin.not,
					\dur, 1/16,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.3,0.2) ],
					],inf),
					\sustain, 0.1,
					\gain, 0.0511,
				),
			).loop
		]),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([691, 114, 51], [0.05, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.08, 0.11, 0.003) ],
		
			\popfstart, 1750,
			\popfend, 061,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.35,
		
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
				1,1,1,1, 1,1,1,0,
				1,1,1,1, 1,1,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,0,0,

				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,0,
				1,1,1,1, 0,0,0,1,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.15,
			\out, BusDef(\sendbus2, \audio),
		),
		PmonoArtic(\acidbass,
			\note, Pseq([
				0,
			],inf),
			\lpenvtrig, 1,
			\lpfr, ~pmodenv.(Pseq([1/4,4,2],inf), 8),
			\lpenvamt, ~pmodenv.(Pseq([8,1/4,2,1,4],inf), 1),
			\octave, Pseq([
				4,5,5,5, 
				4,5,5,5, 
				4,5,5,5, 
				5,4,5,5, 
				4,5,5,5, 
				4,5,5,5, 
				4,5,5,5, 
				4,4,4,5, 
				4,5,5,5, 
				4,5,5,5, 
				4,5,5,5, 
				4,5,6,7, 

			],inf),
			\legato, Pseq([
				0.5,0.1,1,1,
			],inf),
			\accent, Pseq([
				1,1,0,1, 
			],inf),
			\dur, 1/16,
			\amp, 0.1 * ( Pkey(\accent) + 1 ) / 2,
		),
			Pbind(
				\instrument, \pluckym,
				\note, Pseq([
					[0,3+12,6,9+12,12],
					[0,3+12,6,9+12,12]+2,
				],inf) + Pseq([0],inf),
				\decay, 4,
				\legato, 2,
				\env1, Pseq([
					[ Env.adsr(0.1,0.3,3.8,3.1) ],
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,1.1) ],
				],inf),
				\lpfr, 4,
				\octave, 5,
				\dur, 2,
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
			),
			Pbind(
				\instrument, \plucky,
				\note, Pseq([
					Prand([
						2,3,4,5
					],inf)
				],inf) + Pseq([0],inf),
				\lpfr, 4,
				\octave, Prand([5,6],inf),
				\isRest, Pseq([
					Plazy({ arg ev;
						var tab = [ [ 0, 1, 0, 1, 0, 1, 0, 1 ], [ 1, 1, 1, 1, 1, 1, 1, 1 ], [ 0, 1, 0, 1, 1, 1, 1, 1 ], [ 1, 0, 1, 0, 1, 0, 1, 0 ], [ 0, 1, 0, 1, 1, 0, 1, 0 ], [ 1, 1, 1, 1, 1, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 1, 0, 0, 0, 0 ], [ 1, 1, 1, 1, 0, 0, 0, 0 ], [ 1, 0, 1, 0, 0, 0, 0, 0 ] ];
						Pseq({ 
							Pseq([
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,
								Pseq([
									1,1,0,0, 0,0,0,0,
								].scramble,1),
								Pseq(tab.choose),
							]) 
						}.dup( 8 ),4)
					}).loop,
				],inf).coin.not,
				\dur, 1/16,
				\out, BusDef(\sendbus1, \audio),
				\amp, 0.4,
			),
		Pbind(\lag, 0.04) <>
		Ppar([
			Pbind(
				\instrument, \trbass,
				\note, Pseq([
					0,
				],inf),
				\octave, 3,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\lpenvamt, 1/2,
				\lpenv2amt, ~pmodenv.(Pseq([1/2,2],inf), 1),
				\rq, ~pmodenv.(Pseq([0.71,0.2,0.1,0.4],inf), 5.8),
				\lpfr, ~pmodenv.(Pseq([2,1/2,1,4]*1.7,inf), 10.9),
				\lpenv, Pseq([
					[ Env([0,1,0],[0.01,0.18]) ]
				],inf),
				\lpenv2, Pseq([
					[ Env([0,1,0],[0.004,0.18], [1,1]) ]
				],inf),
				\isRest, Pseq([
					1,0,1,0,1,0, 1,0,1,0,1,0, 1,0,1,0,1,0, 1,0,0,0,0,0, 
					1,0,1,0,1,0, 1,0,1,0,1,0, 1,0,1,0,1,0, 1,0,1,0,1,0, 
				],inf).coin.not,
				\dur, 1/24,
				\amp, 0.1/1.2,
				\out, BusDef(\fxbus1, \audio),
			),
			Pmono(\enver,
				\env, Pseq([
					[Env([0,1,1,0],[0.1,0.7,0.1]/4/~t,[3,3,-3,-3])],
				],inf),
				\trigger, 1,
				\inbus, BusDef(\fxbus1, \audio),
				\mix, 1,
				\dur, 1/4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2343].value,
				\isRest, Pseq([
					0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.3,0.2) ],
				],inf),
				\sustain, 0.1,
				\gain, 0.11,
			),
		]),
	])
)).play;
);

(
SynthDef(\droidblip, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar( freq * ( LFNoise0.kr(\randfreq.kr(1)).unipolar * \randamt.kr(1) + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

ProtoDef(\piano).startControl

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind( \instrument, \droidblip,
			 \randfreq, 16*~t,
			 \randamt, Pseg(Pseq([0,1,2],inf),8),
			 \adsr, Pseq([
			 	[ Env.adsr(0.1,0.1,0.8,0.4) ],
			 ],inf),
			 \legato, 1/2,
			\note, Pseq([
				0
			],inf),
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fxbus1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\fxbus1, \audio),
			\delay, 1/4/~t,
			\decay, 2/~t,
			\dur, 1,
		),
	])
)).play;
);

///////


Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 1,
	\amp, 0.1,
),


(
SynthDef(\gitbufrand, {
	arg buf, rate=1, out=0, lfo=0.2, trate=0.5, atk=0.1, rel=5, amp=0.5, pan=0, startPos;
	var sig, trig, env;

	env = EnvGen.kr(Env.new([0,1,0], [atk, rel]), doneAction: 2);
	
	sig = PlayBuf.ar(1, buf, rate * BufRateScale.ir(buf), 1, startPos, loop: 1);

	sig = sig * amp * env;
	sig = Pan2.ar(sig, pan);

	Out.ar(out, sig);
}).add;
)

~git1 = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
~git2 = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
(
Pdef(\gitbufs,
	Pbind(
		\instrument, \gitbufrand,
		\dur, Pwhite(1.5, 2.2, inf)/3,
		\buf, Pseq([ ~git1, ~git2 ],inf),
		\myout, Pseq([0,1],inf),
		\out, Pkey(\myout),
		\rate, 1,
		\startPos, 0,
		\amp, 0.5,
		\pan, Pwhite(-1, -1, inf),
		\rel, 10,

)).play;

)

(
SynthDef(\latched, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Latch.ar(sig, Impulse.ar(MouseX.kr(10,4999)));
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

[0.3, -0.3].midiratio
(
SynthDef(\pwpad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\fadsr.kr(Env.adsr(2.1,1.1,0.4,1.1, 1, -2)), gate, doneAction:0);
	env2 = SinOsc.ar(freq/2); 
	env3 = EnvGen.kr(\triadsr.kr(Env.adsr(3.1,2.1,1,1.1)), gate, doneAction:0);
	env4 = SinOsc.ar(0.10 * SinOsc.kr(0.10, Rand(0,1.0)).range(0,0.10), Rand(0,1.0)).range(1/2,2);
	env5 = EnvGen.ar(Env.triangle(3.1,4.1),gate,doneAction:0);
	env6 = SinOsc.ar(1/113, Rand(0,1.0))*0.1;
	sig1 = Pulse.ar(freq * [0.03, -0.03].midiratio, SinOsc.ar(0.01)+[0.4,0.8* env6]  );
	sig2 = LFTri.ar(freq * ( env4 * env4 * 0.021 + 1 )) * env3;
	sig2 = BPF.ar(sig2, freq, 0.7);
	sig2 = FreqShift.ar(sig2, 0.2) * 0.3 + sig2;
	sig3 = BPF.ar(WhiteNoise.ar, freq*2,0.4);
	sig1 = RLPF.ar(sig1, \lpfr.kr(1.1/2) * freq * (env1 * 5 + 1) * (env2 * env1 * 0.4 + 1), \rq.kr(0.5));
	sig = [sig1*1,sig2 * 0.2, sig3 * 0.2].sum;
	sig = Latch.ar(sig, Impulse.ar(4600)) * 0.02 + sig;
	//sig = [sig2];
	//sig = Pulse.ar(freq, SinOsc.ar(0.01)+0.4 );
	pan = pan + ( [-1,1]*0.3 );
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\pwpad2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\fadsr.kr(Env.adsr(2.1,1.1,0.4,1.1, 1, -2)), gate, doneAction:0);
	env2 = SinOsc.ar(freq/2); 
	env3 = EnvGen.kr(\triadsr.kr(Env.adsr(3.1,2.1,1,1.1)), gate, doneAction:0);
	env4 = SinOsc.ar(0.10 * SinOsc.kr(0.10, Rand(0,1.0)).range(0,0.10), Rand(0,1.0)).range(1/2,2);
	env5 = EnvGen.ar(Env.triangle(3.1,4.1),gate,doneAction:0);
	env6 = SinOsc.ar(1/113, Rand(0,1.0))*0.1;
	sig1 = Pulse.ar(freq * [0.03, -0.03].midiratio, SinOsc.ar(0.01)+[0.4,0.8* env6]  );
	sig2 = LFTri.ar(freq * ( env4 * env4 * 0.021 + 1 )) * env3;
	sig2 = BPF.ar(sig2, freq, 0.7);
	sig2 = FreqShift.ar(sig2, 10.2) * 0.3 + sig2;
	sig3 = BPF.ar(WhiteNoise.ar, freq*2,0.4);
	sig1 = RLPF.ar(sig1, \lpfr.kr(1.1/4) * freq * (env1 * 5 + 1) * (env2 * env1 * 0.4 + 1), \rq.kr(0.5));
	sig = [sig1*1,sig2 * 0.2, sig3 * 0.2].sum;
	sig = Latch.ar(sig, Impulse.ar(2600 - ( env1 * 400 ))) * 0.72 * ( SinOsc.kr(8*~t) * 1 + 1 ) + sig;
	//sig = [sig2];
	//sig = Pulse.ar(freq, SinOsc.ar(0.01)+0.4 );
	pan = pan + ( [-1,1]*0.3 );
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);

SynthDef(\bipsin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \pwpad,
			\adsr, Pseq([
				[ Env.adsr(0.3,0.3,0.8,2.1) ],
			],inf),
			\note, Pseq([
				[0,4,7,12,16,4+12],
				[0,3,6,12,18,3+12],
				[0,7,12,15, 10],
				[0,7,12,15, 8+12]+2,
			],inf),
			\octave, 4,
			\dur, 2,
			\amp, 0.1/2,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \bipsin,
			\adsr, Pseq([
				[ Env.adsr(0.03,0.3,0.8,0.1) ],
			],inf),
			\note, Pseq([
				Plazy({ arg ev;
					Pstep(Pseq(

						[
							[0,4,7,12,16,4+12],
							[0,3,6,12,18,3+12],
							[0,7,12,15, 10],
							[0,7,12,15, 8+12]+2,
						].collect({ arg tab;
							Pfunc({ tab.choose })
						})
					),2)
				}).loop,
			],inf),
			\octave, Prand([5,6,7],inf),
			\sustain, 0.1,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,1,
			],inf).coin.not,
			\dur, Plazy({ Pseq(32.partition(8),1)/32 }).loop,
			\amp, 0.1,
			//\out, BusDef(\fxchorus, \audio),
		),
		PmonoArtic(\acidbass,
			\note, Pseq([
				0,
			],inf),
			\lpenvtrig, 1,
			\lpfr, ~pmodenv.(Pseq([1/4,4,2],inf), 8),
			\lpenvamt, ~pmodenv.(Pseq([8,1/4,2,1,4],inf), 1),
			\octave, Pseq([
				4,5,5,5, 
			],inf)-1,
			\legato, Pseq([
				0.5,0.1,1,1,
			],inf),
			\accent, Pseq([
				1,1,0,1, 
			],inf),
			\dur, 1/16,
			\amp, 0.12 * ( Pkey(\accent) + 1 ) / 2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[21].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			//\lag, 0.04,
			\dur, 1/8,
			\gain, 0.31,
			\out, BusDef(\track1, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\track1),
			\pregain, 1,
			\postgain, 1,
			\delay, 0.0,
			\send0, 0.2,
			\sendbus0, BusDef(\fxchorus, \audio, 2),
			\dur, 1,
		),
		Pbind(
			\instrument, \pwpad2,
			\adsr, Pseq([
				[ Env.adsr(0.3,0.3,0.8,1.1) ],
			],inf),
			\note, Pseq([
				Plazy({ arg ev;
					Pseq(

						[
							[0,4,7,12,16,4+12],
							[0,3,6,12,18,3+12],
							[0,7,12,15, 10],
							[0,7,12,15, 8+12]+2,
						].collect({ arg tab;
							[
								Pseq([[tab.choose, tab.choose], Rest(1)]);
								Pseq([Rest(1), [tab.choose]]);
								Pseq([Rest(1), [tab.choose, tab.choose]]);
								Pseq([tab.choose, tab.choose]);
								Pseq([tab.choose, tab.choose]);
								Pseq([tab.choose, tab.choose]);
								Pseq([tab.choose, Rest(1)]);
							].choose;
						})
					)
				}).loop,
			],inf),
			\octave, Prand([5,6],inf),
			\legato, 1,
			\dur, 2,
			\amp, 0.1/2,
			\out, BusDef(\fxchorus, \audio),
		),
		Pbind(
			\instrument, \pwpad,
			\adsr, Pseq([
				[ Env.adsr(0.3,0.3,0.8,4.1) ],
			],inf),
			\note, Pseq([
				[0,4,7,12,16,4+12],
				[0,3,6,12,18,3+12],
				[0,7,12,15, 10],
				[0,7,12,15, 8+12]+2,
			],inf),
			\octave, 4,
			\legato, 1/2,
			\dur, 4,
			\amp, 0.1/2,
			\out, BusDef(\fxchorus, \audio),
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fxchorus, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 0.5,
			\fb, 0.9,
			\delay, 0.1,
			\diff, 0.001,
			\modfreq, 0.1,
			\modamp, 1/6,
			\gain,2,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fxverb,\audio),
		),
		Pmono(\fx_freeverb2,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\fxverb, \audio),
			\verbmix, 0.6,
			\room, 1.9,
			\damp, 0.7,
			\mix, 1,
			\gain, 1,
			\dur, 2,
		),
		
	])
)).play;
);

~t = 145/4/60; TempoClock.default.tempo = ~t;

(
SynthDef(\acidbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env.perc(0.01,0.7)), \lpenvtrig.tr(1), doneAction:2);
	sig1 = Pulse.ar(freq * [1/2,1,2,3/2], LFNoise1.kr([0.1,0.11]/100)/10) * [0.7,1,0.7,0.2];
	sig2 = LFSaw.ar(freq * [1/2,1,2,3/2]) * [1.0,0.4,0.2,0.1];
	sig = [sig1, sig2].sum;

	sig3 = Latch.ar(sig, Impulse.ar(\latchfreq.kr(300) * ( env1 * 2 + 1 )));
	sig = SelectX.ar(\latchmix.kr(0.51), [sig, sig3]);

	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * (env1 * \lpenvamt.kr(4.4) + 1), \rq.kr(0.1));
	sig = sig + ( MoogFF.ar(sig, \lpfr.kr * freq * (env1 * \lpenvamt.kr + 1), \q.kr(2.5)) * 2 );
	//sig = MoogVCF.ar(sig, \lpfr.kr(1.1) * freq * (env1 * \lpenvamt.kr(4.4) + 1), \q.kr(3.1)) * 4;

	sig4 = sig * \distpreamp.kr(10);
	sig = SelectX.ar(\distmix.kr(0.1), [sig, sig4]);

	sig = HPF.ar(sig, 170);

	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part2, Pdef(\acidbass, 
	Ppar([
		PmonoArtic(\acidbass,
			\note, Pseq([
				0,
			],inf),
			\lpenvtrig, 1,
			\lpfr, ~pmodenv.(Pseq([1/4,4,2],inf), 8),
			\lpenvamt, ~pmodenv.(Pseq([8,1/4,2,1,4],inf), 1),
			\octave, Pseq([
				4,5,5,5, 5,5,4,5, 4,5,5,6, 7,6,5,5,
			],inf)-1,
			\legato, Pseq([
				0.5,1,1,1, 0.5,1,1,1, 0.5,1,1,0.5, 1,1,1,1,
			],inf),
			\accent, Pseq([
				1,1,0,1, 
			],inf),
			\dur, 1/16,
			\amp, 0.1 * ( Pkey(\accent) + 1 ) / 2,
		),
		
	])
)).play;
);
