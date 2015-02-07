BufDef(\march, "vipere/march.flac");
BufDef(\crepe, "field/crepe.flac");
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
		\pos, 0.110,
		\freq, Pseq([100,200,150,200]*4,inf) * Pseg(Pseq([0.25,2],inf),10),
		\range, 0.000001,
		\posenv, Pseq([
			//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
			//[ Env([0.00,0.0189,0.401].integrate.postln,[0.01,0.1]) ],
			//[ Env([0.00,0.0011,0.0012].integrate.postln,[0.01,0.1]) ],
			[ Env([0.00,0.0001,0.0012].integrate.postln,[0.01,0.1]) ],
			//[ Env([0.00,0.0001,0.0012].integrate.postln,[0.01,0.1]) ],
			//[ Env([0.00,0.0001,0.0012].integrate.postln,[0.01,0.1]) ],
		],inf),
		//\finepos, ~envNdefq.(~name+++\lfo1, Env([1,2]/100,1/t)),
		\rq, 0.1,
		\legato, Pseq([0.4,0.2,0.5,0.2],inf) * Pseg(Pseq([0.4],inf),8),
		\legato, 0.71,
		\dur, 1/4,
		\fshift, 0,
		\lpmix, Ndef(~name+++\lfo1, { SinOsc.kr(1/2/t).range(0,1) }),
		\lpmix, 0.5,
		\isRest, false,
		\bufnum, ~buf,
		\ffreq, Pseq([500],inf).stutter(1)*6,
		\amp, 11.0 * Pkey(\amp),
		\ffreqtab, Pseq([
			[[2.3,3.2,0.1,0.1, 0.2,0.8,1.2,1.5]],
		],inf),
		\adsr, Pseq([
			[ Env.adsr(0.01,0.3,0.5,0.01) ],
		],inf),

	)
	
);
)

// END

MIDIBoard.map(\s9, s.volume, \volume)

s.getQueryTree({ arg data; data.asCompileString.postln; })

~kill_nodes_by_name.(\oscsampler);
