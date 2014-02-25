BufDef(\march, "vipere/march.flac");
(
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,0.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,1.9)).range(0,0.02) + 0.15  });
~buf = BufDef(\march);
~buf = BufDef(\moeten);
Ndef(~name+++\lfo1).quant=Pdef.defaultQuant;
Ndef(~name+++\lfo2).quant=Pdef.defaultQuant;
Ndef(~name+++\lfo3).quant=Pdef.defaultQuant;
~fadeTime = 2;
Ndef(~name+++\lfo1).fadeTime = ~fadeTime;
Ndef(~name+++\lfo2).fadeTime = ~fadeTime;
Ndef(~name+++\lfo3).fadeTime = ~fadeTime;
//Ndef(~name+++\lfo1, { Phasor.kr(0, (1/SampleRate.ir).poll *1, 0, 0.81) + 0.1 + LFPulse.kr(8).range(0,0.0001).lag(0.1)});
//Ndef(~name+++\lfo1, { arg freq; LFPulse.kr(freq * t).range(50,2500).lag(0.1)});
//Ndef(~name+++\lfo1).put(1, \set -> Pbind(
//	\freq, Pseq([8,8,16,4],inf),
//	\dur, 1/2,
//));
Ndef(~name+++\lfo1, { arg freq=800; freq.lag(4.001)});
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([8,2,14,2]*100,inf),
	\freq, 100,
	\dur, PdurStutter(Pseq([1,2,4,8, 1,2,1,8],inf),Pseq([1/4],inf)),
	\dur, 1,
));
//Ndef(~name+++\lfo1, { 0.1 + LFPulse.kr(1).range(0,0.0008).lag(0.4)});
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,1.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(1.18).range(0,1.02) + 10.45  });
//Ndef(~name+++\lfo2, { LFSaw.kr(SinOsc.kr(1.12).range(0.01,4.9)).range(0.0001,0.0012)  });
Ndef(~name+++\lfo2, { arg freq; SinOsc.kr(freq).range(0.01,0.02) + 0.2 });
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	//\freq, Pseq([1,1,4,16,8,8,4,4],inf),
	\freq, Pseq([2,2],inf),
	\dur, 1/2,
));
Ndef(~name+++\lfo3, { arg freq=800, flag=0.1; freq.lag(flag)});
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\freq, Pseq([8,2]*10,inf),
	\flag, Pseq([1,2,1,0.5]/2,inf),
	\freq, 100,
	\freq, Pseq([80,200,1000,100],inf),
	\dur, Pseq([4,2,2,2]/4,inf)
));
Pdef(~name +++ \pre, 
	Pbind(
		//\pos, Ndef(~name+++\lfo2),
		\freq, Ndef(~name+++\lfo3).bus.asMap,
		\ffreq, Ndef(~name+++\lfo1),

	) <>
	
	Sdef(~name, \mypreset).pdef <> Pbind(
	\freq, 100,
	\pos, Pseq([0.0,0.01,0.02,0.03],inf),
	\pos, Pseg(Pseq([0,0.1],inf),32)+0.5,
	\pos, 0.412,
	\posenv, Pseq([
		//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
		[ Env([0.001,0.002,0.004].integrate.postln,[0.01,0.1]) ],
		[ Env([0.001,0.003,0.004].integrate.postln,[0.01,0.1]) ],
		[ Env([0.001,0.0013,0.004].integrate.postln,[0.01,0.1]) ],
	],inf),
	\fshift, 0,
	\fshift, Pseq([0,48,-40],inf),
	\fshift, -148,
	\lpmix, 0.11,
	\rq, 0.4,
	\posenv, Pseq([
		//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
		[ Env([0.004,0.0009,0.0071].integrate.postln,[0.02,0.4]) ],
	],inf),
	//\pos, Ndef(~name+++\lfo1),
	//\pos, Pseq([0,0.1,0.5],inf) + Pwhite(0,0.01),
	//\finepos, Ndef(~name+++\lfo1),
	//\range, Pseg(Pseq([0.001,0.21],inf),8),
	//\range, Ndef(~name+++\lfo2),
	\range, 0.0001,
	\ffreq, Pseq([100,300,200,200],inf),
	\ffreq, Pseq([60,70,100,120],inf),
	\ffreq, Pseq([1000,3000,200,2000],inf),
	\bufnum, ~buf,
	\ffreqtab, Pn(Plazy({
		[{ 2.rand } ! 8]
	})),
	\ffreqtab, Pseq([
		[[2.3,3.2,0.1,0.1, 0.2,0.8,1.2,1.5]],
	],inf),
	\ffreqtab, Pseq([[Array.series(8,0.5,0.1).postln]],inf),
	\ffreqtab, Pseq([[Array.geom(8,0.1,1.2).postln]],inf),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.3,0.5,0.21) ],
	],inf),
	\legato, 0.9,
	//\sustain, 0.2,
	\dur, 1/8,
	\amp, 1 * Pkey(\amp),
));
)

// END
Ndef(~name+++\lfo1).fadeTime = ~fadeTime;
Ndef(~name+++\lfo2).fadeTime = ~fadeTime;
Ndef(~name+++\lfo3).fadeTime = ~fadeTime;
Ndef(~name+++\lfo1).free
Ndef(~name+++\lfo1).end
Ndef(~name+++\lfo2).end
Ndef(~name+++\lfo3).end
Ndef(~name+++\lfo1).stop
Ndef(~name+++\lfo1).release

Ndef(~name+++\lfo1).quant=Pdef.defaultQuant;
Ndef(~name+++\lfo2).quant=Pdef.defaultQuant;

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
