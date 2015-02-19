
EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:doneAction);

(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\adsr, [ Env.adsr(0.1,0.1,0.8,0.1) ],
	\dur, 1,
	\amp, 0.1
)).play;
);
