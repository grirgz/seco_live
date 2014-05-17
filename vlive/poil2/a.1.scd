

Ndef(~name).ar(2);
Ndef(~name).play(BusDef(~name+++\mixer));
//Ndef(~name).edit

ProxyChain.from(Ndef(~name), [\dust, \ringmod, \dist, \riseComb5, \rlpf]);
//ProxyChain(~name, [\dust, \ringmod, \dist, \riseComb5, \test]);

//ProxyChain(~name).play(BusDef(~name+++\mixer));

ProxyChain(~name).add(\dust, 1);
ProxyChain(~name).add(\ringmod, 0);
ProxyChain(~name).add(\dist, 0);
ProxyChain(~name).add(\riseComb5, 0);


// END

VecoLib.load_lib
Ndef(~name).stop;
ProxyChain(~name)
MIDIBoard.map(\k9, Ndef(~name), \rlpfreq, \freq.asSpec);
MIDIBoard.map(\s9, Ndef(~name), \wet50, \unipolar.asSpec);
MIDIBoard.map(\s9, Ndef(~name+++\lfo1), \freq, \lofreq.asSpec);
MIDIBoard.map(\k9, Ndef(~name+++\lfo1), \hif, \freq.asSpec);
Ndef(~name).map(\rlpfreq, Ndef(~name+++\lfo1, { arg freq=1, hif=900; SinOsc.ar(freq).range(100,hif) }))
