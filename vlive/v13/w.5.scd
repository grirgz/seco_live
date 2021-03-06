(
Ndef(~name+++\lfo1, { SinOsc.kr(SinOsc.kr(0.1410, 3pi/2)*100+200).range(885,7700)  });
Ndef(~name+++\lfo2, { SinOsc.kr(2*t).range(0,1)  });
Ndef(~name+++\lfo3, { SinOsc.kr(4*t).range(0,1)  });
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		Pseq([070,50],4),
		Pseq([100,60],4),
		Pseq([040,60],4),
		Pseq([090,45],4),
	]*4,inf).stutter(2) + Pseg(Pseq([0,0,-5],inf),Pseq([6,0.5,0.5],inf)),
	\freq, Ndef(~name+++\lfo1).bus.asMap,
	//\freq, 50,
	\fmscale, 0.71,
	\fmfreq, 45,
	\mix, Ndef(~name+++\lfo2),
	\ffmix, Ndef(~name+++\lfo3),
	
	\isRest, Veco(~name).isrest(32),
	\ffreq, Pseq([2000,100,200,300, 2000,100,1000,300],inf),
	\ffreq2, Pseq([290,700,100,200],inf).stutter(2),
	\sawtab1,Pn(Plazy({
		Pseq([[Array.geom(8,1,1.02).scramble]],32)
	})),
	\sawtab2,Pn(Plazy({
		Pseq([[Array.geom(8,1,1/2).scramble]],32)
	})),
	\ffreqtab,Pn(Plazy({
		Pseq([[Array.geom(8,1,1.02).scramble]],32)
	})),
	\ffreqtab2,Pn(Plazy({
		Pseq([[Array.geom(8,0.1,2).scramble]],32)
	})),
	\legato, Pseq([1.11,0.4],inf).stutter(2),

	\dur, 1/8,
));
)
