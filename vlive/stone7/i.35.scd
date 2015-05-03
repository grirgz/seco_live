BufDef(\march, "vipere/march.flac");
(
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,0.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,1.9)).range(0,0.02) + 0.15  });
~buf = BufDef(\march);
~buf = BufDef(\moeten);
//~buf = BufDef(\scream);
~buf = BufDef(\scream, "vipere/scream.flac");
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;
//Ndef(~name+++\lfo1, { Phasor.kr(0, (1/SampleRate.ir).poll *1, 0, 0.81) + 0.1 + LFPulse.kr(8).range(0,0.0001).lag(0.1)});
Ndef(~name+++\lfo1, { arg freq=1; SinOsc.kr(freq * t).range(6050,7500).lag(0.051)});
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([4,2,6,8],inf),
	\dur, 1/1,
));
Ndef(~name+++\lfo2, { arg freq=1, xlag=0; freq.lag(xlag) * \xfac.kr(1)});
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	\freq, Pseq([
		100,140,50,120,
		100,140,50,120,
		100,140,50,120,
		100,40,50, 1000,
	],inf)/1,
	\freq, 100,
	\xlag, Pseq([
		0,0.2,2,0.1,
		1,0.2,2,0.1,
		1,1,1,1,
		0,0,0,0,
	],inf),
	\dur, 1/4,
));
Ndef(~name+++\lfo3, { arg freq=20; freq.lag(4.401)});
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\freq, Pseq([
		0,0.001, 0, 0.002,
	],inf)/100,
	\dur, 1,
));
//Ndef(~name+++\lfo1, { 0.1 + LFPulse.kr(1).range(0,0.0008).lag(0.4)});
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,1.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(1.18).range(0,1.02) + 10.45  });
//Ndef(~name+++\lfo2, { LFSaw.kr(SinOsc.kr(1.12).range(0.01,4.9)).range(0.0001,0.0012)  });
//Ndef(~name+++\lfo2, { SinOsc.kr(1*~t).range(50,170 * SinOsc.kr(1/16*~t).exprange(0.01,1))  });
Pdef(~name +++ \pre, 
	Pbind(

		\instrument, \oscsampler_freqtab,
		\finepos, Ndef(~name+++\lfo3),
		//\finepos, 0.0,
		\pos, 0.82 + Pseq([0.001,0,0.002]/10,inf),
		\pos, 0.4,
		\fineposlag, 0,
		\framerange, Ndef(~name+++\lfo2),
		//\framerange, 100,
		\range, 0.0000,
		\amp, Pkey(\amp) * 2,
		\freq, 200 * 2,
		\freqtab, (Pseq([1,2],16) +.x Pseq([
			[ [0-12,5,8,5+12] ],
			[ [0,4,8,4+12] ],
			[ [0,5,7,5+12] ],
			[ [0,4,7,4+12] ],
		],inf)).midiratio
		//.collect({ arg val;
		//	[
		//		val[0].collect({ arg sval;
		//			sval = sval * (1+ ( 0.051.rand ) );
		//		});
		//	]
		//})
		.stutter(8),
		\bufnum, ~buf,
		\adsr, Pseq([
			[ Env.adsr(0.1,0.0,1.0,0.1) ],
		],inf),
		\ffreqtab, Pseq([[Array.geom(8,1.0,1.01).postln]],inf),
		\isRest, Pseq([
			Prand([
				Pseq([
					1,
				],1),
			],1),
		],inf).coin.not,
		\posenv, Pseq([
			[ Env([0.00,0.00001,0.0001].integrate.postln,[0.2,8.4]) ],
			//Pfunc({ arg ev;
			//	[ Env([0.00,0.0000001,ev[\posenvrel]].integrate.postln,[0.2,8.4]) ];
			//}),
		],inf).stutter(32),
		\amp, Pkey(\amp) * Pseq([
			1,1,1,1, 1,1,0.31,1,
		],inf),
		\dur, 1/4,
		\legato, Pseq([
			Prand([
				3,4,5,
			],1),
			Prand([
				4,4.5,
			],1),

		],inf)/2,
		\lpmix, 1,
		\hpmix, 1,
		\rq, 1,
		\ffreq, 1400,
		\hpfreq, 40,
	)
	<> ~dPdef.(~name+++\premac)
	<> Pbind(\posenvrel, 0.001)
)
);

// END

~set_macro.(\k1, Pdef(~name+++\macro), \ffreq, \freq);
~set_macro.(\k2, Pdef(~name+++\macro), \hpfreq, \freq);
~set_macro.(\k3, Ndef(~name+++\lfo2), \xfac, ControlSpec(0.1,4,\exp));
~set_macro.(\k4, Pdef(~name+++\premac), \levelScale, ControlSpec(0.1,14.51,\exp));
~set_macro.(\k5, Pdef(~name+++\macro), \legato, ControlSpec(0.1,2.51,\exp));
Pdef(~name+++\macro).setBusMode(\ffreq);
Pdef(~name+++\macro).setBusMode(\hpfreq);

Sdef(~name, \mypreset).rebuild
Sdef(~namex, \mypreset).edit
Sdef(~namex, \mypreset).rebuild(true)
a = IdentityDictionary.new; a.putPairs( Sdef(~namex, \mypreset).specs ); a[\fshift]
Sdef(~namex, \mypreset).get(0,0)
Sdef(~name, \mypreset).active_subindex
Sdef(~name, \mypreset).all[0][0] = nil
~score_storage.all['1'][\mypreset] = nil

Pdef.all.do { arg x; x.postln; }

Pdef('1.0.mypreset').source.asCompileString
Pdef('1.0.mypreset').play
