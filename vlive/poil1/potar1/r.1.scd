
// END
(
~myfx = '32fx';
ProxyChain(~myfx).proxy.put(21, \set -> Pbind(
	\hif, Pseq([100,1000,3000],inf),
	\fkdjf, Pfunc({"kjkj".postln; 1}),
	\dur, 1,

));
)
Ndef(~myfx).sources

Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([1],inf),
	\dur, 1,
));

(
~myfx = '32fx';
ProxyChain(~myfx).proxy.add(\bla, \set -> Pbind(
	\hif, Pseq([100,1000,3000],inf),
	\fkdjf, Pfunc({"kjkj".postln; 1}),
	\dur, 1,

));
)
