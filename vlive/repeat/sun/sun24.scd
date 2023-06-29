
// black metal rebel
~t = 150/4/60; TempoClock.default.tempo = ~t;


(
SynthDef(\gregrain_norm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mbufnum, pitch_stretch=1, pos=0, gdur=0.1;
	var sig, clk;
	clk = Impulse.ar(freq);
	pan = Dseq([1,0.4,-1,0.1,-0.9],inf);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = HPF.ar(sig, \hpf.kr(180));
	sig = LPF.ar(sig, \lpf.kr(18000));
	sig = Normalizer.ar(sig);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

(
SynthDef(\gregrain_norm_ienv, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mbufnum, pitch_stretch=1, pos=0, gdur=0.1;
	var sig, clk;
	clk = Impulse.ar(freq);
	pan = Dseq([1,0.4,-1,0.1,-0.9],inf);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = HPF.ar(sig, \hpf.kr(180));
	sig = LPF.ar(sig, \lpf.kr(18000));
	sig = Normalizer.ar(sig);
	sig = sig * EnvGen.kr(\ienv.kr(Env([0,0,1,0],[0,0.1,0.8])), Trig.kr(\itrig.tr(1), \ienvdur.kr(1)));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)


(
Pdef(\xbass1, 
	Pmono(
		\gregrain_norm,
		\mbufnum, BufDef.mono('vipere/petanque.flac'),
		\pos, 1.0,
		\pos, ~pmodenv.(Pseq([1,1.01]+2,1), 8).loop,
		\pitch_stretch, 1,
		//\pitch_stretch, ~pmodenv.(Pseq([1,0.1],1), 8).loop,
		\gdur, 0.1/2,
		//\gdur, Pwhite(0.1,0.2,inf),
		\gdur, ~pmodenv.(Pseq([0.001,0.0002],1), 8).loop,
		//\freq, 300,
		\note, Pseq([
			0,12,-12,
			0,0,0,
			-12,-12,-12,
			0,0,0,
			0,0,0,
			0,0,0,
			-12,-12,-12,
			-12,-12,-12,
			-12,-12,-12,
		],inf) +
		Pseq([
			0,-3,-1,-1
		],inf).stutter(8),
		\lpf, 2000,
		\lpf, ~pmodenv.(Pseq([20,200,20,2000,20,10000],1), 1).loop,
		\hpf, 60,
		\octave, 4,
		//\freq, 60,
		//\freq, ~pmodenv.(Pseq([30,92],1), 8).loop,
		\gain, 1/4,
		\dur, Pn(1/8,inf),
	),
).play;
);

(
Pdef(\xbass1, 
	Pmono(
		\gregrain_norm,
		\mbufnum, BufDef.mono('vipere/petanque.flac'),
		\pos, 1.0,
		\pos, ~pmodenv.(Pseq([1,1.01]+2,1), 8).loop,
		\pitch_stretch, 1,
		//\pitch_stretch, ~pmodenv.(Pseq([1,0.1],1), 8).loop,
		\gdur, 0.1/2,
		//\gdur, Pwhite(0.1,0.2,inf),
		\gdur, ~pmodenv.(Pseq([0.001,0.0002],1), 8).loop,
		//\freq, 300,
		\note, Pseq([
			0,12,-12,
			0,0,0,
			-12,-12,-12,
			0,0,0,
			0,0,0,
			0,0,0,
			-12,-12,-12,
			-12,-12,-12,
			-12,-12,-12,
		],inf) +
		Pseq([
			0,-3,-1,-1
		],inf).stutter(8),
		\lpf, 2000,
		\lpf, ~pmodenv.(Pseq([20,200,20,2000,20,10000],1), 1).loop,
		\hpf, 60,
		\octave, 4,
		//\freq, 60,
		//\freq, ~pmodenv.(Pseq([30,92],1), 8).loop,
		\gain, 1/4,
		\dur, Pn(1/8,inf),
	),
).play;
);

(
Pdef(\xbass1, 
	Pmono(
		\gregrain_norm_ienv,
		\mbufnum, BufDef.mono('vipere/petanque.flac'),
		\pos, 1.0,
		\pos, ~pmodenv.(Pseq([1,1.01]+2,1), 8).loop,
		\pitch_stretch, 1,
		//\pitch_stretch, ~pmodenv.(Pseq([1,0.1],1), 8).loop,
		\gdur, 0.1/2,
		//\gdur, Pwhite(0.1,0.2,inf),
		\gdur, ~pmodenv.(Pseq([0.001,0.0002],1), 8).loop,
		//\freq, 300,
		\itrig, 1,
		\ienvdur, 1/13,
		\ienv, 
		Pseq([
			Pser([
				[ Env([0,0,1,0],[0,0.01,0.4]) ],
			],8*3+5),
			Pseq([
				[ Env([0,0,1,0],[0,0.01,0.05]) ],
			],3),
		],inf),
		\note, Pseq([
			0,0,1,4, 1,\r,\r,\r,
			1,1,1,1, 0,0,-4,\r,
			0,0,1,4, 1,\r,\r,\r,
			1,1,1,0, -4,-4,-4,-4,
		],inf),
		\lpf, 2000,
		\lpf, ~pmodenv.(Pseq([20,200,20,2000,20,10000],1), 1).loop,
		\hpf, 60,
		\octave, 4,
		//\freq, 60,
		//\freq, ~pmodenv.(Pseq([30,92],1), 8).loop,
		\gain, 1/4,
		\dur, Pn(1/8,inf),
	),
).play;
);

NoteTimeline(\bla).edit


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\xbass1),
		Pseq([
			Event.silent(4),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[2468].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],4+4).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		],1),
		Pseq([
			Event.silent(8),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1395].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0, 1,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,1,
				],2).coin.not,
				\legato, Pseq([
					1, 0.41, 0.41, 0.41,
				],inf),
				\dur, 1/16,
				\gain, 0.1,
			),
		],1),

		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pbind(
				\instrument, \playersec_hlpf,
				\bufnum, ~buflib.kick[1395].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,0,0, 1,0,1,0, 1,0,0,0,
					1,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],4).coin.not,
				\hpmix, 1,
				\hpf, 400,
				\legato, Pseq([
					1, 0.41, 0.41, 0.41,
				],inf),
				\dur, 1/16,
				\gain, 0.1,
				//\isRest, true,
			),
		],1),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[2132].value,

			\bufnum, ~buflib.snare[787].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
					1,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 1,0,1,0, 1,0,0,0,
					1,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.01,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/16,
			\gain, 0.41,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
					1,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 1,0,1,0, 1,0,0,0,
					1,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
			\isRest, true,
		),
		Pseq([
			Pbind(
				\instrument, \playersec,
				\bufnum, [
					~buflib.snare[2468].value,
					~buflib.snare[2132].value,
				],
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,1,1,0,
				],4).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain,[0.1/2, 0.41],
			),
		],1),
		
	])
)).play;
);
