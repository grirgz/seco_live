BufDef(\march, "vipere/march.flac");
(
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,0.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,1.9)).range(0,0.02) + 0.15  });
~buf = BufDef(\moeten);
~buf = BufDef(\crepe);
//Ndef(~name+++\lfo1, { Phasor.kr(0, (1/SampleRate.ir).poll *1, 0, 0.81) + 0.1 + LFPulse.kr(8).range(0,0.0001).lag(0.1)});
//Ndef(~name+++\lfo1, { 0.1 + LFPulse.kr(1).range(0,0.0008).lag(0.4)});
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,1.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(1.18).range(0,1.02) + 10.45  });
//Ndef(~name+++\lfo2, { LFSaw.kr(SinOsc.kr(1.12).range(0.01,4.9)).range(0.0001,0.0012)  });
Pdef(~name +++ \pre, 
	Pbind(
		\pos, 0.014 + Pseq([0,1,0,2],inf).stutter(8)/100,
		\pos, 0.140,
		\freq, Pseq([100,200,150,200]*4,inf) * Pseg(Pseq([0.25,2],inf),10),
		\pos, 0.140 + Pseg(Pseq([0,0,0.01,0.7],inf),16),
		\pos, 0.140 + Pseq([
			0,0,0.01,0.5,
			0,0.01,0,0.1,
		],inf).stutter(4),
		\freq, 1000,
		\range, 0.000000001,
		\posenv, Pseq([
			//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
			//[ Env([0.00,0.0189,0.401].integrate.postln,[0.01,0.1]) ],
			[ Env([0.00,0.0011,0.0012].integrate.postln,[0.01,0.1]) ],
			[ Env([0.00,0.0001,0.0012].integrate.postln,[0.01,0.1]) ],
			[ Env([0.00,0.0001,0.0012].integrate.postln,[0.01,0.1]) ],
			[ Env([0.00,0.0001,0.0012].integrate.postln,[0.01,0.1]) ],
		],inf),
		//\finepos, ~envNdefq.(~name+++\lfo1, Env([1,2]/100,1/t)),
		\legato, Pseq([0.4,0.2,0.8,0.2],inf) * Pseg(Pseq([0.5,1],inf),8),
		\dur, 1/4,
		\fshift, 0,
		\lpmix, 1.0,
		\isRest, false,
		\ffreq, Pseq([1000,500],inf).stutter(1),
		\hpf, 100,
		\ffreq, 7000,
		\amp, 24.0 * Pkey(\amp),
		\amp, Pkey(\amp) * Pseq([
			0.5,0.2,1,0.2,
			0.7,0.4,1,0.2,
		],inf) + Pwhite(0.0,0.1),
		\bufnum, ~buf,
		\rq, 0.7,
		\ffreqtab, Pseq([
			[[2.3,3.2,0.1,0.1, 0.2,0.8,1.2,1.5]],
		],inf),

	) <>
	
	Pbind(
	)
);
)

// END

MIDIBoard.map(\s9, s.volume, \volume)

s.getQueryTree({ arg data; data.asCompileString.postln; })

~kill_nodes_by_name.(\oscsampler);
