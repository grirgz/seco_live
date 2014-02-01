
MIDIBoard.map(\k2, Sdef(\1, \morph), \morph);
//MIDIBoard.map(\k1, Sdef(~name, \morph), \mdur)
MIDIBoard.map(\k3, Sdef(\2, \mypreset), \dmix);
MIDIBoard.map(\k4, Sdef(\2, \mypreset), \dmix2);
MIDIBoard.map(\k5, Sdef(\3, \mypreset), \decay);
MIDIBoard.map(\k6, Sdef(\3, \mypreset), \freqfactor);

MIDIBoard.map(\k7, Ndef('5lfo1'), \freq, \lofreq.asSpec);
MIDIBoard.map(\k8, Ndef('5lfo1'), \mul, \unipolar.asSpec);

MIDIBoard.map(\k1, Sdef(\5, \mypreset), \shift, \freq.asSpec);
MIDIBoard.map(\k2, Sdef(\5, \pat), \legato);

MIDIBoard.map(\s1, Ndef('1mixer'), \amp, \unipolar.asSpec);
MIDIBoard.map(\s2, Ndef('2mixer'), \amp, \unipolar.asSpec);
MIDIBoard.map(\s3, Ndef('3mixer'), \amp, \unipolar.asSpec);
MIDIBoard.map(\s5, Ndef('5mixer'), \amp, \unipolar.asSpec);

// END

MIDIBoard.map(\a1, { "plopSDFSDF".debug });

