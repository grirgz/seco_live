
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


////////////// midi event

MIDIOut(0) // first midi output port of supercollider

(
Pdef(\zed, 
	Pbind(
		\type, \midi,
		\midicmd, \control,
		\midiout, MIDIOut(0),
		\ctlNum, 3,
		\chan, 10,
		\control, Pwhite(0,127,inf),
	)
).play;
);


/// multichannel test

(
Pdef(\zed, 
	Pbind(
		\type, \midi,
		\midicmd, \control,
		\midiout, MIDIOut(0),
		\chan, 10,
		\ctlNum, [3,4],
		\control, Ptuple([ Pwhite(0,127,inf), Pseq([12,55],inf) ]),
	)
).play;
);

(
Pdef(\zed, 
	Pbind(
		\type, \midi,
		\midicmd, \control,
		\midiout, MIDIOut(0),
		\chan, 10,
	) <> Ppar([
		Pbind(\ctlNum, 3, \control, Pwhite(0,120,inf)),
		Pbind(\ctlNum, 4, \control, Pwhite(0,12,inf)),
	])
).play;
);

// with custom event type

(
Event.addEventType(\custommidi, {
	var ev = currentEnvironment.copy;

	currentEnvironment.copy.put(\type, \midi).put(\midicmd, \noteOn).play;

	if(ev.ctlNum.isSequenceableCollection) {
		var newev = currentEnvironment.copy;
		newev.put(\type, \midi).put(\midicmd, \control);
		ev.ctlNum.do { arg ctlnum;
			newev.ctlNum = ctlnum;
			newev.control = ev[ctlnum];
			//newev.debug("newev");
			newev.play;
		};
	} {
		currentEnvironment.copy.put(\type, \midi).put(\midicmd, \control).play;
	}
});
)

(
Pdef(\zed, 
	Pbind(
		\type, \custommidi,
		\midiout, MIDIOut(0),
		\chan, 0,
		\ctlNum, [3,10],
		3, Pwhite(0,10,inf),
		10, Pwhite(10,20,inf),
	)
).play;
);
Param
