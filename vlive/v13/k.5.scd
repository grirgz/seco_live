(
~dur = 1/8;
Ndef(~name+++\lfo1, { 
	LFSaw.kr(t / ~dur * 1/16).range(4730,70) +
	LFSaw.kr(t / ~dur * 4).range(40,470)  
});
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		Pseq([070,50],4),
		Pseq([100,60],4),
		Pseq([040,60],4),
		Pseq([090,45],4),
	]*4,inf).stutter(2) + Pseg(Pseq([0,0,-5],inf),Pseq([6,0.5,0.5],inf)),
	\freq, Ndef(~name+++\lfo1).bus.asMap,
	
	\isRest, Veco(~name).isrest(32),
	\ffreq, Pseq([2000,100,200,300, 2000,100,1000,300]/5,inf),
	\sawtab1,Pn(Plazy({
		Pseq([[Array.geom(8,0.1,1.42).scramble]],32)
	})),
	\sawtab2,Pn(Plazy({
		//Pseq([[Array.geom(8,64*1,1/4).scramble]],32),
		t/Pseq([[Array.geom(8,1,1/8).scramble]],32) 
	})),
	\ffreqtab,Pn(Plazy({
		Pseq([[Array.geom(8,1,1.32).scramble]],32)
	})),
	\legato, Pseq([2,1,4,1],inf),

	\dur, 1/8,
));
)
