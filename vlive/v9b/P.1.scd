(
Ndef(~name+++\lfo1, { SinOsc.kr(1).range(0.3,0.4)  });
//Ndef(~name+++\lfo2, { LFCub.kr([1.1,1.01,1.15]*2).range(0.1,1.09).clip(0.8,0.9).sum/3;  });
Ndef(~name+++\lfo2, { LFCub.kr([1.1,1.01,1.15]*8).range(0.1,2.09).clip(0.5,1.1).sum/3;  });
Pdef(~name +++ \pre, Pbind(
	//\pitch_stretch, Pseq([0.4,0.3]+0.5,inf).stutter(3),
	\pitch_stretch, Ndef(~name+++\lfo2),
	\pitch_stretch, 1,
	\pitch_stretch, Pseq([0.99,1.01,1],inf).stutter(3),
	\time_stretch, 1,
	\time_stretch, Pseq([1.03,1.01],inf).stutter(3),
	\isRest, Veco(~namex).isrest(16),
	\randrate, 0,
	\randframes, 0,
	\pos, Ndef(~name+++\lfo1),
	\pos, Pseq([0,0.3,0.3,0.2]+0.13,inf),
	//\pos, Pseq([0,0.3,0.3,0.2]+0.13,inf),
	\pos, 0.2,
	\dur, 1/4,
	\finepos, 1/Ptempo() * s.sampleRate,
	\finepos, Pseq([0,1],inf) * Pkey(\dur) /t * s.sampleRate,
	\finepos, Pseq([0,1,2,3,4],inf)/t,
	\finepos, Pseq([0],inf)/t,
	\finepos, Pdefn(~name+++\finepos) + Pseq([0,1,2,3],inf).stutter(1)/t/4,
	\legato, 0.71,
	\amp, 1 * Pkey(\amp),
	\freq, 100,
));
);

// END
Pdef(~name).quant = nil

s.sampleRate
2/t * s.sampleRate
t
s.sampleRate
BufDef.mono(\booba)
