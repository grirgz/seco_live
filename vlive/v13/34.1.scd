
Ndef(~name+++\lfo1, { 
	var gate = Impulse.kr(1/4);
	//var env = EnvGen.ar(Env([200,300,150,250],[1.4,1.4,1]),gate,doneAction:0);
	var env = EnvGen.ar(Env([0,3,0,5],[1.4,1.4,1]/10),gate,doneAction:0);
	//SinOsc.kr(env * 1).range(0750,4100)  
	var env2 = LFNoise0.kr(0.4).abs * 1000;
	SinOsc.kr(200 + env).range(0750,7100+(env2*10))  
});
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([1764],inf).stutter(4),
	\oscmix, 1,
	\freq, Ndef(~name+++\lfo1).bus.asMap,
	//\freq, 900,
	\fmfreq, 2,
	\fmscale, 0.2,
	//\ffreq, Prand([7000,5000],inf),
	\ffreq, 1000,
	\isRest, Veco(~namex).isrest(16),
	\isRest, false,
	\legato, Prand([0.1,0.4],inf),
	\dur, Pwhite(0.5,4),
	\adsr, Pseq([
		[ Env.adsr(0.7001,0.001,0.9,0.1,1,-9) ],
	],inf),
));
)
