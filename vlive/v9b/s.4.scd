BufDef(\march, "vipere/march.flac");
(
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,0.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,1.9)).range(0,0.02) + 0.15  });
~buf = BufDef(\moeten);
~buf = BufDef(\march);
//Ndef(~name+++\lfo1, { Phasor.kr(0, (1/SampleRate.ir).poll *1, 0, 0.81) + 0.1 + LFPulse.kr(8).range(0,0.0001).lag(0.1)});
Ndef(~name+++\lfo1, { 0.4 + LFPulse.kr(1).range(0,0.0008).lag(0.4)});
//Ndef(~name+++\lfo1).fadeTime=0.0;
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,1.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(1.18).range(0,1.02) + 10.45  });
Ndef(~name+++\lfo2, { LFSaw.kr(SinOsc.kr(1.12).range(0.01,4.9)).range(0.0001,0.0012)  });
Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\pos, 0.2,
	\pos, Ndef(~name+++\lfo1),
	//\pos, Pseq([0,0.1,0.5],inf) + Pwhite(0,0.01),
	//\finepos, Ndef(~name+++\lfo1),
	//\range, Pseg(Pseq([0.001,0.21],inf),8),
	\range, Ndef(~name+++\lfo2),
	\range, 0.00001,
	\ffreq, Pseq([1000,3000,200,2000],inf),
	\lpmix, 0.01,
	\bufnum, ~buf,
	\ffreqtab, Pseq([Array.geom(8,0.5,1.2).postln],inf),
	\ffreqtab, Pseq([
		[2.3,3.2,0.1,0.1, 0.2,0.8,1.2,1.5],
	],inf),
	\ffreqtab, Pn(Plazy({
		Pseq([{ 2.rand } ! 8],1)
	})),
	\ffreqtab, Pseq([Array.series(8,0.5,0.1).postln],inf),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.3,0.5,0.31) ],
	],inf),
	\rq, 0.3,
));
)
