
//~apro_device_id = 1572865;
//MIDIdef.noteOn(\test, { arg ... args; args.debug("piano.scd: test"); });

(
MIDIMap.permanent = true;
MIDIMap.define([nil, ~apro_device_id], [
	\aphome, 34,
	\apleft, 35,
	\apright, 36,
	\apend, 37,
	\apstop, 38,
	\applay, 39,
	\appause, 40,
	\aprecord, 41,
	\aphold, 42,

	\apb1, 43,
	\apb2, 44,
	\apb3, 45,
	\apb4, 46,

	\apk1, 16,
	\apk2, 17,
	\apk3, 18,
	\apk4, 19,
	\apk5, 20,
	\apk6, 21,
	\apk7, 22,
	\apk8, 23,
	\apk9, 24,

	\aps1, 25,
	\aps2, 26,
	\aps3, 27,
	\aps4, 28,
	\aps5, 29,
	\aps6, 30,
	\aps7, 31,
	\aps8, 32,
	\aps9, 33,

	\apa1, \note -> [43, 9],
	\apa2, \note -> [47, 9],
	\apa3, \note -> [50, 9],
	\apa4, \note -> [49, 9],
	\apa5, \note -> [36, 9],
	\apa6, \note -> [38, 9],
	\apa7, \note -> [42, 9],
	\apa8, \note -> [46, 9],

]);
);

// END

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
