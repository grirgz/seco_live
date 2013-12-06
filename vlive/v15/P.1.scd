BufDef(\march, "vipere/march.flac");
(
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,0.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,1.9)).range(0,0.02) + 0.15  });
~buf = BufDef(\moeten);
~buf = BufDef(\march);
//Ndef(~name+++\lfo1, { Phasor.kr(0, (1/SampleRate.ir).poll *1, 0, 0.81) + 0.1 + LFPulse.kr(8).range(0,0.0001).lag(0.1)});
//Ndef(~name+++\lfo1, { 0.1 + LFPulse.kr(1).range(0,0.0008).lag(0.4)});
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,1.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(1.18).range(0,1.02) + 10.45  });
//Ndef(~name+++\lfo2, { LFSaw.kr(SinOsc.kr(1.12).range(0.01,4.9)).range(0.0001,0.0012)  });
~lfolagpat = { arg name, pat;
	var first_val;
	var first_lag;
	var ndef;
	var str;
	var ev;
	if(name.asString[0] == $_) {
		\bla;
	} {
		str = pat.asStream;
		ev = str.next(Event.default);
		first_val = ev[\val];
		first_lag = ev[\vlag];
		first_val.debug("firstval");
		ndef = Ndef(~name+++name, { arg val=first_val, vlag=first_lag; 
			var sig;
			sig = val.lag(vlag);
			//sig.poll(name:name);
			sig;
		});
		Ndef(~name+++name).put(1, \set -> pat);
		Ndef(~name+++name).quant = Pdef.defaultQuant;
		ndef = Ndef(~name+++name);
		ndef;
	}
};
~lfolag = { arg name, val, lag, dur;
	~lfolagpat.(name, Pbind(\val, val, \vlag, lag, \dur, dur));
};
Pdef(~name +++ \pre, 
	Pbind(
		//\freqshift, Pkey(\freqshift) + Pseq([100,-100,0],inf),
		//\fshift, Pseq([100,-100,0],inf),
		//\ffreq, 9000,
		\freq, 100,
		//\range, 1,
		//\posenv, Pseq([
		//	Sdef(~name, \mypreset).get(0).vals[\posenv].vpattern(1),
		//	//Sdef(~name, \mypreset).get(1).vals[\posenv].vpattern(1),
		//],inf).stutter(32),
		\range, \bla,
		\range, ~lfolag.(\lfo3,
			Pseq([
				0.01,0.0001,0,0.1,
				0.00001,0.0001,0.0001,0.0001,
			],inf),
			Pseq([0.4,1,0.4,0.4],inf),
			1/4,
		).bus.asMap,
		\range, 0.0001,
		\ffreq, ~lfolag.(\_lfo2,
			Pseq([
				Pser([500,9100,100,10000],32),
				Pser([50,900,40,1000],16),
				Pser([15000,9100,2100,10000],16),
			],inf),
			0.1,
			1/8,
		),
		\ffreq, ~lfolagpat.(\lfo2, Pbind(
			\val, Pseq([
				Pser([500,9100,100,10000],32),
				Pser([50,900,40,1000],16),
				Pser([15000,9100,2100,10000],16),
			],inf),
			\val, Pseq([1000,50,15000],inf),
			\dur, 1/2,
			\vlag, Pkey(\dur) * 1.0,
		)),

	) <>

	Pseq([
			Pfin(16,Sdef(~name, \mypreset).get(0).pbind),
			Pfin(16,Sdef(~name, \mypreset).get(1).pbind),

	],inf) <>
	
	//Sdef(~name, \mypreset).pdef <>
	Pbind(
		\posenv, Pseq([
			Sdef(~name, \mypreset).get(0).vals[\posenv].vpattern(1),
			Sdef(~name, \mypreset).get(1).vals[\posenv].vpattern(1),
		],inf).stutter(32),
		//\freq, ~lfolag.(\lfo2,
		//	Pseq([500,1000,5000,50],inf),
		//	Pseq([0,1,0,0],inf),
		//	1/4
		//).bus.asMap,
		//\ffreq, ~lfolag.(\lfo1,
		//	Pseq([5100,100,9000,50],inf),
		//	Pseq([0.1,0.01,0,0],inf),
		//	1/8
		//).bus.asMap,
		\ffreq, 100,
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
	\legato, 0.5,
	\amp, 1 * Pkey(\amp),
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
