Sdef(~name, \mypreset).busmorph([0,1],0);
Sdef(~name, \mypreset).busmorph([2,3],1); 
Pdef(~name +++ \pre, Sdef(~name, \mypreset).superbusmorph([0,1]) <> Pbind(
	\dur, 1/4,
	\isRest, Veco(~namex).isrest(16),
	\freq, 100,
));

// END

Sdef(~name, \mypreset);
Sdef(~name, \mypreset).edit
Sdef(~name, \mypresetmorph).edit
MIDIBoard.map(\k1, Sdef(~name, \mypreset_morph_default), \morph)
(
	MIDIBoard.map(\k3, [
		[Sdef(~name, \mypreset_morph_0), \morph],
		[Sdef(~name, \mypreset_morph_1), \morph],
	]);
	MIDIBoard.map(\k4, Sdef(~name, \mypreset_supermorph_default), \morph);
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

Pdef(\plop).addSpec(\spec, \freq.asSpec)
Pdef(\plop).getSpec(\spec)
Pdef(\plop).getSpec(\bla)
Pdef(\plop).addHalo(\spec, nil)
Pdef(\plop).getHalo(\spec)
Pdef(\plop).getHalo(\specx)
Object
Pdef(\plop, Pbind(\freq, Pseq([100,200])))

~sp = Pdef(\plop).getHalo(\spec)
~sp.eventAt(\freq)

~a = Bus.control(s, 1)
~a.class == Bus
~a.set(30)
~a.getSynchronous

