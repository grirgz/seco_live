
(
MIDIBoard.map(\k1, Ndef(~masterfx+++\fx), \wet5, \unipolar.asSpec);
MIDIBoard.map(\k2, Ndef(~masterfx+++\fx), \stutter, ControlSpec(0.1,200,\exp, 0,1));
MIDIBoard.map(\k3, Ndef(~masterfx+++\fx), \time, ControlSpec(0.1,2,\exp, 0,1));
MIDIBoard.map(\k4, Ndef(~masterfx+++\fx), \offset, \unipolar.asSpec);
MIDIBoard.map(\k5, Ndef(~masterfx+++\fx), \wet10, \unipolar.asSpec);
MIDIBoard.map(\k6, Ndef(~masterfx+++\fx), \freqshift, \freqshift.asSpec);
MIDIBoard.map(\k7, Ndef(~masterfx+++\fx), \wet20, \unipolar.asSpec);
MIDIBoard.map(\k8, Ndef(~masterfx+++\fx), \ffreq, \freq.asSpec);
MIDIBoard.map(\k9, Ndef(~masterfx+++\fx), \pvcutoff, \bipolar.asSpec);
MIDIBoard.map(\s9, Ndef(~masterfx+++\fx), \mix, \unipolar.asSpec);
)
// END
(
MIDIBoard.map(\k1, Ndef(~masterfx+++\fx), \diff, \unipolar.asSpec);
MIDIBoard.map(\k2, Ndef(~masterfx+++\fx), \feedback, \unipolar.asSpec);
MIDIBoard.map(\k3, Ndef(~masterfx+++\fx), \time, ControlSpec(0.1,2,\exp, 0,1));
MIDIBoard.map(\k4, Ndef(~masterfx+++\fx), \offset, \unipolar.asSpec);
MIDIBoard.map(\k5, Ndef(~masterfx+++\fx), \wet10, \unipolar.asSpec);
MIDIBoard.map(\k6, Ndef(~masterfx+++\fx), \freqshift, \freqshift.asSpec);
MIDIBoard.map(\k7, Ndef(~masterfx+++\fx), \wet20, \unipolar.asSpec);
MIDIBoard.map(\k8, Ndef(~masterfx+++\fx), \ffreq, \freq.asSpec);
MIDIBoard.map(\k9, Ndef(~masterfx+++\fx), \amp, \amp.asSpec);
MIDIBoard.map(\s9, Ndef(~masterfx+++\fx), \mix, \unipolar.asSpec);
)

(
MIDIBoard.map(\k1, Ndef(~masterfx+++\fx), \wet5, \unipolar.asSpec);
MIDIBoard.map(\k2, Ndef(~masterfx+++\fx), \stutter, ControlSpec(0.1,200,\exp, 0,1));
MIDIBoard.map(\k3, Ndef(~masterfx+++\fx), \time, ControlSpec(0.1,2,\exp, 0,1));
MIDIBoard.map(\k4, Ndef(~masterfx+++\fx), \offset, \unipolar.asSpec);
MIDIBoard.map(\k5, Ndef(~masterfx+++\fx), \wet10, \unipolar.asSpec);
MIDIBoard.map(\k6, Ndef(~masterfx+++\fx), \freqshift, \freqshift.asSpec);
MIDIBoard.map(\k7, Ndef(~masterfx+++\fx), \wet20, \unipolar.asSpec);
MIDIBoard.map(\k8, Ndef(~masterfx+++\fx), \ffreq, \freq.asSpec);
MIDIBoard.map(\k9, Ndef(~masterfx+++\fx), \amp, \amp.asSpec);
MIDIBoard.map(\s9, Ndef(~masterfx+++\fx), \mix, \unipolar.asSpec);
)

MIDIBoard.map(~ndef_to_macros.(Ndef(~masterfx+++\fx)))
Veco(~masterfx).lib.macros = ~ndef_to_macros.(~masterfx+++\fx)
