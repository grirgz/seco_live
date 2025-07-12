
~t = 115/2/60; TempoClock.default.tempo = ~t;

~foley1path = "/home/ggz/Musique/sc/samplekit/cfoley/Blastwave FX Foley Vol. 1/";
(
~buflib[\foley1] ={
		"/home/ggz/Musique/sc/samplekit/cfoley/Blastwave FX Foley Vol. 1/*".pathMatch.collect({ arg path;
			{ BufDef.stereo(path); }
		})
	}.value;
)
(
SynthDef(\basicpadxp, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env([1,2,1],[4.1,0.8])), 1);
	sig1 = SinOsc.ar(freq * [1,1+\det.kr(0.00001)]);
	sig2 = LFSaw.ar(freq * [1,1+\det.kr]);
	sig2 = sig2 * EnvGen.kr(\sawenv.kr(Env([0,1,0],[1.1,1.8])), 1);
	sig2 = LPF.ar(sig2, \lpf.kr(8000) * env1);

	sig1 = sig1 * Duty.kr(1/Rand(1,18)/~t, 0, Dseq([
		1,0,0,0,
	],inf));
	sig2 = sig1 * Duty.kr(1/Rand(1,18)/~t, 0, Dseq([
		1,0,0,0,
	],inf));

	sig = [sig1, sig2].sum / 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [1,-1], amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\unichordo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.2,1],[0.1,0.8]), 1);
	env2 = SinOsc.ar(8/1.5*~t * ( SinOsc.kr(1*~t,Rand(0.0,2)) * 1 + 1 )).range(0.1,1);
	sig1 = SinOsc.ar(freq* [1,1.0001,1/2,1/4] * [0,0.01,0.02].midiratio/4)* EnvGen.kr(Env([0,0.41,0],[0.01,0.2]), 1);
	sig2 = SinOsc.ar(freq/2 * [1,2,1/2] * 0.midiratio).fold(env1) * 0.4;
	sig3 = LFSaw.ar(freq * [1,1.01,1.006,1/2,1/4] * 0.midiratio) * EnvGen.kr(Env([0,0.51,0],[1.1,2.8], 4), 1);
	sig3 = RLPF.ar(sig3, \lpfr.kr(2.1) * EnvGen.kr(Env([1,1/2,2,1],[2,2.1,2.8]), 1) * freq, \rq.kr(0.5));
	sig4 = SinOsc.ar(freq * [2/4,1/4]) * EnvGen.kr(Env([0,0.41,0],[0.01,0.2]), 1);
	sig5 = SinOsc.ar(freq+0.1 * [0+12,0,12.01,-12.02,0-24.03].midiratio/2 * ( LFSaw.ar(freq/2) * 0.4 + 1 )) * EnvGen.kr(Env([0,0.41,0],[0.1,1.5]), 1);
	sig6 = SinOsc.ar(freq*1.001 * [1,1/2,2,1/8]  * ( SinOsc.ar(freq* [0+12,0.01,12.027,0-12.012].midiratio/2) * 1.4 + 1 )) * EnvGen.kr(Env([0,0,0.41,0],[0.3,0.8,6.5]), 1);
	sig6 = HPF.ar(sig6, 1000 * EnvGen.kr(Env([1,2,1],[4.1,0.8]), 1)) + BPF.ar(sig6, 70);
	sig = sig1 + sig2 + sig3 + sig4 + sig5 + sig6;
	sig = sig1 + sig/2;
	sig = RLPF.ar(sig, env2 * 0.1 + 1 * \lpf.kr(1000), 0.5 / (1+ env2 ));
	sig = AllpassL.ar(sig, 0.4,0.01 * [1,0.6,0.7,1.1],4.5) + ( sig * 2 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,5.8)), gate, doneAction:2);
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\bass_fmek, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(0.01*(1..10)/100) * 1; 
	//lfo1 = Duty.kr(1/8/~t, 0, Dseq([
		//1,2,4,2,
	//],inf));
	lfo2 = EnvGen.kr(\fma4env.kr(Env([2,1,1],[0.02,0.1])), 1);
	sig1 = SinOsc.ar(freq * \freqfac1.kr(1) * ( LFNoise1.ar((1..10)*\noisefreqfac.kr(0.1)) * \fma1.kr(1) + 1 ));
	sig2 = SinOsc.ar(freq * \freqfac2.kr(1) * ( sig1 * \fma2.kr(1)*lfo1 + 1 ));
	sig3 = SinOsc.ar(freq * \freqfac3.kr(1) * ( sig2 * \fma3.kr(4) + 1 ));
	sig4 = SinOsc.ar(freq * ( sig3 * \fma4.kr(0.8) * lfo2 + 1 ));
	sig = sig4;
	//sig = sig * SinOsc.ar((1..10)*0.03).clip(0,1); 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\gransinfm, { arg out=0, amp=0.1, freq=100, mix=0.5, gain=1, gate=1, mbufnum=0, pitch_stretch=1, pos=0, gdur=0.1, pan;
	var sig;
	var clk;
	var phase;
	clk = Impulse.ar(\gfreq.kr(40));
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = pos;
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, phase % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = SinOsc.ar(freq * [1,1 + \fdelta.kr(0.001)] * ( LFSaw.ar(sig*\fmffac.kr(100)+(\freqfac.kr(1)*freq)) * \fma.kr(1) + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * gain * amp ;
	Out.ar(out, sig);
}).add;
SynthDef(\simplegran, { arg out=0, mix=0.5, gain=1, gate=1, mbufnum=0, pitch_stretch=1, pos=0, gdur=0.1, pan;
	var sig;
	var clk;
	var phase;
	clk = Impulse.ar(\gfreq.kr(40));
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = pos;
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, phase % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.ar(\asr.kr(Env.asr(0.01,1,0.01)),gate,doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
SynthDef(\doublegran, { arg out=0, mix=0.5, gain=1, gate=1, mbufnum=0, pitch_stretch=1, pos=0, gdur=0.1, pan;
	var sig;
	var clk;
	var phase;
	clk = Impulse.ar(\gfreq.kr(40));
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = pos;
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, phase + [0,\dephase.kr(0)] % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig.mean * 0.6;
	sig.debug("sig");
	sig = sig * EnvGen.ar(\asr.kr(Env.asr(0.01,1,0.01)),gate,doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
SynthDef(\echhlow, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([10,420,182],[4,0.1]/~t,[1,1]),1);
	env2 = EnvGen.kr(Env([10,100,152],[4,0.1]/~t,[1,1]), 1);
	env3 = EnvGen.kr(Env([10,710,1000],[4,0.1]/~t,[1,1]), 1);
	env4 = EnvGen.kr(Env([0.1,2,0.1],[4.0,0.08]/~t), 1);
	sig = WhiteNoise.ar;
	sig = Ringz.ar(sig, rrand(70.0!8,1000),0.01).mean;
	sig = sig * ( SinOsc.ar(1700) * env4 + 1 );
	//sig = RLPF.ar(sig, env2, \rq2.kr(0.8));
	sig = RLPF.ar(sig,  [env3, env2, env1 ], \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,2.4)),gate,doneAction:2);
	sig = Pan2.ar(sig, [-1,0,1]*0.1, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[875].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1479].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
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
		Pseq([

			Pfindur(7.5,Plazy({
				Ppar([
					Pbind(
						\instrument, \playersec,
						\bufnum, ~buflib.kick[875].value,
						//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
						\isRest, Pseq([
							1,0, 1,0, 1,0, 1,0,
							1,0, 1,0, 1,0, 1,0,
							1,0, 1,0, 1,0, 1,0,
							1,0, 1,0, 1,0, 1,1,
						],inf).coin.not,
						\dur, 1/8,
						\gain, 0.1,
					),
					Pbind(
						\instrument, \playersec,
						\bufnum, ~buflib.snare[1834].value,
						//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
						\isRest, Pseq([
							0,0,1,0, 0,0,1,0,
							0,0,1,0, 0,0,1,0,
							0,0,1,0, 0,0,1,0,
							0,0,1,0, 0,0,1,0,
							0,0,1,0, 0,0,1,0,
							0,0,1,0, 0,0,1,0,
							0,0,1,0, 0,0,1,0,
							1,0,0,0, 0,0,1,0,
						],inf).coin.not,
						\dur, 1/8,
						\gain, 0.11/2,
					),
					Pbind(
						\instrument, \playersec,
						\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
						\isRest, Pseq([
							0,0,0,0, 1,0,0,0,
							0,0,0,0, 1,0,0,0,
							0,0,0,0, 1,0,0,0,
							0,0,0,0, 1,1,0,1,
							0,0,0,0, 1,0,0,0,
							0,0,0,0, 1,0,0,0,
							0,0,0,0, 1,0,0,0,
							0,1,0,0, 1,0,0,0,
						],inf).coin.not,
						\dur, 1/8,
						\gain, 0.1,
					),
					Pbind(
						\instrument, \playersec,
						\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
						\isRest, Pseq([
							1,0,0,0, 0,0,0,0,
						],inf).coin.not,
						\dur, 1/8,
						\gain, 0.1,
					),
					Pbind(
						\instrument, \playersec,
						\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
						\isRest, Pseq([
							0,1,
						],inf).coin.not,
						\dur, 1/8,
						\gain, 0.1,
					),
					Pbind(
						\instrument, \playersec,
						\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
						\isRest, Pseq([
							1,
						],inf).coin.not,
						\dur, 1/8,
						\gain, 0.1,
					),
					Pbind(
						\instrument, \playersec,
						\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
						\isRest, Pseq([
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							1,1,1,1, 1,1,1,1,
						],inf).coin.not,
						\dur, 1/8,
						\gain, 0.1,
					),
					Pbind(
						\instrument, \playersec,
						\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
						\isRest, Pseq([
							0,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
						],inf).coin.not,
						\dur, 1/8,
						\gain, 0.1,
					),
				])
			})),

			Plazy({ arg ev;

				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
					\isRest, Pseq([
						1,
					],inf).coin.not,
					\dur, Pn(1/2,1),
					\gain, 0.1,
				)
			})
		],inf)
		
	])
)).play;
);



(
Ndef(\sample, { arg amp=0.5, pan=0, freq=200, mbufnum,
						gdur=12, trate=100, time_stretch=1, pos=0, pitch_stretch = 1, 
						randframes=0.01, randrate=1, doneAction=2, finepos=0,
						release=0.2;
	var ou;
	var ou1, ou2;
	var dur, clk;
	var bufnum = mbufnum;
	var randclk;
	var pitch;
	var sr, phasor;

	bufnum = BufDef.mono("/home/ggz/Musique/sc/samplekit/cfoley/Blastwave FX Foley Vol. 1/ChairMetalFold_S08FO.509.wav");
	bufnum = BufDef.mono("/home/ggz/Musique/sc/samplekit/cfoley/Blastwave FX Foley Vol. 1/ChapStickSlide_S08FO.567.wav");

	//pitch_stretch = 1;
	//time_stretch = 0;
	//trate = 100;
	//pos = SinOsc.kr(1/4*~t,pi).range(0,1) * 0.44 + 0.11;
	//pos = EnvGen.ar(Env([0,1,2]/2,[1,1]/2),LFPulse.kr(1/2*~t),doneAction:0);
	//pos = pos + EnvGen.ar(Env([0,0.2,0.4],[0.4,0.1]),LFPulse.kr(1*~t).poll,doneAction:0).poll;
	//pos = 0.1;
	clk = Impulse.kr(trate);
	randclk = Impulse.kr(randrate * trate);
	dur = gdur;
	pan = (WhiteNoise.kr(0.6) + pan).clip(-1,1);
	sr = SampleRate.ir;
	phasor = Phasor.ar(0, time_stretch.abs / sr / BufDur.kr(bufnum), 0, 1);
	phasor = Select.ar(time_stretch.sign + 1 /2, [
		pos - phasor,
		phasor + pos,
	]);

	//pos = phasor * BufDur.kr(bufnum) + finepos;
	pos = phasor * BufDur.kr(bufnum) + finepos + LFNoise0.kr(randrate,mul:randframes);
	ou = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);
	ou1 = HPF.ar(ou, 7000);
	//ou1 = ou;
	ou2 = LPF.ar(ou, 200);
	//ou = ou1 + ou2;
	ou = Splay.ar(ou, 1, amp);
}).play;
);

Pproto(\)NdefEditor()
WindowDef(\NdefEditor).front(Ndef(\sample))

(
SynthDef(\subbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig1 = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = SelectX.ar(\distmix.kr(0.0), [sig, sig1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\saws, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.01) + 1));
	sig = sig.mean;

	sig1 = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = SelectX.ar(\distmix.kr(0.0), [sig, sig1]);

	sig1 = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = SelectX.ar(\lpmix.kr(0.0), [sig, sig1]);

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar([
			Pbind(
				\instrument, \subbass,
				\distmix, 1,
				\distamp, 2,
				\octave, 3,
				\dur, 1/8,
				\amp, 0.1,
				//\isRest, true,
			),
			Pbind(
				\instrument, \saws,
				\fspread, 0.000125,
				\octave, 3,
				\lpfr, 2,
				\distmix, 0.4,
				\distamp, 2,
				\lpmix, 0.9,
				\dur, 1/8,
				\amp, 0.1,
				//\isRest, true,
			),
			Pbind(\instrument, \doublegran,
				\mbufnum, BufDef.mono("/home/ggz/Musique/sc/samplekit/cfoley/Blastwave FX Foley Vol. 1/ChapStickSlide_S08FO.567.wav"),
				\mbufnum, BufDef.mono('voices/feynman.flac'),
				\mbufnum, BufDef.mono('loop/loop3b_185bpm.flac'),
				\mbufnum, BufDef.mono('voices/kaspi.flac'),
				\pos, Pseq([
					0.8,
					//~pmodenv.(Pseq([0,1,0,0.5]+0.0,1), 4),
				],inf),
				\pos, 0.40,
				//\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
				//\gdur, ~pmodenv.(Pseq([0.1,0.3,0.02],inf), 4),
				\gdur, 0.5,
				\gfreq, 440/2 * Pseq([
					0, -1, 2, 4,
				],inf).midiratio,
				//\gfreq, ~pmodenv.(Pseq([1,1.1]*16/2*~t,1), 8).loop,
				\dephase, 0.01,
				\gfreq, 8*~t,
				\pitch_stretch, 1/2 * Pfunc({ arg ev; ev.use { ( ~freq.value.cpsmidi - (12*5) ).midiratio }  }).trace,
				\dur, 1/4,
				\amp, 0.1,
			),


		].collect { arg pat, idx;
			Pbind(
				\dur, 1,
			) <> pat <> Pbind(
				\note, Pseq([
					0,-1,2,
				],inf),
			);

		});
		
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar([
			Pbind(
				\instrument, \subbass,
				\distmix, 1,
				\distamp, 2,
				\octave, 3,
				\dur, 1/8,
				\amp, 0.1,
				//\isRest, true,
			),
			Pbind(
				\instrument, \saws,
				\fspread, 0.000125,
				\octave, 3,
				\lpfr, 2,
				\distmix, 0.4,
				\distamp, 2,
				\lpmix, 0.9,
				\dur, 1/8,
				\amp, 0.1,
				//\isRest, true,
			),


		].collect { arg pat, idx;
			Pbind(
				\dur, 1,
			) <> pat <> Pbind(
				\note, Pseq([
					0,-1,2,
				],inf),
			);

		}),
			Pbind(\instrument, \doublegran,
				\mbufnum, BufDef.mono("/home/ggz/Musique/sc/samplekit/cfoley/Blastwave FX Foley Vol. 1/ChapStickSlide_S08FO.567.wav"),
				\mbufnum, BufDef.mono('voices/feynman.flac'),
				\mbufnum, BufDef.mono('loop/loop3b_185bpm.flac'),
				\mbufnum, BufDef.mono('voices/kaspi.flac'),
				\pos, Pseq([
					0.7,
					0.4,
					0.8,
					~pmodenv.(Pseq([0,1,0,0.5]+0.0,1), 4),
				],inf),
				//\pos, 0.40,
				//\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
				//\gdur, ~pmodenv.(Pseq([0.1,0.3,0.02],inf), 4),
				\gdur, 0.5,
				\gfreq, 440/2 * Pseq([
					0, -1, 2, 4,
				],inf).midiratio,
				//\gfreq, ~pmodenv.(Pseq([1,1.1]*16/2*~t,1), 8).loop,
				\dephase, 0.01,
				\gfreq, 8*~t,
				\gfreq, ~pmodenv.(Pseq([8,1],1), 8).loop,
				\asr, Pseq([
					[ Env.asr(0.1,0.8,2.1) ],
				],inf),
				\pitch_stretch, 1/2 * Pfunc({ arg ev; ev.use { ( ~freq.value.cpsmidi - (12*5) ).midiratio }  }).trace,
				\dur, 4,
				\legato, 0.3,
				\amp, 0.1,
			),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono(\simplegran,
			\mbufnum, BufDef.mono('loop/loop3b_185bpm.flac'),
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono("/home/ggz/Musique/sc/samplekit/cfoley/Blastwave FX Foley Vol. 1/ChapStickSlide_S08FO.567.wav"),
			\pos, Pseq([
				0.8,
				//~pmodenv.(Pseq([0,1,0,0.5]+0.0,1), 4),
			],inf),
			\pos, 0.43,
			//\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
			\gdur, ~pmodenv.(Pseq([0.1,0.02],inf), 4),
			\gfreq, 440/2 * Pseq([
				0, -1, 2, 4,
			],inf).midiratio,
			\gfreq, ~pmodenv.(Pseq([1,1.1]*16*2*~t,1), 8).loop,
			\pitch_stretch, 1,
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono(\simplegran,
			\mbufnum, BufDef.mono('loop/loop3b_185bpm.flac'),
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono("/home/ggz/Musique/sc/samplekit/cfoley/Blastwave FX Foley Vol. 1/ChapStickSlide_S08FO.567.wav"),
			\pos, Pseq([
				~pmodenv.(Pseq([0,1,0,0.5]+0.0,1), 4),
			],inf),
			\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
			\gdur, ~pmodenv.(Pseq([0.1,0.02],inf), 4),
			\gfreq, 440/2 * Pseq([
				0, -1, 2, 4,
			],inf).midiratio,
			\gfreq, ~pmodenv.(Pseq([50,200,2,1000],1), 8).loop,
			\pitch_stretch, 1,
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
)


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, 'pirodeo',
			\note, Pseq([
				[0,12,12+4,12+9],
				[0,12,12+4,12+10],
				[5,12+5,12+7,12+10],
			],inf),
			\octave, 4,
			\dur, 1,
			\amp, 0.1,
		),	
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, 'pigabberkick',
			\eqstart, 2000,
			\eqrq, 0.3,
			\attack, 0.0010000000474975,
			\decay, 0.0099999997764826,
			\sustain, 0.030000001192093,
			\release, 0.319999999552965,
			\attack_level, 1.0,
			\decay_level, 0.69999998807907,
			\sustain_level, 0.69999998807907,
			\slope_start, 64.0,
			\slope_length1, 0.014999999664724,
			\slope_intermediate, 43.0,
			\slope_length2, 0.10000000149012,
			\boost, 7.0,
			\boost_slide, 0.0,
			\boost_slide_shape, 1.0,
			\boost_slide_curve, 0.0,
			\cutoff, 74.0,
			\cutoff_slide, 0.0,
			\cutoff_slide_shape, 1.0,
			\cutoff_slide_curve, 0.0,
			\res, 0.90000000298023,
			\distamp1, 2,
			\delfreq, 1.9,
			\delrange, 0.001,
			\res_slide, 0.0,
			\res_slide_shape, 1.0,
			\res_slide_curve, 0.0,
			\out_bus, 0.0,
			\freq, 40,
			\legato, 1,
			\dur, 1/1,
			\amp, 0.1,
		),	
	])
)).play;
);




Pbindef(\kick, \instrument, \pigabberkick).edit
Pbindef(\kick, \instrument, \pigabberkick).play


ProtoDef(\piano).startControl(Pdef(\melo))
(
Pdef(\melo, 
	Pbind(
		\instrument, \default,
	)
)
);

