(
//Ndef(~name+++\lfo1, { SinOsc.kr([1,0.3]).range(0.1,1) });
Ndef(~name+++\lfo1, { [SinOsc.kr(1).range(2,3), SinOsc.kr(0.1).range(0.2,0.4)] });
//Ndef(~name+++\lfo1, { SinOsc.kr(1).range(0.1,1) });
Pdef(~name +++ \pre, 
	//~morphpat.(Sdef(~name, \mypreset).getsub(0).pbind, Sdef(~name, \mypreset).getsub(1).pbind, Pseq(Array.series(8,0,1/8),inf))
	//~morph.(\morph, 0.5, Sdef(~name, \mypreset).getsub(0).pbind <> Pbind(\amp, 0.1))
	//~morphpat.(Sdef(~name, \mypreset).getsub(0).pbind, Sdef(~name, \mypreset).getsub(1).pbind, 0)
	Pbind(
		\freq, 200,
		\freqtab, [[1.1,3.7]],
		\freqtab, [Ndef(~name +++ \lfo1).busArg],
		\legato, 1,
));
)
// END

Ndef(~name +++ \lfo1).bus
Ndef(~name +++ \lfo1).busArg
Ndef(~name +++ \lfo1).asBus

Sdef(~namex, \mypreset).edit;
Sdef(~name, \mypreset).rebuild
Sdef(~name, \mypreset).pbind.asStream.next(Event.default)

(
Pdef(~name +++ \pre, Sdef(~name, \mypreset).getsub(0).pbind <> Pbind(
	\freq, 100,
		\legato, 1,
));
)

(
Pdef(~name +++ \pre, Sdef(~name, \mypreset).getsub(1).pbind <> Pbind(
	\freq, 100,
		\legato, 1,
));
)
