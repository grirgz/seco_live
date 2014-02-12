BufDef(\march, "vipere/march.flac");
(
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,0.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,1.9)).range(0,0.02) + 0.15  });
~buf = BufDef(\march);
~buf = BufDef(\moeten);
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
//Ndef(~name+++\lfo1, { Phasor.kr(0, (1/SampleRate.ir).poll *1, 0, 0.81) + 0.1 + LFPulse.kr(8).range(0,0.0001).lag(0.1)});
Ndef(~name+++\lfo1, { arg freq=8, maxrange=0.01, difrange=0.01; LFPulse.kr(freq * t).range(maxrange+difrange,maxrange).lag(0.051)});
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([8,8,16,4]/8,inf),
	\freq, Pseq([
		4,4,4,8,
		4,4,4,8,
		8,8,4,4,
		0,0,0,0,

		4,6,4,8,
		0,0,0,0,
		8,8,4,4,
		0,0,0,0,
	],inf),
	\maxrange, Pseq([
		0.01,0.01,0.01,0.02,
	],inf),
	\difrange, Pseq([
		0.01,0.01,0.1,0.02,
	],inf),
	\maxrange, 0.01,
	\difrange, 0.01,
	\dur, 1/2,
));
//Ndef(~name+++\lfo1, { 0.1 + LFPulse.kr(1).range(0,0.0008).lag(0.4)});
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,1.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(1.18).range(0,1.02) + 10.45  });
//Ndef(~name+++\lfo2, { LFSaw.kr(SinOsc.kr(1.12).range(0.01,4.9)).range(0.0001,0.0012)  });
~set_macro.(\k1, Ndef(~name+++\lfo10), \range, ControlSpec(0.01,4,\lin,0,1));
~set_macro.(\k7, Ndef(~name+++\lfo10), \mfreq, \widefreq.asSpec);
Pdef(~name +++ \pre, 
	Pbind(
		//\pos, ~midi.(\k1, 0.1, ControlSpec(0.001,0.1,\exp, 0,0.1)).vpattern,
		\pos, Ndef(~name+++\lfo10, { arg mfreq=1, range=1; SinOsc.ar(mfreq).range(0.2,0.21)*range; }),
		\lpmix, ~midi.(\k2, 0.5, \unipolar.asSpec).vpattern,
		\ffreq, ~midi.(\k3, 0.1, \freq.asSpec).vpattern,
		\lol, ~midi.(\k5, 0, \unipolar.asSpec),
		\hil, ~midi.(\k6, 1, \unipolar.asSpec),

		\fshift, ~midi.(\k4, 0.1, ControlSpec(-2000.001,2000.1,\lin, 0,0.0)).vpattern,
		\dur, 1,
		\posenv, Pfunc({ arg ev;
			var env = ev[\posenv][0];
			var lol=0, hil=1;
			lol = ev[\lol].get_val;
			hil = ev[\hil].get_val;
			[env.range(lol, hil)];
		}),
		
	//	\range, Ndef(~name+++\lfo1),
	//	\freq, Pseq([50,50,60,40],inf).stutter(16),
	//	\ffreq, Pseq([1000,2000,3000,5000],inf) - Pseq([500,700,0],inf),
	//	\rq, Pseq([
	//		0.1,2,0.3,5,
	//		0.1,0.2,0.3,5,
	//	]/10,inf).stutter(2),

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
	\legato, 1.0,
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
