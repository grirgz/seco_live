(
Ndef(~name+++\lfo1, { 
	var gate = Impulse.kr(1/2);
	var env = EnvGen.ar(Env([1,2,100,0],[1.4,1.4]),gate,doneAction:0);
	SinOsc.kr(env * 1).range(750,5100)  
});
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([1764],inf).stutter(4),
	\freq, Ndef(~name+++\lfo1).bus.asMap,
	\ffreq, 100,
	\isRest, Veco(~namex).isrest(16),
	\legato, 1,
	\adsr, Pseq([
		[ Env.adsr(0.0001,0.001,0.9,1.4,1,-9) ],
		[ Env.adsr(0.0001,0.001,0.9,2.4,1,-9) ],
	],inf),
));
)
