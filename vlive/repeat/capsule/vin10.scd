~t = 185/4/60; TempoClock.default.tempo = ~t;

Pdef(\part).clear;
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,

					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,1,0,
					1,0,0,1, 0,0,0,1,
					1,1,1,0, 0,0,0,0,

				Pseq([
					1,0,0,0, 0,0,0,0,
					
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
			\gain, 0.3,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1719].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1064].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,1,
						1,0,1,0, 0,0,0,0,
			
						1,0,0,0, 0,0,0,1,
						1,0,0,0, 0,0,1,0,
						1,0,0,1, 0,0,0,1,
						1,1,1,0, 0,0,0,0,
			
					Pseq([
						1,0,0,0, 0,0,0,0,
			
					],4),
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.3,
				\isRest, true,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1719].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1064].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.31,
			),
		]),

		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\out, BusDef(\sendbus1, \audio),
		)<>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,1,
						1,0,1,0, 0,0,0,0,
		
						1,0,0,0, 0,0,0,1,
						1,0,0,0, 0,0,1,0,
						1,0,0,1, 0,0,0,1,
						1,1,1,0, 0,0,0,0,
		
					Pseq([
						1,0,0,0, 0,0,0,0,
		
					],inf),
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.3,
				\isRest, true,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1719].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1064].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,1,0,1,
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.31,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, Pseq([
					~buflib.hat[1836].value,
					~buflib.hat[1836].value,
					~buflib.hat[1833].value,
					~buflib.hat[1834].value,
					~buflib.hat[1835].value,
					~buflib.hat[1836].value,
					~buflib.hat[1840].value,
				],inf),
				\isRest, Pseq([
					1,1,1,0, 0,0,0,0,
					0,0,0,0, 0,0,1,1,
					1,1,0,1, 0,1,1,0,
					0,0,0,0, 0,0,1,1,
				],inf).coin.not,
				\dur, 1/8,
				//\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.31,
			),
		
		]),
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					5,4,3,2,
				],inf),
				\octave, 3,
				\lag, 0.04,
				\legato, Pseq([
					1,0,0,0, 0,0,0,0,
					1,1,1,0, 0,1,1,0,
				],inf)/2,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.2,
			),
	]),
)).play;
);

(
Pdef(\part, Pdef(\bassyloop1, 
	Ppar([
		Pbind(
			\out, BusDef(\sendbus1, \audio),
		)<>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,1,
						1,0,1,0, 0,0,0,0,
		
						1,0,0,0, 0,0,0,1,
						1,0,0,0, 0,0,1,0,
						1,0,0,1, 0,0,0,1,
						1,1,1,0, 0,0,0,0,
		
					Pseq([
						1,0,0,0, 0,0,0,0,
		
					],4),
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.3,
				\isRest, true,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,1,0,1,
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.31,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, Pseq([
					~buflib.hat[1836].value,
					~buflib.hat[1836].value,
					~buflib.hat[1833].value,
					~buflib.hat[1834].value,
					~buflib.hat[1835].value,
					~buflib.hat[1836].value,
					~buflib.hat[1840].value,
				],inf),
				\isRest, Pseq([
					1,1,1,0, 0,0,0,0,
					0,0,0,0, 0,0,1,1,
					1,1,0,1, 0,1,1,0,
					0,0,0,0, 0,0,1,1,
				],inf).coin.not,
				\dur, 1/8,
				//\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.31,
			),
		
		]),
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					-1,-2,
				],inf),
				\octave, 3,
				\lag, 0.04,
				\legato, Pseq([
					1,0,0,1, 0,0,0,0,
					1,0,1,1, 0,0,1,0,
				],inf)/2,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.2,
			),
	]),
)).play;
);


FileSystemProject.load("libdef/pdeftrack.scd");
FileSystemProject.load("libdef/apc.scd");
Pdef(\pdefgrid0_0, Pdef(\bassyloop1));
Pdef(\pdefgrid0_0, Pbind(\note, Pseq([0,1],inf), \dur, 1/8));
Pdef(\pdefgrid0_1, Pbind(\note, Pseq([3,4],inf), \dur, 1/8));
TrackDef(\pdefgrid).edit
ProtoDef(\apc40).activate(TrackDef(\pdefgrid));

ProtoDef(\apc40).map_rdn_to_bank(0, \rdn, [\delay, \delay2, \fb, \distamp, \mix, \pitchmix]);
ProtoDef(\apc40).activate_bank_selector
MKtl.find(\midi); // when was not connected

Spec.add(\mix, \unipolar)


MKtl(\apc).

ProtoDef(\apc40).mapParam(\xfader, Param(ProtoDef(\rdn).proxy, \mix))


///////////


(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	sig = 8.collect { arg xx;
		lfo1 = SinOsc.ar(\fac1.kr(0.1)) * \fac2.kr(0.1)  * xx + 1; 
		SinOsc.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.1) * lfo1 + 1));
	}.flat;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
}).play;
);

WindowDef(\NdefEditor).front(Ndef(\zed))

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var fac1, fac2, fspread;
	lfo2 = ( SinOsc.ar(\fac4.kr(0.1)) * 1 + 1 ) * \fac3.kr(0.0001);
	fac1 = SinOsc.ar(freq * lfo2) * \fac1.kr(0.1) + 1;
	fac2 = SinOsc.ar(freq * lfo2) * \fac2.kr(0.1) + 1;
	fspread = SinOsc.ar(freq * lfo2) * \fspread.kr(0.1) + 1;
	sig = 8.collect { arg xx;
		lfo1 = SinOsc.ar(fac1) * fac2 * xx + 1; 
		SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread * lfo1 + 1));
	}.flat;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
SynthDef(\rizmok, { arg out=0, gate=1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var fac1, fac2, fspread;
	var freq;
	var sap;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;

	sap = Amplitude.ar(in).poll;

	sig = sig + Fb({ arg fb;
		var isig;
		var isig2;
		isig = ( fb * \fb.kr(1) * sap ) + sig;

		4.do {
			isig = DelayL.kr(isig, 1,\delay.kr(0.001) * ( SinOsc.ar((1.5)*\delfreq.kr(1)) * \dellfo.kr(0.4) + 1 ) ).mean + (isig * \damp.kr(1));
		};
		isig = isig * \iamp.kr(1);
		isig2 = ( isig*\distamp.kr(10) ).distort * \distpostamp.kr(1/2);
		isig = SelectX.ar(\distmix.kr(0.5), [isig, isig2]);
	
		isig = Limiter.ar(isig);
		isig;
	});

	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\speed, Pseg(Pseq([1,0.1,2],inf),8),
			\dur, 1/8,
			\gain, 0.3,
			\out, BusDef(\fx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1219].value,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
			\sustain, 2,
			\out, BusDef(\fx1, \audio),
		),
		Pmono(\rizmok,
			\inbus, BusDef(\fx1, \audio),
			\dellfo, 0.00001,
			\delfreq, ~pmodenv.(Pseq([0.001,2,21,4],inf), 8),
			\fb, 14.9,
			\delay, ~pmodenv.(Pseq([0.01,2],inf), 8),
			\gain, 0.3,
			\mix, 1,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\fx1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,1,
						1,0,1,0, 0,0,0,0,
			
						1,0,0,0, 0,0,0,1,
						1,0,0,0, 0,0,1,0,
						1,0,0,1, 0,0,0,1,
						1,1,1,0, 0,0,0,0,
			
					Pseq([
						1,0,0,0, 0,0,0,0,
			
					],inf),
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.3,
				\isRest, true,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1719].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1064].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.31,
			),
		]),

		Pmono(\rizmok,
			\inbus, BusDef(\fx1, \audio),
			\dellfo, 0.8,
			\delfreq, 100,
			\fb, 500000.9,
			\distamp, 30,
			\distmix, 0.99,
			\damp, 0.51,
			\delay, 0.001001,
			\gain, 0.2,
			\mix, 1,
			\dur, 1,
			\isRest, true,
		),
		
	])
)).play;
);



(
SynthDef(\fmthree, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var bi;
	bi = ([-1,1] * \fmbi.kr(0) + 1);
	lfo1 = ( SinOsc.kr(freq * \fmfac.kr(1)) * bi * \fmamp.kr(1) + 1 );
	sig1 = SinOsc.ar(freq * lfo1);
	sig2 = LFSaw.ar(freq * lfo1);
	sig3 = LFCub.ar(freq * lfo1);
	sig = SelectX.ar(\oscmix.kr(0.5)*2, [sig1, sig2, sig3]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * SinOsc.ar(\amfac.kr(1)).unipolar; 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig.postln;
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);



(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \fmthree,
			\fmbi, 0.01,
			\oscmix, 0.6,
			\oscmix, ~pmodenv.(Pseq([0,1],inf), 8),
			\fmfac, ~pmodenv.(Pseq([4,1],1), 8).loop,
			\fmfac, Pstep(Pseq([0,1,2,1/4,1/5],inf),1),
			\lpfr, 4,

			\note, Pseq([
				4,3,3,3,
				4,3,3,3,
			],inf),
			\octave, 4,
			\legato, Pseq([
				1,3,0,0, 2,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \fmthree,
				\fmbi, 0.01,
				\oscmix, 0.6,
				\oscmix, ~pmodenv.(Pseq([0,1],inf), 8),
				\fmfac, ~pmodenv.(Pseq([4,1],1), 8).loop,
				\fmfac, Pstep(Pseq([0,1,2,1/4,1/5],inf),1),
				\lpfr, 4,
			
				\note, Pseq([
					4,3,3,3,
					4,3,3,3,
				],inf),
				\octave, 4,
				\legato, Pseq([
					1,3,0,0, 2,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/4,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \fmthree,
				\fmbi, 0.01,
				\oscmix, 0.6,
				\oscmix, ~pmodenv.(Pseq([0,1],inf), 1),
				\fmfac, Pstep(Pseq([0,1/2,1/4,1/5],inf),1),
				\lpfr, 4,
			
				\note, Pseq([
					Pseq([
						0,-1,-3,-4,
					],1).stutter(8*2),
				],inf),
				\octave, 5,
				\legato, Pseq([
					8,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/4,
				\amp, 0.1,
			),
		]),
		
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,

					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,1,0,
					1,0,0,1, 0,0,0,1,
					1,1,1,0, 0,0,0,0,

			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
			\gain, 0.3,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1719].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1064].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		
	])
	])
)).play;
);

(
Pdef(\part, Pdef(\bassyloop1, 
	Ppar([
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \fmthree,
				\fmbi, 0.01,
				\oscmix, 0.6,
				\oscmix, ~pmodenv.(Pseq([0,1],inf), 8),
				\fmfac, ~pmodenv.(Pseq([4,1],1), 8).loop,
				\fmfac, Pstep(Pseq([0,1,2,1/4,1/5],inf),1),
				\lpfr, 4,
			
				\note, Pseq([
					4,3,3,3,
					4,3,3,3,
				],inf),
				\octave, 4,
				\legato, Pseq([
					1,3,0,0, 2,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/4,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \fmthree,
				\fmbi, 0.01,
				\oscmix, 0.6,
				\oscmix, ~pmodenv.(Pseq([0,1],inf), 1),
				\fmfac, Pstep(Pseq([0,1/2,1/4,1/5],inf),1),
				\lpfr, 4,
			
				\note, Pseq([
					Pseq([
						0,-1,-3,-4,
					],1).stutter(8*2),
				],inf),
				\octave, 5,
				\legato, Pseq([
					8,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/4,
				\amp, 0.1,
			),
		]),
		Pbind(\out, BusDef(\sendbus3, \audio)) <>
		Ppar([
			
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1019].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 1,0,0,0,
					0,0,0,1, 1,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
		]),
		Pbind(
			\out, BusDef(\sendbus1, \audio),
		)<>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,1,
						1,0,1,0, 0,0,0,0,
		
						1,0,0,0, 0,0,0,1,
						1,0,0,0, 0,0,1,0,
						1,0,0,1, 0,0,0,1,
						1,1,1,0, 0,0,0,0,
		
					Pseq([
						1,0,0,0, 0,0,0,0,
		
					],4),
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.3,
				\isRest, true,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,1,0,1,
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.31,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, Pseq([
					~buflib.hat[1836].value,
					~buflib.hat[1836].value,
					~buflib.hat[1833].value,
					~buflib.hat[1834].value,
					~buflib.hat[1835].value,
					~buflib.hat[1836].value,
					~buflib.hat[1840].value,
				],inf),
				\isRest, Pseq([
					1,1,1,0, 0,0,0,0,
					0,0,0,0, 0,0,1,1,
					1,1,0,1, 0,1,1,0,
					0,0,0,0, 0,0,1,1,
				],inf).coin.not,
				\dur, 1/8,
				//\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.31,
			),
		
		]),
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					-1,-2,
				],inf),
				\octave, 3,
				\lag, 0.04,
				\legato, Pseq([
					1,0,0,1, 0,0,0,0,
					1,0,1,1, 0,0,1,0,
				],inf)/2,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.2,
			),
	]),
)).play;
);


ClipTimeline(\vin10).edit
ClipTimeline(\vin10_t1).edit


(
Pdef(\part, Pdef(\intro1, 
	Ppar([

		Pbind(\out, BusDef(\sendbus1, \audio)) <> // creazysnare rdn
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					Pseq([
						0
					],8*6),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
		]),
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,1,
						1,0,1,0, 0,0,0,0,
			
						1,0,0,0, 0,0,0,1,
						1,0,0,0, 0,0,1,0,
						1,0,0,1, 0,0,0,1,
						1,1,1,0, 0,0,0,0,
			
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 1,0,0,0,
					],4),
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0.51,0,
					0,0,0,0.2, 1,0,0.1,0.51,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				\bufnum, Pseq([
					~buflib.hat[1065].value,
					~buflib.hat[1066].value,
					~buflib.hat[1065].value,
					~buflib.hat[1060].value,
					~buflib.hat[1061].value,
				],inf).stutter(4),
				\isRest, Pseq([
					Prand([
						Pseq([
							1,0,0,1, 0,1,1,1,
						],1),
						Pseq([
							1,1,0,0, 0,0,1,1,
						],1),
						Pseq([
							1,1,1,1, 1,1,1,1,
						],1),
						Pseq([
							1,0,1,0, 1,0,1,0, 
						],1),
					],1),
				],inf).coin.not,
				\sustain, 0.2,
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([0,1,0,-1],inf))),
				\gain, 0.31,
				\gain, Pkey(\gain) * Pseq([
					Prand([
						Pseq([
							1,1,1,1,
						],1),
						Pseq([
							1,0.4,1,0.67,
						],1),
						Pseq([
							1,1,0.5,0.5,
						],1),
						Pseq([
							0.6,1,0.6,0.67,
						],1),
						Pseq([
							0.6,0.6,0.6,1,
						],1),
					],1),
				],inf),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, Pseq([
					~buflib.hat[1836].value,
					~buflib.hat[1836].value,
					~buflib.hat[1833].value,
					~buflib.hat[1834].value,
					~buflib.hat[1835].value,
					~buflib.hat[1836].value,
					~buflib.hat[1840].value,
				],inf),
				\isRest, Pseq([
					0,1,0,1,0, 1,0,1, 
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1,
					1,1,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.31,
				\isRest, true,
			),
		]),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\intro1, 
	Ppar([

		Pbind(\out, BusDef(\sendbus1, \audio)) <> // creazysnare rdn
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					Pseq([
						0
					],8*6),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
		]),
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
						1,0,1,0, 0,0,0,0,
						1,1,0,0, 0,0,0,0,
			
				],inf).coin.not,
				\dur, 1/4,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,1,
					0,0,1,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/4,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, Pseq([
					~buflib.hat[1836].value,
				],inf),
				\isRest, Pseq([
					1,
				],inf).coin.not,
				\isRest, Pseq([
					0,1,0,1, 0,1,1,0, 
					0,0,1,1, 0,1,1,1, 
				],inf).coin.not,
				\dur, 1/4,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.31,
			),
		]),
		
	])
)).play;
);

(
BufDef(\amen, "vipere/amenbreak.wav");
Pdef(\part, Pdef(\intro1, 
	Ppar([

		Pbind(\out, BusDef(\sendbus1, \audio)) <> // creazysnare rdn
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					Pseq([
						0
					],8*6),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
		]),
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([

			Pseq([
				Pfindur(8,Pmono(
					\playersec,
					\bufnum, BufDef(\amen),
					\degree, Pseq([0],inf),
					\speed, 4*~t/(137/60),
					\speed, 1/2*~t/(137/60),
					\pos, Pseg(Pseq([0,1],inf),8),
					\legato, 0.9981,
					\dur, 1,
					\pos, Pkey(\dur) * Pkey(\speed) * Prand([
						0,7,
					],inf)/2,
					\amp, 0.1
				)),
				//Event.silent(4)
			],inf),
		]),
		
	])
)).play;
);
