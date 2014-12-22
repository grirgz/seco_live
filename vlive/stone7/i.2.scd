BufDef(\march, "vipere/march.flac");
(
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,0.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,1.9)).range(0,0.02) + 0.15  });
~buf = BufDef(\march);
~buf = BufDef(\moeten);
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;
//Ndef(~name+++\lfo1, { Phasor.kr(0, (1/SampleRate.ir).poll *1, 0, 0.81) + 0.1 + LFPulse.kr(8).range(0,0.0001).lag(0.1)});
Ndef(~name+++\lfo1, { arg freq=1; SinOsc.kr(freq * t).range(6050,7500).lag(0.051)});
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([4,2,6,8],inf),
	\dur, 1/1,
));
Ndef(~name+++\lfo3, { arg freq=20; freq.lag(4.401)});
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\freq, Pseq([
		0,0.001, 0, 0.002,
	],inf),
	\dur, 1,
));
//Ndef(~name+++\lfo1, { 0.1 + LFPulse.kr(1).range(0,0.0008).lag(0.4)});
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,1.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(1.18).range(0,1.02) + 10.45  });
//Ndef(~name+++\lfo2, { LFSaw.kr(SinOsc.kr(1.12).range(0.01,4.9)).range(0.0001,0.0012)  });
Ndef(~name+++\lfo2, { 
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = SinOsc.kr(2*~t).range(0.50,170 * SinOsc.kr(1/16*~t).exprange(0.01,1))  ;
	sig2 = SinOsc.kr(8*~t).range(0.50,170 * SinOsc.kr(1/16*~t).exprange(0.01,1))  ;
	sig = SelectX.kr( SinOsc.kr(1/17).range(0,1), [sig1, sig2]);
});
Pdef(~name +++ \pre, 
	Pbind(
		\instrument, ~name+++\b,
		\phase, 0 + Pseg(Pseq([0,0.1],inf),8),
		\fmamp1, Ndef(~name+++\lfo2),
		\freq, 400 * 2 * Pseq([
			Pseq([1],16) + [0,5,8,5+12],
			Pseq([1],16) + [0,4,8,4+12],
			Pseq([1],16) + [0,5,7,5+12],
			Pseq([1],16) + [0,4,7,4+12],
		],inf).midiratio.stutter(2) ,
	\isRest, Pseq([
		Prand([
			Pseq([
				1,
			],1),
		],1),
	],inf).coin.not,
	\amp, Pkey(\amp) * Pseq([
		1,1,1,1, 1,1,0.31,1,
	],inf),
	\dur, 1/8,
	\legato, Pseq([
		Prand([
			3,4,5,
		],1),
		Prand([
			4,4.5,
		],1),
		
	],inf)/2 * Ptuple({Pwhite(1,1.01)}!3),
	
	)
)
);

// END

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
