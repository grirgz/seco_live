
(
Ndef(~name+++\lfo1, { arg fmfreq=1;
	var sig;
	sig = LFSaw.kr(fmfreq).range(50,500);
	sig = sig + LFCub.kr(1/2).range(20,50);
	sig;
});
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\fmfreq, Pseq([1],inf),
	\fmfreq, Pseq([1,2,4,8],inf),
));
Pdef(~name +++ \pre, Pbind(
	\cutoff, Place([100,500,[2000,7000]],inf),
	//\cutoff, Pwhite(100,800.0),
	\freq, Pwhite(100,800.0).stutter(15),
	\freq, Ndef(~name+++\lfo1).bus.asMap,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
		[ Env.adsr(0.001,0.1,0.8,0.1) ],
		[ Env.adsr(0.1,0.1,0.8,0.001) ],
	],inf),
	\dur, 1,
	\isRest, Veco(~namex).isrest(16),
	\legato, 1.5,
	//\pwidth, Ndef(~name+++\lfo3),
	//\rq, Ndef(~name+++\lfo1, { PulseCount.kr(Dust.kr(1),Dust.kr(1))*0.1 }),
	\rq, 0.3,
));

);

// END

