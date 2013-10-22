(
Ndef(~name+++\lfo1, { 
	var gate = Impulse.kr(1/1);
	//var env = EnvGen.ar(Env([200,300,150,250],[1.4,1.4,1]),gate,doneAction:0);
	var env = EnvGen.ar(Env([0,3,0,5],[1.4,1.4,1]/10),gate,doneAction:0);
	//SinOsc.kr(env * 1).range(0750,4100)  
	var env2 = LFNoise0.kr(0.4).abs * 1000;
	//SinOsc.kr(100 + (env *2)).range(0750,7100+(env2*10))  
	SinOsc.kr(1 + (env *2)).range(0450,100+(env2*10))  
});
Ndef(~name+++\lfo2, { 
	var gate = Impulse.kr(1/1);
	//var env = EnvGen.ar(Env([200,300,150,250],[1.4,1.4,1]),gate,doneAction:0);
	var env = EnvGen.ar(Env([0,3,0,5],[1.4,1.4,1]/10),gate,doneAction:0);
	//SinOsc.kr(env * 1).range(0750,4100)  
	var env2 = LFNoise0.kr(0.4).abs * 1000;
	LFPulse.kr(1 + (env *1)).range(0150,5100+(env2*10)).lag(0.06);
	SinOsc.kr(1).range(50,2500);
});
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([1764],inf).stutter(4),
	\oscmix, 0.51,
	\oscmix, Pseq([0,0.2,0.3,0.7,1],inf),
	\freq, Pseq([900,100,50],inf),
	\fmfreq, 20,
	\ffreq, Ndef(~name+++\lfo1).bus.asMap,
	\fmscale, 0.9,
	//\ffreq, Prand([7000,5000],inf),
	\ffreq, 7000,
	\ffreq, Ndef(~name+++\lfo2),
	\isRest, false,
	\isRest, Veco(~namex).isrest(16),
	\legato, Prand([0.9,0.4],inf),
	\dur, Pwhite(0.5,4),
	\dur, 1/8,
	\adsr, Pseq([
		[ Env.adsr(0.0101,0.001,0.4,0.1,1,-9) ],
	],inf),
));
)
