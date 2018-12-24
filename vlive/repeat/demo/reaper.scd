

MIDIClient.init
(
	~keys = nil!127;
MIDIdef.noteOn(\track1, { arg ... args;
	var midinote;
	args.postln;
	midinote = args[1];
	if(~keys[midinote].notNil) {
		~keys[midinote].release;
	};
	~keys[midinote] = Synth(\default, [\freq, args[1].midicps])
	
});
MIDIdef.noteOff(\track1_off, { arg ... args;
	var midinote;
	args.postln;
	midinote = args[1];
	~keys[midinote].release; 
	~keys[midinote] = nil;
	
});
)

//////////////////:



(
~connectTrack = { arg trackid, player;
	
}
)
