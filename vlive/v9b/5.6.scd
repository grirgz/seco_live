
Ndef(~name+++\lfo2, { LFSaw.kr(1/2).range(700,3000) });
//Ndef(~name+++\lfofreq, { Pulse.kr(2).range(200,300) });
Ndef(~name+++\lfofreq, { Pulse.kr(2).range(20,30) + LFSaw.ar(1).range(0,100)});
Pdef(~name +++ \pre, Pbind(
	\freq, Ndef(~name+++\lfofreq).bus.asMap,
	\attackTime, Pseq([0.01,0.1,0.5],inf),
	\fenvamount, Ndef(~name+++\lfo1, { SinOsc.kr(49).range(0.1,5) }),
	\dur, 1/8,
	\gain, Pseq([2,0.1,1],inf),
	\cutoff, Ndef(~name+++\lfo2),

));

// END
