(
Ndef(~name+++\lfo1, { SinOsc.kr(SinOsc.kr(0.1410, 3pi/2)*1+1*100).range(150,700)  });
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		Pseq([070,50],4),
		Pseq([100,60],4),
		Pseq([040,60],4),
		Pseq([090,45],4),
	]*4,inf).stutter(2) + Pseg(Pseq([0,0,-5],inf),Pseq([6,0.5,0.5],inf)),
	\freq, 100,
	\freq, Ndef(~name+++\lfo1).bus.asMap,
	\adsr, Pseq([
		[ Env.adsr(0.101,0.1,0.8,0.7) ],
	],inf),
	
	\isRest, Veco(~name).isrest(32),
	\ffreq, 1000,
	\ffreq, Pseq([2000,100,200,300, 2000,100,1000,300],inf),
	\sawtab1,Pn(Plazy({
		Pseq([[Array.geom(8,1,1.02).scramble]],32)
	})),
	\sawtab2,Pn(Plazy({
		Pseq([[Array.geom(8,1,1.001).scramble]],32)
	})),
	\ffreqtab,Pn(Plazy({
		Pseq([[Array.geom(8,1,1.02).scramble]],32)
	})),
	\legato, Pseq([0.3,0.5,0.5,0.5],inf),

	\dur, 1/8,
));
)
