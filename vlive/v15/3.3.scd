(
Pdef(~name +++ \pre, Pbind(
	\sustain, 0.41,
	//\legato, 0.3,
	\amp, 0.51,
	\lpfreq, Pseq([1000,5000],inf),
	\lpfreq, Pwhite(1000,5000,inf),
	\mixverb, 0.9,
	\room, 1.9,
	\bpfreq1, Ndef(~name+++\lfo2, { SinOsc.kr(0.43).range(1500,7500) }).bus.asMap, 
	\bpfreq2, Ndef(~name+++\lfo3, { SinOsc.kr(0.3).range(150,750) }).bus.asMap, 
	\bpfreq3, Ndef(~name+++\lfo4, { SinOsc.kr(0.17).range(7150,50) }).bus.asMap, 
	\freq, Ndef(~name+++\lfo1, { arg freq=500; SinOsc.kr(2).range(150,freq.lag(0.1)) }).bus.asMap,
	\dur, 1.00,
	\sat, 5000,
	\asr, Pseq([
		[ Env.asr(1.1,0.8,3.4,2) ],
	],inf),
));
);

(
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([1000,800,700,500],inf),
	\dur, 1,
));
)
