~t = 300/4/60; TempoClock.default.tempo = ~t;



(
Pdef(\part, Pdef(\dreadbass, 
	Ppar([
		Pmono(
			 \simplegran_adsrcomp,
			\mbufnum, BufDef.mono('samplekit/vipere/camelcactus.flac'),
			\note, Pseq([
				0,0,1,-1,
			],inf),
			\octave, 3,
			\pitch_stretch, ~pmodenv.(Pseq([1,2,1,4],1), 7).loop,
			\pos, ~pmodenv.(Pseq([1,2,1,4]/10+91,1), 9).loop,
			\gdur, ~pmodenv.(Pseq([0.01,0.4],1), 8).loop,
			\pan, 0.0,
			\gfreq, Pkey(\freq),
			\resfr, Pseq([1,2,3,4],inf),
			\resfr, 2,
			\bwr, 0.3000001907349,
			\resmix, 1.0,
			\lpfr, 6.1000000238419,
			\rq, 0.5,
			\lpmix, 1.0,
			\cpt, 0.10000000149012,
			\cpbelow, 1.00100004673,
			\cpabove, 0.0009999996125698,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\dur, 1,
			\pregain, 40,
			\gain, 1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\nappypool1,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <>
		Pbind(
			'wet10', 1.0,
			'mix', 0.0436974789916,
			'gain', 3.69865546218487,
			'fb', 0.0001,
			'delay2', 0.1001,
			'delay', ~pmodenv.(Pseq([0.1000001,0.02],inf), 8).loop,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 137.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 20000.0,
			'posthpf', 17,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\dreadbass, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0.4,0, 0.3,0,0.3,0,
				0,0,0.5,0.5, 0,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.15 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.15 * Pkey(\score),
		),
		Pmono(
			 \simplegran_adsrcomp,
			\mbufnum, BufDef.mono('samplekit/vipere/camelcactus.flac'),
			\mbufnum, BufDef.mono('vbreaks/Igor Bril - Street Without End.wav'),
			\note, Pseq([
				0,0,1,-1,
			],inf),
			\octave, 3,
			\pitch_stretch, ~pmodenv.(Pseq([1,1,1/2,1/2,1/4],1), 2).loop,
			\pos, Pseq([
				~pmodenv.(Pseq([1,2,1,4]/80+1,1), 8).loop,
			],inf),
			\gdur, ~pmodenv.(Pseq([0.101,0.10],1), 8).loop,
			\pan, 0.0,
			\gfreq, Pkey(\freq),
			//\resfr, Pseq([1,2,3,4],inf),
			\resfr, 2,
			\bwr, 1.3000001907349,
			\resmix, 0.91,
			\lpfr, 2.1000000238419,
			\rq, 0.9,
			\lpmix, 0.940,
			\cpt, 0.10000000149012,
			\cpbelow, 1.00100004673,
			\cpabove, 0.0009999996125698,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\dur, 1,
			\pregain, 400,
			\gain, 1/2,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
			\out, BusDef(\ifx1, \audio),
		),

		Pmono(\rdn_grezbass,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <>

		Pbind(
			'wet10', 1.0,
			'mix', 0.18571428571429,
			'gain', 1.0,
			'fb', 0.0000034014403432308,
			'delay', 0.00000838551534282,
			'delay2', Pseq([
				~pmodenv.(Pseq([0.081,0.182]*0.000001,1), 8),
				~pmodenv.(Pseq([0.081,0.182]*0.0001,1), 8),
				~pmodenv.(Pseq([0.081,0.182]*1.01,1), 8),
			],inf),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 8.403186090713,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.44721359549996,
			'fbdistmix', 0.96638655462185,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.15072520464925,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('loop/pigs.flac'),
			//\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			//\st, 272/8/60,
				\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
				\st, 272/1/60,
				\gain, 0.1,
			\speed, 2.5/Pstep(Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0.7,1.2,1.2, 1,1,1,1,
			],inf),1/4) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseq([
					Pseg(Pseq([
						0, 4,
					],1),1),
				],7),
					Pseg(Pseq([
						0, 4,
					],1),1)+4,
			],inf) / Pkey(\st),
			\dur, PdurStutter(Pseq([1,2,2,8, 4,1,8,1, ],inf), 1/2),
			\gain, 0.1* Pstep(Pseq([
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
			],inf),1/8),
			//\legato, Pseq([1,0.5,0.7,1],inf),
			//\dur, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('loop/pigs.flac'),
			//\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			//\st, 272/8/60,
				\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
				\st, 272/1/60,
				\gain, 0.1,
			\speed, 4/Pseq([1,1.4,1,1,1,1,0.7],inf) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseq([
					Pseg(Pseq([
						0, 8,
					],1),4)+8,
				],8),
			],inf) / Pkey(\st),
			\dur, PdurStutter(Pseq([1,1,1,1, 1,1,1,4, 4,4,4,4, 2,2,1,1],inf), 1),
			\gain, 0.1* Pstep(Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf),1/8),
			//\legato, Pseq([1,0.5,0.7,1],inf),
			//\dur, 1/8,
		),
	Pbind(
		\instrument, \oscsampler3,
		\pos, 1.208,
		\pos, 1.808,
		\freq, 187,
		\range, 0.0000001,
		\posenv, Pseq([
			[ Env([0.00,0.01001,0].integrate.postln,[0.41,8.1]) ],
		],inf),
		\finepos, 1/400 * Pseq([1,4,2,2],inf),
		\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
		   	0,0,1,0, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
		   	0,0,1,0, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
		   	0,0,1,0, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
		   	0,0,1,0, 0,0,1,1,
			4,0,0,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

			4,0,0,0, 1,0,0,1,
		   	0,0,2,0, 1,0,1,1,
			4,0,0,0, 1,0,0,0,
		   	0,0,1,0, 0,0,1,1,
		],inf),
		\levelScale, Pseq([
			1,1,1,1, 1,2,0.73,1/2,
			1,1,1,1, 1,2,0.73,1/2,
			1,1,1,1, 1,2,0.73,1/2,
			1,1,1,1, 1,2,0.73,1/2,

			1,1,1,1, 1,1,1,0.9,
			1,1,1,1, 1,1.2,1,0.8,
			1,1,1,1, 1,2,0.73,1/2,
			1,1,1,1, 1,2,0.73,1/2,

			1,1,1,1, 1,1,1,1/2,
			1,1,1,1, 1,2,0.73,1/2,
		],inf).stutter(2),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\dur, 1/8,
		\fshift, 40,
		\lpmix, 1,
		\rq, 0.4,
		\hpmix, 0,
		\hpfreq, 100,
		\ffreq, Pseq([
			1020,5240,450,700,
		],inf) * Pseq([1,2,1/2],inf).stutter(4) * Pseg(Pseq([0,1],inf),8),
		\ffreq, ~pmodenv.(Pseq([10,5200],1), 8, 1, 3).loop,
		\amp, 0.1/3,
			\bufnum, BufDef.stereo('voices/feynman.flac'),

	) 
		
	])
)).play;
);

(
Pdef(\part, Pdef(\dreadbass, 
	Ppar([
		Pbind(
			\instrument, \simplegran_adsrcomp,
			\mbufnum, BufDef.mono('samplekit/vipere/camelcactus.flac'),
			\note, Pseq([
				0,0,1,-1,
			],inf),
			\octave, 3,
			//\pitch_stretch, ~pmodenv.(Pseq([1,2,1,4],1), 7).loop,
			\pos, ~pmodenv.(Pseq([1,2,1,4]/80+57,1), 2).loop,
			//\gdur, ~pmodenv.(Pseq([0.01,0.04,0.02],1), 8).loop,
			\pan, 0.0,
			\gfreq, Pkey(\freq),
			//\resfr, Pseq([1,2,3,4],inf),
			\resfr, 2,
			\bwr, 0.3000001907349,
			\resmix, 1.0,
			\lpfr, 6.1000000238419,
			\rq, 0.5,
			\lpmix, 1.0,
			\cpt, 0.10000000149012,
			\cpbelow, 1.00100004673,
			\cpabove, 0.0009999996125698,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.21) ],
			],inf),
			\dur, 1,
			\pregain, 180,
			\legato, 0.1,
			//\gain, Ndef(\bass_gain_lfo, { EnvGen.kr(Env([0,1,0],[0.01,0.38]), Impulse.kr(2*~t)); }).asMap,
			//\out, BusDef(\ifx1, \audio),
		),
		
	])
)).play;
);


~protordn_to_fbstring.(ProtoDef(\rdn)).editorInsert
(

		SynthDef(\rdn_grezbass, { arg out=0, gate=1;
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
		thisThread.randSeed = 651677.0;
si = sig;
sig = { arg si, env;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
si = (si * 10.rand * \distamp.kr).tanh / 2;
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
si = (si * 10.rand * \distamp.kr).tanh / 2;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
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
	'mix', 0.28571428571429,
	'gain', 1.0,
	'fb', 0.00034014403432308,
	'delay', 0.33838551534282,
	'delay2', 0.0096204032710648,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 48.403186090713,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.44721359549996,
	'fbdistmix', 0.96638655462185,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.15072520464925,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
)

		
);

////////////////////


(
Pdef(\part, Pdef(\alienrise, 
	Ppar([

		Pseq([
			Pbind(
				\instrument, \oscsampler3,
				\pos, 0.012,
				//\fshift, -148,
				\lpmix, 0.41,
				\hpmix, 0.0,
				\hpfreq, 10,
				\rq, 0.1,
				\posenv, Pseq([
					[ Env([0.004,0.0019,0.1071].integrate.postln,[0.42,8.4]) ],
				],inf),
				\posenv, Pseq([
					[ Env([0.000,0.0002,0.0021].integrate.postln,[0.12,8.4]) ],
				],inf),
				\pos, 0.1 * [1,2,3,4,5,10,20],
				\levelScale, 8*2,
				\timeScale, 2,
				\range, 0.0007,
				\range, ~pmodenv.(Pseq([1,2,1,4]*0.00003,1), 2).loop,
				\ffreq, ~pmodenv.(Pseq([100,14000],1), 8).loop,
				\note, Pseq([
					0,
				],inf).stutter(8),
				\octave, 3,
				\bufnum, BufDef.stereo('voices/feynman.flac'),
				\ffreqtab, Pseq([[Array.geom(8,2.1,0.8).postln]],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.3,0.5,0.21) ],
				],inf),
				\legato, 8.0,
				\dur, 1,
				\isRest, Pseq([
					1,0,0,0,
					0,0,0,0,
				],1).coin.not,
				\amp, 0.41 * Pkey(\amp),
				\amp, ~pmodenv.(Pseq([0.001,1]*0.041,1), 8).loop,
			),
		],1),
		
	])
)).play;
);
(
Pdef(\part, Pdef(\alienrise2, 
	Ppar([

		Pseq([
			Pbind(
				\instrument, \oscsampler3,
				\pos, 0.012,
				//\fshift, -148,
				\lpmix, 0.41,
				\hpmix, 0.0,
				\hpfreq, 10,
				\rq, 0.1,
				\posenv, Pseq([
					[ Env([0.004,0.0019,0.1071].integrate.postln,[0.42,8.4]) ],
				],inf),
				\posenv, Pseq([
					[ Env([0.000,0.0002,0.0021].integrate.postln,[0.12,8.4]) ],
				],inf),
				\pos, 0.1 * [1,2,3,4,5,10,20],
				\levelScale, 8*2,
				\timeScale, 2,
				\range, 0.0007,
				\range, ~pmodenv.(Pseq([1,2,1,4]*0.00003,1), 2).loop,
				\ffreq, ~pmodenv.(Pseq([100,14000],1), 8).loop,
				\note, Pseq([
					0,
				],inf).stutter(8),
				\octave, 3,
				\bufnum, BufDef.stereo('voices/feynman.flac'),
				\bufnum, BufDef.stereo('vbreaks/Augusto Alguero - Ballet Del Arbitro Bueno.wav'),
				\ffreqtab, Pseq([[Array.geom(8,2.1,0.8).postln]],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.3,0.5,0.21) ],
				],inf),
				\legato, 8.0,
				\dur, 1,
				\isRest, Pseq([
					1,0,0,0,
					0,0,0,0,
				],1).coin.not,
				\amp, 0.41 * Pkey(\amp),
				\amp, ~pmodenv.(Pseq([0.001,1]*0.041,1), 8).loop,
			),
			Pbind(
				\instrument, \oscsampler3,
				\pos, 0.012,
				//\fshift, -148,
				\lpmix, 0.41,
				\hpmix, 0.0,
				\hpfreq, 10,
				\rq, 0.1,
				\posenv, Pseq([
					[ Env([0.004,0.0019,0.1071].integrate.postln,[0.42,8.4]) ],
				],inf),
				\posenv, Pseq([
					[ Env([0.000,0.0002,0.0021].integrate.postln,[0.12,8.4]) ],
				],inf),
				\pos, 0.1 * [1,2,3,4,5,10,20],
				\levelScale, 8*2,
				\timeScale, 2,
				\range, 0.0007,
				\range, ~pmodenv.(Pseq([1,2,1,4]*0.00003,1), 2).loop,
				\ffreq, ~pmodenv.(Pseq([100,14000],1), 8).loop,
				\note, Pseq([
					0,
				],inf).stutter(8),
				\octave, 3,
				\bufnum, BufDef.stereo('voices/feynman.flac'),
				\ffreqtab, Pseq([[Array.geom(8,2.1,0.8).postln]],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.3,0.5,0.21) ],
				],inf),
				\legato, 8.0,
				\dur, 1,
				\isRest, Pseq([
					1,0,0,0,
					0,0,0,0,
				],1).coin.not,
				\amp, 0.41 * Pkey(\amp),
				\amp, ~pmodenv.(Pseq([0.001,1]*0.041,1), 8).loop,
			),
		],1),
		
	])
)).play;
);




(
Pdef(\part, Pdef(\cookdrums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vbreaks/Funk Brothers - Home Cookin.wav'),
			\legato, 1,
			\st, 110/2/60,
			\speed, 1/Pstep(Pseq([
				1,0.9,2,1, 1,1,2,1.2,
				2,1.9,2,1, 1,1,1/2,1.2,
				1,0.9,2,1, 1,1,1.2,1.2,
				2,1.9,2,1, 1,1,1.2,1.2,

				1,1,1,1.2, 1,1,1,1,
				2,1.52,1,1, 2,1,1,1,
				1,1,1,1, 0.8,1,1,1,
				1,2,1,1, 1,1,1,1,
			],inf),1/8) * ~t / Pkey(\st),
			\pos, Pseq([

				Pseg(Pseq([
					0, 2,
				],1),2),
				Pseg(Pseq([
					0, 2,
				],1),2)+4,
				Pseg(Pseq([
					0, 2,
				],1),2)+6,
				Pseg(Pseq([
					2, 0,
				],1),2)+4,

				Pseg(Pseq([
					0, 2,
				],1),2),
				Pseg(Pseq([
					0, 2,
				],1),2)+4,
				Pseg(Pseq([
					0, 8,
				],1),4)+1,
				//Pseg(Pseq([
					//1, 4,
				//],1),2),
			],inf) / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, PdurStutter(Pseq([
				Pseq([
					1,1,6,1, 2,1,7,1,
				],4),
				Pseq([
					8,1,4,1, 1,4,2,4,
				],4),
			],inf), 1),
			\isRest, Pstep(Pseq([
				1,1,1,1, 1,0.3,0.3,0.3,
				1,1,1,0.41, 1,1,1,1,
			],inf),1/8).coin.not,
			\gain, 1/8,
		)
	])
)).play;
);

(
Pdef(\part, Pdef(\cookdrums1wet, 
	Ppar([
		Pmono(\fx_fatecho,
			\inbus, BusDef(\ifx2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, Pseq([1,1,0],inf),
			\mix, 0.8,
			\delaymax, 0.04,
			\lfoamp , 0.01,
			\lfofreq, 0.3,
			\shiftmax, 40,
			\fb, 0.7,
			\fbdelay, Pseq([1,2,3,4,1/5,1/10,1/2,1/3],inf)/4/~t,
			\fbdelay, 1/Pseq([1,2,3,4,8],inf)/~t,
			//\fbdelay, Pseq([1,1/4],inf)/4/~t,
			\gain, 1.5,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vbreaks/Funk Brothers - Home Cookin.wav'),
			\legato, 1,
			\st, 110/2/60,
			\speed, 1/Pstep(Pseq([
				1,0.9,2,1, 1,1,2,1.2,
				2,1.9,2,1, 1,1,1/2,1.2,
				1,0.9,2,1, 1,1,1.2,1.2,
				2,1.9,2,1, 1,1,1.2,1.2,

				1,1,1,1.2, 1,1,1,1,
				2,1.52,1,1, 2,1,1,1,
				1,1,1,1, 0.8,1,1,1,
				1,2,1,1, 1,1,1,1,
			],inf),1/8) * ~t / Pkey(\st),
			\pos, Pseq([

				Pseg(Pseq([
					0, 2,
				],1),2),
				Pseg(Pseq([
					0, 2,
				],1),2)+4,
				Pseg(Pseq([
					0, 2,
				],1),2)+6,
				Pseg(Pseq([
					2, 0,
				],1),2)+4,

				Pseg(Pseq([
					0, 2,
				],1),2),
				Pseg(Pseq([
					0, 2,
				],1),2)+4,
				Pseg(Pseq([
					0, 8,
				],1),4)+1,
				//Pseg(Pseq([
					//1, 4,
				//],1),2),
			],inf) / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, PdurStutter(Pseq([
				Pseq([
					1,1,6,1, 2,1,7,1,
				],4),
				Pseq([
					8,1,4,1, 1,4,2,4,
				],4),
			],inf), 1),
			\isRest, Pstep(Pseq([
				1,0,0,0, 1,0.3,0.3,0.3,
			],inf),1/4).coin.not,
			\gain, 1/8,
			\out, BusDef(\ifx2, \audio),
		)
	])
)).play;
);

(
Pdef(\part, Pdef(\cookdrums2, 
	Ppar([
		Pmono(\fx_fatecho,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0.8,
			\mix, Pseq([

					0,0,1,1, 0,1,1,0,
				Pseq([
					1,0,1,1, 0,1,1,0,
				],6),
				0,0,0,0, 0,0,0,0,
			],inf),
			\delaymax, 0.04,
			\lfoamp , 0.01,
			\lfofreq, 0.3,
			\shiftmax, 40,
			\fb, 0.7,
			\fbdelay, Pseq([1,2,3,4,1/5,1/10,1/2,1/3],inf)/4/~t,
			\fbdelay, 1/Pstep(Pseq([1,2,3,4,8],inf),2)/~t,
			//\fbdelay, Pseq([1,1/4],inf)/4/~t,
			\gain, 1.5,
			\dur, 1/2,
		),
		Pbind(
			\lag, -0.01,
			\out, BusDef(\ifx1, \audio)
		) <>
		Ppar([
			
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[879].value,
				\score, Pseq([
					1,0,0.4,0, 0.3,0,0.3,0,
					0,0,0.5,0.5, 0,0,0,0,
				],inf),
				\isRest, Pkey(\score).coin.not,
				\dur, 1/8,
				\gain, 0.15 * Pkey(\score),
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[771].value,
				\score, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf),
				\isRest, Pkey(\score).coin.not,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.15 * Pkey(\score),
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[771].value,
				\score, Pseq([
					1,0,0,0, 0,0,0,1,
					0,1,0,0, 0,0,0,1,
				],inf),
				\isRest, Pkey(\score).coin.not,
				\sustain, 0.1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.05) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11/2 * Pkey(\score),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1090].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\score, Pseq([
					0.2,0,1,0, 0.2,0.2,1,0.2,
					0.2,0,0.2,0.1, 0.2,0,1,0.2,
				],inf),
				\isRest, Pkey(\score).coin.not,
				\dur, 1/8,
				\gain, 0.11 * (Pkey(\score) * 4).clip(0,1),
			),
		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vbreaks/Funk Brothers - Home Cookin.wav'),
			\legato, 1,
			\st, 110/2/60,
			\speed, 1/Pstep(Pseq([
				1,0.9,2,1, 1,1,2,1.2,
				2,1.9,2,1, 1,1,1/2,1.2,
				1,0.9,2,1, 1,1,1.2,1.2,
				2,1.9,2,1, 1,1,1.2,1.2,

				1,1,1,1.2, 1,1,1,1,
				2,1.52,1,1, 2,1,1,1,
				1,1,1,1, 0.8,1,1,1,
				1,2,1,1, 1,1,1,1,
			],inf),1/8) * ~t / Pkey(\st),
			\pos, Pseq([

				Pseg(Pseq([
					0, 2,
				],1),2),
				Pseg(Pseq([
					0, 2,
				],1),2)+4,
				Pseg(Pseq([
					0, 2,
				],1),2)+6,
				Pseg(Pseq([
					2, 0,
				],1),2)+4,

				Pseg(Pseq([
					0, 2,
				],1),2),
				Pseg(Pseq([
					0, 2,
				],1),2)+4,
				Pseg(Pseq([
					0, 8,
				],1),4)+1,
				//Pseg(Pseq([
				//1, 4,
				//],1),2),
			],inf) / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, PdurStutter(Pseq([
				Pser([
					4,4,4,8, 2,8,1,8,
				],inf),
				Pseq([
					1,1,6,1, 2,1,7,1,
				],4),
				Pseq([
					8,1,4,1, 1,4,2,4,
				],4),
			],inf), 1),
			\isRest, Pstep(Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0.81,0.51,0.51,
				],8),
				Pseq([
					1,0,0,0, 0,0.81,0.51,0.51,
					1,0.81,0.51,0.51, 1,0.81,0.51,0.51,
				],8),
				0,0,0,0, 0,0.81,0.51,0.51,
				1,0,0,0, 0,0.81,0.51,0.51,
				0,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0.3,0.3,0.3,
			],inf),1/8).coin.not,
			\gain, 1/13,
		)
	])
)).play;
);


(
// dreadseq1
Pdef(\part, Pdef(\dreadseq1, 
	Ppar([
		
		Pseq([
			Pseq([
				Ppar([
					Pfindur(15,Pdef(\dreadbassrise)),
					Pfindur(16,Pbind(
						\instrument, \oscsampler3,
						\pos, 1.208,
						\pos, 1.808,
						\freq, 187,
						\range, 0.0000001,
						\posenv, Pseq([
							[ Env([0.00,0.01001,0].integrate.postln,[0.41,8.1]) ],
						],inf),
						\finepos, 1/400 * Pseq([1,4,2,2],inf),
						\legato, Pseq([
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,1,0, 0,0,1,1,
						],inf),
						\levelScale, Pseq([
							1,1,1,1, 1,2,0.73,1/2,
						],inf).stutter(2),
						\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
						\dur, 1/8,
						\fshift, 40,
						\lpmix, 1,
						\rq, 0.4,
						\hpmix, 0,
						\hpfreq, 100,
						\ffreq, Pseq([
							1020,5240,450,700,
						],inf) * Pseq([1,2,1/2],inf).stutter(4) * Pseg(Pseq([0,1],inf),8),
						\ffreq, ~pmodenv.(Pseq([10,5200],1), 8, 1, 3).loop,
						\amp, 0.1/3,
						\bufnum, BufDef.stereo('voices/feynman.flac'),

					)) 
				]),
				Pfindur(16,Pdef(\dreadbassdrum5)),
				Pfindur(16,Pdef(\dreadbassdrum1)),
			],1),
			Pfindur(32, Pdef(\dreadbassdrum6)),
			Ppar([
				Pfindur(32,Pdef(\dreadbass3)),
				Pfindur(32,Pseq([
					Pfindur(4,Pmono(\simplegran,
						\mbufnum, BufDef.mono('loop/loop3b_185bpm.flac'),
						\mbufnum, BufDef.mono('voices/kaspi.flac'),
						\mbufnum, BufDef.mono('voices/feynman.flac'),
						\pos, Pseq([
							~pmodenv.(Pseq([1,2],1), 8*8),
						],inf),
						\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
						\gdur, ~pmodenv.(Pseq([0.1,0.02],inf), 4),
						\pitch_stretch, ~pmodenv.(Pseq([2,0.2,0.1],1), 1),
						\dur, 1/4,
						\amp, 0.1 * Pseg(Pseq([1,0],inf),8),
					)),
					Pfindur(6,Pbind(\type,\rest)),
				],inf)),
				Pfindur(28, Pdef(\cookdrums2)),
			]),
			Pfindur(32,Pdef(\dreadbassdrum7)),
			Pfindur(32,Pdef(\dreaddrumdist1)),
			Pfindur(32, Pdef(\dreadbassdrum6)),
		],1),
	])
)).play;
);

(
Pdef(\part, Pdef(\dreadbassdrum2, 
	Ptpar([
		8, Pfindur(32-8,Pdef(\dreadbass2)),
		0, Pfindur(4,Pdef(\alienrise)),
		0, Pfindur(28, Pdef(\cookdrums1wet)),
		24, Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\pos, Pseq([
				4,8,10,12,
			],inf)+ Pseg(Pseq([0,1],1),8),
			\dur, 1/16,
			\gain, 1/8 * Pstep(Pseq([1,1,1,1, 1,1,1,0],inf),1),
		),
		31, Pfindur(1/2, Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\pos, 12,
			\dur, 1/16,
			\gain, 1,
		)),
	]),
)).play;
);

(
Pdef(\part, Pdef(\dreadbassdrum6, 
	Ptpar([
		8, Pfindur(32-8,Pdef(\dreadbass2)),
		0, Pfindur(4,Pdef(\alienrise)),
		0, Pfindur(28, Pdef(\cookdrums1wet)),
		24, Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\pos, Pseq([
				4,8,10,12,
			],inf)+ Pseg(Pseq([0,1],1),8),
			\dur, 1/16,
			\gain, 1/8 * Pstep(Pseq([1,1,1,1, 1,1,1,0],inf),1),
		),
		31, Pfindur(1/2, Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\pos, 12,
			\dur, 1/16,
			\gain, 1,
		)),
		12, PmonoArtic(
			 \nappy,
			\note, Pseq([
				0,
				0,
				1,
				-1,
			],inf)+4,
			\octave,6,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
			\lpf, ~pmodenv.(Pseq([300,1200,4000,8000]+18,1), 8).loop,
			\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\chord, Pseq([
				[ [0,3,7,9].midiratio ],
				[ [0,3,7,10].midiratio ],
			],inf),
			\legato, Pseq([
				1,1,1,0.3,
			],inf),
			\dur, 1,
			\amp, 0.1,
			//\out, BusDef(\ifx1, \audio),
			//\out, BusDef(\sendbus1, \audio),
		),
		0, Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/camelcactus.flac'),
			\pos, Pseq([
				\r,\r,\r,\r, \r,\r,\r,\r,
				\r,\r,\r,\r, \r,\r,\r,\r,
				\r,\r,\r,\r, \r,\r,\r,\r,
				(0..7)+130,
				\r,\r,\r,\r, \r,\r,\r,\r,
				\r,\r,\r,\r, \r,\r,\r,\r,
				\r,\r,\r,\r, \r,\r,\r,\r,
				(0..7)+13,
				\r,\r,\r,\r, \r,\r,\r,\r,
				(0..7)+50,
				\r,\r,\r,\r, \r,\r,\r,\r,
				(0..7)+130,
				\r,\r,\r,\r, \r,\r,\r,\r,
				\r,\r,\r,\r, \r,\r,\r,\r,
				\r,\r,\r,\r, \r,\r,\r,\r,
				(0..7)+50,
			].flat/8,inf),
			\speed, 1.2,
			\legato, 1,
			\dur, 1/8,
			\gain, 1/6,
		),
	]),
)).play;
);

(
Pdef(\part, Pdef(\dreadbassrise, 
	Ppar([
		Pmono(
			 \simplegran_adsrcomp,
			\mbufnum, BufDef.mono('samplekit/vipere/camelcactus.flac'),
			\note, Pseq([
				0,0,1,-1,
			],inf),
			\octave, 3,
			\pitch_stretch, ~pmodenv.(Pseq([1,2,1,4],1), 7).loop,
			\pos, ~pmodenv.(Pseq([1,2,1,4]/10+91,1), 9).loop,
			\gdur, ~pmodenv.(Pseq([0.01,0.4],1), 8).loop,
			\pan, 0.0,
			\gfreq, Pkey(\freq),
			\resfr, Pseq([1,2,3,4],inf),
			\resfr, 2,
			\bwr, 0.3000001907349,
			\resmix, 1.0,
			\lpfr, 6.1000000238419,
			\rq, 0.5,
			\lpmix, 1.0,
			\cpt, 0.10000000149012,
			\cpbelow, 1.00100004673,
			\cpabove, 0.0009999996125698,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\dur, 1,
			\pregain, 40,
			\gain, 1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\nappypool1,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <>
		Pbind(
			'wet10', 1.0,
			'mix', 0.0436974789916,
			'gain', 3.69865546218487,
			'fb', 0.0001,
			'delay2', 0.1001,
			'delay', ~pmodenv.(Pseq([0.1000001,0.02],inf), 8).loop,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 137.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', ~pmodenv.(Pseq([1,100,2000],1), 8),
			'posthpf', 17,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Ppar([
				Pfindur(15,Pdef(\dreadbassrise)),
				Pfindur(16,Pbind(
					\instrument, \oscsampler3,
					\pos, 1.208,
					\pos, 1.808,
					\freq, 187,
					\range, 0.0000001,
					\posenv, Pseq([
						[ Env([0.00,0.01001,0].integrate.postln,[0.41,8.1]) ],
					],inf),
					\finepos, 1/400 * Pseq([1,4,2,2],inf),
					\legato, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,1,1,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,1,1,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,1,1,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,1,1,
						4,0,0,0, 1,0,0,1,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						4,0,0,0, 1,0,0,1,
						0,0,2,0, 1,0,1,1,
						4,0,0,0, 1,0,0,0,
						0,0,1,0, 0,0,1,1,
					],inf),
					\levelScale, Pseq([
						1,1,1,1, 1,2,0.73,1/2,
						1,1,1,1, 1,2,0.73,1/2,
						1,1,1,1, 1,2,0.73,1/2,
						1,1,1,1, 1,2,0.73,1/2,

						1,1,1,1, 1,1,1,0.9,
						1,1,1,1, 1,1.2,1,0.8,
						1,1,1,1, 1,2,0.73,1/2,
						1,1,1,1, 1,2,0.73,1/2,

						1,1,1,1, 1,1,1,1/2,
						1,1,1,1, 1,2,0.73,1/2,
					],inf).stutter(2),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\dur, 1/8,
					\fshift, 40,
					\lpmix, 1,
					\rq, 0.4,
					\hpmix, 0,
					\hpfreq, 100,
					\ffreq, Pseq([
						1020,5240,450,700,
					],inf) * Pseq([1,2,1/2],inf).stutter(4) * Pseg(Pseq([0,1],inf),8),
					\ffreq, ~pmodenv.(Pseq([10,5200],1), 8, 1, 3).loop,
					\amp, 0.1/3,
					\bufnum, BufDef.stereo('voices/feynman.flac'),

				)) 
			]),
			Pdef(\dreadbassdrum1),
		],1),
	])
)).play;
);


(
Pdef(\part, Pdef(\dreadbassdrum1, 
	Ppar([
		
		Pbind(
			\rester, Pstep(Pseq([
				1,1, 1,1,
				1,1, 1,0,
			],inf),2),
			\type, Pfunc({ arg ev;
				if(ev[\rester].coin) { ev[\type] } { \rest }
			}),
		)<>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, BufDef('loop/pigs.flac'),
				//\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
				\legato, 1,
				//\st, 272/8/60,
				\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
				\st, 272/1/60,
				\gain, 0.1,
				\speed, 2.5/Pstep(Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,0.7,1.2,1.2, 1,1,1,1,
				],inf),1/4) * ~t / Pkey(\st),
				\pos, Pseq([
					Pseq([
						Pseg(Pseq([
							0, 4,
						],1),1),
					],7),
					Pseg(Pseq([
						0, 4,
					],1),1)+4,
				],inf) / Pkey(\st),
				\dur, PdurStutter(Pseq([1,2,2,8, 4,1,8,1, ],inf), 1/2),
				\gain, 0.1* Pstep(Pseq([
					1,1,1,1, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
				],inf),1/8),
				//\legato, Pseq([1,0.5,0.7,1],inf),
				//\dur, 1/8,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, BufDef('loop/pigs.flac'),
				//\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
				\legato, 1,
				//\st, 272/8/60,
				\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
				\st, 272/1/60,
				\gain, 0.1,
				\speed, 4/Pseq([1,1.4,1,1,1,1,0.7],inf) * ~t / Pkey(\st),
				\pos, Pseq([
					Pseq([
						Pseg(Pseq([
							0, 8,
						],1),4)+8,
					],8),
				],inf) / Pkey(\st),
				\dur, PdurStutter(Pseq([1,1,1,1, 1,1,1,4, 4,4,4,4, 2,2,1,1],inf), 1),
				\gain, 0.1* Pstep(Pseq([
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1,
				],inf),1/8),
				//\legato, Pseq([1,0.5,0.7,1],inf),
				//\dur, 1/8,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[879].value,
				\score, Pseq([
					1,0,0.4,0, 0.3,0,0.3,0,
					0,0,0.5,0.5, 0,0,0,0,
				],inf),
				\isRest, Pkey(\score).coin.not,
				\dur, 1/8,
				\gain, 0.15 * Pkey(\score),
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[771].value,
				\score, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf),
				\isRest, Pkey(\score).coin.not,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.15 * Pkey(\score),
			),
		]),
		Pmono(
			 \simplegran_adsrcomp,
			\mbufnum, BufDef.mono('samplekit/vipere/camelcactus.flac'),
			\mbufnum, BufDef.mono('vbreaks/Igor Bril - Street Without End.wav'),
			\note, Pseq([
				0,0,1,-1,
			],inf),
			\octave, 3,
			\pitch_stretch, ~pmodenv.(Pseq([1,1,1/2,1/2,1/4],1), 2).loop,
			\pos, Pseq([
				~pmodenv.(Pseq([1,2,1,4]/80+1,1), 8).loop,
			],inf),
			\gdur, ~pmodenv.(Pseq([0.101,0.10],1), 8).loop,
			\pan, 0.0,
			\gfreq, Pkey(\freq),
			//\resfr, Pseq([1,2,3,4],inf),
			\resfr, 2,
			\bwr, 1.3000001907349,
			\resmix, 0.91,
			\lpfr, 2.1000000238419,
			\rq, 0.9,
			\lpmix, 0.940,
			\cpt, 0.10000000149012,
			\cpbelow, 1.00100004673,
			\cpabove, 0.0009999996125698,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\dur, 1,
			\pregain, 400,
			\gain, 1/2,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
			\out, BusDef(\ifx1, \audio),
		),

		Pmono(\rdn_grezbass,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <>

		Pbind(
			'wet10', 1.0,
			'mix', 0.18571428571429,
			'gain', 1.0,
			'fb', 0.0000034014403432308,
			'delay', 0.00000838551534282,
			'delay2', Pseq([
				~pmodenv.(Pseq([0.081,0.182]*0.000001,1), 8),
				~pmodenv.(Pseq([0.081,0.182]*0.0001,1), 8),
				~pmodenv.(Pseq([0.081,0.182]*1.01,1), 8),
			],inf),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 8.403186090713,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.44721359549996,
			'fbdistmix', 0.96638655462185,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.15072520464925,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
	Pbind(
		\instrument, \oscsampler3,
		\pos, 1.208,
		\pos, 1.808,
		\freq, 187,
		\range, 0.0000001,
		\posenv, Pseq([
			[ Env([0.00,0.01001,0].integrate.postln,[0.41,8.1]) ],
		],inf),
		\finepos, 1/400 * Pseq([1,4,2,2],inf),
		\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
		   	0,0,1,0, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
		   	0,0,1,0, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
		   	0,0,1,0, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
		   	0,0,1,0, 0,0,1,1,
			4,0,0,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

			4,0,0,0, 1,0,0,1,
		   	0,0,2,0, 1,0,1,1,
			4,0,0,0, 1,0,0,0,
		   	0,0,1,0, 0,0,1,1,
		],inf),
		\levelScale, Pseq([
			1,1,1,1, 1,2,0.73,1/2,
			1,1,1,1, 1,2,0.73,1/2,
			1,1,1,1, 1,2,0.73,1/2,
			1,1,1,1, 1,2,0.73,1/2,

			1,1,1,1, 1,1,1,0.9,
			1,1,1,1, 1,1.2,1,0.8,
			1,1,1,1, 1,2,0.73,1/2,
			1,1,1,1, 1,2,0.73,1/2,

			1,1,1,1, 1,1,1,1/2,
			1,1,1,1, 1,2,0.73,1/2,
		],inf).stutter(2),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\dur, 1/8,
		\fshift, 40,
		\lpmix, 1,
		\rq, 0.4,
		\hpmix, 0,
		\hpfreq, 100,
		\ffreq, Pseq([
			1020,5240,450,700,
		],inf) * Pseq([1,2,1/2],inf).stutter(4) * Pseg(Pseq([0,1],inf),8),
		\ffreq, ~pmodenv.(Pseq([10,5200],1), 8, 1, 3).loop,
		\amp, 0.1/3,
			\bufnum, BufDef.stereo('voices/feynman.flac'),

	) 
		
	])
)).play;
);


(
Pdef(\part, Pdef(\dreadbass1, 
	Ppar([
		
		Pmono(
			 \simplegran_adsrcomp,
			\mbufnum, BufDef.mono('samplekit/vipere/camelcactus.flac'),
			\mbufnum, BufDef.mono('vbreaks/Igor Bril - Street Without End.wav'),
			\note, Pseq([
				0,0,1,-1,
			],inf),
			\octave, 3,
			\pitch_stretch, ~pmodenv.(Pseq([1,1,1/2,1/2,1/4],1), 2).loop,
			\pos, Pseq([
				~pmodenv.(Pseq([1,2,1,4]/80+1,1), 8).loop,
			],inf),
			\gdur, ~pmodenv.(Pseq([0.101,0.10],1), 8).loop,
			\pan, 0.0,
			\gfreq, Pkey(\freq),
			//\resfr, Pseq([1,2,3,4],inf),
			\resfr, 2,
			\bwr, 1.3000001907349,
			\resmix, 0.91,
			\lpfr, 2.1000000238419,
			\rq, 0.9,
			\lpmix, 0.940,
			\cpt, 0.10000000149012,
			\cpbelow, 1.00100004673,
			\cpabove, 0.0009999996125698,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\dur, 1,
			\pregain, 400,
			\gain, 1/2,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
			\out, BusDef(\ifx1, \audio),
		),

		Pmono(\rdn_grezbass,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <>

		Pbind(
			'wet10', 1.0,
			'mix', 0.18571428571429,
			'gain', 1.0,
			'fb', 0.0000034014403432308,
			'delay', 0.00000838551534282,
			'delay2', Pseq([
				~pmodenv.(Pseq([0.081,0.182]*0.000001,1), 8),
				~pmodenv.(Pseq([0.081,0.182]*0.0001,1), 8),
				~pmodenv.(Pseq([0.081,0.182]*1.01,1), 8),
			],inf),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 8.403186090713,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.44721359549996,
			'fbdistmix', 0.96638655462185,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.15072520464925,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\dreadbass2, 
	Ppar([
		Pbind(
			\instrument, \simplegran_adsrcomp,
			\mbufnum, BufDef.mono('samplekit/vipere/camelcactus.flac'),
			\note, Pseq([
				0,0,1,-1,
			],inf),
			\octave, 3,
			//\pitch_stretch, ~pmodenv.(Pseq([1,2,1,4],1), 7).loop,
			\pos, ~pmodenv.(Pseq([1,2,1,4]/80+57,1), 2).loop,
			//\gdur, ~pmodenv.(Pseq([0.01,0.04,0.02],1), 8).loop,
			\pan, 0.0,
			\gfreq, Pkey(\freq),
			//\resfr, Pseq([1,2,3,4],inf),
			\resfr, 2,
			\bwr, 0.3000001907349,
			\resmix, 1.0,
			\lpfr, 6.1000000238419,
			\rq, 0.5,
			\lpmix, 1.0,
			\cpt, 0.10000000149012,
			\cpbelow, 1.00100004673,
			\cpabove, 0.0009999996125698,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.21) ],
			],inf),
			\dur, 1,
			\pregain, 180,
			\legato, 0.1,
			//\gain, Ndef(\bass_gain_lfo, { EnvGen.kr(Env([0,1,0],[0.01,0.38]), Impulse.kr(2*~t)); }).asMap,
			//\out, BusDef(\ifx1, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\dreadbass3, 
	Ppar([
		Pmono(
			 \simplegran_adsrcomp,
			\mbufnum, BufDef.mono('samplekit/vipere/camelcactus.flac'),
			\mbufnum, BufDef.mono('vbreaks/Igor Bril - Street Without End.wav'),
			\note, Pseq([
				0,0,1,-1,
			],inf),
			\octave, 3,
			\pitch_stretch, Pseq([
				~pmodenv.(Pseq([1,1,1,1,4],1), 1/2).loop,
				~pmodenv.(Pseq([1,1,1/2,1/2,1/4],1), 1/2).loop,
			],inf),
			\pos, Pseq([
				~pmodenv.(Pseq([1,1,0,0],1), 1/4).loop,
			],inf),
			\gdur, ~pmodenv.(Pseq([0.101,0.10],1), 1).loop,
			\pan, 0.0,
			\gfreq, Pkey(\freq),
			//\resfr, Pseq([1,2,3,4],inf),
			\resfr, 2,
			\bwr, 1.3000001907349,
			\resmix, 0.91,
			\lpfr, 2.1000000238419,
			\rq, 0.9,
			\lpmix, 0.940,
			\cpt, 0.10000000149012,
			\cpbelow, 1.00100004673,
			\cpabove, 0.0009999996125698,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\dur, 1,
			\pregain, 400,
			\gain, 1/2 * Pseq([
				1,0.1,1,0.1,
				1,0,0.1,0.1,
				1,0,1,0,
				1,0,0,0,
			],inf),
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
			\out, BusDef(\ifx1, \audio),
		),

		Pmono(\rdn_grezbass,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <>

		Pbind(
			'wet10', 1.0,
			'mix', 0.18571428571429,
			'gain', 1.0,
			'fb', 0.0010004014403432308 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,0,0,0,
			],inf),
			'delay', 0.00100838551534282,
			'delay2', Pseq([
				~pmodenv.(Pseq([0.081,0.182]*0.000001,1), 8),
			],inf),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 8.403186090713,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.44721359549996,
			'fbdistmix', 0.96638655462185,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.15072520464925,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\dreadbassdrum3, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0.4,0, 0.3,0,0.3,0,
				0,0,0.5,0.5, 0,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.15 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.15 * Pkey(\score),
		),
		Pmono(
			 \simplegran_adsrcomp,
			\mbufnum, BufDef.mono('samplekit/vipere/camelcactus.flac'),
			\mbufnum, BufDef.mono('vbreaks/Igor Bril - Street Without End.wav'),
			\note, Pseq([
				0,0,1,-1,
			],inf),
			\octave, 3,
			\pitch_stretch, Pseq([
				~pmodenv.(Pseq([1,1,1,1,4],1), 1/2).loop,
				~pmodenv.(Pseq([1,1,1/2,1/2,1/4],1), 1/2).loop,
			],inf),
			\pos, Pseq([
				~pmodenv.(Pseq([1,1,0,0],1), 1/4).loop,
			],inf),
			\gdur, ~pmodenv.(Pseq([0.101,0.10],1), 1).loop,
			\pan, 0.0,
			\gfreq, Pkey(\freq),
			//\resfr, Pseq([1,2,3,4],inf),
			\resfr, 2,
			\bwr, 1.3000001907349,
			\resmix, 0.91,
			\lpfr, 2.1000000238419,
			\rq, 0.9,
			\lpmix, 0.940,
			\cpt, 0.10000000149012,
			\cpbelow, 1.00100004673,
			\cpabove, 0.0009999996125698,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\dur, 1,
			\pregain, 400,
			\gain, 1/2 * Pseq([
				1,0.1,1,0.1,
				1,0,0.1,0.1,
				1,0,1,0,
				1,0,0,0,
			],inf),
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
			\out, BusDef(\ifx1, \audio),
		),

		Pmono(\rdn_grezbass,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <>

		Pbind(
			'wet10', 1.0,
			'mix', 0.18571428571429,
			'gain', 1.0,
			'fb', 0.0010004014403432308 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,0,0,0,
			],inf),
			'delay', 0.00100838551534282,
			'delay2', Pseq([
				~pmodenv.(Pseq([0.081,0.182]*0.000001,1), 8),
			],inf),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 8.403186090713,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.44721359549996,
			'fbdistmix', 0.96638655462185,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.15072520464925,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
		Pseq([
			Pbind(
				\pos, Pseq([
					Pseq([
						Pfin(32-8, Pseq([
							(0..7),
							6,2,2,3, 8,2,5,2,
							(0..7),
							(0..7)+8,
						].flat,inf)),
						\r,\r,\r,\r, \r,\r,\r,\r,
					].flat,1),
					Pseq([
						Pfin(32-8, Pseq([
							(0..3),
							(0..3),
							6,2,2,2, 8,2,2,2,
						].flat,inf)),
						\r,\r,\r,\r, \r,\r,\r,\r,
					].flat,1),
					Pseq([
						Pfin(32-8, Pseq([
							(0..3),4,4,0,4,
							(0..7)+8,
						].flat,inf)),
						\r,\r,\r,\r, \r,\r,\r,\r,
					].flat,1),
					Pseq([
						Pfin(32-8, Pseq([
							\r
						].flat,inf)),
						\r,\r,\r,\r, \r,\r,\r,\r,
					].flat,1),
					//Pseq([
						//Pfin(32-8, Pseq([
							//2,
						//].flat,inf)),
						//(0..7)+29,
					//].flat,1),
				].flat/8,inf),
			)
		],inf)<>
		Pdef(\igorbreak),
		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('loop/pigs.flac'),
			//\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			//\st, 272/8/60,
				\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
				\st, 272/1/60,
				\gain, 0.1,
			\speed, 2.5/Pstep(Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0.7,1.2,1.2, 1,1,1,1,
			],inf),1/4) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseq([
					Pseg(Pseq([
						0, 4,
					],1),1),
				],7),
					Pseg(Pseq([
						0, 4,
					],1),1)+4,
			],inf) / Pkey(\st),
			\dur, PdurStutter(Pseq([1,2,2,8, 4,1,8,1, ],inf), 1/2),
			\gain, 0.1* Pstep(Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
			],inf),1/8),
			//\legato, Pseq([1,0.5,0.7,1],inf),
			//\dur, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('loop/pigs.flac'),
			//\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			//\st, 272/8/60,
				\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
				\st, 272/1/60,
				\gain, 0.1,
			\speed, 4/Pseq([1,1.4,1,1,1,1,0.7],inf) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseq([
					Pseg(Pseq([
						0, 8,
					],1),4)+8,
				],8),
			],inf) / Pkey(\st),
			\dur, PdurStutter(Pseq([1,1,1,1, 1,1,1,4, 4,4,4,4, 2,2,1,1],inf), 1),
			\gain, 0.1* Pstep(Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf),1/8),
			//\legato, Pseq([1,0.5,0.7,1],inf),
			//\dur, 1/8,
		),
	Pbind(
		\instrument, \oscsampler3,
		\pos, 1.208,
		\pos, 1.808,
		\freq, 187,
		\range, 0.0000001,
		\posenv, Pseq([
			[ Env([0.00,0.01001,0].integrate.postln,[0.41,8.1]) ],
		],inf),
		\finepos, 1/400 * Pseq([1,4,2,2],inf),
		\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
		   	0,0,1,0, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
		   	0,0,1,0, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
		   	0,0,1,0, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
		   	0,0,1,0, 0,0,1,1,
			4,0,0,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

			4,0,0,0, 1,0,0,1,
		   	0,0,2,0, 1,0,1,1,
			4,0,0,0, 1,0,0,0,
		   	0,0,1,0, 0,0,1,1,
		],inf),
		\levelScale, Pseq([
			1,1,1,1, 1,2,0.73,1/2,
			1,1,1,1, 1,2,0.73,1/2,
			1,1,1,1, 1,2,0.73,1/2,
			1,1,1,1, 1,2,0.73,1/2,

			1,1,1,1, 1,1,1,0.9,
			1,1,1,1, 1,1.2,1,0.8,
			1,1,1,1, 1,2,0.73,1/2,
			1,1,1,1, 1,2,0.73,1/2,

			1,1,1,1, 1,1,1,1/2,
			1,1,1,1, 1,2,0.73,1/2,
		],inf).stutter(2),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\dur, 1/8,
		\fshift, 40,
		\lpmix, 1,
		\rq, 0.4,
		\hpmix, 0,
		\hpfreq, 100,
		\ffreq, Pseq([
			1020,5240,450,700,
		],inf) * Pseq([1,2,1/2],inf).stutter(4) * Pseg(Pseq([0,1],inf),8),
		\ffreq, ~pmodenv.(Pseq([10,5200],1), 8, 1, 3).loop,
		\amp, 0.1/3,
			\bufnum, BufDef.stereo('voices/feynman.flac'),

	) 
		
	])
)).play;
);

(
Pdef(\part, Pdef(\dreadbass4, 
	Ppar([
		
		Pmono(
			 \simplegran_adsrcomp,
			\mbufnum, BufDef.mono('samplekit/vipere/camelcactus.flac'),
			\mbufnum, BufDef.mono('vbreaks/Igor Bril - Street Without End.wav'),
			\note, Pseq([
				0,0,1,-1,
			],inf),
			\octave, 3,
			\pitch_stretch, ~pmodenv.(Pseq([1,1,1/2,1/2,1/4],1), 2).loop,
			\pos, Pseq([
				~pmodenv.(Pseq([1,2,1,4]/80+1,1), 8).loop,
			],inf),
			\gdur, ~pmodenv.(Pseq([0.101,0.10],1), 8).loop,
			\pan, 0.0,
			\gfreq, Pkey(\freq),
			//\resfr, Pseq([1,2,3,4],inf),
			\resfr, 2,
			\bwr, 1.3000001907349,
			\resmix, 0.91,
			\lpfr, 2.1000000238419,
			\rq, 0.9,
			\lpmix, 0.940,
			\cpt, 0.10000000149012,
			\cpbelow, 1.00100004673,
			\cpabove, 0.0009999996125698,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\dur, 1,
			\pregain, 400,
			\gain, 1/2,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
			\out, BusDef(\ifx1, \audio),
		),

		Pmono(\rdn_grezbass,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <>

		Pbind(
			'wet10', 1.0,
			'mix', 0.18571428571429,
			'gain', 1.0,
			'fb', 0.0000034014403432308,
			'delay', 0.00000838551534282,
			'delay2', Pseq([
				~pmodenv.(Pseq([0.081,0.182]*0.000001,1), 8),
				~pmodenv.(Pseq([0.081,0.182]*0.0001,1), 8),
				~pmodenv.(Pseq([0.081,0.182]*1.01,1), 8),
			],inf),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 8.403186090713,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.44721359549996,
			'fbdistmix', 0.96638655462185,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.15072520464925,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\out, BusDef(\ifx2, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\ifx2, \audio),
			\legato, Pseg(Pseq([0.1,1],inf),8),
			\isRest, Pseq([
				1,0,0,1, 0.94,0.71,0,0,
				1,0.4,0,0, 0.6,0,0,0.8,
				1,0,0.7,0.71, 0,0.71,0.71,0.71,
				1,0,1,1, 0,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\dreadbassdrum4, 
	Ppar([
		
		Pdef(\dreadbass4),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,1,
				1,0,0.4,0, 0.3,0,0.3,0,
				0,0,0.5,0.5, 0,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.15 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.15 * Pkey(\score),
		),
		Pseq([
			Pbind(
				\pos, Pseq([
					Pseq([
						Pfin(32-8, Pseq([
							(0..7),
							6,2,2,2, 8,2,2,2,
						].flat,inf)),
						(0..7)+29,
					].flat,1),
					Pseq([
						Pfin(32-8, Pseq([
							(0..3),
							(0..3),
							6,2,2,2, 8,2,2,2,
						].flat,inf)),
						(0..7)+29,
					].flat,1),
					//Pseq([
						//Pfin(32-8, Pseq([
							//2,
						//].flat,inf)),
						//(0..7)+29,
					//].flat,1),
				].flat/8,inf),
			)
		],inf)<>
		Pdef(\igorbreak),
	])
)).play;
);


(
Pdef(\part, Pdef(\dreaddrums1, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				Pseq([
					1,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
				],2),
				Pseq([
					1,0,0.4,0, 0.3,0,0.3,0,
					0,0,0.5,0.5, 0,0,0,0,
				],4),
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.15 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					0,0,0,0, 1,0,0,0,
				],8),
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.15 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('loop/pigs.flac'),
			//\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			//\st, 272/8/60,
				\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
				\st, 272/1/60,
				\gain, 0.1,
			\speed, 2.5/Pstep(Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0.7,1.2,1.2, 1,1,1,1,
			],inf),1/4) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseq([
					Pseg(Pseq([
						0, 4,
					],1),1),
				],7),
					Pseg(Pseq([
						0, 4,
					],1),1)+4,
			],inf) / Pkey(\st),
			\dur, PdurStutter(Pseq([1, ],inf), 1/2),
			\gain, 0.1* Pstep(Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),1/8),
			//\legato, Pseq([1,0.5,0.7,1],inf),
			//\dur, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('loop/pigs.flac'),
			//\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			//\st, 272/8/60,
				\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
				\st, 272/1/60,
				\gain, 0.1,
			\speed, 4/Pseq([1],inf) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseq([
					Pseg(Pseq([
						0, 4,
					],1),4)+8,
				],8),
			],inf) / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, PdurStutter(Pseq([1,1,1,1, 1,1,1,4, 4,4,4,4, 2,2,1,1],inf), 1),
			\gain, 0.1* Pstep(Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,1,1,1,
			],inf),1/8),
			//\legato, Pseq([1,0.5,0.7,1],inf),
			//\dur, 1/8,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\dreadbassdrum5, 
	Ppar([
		
		Pdef(\dreadbass1),
		Pdef(\dreaddrums1),
	])
)).play;
);

(
	Pdef(\part, Pdef(\dreadbassdrum7, 
		Ppar([

			Pdef(\dreadbass4),

			Pbind(
				\rester, Pstep(Pseq([
					1,1, 1,1,
					1,1, 1,1,
					1,1, 1,1,
					1,1, 1,0,
				],inf),2),
				\type, Pfunc({ arg ev;
					if(ev[\rester].coin) { ev[\type] } { \rest }
				}),
			)<>
			Ppar([
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
					\bufnum, ~buflib.kick[879].value,
					\score, Pseq([
						1,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,1,
						1,0,0.4,0, 0.3,0,0.3,0,
						0,0,0.5,0.5, 0,0,0,0,
					],inf),
					\isRest, Pkey(\score).coin.not,
					\dur, 1/8,
					\gain, 0.15 * Pkey(\score),
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\bufnum, ~buflib.snare[771].value,
					\score, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf),
					\isRest, Pkey(\score).coin.not,
					\dur, 1/8,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\gain, 0.15 * Pkey(\score),
				),
				Pseq([
					Pbind(
						\pos, Pseq([
							Pseq([
								Pfin(32-8, Pseq([
									(0..7),
									6,2,2,2, 8,2,2,2,
								].flat,inf)),
								(0..7)+29,
							].flat,1),
							Pseq([
								Pfin(32-8, Pseq([
									(0..3),
									(0..3),
									6,2,2,2, 8,2,2,2,
								].flat,inf)),
								(0..7)+29,
							].flat,1),
							//Pseq([
							//Pfin(32-8, Pseq([
							//2,
							//].flat,inf)),
							//(0..7)+29,
							//].flat,1),
						].flat/8,inf),
					)
				],inf)<>
				Pdef(\igorbreak),
			]),
			Ptpar([
				8, Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('samplekit/vipere/metal.flac'),
					\speed, Pseq([
						(0..3)/10+1,
						(0..3).reverse/10+1
					].flat,inf)*0.9,
					\pos, Pseq([
						Pseq([
							\r,\r,\r,\r, \r,\r,\r,\r,
							\r,\r,\r,\r, 1,9,32,11,
							\r,\r,\r,\r, \r,\r,\r,\r,
							\r,\r,\r,\r, \r,\r,\r,\r,
							
							\r,\r,\r,\r, 1,9,32,11,
							\r,\r,\r,\r, \r,\r,\r,\r,
							4,9,2,1, 1,9,32,11,
							\r,\r,\r,\r, \r,\r,\r,\r,
						],2),
						Pseq([
							\r,\r,\r,\r, \r,\r,\r,\r,
							\r,\r,\r,\r, 1,9,32,11,
							\r,\r,\r,\r, \r,\r,\r,\r,
							\r,\r,\r,\r, \r,\r,\r,\r,
							
							\r,\r,\r,\r, \r,\r,\r,\r,
							\r,\r,\r,\r, \r,\r,\r,\r,
							\r,\r,\r,\r, \r,\r,\r,\r,
							\r,\r,\r,\r, \r,\r,\r,\r,
						],1),

						//Pseq([ 0,1,2,0, 0,0,0,0, ],1)+1,
						//Pseq([ 0,0,4,4, 0,4,0,0, ],1)+7,
						//Pseq([ 4,5,0,4, 0,6,0,0, ],1)+7,
						//Pseq([ 0,0,0,0, 0,7,8,9, ],1)+7,

						//Pseq([ 0,1,2,0, 0,0,0,0, ],1)+1,
						//Pseq([ 0,0,0,0, 0,0,0,0, ],1)+7,
						//Pseq([ 0,5,0,0, 0,6,0,7, ],1)+7,
						//Pseq([ 0,0,0,0, 0,7,8,9, ],1)+7,
						//(0..3)*2,
						//(0..7)*2+10,
					].flat/8,inf),
					\legato, 1,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.9) ],
						[ Env.adsr(0.01,0.1,0.8,0.4) ],
						[ Env.adsr(0.01,0.1,0.8,0.4) ],
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\dur, 1/8,
					\gain, 1/6,
				),
				8,Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('samplekit/vipere/camelcactus.flac'),
					\pos, Pseq([
						Pseq([
							\r,\r,\r,\r, \r,\r,\r,\r,
							\r,\r,\r,\r, \r,\r,\r,\r,
							\r,\r,\r,\r, \r,\r,\r,\r,
							\r,\r,\r,\r, (0..3)+60,
						].flat,1),
						Pseq([
							\r,\r,\r,\r, \r,\r,\r,\r,
							\r,\r,\r,\r, \r,\r,\r,\r,
							\r,\r,\r,\r, \r,\r,\r,\r,
							\r,\r,\r,\r, (0..3)+62,
						].flat,1),

						//Pseq([
						//\r,\r,\r,\r, \r,\r,\r,\r,
						//\r,\r,\r,\r, \r,\r,\r,\r,
						//\r,\r,\r,\r, \r,\r,\r,\r,
						//\r,\r,\r,\r, (0..3)+86,
						//].flat,1),
						//\r,\r,\r,\r, \r,\r,\r,\r,
						//\r,\r,\r,\r, \r,\r,\r,\r,
						//\r,\r,\r,\r, \r,\r,\r,\r,
						//\r,\r,\r,\r, (0..3)+72,

						//\r,\r,\r,\r, \r,\r,\r,\r,
						//\r,\r,\r,\r, \r,\r,\r,\r,
						//\r,\r,\r,\r, \r,\r,\r,\r,
						//\r,\r,\r,\r, (0..3)+42,
					].flat/8,inf),
					\speed, 0.8,
					\legato, 1,
					\dur, 1/8,
					\gain, 1/4,
				),
				16,Pbind(
					\instrument, \pluck,
					\degree, Pseq([
						0,0,0,0,
						0,0,0,-1,
					],inf).stutter(2),
					\mtranspose, Pstep(Pseq([
						0,3,
					],inf),4),
					\freq, Pseg(Pseq([80.midicps,78.midicps],1),4).loop,
					//\dstrum, Pseg(Pseq([0,0.0010],inf),8*2),
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\isRest, Pseq([
						1,1,1,1, 1,1,1,1,
					],inf).coin.not,
					\decay, 1.44,
					\coef, Pseg(Pseq((1..10)/10,inf),1),
					\coef, Pseq([
						0.7,0.7,0.4,0.7, 0.1,0.7,0.4,0.7,
						0.7,0.7,0.4,0.7, 0.1,0.7,0.4,0.07,
					],inf),
					//\coef, 0.005,
					\dur, 1/8,
					\amp, 0.1/6,
				),
				24, Pbind(
					\instrument, \playersec,
					\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
					\legato, 1,
					\st, 272/4/60,
					\speed, 1 * ~t / Pkey(\st),
					\pos, Pseq([
						Pn(11,32-8),
						Pn(\r,8),
						Pn(65,32-8),
						Pn(81,6),\r,\r
					].flat,inf)/8 / Pkey(\st),
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\dur, 1/8,
					\gain, 1/11,
					//\isRest, true,
					//\out, BusDef(\sendbus2, \audio),
				),
			]),
		])
	)).play;
);


(
	Pdef(\part, Pdef(\dreaddrumdist1, 
		Pfindur(32,Ppar([

			Pbind(
				\rester, Pstep(Pseq([
					1,1, 1,1,
					1,1, 1,0,
					1,1, 1,1,
					1,1, 0,0,
				],inf),2),
				\type, Pfunc({ arg ev;
					if(ev[\rester].coin) { ev[\type] } { \rest }
				}),
			)<>
			Ppar([
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
					\bufnum, ~buflib.kick[879].value,
					\score, Pseq([
						1,0,0.4,0, 0.3,0,0.3,0,
						0,0,0.5,0.5, 0,0,0,0,
					],inf),
					\isRest, Pkey(\score).coin.not,
					\dur, 1/8,
					\gain, 0.15 * Pkey(\score),
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\bufnum, ~buflib.snare[771].value,
					\score, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf),
					\isRest, Pkey(\score).coin.not,
					\dur, 1/8,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\gain, 0.15 * Pkey(\score),
				),
			]),
			Pseq([
				Pfindur(8,PmonoArtic(
					\nappy,
					\note, Pseq([
						0,
						0,
						1,
						-1,
					],inf)+4,
					\octave,6,
					//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
					\lpf, ~pmodenv.(Pseq([4300,120,4000,800]+18,1), 2).loop,
					\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
					\rq, 0.1,
					\hpf, ~pmodenv.(Pseq([10000,1000,2,1,400],1), 4).loop,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,0.8,2.1) ],
					],inf),
					\chord, Pseq([
						[ [0,3,7,9].midiratio ],
						[ [0,3,7,10].midiratio ],
						[ [0,3,7,11].midiratio ],
						[ [0,3,7,12].midiratio ],
					],inf),
					\legato, Pseq([
						1,1,1,0.3,
					],inf),
					\dur, 1,
					\amp, 0.1,
					//\out, BusDef(\ifx1, \audio),
					//\out, BusDef(\sendbus1, \audio),
				)),
				Pfindur(8,PmonoArtic(
					\nappy,
					\note, Pstep(Pseq([
						0,
						0,
						1,
						-1,
					],inf)+4,1),
					\octave,6 + Pseq([1,0,-1],inf).stutter(3),
					//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
					\lpf, ~pmodenv.(Pseq([4300,120,4000,800]+18,1), 2).loop,
					\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
					\rq, 0.1,
					\hpf, ~pmodenv.(Pseq([4000,1000,2,1,400],1), 4).loop,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,0.8,2.1) ],
					],inf),
					\chord, Pseq([
						[ [0,3,7,9].midiratio ],
						[ [0,3,7,10].midiratio ],
						[ [0,3,7,11].midiratio ],
						[ [0,3,7,12].midiratio ],
					],inf),
					\legato, Pseq([
						1,1,1,0.3,
					],inf),
					\dur, 1/8,
					\amp, 0.1,
					//\out, BusDef(\ifx1, \audio),
					//\out, BusDef(\sendbus1, \audio),
				)),
				Pfindur(8,PmonoArtic(
					\nappy,
					\note, Pstep(Pseq([
						0,
						0,
						1,
						-1,
					],inf)+4,1),
					\octave,6,
					//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
					\lpf, ~pmodenv.(Pseq([4300,800]+18,1), 2).loop,
					\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
					\rq, 0.1,
					\hpf, ~pmodenv.(Pseq([100,1000,2,1,400],1), 4).loop,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,0.8,0.1) ],
					],inf),
					\chord, Pseq([
						[ [0,3,7,9].midiratio ],
						[ [0,3,7,10].midiratio ],
						[ [0,3,7,11].midiratio ],
						[ [0,3,7,12].midiratio ],
					],inf),
					\legato, Pseq([
						1,1,1,0.3,
					],inf),
					\legato, 0.2,
					\dur, PdurStutter(Pseq([1,4,2,8],inf), 1/2),
					\amp, 0.1,
					//\out, BusDef(\ifx1, \audio),
					//\out, BusDef(\sendbus1, \audio),
				)),
				Pfindur(8,PmonoArtic(
					\nappy,
					\note, Pstep(Pseq([
						0,
						0,
						1,
						-1,
					],inf)+4,1),
					\octave,6,
					//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
					\lpf, ~pmodenv.(Pseq([4300,800]+18,1), 2).loop,
					\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
					\rq, 0.1,
					\hpf, ~pmodenv.(Pseq([100,1000,2,1,400],1), 4).loop,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,0.8,0.1) ],
					],inf),
					\chord, Pseq([
						[ [0,3,7,9].midiratio ],
						[ [0,3,7,10].midiratio ],
						[ [0,3,7,11].midiratio ],
						[ [0,3,7,12].midiratio ],
					],inf),
					\legato, Pseq([
						1,1,1,0.3,
					],inf),
					\dur, PdurStutter(Pseq([1,4,1,1, 1,1,1,1],inf), 1/2),
					\amp, 0.1,
					//\out, BusDef(\ifx1, \audio),
					//\out, BusDef(\sendbus1, \audio),
				)),
			],1),
			Pbind(\out, BusDef(\ifx1, \audio), \lag, -0.04) <>
			Ppar([
				Pseq([
					Pbind(
						\pos, Pseq([
							Pseq([
								Pfin(32-8, Pseq([
									(0..7),
									6,2,2,3, 8,2,5,2,
									(0..7),
									(0..7)+8,
								].flat,inf)),
								\r,\r,\r,\r, \r,\r,\r,\r,
							].flat,1),
							Pseq([
								Pfin(32-8, Pseq([
									(0..3),
									(0..3),
									6,2,2,2, 8,2,2,2,
								].flat,inf)),
								\r,\r,\r,\r, \r,\r,\r,\r,
							].flat,1),
							Pseq([
								Pfin(32-8, Pseq([
									(0..3),4,4,0,4,
									(0..7)+8,
								].flat,inf)),
								\r,\r,\r,\r, \r,\r,\r,\r,
							].flat,1),
							Pseq([
								Pfin(32-8, Pseq([
									\r
								].flat,inf)),
								\r,\r,\r,\r, \r,\r,\r,\r,
							].flat,1),
							//Pseq([
							//Pfin(32-8, Pseq([
							//2,
							//].flat,inf)),
							//(0..7)+29,
							//].flat,1),
						].flat/8,inf),
					)
				],inf)<>
				Pdef(\igorbreak),
				Pbind(
					\instrument, \playersec,
					//\bufnum, BufDef('loop/pigs.flac'),
					//\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
					\legato, 1,
					//\st, 272/8/60,
					\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
					\st, 272/1/60,
					\gain, 0.1,
					\speed, 2.5/Pstep(Pseq([
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
						1,0.7,1.2,1.2, 1,1,1,1,
					],inf),1/4) * ~t / Pkey(\st),
					\pos, Pseq([
						Pseq([
							Pseg(Pseq([
								0, 4,
							],1),1),
						],7),
						Pseg(Pseq([
							0, 4,
						],1),1)+4,
					],inf) / Pkey(\st),
					\dur, PdurStutter(Pseq([1,2,2,8, 4,1,8,1, ],inf), 1/2),
					\gain, 0.1* Pstep(Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						0,0,0,0, 0,0,0,0,
					],inf),1/8),
					//\legato, Pseq([1,0.5,0.7,1],inf),
					//\dur, 1/8,
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, BufDef('loop/pigs.flac'),
					//\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
					\legato, 1,
					//\st, 272/8/60,
					\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
					\st, 272/1/60,
					\gain, 0.1,
					\speed, 4/Pseq([1,1.4,1,1,1,1,0.7],inf) * ~t / Pkey(\st),
					\pos, Pseq([
						Pseq([
							Pseg(Pseq([
								0, 8,
							],1),4)+8,
						],8),
					],inf) / Pkey(\st),
					\dur, PdurStutter(Pseq([1,1,1,1, 1,1,1,4, 4,4,4,4, 2,2,1,1],inf), 1),
					\gain, 0.1* Pstep(Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,1,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
					],inf),1/8),
					//\legato, Pseq([1,0.5,0.7,1],inf),
					//\dur, 1/8,
				),
			]),
			Pmono(\rdn_noiser,
				\inbus, BusDef(\ifx1, \audio),
				\addAction, \addToTail,
				\lag, 0.0009,
				\dur, 1,
			)<>
			Pbind(
				'wet10', 1.0,
				'mix', 0.28571428571429 * Pseq([
					//Pseq([
						//0,0,0,0, 0,0,0,0,
					//],1)+0.3,
					1,1,1,1, 1,1,1,1,
				],inf),
				'gain', 1.0,
				'fb', 0.0012489775883775 * Pseq([
					1,1,1,0, 2,1,1,1,
				],inf),
				'delay', 0.000001 * Pseq([
					1,100,1000,
				],inf).stutter(4),
				'delay2', 0.0000001,
				'delay2', 0.000001 * Pseq([
					1,100,1000,
				],inf).stutter(4),
				'shift', 0.0,
				'shift2', 0.0,
				'distamp', 19.121088211933 * Pseq([
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1,
				],inf),
				'pitchlag', 1.0,
				'pitchmix', 0.0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 17,
				'fbdistamp', 0.44721359549996,
				'fbdistmix', 0.96638655462185,
				'postlpf', 17000,
				'posthpf', 17,
				'wetamp', 0.15072520464925,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
			),
			Ptpar([
				24, Ppar([
					Pbind(
						\instrument, Pseq([
							//Pseq([
							//\stringsx,
							//],6),
							Pseq([
								\stringsx4,
							],2),
						],inf),
						\degree, Pseq([
							[0-12,0,-4,2],
							[-1,0,-4,2,1],
							[-1,0,-4,2,1,3],
							[-1,0,-4,2,1,3,4],
						],1).stutter(2),
						\mtranspose, Pstep(Pseq([
							0,
						],inf),4),
						\octave, 6,
						\adsr, Pseq([
							Pseq([
								[ Env.adsr(0.1,0.1,0.8,0.4) ],
							],7),
							Pseq([
								[ Env.adsr(0.1,0.1,0.8,3.4) ],
							],1),
						],inf),
						\legato, Pseq([
							1
						],inf),
						\lag, Pseq([
							Pseq([
								0
							],6),
						],inf),
						\dur, 1,
						\amp, 0.1,
						\out, BusDef(\ifx3, \audio),
					),
					Pmono( \fx_simplecompander,
						\inbus, BusDef(\ifx3, \audio),
						\addAction, \addToTail,
						\lag, 0.0009,
						\pregain, 1.0,
						\cpt, 0.10000000149012,
						\cpbelow, 1.00100004673,
						\cpabove, 0.0099999997764826,
						\cpclamp, 0.0099999997764826,
						\cprelax, 0.10000000149012,
						\adsr, Pseq([
							[ Env.adsr(0.01,0.1,0.8,3.1) ],
						],inf),
						\mix, 1.0,
						\gain, 1.5,
						\dur, 1,
					),
				]),
			])
		]))
	)).play;
);

~protordn_to_fbstring.(ProtoDef(\rdn)).editorInsert
(

	SynthDef(\rdn_noiser, { arg out=0, gate=1;
		// code: 5-RLQC-3S77
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
		thisThread.randSeed = 127207.0;
		si = sig;
		sig = { arg si, env;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
			si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
			si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
			si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
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
		'mix', 0.28571428571429,
		'gain', 1.0,
		'fb', 0.0012489775883775,
		'delay', 0.0001,
		'delay2', 0.0001,
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 19.121088211933,
		'pitchlag', 1.0,
		'pitchmix', 0.0,
		'prelpf', 17000,
		'prehpf', 17,
		'lpf', 17000,
		'hpf', 17,
		'fbdistamp', 0.44721359549996,
		'fbdistmix', 0.96638655462185,
		'postlpf', 17000,
		'posthpf', 17,
		'wetamp', 0.15072520464925,
		'indelay', 0.04,
		'wet20', 1.0,
		'mamp', 1,
	)


);

///////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
			Pfindur(8,Ptpar([
				0, Ppar([
						Pbind(
						\instrument, Pseq([
							//Pseq([
								//\stringsx,
							//],6),
							Pseq([
								\stringsx4,
							],2),
						],inf),
						\degree, Pseq([
							[0-12,0,-4,2],
							[-1,0,-4,2,1],
							[-1,0,-4,2,1,3],
							[-1,0,-4,2,1,3,4],
						],1).stutter(2),
						\mtranspose, Pstep(Pseq([
							0,
						],inf),4),
						\octave, 6,
						\adsr, Pseq([
							Pseq([
								[ Env.adsr(0.1,0.1,0.8,0.4) ],
							],7),
							Pseq([
								[ Env.adsr(0.1,0.1,0.8,3.4) ],
							],1),
						],inf),
						\legato, Pseq([
							1
						],inf),
						\lag, Pseq([
							Pseq([
								0
							],6),
						],inf),
						\dur, 1,
						\amp, 0.1,
						\out, BusDef(\ifx3, \audio),
					),
					Pmono( \fx_simplecompander,
						\inbus, BusDef(\ifx3, \audio),
						\addAction, \addToTail,
						\lag, 0.0009,
						\pregain, 1.0,
						\cpt, 0.10000000149012,
						\cpbelow, 1.00100004673,
						\cpabove, 0.0099999997764826,
						\cpclamp, 0.0099999997764826,
						\cprelax, 0.10000000149012,
						\adsr, Pseq([
							[ Env.adsr(0.01,0.1,0.8,3.1) ],
						],inf),
						\mix, 1.0,
						\gain, 1.5,
						\dur, 1,
					),
				]),
			]))
	])
)).play;
);

(
SynthDef(\stringsx4, { arg out, freq=440, amp=0.8, gate=1, pan, freqLag=0.2;
	var env, in, delay, f1, f2;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	f1 = freq.lag(freqLag);
	f2 = freq.lag(freqLag * 0.5);

	env1 = EnvGen.kr(Env([1,1.12,1],[0.051,0.8]), 1);
	delay = 0.25 / f2;
	env = \adsr.kr(Env.adsr(0.1,0.1,0.8,0.1));
	in = WhiteNoise.ar(180);
	in = CombL.ar(in, delay, delay * ( SinOsc.kr([1,2]*4) * 0.1 + 1 ) , 1);
	in = Resonz.ar(in, f1 * env1, 0.001).abs;
	in = in * EnvGen.kr(env, gate, doneAction:2);
	Out.ar(out, Pan2.ar(in, pan, amp).mean);

}).add;
)
