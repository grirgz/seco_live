
Pdef(~name +++ \pre, Pbind(
	\pos, Pseq([0,0.1,0.2,0.3,5],inf) + Pwhite(0.0,0.12),
	//\speed, Pseq([2.1,0.5,0.25,1, 1.2,0.5,1.1,1.2],inf)/1.2 * Pseq([0.91,0.8],inf).stutter(16) * Pwhite(0.95,1.061),
	\speed, Ndef(~name+++\lfo1, { SinOsc.kr(SinOsc.kr(0.1).range(0.1,5)).range(0.2,0.8) }),
	\dur, 1/4 * Pwhite(0.9,1.1),
	\amp, Pkey(\amp) *4.5,
	\sustain, Pwhite(0.40,0.95),
));
