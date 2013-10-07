(


Ndef(~name+++\lfo1, { arg fmfreq; SinOsc.kr(fmfreq * [1,0.2]).sum.clip(0.5) * \bscale.kr(1) * \base.kr(1000) + \base.kr  });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\fmfreq, 1 * t,
	\bscale, Pseq([0.91,0.5,0.3],inf),
	\base, Pseq([100,200]*1,inf),
	\base, Pseq([
		100,200, 100,400,
		400,200, 100,400,
	]/2,inf).stutter(2),
	\fmfreq, Pseq([
		1,2,1,4
	]*2,inf),
	\fmfreq, 4 * t,
	\dur, 1/4,
));
Ndef(~name+++\lfo2, { arg fmfreq; SinOsc.kr(fmfreq * [1,0.2], \phase.kr(0)).range(0.100,1.4100).clip(0.1).sum  });
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	\fmfreq, Pseq([4,2,8,4]*1,inf),
	\fmfreq, Pseq([1,2,1,4]*1,inf),
	\phase, 3.5,
	\fmfreq, 5.400,
	\dur, 1/2,
));
Ndef(~name+++\lfo3, { arg fmfreq; SinOsc.kr(fmfreq * [1,0.2]).sum.clip(0.5) * \bscale.kr(1) * \base.kr(1000) + \base.kr  });
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\fmfreq, 1 * t,
	\bscale, Pseq([0.91,0.5,0.1,0.1],inf),
	\base, Pseq([2000,200,4000,50]/1,inf),
	\base, Pseq([
		200,1200,1500,1350,
		200,3200,1500,0350,
	]/1,inf),
	\fmfreq, Pseq([
		1,2,1,4
	]*2,inf),
	\fmfreq, 8 * t,
	\dur, 1/8,
));
//~preset = Sdef(~name, \mypreset).get(k).pbind.blend(Sdef(~name, \mypreset).get(6).pbind, 0.5);
~preset = Sdef(~name, \mypreset).get(0).pbind.blend(Sdef(~name, \mypreset).get(6).pbind, 
Pseg(
	Pseq([0,0.2,0.5,0.8,1],inf)
	,1)
);
Pdef(~name +++ \pre, 
	
	Pbind(

		//\isRest, Veco(~namex).isrest(32),
	) 
	<> ~preset
	<> Pbind(
		\noisefreq, 10.1,
		\delayfactor, 0.8,
		\shift, 230,
		\degree, Pseq([0],inf),
		\oscmix, 0.51,
		\oscfreq, Pseq([100,200,500,1000],inf),
		\oscfreq, Pseq([50,120,150,80],inf),
		\ffreq, Ndef(~name+++\lfo3),
		\freqtab, Pseq([
			//[ Array.geom(8,1.0,1.001) ],
			[ Array.series(8,1.0,0.201) ],

		],inf),
		\ffreqtab, Pseq([
			//[ Array.geom(8,1.0,1.01) ],
			[ Array.series(8,2.0,0.801) ],

		],inf),


		\fbase, 400 + Pseq([1,1.5,1.7,0.5],inf).stutter(4),
		\fbase, Ndef(~name+++\lfo1),
		\fbase2, 450,

		\fscale, Pseq([1.8,1.7,0.6],inf),
		\fscale2, 3.4,
		\fscale2, Pseq([4.8,1,1.7,0.6],inf),

		//\decay, 2.8,
		\decay2, 0.8,
		\dur, 1/8,
		\adsr, Pseq([
			[ Env.adsr(0.001,0.1,0.8,0.1) ],
		],inf),
		\legato, Pseq([4,1,0.5,2],inf),

		\freqfactor, Pseq([1,1.1,0.42,1.3],inf),
		\freqfactor2, Pseq([1,1.1,0.42,1.3],inf),
		\freqfactor2, Ndef(~name+++\lfo2),
		\freqfactor, 1,
));
);

// END

Ndef(~name+++\lfo1, { arg fmfreq; SinOsc.kr(fmfreq).range(400,4800)+500  });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\fmfreq, 1,
	\fmfreq, Pseq([
		1,2,1,4
	]*2,inf),
	\fmfreq, 0.10,
	\dur, 1/2,
));

Sdef(~name, \mypreset).get(0).edit;
Sdef(~name, \mypreset).edit;
Sdef(~name, \mypreset).get(0).pbind.trace.play
~preset = Sdef(~name, \mypreset).get(0).pbind.blend(Sdef(~name, \mypreset).get(6).pbind, 0.5);
~preset = Sdef(~name, \mypreset).get(0).pbind.blend(Sdef(~name, \mypreset).get(6).pbind, 0.5) 
~pre = Pbind(\instrument, \default, \isRest, false) <> ~preset
~pre.trace.play
~preset.trace.play


~pre = Pbind(\freq, 500).blend(Pbind(\freq, 5000), 0.5) <> Pbind(\dur, 1/2, \isRest, false)
~pre.trace.play



(
	
	~a = Pbind(
		\instrument, \default,
		\freq, Pseq([100,200,300,250],inf).stutter(Pseq([1,2,3],inf)),
		\dur, 1/8,
		\amp, 0.1
	);
	~b = Pbind(
		\instrument, \default,
		\freq, Pseq([100,200]+300,inf),
		\dur, 1/4,
		\amp, 0.1
	);
	//Ndef(\bla, { \target.kr(100)+\base.kr(0) });
	Ndef(\bla, { SelectX.kr(Ndef(\mixx).kr, [\src.kr(200), \target.kr(100)])+\base.kr(0) });
	~a = Pbind(
		\freq, Prout { arg ev;
			var ndef = Ndef(\bla);
			//ndef.xset(\target, 100);
			500.do {
				ndef.set(\base, ev[\freq].postln);
				ev = ndef.bus.asMap.yield;
			};
		}
	) <> ~a;
	Pdef(\a,Ppar([~a])).play;
)

Ndef(\bla).set(\target, 100)
Ndef(\bla).fadeTime = 0.42
Ndef(\bla).map(\mix, Ndef(\bli, { LFSaw.kr(1).range(0,1) }))
Ndef(\bla).set(\target, 800)
Ndef(\bla).set(\src, 400)
Ndef(\bla).set(\src, 40)

Ndef(\bla).xset(\target, 500)
Ndef(\bla).xset(\target, 1500)
Ndef(\bla).xset(\src, 400)
Ndef(\bla).xset(\src, 40)
Ndef(\mix, {DC.kr(1)})
Ndef(\mix, {1})
t
Ndef(\mixx, { SinOsc.kr(28*t).range(0,1) })
Ndef(\mixx, { SinOsc.kr(28*t).range(0,1) + SinOsc.ar(1*t).range(0,0.2) })
Ndef(\mixx, { SinOsc.kr(8*t).range(0,1) })
Ndef(\mixx, { Line.kr(Ndef(\mixx).kr,0,4) })
Ndef(\mixx, { Line.kr(Ndef(\mixx).kr,1,4) })
Ndef(\mixx, { Line.kr(Ndef(\mixx).kr,Ndef(\mixx).kr/2,4) })
Ndef(\mixx, 1)
Ndef(\mixx).fadeTime = 4.5


Sdef(~name, \mypreset).get(0).edit;



Sdef(~name, \mypreset).set(0, (
	version: 1,
	specs: [
		\freq, \freq.asSpec,
	],
	preset: [
		\freq, 354.23,
	]
))
