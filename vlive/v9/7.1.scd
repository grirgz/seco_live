Ndef(~name+++\fx).play;
Ndef(~name+++\fx).put(1, \set -> Pbind(
	\lfo, Pseq([10],inf),
	\lfo, 100,
	\lfo, Pseq([0.1,50,0.1,10],inf),
	\dur, 1/4,
));

Ndef(~name+++\lfo2, { XLine.kr(200,3000,4) });
Ndef(~name+++\lfofreq, { Pulse.kr(1).range(200,300) });
Pdef(~name +++ \pre, Pbind(
	\freq, Ndef(~name+++\lfofreq).bus.asMap,
	\freq, Ptuple([
		Place([50,[100,200],100,[250,260,270]],inf),
		Place([[100,200],150,[250,260,270]],inf),
	]),
	\attackTime, Pseq([0.01,0.1,0.5],inf),
	\fenvamount, Ndef(~name+++\lfo1, { SinOsc.kr(1).range(0.1,3) }),
	\dur, 1/4,
	\legato, 1.5,
	\gain, Pseq([2,0.1,1],inf),
	\cutoff, Ndef(~name+++\lfo2),

));

// END

Ndef(~name+++\fx_lfo, { arg lfo; DC.kr(lfo) });
Ndef(~name+++\fx_lfo).put(1, \set -> Pbind(
	\lfo, Pseq([10],inf),
	\lfo, Pseq([0.1,5,0.1,10],inf),
	\dur, 1/4,
));
Ndef(~name+++\fx).map(\lfo, Ndef(~name+++\fx_lfo));
Ndef(~name+++\fx).unmap(\lfo);
Ndef(~name+++\fx_lfo1, \setsrc -> Pbind(
	\source, Pseq([1,100,06],inf),
));
