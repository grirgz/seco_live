
(
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
]);
MIDIBoard.permanent = true;
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
