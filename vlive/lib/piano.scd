
//MIDIdef.noteOn(\test, { arg ... args; args.debug("piano.scd: test"); });

(
MIDIBoard.permanent = true;
MIDIBoard.define(0, [
	\home, 34,
	\left, 35,
	\right, 36,
	\end, 37,
	\stop, 38,
	\play, 39,
	\pause, 40,
	\record, 41,
	\hold, 42,

	\b1, 43,
	\b2, 44,
	\b3, 45,
	\b4, 46,

	\k1, 16,
	\k2, 17,
	\k3, 18,
	\k4, 19,
	\k5, 20,
	\k6, 21,
	\k7, 22,
	\k8, 23,
	\k9, 24,

	\s1, 25,
	\s2, 26,
	\s3, 27,
	\s4, 28,
	\s5, 29,
	\s6, 30,
	\s7, 31,
	\s8, 32,
	\s9, 33,

	\a1, \note -> [43, 9],
	\a2, \note -> [47, 9],
	\a3, \note -> [50, 9],
	\a4, \note -> [49, 9],
	\a5, \note -> [36, 9],
	\a6, \note -> [38, 9],
	\a7, \note -> [42, 9],
	\a8, \note -> [46, 9],

]);
);

(
MIDIBoard.map(\record, { 
	~record_button_state = 1;
	~record_button_state.debug("statex");
}, {
	~record_button_state = 0;
	~record_button_state.debug("state");
});

MIDIBoard.map(\play, { 
	if(~record_button_state == 1) {
		Sdef(~name, \mynotes).record(inf, 16)
	} {
		Veco(~namex).response_on;
	}
});

MIDIBoard.map(\stop, { 
	if(~record_button_state == 1) {
		Sdef(~name, \mynotes).stop_recording
	} {
		Veco(~name).stop_node(true);
	}
});

MIDIBoard.map(\pause, { 
	if(~record_button_state == 1) {
		Sdef(~name, \mynotes).cancel_recording
	} {
		Veco(~name).stop_node;
	}
});

);
