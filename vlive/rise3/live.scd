Ndef(~masterfx+++\fx).set(\decay, 0.1)
MIDIBoard.map(\k1, Ndef(~masterfx+++\fx), \decay, ControlSpec(0.001,1,\exp))
MIDIBoard.map(\k9, Ndef(~masterfx+++\fx), \amp, ControlSpec(0.001,2,\exp))
MIDIBoard.map(\k8, Ndef(~masterfx+++\fx), \feedback, ControlSpec(0.0001,1,\exp))
