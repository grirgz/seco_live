(
SynthDef(\playersec_osczig_fat, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, velamp=1;
	// pos in seconds
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var trigger = Impulse.ar(\trigfreq.kr(0) * [1,1/2,1/4,2]);
	var speedtrigger = Impulse.ar(\trigfreq.kr*2);
	speed = speed * Demand.ar(speedtrigger, 0, Dseq([
		1,-1,
	],inf));
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos+[ [0,0.01] ]*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop).mean;
	env1 = EnvGen.kr(Env([1/2,1,2,1],[0.1,2.1,4.8]), 1);
	sig1 = RLPF.ar(sig, \lpfr.kr(1) * \trigfreq.kr * env1, \rq.kr(0.5));
	sig = SelectX.ar(\lpmix.kr(0.5), [sig, sig1]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	sig.debug("sig");
	sig = sig.flop.sum.debug("sig");
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
SynthDef(\playersec_zix2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.5,0],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,0.5,0],[0.1,0.8]), 1);
	speed = speed * EnvGen.kr(Env([0.21,1,1,0.2,1],[0.12,1,0.12,0.12]), 1);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = FreqShift.ar(LPF.ar(sig, 4000), 2300) + HPF.ar(sig, 4000);
	sig = HPF.ar(sig, 6000)*18;
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
SynthDef(\comp, { arg out=0, gate=1,freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\sendbus2, \audio)), 2); 
	var sidein = InFeedback.ar(\sidebus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	//sig = sig + DelayC.ar(sig, 0.01, 0.0001 * [0.1235,1,0.86534]).mean/2;
	sig = Compander.ar(sig, sidein, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.9), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = sig * \gain.kr(1);
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	//sig = in;
	sig = sig + CombL.ar(sig, 0.5, 0.5 * SinOsc.kr(1/12).range(1.01,1),1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0,1,0.01)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\concombre, { arg out=0, gate=1,freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\sendbus2, \audio)), 2); 
	var sidein = InFeedback.ar(\sidebus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	//sig = sig + DelayC.ar(sig, 0.01, 0.0001 * [0.1235,1,0.86534]).mean/2;
	sig = sig + CombL.ar(sig, 0.5, 0.5 * SinOsc.kr(1/12).range(1.01,1),1);
	sig = Compander.ar(sig, sidein, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.9), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = sig * \gain.kr(1);
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	//sig = in;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0,1,0.01)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\droblip, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * ( 1 + ( SinOsc.ar((1..8)*100 * ( 1 + ( SinOsc.ar((1..8)*40 * ( 1 + ( SinOsc.kr((1..8)/88) * 1 ))) * 1 ))) * 1 ));
	sig = sig * ( 1 + ( SinOsc.ar((1..8)*101 * ( 1 + ( SinOsc.ar((1..8)*40 * ( 1 + ( SinOsc.kr((1..8)/88) * 1 ))) * 1 ))) * 1 ));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	pan = LFNoise1.ar((1..8)/80);
	sig = Pan2.ar(sig, pan, amp.lag(0.1)).mean;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
SynthDef(\droblipbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = sig* ( 1 + ( LFSaw.ar(freq * [1/2,1,2]) * 0.5 ));
	sig = sig.tanh;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = LPF.ar(sig, 1000);
	sig = sig * 2;
	sig = HPF.ar(sig, 40);
	pan = LFNoise1.ar((1..8)/80)*0.01;
	sig = Pan2.ar(sig, pan, amp.lag(0.1)).mean;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
~mymaster = {
	ProtoDef(\simpleMixer).play;
};
)

(
	~mymaster.();
	~master.();
	// static drone
//ProtoDef(\simpleMixer).play;
Pdef(\testox, Pdef(\oxstatic,
	Ppar([
		4.collect {
			Pmono(  \droblip,
				\freq, Pseq([
					exprand(100.0,14000),
					exprand(100.0,14000),
				],inf).stutter([2,4,6,8].choose).stutter(4),
				\dur, 1,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,0,1,1,
					1,0,1,1,
			
				].scramble,inf)*0.1/4,
			);
		},
		1.collect {
			Pmono(  \droblipbass,
				\freq, Pseq([
					exprand(60.0,80),
					exprand(60.0,80),
				],inf).stutter([2,4,6,8].choose).stutter(4),
				\dur, 2,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,0,
				],inf)*0.1,
			);
		},

		Pmono(\comp,
			\group, GroupDef(\fx, 1, \addAfter),
			\inbus, BusDef(\fx1, \audio),
			\sidebus, BusDef(\sendbus3, \audio),
			\cpt, 0.021,
			\cpabove, 0.1,
			\dur, 1,
			\amp, 0.1,
		),

				Pbind(
					\out, BusDef(\mixer2),
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,0, 1,0,1, 1,0,0, 1,0,0,
						1,0,0, 1,0,1, 1,0,0, 1,0,0,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.05,0.1,0.8,0.02) ],
					],inf),
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.1,0.01,0.01

					],inf),
					\dur, 1/12,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0132,
				),
				Pbind(
					\out, BusDef(\mixer0),
					\instrument, \snapkick,
					\isRest, Pseq([

						1,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						1,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
					],inf).coin.not,
					\sustain, 0.01,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // hi snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/2,
				),
				Pbind( // low snare
					\out, BusDef(\drumchain, \audio),
					\instrument, \snaretuned,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.13) ],
					],inf),
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
						0,0,1, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,1, 0,0,0,
					],inf).coin.not,
					//\lag, 0.120/~t,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/4,
					\isRest, true,
				),
	].flat),
));
);

ProtoDef(\simpleMixer).edit
ProtoDef(\rdn2).edit
ProtoDef(\rdn).edit

(
	// waving drone
~mymaster.();
~master.();
Pdef(\testox, Pdef(\oxwave,
	Ppar([
		4.collect {
			Pmono(  \droblip,
				\freq, ~pmodenv.(Pseq([exprand(100.0,14000),exprand(100.0,14000)],inf), 8),
				\dur, 1,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,0,1,1,
					1,0,1,1,
			
				].scramble,inf)*0.1/4,
			);
		},
		1.collect {
			Pmono(  \droblipbass,
				\freq, Pseq([
					exprand(60.0,80),
					exprand(60.0,80),
				],inf).stutter([2,4,6,8].choose).stutter(4),
				\dur, 2,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,0,
				],inf)*0.1,
			);
		},

		Pmono(\concombre,
			\group, GroupDef(\fx, 1, \addAfter),
			\inbus, BusDef(\fx1, \audio),
			\sidebus, BusDef(\sendbus3, \audio),
			\cpt, 0.021,
			\cpabove, 0.1,
			\dur, 1,
			\amp, 0.1,
		),

				Pbind(
					\out, BusDef(\mixer2),
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,0, 1,0,1, 1,0,0, 1,0,0,
						1,0,0, 1,0,1, 1,0,0, 1,0,0,
						1,0,1, 1,0,1, 1,0,0, 1,0,1,
						1,0,0, 1,1,0, 0,1,1, 1,0,0,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.05,0.1,0.8,0.02) ],
					],inf),
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.1,0.01,0.01

					],inf),
					\dur, 1/12,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0132,
				),
				Pbind(
					\out, BusDef(\mixer0),
					\instrument, \snapkick,
					\isRest, Pseq([

						1,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						1,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
					],inf).coin.not,
					\sustain, 0.01,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind(
					\instrument, Pseq([\playersec_zix2],inf).stutter(8*4),
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						2.2
					],inf).stutter(1),
					\isRest, Pseq([
						3,0,0,
					],inf).coin.not,
					\speed, 0.95,
					\legato, Pseq([
						Pser([
							0.4,0.1,0.1,
							0.2,0.1,0.1,
						],8*2)*2,
					],inf),
					\legato, Pseq([
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 0,0,1, 1,0,0,

							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 1,0,0, 2,0,0,
							20,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind(
					\instrument, Pseq([\playersec_zix2],inf).stutter(8*4),
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						0.1
					],inf).stutter(1),
					\isRest, Pseq([
						3,0,0,
					],inf).coin.not,
					\speed, 1,
					\legato, Pseq([
						Pser([
							0.4,0.1,0.1,
							0.2,0.1,0.1,
						],8*2)*2,
					],inf),
					\legato, Pseq([
						18,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,1, 0,0,1,

						18,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0, 0,0,0,

						18,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

						0,0,0, 0,0,0, 0,0,1, 0,1,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,1, 0,1,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // hi snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/2,
				),
				Pbind( // low snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.13) ],
					],inf),
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 0,0,0,  0,0,1, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 1,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,1, 0,0,0,
					],inf).coin.not,
					//\lag, 0.120/~t,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/4,
				),
	].flat),
)).play;
);

(
	// end waving bass & drone
~mymaster.();
~master.();
Pdef(\testox, Pdef(\oxendwave,
	Ppar([
		4.collect {
			Pmono(  \droblip,
				\freq, ~pmodenv.(Pseq([exprand(100.0,14000)!3,exprand(100.0,14000)].flatten,inf), 4),
				\dur, 1,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,0,1,1,
					1,0,1,1,
			
				].scramble,inf)*0.1/4,
			);
		},
		1.collect {
			Pmono(  \droblipbass,
				\freq, Pseq([
					~pmodenv.(Pseq([exprand(60.0,80)!3,exprand(60.0,180)].flatten,inf), 4),
				],inf).stutter([2,4,6,8].choose).stutter(4),
				\dur, 2,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,0,
				],inf)*0.1,
			);
		},

		Pmono(\concombre,
			\group, GroupDef(\fx, 1, \addAfter),
			\inbus, BusDef(\fx1, \audio),
			\sidebus, BusDef(\sendbus3, \audio),
			\cpt, 0.021,
			\cpabove, 0.1,
			\dur, 1,
			\amp, 0.1,
		),

				Pbind(
					\out, BusDef(\mixer2),
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,0, 1,0,1, 1,0,0, 1,0,0,
						1,0,0, 1,0,1, 1,0,0, 1,0,0,
						1,0,1, 1,0,1, 1,0,0, 1,0,1,
						1,0,0, 1,1,0, 0,1,1, 1,0,0,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.05,0.1,0.8,0.02) ],
					],inf),
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.1,0.01,0.01

					],inf),
					\dur, 1/12,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0132,
				),
				Pbind(
					\out, BusDef(\mixer0),
					\instrument, \snapkick,
					\isRest, Pseq([

						1,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						1,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
					],inf).coin.not,
					\sustain, 0.01,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind(
					\instrument, Pseq([\playersec_zix2],inf).stutter(8*4),
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						2.2
					],inf).stutter(1),
					\isRest, Pseq([
						3,0,0,
					],inf).coin.not,
					\speed, 0.95,
					\legato, Pseq([
						Pser([
							0.4,0.1,0.1,
							0.2,0.1,0.1,
						],8*2)*2,
					],inf),
					\legato, Pseq([
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 0,0,1, 1,0,0,

							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 1,0,0, 2,0,0,
							20,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind(
					\instrument, Pseq([\playersec_zix2],inf).stutter(8*4),
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						0.1
					],inf).stutter(1),
					\isRest, Pseq([
						3,0,0,
					],inf).coin.not,
					\speed, 1,
					\legato, Pseq([
						Pser([
							0.4,0.1,0.1,
							0.2,0.1,0.1,
						],8*2)*2,
					],inf),
					\legato, Pseq([
						18,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,1, 0,0,1,

						18,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0, 0,0,0,

						18,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

						0,0,0, 0,0,0, 0,0,1, 0,1,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,1, 0,1,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // hi snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/2,
				),
				Pbind( // low snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.13) ],
					],inf),
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 0,0,0,  0,0,1, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 1,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,1, 0,0,0,
					],inf).coin.not,
					//\lag, 0.120/~t,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/4,
				),
	].flat),
)).play;
);

(
	// fastbass
~mymaster.();
~master.();
Pdef(\testox, Pdef(\oxfast,
	Ppar([
		1.collect {
			Pmono(  \droblip,
				\freq, Pseq([9,0],inf).midiratio* 65*8,
				\dur, 1/4,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,0,1,1,
					1,0,1,1,
			
				].scramble,inf)*0.1/4,
			);
		},
		1.collect {
			Pmono(  \droblipbass,
				\freq, Pseq([
					~pmodenv.(Pseq([exprand(60.0,80)!3,exprand(60.0,180)].flatten,inf), 4),
				],inf).stutter([2,4,6,8].choose).stutter(4),
				\dur, 1/2,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,0,
				],inf)*0.1,
				\isRest, true,
			);
		},

		Pmono(\concombre,
			\group, GroupDef(\fx, 1, \addAfter),
			\inbus, BusDef(\fx1, \audio),
			\sidebus, BusDef(\sendbus3, \audio),
			\cpt, 0.021,
			\cpabove, 0.1,
			\dur, 1,
			\amp, 0.1,
		),

				Pbind(
					\out, BusDef(\mixer2),
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,0, 1,0,0, 1,0,0, 1,0,0,
						1,0,0, 1,0,0, 1,0,0, 1,0,0,
						1,0,0, 1,0,0, 1,0,0, 1,0,0,
						1,0,1, 1,1,0, 1,1,0, 1,1,0,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.05,0.1,0.8,0.02) ],
					],inf),
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.1,0.01,0.01

					],inf),
					\dur, 1/12,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0132,
				),
				Pbind(
					\out, BusDef(\mixer0),
					\instrument, \snapkick,
					\isRest, Pseq([

						1,0,0, 1,0,0,  0,0,0, 0,0,1,
						1,0,0, 1,0,0,  0,0,0, 0,0,0,
						1,0,0, 1,0,0,  0,0,0, 0,0,1,
						1,0,0, 1,0,0,  0,0,1, 0,0,0,

						1,0,0, 1,0,0,  0,0,0, 0,0,1,
						1,0,0, 1,0,0,  0,0,0, 0,0,0,
						1,0,0, 0,0,1,  0,0,0, 0,0,1,
						1,0,1, 1,0,0,  0,0,0, 0,0,0,

						1,0,0, 1,0,0,  0,0,0, 0,0,1,
						1,0,0, 1,0,0,  0,0,0, 0,0,0,
						1,0,0, 1,0,0,  0,0,1, 0,0,1,
						1,0,0, 1,0,1,  0,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.01,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // oscsmp bass
					\instrument, \playersec_osc,
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						2.2
					],inf).stutter(1),
					\trigfreq, 65,
					\pos, ~pmodsynth.({ 
						SinOsc.kr(1/20).range(0,0.01)+1.7 + Duty.kr(1/8/~t, 0, Dseq([
							0,Dwhite(0.1,0.4,1),0,0,
						],inf)) 
					}),
					\speed, 0.95,
					\legato, Pseq([
							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							6,0,0, 0,0,0, 0,0,0, 0,0,00.81,
							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							6,0,0, 0,0,0, 0,0,1, 0,0,00.8,

							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							6,0,0, 0,0,0, 0,0,0, 0,0,00.81,
							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							4,0,0, 0,1,0, 0,0,1, 0,0,00.81,

							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							6,0,0, 0,0,0, 0,0,0, 0,0,00.81,
							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							3,0,0, 3,0,0, 0,0,0, 0,0,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // oscsmp lead
					\instrument, \playersec_osczig_fat,
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						2.2
					],inf).stutter(1),
					\trigfreq, Pseq([
						 {
							(0..24).choose
						}.dup(7).sort.reverse.midiratio * 65*16,
						 {
							(0..24).choose
						}.dup(1).sort.reverse.midiratio * 65*16,
						 {
							(0..24).choose
						}.dup(7).sort.reverse.midiratio * 65*16,
						 {
							(0..24).choose
						}.dup(1).sort.reverse.midiratio * 65*16,
					].flatten,inf).stutter(12),
					\pos, ~pmodsynth.({ 
						SinOsc.kr(1/32).range(0,0.1)+0.3  +
						SinOsc.kr(2 * ( 1 + ( SinOsc.kr(1/82) * 4 ))).range(0,0.01) 
					}),
					\speed, 0.95,
					\legato, Pseq([
							9,0,0, 0,0,0, 0,0,0, 0,0,0,
							6,0,0, 0,0,0, 0,0,0, 3,0,0,
							9,0,0, 0,0,0, 0,0,0, 0,0,0,
							2,0,0, 0,0,0, 1,1,0, 2,0,0,
					],inf),
					\rq, 0.2,
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\lpmix, 1,
					\lpfr, 0.7,
					\gain, 0.2,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // hi snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/2,
				),
				Pbind( // low snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.13) ],
					],inf),
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 0,0,0,  0,0,1, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 1,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,1, 0,0,0,
					],inf).coin.not,
					//\lag, 0.120/~t,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/4,
				),
	].flat),
)).play;
);


(
	// fastbass 2
~mymaster.();
~master.();
Pdef(\testox, Pdef(\oxfast2,
	Ppar([
		1.collect {
			Pmono(  \droblip,
				\freq, Pseq([9,0],inf).midiratio* 65*8,
				\dur, 1/4,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,0,1,1,
					1,0,1,1,
			
				].scramble,inf)*0.1/4,
			);
		},
		1.collect {
			Pmono(  \droblipbass,
				\freq, Pseq([
					~pmodenv.(Pseq([exprand(60.0,80)!3,exprand(60.0,180)].flatten,inf), 4),
				],inf).stutter([2,4,6,8].choose).stutter(4),
				\dur, 1/2,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,0,
				],inf)*0.1,
				\isRest, true,
			);
		},

		Pmono(\concombre,
			\group, GroupDef(\fx, 1, \addAfter),
			\inbus, BusDef(\fx1, \audio),
			\sidebus, BusDef(\sendbus3, \audio),
			\cpt, 0.021,
			\cpabove, 0.1,
			\dur, 1,
			\amp, 0.1,
		),

				Pbind(
					\out, BusDef(\mixer2),
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,0, 1,0,0, 1,0,0, 1,0,0,
						1,0,0, 1,0,0, 1,0,0, 1,0,0,
						1,0,0, 1,0,0, 1,0,0, 1,0,0,
						1,0,1, 1,1,0, 1,1,0, 1,1,0,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.05,0.1,0.8,0.02) ],
					],inf),
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.1,0.01,0.01

					],inf),
					\dur, 1/12,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0132,
				),
				Pbind(
					\out, BusDef(\mixer0),
					\instrument, \snapkick,
					\isRest, Pseq([

						1,0,0, 1,0,0,  0,0,0, 0,0,1,
						1,0,0, 1,0,0,  0,0,0, 0,0,0,
						1,0,0, 1,0,0,  0,0,0, 0,0,1,
						1,0,0, 1,0,0,  0,0,1, 0,0,0,

						1,0,0, 1,0,0,  0,0,0, 0,0,1,
						1,0,0, 1,0,0,  0,0,0, 0,0,0,
						1,0,0, 0,0,1,  0,0,0, 0,0,1,
						1,0,1, 1,0,0,  0,0,0, 0,0,0,

						1,0,0, 1,0,0,  0,0,0, 0,0,1,
						1,0,0, 1,0,0,  0,0,0, 0,0,0,
						1,0,0, 1,0,0,  0,0,1, 0,0,1,
						1,0,0, 1,0,1,  0,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.01,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // oscsmp bass
					\instrument, \playersec_osc,
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						2.2
					],inf).stutter(1),
					\trigfreq, 65,
					\pos, ~pmodsynth.({ 
						SinOsc.kr(1/20).range(0,0.01)+1.7 + Duty.kr(1/8/~t, 0, Dseq([
							0,Dwhite(0.1,0.4,1),0,0,
						],inf)) 
					}),
					\speed, 0.95,
					\legato, Pseq([
							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							6,0,0, 0,0,0, 0,0,0, 0,0,00.81,
							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							6,0,0, 0,0,0, 0,0,1, 0,0,00.8,

							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							6,0,0, 0,0,0, 0,0,0, 0,0,00.81,
							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							4,0,0, 0,1,0, 0,0,1, 0,0,00.81,

							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							6,0,0, 0,0,0, 0,0,0, 0,0,00.81,
							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							3,0,0, 3,0,0, 0,0,0, 0,0,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),

				Pmono(\oscsampler3,
					\finepos, Pseq([0,0,0.0004,0.01004],inf) + Pseq([0,0.1,0.20,0.25],inf).stutter(8),
					\fineposlag, 0.4,
					\pos, 1.2,
					\freq, 65 * Pseq([
						[0,9,8],
						[0,7,2],
					],inf).midiratio.stutter(4) * 4,
					\ffreq, ~pmodenv.(Pseq([100,3200,4000,10000],inf), 8),
					\bufnum, BufDef('voices/feynman.flac'),
					\ffreqtab, Pseq([[Array.geom(8,1.0,1.01).postln]],inf),
					\range, 0.0001,
					\posenv, Pseq([
						[ Env([0.00,0.014,0.0].integrate.postln,[0.42,8.4]) ],
					],inf),
					\amp, 0.1/2,
					\dur, 1,
				),
				Pbind( // hi snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/2,
				),
				Pbind( // low snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.13) ],
					],inf),
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 0,0,0,  0,0,1, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 1,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,1, 0,0,0,
					],inf).coin.not,
					//\lag, 0.120/~t,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/4,
				),
	].flat),
)).play;
);

(
	// short
~mymaster.();
~master.();
Pdef(\testox, Pdef(\oxtrans1,
	Ppar([
		1.collect {
			Pmono(  \droblip,
				\freq, exprand(100.0,14000),
				\dur, 1/3,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,1,0,
					0,0,0,
			
				],inf)*0.1/4,
			);
		},
		1.collect {
			Pmono(  \droblip,
				\freq, exprand(100.0,14000),
				\dur, 1/6,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					0,0,0, 0,0,0,
					1,0,1, 1,0,0,
			
				],inf)*0.1/4,
			);
		},
		1.collect {
			Pmono(  \droblipbass,
				\freq, 65,
				\dur, 1/12,
				//\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					1,1,1, 1,1,1,  0,0,0, 0,0,0,
				],inf)*0.1,
			);
		},

		Pmono(\concombre,
			\group, GroupDef(\fx, 1, \addAfter),
			\inbus, BusDef(\fx1, \audio),
			\sidebus, BusDef(\sendbus3, \audio),
			\cpt, 0.021,
			\cpabove, 0.1,
			\dur, 1,
			\amp, 0.1,
		),

				Pbind(
					\out, BusDef(\mixer2),
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,0, 1,0,0, 1,0,0, 1,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.05,0.1,0.8,0.02) ],
					],inf),
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.1,0.01,0.01

					],inf),
					\dur, 1/12,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0132,
				),
				Pbind(
					\out, BusDef(\mixer0),
					\instrument, \snapkick,
					\isRest, Pseq([

						1,0,0, 1,0,0,  1,0,0, 1,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
					],inf).coin.not,
					\sustain, 0.01,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // hi snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						1,0,0, 0,0,0,  0,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/2,
				),
				Pbind( // low snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.13) ],
					],inf),
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

					],inf).coin.not,
					//\lag, 0.120/~t,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/4,
				),
				Pbind(
					\instrument, Pseq([\playersec_zix2],inf).stutter(8*4),
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						2.2
					],inf).stutter(1),
					\isRest, Pseq([
						3,0,0,
					],inf).coin.not,
					\speed, 0.95,
					\legato, Pseq([
						Pser([
							0.4,0.1,0.1,
							0.2,0.1,0.1,
						],8*2)*2,
					],inf),
					\legato, Pseq([
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 1,0,0, 2,0,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind(
					\instrument, Pseq([\playersec_zix2],inf).stutter(8*4),
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						0.1
					],inf).stutter(1),
					\isRest, Pseq([
						3,0,0,
					],inf).coin.not,
					\speed, 1,
					\legato, Pseq([
						Pser([
							0.4,0.1,0.1,
							0.2,0.1,0.1,
						],8*2)*2,
					],inf),
					\legato, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,1, 0,0,1,

					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
	].flat),
)).play;
);

(
	// short2
~mymaster.();
~master.();
Pdef(\testox, Pdef(\oxtrans2,
	Ppar([
		1.collect {
			Pmono(  \droblip,
				\freq, exprand(100.0,14000),
				\dur, 1/3,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,1,0,
					0,0,0,
			
				],inf)*0.1/4,
			);
		},
		1.collect {
			Pmono(  \droblip,
				\freq, exprand(100.0,14000),
				\dur, 1/6,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					0,0,0, 0,0,0,
					1,0,1, 1,0,0,
			
				],inf)*0.1/4,
			);
		},
		1.collect {
			Pmono(  \droblipbass,
				\freq, 65,
				\dur, 1/12,
				//\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					1,1,1, 1,1,1,  0,0,0, 0,0,0,
				],inf)*0.1,
			);
		},

		Pmono(\concombre,
			\group, GroupDef(\fx, 1, \addAfter),
			\inbus, BusDef(\fx1, \audio),
			\sidebus, BusDef(\sendbus3, \audio),
			\cpt, 0.021,
			\cpabove, 0.1,
			\dur, 1,
			\amp, 0.1,
		),

				Pbind(
					\out, BusDef(\mixer2),
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,0, 1,0,0,  1,0,0, 1,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.05,0.1,0.8,0.02) ],
					],inf),
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.1,0.01,0.01

					],inf),
					\dur, 1/12,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0132,
				),
				Pbind(
					\out, BusDef(\mixer0),
					\instrument, \snapkick,
					\isRest, Pseq([
						1,0,0, 1,0,0, 0,0,0, 0,0,1,
						1,0,0, 0,0,1,  1,0,1, 1,0,0,

					],inf).coin.not,
					\sustain, 0.01,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // hi snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/2,
				),
				Pbind( // low snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.13) ],
					],inf),
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

					],inf).coin.not,
					//\lag, 0.120/~t,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/4,
				),
				Pbind(
					\instrument, Pseq([\playersec_zix2],inf).stutter(8*4),
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						2.2
					],inf).stutter(1),
					\isRest, Pseq([
						3,0,0,
					],inf).coin.not,
					\speed, 0.95,
					\legato, Pseq([
						Pser([
							0.4,0.1,0.1,
							0.2,0.1,0.1,
						],8*2)*2,
					],inf),
					\legato, Pseq([
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 1,0,0, 2,0,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind(
					\instrument, Pseq([\playersec_zix2],inf).stutter(8*4),
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						0.1
					],inf).stutter(1),
					\isRest, Pseq([
						3,0,0,
					],inf).coin.not,
					\speed, 1,
					\legato, Pseq([
						Pser([
							0.4,0.1,0.1,
							0.2,0.1,0.1,
						],8*2)*2,
					],inf),
					\legato, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,1, 0,0,1,

					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
	].flat),
)).play;
);

(
	// static endbar
~mymaster.();
~master.();
Pdef(\testox, Pdef(\oxstatic_endbar,

	Ppar([
		4.collect {
			Pmono(  \droblip,
				\freq, Pseq([
					exprand(100.0,14000),
					exprand(100.0,14000),
				],inf).stutter([2,4,6,8].choose).stutter(4),
				\dur, 1,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,
					1,
					0,
					0,
				],inf)*0.1/4,
			);
		},
		1.collect {
			Pmono(  \droblipbass,
				\freq, Pseq([
					exprand(60.0,80),
					exprand(60.0,80),
				],inf).stutter([2,4,6,8].choose).stutter(4),
				\dur, 2,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,0,
				],inf)*0.1,
			);
		},

		Pmono(\comp,
			\group, GroupDef(\fx, 1, \addAfter),
			\inbus, BusDef(\fx1, \audio),
			\sidebus, BusDef(\sendbus3, \audio),
			\cpt, 0.021,
			\cpabove, 0.1,
			\dur, 1,
			\amp, 0.1,
		),

				Pbind(
					\out, BusDef(\mixer2),
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,0, 1,0,1, 1,0,0, 1,0,0,
						1,0,0, 1,0,1, 1,0,0, 1,0,0,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.05,0.1,0.8,0.02) ],
					],inf),
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.1,0.01,0.01

					],inf),
					\dur, 1/12,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0132,
				),
				Pbind(
					\out, BusDef(\mixer0),
					\instrument, \snapkick,
					\isRest, Pseq([

						1,0,0, 0,0,0,  0,0,0, 0,0,0,
						1,0,0, 0,0,0,  0,0,0, 0,0,1,
						1,0,0, 0,0,1,  1,0,1, 1,0,0,
						1,0,0, 0,0,1,  0,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.01,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // hi snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/2,
				),
				Pbind( // low snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.13) ],
					],inf),
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 0,0,0,
					],inf).coin.not,
					//\lag, 0.120/~t,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/4,
				),
				Pbind(
					\instrument, Pseq([\playersec_zix2],inf).stutter(8*4),
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						2.2
					],inf).stutter(1),
					\isRest, Pseq([
						3,0,0,
					],inf).coin.not,
					\speed, 0.95,
					\legato, Pseq([
						Pser([
							0.4,0.1,0.1,
							0.2,0.1,0.1,
						],8*2)*2,
					],inf),
					\legato, Pseq([
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 4,0,0, 0,1,0,
							0,0,0, 0,0,2, 0,0,2, 0,1,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // oscsmp lead
					\instrument, \playersec_osczig_fat,
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						2.2
					],inf).stutter(1),
					\trigfreq, Pseq([
						 {
							(0..24).choose
						}.dup(7).sort.reverse.midiratio * 65*16,
						 {
							(0..24).choose
						}.dup(1).sort.reverse.midiratio * 65*16,
						 {
							(0..24).choose
						}.dup(7).sort.reverse.midiratio * 65*16,
						 {
							(0..24).choose
						}.dup(1).sort.reverse.midiratio * 65*16,
					].flatten,inf).stutter(12),
					\pos, ~pmodsynth.({ 
						SinOsc.kr(1/32).range(0,0.1)+0.3  +
						SinOsc.kr(2 * ( 1 + ( SinOsc.kr(1/82) * 4 ))).range(0,0.01) 
					}),
					\speed, 0.95,
					\legato, Pseq([
							0,0,0, 0,0,0,  0,0,0, 0,0,0,
							0,0,0, 0,0,0,  0,0,0, 0,0,0,
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							6,0,0, 0,0,0, 0,0,0, 3,0,0,
					],inf),
					\rq, 0.2,
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\lpmix, 1,
					\lpfr, 0.7,
					\gain, 0.2,
					\dur, 1/12,
					\amp, 0.1,
				),
	].flat),

)).play;
);

(
	// fast endbar
~mymaster.();
~master.();
Pdef(\testox, Pdef(\oxfast_endbar,

	Ppar([
		1.collect {
			Pmono(  \droblip,
				\freq, Pseq([9,0],inf).midiratio* 65*8,
				\dur, 1/4,
				\out, BusDef(\fx1, \audio),
				\amp, Pseq([
					1,0,1,1,
					1,0,1,1,
			
				].scramble,inf)*0.1/4,
			);
		},

		Pmono(\concombre,
			\group, GroupDef(\fx, 1, \addAfter),
			\inbus, BusDef(\fx1, \audio),
			\sidebus, BusDef(\sendbus3, \audio),
			\cpt, 0.021,
			\cpabove, 0.1,
			\dur, 1,
			\amp, 0.1,
		),

				Pbind(
					\out, BusDef(\mixer2),
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,0, 1,0,0, 1,0,0, 1,0,0,
						1,0,0, 1,0,0, 1,0,0, 1,0,0,
						0,0,0, 1,1,1,  0,0,0, 0,0,0,
						0,0,0, 1,1,1,  0,0,0, 0,0,0,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.05,0.1,0.8,0.02) ],
					],inf),
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.1,0.01,0.01

					],inf),
					\dur, 1/12,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0132,
				),
				Pbind(
					\out, BusDef(\mixer0),
					\instrument, \snapkick,
					\isRest, Pseq([

						1,0,0, 1,0,0,  0,0,0, 0,0,1,
						1,0,0, 1,0,0,  0,0,0, 0,0,0,
						1,0,0, 1,1,0,  0,0,0, 1,0,1,
						1,0,1, 1,0,1,  1,0,0, 1,0,1,
					],inf).coin.not,
					\sustain, 0.01,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // hi snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/2,
				),
				Pbind( // low snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.13) ],
					],inf),
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 0,0,0,  0,0,1, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 1,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,1, 0,0,0,
					],inf).coin.not,
					//\lag, 0.120/~t,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/4,
				),
				Pbind( // oscsmp bass
					\instrument, \playersec_osc,
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						2.2
					],inf).stutter(1),
					\trigfreq, 65,
					\pos, ~pmodsynth.({ 
						SinOsc.kr(1/20).range(0,0.01)+1.7 + Duty.kr(1/8/~t, 0, Dseq([
							0,Dwhite(0.1,0.4,1),0,0,
						],inf)) 
					}),
					\speed, 0.95,
					\legato, Pseq([
							6,0,0, 0,0,0, 0,0,0, 0,0,00,
							6,0,0, 0,0,0, 0,0,0, 0,0,00.81,
							1,0,0, 0,0,0, 1,0,0, 0,0,00,
							0,0,0, 0,0,0, 1,0,0, 3,0,00,

					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // oscsmp lead
					\instrument, \playersec_osczig_fat,
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						2.2
					],inf).stutter(1),
					\trigfreq, Pseq([
						 {
							(0..24).choose
						}.dup(7).sort.reverse.midiratio * 65*16,
						 {
							(0..24).choose
						}.dup(1).sort.reverse.midiratio * 65*16,
						 {
							(0..24).choose
						}.dup(7).sort.reverse.midiratio * 65*16,
						 {
							(0..24).choose
						}.dup(1).sort.reverse.midiratio * 65*16,
					].flatten,inf).stutter(12),
					\pos, ~pmodsynth.({ 
						SinOsc.kr(1/32).range(0,0.1)+0.3  +
						SinOsc.kr(2 * ( 1 + ( SinOsc.kr(1/82) * 4 ))).range(0,0.01) 
					}),
					\speed, 0.95,
					\legato, Pseq([
							9,0,0, 0,0,0, 0,0,0, 0,0,0,
							6,0,0, 0,0,0, 0,0,0, 3,0,0,
							9,0,0, 0,0,0, 0,0,0, 0,0,0,
							2,0,0, 0,0,0, 1,1,0, 2,0,0,
					],inf),
					\rq, 0.2,
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\lpmix, 1,
					\lpfr, 0.7,
					\gain, 0.2,
					\dur, 1/12,
					\amp, 0.1,
				),
	].flat),

)).play;
);

//////////////// MAIN

Ndef(\rdn2).end
(
~mymaster.();
~master.();
GroupDef(\fx, 1, \addAfter);
Pdef(\testox, Pdef(\main, 
	Pseq([
		Pfindur(12,
			Pdef(\oxstatic),
		),
		Pfindur(4,
			Pdef(\oxstatic_endbar),
		),
		Pfindur(12,
			Pdef(\oxfast),
		),
		Pfindur(4,
			Pdef(\oxfast_endbar),
		),
		Pfindur(12,
			Pdef(\oxwave),
		),
		Pfindur(4,
			Pdef(\oxstatic_endbar),
		),
		Pfindur(12,
			Pdef(\oxfast2),
		),
		Pfindur(4,
			Pdef(\oxfast_endbar),
		),
		Pfindur(12,
			Pdef(\oxendwave),
		),
		Pfindur(4,
			Pdef(\oxtrans2),
		),
		
	])
)).play;
)
