
(
Ndef(~name+++\lfo1, { arg fmfreq=40, fmfreq2;
	var sig;
	sig = LFSaw.kr(fmfreq2);
	//sig = sig + LFCub.kr(1/2).range(20,50);
	sig = Impulse.kr(fmfreq+(sig*2));
	sig = EnvGen.kr(Env([200,450,100,300,200],[0.2,0.03,0.04,0.1],-1,1,1),sig);
	sig;
});
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\fmfreq, Pseq([1],inf),
	\fmfreq, Pseq([4,8,4,8]*2,inf),
	\fmfreq, Pseq([40,32,28],inf),
	\fmfreq, Pseq([
		10,32,28,40,
		21,15,28,40,
	],inf),
	\dur, 1/4,
	\fmfreq2, Pseq([40,32,28]/2,inf),
));
Ndef(~name+++\lfo2, { arg fmfreq=1;
	var sig;
	sig = LFSaw.kr(fmfreq).range(0.5,0.1500);
	sig = sig + LFCub.kr(1/2).range(0.20,0.50);
	//sig = sig.wrap(1);
	sig;
});
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	\fmfreq, Pseq([1],inf),
	\fmfreq, Pseq([1,2,4,8]*0.4,inf),
));
Pdef(~name +++ \pre, Pbind(
	//\cutoff, Place([100,500,[2000,7000]],inf),
	//\cutoff, Pwhite(100,800.0),
	\cutoff, 1000,
	\freq, Pwhite(100,800.0).stutter(15),
	\freq, Ndef(~name+++\lfo1).bus.asMap,
	\pwidth, Ndef(~name+++\lfo2),
	\pwidth, 0.5,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
		[ Env.adsr(0.001,0.1,0.8,0.1) ],
		[ Env.adsr(0.1,0.1,0.8,0.001) ],
	],inf).stutter(4),
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
		[ Env.adsr(0.001,0.1,0.8,0.1) ],
	],inf).stutter(2),
	\dur, 1/8,
	\isRest, Veco(~namex).isrest(16),
	\legato, 1.5,
	//\pwidth, Ndef(~name+++\lfo3),
	//\rq, Ndef(~name+++\lfo1, { PulseCount.kr(Dust.kr(1),Dust.kr(1))*0.1 }),
	\rq, 0.3,
));

);

// END

