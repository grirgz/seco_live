

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


/////////////////////////

~
