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
	\legato, 0.1,
	\isRest, Pseq([1,0,0.51,0, 1,0.3,0.3,0.4],inf).coin.not,
	\legato, Pseq([0.1,0.3,0.4,1],inf),
	\isRest, false,
	\dur, 1/8,
	\pos, 0.1,
	\posenv, Pseq([
		Plazy({[Env([0,0.101.rand,0.2],[0.51,0.1])]}),
		[Env([0,0.101,0.2],[0.051,0.1])]
	],inf).stutter(2),
	\range, 0.00001,
	\legato, 1.5,
	\legato, Pseq(~seqmod.(0.1 ! 16, 4, 0.3 ! 4),inf),
	\legato, Pseq(~seqmod.(0.1 ! 16, 4, 0.3 ! 4),inf),
	\legato, Prand(~seqmod.(0.1 ! 16, 4, 0.3 ! 4),inf),
	\isRest, Pseq([1,0,0.51,0, 1,0,0,0],inf).coin.not,
	//\lag, Pseq([0, -0.1],inf),
	\amp, 4.0 * Pkey(\amp) * 1,
));
)

// END
Pdef(~name).clear
Pdef(~name+++\pre).clear
Ndef(~name+++\fx).clear

MIDIBoard.map(\s9, s.volume, \volume)

s.getQueryTree({ arg data; data.asCompileString.postln; })

~kill_nodes_by_name.(\oscsampler);
