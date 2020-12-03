(
Pdef.defaultQuant = 2;
//Ndef.defaultQuant = 1;
~t = 135/4/60; TempoClock.default.tempo = ~t;
s.waitForBoot {
	"lib.scd".loadRelative;
	//FileSystemProject.load("capsule/lib.scd");

	FileSystemProject.load("libdef/mixerPreset.scd");

	FileSystemProject.load("capsule/ile_lib.scd");
	FileSystemProject.load("capsule/mainwindow.scd");
	FileSystemProject.load("capsule/track1.scd");
	FileSystemProject.load("capsule/draftsynth.scd");
	FileSystemProject.load("capsule/PatKitDef_ksh.scd");
	FileSystemProject.load("holis/synthdef.scd");

};
);


{ SinOsc.ar(2500) ! 2 * 0.1}.play;
ParamProto.init(true)
ProtoDef(\piano).startControl()
SCVim.generateTagsFile
Help.gui
SCDoc.findHelpFile("Pdef")
HelpBrowser.openHelpFor("Pdef")
SCDoc.indexAllDocuments(clearCache: false) // regenerate

MIDIClient.list
MIDIClient.init
MIDIClient.restart

(


	// define channels
	Pdef(\kick, Pbind(
		\out, BusDef(\mixer0, \audio),
	));
	Pdef(\snare, Pbind(
		\out, BusDef(\mixer1, \audio),
	));
	Pdef(\hat, Pbind(
		\out, BusDef(\mixer2, \audio),
	));
	Pdef(\bass, Pbind(
		\out, BusDef(\mixer3, \audio),
	));
	Pdef(\pad, Pbind(
		\out, BusDef(\mixer4, \audio),
	));
	Pdef(\piano, Pbind(
		\out, BusDef(\mixer5, \audio),
	));

	// less generic name to avoid name clash
	Pdef(\c_kick, Pbind(
		\out, BusDef(\mixer0, \audio),
	));
	Pdef(\c_snare, Pbind(
		\out, BusDef(\mixer1, \audio),
	));
	Pdef(\c_hat, Pbind(
		\out, BusDef(\mixer2, \audio),
	));
	Pdef(\c_bass, Pbind(
		\out, BusDef(\mixer3, \audio),
	));
	Pdef(\c_pad, Pbind(
		\out, BusDef(\mixer4, \audio),
	));
	Pdef(\c_piano, Pbind(
		\out, BusDef(\mixer5, \audio),
	));
	Pdef(\c_drums, Pbind(
		\out, BusDef(\mixer6, \audio),
	));

	BusDef(\mixer6, \audio);
	BusDef(\mixer7, \audio);
	BusDef(\mixer8, \audio);




	ProtoDef(\simpleMixer).tracks[0].proxy.set(\send0, 1);
	ProtoDef(\simpleMixer).tracks[1].proxy.set(\send0, 1);
	ProtoDef(\simpleMixer).tracks[2].proxy.set(\send0, 1);
	ProtoDef(\rdn).outBus = BusDef(\mixer7, \audio);
	ProtoDef(\rdn).inBus = BusDef(\sendbus1, \audio);
	ProtoDef(\rdn).fxdef = \del3;

	ProtoDef(\rdn2, ProtoTemplateDef(\rdn));
	ProtoDef(\rdn2).outBus = BusDef(\mixer8, \audio);
	ProtoDef(\rdn2).inBus = BusDef(\sendbus2, \audio);
	ProtoDef(\rdn2).fxdef = \del3full;
	ProtoDef(\rdn2).genfx;
	ProtoDef(\rdn2).proxy.set(\indelay, 0.04);

	ProtoDef(\rdn3, ProtoTemplateDef(\rdn));
	ProtoDef(\rdn3).outBus = BusDef(\mixer8, \audio);
	ProtoDef(\rdn3).inBus = BusDef(\sendbus3, \audio);
	ProtoDef(\rdn3).fxdef = \del3full;
	ProtoDef(\rdn3).genfx;
	ProtoDef(\rdn3).proxy.set(\indelay, 0.04);

	7.do { arg idx;
		ProtoDef(\simpleMixer).tracks[idx].proxy.set(\prefader, 1);
		ProtoDef(\simpleMixer).tracks[idx].proxy.set(\postdelay, 0.04);
	};

	~master = {
		ProtoDef(\simpleMixer).play;
		ProtoDef(\rdn).play;
		Ndef(\drumgroup, \busgroup).set(\inbus, BusDef(\sendbus0)).play(BusDef(\mixer6).index, 2);
	};
	~master_simple = {
		ProtoDef(\simpleMixer).play;
		Ndef(\drumgroup, \busgroup).set(\inbus, BusDef(\sendbus0)).play(BusDef(\mixer6).index, 2);
	};


);

~startControl.();


(
	~master.();
	Pdef(\main, 
		Pseq([
			Pdef(\track1),
			Rest(8),
			Pdef(\drbass),
			Rest(8),
			Pdef(\track2),
		])
	).play;
)

// END

////////////// CONTROL

WindowDef(\main).front;

ProtoDef(\rdn).edit;
ProtoDef(\rdn2, ProtoTemplateDef(\rdn));
ProtoDef(\rdn2).edit;
ProtoDef(\rdn).inbus
ProtoDef(\simpleMixer).edit;
~master.()

	(
	~master2 = {
		ProtoDef(\simpleMixer).play;
		ProtoDef(\rdn).play;
		ProtoDef(\rdn2).play;
		Ndef(\drumgroup, \busgroup).set(\inbus, BusDef(\sendbus0)).play(BusDef(\mixer6).index, 2);
	};
	)




Refresh the list of available sources and destinations.
If you have connected a MIDI device after MIDIClient initialization, you won't see it until this method is run.
	////////////////
MIDIClient.destinations


This is Linux specific code.
The function takes care of initializing MIDIClient, detects a MIDI device named SE25 and connects it to port 0 of SuperCollider.



(
~connect_midi_devices = { 
	// init or refresh MIDIClient end points
	if(MIDIClient.initialized == false) { 
		MIDIClient.init; 
	} {
		MIDIClient.list; 
	};

	MIDIClient.sources.do({ arg endPoint;
		if(endPoint.device == "SE25" and: { endPoint.name == "SE25 MIDI 1" }) {
			// catch exception thrown when already connected
			try {
				// connect SuperCollider out port 0 to MIDI device
				MIDIOut.connect(0, endPoint.uid); 
			};
			try {
				// connect MIDI device to SuperCollider in port 0
				MIDIIn.connect(0, endPoint.uid); 
			}
		}
	})

}
)


~connect_midi_devices = { 
	var device_se25;

	// init or refresh MIDIClient end points
	if(MIDIClient.initialized == false) { 
		MIDIClient.init; 
	} {
		MIDIClient.list; 
	};

	MIDIClient.destinations.do({ arg endPoint;
		if(endPoint.device == "iCON iControls V2.00" and: { endPoint.name == "iCON iControls V2.00 MIDI 1" }) {
			MIDIOut.connect(0, endPoint.uid); // connect in jackd
			MIDIIn.connect(0, endPoint.uid); // connect in jackd
		}
	})

}
~connect_midi_devices.()


~connect_jack_device = { arg idsymbol;
	"==== %: Device id = %".format(idsymbol, topEnvironment[idsymbol]).debug;
	if(topEnvironment[idsymbol].notNil) {
		try {
			MIDIOut.connect(0, topEnvironment[idsymbol]);
		} {
			"%: Probably already connected out".format(idsymbol).debug;
		};
		try {
			MIDIIn.connect(0, topEnvironment[idsymbol]);
		} {
			"%: Probably already connected in".format(idsymbol).debug;
		};
	} {
		"%: Device id is nil".format(idsymbol).debug;
	};
};

~connect_jack = {
	~launchpad_device_id = MIDIIn.findPort ("Launchpad S", "Launchpad S MIDI 1") !? (_.uid);
	~icon_device_id = MIDIIn.findPort ("iCON iControls V2.00", "iCON iControls V2.00 MIDI 1") !? (_.uid);
	~apro_device_id = MIDIIn.findPort ("A-PRO", "A-PRO MIDI 2") !? (_.uid);
	~apc_device_id = MIDIIn.findPort ("APC40 mkII", "APC40 mkII MIDI 1") !? (_.uid);
	~nektar_device_id = MIDIIn.findPort ("SE25", "SE25 MIDI 1") !? (_.uid);

	[\launchpad_device_id, \icon_device_id, \apro_device_id, \apc_device_id, \nektar_device_id].do(~connect_jack_device);
};

~restart_jack = {

	MIDIClient.list; // yes!!! stupid name for a refresh
	//MIDIClient.destinations.debug;
	//MIDIClient.restart;// does nothing
	//MIDIClient.disposeClient; // does nothing
};

~initialize_jack = {
	if(MIDIClient.initialized == false) { 
		MIDIClient.init; 
		//"~/bin/launchpad_connect".standardizePath.unixCmd;
		//"jack_connect A-PRO:midi/playback_2 SuperCollider:midi/capture_1".unixCmd;
	} {
		"Midi already initialized, just connect.";
		//MIDIClient.restart;
		MIDIClient.list; // yes!!! stupid name for a refresh
	};

	~connect_jack.();
	//~launchpad_device_id = MIDIIn.findPort ("Launchpad S-Launchpad S MIDI 1", "Launchpad S-Launchpad S MIDI 1") !? (_.uid);
	//~icon_device_id = MIDIIn.findPort ("iCON iControls V2.00-iCON iControls V2.00 MIDI 1", "iCON iControls V2.00-iCON iControls V2.00 MIDI 1") !? (_.uid);
	//MIDIOut(0).connect( MIDIClient.destinations.detectIndex { arg x; x.device == "Launchpad S-Launchpad S MIDI 1" } );
	//MIDIOut(0).connect( MIDIClient.destinations.detectIndex { arg x; x.device == "iCON iControls V2.00-iCON iControls V2.00 MIDI 1" } );

	// this worked in 3.7alpha
	//MIDIOut(0).connect( MIDIClient.destinations.detectIndex { arg x; x.device == "Launchpad S" } );
	//MIDIOut(0).connect( MIDIClient.destinations.detectIndex { arg x; x.device == "iCON iControls V2.00" } );
	//MIDIIn.connect(0, ~launchpad_device_id);
	//MIDIIn.connect(0, ~icon_device_id);
};

(
{
var n = 30;
var f0 = 200;
var freqs = Array.fill(n, {arg i; f0*(i+1)});
var amps = Array.fill(n, {arg i; 1/(i+1)});
var filtered_amps = n.collect {arg i; SelectX.kr(freqs[i] < MouseX.kr(80,10000,\exponential), [ amps[i] , 0 ])};
var sig = Mix.ar(SinOsc.ar(freq:freqs, mul:filtered_amps));
Pan2.ar(sig*0.5, 0.0);
}.play;
)

NoteTimeline(\bla).edit
ClipTimeline(\bla).edit
{ SinOsc.ar(500) ! 2 * 0.1}.play;
