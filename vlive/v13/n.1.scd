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

Ndef(~name+++\lfo1, { SinOsc.kr(t/2).range(500,9000)  });
Ndef(~name+++\lfo2, { SinOsc.kr(t/4 + 0.1).range(50,5900)  });
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
	\freq, Pseq([070,40],inf).stutter(~bar) * 5,
	\freq2, Pseq([50,60],inf).stutter(~bar) * 5,
	\freq3, Pkey(\freq)*(3/5),
	\isRest, Veco(~namex).isrest(32),
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
	\dur, 1/4,
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
