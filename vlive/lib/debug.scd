Sdef(~name, \mypreset).get_active_score.edit
Sdef(~name, \mypreset).get_active_score.score_view
Sdef(~name, \mypreset).get_active_score.score_view.control_views

Veco.main.node_unames
Veco.main.project_path
Veco.main.project_name
PathName(Veco.main.project_path).asRelativePath(~path);
Veco.user_path
~path = ~strip_end_slash.(Veco.user_path)


////////////////////////////////////////////


MIDIBoard.controls[\loop]
MIDIBoard.map(\loop, { "plop".postln; });
(

	MIDIBoard.map(\k1, [
		[Ndef(Veco.main.get_node_by_index(0).uname+++\mixer), \preamp, \unipolar.asSpec],
		[Ndef(Veco.main.get_node_by_index(1).uname+++\mixer), \preamp, \unipolar.asSpec],
	])

)
Veco.main.get_node_by_index(16).uname
Veco.main.get_node_by_index(0).uname

		Env([0,1,0.3,0.8,0],[1,1,1,1].normalizeSum).at(2)
(
	~spec = (
		env: Env([0,1,0.3,0.8,0],[1,1,1,1].normalizeSum),
		map: { arg self, val;
			self.env.at(val)
		},
		unmap: { arg self, val;
			val
		},
	);

	MIDIBoard.map(\k2, Ndef(Veco.main.get_node_by_index(0).uname+++\mixer), \preamp, ~spec);
	//MIDIBoard.map(\k2, Ndef(Veco.main.get_node_by_index(0).uname+++\mixer), \preamp, ControlSpec(0,0.5,\lin,0,0));

)
~spec.map(1)
~spec.unmap(0.5)
(
	~spec = (
		map: { arg self, val;
			val/2
		},
		unmap: { arg self, val;
			val*2
		},
	);

	MIDIBoard.map(\k2, [
		[Ndef(Veco.main.get_node_by_index(0).uname+++\mixer), \preamp, ~spec],
	])

)
