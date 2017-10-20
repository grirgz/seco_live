(
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
~mymaster = {
	ProtoDef(\simpleMixer).play;
};
)

(
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
ProtoDef(\simpleMixer).play;
Pdef(\testox, 
	Ppar([
		8.collect {
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
).play;
);

ProtoDef(\simpleMixer).edit
ProtoDef(\rdn2).edit

(
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
~mymaster.();
~master.();
Pdef(\testox, 
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
).play;
)
