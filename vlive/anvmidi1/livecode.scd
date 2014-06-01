
//Ndef(\amixer).set(\amp, 1)
Ndef(\amixer).unset(\amp)
(

Ndef(\amixer).put(5000, \set -> 
	Pbind(
		\amp, Pseq([1,0,1,0],inf),
		\dur, 1/2,
	)
)
)

(

Ndef(\rmixer).put(5000, \set -> 
	Pbind(
		\amp, Pseq([0,1,1,0],inf),
		\dur, 1/2 + (1/8),
	)
)
)
Ndef(\rmixer).quant = Pdef.defaultQuant;
Ndef(\amixer).quant = Pdef.defaultQuant;
