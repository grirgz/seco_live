SynthDef(\modenv, { arg out=0, amp=0.1, gate=1;
	var sig;
	sig = EnvGen.kr(\env.kr(Env([1,2,1],[0.1,0.8])), gate, doneAction:2);
	Out.kr(out, sig);
}).store;

(
Pdef(\test, Pbind(
	\instrument, \default,
	\freq, ~pmodenv.(Pseq([200,2300,1300],inf), Pseq([1,2],inf)),
	\dur, 1/4,
	\amp, 0.1,
)).play;
)

60.5.midicps
61.midicps
{ MdaPiano.ar(60.5.midicps)*0.1!2 }.play
{ MdaPiano.ar(61.midicps)*0.1!2 }.play
{ MdaPiano.ar( XLine.kr(100,400,10))*0.1!2 }.play


(
Pdef(\test, Pbind(
	\instrument, \default,
	\bla, Prout({ arg ev;
		bla = EventStreamCleanup.new;
		inf.do {

			ev.debug("ev");
			1.yield;
		}
	}),
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1,
)).play;
);
