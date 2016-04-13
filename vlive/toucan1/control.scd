

(
MIDIMap(\c1, { 
	var node = Veco.project_slots[0][\veco].get_node_by_index(34);
	~midi_macro_manager.map_node_macro_to_knobs(node); 
});
MIDIMap(\c2, { 
	var node = Veco.project_slots[0][\veco].get_node_by_index(35);
	~midi_macro_manager.map_node_macro_to_knobs(node); 
});
MIDIMap(\c3, { 
	~midi_macro_manager.map_sendpad_to_knobs(2);
	~midi_macro_manager.map_sendpad_to_faders(3);
});
);

// END

Ndef(~name+++\mixer).edit
MIDIMap(\a2, { "fuck".postln });

Veco.project_slots[0]

Ndef(\bla, { arg fra=3; })
Ndef(\bla).getHalo(\spec)
Spec.add(\fra, ControlSpec(0,123,\lin))
Ndef(\bla).addHalo(\spec, ())
Ndef(\bla).addSpec(\fra, ControlSpec(0,1,\lin))
Ndef(\bla).addSpec(\fra, nil)
