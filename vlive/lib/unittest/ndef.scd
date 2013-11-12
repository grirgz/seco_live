
/// launch two lfo
(
Ndef(\fx, { arg freq=100;
	SinOsc.ar(freq)
});
//30000.do { arg x; x.postln; };
Ndef(\lfo, {
	SinOsc.kr(1).range(100,200)
});
Ndef(\fx).map(\freq, Ndef(\lfo));
)

//////////////////////////////////////

(
// block pbind
Ndef(\fx).put(1, \set -> Pbind(\freq, Pseq([100,200],200)));
Ndef(\fx, { arg freq=100;
	SinOsc.ar(freq) ! 2
}).play;

)
(
// no blocking
Ndef(\fx, { arg freq=100;
	SinOsc.ar(freq) ! 2
}).play;
Ndef(\fx).put(1, \set -> Pbind(\freq, Pseq([100,200],200)));
)

//////////////////////////////////////

(
	
Ndef(\fx, { arg freq=100;
	SinOsc.ar(freq) ! 2
});
)
Ndef(\fx).end
Ndef(\fx)
(
// no blocking
Ndef(\fx).play;
Ndef(\fx).put(1, nil);
Ndef(\fx).put(1, \set -> Pbind(\freq, Pseq([100,200,300,400,500],200)));
)
