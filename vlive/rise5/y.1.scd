BufDef(\march, "vipere/march.flac");
(
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,0.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,1.9)).range(0,0.02) + 0.15  });
~buf = BufDef(\march);
~buf = BufDef(\moeten);
BufDef(\moto, "vipere/moto.flac");
~buf = BufDef(\moto);
~buf = BufDef(\metal, "vipere/metal.flac");
~buf = BufDef(\ukraine, "bruit1/07_ukraine.flac");
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
//Ndef(~name+++\lfo1, { Phasor.kr(0, (1/SampleRate.ir).poll *1, 0, 0.81) + 0.1 + LFPulse.kr(8).range(0,0.0001).lag(0.1)});
//Ndef(~name+++\lfo1, { 0.1 + LFPulse.kr(1).range(0,0.0008).lag(0.4)});
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,1.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(1.18).range(0,1.02) + 10.45  });
//Ndef(~name+++\lfo2, { LFSaw.kr(SinOsc.kr(1.12).range(0.01,4.9)).range(0.0001,0.0012)  });
Pdef(~name +++ \pre, Pbind(
	\freq, 422,
	\pos, Pseq([0.0,0.01,0.02,0.03],inf),
	\pos, Pseg(Pseq([0,0.1],inf),32)+0.5,
	\pos, 0.042,
	\posenv, Pseq([
		//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
		[ Env([0.001,0.002,0.004].integrate.postln,[0.01,0.1]) ],
		[ Env([0.001,0.003,0.004].integrate.postln,[0.01,0.1]) ],
		[ Env([0.001,0.1013,0.004].integrate.postln,[0.01,0.1]) ],
	],inf),
	\fshift, Pseq([0,48,-40],inf),
	\fshift, 0,
	\fshift, -48,
	\lpmix, 0.99,
	\rq, 0.4,
	\posenv, Pseq([
		//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
		[ Env([0.001,0.0110001,0.00004071].integrate.postln,[0.22,0.44]) ],
	],inf),
	\finepos, Pwhite(0,0.01),
	//\pos, Ndef(~name+++\lfo1),
	//\finepos, Ndef(~name+++\lfo1),
	//\range, Pseg(Pseq([0.001,0.21],inf),8),
	//\range, Ndef(~name+++\lfo2),
	\range, 0.000098,
	\ffreq, Pseq([100,300,200,200],inf),
	\ffreq, Pseq([1000,3000,200,2000],inf),
	\ffreq, Pseq([60,70,100,120],inf),
	\ffreq, Ndef(~name+++\lfo1, { CuspN.ar(1/8 * ~t).range(100,5000) }),
	\pos, 0.42,
	\bufnum, ~buf,
	\lpmix, 1,
	\ffreqtab, Pn(Plazy({
		[{ 2.rand } ! 8]
	})),
	\ffreqtab, Pseq([
		[[2.3,3.2,0.1,0.1, 0.2,0.8,1.2,1.5]],
	],inf),
	\ffreqtab, Pseq([[Array.geom(8,0.1,1.2).postln]],inf),
	\ffreqtab, Prand([
		[Array.series(8,0.5,0.1).postln],
		//[Array.series(8,0.01,0.7).postln],
	],inf),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.3,0.5,0.41) ],
	],inf),
	\legato, 0.5,
	\dur, Pkey(\dur) * ~swing1,
	\isRest, Veco(~namex).isrest(16),
	\isRest, Plazy({
		Pseq([
			0,1,0,1,
			0.2,0.5,0.3,0.4
		].collect(_.coin),1)
	}).loop,
	\amp, 4 * Pkey(\amp),
));
)
