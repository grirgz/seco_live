(
Ndef(~name+++\fx, { arg freq=4, amp=1;
	var in = In.ar(BusDef(~name+++\fx),2);
	var sig;
	var sig1,sig2,sig3,sig4,sig5;
	sig = in;
	sig = FreeVerb.ar(sig, 0.41,4.7,0.1)*2;
	sig = sig * amp;
	sig;
});

//Ndef(~name+++\fx).put(1, \set -> Pbind(
//	\freq, Pseq([
//		4,0,4,4, 8,0,0,4,
//		4,0,8,0, 4,8,0,8,
//		8,0,8,8, 4,0,4,4,
//		4,0,16,16, 4,0,0,8,
//		//2,8,4,2, 2,8,4,0,
//		//2,8,4,2, 2,8,4,0,
//	],inf),
//	\amp, Pseq([
//		1,1,1,1, 1,1,1,1,
//		1,1,1,1, 1,1,1,1,
//	],inf),
//	\dur, 1/4,
//));

//Ndef(~name+++\lfo1, { SinOsc.kr(t/16).range(500,9000) + LFNoise1.kr(1).range(0,300) });
//Ndef(~name+++\lfo1, { XLine.kr(10,5000,40) + LFNoise1.kr(1).range(0,300) });
Ndef(~name+++\lfo3, { IEnvGen.kr(Env([10,1000,500],[0.4,0.3].normalizeSum), SinOsc.kr(1 + LFNoise1.kr(1).range(0,59)).range(0,1))  });
Ndef(~name+++\lfo1, { Ndef(~name+++\lfo3).kr.lag(0.1) + LFNoise1.kr(1).range(0,50)  });
Ndef(~name+++\lfo2, { Ndef(~name+++\lfo3).kr.lag(0.5) + LFNoise1.kr(1).range(0,50)  });
~bar = 16;
Pdef(~name +++ \pre, Pbind(
	//\degree, Pseq([0,4,2,2],inf),
	//\mtranspose, Pstep(Pseq([0,2],inf),4),
	//\root, -4,
	//Pseq([100,60],4),
	//Pseq([070,50],4),

		//Pseq([070,50],4),
		//Pseq([100,60],4),
		//Pseq([040,60],4),
		//Pseq([090,45],4),
	//\freq, Pseq([070,40],inf).stutter(~bar) * 5,
	//\freq, Ndef(~name+++\lfo1).bus.asMap,
	//\degree, Pseq([0,2,0,1],inf),
	\degree, Pseq([
		0,2,4,4, 0,0,-2,1,
		0,0,1,1, 0,0,-2,1,
	],inf).stutter(4),
	//\freq2, Pseq([0,0],inf).stutter(~bar) * 5,
	\freq2, Pkey(\freq)*(1/5),
	\freq3, Pkey(\freq)*(3/5),
	//\freq3, Ndef(~name+++\lfo2).bus.asMap,
	//\freq3, Ndef(~name+++\lfo3).bus.asMap,
	\isRest, Veco(~namex).isrest(8),
	//\isRest, Veco(~namex).isrest(8),
	\legato, 1.0,
	\ffreq, 5000,
	\ffreq, Ndef(~name+++\lfo2),
	\cutoff, Ndef(~name+++\lfo1),
	\adsr, Pseq([
		[ Env.adsr(0.001,0.1,0.8,0.11) ],
	],inf),
	\amp, 0.4 * Pkey(\amp),
	\dur, 1/4 * Pseq(1+[0,-0.01,0.01,0],inf),
	\dur, 1/2,
));
)
// END

Ndef(~name+++\fx).quant=4;

Ndef(~name+++\fx).put(1, \set -> Pbind(
	\freq, Pseq([
		4,0,4,4, 4,16,4,4,
		0,4,4,0, 4,16,4,8,
		4,4,8,8, 4,16,4,4,
		4,8,4,0, 4,16,4,4,
		//2,8,4,2, 2,8,4,0,
		//2,8,4,2, 2,8,4,0,
	],inf),
	\amp, Pseq([
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,1,
	],inf),
	\dur, 1/4,
));


