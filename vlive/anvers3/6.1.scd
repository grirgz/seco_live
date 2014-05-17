BufDef(\march, "vipere/march.flac");
(
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,0.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,1.9)).range(0,0.02) + 0.15  });
~buf = BufDef(\moeten);
~buf = BufDef(\march);
//Ndef(~name+++\lfo1, { Phasor.kr(0, (1/SampleRate.ir).poll *1, 0, 0.81) + 0.1 + LFPulse.kr(8).range(0,0.0001).lag(0.1)});
//Ndef(~name+++\lfo1, { 0.1 + LFPulse.kr(1).range(0,0.0008).lag(0.4)});
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,1.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(1.18).range(0,1.02) + 10.45  });
//Ndef(~name+++\lfo2, { LFSaw.kr(SinOsc.kr(1.12).range(0.01,4.9)).range(0.0001,0.0012)  });
Pdef(~name +++ \pre, Pbind(
	\pos, Pseq([0.0,0.01,0.02,0.03],inf),
	\pos, Pseg(Pseq([0,0.1],inf),32)+0.8,
	\pos, 0.172,
	\posenv, Pseq([
		//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
		[ Env([0.001,0.002,0.004].integrate.postln,[0.01,0.1]) ],
		[ Env([0.001,0.003,0.004].integrate.postln,[0.01,0.1]) ],
		[ Env([0.001,0.0013,0.004].integrate.postln,[0.01,0.1]) ],
	],inf),
	\fshift, 0,
	\fshift, -48,
	\fshift, Pseq([0,48,-40],inf),
	\lpmix, 0.79,
	\rq, 0.1,
	\posenv, Pseq([
		//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
		[ Env([0.001,0.0389,0.0481].integrate.postln,[0.11,0.1]) ],
	],inf),
	\posenv, Pseq([
		//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
		[ Env([0,0,0].integrate.postln,[0.11,0.1]) ],
	],inf),
	//\pos, Ndef(~name+++\lfo1),
	//\pos, Pseq([0,0.1,0.5],inf) + Pwhite(0,0.01),
	//\finepos, Ndef(~name+++\lfo1),
	//\range, Pseg(Pseq([0.001,0.21],inf),8),
	//\range, Ndef(~name+++\lfo2),
	\range, 0.0001,
	\ffreq, Pseq([100,300,200,200],inf),
	\ffreq, Pseq([60,1000,3000,200,2000],inf),
	\ffreq, Pseq([60,70,100,120],inf),
	\bufnum, ~buf,
	\ffreqtab, Pn(Plazy({
		[{ 2.rand } ! 8]
	})),
	\ffreqtab, Pseq([
		[[2.3,3.2,0.1,0.1, 0.2,0.8,1.2,1.5]],
	],inf),
	\ffreqtab, Pseq([[Array.geom(8,1.8,1.2).postln]],inf),
	\ffreqtab, Pseq([[Array.series(8,0.5,0.1).postln]],inf),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.3,0.5,0.51) ],
	],inf),
	\freq, Pseq([100,300],inf).stutter(4),

	\pos, Ndef(~name+++\lfo3, { SinOsc.kr(0.01).range(0.1,0.7) }),
	\ffreq, [
		Ndef(~name+++\lfo1, { SinOsc.kr(1).range(40,1000) }),
		Ndef(~name+++\lfo2, { CuspN.ar(200).range(4000,8000) }),
	],
	\ffreq, 10000,
	\isRest, (Pseq([1,0],inf).coin.not.stutter(Pfinval(32, Prand([8,8,4,16, 8,4,4,8],inf)))).loop,
	\isRest, (Pseq([1,0],inf).coin.not.stutter(Pfinval(8, Prand([8,2,4],inf)))).loop,
	\legato, Pseq([0.1,1.6],inf),
	\amp, 1 * Pkey(\amp),
));
)

sync
(
	var a, b;
	a = Pfinval(5, Pseq(#[1, 2, 3],inf)).loop;
	b = a.asStream;
	9.do({ b.next.postln;  });

)
