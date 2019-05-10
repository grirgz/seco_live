

MIDIdef.cc(\cross, { arg ...xx; xx.postln; }).learn
MIDIdef.cc(\knob1, { arg ...xx; xx.postln; }).learn
48.asHex
0x30


m = MIDIOut(0);

// receive sysex

MIDIdef.sysex(\sysex, { arg ...args; args.postln; }, ~apc_device_id, nil, nil)

// change mode
~apc_device_id
~apc_init_mode = (generic:0x40, live1:0x41, live2:0x42)
m.sysex(Int8Array[0xF0, 0x47, ~apc_device_id, 0x29, 0x60, 0, 0x04, ~apc_init_mode.live1, 0,0,0, 0xF7])

// device inquiry

m.sysex(Int8Array[0xF0, 0x7E, 0x7F, 0x06, 0x01, 0xF7])


// set led position to 100 for know 0x10 (device knob 1)
m.control(0, 0x10, 100)
// set pad color
m.noteOn(0, 0, 123)

////////////////// map rdn

FileSystemProject.load("libdef/apc.scd");
ProtoDef(\apc40).map_rdn_to_bank(0, \rdn, [\delay, \delay2]);
ProtoDef(\apc40).activate_bank_selector


///////////////////////// Pdefgrid

FileSystemProject.load("libdef/pdeftrack.scd");
FileSystemProject.load("libdef/apc.scd");
Pdef(\pdefgrid0_0, Pbind(\note, Pseq([0,1],inf), \dur, 1/8));
Pdef(\pdefgrid0_1, Pbind(\note, Pseq([3,4],inf), \dur, 1/8));
TrackDef(\pdefgrid).edit
ProtoDef(\apc40).activate(TrackDef(\pdefgrid));

////////////////////// ProtoDef(\apc40)

FileSystemProject.load("libdef/apc.scd");

(
ProtoDef(\rdn2, ProtoTemplateDef(\rdn));
TrackDef(\mygrid, TrackTemplateDef(\playergrid));

TrackDef(\mygrid).childAt(0,0).source = Pdef(\part1);
TrackDef(\mygrid).childAt(0,1).source = Pdef(\part2);
ProtoDef(\apc40).activate(TrackDef(\mygrid)); /// map a track group to apc40
	~master = {
		"master!".debug;
		ProtoDef(\apc40).render_grid;
		ProtoDef(\simpleMixer).play;
		ProtoDef(\rdn).play;
		ProtoDef(\rdn2).play;
		//Ndef(\drumgroup, \busgroup).set(\inbus, BusDef(\sendbus0)).play(BusDef(\mixer6).index, 2);
	};
);



// map rdn fx on banks button + knobs
ProtoDef(\rdn).edit
ProtoDef(\rdn2, ProtoTemplateDef(\rdn)).edit

ProtoDef(\apc40).startControl
ProtoDef(\apc40).midimap(\tk1, Param(Pdef(\basicbass), \lpf, \freq))
Param(Pdef(\basicbass), \lpf, \freq).setBusMode
(
ProtoDef(\apc40).bank_actions[0] = { arg self;
	self.midimap(\dk1, Param(Ndef(\rdn), \delay));
	self.midimap(\dk2, Param(Ndef(\rdn), \delay2));
	self.midimap(\dk4, Param(Ndef(\rdn), \fb));
	
	self.midimap(\dk5, Param(Ndef(\rdn), \distamp));
	self.midimap(\dk8, Param(Ndef(\rdn), \gain));
};
ProtoDef(\apc40).bank_actions[1] = { arg self;
	self.midimap(\dk1, Param(Ndef(\rdn2), \delay));
	self.midimap(\dk2, Param(Ndef(\rdn2), \delay2));
	self.midimap(\dk3, Param(Ndef(\rdn2), \delay3));
	self.midimap(\dk4, Param(Ndef(\rdn2), \fb));
	
	self.midimap(\dk5, Param(Ndef(\rdn2), \distamp));
	self.midimap(\dk6, Param(Ndef(\rdn2), \distamp2));
	self.midimap(\dk7, Param(Ndef(\rdn2), \distamp3));

	self.midimap(\dk8, Param(Ndef(\rdn2), \gain));
};
)

///// map rdn editor to shift key
(
Pdef(\echo, 
	Pmono(\fx_echo,
		\inbus, BusDef(\sendbus2),
		\dur, 1,
	),
).play;
Pdef(\echo).addHalo(\instrument, \fx_echo);
Pdef(\echo).addSpec(\pfmix, \unipolar);
		ProtoDef(\apc40).bank_actions[2] = { arg self;
			if(self.shiftModifier) {
				{
				 WindowDef(\PdefEditor).front(Pdef(\echo))
				}.defer;
			} {

				self.debug("se");
				self.mapParam([ \kn, \d, 0 ], Param(Pdef(\echo), \decay).setBusMode);
				self.mapParam([ \kn, \d, 3 ], Param(Pdef(\echo), \mix).setBusMode);

				self.mapParam([ \kn, \d, 4 ], Param(Pdef(\echo), \pfmix).setBusMode);
				self.mapParam([ \kn, \d, 5 ], Param(Pdef(\echo), \lpf).setBusMode);
				self.mapParam([ \kn, \d, 6 ], Param(Pdef(\echo), \hpf).setBusMode);
				self.mapParam([ \kn, \d, 7 ], Param(Pdef(\echo), \gain).setBusMode);

			};
		};
);
