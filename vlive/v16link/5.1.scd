(
//Ndef(~name+++\lfo1, { SinOsc.kr(7/2).exprange(0.5,40) });
Ndef(~name+++\lfo1, { SinOsc.kr([1,1+0.1]*2).exprange(0.5,40).mean });
Ndef(~name+++\lfo1).quant =Pdef.defaultQuant;

Ndef(~name+++\lfo2, { LFSaw.kr([1/2,1/2+0.01]).exprange(0.5,5).mean });
Ndef(~name+++\lfo2).quant =Pdef.defaultQuant;

Pdef(~name +++ \pre, Pbind(
	\dist, Ndef(~name+++\lfo1),
	\fratio, Ndef(~name+++\lfo2),

) <>
Sdef(~name, \mypreset).pdef <> Pbind(
	\freq, 160,
));
)

// END

(
MIDIBoard.define(1, [
	\k1, 1,
	\k2, 2,
	\but1, 35,
]);
)
(

MIDIBoard.map(\k1, Sdef(~name, \mypreset), \dist);
MIDIBoard.map(\k2, Sdef(~name, \mypreset), \fratio);
)

Sdef(~name, \mypreset).get_active_score.pbind
Sdef(~name, \mypreset).get_active_score.vals[\dist].get_val
Sdef(~name, \mypreset).edit
Sdef(~name, \mypreset).pdef.source
Sdef(~name, \mypreset).pdef
Sdef(~name, \mypreset).pbind
Sdef(~name, \mypreset).keys
Sdef(~name, \mypreset).all
~class_score_preset_wrapper
Sdef(~name, \mypreset).rebuild
