

(
MIDIMap(\c1, { 
	//var node = Veco.project_slots[0][\veco].get_node_by_index(34);
	var node = Veco(16);
	~midi_macro_manager.map_node_macro_to_knobs(node); 
});
MIDIMap(\c2, { 
	//var node = Veco.project_slots[0][\veco].get_node_by_index(35);
	var node = Veco(17);
	~midi_macro_manager.map_node_macro_to_knobs(node); 
});
MIDIMap(\c3, { 
	~midi_macro_manager.map_sendpad_to_knobs(0);
	~midi_macro_manager.map_sendpad_to_faders(1);
});
MIDIMap(\c4, { 
	var node1 = Veco(16);
	var node2 = Veco(17);
	var fx1 = Ndef(node1.uname+++\fx);
	var fx2 = Ndef(node2.uname+++\fx);
	MIDIMap(\k1, Param(Ndef(node1.uname+++\mixer), \amp, \unipolar));
	MIDIMap(\k2, Param(fx1, \wet10, \unipolar));
	MIDIMap(\k3, Param(fx1, \wetamp, ControlSpec(0,4,\lin)));
	MIDIMap(\k4, Param(fx1, \mamp, ControlSpec(0,4,\lin)));

	MIDIMap(\s1, Param(Ndef(node2.uname+++\mixer), \amp, \unipolar));
	MIDIMap(\s2, Param(fx2, \wet10, \unipolar));
	MIDIMap(\s3, Param(fx2, \wetamp, ControlSpec(0,4,\lin)));
	MIDIMap(\s4, Param(fx2, \mamp, ControlSpec(0,4,\lin)));
});
MIDIMap(\stop, { 
	{
		topEnvironment[\meterview].debug("meter");
		if(topEnvironment[\meterview].notNil) {
			if(topEnvironment[\meterview].window.notNil) {
				topEnvironment[\meterview].window.close;
			};
		};
		topEnvironment[\meterview] = s.meter;
	}.defer;
});

MIDIMap(\c7, { 
	//var node = Veco.project_slots[0][\veco].get_node_by_index(34);
	var node = Veco(16);
	Ndef(node.uname+++\fx).set(\shift, 0);
	Ndef(node.uname+++\fx).set(\shift2, 0);
});
MIDIMap(\c8, { 
	//var node = Veco.project_slots[0][\veco].get_node_by_index(35);
	var node = Veco(17);
	Ndef(node.uname+++\fx).set(\shift, 0);
	Ndef(node.uname+++\fx).set(\shift2, 0);
});
);

// END

topEnvironment[\meterview]
	~xxnode = Veco.project_slots[0][\veco].get_node_by_index(35);
	~xxnode.uname
Ndef(~name+++\mixer).edit
MIDIMap(\a2, { "fuck".postln });

Veco.project_slots[0]

Ndef(\bla, { arg fra=3; })
Ndef(\bla).getHalo(\spec)
Spec.add(\fra, ControlSpec(0,123,\lin))
Ndef(\bla).addHalo(\spec, ())
Ndef(\bla).addSpec(\fra, ControlSpec(0,1,\lin))
Ndef(\bla).addSpec(\fra, nil)
