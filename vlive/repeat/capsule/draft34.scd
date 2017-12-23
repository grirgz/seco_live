~t = 105/1/60; TempoClock.default.tempo = ~t;

(
	Pdef(\part, Pdef(\plop, 
		Ppar([

			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
				],inf).coin.not,
				//\dur, 1/8 * Pseq([4/3,2/3],inf),
				\dur, 1/8,
				\amp, 0.2,
				//			\out, BusDef(\fx2),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				//\out, BusDef(\fx1, \audio),
				\sustain, 0.2,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 4,
				\speed, 0.9,
				\isRest, Pseq([
					1,0,1,0,
					0,0,1,0,
				],inf).coin.not,
				//\out, BusDef(\fx1, \audio),
				\sustain, 0.071,
				\gain, 0.3,
				\dur, 1/4,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0, 
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.4, 0.1, 0.2, 0.1,
				],inf),
				\dur, 1/16,
				//	\out, BusDef(\fx3, \audio),
				//\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
				\pan, 0,
				\amp, 0.02,
			),
			Pbind(
				\instrument, \phyhat4,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.4, 0.1, 0.2, 0.1,
				],inf),
				\dur, 1/16,
				//	\out, BusDef(\fx3, \audio),
				//\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
				\pan, 0,
				\amp, 0.02,
			),

		])
	)).play;
)

////////////////////////////////////////////

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\fxperc)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
				],inf).coin.not,
				//\dur, 1/8 * Pseq([4/3,2/3],inf),
				\dur, 1/8,
				\amp, 0.2,
				//			\out, BusDef(\fx2),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				//\out, BusDef(\fx1, \audio),
				\sustain, 0.2,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/8,
			)),
		]),
		Pbind(
			\instrument, \brolosc,
			\note, Pseq([
				0,4,4,4,
			],inf),
			\sustain, 0.1,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fx1, \audio),
		),
				Pmono(\fxbrol,
					\inbus, BusDef(\fx1, \audio),
					\fb, 0.1,
					\mix, Pseq([
						0.5
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\oscmix, ~pmodenv.(Pseq([0,4]/4,inf), 8),
					\distamp, 50,
					\delay, 0.0001,
					\gain, 0.2,
					\dur, Pseq([1/2],inf),
					\amp, 0.1,
				),
				Pmono(\fxbrol,
					\inbus, BusDef(\fxperc, \audio),
					\fb, 0.1,
					\mix, Pseq([
						0.5
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\oscmix, ~pmodenv.(Pseq([0,4]/4,inf), 8),
					\distamp, 5.50,
					\delay, 0.0001,
					\gain, 1.2,
					\dur, Pseq([1/2],inf),
					\amp, 0.1,
				),
	])
)).play;
)

////////////////

(
SynthDef(\brolosc, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(\oscmix.kr(0.5)*2, [sig1, sig2, sig3]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\fxbrol, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in;
	var insig;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	//sig = Decimator.ar(sig, \samplerate.kr(1)*SampleRate.ir,8);
	//insig = SelectX.ar(\inmix.kr(0.5), [DC.ar(0), in]);
	insig = in;
	sig = LocalIn.ar(2) * \fb.kr(0.01);
	sig = sig + insig;
	//sig = sig * ( SinOsc.ar(4) * 1 + 1 );
	//sig = sig * ( SinOsc.ar(410 * ( SinOsc.kr(1/13) * 1 + 1 )) * 1 + 1 );
	//sig = DelayC.ar(sig, 0.2, 0.10001 * ( SinOsc.kr(4.01*[1,3.23,1.342]) * 0.02 + 1 )).sum + sig;
	//sig = DelayC.ar(sig, 0.1, 0.01 * ( SinOsc.kr(12 * ( SinOsc.kr(1/12) * 1 + 1 )) * 1 + 1 ) * ( SinOsc.kr(0.01*[1,3.23,1.342]*0.123) * 0.2 + 1 )).sum + sig;
	//sig = AllpassC.ar(sig, 0.2, 0.1 * ( SinOsc.ar(341) * 1 + 1 ),0)+sig;
	sig = AllpassC.ar(sig, 0.2, 0.0001 * ( SinOsc.ar(141) * 1 + 1 ),0)+sig;
	//sig = DelayC.ar(sig, 0.3, 0.01 * ( SinOsc.kr(1/10) * 1 + 1 ) * ( SinOsc.ar(3208*[1,1.023,1.0342]) * 0.1 + 1 )).sum + sig;
	//sig = DelayC.ar(sig, 0.3, 0.1 * ( SinOsc.ar(0.01*[1,1.023,1.0342]) * 0.8 + 1 )).sum + sig;
	sig = ( sig*\distamp.kr(1) ).tanh * \distpostamp.kr(1/2);
	sig = LPF.ar(sig, SinOsc.kr(1/4 * ( SinOsc.kr(1/23) * 1 + 1 )).range(30,11000));
	sig = LPF.ar(sig, \lpf.kr(10000));
	//sig = MidEQ.ar(sig, 200, 1, -0.2);
	sig = sig /2;
	sig = Limiter.ar(sig);
	sig = LeakDC.ar(sig);
	LocalOut.ar(sig);
	sig.debug("sig");
	sig = SelectX.ar(\mix.kr(0.5), [insig, sig]);
	sig = sig * \gain.kr(0.3);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\fxperc)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				//\dur, 1/8 * Pseq([4/3,2/3],inf),
				\dur, 1/8,
				\amp, 0.2,
				//			\out, BusDef(\fx2),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				//\out, BusDef(\fx1, \audio),
				\sustain, 0.2,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/8,
			)),
		]),
		Pbind(\out, BusDef(\fxperc2)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,

					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,
					1,0,1,0, 0,0,1,0,
				],inf).coin.not,
				//\dur, 1/8 * Pseq([4/3,2/3],inf),
				\dur, 1/8,
				\amp, 0.2,
				//			\out, BusDef(\fx2),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				//\out, BusDef(\fx1, \audio),
				\sustain, 0.07,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/8,
			)),
		]),
		Pbind(
			\instrument, \brolosc,
			\note, Pseq([
				0,4,4,4,
			],inf),
			\freq, Pseq([
				100,130,
			],inf),
			\oscmix, ~pmodenv.(Pseq([0,4]/4,inf), 8),
			\oscmix, Pseq([
				1,1/2,1/4,0,
			],inf),
			\isRest, Pseq([
				1,0,1,1, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\fxbass, \audio),
		),
		Pbind(
			\instrument, \brolosc,
			\note, Pseq([
				0,4,4,4,
			],inf),
			\freq, Pseq([
				100,400,300,100,
			],inf).stutter(4)*4,
			\oscmix, ~pmodenv.(Pseq([0,4]/4,inf), 8),
			\oscmix, Pseq([
				1,1/2,1/4,0,
			],inf),
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\fx1, \audio),
		),
				Pmono(\fxbrol2,
					\inbus, BusDef(\fxbass, \audio),
					\fb, 0.4,
					\mix, Pseq([
						0.7
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\delayfac, ~pmodenv.(Pseq([1,2,1,4],inf), 8),
					\lpf, Pseq([
						1000,4000,100,1000,
					],inf),
					\lpf, 14000,
					\prelim, 1.2,
					\wetgain, 0.4,
					\distamp, Pseq([
						1,10,3,100
					],inf).stutter(16*4),
					\delay, 0.1001,
					\gain, 0.8,
					\dur, Pseq([1/2],inf),
					\amp, 0.1,
				),
				Pmono(\fxbrol2,
					\inbus, BusDef(\fx1, \audio),
					\fb, 0.1,
					\mix, Pseq([
						0.7
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\delayfac, ~pmodenv.(Pseq([1,2,1,4],inf), 8),
					\lpf, 14000,
					\lpf, ( Pseq([
						1000,14000,100,7000,
						100,100, 14000,10000,
					],inf) * Pseq([
						1/10,1,2,4,
						8,16,1,16,
						1/10,1,2,4,
						8,16,1,16,
						1/10,1,2,4,
						8,16,1,16,
						20,20,20,20,
						20,20,1,1,
					],inf).stutter(16) ).clip(10,20000),
					\prelim, 1.2,
					\wetgain, 0.4,
					\distamp, 100,
					\delay, 0.0001,
					\gain, 0.8,
					\dur, Pseq([1/4],inf),
					\amp, 0.1,
				),
				Pmono(\fxbrol2,
					\inbus, BusDef(\fxperc, \audio),
					\fb, 0.020,
					\mix, Pseq([
						0.5
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\distamp, 100.1050,
					\delayfac, 0.1001,
					\decay, 0.0001,
					\gain, 1.0,
					\dur, Pseq([1/2],inf),
					\amp, 0.1,
				),
				Pmono(\fxbrol2,
					\inbus, BusDef(\fxperc2, \audio),
					\fb, 0.03,
					\mix, Pseq([
						0.5
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\distamp, Pseq([
						10,10,100,10,
					],inf).stutter(16*4),
					\delayfac, 0.01,
					\decay, 0.0000,
					\gain, 1.2,
					\dur, Pseq([1/2],inf),
					\amp, 0.1,
				),
	])
)).play;
)

Pdef(\part).clear

(
SynthDef(\brolosc2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(\oscmix.kr(0.5)*2, [sig1, sig2, sig3]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = HPF.ar(sig, \hpf.kr(10));
	sig = sig * \prelim.kr(1);
	sig = Limiter.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\fxbrol2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in;
	var insig;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	//sig = Decimator.ar(sig, \samplerate.kr(1)*SampleRate.ir,8);
	//insig = SelectX.ar(\inmix.kr(0.5), [DC.ar(0), in]);
	insig = in;
	sig = LocalIn.ar(2) * \fb.kr(0.01);
	sig = sig + insig;
	//sig = sig * ( SinOsc.ar(4) * 1 + 1 );
	//sig = sig * ( SinOsc.ar(410 * ( SinOsc.kr(1/13) * 1 + 1 )) * 1 + 1 );
	//sig = DelayC.ar(sig, 0.2, 0.10001 * ( SinOsc.kr(4.01*[1,3.23,1.342]) * 0.02 + 1 )).sum + sig;
	//sig = DelayC.ar(sig, 0.1, 0.01 * ( SinOsc.kr(12 * ( SinOsc.kr(1/12) * 1 + 1 )) * 1 + 1 ) * ( SinOsc.kr(0.01*[1,3.23,1.342]*0.123) * 0.2 + 1 )).sum + sig;
	//sig = AllpassC.ar(sig, 0.2, 0.1 * ( SinOsc.ar(341) * 1 + 1 ),0)+sig;
	sig = AllpassC.ar(sig, 0.2, 0.0001 * \delayfac.kr(1),\decay.kr(0))+sig;
	//sig = DelayC.ar(sig, 0.3, 0.01 * ( SinOsc.kr(1/10) * 1 + 1 ) * ( SinOsc.ar(3208*[1,1.023,1.0342]) * 0.1 + 1 )).sum + sig;
	//sig = DelayC.ar(sig, 0.3, 0.1 * ( SinOsc.ar(0.01*[1,1.023,1.0342]) * 0.8 + 1 )).sum + sig;
	sig = ( sig*\distamp.kr(1) ).tanh * \distpostamp.kr(1/2);
	//sig = LPF.ar(sig, SinOsc.kr(1/4 * ( SinOsc.kr(1/23) * 1 + 1 )).range(30,11000));
	sig = LPF.ar(sig, \lpf.kr(10000));
	//sig = MidEQ.ar(sig, 200, 1, -0.2);
	sig = HPF.ar(sig, \hpf.kr(10));
	sig = sig /2;
	sig = sig * \prelim.kr(1);
	sig = Limiter.ar(sig);
	sig = LeakDC.ar(sig);
	LocalOut.ar(sig);
	sig.debug("sig");
	sig = sig * \wetgain.kr(1);
	sig = SelectX.ar(\mix.kr(0.5), [insig, sig]);
	sig = sig * \gain.kr(0.3);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\fxperc)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				//\dur, 1/8 * Pseq([4/3,2/3],inf),
				\dur, 1/8,
				\amp, 0.2,
				//			\out, BusDef(\fx2),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				//\out, BusDef(\fx1, \audio),
				\sustain, 0.2,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/8,
			)),
		]),
		Pbind(\out, BusDef(\fxperc2)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,

					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,
					1,0,1,0, 0,0,1,0,
				],inf).coin.not,
				//\dur, 1/8 * Pseq([4/3,2/3],inf),
				\dur, 1/8,
				\amp, 0.2,
				//			\out, BusDef(\fx2),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				//\out, BusDef(\fx1, \audio),
				\sustain, 0.07,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/8,
			)),
		]),
		Pbind(
			\instrument, \brolosc2,
			\freq, Pseq([
				70,70,70,130,
			],inf),
			\legato, Pseq([
				1,1,0,1, 1,1,0,1,
				4,0,0,0, 1,1,1,0,
			],inf),
			\lpfr, Pseq([
				1,2,4,8,
				16,16,16,16,
			],inf).stutter(16) * Pseq([1,1.2,1,0.5],inf),
			\rq, Pseq([
				0.5, 0.5, 0.5, 0.5,
				0.1, 0.1, 0.051, 0.01,
			],inf).stutter(16),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\oscmix, Pseq([
				1/2,
			],inf),
			\prelim, 2,
			\hpf, 50,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\fxbass, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \basicbass,
			\freq, Pseq([
				70,70,70,130,
			],inf),
			\legato, Pseq([
				1,1,0,1, 1,1,0,1,
				4,0,0,0, 1,1,1,0,
			],inf),
			\lpfr, Pseq([
				1,2,4,8,
				16,16,16,16,
			],inf).stutter(16) * Pseq([1,1.2,1,0.5],inf),
			\rq, Pseq([
				0.5, 0.5, 0.5, 0.5,
				0.1, 0.1, 0.051, 0.01,
			],inf).stutter(16),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\oscmix, Pseq([
				1/2,
			],inf),
			\prelim, 2,
			\hpf, 50,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\fxbass, \audio),
		),
		Pbind(
			\instrument, \brolosc,
			\note, Pseq([
				0,4,4,4,
			],inf),
			\freq, Pseq([
				100,400,300,100,
			],inf).stutter(4)*4,
			\oscmix, ~pmodenv.(Pseq([0,4]/4,inf), 8),
			\oscmix, Pseq([
				1,1/2,1/4,0,
			],inf),
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\fx1, \audio),
			\isRest, true,
		),
				Pmono(\fxbrol2,
					\inbus, BusDef(\fxbass, \audio),
					\fb, 0.4,
					\mix, Pseq([
						0.1
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\delayfac, ~pmodenv.(Pseq([1,2,1,4],inf), 8),
					\lpf, Pseq([
						1000,4000,100,1000,
					],inf),
					\lpf, 14000,
					\prelim, 1.2,
					\wetgain, 0.4,
					\distamp, 1,
					\delay, 0.1001,
					\gain, 1.8,
					\hpf, 400,
					\dur, Pseq([1/2],inf),
					\amp, 0.1,
				),
				Pmono(\fxbrol2,
					\inbus, BusDef(\fx1, \audio),
					\fb, 0.1,
					\mix, Pseq([
						0.7
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\delayfac, ~pmodenv.(Pseq([1,2,1,4],inf), 8),
					\lpf, 14000,
					\prelim, 1.2,
					\wetgain, 0.4,
					\distamp, 10,
					\delay, 0.0001,
					\gain, 0.8,
					\dur, Pseq([1/4],inf),
					\amp, 0.1,
				),
				Pmono(\fxbrol2,
					\inbus, BusDef(\fxperc, \audio),
					\fb, 0.020,
					\mix, Pseq([
						0.5
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\distamp, 100.1050,
					\delayfac, 0.1001,
					\decay, 0.0001,
					\gain, 0.4,
					\dur, Pseq([1/2],inf),
					\amp, 0.1,
				),
				Pmono(\fxbrol2,
					\inbus, BusDef(\fxperc2, \audio),
					\fb, 0.03,
					\mix, Pseq([
						0.5
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\distamp, Pseq([
						10,10,100,10,
					],inf).stutter(16*4),
					\delayfac, 0.01,
					\decay, 0.0000,
					\gain, 0.6,
					\dur, Pseq([1/2],inf),
					\amp, 0.1,
				),
	])
)).play;
)


///

(
SynthDef(\crackle, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = Crackle.ar(\chaos.kr(1));
	sig = Formlet.ar(sig, freq,\format.kr(0.21),\formdec.kr(0.1));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = HPF.ar(sig, 50);
	sig = Limiter.ar(sig);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\crackle2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = Crackle.ar(\chaos.kr(1));
	sig = LFSaw.ar(freq * ( sig* 10.1 + 1 )); 
	//sig = Formlet.ar(sig, freq,\format.kr(0.21),\formdec.kr(0.1));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = HPF.ar(sig, 50);
	sig = Limiter.ar(sig);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part2).reset;
);

(
SynthDef(\crackle3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,4,2,1],[0.1,0.18,1]), \trigenv.tr(1));
	sig = Crackle.ar(\chaos.kr(1));
	sig = LFSaw.ar(freq * [1/2,1,2,1.001,2.0001] * ( sig* \modamp.kr(1.1)  + 1 )); 
	//sig = Formlet.ar(sig, freq,\format.kr(0.21)* env1,\formdec.kr(0.1));
	sig = LPF.ar(sig, \lpf.kr(400) * env1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = HPF.ar(sig, \hpf.kr(50));
	sig = Limiter.ar(sig);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\part2).reset;
);

Formlet
(
Pdef(\part2, Pdef(\plop2, 
	Ppar([
		Pmono(\crackle3,
			\chaos, 1.93500,
			\note, Pseq([
				1,3,12,4,
			],inf),
			\trigenv, Pseq([
				1,0,0,0,
				1,1,0,0,
			],inf),
			\note, Pseq([
				[1,3,9],
				[1,3,9],
				[1,3,9],
				[1,3,9]+4,
			],inf),
			\octave, 5,
			\format, Pseq([
				1,2,3,4,5
			],inf)/14,
			\formdec, 0.3,
			\dur, 1,
			\amp, 0.3,
		),
	])
)).play;
)
Pdef(\part2).clear

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\fxperc)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				//\dur, 1/8 * Pseq([4/3,2/3],inf),
				\dur, 1/8,
				\amp, 0.2,
				//			\out, BusDef(\fx2),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				//\out, BusDef(\fx1, \audio),
				\sustain, 0.2,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
				],inf).coin.not,
				//\out, BusDef(\fx1, \audio),
				\sustain, 0.1,
				\gain, 0.2,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					1,0,0,0,
				],inf).coin.not,
				//\out, BusDef(\fx1, \audio),
				\sustain, 0.1,
				\gain, 0.1,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/8,
			)),
		]),
		Pmono(\crackle3,
			\chaos, 1.93500,
			\note, Pseq([
				1,3,12,4,
			],inf),
			\trigenv, Pseq([
				1,0,0,0,
				1,1,0,0,
			],inf),
			\note, Pseq([
				[1,3,9],
				[1,3,9],
				[1,3,9],
				[1,3,9]+4,
			],inf),
			\note, Pseq([
				[0,7,11,17],
				[0,7,11,17],
				[0,7,11,17],
				[0,6,9,16],
			],inf).stutter(2),
			\note, Pseq([
				[0,11,13],
				[0,2,3,13],
				[0,2,14,13],
				[0,3,17,13],
			],inf).stutter(2),
			\octave, 5,
			\format, Pseq([
				1,2,3,4,5
			],inf)/14,
			\formdec, 0.3,
			\dur, 1,
			\amp, 0.3,
			\out, BusDef(\fx1, \audio),
		),
				Pmono(\fxbrol2,
					\inbus, BusDef(\fxperc, \audio),
					\fb, 0.020,
					\mix, Pseq([
						0.5
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\distamp, 100.1050,
					\delayfac, 0.1001,
					\decay, 0.0001,
					\gain, 0.4,
					\dur, Pseq([1/2],inf),
					\amp, 0.1,
				),
				Pmono(\fxbrol2,
					\inbus, BusDef(\fx1, \audio),
					\fb, 0.03,
					\mix, Pseq([
						0.5
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\distamp, Pseq([
						10,10,100,10,
					],inf).stutter(16*4),
					\delayfac, 0.01,
					\decay, 0.0000,
					\gain, 0.6,
					\dur, Pseq([1/2],inf),
					\amp, 0.1,
				),
	])
)).play;
)
