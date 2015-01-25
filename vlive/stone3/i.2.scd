BufDef(\march, "vipere/march.flac");

(
// TAGS: pdef, simple, repetitive, multitimbre, treble

~buf = BufDef(\march);
~buf = BufDef(\moeten);

Pdef(~name +++ \pre, 
	Pbind(
		\finepos, Pseq([0,0,0.0000,0.000],inf) + Pseq([0,0],inf).stutter(16),
		\fineposlag, 4.4,
		\pos, 0.7,
		\range, 0.0000,
		\framerange, 50,
		\amp, Pkey(\amp) * 2,
		\freq, 60.midicps * Pseq([
			Pseq([0],16),
			Pseq([7],16),
		],inf).midiratio.stutter(4) * 8,
		//\freq, 80,
		\isRest, false,
	\bufnum, ~buf,
	\ffreqtab, Pseq([[Array.geom(8,1.0,1.01).postln]],inf),
	\posenv, Pseq([
		[ Env([0.00,0.0020,0.0300].integrate.postln,[0.02,8.4]) ],
		[ Env([0.00,0.0010,0.0000].integrate.postln,[0.42,8.4]) ],
	],inf).stutter(32),
	\isRest, Pseq([
		1,0,1,0,
	],inf).coin.not,
	\dur, 1/8,
	\legato, Pseq([
		Pseq([
			1
		],4),
	],inf),
	\lpmix, 1,
	\hpmix, 1,
	\ffreq, 14400,
	\hpfreq, 10700,
	
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
