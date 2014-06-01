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
		\pos, 0.12,
		\posenv, Pseq([
			[Env([0.0,0.03,0.104],[4.72,4.72])]
		],inf),
		\range, 0.00001,
		\dur, 1,
		\ffreqtab, Pseq([
			[ 	Array.series(8,0.1,0.07) ]
		],inf),
		\lpmix, 0.01,
		\finepos, 0,
		\freq, Pseq([80,50],inf).stutter(64) * 1,
		\freq, Pseq([100,300],inf),
		\legato, Pseq([
			1,0.1,1,0.1,
		],inf).stutter(4),
		\legato, 1.81,
		\legato, 0.8,
		\legato, Pseq(
			~seqmod.(1!16, 15,[0.9])
		,inf).stutter(1),
		//\lag, Pseq([0.05, 0, 0.05, 0],inf) / t,
		\isRest, Pseq([
			1,1,1,1,
			0,0,0,0,
		],inf).coin.not.stutter(1),
		\isRest, false,
		\amp, 4.0 * Pkey(\amp),
));
)

// END

MIDIBoard.map(\s9, s.volume, \volume)

s.getQueryTree({ arg data; data.asCompileString.postln; })

~kill_nodes_by_name.(\oscsampler);
~kill_nodes_by_name.(\oscsampler);
~kill_nodes_by_name
