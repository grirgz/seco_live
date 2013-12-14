BufDef(\march, "vipere/march.flac");
(
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,0.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,1.9)).range(0,0.02) + 0.15  });
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo1, { arg freq = 1; SinOsc.kr(freq).range(50.01,500.9) });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([
		32,8,1,1, 16,1,8,1,
		0.5,8,0.5,1, 16,1,8,32,
	],inf)*4,
	\freq, Pseq([
		200,500,1,1,
	],inf),
	\dur, 1,
));
BufDef(\moto, "vipere/moto.flac");
~buf = BufDef(\march);
~buf = BufDef(\moeten);
~buf = BufDef(\moto);
//Ndef(~name+++\lfo1, { Phasor.kr(0, (1/SampleRate.ir).poll *1, 0, 0.81) + 0.1 + LFPulse.kr(8).range(0,0.0001).lag(0.1)});
//Ndef(~name+++\lfo1, { 0.1 + LFPulse.kr(1).range(0,0.0008).lag(0.4)});
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,1.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(1.18).range(0,1.02) + 10.45  });
//Ndef(~name+++\lfo2, { LFSaw.kr(SinOsc.kr(1.12).range(0.01,4.9)).range(0.0001,0.0012)  });
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([400],inf),
	\freq, 52*4,
	\freq, Ndef(~name+++\lfo1).bus.asMap,
	\pos, Pseq([0.0,0.01,0.02,0.03],inf),
	\pos, Pseg(Pseq([0,0.1],inf),32)+0.5,
	\pos, Pseq([0.0,0.1,0.2,0.3],inf)/10 + 0.1 + Pseq([0.1,0.2],inf),
	\pos, 0.432,
	\posenv, Pseq([
		//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
		[ Env([0.011,0.002,0.004].integrate.postln,[0.01,0.1]) ],
		[ Env([0.001,0.0013,0.004].integrate.postln,[0.01,0.1]) ],
		[ Env([0.001,0.003,0.004].integrate.postln,[0.01,0.1]) ],
	],inf),
	\posenv, Pseq([
		//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
		[ Env([0.002,0.031,0.0021,0.0001,  0.001].integrate.debug("bla"),[0.002,0.2,0.1,0.1]) ],
		[ Env([0.012,0.071,0.0021,0.0001,  0.001].integrate.debug("bla"),[0.002,0.2,0.1,0.1]) ],
		[ Env([0.012,0.011,0.0021,0.0001,  0.001].integrate.debug("bla"),[0.002,0.2,0.1,0.1]) ],
	],inf).stutter(4),
	\posenv, Pseq([
		//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
		[ Env([0.01,0.021,-0.0121,-0.0031,  0.0041].integrate.debug("bla"),[0.2,0.2,0.2,0.2]) ],
		[ Env([0.01,0.021,0.0121,-0.0031,  0.0041].integrate.debug("bla"),[0.2,0.2,0.2,0.2]) ],
		[ Env([0.01,0.021,-0.0121,-0.0031,  0.0041].integrate.debug("bla"),[0.2,0.2,0.2,0.2]) ],
		[ Env([0.01,0.021,0.0421,-0.0031,  0.0041].integrate.debug("bla"),[0.2,0.2,0.2,0.2]) ],
	],inf).stutter(4),
	\posenv, Pseq([
		//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
		[ Env([0.001,0.071,0.0001,0.0001,  0.0041].integrate.debug("bla")/10,[0.01,0.1,0.2,0.2]) ],
		[ Env([0.001,0.071,0.0001,0.4001,  0.0041].integrate.debug("bla")/10,[0.01,0.1,0.2,0.2]) ],
		[ Env([0.001,0.071,0.0001,0.0001,  0.0041].integrate.debug("bla")/10,[0.01,0.1,0.2,0.2]) ],
		[ Env([0.001,0.471,-0.4001,0.0001,  0.0041].integrate.debug("bla")/10,[0.01,0.1,0.2,0.2]) ],
	],inf).stutter(4),
	\fshift, Pseq([0,48,0,-40],inf),
	\fshift, 0,
	\fshift, 48,
	\lpmix, 0.29,
	\rq, 0.4,
	//\pos, Ndef(~name+++\lfo1),
	//\pos, Pseq([0,0.1,0.5],inf) + Pwhite(0,0.01),
	//\finepos, Ndef(~name+++\lfo1),
	//\range, Pseg(Pseq([0.001,0.21],inf),8),
	//\range, Ndef(~name+++\lfo2),
	\range, 0.00001,
	\ffreq, Pseq([100,300,200,200],inf),
	\ffreq, 480 + Pwhite(0,250.0),
	\ffreq, Pseq([60,70,100,120],inf),
	\ffreq, Pseq([1000,3000,200,2000],inf).stutter(16) + Pseq([0,0,500,0],inf),
	\isRest, Veco(~namex).isrest(32),
	\dur, 1/8,
	\bufnum, ~buf,
	\ffreqtab, Pn(Plazy({
		[{ 2.rand } ! 8]
	})),
	\ffreqtab, Pseq([
		[[2.3,3.2,0.1,0.1, 0.2,0.8,1.2,1.5]],
	],inf),
	\ffreqtab, Pseq([[Array.geom(8,0.1,1.2).postln]],inf),
	\ffreqtab, Pseq([[Array.series(8,0.1,0.1).postln]],inf),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.3,0.5,0.001) ],
	],inf),
	\legato, 4.5,
	\amp, 1 * Pkey(\amp),
));
)
