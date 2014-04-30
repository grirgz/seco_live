Sdef(~name, \mypreset).busmorph([0,1],0);
Sdef(~name, \mypreset).busmorph([2,3],1); 
Pdef(~name +++ \pre, Sdef(~name, \mypreset).superbusmorph([0,1]) <> Pbind(
	\freq, 100,
	\dur, 1/4,
	\isRest, Veco(~namex).isrest(16),
));

// END

Sdef(~name, \mypreset);
Sdef(~name, \mypreset).edit
Sdef(~name, \mypresetmorph).edit
MIDIBoard.map(\k1, Sdef(~name, \mypreset_morph_default), \morph)
(
	MIDIBoard.map(\k1, [
		[Sdef(~name, \mypreset_morph_0), \morph],
		[Sdef(~name, \mypreset_morph_1), \morph],
	]);
	MIDIBoard.map(\k2, Sdef(~name, \mypreset_supermorph_default), \morph);
)
(
MIDIBoard.map(\k1, Sdef(~name, \mypreset_morph_0), \morph);
MIDIBoard.map(\k2, Sdef(~name, \mypreset_morph_1), \morph);
MIDIBoard.map(\k3, Sdef(~name, \mypreset_supermorph_default), \morph);
)
Sdef(~name, \mypreset).busmorph([0,1]) 
Sdef(~name, \mypreset).busmorpher.vpattern
Sdef(~name, \mypreset).busmorpher.do(_.set_bus_mode(true))
Sdef(~name, \mypreset).busmorpher.keys
Sdef(~name, \mypreset).busmorpher[\_supermorph_default].get_event
Sdef(~name, \mypreset).busmorpher[\_morph_0].vals[\adsr].get_env
Sdef(~name, \mypreset).busmorpher[\_morph_0].vals[\adsr].get_env
Sdef(~name, \mypreset).get(0).get_event
Sdef(~name, \mypreset).get(0).vals[\adsr].get_val
(
	
~a = [Sdef(~name, \mypreset).get(0).vals[\adsr].get_val,
Sdef(~name, \mypreset).get(0).vals[\adsr].get_val];
~a.blendAt(1)
)
