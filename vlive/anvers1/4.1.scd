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
Pdef(~name +++ \pre, PmonoArtic(\oscsampler,
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
		[ Env([0.001,0.0089,-0.3481].integrate.postln,[0.01,0.1]) ],
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
	\ffreq, Pseq([6000,420],inf),
	//\ffreq, 2000,
	\bufnum, ~buf,
	\freq, Pseq([
		Pser([50,55],16),
		Pser([40,45],16-4),
		100,1040,120,300,
	],inf) + 10,
	\ffreqtab, Pseq([[Array.series(8,0.5,0.1).postln]],inf),
	\ffreqtab, Pn(Plazy({
		[{ 1.rand } ! 8]
	})),
	\ffreqtab, Pseq([[Array.geom(8,1.8,1.2).postln]],inf),
	\ffreqtab, Pseq([
		[[2.3,3.2,0.1,0.1, 0.2,0.8,1.2,1.5]],
	],inf),
	\dur, 1/4,
	\pos, Pwhite(0.0,0.4).stutter(32),
	\pos, Pseq([0.1,0.1],inf).stutter(2),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.3,0.5,0.51) ],
	],inf),
	\isRest, Pseq([1],inf).coin.not,
	\legato, Pseq([1,0.4,1,0.3, Pn(1,4)],inf),
	\lag, Pseq([0, 0.05],inf) / t,
	\legato, 0.5,
	\legato, 1,
	\legato, Pseq([
		Pser([1,1,1,1],32-4),
		0.6,1.0,1.0,0.6
	],inf),
	\amp, 4.0 * Pkey(\amp),
));
)

// END

MIDIBoard.map(\s9, s.volume, \volume)

s.getQueryTree({ arg data; data.asCompileString.postln; })

~kill_nodes_by_name.(\oscsampler);
