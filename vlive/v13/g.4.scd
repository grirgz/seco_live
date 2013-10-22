(
~dur = 1/8;
Ndef(~name+++\lfo1, { LFSaw.kr(t / ~dur * 1/8).range(30,1770)  });
Pdef(~name +++ \pre, Pbind(
	//\freq, Pseq([100,50],inf).stutter(4),
	//\freq, 50,
	\degree, Prand([0,1,2,3,4,5,6,7,8],inf).stutter(4),
	\degree, Prand([0,2,4,7],inf),
	\freq, Ndef(~name+++\lfo1).bus.asMap,
	\mtranspose, Pstep(Pseq([
		-2,-1, 5,5,4,2,
		0,2,0,4,4,-3,
	],inf),2),
	\mtranspose, Pseq([0,0],inf),
	\octave, 3,
	\ffscale, Pseq([1,4,8],inf).stutter(8),
	//\detune, [1,0.401],
	\isRest, Veco(~namex).isrest(16),
	//\sustain, Prand([2,1.3,0.6,0.3,0.1],inf),
	//\lag, Prand([0.01,0],inf),
	//\sustain, 0.2,
	//\sustain, Prand([0.2,0.3,0.1],inf),
	\legato, Pseq([4,1,2,1],inf),
	\legato, Pseq([4],inf),
	\dur, ~dur,
	\amp, 1.0 * Pkey(\amp),
));
);
