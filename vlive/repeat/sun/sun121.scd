// try again rdn drums

~t = 175/4/60; TempoClock.default.tempo = ~t;


// put hpf to 130 to avoid muddy bass

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1503].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,4,
			],inf).stutter(8),
			\octave, 3,
			\lpf, 13000,
			\legato, 0.9,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(\lag, 0.04) <>
		Ppar([
			
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1073].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[788].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[741].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
					0,0,1,1, 0,1,0,1,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11/2,
			),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,1,
				],inf),
				\octave, 5,
				\lpf, PmodEnv(Pseq([100,8000],1), 8,\exp).loop,
				\dur, 1/8,
				\amp, 0.1/4,
				\isRest, true,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef.stereo('vbreaks/Bernard Purdie - Funky Donkey (part3).wav'),
				\legato, 1,
				\st, 177/4/60,
				\speed, 1 * ~t / Pkey(\st),
				\pos, Pseg(Pseq([
					0, 4,
				]+0,1),4).loop / Pkey(\st),
				\dur, 1/8,
				\gain, 1/8,
				\out, BusDef(\drumfx, \audio),
			),
			Pmono(\fx_hpf,
				\inbus, BusDef(\drumfx, \audio),
				\addAction, \addToTail,
				\hpf, 800,
				\lag, 0.0009,
				\dur, 1,
			),
		]),
		
	])
)).play;
);

~protordn_to_fbstring.(ProtoDef(\rdn)).editorInsert
(

SynthDef(\rdn_distkick, { arg out=0, gate=1;
	// code: 5-IOUA-FR77
	var si, env = ();
	var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
	var code, rdnkey;

	var sig;
	var sigin;
	var del, shi;
	var del2, shi2;
	var distamp;
	var hasFreq, afreq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var pitchlag;
	var pitchmix;
	var fb, fb1, fb2;
	var gain;
	var mix;
	var indelay;
	//"default_make_graph".debug("!!!");
	rdnkey = rdnkey ? \default;
	code = code ? "4--";
	sig = in;
	mix = \mix.kr(0.5);
	gain = \gain.kr(1);
	fb = \fb.kr(0.001);
	del = \delay.kr(0.001,0.1);
	del2 = \delay2.kr(0.001,0.1);
	shi = \shift.kr(0);
	shi2 = \shift2.kr(0);
	distamp = \distamp.kr(1);
	pitchlag = \pitchlag.kr(1/8) / TempoClock.default.tempo;
	pitchmix = \pitchmix.kr(0);

	sig = LPF.ar(sig, \prelpf.kr(17000));
	sig = HPF.ar(sig, \prehpf.kr(17));

	sig = sig + (LocalIn.ar(2) * fb);

	sig = LPF.ar(sig, \lpf.kr(17000));
	sig = HPF.ar(sig, \hpf.kr(17));
	thisThread.randSeed = 519399.0;
	si = sig;
	sig = { arg si, env;
		si = [
			{ arg si, env;
				si = (si * 10.rand * \distamp.kr).tanh / 2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
				si = [
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					}.value(si, env);

				].mean;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
				si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
				si = [
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					}.value(si, env);

				].mean;
			}.value(si, env);
			,
			{ arg si, env;
				si = (si * 10.rand * \distamp.kr).tanh / 2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = (si * 10.rand * \distamp.kr).tanh / 2;
				si = (si * 10.rand * \distamp.kr).tanh / 2;
			}.value(si, env);

		].mean;
	}.value(si, env);


	sig1 = sig.tanh * \fbdistamp.kr(1/2);
	sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

	sig = Limiter.ar(sig);

	sig1 = sig;
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	sig = SelectX.ar(pitchmix, [sig, sig1]);

	LocalOut.ar(sig);
	sig = LPF.ar(sig, \postlpf.kr(17000));
	sig = HPF.ar(sig, \posthpf.kr(17));
	sig = Limiter.ar(sig);
	sig = sig * \wetamp.kr(1);

	indelay = \indelay.kr(0);
	sigin = DelayL.ar(in, 0.2, indelay);
	sig = SelectX.ar(mix, [sigin, sig]);
	sig = sig * gain;
	//sig.debug("end sig");
	sig;


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0,1,0.001)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;


Pbind(
	'wet10', 1.0,
	'mix', 0.7436974789916,
	'gain', 0.40336134453782,
	'fb', 0.0008851654753784,
	'delay', 0.36561601440852,
	'delay2', 0.00035860954820118,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 6.7256008986351,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
)


);


(
Ndef(\rdn)[10000] = \pset -> 

Pbind(
	'wet10', 1.0,
	'mix', 0.7436974789916,
	'gain', 0.40336134453782,
	'fb', 0.0008851654753784,
	'delay', 0.36561601440852,
	'delay2', 0.00035860954820118,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 6.7256008986351,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1)
)



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1503].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,-4,-5,-6,

			],inf).stutter(8),
			\octave, 3,
			\envamt, 10,
			\lpf, 130,
			\legato, 0.9,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(\lag, 0.04) <>
		Ppar([
			
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1073].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[788].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[741].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
					0,0,1,1, 0,1,0,1,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11/2,
			),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					Pser([
						8,7,
					],8),
					Pser([
						2,
					],8),
					Pser([
						8,7,
					],8),
					Pser([
						1,
					],8),
				],inf),
				\octave, 5,
				\lpf, PmodEnv(Pseq([100,8000],1), 8,\exp).loop,
				\dur, 1/8,
				\amp, 0.1/4,
				//\out, BusDef(\sendbus2, \audio),
				\out, BusDef(\melfx, \audio),
			),
			Pmono(\fx_freeverb2,
				\inbus, BusDef(\melfx, \audio),
				\addAction, \addToTail,
				\lag, 0.0009,
				\dur, 1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef.stereo('vbreaks/Bernard Purdie - Funky Donkey (part3).wav'),
				\legato, 1,
				\st, 177/4/60,
				\speed, 1 * ~t / Pkey(\st),
				\pos, Pseg(Pseq([
					0, 4,
				]+0,1),4).loop / Pkey(\st),
				\dur, 1/8,
				\legato, 0.8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 1/8,
				\out, BusDef(\drumfx, \audio),
			),
			Pmono(\fx_lpfhpf,
				\inbus, BusDef(\drumfx, \audio),
				\addAction, \addToTail,
				\hpf, 2000,
				\lpf, 7000,
				\lag, 0.0009,
				\dur, 1,
			),
		]),
		
	])
)).play;
);
