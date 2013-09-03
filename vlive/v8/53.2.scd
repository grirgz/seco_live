//Ndef(~name+++\lfo1, { SinOsc.kr(XLine.kr(0.5,32,32)).range(2,100) });
(
Ndef(~name+++\lfo1, { 
	var lfo = SinOsc.kr(0.1);
	var lfo2 = SinOsc.kr(0.3, pi/2);
	var sig = SinOsc.kr(lfo.range(0.5,32)).range(2,lfo2.range(0.5,50)*100);
	Pulse.kr(4.73).range(0.5,1)*300 + sig/5;
});

Pdef(~name +++ \pre, Pbind(
	//\degree, Pseq([0],inf),
	\freq, Ndef(~name+++\lfo1).bus.asMap,
	//\freq, Pseq([50,200,500,2000],inf) * Pwhite(0.4,1.2),
	\hpfreq, 2,
	\rq, 0.4,
	\rq, Pseq([0.14,0.5,0.3],inf),
	\legato, 1.4,
	\dur, Pseq([1/16, Pwhite(0.01,0.3,1)],inf) ,
))
);
