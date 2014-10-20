BufDef(\march, "vipere/march.flac");
(
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,0.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,1.9)).range(0,0.02) + 0.15  });
~buf = BufDef(\march);
~buf = BufDef(\moeten);
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;
//Ndef(~name+++\lfo1, { Phasor.kr(0, (1/SampleRate.ir).poll *1, 0, 0.81) + 0.1 + LFPulse.kr(8).range(0,0.0001).lag(0.1)});
Ndef(~name+++\lfo1, { arg freq=1; SinOsc.kr(freq * t).range(50,\fmax.kr(7500)).lag(0.051)});
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([1,1,16,1,1,8,1,1],inf),
	\freq, 700,
	\fmax, Pseq([
		1000,100,7000,100,
	],inf),
	\dur, 1/1,
));
Ndef(~name+++\lfo3, { arg freq=20; freq.lag(0.401).round(0.1) * SinOsc.kr(1/16*t).range(0.5,1.5).round(0.1)});
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\freq, Pseq([
		2,2,2,2,
		2,4,4,6,
		2,8,2,2,
		2,4,4,6,
	]*250,inf),
	\dur, 1/4,
));
//Ndef(~name+++\lfo1, { 0.1 + LFPulse.kr(1).range(0,0.0008).lag(0.4)});
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,1.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(1.18).range(0,1.02) + 10.45  });
//Ndef(~name+++\lfo2, { LFSaw.kr(SinOsc.kr(1.12).range(0.01,4.9)).range(0.0001,0.0012)  });
Pdef(~name +++ \pre, 
	Pbind(
		\freq, 100,
		\ffreq, 5800,
		\ffreq, Ndef(~name+++\lfo1),
		\freq, Ndef(~name+++\lfo3).bus.asMap,

	) <>
	
	//Sdef(~name, \mypreset).pdef <>
	Pbind(
	\freq, 700,
	\pos, Pseq([0.0,0.01,0.02,0.03],inf),
	\pos, Pseg(Pseq([0,0.1],inf),32)+0.5,
	\pos, 0.3993993993994,
	\pos, 0.1993993993994,
	\fshift, 0,
	\fshift, Pseq([0,48,-40],inf),
	\fshift, -448,
	\pan, Prand([Pseq([0],4),Pseq([0],2), 0,-1,1],inf).stutter(16)/3,
	\lpmix, 1.01,
	\hpmix, 0.0,
	\hpfreq, 10,
	\rq, 0.1,
	\posenv, Pseq([
		//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
		[ Env([0.004,0.0009,0.0071].integrate.postln,[0.02,0.4]) ],
		[ Env([0.004,0.0019,0.0171].integrate.postln,[0.02,0.4]) ],
		[ Env([0.004,0.0009,0.0071].integrate.postln,[0.02,0.4]) ],
		[ Env([0.004,0.0017,0.0171].integrate.postln,[0.02,0.4]) ],

		[ Env([0.004,0.0009,0.0271].integrate.postln,[0.02,0.8]) ],
		[ Env([0.004,0.0019,0.0171].integrate.postln,[0.02,0.4]) ],
		[ Env([0.004,0.0009,0.0071].integrate.postln,[0.02,0.4]) ],
		[ Env([0.004,0.0017,0.0171].integrate.postln,[0.02,0.4]) ],
	],inf),
	\posenv, Prand([
		//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
		//[ Env([0.004,0.0009,0.0071].integrate.postln,[2.42,5.4]) ],
		[ Env([0.004,0.0019,0.2071].integrate.postln,[3.22,5.4]) ],
		[ Env([0.004,0.0009,0.2571].integrate.postln,[3.22,5.4]) ],
	],inf).stutter(16),
	\levelScale, 1,
	\timeScale, 1,
	\range, 0.001,
	\ffreq, Pseq([100,300,200,200],inf),
	\ffreq, Pseq([60,70,100,120],inf),
	\ffreq, Pseq([1000,3000,200,2000],inf),
	\bufnum, ~buf,
	\ffreqtab, Pseq([
		[[2.3,3.2,0.1,0.1, 0.2,0.8,1.2,1.5]],
	],inf),
	\ffreqtab, Pseq([[Array.series(8,0.5,0.1).postln]],inf),
	\ffreqtab, Pseq([[Array.geom(8,4.1,0.8).postln]],inf),
	\ffreqtab, Pn(Plazy({
		[{ 2.rand + 1 } ! 8]
	})),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.3,0.5,0.21) ],
	],inf),
	\legato, 3.0,
	\dur, 1/4,
	\isRest, Pseq([
		0,0,0,0,
		0,0,0,0,
		0,0,0,0,
		0,0,1,0,
	],inf).coin.not,
	\amp, 10 * Pkey(\amp),
));
)

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
