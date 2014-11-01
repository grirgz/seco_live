(
~buf = BufDef(\march);
~buf = BufDef(\moeten);
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo1, { arg freq=1, fmin=50, fmax=5000; fmin.lag(0.051)});
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([4,1,16,1,32,8,1,1],inf),
	\freq, 1,
	\fmax, 7000,
	\fmin, 50,
	\fmin, Pseq([
		5000,2000, 5000,2000,
		5000,3000, 3000,3000,
		3000,3000, 3000,3000,
		3000,3000, 3000,3000,
	],inf),
	\dur, 1/4,
));
Ndef(~name+++\lfo3, { arg freq=20, flag=0.1; freq.lag(flag)});
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\freq, Pseq([
		1,1,
		1,1,
		1,1,
		2200,7000.1,
	],inf),
	\flag, Pseq([
		1.0, 1.0, 0.0, 1.0,
	],inf),
	\flag, Pseq([
		1.1, 1.1, 1.1, 1.1,
		0.1, 0.1, 0.1, 0.1,
		0,0,0,0,
		0,0,0,0,
	],inf),
	\dur, 1/8,
));
Pdef(~name +++ \pre, 
	Pbind(
		\ffreq, Ndef(~name+++\lfo1),
		\freq, Ndef(~name+++\lfo3).bus.asMap,
		\range, Pseg(Pseq([0.0001,0.00008,0.1],inf), Pseq([7,1,0],inf)),
		\bufnum, ~buf,
	) <>
		//Sdef(~name, \mypreset).getsub(0).pdef <>
		//( freq: 1000 ) <>
		Pseq([

			Plazy({ arg ev;

				var res;
				res = blend(

					Sdef(ev[\name], \mypreset).getsub(0).get_event,
					Sdef(ev[\name], \mypreset).getsub(1).get_event,
					//0.5
					ev[\blender].debug("BLEDER")
					//ev[\blender],
				);
				res[\amp] = res[\amp] * ev[\amp];
				res;
			}) 
		],inf) <>
		//Sdef(~name, \mypreset).pdef <>
	//Pseq([
		//blend(
		//	Pfin(1, Sdef(~name, \mypreset).getsub(0).valpbind),
		//	Pfin(1, Sdef(~name, \mypreset).getsub(1).valpbind),
		//	0.5,

		//)
	//],inf) <>
	
	Pbind(
		\name, ~name,
		\blender, Pseq([
			Pser([0],16),
			Pser([1],16),
		],inf),
		\blender, Pseg(Pseq([0,1],inf),4, 8),
		\blender, Pseq([
			Pser([0.1],4),
			Pser([0.0,0.1],4),
			Pser([0.1],4),
			Pser([0.1,0.2],4),

		],inf),
	\legato, 0.4,
	\dur, 1/4,
	\amp, 1 * Pkey(\amp),
));
)

// END
a = Sdef(~name, \mypreset).getsub(0).get_event

a = Sdef(~name, \mypreset).getsub(0).valpbind.asStream
a.next(Event.default)

a = Sdef(~name, \mypreset).getsub(0).pbind.asStream
a.next(Event.default)
a.play
Veco.force_init
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
//Ndef(~name+++\lfo1, { 0.1 + LFPulse.kr(1).range(0,0.0008).lag(0.4)});
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,1.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(1.18).range(0,1.02) + 10.45  });
//Ndef(~name+++\lfo2, { LFSaw.kr(SinOsc.kr(1.12).range(0.01,4.9)).range(0.0001,0.0012)  });
(
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,0.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,1.9)).range(0,0.02) + 0.15  });
~buf = BufDef(\march);
~buf = BufDef(\moeten);
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;
//Ndef(~name+++\lfo1, { Phasor.kr(0, (1/SampleRate.ir).poll *1, 0, 0.81) + 0.1 + LFPulse.kr(8).range(0,0.0001).lag(0.1)});
Ndef(~name+++\lfo1, { arg freq=1; LFPulse.kr(freq * t).range(50,7500).lag(0.051)});
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([1,1,16,1,1,8,1,1],inf),
	\dur, 1/2,
));
Ndef(~name+++\lfo3, { arg freq=20; freq.lag(0.101)});
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\freq, Pseq([2,2,16,1]*10,inf),
	\dur, 1/2,
));
Pdef(~name +++ \pre, 
	Pbind(
		\ffreq, Ndef(~name+++\lfo1),
		\freq, Ndef(~name+++\lfo3).bus.asMap,

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
	\legato, 16.0,
	\amp, 1 * Pkey(\amp),
));
)
