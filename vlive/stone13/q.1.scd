
(
SynthDef(~namex, {arg out= 0, ress = 0, gate=1;
		var klank, env;
		var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
		var sig;
		sig = Klank.ar(`[{Rand(70,\rmax.kr(20000))}!7, {Rand(0.128,0.700)}!7],BrownNoise.ar(0.7));
		sig1 = sig * Klank.ar(`[( {Rand(70,21000)}!7 * (1..8)/8 * LFNoise1.kr(1/2 * (1..8)/8).range(0.0,1.0) ).clip(50,20000), {Rand(0.128,0.700)}!7],BrownNoise.ar(0.7));
		sig = SelectX.ar(\mix1.kr(0.5), [sig, sig1]);
		sig1 = sig.tanh;
		sig2 = Limiter.ar(sig) * 2.9;
		sig = SelectX.ar(\mix2.kr(0.5), [sig2, sig1]);
		sig = sig*7;
		//env = EnvGen.kr(Env.adsr(0.0001,0.1,0.4,ress), Trig.kr(1,1/4), doneAction:2);
		env = EnvGen.kr(\adsr.kr(Env.adsr(0.0001,0.1,0.4,1)), gate, doneAction:2);
		//klank = Pan2.ar(klank, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! klank.size, 1).mean;
		sig = Splay.ar(sig, 0.99, 1, 0);
		sig.debug("fkjfkj");
		Out.ar(0, sig*env*0.0128);
}).add;
);


(
Pdef(~name +++ \pre, 
	Pseq([
		Pdef(~name+++\v1),
		Pdef(~name+++\v2),
	],inf)
);
)

(
Pdef(~name +++ \v1, Pbind(
	\instrument, ~namex,
	\isRest, false,
	\rep, Pn(1,10),
	\mix1, 1,
	\mix2, 1,
	\legato, Pwhite(0.1,1.8),
	\dur, Pwhite(0.1,0.8),
).trace);
Pdef(~name +++ \v2, Pbind(
	\instrument, ~namex,
	\isRest, false,
	\rmax, 1000,
	\mix1, 0,
	\mix2, 0,
	\rep, Pn(1,10),
	\legato, Pwhite(0.1,0.3),
	\dur, Pwhite(0.1,0.3),
));
)
