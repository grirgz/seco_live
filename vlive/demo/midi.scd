
MIDIClient.init; // needed to have jack see supercollider midi
// there is a bug that add SC output each time i run

MIDIClient.sources[3].name
MIDIClient.sources
MIDIClient.restart; // does nothing
MIDIClient.disposeClient; // does nothing

MIDIIn.findPort ("SE25", "SE25 MIDI 1");

MIDIClient.list; /// YES!!! this refresh the list! // but fail sometime with 
k
]kk

MIDIEndPoint

(
MIDIClient.sources.collect({ arg con;
	con.name.postln;
	con.device.postln;

})
)

(
MIDIdef.noteOn(\piano, { arg ... args;
	args.postln;
	
});
)
