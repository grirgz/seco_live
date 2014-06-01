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

Pdef(~name +++ \pre, 
	//PmonoArtic(\oscsampler,
	Pbind(
		\pos, Pseq([0.0,0.01,0.02,0.03],inf),
		\pos, Pseg(Pseq([0,0.1],inf),32)+0.8,
		\pos, 0.29,
		\posenv, Pseq([
			[Env([0.0,0.03,0.104],[4.72,4.72])]
		],inf),
		\range, 0.00001 * Pseg(Pseq([0,1],inf),2),
		\dur, 1/4,
		\ffreq, Pseq([200,4000],inf),
		\pan, Prand([1,0.5,-0.5,-1,0.7,-0.7],inf).stutter(8) * 0.3,
		\ffreqtab, Pseq([
			[ 	Array.series(8,0.1,0.07) ]
		],inf),
		\adsr, Pseq([
			[ Env.adsr(0.4,0.1,0.8,0.4) ],
		],inf),
		\lpmix, Pseq([0.2,0.7,0.1],inf),
		\lpmix, 0,
		\finepos, 0,
		\freq, Pseq([80,50],inf).stutter(64) * 1,
		\freq, Pseq([200,5000,1000,3000],inf),
		\freq, Pseq([4200,5000,1000,3000],inf),
		\freq, Pseq([420,1000,2000,8000],inf).stutter(8),
		\freq, Pseq([420,12000,100,8000],inf).stutter(8),
		\range, 0.001 / Pseq([10,100,1,100],inf).stutter(8),
		//\range, Ndef(~name+++\lfo4, { CuspN.ar(10).range(0.00001,0.000001) }),
		\range, Ndef(~name+++\lfo4, { SinOsc.ar(1/2*t).range(0.00001,0.000001) }),
		\finepos, Ndef(~name+++\lfo5, { CuspN.ar(4*t).range(0.000001,0.01) }),
		\legato, Pseq([
			1,0.1,1,0.1,
		],inf).stutter(4),
		\legato, 1.81,
		\legato, 0.8,
		\legato, Pseq(
			~seqmod.(1!16, 15,[0.9])
		,inf).stutter(1),
		//\lag, Pseq([0.05, 0, 0.05, 0],inf) / t,
		\isRest, false,
		\isRest, Pseq([
			1,1,1,1,
			0,0,0,0,
		],inf).coin.not.stutter(8),
		\isRest, Pseq([
			1,0,1,1,
			0.5,0.5,0.5,0,
			1,0.5,1,1,
			0.5,0.5,0.5,0,
		],inf).coin.not.stutter(1),
		\amp, 3.0 * Pkey(\amp),
));
)

// END

MIDIBoard.map(\s9, s.volume, \volume)

s.getQueryTree({ arg data; data.asCompileString.postln; })

~kill_nodes_by_name.(\oscsampler);
