
(
MIDIBoard.map(\play, {
	~name = 't';
	~set_macro.(\k1, Pdef(~name+++\macro), \env0_timescale, ControlSpec(0.01,4,\exp, 0,1), 0);
	~set_macro.(\k2, Pdef(~name+++\macro), \midinote_stutter, ControlSpec(1,16,\lin,1,1), 0);
	~set_macro.(\k3, Pdef(~name+++\macro), \restprob, ControlSpec(0,0.5,\lin,0,0), 0);
	~name = 'r';
	~set_macro.(\k4, Sdef(~name, \mypreset_morph_0), \morph, nil,0);
})
);
