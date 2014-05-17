Pdef(~name +++ \pre, 
	~lmorphpat.(
		[
			Sdef(~name, \mypreset).getsub(0).pbind,
			Sdef(~name, \mypreset).getsub(1).pbind,
			Sdef(~name, \mypreset).getsub(2).pbind,
		],
		//Pseq([0,0.5,1],inf)
		//Sdef(~name, \morph).vals[\morph].valpattern
		Sdef(~name, \morph).get_active_score.vals[\morph].valpattern
	)
	<> Pbind(
		\name, ~name,
		\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.1], [-4, -2, -4]) ],
		\env1, [ Env.new([120, 59, 29], [0.005, 0.29], [-4, -5]) ],
	)
);

// END

Sdef(~name, \mypreset).edit
Sdef(~name, \mypreset).rebuild(true)
Sdef(~name, \mypreset).delete(0)

~score_storage.all[\1][\morph]

Sdef(~name, \mypreset)
Sdef(~name, \mypreset).get(0)
Sdef(~name, \mypreset).get(0,2).vals[\fratio].val
Sdef.force(~name, \morph, \preset, [\morph, \unipolar.asSpec])
Sdef.force(~name, \morph, \preset, [\morph, \unipolar.asSpec, \mdur, ControlSpec(0,7,\lin,1,1)])
Sdef(~name, \morph).edit
Sdef(~name, \morph).delete(0)
Sdef(~name, \morph).rebuild(true)
MIDIBoard.map(\k2, Sdef(~name, \morph), \morph)
MIDIBoard.map(\k1, Sdef(~name, \morph), \mdur)

		Sdef(~name, \morph).vals[\morph].valpattern
		Sdef(~name, \morph).vals[\mdur].valpattern
		Sdef(~name, \morph).get_active_score.vals[\morph].valpattern
		Sdef(~name, \morph).get_active_score.vals[\morph].get_val
		Sdef(~name, \morph).get_active_score.vals[\mdur].get_val
		2**1 * 1/8
VecoLib.load_lib
